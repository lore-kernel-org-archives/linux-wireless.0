Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:56199 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751096AbXIAEeV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Sep 2007 00:34:21 -0400
Received: from dv.roinet.com (static-72-92-88-10.phlapa.fios.verizon.net [72.92.88.10])
	by relay.cesmail.net (Postfix) with ESMTP id CEDFF618FE1
	for <linux-wireless@vger.kernel.org>; Sat,  1 Sep 2007 00:34:20 -0400 (EDT)
From: Pavel Roskin <proski@gnu.org>
Subject: [PATCH 01/35] Protect at76_get_op_mode() and at76_get_mib() against  short reads
To: linux-wireless@vger.kernel.org
Date: Sat, 01 Sep 2007 00:34:20 -0400
Message-ID: <20070901043420.2498.30002.stgit@dv.roinet.com>
In-Reply-To: <20070901043233.2498.95850.stgit@dv.roinet.com>
References: <20070901043233.2498.95850.stgit@dv.roinet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Don't rely on usb_control_msg() returning -EPIPE in absence of working
firmware.  In some cases, no error is returned, but no data is read.

Interpret short reads as an error, return -EIO.

Signed-off-by: Pavel Roskin <proski@gnu.org>
---

 drivers/net/wireless/at76_usb.c |   18 +++++++++++++-----
 1 files changed, 13 insertions(+), 5 deletions(-)


diff --git a/drivers/net/wireless/at76_usb.c b/drivers/net/wireless/at76_usb.c
index d5e939e..f2a74d4 100644
--- a/drivers/net/wireless/at76_usb.c
+++ b/drivers/net/wireless/at76_usb.c
@@ -578,7 +578,10 @@ static int at76_get_op_mode(struct usb_device *udev)
 			      USB_CTRL_GET_TIMEOUT);
 	if (ret < 0)
 		return ret;
-	return op_mode;
+	else if (ret < 1)
+		return -EIO;
+	else
+		return op_mode;
 }
 
 /* Load a block of the second ("external") part of the firmware */
@@ -695,10 +698,15 @@ static struct reg_domain const *at76_get_reg_domain(u16 code)
 static inline int at76_get_mib(struct usb_device *udev, u16 mib, void *buf,
 			       int buf_size)
 {
-	return usb_control_msg(udev, usb_rcvctrlpipe(udev, 0), 0x33,
-			       USB_TYPE_VENDOR | USB_DIR_IN |
-			       USB_RECIP_INTERFACE, mib << 8, 0, buf, buf_size,
-			       USB_CTRL_GET_TIMEOUT);
+	int ret;
+
+	ret = usb_control_msg(udev, usb_rcvctrlpipe(udev, 0), 0x33,
+			      USB_TYPE_VENDOR | USB_DIR_IN |
+			      USB_RECIP_INTERFACE, mib << 8, 0, buf, buf_size,
+			      USB_CTRL_GET_TIMEOUT);
+	if (ret >= 0 && ret != buf_size)
+		return -EIO;
+	return ret;
 }
 
 /* Return positive number for status, negative for an error */
