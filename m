Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:28086 "EHLO
        sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753253AbdLAOtM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 1 Dec 2017 09:49:12 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: =?utf-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@toke.dk>
CC: "akolli@codeaurora.org" <akolli@codeaurora.org>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "Anilkumar Kolli" <akolli@qti.qualcomm.com>,
        "linux-wireless-owner@vger.kernel.org"
        <linux-wireless-owner@vger.kernel.org>
Subject: Re: [PATCH 2/2] ath10k: add per peer tx stats support for 10.2.4
Date: Fri, 1 Dec 2017 14:49:02 +0000
Message-ID: <87k1y6y04i.fsf@kamboji.qca.qualcomm.com> (sfid-20171201_154933_498091_F6F7486D)
References: <1512046701-14435-1-git-send-email-akolli@qti.qualcomm.com>
        <1512046701-14435-3-git-send-email-akolli@qti.qualcomm.com>
        <87k1y7zqtj.fsf@kamboji.qca.qualcomm.com>
        <DAB5EBB8-C820-4056-8AAB-063D05F38BD5@toke.dk>
        <87bmjjzppd.fsf@kamboji.qca.qualcomm.com>
        <5080a68538fd2d883e15bacaa969661b@codeaurora.org>       <87r2se36rq.fsf@toke.dk>
In-Reply-To: <87r2se36rq.fsf@toke.dk> ("Toke
 \=\?utf-8\?Q\?H\=C3\=B8iland-J\?\= \=\?utf-8\?Q\?\=C3\=B8rgensen\=22's\?\=
 message of     "Fri, 01 Dec 2017 14:41:13 +0100")
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2VuIDx0b2tlQHRva2UuZGs+IHdyaXRlczoNCg0KPiBha29s
bGlAY29kZWF1cm9yYS5vcmcgd3JpdGVzOg0KPg0KPj4gT24gMjAxNy0xMS0zMCAyMjowOCwgS2Fs
bGUgVmFsbyB3cm90ZToNCj4+PiBUb2tlIEjDuGlsYW5kLUrDuHJnZW5zZW4gPHRva2VAdG9rZS5k
az4gd3JpdGVzOg0KPj4+IA0KPj4+Pj4+ICtzdHJ1Y3QgYXRoMTBrXzEwXzJfcGVlcl90eF9zdGF0
cyB7DQo+Pj4+Pj4gKwl1OCByYXRlY29kZVtQRUVSX1NUQVRTX0ZPUl9OT19PRl9QUERVU107DQo+
Pj4+Pj4gKwl1OCBzdWNjZXNzX3BrdHNbUEVFUl9TVEFUU19GT1JfTk9fT0ZfUFBEVVNdOw0KPj4+
Pj4+ICsJX19sZTE2IHN1Y2Nlc3NfYnl0ZXNbUEVFUl9TVEFUU19GT1JfTk9fT0ZfUFBEVVNdOw0K
Pj4+Pj4+ICsJdTggcmV0cnlfcGt0c1tQRUVSX1NUQVRTX0ZPUl9OT19PRl9QUERVU107DQo+Pj4+
Pj4gKwlfX2xlMTYgcmV0cnlfYnl0ZXNbUEVFUl9TVEFUU19GT1JfTk9fT0ZfUFBEVVNdOw0KPj4+
Pj4+ICsJdTggZmFpbGVkX3BrdHNbUEVFUl9TVEFUU19GT1JfTk9fT0ZfUFBEVVNdOw0KPj4+Pj4+
ICsJX19sZTE2IGZhaWxlZF9ieXRlc1tQRUVSX1NUQVRTX0ZPUl9OT19PRl9QUERVU107DQo+Pj4+
Pj4gKwl1OCBmbGFnc1tQRUVSX1NUQVRTX0ZPUl9OT19PRl9QUERVU107DQo+Pj4+Pj4gKwlfX2xl
MzIgdHhfZHVyYXRpb247DQo+Pj4+Pj4gKwl1OCB0eF9wcGR1X2NudDsNCj4+Pj4+PiArCXU4IHBl
ZXJfaWQ7DQo+Pj4+Pj4gK30gX19wYWNrZWQ7DQo+Pj4+PiANCj4+Pj4+IFRva2UsIGhvcGVmdWxs
eSB0aGUgdHhfZHVyYXRpb24gdmFsdWUgaGVyZSBoZWxwcyB3aXRoIEFURg0KPj4+Pj4gaW1wbGVt
ZW50YXRpb24NCj4+Pj4+IHVzaW5nIFFDQTk4OFguDQo+Pj4+IA0KPj4+PiBBd2Vzb21lISBXaGF0
J3MgdGhlIHNlbWFudGljcyBvZiB0aGlzIGZpZWxkPyBKdXN0IHRvdGFsDQo+Pj4+IGR1cmF0aW9u
IHNwZW50IHNlcnZpbmcgdGhhdCBzdGF0aW9uIGluIHRoZSByZXBvcnRpbmcgaW50ZXJ2YWw/DQo+
Pj4+IERvZXMgaXQgaW5jbHVkZSByZXRyeSBhdHRlbXB0cz8NCj4+PiANCj4+PiBJIGhhdmUgbm8g
Y2x1ZSA6KSBJIGp1c3Qgbm90aWNlZCB0aGlzIHdoaWxlIEkgd2FzIHJldmlld2luZyB0aGUgcGF0
Y2gNCj4+PiBpbnRlcm5hbGx5IGFuZCBpbW1lZGlhdGVseSByZWNhbGxlZCBvdXIgZGlzY3Vzc2lv
bnMgYXQgU2VvdWwuIEkgY2FuIHRyeQ0KPj4+IHRvIGZpbmQgb3V0LCBidXQgdGhhdCB3aWxsIHRh
a2UgYSBsb25nIHRpbWUgYXMgSSBoYXZlIHdheSB0b28gbXVjaCANCj4+PiBzdHVmZg0KPj4+IHBl
bmRpbmcgYXQgdGhlIG1vbWVudC4gSG9wZWZ1bGx5IHNvbWVvbmUgbW9yZSBrbm93bGVkZ2VhYmxl
IA0KPj4+IChBbmlsa3VtYXI/KQ0KPj4+IGNhbiBjaGltZSBpbiBhbmQgaGVscC4NCj4+DQo+PiB0
eF9kdXJhdGlvbiBpcyBhZ2dyZWdhdGUgdGltZSBkdXJhdGlvbiBvZiA0IFBQRFUgc2VudCB0byBT
VEEuDQo+PiBGVyBzZW5kcyB0aGVzZSB2YWx1ZXMgZm9yIHJldHJ5IHBhY2tldHMgYWxzby4NCj4N
Cj4gR3JlYXQsIHRoYXQgc291bmRzIGxpa2UganVzdCB3aGF0IHdlIG5lZWQuDQoNCkV4Y2VwdCBt
YXBwaW5nIHRvIHRoZSBpZWU4MDIxMV90eF9zdGF0dXMoKSBtaWdodCBiZSBkaWZmaWN1bHQuIEkn
bSBub3QNCnN1cmUgaG93IEhUVF9UMkhfTVNHX1RZUEVfUEtUTE9HIGV2ZW50cyBhcmUgc2VudCBp
biByZWxhdGlvbiB0bw0KSFRUX1QySF9NU0dfVFlQRV9UWF9DT01QTF9JTkQuDQoNCi0tIA0KS2Fs
bGUgVmFsbw==
