Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:64488 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751376AbdGSGXz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 19 Jul 2017 02:23:55 -0400
From: "Coelho, Luciano" <luciano.coelho@intel.com>
To: "dan.carpenter@oracle.com" <dan.carpenter@oracle.com>,
        "Dreyfuss, Haim" <haim.dreyfuss@intel.com>,
        "Berg, Johannes" <johannes.berg@intel.com>
CC: "Kaufman, Liad" <liad.kaufman@intel.com>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        linuxwifi <linuxwifi@intel.com>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        "Dvir, Sharon" <sharon.dvir@intel.com>,
        "Sharon, Sara" <sara.sharon@intel.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
Subject: Re: [PATCH] iwlwifi: pcie: Fix error code in iwl_trans_pcie_alloc()
Date: Wed, 19 Jul 2017 06:23:38 +0000
Message-ID: <1500445417.22048.254.camel@intel.com> (sfid-20170719_082404_488825_5F34677A)
References: <20170712075300.sbd2vlwqf4rriale@mwanda>
In-Reply-To: <20170712075300.sbd2vlwqf4rriale@mwanda>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

SGkgRGFuLA0KDQpPbiBXZWQsIDIwMTctMDctMTIgYXQgMTA6NTMgKzAzMDAsIERhbiBDYXJwZW50
ZXIgd3JvdGU6DQo+IFdlIGFjY2lkZW50YWxseSBmb3Jnb3QgdG8gcHJvcG9nYXRlIHRoZSBlcnJv
ciBjb2RlIG9uIHRoaXMgcGF0aC4gIEl0DQo+IG1lYW5zIHdlIHJldHVybiBFUlJfUFRSKDApIHdo
aWNoIGlzIE5VTEwgYW5kIGl0IHJlc3VsdHMgaW4gYSBOVUxMDQo+IGRlcmVmZXJlbmNlIGluIHRo
ZSBjYWxsZXIuDQo+IA0KPiBGaXhlczogMmU1ZDRhOGY2MWRjICgiaXdsd2lmaTogcGNpZTogQWRk
IG5ldyBjb25maWd1cmF0aW9uIHRvIGVuYWJsZSBNU0lYIikNCj4gU2lnbmVkLW9mZi1ieTogRGFu
IENhcnBlbnRlciA8ZGFuLmNhcnBlbnRlckBvcmFjbGUuY29tPg0KPiANCj4gZGlmZiAtLWdpdCBh
L2RyaXZlcnMvbmV0L3dpcmVsZXNzL2ludGVsL2l3bHdpZmkvcGNpZS90cmFucy5jIGIvZHJpdmVy
cy9uZXQvd2lyZWxlc3MvaW50ZWwvaXdsd2lmaS9wY2llL3RyYW5zLmMNCj4gaW5kZXggOTJiM2E1
NWQwZmJjLi5mOTVlZWM1MjUwOGUgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvbmV0L3dpcmVsZXNz
L2ludGVsL2l3bHdpZmkvcGNpZS90cmFucy5jDQo+ICsrKyBiL2RyaXZlcnMvbmV0L3dpcmVsZXNz
L2ludGVsL2l3bHdpZmkvcGNpZS90cmFucy5jDQo+IEBAIC0zMTUwLDcgKzMxNTAsOCBAQCBzdHJ1
Y3QgaXdsX3RyYW5zICppd2xfdHJhbnNfcGNpZV9hbGxvYyhzdHJ1Y3QgcGNpX2RldiAqcGRldiwN
Cj4gIAlpbml0X3dhaXRxdWV1ZV9oZWFkKCZ0cmFuc19wY2llLT5kMGkzX3dhaXRxKTsNCj4gIA0K
PiAgCWlmICh0cmFuc19wY2llLT5tc2l4X2VuYWJsZWQpIHsNCj4gLQkJaWYgKGl3bF9wY2llX2lu
aXRfbXNpeF9oYW5kbGVyKHBkZXYsIHRyYW5zX3BjaWUpKQ0KPiArCQlyZXQgPSBpd2xfcGNpZV9p
bml0X21zaXhfaGFuZGxlcihwZGV2LCB0cmFuc19wY2llKTsNCj4gKwkJaWYgKHJldCkNCj4gIAkJ
CWdvdG8gb3V0X25vX3BjaTsNCj4gIAkgfSBlbHNlIHsNCj4gIAkJcmV0ID0gaXdsX3BjaWVfYWxs
b2NfaWN0KHRyYW5zKTsNCg0KWW91IGFscmVhZHkgc2VudCBhbiBlcXVpdmFsZW50IHBhdGNoOg0K
DQpodHRwczovL3BhdGNod29yay5rZXJuZWwub3JnL3BhdGNoLzk4MjU4OTUvDQoNCkFuZCBJJ3Zl
IGFscmVhZHkgc2VudCBpdCBvdXQgdG8gYmUgYXBwbGllZCBpbiA0LjEzLXJjKi4gIEknbGwgc2Vu
ZCBhDQpwdWxsLXJlcSBmb3IgLWZpeGVzIGxhdGVyIHRoaXMgd2Vlay4NCg0KVGhhbmtzIGFueXdh
eS4gOikNCg0KLS0NCkNoZWVycywNCkx1Y2Eu
