Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:39368 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753671AbcBAMc2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Feb 2016 07:32:28 -0500
From: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
To: Nikolay Martynov <mar.kolya@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Berg, Johannes" <johannes.berg@intel.com>,
	"julian.calaby@gmail.com" <julian.calaby@gmail.com>
Subject: RE: [PATCH v2] iwldvm: fix chain gain calibration when firmware
 return zero values
Date: Mon, 1 Feb 2016 12:32:24 +0000
Message-ID: <0BA3FCBA62E2DC44AF3030971E174FB32E9F5FAF@hasmsx107.ger.corp.intel.com> (sfid-20160201_133231_373945_2731E73C)
References: <1453527309-23881-1-git-send-email-mar.kolya@gmail.com>
	<1453760341-30008-1-git-send-email-mar.kolya@gmail.com>
	<0BA3FCBA62E2DC44AF3030971E174FB32E9D2EC6@hasmsx109.ger.corp.intel.com>
	<CALGY4fv5t7k9Xcw1iysL3gyLih7S4z2Y7ShXTJiXWc5aDVVM_A@mail.gmail.com>
	<0BA3FCBA62E2DC44AF3030971E174FB32E9E3F16@hasmsx107.ger.corp.intel.com>
	<CALGY4fsx3uPox8+=S13thXarW0yGLK+8BSqzjwqRtubrAG1ybQ@mail.gmail.com>
	<0BA3FCBA62E2DC44AF3030971E174FB32E9ED4FD@hasmsx107.ger.corp.intel.com>
 <CALGY4ftjhwJjDsgwwfL7NoCnpdqEATL4tsUAPM9yhdsm7ZChqg@mail.gmail.com>
In-Reply-To: <CALGY4ftjhwJjDsgwwfL7NoCnpdqEATL4tsUAPM9yhdsm7ZChqg@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

WyBzbmlwIF0NCg0KPiA+Pg0KPiA+DQo+ID4gQXJlIHlvdSBzdXJlIHRoYXQgdGhlIGFudGVubmEg
dGhhdCByZXBvcnRlZCAwICJyZWNvdmVycyIgYW5kIHJlcG9ydHMgZ29vZA0KPiB2YWx1ZXMgbGF0
ZXI/DQo+IA0KPiBJbiBmYWN0IGl0IGRvZXMsIGJ1dCBhcHBhcmVudGx5IHRoYXQncyBub3QgdGhl
IHByb2JsZW0gKEkndmUgY2hlY2tlZCB3aXRoDQo+IG1vbml0b3IgZGV2aWNlIGFuZCBhZnRlciBz
ZWVpbmcgemVyb3MgZHVyaW5nIGNhbGlicmF0aW9uIEkgc2VlIHBhY2tldHMgYW5kDQo+IG1heCBy
YXRlIGNvbWluZyBpbiBmcm9tIEFQKS4NCj4gDQo+IEkndmUgZG9uZSBzb21lIG1vcmUgdGVzdGlu
ZyBhbmQgaXQgdHVybnMgb3V0IHRoYXQgb3JpZ2luYWwgcHJvYmxlbSBvZiBvbmUNCj4gYW50ZW5u
YSBiZWluZyBkaXNhYmxlZCBpcyBjYXVzZWQgYnkgcG93ZXJfc2F2ZSBwYXJhbWV0ZXIgYmVpbmcg
c2V0IHRvDQo+IHRydWUuIEkgY2Fubm90IHJlcHJvZHVjZSB0aGUgcHJvYmxlbSB3aXRoIHRoYXQg
cGFyYW1ldGVyIGJlaW5nIHNldCB0byBmYWxzZS4NCj4gDQo+IEkgZ3Vlc3MgZmlybXdhcmUgdHVy
bnMgb2ZmIHNvbWUgcmVjZWl2aW5nIGFudGVubmFzIHRvIGNvbnNlcnZlIHBvd2VyIGFuZA0KPiBy
ZXBvcnRzIHRoYXQgc3RhdCBhcyB6ZXJvLg0KPiANCj4gSSBzZWUgdGhlcmUgaXMgc29tZSBsb2dp
YyB0byBwcmV2ZW50IHBvd2VyIHNhdmluZyBmcm9tIGFmZmVjdGluZyB0aGlzDQo+IGNhbGlicmF0
aW9uIGJ1dCBpdCBsb29rcyBsaWtlIGl0IGRvZXNuJ3Qgd29yayBwcm9wZXJseSB3aGVuIHBvd2Vy
X3NhdmU9dHJ1ZQ0KPiBhbmQgdW5mb3J0dW5hdGVseSBJIGNvdWxkIG5vdCBpbW1lZGlhdGVseSBm
aWd1cmUgb3V0IHdoeS4NCj4gDQo+IFBsZWFzZSBkaXNyZWdhcmQgdGhpcyBwYXRjaCBiZWNhdXNl
IG9yaWdpbmFsIHByb2JsZW0gaXMgY2F1c2UgYnkgcG93ZXINCj4gc2F2aW5nLCBub3QgYnkgZmly
bXdhcmUgaXNzdWUgKGF0IGxlYXN0IGFzIGZhciBhcyBJIGNvdWxkIHJlcHJvZHVjZSkuDQo+IA0K
PiBTb3JyeSBmb3Igbm90IHRlc3RpbmcgaXQgbW9yZSB0aG9yb3VnaGx5IGJlZm9yZSBzZW5kaW5n
IHRoZSBwYXRjaCBhbmQgdGhhbmtzDQo+IGZvciBraW5kbHkgcmV2aWV3aW5nIGl0IGFuZCBwcm92
aWRpbmcgY29tbWVudHMhDQo+IA0KDQpObyB3b3JyaWVzLCByZWFsbHkgOikNCg0K
