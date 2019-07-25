Return-Path: <SRS0=wvrd=VW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF69FC76194
	for <linux-wireless@archiver.kernel.org>; Thu, 25 Jul 2019 10:52:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C0606218DA
	for <linux-wireless@archiver.kernel.org>; Thu, 25 Jul 2019 10:52:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RsSLnp6n"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728997AbfGYKwn (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 25 Jul 2019 06:52:43 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:39897 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728726AbfGYKwm (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 25 Jul 2019 06:52:42 -0400
Received: by mail-pf1-f195.google.com with SMTP id f17so18571443pfn.6
        for <linux-wireless@vger.kernel.org>; Thu, 25 Jul 2019 03:52:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=oVgsCC3RiMGe7tuxXcUxMfUIA90785iH1rwNHlmoQXA=;
        b=RsSLnp6nFquwCMocdU6z//Ph35z5I/90G7FnIPxTN2T5qlJnqh4e/v6soMkoGR/xsM
         yJ2C+V+v2NPEC52DDtF9bGs8WaofvreO6V0Z+BX8plQbjl45fD5+0kFmc2AEBZf6L1PY
         RsTEKuzwyfedBIuClDjmoRF6989y+Ubm4ZQi/kBZZytsecj9pMTdmmtuTWtKEW+TY1dB
         3XspJacnivN1MEagv8nFHLM6mUr8JDvys22ijz5Un3kzo2jTbn31PTTQK1J8AogH9Si3
         bVh14In8//BxK4ZuzbCyyL6B39z92YvDTlm4hleLCZwHFgF5/1vtOPziXFNX6skEISUt
         ydWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=oVgsCC3RiMGe7tuxXcUxMfUIA90785iH1rwNHlmoQXA=;
        b=Sa8lKXRxEq7rn04JRYLMewZuFKXmq0cLhZNVk0xIGlpjcS9R4jbo7Usv6W+Wep4/r1
         JzkDiGOAbeD/CfyNwovuFXL8RPmmcL+7GcwKfn19XfW6Q2YbROnvZ6b+4Zj9zpLkHbzU
         TEtvg9zYJ5bnk1mUg06KO+PTX00JaS9aSE/lLcRiuHBrikk2FNAEnMvtXXInBRQ34QAD
         hslFvmHeaKina3jPiiVIgTpZdhq2IOUIFFUVUMcVyf8hia4RXiWHvCEgtDAVQ+4yFhaZ
         /opSSQbmMPgWfSNiiD63NIHlktbAgYnHUD2jBsrnai3VNmCKz79u0qdHzJR+O3cteaUn
         K1/w==
X-Gm-Message-State: APjAAAVezUOr25FGDin/ekIHFrFLgiYdiEJJmd2U2VMa7446L/HgcVeM
        L8+NvUhMGHdLlADyp6I7EIE=
X-Google-Smtp-Source: APXvYqx4UWSdme9tiI3AzytSahCZRWQukrJJH/H6Z5w8r8y/d1tVcl+YicKuIvogxFG9nwHRPt5r9A==
X-Received: by 2002:a63:2784:: with SMTP id n126mr82906273pgn.92.1564051961637;
        Thu, 25 Jul 2019 03:52:41 -0700 (PDT)
Received: from cpu508.localdomain ([183.82.100.30])
        by smtp.gmail.com with ESMTPSA id f12sm44213015pgo.85.2019.07.25.03.52.37
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 25 Jul 2019 03:52:41 -0700 (PDT)
From:   Ganapathi Kondraju <ganapathirajukondraju@gmail.com>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org, rishikesh.basu@redpinesignals.com,
        krishna.pedda@redpinesignals.com, narasimha.a@redpinesignals.com,
        srinivas.chappidi@redpinesignals.com,
        Ganapathi Kondraju <ganapathirajukondraju@gmail.com>
Subject: [PATCH] rsi: fix for sdio reset card issue
Date:   Thu, 25 Jul 2019 16:21:50 +0530
Message-Id: <1564051910-20136-1-git-send-email-ganapathirajukondraju@gmail.com>
X-Mailer: git-send-email 2.5.5
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Issue: While removing and inserting the driver module, observed driver
loading is not successful.

Root cause: Card is not resetted completely without issuing cmd5.

Fix: Issued cmd5 properly.

Signed-off-by: Ganapathi Kondraju <ganapathirajukondraju@gmail.com>
---
 drivers/net/wireless/rsi/rsi_91x_sdio.c | 17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_sdio.c b/drivers/net/wireless/rsi/rsi_91x_sdio.c
index b42cd50..b3c7724 100644
--- a/drivers/net/wireless/rsi/rsi_91x_sdio.c
+++ b/drivers/net/wireless/rsi/rsi_91x_sdio.c
@@ -230,19 +230,16 @@ static void rsi_reset_card(struct sdio_func *pfunction)
 		rsi_dbg(ERR_ZONE, "%s: CMD0 failed : %d\n", __func__, err);
 
 	/* Issue CMD5, arg = 0 */
-	if (!host->ocr_avail) {
-		err = rsi_issue_sdiocommand(pfunction,	SD_IO_SEND_OP_COND, 0,
-					    (MMC_RSP_R4 | MMC_CMD_BCR), &resp);
-		if (err)
-			rsi_dbg(ERR_ZONE, "%s: CMD5 failed : %d\n",
-				__func__, err);
-
-		host->ocr_avail = resp;
-	}
+	err = rsi_issue_sdiocommand(pfunction,	SD_IO_SEND_OP_COND, 0,
+				    (MMC_RSP_R4 | MMC_CMD_BCR), &resp);
+	if (err)
+		rsi_dbg(ERR_ZONE, "%s: CMD5 failed : %d\n",
+			__func__, err);
+	card->ocr = resp;
 	/* Issue CMD5, arg = ocr. Wait till card is ready  */
 	for (i = 0; i < 100; i++) {
 		err = rsi_issue_sdiocommand(pfunction, SD_IO_SEND_OP_COND,
-					    host->ocr_avail,
+					    card->ocr,
 					    (MMC_RSP_R4 | MMC_CMD_BCR), &resp);
 		if (err) {
 			rsi_dbg(ERR_ZONE, "%s: CMD5 failed : %d\n",
-- 
2.5.5

