Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:19546 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752883AbdCOJyn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 15 Mar 2017 05:54:43 -0400
From: "Coelho, Luciano" <luciano.coelho@intel.com>
To: "kvalo@codeaurora.org" <kvalo@codeaurora.org>
CC: "Kaufman, Liad" <liad.kaufman@intel.com>,
        linuxwifi <linuxwifi@intel.com>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        "Berg, Johannes" <johannes.berg@intel.com>,
        "Sharon, Sara" <sara.sharon@intel.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
Subject: Re: [RESEND PATCH 4.11] iwlwifi: mvm: cleanup pending frames in DQA
 mode
Date: Wed, 15 Mar 2017 09:54:38 +0000
Message-ID: <1489571676.22435.46.camel@intel.com> (sfid-20170315_105446_942720_97AE6369)
References: <1489410030.22435.34.camel@coelho.fi>
         <20170314075035.19248-1-luca@coelho.fi> <87pohi6f5d.fsf@purkki.adurom.net>
In-Reply-To: <87pohi6f5d.fsf@purkki.adurom.net>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

T24gV2VkLCAyMDE3LTAzLTE1IGF0IDExOjUyICswMjAwLCBLYWxsZSBWYWxvIHdyb3RlOg0KPiBM
dWNhIENvZWxobyA8bHVjYUBjb2VsaG8uZmk+IHdyaXRlczoNCj4gDQo+ID4gRnJvbTogU2FyYSBT
aGFyb24gPHNhcmEuc2hhcm9uQGludGVsLmNvbT4NCj4gPiANCj4gPiBXaGVuIGEgc3RhdGlvbiBp
cyBhc2xlZXAsIHRoZSBmdyB3aWxsIHNldCBpdCBhcyAiYXNsZWVwIi4NCj4gPiBBbGwgcXVldWVz
IHRoYXQgYXJlIHVzZWQgb25seSBieSBvbmUgc3RhdGlvbiB3aWxsIGJlIHN0b3BwZWQgYnkNCj4g
PiB0aGUgZncuDQo+ID4gDQo+ID4gSW4gcHJlLURRQSBtb2RlIHRoaXMgd2FzIHJlbGV2YW50IGZv
ciBhZ2dyZWdhdGlvbiBxdWV1ZXMuIEhvd2V2ZXIsDQo+ID4gaW4gRFFBIG1vZGUgYSBxdWV1ZSBp
cyBvd25lZCBieSBvbmUgc3RhdGlvbiBvbmx5LCBzbyBhbGwgcXVldWVzDQo+ID4gd2lsbCBiZSBz
dG9wcGVkLg0KPiA+IEFzIGEgcmVzdWx0LCB3ZSBkb24ndCBleHBlY3QgdG8gZ2V0IGZpbHRlcmVk
IGZyYW1lcyBiYWNrIHRvDQo+ID4gbWFjODAyMTEgYW5kIGRvbid0IGhhdmUgdG8gbWFpbnRhaW4g
dGhlIGVudGlyZSBwZW5kaW5nX2ZyYW1lcw0KPiA+IHN0YXRlIGxvZ2ljLCB0aGUgc2FtZSB3YXkg
YXMgd2UgZG8gaW4gYWdncmVnYXRpb25zLg0KPiA+IA0KPiA+IFRoZSBjb3JyZWN0IGJlaGF2aW9y
IGlzIHRvIGFsaWduIERRQSBiZWhhdmlvciB3aXRoIHRoZSBhZ2dyZWdhdGlvbg0KPiA+IHF1ZXVl
IGJlaGF2aW91ciBwcmUtRFFBOg0KPiA+IC0gRG9uJ3QgY291bnQgcGVuZGluZyBmcmFtZXMuDQo+
ID4gLSBMZXQgbWFjODAyMTEga25vdyB3ZSBoYXZlIGZyYW1lcyBpbiB0aGVzZSBxdWV1ZXMgc28g
dGhhdCBpdCBjYW4NCj4gPiBwcm9wZXJseSBoYW5kbGUgdHJpZ2dlciBmcmFtZXMuDQo+ID4gDQo+
ID4gV2hlbiBhIHRyaWdnZXIgZnJhbWUgaXMgcmVjZWl2ZWQsIG1hYzgwMjExIHRlbGxzIHRoZSBk
cml2ZXIgdG8gc2VuZA0KPiA+IGZyYW1lcyBmcm9tIHRoZSBxdWV1ZXMgdXNpbmcgcmVsZWFzZV9i
dWZmZXJlZF9mcmFtZXMuDQo+ID4gVGhlIGRyaXZlciB3aWxsIHRlbGwgdGhlIGZ3IHRvIGxldCBm
cmFtZXMgb3V0IGV2ZW4gaWYgdGhlIHN0YXRpb24NCj4gPiBpcyBhc2xlZXAuIFRoaXMgaXMgZG9u
ZSBieSBpd2xfbXZtX3N0YV9tb2RpZnlfc2xlZXBfdHhfY291bnQuDQo+ID4gDQo+ID4gUmVwb3J0
ZWQtYW5kLXRlc3RlZC1ieTogSmVucyBBeGJvZSA8YXhib2VAa2VybmVsLmRrPg0KPiA+IFJlcG9y
dGVkLWJ5OiBMaW51cyBUb3J2YWxkcyA8dG9ydmFsZHNAbGludXgtZm91bmRhdGlvbi5vcmc+DQo+
ID4gU2lnbmVkLW9mZi1ieTogU2FyYSBTaGFyb24gPHNhcmEuc2hhcm9uQGludGVsLmNvbT4NCj4g
PiBTaWduZWQtb2ZmLWJ5OiBMdWNhIENvZWxobyA8bHVjaWFuby5jb2VsaG9AaW50ZWwuY29tPg0K
PiA+IC0tLQ0KPiA+IA0KPiA+IEp1c3QgcmVzZW5kaW5nIHdpdGggcmVwb3J0ZWQgYW5kIHRlc3Rl
ZCBieSB0YWdzLg0KPiANCj4gU29ycnksIG15IHVzdWFsIHJhbnQgZm9sbG93cyA6KSBCdXQgbmV2
ZXIgZXZlciB1c2UgIlJFU0VORCIsIGl0J3Mgc28NCj4gbXVjaCBzaW1wbGVyIHRvIGhhdmUgdjIs
IHYzIGFuZCBzbyBvbiB0byBmaWd1cmUgb3V0IHdoYXQncyB0aGUgKGxhdGVzdCkNCj4gdmVyc2lv
biBJIHNob3VsZCB0YWtlLg0KDQpPa2F5LCBzb3JyeS4gIEkganVzdCB1c2VkIFJFU0VORCwgYmVj
YXVzZSBJIGRpZG4ndCBjaGFuZ2UgdGhlIHBhdGNoDQppdHNlbGYsIGJ1dCBvbmx5IGFkZGVkIHRo
ZSByZXBvcnRlZC1ieSB0YWdzLi4uDQoNCi0tDQpMdWNhLg==
