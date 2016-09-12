Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f66.google.com ([209.85.220.66]:35331 "EHLO
        mail-pa0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757504AbcILJny (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 12 Sep 2016 05:43:54 -0400
Received: by mail-pa0-f66.google.com with SMTP id pp5so7548900pac.2
        for <linux-wireless@vger.kernel.org>; Mon, 12 Sep 2016 02:43:54 -0700 (PDT)
From: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
To: linux-wireless@vger.kernel.org, kvalo@codeaurora.org,
        johannes.berg@intel.com, hofrat@osadl.org
Cc: prameela.j04cs@gmail.com, prameela.garnepudi@redpinesignals.com
Subject: [PATCH 8/9] rsi: code clean up and replaced ctrl message timeouts with macros in file rsi_91x_usb.c
Date: Mon, 12 Sep 2016 15:08:23 +0530
Message-Id: <340487567235056703e4c97170c63cb719fa5460.1473669618.git.prameela.j04cs@gmail.com> (sfid-20160912_114357_800607_A40EB7BF)
In-Reply-To: <cover.1473669618.git.prameela.j04cs@gmail.com>
References: <cover.1473669618.git.prameela.j04cs@gmail.com>
In-Reply-To: <cover.1473669618.git.prameela.j04cs@gmail.com>
References: <cover.1473669618.git.prameela.j04cs@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
---
 drivers/net/wireless/rsi/rsi_91x_usb.c | 42 +++++++++++++++++++---------------
 1 file changed, 23 insertions(+), 19 deletions(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_usb.c b/drivers/net/wireless/rsi/rsi_91x_usb.c
index ef5d394..21957dd 100644
--- a/drivers/net/wireless/rsi/rsi_91x_usb.c
+++ b/drivers/net/wireless/rsi/rsi_91x_usb.c
@@ -1,6 +1,9 @@
 /**
  * Copyright (c) 2014 Redpine Signals Inc.
  *
+ * Developers:
+ *	Prameela Rani Garnepudi	2016 <prameela.garnepudi@redpinesignals.com>
+ *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
  * copyright notice and this permission notice appear in all copies.
@@ -19,7 +22,7 @@
 #include "rsi_usb.h"
 
 /**
- * rsi_usb_card_write() - This function writes to the USB Card.
+ * rsi_usb_card_write() - This function writes data to the USB Card.
  * @adapter: Pointer to the adapter structure.
  * @buf: Pointer to the buffer from where the data has to be taken.
  * @len: Length to be written.
@@ -34,7 +37,7 @@ static int rsi_usb_card_write(struct rsi_hw *adapter,
 {
 	struct rsi_91x_usbdev *dev = (struct rsi_91x_usbdev *)adapter->rsi_dev;
 	int status;
-	s32 transfer;
+	int transfer;
 
 	status = usb_bulk_msg(dev->usbdev,
 			      usb_sndbulkpipe(dev->usbdev,
@@ -46,7 +49,7 @@ static int rsi_usb_card_write(struct rsi_hw *adapter,
 
 	if (status < 0) {
 		rsi_dbg(ERR_ZONE,
-			"Card write failed with error code :%10d\n", status);
+			"Card write failed with error code :%d\n", status);
 		dev->write_fail = 1;
 	}
 	return status;
@@ -155,11 +158,11 @@ static int rsi_usb_reg_read(struct usb_device *usbdev,
 			    u16 len)
 {
 	u8 *buf;
-	int status = -ENOMEM;
+	int status = 0;
 
 	buf  = kmalloc(0x04, GFP_KERNEL);
 	if (!buf)
-		return status;
+		return -ENOMEM;
 
 	status = usb_control_msg(usbdev,
 				 usb_rcvctrlpipe(usbdev, 0),
@@ -168,7 +171,7 @@ static int rsi_usb_reg_read(struct usb_device *usbdev,
 				 ((reg & 0xffff0000) >> 16), (reg & 0xffff),
 				 (void *)buf,
 				 len,
-				 HZ * 5);
+				 USB_CTRL_GET_TIMEOUT);
 
 	*value = (buf[0] | (buf[1] << 8));
 	if (status < 0) {
@@ -197,11 +200,11 @@ static int rsi_usb_reg_write(struct usb_device *usbdev,
 			     u16 len)
 {
 	u8 *usb_reg_buf;
-	int status = -ENOMEM;
+	int status = 0;
 
 	usb_reg_buf  = kmalloc(0x04, GFP_KERNEL);
 	if (!usb_reg_buf)
-		return status;
+		return -ENOMEM;
 
 	usb_reg_buf[0] = (value & 0x00ff);
 	usb_reg_buf[1] = (value & 0xff00) >> 8;
@@ -216,7 +219,7 @@ static int rsi_usb_reg_write(struct usb_device *usbdev,
 				 (reg & 0xffff),
 				 (void *)usb_reg_buf,
 				 len,
-				 HZ * 5);
+				 USB_CTRL_SET_TIMEOUT);
 	if (status < 0) {
 		rsi_dbg(ERR_ZONE,
 			"%s: Reg write failed with error code :%d\n",
@@ -275,11 +278,11 @@ static int rsi_rx_urb_submit(struct rsi_hw *adapter)
 
 /**
  * rsi_usb_write_register_multiple() - This function writes multiple bytes of
- *				       information to multiple registers.
- * @adapter: Pointer to the adapter structure.
- * @addr: Address of the register.
- * @data: Pointer to the data that has to be written.
- * @count: Number of multiple bytes to be written on to the registers.
+ *				       information to the given address.
+ * @adapter:	Pointer to the adapter structure.
+ * @addr:	Address of the register.
+ * @data:	Pointer to the data that has to be written.
+ * @count:	Number of multiple bytes to be written on to the registers.
  *
  * Return: status: 0 on success, a negative error code on failure.
  */
@@ -308,16 +311,17 @@ int rsi_usb_write_register_multiple(struct rsi_hw *adapter,
 					 (addr & 0xffff),
 					 (void *)buf,
 					 transfer,
-					 HZ * 5);
+					 USB_CTRL_SET_TIMEOUT);
 		if (status < 0) {
 			rsi_dbg(ERR_ZONE,
 				"Reg write failed with error code :%d\n",
 				status);
-		} else {
-			count -= transfer;
-			data += transfer;
-			addr += transfer;
+			kfree(buf);
+			return status;
 		}
+		count -= transfer;
+		data += transfer;
+		addr += transfer;
 	}
 
 	kfree(buf);
-- 
2.4.11
