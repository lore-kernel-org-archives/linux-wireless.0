Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:35568 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1043800AbdDVKPY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 22 Apr 2017 06:15:24 -0400
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
        Malcolm Priestley <tvboxspy@gmail.com>,
        "# v4 . 9+" <stable@vger.kernel.org>
Subject: [PATCH 2/2] staging: vt6656: use off stack for in buffer USB transfers.
Date: Sat, 22 Apr 2017 11:14:58 +0100
Message-Id: <20170422101458.4566-2-tvboxspy@gmail.com> (sfid-20170422_121532_758572_7FA9EAFF)
In-Reply-To: <20170422101458.4566-1-tvboxspy@gmail.com>
References: <20170422101458.4566-1-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since 4.9 mandated USB buffers to be heap allocated. This causes
the driver to fail.

Create buffer for USB transfers.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
Cc: <stable@vger.kernel.org> # v4.9+
---
 drivers/staging/vt6656/usbpipe.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/vt6656/usbpipe.c b/drivers/staging/vt6656/usbpipe.c
index ea5a7c65ad1b..dc11a05be8c4 100644
--- a/drivers/staging/vt6656/usbpipe.c
+++ b/drivers/staging/vt6656/usbpipe.c
@@ -85,15 +85,28 @@ int vnt_control_in(struct vnt_private *priv, u8 request, u16 value,
 		    u16 index, u16 length, u8 *buffer)
 {
 	int status;
+	u8 *usb_buffer;
 
 	if (test_bit(DEVICE_FLAGS_DISCONNECTED, &priv->flags))
 		return STATUS_FAILURE;
 
 	mutex_lock(&priv->usb_lock);
 
+	usb_buffer = kmalloc(length, GFP_KERNEL);
+	if (!usb_buffer) {
+		mutex_unlock(&priv->usb_lock);
+		return -ENOMEM;
+	}
+
 	status = usb_control_msg(priv->usb,
-				usb_rcvctrlpipe(priv->usb, 0), request, 0xc0,
-				value, index, buffer, length, USB_CTL_WAIT);
+				 usb_rcvctrlpipe(priv->usb, 0),
+				 request, 0xc0, value,
+				 index, usb_buffer, length, USB_CTL_WAIT);
+
+	if (status == length)
+		memcpy(buffer, usb_buffer, length);
+
+	kfree(usb_buffer);
 
 	mutex_unlock(&priv->usb_lock);
 
-- 
2.11.0
