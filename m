Return-Path: <SRS0=nRo4=MP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B619C00449
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Oct 2018 09:53:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0A1722098A
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Oct 2018 09:53:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0A1722098A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727040AbeJCQkS (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 3 Oct 2018 12:40:18 -0400
Received: from mga12.intel.com ([192.55.52.136]:60810 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725976AbeJCQkS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 3 Oct 2018 12:40:18 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 03 Oct 2018 02:52:38 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.54,335,1534834800"; 
   d="scan'208";a="268060754"
Received: from fmsmsx107.amr.corp.intel.com ([10.18.124.205])
  by fmsmga005.fm.intel.com with ESMTP; 03 Oct 2018 02:52:18 -0700
Received: from fmsmsx158.amr.corp.intel.com (10.18.116.75) by
 fmsmsx107.amr.corp.intel.com (10.18.124.205) with Microsoft SMTP Server (TLS)
 id 14.3.319.2; Wed, 3 Oct 2018 02:52:18 -0700
Received: from HASMSX109.ger.corp.intel.com (10.184.198.21) by
 fmsmsx158.amr.corp.intel.com (10.18.116.75) with Microsoft SMTP Server (TLS)
 id 14.3.319.2; Wed, 3 Oct 2018 02:52:18 -0700
Received: from hasmsx111.ger.corp.intel.com ([169.254.5.194]) by
 hasmsx109.ger.corp.intel.com ([169.254.3.74]) with mapi id 14.03.0319.002;
 Wed, 3 Oct 2018 12:50:58 +0300
From:   "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
To:     Kai Heng Feng <kai.heng.feng@canonical.com>,
        Kalle Valo <kvalo@codeaurora.org>
CC:     LKML <linux-kernel@vger.kernel.org>,
        "Berg, Johannes" <johannes.berg@intel.com>,
        "Coelho, Luciano" <luciano.coelho@intel.com>,
        linuxwifi <linuxwifi@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [RESEND] [PATCH 3/3] iwlwifi: Load firmware exclusively for
 Intel WiFi
Thread-Topic: [RESEND] [PATCH 3/3] iwlwifi: Load firmware exclusively for
 Intel WiFi
Thread-Index: AQHUWvtvTLUUJbuyfESwvLxugqx0LqUNRppQ
Date:   Wed, 3 Oct 2018 09:50:58 +0000
Message-ID: <0BA3FCBA62E2DC44AF3030971E174FB301336D868D@HASMSX111.ger.corp.intel.com>
References: <20181003073556.28154-1-kai.heng.feng@canonical.com>
 <20181003073556.28154-3-kai.heng.feng@canonical.com>
 <87y3bfiees.fsf@kamboji.qca.qualcomm.com>
 <265BAF93-4BFF-4850-92F7-80AC39496473@canonical.com>
In-Reply-To: <265BAF93-4BFF-4850-92F7-80AC39496473@canonical.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiZTA2NDljYjYtOWUyNC00ZTRjLTk2YTctM2Y0NGUzN2FhN2M4IiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoibEViM2N2RHY2ODA2bEgySjZHSURPbUNyZXJITW9nYTNZazhEUkxZWnhvXC9CbExlUm1EMXhyQzN0T0lMcGxEdysifQ==
x-ctpclassification: CTP_NT
dlp-product: dlpe-windows
dlp-version: 11.0.400.15
dlp-reaction: no-action
x-originating-ip: [10.12.124.193]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

PiANCj4gPiBPbiBPY3QgMywgMjAxOCwgYXQgNToxMCBQTSwgS2FsbGUgVmFsbyA8a3ZhbG9AY29k
ZWF1cm9yYS5vcmc+IHdyb3RlOg0KPiA+DQo+ID4gS2FpLUhlbmcgRmVuZyA8a2FpLmhlbmcuZmVu
Z0BjYW5vbmljYWwuY29tPiB3cml0ZXM6DQo+ID4NCj4gPj4gVG8gYXZvaWQgdGhlIGZpcm13YXJl
IGxvYWRpbmcgcmFjZSBiZXR3ZWVuIEJsdWV0b290aCBhbmQgV2lGaSBvbg0KPiA+PiBJbnRlbCA4
MjYwLCBsb2FkIGZpcm13YXJlIGV4Y2x1c2l2ZWx5IHdoZW4gQlRfSU5URUwgaXMgZW5hYmxlZC4N
Cj4gPj4NCj4gPj4gU2lnbmVkLW9mZi1ieTogS2FpLUhlbmcgRmVuZyA8a2FpLmhlbmcuZmVuZ0Bj
YW5vbmljYWwuY29tPg0KPiA+DQo+ID4gU3RpbGwgdGhlIGNvbW1pdCBsb2cgdGVsbHMgbm90aGlu
ZyBhYm91dCB0aGUgYWN0dWFsIHByb2JsZW0gd2hpY2gNCj4gPiBtYWtlcyByZXZpZXcgaW1wb3Nz
aWJsZS4NCj4gDQo+IFNvcnJ5IGZvciB0aGF0LiBUaGUgZmlyc3QgdHdvIHBhdGNoZXMgWzFdIG9u
bHkgc2VuZHMgdG8gbGludXgtYmx1ZXRvb3RoIGFuZA0KPiBMTUtMLg0KPiANCj4gSSBkb27igJl0
IGtub3cgd2hhdCByZWFsbHkgaGFwcGVuZWQgYXQgaGFyZHdhcmUvZmlybXdhcmUgbGV2ZWwsIGJ1
dCBtYWtpbmcNCj4gYnR1c2IgYW5kIGl3bHdpZmkgbG9hZCBmaXJtd2FyZSBzZXF1ZW50aWFsbHkg
Y2FuIHdvcmthcm91bmQgdGhlIGlzc3VlLg0KPiANCj4gTWF0dCBDaGVuIG1heSBiZSBhYmxlIHRv
IGV4cGxhaW4gdGhpcyBpc3N1ZSB3aXRoIG1vcmUgZGV0YWlsLg0KPiANCj4gWzFdIGh0dHBzOi8v
bGttbC5vcmcvbGttbC8yMDE4LzEwLzMvMzIyDQo+DQoNCkkganVzdCByZWFkIHRoZSBjb2RlIG9m
IHRoaXMgcGF0Y2ggYW5kIEkgZG9uJ3QgcXVpdGUgdW5kZXJzdGFuZC4NCllvdSBoYXZlIGEgZnVu
Y3Rpb24gdGhhdCBpcyBkZWNsYXJlZCBhcyBhIG5vbi1pbmxpbmUgZnVuY3Rpb24gaW4gdHdvIGRp
ZmZlcmVudCBoZWFkZXIgZmlsZXM/DQpidGludGVsX2Zpcm13YXJlX2xvY2sgaXMgZGVjbGFyZWQg
aGVyZToNCg0KLS0tIC9kZXYvbnVsbA0KKysrIGIvaW5jbHVkZS9saW51eC9pbnRlbC13aWZpLWJ0
LmgNCkBAIC0wLDAgKzEsOCBAQA0KKy8qIFNQRFgtTGljZW5zZS1JZGVudGlmaWVyOiBHUEwtMi4w
ICovDQorI2lmbmRlZiBfX0lOVEVMX1dJRklfQlRfSF9fDQorI2RlZmluZSBfX0lOVEVMX1dJRklf
QlRfSF9fDQorDQordm9pZCBidGludGVsX2Zpcm13YXJlX2xvY2sodm9pZCk7DQoNCkFuZCAuLi4N
Cg0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvYmx1ZXRvb3RoL2J0aW50ZWwuaCBiL2RyaXZlcnMvYmx1
ZXRvb3RoL2J0aW50ZWwuaA0KaW5kZXggNDFjNjQyY2M1MjNmLi4xMzczZmZjMmI1NzUgMTAwNjQ0
DQotLS0gYS9kcml2ZXJzL2JsdWV0b290aC9idGludGVsLmgNCisrKyBiL2RyaXZlcnMvYmx1ZXRv
b3RoL2J0aW50ZWwuaA0KQEAgLTEwMiw2ICsxMDIsOCBAQCBpbnQgYnRpbnRlbF9yZWFkX2Jvb3Rf
cGFyYW1zKHN0cnVjdCBoY2lfZGV2ICpoZGV2LA0KIAkJCSAgICAgc3RydWN0IGludGVsX2Jvb3Rf
cGFyYW1zICpwYXJhbXMpOw0KIGludCBidGludGVsX2Rvd25sb2FkX2Zpcm13YXJlKHN0cnVjdCBo
Y2lfZGV2ICpkZXYsIGNvbnN0IHN0cnVjdCBmaXJtd2FyZSAqZncsDQogCQkJICAgICAgdTMyICpi
b290X3BhcmFtKTsNCit2b2lkIGJ0aW50ZWxfZmlybXdhcmVfbG9jayh2b2lkKTsNCg0KDQpUaGlz
IGNhbid0IGJlIHJpZ2h0Lg0K
