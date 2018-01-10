Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rtits2.realtek.com ([211.75.126.72]:33886 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965204AbeAJJjD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 10 Jan 2018 04:39:03 -0500
From: Pkshih <pkshih@realtek.com>
To: Arend van Spriel <arend.vanspriel@broadcom.com>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>
CC: "Larry.Finger@lwfinger.net" <Larry.Finger@lwfinger.net>,
        =?big5?B?svir26vF?= <yhchuang@realtek.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [PATCH 02/10] rtlwifi: fix scan channel 1 fail after IPS
Date: Wed, 10 Jan 2018 09:38:48 +0000
Message-ID: <5B2DA6FDDF928F4E855344EE0A5C39D13BE66622@RTITMBSV07.realtek.com.tw> (sfid-20180110_103909_676458_10056778)
References: <20180110052002.9544-1-pkshih@realtek.com>
 <20180110052002.9544-3-pkshih@realtek.com> <5A55CB01.5040504@broadcom.com>
In-Reply-To: <5A55CB01.5040504@broadcom.com>
Content-Type: text/plain; charset="big5"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogQXJlbmQgdmFuIFNwcmll
bCBbbWFpbHRvOmFyZW5kLnZhbnNwcmllbEBicm9hZGNvbS5jb21dDQo+IFNlbnQ6IFdlZG5lc2Rh
eSwgSmFudWFyeSAxMCwgMjAxOCA0OjEzIFBNDQo+IFRvOiBQa3NoaWg7IGt2YWxvQGNvZGVhdXJv
cmEub3JnDQo+IENjOiBMYXJyeS5GaW5nZXJAbHdmaW5nZXIubmV0OyCy+Kvbq8U7IGxpbnV4LXdp
cmVsZXNzQHZnZXIua2VybmVsLm9yZw0KPiBTdWJqZWN0OiBSZTogW1BBVENIIDAyLzEwXSBydGx3
aWZpOiBmaXggc2NhbiBjaGFubmVsIDEgZmFpbCBhZnRlciBJUFMNCj4gDQo+IE9uIDEvMTAvMjAx
OCA2OjE5IEFNLCBwa3NoaWhAcmVhbHRlay5jb20gd3JvdGU6DQo+ID4gRnJvbTogUGluZy1LZSBT
aGloIDxwa3NoaWhAcmVhbHRlay5jb20+DQo+ID4NCj4gPiBJZiB0aGVyZSBpcyBubyBjb25uZWN0
aW9uLCBkcml2ZXIgd2lsbCBlbnRlciBJUFMgc3RhdGUuIE1lYW53aGlsZSwgaXQNCj4gPiBmYWls
cyB0byBzY2FuIGNoYW5uZWwgMSBieSB0aGUgY29tbWFuZCAnaXcgZGV2IHdsYW4wIHNjYW4gZnJl
cSAyNDEyJywNCj4gPiBiZWNhdXNlIGhhcmR3YXJlIGNoYW5uZWwgc2V0dGluZyBsb3NlIGFmdGVy
IElQUy4gVGh1cywgcmVzdG9yZSBjaGFubmVsDQo+ID4gc2V0dGluZyBmcm9tIGh3LT5jb25mLmNo
YW5uZWwgc2V0IGJ5IGxhc3QgcnRsX29wX2NvbmZpZygpLg0KPiA+DQo+ID4gU2lnbmVkLW9mZi1i
eTogVGltIExlZSA8dGltbGVlQHJlYWx0ZWsuY29tPg0KPiANCj4gWW91IG5lZWQgdG8gYWRkIHlv
dXIgc29iIGhlcmUgYXMgd2VsbCBhcyB5b3UgYXJlIHN1Ym1pdHRpbmcgdGhlbS4NCj4gDQoNCkkn
bGwgYWRkIGl0IGluIHYyLg0KDQo+ID4gLS0tDQo+ID4gICBkcml2ZXJzL25ldC93aXJlbGVzcy9y
ZWFsdGVrL3J0bHdpZmkvcHMuYyB8IDYgKysrKysrDQo+ID4gICAxIGZpbGUgY2hhbmdlZCwgNiBp
bnNlcnRpb25zKCspDQo+ID4NCj4gPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvd2lyZWxlc3Mv
cmVhbHRlay9ydGx3aWZpL3BzLmMgYi9kcml2ZXJzL25ldC93aXJlbGVzcy9yZWFsdGVrL3J0bHdp
ZmkvcHMuYw0KPiA+IGluZGV4IDZhNDAwODg0NWY0OS4uMGZmZTQzNzcyYzlhIDEwMDY0NA0KPiA+
IC0tLSBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL3JlYWx0ZWsvcnRsd2lmaS9wcy5jDQo+ID4gKysr
IGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvcmVhbHRlay9ydGx3aWZpL3BzLmMNCj4gPiBAQCAtNTEs
NiArNTEsMTIgQEAgYm9vbCBydGxfcHNfZW5hYmxlX25pYyhzdHJ1Y3QgaWVlZTgwMjExX2h3ICpo
dykNCj4gPiAgIAkJCSZydGxtYWMtPnJldHJ5X2xvbmcpOw0KPiA+ICAgCVJUX0NMRUFSX1BTX0xF
VkVMKHBwc2MsIFJUX1JGX09GRl9MRVZMX0hBTFRfTklDKTsNCj4gPg0KPiA+ICsJLyo8Mi4xPiBT
d2l0Y2ggQ2hhbm5lbCAmIEJhbmR3aWR0aCB0byBsYXN0IHJ0bF9vcF9jb25maWcgc2V0dGluZyov
DQo+IA0KPiBJcyB0aGlzIHR5cGUgb2YgY29tbWVudCByZWFsbHkgaGVscGZ1bD8gVG8gbWUgaXQg
c2VlbXMgdGhlIGNhbGxiYWNrDQo+IG5hbWVzIHByb3ZpZGUgZW5vdWdoIGNvbnRleHQuDQo+IA0K
DQpEbyB5b3UgbWVhbiB0aGUgIjwyLjE+IiBpc24ndCBuZWVkZWQ/IA0KVGhpcyBpcyBiZWNhdXNl
ICI8MT4sIDwyPiwgPDM+Li4uIiBleGlzdCBpbiB0aGUgZnVuY3Rpb24sIHNvDQp3ZSB3YW50IHRv
IG1ha2UgaXQgdG8gYmUgY29uc2lzdGVudC4NCg0KUEsNCg0K
