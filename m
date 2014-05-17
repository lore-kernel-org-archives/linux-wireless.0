Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f42.google.com ([74.125.82.42]:36683 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932145AbaEQIww (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 May 2014 04:52:52 -0400
Received: by mail-wg0-f42.google.com with SMTP id y10so5789933wgg.1
        for <linux-wireless@vger.kernel.org>; Sat, 17 May 2014 01:52:51 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 03/22] staging: vt6656: usbpipe: replace debug messsages.
Date: Sat, 17 May 2014 09:50:20 +0100
Message-Id: <1400316639-4430-3-git-send-email-tvboxspy@gmail.com> (sfid-20140517_105256_849914_38752ADE)
In-Reply-To: <1400316639-4430-1-git-send-email-tvboxspy@gmail.com>
References: <1400316639-4430-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Replace all DBG_PRT wiht dev_dbg

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/usbpipe.c | 39 +++++++++++++++------------------------
 1 file changed, 15 insertions(+), 24 deletions(-)

diff --git a/drivers/staging/vt6656/usbpipe.c b/drivers/staging/vt6656/usbpipe.c
index 8d0705d..5a466653 100644
--- a/drivers/staging/vt6656/usbpipe.c
+++ b/drivers/staging/vt6656/usbpipe.c
@@ -51,9 +51,6 @@
 //endpoint 2: read bulk
 //endpoint 3: write bulk
 
-//static int          msglevel                =MSG_LEVEL_DEBUG;
-static int          msglevel                =MSG_LEVEL_INFO;
-
 #define USB_CTL_WAIT   500 //ms
 
 #ifndef URB_ASYNC_UNLINK
@@ -142,8 +139,7 @@ int PIPEnsInterruptRead(struct vnt_private *priv)
 
 	status = usb_submit_urb(priv->pInterruptURB, GFP_ATOMIC);
 	if (status) {
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO
-			"Submit int URB failed %d\n", status);
+		dev_dbg(&priv->usb->dev, "Submit int URB failed %d\n", status);
 		priv->int_buf.in_use = false;
 	}
 
@@ -188,16 +184,14 @@ static void s_nsInterruptUsbIoCompleteRead(struct urb *urb)
 	if (status != STATUS_SUCCESS) {
 		priv->int_buf.in_use = false;
 
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO
-			"IntUSBIoCompleteControl STATUS = %d\n", status);
+		dev_dbg(&priv->usb->dev, "%s status = %d\n", __func__, status);
 	} else {
 		INTnsProcessData(priv);
 	}
 
 	status = usb_submit_urb(priv->pInterruptURB, GFP_ATOMIC);
 	if (status) {
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO
-			"Submit int URB failed %d\n", status);
+		dev_dbg(&priv->usb->dev, "Submit int URB failed %d\n", status);
 	} else {
 		priv->int_buf.in_use = true;
 	}
@@ -229,7 +223,7 @@ int PIPEnsBulkInUsbRead(struct vnt_private *priv, struct vnt_rcb *rcb)
 
 	urb = rcb->pUrb;
 	if (rcb->skb == NULL) {
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"rcb->skb is null\n");
+		dev_dbg(&priv->usb->dev, "rcb->skb is null\n");
 		return status;
 	}
 
@@ -243,8 +237,7 @@ int PIPEnsBulkInUsbRead(struct vnt_private *priv, struct vnt_rcb *rcb)
 
 	status = usb_submit_urb(urb, GFP_ATOMIC);
 	if (status != 0) {
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO
-				"Submit Rx URB failed %d\n", status);
+		dev_dbg(&priv->usb->dev, "Submit Rx URB failed %d\n", status);
 		return STATUS_FAILURE ;
 	}
 
@@ -285,8 +278,7 @@ static void s_nsBulkInUsbIoCompleteRead(struct urb *urb)
 		return;
 	case -ETIMEDOUT:
 	default:
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO
-				"BULK In failed %d\n", urb->status);
+		dev_dbg(&priv->usb->dev, "BULK In failed %d\n", urb->status);
 		break;
 	}
 
@@ -301,8 +293,9 @@ static void s_nsBulkInUsbIoCompleteRead(struct urb *urb)
 
 	rcb->Ref--;
 	if (rcb->Ref == 0) {
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"RxvFreeNormal %d\n",
-							priv->NumRecvFreeList);
+		dev_dbg(&priv->usb->dev,
+				"RxvFreeNormal %d\n", priv->NumRecvFreeList);
+
 		spin_lock_irqsave(&priv->lock, flags);
 
 		RXvFreeRCB(rcb, re_alloc_skb);
@@ -352,8 +345,8 @@ int PIPEnsSendBulkOut(struct vnt_private *priv,
 
 	status = usb_submit_urb(urb, GFP_ATOMIC);
 	if (status != 0) {
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO
-				"Submit Tx URB failed %d\n", status);
+		dev_dbg(&priv->usb->dev, "Submit Tx URB failed %d\n", status);
+
 		context->in_use = false;
 		return STATUS_FAILURE;
 	}
@@ -397,8 +390,7 @@ static void s_nsBulkOutIoCompleteWrite(struct urb *urb)
 
 	switch (urb->status) {
 	case 0:
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO
-			"Write %d bytes\n", context->buf_len);
+		dev_dbg(&priv->usb->dev, "Write %d bytes\n", context->buf_len);
 		break;
 	case -ECONNRESET:
 	case -ENOENT:
@@ -407,8 +399,7 @@ static void s_nsBulkOutIoCompleteWrite(struct urb *urb)
 		return;
 	case -ETIMEDOUT:
 	default:
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO
-				"BULK Out failed %d\n", urb->status);
+		dev_dbg(&priv->usb->dev, "BULK Out failed %d\n", urb->status);
 		break;
 	}
 
@@ -419,8 +410,8 @@ static void s_nsBulkOutIoCompleteWrite(struct urb *urb)
 		if (context->skb != NULL) {
 			dev_kfree_skb_irq(context->skb);
 			context->skb = NULL;
-			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO
-				"tx  %d bytes\n", context->buf_len);
+			dev_dbg(&priv->usb->dev,
+					"tx  %d bytes\n", context->buf_len);
 		}
 
 		priv->dev->trans_start = jiffies;
-- 
1.9.1

