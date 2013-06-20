Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mxout1.netvision.net.il ([194.90.9.20]:47551 "EHLO
	mxout1.netvision.net.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965093Ab3FTNp6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Jun 2013 09:45:58 -0400
Received: from localhost.localdomain ([82.166.196.250])
 by mxout1.netvision.net.il
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTPA id <0MOP007AN28ER0C0@mxout1.netvision.net.il> for
 linux-wireless@vger.kernel.org; Thu, 20 Jun 2013 16:45:56 +0300 (IDT)
From: Kirshenbaum Erez <erezk@wilocity.com>
To: qca_vkondrat@qca.qualcomm.com
Cc: linux-wireless@vger.kernel.org,
	Kirshenbaum Erez <erezk@wilocity.com>
Subject: [PATCH 1/2] wil6210: set vring index for all descriptors
Date: Thu, 20 Jun 2013 15:45:25 +0300
Message-id: <1371732325-4112-1-git-send-email-erezk@wilocity.com> (sfid-20130620_154601_739242_0D89D9B9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The vring index (MAC queue id) must be set in all TX descriptors
otherwise HW will fail to release descriptors for a specific vring  
(disconnect or vring switch flows).
This is normally occurs when fragmentation required, if vring index 
will not be the same for all SKB descriptors HW will fail to flush this 
MAC queue.

Signed-off-by: Kirshenbaum Erez <erezk@wilocity.com>
---
 drivers/net/wireless/ath/wil6210/txrx.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/txrx.c b/drivers/net/wireless/ath/wil6210/txrx.c
index e1c492b..b79ba10 100644
--- a/drivers/net/wireless/ath/wil6210/txrx.c
+++ b/drivers/net/wireless/ath/wil6210/txrx.c
@@ -621,7 +621,8 @@ static struct vring *wil_find_tx_vring(struct wil6210_priv *wil,
 	return NULL;
 }
 
-static int wil_tx_desc_map(struct vring_tx_desc *d, dma_addr_t pa, u32 len)
+static int wil_tx_desc_map(struct vring_tx_desc *d, dma_addr_t pa, u32 len,
+			   int vring_index)
 {
 	wil_desc_addr_set(&d->dma.addr, pa);
 	d->dma.ip_length = 0;
@@ -631,6 +632,7 @@ static int wil_tx_desc_map(struct vring_tx_desc *d, dma_addr_t pa, u32 len)
 	d->dma.status = 0; /* BIT(0) should be 0 for HW_OWNED */
 	d->dma.length = cpu_to_le16((u16)len);
 	d->dma.d0 = 0;
+	d->dma.d0 = (vring_index << DMA_CFG_DESC_TX_0_QID_POS);
 	d->mac.d[0] = 0;
 	d->mac.d[1] = 0;
 	d->mac.d[2] = 0;
@@ -684,7 +686,7 @@ static int wil_tx_vring(struct wil6210_priv *wil, struct vring *vring,
 	if (unlikely(dma_mapping_error(dev, pa)))
 		return -EINVAL;
 	/* 1-st segment */
-	wil_tx_desc_map(d, pa, skb_headlen(skb));
+	wil_tx_desc_map(d, pa, skb_headlen(skb), vring_index);
 	d->mac.d[2] |= ((nr_frags + 1) <<
 		       MAC_CFG_DESC_TX_2_NUM_OF_DESCRIPTORS_POS);
 	if (nr_frags)
@@ -701,7 +703,7 @@ static int wil_tx_vring(struct wil6210_priv *wil, struct vring *vring,
 				DMA_TO_DEVICE);
 		if (unlikely(dma_mapping_error(dev, pa)))
 			goto dma_error;
-		wil_tx_desc_map(d, pa, len);
+		wil_tx_desc_map(d, pa, len, vring_index);
 		vring->ctx[i] = NULL;
 		*_d = *d;
 	}
@@ -709,7 +711,6 @@ static int wil_tx_vring(struct wil6210_priv *wil, struct vring *vring,
 	d->dma.d0 |= BIT(DMA_CFG_DESC_TX_0_CMD_EOP_POS);
 	d->dma.d0 |= BIT(9); /* BUG: undocumented bit */
 	d->dma.d0 |= BIT(DMA_CFG_DESC_TX_0_CMD_DMA_IT_POS);
-	d->dma.d0 |= (vring_index << DMA_CFG_DESC_TX_0_QID_POS);
 	*_d = *d;
 
 	wil_hex_dump_txrx("Tx ", DUMP_PREFIX_NONE, 32, 4,
-- 
1.7.11.7

