Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f54.google.com ([209.85.160.54]:39730 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756889AbaDBCI0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Apr 2014 22:08:26 -0400
Received: by mail-pb0-f54.google.com with SMTP id ma3so10835516pbc.27
        for <linux-wireless@vger.kernel.org>; Tue, 01 Apr 2014 19:08:26 -0700 (PDT)
From: Fariya Fatima <fariyaf@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Fariya Fatima <fariyaf@gmail.com>
Subject: [PATCH 6/6] rsi: Fixed issue relating to doing dma on stack error.
Date: Wed,  2 Apr 2014 07:38:05 +0530
Message-Id: <1396404485-3989-7-git-send-email-fariyaf@gmail.com> (sfid-20140402_040830_886741_1B1C5EFD)
In-Reply-To: <1396404485-3989-1-git-send-email-fariyaf@gmail.com>
References: <1396404485-3989-1-git-send-email-fariyaf@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Fariya Fatima <fariyaf@gmail.com>

Signed-off-by: Fariya Fatima <fariyaf@gmail.com>
---
 drivers/net/wireless/rsi/rsi_91x_usb.c |   26 +++++++++++++++++++-------
 1 files changed, 19 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_usb.c b/drivers/net/wireless/rsi/rsi_91x_usb.c
index bb1bf96..4c46e56 100644
--- a/drivers/net/wireless/rsi/rsi_91x_usb.c
+++ b/drivers/net/wireless/rsi/rsi_91x_usb.c
@@ -154,24 +154,30 @@ static int rsi_usb_reg_read(struct usb_device *usbdev,
 			    u16 *value,
 			    u16 len)
 {
-	u8 temp_buf[4];
-	int status = 0;
+	u8 *buf;
+	int status = -ENOMEM;
+
+	buf  = kmalloc(0x04, GFP_KERNEL);
+	if (!buf)
+		return status;
 
 	status = usb_control_msg(usbdev,
 				 usb_rcvctrlpipe(usbdev, 0),
 				 USB_VENDOR_REGISTER_READ,
 				 USB_TYPE_VENDOR,
 				 ((reg & 0xffff0000) >> 16), (reg & 0xffff),
-				 (void *)temp_buf,
+				 (void *)buf,
 				 len,
 				 HZ * 5);
 
-	*value = (temp_buf[0] | (temp_buf[1] << 8));
+	*value = (buf[0] | (buf[1] << 8));
 	if (status < 0) {
 		rsi_dbg(ERR_ZONE,
 			"%s: Reg read failed with error code :%d\n",
 			__func__, status);
 	}
+	kfree(buf);
+
 	return status;
 }
 
@@ -190,8 +196,12 @@ static int rsi_usb_reg_write(struct usb_device *usbdev,
 			     u16 value,
 			     u16 len)
 {
-	u8 usb_reg_buf[4];
-	int status = 0;
+	u8 *usb_reg_buf;
+	int status = -ENOMEM;
+
+	usb_reg_buf  = kmalloc(0x04, GFP_KERNEL);
+	if (!usb_reg_buf)
+		return status;
 
 	usb_reg_buf[0] = (value & 0x00ff);
 	usb_reg_buf[1] = (value & 0xff00) >> 8;
@@ -212,6 +222,8 @@ static int rsi_usb_reg_write(struct usb_device *usbdev,
 			"%s: Reg write failed with error code :%d\n",
 			__func__, status);
 	}
+	kfree(usb_reg_buf);
+
 	return status;
 }
 
@@ -286,7 +298,7 @@ int rsi_usb_write_register_multiple(struct rsi_hw *adapter,
 		return -ENOMEM;
 
 	while (count) {
-		transfer = min_t(int, count, 4096);
+		transfer = (u8)(min_t(u32, count, 4096));
 		memcpy(buf, data, transfer);
 		status = usb_control_msg(dev->usbdev,
 					 usb_sndctrlpipe(dev->usbdev, 0),
-- 
1.7.5.4

