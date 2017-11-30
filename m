Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out.qualcomm.com ([129.46.98.28]:39217 "EHLO
        alexa-out.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750747AbdK3QjJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 30 Nov 2017 11:39:09 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: =?utf-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@toke.dk>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
        "akolli@codeaurora.org" <akolli@codeaurora.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "Anilkumar Kolli" <akolli@qti.qualcomm.com>
Subject: Re: [PATCH 2/2] ath10k: add per peer tx stats support for 10.2.4
Date: Thu, 30 Nov 2017 16:38:54 +0000
Message-ID: <87bmjjzppd.fsf@kamboji.qca.qualcomm.com> (sfid-20171130_173913_231457_452BB4B0)
References: <1512046701-14435-1-git-send-email-akolli@qti.qualcomm.com>
        <1512046701-14435-3-git-send-email-akolli@qti.qualcomm.com>
        <87k1y7zqtj.fsf@kamboji.qca.qualcomm.com>
        <DAB5EBB8-C820-4056-8AAB-063D05F38BD5@toke.dk>
In-Reply-To: <DAB5EBB8-C820-4056-8AAB-063D05F38BD5@toke.dk> ("Toke
        \=\?utf-8\?Q\?H\=C3\=B8iland-J\=C3\=B8rgensen\=22's\?\= message of "Thu, 30
 Nov 2017 17:28:42 +0100")
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2VuIDx0b2tlQHRva2UuZGs+IHdyaXRlczoNCg0KPj4+ICtz
dHJ1Y3QgYXRoMTBrXzEwXzJfcGVlcl90eF9zdGF0cyB7DQo+Pj4gKwl1OCByYXRlY29kZVtQRUVS
X1NUQVRTX0ZPUl9OT19PRl9QUERVU107DQo+Pj4gKwl1OCBzdWNjZXNzX3BrdHNbUEVFUl9TVEFU
U19GT1JfTk9fT0ZfUFBEVVNdOw0KPj4+ICsJX19sZTE2IHN1Y2Nlc3NfYnl0ZXNbUEVFUl9TVEFU
U19GT1JfTk9fT0ZfUFBEVVNdOw0KPj4+ICsJdTggcmV0cnlfcGt0c1tQRUVSX1NUQVRTX0ZPUl9O
T19PRl9QUERVU107DQo+Pj4gKwlfX2xlMTYgcmV0cnlfYnl0ZXNbUEVFUl9TVEFUU19GT1JfTk9f
T0ZfUFBEVVNdOw0KPj4+ICsJdTggZmFpbGVkX3BrdHNbUEVFUl9TVEFUU19GT1JfTk9fT0ZfUFBE
VVNdOw0KPj4+ICsJX19sZTE2IGZhaWxlZF9ieXRlc1tQRUVSX1NUQVRTX0ZPUl9OT19PRl9QUERV
U107DQo+Pj4gKwl1OCBmbGFnc1tQRUVSX1NUQVRTX0ZPUl9OT19PRl9QUERVU107DQo+Pj4gKwlf
X2xlMzIgdHhfZHVyYXRpb247DQo+Pj4gKwl1OCB0eF9wcGR1X2NudDsNCj4+PiArCXU4IHBlZXJf
aWQ7DQo+Pj4gK30gX19wYWNrZWQ7DQo+Pg0KPj5Ub2tlLCBob3BlZnVsbHkgdGhlIHR4X2R1cmF0
aW9uIHZhbHVlIGhlcmUgaGVscHMgd2l0aCBBVEYNCj4+aW1wbGVtZW50YXRpb24NCj4+dXNpbmcg
UUNBOTg4WC4NCj4NCj4gQXdlc29tZSEgV2hhdCdzIHRoZSBzZW1hbnRpY3Mgb2YgdGhpcyBmaWVs
ZD8gSnVzdCB0b3RhbCANCj4gZHVyYXRpb24gc3BlbnQgc2VydmluZyB0aGF0IHN0YXRpb24gaW4g
dGhlIHJlcG9ydGluZyBpbnRlcnZhbD8NCj4gRG9lcyBpdCBpbmNsdWRlIHJldHJ5IGF0dGVtcHRz
Pw0KDQpJIGhhdmUgbm8gY2x1ZSA6KSBJIGp1c3Qgbm90aWNlZCB0aGlzIHdoaWxlIEkgd2FzIHJl
dmlld2luZyB0aGUgcGF0Y2gNCmludGVybmFsbHkgYW5kIGltbWVkaWF0ZWx5IHJlY2FsbGVkIG91
ciBkaXNjdXNzaW9ucyBhdCBTZW91bC4gSSBjYW4gdHJ5DQp0byBmaW5kIG91dCwgYnV0IHRoYXQg
d2lsbCB0YWtlIGEgbG9uZyB0aW1lIGFzIEkgaGF2ZSB3YXkgdG9vIG11Y2ggc3R1ZmYNCnBlbmRp
bmcgYXQgdGhlIG1vbWVudC4gSG9wZWZ1bGx5IHNvbWVvbmUgbW9yZSBrbm93bGVkZ2VhYmxlIChB
bmlsa3VtYXI/KQ0KY2FuIGNoaW1lIGluIGFuZCBoZWxwLg0KDQotLSANCkthbGxlIFZhbG8=
