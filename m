Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f182.google.com ([209.85.212.182]:54902 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751573AbaB0XHH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Feb 2014 18:07:07 -0500
Received: by mail-wi0-f182.google.com with SMTP id f8so71185wiw.15
        for <linux-wireless@vger.kernel.org>; Thu, 27 Feb 2014 15:07:06 -0800 (PST)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 2/7] staging: vt6656: Remove all variables ulInt*
Date: Thu, 27 Feb 2014 23:06:10 +0000
Message-Id: <1393542375-13110-2-git-send-email-tvboxspy@gmail.com> (sfid-20140228_000711_804164_EE7AE91B)
In-Reply-To: <1393542375-13110-1-git-send-email-tvboxspy@gmail.com>
References: <1393542375-13110-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

None of these variables reach user or used by debug messages.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/device.h  | 6 ------
 drivers/staging/vt6656/usbpipe.c | 3 ---
 2 files changed, 9 deletions(-)

diff --git a/drivers/staging/vt6656/device.h b/drivers/staging/vt6656/device.h
index 50262dc..2574029 100644
--- a/drivers/staging/vt6656/device.h
+++ b/drivers/staging/vt6656/device.h
@@ -423,12 +423,6 @@ struct vnt_private {
 	/* default config from file by user setting */
 	DEFAULT_CONFIG config_file;
 
-	/* Statistic for USB */
-	unsigned long ulIntInPosted;
-	unsigned long ulIntInError;
-	unsigned long ulIntInContCRCError;
-	unsigned long ulIntInBytesRead;
-
 	/* Version control */
 	u16 wFirmwareVersion;
 	u8 byLocalID;
diff --git a/drivers/staging/vt6656/usbpipe.c b/drivers/staging/vt6656/usbpipe.c
index ce396b9..0a3aeec 100644
--- a/drivers/staging/vt6656/usbpipe.c
+++ b/drivers/staging/vt6656/usbpipe.c
@@ -306,7 +306,6 @@ int PIPEnsInterruptRead(struct vnt_private *priv)
 		return STATUS_FAILURE;
 
 	priv->int_buf.in_use = true;
-	priv->ulIntInPosted++;
 
 	usb_fill_int_urb(priv->pInterruptURB,
 		priv->usb,
@@ -377,8 +376,6 @@ static void s_nsInterruptUsbIoCompleteRead(struct urb *urb)
 		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO
 			"IntUSBIoCompleteControl STATUS = %d\n", status);
 	} else {
-		priv->ulIntInBytesRead += (unsigned long)urb->actual_length;
-		priv->ulIntInContCRCError = 0;
 		priv->bEventAvailable = true;
 		INTnsProcessData(priv);
 	}
-- 
1.9.0

