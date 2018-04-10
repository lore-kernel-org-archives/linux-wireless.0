Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:40849 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754289AbeDJPBn (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 10 Apr 2018 11:01:43 -0400
Received: by mail-pf0-f194.google.com with SMTP id y66so8520022pfi.7
        for <linux-wireless@vger.kernel.org>; Tue, 10 Apr 2018 08:01:43 -0700 (PDT)
From: Siva Rebbagondla <siva8118@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>,
        Sushant Mishra <sushant.mishra@redpinesignals.com>
Subject: [v2 1/7] rsi: disable fw watchdog timer during reset
Date: Tue, 10 Apr 2018 20:34:11 +0530
Message-Id: <1523372657-6067-2-git-send-email-siva8118@gmail.com> (sfid-20180410_170149_148098_3CB6E78D)
In-Reply-To: <1523372657-6067-1-git-send-email-siva8118@gmail.com>
References: <1523372657-6067-1-git-send-email-siva8118@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <amit.karwar@redpinesignals.com>

Firmware's watchdog timer should be disabled as a part of reset
sequence. This change fixes a firmware hang issue observed during
stress tests.

Signed-off-by: Amitkumar Karwar <amit.karwar@redpinesignals.com>
Signed-off-by: Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>
---
 drivers/net/wireless/rsi/rsi_91x_usb.c | 7 +++++++
 drivers/net/wireless/rsi/rsi_hal.h     | 1 +
 drivers/net/wireless/rsi/rsi_usb.h     | 1 +
 3 files changed, 9 insertions(+)

diff --git a/drivers/net/wireless/rsi/rsi_91x_usb.c b/drivers/net/wireless/rsi/rsi_91x_usb.c
index 7b8bae3..b065438 100644
--- a/drivers/net/wireless/rsi/rsi_91x_usb.c
+++ b/drivers/net/wireless/rsi/rsi_91x_usb.c
@@ -687,6 +687,13 @@ static int rsi_reset_card(struct rsi_hw *adapter)
 	 */
 	msleep(100);
 
+	if (rsi_usb_master_reg_write(adapter, SWBL_REGOUT,
+				     RSI_FW_WDT_DISABLE_REQ,
+				     RSI_COMMON_REG_SIZE) < 0) {
+		rsi_dbg(ERR_ZONE, "Disabling firmware watchdog timer failed\n");
+		goto fail;
+	}
+
 	ret = usb_ulp_read_write(adapter, RSI_WATCH_DOG_TIMER_1,
 				 RSI_ULP_WRITE_2, 32);
 	if (ret < 0)
diff --git a/drivers/net/wireless/rsi/rsi_hal.h b/drivers/net/wireless/rsi/rsi_hal.h
index d6c2baa..327638c 100644
--- a/drivers/net/wireless/rsi/rsi_hal.h
+++ b/drivers/net/wireless/rsi/rsi_hal.h
@@ -115,6 +115,7 @@
 #define FW_FLASH_OFFSET			0x820
 #define LMAC_VER_OFFSET			(FW_FLASH_OFFSET + 0x200)
 #define MAX_DWORD_ALIGN_BYTES		64
+#define RSI_COMMON_REG_SIZE		2
 
 struct bl_header {
 	__le32 flags;
diff --git a/drivers/net/wireless/rsi/rsi_usb.h b/drivers/net/wireless/rsi/rsi_usb.h
index a88d592..b6fe79f 100644
--- a/drivers/net/wireless/rsi/rsi_usb.h
+++ b/drivers/net/wireless/rsi/rsi_usb.h
@@ -26,6 +26,7 @@
 #define RSI_USB_READY_MAGIC_NUM      0xab
 #define FW_STATUS_REG                0x41050012
 #define RSI_TA_HOLD_REG              0x22000844
+#define RSI_FW_WDT_DISABLE_REQ	     0x69
 
 #define USB_VENDOR_REGISTER_READ     0x15
 #define USB_VENDOR_REGISTER_WRITE    0x16
-- 
2.7.4
