Return-Path: <SRS0=OUAD=SF=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28A16C4360F
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Apr 2019 04:13:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E1A332084C
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Apr 2019 04:13:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lIM042Rz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727074AbfDCENl (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 3 Apr 2019 00:13:41 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:40159 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726245AbfDCENl (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 3 Apr 2019 00:13:41 -0400
Received: by mail-pf1-f195.google.com with SMTP id c207so7469135pfc.7
        for <linux-wireless@vger.kernel.org>; Tue, 02 Apr 2019 21:13:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=b3AQPr73/M6BOJOJFvexFFcTQAPsKqGUU3t/QQimKwE=;
        b=lIM042RzPnKKnPEKycR1N6Apny233i9z6C6Oe9ycw0iHtisqBA9g1Os4uFpcpjAm+v
         hpNoG9qQQG2tMi/kIb0wxOKZeHT1CYXCo6xzr6el9yYRTXuBf9vSNrMNQWcjjYpMSPEd
         J6o3SAWWK0Go0SWqWTN41sd4U2ya+1h2Xru4U1Np457JJ7n2DTvyWEVGDzlF/A765/Rn
         wx3ZLXRxYcs4GK4RM3qa/vSJo6n+KiS2rDW4Ba1ZIew7wZ/C4Gn1QgVHmhQ0It40Ig2b
         wDCQbpJK2UxJr1UcSJxibfN9Zdcqv45y2ywjMWWXtA2e/0NN3PeuTY+TKMFtzyjlxYon
         zxsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=b3AQPr73/M6BOJOJFvexFFcTQAPsKqGUU3t/QQimKwE=;
        b=KP+XmbU4Unxk3+J3XNbm3iU13vtkac+PD6/3q7KIBUYhNqjHHA/WFsb6lGxj5gFmG9
         gJYYAYkXqDp56o4wh40r5tQmQNnmNwv1C5pqBJVcOqoY1ZfZbVC99TD+ZK47TfJM6f3J
         PSHjbwM1r3i3f10ZY9O02b/KNnyEArddLHddb/+F0tzqY93B/UukOqDhFh1zpw4iv6iQ
         nW06wSgUr9jcH+DviTaQFMSUcrkTrbdJTtiJ9eoaChyTUaCb50Fu0jyXHHo2B8Tt0IGv
         NHY3FDwbvSsHUsXyItCs21FgCO0dVD1zvcofRdGU8AlLcbOye48GPI1xM9qAT/k5R7wm
         QWaA==
X-Gm-Message-State: APjAAAXVHl1zOWhgx1qqn6x41JmEQfomPKVTdXZV4pFvrMqyIQZnAu3b
        4GslBlm9ehGd66LW6Teg0cOa91VN3GPXCIDX
X-Google-Smtp-Source: APXvYqwEmO/4QQUJUbJulmemmFjPZrWouvkv16MR2/OKOguuZCbJaHaALy72OZBWGlKjjrmBD6qFTg==
X-Received: by 2002:a63:8548:: with SMTP id u69mr70274066pgd.85.1554264820271;
        Tue, 02 Apr 2019 21:13:40 -0700 (PDT)
Received: from siva.domain.name ([123.201.77.78])
        by smtp.gmail.com with ESMTPSA id r3sm42290239pgb.82.2019.04.02.21.13.37
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 02 Apr 2019 21:13:39 -0700 (PDT)
From:   Siva Rebbagondla <siva8118@gmail.com>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org, amitkarwar@gmail.com,
        krishna.pedda@redpinesignals.com,
        Ganapathiraju Kondraju <ganapathi.kondraju@redpinesignals.com>,
        Siva Rebbagondla <siva8118@gmail.com>
Subject: [PATCH 7/8] rsi: reset device changes for 9116
Date:   Wed,  3 Apr 2019 09:43:08 +0530
Message-Id: <20190403041309.12829-8-siva8118@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190403041309.12829-1-siva8118@gmail.com>
References: <20190403041309.12829-1-siva8118@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Device reset register(watchdog timer related) addresses and
values are different for 9116.

Signed-off-by: Siva Rebbagondla <siva8118@gmail.com>
---
 drivers/net/wireless/rsi/rsi_91x_sdio.c | 45 ++++++++++++++----
 drivers/net/wireless/rsi/rsi_91x_usb.c  | 61 +++++++++++++++++--------
 drivers/net/wireless/rsi/rsi_hal.h      | 15 ++++++
 3 files changed, 91 insertions(+), 30 deletions(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_sdio.c b/drivers/net/wireless/rsi/rsi_91x_sdio.c
index e9a2af0a1a80..f9c67ed473d1 100644
--- a/drivers/net/wireless/rsi/rsi_91x_sdio.c
+++ b/drivers/net/wireless/rsi/rsi_91x_sdio.c
@@ -1167,16 +1167,41 @@ static void rsi_reset_chip(struct rsi_hw *adapter)
 	 * and any pending dma transfers to rf spi in device to finish.
 	 */
 	msleep(100);
-
-	ulp_read_write(adapter, RSI_ULP_RESET_REG, RSI_ULP_WRITE_0, 32);
-	ulp_read_write(adapter, RSI_WATCH_DOG_TIMER_1, RSI_ULP_WRITE_2, 32);
-	ulp_read_write(adapter, RSI_WATCH_DOG_TIMER_2, RSI_ULP_WRITE_0, 32);
-	ulp_read_write(adapter, RSI_WATCH_DOG_DELAY_TIMER_1, RSI_ULP_WRITE_50,
-		       32);
-	ulp_read_write(adapter, RSI_WATCH_DOG_DELAY_TIMER_2, RSI_ULP_WRITE_0,
-		       32);
-	ulp_read_write(adapter, RSI_WATCH_DOG_TIMER_ENABLE,
-		       RSI_ULP_TIMER_ENABLE, 32);
+	if (adapter->device_model != RSI_DEV_9116) {
+		ulp_read_write(adapter, RSI_ULP_RESET_REG, RSI_ULP_WRITE_0, 32);
+		ulp_read_write(adapter,
+			       RSI_WATCH_DOG_TIMER_1, RSI_ULP_WRITE_2, 32);
+		ulp_read_write(adapter, RSI_WATCH_DOG_TIMER_2, RSI_ULP_WRITE_0,
+			       32);
+		ulp_read_write(adapter, RSI_WATCH_DOG_DELAY_TIMER_1,
+			       RSI_ULP_WRITE_50, 32);
+		ulp_read_write(adapter, RSI_WATCH_DOG_DELAY_TIMER_2,
+			       RSI_ULP_WRITE_0, 32);
+		ulp_read_write(adapter, RSI_WATCH_DOG_TIMER_ENABLE,
+			       RSI_ULP_TIMER_ENABLE, 32);
+	} else {
+		if ((rsi_sdio_master_reg_write(adapter,
+					       NWP_WWD_INTERRUPT_TIMER,
+					       NWP_WWD_INT_TIMER_CLKS,
+					       RSI_9116_REG_SIZE)) < 0) {
+			rsi_dbg(ERR_ZONE, "Failed to write to intr timer\n");
+		}
+		if ((rsi_sdio_master_reg_write(adapter,
+					       NWP_WWD_SYSTEM_RESET_TIMER,
+					       NWP_WWD_SYS_RESET_TIMER_CLKS,
+					       RSI_9116_REG_SIZE)) < 0) {
+			rsi_dbg(ERR_ZONE,
+				"Failed to write to system reset timer\n");
+		}
+		if ((rsi_sdio_master_reg_write(adapter,
+					       NWP_WWD_MODE_AND_RSTART,
+					       NWP_WWD_TIMER_DISABLE,
+					       RSI_9116_REG_SIZE)) < 0) {
+			rsi_dbg(ERR_ZONE,
+				"Failed to write to mode and restart\n");
+		}
+		rsi_dbg(ERR_ZONE, "***** Watch Dog Reset Successful *****\n");
+	}
 	/* This msleep will be sufficient for the ulp
 	 * read write operations to complete for chip reset.
 	 */
diff --git a/drivers/net/wireless/rsi/rsi_91x_usb.c b/drivers/net/wireless/rsi/rsi_91x_usb.c
index 7d9b85925150..f0475b20f153 100644
--- a/drivers/net/wireless/rsi/rsi_91x_usb.c
+++ b/drivers/net/wireless/rsi/rsi_91x_usb.c
@@ -698,26 +698,47 @@ static int rsi_reset_card(struct rsi_hw *adapter)
 		goto fail;
 	}
 
-	ret = usb_ulp_read_write(adapter, RSI_WATCH_DOG_TIMER_1,
-				 RSI_ULP_WRITE_2, 32);
-	if (ret < 0)
-		goto fail;
-	ret = usb_ulp_read_write(adapter, RSI_WATCH_DOG_TIMER_2,
-				 RSI_ULP_WRITE_0, 32);
-	if (ret < 0)
-		goto fail;
-	ret = usb_ulp_read_write(adapter, RSI_WATCH_DOG_DELAY_TIMER_1,
-				 RSI_ULP_WRITE_50, 32);
-	if (ret < 0)
-		goto fail;
-	ret = usb_ulp_read_write(adapter, RSI_WATCH_DOG_DELAY_TIMER_2,
-				 RSI_ULP_WRITE_0, 32);
-	if (ret < 0)
-		goto fail;
-	ret = usb_ulp_read_write(adapter, RSI_WATCH_DOG_TIMER_ENABLE,
-				 RSI_ULP_TIMER_ENABLE, 32);
-	if (ret < 0)
-		goto fail;
+	if (adapter->device_model != RSI_DEV_9116) {
+		ret = usb_ulp_read_write(adapter, RSI_WATCH_DOG_TIMER_1,
+					 RSI_ULP_WRITE_2, 32);
+		if (ret < 0)
+			goto fail;
+		ret = usb_ulp_read_write(adapter, RSI_WATCH_DOG_TIMER_2,
+					 RSI_ULP_WRITE_0, 32);
+		if (ret < 0)
+			goto fail;
+		ret = usb_ulp_read_write(adapter, RSI_WATCH_DOG_DELAY_TIMER_1,
+					 RSI_ULP_WRITE_50, 32);
+		if (ret < 0)
+			goto fail;
+		ret = usb_ulp_read_write(adapter, RSI_WATCH_DOG_DELAY_TIMER_2,
+					 RSI_ULP_WRITE_0, 32);
+		if (ret < 0)
+			goto fail;
+		ret = usb_ulp_read_write(adapter, RSI_WATCH_DOG_TIMER_ENABLE,
+					 RSI_ULP_TIMER_ENABLE, 32);
+		if (ret < 0)
+			goto fail;
+	} else {
+		if ((rsi_usb_master_reg_write(adapter,
+					      NWP_WWD_INTERRUPT_TIMER,
+					      NWP_WWD_INT_TIMER_CLKS,
+					      RSI_9116_REG_SIZE)) < 0) {
+			goto fail;
+		}
+		if ((rsi_usb_master_reg_write(adapter,
+					      NWP_WWD_SYSTEM_RESET_TIMER,
+					      NWP_WWD_SYS_RESET_TIMER_CLKS,
+					      RSI_9116_REG_SIZE)) < 0) {
+			goto fail;
+		}
+		if ((rsi_usb_master_reg_write(adapter,
+					      NWP_WWD_MODE_AND_RSTART,
+					      NWP_WWD_TIMER_DISABLE,
+					      RSI_9116_REG_SIZE)) < 0) {
+			goto fail;
+		}
+	}
 
 	rsi_dbg(INFO_ZONE, "Reset card done\n");
 	return ret;
diff --git a/drivers/net/wireless/rsi/rsi_hal.h b/drivers/net/wireless/rsi/rsi_hal.h
index c07b1a006d3f..46e36df9e8e3 100644
--- a/drivers/net/wireless/rsi/rsi_hal.h
+++ b/drivers/net/wireless/rsi/rsi_hal.h
@@ -70,6 +70,21 @@
 #define RSI_WATCH_DOG_DELAY_TIMER_2		0x16f
 #define RSI_WATCH_DOG_TIMER_ENABLE		0x170
 
+/* Watchdog timer addresses for 9116 */
+#define NWP_AHB_BASE_ADDR		0x41300000
+#define NWP_WWD_INTERRUPT_TIMER		(NWP_AHB_BASE_ADDR + 0x300)
+#define NWP_WWD_SYSTEM_RESET_TIMER	(NWP_AHB_BASE_ADDR + 0x304)
+#define NWP_WWD_WINDOW_TIMER		(NWP_AHB_BASE_ADDR + 0x308)
+#define NWP_WWD_TIMER_SETTINGS		(NWP_AHB_BASE_ADDR + 0x30C)
+#define NWP_WWD_MODE_AND_RSTART		(NWP_AHB_BASE_ADDR + 0x310)
+#define NWP_WWD_RESET_BYPASS		(NWP_AHB_BASE_ADDR + 0x314)
+#define NWP_FSM_INTR_MASK_REG		(NWP_AHB_BASE_ADDR + 0x104)
+
+/* Watchdog timer values */
+#define NWP_WWD_INT_TIMER_CLKS		5
+#define NWP_WWD_SYS_RESET_TIMER_CLKS	4
+#define NWP_WWD_TIMER_DISABLE		0xAA0001
+
 #define RSI_ULP_WRITE_0			00
 #define RSI_ULP_WRITE_2			02
 #define RSI_ULP_WRITE_50		50
-- 
2.17.1

