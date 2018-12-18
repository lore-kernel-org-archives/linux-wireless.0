Return-Path: <SRS0=MtVb=O3=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B915C43387
	for <linux-wireless@archiver.kernel.org>; Tue, 18 Dec 2018 00:55:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4244A2080D
	for <linux-wireless@archiver.kernel.org>; Tue, 18 Dec 2018 00:55:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726312AbeLRAzc (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 17 Dec 2018 19:55:32 -0500
Received: from mga09.intel.com ([134.134.136.24]:12008 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726282AbeLRAzc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 17 Dec 2018 19:55:32 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 Dec 2018 16:55:31 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,367,1539673200"; 
   d="scan'208";a="102296711"
Received: from irsmsx108.ger.corp.intel.com ([163.33.3.3])
  by orsmga008.jf.intel.com with ESMTP; 17 Dec 2018 16:55:30 -0800
Received: from irsmsx102.ger.corp.intel.com ([169.254.2.29]) by
 IRSMSX108.ger.corp.intel.com ([169.254.11.26]) with mapi id 14.03.0415.000;
 Tue, 18 Dec 2018 00:55:29 +0000
From:   "Coelho, Luciano" <luciano.coelho@intel.com>
To:     "egrumbach@gmail.com" <egrumbach@gmail.com>
CC:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
        "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
Subject: Re: [PATCH 12/24] mac80211: ignore NullFunc frames in the duplicate
 detection
Thread-Topic: [PATCH 12/24] mac80211: ignore NullFunc frames in the
 duplicate detection
Thread-Index: AQHUlFc8SzKZFbo0bEyghA9LsB/AO6WAD2OAgAOgpQA=
Date:   Tue, 18 Dec 2018 00:55:28 +0000
Message-ID: <43d750de71e30e5df06d826331857739624a0dec.camel@intel.com>
References: <20181215090325.31604-1-luca@coelho.fi>
         <20181215090325.31604-13-luca@coelho.fi>
         <CANUX_P2En=4v24qpOvxtRSn-V8f851-mW0o4pK+-VKrprwf6_w@mail.gmail.com>
In-Reply-To: <CANUX_P2En=4v24qpOvxtRSn-V8f851-mW0o4pK+-VKrprwf6_w@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.251.147.75]
Content-Type: text/plain; charset="utf-8"
Content-ID: <AC438E59C1B05346ADCB7ABE93A0BAFE@intel.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

T24gU2F0LCAyMDE4LTEyLTE1IGF0IDE5OjMxICswMjAwLCBFbW1hbnVlbCBHcnVtYmFjaCB3cm90
ZToNCj4gT24gU2F0LCBEZWMgMTUsIDIwMTggYXQgMTE6MjAgQU0gTHVjYSBDb2VsaG8gPGx1Y2FA
Y29lbGhvLmZpPiB3cm90ZToNCj4gPiBGcm9tOiBFbW1hbnVlbCBHcnVtYmFjaCA8ZW1tYW51ZWwu
Z3J1bWJhY2hAaW50ZWwuY29tPg0KPiA+IA0KPiA+IE51bGxGdW5jIHBhY2tldHMgc2hvdWxkIG5l
dmVyIGJlIGR1cGxpY2F0ZSBqdXN0IGxpa2UNCj4gPiBRb1MtTnVsbEZ1bmMgcGFja2V0cy4NCj4g
PiANCj4gPiBXZSBzYXcgYSBjbGllbnQgdGhhdCBlbnRlcnMgLyBleGl0cyBwb3dlciBzYXZlIHdp
dGgNCj4gPiBOdWxsRnVuYyBmcmFtZXMgKGFuZCBub3Qgd2l0aCBRb1MtTnVsbEZ1bmMpIGRlc3Bp
dGUgdGhlDQo+ID4gZmFjdCB0aGF0IHRoZSBhc3NvY2lhdGlvbiBzdXBwb3J0cyBIVC4NCj4gPiBU
aGlzIHNwZWNpZmljIGNsaWVudCBhbHNvIHJlLXVzZXMgYSBub24temVybyBzZXF1ZW5jZSBudW1i
ZXINCj4gPiBmb3IgZGlmZmVyZW50IE51bGxGdW5jIGZyYW1lcy4NCj4gPiBBdCBzb21lIHBvaW50
LCB0aGUgY2xpZW50IGhhZCB0byBzZW5kIGEgcmV0cmFuc21pc3Npb24gb2YNCj4gPiB0aGUgTnVs
bEZ1bmMgZnJhbWUgYW5kIHdlIGRyb3BwZWQgaXQsIGxlYWRpbmcgdG8gYQ0KPiA+IG1pc2FsaWdu
bWVudCBpbiB0aGUgcG93ZXIgc2F2ZSBzdGF0ZS4NCj4gPiBGaXggdGhpcyBieSBuZXZlciBjb25z
aWRlciBhIE51bGxGdW5jIGZyYW1lIGFzIGR1cGxpY2F0ZSwNCj4gPiBqdXN0IGxpa2Ugd2UgZG8g
Zm9yIFFvUyBOdWxsRnVuYyBmcmFtZXMuDQo+ID4gDQo+ID4gVGhpcyBmaXhlcyBodHRwczovL2J1
Z3ppbGxhLmtlcm5lbC5vcmcvc2hvd19idWcuY2dpP2lkPTIwMTQ0OQ0KPiA+IA0KPiANCj4gVGhp
cyBoYXMgYWxyZWFkeSBiZWVuIHNlbnQsIGl0IGlzIGluIG5ldC5naXQgYWxyZWFkeSA6KQ0KDQpP
b3BzLCBzb3JyeSwgbXkgYmFkLiAgSSBvYnZpb3VzbHkgZm9yZ290IHRvIGxvb2sgaXQgdXAgYmVm
b3JlIHNlbmRpbmcuDQoNCi0tDQpDaGVlcnMsDQpMdWNhLg0K
