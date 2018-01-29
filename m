Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rtits2.realtek.com ([211.75.126.72]:54659 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751514AbeA2DBV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 28 Jan 2018 22:01:21 -0500
From: Pkshih <pkshih@realtek.com>
To: "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        "Larry.Finger@lwfinger.net" <Larry.Finger@lwfinger.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 06/10] rtlwifi: Fix VHT NSS in RC
Date: Mon, 29 Jan 2018 03:01:10 +0000
Message-ID: <1517194870.2618.5.camel@realtek.com> (sfid-20180129_040204_230847_9EE52B6B)
References: <20180126074645.27201-1-pkshih@realtek.com>
         <20180126074645.27201-7-pkshih@realtek.com>
         <940c2aa9-67c3-7058-7e25-665a56eb4b1b@lwfinger.net>
In-Reply-To: <940c2aa9-67c3-7058-7e25-665a56eb4b1b@lwfinger.net>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

T24gU2F0LCAyMDE4LTAxLTI3IGF0IDEzOjM5IC0wNjAwLCBMYXJyeSBGaW5nZXIgd3JvdGU6DQo+
IE9uIDAxLzI2LzIwMTggMDE6NDYgQU0sIHBrc2hpaEByZWFsdGVrLmNvbSB3cm90ZToNCj4gPiBG
cm9tOiBQaW5nLUtlIFNoaWggPHBrc2hpaEByZWFsdGVrLmNvbT4NCj4gPsKgDQo+ID4gTlNTIGlz
IGEgYXJndW1lbnQgb2YgaGlnaGVzdCByYXRlIGluIFJDLCBhbmQgaXQgb2NjdXBpZXMgYml0IDQt
NyBzbyB1c2UNCj4gPiBpZWVlODAyMTFfcmF0ZV9zZXRfdmh0KCkgdG8gZmlsbCB0aGUgdmFsdWVz
LiBTaW5jZSBpdCBnb3QgY29ycmVjdCByYXRlDQo+ID4gaW5kZXgsIHdlIGRvbid0IG5lZWQgdG8g
Y2hlY2sgY2hpcHMgdG8gYXNzaWduIE5TUyBpbiBzZXQgZnVuY3Rpb24gYW55bW9yZS4NCj4gPsKg
DQo+ID4gU2lnbmVkLW9mZi1ieTogUGluZy1LZSBTaGloIDxwa3NoaWhAcmVhbHRlay5jb20+DQo+
ID4gLS0tDQo+ID7CoMKgwqBkcml2ZXJzL25ldC93aXJlbGVzcy9yZWFsdGVrL3J0bHdpZmkvcmMu
YyB8IDQ5ICsrKysrKysrKysrKysrKysrKysrKysrKysNCj4gLS0tLS0tDQo+ID7CoMKgwqAxIGZp
bGUgY2hhbmdlZCwgNDAgaW5zZXJ0aW9ucygrKSwgOSBkZWxldGlvbnMoLSkNCj4gPsKgDQo+ID4g
ZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL3JlYWx0ZWsvcnRsd2lmaS9yYy5jDQo+
IGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvcmVhbHRlay9ydGx3aWZpL3JjLmMNCj4gPiBpbmRleCBk
MWNiN2Q0MDU2MTguLjM5NmJlZDhkM2Q1MSAxMDA2NDQNCj4gPiAtLS0gYS9kcml2ZXJzL25ldC93
aXJlbGVzcy9yZWFsdGVrL3J0bHdpZmkvcmMuYw0KPiA+ICsrKyBiL2RyaXZlcnMvbmV0L3dpcmVs
ZXNzL3JlYWx0ZWsvcnRsd2lmaS9yYy5jDQo+ID4gQEAgLTQyLDYgKzQyLDE3IEBAIHN0YXRpYyB1
OCBfcnRsX3JjX2dldF9oaWdoZXN0X3JpeChzdHJ1Y3QgcnRsX3ByaXYNCj4gKnJ0bHByaXYsDQo+
ID7CoMKgwqAJc3RydWN0IHJ0bF9waHkgKnJ0bHBoeSA9ICYocnRscHJpdi0+cGh5KTsNCj4gPsKg
wqDCoAlzdHJ1Y3QgcnRsX3N0YV9pbmZvICpzdGFfZW50cnkgPSBOVUxMOw0KPiA+wqDCoMKgCXUx
NiB3aXJlbGVzc19tb2RlID0gMDsNCj4gPiArCXU4IG5zczsNCj4gPiArCXN0cnVjdCBpZWVlODAy
MTFfdHhfcmF0ZSByYXRlOw0KPiA+ICsNCj4gPiArCWlmIChnZXRfcmZfdHlwZShydGxwaHkpID49
IFJGXzRUNFIpDQo+ID4gKwkJbnNzID0gNDsNCj4gPiArCWVsc2UgaWYgKGdldF9yZl90eXBlKHJ0
bHBoeSkgPj0gUkZfM1QzUikNCj4gPiArCQluc3MgPSAzOw0KPiA+ICsJZWxzZSBpZiAoZ2V0X3Jm
X3R5cGUocnRscGh5KSA+PSBSRl8yVDJSKQ0KPiA+ICsJCW5zcyA9IDI7DQo+ID4gKwllbHNlDQo+
ID4gKwkJbnNzID0gMTsNCj7CoA0KPiBBcyBhIGdlbmVyYWwgcnVsZSwgSSB0aGluayB0aGF0IGlm
IC4uLiBlbHNlIGlmIC4uLiBlbHNlIGlmIC4uLiBlbHNlIC4uLsKgDQo+IGNvbnN0cnVjdGlvbnMg
c2hvdWxkIGJlIGNoYW5nZWQgdG8gc3dpdGNoIHN0YXRlbWVudHMuIFRoaXMgb25lIGlzIHNpbXBs
ZQ0KPiBlbm91Z2jCoA0KPiB0aGF0IHRoZXJlIHdpbGwgYmUgbm8gY29tcGxpY2F0aW9ucywgYnV0
IGtlZXAgdGhpcyBpbiBtaW5kIGluIHRoZSBmdXR1cmUuDQo+wqANCg0KVGhlIGNvZGUgYWxzbyBj
b25mdXNlZCBtZSwgc28gSSdsbCBjaGFuZ2UgdGhlbSB0byAnc3dpdGNoLi4uY2FzZScgaW4gdjIu
DQoNClBLDQoNCg==
