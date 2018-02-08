Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rtits2.realtek.com ([211.75.126.72]:60923 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750806AbeBHBHA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 7 Feb 2018 20:07:00 -0500
From: Pkshih <pkshih@realtek.com>
To: "mka@chromium.org" <mka@chromium.org>,
        "Larry.Finger@lwfinger.net" <Larry.Finger@lwfinger.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "craigb@chromium.org" <craigb@chromium.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "groeck@chromium.org" <groeck@chromium.org>,
        "teravest@chromium.org" <teravest@chromium.org>
Subject: Re: [PATCH] rtlwifi: rtl8192cu: Remove variable self-assignment in rf.c
Date: Thu, 8 Feb 2018 01:06:43 +0000
Message-ID: <1518052003.2680.1.camel@realtek.com> (sfid-20180208_020720_577770_5C5C5ED3)
References: <20180207202634.98937-1-mka@chromium.org>
         <947198f5-23eb-afbc-7979-fbc38b6a1a37@lwfinger.net>
         <20180207205136.GB116483@google.com>
In-Reply-To: <20180207205136.GB116483@google.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

T24gV2VkLCAyMDE4LTAyLTA3IGF0IDEyOjUxIC0wODAwLCBNYXR0aGlhcyBLYWVobGNrZSB3cm90
ZToNCj4gRWwgV2VkLCBGZWIgMDcsIDIwMTggYXQgMDI6MzU6NTlQTSAtMDYwMCBMYXJyeSBGaW5n
ZXIgaGEgZGl0Og0KPiANCj4gPiBPbiAwMi8wNy8yMDE4IDAyOjI2IFBNLCBNYXR0aGlhcyBLYWVo
bGNrZSB3cm90ZToNCj4gPiA+IEluIF9ydGw5MmNfZ2V0X3R4cG93ZXJfd3JpdGV2YWxfYnlfcmVn
dWxhdG9yeSgpIHRoZSB2YXJpYWJsZSB3cml0ZVZhbA0KPiA+ID4gaXMgYXNzaWduZWQgdG8gaXRz
ZWxmIGluIGFuIGlmIC4uLiBlbHNlIHN0YXRlbWVudCwgYXBwYXJlbnRseSBvbmx5IHRvDQo+ID4g
PiBkb2N1bWVudCB0aGF0IHRoZSBicmFuY2ggY29uZGl0aW9uIGlzIGhhbmRsZWQgYW5kIHRoYXQg
YSBwcmV2aW91c2x5IHJlYWQNCj4gPiA+IHZhbHVlIHNob3VsZCBiZSByZXR1cm5lZCB1bm1vZGlm
aWVkLiBUaGUgc2VsZi1hc3NpZ25tZW50IGNhdXNlcyBjbGFuZyB0bw0KPiA+ID4gcmFpc2UgdGhl
IGZvbGxvd2luZyB3YXJuaW5nOg0KPiA+ID7CoA0KPiA+ID4gZHJpdmVycy9uZXQvd2lyZWxlc3Mv
cmVhbHRlay9ydGx3aWZpL3J0bDgxOTJjdS9yZi5jOjMwNDoxMzoNCj4gPiA+wqDCoMKgwqBlcnJv
cjogZXhwbGljaXRseSBhc3NpZ25pbmcgdmFsdWUgb2YgdmFyaWFibGUgb2YgdHlwZSAndTMyJw0K
PiA+ID7CoMKgwqDCoMKgwqAoYWthICd1bnNpZ25lZCBpbnQnKSB0byBpdHNlbGYgWy1XZXJyb3Is
LVdzZWxmLWFzc2lnbl0NCj4gPiA+wqDCoMKgwqB3cml0ZVZhbCA9IHdyaXRlVmFsOw0KPiA+ID7C
oA0KPiA+ID4gUmVwbGFjZSB0aGUgc2VsZi1hc3NpZ25tZW50IHdpdGggYSBzZW1pY29sb24sIHdo
aWNoIHN0aWxsIHNlcnZlcyB0bw0KPiA+ID4gZG9jdW1lbnQgdGhlICdoYW5kbGluZycgb2YgdGhl
IGJyYW5jaCBjb25kaXRpb24uDQo+ID4gPsKgDQo+ID4gPiBTaWduZWQtb2ZmLWJ5OiBNYXR0aGlh
cyBLYWVobGNrZSA8bWthQGNocm9taXVtLm9yZz4NCj4gPiA+IC0tLQ0KPiA+ID7CoMKgwqBkcml2
ZXJzL25ldC93aXJlbGVzcy9yZWFsdGVrL3J0bHdpZmkvcnRsODE5MmN1L3JmLmMgfCAyICstDQo+
ID4gPsKgwqDCoDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKSwgMSBkZWxldGlvbigtKQ0K
PiA+ID7CoA0KPiA+ID4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL3JlYWx0ZWsv
cnRsd2lmaS9ydGw4MTkyY3UvcmYuYw0KPiBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL3JlYWx0ZWsv
cnRsd2lmaS9ydGw4MTkyY3UvcmYuYw0KPiA+ID4gaW5kZXggOWNmZjZiYzQwNDljLi40ZGI5MjQ5
NmMxMjIgMTAwNjQ0DQo+ID4gPiAtLS0gYS9kcml2ZXJzL25ldC93aXJlbGVzcy9yZWFsdGVrL3J0
bHdpZmkvcnRsODE5MmN1L3JmLmMNCj4gPiA+ICsrKyBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL3Jl
YWx0ZWsvcnRsd2lmaS9ydGw4MTkyY3UvcmYuYw0KPiA+ID4gQEAgLTMwMSw3ICszMDEsNyBAQCBz
dGF0aWMgdm9pZCBfcnRsOTJjX2dldF90eHBvd2VyX3dyaXRldmFsX2J5X3JlZ3VsYXRvcnkoc3Ry
dWN0IGllZWU4MDIxMV9odw0KPiAqaHcsDQo+ID4gPsKgwqDCoAkJCXdyaXRlVmFsID0gd3JpdGVW
YWwgLSAweDA2MDYwNjA2Ow0KPiA+ID7CoMKgwqAJCWVsc2UgaWYgKHJ0bHByaXYtPmRtLmR5bmFt
aWNfdHhoaWdocG93ZXJfbHZsID09DQo+ID4gPsKgwqDCoAkJCcKgVFhISUdIUFdSTEVWRUxfQlQy
KQ0KPiA+ID4gLQkJCXdyaXRlVmFsID0gd3JpdGVWYWw7DQo+ID4gPiArCQkJOw0KPiA+ID7CoMKg
wqAJCSoocF9vdXR3cml0ZXZhbCArIHJmKSA9IHdyaXRlVmFsOw0KPiA+ID7CoMKgwqAJfQ0KPiA+
ID7CoMKgwqB9DQo+ID4gPsKgDQo+ID7CoA0KPiA+IEFzIHRoZSBicmFuY2ggY29uZGl0aW9uIGRv
ZXMgbm90aGluZywgd2h5IG5vdCByZW1vdmUgaXQgYW5kIHNhdmUgdGhlDQo+ID4gY29tcGlsZXIn
cyBvcHRpbWl6ZXIgYSBiaXQgb2Ygd29yaz8gVGhlIGNvZGUgbG9va3Mgc3RyYW5nZSwgYnV0IGl0
IG1hdGNoZXMNCj4gPiB0aGUgcmVzdCBvZiBSZWFsdGVrJ3MgVVNCIGRyaXZlcnMuDQoNCkFncmVl
IExhcnJ5J3MgY29tbWVudC4NCg0KPiANCj4gU3VyZSwgSSBhbSBoYXBweSB0byBjaGFuZ2UgaXQg
dG8gd2hhdGV2ZXIgdGhlIGF1dGhvcnMvbWFpbnRhaW5lcnMgcHJlZmVyLg0KPiANCj4gSSdsbCB3
YWl0IGEgYml0IGJlZm9yZSByZXNwaW5uaW5nIGZvciBpZiBvdGhlcnMgZmVlbCBzdHJvbmdseSBh
Ym91dA0KPiBrZWVwaW5nIHRoZSBicmFuY2guDQo+IA0KPiAtLS0tLS1QbGVhc2UgY29uc2lkZXIg
dGhlIGVudmlyb25tZW50IGJlZm9yZSBwcmludGluZyB0aGlzIGUtbWFpbC4=
