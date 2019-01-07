Return-Path: <SRS0=TVdy=PP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2398C43387
	for <linux-wireless@archiver.kernel.org>; Mon,  7 Jan 2019 07:22:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 581B420675
	for <linux-wireless@archiver.kernel.org>; Mon,  7 Jan 2019 07:22:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=qti.qualcomm.com header.i=@qti.qualcomm.com header.b="nQRl9gpm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726441AbfAGHW1 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 7 Jan 2019 02:22:27 -0500
Received: from alexa-out-tai-01.qualcomm.com ([103.229.16.226]:21254 "EHLO
        alexa-out-tai-01.qualcomm.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726257AbfAGHW1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 7 Jan 2019 02:22:27 -0500
X-Greylist: delayed 374 seconds by postgrey-1.27 at vger.kernel.org; Mon, 07 Jan 2019 02:22:25 EST
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=qti.qualcomm.com; i=@qti.qualcomm.com; q=dns/txt;
  s=qcdkim; t=1546845745; x=1578381745;
  h=from:to:cc:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version:subject;
  bh=7+Ct2ujG38cYtRhsA8MeZmVlwmdEwKmBzg6rvJ8l/kI=;
  b=nQRl9gpm51hjbOlt+yLYBwR+m1W39aB7R2OCknPXoi2LBlmC9jfxhQnx
   1SLJ66u+pfr/fUh3fnA1MlwfKEUwkFiHeoo9lntyai5pWMTm3xM23A0yY
   791msboCjb+ErnKOPBTr4yx8V6cOXd/f0hJU5FgMdqT2zdEqTwQL3LAzN
   k=;
X-IronPort-AV: E=Sophos;i="5.56,450,1539619200"; 
   d="scan'208";a="1745853"
Subject: RE: [PATCH] ath10k: Remove ATH10K_STATE_RESTARTED in simulate fw crash
Thread-Topic: [PATCH] ath10k: Remove ATH10K_STATE_RESTARTED in simulate fw crash
Received: from ironmsg03-tai.qualcomm.com ([10.249.140.8])
  by alexa-out-tai-01.qualcomm.com with ESMTP; 07 Jan 2019 15:16:10 +0800
X-IronPort-AV: E=McAfee;i="5900,7806,9128"; a="21602778"
Received: from aptaiexm02e.ap.qualcomm.com ([10.249.150.15])
  by ironmsg03-tai.qualcomm.com with ESMTP/TLS/AES256-SHA; 07 Jan 2019 15:16:10 +0800
Received: from aptaiexm02f.ap.qualcomm.com (10.249.150.16) by
 aptaiexm02e.ap.qualcomm.com (10.249.150.15) with Microsoft SMTP Server (TLS)
 id 15.0.1395.4; Mon, 7 Jan 2019 15:16:08 +0800
Received: from aptaiexm02f.ap.qualcomm.com ([fe80::4152:1436:e436:faa1]) by
 aptaiexm02f.ap.qualcomm.com ([fe80::4152:1436:e436:faa1%19]) with mapi id
 15.00.1395.000; Mon, 7 Jan 2019 15:16:08 +0800
From:   Wen Gong <wgong@qti.qualcomm.com>
To:     =?utf-8?B?TWljaGHFgiBLYXppb3I=?= <kazikcz@gmail.com>,
        Wen Gong <wgong@codeaurora.org>
CC:     linux-wireless <linux-wireless@vger.kernel.org>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Thread-Index: AQHUe+6WsGTuUx3Y8EqejUiIIhZOXKWjuVBQ
Date:   Mon, 7 Jan 2019 07:16:08 +0000
Message-ID: <195f3bb0c88c43a6b1ca0ad336f947c0@aptaiexm02f.ap.qualcomm.com>
References: <1542163824-795-1-git-send-email-wgong@codeaurora.org>
 <CABvG-CWg-VXAtoN8HZumW-ZdP6dX9cO_8fWJ58C22kD2yDcXdw@mail.gmail.com>
In-Reply-To: <CABvG-CWg-VXAtoN8HZumW-ZdP6dX9cO_8fWJ58C22kD2yDcXdw@mail.gmail.com>
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

PiA+IEl0IGlzIGJlY2F1c2UgdGhlIHN0YXRlIGhhcyBub3QgY2hhbmdlZCB0byBBVEgxMEtfU1RB
VEVfT04NCj4gPiBpbW1lZGlhdGVseSwgdGhlbiBpdCB3aWxsIGhhdmUgbW9yZSB0aGFuIHR3byBz
aW11bGF0ZSBjcmFzaCBwcm9jZXNzDQo+ID4gcnVubmluZyBtZWFud2hpbGUsIGFuZCBjb21wbGV0
ZS93YWtldXAgc29tZSBmaWVsZCB0d2ljZSwgaXQgZGVzdHJveQ0KPiA+IHRoZSBub3JtYWwgcmVj
b3ZlcnkgcHJvY2Vzcy4NCj4gDQo+IFRoaXMgd2FzIGludGVuZGVkIHRvIGFsbG93IHRlc3Rpbmcg
bm90IG9ubHkgZmlybXdhcmUgY3Jhc2ggcGF0aCAoYW5kDQo+IHJlY292ZXJ5KSBidXQgYWxzbyBm
aXJtd2FyZSBjcmFzaCB3aGlsZSByZWNvdmVyaW5nIGZyb20gYSBmaXJtd2FyZSBjcmFzaC4NCj4g
DQpJZiBmaXJtd2FyZSBpcyByZWNvdmVyaW5nIGZyb20gY3Jhc2gsIHRoZW4gc2ltdWxhdGUgYSBu
ZXcgY3Jhc2ggd2lsbCB0cmlnZ2VyIGVycm9yLg0KU28gcmVtb3ZlIGl0Lg0KPiANCj4gTWljaGHF
gg0KPiANCj4gX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18N
Cj4gYXRoMTBrIG1haWxpbmcgbGlzdA0KPiBhdGgxMGtAbGlzdHMuaW5mcmFkZWFkLm9yZw0KPiBo
dHRwOi8vbGlzdHMuaW5mcmFkZWFkLm9yZy9tYWlsbWFuL2xpc3RpbmZvL2F0aDEwaw0K
