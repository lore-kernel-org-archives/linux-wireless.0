Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fw.wantstofly.org ([80.101.37.227]:59631 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756627AbZJVSxu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Oct 2009 14:53:50 -0400
Date: Thu, 22 Oct 2009 20:20:40 +0200
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 13/28] mwl8k: shorten receive/transmit state variable names
Message-ID: <20091022182040.GO1583@mail.wantstofly.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

To conserve horizontal space.

Signed-off-by: Lennert Buytenhek <buytenh@marvell.com>
---
 drivers/net/wireless/mwl8k.c |  194 ++++++++++++++++++++----------------------
 1 files changed, 93 insertions(+), 101 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index 60b0076..f282550 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -87,30 +87,30 @@ MODULE_DEVICE_TABLE(pci, mwl8k_table);
 #define MWL8K_TX_QUEUES		4
 
 struct mwl8k_rx_queue {
-	int rx_desc_count;
+	int rxd_count;
 
 	/* hw receives here */
-	int rx_head;
+	int head;
 
 	/* refill descs here */
-	int rx_tail;
+	int tail;
 
-	struct mwl8k_rx_desc *rx_desc_area;
-	dma_addr_t rx_desc_dma;
-	struct sk_buff **rx_skb;
+	struct mwl8k_rx_desc *rxd;
+	dma_addr_t rxd_dma;
+	struct sk_buff **skb;
 };
 
 struct mwl8k_tx_queue {
 	/* hw transmits here */
-	int tx_head;
+	int head;
 
 	/* sw appends here */
-	int tx_tail;
+	int tail;
 
-	struct ieee80211_tx_queue_stats tx_stats;
-	struct mwl8k_tx_desc *tx_desc_area;
-	dma_addr_t tx_desc_dma;
-	struct sk_buff **tx_skb;
+	struct ieee80211_tx_queue_stats stats;
+	struct mwl8k_tx_desc *txd;
+	dma_addr_t txd_dma;
+	struct sk_buff **skb;
 };
 
 /* Pointers to the firmware data and meta information about it.  */
@@ -737,7 +737,7 @@ struct mwl8k_rx_desc {
 	__u8 link_quality;
 	__u8 noise_level;
 	__le32 pkt_phys_addr;
-	__le32 next_rx_desc_phys_addr;
+	__le32 next_rxd_phys_addr;
 	__le16 qos_control;
 	__le16 rate_info;
 	__le32 pad0[4];
@@ -766,42 +766,38 @@ static int mwl8k_rxq_init(struct ieee80211_hw *hw, int index)
 	int size;
 	int i;
 
-	rxq->rx_desc_count = 0;
-	rxq->rx_head = 0;
-	rxq->rx_tail = 0;
+	rxq->rxd_count = 0;
+	rxq->head = 0;
+	rxq->tail = 0;
 
 	size = MWL8K_RX_DESCS * sizeof(struct mwl8k_rx_desc);
 
-	rxq->rx_desc_area =
-		pci_alloc_consistent(priv->pdev, size, &rxq->rx_desc_dma);
-	if (rxq->rx_desc_area == NULL) {
+	rxq->rxd = pci_alloc_consistent(priv->pdev, size, &rxq->rxd_dma);
+	if (rxq->rxd == NULL) {
 		printk(KERN_ERR "%s: failed to alloc RX descriptors\n",
 		       wiphy_name(hw->wiphy));
 		return -ENOMEM;
 	}
-	memset(rxq->rx_desc_area, 0, size);
+	memset(rxq->rxd, 0, size);
 
-	rxq->rx_skb = kmalloc(MWL8K_RX_DESCS *
-				sizeof(*rxq->rx_skb), GFP_KERNEL);
-	if (rxq->rx_skb == NULL) {
+	rxq->skb = kmalloc(MWL8K_RX_DESCS * sizeof(*rxq->skb), GFP_KERNEL);
+	if (rxq->skb == NULL) {
 		printk(KERN_ERR "%s: failed to alloc RX skbuff list\n",
 		       wiphy_name(hw->wiphy));
-		pci_free_consistent(priv->pdev, size,
-				    rxq->rx_desc_area, rxq->rx_desc_dma);
+		pci_free_consistent(priv->pdev, size, rxq->rxd, rxq->rxd_dma);
 		return -ENOMEM;
 	}
-	memset(rxq->rx_skb, 0, MWL8K_RX_DESCS * sizeof(*rxq->rx_skb));
+	memset(rxq->skb, 0, MWL8K_RX_DESCS * sizeof(*rxq->skb));
 
 	for (i = 0; i < MWL8K_RX_DESCS; i++) {
 		struct mwl8k_rx_desc *rx_desc;
 		int nexti;
 
-		rx_desc = rxq->rx_desc_area + i;
+		rx_desc = rxq->rxd + i;
 		nexti = (i + 1) % MWL8K_RX_DESCS;
 
-		rx_desc->next_rx_desc_phys_addr =
-			cpu_to_le32(rxq->rx_desc_dma
-						+ nexti * sizeof(*rx_desc));
+		rx_desc->next_rxd_phys_addr =
+			cpu_to_le32(rxq->rxd_dma + nexti * sizeof(*rx_desc));
 		rx_desc->rx_ctrl = MWL8K_RX_CTRL_OWNED_BY_HOST;
 	}
 
@@ -815,7 +811,7 @@ static int rxq_refill(struct ieee80211_hw *hw, int index, int limit)
 	int refilled;
 
 	refilled = 0;
-	while (rxq->rx_desc_count < MWL8K_RX_DESCS && limit--) {
+	while (rxq->rxd_count < MWL8K_RX_DESCS && limit--) {
 		struct sk_buff *skb;
 		int rx;
 
@@ -823,19 +819,19 @@ static int rxq_refill(struct ieee80211_hw *hw, int index, int limit)
 		if (skb == NULL)
 			break;
 
-		rxq->rx_desc_count++;
+		rxq->rxd_count++;
 
-		rx = rxq->rx_tail;
-		rxq->rx_tail = (rx + 1) % MWL8K_RX_DESCS;
+		rx = rxq->tail;
+		rxq->tail = (rx + 1) % MWL8K_RX_DESCS;
 
-		rxq->rx_desc_area[rx].pkt_phys_addr =
+		rxq->rxd[rx].pkt_phys_addr =
 			cpu_to_le32(pci_map_single(priv->pdev, skb->data,
 					MWL8K_RX_MAXSZ, DMA_FROM_DEVICE));
 
-		rxq->rx_desc_area[rx].pkt_len = cpu_to_le16(MWL8K_RX_MAXSZ);
-		rxq->rx_skb[rx] = skb;
+		rxq->rxd[rx].pkt_len = cpu_to_le16(MWL8K_RX_MAXSZ);
+		rxq->skb[rx] = skb;
 		wmb();
-		rxq->rx_desc_area[rx].rx_ctrl = 0;
+		rxq->rxd[rx].rx_ctrl = 0;
 
 		refilled++;
 	}
@@ -851,24 +847,24 @@ static void mwl8k_rxq_deinit(struct ieee80211_hw *hw, int index)
 	int i;
 
 	for (i = 0; i < MWL8K_RX_DESCS; i++) {
-		if (rxq->rx_skb[i] != NULL) {
+		if (rxq->skb[i] != NULL) {
 			unsigned long addr;
 
-			addr = le32_to_cpu(rxq->rx_desc_area[i].pkt_phys_addr);
+			addr = le32_to_cpu(rxq->rxd[i].pkt_phys_addr);
 			pci_unmap_single(priv->pdev, addr, MWL8K_RX_MAXSZ,
 					 PCI_DMA_FROMDEVICE);
-			kfree_skb(rxq->rx_skb[i]);
-			rxq->rx_skb[i] = NULL;
+			kfree_skb(rxq->skb[i]);
+			rxq->skb[i] = NULL;
 		}
 	}
 
-	kfree(rxq->rx_skb);
-	rxq->rx_skb = NULL;
+	kfree(rxq->skb);
+	rxq->skb = NULL;
 
 	pci_free_consistent(priv->pdev,
 			    MWL8K_RX_DESCS * sizeof(struct mwl8k_rx_desc),
-			    rxq->rx_desc_area, rxq->rx_desc_dma);
-	rxq->rx_desc_area = NULL;
+			    rxq->rxd, rxq->rxd_dma);
+	rxq->rxd = NULL;
 }
 
 
@@ -909,7 +905,7 @@ static int rxq_process(struct ieee80211_hw *hw, int index, int limit)
 	int processed;
 
 	processed = 0;
-	while (rxq->rx_desc_count && limit--) {
+	while (rxq->rxd_count && limit--) {
 		struct mwl8k_rx_desc *rx_desc;
 		struct sk_buff *skb;
 		struct ieee80211_rx_status status;
@@ -917,18 +913,18 @@ static int rxq_process(struct ieee80211_hw *hw, int index, int limit)
 		struct ieee80211_hdr *wh;
 		u16 rate_info;
 
-		rx_desc = rxq->rx_desc_area + rxq->rx_head;
+		rx_desc = rxq->rxd + rxq->head;
 		if (!(rx_desc->rx_ctrl & MWL8K_RX_CTRL_OWNED_BY_HOST))
 			break;
 		rmb();
 
-		skb = rxq->rx_skb[rxq->rx_head];
+		skb = rxq->skb[rxq->head];
 		if (skb == NULL)
 			break;
-		rxq->rx_skb[rxq->rx_head] = NULL;
+		rxq->skb[rxq->head] = NULL;
 
-		rxq->rx_head = (rxq->rx_head + 1) % MWL8K_RX_DESCS;
-		rxq->rx_desc_count--;
+		rxq->head = (rxq->head + 1) % MWL8K_RX_DESCS;
+		rxq->rxd_count--;
 
 		addr = le32_to_cpu(rx_desc->pkt_phys_addr);
 		pci_unmap_single(priv->pdev, addr,
@@ -999,7 +995,7 @@ struct mwl8k_tx_desc {
 	__le32 pkt_phys_addr;
 	__le16 pkt_len;
 	__u8 dest_MAC_addr[ETH_ALEN];
-	__le32 next_tx_desc_phys_addr;
+	__le32 next_txd_phys_addr;
 	__le32 reserved;
 	__le16 rate_info;
 	__u8 peer_id;
@@ -1015,44 +1011,40 @@ static int mwl8k_txq_init(struct ieee80211_hw *hw, int index)
 	int size;
 	int i;
 
-	memset(&txq->tx_stats, 0, sizeof(struct ieee80211_tx_queue_stats));
-	txq->tx_stats.limit = MWL8K_TX_DESCS;
-	txq->tx_head = 0;
-	txq->tx_tail = 0;
+	memset(&txq->stats, 0, sizeof(struct ieee80211_tx_queue_stats));
+	txq->stats.limit = MWL8K_TX_DESCS;
+	txq->head = 0;
+	txq->tail = 0;
 
 	size = MWL8K_TX_DESCS * sizeof(struct mwl8k_tx_desc);
 
-	txq->tx_desc_area =
-		pci_alloc_consistent(priv->pdev, size, &txq->tx_desc_dma);
-	if (txq->tx_desc_area == NULL) {
+	txq->txd = pci_alloc_consistent(priv->pdev, size, &txq->txd_dma);
+	if (txq->txd == NULL) {
 		printk(KERN_ERR "%s: failed to alloc TX descriptors\n",
 		       wiphy_name(hw->wiphy));
 		return -ENOMEM;
 	}
-	memset(txq->tx_desc_area, 0, size);
+	memset(txq->txd, 0, size);
 
-	txq->tx_skb = kmalloc(MWL8K_TX_DESCS * sizeof(*txq->tx_skb),
-								GFP_KERNEL);
-	if (txq->tx_skb == NULL) {
+	txq->skb = kmalloc(MWL8K_TX_DESCS * sizeof(*txq->skb), GFP_KERNEL);
+	if (txq->skb == NULL) {
 		printk(KERN_ERR "%s: failed to alloc TX skbuff list\n",
 		       wiphy_name(hw->wiphy));
-		pci_free_consistent(priv->pdev, size,
-				    txq->tx_desc_area, txq->tx_desc_dma);
+		pci_free_consistent(priv->pdev, size, txq->txd, txq->txd_dma);
 		return -ENOMEM;
 	}
-	memset(txq->tx_skb, 0, MWL8K_TX_DESCS * sizeof(*txq->tx_skb));
+	memset(txq->skb, 0, MWL8K_TX_DESCS * sizeof(*txq->skb));
 
 	for (i = 0; i < MWL8K_TX_DESCS; i++) {
 		struct mwl8k_tx_desc *tx_desc;
 		int nexti;
 
-		tx_desc = txq->tx_desc_area + i;
+		tx_desc = txq->txd + i;
 		nexti = (i + 1) % MWL8K_TX_DESCS;
 
 		tx_desc->status = 0;
-		tx_desc->next_tx_desc_phys_addr =
-			cpu_to_le32(txq->tx_desc_dma +
-						nexti * sizeof(*tx_desc));
+		tx_desc->next_txd_phys_addr =
+			cpu_to_le32(txq->txd_dma + nexti * sizeof(*tx_desc));
 	}
 
 	return 0;
@@ -1088,11 +1080,11 @@ static int mwl8k_scan_tx_ring(struct mwl8k_priv *priv,
 
 	for (count = 0; count < MWL8K_TX_QUEUES; count++) {
 		txq = priv->txq + count;
-		txinfo[count].len = txq->tx_stats.len;
-		txinfo[count].head = txq->tx_head;
-		txinfo[count].tail = txq->tx_tail;
+		txinfo[count].len = txq->stats.len;
+		txinfo[count].head = txq->head;
+		txinfo[count].tail = txq->tail;
 		for (desc = 0; desc < MWL8K_TX_DESCS; desc++) {
-			tx_desc = txq->tx_desc_area + desc;
+			tx_desc = txq->txd + desc;
 			status = le32_to_cpu(tx_desc->status);
 
 			if (status & MWL8K_TXD_STATUS_FW_OWNED)
@@ -1173,7 +1165,7 @@ static void mwl8k_txq_reclaim(struct ieee80211_hw *hw, int index, int force)
 	struct mwl8k_tx_queue *txq = priv->txq + index;
 	int wake = 0;
 
-	while (txq->tx_stats.len > 0) {
+	while (txq->stats.len > 0) {
 		int tx;
 		struct mwl8k_tx_desc *tx_desc;
 		unsigned long addr;
@@ -1182,8 +1174,8 @@ static void mwl8k_txq_reclaim(struct ieee80211_hw *hw, int index, int force)
 		struct ieee80211_tx_info *info;
 		u32 status;
 
-		tx = txq->tx_head;
-		tx_desc = txq->tx_desc_area + tx;
+		tx = txq->head;
+		tx_desc = txq->txd + tx;
 
 		status = le32_to_cpu(tx_desc->status);
 
@@ -1194,15 +1186,15 @@ static void mwl8k_txq_reclaim(struct ieee80211_hw *hw, int index, int force)
 				~cpu_to_le32(MWL8K_TXD_STATUS_FW_OWNED);
 		}
 
-		txq->tx_head = (tx + 1) % MWL8K_TX_DESCS;
-		BUG_ON(txq->tx_stats.len == 0);
-		txq->tx_stats.len--;
+		txq->head = (tx + 1) % MWL8K_TX_DESCS;
+		BUG_ON(txq->stats.len == 0);
+		txq->stats.len--;
 		priv->pending_tx_pkts--;
 
 		addr = le32_to_cpu(tx_desc->pkt_phys_addr);
 		size = le16_to_cpu(tx_desc->pkt_len);
-		skb = txq->tx_skb[tx];
-		txq->tx_skb[tx] = NULL;
+		skb = txq->skb[tx];
+		txq->skb[tx] = NULL;
 
 		BUG_ON(skb == NULL);
 		pci_unmap_single(priv->pdev, addr, size, PCI_DMA_TODEVICE);
@@ -1235,13 +1227,13 @@ static void mwl8k_txq_deinit(struct ieee80211_hw *hw, int index)
 
 	mwl8k_txq_reclaim(hw, index, 1);
 
-	kfree(txq->tx_skb);
-	txq->tx_skb = NULL;
+	kfree(txq->skb);
+	txq->skb = NULL;
 
 	pci_free_consistent(priv->pdev,
 			    MWL8K_TX_DESCS * sizeof(struct mwl8k_tx_desc),
-			    txq->tx_desc_area, txq->tx_desc_dma);
-	txq->tx_desc_area = NULL;
+			    txq->txd, txq->txd_dma);
+	txq->txd = NULL;
 }
 
 static int
@@ -1318,10 +1310,10 @@ mwl8k_txq_xmit(struct ieee80211_hw *hw, int index, struct sk_buff *skb)
 
 	txq = priv->txq + index;
 
-	BUG_ON(txq->tx_skb[txq->tx_tail] != NULL);
-	txq->tx_skb[txq->tx_tail] = skb;
+	BUG_ON(txq->skb[txq->tail] != NULL);
+	txq->skb[txq->tail] = skb;
 
-	tx = txq->tx_desc_area + txq->tx_tail;
+	tx = txq->txd + txq->tail;
 	tx->data_rate = txdatarate;
 	tx->tx_priority = index;
 	tx->qos_control = cpu_to_le16(qos);
@@ -1332,15 +1324,15 @@ mwl8k_txq_xmit(struct ieee80211_hw *hw, int index, struct sk_buff *skb)
 	wmb();
 	tx->status = cpu_to_le32(MWL8K_TXD_STATUS_FW_OWNED | txstatus);
 
-	txq->tx_stats.count++;
-	txq->tx_stats.len++;
+	txq->stats.count++;
+	txq->stats.len++;
 	priv->pending_tx_pkts++;
 
-	txq->tx_tail++;
-	if (txq->tx_tail == MWL8K_TX_DESCS)
-		txq->tx_tail = 0;
+	txq->tail++;
+	if (txq->tail == MWL8K_TX_DESCS)
+		txq->tail = 0;
 
-	if (txq->tx_head == txq->tx_tail)
+	if (txq->head == txq->tail)
 		ieee80211_stop_queue(hw, index);
 
 	mwl8k_tx_start(priv);
@@ -1491,7 +1483,7 @@ struct mwl8k_cmd_get_hw_spec {
 	__le32 tx_queue_ptrs[MWL8K_TX_QUEUES];
 	__le32 caps2;
 	__le32 num_tx_desc_per_queue;
-	__le32 total_rx_desc;
+	__le32 total_rxd;
 } __attribute__((packed));
 
 static int mwl8k_cmd_get_hw_spec(struct ieee80211_hw *hw)
@@ -1510,12 +1502,12 @@ static int mwl8k_cmd_get_hw_spec(struct ieee80211_hw *hw)
 
 	memset(cmd->perm_addr, 0xff, sizeof(cmd->perm_addr));
 	cmd->ps_cookie = cpu_to_le32(priv->cookie_dma);
-	cmd->rx_queue_ptr = cpu_to_le32(priv->rxq[0].rx_desc_dma);
+	cmd->rx_queue_ptr = cpu_to_le32(priv->rxq[0].rxd_dma);
 	cmd->num_tx_queues = cpu_to_le32(MWL8K_TX_QUEUES);
 	for (i = 0; i < MWL8K_TX_QUEUES; i++)
-		cmd->tx_queue_ptrs[i] = cpu_to_le32(priv->txq[i].tx_desc_dma);
+		cmd->tx_queue_ptrs[i] = cpu_to_le32(priv->txq[i].txd_dma);
 	cmd->num_tx_desc_per_queue = cpu_to_le32(MWL8K_TX_DESCS);
-	cmd->total_rx_desc = cpu_to_le32(MWL8K_RX_DESCS);
+	cmd->total_rxd = cpu_to_le32(MWL8K_RX_DESCS);
 
 	rc = mwl8k_post_cmd(hw, &cmd->header);
 
@@ -2887,7 +2879,7 @@ static int mwl8k_get_tx_stats(struct ieee80211_hw *hw,
 	spin_lock_bh(&priv->tx_lock);
 	for (index = 0; index < MWL8K_TX_QUEUES; index++) {
 		txq = priv->txq + index;
-		memcpy(&stats[index], &txq->tx_stats,
+		memcpy(&stats[index], &txq->stats,
 			sizeof(struct ieee80211_tx_queue_stats));
 	}
 	spin_unlock_bh(&priv->tx_lock);
-- 
1.5.6.4

