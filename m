Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f170.google.com ([74.125.82.170]:39434 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751747AbaB0XHP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Feb 2014 18:07:15 -0500
Received: by mail-we0-f170.google.com with SMTP id w61so1324782wes.29
        for <linux-wireless@vger.kernel.org>; Thu, 27 Feb 2014 15:07:14 -0800 (PST)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 4/7] staging: vt6656: Remove unused variable bEventAvailable.
Date: Thu, 27 Feb 2014 23:06:12 +0000
Message-Id: <1393542375-13110-4-git-send-email-tvboxspy@gmail.com> (sfid-20140228_000724_405952_9A1757AD)
In-Reply-To: <1393542375-13110-1-git-send-email-tvboxspy@gmail.com>
References: <1393542375-13110-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Flips from true to false but does nothing.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/device.h   | 1 -
 drivers/staging/vt6656/main_usb.c | 1 -
 drivers/staging/vt6656/usbpipe.c  | 1 -
 3 files changed, 3 deletions(-)

diff --git a/drivers/staging/vt6656/device.h b/drivers/staging/vt6656/device.h
index 72bcafb..1124aa4 100644
--- a/drivers/staging/vt6656/device.h
+++ b/drivers/staging/vt6656/device.h
@@ -417,7 +417,6 @@ struct vnt_private {
 
 	/* Variables to track resources for the Interrupt In Pipe */
 	struct vnt_interrupt_buffer int_buf;
-	int bEventAvailable;
 
 	/* default config from file by user setting */
 	DEFAULT_CONFIG config_file;
diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index 7783050..e1d90c5 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -998,7 +998,6 @@ static int  device_open(struct net_device *dev)
     pDevice->eEncryptionStatus = Ndis802_11EncryptionDisabled;
 
     pDevice->bIsRxWorkItemQueued = true;
-    pDevice->bEventAvailable = false;
 
    pDevice->bWPADEVUp = false;
      pDevice->bwextstep0 = false;
diff --git a/drivers/staging/vt6656/usbpipe.c b/drivers/staging/vt6656/usbpipe.c
index 0a3aeec..5ce583e 100644
--- a/drivers/staging/vt6656/usbpipe.c
+++ b/drivers/staging/vt6656/usbpipe.c
@@ -376,7 +376,6 @@ static void s_nsInterruptUsbIoCompleteRead(struct urb *urb)
 		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO
 			"IntUSBIoCompleteControl STATUS = %d\n", status);
 	} else {
-		priv->bEventAvailable = true;
 		INTnsProcessData(priv);
 	}
 
-- 
1.9.0

