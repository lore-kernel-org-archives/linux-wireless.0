Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:51203 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751787AbaB1X7j (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Feb 2014 18:59:39 -0500
Received: by mail-we0-f174.google.com with SMTP id t60so1105618wes.5
        for <linux-wireless@vger.kernel.org>; Fri, 28 Feb 2014 15:59:38 -0800 (PST)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 1/9] staging: vt6656: Clean up RXvWorkItem
Date: Fri, 28 Feb 2014 23:58:31 +0000
Message-Id: <1393631919-16182-1-git-send-email-tvboxspy@gmail.com> (sfid-20140301_005958_434708_9251DA8B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove white space and camel case.

Camel case changes
pDevice -> priv
ntStatus -> status
pRCB -> rcb

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/dpc.c | 36 ++++++++++++++++++++----------------
 1 file changed, 20 insertions(+), 16 deletions(-)

diff --git a/drivers/staging/vt6656/dpc.c b/drivers/staging/vt6656/dpc.c
index 03351e7..6894490 100644
--- a/drivers/staging/vt6656/dpc.c
+++ b/drivers/staging/vt6656/dpc.c
@@ -1295,28 +1295,32 @@ static int s_bAPModeRxData(struct vnt_private *pDevice, struct sk_buff *skb,
 
 void RXvWorkItem(struct work_struct *work)
 {
-	struct vnt_private *pDevice =
+	struct vnt_private *priv =
 		container_of(work, struct vnt_private, read_work_item);
-	int ntStatus;
-	struct vnt_rcb *pRCB = NULL;
+	int status;
+	struct vnt_rcb *rcb = NULL;
 
-	if (pDevice->Flags & fMP_DISCONNECTED)
+	if (priv->Flags & fMP_DISCONNECTED)
 		return;
 
-    DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"---->Rx Polling Thread\n");
-    spin_lock_irq(&pDevice->lock);
+	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"---->Rx Polling Thread\n");
 
-    while ((pDevice->Flags & fMP_POST_READS) &&
-            MP_IS_READY(pDevice) &&
-            (pDevice->NumRecvFreeList != 0) ) {
-        pRCB = pDevice->FirstRecvFreeList;
-        pDevice->NumRecvFreeList--;
-        DequeueRCB(pDevice->FirstRecvFreeList, pDevice->LastRecvFreeList);
-        ntStatus = PIPEnsBulkInUsbRead(pDevice, pRCB);
-    }
-    pDevice->bIsRxWorkItemQueued = false;
-    spin_unlock_irq(&pDevice->lock);
+	spin_lock_irq(&priv->lock);
+
+	while ((priv->Flags & fMP_POST_READS) && MP_IS_READY(priv) &&
+			(priv->NumRecvFreeList != 0)) {
+		rcb = priv->FirstRecvFreeList;
+
+		priv->NumRecvFreeList--;
+
+		DequeueRCB(priv->FirstRecvFreeList, priv->LastRecvFreeList);
+
+		status = PIPEnsBulkInUsbRead(priv, rcb);
+	}
+
+	priv->bIsRxWorkItemQueued = false;
 
+	spin_unlock_irq(&priv->lock);
 }
 
 void RXvFreeRCB(struct vnt_rcb *pRCB, int bReAllocSkb)
-- 
1.9.0

