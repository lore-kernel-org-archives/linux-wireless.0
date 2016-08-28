Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:40324 "EHLO comal.ext.ti.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932281AbcH1HeS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 28 Aug 2016 03:34:18 -0400
From: "Mishol, Guy" <guym@ti.com>
To: "Pedersen, Thomas" <twp@qca.qualcomm.com>
CC: Kalle Valo <kvalo@codeaurora.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [PATCH] wlcore: mesh: add zone time sync support
Date: Sun, 28 Aug 2016 07:34:10 +0000
Message-ID: <97207D90F0289D498537011312FCAD1138F60850@DFRE01.ent.ti.com> (sfid-20160828_093422_541642_D5655864)
References: <20160808085706.22668-1-guym@ti.com>
         <1471538527.3432.21.camel@qca.qualcomm.com>
         <874m6h5bex.fsf@purkki.adurom.net>
         <97207D90F0289D498537011312FCAD1138F55E66@DFRE01.ent.ti.com>
 <1472151013.3432.33.camel@qca.qualcomm.com>
In-Reply-To: <1472151013.3432.33.camel@qca.qualcomm.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

T24gVGh1LCBBdWcgMjUsIDIwMTYgYXQgMjE6NTA6NTksIFBlZGVyc2VuLCBUaG9tYXMgd3JvdGU6
DQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0hdIHdsY29yZTogbWVzaDogYWRkIHpvbmUgdGltZSBzeW5j
IHN1cHBvcnQNCj4gDQo+IE9uIFN1biwgMjAxNi0wOC0yMSBhdCAxMDoxMyArMDAwMCwgTWlzaG9s
LCBHdXkgd3JvdGU6DQo+ID4gS2FsbGUvVGhvbWFzLA0KPiA+IFRoYW5rcyBmb3IgeW91ciBmZWVk
YmFjay4NCj4gPg0KPiA+IFRoaXMgdGltZSBzeW5jIHN1cHBvcnQgaXMgZGlmZmVyZW50IGZyb20g
dGhlIG9uZSB0aGF0IG1hYzgwMjExIA0KPiA+IG1haW50YWlucw0KPiB3aXRoIG1lc2ggcGVlcnMu
DQo+ID4gVGhpcyB0aW1lIHN5bmMgaXMgbW9zdGx5IHVzZWQgYnkgdXBwZXIgbGF5ZXJzIGZvciBz
ZXZlcmFsIA0KPiA+IGFwcGxpY2F0aW9ucyAobGlrZQ0KPiBhdWRpbykuDQo+ID4gSW4gdGhpcyBj
YXNlIHdlIGFsbG93IHRoZSB1c2VyIHRvIGNvbmZpZ3VyZSBmb3IgZWFjaCB6b25lIHdobyB3aWxs
IA0KPiA+IGJlIHRoZQ0KPiBzeW5jaHJvbml6ZXIuDQo+ID4gWW91IGNhbiByZWZlciB0byB0aGUg
Zm9sbG93aW5nIEFwcGxpY2F0aW9uIFJlcG9ydCAoY2hhcHRlciA2KSBmb3IgDQo+ID4gbW9yZQ0K
PiA+IGluZm9ybWF0aW9uOiBodHRwOi8vd3d3LnRpLmNvbS9saXQvYW4vc3dhYTE2Ni9zd2FhMTY2
LnBkZg0KPiANCj4gU28gaXQgYnJlYWtzIHJlZ3VsYXIgbWVzaCBzeW5jaHJvbml6YXRpb24/IFBv
d2VyIFNhdmUsIGFuZCBpbiB0aGUgDQo+IGZ1dHVyZSBwb3NzaWJseSBERlMgYW5kIE1DQ0EgcmVs
eSBvbiB0aGlzIHRvIHdvcmsuDQo+IA0KPiBJdCBzb3VuZHMgbGlrZSB5b3Ugd2FudCBzb21lIGFi
c29sdXRlIFRTRiB0aW1lIHN5bmNocm9uaXplZCB3aXRoaW4gMjB1cy4NCj4gTWVzaCBUU0Ygc3lu
Y2hyb25pemF0aW9uIGNhbiBwcm92aWRlIHRoaXMsIGl0J3MganVzdCBhIGxpdHRsZSBtb3JlIA0K
PiBjb21wbGljYXRlZCBhcyB5b3UnbGwgbmVlZCB0byBjb21wdXRlIGF0IHRoZSBhcHBsaWNhdGlv
biBsZXZlbCB1c2luZyB0aGUgcGVyLXN0YSBvZmZzZXRzLg0KPiBNZXNoIHN5bmNocm9uaXphdGlv
biBhY2N1cmFjeSB3YXMgcHJldHR5IGdvb2QgSUlSQywgdW5mb3J0dW5hdGVseSBJIA0KPiBkb24n
dCBoYXZlIGFueSB0ZXN0IGRhdGEgdG8gc2hhcmUgOigNCg0KWWVzLiBUaGlzIGZlYXR1cmUgY2Fu
IGhpdCB0aW1lIGFjY3VyYWN5IG9mIGxlc3MgdGhhbiAyMHVzIHdoZW4gdXNpbmcgd2wxOHh4IGRl
dmljZXMuDQpJdCBpcyBub3QgYnVpbHQgZm9yIG1lc2ggcm9sZSBzcGVjaWZpY2FsbHkgYnV0IGZv
ciBTVEEgYW5kIEFQIGFzIHdlbGwuDQpVbmxpa2UgU1RBIGFuZCBBUCBtb2RlcyB3aGVyZSB0aGUg
dG9wb2xvZ3kgaXMgd2VsbCBkZWZpbmVkIHdoZW4gcnVubmluZyBtZXNoDQp5b3UgaGF2ZSBzZXZl
cmFsIHpvbmVzIHRoYXQgY2FuIGJlIHRyZWF0ZWQgYXMgU1RBLUFQIHRvcG9sb2d5Lg0KVGhpcyBw
YXRjaCBqdXN0IGFkZCB0aGUgQVBJIGZvciBjb25maWd1cmluZyB3aGljaCBtZXNoIHBlZXIgd2ls
bCBhY3QgYXMgQVAgb24gaXRzIHpvbmUNCkZvciB0aGUgdGltZSBzeW5jaHJvbml6YXRpb24gbWF0
dGVyLg0KSXQgaGFzIG5vdGhpbmcgdG8gZG8gd2l0aCBNZXNoIFRTRiBzeW5jaHJvbml6YXRpb24g
c3BlY2lmaWNhbGx5IHNvIGl0IHNob3VsZG7igJl0IGJyZWFrIGFueXRoaW5nLg0KDQpHdXkNCg==
