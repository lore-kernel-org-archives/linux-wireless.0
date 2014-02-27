Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f42.google.com ([74.125.82.42]:51513 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751914AbaB0XHY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Feb 2014 18:07:24 -0500
Received: by mail-wg0-f42.google.com with SMTP id x13so3451198wgg.13
        for <linux-wireless@vger.kernel.org>; Thu, 27 Feb 2014 15:07:23 -0800 (PST)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 7/7] staging: vt6656: s_nsBulkOutIoCompleteWrite Remove variable status.
Date: Thu, 27 Feb 2014 23:06:15 +0000
Message-Id: <1393542375-13110-7-git-send-email-tvboxspy@gmail.com> (sfid-20140228_000734_922691_6B7FB2DC)
In-Reply-To: <1393542375-13110-1-git-send-email-tvboxspy@gmail.com>
References: <1393542375-13110-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove status and move debug messages to switch statement.

Remove duplicate second debug message.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/usbpipe.c | 24 +++++-------------------
 1 file changed, 5 insertions(+), 19 deletions(-)

diff --git a/drivers/staging/vt6656/usbpipe.c b/drivers/staging/vt6656/usbpipe.c
index 57efb7f..a4a4bf2 100644
--- a/drivers/staging/vt6656/usbpipe.c
+++ b/drivers/staging/vt6656/usbpipe.c
@@ -584,38 +584,29 @@ static void s_nsBulkOutIoCompleteWrite(struct urb *urb)
 	struct vnt_usb_send_context *context = urb->context;
 	struct vnt_private *priv = context->pDevice;
 	u8 context_type = context->type;
-	int status;
 
 	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"---->s_nsBulkOutIoCompleteWrite\n");
 
 	switch (urb->status) {
 	case 0:
-	case -ETIMEDOUT:
+		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO
+			"Write %d bytes\n", context->uBufLen);
 		break;
 	case -ECONNRESET:
 	case -ENOENT:
 	case -ESHUTDOWN:
 		context->bBoolInUse = false;
 		return;
+	case -ETIMEDOUT:
 	default:
+		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO
+				"BULK Out failed %d\n", urb->status);
 		break;
 	}
 
 	if (!netif_device_present(priv->dev))
 		return;
 
-
-	status = urb->status;
-
-	if (status == STATUS_SUCCESS) {
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO
-			"Write %d bytes\n", context->uBufLen);
-	} else {
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO
-				"BULK Out failed %d\n", status);
-	}
-
-
 	if (CONTEXT_DATA_PACKET == context_type) {
 		if (context->pPacket != NULL) {
 			dev_kfree_skb_irq(context->pPacket);
@@ -625,11 +616,6 @@ static void s_nsBulkOutIoCompleteWrite(struct urb *urb)
 		}
 
 		priv->dev->trans_start = jiffies;
-
-		if (status != STATUS_SUCCESS) {
-			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO
-				"Send USB error! [%08xh]\n", status);
-		}
 	}
 
 	if (priv->bLinkPass == true) {
-- 
1.9.0

