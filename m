Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:53989 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751555AbcDULHn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Apr 2016 07:07:43 -0400
From: "Reizer, Eyal" <eyalr@ti.com>
To: Mark Brown <broonie@kernel.org>
CC: "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
	=?utf-8?B?77+977+977+977+9IO+/ve+/ve+/ve+/ve+/vQ==?=
	<eyalreizer@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	"linux-spi@vger.kernel.org" <linux-spi@vger.kernel.org>
Subject: RE: [PATCHv2] wlcore: spi: add wl18xx support
Date: Thu, 21 Apr 2016 11:07:37 +0000
Message-ID: <8665E2433BC68541A24DFFCA87B70F5B360C2E14@DFRE01.ent.ti.com> (sfid-20160421_130823_441612_21666D6A)
References: <14313437.cDJIgY3kzo@wuerfel>
 <8665E2433BC68541A24DFFCA87B70F5B360BF614@DFRE01.ent.ti.com>
 <1463330011.BhWEcYYuGD@wuerfel>
 <8665E2433BC68541A24DFFCA87B70F5B360C0745@DFRE01.ent.ti.com>
 <20160419171239.GC3217@sirena.org.uk>
 <sjdvun1fuj4nyi0bgf268g53.1461086401627@email.android.com>
 <20160419172706.GD3217@sirena.org.uk>
 <oe8hqfknrcljrjawnrxlohvr.1461087275186@email.android.com>
 <20160419175402.GE3217@sirena.org.uk>
 <us0dopt1inbrt0x47njgc2vy.1461089085965@email.android.com>
 <20160419184627.GG3217@sirena.org.uk>
In-Reply-To: <20160419184627.GG3217@sirena.org.uk>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

PiANCj4gPiBUaGFua3MhIEdsYWQgdGhlIGlsbHVzdHJhdGlvbiBoZWxwZWQuDQo+ID4gSSB3aWxs
IHRyeSBpdCBvdXQgYWdhaW4gYXMgaWYgaSByZWNhbGwgY290cmVjdGx5LCBpIGRpZCB0cnkgdGhh
dCBsLCBhbmQgaXQgZGlkbnQgcHJvZHVjZQ0KPiB0aGUgY29ycmVjdCB3YXZlZm9ybSwgYnV0IHBl
cmhhcHMgaSBkaWRudCB1bmRlcnN0YW5kIHRoZSB1c2FnZSBvZg0KPiAuY3NfY2hhbmdlIGNvcnJl
Y3RseS4NCj4gPiBXaWxsIGRvdWJsZSBjaGVjayBhbnl3YXkuDQo+IA0KPiBJdCBjb3VsZCBhbHNv
IGJlIGEgYnVnIGluIHlvdXIgY29udHJvbGxlciBkcml2ZXIsIGl0J3MgY29tbW9uIGZvciB0aGVt
IHRvIG5vdA0KPiBoYW5kbGUgY3NfY2hhbmdlIGNvcnJlY3RseSAoYXQgbGVhc3QgdGhvc2UgdGhh
dCBvcGVuIGNvZGUgdGhlIG1lc3NhZ2UgbG9vcCwNCj4gb2J2aW91c2x5IG1vZGVybiBvbmVzIGp1
c3QgZmFjdG9yIHRoaXMgb3V0IGludG8gdGhlIGNvcmUpLg0KDQpUcmllZCBsb29raW5nIGludG8g
dXNpbmcgY3NfY2hhbmdlIGFuZCBub3Qgc3VyZSBJIHVuZGVyc3RhbmQgaG93IGl0IHdvdWxkIGRv
IHdoYXQgSSBuZWVkLg0KQWNjb3JkaW5nIHRvLCBpbmNsdWRlL2xpbnV4L3NwaS9zcGkuaDoNCg0K
KiBBbGwgU1BJIHRyYW5zZmVycyBzdGFydCB3aXRoIHRoZSByZWxldmFudCBjaGlwc2VsZWN0IGFj
dGl2ZS4gIE5vcm1hbGx5DQoqIGl0IHN0YXlzIHNlbGVjdGVkIHVudGlsIGFmdGVyIHRoZSBsYXN0
IHRyYW5zZmVyIGluIGEgbWVzc2FnZS4gIERyaXZlcnMNCiogY2FuIGFmZmVjdCB0aGUgY2hpcHNl
bGVjdCBzaWduYWwgdXNpbmcgY3NfY2hhbmdlLg0KKg0KKiAoaSkgSWYgdGhlIHRyYW5zZmVyIGlz
bid0IHRoZSBsYXN0IG9uZSBpbiB0aGUgbWVzc2FnZSwgdGhpcyBmbGFnIGlzDQoqIHVzZWQgdG8g
bWFrZSB0aGUgY2hpcHNlbGVjdCBicmllZmx5IGdvIGluYWN0aXZlIGluIHRoZSBtaWRkbGUgb2Yg
dGhlDQoqIG1lc3NhZ2UuICBUb2dnbGluZyBjaGlwc2VsZWN0IGluIHRoaXMgd2F5IG1heSBiZSBu
ZWVkZWQgdG8gdGVybWluYXRlDQoqIGEgY2hpcCBjb21tYW5kLCBsZXR0aW5nIGEgc2luZ2xlIHNw
aV9tZXNzYWdlIHBlcmZvcm0gYWxsIG9mIGdyb3VwIG9mDQoqIGNoaXAgdHJhbnNhY3Rpb25zIHRv
Z2V0aGVyLg0KDQpOb3csIGluIG15IGNhc2UgSSBuZWVkIHRoZSBDUyBwaW4gdG8gZ28gaW5hY3Rp
dmUgYW5kIHN0YXkgaW5hY3RpdmUgZHVyaW5nIHRoZSB0cmFuc2ZlciANCm9mIHRoZSBuZXh0IGJ5
dGUgZm9yIGNvbXBsZXRpbmcgdGhlIFNQSSBpbml0IGNvcnJlY3RseSAoc2VuZGluZyB0aGUgZXh0
cmEgY2xvY2sgY3ljbGVzIHdoaWxlIENTIGlzIGluYWN0aXZlKQ0KSWYgSSByZWFkIHRoZSBhYm92
ZSBjb3JyZWN0bHksIENTIHdpbGwgb25seSBicmllZmx5IGdvIGluYWN0aXZlIGJ1dCB3aWxsIHdo
ZW4gdGhlIG5leHQgYnl0ZSANCmlzIHNlbnQgaXQgd2lsbCBiZSBhY3RpdmUgYWdhaW4uDQpXaGF0
IGFtIEkgbWlzc2luZz8NCg0KQmVzdCBSZWdhcmRzLA0KRXlhbA0KDQo=
