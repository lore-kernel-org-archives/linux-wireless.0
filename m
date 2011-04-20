Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog103.obsmtp.com ([74.125.149.71]:57712 "EHLO
	na3sys009aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755922Ab1DTTzo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Apr 2011 15:55:44 -0400
From: Bing Zhao <bzhao@marvell.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Joe Perches <joe@perches.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Marc Yang <yangyang@marvell.com>,
	Ramesh Radhakrishnan <rramesh@marvell.com>,
	Frank Huang <frankh@marvell.com>
Date: Wed, 20 Apr 2011 12:55:04 -0700
Subject: RE: [PATCH v2] wireless: mwifiex: initial commit for Marvell
 mwifiex driver
Message-ID: <477F20668A386D41ADCC57781B1F704307FAAC298D@SC-VEXCH1.marvell.com>
References: <1299873746-29484-1-git-send-email-bzhao@marvell.com>
	 <1299874885.4320.5.camel@jlt3.sipsolutions.net>
	 <477F20668A386D41ADCC57781B1F704307FA4C2D82@SC-VEXCH1.marvell.com>
	 <1300190698.5596.15.camel@jlt3.sipsolutions.net>
	 <477F20668A386D41ADCC57781B1F704307FAAC2955@SC-VEXCH1.marvell.com>
 <1303326002.3619.9.camel@jlt3.sipsolutions.net>
In-Reply-To: <1303326002.3619.9.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

PiA+IC0tLQ0KPiA+IGRpZmYgLS1naXQgYS9pbmNsdWRlL25ldC9jZmc4MDIxMS5oIGIvaW5jbHVk
ZS9uZXQvY2ZnODAyMTEuaA0KPiA+IGluZGV4IGQzMGVhZGEuLjFjZGM0M2UgMTAwNjQ0DQo+ID4g
LS0tIGEvaW5jbHVkZS9uZXQvY2ZnODAyMTEuaA0KPiA+ICsrKyBiL2luY2x1ZGUvbmV0L2NmZzgw
MjExLmgNCj4gPiBAQCAtMTk3NCw2ICsxOTc0LDcgQEAgZXh0ZXJuIGludCBpZWVlODAyMTFfcmFk
aW90YXBfaXRlcmF0b3JfbmV4dCgNCj4gPg0KPiA+ICBleHRlcm4gY29uc3QgdW5zaWduZWQgY2hh
ciByZmMxMDQyX2hlYWRlcls2XTsNCj4gPiAgZXh0ZXJuIGNvbnN0IHVuc2lnbmVkIGNoYXIgYnJp
ZGdlX3R1bm5lbF9oZWFkZXJbNl07DQo+ID4gK2V4dGVybiBib29sIGNmZzgwMjExX2Rpc2FibGVf
NDBtaHpfMjRnaHo7DQo+ID4NCj4gPiAgLyoqDQo+ID4gICAqIGllZWU4MDIxMV9nZXRfaGRybGVu
X2Zyb21fc2tiIC0gZ2V0IGhlYWRlciBsZW5ndGggZnJvbSBkYXRhDQo+ID4gZGlmZiAtLWdpdCBh
L25ldC9tYWM4MDIxMS9tYWluLmMgYi9uZXQvbWFjODAyMTEvbWFpbi5jDQo+ID4gaW5kZXggMGFi
MmE4ZC4uNDI5MGI1MCAxMDA2NDQNCj4gPiAtLS0gYS9uZXQvbWFjODAyMTEvbWFpbi5jDQo+ID4g
KysrIGIvbmV0L21hYzgwMjExL21haW4uYw0KPiA+IEBAIC0zMywxMiArMzMsNiBAQA0KPiA+ICAj
aW5jbHVkZSAiY2ZnLmgiDQo+ID4gICNpbmNsdWRlICJkZWJ1Z2ZzLmgiDQo+ID4NCj4gPiAtDQo+
ID4gLXN0YXRpYyBib29sIGllZWU4MDIxMV9kaXNhYmxlXzQwbWh6XzI0Z2h6Ow0KPiA+IC1tb2R1
bGVfcGFyYW0oaWVlZTgwMjExX2Rpc2FibGVfNDBtaHpfMjRnaHosIGJvb2wsIDA2NDQpOw0KPiA+
IC1NT0RVTEVfUEFSTV9ERVNDKGllZWU4MDIxMV9kaXNhYmxlXzQwbWh6XzI0Z2h6LA0KPiA+IC0J
CSAiRGlzYWJsZSA0ME1IeiBzdXBwb3J0IGluIHRoZSAyLjRHSHogYmFuZCIpOw0KPiA+IC0NCj4g
PiAgc3RhdGljIHN0cnVjdCBsb2NrX2NsYXNzX2tleSBpZWVlODAyMTFfcnhfc2tiX3F1ZXVlX2Ns
YXNzOw0KPiA+DQo+ID4gIHZvaWQgaWVlZTgwMjExX2NvbmZpZ3VyZV9maWx0ZXIoc3RydWN0IGll
ZWU4MDIxMV9sb2NhbCAqbG9jYWwpDQo+ID4gQEAgLTcyOSwxMSArNzIzLDExIEBAIGludCBpZWVl
ODAyMTFfcmVnaXN0ZXJfaHcoc3RydWN0IGllZWU4MDIxMV9odyAqaHcpDQo+ID4gIAkJY2hhbm5l
bHMgKz0gc2JhbmQtPm5fY2hhbm5lbHM7DQo+ID4NCj4gPiAgCQkvKg0KPiA+IC0JCSAqIFNpbmNl
IGllZWU4MDIxMV9kaXNhYmxlXzQwbWh6XzI0Z2h6IGlzIGdsb2JhbCwgd2UgY2FuDQo+ID4gKwkJ
ICogU2luY2UgY2ZnODAyMTFfZGlzYWJsZV80MG1oel8yNGdoeiBpcyBnbG9iYWwsIHdlIGNhbg0K
PiA+ICAJCSAqIG1vZGlmeSB0aGUgc2JhbmQncyBodCBkYXRhIGV2ZW4gaWYgdGhlIGRyaXZlciB1
c2VzIGENCj4gPiAgCQkgKiBnbG9iYWwgc3RydWN0dXJlIGZvciB0aGF0Lg0KPiA+ICAJCSAqLw0K
PiA+IC0JCWlmIChpZWVlODAyMTFfZGlzYWJsZV80MG1oel8yNGdoeiAmJg0KPiA+ICsJCWlmIChj
Zmc4MDIxMV9kaXNhYmxlXzQwbWh6XzI0Z2h6ICYmDQo+ID4gIAkJICAgIGJhbmQgPT0gSUVFRTgw
MjExX0JBTkRfMkdIWiAmJg0KPiA+ICAJCSAgICBzYmFuZC0+aHRfY2FwLmh0X3N1cHBvcnRlZCkg
ew0KPiA+ICAJCQlzYmFuZC0+aHRfY2FwLmNhcCAmPSB+SUVFRTgwMjExX0hUX0NBUF9TVVBfV0lE
VEhfMjBfNDA7DQo+IA0KPiBXZWxsLCBJIHRoaW5rIGluIHRoYXQgY2FzZSB0aGlzIGNvZGUgc2hv
dWxkIGFsc28gYmUgbW92ZWQuDQoNCk9LLiBJIHdpbGwgcmVzZW5kIHRoZSBwYXRjaC4NCg0KVGhh
bmtzLA0KDQpCaW5nDQo=
