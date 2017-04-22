Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:36227 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1043799AbdDVKPX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 22 Apr 2017 06:15:23 -0400
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
        Malcolm Priestley <tvboxspy@gmail.com>,
        "# v4 . 9+" <stable@vger.kernel.org>
Subject: [PATCH 1/2] staging: vt6656: use off stack for out buffer USB transfers.
Date: Sat, 22 Apr 2017 11:14:57 +0100
Message-Id: <20170422101458.4566-1-tvboxspy@gmail.com> (sfid-20170422_121532_231564_3F6F0BF6)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since 4.9 mandated USB buffers be heap allocated this causes the driver
to fail.

Since there is a wide range of buffer sizes use kmemdup to create
allocated buffer.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
Cc: <stable@vger.kernel.org> # v4.9+
---
 drivers/staging/vt6656/usbpipe.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/vt6656/usbpipe.c b/drivers/staging/vt6656/usbpipe.c
index 9ad8503d2589..ea5a7c65ad1b 100644
--- a/drivers/staging/vt6656/usbpipe.c
+++ b/drivers/staging/vt6656/usbpipe.c
@@ -47,15 +47,25 @@ int vnt_control_out(struct vnt_private *priv, u8 request, u16 value,
 		     u16 index, u16 length, u8 *buffer)
 {
 	int status = 0;
+	u8 *usb_buffer;
 
 	if (test_bit(DEVICE_FLAGS_DISCONNECTED, &priv->flags))
 		return STATUS_FAILURE;
 
 	mutex_lock(&priv->usb_lock);
 
+	usb_buffer = kmemdup(buffer, length, GFP_KERNEL);
+	if (!usb_buffer) {
+		mutex_unlock(&priv->usb_lock);
+		return -ENOMEM;
+	}
+
 	status = usb_control_msg(priv->usb,
-		usb_sndctrlpipe(priv->usb, 0), request, 0x40, value,
-			index, buffer, length, USB_CTL_WAIT);
+				 usb_sndctrlpipe(priv->usb, 0),
+				 request, 0x40, value,
+				 index, usb_buffer, length, USB_CTL_WAIT);
+
+	kfree(usb_buffer);
 
 	mutex_unlock(&priv->usb_lock);
 
-- 
2.11.0
