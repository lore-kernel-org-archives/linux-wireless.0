Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rtits2.realtek.com ([211.75.126.72]:40632 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752739AbeDECHY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 4 Apr 2018 22:07:24 -0400
From: Pkshih <pkshih@realtek.com>
To: =?utf-8?B?6I6K5b2l5a6j?= <yhchuang@realtek.com>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        "gustavo@embeddedor.com" <gustavo@embeddedor.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [rtlwifi-btcoex] Suspicious code in halbtc8821a1ant driver
Date: Thu, 5 Apr 2018 02:06:56 +0000
Message-ID: <1522894016.1824.2.camel@realtek.com> (sfid-20180405_040740_019948_2981CAED)
References: <20180405012540.GA24241@embeddedor.com>
In-Reply-To: <20180405012540.GA24241@embeddedor.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

T24gVGh1LCAyMDE4LTA0LTA1IGF0IDAxOjI1ICswMDAwLCBHdXN0YXZvIEEuIFIuIFNpbHZhIHdy
b3RlOg0KPiBIaSBhbGwsDQo+IA0KPiBXaGlsZSBkb2luZyBzb21lIHN0YXRpYyBhbmFseXNpcyBJ
IGNhbWUgYWNyb3NzIHRoZSBmb2xsb3dpbmcgcGllY2Ugb2YgY29kZSBhdA0KPiBkcml2ZXJzL25l
dC93aXJlbGVzcy9yZWFsdGVrL3J0bHdpZmkvYnRjb2V4aXN0L2hhbGJ0Yzg4MjFhMWFudC5jOjE1
ODE6DQo+IA0KPiAxNTgxIHN0YXRpYyB2b2lkIGJ0Yzg4MjFhMWFudF9hY3RfYnRfc2NvX2hpZF9v
bmx5X2J1c3koc3RydWN0IGJ0Y19jb2V4aXN0ICpidGNvZXhpc3QsDQo+IDE1ODLCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqB1OCB3aWZpX3N0YXR1cykNCj4gMTU4
MyB7DQo+IDE1ODTCoMKgwqDCoMKgwqDCoMKgwqAvKiB0ZG1hIGFuZCBjb2V4IHRhYmxlICovDQo+
IDE1ODXCoMKgwqDCoMKgwqDCoMKgwqBidGM4ODIxYTFhbnRfcHNfdGRtYShidGNvZXhpc3QsIE5P
Uk1BTF9FWEVDLCB0cnVlLCA1KTsNCj4gMTU4NsKgDQo+IDE1ODfCoMKgwqDCoMKgwqDCoMKgwqBp
ZiAoQlRfODgyMUFfMUFOVF9XSUZJX1NUQVRVU19OT05fQ09OTkVDVEVEX0FTU09fQVVUSF9TQ0FO
ID09DQo+IDE1ODjCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHdpZmlfc3RhdHVzKQ0KPiAxNTg5
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGJ0Yzg4MjFhMWFudF9jb2V4X3RhYmxl
X3dpdGhfdHlwZShidGNvZXhpc3QsIE5PUk1BTF9FWEVDLCAxKTsNCj4gMTU5MMKgwqDCoMKgwqDC
oMKgwqDCoGVsc2UNCj4gMTU5McKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBidGM4
ODIxYTFhbnRfY29leF90YWJsZV93aXRoX3R5cGUoYnRjb2V4aXN0LCBOT1JNQUxfRVhFQywgMSk7
DQo+IDE1OTIgfQ0KPiANCj4gVGhlIGlzc3VlIGhlcmUgaXMgdGhhdCB0aGUgY29kZSBmb3IgYm90
aCBicmFuY2hlcyBvZiB0aGUgaWYtZWxzZSBzdGF0ZW1lbnQgaXMgaWRlbnRpY2FsLg0KPiANCj4g
VGhlIGlmLWVsc2Ugd2FzIGludHJvZHVjZWQgYSB5ZWFyIGFnbyBpbiB0aGlzIGNvbW1pdCBjNjgy
MTYxM2U2NTMNCj4gDQo+IEkgd29uZGVyIGlmIGFuIGFyZ3VtZW50IHNob3VsZCBiZSBjaGFuZ2Vk
IGluIGFueSBvZiB0aGUgY2FsbHMgdG8NCj4gYnRjODgyMWExYW50X2NvZXhfdGFibGVfd2l0aF90
eXBlPw0KPiANCj4gDQoNCkl0IGxvb2tzIHdlaXJkLiBTaW5jZSB3ZSdyZSBpbiBzcHJpbmcgdmFj
YXRpb24sIEknbGwgY2hlY2sgbXkgY29sbGVhZ3VlIG5leHQgTW9uZGF5Lg0KDQpQSw0KDQo=
