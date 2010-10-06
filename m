Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:43465 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758316Ab0JFGTf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Oct 2010 02:19:35 -0400
From: "Gabay, Benzy" <benzyg@ti.com>
To: Juuso Oikarinen <juuso.oikarinen@nokia.com>
CC: "Coelho Luciano (Nokia-MS/Helsinki)" <Luciano.Coelho@nokia.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Wed, 6 Oct 2010 01:19:29 -0500
Subject: RE: [PATCH 13/25] wl1271: Enable/disable 11a support based on INI
 configuration
Message-ID: <676FD6AA0F002F49B89E70F0C5EFD22C135ADBA335@dlee04.ent.ti.com>
References: <1285576669-8070-1-git-send-email-luciano.coelho@nokia.com>
	 <1285576669-8070-14-git-send-email-luciano.coelho@nokia.com>
	 <676FD6AA0F002F49B89E70F0C5EFD22C135ADBA314@dlee04.ent.ti.com>
 <1286343360.11177.262.camel@wimaxnb.nmp.nokia.com>
In-Reply-To: <1286343360.11177.262.camel@wimaxnb.nmp.nokia.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

SnV1c28sDQoNCg0KPiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBTZW50OiBXZWRuZXNk
YXksIE9jdG9iZXIgMDYsIDIwMTAgMTI6MzYgQU0NCj4gDQo+IE9uIFdlZCwgMjAxMC0xMC0wNiBh
dCAwNzoyNiArMDIwMCwgZXh0IEdhYmF5LCBCZW56eSB3cm90ZToNCj4gPiBKdXVzbyAsDQo+ID4g
SSB0aG91Z2h0IHRoYXQgdGhlcmUgaXMgbm8gLmluaSBpbiB0aGUgMTI3MSBNQUM4MDIuMTEgc29s
dXRpb24uDQo+ID4gQWNjb3JkaW5nIHRvIHRoZSBjb2RlIGJlbG93IHlvdSBhcmUgZGVjaWRpbmcg
aWYgaXQgaXMgImEiIG9yIG5vdA0KPiBhY2NvcmRpbmcgdG8gTlZTIGZpbGUuDQo+ID4NCj4gPiBJ
cyBpdCBhIHR5cG8gaW4geW91ciBoZWFkZXIgZGVzY3JpcHRpb24gb3IgZGlkIEkgZ2V0IGl0IHdy
b25nPw0KPiANCj4gTm8gdHlwbywgdGhlcmUgaXMgYSBjb25maWd1cmF0aW9uIHNlY3Rpb24gaW5z
aWRlIHRoZSB3bDEyNzEtbnZzLmJpbg0KPiAtZmlsZSByZWZlcnJlZCB0byBhcyB0aGUgIklOSS1z
ZWN0aW9uLiIgVGhhdCBpbmkgc2VjdGlvbiBjb25maWd1cmVzDQo+IGdlbmVyYWwgcGFyYW1ldGVy
cyAoaW5jbHVkaW5nIHRoZSBkdWFsLWJhbmQgc3VwcG9ydCkgYW5kIHNldmVyYWwNCj4gcmFkaW8t
cGFyYW1ldGVycy4NCg0KDQoNCkdvdCBpdC4gDQpUaGFua3MgZm9yIHRoZSBwYXRpZW50Lg0KDQpC
ZW56eQ0KDQoNCj4gDQo+IFRoZXNlIElOSS1wYXJhbWV0ZXJzIGFyZSB0aGUgb25seSB3YXkgZm9y
IHRoZSBkcml2ZXIgdG8ga25vdyB3aGV0aGVyDQo+IHRoZXJlIGlzIDExYSBSRiBzdXBwb3J0IGlu
IHRoZSBoYXJkd2FyZSBvciBub3QuDQo+IA0KPiAtSnV1c28NCg0KDQo+IA0KPiA+ID4gU2VudDog
TW9uZGF5LCBTZXB0ZW1iZXIgMjcsIDIwMTAgMzozOCBBTQ0KPiA+ID4NCj4gPiA+IEZyb206IEp1
dXNvIE9pa2FyaW5lbiA8anV1c28ub2lrYXJpbmVuQG5va2lhLmNvbT4NCj4gPiA+DQo+ID4gPiBJ
bnN0ZWFkIG9mIGhhcmRjb2RpbmcgMTFhIHN1cHBvcnQsIGVuYWJsZS9kaXNhYmxlIGRyaXZlciBz
dXBwb3J0DQo+IGJhc2VkDQo+ID4gPiBvbg0KPiA+ID4gdGhlIGR1YWwtbW9kZS1zZWxlY3QgcGFy
YW1ldGVyIGluIHRoZSBudnMtZmlsZSBnZW5lcmFsIHBhcmFtdGVycy4NCj4gPiA+DQo+ID4gPiBT
aWduZWQtb2ZmLWJ5OiBKdXVzbyBPaWthcmluZW4gPGp1dXNvLm9pa2FyaW5lbkBub2tpYS5jb20+
DQo+ID4gPiBSZXZpZXdlZC1ieTogTHVjaWFubyBDb2VsaG8gPGx1Y2lhbm8uY29lbGhvQG5va2lh
LmNvbT4NCj4gPiA+IFNpZ25lZC1vZmYtYnk6IEx1Y2lhbm8gQ29lbGhvIDxsdWNpYW5vLmNvZWxo
b0Bub2tpYS5jb20+DQo+ID4gPiAtLS0NCj4gDQo+IA0KDQo=
