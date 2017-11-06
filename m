Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out.qualcomm.com ([129.46.98.28]:53006 "EHLO
        alexa-out.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753724AbdKFRoI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 6 Nov 2017 12:44:08 -0500
From: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "rmanohar@codeaurora.org" <rmanohar@codeaurora.org>
Subject: RE: [PATCH] mac80211: Update last_ack status for all except probing
 frames
Date: Mon, 6 Nov 2017 17:44:07 +0000
Message-ID: <8bb232d231884f9595c81f945a5eef4f@NALASEXR01H.na.qualcomm.com> (sfid-20171106_184412_363975_74A5498B)
References: <1509409746-26592-1-git-send-email-rmanohar@qti.qualcomm.com>
 <1509964164.2669.0.camel@sipsolutions.net>
In-Reply-To: <1509964164.2669.0.camel@sipsolutions.net>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

PiBPbiBNb24sIDIwMTctMTAtMzAgYXQgMTc6MjkgLTA3MDAsIFJhamt1bWFyIE1hbm9oYXJhbiB3
cm90ZToNCj4gPiBVcGRhdGUgbGFzdF9hY2sgc3RhdHVzIGZvciBhbGwgZXhjZXB0IHN0YXRpb24g
cHJvYmluZyBmcmFtZXMgKGkuZSBudWxsDQo+ID4gZGF0YSkuIE90aGVyd2lzZSB0aGUgc3RhdGlv
biBpbmFjdGl2aXR5IGR1cmF0aW9uIGlzIGNsZWFyZWQgd2hlbmV2ZXINCj4gPiBBUCBpcyBjaGVj
a2luZyBwcmVzZW5jZSBvZiBpZGxlIHN0YXRpb25zIGJ5IHNlbmRpbmcgbnVsbCBkYXRhIGZyYW1l
DQo+ID4gZm9yIGV2ZXJ5IGluYWN0aXZlIHRocmVzaG9sZCAoYXBfbWF4X2luYWN0aXZpdHkpLg0K
PiANCj4gWW91IG1ha2UgaXQgc291bmQgbGlrZSB0aGlzIGlzIGEgcHJvYmxlbSwgYnV0IGRvbid0
IGV4cGxhaW4gd2h5IGl0IHdvdWxkIGJlPyBJDQo+IGRvbid0IHJlYWxseSBzZWUgaXQgYW55d2F5
Lg0KPiANCkZvciBzdGVlcmluZyBhbiBpZGxlIHN0YXRpb24gZnJvbSBvbmUgQlNTIHRvIGFub3Ro
ZXIsIHRoZSBzdGVlcmluZyBhcHBsaWNhdGlvbg0KaGFzIHRvIGtub3cgdGhlIGFjdHVhbCBzdGF0
aW9uIGlkbGUgcGVyaW9kLiBCdXQgaWYgdGhlIGlkbGUgcGVyaW9kIGlzIGNsZWFyZWQgYnkNCmFw
X21heF9pbmFjdGl2aXR5LCB0aGUgc3RlZXJpbmcgYXBwbGljYXRpb24gY2Fubm90IHN0ZWVyIHRo
ZSBzdGF0aW9uIGV2ZW4gdGhvdWdoDQp0aGUgc3RhdGlvbiBpcyBub3Qgc2VuZGluZyBvciByZWNl
aXZpbmcgYW55IGRhdGEgb3IgbWdtdC4gZnJhbWUuDQoNClRob3VnaCBrZWVwaW5nIGxvbmdlciBp
ZGxlIHRocmVzaG9sZCAoYXBfbWF4X2luYWN0aXZpdHkpIHRoYW4gc3RlZXJpbmcgYXBwbGljYXRp
b24NCmxpbWl0IG1heSBoZWxwIHRvIGlkZW50aWZ5IGlkbGUgc3RhdGlvbiwgaXQgd2lsbCBkaWZm
ZXIgcmVtb3ZpbmcgdGhlIHN0YXRpb25zIHRoYXQgbGVmdCBCU1MuDQoNCi1SYWprdW1hcg0K
