Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog133.obsmtp.com ([74.125.149.82]:35372 "EHLO
	na3sys009aog133.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754583Ab2EHToS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 May 2012 15:44:18 -0400
From: Bing Zhao <bzhao@marvell.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Avinash Patil <patila@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	stone Piao <piaoyun@marvell.com>,
	Frank Huang <frankh@marvell.com>,
	harvey yang <harvey.huawei.yang@gmail.com>
Date: Tue, 8 May 2012 12:43:51 -0700
Subject: RE: [PATCH 17/18] mwifiex: parse beacon, probe response and assoc
 response IEs from start_ap
Message-ID: <477F20668A386D41ADCC57781B1F7043083A4ADE8F@SC-VEXCH1.marvell.com> (sfid-20120508_214421_390916_D0B72677)
References: <1336029760-22565-1-git-send-email-bzhao@marvell.com>
	 <1336029760-22565-18-git-send-email-bzhao@marvell.com>
	 (sfid-20120503_092407_448446_1D53B766)
 <1336054745.5167.0.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

SGkgSm9oYW5uZXMsDQoNCj4gVGhhbmtzIGZvciB5b3VyIGNvbW1lbnQuDQo+IA0KPiA+ID4gQWRk
IGxvZ2ljIGZvciBwYXJzaW5nIHRhaWwgSUVzLCBiZWFjb24gSUVzLCBwcm9iZSByZXNwb25zZSBJ
RXMNCj4gPiA+IGFuZCBhc3NvYyByZXNwb25zZSBJRXMgZnJvbSBjZmc4MDIxMV9hcF9zZXR0aW5n
cyBwYXJhbWV0ZXIgb2YNCj4gPiA+IHN0YXJ0X2FwIGhhbmRsZXIuDQo+ID4gPg0KPiA+ID4gVGhp
cyBwYXRjaCBhbHNvIGltcGxlbWVudHMgZnVuY3Rpb25hbGl0eSB0byByZXRyaWV2ZSBSU04gSUUg
ZnJvbQ0KPiA+ID4gdGFpbCBJRSBhbmQgc2VuZCBpdCB0byBGVy4NCj4gPg0KPiA+IFRoaXMgZG9l
c24ndCBzZWVtIHJpZ2h0IC0tIHlvdSBzaG91bGQgdXNlIEFQIFNNRSBtb2RlIGFuZCBnZXQgbXVj
aCBtb3JlDQo+ID4gZGV0YWlsIGluIG90aGVyIGF0dHJpYnV0ZXM/IExvb2sgYXQgYXRoNmtsPw0K
PiANCj4gV2lsbCBsb29rIGludG8gdGhpcy4NCg0KYXRoNmtsIG1ha2VzIHVzZSBvZiBjZmc4MDIx
MV9maW5kX2llKCkgdG8gcGFyc2UgUlNOIElFIGZyb20gYmVhY29uLnRhaWwuDQoNCllvdSBhcmUg
cmlnaHQuIG13aWZpZXggc2hvdWxkIHVzZSB0aGlzIEFQSSB0b28sIGluc3RlYWQgb2YgaW1wbGVt
ZW50aW5nIGl0cyBvd24uDQoNCkZvciBBUCBTTUUgbW9kZSwgd2UgaGF2ZSBzZXQgV0lQSFlfRkxB
R19IQVZFX0FQX1NNRSBiaXQgaW4gd2lwaHktPmZsYWdzIChQQVRDSCAzLzE4KS4NCkFuZCBpbiBz
dGFydF91cCgpIGhhbmRsZXIsIHdlIHJldHJpZXZlIGJlYWNvbiBJRSwgcHJvYmUgcmVzcG9uc2Ug
SUUsIGFuZCBhc3NvY2lhdGlvbiByZXNwb25zZSBJRSBmcm9tIGNmZzgwMjExX2FwX3NldHRpbmdz
IGJlYWNvbiB0YWlsLiBEcml2ZXIgd2lsbCBzZW5kIHRoZXNlIElFcyB0byBmaXJtd2FyZS4NCg0K
T3RoZXIgY2ZnODAyMTFfYXBfc2V0dGluZ3MgcGFyYW1ldGVycyAoc3NpZCwgYmVhY29uIGludGVy
dmFsLCBkdGltIHBlcmlvZCwgc2VjdXJpdHkpIGhhdmUgYmVlbiB0YWtlbiBjYXJlIG9mIGluIHBh
dGNoZXMgMTIvMTggYW5kIDE0LzE4Lg0KDQpJIHdpbGwgcmVzcGluIHYyIHBhdGNoc2V0IHRvIGlu
Y2x1ZGUgdGhlIGNmZzgwMjExX2ZpbmRfaWUoKSBjaGFuZ2UuDQoNClRoYW5rcywNCkJpbmcNCg0K
