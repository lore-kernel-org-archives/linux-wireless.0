Return-Path: <SRS0=80NG=P2=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DF9AC43387
	for <linux-wireless@archiver.kernel.org>; Fri, 18 Jan 2019 09:18:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 29B5B20823
	for <linux-wireless@archiver.kernel.org>; Fri, 18 Jan 2019 09:18:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="rNevZuHb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726981AbfARJSU (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 18 Jan 2019 04:18:20 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:33343 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725924AbfARJST (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 18 Jan 2019 04:18:19 -0500
Received: by mail-pg1-f196.google.com with SMTP id z11so5782826pgu.0
        for <linux-wireless@vger.kernel.org>; Fri, 18 Jan 2019 01:18:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=m6hTkkgeB4WIs4dO5qVCgkJHHaM0qAwiWiDgz461vLo=;
        b=rNevZuHbzxX9XySDrJYAP3VAzYsKmErAiXs/dssTN9Yjz+wkyR3jdhsqVZcWzdIPvd
         hyoRSc0Oxk9MHObAobTsCbA0tSJgbRjKZ/CMBAMfP5Im+mqur0XQaMk1Auq4l0FcOXP6
         hRlbTiGRpUPJmXkfDOwWYA7n7rYv5pikUfPP2oyT11y9B7v++6bNKWldFcbfAnjenm2A
         H1+OWTlqO+6Rlo1E00ABxHXUa+7z0syUegLITUJemMdSdWA8Jh2xZkJal9C2rMBFtpmc
         qT/j3l/DpT9oUEMcLo5P57iHD22P9QRDT+xAktBA7gIRg2q/hEOwlWcD9bu6kc2ueoMB
         Namw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=m6hTkkgeB4WIs4dO5qVCgkJHHaM0qAwiWiDgz461vLo=;
        b=Q/nMkHAyFbMTYX2Wyj0Hotv4czEIxB6ssdAUQ3ygvfVAjWWLTlqzOZkYldbvqb3UaW
         oVhmug8QqEMB1AUH1SLAOnL+yT2sUW9aFDcDBhGss7iRZjckQPnPYXo0eH2QNP6SWpTu
         9vTbvIUK13PrxA9L/PG7Q0jBYhFOiSDj/sc3TmCyCfdDCNkq1tHkq6YRkyvVxuqYjvZj
         Bzi/vhqYak3WNn2491/mOpLInfkA7f4pAZuGupoQjWNA3CryMpEs8MUd+UMikGJmMzj6
         68P/wuDs1cWw2dhgiR5UHXc+YiBNFsJEqHuAzp4kr+PTz6m3cpXANkv1WnRlJOPLUmM1
         LGtw==
X-Gm-Message-State: AJcUukf0mixDFctMZQ6j7QdYkNabeUq9vfcv1ZgtBLYHifHxk5UgUI3n
        tKzxlopms0apwiYVDPu2Gv4=
X-Google-Smtp-Source: ALg8bN4+4iXcGOIYrGkqGFzLhlNbxVI/JZg0AA360hARfkQvOZ9+mi+thHoL9NsB1bDtyKJBrtGIIw==
X-Received: by 2002:a62:3888:: with SMTP id f130mr18295080pfa.132.1547803098378;
        Fri, 18 Jan 2019 01:18:18 -0800 (PST)
Received: from cpu459.localdomain ([203.196.161.90])
        by smtp.gmail.com with ESMTPSA id m11sm6225596pgh.51.2019.01.18.01.18.16
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 18 Jan 2019 01:18:17 -0800 (PST)
From:   Siva Rebbagondla <siva8118@gmail.com>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org,
        Rishikesh Basu <rishikesh.basu@redpinesignals.com>,
        Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>,
        Ganapathi Kondraju <ganapathi.kondraju@redpinesignals.com>
Subject: [PATCH] rsi: Suppress sdhci warnings in mmc
Date:   Fri, 18 Jan 2019 14:48:07 +0530
Message-Id: <1547803087-2767-1-git-send-email-siva8118@gmail.com>
X-Mailer: git-send-email 2.5.5
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>

while inserting and removing sdio module multiple times, we are getting
sdhci warnings. This is because, improper assignment of ocr_avail value.
Fixed this by assigning proper value.

This patch is enhancement for commit 78e450719c702 ("rsi: Fix 'invalid
vdd' warning in mmc").

Signed-off-by: Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>
---
 drivers/net/wireless/rsi/rsi_91x_sdio.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_sdio.c b/drivers/net/wireless/rsi/rsi_91x_sdio.c
index 5733e44..b412b65e 100644
--- a/drivers/net/wireless/rsi/rsi_91x_sdio.c
+++ b/drivers/net/wireless/rsi/rsi_91x_sdio.c
@@ -230,16 +230,19 @@ static void rsi_reset_card(struct sdio_func *pfunction)
 		rsi_dbg(ERR_ZONE, "%s: CMD0 failed : %d\n", __func__, err);
 
 	/* Issue CMD5, arg = 0 */
-	err = rsi_issue_sdiocommand(pfunction,	SD_IO_SEND_OP_COND, 0,
-				    (MMC_RSP_R4 | MMC_CMD_BCR), &resp);
-	if (err)
-		rsi_dbg(ERR_ZONE, "%s: CMD5 failed : %d\n", __func__, err);
-	card->ocr = resp;
+	if (!host->ocr_avail) {
+		err = rsi_issue_sdiocommand(pfunction,	SD_IO_SEND_OP_COND, 0,
+					    (MMC_RSP_R4 | MMC_CMD_BCR), &resp);
+		if (err)
+			rsi_dbg(ERR_ZONE, "%s: CMD5 failed : %d\n",
+				__func__, err);
 
+		host->ocr_avail = resp;
+	}
 	/* Issue CMD5, arg = ocr. Wait till card is ready  */
 	for (i = 0; i < 100; i++) {
 		err = rsi_issue_sdiocommand(pfunction, SD_IO_SEND_OP_COND,
-					    card->ocr,
+					    host->ocr_avail,
 					    (MMC_RSP_R4 | MMC_CMD_BCR), &resp);
 		if (err) {
 			rsi_dbg(ERR_ZONE, "%s: CMD5 failed : %d\n",
-- 
2.5.5

