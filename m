Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f169.google.com ([209.85.212.169]:47875 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751232AbaB0XHA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Feb 2014 18:07:00 -0500
Received: by mail-wi0-f169.google.com with SMTP id bs8so1243013wib.0
        for <linux-wireless@vger.kernel.org>; Thu, 27 Feb 2014 15:06:58 -0800 (PST)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 1/7] staging: vt6656: Remove all variables ulBulk*
Date: Thu, 27 Feb 2014 23:06:09 +0000
Message-Id: <1393542375-13110-1-git-send-email-tvboxspy@gmail.com> (sfid-20140228_000704_499227_622A3EEF)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

None of these variables reach user or in any debug messages.

Remove them all.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/device.h  | 10 ----------
 drivers/staging/vt6656/usbpipe.c | 10 ----------
 2 files changed, 20 deletions(-)

diff --git a/drivers/staging/vt6656/device.h b/drivers/staging/vt6656/device.h
index ce1587a..50262dc 100644
--- a/drivers/staging/vt6656/device.h
+++ b/drivers/staging/vt6656/device.h
@@ -424,16 +424,6 @@ struct vnt_private {
 	DEFAULT_CONFIG config_file;
 
 	/* Statistic for USB */
-	unsigned long ulBulkInPosted;
-	unsigned long ulBulkInError;
-	unsigned long ulBulkInContCRCError;
-	unsigned long ulBulkInBytesRead;
-
-	unsigned long ulBulkOutPosted;
-	unsigned long ulBulkOutError;
-	unsigned long ulBulkOutContCRCError;
-	unsigned long ulBulkOutBytesWrite;
-
 	unsigned long ulIntInPosted;
 	unsigned long ulIntInError;
 	unsigned long ulIntInContCRCError;
diff --git a/drivers/staging/vt6656/usbpipe.c b/drivers/staging/vt6656/usbpipe.c
index 54c68a5..ce396b9 100644
--- a/drivers/staging/vt6656/usbpipe.c
+++ b/drivers/staging/vt6656/usbpipe.c
@@ -372,7 +372,6 @@ static void s_nsInterruptUsbIoCompleteRead(struct urb *urb)
 		"s_nsInterruptUsbIoCompleteRead Status %d\n", status);
 
 	if (status != STATUS_SUCCESS) {
-		priv->ulBulkInError++;
 		priv->int_buf.in_use = false;
 
 		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO
@@ -419,8 +418,6 @@ int PIPEnsBulkInUsbRead(struct vnt_private *priv, struct vnt_rcb *rcb)
 	if (priv->Flags & fMP_DISCONNECTED)
 		return STATUS_FAILURE;
 
-	priv->ulBulkInPosted++;
-
 	urb = rcb->pUrb;
 	if (rcb->skb == NULL) {
 		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"rcb->skb is null\n");
@@ -473,8 +470,6 @@ static void s_nsBulkInUsbIoCompleteRead(struct urb *urb)
 
 	switch (urb->status) {
 	case 0:
-		priv->ulBulkInContCRCError = 0;
-		priv->ulBulkInBytesRead += urb->actual_length;
 		break;
 	case -ECONNRESET:
 	case -ENOENT:
@@ -482,7 +477,6 @@ static void s_nsBulkInUsbIoCompleteRead(struct urb *urb)
 		return;
 	case -ETIMEDOUT:
 	default:
-		priv->ulBulkInError++;
 		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO
 				"BULK In failed %d\n", urb->status);
 		break;
@@ -541,7 +535,6 @@ int PIPEnsSendBulkOut(struct vnt_private *priv,
 	}
 
 	urb = context->pUrb;
-	priv->ulBulkOutPosted++;
 
 	usb_fill_bulk_urb(urb,
 			priv->usb,
@@ -622,12 +615,9 @@ static void s_nsBulkOutIoCompleteWrite(struct urb *urb)
 	if (status == STATUS_SUCCESS) {
 		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO
 			"Write %d bytes\n", (int)buf_len);
-		priv->ulBulkOutBytesWrite += buf_len;
-		priv->ulBulkOutContCRCError = 0;
 	} else {
 		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO
 				"BULK Out failed %d\n", status);
-		priv->ulBulkOutError++;
 	}
 
 
-- 
1.9.0

