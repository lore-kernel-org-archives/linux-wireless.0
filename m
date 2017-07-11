Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:32959 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932729AbdGKObE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 11 Jul 2017 10:31:04 -0400
Received: by mail-pf0-f195.google.com with SMTP id e199so165148pfh.0
        for <linux-wireless@vger.kernel.org>; Tue, 11 Jul 2017 07:31:04 -0700 (PDT)
From: Amitkumar Karwar <amitkarwar@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Subject: [PATCH 1/3] rsi: use macro for allocating USB buffer
Date: Tue, 11 Jul 2017 19:57:51 +0530
Message-Id: <1499783273-15428-1-git-send-email-amitkarwar@gmail.com> (sfid-20170711_163108_592263_31D2AF22)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <amit.karwar@redpinesignals.com>

4 bytes is fixed size for reading or writing USB register. We
will use a macro instead of hardcoding this.

Fixes: b97e9b94ad75c ("rsi: Add new host interface operations")
Signed-off-by: Amitkumar Karwar <amit.karwar@redpinesignals.com>
---
 drivers/net/wireless/rsi/rsi_91x_usb.c | 4 ++--
 drivers/net/wireless/rsi/rsi_usb.h     | 1 +
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_usb.c b/drivers/net/wireless/rsi/rsi_91x_usb.c
index 3febf24..99a520a 100644
--- a/drivers/net/wireless/rsi/rsi_91x_usb.c
+++ b/drivers/net/wireless/rsi/rsi_91x_usb.c
@@ -162,7 +162,7 @@ static int rsi_usb_reg_read(struct usb_device *usbdev,
 	u8 *buf;
 	int status = -ENOMEM;
 
-	buf  = kmalloc(0x04, GFP_KERNEL);
+	buf  = kmalloc(RSI_USB_CTRL_BUF_SIZE, GFP_KERNEL);
 	if (!buf)
 		return status;
 
@@ -204,7 +204,7 @@ static int rsi_usb_reg_write(struct usb_device *usbdev,
 	u8 *usb_reg_buf;
 	int status = -ENOMEM;
 
-	usb_reg_buf  = kmalloc(0x04, GFP_KERNEL);
+	usb_reg_buf  = kmalloc(RSI_USB_CTRL_BUF_SIZE, GFP_KERNEL);
 	if (!usb_reg_buf)
 		return status;
 
diff --git a/drivers/net/wireless/rsi/rsi_usb.h b/drivers/net/wireless/rsi/rsi_usb.h
index 3babf81..891daea 100644
--- a/drivers/net/wireless/rsi/rsi_usb.h
+++ b/drivers/net/wireless/rsi/rsi_usb.h
@@ -37,6 +37,7 @@
 #define BT_EP                        2
 
 #define RSI_USB_BUF_SIZE	     4096
+#define RSI_USB_CTRL_BUF_SIZE	     0x04
 
 struct rsi_91x_usbdev {
 	struct rsi_thread rx_thread;
-- 
2.7.4
