Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:63309 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751050Ab1IUFIP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Sep 2011 01:08:15 -0400
From: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
To: "Guy, Wey-Yi W" <wey-yi.w.guy@intel.com>,
	Daniel Halperin <dhalperi@cs.washington.edu>
CC: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Wed, 21 Sep 2011 08:06:20 +0300
Subject: RE: [PATCH 7/8] iwlagn: pending frames musn't be incremented if agg
 is on
Message-ID: <4825B8A2C4E264489E57869F0DCFB223445749EA16@hasmsx502.ger.corp.intel.com> (sfid-20110921_070818_556694_D23FF1BA)
References: <1316558247-10018-1-git-send-email-wey-yi.w.guy@intel.com>
	 <1316558247-10018-8-git-send-email-wey-yi.w.guy@intel.com>
	 <CALSq=Ba0-Jryh=cU5bp9MpeTtOAru3YqavuTtwuudjO2_Ri5Ag@mail.gmail.com>
 <1316565315.23660.2.camel@wwguy-ubuntu>
In-Reply-To: <1316565315.23660.2.camel@wwguy-ubuntu>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

PiA+ID4NCj4gPiA+IEZyb206IEVtbWFudWVsIEdydW1iYWNoIDxlbW1hbnVlbC5ncnVtYmFjaEBp
bnRlbC5jb20+DQo+ID4gPg0KPiA+ID4gRHVyaW5nIG15IHdvcmtzIG9uIHRoZSB0cmFuc3BvcnQg
bGF5ZXIgSSByZW1vdmVkIGNvZGUgdGhhdCB1cGRhdGVkDQo+ID4gPiBhIGxvY2FsIHZhcmlhYmxl
IChpc19hZ2cpIHRoYXQgaXMgbmVlZGVkIHRvIGtlZXAgdGhlIHBlbmRpbmdfZnJhbWVzDQo+ID4g
PiBjb3VudCB1cCB0byBkYXRlLiBGaXggdGhpcy4NCj4gPg0KPiA+IFNlZW1zIGxpa2UgYSBiaWcg
YnVnLg0KPiA+DQo+ID4gSXMgdGhpcyBhIGJ1Z2ZpeCBmb3IgYSBwYXRjaCBlYXJsaWVyIGluIHRo
ZSBzZXJpZXMgb3IgYSBwYXRjaCB0aGF0J3MNCj4gPiBhbHJlYWR5IGJlZW4gYWNjZXB0ZWQuIElm
IHRoZSBmb3JtZXIsIHdoeSBub3QgbWVyZ2U/IElmIHRoZSBsYXR0ZXIsDQo+ID4gd2h5IG5vdCBD
QydlZCBhcyBhIGZpeCB0byBhbiBlYXJsaWVyIHZlcnNpb24gb2YgdGhlIGtlcm5lbD8NCj4gPg0K
PiBnb29kIHBvaW50LCBJIHdpbGwgd29yayB3aXRoIEVtbWFudWVsIHRvIGZpZ3VyZSBvdXQgaWYg
d2UgbmVlZCB0bw0KPiBiYWNrcG9ydCB0byB0aGUgZWFybGllciBrZXJuZWwNCj4gDQo+IFRoYW5r
cyBmb3IgY2F0Y2ggdGhpcyBvbmUNCj4gDQo+IFdleQ0KPiANCg0KVGhlIGJ1ZyB3YXMgaW50cm9k
dWNlZCBieSBlMTNjMGM1OWUwZWMzODU1OGFjODUzZDU2NTU1ZTkxNWI0ZGM3ZGMyIGluIEpvaG4n
cyB0cmVlIHdoaWNoIGlzbid0IGluIDMuMSBzZXJpZXMuIFNvIHRoZXJlIGlzIG5vIGVhcmxpZXIg
dmVyc2lvbiBvZiB0aGUga2VybmVsIHRoYXQgbmVlZCB0byBiZSBmaXhlZC4gQnVnIGludHJvZHVj
ZWQgYW5kIGZpeGVkIGluIDMuMiBieSBkaWZmZXJlbnQgcGF0Y2ggc2VyaWVzLg0KLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tCkludGVsIElzcmFlbCAoNzQpIExpbWl0ZWQKClRoaXMgZS1tYWlsIGFuZCBhbnkgYXR0YWNo
bWVudHMgbWF5IGNvbnRhaW4gY29uZmlkZW50aWFsIG1hdGVyaWFsIGZvcgp0aGUgc29sZSB1c2Ug
b2YgdGhlIGludGVuZGVkIHJlY2lwaWVudChzKS4gQW55IHJldmlldyBvciBkaXN0cmlidXRpb24K
Ynkgb3RoZXJzIGlzIHN0cmljdGx5IHByb2hpYml0ZWQuIElmIHlvdSBhcmUgbm90IHRoZSBpbnRl
bmRlZApyZWNpcGllbnQsIHBsZWFzZSBjb250YWN0IHRoZSBzZW5kZXIgYW5kIGRlbGV0ZSBhbGwg
Y29waWVzLgo=

