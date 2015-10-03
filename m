Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f182.google.com ([209.85.212.182]:35480 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750834AbbJCTam (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 3 Oct 2015 15:30:42 -0400
Received: by wicge5 with SMTP id ge5so72164386wic.0
        for <linux-wireless@vger.kernel.org>; Sat, 03 Oct 2015 12:30:41 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 2/6] staging: vt6655: device_main.c replace pDesc with desc.
Date: Sat,  3 Oct 2015 20:30:23 +0100
Message-Id: <1443900627-2924-2-git-send-email-tvboxspy@gmail.com> (sfid-20151003_213048_076097_CDFD2536)
In-Reply-To: <1443900627-2924-1-git-send-email-tvboxspy@gmail.com>
References: <1443900627-2924-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Removing camel case.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/device_main.c | 80 ++++++++++++++++++------------------
 1 file changed, 40 insertions(+), 40 deletions(-)

diff --git a/drivers/staging/vt6655/device_main.c b/drivers/staging/vt6655/device_main.c
index 603f189..41c08b3 100644
--- a/drivers/staging/vt6655/device_main.c
+++ b/drivers/staging/vt6655/device_main.c
@@ -545,19 +545,19 @@ static void device_init_rd0_ring(struct vnt_private *priv)
 {
 	int i;
 	dma_addr_t      curr = priv->rd0_pool_dma;
-	struct vnt_rx_desc *pDesc;
+	struct vnt_rx_desc *desc;
 
 	/* Init the RD0 ring entries */
 	for (i = 0; i < priv->sOpts.nRxDescs0;
 	     i ++, curr += sizeof(struct vnt_rx_desc)) {
-		pDesc = &(priv->aRD0Ring[i]);
-		pDesc->rd_info = alloc_rd_info();
+		desc = &priv->aRD0Ring[i];
+		desc->rd_info = alloc_rd_info();
 
-		if (!device_alloc_rx_buf(priv, pDesc))
+		if (!device_alloc_rx_buf(priv, desc))
 			dev_err(&priv->pcid->dev, "can not alloc rx bufs\n");
 
-		pDesc->next = &(priv->aRD0Ring[(i+1) % priv->sOpts.nRxDescs0]);
-		pDesc->next_desc = cpu_to_le32(curr + sizeof(struct vnt_rx_desc));
+		desc->next = &(priv->aRD0Ring[(i+1) % priv->sOpts.nRxDescs0]);
+		desc->next_desc = cpu_to_le32(curr + sizeof(struct vnt_rx_desc));
 	}
 
 	if (i > 0)
@@ -569,19 +569,19 @@ static void device_init_rd1_ring(struct vnt_private *priv)
 {
 	int i;
 	dma_addr_t      curr = priv->rd1_pool_dma;
-	struct vnt_rx_desc *pDesc;
+	struct vnt_rx_desc *desc;
 
 	/* Init the RD1 ring entries */
 	for (i = 0; i < priv->sOpts.nRxDescs1;
 	     i ++, curr += sizeof(struct vnt_rx_desc)) {
-		pDesc = &(priv->aRD1Ring[i]);
-		pDesc->rd_info = alloc_rd_info();
+		desc = &priv->aRD1Ring[i];
+		desc->rd_info = alloc_rd_info();
 
-		if (!device_alloc_rx_buf(priv, pDesc))
+		if (!device_alloc_rx_buf(priv, desc))
 			dev_err(&priv->pcid->dev, "can not alloc rx bufs\n");
 
-		pDesc->next = &(priv->aRD1Ring[(i+1) % priv->sOpts.nRxDescs1]);
-		pDesc->next_desc = cpu_to_le32(curr + sizeof(struct vnt_rx_desc));
+		desc->next = &(priv->aRD1Ring[(i+1) % priv->sOpts.nRxDescs1]);
+		desc->next_desc = cpu_to_le32(curr + sizeof(struct vnt_rx_desc));
 	}
 
 	if (i > 0)
@@ -594,15 +594,15 @@ static void device_free_rd0_ring(struct vnt_private *priv)
 	int i;
 
 	for (i = 0; i < priv->sOpts.nRxDescs0; i++) {
-		struct vnt_rx_desc *pDesc = &(priv->aRD0Ring[i]);
-		struct vnt_rd_info *rd_info = pDesc->rd_info;
+		struct vnt_rx_desc *desc = &(priv->aRD0Ring[i]);
+		struct vnt_rd_info *rd_info = desc->rd_info;
 
 		dma_unmap_single(&priv->pcid->dev, rd_info->skb_dma,
 				 priv->rx_buf_sz, DMA_FROM_DEVICE);
 
 		dev_kfree_skb(rd_info->skb);
 
-		kfree(pDesc->rd_info);
+		kfree(desc->rd_info);
 	}
 }
 
@@ -611,15 +611,15 @@ static void device_free_rd1_ring(struct vnt_private *priv)
 	int i;
 
 	for (i = 0; i < priv->sOpts.nRxDescs1; i++) {
-		struct vnt_rx_desc *pDesc = &(priv->aRD1Ring[i]);
-		struct vnt_rd_info *rd_info = pDesc->rd_info;
+		struct vnt_rx_desc *desc = &priv->aRD1Ring[i];
+		struct vnt_rd_info *rd_info = desc->rd_info;
 
 		dma_unmap_single(&priv->pcid->dev, rd_info->skb_dma,
 				 priv->rx_buf_sz, DMA_FROM_DEVICE);
 
 		dev_kfree_skb(rd_info->skb);
 
-		kfree(pDesc->rd_info);
+		kfree(desc->rd_info);
 	}
 }
 
@@ -627,19 +627,19 @@ static void device_init_td0_ring(struct vnt_private *priv)
 {
 	int i;
 	dma_addr_t  curr;
-	struct vnt_tx_desc *pDesc;
+	struct vnt_tx_desc *desc;
 
 	curr = priv->td0_pool_dma;
 	for (i = 0; i < priv->sOpts.nTxDescs[0];
 	     i++, curr += sizeof(struct vnt_tx_desc)) {
-		pDesc = &(priv->apTD0Rings[i]);
-		pDesc->td_info = alloc_td_info();
+		desc = &priv->apTD0Rings[i];
+		desc->td_info = alloc_td_info();
 
-		pDesc->td_info->buf = priv->tx0_bufs + i * PKT_BUF_SZ;
-		pDesc->td_info->buf_dma = priv->tx_bufs_dma0 + i * PKT_BUF_SZ;
+		desc->td_info->buf = priv->tx0_bufs + i * PKT_BUF_SZ;
+		desc->td_info->buf_dma = priv->tx_bufs_dma0 + i * PKT_BUF_SZ;
 
-		pDesc->next = &(priv->apTD0Rings[(i+1) % priv->sOpts.nTxDescs[0]]);
-		pDesc->next_desc = cpu_to_le32(curr + sizeof(struct vnt_tx_desc));
+		desc->next = &(priv->apTD0Rings[(i+1) % priv->sOpts.nTxDescs[0]]);
+		desc->next_desc = cpu_to_le32(curr + sizeof(struct vnt_tx_desc));
 	}
 
 	if (i > 0)
@@ -651,20 +651,20 @@ static void device_init_td1_ring(struct vnt_private *priv)
 {
 	int i;
 	dma_addr_t  curr;
-	struct vnt_tx_desc *pDesc;
+	struct vnt_tx_desc *desc;
 
 	/* Init the TD ring entries */
 	curr = priv->td1_pool_dma;
 	for (i = 0; i < priv->sOpts.nTxDescs[1];
 	     i++, curr += sizeof(struct vnt_tx_desc)) {
-		pDesc = &(priv->apTD1Rings[i]);
-		pDesc->td_info = alloc_td_info();
+		desc = &priv->apTD1Rings[i];
+		desc->td_info = alloc_td_info();
 
-		pDesc->td_info->buf = priv->tx1_bufs + i * PKT_BUF_SZ;
-		pDesc->td_info->buf_dma = priv->tx_bufs_dma1 + i * PKT_BUF_SZ;
+		desc->td_info->buf = priv->tx1_bufs + i * PKT_BUF_SZ;
+		desc->td_info->buf_dma = priv->tx_bufs_dma1 + i * PKT_BUF_SZ;
 
-		pDesc->next = &(priv->apTD1Rings[(i + 1) % priv->sOpts.nTxDescs[1]]);
-		pDesc->next_desc = cpu_to_le32(curr + sizeof(struct vnt_tx_desc));
+		desc->next = &(priv->apTD1Rings[(i + 1) % priv->sOpts.nTxDescs[1]]);
+		desc->next_desc = cpu_to_le32(curr + sizeof(struct vnt_tx_desc));
 	}
 
 	if (i > 0)
@@ -677,11 +677,11 @@ static void device_free_td0_ring(struct vnt_private *priv)
 	int i;
 
 	for (i = 0; i < priv->sOpts.nTxDescs[0]; i++) {
-		struct vnt_tx_desc *pDesc = &priv->apTD0Rings[i];
-		struct vnt_td_info *pTDInfo = pDesc->td_info;
+		struct vnt_tx_desc *desc = &priv->apTD0Rings[i];
+		struct vnt_td_info *pTDInfo = desc->td_info;
 
 		dev_kfree_skb(pTDInfo->skb);
-		kfree(pDesc->td_info);
+		kfree(desc->td_info);
 	}
 }
 
@@ -690,11 +690,11 @@ static void device_free_td1_ring(struct vnt_private *priv)
 	int i;
 
 	for (i = 0; i < priv->sOpts.nTxDescs[1]; i++) {
-		struct vnt_tx_desc *pDesc = &priv->apTD1Rings[i];
-		struct vnt_td_info *pTDInfo = pDesc->td_info;
+		struct vnt_tx_desc *desc = &priv->apTD1Rings[i];
+		struct vnt_td_info *pTDInfo = desc->td_info;
 
 		dev_kfree_skb(pTDInfo->skb);
-		kfree(pDesc->td_info);
+		kfree(desc->td_info);
 	}
 }
 
@@ -890,9 +890,9 @@ static void device_error(struct vnt_private *priv, unsigned short status)
 }
 
 static void device_free_tx_buf(struct vnt_private *priv,
-			       struct vnt_tx_desc *pDesc)
+			       struct vnt_tx_desc *desc)
 {
-	struct vnt_td_info *pTDInfo = pDesc->td_info;
+	struct vnt_td_info *pTDInfo = desc->td_info;
 	struct sk_buff *skb = pTDInfo->skb;
 
 	if (skb)
-- 
2.5.0

