Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([198.47.19.12]:58937 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751144AbcGMKLs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jul 2016 06:11:48 -0400
From: "Machani, Yaniv" <yanivma@ti.com>
To: Johannes Berg <johannes@sipsolutions.net>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"David S . Miller" <davem@davemloft.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC: "Hahn, Maital" <maitalm@ti.com>
Subject: RE: [PATCH 1/4] mac80211: mesh: flush stations before beacons are
 stopped
Date: Wed, 13 Jul 2016 10:11:25 +0000
Message-ID: <AE1C82FB3D0EC64DB1F752C81CBD1101391FC38C@DFRE01.ent.ti.com> (sfid-20160713_121246_720412_499C3C86)
References: <20160628111307.8784-1-yanivma@ti.com>
	 <20160628111307.8784-2-yanivma@ti.com>
	 (sfid-20160628_131058_738638_5F9A964D)
 <1467184459.2461.1.camel@sipsolutions.net>
In-Reply-To: <1467184459.2461.1.camel@sipsolutions.net>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

T24gV2VkLCBKdW4gMjksIDIwMTYgYXQgMTA6MTQ6MTksIEpvaGFubmVzIEJlcmcgd3JvdGU6DQo+
IENjOiBIYWhuLCBNYWl0YWwNCj4gU3ViamVjdDogUmU6IFtQQVRDSCAxLzRdIG1hYzgwMjExOiBt
ZXNoOiBmbHVzaCBzdGF0aW9ucyBiZWZvcmUgYmVhY29ucyANCj4gYXJlIHN0b3BwZWQNCj4gDQo+
IE9uIFR1ZSwgMjAxNi0wNi0yOCBhdCAxNDoxMyArMDMwMCwgWWFuaXYgTWFjaGFuaSB3cm90ZToN
Cj4gPiBGcm9tOiBNYWl0YWwgSGFobiA8bWFpdGFsbUB0aS5jb20+DQo+ID4NCj4gPiBTb21lIGRy
aXZlcnMgKGUuZy4gd2wxOHh4KSBleHBlY3QgdGhhdCB0aGUgbGFzdCBzdGFnZSBpbiB0aGUgDQo+
ID4gZGUtaW5pdGlhbGl6YXRpb24gcHJvY2VzcyB3aWxsIGJlIHN0b3BwaW5nIHRoZSBiZWFjb25z
LCBzaW1pbGFyIHRvIGFwLg0KPiA+IFVwZGF0ZSBpZWVlODAyMTFfc3RvcF9tZXNoKCkgZmxvdyBh
Y2NvcmRpbmdseS4NCj4gPg0KPiBIb3cgd2VsbCBoYXZlIHlvdSB0ZXN0ZWQgdGhhdCB3aXRoIG90
aGVyIGRyaXZlcnM/DQo+IA0KDQpTb3JyeSBmb3IgdGhlIGRlbGF5ZWQgcmVzcG9uc2UgKEkndmUg
YmVlbiBvdXQpIGFuZCB0aGFua3MgZm9yIHlvdXIgY29tbWVudHMsDQpJIGhhdmUgdGVzdGVkIGl0
IHdpdGggUlQzNTcyIGFzIHdlbGwsIGFuZCBkaWRuJ3Qgc2VlIGFueSBpc3N1ZS4NCkknbGwgdXBk
YXRlIHRoZSBjb21tZW50IHRvIHJlZmxlY3QgdGhhdC4NCg0KVGhhbmtzLA0KWWFuaXYNCg0KPiBD
aGFuZ2luZyBiZWhhdmlvdXIgdG8gc29tZXRoaW5nIGEgc2luZ2xlIGRyaXZlciBkZXNpcmVzIGlz
bid0IA0KPiBuZWNlc3NhcmlseSB0aGUgYmVzdCB0aGluZyB0byBkbywgc2luY2UgdGhlcmUgYWx3
YXlzIGFyZSBtdWx0aXBsZSBkcml2ZXJzLg0KPiANCj4gSWYgeW91J3JlIGFibGUgdG8gZGVtb25z
dHJhdGUgdGhhdCBpdCB3b3JrcyB3aXRoIHRoZSBvdGhlciBkcml2ZXJzIEknbSANCj4gd2lsbGlu
ZyB0byB0YWtlIHRoYXQgLSB0aGUgY2hhbmdlIG1ha2VzIHNlbnNlIGFmdGVyIGFsbCwgYW5kIGl0
IHNlZW1zIA0KPiBkcml2ZXJzIG11c3Qgc3VwcG9ydCB0aGlzIG9yZGVyaW5nIHNpbmNlIHBlZXJz
IGFyZSBhbHNvIHJlbW92ZWQgDQo+IGR5bmFtaWNhbGx5Li4uIEJ1dCBzdGlsbC4gRG9uJ3QganVz
dCBtYWtlIGEgY2hhbmdlIGxpa2UgdGhhdCB3aXRob3V0IA0KPiBldmVuIGdpdmluZyBhbnkgaW5k
aWNhdGlvbiB3aHkgeW91IHRoaW5rIGl0J3MgZmluZSBmb3Igb3RoZXIgZHJpdmVycyENCj4gDQo+
IGpvaGFubmVzDQoNCg0K
