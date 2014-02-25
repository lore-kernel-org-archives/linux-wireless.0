Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f176.google.com ([74.125.82.176]:56063 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753288AbaBYUxq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Feb 2014 15:53:46 -0500
Received: by mail-we0-f176.google.com with SMTP id p61so908825wes.35
        for <linux-wireless@vger.kernel.org>; Tue, 25 Feb 2014 12:53:45 -0800 (PST)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 03/10] staging: vt6656: clean up PIPEnsSendBulkOut.
Date: Tue, 25 Feb 2014 20:51:45 +0000
Message-Id: <1393361512-13805-3-git-send-email-tvboxspy@gmail.com> (sfid-20140225_215349_158458_810C5FEC)
In-Reply-To: <1393361512-13805-1-git-send-email-tvboxspy@gmail.com>
References: <1393361512-13805-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove commented out code, white space and camel case.

camel case changes
pDevice -> priv
pContext -> context
pUrb -> urb

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/usbpipe.c | 61 +++++++++++++++++-----------------------
 1 file changed, 26 insertions(+), 35 deletions(-)

diff --git a/drivers/staging/vt6656/usbpipe.c b/drivers/staging/vt6656/usbpipe.c
index 706c163..9a922b4 100644
--- a/drivers/staging/vt6656/usbpipe.c
+++ b/drivers/staging/vt6656/usbpipe.c
@@ -528,50 +528,41 @@ static void s_nsBulkInUsbIoCompleteRead(struct urb *urb)
  *
  */
 
-int PIPEnsSendBulkOut(struct vnt_private *pDevice,
-				struct vnt_usb_send_context *pContext)
+int PIPEnsSendBulkOut(struct vnt_private *priv,
+				struct vnt_usb_send_context *context)
 {
 	int status;
-	struct urb          *pUrb;
+	struct urb *urb;
 
-    pDevice->bPWBitOn = false;
+	priv->bPWBitOn = false;
 
-/*
-    if (pDevice->pPendingBulkOutContext != NULL) {
-        pDevice->NumContextsQueued++;
-        EnqueueContext(pDevice->FirstTxContextQueue, pDevice->LastTxContextQueue, pContext);
-        status = STATUS_PENDING;
-        DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"Send pending!\n");
-        return status;
-    }
-*/
-
-    DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"s_nsSendBulkOut\n");
+	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"s_nsSendBulkOut\n");
 
-	if (!(MP_IS_READY(pDevice) && pDevice->Flags & fMP_POST_WRITES)) {
-		pContext->bBoolInUse = false;
+	if (!(MP_IS_READY(priv) && priv->Flags & fMP_POST_WRITES)) {
+		context->bBoolInUse = false;
 		return STATUS_RESOURCES;
 	}
 
-        pUrb = pContext->pUrb;
-        pDevice->ulBulkOutPosted++;
-//        pDevice->pPendingBulkOutContext = pContext;
-	usb_fill_bulk_urb(pUrb,
-			pDevice->usb,
-			usb_sndbulkpipe(pDevice->usb, 3),
-			pContext->Data,
-			pContext->uBufLen,
+	urb = context->pUrb;
+	priv->ulBulkOutPosted++;
+
+	usb_fill_bulk_urb(urb,
+			priv->usb,
+			usb_sndbulkpipe(priv->usb, 3),
+			context->Data,
+			context->uBufLen,
 			s_nsBulkOutIoCompleteWrite,
-			pContext);
-
-    	status = usb_submit_urb(pUrb, GFP_ATOMIC);
-    	if (status != 0)
-    	{
-    		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"Submit Tx URB failed %d\n", status);
-		pContext->bBoolInUse = false;
-    		return STATUS_FAILURE;
-    	}
-        return STATUS_PENDING;
+			context);
+
+	status = usb_submit_urb(urb, GFP_ATOMIC);
+	if (status != 0) {
+		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO
+				"Submit Tx URB failed %d\n", status);
+		context->bBoolInUse = false;
+		return STATUS_FAILURE;
+	}
+
+	return STATUS_PENDING;
 }
 
 /*
-- 
1.9.0

