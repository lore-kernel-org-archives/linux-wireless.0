Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f173.google.com ([74.125.82.173]:37220 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932284AbaFYUVq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Jun 2014 16:21:46 -0400
Received: by mail-we0-f173.google.com with SMTP id t60so2641569wes.18
        for <linux-wireless@vger.kernel.org>; Wed, 25 Jun 2014 13:21:45 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 25/34] staging: vt6656: dpc remove dead code RXvMngWorkItem
Date: Wed, 25 Jun 2014 21:20:02 +0100
Message-Id: <1403727611-6825-26-git-send-email-tvboxspy@gmail.com> (sfid-20140625_223012_961081_4C78A04D)
In-Reply-To: <1403727611-6825-1-git-send-email-tvboxspy@gmail.com>
References: <1403727611-6825-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/dpc.c | 46 --------------------------------------------
 drivers/staging/vt6656/dpc.h |  2 --
 2 files changed, 48 deletions(-)

diff --git a/drivers/staging/vt6656/dpc.c b/drivers/staging/vt6656/dpc.c
index 65a3a70..ceeb3ee 100644
--- a/drivers/staging/vt6656/dpc.c
+++ b/drivers/staging/vt6656/dpc.c
@@ -112,52 +112,6 @@ void RXvFreeRCB(struct vnt_rcb *rcb, int re_alloc_skb)
 			priv->NumRecvFreeList, priv->NumRecvMngList);
 }
 
-void RXvMngWorkItem(struct work_struct *work)
-{
-	struct vnt_private *pDevice =
-		container_of(work, struct vnt_private, rx_mng_work_item);
-	struct vnt_rcb *pRCB = NULL;
-	struct vnt_rx_mgmt *pRxPacket;
-	int bReAllocSkb = false;
-	unsigned long flags;
-
-	if (pDevice->Flags & fMP_DISCONNECTED)
-		return;
-
-    DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"---->Rx Mng Thread\n");
-
-    while (pDevice->NumRecvMngList!=0)
-    {
-	spin_lock_irqsave(&pDevice->lock, flags);
-
-        pRCB = pDevice->FirstRecvMngList;
-        pDevice->NumRecvMngList--;
-        DequeueRCB(pDevice->FirstRecvMngList, pDevice->LastRecvMngList);
-
-	spin_unlock_irqrestore(&pDevice->lock, flags);
-
-        if(!pRCB){
-            break;
-        }
-        pRxPacket = &(pRCB->sMngPacket);
-        pRCB->Ref--;
-	if (pRCB->Ref == 0) {
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"RxvFreeMng %d %d\n",
-			pDevice->NumRecvFreeList, pDevice->NumRecvMngList);
-
-		spin_lock_irqsave(&pDevice->lock, flags);
-
-		RXvFreeRCB(pRCB, bReAllocSkb);
-
-		spin_unlock_irqrestore(&pDevice->lock, flags);
-	} else {
-            DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"Rx Mng Only we have the right to free RCB\n");
-        }
-    }
-
-	pDevice->bIsRxMngWorkItemQueued = false;
-}
-
 int vnt_rx_data(struct vnt_private *priv, struct vnt_rcb *ptr_rcb,
 	unsigned long bytes_received)
 {
diff --git a/drivers/staging/vt6656/dpc.h b/drivers/staging/vt6656/dpc.h
index 0afd882..1df2ae8 100644
--- a/drivers/staging/vt6656/dpc.h
+++ b/drivers/staging/vt6656/dpc.h
@@ -34,8 +34,6 @@
 
 void RXvWorkItem(struct work_struct *work);
 
-void RXvMngWorkItem(struct work_struct *work);
-
 void RXvFreeRCB(struct vnt_rcb *pRCB, int bReAllocSkb);
 
 int vnt_rx_data(struct vnt_private *, struct vnt_rcb *,
-- 
1.9.1

