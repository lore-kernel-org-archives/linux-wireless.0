Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rtits2.realtek.com ([211.75.126.72]:40187 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S945331AbdDTNaK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 20 Apr 2017 09:30:10 -0400
Received: from mail.realtek.com (rtitexh01.realtek.com.tw [172.21.6.62])
        by rtits2.realtek.com.tw (8.15.2/2.55/5.73) with ESMTP id v3KDU3MV021199
        for <linux-wireless@vger.kernel.org>; Thu, 20 Apr 2017 21:30:03 +0800
From: =?utf-8?B?6I6K5b2l5a6j?= <yhchuang@realtek.com>
To: Szuyitasi <szuyitasi@realtek.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Pkshih <pkshih@realtek.com>, Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: RE: [PATCH 06/10] rtlwifi: btcoex: 21a 2ant: run mechanism if status changes or auto adjust is set
Date: Thu, 20 Apr 2017 13:30:02 +0000
Message-ID: <F7CD281DE3E379468C6D07993EA72F8401533A7C@RTITMBSV07.realtek.com.tw> (sfid-20170420_153017_459191_590DF814)
References: <20170416190428.23857-1-Larry.Finger@lwfinger.net>
        <20170416190428.23857-7-Larry.Finger@lwfinger.net>
 <87bmrrbb8q.fsf@purkki.adurom.net>
In-Reply-To: <87bmrrbb8q.fsf@purkki.adurom.net>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

RGVhciBTWSwNCg0KTGludXgga2VybmVsIHVwc3RyZWFtIOS4iumdouWwjeaWvOmAmeeoriBpZmRl
ZiDnmoTmlrnlvI/mmK/kuI3oqo3lkIznmoQNCuiDveWQpueUqOWFtuS7lueahOaWueW8j+S+huS7
o+abv+WRoj8NCuaIluaYr+WIqeeUqOiuiuaVuOS+huaOp+WItuOAgg0KDQrlj6blpJblpoLmnpxk
ZWZhdWx05piv6LeR5ZOq6YKK77yM5p+Q5LiA6Lev5Y+q5pivZm9yIHNwZWNpYWwgY2FzZeeahOip
sQ0K5Y+v5Lul5YWI5oqK5YW25Lit5LiA6YKK5ou/5o6J44CCDQrlhYjkuIp1cHN0cmVhbSDkuYvl
vozlho3kvoZyZWZpbmUNCg0KDQpCZXN0IFJlZ2FyZHMsDQpUb255DQoNCi0tLS0tT3JpZ2luYWwg
TWVzc2FnZS0tLS0tDQpGcm9tOiBLYWxsZSBWYWxvIFttYWlsdG86a3ZhbG9AY29kZWF1cm9yYS5v
cmddIA0KU2VudDogVGh1cnNkYXksIEFwcmlsIDIwLCAyMDE3IDY6NTQgUE0NClRvOiBMYXJyeSBG
aW5nZXINCkNjOiBsaW51eC13aXJlbGVzc0B2Z2VyLmtlcm5lbC5vcmc7IOiOiuW9peWuozsgUGtz
aGloOyBCaXJtaW5nIENoaXU7IFNoYW9mdTsgU3RldmVuIFRpbmcNClN1YmplY3Q6IFJlOiBbUEFU
Q0ggMDYvMTBdIHJ0bHdpZmk6IGJ0Y29leDogMjFhIDJhbnQ6IHJ1biBtZWNoYW5pc20gaWYgc3Rh
dHVzIGNoYW5nZXMgb3IgYXV0byBhZGp1c3QgaXMgc2V0DQoNCkxhcnJ5IEZpbmdlciA8TGFycnku
RmluZ2VyQGx3ZmluZ2VyLm5ldD4gd3JpdGVzOg0KDQo+IEZyb206IFlhbi1Ic3VhbiBDaHVhbmcg
PHloY2h1YW5nQHJlYWx0ZWsuY29tPg0KPg0KPiBUaGUgZHJpdmVyIHdpbGwgcGVyaW9kaWNhbGx5
IGFzayB0aGUgY29leCwgYW5kIHRoZSBjb2V4IG9ubHkgcnVucyB0aGUgDQo+IG1lY2hhbmlzbSB3
aGVuIHRoZSBzdGF0dXMgd2FzIGNoYW5nZWQgb3IgdGhlIGF1dG8gYWRqdXN0IGlzIHNldC4NCj4N
Cj4gU2lnbmVkLW9mZi1ieTogWWFuLUhzdWFuIENodWFuZyA8eWhjaHVhbmdAcmVhbHRlay5jb20+
DQo+IFNpZ25lZC1vZmYtYnk6IExhcnJ5IEZpbmdlciA8TGFycnkuRmluZ2VyQGx3ZmluZ2VyLm5l
dD4NCj4gQ2M6IFBrc2hpaCA8cGtzaGloQHJlYWx0ZWsuY29tPg0KPiBDYzogQmlybWluZyBDaGl1
IDxiaXJtaW5nQHJlYWx0ZWsuY29tPg0KPiBDYzogU2hhb2Z1IDxzaGFvZnVAcmVhbHRlay5jb20+
DQo+IENjOiBTdGV2ZW4gVGluZyA8c3RldmVudGluZ0ByZWFsdGVrLmNvbT4NCg0KWy4uLl0NCg0K
PiBAQCAtNDIwMCw3ICs0MjAwLDE0IEBAIHZvaWQgZXhfYnRjODgyMWEyYW50X3BlcmlvZGljYWwo
c3RydWN0IGJ0Y19jb2V4aXN0ICpidGNvZXhpc3QpDQo+ICAJCQkgIltCVENvZXhdLCAqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
XG4iKTsNCj4gIAl9DQo+ICANCj4gKyNpZmRlZiBCVF9BVVRPX1JFUE9SVF9PTkxZXzg4MjFBXzJB
TlQNCj4gIAlidGM4ODIxYTJhbnRfcXVlcnlfYnRfaW5mbyhidGNvZXhpc3QpOw0KPiArI2Vsc2UN
Cj4gIAlidGM4ODIxYTJhbnRfbW9uaXRvcl9idF9jdHIoYnRjb2V4aXN0KTsNCj4gIAlidGM4ODIx
YTJhbnRfbW9uaXRvcl93aWZpX2N0cihidGNvZXhpc3QpOw0KPiArDQo+ICsJaWYgKGJ0Yzg4MjFh
MmFudF9pc193aWZpX3N0YXR1c19jaGFuZ2VkKGJ0Y29leGlzdCkgfHwNCj4gKwkgICAgY29leF9k
bS0+YXV0b190ZG1hX2FkanVzdCkNCj4gKwkJYnRjODgyMWEyYW50X3J1bl9jb2V4aXN0X21lY2hh
bmlzbShidGNvZXhpc3QpOw0KPiArI2VuZGlmDQoNClRoaXMgaWZkZWYgbG9va3MgZmlzaHkuIFdo
eSBpcyBpdCBuZWVkZWQ/DQoNCkluIGdlbmVyYWwgSSB3b3VsZCBleHBlY3QgdG8gc2VlIGlmZGVm
cyBvbmx5IGZvciBLY29uZmlnIG9wdGlvbnMgb3IgZGVmaW5lcyB3aGljaCB2YWx1ZSBjb21lcyBm
cm9tIGNvcmUga2VybmVsLg0KDQotLQ0KS2FsbGUgVmFsbw0KDQotLS0tLS1QbGVhc2UgY29uc2lk
ZXIgdGhlIGVudmlyb25tZW50IGJlZm9yZSBwcmludGluZyB0aGlzIGUtbWFpbC4NCg==
