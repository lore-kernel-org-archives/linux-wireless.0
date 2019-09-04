Return-Path: <SRS0=IwVr=W7=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C2C1C3A5A2
	for <linux-wireless@archiver.kernel.org>; Wed,  4 Sep 2019 02:58:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 015E62077B
	for <linux-wireless@archiver.kernel.org>; Wed,  4 Sep 2019 02:58:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=qti.qualcomm.com header.i=@qti.qualcomm.com header.b="AzgiKbww"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727914AbfIDC6g (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 3 Sep 2019 22:58:36 -0400
Received: from alexa-out-tai-01.qualcomm.com ([103.229.16.226]:27081 "EHLO
        alexa-out-tai-01.qualcomm.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727716AbfIDC6g (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 3 Sep 2019 22:58:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=qti.qualcomm.com; i=@qti.qualcomm.com; q=dns/txt;
  s=qcdkim; t=1567565914; x=1599101914;
  h=from:to:cc:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version:subject;
  bh=2WLg4IFzY5ZyJwxmJS+sM5P2jT18J8lsNBM2mxP2Pfo=;
  b=AzgiKbww+yd0sEauXoJzrWcLpoSXoJbUF57IiU6HyWszmOqq5t0xsvTa
   lguSvKLCiUkNO+J4Guo5JozBwsBChzlko8c2ueU0XbT8vSnNnrF+YCIVx
   PHTqYBsj1qfMrOtIym2EA3c1BMT0sCZtaV3TcbXCDc3aeRcO9tTcm6wr4
   I=;
Subject: RE: [PATCH v3 7/8] ath10k: enable alt data of TX path for sdio
Thread-Topic: [PATCH v3 7/8] ath10k: enable alt data of TX path for sdio
Received: from ironmsg01-tai.qualcomm.com ([10.249.140.6])
  by alexa-out-tai-01.qualcomm.com with ESMTP; 04 Sep 2019 10:58:33 +0800
Received: from aptaiexm02f.ap.qualcomm.com ([10.249.150.16])
  by ironmsg01-tai.qualcomm.com with ESMTP/TLS/AES256-SHA; 04 Sep 2019 10:58:33 +0800
Received: from aptaiexm02f.ap.qualcomm.com (10.249.150.16) by
 aptaiexm02f.ap.qualcomm.com (10.249.150.16) with Microsoft SMTP Server (TLS)
 id 15.0.1473.3; Wed, 4 Sep 2019 10:58:31 +0800
Received: from aptaiexm02f.ap.qualcomm.com ([fe80::4152:1436:e436:faa1]) by
 aptaiexm02f.ap.qualcomm.com ([fe80::4152:1436:e436:faa1%19]) with mapi id
 15.00.1473.005; Wed, 4 Sep 2019 10:58:31 +0800
From:   Wen Gong <wgong@qti.qualcomm.com>
To:     Wen Gong <wgong@codeaurora.org>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
CC:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Thread-Index: AQHVXp81B3vIPYfib0uUEwHtYNlf4aca29dQ
Date:   Wed, 4 Sep 2019 02:58:31 +0000
Message-ID: <a5ccd7003f414d09b8b7de207576c10c@aptaiexm02f.ap.qualcomm.com>
References: <1566998177-2658-1-git-send-email-wgong@codeaurora.org>
 <1566998177-2658-8-git-send-email-wgong@codeaurora.org>
In-Reply-To: <1566998177-2658-8-git-send-email-wgong@codeaurora.org>
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
> Subject: [EXT] [PATCH v3 7/8] ath10k: enable alt data of TX path for sdio
>=20
Patch v4 sent, https://patchwork.kernel.org/patch/11126235/

>=20
> _______________________________________________
> ath10k mailing list
> ath10k@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/ath10k
