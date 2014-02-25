Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f171.google.com ([74.125.82.171]:34943 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753531AbaBYUx4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Feb 2014 15:53:56 -0500
Received: by mail-we0-f171.google.com with SMTP id u56so906958wes.16
        for <linux-wireless@vger.kernel.org>; Tue, 25 Feb 2014 12:53:55 -0800 (PST)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 07/10] staging: vt6656: clean up s_nsBulkInUsbIoCompleteRead
Date: Tue, 25 Feb 2014 20:51:49 +0000
Message-Id: <1393361512-13805-7-git-send-email-tvboxspy@gmail.com> (sfid-20140225_215402_202014_4D15AD4F)
In-Reply-To: <1393361512-13805-1-git-send-email-tvboxspy@gmail.com>
References: <1393361512-13805-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Clean up white space and camel case.

Camel case changes
pDevice -> priv
pRCB -> rcb
bReAllocSkb -> re_alloc_skb

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/usbpipe.c | 49 ++++++++++++++++++++++------------------
 1 file changed, 27 insertions(+), 22 deletions(-)

diff --git a/drivers/staging/vt6656/usbpipe.c b/drivers/staging/vt6656/usbpipe.c
index 1cab7a3..8092c9a 100644
--- a/drivers/staging/vt6656/usbpipe.c
+++ b/drivers/staging/vt6656/usbpipe.c
@@ -467,16 +467,16 @@ int PIPEnsBulkInUsbRead(struct vnt_private *pDevice, struct vnt_rcb *pRCB)
 
 static void s_nsBulkInUsbIoCompleteRead(struct urb *urb)
 {
-	struct vnt_rcb *pRCB = (struct vnt_rcb *)urb->context;
-	struct vnt_private *pDevice = pRCB->pDevice;
-	int bReAllocSkb = false;
+	struct vnt_rcb *rcb = (struct vnt_rcb *)urb->context;
+	struct vnt_private *priv = rcb->pDevice;
+	int re_alloc_skb = false;
 
-    DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"---->s_nsBulkInUsbIoCompleteRead\n");
+	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"---->s_nsBulkInUsbIoCompleteRead\n");
 
 	switch (urb->status) {
 	case 0:
-		pDevice->ulBulkInContCRCError = 0;
-		pDevice->ulBulkInBytesRead += urb->actual_length;
+		priv->ulBulkInContCRCError = 0;
+		priv->ulBulkInBytesRead += urb->actual_length;
 		break;
 	case -ECONNRESET:
 	case -ENOENT:
@@ -484,28 +484,33 @@ static void s_nsBulkInUsbIoCompleteRead(struct urb *urb)
 		return;
 	case -ETIMEDOUT:
 	default:
-		pDevice->ulBulkInError++;
+		priv->ulBulkInError++;
 		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO
 				"BULK In failed %d\n", urb->status);
 		break;
 	}
 
-    if (urb->actual_length) {
-        spin_lock(&pDevice->lock);
-	if (RXbBulkInProcessData(pDevice, pRCB, urb->actual_length) == true)
-            bReAllocSkb = true;
-        spin_unlock(&pDevice->lock);
-    }
-    pRCB->Ref--;
-    if (pRCB->Ref == 0)
-    {
-        DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"RxvFreeNormal %d \n",pDevice->NumRecvFreeList);
-        spin_lock(&pDevice->lock);
-        RXvFreeRCB(pRCB, bReAllocSkb);
-        spin_unlock(&pDevice->lock);
-    }
+	if (urb->actual_length) {
+		spin_lock(&priv->lock);
+
+		if (RXbBulkInProcessData(priv, rcb, urb->actual_length) == true)
+			re_alloc_skb = true;
+
+		spin_unlock(&priv->lock);
+	}
 
-    return;
+	rcb->Ref--;
+	if (rcb->Ref == 0) {
+		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"RxvFreeNormal %d\n",
+							priv->NumRecvFreeList);
+		spin_lock(&priv->lock);
+
+		RXvFreeRCB(rcb, re_alloc_skb);
+
+		spin_unlock(&priv->lock);
+	}
+
+	return;
 }
 
 /*
-- 
1.9.0

