Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:51396 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752952AbaBSVyw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Feb 2014 16:54:52 -0500
Received: by mail-wi0-f174.google.com with SMTP id f8so5225994wiw.13
        for <linux-wireless@vger.kernel.org>; Wed, 19 Feb 2014 13:54:50 -0800 (PST)
Message-ID: <1392846885.20211.13.camel@canaries64-MCP7A> (sfid-20140219_225455_501554_326144A3)
Subject: [PATCH  3/4] staging: vt6656: clean up s_nsBulkOutIoCompleteWrite.
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Wed, 19 Feb 2014 21:54:45 +0000
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove commented out, white space and camel case.

Camel case changes
pContext -> context
pDevice -> priv
ContextType -> context_type
ulBufLen -> buf_len

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/usbpipe.c | 88 ++++++++++++++++++++--------------------
 1 file changed, 43 insertions(+), 45 deletions(-)

diff --git a/drivers/staging/vt6656/usbpipe.c b/drivers/staging/vt6656/usbpipe.c
index 61d8220..0ae5d20 100644
--- a/drivers/staging/vt6656/usbpipe.c
+++ b/drivers/staging/vt6656/usbpipe.c
@@ -607,14 +607,14 @@ int PIPEnsSendBulkOut(struct vnt_private *pDevice,
 
 static void s_nsBulkOutIoCompleteWrite(struct urb *urb)
 {
-	struct vnt_usb_send_context *pContext =
+	struct vnt_usb_send_context *context =
 			(struct vnt_usb_send_context *)urb->context;
-	struct vnt_private *pDevice = pContext->pDevice;
-	CONTEXT_TYPE ContextType = pContext->Type;
-	unsigned long ulBufLen = pContext->uBufLen;
+	struct vnt_private *priv = context->pDevice;
+	CONTEXT_TYPE context_type = context->Type;
+	unsigned long buf_len = context->uBufLen;
 	int status;
 
-    DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"---->s_nsBulkOutIoCompleteWrite\n");
+	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"---->s_nsBulkOutIoCompleteWrite\n");
 
 	switch (urb->status) {
 	case 0:
@@ -623,58 +623,56 @@ static void s_nsBulkOutIoCompleteWrite(struct urb *urb)
 	case -ECONNRESET:
 	case -ENOENT:
 	case -ESHUTDOWN:
-		pContext->bBoolInUse = false;
+		context->bBoolInUse = false;
 		return;
 	default:
 		break;
 	}
 
-    if (!netif_device_present(pDevice->dev))
-	    return;
+	if (!netif_device_present(priv->dev))
+		return;
 
-   //
-    // Perform various IRP, URB, and buffer 'sanity checks'
-    //
 
-    status = urb->status;
+	status = urb->status;
 
-    if(status == STATUS_SUCCESS) {
-        DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"Write %d bytes\n",(int)ulBufLen);
-        pDevice->ulBulkOutBytesWrite += ulBufLen;
-        pDevice->ulBulkOutContCRCError = 0;
-    } else {
-        DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"BULK Out failed %d\n", status);
-        pDevice->ulBulkOutError++;
-    }
+	if (status == STATUS_SUCCESS) {
+		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO
+			"Write %d bytes\n", (int)buf_len);
+		priv->ulBulkOutBytesWrite += buf_len;
+		priv->ulBulkOutContCRCError = 0;
+	} else {
+		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO
+				"BULK Out failed %d\n", status);
+		priv->ulBulkOutError++;
+	}
 
-//    pDevice->ulCheckForHangCount = 0;
-//    pDevice->pPendingBulkOutContext = NULL;
 
-    if ( CONTEXT_DATA_PACKET == ContextType ) {
-        // Indicate to the protocol the status of the sent packet and return
-        // ownership of the packet.
-	    if (pContext->pPacket != NULL) {
-	        dev_kfree_skb_irq(pContext->pPacket);
-	        pContext->pPacket = NULL;
-            DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"tx  %d bytes\n",(int)ulBufLen);
-	    }
+	if (CONTEXT_DATA_PACKET == context_type) {
+		if (context->pPacket != NULL) {
+			dev_kfree_skb_irq(context->pPacket);
+			context->pPacket = NULL;
+			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO
+				"tx  %d bytes\n", (int)buf_len);
+		}
 
-        pDevice->dev->trans_start = jiffies;
+		priv->dev->trans_start = jiffies;
 
-        if (status == STATUS_SUCCESS) {
-            pDevice->packetsSent++;
-        }
-        else {
-            DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"Send USB error! [%08xh]\n", status);
-            pDevice->packetsSentDropped++;
-        }
+		if (status == STATUS_SUCCESS) {
+			priv->packetsSent++;
+		} else {
+			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO
+				"Send USB error! [%08xh]\n", status);
+			priv->packetsSentDropped++;
+		}
 
-    }
-    if (pDevice->bLinkPass == true) {
-        if (netif_queue_stopped(pDevice->dev))
-            netif_wake_queue(pDevice->dev);
-    }
-    pContext->bBoolInUse = false;
+	}
 
-    return;
+	if (priv->bLinkPass == true) {
+		if (netif_queue_stopped(priv->dev))
+			netif_wake_queue(priv->dev);
+	}
+
+	context->bBoolInUse = false;
+
+	return;
 }
-- 
1.9.rc1


