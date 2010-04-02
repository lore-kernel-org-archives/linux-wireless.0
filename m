Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:41444 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751279Ab0DBEKk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Apr 2010 00:10:40 -0400
Date: Fri, 2 Apr 2010 13:10:38 +0900
To: linux-wireless@vger.kernel.org
Cc: buytenh@wantstofly.org
Subject: [PATCH] mwl8k: use the dma state API instead of the pci equivalents
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Message-Id: <20100402130828O.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The DMA API is preferred.

No functional change.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/net/wireless/mwl8k.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index ac65e13..fe3c0e0 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -108,7 +108,7 @@ struct mwl8k_rx_queue {
 	dma_addr_t rxd_dma;
 	struct {
 		struct sk_buff *skb;
-		DECLARE_PCI_UNMAP_ADDR(dma)
+		DEFINE_DMA_UNMAP_ADDR(dma);
 	} *buf;
 };
 
@@ -964,7 +964,7 @@ static int rxq_refill(struct ieee80211_hw *hw, int index, int limit)
 		if (rxq->tail == MWL8K_RX_DESCS)
 			rxq->tail = 0;
 		rxq->buf[rx].skb = skb;
-		pci_unmap_addr_set(&rxq->buf[rx], dma, addr);
+		dma_unmap_addr_set(&rxq->buf[rx], dma, addr);
 
 		rxd = rxq->rxd + (rx * priv->rxd_ops->rxd_size);
 		priv->rxd_ops->rxd_refill(rxd, addr, MWL8K_RX_MAXSZ);
@@ -985,9 +985,9 @@ static void mwl8k_rxq_deinit(struct ieee80211_hw *hw, int index)
 	for (i = 0; i < MWL8K_RX_DESCS; i++) {
 		if (rxq->buf[i].skb != NULL) {
 			pci_unmap_single(priv->pdev,
-					 pci_unmap_addr(&rxq->buf[i], dma),
+					 dma_unmap_addr(&rxq->buf[i], dma),
 					 MWL8K_RX_MAXSZ, PCI_DMA_FROMDEVICE);
-			pci_unmap_addr_set(&rxq->buf[i], dma, 0);
+			dma_unmap_addr_set(&rxq->buf[i], dma, 0);
 
 			kfree_skb(rxq->buf[i].skb);
 			rxq->buf[i].skb = NULL;
@@ -1061,9 +1061,9 @@ static int rxq_process(struct ieee80211_hw *hw, int index, int limit)
 		rxq->buf[rxq->head].skb = NULL;
 
 		pci_unmap_single(priv->pdev,
-				 pci_unmap_addr(&rxq->buf[rxq->head], dma),
+				 dma_unmap_addr(&rxq->buf[rxq->head], dma),
 				 MWL8K_RX_MAXSZ, PCI_DMA_FROMDEVICE);
-		pci_unmap_addr_set(&rxq->buf[rxq->head], dma, 0);
+		dma_unmap_addr_set(&rxq->buf[rxq->head], dma, 0);
 
 		rxq->head++;
 		if (rxq->head == MWL8K_RX_DESCS)
-- 
1.7.0

