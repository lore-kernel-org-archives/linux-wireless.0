Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fw.wantstofly.org ([80.101.37.227]:59625 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756579AbZJVSxt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Oct 2009 14:53:49 -0400
Date: Thu, 22 Oct 2009 20:20:56 +0200
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 18/28] mwl8k: use pci_unmap_addr{,set}() to keep track of unmap addresses on rx
Message-ID: <20091022182056.GT1583@mail.wantstofly.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Instead of reading back the unmap address from the receive
descriptor when doing receive processing, use DECLARE_PCI_UNMAP_ADDR
and pci_unmap_addr{,set}() to keep track of these addresses.

Signed-off-by: Lennert Buytenhek <buytenh@marvell.com>
---
 drivers/net/wireless/mwl8k.c |   55 +++++++++++++++++++++++-------------------
 1 files changed, 30 insertions(+), 25 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index 703c306..96faec6 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -96,7 +96,10 @@ struct mwl8k_rx_queue {
 
 	struct mwl8k_rx_desc *rxd;
 	dma_addr_t rxd_dma;
-	struct sk_buff **skb;
+	struct {
+		struct sk_buff *skb;
+		DECLARE_PCI_UNMAP_ADDR(dma)
+	} *buf;
 };
 
 struct mwl8k_tx_queue {
@@ -790,14 +793,14 @@ static int mwl8k_rxq_init(struct ieee80211_hw *hw, int index)
 	}
 	memset(rxq->rxd, 0, size);
 
-	rxq->skb = kmalloc(MWL8K_RX_DESCS * sizeof(*rxq->skb), GFP_KERNEL);
-	if (rxq->skb == NULL) {
+	rxq->buf = kmalloc(MWL8K_RX_DESCS * sizeof(*rxq->buf), GFP_KERNEL);
+	if (rxq->buf == NULL) {
 		printk(KERN_ERR "%s: failed to alloc RX skbuff list\n",
 		       wiphy_name(hw->wiphy));
 		pci_free_consistent(priv->pdev, size, rxq->rxd, rxq->rxd_dma);
 		return -ENOMEM;
 	}
-	memset(rxq->skb, 0, MWL8K_RX_DESCS * sizeof(*rxq->skb));
+	memset(rxq->buf, 0, MWL8K_RX_DESCS * sizeof(*rxq->buf));
 
 	for (i = 0; i < MWL8K_RX_DESCS; i++) {
 		struct mwl8k_rx_desc *rx_desc;
@@ -823,6 +826,7 @@ static int rxq_refill(struct ieee80211_hw *hw, int index, int limit)
 	refilled = 0;
 	while (rxq->rxd_count < MWL8K_RX_DESCS && limit--) {
 		struct sk_buff *skb;
+		dma_addr_t addr;
 		int rx;
 
 		skb = dev_alloc_skb(MWL8K_RX_MAXSZ);
@@ -834,12 +838,13 @@ static int rxq_refill(struct ieee80211_hw *hw, int index, int limit)
 		rx = rxq->tail;
 		rxq->tail = (rx + 1) % MWL8K_RX_DESCS;
 
-		rxq->rxd[rx].pkt_phys_addr =
-			cpu_to_le32(pci_map_single(priv->pdev, skb->data,
-					MWL8K_RX_MAXSZ, DMA_FROM_DEVICE));
+		addr = pci_map_single(priv->pdev, skb->data,
+				      MWL8K_RX_MAXSZ, DMA_FROM_DEVICE);
 
 		rxq->rxd[rx].pkt_len = cpu_to_le16(MWL8K_RX_MAXSZ);
-		rxq->skb[rx] = skb;
+		rxq->rxd[rx].pkt_phys_addr = cpu_to_le32(addr);
+		rxq->buf[rx].skb = skb;
+		pci_unmap_addr_set(&rxq->buf[rx], dma, addr);
 		wmb();
 		rxq->rxd[rx].rx_ctrl = 0;
 
@@ -857,19 +862,19 @@ static void mwl8k_rxq_deinit(struct ieee80211_hw *hw, int index)
 	int i;
 
 	for (i = 0; i < MWL8K_RX_DESCS; i++) {
-		if (rxq->skb[i] != NULL) {
-			unsigned long addr;
-
-			addr = le32_to_cpu(rxq->rxd[i].pkt_phys_addr);
-			pci_unmap_single(priv->pdev, addr, MWL8K_RX_MAXSZ,
-					 PCI_DMA_FROMDEVICE);
-			kfree_skb(rxq->skb[i]);
-			rxq->skb[i] = NULL;
+		if (rxq->buf[i].skb != NULL) {
+			pci_unmap_single(priv->pdev,
+					 pci_unmap_addr(&rxq->buf[i], dma),
+					 MWL8K_RX_MAXSZ, PCI_DMA_FROMDEVICE);
+			pci_unmap_addr_set(&rxq->buf[i], dma, 0);
+
+			kfree_skb(rxq->buf[i].skb);
+			rxq->buf[i].skb = NULL;
 		}
 	}
 
-	kfree(rxq->skb);
-	rxq->skb = NULL;
+	kfree(rxq->buf);
+	rxq->buf = NULL;
 
 	pci_free_consistent(priv->pdev,
 			    MWL8K_RX_DESCS * sizeof(struct mwl8k_rx_desc),
@@ -919,7 +924,6 @@ static int rxq_process(struct ieee80211_hw *hw, int index, int limit)
 		struct mwl8k_rx_desc *rx_desc;
 		struct sk_buff *skb;
 		struct ieee80211_rx_status status;
-		unsigned long addr;
 		struct ieee80211_hdr *wh;
 		u16 rate_info;
 
@@ -928,18 +932,19 @@ static int rxq_process(struct ieee80211_hw *hw, int index, int limit)
 			break;
 		rmb();
 
-		skb = rxq->skb[rxq->head];
+		skb = rxq->buf[rxq->head].skb;
 		if (skb == NULL)
 			break;
-		rxq->skb[rxq->head] = NULL;
+		rxq->buf[rxq->head].skb = NULL;
+
+		pci_unmap_single(priv->pdev,
+				 pci_unmap_addr(&rxq->buf[rxq->head], dma),
+				 MWL8K_RX_MAXSZ, PCI_DMA_FROMDEVICE);
+		pci_unmap_addr_set(&rxq->buf[rxq->head], dma, 0);
 
 		rxq->head = (rxq->head + 1) % MWL8K_RX_DESCS;
 		rxq->rxd_count--;
 
-		addr = le32_to_cpu(rx_desc->pkt_phys_addr);
-		pci_unmap_single(priv->pdev, addr,
-					MWL8K_RX_MAXSZ, PCI_DMA_FROMDEVICE);
-
 		skb_put(skb, le16_to_cpu(rx_desc->pkt_len));
 		mwl8k_remove_dma_header(skb);
 
-- 
1.5.6.4
