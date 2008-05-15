Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mba.ocn.ne.jp ([122.1.235.107]:54417 "EHLO smtp.mba.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750830AbYEOPh2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 May 2008 11:37:28 -0400
Date: Fri, 16 May 2008 00:12:15 +0900 (JST)
Message-Id: <20080516.001215.39152691.anemo@mba.ocn.ne.jp> (sfid-20080515_173732_220655_C9E56A59)
To: Daniel Drake <dsd@gentoo.org>, Ulrich Kunitz <kune@deine-taler.de>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] zd1211rw: Use DMA-aware buffer for usb transfer
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The zd1211rw driver uses unaligned stack buffer for USB control
message.  But it might cause stack corruption on non-coherent
platform, such as MIPS.  Use DMA-aware buffers for USB transfer.

Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
---
 drivers/net/wireless/zd1211rw/zd_usb.c |   20 ++++++++++++++------
 1 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/zd1211rw/zd_usb.c b/drivers/net/wireless/zd1211rw/zd_usb.c
index 12e24f0..fbacfe4 100644
--- a/drivers/net/wireless/zd1211rw/zd_usb.c
+++ b/drivers/net/wireless/zd1211rw/zd_usb.c
@@ -172,7 +172,7 @@ static int upload_code(struct usb_device *udev,
 		r = usb_control_msg(udev, usb_rcvctrlpipe(udev, 0),
 			USB_REQ_FIRMWARE_CONFIRM,
 			USB_DIR_IN | USB_TYPE_VENDOR,
-			0, 0, &ret, sizeof(ret), 5000 /* ms */);
+			0, 0, p, sizeof(ret), 5000 /* ms */);
 		if (r != sizeof(ret)) {
 			dev_err(&udev->dev,
 				"control request firmeware confirmation failed."
@@ -181,6 +181,7 @@ static int upload_code(struct usb_device *udev,
 				r = -ENODEV;
 			goto error;
 		}
+		ret = p[0];
 		if (ret & 0x80) {
 			dev_err(&udev->dev,
 				"Internal error while downloading."
@@ -312,22 +313,29 @@ int zd_usb_read_fw(struct zd_usb *usb, zd_addr_t addr, u8 *data, u16 len)
 {
 	int r;
 	struct usb_device *udev = zd_usb_to_usbdev(usb);
+	u8 *buf = kmalloc(len, GFP_KERNEL);
 
+	if (!buf)
+		return -ENOMEM;
 	r = usb_control_msg(udev, usb_rcvctrlpipe(udev, 0),
 		USB_REQ_FIRMWARE_READ_DATA, USB_DIR_IN | 0x40, addr, 0,
-		data, len, 5000);
+		buf, len, 5000);
 	if (r < 0) {
 		dev_err(&udev->dev,
 			"read over firmware interface failed: %d\n", r);
-		return r;
+		goto exit;
 	} else if (r != len) {
 		dev_err(&udev->dev,
 			"incomplete read over firmware interface: %d/%d\n",
 			r, len);
-		return -EIO;
+		r = -EIO;
+		goto exit;
 	}
-
-	return 0;
+	r = 0;
+	memcpy(data, buf, len);
+exit:
+	kfree(buf);
+	return r;
 }
 
 #define urb_dev(urb) (&(urb)->dev->dev)
