Return-Path: <SRS0=IwVr=W7=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1591C3A5A2
	for <linux-wireless@archiver.kernel.org>; Wed,  4 Sep 2019 02:55:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7A7C62073F
	for <linux-wireless@archiver.kernel.org>; Wed,  4 Sep 2019 02:55:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=qti.qualcomm.com header.i=@qti.qualcomm.com header.b="GIVKNV/K"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727947AbfIDCzj (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 3 Sep 2019 22:55:39 -0400
Received: from alexa-out-tai-01.qualcomm.com ([103.229.16.226]:26138 "EHLO
        alexa-out-tai-01.qualcomm.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727938AbfIDCzj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 3 Sep 2019 22:55:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=qti.qualcomm.com; i=@qti.qualcomm.com; q=dns/txt;
  s=qcdkim; t=1567565738; x=1599101738;
  h=from:to:cc:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version:subject;
  bh=fXJWFJYtCBBPFlVWzeaCfuIz2m9Bwk4PYTOx0F6DdYI=;
  b=GIVKNV/KWpiD6JzkEh4oUH5l+r/UNxNSHAUdvrQmC9wubgfq0IaFEJvk
   ZGL19vZYm3ZvJv49qrhbleKxTXr/MkSper5HFyNW/KE636K7VQJG6ZT31
   0mxAU8dVpC0GFfx0yDMATKEktYum5nyJ6cTYT7oH2AKVdLR24tHEjzzHY
   s=;
Subject: RE: [PATCH v3 5/8] ath10k: disable TX complete indication of htt for sdio
Thread-Topic: [PATCH v3 5/8] ath10k: disable TX complete indication of htt for sdio
Received: from ironmsg02-tai.qualcomm.com ([10.249.140.7])
  by alexa-out-tai-01.qualcomm.com with ESMTP; 04 Sep 2019 10:55:36 +0800
Received: from aptaiexm02e.ap.qualcomm.com ([10.249.150.15])
  by ironmsg02-tai.qualcomm.com with ESMTP/TLS/AES256-SHA; 04 Sep 2019 10:55:34 +0800
Received: from aptaiexm02f.ap.qualcomm.com (10.249.150.16) by
 aptaiexm02e.ap.qualcomm.com (10.249.150.15) with Microsoft SMTP Server (TLS)
 id 15.0.1473.3; Wed, 4 Sep 2019 10:55:32 +0800
Received: from aptaiexm02f.ap.qualcomm.com ([fe80::4152:1436:e436:faa1]) by
 aptaiexm02f.ap.qualcomm.com ([fe80::4152:1436:e436:faa1%19]) with mapi id
 15.00.1473.005; Wed, 4 Sep 2019 10:55:32 +0800
From:   Wen Gong <wgong@qti.qualcomm.com>
To:     Wen Gong <wgong@codeaurora.org>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
CC:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Thread-Index: AQHVXpJTQeY5alwS8EWGeEhe/5ecD6ca2v8w
Date:   Wed, 4 Sep 2019 02:54:58 +0000
Message-ID: <9bafbc777b224f5180ddec0d0ab25b31@aptaiexm02f.ap.qualcomm.com>
References: <1566998177-2658-1-git-send-email-wgong@codeaurora.org>
 <1566998177-2658-6-git-send-email-wgong@codeaurora.org>
In-Reply-To: <1566998177-2658-6-git-send-email-wgong@codeaurora.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.249.136.10]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

> -----Original Message-----
> From: ath10k <ath10k-bounces@lists.infradead.org> On Behalf Of Wen Gong
> Sent: Wednesday, August 28, 2019 9:16 PM
> To: ath10k@lists.infradead.org
> Cc: linux-wireless@vger.kernel.org
> Subject: [EXT] [PATCH v3 5/8] ath10k: disable TX complete indication of h=
tt
> for sdio
Patch v4 sent, https://patchwork.kernel.org/patch/11126231/
>=20
>=20
> _______________________________________________
> ath10k mailing list
> ath10k@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/ath10k
