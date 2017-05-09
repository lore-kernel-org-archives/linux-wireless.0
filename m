Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:33315 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753810AbdEINcA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 9 May 2017 09:32:00 -0400
Received: by mail-pf0-f193.google.com with SMTP id a23so62467pfe.0
        for <linux-wireless@vger.kernel.org>; Tue, 09 May 2017 06:32:00 -0700 (PDT)
From: Amitkumar Karwar <amitkarwar@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>
Subject: [v2 05/11] rsi: Remove unnecessary buffer allocation
Date: Tue,  9 May 2017 19:00:08 +0530
Message-Id: <1494336614-2107-6-git-send-email-amit.karwar@redpinesignals.com> (sfid-20170509_153219_738921_BD774159)
In-Reply-To: <1494336614-2107-1-git-send-email-amit.karwar@redpinesignals.com>
References: <1494336614-2107-1-git-send-email-amit.karwar@redpinesignals.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>

In functions usb read register and usb write register, dynamic allocation
of 4 bytes is used. This is removed as it is unncessary for local variable
and for such small data.

Signed-off-by: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Signed-off-by: Amitkumar Karwar <amit.karwar@redpinesignals.com>
---
 drivers/net/wireless/rsi/rsi_91x_usb.c | 18 ++++--------------
 1 file changed, 4 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_usb.c b/drivers/net/wireless/rsi/rsi_91x_usb.c
index 73b01a8..8eb7407 100644
--- a/drivers/net/wireless/rsi/rsi_91x_usb.c
+++ b/drivers/net/wireless/rsi/rsi_91x_usb.c
@@ -157,12 +157,8 @@ static int rsi_usb_reg_read(struct usb_device *usbdev,
 			    u16 *value,
 			    u16 len)
 {
-	u8 *buf;
-	int status = -ENOMEM;
-
-	buf  = kmalloc(0x04, GFP_KERNEL);
-	if (!buf)
-		return status;
+	u8 buf[4];
+	int status;
 
 	status = usb_control_msg(usbdev,
 				 usb_rcvctrlpipe(usbdev, 0),
@@ -179,7 +175,6 @@ static int rsi_usb_reg_read(struct usb_device *usbdev,
 			"%s: Reg read failed with error code :%d\n",
 			__func__, status);
 	}
-	kfree(buf);
 
 	return status;
 }
@@ -199,12 +194,8 @@ static int rsi_usb_reg_write(struct usb_device *usbdev,
 			     u16 value,
 			     u16 len)
 {
-	u8 *usb_reg_buf;
-	int status = -ENOMEM;
-
-	usb_reg_buf  = kmalloc(0x04, GFP_KERNEL);
-	if (!usb_reg_buf)
-		return status;
+	u8 usb_reg_buf[4];
+	int status;
 
 	usb_reg_buf[0] = (value & 0x00ff);
 	usb_reg_buf[1] = (value & 0xff00) >> 8;
@@ -225,7 +216,6 @@ static int rsi_usb_reg_write(struct usb_device *usbdev,
 			"%s: Reg write failed with error code :%d\n",
 			__func__, status);
 	}
-	kfree(usb_reg_buf);
 
 	return status;
 }
-- 
2.7.4
