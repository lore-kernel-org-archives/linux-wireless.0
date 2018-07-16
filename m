Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:39817 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727313AbeGPODj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 16 Jul 2018 10:03:39 -0400
Received: by mail-pf0-f196.google.com with SMTP id j8-v6so1664242pff.6
        for <linux-wireless@vger.kernel.org>; Mon, 16 Jul 2018 06:36:10 -0700 (PDT)
From: Siva Rebbagondla <siva8118@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Sushant Kumar Mishra <sushant.mishra@redpinesignals.com>,
        Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>,
        Amol Hanwate <amol.hanwate@redpinesignals.com>
Subject: [PATCH 1/6] rsi: remove redundant device ids
Date: Mon, 16 Jul 2018 19:09:32 +0530
Message-Id: <1531748377-29215-2-git-send-email-siva8118@gmail.com> (sfid-20180716_153613_273351_7FC43DEB)
In-Reply-To: <1531748377-29215-1-git-send-email-siva8118@gmail.com>
References: <1531748377-29215-1-git-send-email-siva8118@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>

Removing redundant device id's from both usb and sdio idtables, as rsi
driver currently supporting only one module(RS9113). Also, replaced ids
with specific defines.

Signed-off-by: Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>
---
 drivers/net/wireless/rsi/rsi_91x_sdio.c | 5 +----
 drivers/net/wireless/rsi/rsi_91x_usb.c  | 6 +-----
 drivers/net/wireless/rsi/rsi_sdio.h     | 3 +++
 drivers/net/wireless/rsi/rsi_usb.h      | 3 +++
 4 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_sdio.c b/drivers/net/wireless/rsi/rsi_91x_sdio.c
index 416981d..5733e44 100644
--- a/drivers/net/wireless/rsi/rsi_91x_sdio.c
+++ b/drivers/net/wireless/rsi/rsi_91x_sdio.c
@@ -1394,10 +1394,7 @@ static const struct dev_pm_ops rsi_pm_ops = {
 #endif
 
 static const struct sdio_device_id rsi_dev_table[] =  {
-	{ SDIO_DEVICE(0x303, 0x100) },
-	{ SDIO_DEVICE(0x041B, 0x0301) },
-	{ SDIO_DEVICE(0x041B, 0x0201) },
-	{ SDIO_DEVICE(0x041B, 0x9330) },
+	{ SDIO_DEVICE(RSI_SDIO_VID_9113, RSI_SDIO_PID_9113) },
 	{ /* Blank */},
 };
 
diff --git a/drivers/net/wireless/rsi/rsi_91x_usb.c b/drivers/net/wireless/rsi/rsi_91x_usb.c
index 6ce6b75..c0a163e 100644
--- a/drivers/net/wireless/rsi/rsi_91x_usb.c
+++ b/drivers/net/wireless/rsi/rsi_91x_usb.c
@@ -835,11 +835,7 @@ static int rsi_resume(struct usb_interface *intf)
 #endif
 
 static const struct usb_device_id rsi_dev_table[] = {
-	{ USB_DEVICE(0x0303, 0x0100) },
-	{ USB_DEVICE(0x041B, 0x0301) },
-	{ USB_DEVICE(0x041B, 0x0201) },
-	{ USB_DEVICE(0x041B, 0x9330) },
-	{ USB_DEVICE(0x1618, 0x9113) },
+	{ USB_DEVICE(RSI_USB_VID_9113, RSI_USB_PID_9113) },
 	{ /* Blank */},
 };
 
diff --git a/drivers/net/wireless/rsi/rsi_sdio.h b/drivers/net/wireless/rsi/rsi_sdio.h
index 353dbdf..66dcd2e 100644
--- a/drivers/net/wireless/rsi/rsi_sdio.h
+++ b/drivers/net/wireless/rsi/rsi_sdio.h
@@ -28,6 +28,9 @@
 #include <linux/mmc/sdio_ids.h>
 #include "rsi_main.h"
 
+#define RSI_SDIO_VID_9113    0x041B
+#define RSI_SDIO_PID_9113    0x9330
+
 enum sdio_interrupt_type {
 	BUFFER_FULL         = 0x0,
 	BUFFER_AVAILABLE    = 0x2,
diff --git a/drivers/net/wireless/rsi/rsi_usb.h b/drivers/net/wireless/rsi/rsi_usb.h
index b6fe79f..5b2eddd 100644
--- a/drivers/net/wireless/rsi/rsi_usb.h
+++ b/drivers/net/wireless/rsi/rsi_usb.h
@@ -22,6 +22,9 @@
 #include "rsi_main.h"
 #include "rsi_common.h"
 
+#define RSI_USB_VID_9113	0x1618
+#define RSI_USB_PID_9113	0x9113
+
 #define USB_INTERNAL_REG_1           0x25000
 #define RSI_USB_READY_MAGIC_NUM      0xab
 #define FW_STATUS_REG                0x41050012
-- 
2.5.5
