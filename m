Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:61594 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751787AbaB1X7u (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Feb 2014 18:59:50 -0500
Received: by mail-wg0-f44.google.com with SMTP id a1so1118988wgh.15
        for <linux-wireless@vger.kernel.org>; Fri, 28 Feb 2014 15:59:49 -0800 (PST)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 2/9] staging: vt6656: Clean up RXvFreeRCB.
Date: Fri, 28 Feb 2014 23:58:32 +0000
Message-Id: <1393631919-16182-2-git-send-email-tvboxspy@gmail.com> (sfid-20140301_010000_044523_0E241C2C)
In-Reply-To: <1393631919-16182-1-git-send-email-tvboxspy@gmail.com>
References: <1393631919-16182-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Clean up white space, comments and camel case.

Camel case changes
pRCB -> rcb
bReAllocSkb -> re_alloc_skb
pDevice -> priv

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/dpc.c | 53 ++++++++++++++++++++++----------------------
 1 file changed, 27 insertions(+), 26 deletions(-)

diff --git a/drivers/staging/vt6656/dpc.c b/drivers/staging/vt6656/dpc.c
index 6894490..18ad3e6 100644
--- a/drivers/staging/vt6656/dpc.c
+++ b/drivers/staging/vt6656/dpc.c
@@ -1323,39 +1323,40 @@ void RXvWorkItem(struct work_struct *work)
 	spin_unlock_irq(&priv->lock);
 }
 
-void RXvFreeRCB(struct vnt_rcb *pRCB, int bReAllocSkb)
+void RXvFreeRCB(struct vnt_rcb *rcb, int re_alloc_skb)
 {
-	struct vnt_private *pDevice = pRCB->pDevice;
+	struct vnt_private *priv = rcb->pDevice;
 
-    DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"---->RXvFreeRCB\n");
+	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"---->RXvFreeRCB\n");
 
-	if (bReAllocSkb == false) {
-		kfree_skb(pRCB->skb);
-		bReAllocSkb = true;
+	if (re_alloc_skb == false) {
+		kfree_skb(rcb->skb);
+		re_alloc_skb = true;
 	}
 
-    if (bReAllocSkb == true) {
-        pRCB->skb = dev_alloc_skb((int)pDevice->rx_buf_sz);
-        // todo error handling
-        if (pRCB->skb == NULL) {
-            DBG_PRT(MSG_LEVEL_ERR,KERN_ERR" Failed to re-alloc rx skb\n");
-        }else {
-            pRCB->skb->dev = pDevice->dev;
-        }
-    }
-    //
-    // Insert the RCB back in the Recv free list
-    //
-    EnqueueRCB(pDevice->FirstRecvFreeList, pDevice->LastRecvFreeList, pRCB);
-    pDevice->NumRecvFreeList++;
+	if (re_alloc_skb == true) {
+		rcb->skb = dev_alloc_skb((int)priv->rx_buf_sz);
+		/* TODO error handling */
+		if (rcb->skb == NULL) {
+			DBG_PRT(MSG_LEVEL_ERR, KERN_ERR
+				" Failed to re-alloc rx skb\n");
+		} else {
+			rcb->skb->dev = priv->dev;
+		}
+	}
 
-    if ((pDevice->Flags & fMP_POST_READS) && MP_IS_READY(pDevice) &&
-        (pDevice->bIsRxWorkItemQueued == false) ) {
+	/* Insert the RCB back in the Recv free list */
+	EnqueueRCB(priv->FirstRecvFreeList, priv->LastRecvFreeList, rcb);
+	priv->NumRecvFreeList++;
 
-        pDevice->bIsRxWorkItemQueued = true;
-	schedule_work(&pDevice->read_work_item);
-    }
-    DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"<----RXFreeRCB %d %d\n",pDevice->NumRecvFreeList, pDevice->NumRecvMngList);
+	if ((priv->Flags & fMP_POST_READS) && MP_IS_READY(priv) &&
+			(priv->bIsRxWorkItemQueued == false)) {
+		priv->bIsRxWorkItemQueued = true;
+		schedule_work(&priv->read_work_item);
+	}
+
+	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"<----RXFreeRCB %d %d\n",
+			priv->NumRecvFreeList, priv->NumRecvMngList);
 }
 
 void RXvMngWorkItem(struct work_struct *work)
-- 
1.9.0

