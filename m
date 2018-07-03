Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rtits2.realtek.com ([211.75.126.72]:54842 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753987AbeGCGDy (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 3 Jul 2018 02:03:54 -0400
From: Pkshih <pkshih@realtek.com>
To: "kvalo@codeaurora.org" <kvalo@codeaurora.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "Larry.Finger@lwfinger.net" <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH 13/14] rtlwifi: access skb->data to get C2H data by macro
Date: Tue, 3 Jul 2018 06:03:42 +0000
Message-ID: <1530597815.6330.4.camel@realtek.com> (sfid-20180703_080358_584434_08405CD6)
References: <20180518093007.23594-1-pkshih@realtek.com>
         <20180518093007.23594-14-pkshih@realtek.com>
         <87po1fhwfd.fsf@purkki.adurom.net> <1527732798.8418.7.camel@realtek.com>
         <87sh56f3sv.fsf@codeaurora.org>
In-Reply-To: <87sh56f3sv.fsf@codeaurora.org>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

T24gRnJpLCAyMDE4LTA2LTI5IGF0IDEwOjMwICswMzAwLCBLYWxsZSBWYWxvIHdyb3RlOg0KPiBQ
a3NoaWggPHBrc2hpaEByZWFsdGVrLmNvbT4gd3JpdGVzOg0KPiANCj4gPiBPbiBUdWUsIDIwMTgt
MDUtMjkgYXQgMDg6MTggKzAzMDAsIEthbGxlIFZhbG8gd3JvdGU6DQo+ID4+IDxwa3NoaWhAcmVh
bHRlay5jb20+IHdyaXRlczoNCj4gPj7CoA0KPiA+DQo+ID4gQmVjYXVzZSBDMkggZGF0YSBpcyBs
aXR0bGUgZW5kaWFuIG9yZGVyLCB0aGUgc3RydWN0IHdpbGwgbG9vayBsaWtlDQo+ID4gc3RydWN0
IGZvbyB7DQo+ID4gI2lmZGVmwqBfX0xJVFRMRV9FTkRJQU4NCj4gPsKgCXU4IGJhcjo0Ow0KPiA+
wqAJdTgga29vOjQ7DQo+ID4gI2Vsc2UNCj4gPsKgCXU4IGtvbzo0Ow0KPiA+wqAJdTggYmFyOjQ7
DQo+ID4gI2VuZGlmDQo+ID4gfQ0KPiANCj4gV2l0aCB1OCB5b3UgZG9uJ3QgbmVlZCBlbmRpYW4g
Y2hlY2ssIHJpZ2h0PyBJIHdvdWxkIGFzc3VtZSB0aGF0IHdpdGgNCj4gYm90aCBsaXR0bGUgYW5k
IGJpZyBlbmRpYW4gYmFyIGFuZCBrb28gd291bGQgYmUgaW4gdGhlIHNhbWUgcGxhY2UuDQoNCkkg
dGhpbmsgdTggd2l0aCBiaXRmaWVsZCB3b3VsZCBiZSBkaWZmZXJlbnQgYmV0d2VlbiBsaXR0bGUg
YW5kIGJpZyBlbmRpYW4NCm1hY2hpbmVzLg0KDQo+ID4gSXMgdGhpcyBhIGxpbnV4IGNvbnZlbnRp
b24/DQo+IA0KPiBFYXJsaWVyIGJpdGZpZWxkcyB3ZXJlIGRpc2xpa2VkIGJ1dCBub3dhZGF5cyB0
aGV5IHNlZW0gdG8gYmUgaGF2ZSBiZWNvbWUNCj4gbW9yZSBhY2NlcHRhYmxlLiBCdXQgSSB0aGlu
ayB0aGUgcHJlZmVycmVkIHdheSBzdGlsbCBpcyBzb21ldGhpbmcgbGlrZQ0KPiB0aGlzICh1c2lu
ZyB1MzIgYW5kIDE2IGJpdCBmaWVsZHMpOg0KPiANCj4gc3RydWN0IGZvbyB7DQo+IMKgwqDCoMKg
wqDCoMKgwqBfX2xlMzIga29vYmFyOw0KPiB9DQo+IA0KPiAjZGVmaW5lIFJUTFdJRklfQkFSX01B
U0sgR0VOTUFTSygxNSwgMCkNCj4gI2RlZmluZSBSVExXSUZJX0tPT19NQVNLIEdFTk1BU0soMzEs
IDE2KQ0KPiANCj4gYmFyID0gRklFTERfR0VUKFJUTFdJRklfQkFSX01BU0ssIF9fbGUzMl90b19j
cHUoZm9vLT5rb29iYXIpKTsNCj4ga29vID0gRklFTERfR0VUKFJUTFdJRklfS09PX01BU0ssIF9f
bGUzMl90b19jcHUoZm9vLT5rb29iYXIpKTsNCj4gDQo+IE9mIGNvdXJzZSB0aGVyZSBjYW4gYmUg
b3RoZXIgZ29vZCB3YXlzIHRvIGRvIHRoZSBzYW1lLCBvdGhlcnMgY2FuIGNoaW1lDQo+IGluIGFi
b3V0IHRob3NlLCBidXQgdGhpcyBpcyBob3cgSSB3b3VsZCBkbyBpdC4NCj4gDQoNCkkgd2lsbCBy
ZXdyaXRlIHRoaXMgcGFydCBieSB5b3VyIHN1Z2dlc3Rpb25zLg0KVGhhbmtzDQpQSw0KDQo=
