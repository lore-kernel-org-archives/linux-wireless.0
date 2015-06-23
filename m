Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:2576 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750762AbbFWGkc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Jun 2015 02:40:32 -0400
From: "Otcheretianski, Andrei" <andrei.otcheretianski@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ath9k-devel@venema.h4ckr.net" <ath9k-devel@venema.h4ckr.net>,
	"nbd@openwrt.org" <nbd@openwrt.org>,
	"sujith@msujith.org" <sujith@msujith.org>
Subject: RE: [PATCH 2/3] ath9k: make rxfilter per HW
Date: Tue, 23 Jun 2015 06:40:19 +0000
Message-ID: <B2CD83211F5FDD478D7EFFF030D107ED3DEEB4F3@hasmsx107.ger.corp.intel.com> (sfid-20150623_084036_884815_E83F5957)
References: <1434973385-15865-1-git-send-email-janusz.dziedzic@tieto.com>
	 <1434973385-15865-3-git-send-email-janusz.dziedzic@tieto.com>
	 (sfid-20150622_134339_744222_8D689257)
 <1434974312.19597.9.camel@sipsolutions.net>
	 (sfid-20150622_135841_850054_31462557)
 <1434974380.19597.10.camel@sipsolutions.net>
In-Reply-To: <1434974380.19597.10.camel@sipsolutions.net>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBKb2hhbm5lcyBCZXJnIFttYWls
dG86am9oYW5uZXNAc2lwc29sdXRpb25zLm5ldF0NCj4gU2VudDogTW9uZGF5LCBKdW5lIDIyLCAy
MDE1IDE1OjAwDQo+IFRvOiBKYW51c3ogRHppZWR6aWMNCj4gQ2M6IGxpbnV4LXdpcmVsZXNzQHZn
ZXIua2VybmVsLm9yZzsgYXRoOWstZGV2ZWxAdmVuZW1hLmg0Y2tyLm5ldDsNCj4gbmJkQG9wZW53
cnQub3JnOyBzdWppdGhAbXN1aml0aC5vcmc7IE90Y2hlcmV0aWFuc2tpLCBBbmRyZWkNCj4gU3Vi
amVjdDogUmU6IFtQQVRDSCAyLzNdIGF0aDlrOiBtYWtlIHJ4ZmlsdGVyIHBlciBIVw0KPiANCj4g
T24gTW9uLCAyMDE1LTA2LTIyIGF0IDEzOjU4ICswMjAwLCBKb2hhbm5lcyBCZXJnIHdyb3RlOg0K
PiA+IE9uIE1vbiwgMjAxNS0wNi0yMiBhdCAxMzo0MyArMDIwMCwgSmFudXN6IER6aWVkemljIHdy
b3RlOg0KPiA+ID4gbWFjODAyMTEgY29uZmlndXJlIHJ4ZmlsdGVyIHBlciBIVywNCj4gPiA+IHNv
IHdlIGRvbid0IG5lZWQgdGhpcyBwZXIgY2hhbm5lbC4NCj4gPg0KPiA+IEFzIEkgc2FpZCBiZWZv
cmUsIEkgdGhpbmsgdGhlcmUncyB2YWx1ZSBpbiBtYWM4MDIxMSBkb2luZyBpdCBwZXINCj4gPiBj
aGFuY3R4IG9yIGV2ZW4gcGVyIHZpZiwgYW5kIGl0IHNob3VsZCBiZSBtb3JlIGVmZmljaWVudCB0
byBkbyBzby4NCj4gPg0KPiA+IEl0J3MgdGVtcHRpbmcgdG8gZG8gaXQgcGVyIHZpZiBhbmQgbGVh
dmUgdGhlIGNoYW5jdHggd29yayB1cCB0byB0aGUNCj4gPiBkcml2ZXIsIGJ1dCBwZXJoYXBzIHdp
dGggQ1NBIGFuZCBhbGwgdGhhdCBpdCBnZXRzIGNvbXBsaWNhdGVkIGVub3VnaA0KPiA+IHRoYXQg
ZG9pbmcgaXQgcGVyIGNoYW5jdHggaW4gbWFjODAyMTEgd291bGQgbWFrZSBzZW5zZT8NCg0KSSBk
b24ndCB0aGluayB0aGF0IGl0IG1ha2VzIHNlbnNlIHRvIGRvIGl0IHBlciBjaGFuY3R4IGluIG1h
YzgwMjExLg0KVGhlIGNmZzgwMjExIEFQSSB0byBjb25maWd1cmUgZmlsdGVyIGlzbid0IGF3YXJl
IGFib3V0IGNoYW5jdHgncyBhbmQgYWxzbw0KdmlmcyB0aGF0IHNoYXJlIHNhbWUgY2hhbmN0eCBt
YXkgaGF2ZSBkaWZmZXJlbnQgZmlsdGVycyBldGMuLg0KDQpBbmRyZWkNCj4gDQo+IE9uIHRoZSBv
dGhlciBoYW5kLCBJIHRoaW5rIG91ciBkZXZpY2UgcmVxdWlyZXMgaXQgcGVyIHZpZiwgc28gd2Un
ZCBwcm9iYWJseQ0KPiBoYXZlIHRvIGRvIGJvdGguDQo+IA0KPiArQW5kcmVpLCB3aG8gd2FzIGxv
b2tpbmcgaW50byB0aGlzLg0KPiANCj4gam9oYW5uZXMNCg0K
--
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
