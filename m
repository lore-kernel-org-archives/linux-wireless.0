Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rtits2.realtek.com ([211.75.126.72]:53880 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932606AbeEaCNs (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 30 May 2018 22:13:48 -0400
From: Pkshih <pkshih@realtek.com>
To: "kvalo@codeaurora.org" <kvalo@codeaurora.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "Larry.Finger@lwfinger.net" <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH 13/14] rtlwifi: access skb->data to get C2H data by macro
Date: Thu, 31 May 2018 02:13:35 +0000
Message-ID: <1527732798.8418.7.camel@realtek.com> (sfid-20180531_041354_739139_E49CE01B)
References: <20180518093007.23594-1-pkshih@realtek.com>
         <20180518093007.23594-14-pkshih@realtek.com>
         <87po1fhwfd.fsf@purkki.adurom.net>
In-Reply-To: <87po1fhwfd.fsf@purkki.adurom.net>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

T24gVHVlLCAyMDE4LTA1LTI5IGF0IDA4OjE4ICswMzAwLCBLYWxsZSBWYWxvIHdyb3RlOg0KPiA8
cGtzaGloQHJlYWx0ZWsuY29tPiB3cml0ZXM6DQo+wqANCj4gPiBGcm9tOiBQaW5nLUtlIFNoaWgg
PHBrc2hpaEByZWFsdGVrLmNvbT4NCj4gPg0KPiA+IFRoZSBmb3JtYXQgb2YgQzJIIGRhdGEgaXMg
SUQoMSBieXRlKSArIExlbmd0aCgxIGJ5dGUpICsgdmFsdWUsIGFuZCBpdCBpcw0KPiA+IG1vcmUg
cmVhZGFibGUgdG8gdXNlIG1hY3JvcyB0byBhY2Nlc3MgQzJIIGRhdGEuDQo+ID4NCj4gPiBTaWdu
ZWQtb2ZmLWJ5OiBQaW5nLUtlIFNoaWggPHBrc2hpaEByZWFsdGVrLmNvbT4NCj7CoA0KPiBbLi4u
XQ0KPsKgDQo+ID4gLS0tIGEvZHJpdmVycy9uZXQvd2lyZWxlc3MvcmVhbHRlay9ydGx3aWZpL3dp
ZmkuaA0KPiA+ICsrKyBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL3JlYWx0ZWsvcnRsd2lmaS93aWZp
LmgNCj4gPiBAQCAtMTc3LDYgKzE3NywxMSBAQCBlbnVtIHJ0bF9jMmhfZXZ0X3YyIHsNCj4gPsKg
wqAJQzJIX1YyX0NDWF9SUFQgPSAweDBGLA0KPiA+wqDCoH07DQo+ID7CoMKgDQo+ID4gKyNkZWZp
bmUgR0VUX0MySF9DTURfSUQoYzJoKQkoe3U4ICpfX2MyaCA9IGMyaDsgX19jMmhbMF07IH0pDQo+
ID4gKyNkZWZpbmUgR0VUX0MySF9TRVEoYzJoKQkoe3U4ICpfX2MyaCA9IGMyaDsgX19jMmhbMV07
IH0pDQo+ID4gKyNkZWZpbmUgQzJIX0RBVEFfT0ZGU0VUCQkyDQo+ID4gKyNkZWZpbmUgR0VUX0My
SF9EQVRBX1BUUihjMmgpCSh7dTggKl9fYzJoID0gYzJoOyAmX19jMmhbQzJIX0RBVEFfT0ZGU0VU
XTsgfSkNCj7CoA0KPiBUaGVzZSBtYWNyb3MgYXJlIG5vdCByZWFsbHkgcHJldHR5LCBhIHByb3Bl
ciBzdGF0aWMgaW5saW5lIGZ1bmN0aW9uDQo+IHdvdWxkIGJlIGEgbXVjaCBiZXR0ZXIgY2hvaXNl
LiBCdXQgSSdtIHBsYW5uaW5nIHRvIGFwcGx5IHRoaXMgcGF0Y2gNCj4gYW55d2F5LCBJIGRvbid0
IHRoaW5rIGl0J3MgYSBibG9ja2VyIGJ1dCBhIGdvb2QgaWRlYSB0byBjbGVhbnVwIGxhdGVyLg0K
PsKgDQo+IEFuZCBydGx3aWZpIHJlYWxseSBzaG91bGQgZ2V0IGF3YXkgd2l0aCB0aGlzIGZvb1sw
XSBhbmQgZm9vWzFdIHN0eWxlIG9mDQo+IGJ1ZmZlcnMgYW5kIHN3aXRjaCB0byBwcm9wZXIgc3Ry
dWN0cyAoZm9vLT5iYXIgYW5kIGZvby0+a29vKS4NCg0KVGhhbmtzIGZvciB5b3VyIHJldmlldyBh
bmQgc3VnZ2VzdGlvbi4NCg0KQmVjYXVzZSBDMkggZGF0YSBpcyBsaXR0bGUgZW5kaWFuIG9yZGVy
LCB0aGUgc3RydWN0IHdpbGwgbG9vayBsaWtlDQpzdHJ1Y3QgZm9vIHsNCiNpZmRlZsKgX19MSVRU
TEVfRU5ESUFODQoJdTggYmFyOjQ7DQoJdTgga29vOjQ7DQojZWxzZQ0KCXU4IGtvbzo0Ow0KCXU4
IGJhcjo0Ow0KI2VuZGlmDQp9DQoNCklzIHRoaXMgYSBsaW51eCBjb252ZW50aW9uPw0KDQpSZWdh
cmRzDQpQSw0KDQo=
