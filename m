Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rtits2.realtek.com ([211.75.126.72]:46813 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754631AbeARJFw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 18 Jan 2018 04:05:52 -0500
From: Pkshih <pkshih@realtek.com>
To: "arend.vanspriel@broadcom.com" <arend.vanspriel@broadcom.com>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        "johannes@sipsolutions.net" <johannes@sipsolutions.net>
CC: =?utf-8?B?6I6K5b2l5a6j?= <yhchuang@realtek.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "Larry.Finger@lwfinger.net" <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH v2 05/10] rtlwifi: enable mac80211 fast-tx support
Date: Thu, 18 Jan 2018 09:05:30 +0000
Message-ID: <1516266330.3990.6.camel@realtek.com> (sfid-20180118_100603_223703_9D434BFD)
References: <20180111070932.9929-1-pkshih@realtek.com>
         <20180111070932.9929-6-pkshih@realtek.com>
         <871sip24fc.fsf@purkki.adurom.net> <5A5E5C99.5020607@broadcom.com>
         (sfid-20180116_211216_753091_08EEF52B)
 <1516141444.410.52.camel@sipsolutions.net>
In-Reply-To: <1516141444.410.52.camel@sipsolutions.net>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

T24gVHVlLCAyMDE4LTAxLTE2IGF0IDIzOjI0ICswMTAwLCBKb2hhbm5lcyBCZXJnIHdyb3RlOg0K
PiBPbiBUdWUsIDIwMTgtMDEtMTYgYXQgMjE6MTIgKzAxMDAsIEFyZW5kIHZhbiBTcHJpZWwgd3Jv
dGU6DQo+ID4gDQo+ID4gDQo+ID4gV2hlbiBJIHNhdyB0aGlzIGZseWluZyBieSBJIGhhZCB0aGUg
c2FtZSBmZWVsaW5nLiBUaGlzIGlzIGNsZWFybHkNCj4gPiBub3TCoA0KPiA+IGhvdyBpdCB3YXMg
aW50ZW5kZWQgYWx0aG91Z2ggeW91IGNvdWxkIGludGVycHJldCB0aGUgY29tbWVudHMgb2YNCj4g
PiB0aGXCoA0KPiA+IC5zZXRfZnJhZ190aHJlc2hvbGQoKSBjYWxsYmFjayBhbmQgSUVFRTgwMjEx
X0hXX1NVUFBPUlRTX1RYX0ZSQUcuwqANCj4gPiBIb3dldmVyLCB0aGUgZnJhZ21lbnRhdGlvbiB0
aHJlc2hvbGQgaXMgYSB1c2VyLWNvbmZpZ3VyYWJsZSBzdGFja8KgDQo+ID4gcGFyYW1ldGVyIGFz
IHBlciB0aGUgc3RhbmRhcmQuIFRoaXMgcGF0Y2ggZWZmZWN0aXZlbHkga2lsbCB0aGF0DQo+ID4g
b3B0aW9uwqANCj4gPiBmb3IgdGhlIHVzZXIgYWx0aG91Z2ggdGhlcmUgbWF5IGJlIFJGIGNvbmRp
dGlvbnMgaW4gd2hpY2gNCj4gPiBmcmFnbWVudGF0aW9uwqANCj4gPiBjYW4gaGVscC4gSGF2aW5n
IHRoZSB1c2VyIGNvbmZpZ3VyZSBhIGZyYWdtZW50YXRpb24gdGhyZXNob2xkIG9mDQo+ID4gMjM0
NsKgDQo+ID4gYWxzbyBkaXNhYmxlcyBmcmFnbWVudGF0aW9uIGFuZCBhbGxvd3MgbWFjODAyMTEg
dG8gdXNlIGNhY2hlZA0KPiA+IGZhc3RwYXRoLg0KPiA+IA0KPiDCoMKgwqDCoMKgwqDCoMKgLyog
ZmFzdC14bWl0IGRvZXNuJ3QgaGFuZGxlIGZyYWdtZW50YXRpb24gYXQgYWxsICovDQo+IMKgwqDC
oMKgwqDCoMKgwqBpZiAobG9jYWwtPmh3LndpcGh5LT5mcmFnX3RocmVzaG9sZCAhPSAodTMyKS0x
ICYmDQo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCFpZWVlODAyMTFfaHdfY2hlY2soJmxvY2Fs
LT5odywgU1VQUE9SVFNfVFhfRlJBRykpDQo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgZ290byBvdXQ7DQo+IA0KDQpUaGFuayB5b3UgZm9yIHRoaXMgcG9pbnQuIFRoaXMgY29tbWl0
IGhhcyBub3QgdG8gc2V0IFNVUFBPUlRTX1RYX0ZSQUcswqANCmJ1dCBvbmx5IHNldCBTVVBQT1JU
X0ZBU1RfWE1JVC4gSSdsbCB0ZXN0IGFuZCBwcmVwYXJlIGZvciBuZXh0wqANCnN1Ym1pc3Npb24u
DQoNClBLDQoNCg==
