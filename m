Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog110.obsmtp.com ([74.125.149.203]:49355 "EHLO
	na3sys009aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754829Ab1H2TZd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Aug 2011 15:25:33 -0400
From: Bing Zhao <bzhao@marvell.com>
To: Joe Perches <joe@perches.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Frank Huang <frankh@marvell.com>, Walter Harms <wharms@bfs.de>
Date: Mon, 29 Aug 2011 12:25:23 -0700
Subject: RE: [PATCH v2] mwifiex: replace kmalloc & memcpy sequence with
 kmemdup
Message-ID: <477F20668A386D41ADCC57781B1F70430815013582@SC-VEXCH1.marvell.com> (sfid-20110829_212542_956609_0DFED8CD)
References: <1314301042-15021-1-git-send-email-bzhao@marvell.com>
 <1314315908.4637.23.camel@Joe-Laptop>
In-Reply-To: <1314315908.4637.23.camel@Joe-Laptop>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

SGkgSm9lLA0KDQpUaGFua3MgZm9yIHlvdXIgY29tbWVudC4NCg0KPiA+IFNlcXVlbmNlIG9mIGtt
YWxsb2Mva3phbGxvYyBhbmQgbWVtY3B5IGlzIHJlcGxhY2VkIHdpdGgNCj4gPiBrbWVtZHVwLg0K
PiA+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC93aXJlbGVzcy9td2lmaWV4L3NjYW4uYyBiL2Ry
aXZlcnMvbmV0L3dpcmVsZXNzL213aWZpZXgvc2Nhbi5jDQo+IFtdDQo+ID4gQEAgLTE5ODYsMTcg
KzE5ODYsMjAgQEAgbXdpZmlleF9zYXZlX2N1cnJfYmNuKHN0cnVjdCBtd2lmaWV4X3ByaXZhdGUg
KnByaXYpDQo+ID4gIAkJcHJpdi0+Y3Vycl9iY25fc2l6ZSA9IGN1cnJfYnNzLT5iZWFjb25fYnVm
X3NpemU7DQo+ID4NCj4gPiAgCQlrZnJlZShwcml2LT5jdXJyX2Jjbl9idWYpOw0KPiA+IC0JCXBy
aXYtPmN1cnJfYmNuX2J1ZiA9IGt6YWxsb2MoY3Vycl9ic3MtPmJlYWNvbl9idWZfc2l6ZSwNCj4g
PiArDQo+ID4gKwkJcHJpdi0+Y3Vycl9iY25fYnVmID0ga21lbWR1cChjdXJyX2Jzcy0+YmVhY29u
X2J1ZiwNCj4gPiArCQkJCQkJY3Vycl9ic3MtPmJlYWNvbl9idWZfc2l6ZSwNCj4gPiAgCQkJCQkJ
R0ZQX0tFUk5FTCk7DQo+IA0KPiBJIHRoaW5rIHRoaXMgYmxvY2ssIGJlY2F1c2Ugb2YgdGhlIG5l
dyBlbHNlIGJlbG93IGl0LA0KPiBpc24ndCBhbiBpbXByb3ZlbWVudC4NCg0KT0suIFRoZW4gd2Ug
Y2FuIGp1c3QgdXNlIGttYWxsb2MgaW5zdGVhZCBvZiBremFsbG9jIHRvIHNhdmUgYSBidWZmZXIg
emVyb2luZyBvdXQgaW4gdjMuDQoNCj4gDQo+IFRoaXMga2ZyZWUva3phbGxvYyBzaG91bGQgcHJv
YmFibHkganVzdCBiZSBrcmVhbGxvYyB3aXRoDQo+IHRoZSBtZW1zZXQgdW5jaGFuZ2VkLg0KDQpU
aGUga3JlYWxsb2MgZG9lc24ndCBzZWVtIHN1aXRhYmxlIGhlcmUgYmVjYXVzZSBrcmVhbGxvYyBk
b2VzIGEgdXNlbGVzcyBtZW1jcHkuDQoNClRoYW5rcywNCkJpbmcNCg0KPiANCj4gPiAgCQlpZiAo
IXByaXYtPmN1cnJfYmNuX2J1Zikgew0KPiA+ICAJCQlkZXZfZXJyKHByaXYtPmFkYXB0ZXItPmRl
diwNCj4gPiAgCQkJCQkiZmFpbGVkIHRvIGFsbG9jIGN1cnJfYmNuX2J1ZlxuIik7DQo+ID4gIAkJ
CXJldHVybjsNCj4gPiAgCQl9DQo+ID4gKwl9IGVsc2Ugew0KPiA+ICsJCW1lbWNweShwcml2LT5j
dXJyX2Jjbl9idWYsIGN1cnJfYnNzLT5iZWFjb25fYnVmLA0KPiA+ICsJCQljdXJyX2Jzcy0+YmVh
Y29uX2J1Zl9zaXplKTsNCj4gPiAgCX0NCj4gPg0KPiA+IC0JbWVtY3B5KHByaXYtPmN1cnJfYmNu
X2J1ZiwgY3Vycl9ic3MtPmJlYWNvbl9idWYsDQo+ID4gLQkJY3Vycl9ic3MtPmJlYWNvbl9idWZf
c2l6ZSk7DQo+ID4gIAlkZXZfZGJnKHByaXYtPmFkYXB0ZXItPmRldiwgImluZm86IGN1cnJlbnQg
YmVhY29uIHNhdmVkICVkXG4iLA0KPiA+ICAJCXByaXYtPmN1cnJfYmNuX3NpemUpOw0KPiANCg0K
