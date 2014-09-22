Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:53358 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754176AbaIVU2V (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Sep 2014 16:28:21 -0400
Received: by mail-wi0-f180.google.com with SMTP id q5so3829282wiv.1
        for <linux-wireless@vger.kernel.org>; Mon, 22 Sep 2014 13:28:20 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 1/2] staging: vt6655: pr_err remove string to net device name
Date: Mon, 22 Sep 2014 21:27:46 +0100
Message-Id: <1411417667-9191-1-git-send-email-tvboxspy@gmail.com> (sfid-20140922_222825_230201_4A403A79)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Just print driver name with dev_err removing the string formatting.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/device_main.c | 34 +++++++++++++++-------------------
 1 file changed, 15 insertions(+), 19 deletions(-)

diff --git a/drivers/staging/vt6655/device_main.c b/drivers/staging/vt6655/device_main.c
index aaeb371..1a1440f 100644
--- a/drivers/staging/vt6655/device_main.c
+++ b/drivers/staging/vt6655/device_main.c
@@ -1043,8 +1043,7 @@ static bool device_init_rings(struct vnt_private *pDevice)
 					 pDevice->sOpts.nTxDescs[1] * sizeof(STxDesc),
 					 &pDevice->pool_dma);
 	if (vir_pool == NULL) {
-		pr_err("%s : allocate desc dma memory failed\n",
-		       pDevice->dev->name);
+		dev_err(&pDevice->pcid->dev, "allocate desc dma memory failed\n");
 		return false;
 	}
 
@@ -1063,8 +1062,8 @@ static bool device_init_rings(struct vnt_private *pDevice)
 						  CB_MAX_BUF_SIZE,
 						  &pDevice->tx_bufs_dma0);
 	if (pDevice->tx0_bufs == NULL) {
-		pr_err("%s: allocate buf dma memory failed\n",
-		       pDevice->dev->name);
+		dev_err(&pDevice->pcid->dev, "allocate buf dma memory failed\n");
+
 		pci_free_consistent(pDevice->pcid,
 				    pDevice->sOpts.nRxDescs0 * sizeof(SRxDesc) +
 				    pDevice->sOpts.nRxDescs1 * sizeof(SRxDesc) +
@@ -1141,10 +1140,9 @@ static void device_init_rd0_ring(struct vnt_private *pDevice)
 		pDesc = &(pDevice->aRD0Ring[i]);
 		pDesc->pRDInfo = alloc_rd_info();
 		ASSERT(pDesc->pRDInfo);
-		if (!device_alloc_rx_buf(pDevice, pDesc)) {
-			pr_err("%s: can not alloc rx bufs\n",
-			       pDevice->dev->name);
-		}
+		if (!device_alloc_rx_buf(pDevice, pDesc))
+			dev_err(&pDevice->pcid->dev, "can not alloc rx bufs\n");
+
 		pDesc->next = &(pDevice->aRD0Ring[(i+1) % pDevice->sOpts.nRxDescs0]);
 		pDesc->pRDInfo->curr_desc = cpu_to_le32(curr);
 		pDesc->next_desc = cpu_to_le32(curr + sizeof(SRxDesc));
@@ -1166,10 +1164,9 @@ static void device_init_rd1_ring(struct vnt_private *pDevice)
 		pDesc = &(pDevice->aRD1Ring[i]);
 		pDesc->pRDInfo = alloc_rd_info();
 		ASSERT(pDesc->pRDInfo);
-		if (!device_alloc_rx_buf(pDevice, pDesc)) {
-			pr_err("%s: can not alloc rx bufs\n",
-			       pDevice->dev->name);
-		}
+		if (!device_alloc_rx_buf(pDevice, pDesc))
+			dev_err(&pDevice->pcid->dev, "can not alloc rx bufs\n");
+
 		pDesc->next = &(pDevice->aRD1Ring[(i+1) % pDevice->sOpts.nRxDescs1]);
 		pDesc->pRDInfo->curr_desc = cpu_to_le32(curr);
 		pDesc->next_desc = cpu_to_le32(curr + sizeof(SRxDesc));
@@ -1188,10 +1185,8 @@ static void device_init_defrag_cb(struct vnt_private *pDevice)
 	/* Init the fragment ctl entries */
 	for (i = 0; i < CB_MAX_RX_FRAG; i++) {
 		pDeF = &(pDevice->sRxDFCB[i]);
-		if (!device_alloc_frag_buf(pDevice, pDeF)) {
-			pr_err("%s: can not alloc frag bufs\n",
-			       pDevice->dev->name);
-		}
+		if (!device_alloc_frag_buf(pDevice, pDeF))
+			dev_err(&pDevice->pcid->dev, "can not alloc frag bufs\n");
 	}
 	pDevice->cbDFCB = CB_MAX_RX_FRAG;
 	pDevice->cbFreeDFCB = pDevice->cbDFCB;
@@ -1348,8 +1343,8 @@ static int device_rx_srv(struct vnt_private *pDevice, unsigned int uIdx)
 			break;
 		if (device_receive_frame(pDevice, pRD)) {
 			if (!device_alloc_rx_buf(pDevice, pRD)) {
-				pr_err("%s: can not allocate rx buf\n",
-				       pDevice->dev->name);
+				dev_err(&pDevice->pcid->dev,
+					"can not allocate rx buf\n");
 				break;
 			}
 		}
@@ -1525,7 +1520,8 @@ static int device_tx_srv(struct vnt_private *pDevice, unsigned int uIdx)
 static void device_error(struct vnt_private *pDevice, unsigned short status)
 {
 	if (status & ISR_FETALERR) {
-		pr_err("%s: Hardware fatal error\n", pDevice->dev->name);
+		dev_err(&pDevice->pcid->dev, "Hardware fatal error\n");
+
 		netif_stop_queue(pDevice->dev);
 		del_timer(&pDevice->sTimerCommand);
 		del_timer(&(pDevice->pMgmt->sTimerSecondCallback));
-- 
1.9.1

