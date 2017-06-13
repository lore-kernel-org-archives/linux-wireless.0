Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:36026 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753697AbdFMOvq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 13 Jun 2017 10:51:46 -0400
Received: by mail-pf0-f193.google.com with SMTP id y7so21957841pfd.3
        for <linux-wireless@vger.kernel.org>; Tue, 13 Jun 2017 07:51:46 -0700 (PDT)
From: Amitkumar Karwar <amitkarwar@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org, Alexey.Brodkin@synopsys.com,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Karun Eagalapati <karun256@gmail.com>,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>
Subject: [PATCH 05/20] rsi: card reset for USB interface
Date: Tue, 13 Jun 2017 20:18:53 +0530
Message-Id: <1497365348-2305-6-git-send-email-amit.karwar@redpinesignals.com> (sfid-20170613_165149_642592_7C9C363D)
In-Reply-To: <1497365348-2305-1-git-send-email-amit.karwar@redpinesignals.com>
References: <1497365348-2305-1-git-send-email-amit.karwar@redpinesignals.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Karun Eagalapati <karun256@gmail.com>

We need to reset the chip in teardown path so that it can work
next time when driver is loaded. This patch adds support for this
reset configuration for USB.

Signed-off-by: Karun Eagalapati <karun256@gmail.com>
Signed-off-by: Amitkumar Karwar <amit.karwar@redpinesignals.com>
---
 drivers/net/wireless/rsi/rsi_91x_usb.c | 72 ++++++++++++++++++++++++++++++++++
 drivers/net/wireless/rsi/rsi_usb.h     |  1 +
 2 files changed, 73 insertions(+)

diff --git a/drivers/net/wireless/rsi/rsi_91x_usb.c b/drivers/net/wireless/rsi/rsi_91x_usb.c
index bcd7f45..1d7bb9d 100644
--- a/drivers/net/wireless/rsi/rsi_91x_usb.c
+++ b/drivers/net/wireless/rsi/rsi_91x_usb.c
@@ -558,6 +558,77 @@ static int rsi_init_usb_interface(struct rsi_hw *adapter,
 	return status;
 }
 
+static int usb_ulp_read_write(struct rsi_hw *adapter, u16 addr, u32 data,
+			      u16 len_in_bits)
+{
+	int ret;
+
+	ret = rsi_usb_master_reg_write
+			(adapter, RSI_GSPI_DATA_REG1,
+			 ((addr << 6) | ((data >> 16) & 0xffff)), 2);
+	if (ret < 0)
+		return ret;
+
+	ret = rsi_usb_master_reg_write(adapter, RSI_GSPI_DATA_REG0,
+				       (data & 0xffff), 2);
+	if (ret < 0)
+		return ret;
+
+	/* Initializing GSPI for ULP read/writes */
+	rsi_usb_master_reg_write(adapter, RSI_GSPI_CTRL_REG0,
+				 RSI_GSPI_CTRL_REG0_VALUE, 2);
+
+	ret = rsi_usb_master_reg_write(adapter, RSI_GSPI_CTRL_REG1,
+				       ((len_in_bits - 1) | RSI_GSPI_TRIG), 2);
+	if (ret < 0)
+		return ret;
+
+	msleep(20);
+
+	return 0;
+}
+
+static int rsi_reset_card(struct rsi_hw *adapter)
+{
+	int ret;
+
+	rsi_dbg(INFO_ZONE, "Resetting Card...\n");
+	rsi_usb_master_reg_write(adapter, RSI_TA_HOLD_REG, 0xE, 4);
+
+	/* This msleep will ensure Thread-Arch processor to go to hold
+	 * and any pending dma transfers to rf in device to finish.
+	 */
+	msleep(100);
+
+	ret = usb_ulp_read_write(adapter, RSI_WATCH_DOG_TIMER_1,
+				 RSI_ULP_WRITE_2, 32);
+	if (ret < 0)
+		goto fail;
+	ret = usb_ulp_read_write(adapter, RSI_WATCH_DOG_TIMER_2,
+				 RSI_ULP_WRITE_0, 32);
+	if (ret < 0)
+		goto fail;
+	ret = usb_ulp_read_write(adapter, RSI_WATCH_DOG_DELAY_TIMER_1,
+				 RSI_ULP_WRITE_50, 32);
+	if (ret < 0)
+		goto fail;
+	ret = usb_ulp_read_write(adapter, RSI_WATCH_DOG_DELAY_TIMER_2,
+				 RSI_ULP_WRITE_0, 32);
+	if (ret < 0)
+		goto fail;
+	ret = usb_ulp_read_write(adapter, RSI_WATCH_DOG_TIMER_ENABLE,
+				 RSI_ULP_TIMER_ENABLE, 32);
+	if (ret < 0)
+		goto fail;
+
+	rsi_dbg(INFO_ZONE, "Reset card done\n");
+	return ret;
+
+fail:
+	rsi_dbg(ERR_ZONE, "Reset card failed\n");
+	return ret;
+}
+
 /**
  * rsi_probe() - This function is called by kernel when the driver provided
  *		 Vendor and device IDs are matched. All the initialization
@@ -641,6 +712,7 @@ static void rsi_disconnect(struct usb_interface *pfunction)
 		return;
 
 	rsi_mac80211_detach(adapter);
+	rsi_reset_card(adapter);
 	rsi_deinit_usb_interface(adapter);
 	rsi_91x_deinit(adapter);
 
diff --git a/drivers/net/wireless/rsi/rsi_usb.h b/drivers/net/wireless/rsi/rsi_usb.h
index 59513ac..2c5c0e7 100644
--- a/drivers/net/wireless/rsi/rsi_usb.h
+++ b/drivers/net/wireless/rsi/rsi_usb.h
@@ -25,6 +25,7 @@
 #define USB_INTERNAL_REG_1           0x25000
 #define RSI_USB_READY_MAGIC_NUM      0xab
 #define FW_STATUS_REG                0x41050012
+#define RSI_TA_HOLD_REG              0x22000844
 
 #define USB_VENDOR_REGISTER_READ     0x15
 #define USB_VENDOR_REGISTER_WRITE    0x16
-- 
2.7.4
