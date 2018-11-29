Return-Path: <SRS0=Li3M=OI=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2AB3C04EBA
	for <linux-wireless@archiver.kernel.org>; Thu, 29 Nov 2018 07:28:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 824CD20868
	for <linux-wireless@archiver.kernel.org>; Thu, 29 Nov 2018 07:28:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 824CD20868
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=zte.com.cn
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726667AbeK2Sck (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 29 Nov 2018 13:32:40 -0500
Received: from mxhk.zte.com.cn ([63.217.80.70]:55968 "EHLO mxhk.zte.com.cn"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726580AbeK2Sck (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 29 Nov 2018 13:32:40 -0500
Received: from mse01.zte.com.cn (unknown [10.30.3.20])
        by Forcepoint Email with ESMTPS id 2A63E42B2C91D7C29CD1;
        Thu, 29 Nov 2018 15:28:14 +0800 (CST)
Received: from notes_smtp.zte.com.cn ([10.30.1.239])
        by mse01.zte.com.cn with ESMTP id wAT7S4IN064378;
        Thu, 29 Nov 2018 15:28:04 +0800 (GMT-8)
        (envelope-from wen.yang99@zte.com.cn)
Received: from LIN-A6CB96A0603.zte.intra ([10.90.106.118])
          by szsmtp06.zte.com.cn (Lotus Domino Release 8.5.3FP6)
          with ESMTP id 2018112915283431-13671033 ;
          Thu, 29 Nov 2018 15:28:34 +0800 
From:   Wen Yang <wen.yang99@zte.com.cn>
To:     sameo@linux.intel.com
Cc:     linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        zhong.weidong@zte.com.cn, Wen Yang <wen.yang99@zte.com.cn>
Subject: [PATCH] NFC: fdp: Fix signedness bug in fdp_nci_send_patch
Date:   Thu, 29 Nov 2018 15:28:00 +0800
Message-Id: <20181129072800.7569-1-wen.yang99@zte.com.cn>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
X-MIMETrack: Itemize by SMTP Server on SZSMTP06/server/zte_ltd(Release 8.5.3FP6|November
 21, 2013) at 2018-11-29 15:28:34,
        Serialize by Router on notes_smtp/zte_ltd(Release 9.0.1FP7|August  17, 2016) at
 2018-11-29 15:27:52
Content-Transfer-Encoding: quoted-printable
X-MAIL: mse01.zte.com.cn wAT7S4IN064378
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Currently, the error handling for the call to
nci=5Fconn=5Fmax=5Fdata=5Fpkt=5Fpayload=5Fsize() doesn't work
because *max=5Fsize* is of type u8 (8 bits, unsigned),
which makes it impossible for it to hold a value less
than 0.

Fix this by changing the type of variable *max=5Fsize*
to s16 (16 bits, signed).

since conn=5Finfo->max=5Fpkt=5Fpayload=5Flen is of type u8,
so s16 is enough.

Signed-off-by: Wen Yang <wen.yang99@zte.com.cn>
CC: Samuel Ortiz <sameo@linux.intel.com>
CC: linux-wireless@vger.kernel.org
CC: linux-kernel@vger.kernel.org
---
 drivers/nfc/fdp/fdp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nfc/fdp/fdp.c b/drivers/nfc/fdp/fdp.c
index d5784a47fc13..d9203e2468fd 100644
--- a/drivers/nfc/fdp/fdp.c
+++ b/drivers/nfc/fdp/fdp.c
@@ -192,7 +192,7 @@ static int fdp=5Fnci=5Fsend=5Fpatch(struct nci=5Fdev *n=
dev, u8 conn=5Fid, u8 type)
 	const struct firmware *fw;
 	struct sk=5Fbuff *skb;
 	unsigned long len;
-	u8 max=5Fsize, payload=5Fsize;
+	s16 max=5Fsize, payload=5Fsize;
 	int rc =3D 0;
=20
 	if ((type =3D=3D NCI=5FPATCH=5FTYPE=5FOTP && !info->otp=5Fpatch) ||
--=20
2.19.1

