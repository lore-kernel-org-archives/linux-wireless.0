Return-Path: <SRS0=MtVb=O3=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A03DEC43387
	for <linux-wireless@archiver.kernel.org>; Tue, 18 Dec 2018 13:40:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7868021873
	for <linux-wireless@archiver.kernel.org>; Tue, 18 Dec 2018 13:40:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726556AbeLRNkZ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 18 Dec 2018 08:40:25 -0500
Received: from mga02.intel.com ([134.134.136.20]:41273 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726446AbeLRNkZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 18 Dec 2018 08:40:25 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 18 Dec 2018 05:40:24 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,368,1539673200"; 
   d="scan'208";a="108305788"
Received: from fmsmsx108.amr.corp.intel.com ([10.18.124.206])
  by fmsmga007.fm.intel.com with ESMTP; 18 Dec 2018 05:40:24 -0800
Received: from fmsmsx125.amr.corp.intel.com (10.18.125.40) by
 FMSMSX108.amr.corp.intel.com (10.18.124.206) with Microsoft SMTP Server (TLS)
 id 14.3.408.0; Tue, 18 Dec 2018 05:40:24 -0800
Received: from lcsmsx154.ger.corp.intel.com (10.186.165.229) by
 FMSMSX125.amr.corp.intel.com (10.18.125.40) with Microsoft SMTP Server (TLS)
 id 14.3.408.0; Tue, 18 Dec 2018 05:40:24 -0800
Received: from hasmsx111.ger.corp.intel.com ([169.254.5.58]) by
 LCSMSX154.ger.corp.intel.com ([169.254.7.82]) with mapi id 14.03.0415.000;
 Tue, 18 Dec 2018 15:40:21 +0200
From:   "Otcheretianski, Andrei" <andrei.otcheretianski@intel.com>
To:     Johannes Berg <johannes@sipsolutions.net>,
        Srinivas Dasari <dasaris@codeaurora.org>
CC:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [PATCH] cfg80211: Authentication offload to user space in AP
 mode
Thread-Topic: [PATCH] cfg80211: Authentication offload to user space in AP
 mode
Thread-Index: AQHUltWJ56SD8pWgiU22drtVmLatnKWEfymw
Date:   Tue, 18 Dec 2018 13:40:21 +0000
Message-ID: <B2CD83211F5FDD478D7EFFF030D107EDCD031EAB@HASMSX111.ger.corp.intel.com>
References: <1544779909-27758-1-git-send-email-dasaris@codeaurora.org>
         (sfid-20181214_103219_686121_BC072990)
 <dd3263b2b3f0850a26b316f9e8cb0cba81dc97c7.camel@sipsolutions.net>
In-Reply-To: <dd3263b2b3f0850a26b316f9e8cb0cba81dc97c7.camel@sipsolutions.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.0.400.15
dlp-reaction: no-action
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiZTI2Mjk1OWEtNjkyZi00YTM4LTlmNWEtNTJiYjNmMmJiNmQ2IiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiSytBdDdNb0Q3eU5qSUlvUjZFdW45TG10Z3RORVcrTzFSWE4zT3AwWGs1Z0c5UVNseGt1MGU5R0JDZzg1cjFtcSJ9
x-ctpclassification: CTP_NT
x-originating-ip: [10.255.207.227]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

PiBTbywgaW50ZXJlc3RpbmcgLSBBbmRyZWkgYWxzbyBhZGRlZCB0aGUgUE1LSUQgYnV0IGFsc28g
dGhlIFBNSyBoZXJlLCBpbiBhDQo+IHNlcGFyYXRlIHBhdGNoOg0KPiBodHRwczovL3BhdGNod29y
ay5rZXJuZWwub3JnL3BhdGNoLzEwNzMyMDkzLw0KDQpZZWFoLCBQTUsgaXMgbmVlZGVkIGZvciB0
aGUgZGV2aWNlcyB0aGF0IG9mZmxvYWQgNHdheSBoYW5kc2hha2UuDQo+PlsuLi5dDQo+ID4gLQlp
ZiAoIWluZm8tPmF0dHJzW05MODAyMTFfQVRUUl9TU0lEXSkNCj4gPiArCWlmICghaW5mby0+YXR0
cnNbTkw4MDIxMV9BVFRSX1NTSURdICYmDQo+ID4gKwkgICAgZGV2LT5pZWVlODAyMTFfcHRyLT5p
ZnR5cGUgIT0gTkw4MDIxMV9JRlRZUEVfQVAgJiYNCj4gPiArCSAgICBkZXYtPmllZWU4MDIxMV9w
dHItPmlmdHlwZSAhPSBOTDgwMjExX0lGVFlQRV9BUF9WTEFOICYmDQo+ID4gKwkgICAgZGV2LT5p
ZWVlODAyMTFfcHRyLT5pZnR5cGUgIT0gTkw4MDIxMV9JRlRZUEVfUDJQX0dPKQ0KPiA+ICAJCXJl
dHVybiAtRUlOVkFMOw0KPiANCj4gSG0uIGRvIHdlIHJlYWxseSBleHBlY3QgdGhpcyBvbiBBUF9W
TEFOPw0KDQpBY3R1YWxseSBJJ20gbm90IHN1cmUgYWJvdXQgR08gbmVpdGhlci4gUDJQIGRvZXNu
J3QgdXNlIFNBRSBldGMuLg0KDQpBbmRyZWkNCj4gDQo+IGpvaGFubmVzDQoNCg==
