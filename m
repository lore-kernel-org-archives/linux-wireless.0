Return-Path: <SRS0=YfBD=WY=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CC7DC3A5A1
	for <linux-wireless@archiver.kernel.org>; Wed, 28 Aug 2019 04:29:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 041132080F
	for <linux-wireless@archiver.kernel.org>; Wed, 28 Aug 2019 04:29:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=qti.qualcomm.com header.i=@qti.qualcomm.com header.b="jsrayDFO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726187AbfH1E33 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 28 Aug 2019 00:29:29 -0400
Received: from alexa-out-tai-02.qualcomm.com ([103.229.16.227]:26753 "EHLO
        alexa-out-tai-02.qualcomm.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725763AbfH1E33 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Aug 2019 00:29:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=qti.qualcomm.com; i=@qti.qualcomm.com; q=dns/txt;
  s=qcdkim; t=1566966567; x=1598502567;
  h=from:to:cc:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version:subject;
  bh=wLV1kSn7JGBRMEYFyS2axcQJbSvHj8cdThEb8IJFSNo=;
  b=jsrayDFON37BLE4iLB0R5rYms73nlaV84Mz4S1uKNa+ZLPr2MUGhCoik
   6Z8SEYDp8ETuxyBo47E47gOt3iZpK4pTz/pRUxluHct0WL9tEs0xWcu/Y
   IiyCva4cHyBF02SdkrRvrvhKUpvkWt8LsIydbVECMldneaQm3gjyvU8vb
   8=;
Subject: RE: [PATCH v2 4/7] ath10k: disable TX complete indication of htt for sdio
Thread-Topic: [PATCH v2 4/7] ath10k: disable TX complete indication of htt for sdio
Received: from ironmsg03-tai.qualcomm.com ([10.249.140.8])
  by alexa-out-tai-02.qualcomm.com with ESMTP; 28 Aug 2019 12:29:26 +0800
Received: from aptaiexm02a.ap.qualcomm.com ([10.249.150.11])
  by ironmsg03-tai.qualcomm.com with ESMTP/TLS/AES256-SHA; 28 Aug 2019 12:29:26 +0800
Received: from aptaiexm02f.ap.qualcomm.com (10.249.150.16) by
 aptaiexm02a.ap.qualcomm.com (10.249.150.11) with Microsoft SMTP Server (TLS)
 id 15.0.1473.3; Wed, 28 Aug 2019 12:29:24 +0800
Received: from aptaiexm02f.ap.qualcomm.com ([fe80::4152:1436:e436:faa1]) by
 aptaiexm02f.ap.qualcomm.com ([fe80::4152:1436:e436:faa1%19]) with mapi id
 15.00.1473.005; Wed, 28 Aug 2019 12:29:25 +0800
From:   Wen Gong <wgong@qti.qualcomm.com>
To:     Wen Gong <wgong@codeaurora.org>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
CC:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Thread-Index: AQHVXMcm/tkLK8iMXUGNx3Qqynvy0qcP+K+w
Date:   Wed, 28 Aug 2019 04:29:24 +0000
Message-ID: <c9948e59a395437d8fa2c0132467af43@aptaiexm02f.ap.qualcomm.com>
References: <1566903707-27536-1-git-send-email-wgong@codeaurora.org>
 <1566903707-27536-5-git-send-email-wgong@codeaurora.org>
In-Reply-To: <1566903707-27536-5-git-send-email-wgong@codeaurora.org>
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
> Sent: Tuesday, August 27, 2019 7:02 PM
> To: ath10k@lists.infradead.org
> Cc: linux-wireless@vger.kernel.org
> Subject: [EXT] [PATCH v2 4/7] ath10k: disable TX complete indication of h=
tt
> for sdio

v2: change some code style

>=20
> _______________________________________________
> ath10k mailing list
> ath10k@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/ath10k
