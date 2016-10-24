Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:51965 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S938845AbcJXOUn (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 24 Oct 2016 10:20:43 -0400
From: "Undekari, Sunil Dutt" <usdutt@qti.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>,
        "Kushwaha, Purushottam" <pkushwah@qti.qualcomm.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "Malinen, Jouni" <jouni@qca.qualcomm.com>,
        "Hullur Subramanyam, Amarnath" <amarnath@qca.qualcomm.com>
Subject: RE: [PATCH v3] cfg80211: Check radar_detect and
 num_different_channels with beacon interface combinations.
Date: Mon, 24 Oct 2016 14:20:31 +0000
Message-ID: <a413d57641114fbcb4c33d4b0fa46d01@aphydexm01f.ap.qualcomm.com> (sfid-20161024_162048_009222_3232B26E)
References: <1476371730-23027-1-git-send-email-pkushwah@qti.qualcomm.com>
         <1477052876.4068.40.camel@sipsolutions.net>
         <9a1df5c048894351bbec2d502772b862@aphydexm01f.ap.qualcomm.com>
 <1477316138.4085.19.camel@sipsolutions.net>
In-Reply-To: <1477316138.4085.19.camel@sipsolutions.net>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

T0sgLiBUaGFua3MgLiBXZSBzaGFsbCB3YWl0IGZvciB0aGVtIHRvIGdldCB1cCBzdHJlYW1lZC4N
Cg0KUmVnYXJkcywNClN1bmlsDQogIA0KDQotLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KRnJv
bTogSm9oYW5uZXMgQmVyZyBbbWFpbHRvOmpvaGFubmVzQHNpcHNvbHV0aW9ucy5uZXRdIA0KU2Vu
dDogTW9uZGF5LCBPY3RvYmVyIDI0LCAyMDE2IDc6MDYgUE0NClRvOiBVbmRla2FyaSwgU3VuaWwg
RHV0dCA8dXNkdXR0QHF0aS5xdWFsY29tbS5jb20+OyBLdXNod2FoYSwgUHVydXNob3R0YW0gPHBr
dXNod2FoQHF0aS5xdWFsY29tbS5jb20+DQpDYzogbGludXgtd2lyZWxlc3NAdmdlci5rZXJuZWwu
b3JnOyBNYWxpbmVuLCBKb3VuaSA8am91bmlAcWNhLnF1YWxjb21tLmNvbT47IEh1bGx1ciBTdWJy
YW1hbnlhbSwgQW1hcm5hdGggPGFtYXJuYXRoQHFjYS5xdWFsY29tbS5jb20+DQpTdWJqZWN0OiBS
ZTogW1BBVENIIHYzXSBjZmc4MDIxMTogQ2hlY2sgcmFkYXJfZGV0ZWN0IGFuZCBudW1fZGlmZmVy
ZW50X2NoYW5uZWxzIHdpdGggYmVhY29uIGludGVyZmFjZSBjb21iaW5hdGlvbnMuDQoNCk9uIE1v
biwgMjAxNi0xMC0yNCBhdCAxMTo1OSArMDAwMCwgVW5kZWthcmksIFN1bmlsIER1dHQgd3JvdGU6
DQo+ID4gDQo+ID4gSSd2ZSBqdXN0IHNlbnQgb3V0IGEgZmV3IHBhdGNoZXMgdGhhdCwgSSB0aGlu
aywgaW1wbGVtZW50IHRoZSANCj4gPiBuZWNlc3NhcnkgdmFsaWRhdGlvbiBmb3IganVzdCB0aGUg
YmVhY29uIGludGVydmFscywgd2l0aG91dCBhbGwgdGhpcyANCj4gPiBleHRyYSBiYWdnYWdlLiBQ
bGVhc2UgdGFrZSBhIGxvb2sgYW5kIGxldCBtZSBrbm93IHdoYXQgeW91IHRoaW5rLg0KPiBJIHVu
ZGVyc3RhbmQgdGhhdCB0aGUgbmV3IHBhdGNoZXMgZnJvbSB5b3UgYXJlIGluIGNvbnNpc3RlbnQg
d2l0aCB0aGUgDQo+IGV4aXN0aW5nIGRlc2lnbiBvZiB2YWxpZGF0aW5nIHRoZSByYWRhciBkZXRl
Y3Rpb24gLyBjaGFubmVscyBieSBoYXZpbmcgDQo+IHRoaXMgdmFsaWRhdGlvbiBkb25lIGluIHRo
ZSBjZmc4MDIxMSBkcml2ZXJzIHRocm91Z2ggDQo+IGNmZzgwMjExX2NoZWNrX2NvbWJpbmF0aW9u
cy4NCg0KT2ssIHNvIHdlIGFncmVlIGhlcmUsIHRoYXQncyBnb29kIDopDQoNCj4gV2l0aCB0aGlz
IGFwcHJvYWNoICwgd291bGRuJ3QgdGhlIGV4aXN0aW5nIGNmZzgwMjExIGRyaXZlcnMgYmVoYXZl
IHRoZSANCj4gb3RoZXIgd2F5ID8gSSBtZWFuICwgd2l0aCB0aGVzZSBjb21taXRzIGFuZCB0aGUg
Y3VycmVudCBjZmc4MDIxMSANCj4gZHJpdmVycyAoIGRvIG5vdCBhZHZlcnRpc2UgYmVhY29uX2lu
dF9taW5fZ2NkIGFuZCBpbnZva2UNCj4gY2ZnODAyMTFfY2hlY2tfY29tYmluYXRpb25zKSAsIHRo
ZSB2YWxpZGF0aW9uIGZvciB0aGUgZGlmZmVyZW50IGJlYWNvbiANCj4gaW50ZXJ2YWwgc2hhbGwg
c3VjY2VlZCAsIGJ1dCB0aGUgY3VycmVudCBrZXJuZWwgKCBjZmc4MDIxMSBpbnRlcmZhY2UgKSAN
Cj4gd2l0aCB0aGUgc2FtZSBkcml2ZXIgZmFpbHMgdGhlIHN0YXJ0IG9mIHRoZSBBUCAvIG1lc2gu
DQo+IElzIGl0IG5vdCBicmVha2luZyB0aGUgYmFja3dhcmQgY29tcGF0aWJpbGl0eSA/IElzIHRo
aXMgZXhwZWN0ZWQgPw0KDQpBbnkgZHJpdmVyIHRoYXQgc3VwcG9ydHMgY29tYmluYXRpb25zIHNo
b3VsZCBhbHNvIGludm9rZSBjaGVja19jb21iaW5hdGlvbnMuIFRoaXMgZG9lc24ndCBhcHBlYXIg
dG8gYmUgdHJ1ZSBmb3IgbXdpZmlleCwgYnV0IHRoYXQncyBhbHJlYWR5IGEgYnVnL3Byb2JsZW0g
aW4gdGhhdCBkcml2ZXIsIGl0IGRvZXNuJ3QgcmVhbGx5IGNoYW5nZSBtdWNoPw0KDQpqb2hhbm5l
cw0K
