import 'package:faem_app/Models/InitData.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../app.dart';

String jwtToken = '';
var checkNumber, clientPhoneNumber;

Future<InitData> getInitData() async {
  InitData initData = null;
  checkNumber = null;
  sharedPreferences = await SharedPreferences.getInstance();
  jwtToken = sharedPreferences.getString('jwt');
  var url = 'https://client.apis.stage.faem.pro/api/v2/initdata';
  var response = await http.get(url, headers: <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
    'Authorization': 'Bearer ${jwtToken}'
  });
  if(response.statusCode == 200) {
    var jsonResponse = json.decode(response.body);
    initData = new InitData.fromJson(jsonResponse);
    checkNumber = initData.clientUuid;
    clientPhoneNumber = initData.clientPhone;
    print('InitData: ${response.body}');
  } else {
    var jsonResponse = json.decode(response.body);
    initData = new InitData.fromJson(jsonResponse);
    print('InitData ERROR: ${response.body}');
  }
  return initData;
}