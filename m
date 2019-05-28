Return-Path: <SRS0=DQ7G=T4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 130A7C04AB3
	for <linux-wireless@archiver.kernel.org>; Tue, 28 May 2019 02:55:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DA3082075E
	for <linux-wireless@archiver.kernel.org>; Tue, 28 May 2019 02:54:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=qti.qualcomm.com header.i=@qti.qualcomm.com header.b="WieZggBa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727931AbfE1Cy7 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 27 May 2019 22:54:59 -0400
Received: from alexa-out-tai-01.qualcomm.com ([103.229.16.226]:10182 "EHLO
        alexa-out-tai-01.qualcomm.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727507AbfE1Cy6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 27 May 2019 22:54:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=qti.qualcomm.com; i=@qti.qualcomm.com; q=dns/txt;
  s=qcdkim; t=1559012097; x=1590548097;
  h=from:to:cc:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version:subject;
  bh=zNYXwNuVh9/1L9/I1OSG3THPZyntxIZ+lEywT6ycp0M=;
  b=WieZggBagZ2WQumgkk/sUFORNePwhYGFYm1aE37eQBClFDYLJhpOfzTZ
   k+R35RKka6ZaLPfddK0v3MpOA8ktBlL8gEnOuxRfOamd2CuXPEj/lCUN5
   1cWpMcdONXEWGKMKqQ6KHVIe9BuzBOqRZknoxZcDc7mJmWEXjDHeINnAo
   s=;
Subject: RE: [PATCH v2] ath10k: add support for simulate crash on SDIO chip
Thread-Topic: [PATCH v2] ath10k: add support for simulate crash on SDIO chip
Received: from ironmsg02-tai.qualcomm.com ([10.249.140.7])
  by alexa-out-tai-01.qualcomm.com with ESMTP; 28 May 2019 10:54:56 +0800
X-IronPort-AV: E=McAfee;i="5900,7806,9270"; a="30540123"
Received: from aptaiexm02f.ap.qualcomm.com ([10.249.150.16])
  by ironmsg02-tai.qualcomm.com with ESMTP/TLS/AES256-SHA; 28 May 2019 10:54:55 +0800
Received: from aptaiexm02f.ap.qualcomm.com (10.249.150.16) by
 aptaiexm02f.ap.qualcomm.com (10.249.150.16) with Microsoft SMTP Server (TLS)
 id 15.0.1395.4; Tue, 28 May 2019 10:54:53 +0800
Received: from aptaiexm02f.ap.qualcomm.com ([fe80::4152:1436:e436:faa1]) by
 aptaiexm02f.ap.qualcomm.com ([fe80::4152:1436:e436:faa1%19]) with mapi id
 15.00.1395.000; Tue, 28 May 2019 10:54:53 +0800
From:   Wen Gong <wgong@qti.qualcomm.com>
To:     Claire Chang <tientzu@google.com>, Wen Gong <wgong@codeaurora.org>
CC:     "open list:NETWORKING DRIVERS (WIRELESS)" 
        <linux-wireless@vger.kernel.org>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Thread-Index: AQHVCslW/u/fYzi78E+Y5SXBgv663aZ2uDcwgAkzO/A=
Date:   Tue, 28 May 2019 02:54:53 +0000
Message-ID: <4b8277404b26439395006d4476dd5e06@aptaiexm02f.ap.qualcomm.com>
References: <1556524457-17469-1-git-send-email-wgong@codeaurora.org>
 <CALiNf29_GwSEUJ_vdp+_1DeDyFZj0uuUY9kYh94w4P_eeDT=8g@mail.gmail.com>
 <5b1f1d8619524128894e5f31ca4733af@aptaiexm02f.ap.qualcomm.com>
In-Reply-To: <5b1f1d8619524128894e5f31ca4733af@aptaiexm02f.ap.qualcomm.com>
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
> Sent: Wednesday, May 22, 2019 2:24 PM
> To: Claire Chang <tientzu@google.com>; Wen Gong
> <wgong@codeaurora.org>
> Cc: open list:NETWORKING DRIVERS (WIRELESS) <linux-
> wireless@vger.kernel.org>; ath10k@lists.infradead.org
> Subject: [EXT] RE: [PATCH v2] ath10k: add support for simulate crash on S=
DIO
> chip
> > Tested-by: Claire Chang <tientzu@chromium.org>
> >
> > If this patch adds support for detecting the real firmware assert,
> > maybe the title should be "add support for _crash recovery_ on SDIO
> > chip"
> Yes, seems this title is more appropriate.
Hi Claire
New patch has uploaded for the change
https://patchwork.kernel.org/patch/10955189/
[v3] ath10k: add support for firmware crash recovery on SDIO chip
