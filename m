Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:10133 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752267AbdDKGG6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 11 Apr 2017 02:06:58 -0400
From: Manikanta Pubbisetty <mpubbise@qti.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
Subject: RE: [RFCv2 2/2] mac80211: Implement data xmit for 802.11 encap
 offload
Date: Tue, 11 Apr 2017 06:06:50 +0000
Message-ID: <0dac83ae0f6f406b96e82be011dad54a@aphydexm01a.ap.qualcomm.com> (sfid-20170411_080703_245874_EA89F1C4)
References: <1488540807-27415-1-git-send-email-mpubbise@qti.qualcomm.com>
         <1488540807-27415-3-git-send-email-mpubbise@qti.qualcomm.com>
         <1488544754.25750.8.camel@sipsolutions.net>
         <30b4079fcf574d6fb62a10d8fa85ac06@aphydexm01f.ap.qualcomm.com>
         <1489008812.7127.9.camel@sipsolutions.net>
         <828dd0c9cb0d409eb4d3aadc7f585a69@aphydexm01f.ap.qualcomm.com>
         <1489500692.10872.11.camel@sipsolutions.net>
         <fbc82bc9af344237bd5cd3210d9d012e@aphydexm01f.ap.qualcomm.com>
 <1490961139.6288.10.camel@sipsolutions.net>
In-Reply-To: <1490961139.6288.10.camel@sipsolutions.net>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

PlNvcnJ5LCBhbG1vc3QgZHJvcHBlZCB0aGlzIHRocmVhZCAtIG15IGJhZC4NCj4NCj4+ID4gPiBb
TWFuaWthbnRhXSBIbW1tLCBJIHdvdWxkIGxpa2UgdG8gaGF2ZSBpZWVlODAyMTFfdHhfc3RhdHVz
XzgwMjMNCj4+ID4gPiBmb3Igbm93IGFuZCBnbyB3aXRoIGEgVE9ETyBmb3Igc2luZ2xlIHR4IHJl
cG9ydGluZyBtZWNoYW5pc20gZm9yDQo+PiA+ID4gYm90aCBFdGhlcm5ldCBhbmQgODAyLjExIHR4
IGZvcm1hdHMuIEFueSB0aG91Z2h0cz8NCj4+ID4NCj4+ID4gVGhlcmUncyBhbiBhZGRpdGlvbmFs
IHdyaW5rbGUgYnR3IC0gd2UgY3VycmVudGx5IHJlcG9ydCB0aGUgODAyLjExDQo+PiA+IGZyYW1l
IHRvIHRoZSBtb25pdG9yIGludGVyZmFjZSwgaWYgYWN0aXZlLiBOb3Qgc3VyZSB3ZSBjYW4ga2Vl
cA0KPj4gPiB0aGF0LCBidXQgaXQncyBzb21ldGhpbmcgdG8gdGhpbmsgYWJvdXQuDQo+PiA+DQo+
Pg0KPj4gW01hbmlrYW50YV0gR29vZCBwb2ludCwgdGhpcyBpcyBzb21ldGhpbmcgd2UgaGF2ZSB0
byB0aGluayBhYm91dC4gSQ0KPj4gYmVsaWV2ZSB0aGlzIG9uZSBpcyB0cmlja3ksIGRvIHdlIG5l
ZWQgdG8gYWRkIHRoZSAuMTEgaGVhZGVyIGp1c3QNCj4+IGJlZm9yZSBnaXZpbmcgdG8gbW9uaXRv
ciBpbnRlcmZhY2VzPw0KPg0KPkl0J3MgY29tcGxpY2F0ZWQuIFRoZSBpbnRlcmZhY2UgaGFzIHJh
ZGlvdGFwKzgwMi4xMSB0eXBlLCBzbyBvbiB0aGUgb25lIGhhbmQgaXQNCj5zaG91bGQgaGF2ZSA4
MDIuMTEgaGVhZGVyLiBPbiB0aGUgb3RoZXIgaGFuZCwgaGF2aW5nIHdoYXQgd2VudCB0byB0aGUN
Cj5oYXJkd2FyZSBjYW4gYmUgaGVscGZ1bC4gSG93ZXZlciwgSSBkb24ndCB0aGluayB3ZSBjYW4g
Z2V0IGFyb3VuZCB0aGUNCj5yYWRpb3RhcCs4MDIuMTEgdHlwZSBpbiBhbnkgd2F5Lg0KPg0KPj4g
SG93IGltcG9ydGFudCB3aWxsIHRoaXMgYmUgZm9yIEV0aGVybmV0IHR4IGNoYW5nZXM/IEkgYW0g
cnVubmluZyBvdXQNCj4+IG9mIHRob3VnaHRzLg0KPg0KPldlbGwgSSB0aGluayBpdCdzIHNvbWV0
aGluZyB3ZSBzaG91bGQgY29uc2lkZXIgd2hlbiB3ZSBsb29rIGF0IHRoaXMgcGF0aC4NCj5Ib3Bl
ZnVsbHkgbm9ib2R5IHdobyByZWFsbHkgY2FyZXMgYWJvdXQgcGVyZm9ybWFuY2UgaGFzIHRoZSBt
b25pdG9yIHN0dWZmDQo+YWN0aXZlIC0gYWx0aG91Z2ggd2UncmUgdGhpbmtpbmcgb2Ygd2F5cyB0
byBwdXNoIGRvd24gZmlsdGVycyB0byBtYWtlIHRoYXQgbGVzcw0KPmV4cGVuc2l2ZS4NCj4NCj5K
b2hhbm5lcw0KDQpbTWFuaWthbnRhXSBUaGFua3MgZm9yIHlvdXIgdGltZSBpbiByZXZpZXdpbmcg
dGhlIHBhdGNoIEpvaGFubmVzLCBJIHdpbGwgbWFrZSB0aGUgY2hhbmdlcyBhcyBkaXNjdXNzZWQg
YW5kIHNlbmQgb3V0IHRoZSBuZXh0IHJldmlzaW9uIG9mIHRoZSBwYXRjaC4NCg0KLS0NCk1hbmlr
YW50YQ0K
