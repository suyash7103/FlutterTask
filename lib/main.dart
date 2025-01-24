import 'package:flutter/material.dart';
import 'dart:html' as html;
import 'dart:ui_web' as ui;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Disable the debug banner
      home: Scaffold(
        appBar: AppBar(
          title: Text('Password Protected YouTube Video'),
        ),
        body: Center(
          child: PasswordProtectedPage(),
        ),
      ),
    );
  }
}

class PasswordProtectedPage extends StatefulWidget {
  @override
  _PasswordProtectedPageState createState() => _PasswordProtectedPageState();
}

class _PasswordProtectedPageState extends State<PasswordProtectedPage> {
  final _passwordController = TextEditingController();
  bool _isAuthenticated = false;

  @override
  Widget build(BuildContext context) {
    return _isAuthenticated
        ? YouTubeWebView()
        : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Enter Password',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_passwordController.text == '1234') {
                    setState(() {
                      _isAuthenticated = true;
                    });
                  } else {
                    // Incorrect password
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Incorrect Password')));
                  }
                },
                child: Text('Submit'),
              ),
            ],
          );
  }
}

class YouTubeWebView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Create an iframe element to embed YouTube with a customized URL for masking
    final iframeElement = html.IFrameElement()
      ..width = '100%'
      ..height = '100%'
      ..src =
          'https://www.youtube.com/embed/gkD7TbavRwA?controls=0&modestbranding=1&rel=0&autohide=1&showinfo=0&iv_load_policy=3&fs=0'
      ..style.border = 'none'
      ..style.width = '100%' // Ensure it fills the container
      ..style.height = '100%'; // Ensure it fills the container

    // Register the iframe element with a unique view type
    ui.platformViewRegistry.registerViewFactory(
      'youtube-player',
      (int viewId) => iframeElement,
    );

    // Return the iframe as a view
    return HtmlElementView(viewType: 'youtube-player');
  }
}
