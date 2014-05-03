Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:35915 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751805AbaECOTv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 3 May 2014 10:19:51 -0400
Received: by mail-wi0-f179.google.com with SMTP id bs8so3628034wib.12
        for <linux-wireless@vger.kernel.org>; Sat, 03 May 2014 07:19:50 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 03/13] staging: vt6656: lock changes: RXvMngWorkItem.
Date: Sat,  3 May 2014 15:17:24 +0100
Message-Id: <1399126654-2663-3-git-send-email-tvboxspy@gmail.com> (sfid-20140503_161955_315970_2F923152)
In-Reply-To: <1399126654-2663-1-git-send-email-tvboxspy@gmail.com>
References: <1399126654-2663-1-git-send-email-tvboxspy@gmail.com>
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

