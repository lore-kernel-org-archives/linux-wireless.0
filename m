Return-Path: <SRS0=ZTn4=SK=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD718C10F13
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Apr 2019 10:20:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 98B9D20833
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Apr 2019 10:20:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=qti.qualcomm.com header.i=@qti.qualcomm.com header.b="Y65Z/bts"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726119AbfDHKUD (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 8 Apr 2019 06:20:03 -0400
Received: from alexa-out-tai-02.qualcomm.com ([103.229.16.227]:49040 "EHLO
        alexa-out-tai-02.qualcomm.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725857AbfDHKUD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 8 Apr 2019 06:20:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=qti.qualcomm.com; i=@qti.qualcomm.com; q=dns/txt;
  s=qcdkim; t=1554718801; x=1586254801;
  h=from:to:cc:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version:subject;
  bh=rvWuDjoL7k8UF13sbdUywrFVSHLQE6F3SoShyz50NoI=;
  b=Y65Z/bts+JZDGyh7fx2QzMF2Wm4kDK80aeiBZT+cgypJ2Rujt5WG9R78
   OOWgxr7dO8wRdoNPz9BMbPMBx/h4RLNTOyMPnrj9FoDt/lo2RLxw3WMy9
   /qcWQGf4g3C+8xKwiyPpJ53UEhZ5MuiO30otfmWX3WVypfIq/u8aXwJob
   0=;
X-IronPort-AV: E=Sophos;i="5.60,324,1549900800"; 
   d="scan'208";a="2154146"
Subject: RE: [PATCH] ath10k: Remove ATH10K_STATE_RESTARTED in simulate fw crash
Thread-Topic: [PATCH] ath10k: Remove ATH10K_STATE_RESTARTED in simulate fw crash
Received: from ironmsg02-tai.qualcomm.com ([10.249.140.7])
  by alexa-out-tai-02.qualcomm.com with ESMTP; 08 Apr 2019 18:20:00 +0800
X-IronPort-AV: E=McAfee;i="5900,7806,9220"; a="26558402"
Received: from aptaiexm02a.ap.qualcomm.com ([10.249.150.11])
  by ironmsg02-tai.qualcomm.com with ESMTP/TLS/AES256-SHA; 08 Apr 2019 18:20:00 +0800
Received: from aptaiexm02f.ap.qualcomm.com (10.249.150.16) by
 aptaiexm02a.ap.qualcomm.com (10.249.150.11) with Microsoft SMTP Server (TLS)
 id 15.0.1395.4; Mon, 8 Apr 2019 18:19:58 +0800
Received: from aptaiexm02f.ap.qualcomm.com ([fe80::4152:1436:e436:faa1]) by
 aptaiexm02f.ap.qualcomm.com ([fe80::4152:1436:e436:faa1%19]) with mapi id
 15.00.1395.000; Mon, 8 Apr 2019 18:19:58 +0800
From:   Wen Gong <wgong@qti.qualcomm.com>
To:     =?utf-8?B?TWljaGHFgiBLYXppb3I=?= <kazikcz@gmail.com>
CC:     Wen Gong <wgong@codeaurora.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Thread-Index: AQHUpmQJz5XVQIMvMUei5K703fyTnaYnTmZwgAtNzTA=
Date:   Mon, 8 Apr 2019 10:19:58 +0000
Message-ID: <54b4dab1191d41b8b329f3ceb7017626@aptaiexm02f.ap.qualcomm.com>
References: <1542163824-795-1-git-send-email-wgong@codeaurora.org>
 <CABvG-CWg-VXAtoN8HZumW-ZdP6dX9cO_8fWJ58C22kD2yDcXdw@mail.gmail.com>
 <195f3bb0c88c43a6b1ca0ad336f947c0@aptaiexm02f.ap.qualcomm.com>
 <CABvG-CWAfB8jjCDW4ggjJ8_YC++CjttJOMOt4s24F3mymvNR9A@mail.gmail.com>
 <02904ba8682441e1a89668c1345cbec9@aptaiexm02f.ap.qualcomm.com>
In-Reply-To: <02904ba8682441e1a89668c1345cbec9@aptaiexm02f.ap.qualcomm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.249.136.10]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

DQoNCg0KDQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IFdlbiBHb25nDQo+
IFNlbnQ6IE1vbmRheSwgQXByaWwgMSwgMjAxOSAyOjExIFBNDQo+IFRvOiAnTWljaGHFgiBLYXpp
b3InIDxrYXppa2N6QGdtYWlsLmNvbT4NCj4gQ2M6IFdlbiBHb25nIDx3Z29uZ0Bjb2RlYXVyb3Jh
Lm9yZz47IGxpbnV4LXdpcmVsZXNzIDxsaW51eC0NCj4gd2lyZWxlc3NAdmdlci5rZXJuZWwub3Jn
PjsgYXRoMTBrQGxpc3RzLmluZnJhZGVhZC5vcmcNCj4gU3ViamVjdDogUkU6IFtFWFRdIFJlOiBb
UEFUQ0hdIGF0aDEwazogUmVtb3ZlIEFUSDEwS19TVEFURV9SRVNUQVJURUQgaW4NCj4gc2ltdWxh
dGUgZncgY3Jhc2gNCj4gDQo+ID4NCj4gPiBJZiBpdCdzIHN0aWxsIGJvdGhlcmluZyB5b3UgdGhl
biBwbGVhc2UgY29uc2lkZXIgYSBjcmFzaCBjb3VudGVyDQo+ID4gdGhyZXNob2xkIHNvIHRoYXQs
IGUuZy4gYWZ0ZXIgNSBjcmFzaC13aGlsZS1yZXN0YXJ0aW5nIGl0J3MgZ29pbmcgdG8NCj4gPiBn
aXZlIHVwLiBIb3dldmVyIEkgZG91YnQgaXQncyB3b3J0aCB0aGUgZWZmb3J0LiBNeSBleHBlcmll
bmNlIHRlbGxzIG1lDQo+ID4gZmlybXdhcmUgY3Jhc2hlcyBkdXJpbmcgcmVjb3ZlcnkgYXJlIHJh
cmVseSwgaWYgYXQgYWxsLCB0cmFuc2llbnQuDQo+ID4NCj4gPiBUaGUgc2ltdWxhdGVkIGZ3IGNy
YXNoIGlzIG5vdCByZXByZXNlbnRhdGl2ZSBoZXJlLiBJdCdzIGEgbWVyZSB0b29sIHRvDQo+ID4g
dGVzdCBkcml2ZXIgY29kZS4NCj4gPg0KPiBIaSBNaWNoYWwsDQo+IFRoZXJlIGhhdmUgYSBzdHJl
c3MgdGVzdCBjYXNlIGZvciB0aGUgc2ltdWxhdGUgZncgY3Jhc2gsIGl0IHdpbGwgc2ltdWxhdGUg
ZncNCj4gY3Jhc2gNCj4gaW4gYSB2ZXJ5IHNob3J0IHRpbWUgZm9yIGVhY2ggdGVzdCwgdGhpcyB3
aWxsIHRyaWdnZXIgdGhlIHN0cmVzcyB0ZXN0IGZhaWwuDQo+IFRoZSBzaW11bGF0ZSBmdyBjcmFz
aCBwcm9jZXNzIHNob3VsZCBub3QgYmUgcnVuIHBhcmFsbGVsLCBhZnRlciB0aGlzIHBhdGNoLCB0
aGUNCj4gU3RyZXNzIHRlc3QgY2FzZSB3aWxsIHBhc3MuDQo+ID4NCg0KSGkgTWljaGHFgiwNCkRv
IHlvdSBoYXZlIHNvbWUgbmV3IGNvbW1lbnRzPw0KDQo+ID4gTWljaGHFgg0K
