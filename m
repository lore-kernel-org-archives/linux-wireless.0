Return-Path: <SRS0=OUAD=SF=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13F38C4360F
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Apr 2019 04:13:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CE74E2084C
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Apr 2019 04:13:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GpiigFnF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726670AbfDCEN0 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 3 Apr 2019 00:13:26 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:42848 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726157AbfDCEN0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 3 Apr 2019 00:13:26 -0400
Received: by mail-pg1-f196.google.com with SMTP id p6so7608914pgh.9
        for <linux-wireless@vger.kernel.org>; Tue, 02 Apr 2019 21:13:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=+sEHGnOYz2cLvlolqiFPXNsyR5Q8ySCP/5Fd307ot9c=;
        b=GpiigFnFuL7MSoHMYfA5UZfN0XLyMq8jzGX8ICaXF06HQzT2800bn8PC3f1dto6b+O
         5f+6QXUYUTPqCFeYcSOyC1ArUyPTlsHW9aR7b7nlMGPLq/MJLI/JwfSH6Ca5vvrrRBiK
         85w4uX8wWd8uoCQSYMfnbXKIhdpul/j8gAhELpbl0W8rgMhxga7gdoQWoR5ZQtlVrhHh
         EYca4EMczqKtKG6oJ+jq5AHv4eJzL44i+6vsR86y12ulXRSL9lqH/pGhVCu+7ov9b1ki
         DKf2zcmM/oAP5tkUpBn8uUtvHmCg6s1vyWlVpRNRUeDny/YNr2nHQp4DpiR/6Q0Hol+n
         nKlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=+sEHGnOYz2cLvlolqiFPXNsyR5Q8ySCP/5Fd307ot9c=;
        b=FdmweVntipPsZJ8KI+yUm01c0xFxweM1QEvYyGxwTacgrtWSjXLQ997JNvBBxC/DXr
         +YMDdBlTHktDun7caPUhVD+4PiU2cMafQzD03Q8Z1uJH4nte0qEGPkRjoub+FB6JPr7U
         +nYOL19dEoExsFIY72qUUJYA4+rVHgyn8R0iHhvNqcdkZqPZYAXPdlb/OXB8r5U27Go4
         AINyVfZlpXcwFxe9sISiIbs9zOJrhWFlTIHgSRQsamF/5Hgwam9bWZ7rXTwsrYGBxEw9
         mhl2RN27jLOToVYO+1AF/yHXLD65RijvioSxSJA1K5PD+FNNVP/5JPKunMw1OwMjCBAo
         MI5A==
X-Gm-Message-State: APjAAAX60VLjorU4s4Cuu2zjqme3vMjc4st+2o8BaPj4OkjJhGP2T4z8
        gH9fiuC8QD+vsqSyI7UOZEVopXTtrMgR3MFL
X-Google-Smtp-Source: APXvYqwvDhxKEDXlq7opQ2Boj8+6wgvSvq5pfbXpIBYI+vOyB73zcWBtXuYZWyoW6WZhXdhVeaDF9w==
X-Received: by 2002:aa7:85d9:: with SMTP id z25mr62524251pfn.31.1554264804882;
        Tue, 02 Apr 2019 21:13:24 -0700 (PDT)
Received: from siva.domain.name ([123.201.77.78])
        by smtp.gmail.com with ESMTPSA id r3sm42290239pgb.82.2019.04.02.21.13.22
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 02 Apr 2019 21:13:24 -0700 (PDT)
From:   Siva Rebbagondla <siva8118@gmail.com>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org, amitkarwar@gmail.com,
        krishna.pedda@redpinesignals.com,
        Ganapathiraju Kondraju <ganapathi.kondraju@redpinesignals.com>,
        Siva Rebbagondla <siva8118@gmail.com>
Subject: [PATCH 1/8] rsi: add new device model for 9116
Date:   Wed,  3 Apr 2019 09:43:02 +0530
Message-Id: <20190403041309.12829-2-siva8118@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190403041309.12829-1-siva8118@gmail.com>
References: <20190403041309.12829-1-siva8118@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

9116 device id entry is added in both SDIO and USB interfaces.
New enumberation value taken for the device model. Based on the
device model detected run time, few device specific operations
needs to be performed.

adding rsi_dev_model to get device type in run time, as we can use
same driver for 9113 and 9116 except few firmware load changes.

Signed-off-by: Siva Rebbagondla <siva8118@gmail.com>
---
 drivers/net/wireless/rsi/rsi_91x_sdio.c | 19 +++++++++++++++++--
 drivers/net/wireless/rsi/rsi_91x_usb.c  | 15 ++++++++++++++-
 drivers/net/wireless/rsi/rsi_main.h     |  8 ++++++--
 drivers/net/wireless/rsi/rsi_sdio.h     |  3 ++-
 drivers/net/wireless/rsi/rsi_usb.h      |  3 ++-
 5 files changed, 41 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_sdio.c b/drivers/net/wireless/rsi/rsi_91x_sdio.c
index 3430d7a0899e..2f4bc25d93ca 100644
--- a/drivers/net/wireless/rsi/rsi_91x_sdio.c
+++ b/drivers/net/wireless/rsi/rsi_91x_sdio.c
@@ -949,7 +949,7 @@ static int rsi_probe(struct sdio_func *pfunction,
 {
 	struct rsi_hw *adapter;
 	struct rsi_91x_sdiodev *sdev;
-	int status;
+	int status = -EINVAL;
 
 	rsi_dbg(INIT_ZONE, "%s: Init function called\n", __func__);
 
@@ -968,6 +968,20 @@ static int rsi_probe(struct sdio_func *pfunction,
 		status = -EIO;
 		goto fail_free_adapter;
 	}
+
+	if (pfunction->device == RSI_SDIO_PID_9113) {
+		rsi_dbg(ERR_ZONE, "%s: 9113 module detected\n", __func__);
+		adapter->device_model = RSI_DEV_9113;
+	} else  if (pfunction->device == RSI_SDIO_PID_9116) {
+		rsi_dbg(ERR_ZONE, "%s: 9116 module detected\n", __func__);
+		adapter->device_model = RSI_DEV_9116;
+	} else {
+		rsi_dbg(ERR_ZONE,
+			"%s: Unsupported RSI device id 0x%x\n", __func__,
+			pfunction->device);
+		goto fail_free_adapter;
+	}
+
 	sdev = (struct rsi_91x_sdiodev *)adapter->rsi_dev;
 	rsi_init_event(&sdev->rx_thread.event);
 	status = rsi_create_kthread(adapter->priv, &sdev->rx_thread,
@@ -1415,7 +1429,8 @@ static const struct dev_pm_ops rsi_pm_ops = {
 #endif
 
 static const struct sdio_device_id rsi_dev_table[] =  {
-	{ SDIO_DEVICE(RSI_SDIO_VID_9113, RSI_SDIO_PID_9113) },
+	{ SDIO_DEVICE(RSI_SDIO_VENDOR_ID, RSI_SDIO_PID_9113) },
+	{ SDIO_DEVICE(RSI_SDIO_VENDOR_ID, RSI_SDIO_PID_9116) },
 	{ /* Blank */},
 };
 
diff --git a/drivers/net/wireless/rsi/rsi_91x_usb.c b/drivers/net/wireless/rsi/rsi_91x_usb.c
index ac0ef5ea6ffb..7d9b85925150 100644
--- a/drivers/net/wireless/rsi/rsi_91x_usb.c
+++ b/drivers/net/wireless/rsi/rsi_91x_usb.c
@@ -763,6 +763,18 @@ static int rsi_probe(struct usb_interface *pfunction,
 
 	rsi_dbg(ERR_ZONE, "%s: Initialized os intf ops\n", __func__);
 
+	if (id && id->idProduct == RSI_USB_PID_9113) {
+		rsi_dbg(INIT_ZONE, "%s: 9113 module detected\n", __func__);
+		adapter->device_model = RSI_DEV_9113;
+	} else if (id && id->idProduct == RSI_USB_PID_9116) {
+		rsi_dbg(INIT_ZONE, "%s: 9116 module detected\n", __func__);
+		adapter->device_model = RSI_DEV_9116;
+	} else {
+		rsi_dbg(ERR_ZONE, "%s: Unsupported RSI device id 0x%x\n",
+			__func__, id->idProduct);
+		goto err1;
+	}
+
 	dev = (struct rsi_91x_usbdev *)adapter->rsi_dev;
 
 	status = rsi_usb_reg_read(dev->usbdev, FW_STATUS_REG, &fw_status, 2);
@@ -845,7 +857,8 @@ static int rsi_resume(struct usb_interface *intf)
 #endif
 
 static const struct usb_device_id rsi_dev_table[] = {
-	{ USB_DEVICE(RSI_USB_VID_9113, RSI_USB_PID_9113) },
+	{ USB_DEVICE(RSI_USB_VENDOR_ID, RSI_USB_PID_9113) },
+	{ USB_DEVICE(RSI_USB_VENDOR_ID, RSI_USB_PID_9116) },
 	{ /* Blank */},
 };
 
diff --git a/drivers/net/wireless/rsi/rsi_main.h b/drivers/net/wireless/rsi/rsi_main.h
index 35d13f35e9b0..077cc97dbe6f 100644
--- a/drivers/net/wireless/rsi/rsi_main.h
+++ b/drivers/net/wireless/rsi/rsi_main.h
@@ -111,9 +111,13 @@ extern __printf(2, 3) void rsi_dbg(u32 zone, const char *fmt, ...);
 #define RSI_WOW_ENABLED			BIT(0)
 #define RSI_WOW_NO_CONNECTION		BIT(1)
 
-#define RSI_DEV_9113		1
 #define RSI_MAX_RX_PKTS		64
 
+enum rsi_dev_model {
+	RSI_DEV_9113 = 0,
+	RSI_DEV_9116
+};
+
 struct version_info {
 	u16 major;
 	u16 minor;
@@ -329,7 +333,7 @@ struct eeprom_read {
 
 struct rsi_hw {
 	struct rsi_common *priv;
-	u8 device_model;
+	enum rsi_dev_model device_model;
 	struct ieee80211_hw *hw;
 	struct ieee80211_vif *vifs[RSI_MAX_VIFS];
 	struct ieee80211_tx_queue_params edca_params[NUM_EDCA_QUEUES];
diff --git a/drivers/net/wireless/rsi/rsi_sdio.h b/drivers/net/wireless/rsi/rsi_sdio.h
index 66dcd2ec9051..838e929f7235 100644
--- a/drivers/net/wireless/rsi/rsi_sdio.h
+++ b/drivers/net/wireless/rsi/rsi_sdio.h
@@ -28,8 +28,9 @@
 #include <linux/mmc/sdio_ids.h>
 #include "rsi_main.h"
 
-#define RSI_SDIO_VID_9113    0x041B
+#define RSI_SDIO_VENDOR_ID   0x041B
 #define RSI_SDIO_PID_9113    0x9330
+#define RSI_SDIO_PID_9116    0x9116
 
 enum sdio_interrupt_type {
 	BUFFER_FULL         = 0x0,
diff --git a/drivers/net/wireless/rsi/rsi_usb.h b/drivers/net/wireless/rsi/rsi_usb.h
index 5b2eddd1a2ee..8702f434b569 100644
--- a/drivers/net/wireless/rsi/rsi_usb.h
+++ b/drivers/net/wireless/rsi/rsi_usb.h
@@ -22,8 +22,9 @@
 #include "rsi_main.h"
 #include "rsi_common.h"
 
-#define RSI_USB_VID_9113	0x1618
+#define RSI_USB_VENDOR_ID	0x1618
 #define RSI_USB_PID_9113	0x9113
+#define RSI_USB_PID_9116	0x9116
 
 #define USB_INTERNAL_REG_1           0x25000
 #define RSI_USB_READY_MAGIC_NUM      0xab
-- 
2.17.1

