import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:digittodoapp/models/db_manager.dart';
import 'package:digittodoapp/models/task.dart';
import 'package:digittodoapp/screens/all-task-screen.dart';
import 'package:digittodoapp/screens/completed-task-screen.dart';
import 'package:digittodoapp/screens/home-screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../widgets/header.dart';

class InsertNewTask extends StatefulWidget {
  @override
  _InsertNewTaskState createState() => _InsertNewTaskState();
}

class _InsertNewTaskState extends State<InsertNewTask> {
  int selectedIndex = 0;
  final mainKey = GlobalKey<ScaffoldState>();

  void onTapped(int value) {
    setState(() => selectedIndex = value);

    if (selectedIndex == 1) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => CompletedTask()));
    } else if (selectedIndex == 2) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => AllTask()));
    } else {
      Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()));
    }
  }

  DbManager dbManager = new DbManager();
  final formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  var _datePickerController = TextEditingController();

  final format = DateFormat("yyyy-MM-dd");
  bool isButtonDisabled = true;

  void addTask() {
    Task task = new Task(
      title: _titleController.text,
      description: _descriptionController.text,
      date: _datePickerController.text,
      status: 0,
    );
    dbManager.insertTask(task).then((id) => {Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()))});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: mainKey,
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Header(),
            Form(
              key: formKey,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5.0),
                      child: TextFormField(
                        autocorrect: false,
                        decoration: InputDecoration(labelText: "Title *"),
                        controller: _titleController,
                        onChanged: (val) {
                          if (val.isNotEmpty) {
                            setState(() => isButtonDisabled = false);
                          } else {
                            setState(() => isButtonDisabled = true);
                          }
                        },
                        validator: (val) => val.isNotEmpty ? null : 'Title Should Not Be empty',
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5.0),
                      child: TextField(
                        autocorrect: false,
                        decoration: InputDecoration(labelText: "Task details"),
                        controller: _descriptionController,
                        keyboardType: TextInputType.multiline,
                        maxLines: 5,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10.0),
                      child: DateTimeField(
                        format: format,
                        controller: _datePickerController,
                        onShowPicker: (context, currentValue) {
                          return showDatePicker(
                              context: context,
                              fieldHintText: 'Date',
                              fieldLabelText: 'Date',
                              helpText: 'Date',
                              firstDate: DateTime(1900),
                              initialDate: currentValue ?? DateTime.now(),
                              lastDate: DateTime(2100));
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10, right: 20),
                      child: Align(
                        alignment: Alignment.topRight,
                        child: RaisedButton(
                          color: Colors.grey[900],
                          textColor: Colors.white,
                          child: Text("Save"),
                          onPressed: () => isButtonDisabled ? null : addTask(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
        decoration: BoxDecoration(
          color: Colors.transparent,
          image: DecorationImage(fit: BoxFit.fill, image: AssetImage('assets/bg.png')),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: true,
        showUnselectedLabels: true,
        selectedItemColor: Colors.green,
        selectedFontSize: 15,
        currentIndex: selectedIndex,
        onTap: onTapped,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.timelapse, size: 30.0),
            title: Text('Pending', style: TextStyle(color: Colors.black)),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_box, size: 30.0),
            title: Text('Completed', style: TextStyle(color: Colors.black)),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.featured_play_list, size: 30.0),
            title: Text('All', style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );
  }
}
