Return-Path: <SRS0=IwVr=W7=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49B61C3A5A2
	for <linux-wireless@archiver.kernel.org>; Wed,  4 Sep 2019 02:50:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1546B21897
	for <linux-wireless@archiver.kernel.org>; Wed,  4 Sep 2019 02:50:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=qti.qualcomm.com header.i=@qti.qualcomm.com header.b="rtK7qCXM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727914AbfIDCuP (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 3 Sep 2019 22:50:15 -0400
Received: from alexa-out-tai-01.qualcomm.com ([103.229.16.226]:24375 "EHLO
        alexa-out-tai-01.qualcomm.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727867AbfIDCuP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 3 Sep 2019 22:50:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=qti.qualcomm.com; i=@qti.qualcomm.com; q=dns/txt;
  s=qcdkim; t=1567565413; x=1599101413;
  h=from:to:cc:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version:subject;
  bh=44eugvvOxE68WWjKvO79s/b4AgVnqfdN+gD7csPzzg8=;
  b=rtK7qCXMZewcgPQsdVlZ30LReg/j8wwWRu0z//C4LryUGHYIWiitX0th
   UoACHx6cXOPBWK5FhaPKxrjr4eOQ8u3Vs2Fx93vCF2Ne+df/HLZEMsxQ9
   1uYtPga3d5aauvx2JNKXgrEiIIn/5oU+y+J/2XBdTD0OVmTzjthGhRTbG
   Y=;
Subject: RE: [PATCH v4 3/8] ath10k: change max RX bundle size from 8 to 32 for sdio
Thread-Topic: [PATCH v4 3/8] ath10k: change max RX bundle size from 8 to 32 for sdio
Received: from ironmsg03-tai.qualcomm.com ([10.249.140.8])
  by alexa-out-tai-01.qualcomm.com with ESMTP; 04 Sep 2019 10:50:12 +0800
Received: from aptaiexm02f.ap.qualcomm.com ([10.249.150.16])
  by ironmsg03-tai.qualcomm.com with ESMTP/TLS/AES256-SHA; 04 Sep 2019 10:50:12 +0800
Received: from aptaiexm02f.ap.qualcomm.com (10.249.150.16) by
 aptaiexm02f.ap.qualcomm.com (10.249.150.16) with Microsoft SMTP Server (TLS)
 id 15.0.1473.3; Wed, 4 Sep 2019 10:50:10 +0800
Received: from aptaiexm02f.ap.qualcomm.com ([fe80::4152:1436:e436:faa1]) by
 aptaiexm02f.ap.qualcomm.com ([fe80::4152:1436:e436:faa1%19]) with mapi id
 15.00.1473.005; Wed, 4 Sep 2019 10:50:10 +0800
From:   Wen Gong <wgong@qti.qualcomm.com>
To:     Wen Gong <wgong@codeaurora.org>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
CC:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Thread-Index: AQHVYXAVa1OUNWMQOEGN3QFbDA2u66ca0++A
Date:   Wed, 4 Sep 2019 02:50:10 +0000
Message-ID: <f70df46709bc4badb36c94e2dd8a49a9@aptaiexm02f.ap.qualcomm.com>
References: <1567416146-14403-1-git-send-email-wgong@codeaurora.org>
 <1567416146-14403-4-git-send-email-wgong@codeaurora.org>
In-Reply-To: <1567416146-14403-4-git-send-email-wgong@codeaurora.org>
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
> Sent: Monday, September 2, 2019 5:22 PM
> To: ath10k@lists.infradead.org
> Cc: linux-wireless@vger.kernel.org
> Subject: [EXT] [PATCH v4 3/8] ath10k: change max RX bundle size from 8 to
> 32 for sdio
>=20
Patch v4 sent, https://patchwork.kernel.org/patch/11126225/
>=20
>=20
> _______________________________________________
> ath10k mailing list
> ath10k@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/ath10k
