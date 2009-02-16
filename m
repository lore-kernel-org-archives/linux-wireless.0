Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.30]:5270 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755491AbZBPChh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Feb 2009 21:37:37 -0500
Received: by yx-out-2324.google.com with SMTP id 8so900322yxm.1
        for <linux-wireless@vger.kernel.org>; Sun, 15 Feb 2009 18:37:35 -0800 (PST)
MIME-Version: 1.0
Date: Sun, 15 Feb 2009 21:37:35 -0500
Message-ID: <c4d76b3b0902151837o797d850ajb883ce98338aa8a1@mail.gmail.com> (sfid-20090216_033741_914816_DE7D67D4)
Subject: [PATCH] at76c50x-usb: clean up DMA on stack
From: Jason Andryuk <jandryuk@gmail.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Kalle Valo <kalle.valo@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

cleanup dma on stack issues

- no DMA on stack
- cleanup unclear endianness issue

Corrected version of Oliver Neukum's original patch for at76_usb

Signed-off-by: Jason Andryuk <jandryuk@gmail.com>
--

diff --git a/drivers/net/wireless/at76c50x-usb.c
b/drivers/net/wireless/at76c50x-usb.c
index a89ee2d..2f18248 100644
--- a/drivers/net/wireless/at76c50x-usb.c
+++ b/drivers/net/wireless/at76c50x-usb.c
@@ -580,18 +580,25 @@ static int at76_remap(struct usb_device *udev)
 static int at76_get_op_mode(struct usb_device *udev)
 {
     int ret;
-    u8 op_mode;
+    u8 saved;
+    u8 *op_mode;

+    op_mode = kmalloc(1, GFP_NOIO);
+    if (!op_mode)
+        return -ENOMEM;
     ret = usb_control_msg(udev, usb_rcvctrlpipe(udev, 0), 0x33,
                   USB_TYPE_VENDOR | USB_DIR_IN |
-                  USB_RECIP_INTERFACE, 0x01, 0, &op_mode, 1,
+                  USB_RECIP_INTERFACE, 0x01, 0, op_mode, 1,
                   USB_CTRL_GET_TIMEOUT);
+    saved = *op_mode;
+    kfree(op_mode);
+
     if (ret < 0)
         return ret;
     else if (ret < 1)
         return -EIO;
     else
-        return op_mode;
+        return saved;
 }

 /* Load a block of the second ("external") part of the firmware */
@@ -704,21 +711,25 @@ static inline int at76_get_mib(struct usb_device
*udev, u16 mib, void *buf,
 /* Return positive number for status, negative for an error */
 static inline int at76_get_cmd_status(struct usb_device *udev, u8 cmd)
 {
-    u8 stat_buf[40];
+    u8 *stat_buf;
     int ret;
-
+
+    stat_buf = kmalloc(40, GFP_NOIO);
+    if (!stat_buf)
+        return -ENOMEM;
+
     ret = usb_control_msg(udev, usb_rcvctrlpipe(udev, 0), 0x22,
-                  USB_TYPE_VENDOR | USB_DIR_IN |
-                  USB_RECIP_INTERFACE, cmd, 0, stat_buf,
-                  sizeof(stat_buf), USB_CTRL_GET_TIMEOUT);
-    if (ret < 0)
-        return ret;
-
-    return stat_buf[5];
+            USB_TYPE_VENDOR | USB_DIR_IN |
+            USB_RECIP_INTERFACE, cmd, 0, stat_buf,
+            40, USB_CTRL_GET_TIMEOUT);
+    if (ret >= 0)
+        ret = stat_buf[5];
+    kfree(stat_buf);
+
+    return ret;
 }

 #define MAKE_CMD_CASE(c) case (c): return #c
-
 static const char *at76_get_cmd_string(u8 cmd_status)
 {
     switch (cmd_status) {
@@ -735,7 +746,7 @@ static const char *at76_get_cmd_string(u8 cmd_status)
     return "UNKNOWN";
 }

-static int at76_set_card_command(struct usb_device *udev, int cmd, void *buf,
+static int at76_set_card_command(struct usb_device *udev, u8 cmd, void *buf,
                  int buf_size)
 {
     int ret;
