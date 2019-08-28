Return-Path: <SRS0=YfBD=WY=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5440C3A5A1
	for <linux-wireless@archiver.kernel.org>; Wed, 28 Aug 2019 13:03:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8925C20679
	for <linux-wireless@archiver.kernel.org>; Wed, 28 Aug 2019 13:03:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=qti.qualcomm.com header.i=@qti.qualcomm.com header.b="idW8LNGY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726449AbfH1NDX (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 28 Aug 2019 09:03:23 -0400
Received: from alexa-out-tai-02.qualcomm.com ([103.229.16.227]:62346 "EHLO
        alexa-out-tai-02.qualcomm.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726253AbfH1NDX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Aug 2019 09:03:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=qti.qualcomm.com; i=@qti.qualcomm.com; q=dns/txt;
  s=qcdkim; t=1566997402; x=1598533402;
  h=from:to:cc:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version:subject;
  bh=J2JIvCo/gDWUqveBoiH0BGVSG/QSfuMxe9cIL73DU34=;
  b=idW8LNGY8J1KaMX4qyUzRY78DWsyRiKUgKYizSp/tkIAuITp6P2LQUig
   XZJPi/2B70jMOnLDDne+WP/mdiuqP9ONLCB0ngdwXqg1ksGOL2NDWhhIw
   ocxpRWbYICv8DDAolmqEe16itbaHIbspLxEGxNGha0iOI1Z2hPM1Yq+Db
   w=;
Subject: RE: [PATCH v2 5/7] ath10k: add htt TX bundle for sdio
Thread-Topic: [PATCH v2 5/7] ath10k: add htt TX bundle for sdio
Received: from ironmsg03-tai.qualcomm.com ([10.249.140.8])
  by alexa-out-tai-02.qualcomm.com with ESMTP; 28 Aug 2019 21:03:21 +0800
Received: from aptaiexm02b.ap.qualcomm.com ([10.249.150.12])
  by ironmsg03-tai.qualcomm.com with ESMTP/TLS/AES256-SHA; 28 Aug 2019 21:03:21 +0800
Received: from aptaiexm02f.ap.qualcomm.com (10.249.150.16) by
 aptaiexm02b.ap.qualcomm.com (10.249.150.12) with Microsoft SMTP Server (TLS)
 id 15.0.1473.3; Wed, 28 Aug 2019 21:03:19 +0800
Received: from aptaiexm02f.ap.qualcomm.com ([fe80::4152:1436:e436:faa1]) by
 aptaiexm02f.ap.qualcomm.com ([fe80::4152:1436:e436:faa1%19]) with mapi id
 15.00.1473.005; Wed, 28 Aug 2019 21:03:19 +0800
From:   Wen Gong <wgong@qti.qualcomm.com>
To:     Nicolas Boichat <drinkcat@chromium.org>,
        Wen Gong <wgong@codeaurora.org>
CC:     "open list:NETWORKING DRIVERS (WIRELESS)" 
        <linux-wireless@vger.kernel.org>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Thread-Index: AQHVXWKa4RLo4LlR4Eu0hbim+24wL6cQhk8A
Date:   Wed, 28 Aug 2019 13:03:19 +0000
Message-ID: <2ebd81574092476a952ddeb671d1bfcf@aptaiexm02f.ap.qualcomm.com>
References: <1566903707-27536-1-git-send-email-wgong@codeaurora.org>
 <1566903707-27536-6-git-send-email-wgong@codeaurora.org>
 <CANMq1KAQncoZ3yX5Sfsc5tR8z9tJyA=jFF4_F1K=hLRe51OD4g@mail.gmail.com>
In-Reply-To: <CANMq1KAQncoZ3yX5Sfsc5tR8z9tJyA=jFF4_F1K=hLRe51OD4g@mail.gmail.com>
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
> Sent: Wednesday, August 28, 2019 1:36 PM
> To: Wen Gong <wgong@codeaurora.org>
> Cc: open list:NETWORKING DRIVERS (WIRELESS) <linux-
> wireless@vger.kernel.org>; ath10k@lists.infradead.org
> Subject: [EXT] Re: [PATCH v2 5/7] ath10k: add htt TX bundle for sdio
>=20
>=20
> > +       int cn =3D 0;
> > +       unsigned int skb_len;
> > +
> > +       ath10k_dbg(ar, ATH10K_DBG_HTC, "bundle skb: len:%d\n",
> bundle_skb->len);
> > +       skb_len =3D bundle_skb->len;
> > +       ret =3D ath10k_htc_consume_credit(ep, skb_len, true);
>=20
> ret makes me think of some error status, can we find a better name?
> Like credit_available or something?
If consume fail, it mean a error status(-EAGAIN), then it mean fail for thi=
s tx.
> _______________________________________________
> ath10k mailing list
> ath10k@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/ath10k
