Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:35176 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751462AbdEPKCx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 16 May 2017 06:02:53 -0400
Received: by mail-pg0-f67.google.com with SMTP id i63so20848914pgd.2
        for <linux-wireless@vger.kernel.org>; Tue, 16 May 2017 03:02:53 -0700 (PDT)
From: Amitkumar Karwar <amitkarwar@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>
Subject: [v3 03/11] rsi: define RSI_USB_BUF_SIZE macro
Date: Tue, 16 May 2017 15:31:09 +0530
Message-Id: <1494928877-27168-4-git-send-email-amit.karwar@redpinesignals.com> (sfid-20170516_120347_454062_1798108D)
In-Reply-To: <1494928877-27168-1-git-send-email-amit.karwar@redpinesignals.com>
References: <1494928877-27168-1-git-send-email-amit.karwar@redpinesignals.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

RSI_USB_BUF_SIZE macro is used instead of hardcoding a buffer
size to 4096.

Signed-off-by: Amitkumar Karwar <amit.karwar@redpinesignals.com>
---
v3: Newly added patch in v3
---
 drivers/net/wireless/rsi/rsi_91x_usb.c | 4 ++--
 drivers/net/wireless/rsi/rsi_usb.h     | 2 ++
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_usb.c b/drivers/net/wireless/rsi/rsi_91x_usb.c
index cc8deec..be8487c 100644
--- a/drivers/net/wireless/rsi/rsi_91x_usb.c
+++ b/drivers/net/wireless/rsi/rsi_91x_usb.c
@@ -293,12 +293,12 @@ int rsi_usb_write_register_multiple(struct rsi_hw *adapter,
 	u8 transfer;
 	int status = 0;
 
-	buf = kzalloc(4096, GFP_KERNEL);
+	buf = kzalloc(RSI_USB_BUF_SIZE, GFP_KERNEL);
 	if (!buf)
 		return -ENOMEM;
 
 	while (count) {
-		transfer = (u8)(min_t(u32, count, 4096));
+		transfer = (u8)(min_t(u32, count, RSI_USB_BUF_SIZE));
 		memcpy(buf, data, transfer);
 		status = usb_control_msg(dev->usbdev,
 					 usb_sndctrlpipe(dev->usbdev, 0),
diff --git a/drivers/net/wireless/rsi/rsi_usb.h b/drivers/net/wireless/rsi/rsi_usb.h
index ebea0c4..48c9211 100644
--- a/drivers/net/wireless/rsi/rsi_usb.h
+++ b/drivers/net/wireless/rsi/rsi_usb.h
@@ -35,6 +35,8 @@
 #define MGMT_EP                      1
 #define DATA_EP                      2
 
+#define RSI_USB_BUF_SIZE	     4096
+
 struct rsi_91x_usbdev {
 	struct rsi_thread rx_thread;
 	u8 endpoint;
-- 
2.7.4
