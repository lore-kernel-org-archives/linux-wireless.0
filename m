Return-Path: <SRS0=E2P1=NN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,T_DKIMWL_WL_HIGH,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70149C32789
	for <linux-wireless@archiver.kernel.org>; Fri,  2 Nov 2018 17:18:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 355CD2081F
	for <linux-wireless@archiver.kernel.org>; Fri,  2 Nov 2018 17:18:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="Rjn4VI5f"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 355CD2081F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728186AbeKCC0Z (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 2 Nov 2018 22:26:25 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:41769 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727859AbeKCC0Y (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 2 Nov 2018 22:26:24 -0400
Received: by mail-pl1-f194.google.com with SMTP id p16-v6so1296879plr.8
        for <linux-wireless@vger.kernel.org>; Fri, 02 Nov 2018 10:18:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vxrhorXX1I4QvppP0esrwgeopQAFC7+da941Yp0F+Tg=;
        b=Rjn4VI5fPWJytnOMb4Oj6XR7S0nwzDVRNwgoJyMmX2GczojuTlrJgVFu0DIjSu9gO9
         tmXq2e5KZqBPx2Kq1v9QOAHW79COqMmgHmmWKXithrpZt9vsdCgFfE+oCkOMb/jcgq9y
         PI2teqlVQ4DnKnSe5BRX2JHvJfNtwZftoE6Z0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vxrhorXX1I4QvppP0esrwgeopQAFC7+da941Yp0F+Tg=;
        b=X6yeAb5K9oTMZdvINSskuoyRrYqdUf9bfzSe4tZW5JKXpxkKrxdfjOaFibF9sYSZjs
         +pn9re884XJTAY9lC7avkOZd4QK83uuqzCv5LjVBZ1ZCCLc0LMfV12u8hmSoYhE6JPUe
         n+t/AfaEuJgM1iQ6JHeXA26/VOV40RVKJ7esEdkagwEpkv0WdyoZ+R1/+h9qkm3/hAiP
         hL20bqmfPhWBjxPglo2KyKM4AqaGFPHBJP8m6x2GS+JmW0Ro3R6Qy2dGF3XpuUElodlf
         jwzP6llvi5R39apm+baaVbB3gbIbNwmMg8NbH3EchSpTCsDqRQQOZBxHnqdglpJQeej2
         qy4Q==
X-Gm-Message-State: AGRZ1gK52HQUv6RFz2T23wObVRvyxN6/HDpmfbenS1nXxzt5yaajOK4M
        nagimrXHKwiAqzpYF3ptDf2eHg==
X-Google-Smtp-Source: AJdET5f9d82pLUTbT81Ulv+XX3x8SN/YI7w0S26HUFseQXn/kHBNtgvnwusVbdQmwBF+pRqr6lMiKg==
X-Received: by 2002:a17:902:9b84:: with SMTP id y4-v6mr12645436plp.332.1541179112291;
        Fri, 02 Nov 2018 10:18:32 -0700 (PDT)
Received: from smtp.gmail.com ([2620:15c:202:1:299d:6b87:5478:d28a])
        by smtp.gmail.com with ESMTPSA id d5-v6sm19222675pfo.131.2018.11.02.10.18.30
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 02 Nov 2018 10:18:31 -0700 (PDT)
From:   Brian Norris <briannorris@chromium.org>
To:     ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org,
        Rakesh Pillai <pillair@qti.qualcomm.com>,
        Govind Singh <govinds@qti.qualcomm.com>,
        <linux-kernel@vger.kernel.org>,
        Brian Norris <briannorris@chromium.org>
Subject: [PATCH 3/3] ath10k: fix struct init whitespace in SNOC driver
Date:   Fri,  2 Nov 2018 10:17:49 -0700
Message-Id: <20181102171749.38680-3-briannorris@chromium.org>
X-Mailer: git-send-email 2.19.1.930.g4563a0d9d0-goog
In-Reply-To: <20181102171749.38680-1-briannorris@chromium.org>
References: <20181102171749.38680-1-briannorris@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Signed-off-by: Brian Norris <briannorris@chromium.org>
---
 drivers/net/wireless/ath/ath10k/snoc.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/snoc.c b/drivers/net/wireless/ath/ath10k/snoc.c
index 8d3d9bca410f..ffdebf9a5ac6 100644
--- a/drivers/net/wireless/ath/ath10k/snoc.c
+++ b/drivers/net/wireless/ath/ath10k/snoc.c
@@ -1641,12 +1641,12 @@ static int ath10k_snoc_remove(struct platform_device *pdev)
 }
 
 static struct platform_driver ath10k_snoc_driver = {
-		.probe  = ath10k_snoc_probe,
-		.remove = ath10k_snoc_remove,
-		.driver = {
-			.name   = "ath10k_snoc",
-			.of_match_table = ath10k_snoc_dt_match,
-		},
+	.probe  = ath10k_snoc_probe,
+	.remove = ath10k_snoc_remove,
+	.driver = {
+		.name   = "ath10k_snoc",
+		.of_match_table = ath10k_snoc_dt_match,
+	},
 };
 module_platform_driver(ath10k_snoc_driver);
 
-- 
2.19.1.930.g4563a0d9d0-goog

