Return-Path: <SRS0=fVU0=YL=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 427A6CA9EA1
	for <linux-wireless@archiver.kernel.org>; Fri, 18 Oct 2019 07:32:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 146D821925
	for <linux-wireless@archiver.kernel.org>; Fri, 18 Oct 2019 07:32:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=qti.qualcomm.com header.i=@qti.qualcomm.com header.b="F6M3iOTL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2504657AbfJRHca (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 18 Oct 2019 03:32:30 -0400
Received: from alexa-out-tai-01.qualcomm.com ([103.229.16.226]:47551 "EHLO
        alexa-out-tai-01.qualcomm.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2504654AbfJRHca (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 18 Oct 2019 03:32:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=qti.qualcomm.com; i=@qti.qualcomm.com; q=dns/txt;
  s=qcdkim; t=1571383948; x=1602919948;
  h=from:to:cc:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version:subject;
  bh=c1Z13+CwjbsZVMjbpUr1K4JixK1KqtG40lCJzoikBGs=;
  b=F6M3iOTLBtfy+TO5995MfxaMHbwNk5aluM7U8R+HC4bZrkHVLMa8nybI
   0wpmb2N6S/BHGlBsGkXqT4x1yEUbFmXB2r4C2eo54BOj4HyztXXneqH+o
   0iTtVac1cUrabxAEsfDxzYYF8Dt+C3NJnUUURMlVzIW1DkN8RE81MeM4t
   Y=;
Subject: RE: [PATCH v6 0/3] ath10k: improve throughout of TX of sdio
Thread-Topic: [PATCH v6 0/3] ath10k: improve throughout of TX of sdio
Received: from ironmsg03-tai.qualcomm.com ([10.249.140.8])
  by alexa-out-tai-01.qualcomm.com with ESMTP; 18 Oct 2019 15:32:27 +0800
IronPort-SDR: NJ6BTczjvaxbwMsG+6lkJorgaIgazj1CSNLxtf4cx6/CLsQJKutKFZKQ9UMzSKg/0/0QzszFSO
 hvXVrkXy9Q4nnv5kId6L8BlcmY0oY3FvU=
Received: from aptaiexm02f.ap.qualcomm.com ([10.249.150.16])
  by ironmsg03-tai.qualcomm.com with ESMTP/TLS/AES256-SHA; 18 Oct 2019 15:32:23 +0800
Received: from aptaiexm02f.ap.qualcomm.com (10.249.150.16) by
 aptaiexm02f.ap.qualcomm.com (10.249.150.16) with Microsoft SMTP Server (TLS)
 id 15.0.1473.3; Fri, 18 Oct 2019 15:32:21 +0800
Received: from aptaiexm02f.ap.qualcomm.com ([fe80::4152:1436:e436:faa1]) by
 aptaiexm02f.ap.qualcomm.com ([fe80::4152:1436:e436:faa1%19]) with mapi id
 15.00.1473.005; Fri, 18 Oct 2019 15:32:21 +0800
From:   Wen Gong <wgong@qti.qualcomm.com>
To:     Wen Gong <wgong@codeaurora.org>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
CC:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Thread-Index: AQHVgoV9jFQGH+/mB0aT0w8iTqCe9KdgBu1w
Date:   Fri, 18 Oct 2019 07:32:21 +0000
Message-ID: <242a332d3a2744ad8d17186e57540984@aptaiexm02f.ap.qualcomm.com>
References: <20191014114916.7519-1-wgong@codeaurora.org>
In-Reply-To: <20191014114916.7519-1-wgong@codeaurora.org>
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
> Sent: Monday, October 14, 2019 7:49 PM
> To: ath10k@lists.infradead.org
> Cc: linux-wireless@vger.kernel.org
> Subject: [EXT] [PATCH v6 0/3] ath10k: improve throughout of TX of sdio
V7 have sent
https://patchwork.kernel.org/patch/11197611/
https://patchwork.kernel.org/patch/11197615/
https://patchwork.kernel.org/patch/11197613/
>=20
> _______________________________________________
> ath10k mailing list
> ath10k@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/ath10k
