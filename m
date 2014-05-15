Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f45.google.com ([74.125.82.45]:52121 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752129AbaEOVvl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 May 2014 17:51:41 -0400
Received: by mail-wg0-f45.google.com with SMTP id m15so4178769wgh.16
        for <linux-wireless@vger.kernel.org>; Thu, 15 May 2014 14:51:40 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH rebased 05/15] staging: vt6656: lock changes: RXvMngWorkItem.
Date: Thu, 15 May 2014 22:49:14 +0100
Message-Id: <1400190564-5135-5-git-send-email-tvboxspy@gmail.com> (sfid-20140515_235144_932730_037E353D)
In-Reply-To: <1400190564-5135-1-git-send-email-tvboxspy@gmail.com>
References: <1400190564-5135-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Narrow atomic locks in RXvMngWorkItem.

We must lock the DequeueRCB and RXvFreeRCB so that
they are in sync.

vMgrRxManagePacket can nolonger be atomically called.

There is no need for an overall lock.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/dpc.c | 23 ++++++++++++++++-------
 1 file changed, 16 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/vt6656/dpc.c b/drivers/staging/vt6656/dpc.c
index 4ccaa7e..156399d 100644
--- a/drivers/staging/vt6656/dpc.c
+++ b/drivers/staging/vt6656/dpc.c
@@ -1363,34 +1363,43 @@ void RXvMngWorkItem(struct work_struct *work)
 	struct vnt_rcb *pRCB = NULL;
 	struct vnt_rx_mgmt *pRxPacket;
 	int bReAllocSkb = false;
+	unsigned long flags;
 
 	if (pDevice->Flags & fMP_DISCONNECTED)
 		return;
 
     DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"---->Rx Mng Thread\n");
 
-    spin_lock_irq(&pDevice->lock);
     while (pDevice->NumRecvMngList!=0)
     {
+	spin_lock_irqsave(&pDevice->lock, flags);
+
         pRCB = pDevice->FirstRecvMngList;
         pDevice->NumRecvMngList--;
         DequeueRCB(pDevice->FirstRecvMngList, pDevice->LastRecvMngList);
+
+	spin_unlock_irqrestore(&pDevice->lock, flags);
+
         if(!pRCB){
             break;
         }
         pRxPacket = &(pRCB->sMngPacket);
 	vMgrRxManagePacket(pDevice, &pDevice->vnt_mgmt, pRxPacket);
         pRCB->Ref--;
-        if(pRCB->Ref == 0) {
-            DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"RxvFreeMng %d %d\n",pDevice->NumRecvFreeList, pDevice->NumRecvMngList);
-            RXvFreeRCB(pRCB, bReAllocSkb);
-        } else {
+	if (pRCB->Ref == 0) {
+		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"RxvFreeMng %d %d\n",
+			pDevice->NumRecvFreeList, pDevice->NumRecvMngList);
+
+		spin_lock_irqsave(&pDevice->lock, flags);
+
+		RXvFreeRCB(pRCB, bReAllocSkb);
+
+		spin_unlock_irqrestore(&pDevice->lock, flags);
+	} else {
             DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"Rx Mng Only we have the right to free RCB\n");
         }
     }
 
 	pDevice->bIsRxMngWorkItemQueued = false;
-	spin_unlock_irq(&pDevice->lock);
-
 }
 
-- 
1.9.1

