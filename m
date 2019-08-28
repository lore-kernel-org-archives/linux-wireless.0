Return-Path: <SRS0=YfBD=WY=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF8DCC3A5A3
	for <linux-wireless@archiver.kernel.org>; Wed, 28 Aug 2019 02:31:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C441C214DA
	for <linux-wireless@archiver.kernel.org>; Wed, 28 Aug 2019 02:31:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=qti.qualcomm.com header.i=@qti.qualcomm.com header.b="f+m1YCtD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726256AbfH1Cbp (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 27 Aug 2019 22:31:45 -0400
Received: from alexa-out-tai-01.qualcomm.com ([103.229.16.226]:48849 "EHLO
        alexa-out-tai-01.qualcomm.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726096AbfH1Cbo (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 27 Aug 2019 22:31:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=qti.qualcomm.com; i=@qti.qualcomm.com; q=dns/txt;
  s=qcdkim; t=1566959503; x=1598495503;
  h=from:to:cc:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version:subject;
  bh=uWpyLyt1Q9QOr16kRuszAxnep3sR5hO2WlTvUQdD2dI=;
  b=f+m1YCtD2sreZQWlzPWch+XmT3JF4VlnWehUODtLfP1AfhVe2J9FUouT
   Q5fuHkMtyrU7K+rn84QIoq0NEDZZesWHCvdvB+wdMDIOMihmJ7pdi2JsN
   f7Xi3ufgfVj8PQAopPL0nkFBTPFj+JshCZ9+9Qy/psJHlEWSKJ9M6nXDo
   Y=;
Subject: RE: [PATCH 2/7] ath10k: change max RX bundle size from 8 to 32 for sdio
Thread-Topic: [PATCH 2/7] ath10k: change max RX bundle size from 8 to 32 for sdio
Received: from ironmsg03-tai.qualcomm.com ([10.249.140.8])
  by alexa-out-tai-01.qualcomm.com with ESMTP; 28 Aug 2019 10:31:41 +0800
Received: from aptaiexm02f.ap.qualcomm.com ([10.249.150.16])
  by ironmsg03-tai.qualcomm.com with ESMTP/TLS/AES256-SHA; 28 Aug 2019 10:31:36 +0800
Received: from aptaiexm02f.ap.qualcomm.com (10.249.150.16) by
 aptaiexm02f.ap.qualcomm.com (10.249.150.16) with Microsoft SMTP Server (TLS)
 id 15.0.1473.3; Wed, 28 Aug 2019 10:31:34 +0800
Received: from aptaiexm02f.ap.qualcomm.com ([fe80::4152:1436:e436:faa1]) by
 aptaiexm02f.ap.qualcomm.com ([fe80::4152:1436:e436:faa1%19]) with mapi id
 15.00.1473.005; Wed, 28 Aug 2019 10:31:34 +0800
From:   Wen Gong <wgong@qti.qualcomm.com>
To:     Nicolas Boichat <drinkcat@chromium.org>,
        Wen Gong <wgong@codeaurora.org>
CC:     "open list:NETWORKING DRIVERS (WIRELESS)" 
        <linux-wireless@vger.kernel.org>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Thread-Index: AQHVXKsXjUGwyI7gPEe83ghz4pg/wacP183A
Date:   Wed, 28 Aug 2019 02:31:34 +0000
Message-ID: <166d63589ee043c9bc5fab8e837a5aa1@aptaiexm02f.ap.qualcomm.com>
References: <1566302108-18219-1-git-send-email-wgong@codeaurora.org>
 <1566302108-18219-3-git-send-email-wgong@codeaurora.org>
 <CANMq1KBRMnVqw5rcnVcJs1UjYJxh+RqAEKSAjboojoMgJQpSDw@mail.gmail.com>
In-Reply-To: <CANMq1KBRMnVqw5rcnVcJs1UjYJxh+RqAEKSAjboojoMgJQpSDw@mail.gmail.com>
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
> From: ath10k <ath10k-bounces@lists.infradead.org> On Behalf Of Nicolas
> Boichat
> Sent: Tuesday, August 27, 2019 3:43 PM
> To: Wen Gong <wgong@codeaurora.org>
> Cc: open list:NETWORKING DRIVERS (WIRELESS) <linux-
> wireless@vger.kernel.org>; ath10k@lists.infradead.org
> Subject: [EXT] Re: [PATCH 2/7] ath10k: change max RX bundle size from 8 t=
o
> 32 for sdio
>=20
> > @@ -501,6 +501,7 @@ static int ath10k_sdio_mbox_alloc_bundle(struct
> ath10k *ar,
> >         int ret, i;
> >
> >         *bndl_cnt =3D FIELD_GET(ATH10K_HTC_FLAG_BUNDLE_MASK, htc_hdr-
> >flags);
> > +       *bndl_cnt +=3D (FIELD_GET(GENMASK(3, 2), htc_hdr->flags) << 4);
>=20
> GENMASK(3, 2): Please define this macro somewhere.
>=20
> Also, I'd merge the 2 lines in 1.
Patch v2 has sent, https://patchwork.kernel.org/patch/11116677/
> ath10k mailing list
> ath10k@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/ath10k
