Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:3774 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750799AbcLPFkv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 16 Dec 2016 00:40:51 -0500
From: "Thiagarajan, Vasanthakumar" <vthiagar@qti.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>,
        "nbd@nbd.name" <nbd@nbd.name>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [RFC 2/3] mac80211: Implement data xmit for 802.11 encap offload
Date: Fri, 16 Dec 2016 05:37:39 +0000
Message-ID: <58537DA3.1090901@qti.qualcomm.com> (sfid-20161216_064105_828116_CE57E77D)
References: <1481781608-5181-1-git-send-email-vthiagar@qti.qualcomm.com>
         <1481781608-5181-3-git-send-email-vthiagar@qti.qualcomm.com>
         <1481794142.31776.5.camel@sipsolutions.net>
         <58528607.7090101@qti.qualcomm.com>
         <85c98160-3ee9-07db-cb4c-9e300f0ba798@nbd.name>
 <1481809984.2582.5.camel@sipsolutions.net>
In-Reply-To: <1481809984.2582.5.camel@sipsolutions.net>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

T24gVGh1cnNkYXkgMTUgRGVjZW1iZXIgMjAxNiAwNzoyMyBQTSwgSm9oYW5uZXMgQmVyZyB3cm90
ZToNCj4NCj4+PiBJIGFncmVlLiBEeW5hbWljIHN3aXRjaCBwYXJ0IGlzIGJ1Z2d5LCB3ZSBjYW4g
c3RhcnQgd2l0aCBub3QNCj4+PiBhbGxvd2luZyBpbnRlcmZhY2VzIHJlc3VsdGluZyBpbiBkeW5h
bWljIHN3aXRjaC4NCj4+DQo+PiBEb2VzIHRoaXMgbWVhbiB0aGF0IHdoZW4gYnJpbmdpbmcgdXAg
bXVsdGlwbGUgaW50ZXJmYWNlcywgdXNlcnMgd291bGQNCj4+IG5lZWQgdG8gZmlndXJlIG91dCB0
aGUgJ21hZ2ljJyBvcmRlciB0aGF0IHdvcmtzPw0KPg0KPiBJIHRoaW5rIHdlIG5lZWQgdG8gdGFs
ayBhYm91dCBoYXJkd2FyZSBjYXBhYmlsaXRpZXMgYXQgdGhpcyBwb2ludC4NCg0KUUNBOTg4WCBk
b2VzIG5vdCBoYXZlIGNhcGFiaWxpdHkgdG8gY29uZmlndXJlIHZpZiBzcGVjaWZpYyBkZWNhcCBt
b2RlLiBFbmNhcCBtb2RlDQppcyBjb25maWd1cmFibGUgcGVyIHBhY2tldCBmb3IgYWxsIHRoZSBh
dGgxMGsgYmFzZWQgY2hpcHMgc28gdGhpcyBwYXJ0IHNob3VsZCBiZQ0KZmluZSB0byBzdXBwb3J0
IHBlciB2aWYgY29uZmlndXJhdGlvbi4gTmV3ZXIgUUNBIGNoaXBzIGxpa2UgUUNBOTk4NCwgUUNB
NDAxOSwgUUNBOTg4OA0KYW5kIFFDQTk5WDAgc3VwcG9ydHMgZGVjYXAgbW9kZSBjb25maWd1cmF0
aW9uIHBlciB2aWYuIFRvIHJlZHVjZSB0aGUgY29tcGxleGl0eSwNCndlIGNhbiBwcm9iYWJseSBt
YWtlIHBlciB2aWYgZW5jYXAvZGVjYXAgY29uZmlndXJhdGlvbiBtYW5kYXRvcnkgdG8gZW5hYmxl
IGV0aGVybmV0DQpmcmFtZSBmb3JtYXQsIG5vdCBzdXJlIGhvdyB0aGlzIHdpbGwgd29yayB3aXRo
IG5vbi1RQ0EgY2FwYWJsZSBoYXJkd2FyZS4NCg0KPg0KPiBJIHdhcyBhc3N1bWluZyB0aGF0IGl0
IHdvdWxkIGFjdHVhbGx5IGJlIHBvc3NpYmxlIHRvIHJ1biB0d28gaW50ZXJmYWNlcw0KPiB3aXRo
IGRpZmZlcmVudCBwYXRocyBoZXJlIGNvbmN1cnJlbnRseSAtIGlzIHRoYXQgbm90IHRydWU/IElm
IHRoYXQncw0KPiBub3QgdHJ1ZSwgdGhlbiB3ZSBhYnNvbHV0ZWx5IF9uZWVkXyBkeW5hbWljIHN3
aXRjaGluZywgSSBhZ3JlZSB3aXRoDQo+IEZlbGl4LCBidXQgdGhlbiB3ZSBoYXZlIGEgcHJldHR5
IGJpZyBjb21wbGljYXRpb24gdG8gZmlndXJlIG91dC4gQnV0IHdlDQo+IGNhbid0IGxldCB0aGlz
IG9wdGltaXNhdGlvbiBhZmZlY3QgdXNlciBleHBlcmllbmNlLg0KDQpTdXJlLg0KDQpWYXNhbnRo
