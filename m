Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xi.wantstofly.org ([80.101.37.227]:45746 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755492AbZHRDx2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Aug 2009 23:53:28 -0400
Date: Tue, 18 Aug 2009 05:53:29 +0200
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: [PATCH 16/29] mwl8k: mwl8k_txq_xmit() rework
Message-ID: <20090818035329.GU18639@mail.wantstofly.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Various mwl8k_txq_xmit changes:
- Extract the QoS field before adding the DMA header.
- Only write to tx->status once, and only after all the other
  descriptor fields have been set.
- Do all tx state manipulation under the tx spinlock.
- Remove the priv->inconfig check, as all transmit queues will
  be frozen during config cycles, so we won't ever be asked to
  transmit if a config cycle is running.
- Remove some more dead code.

Signed-off-by: Lennert Buytenhek <buytenh@marvell.com>
---
 drivers/net/wireless/mwl8k.c |  145 +++++++++++++++---------------------------
 1 files changed, 52 insertions(+), 93 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index e46cf3c..f0d1fa7 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -1257,46 +1257,60 @@ mwl8k_txq_xmit(struct ieee80211_hw *hw, int index, struct sk_buff *skb)
 {
 	struct mwl8k_priv *priv = hw->priv;
 	struct ieee80211_tx_info *tx_info;
+	struct mwl8k_vif *mwl8k_vif;
 	struct ieee80211_hdr *wh;
 	struct mwl8k_tx_queue *txq;
 	struct mwl8k_tx_desc *tx;
-	struct mwl8k_dma_data *tr;
-	struct mwl8k_vif *mwl8k_vif;
 	dma_addr_t dma;
-	u16 qos = 0;
-	bool qosframe = false, ampduframe = false;
-	bool mcframe = false, eapolframe = false;
-	bool amsduframe = false;
-	__le16 fc;
+	u32 txstatus;
+	u8 txdatarate;
+	u16 qos;
 
-	txq = priv->txq + index;
-	tx = txq->tx_desc_area + txq->tx_tail;
-
-	BUG_ON(txq->tx_skb[txq->tx_tail] != NULL);
+	wh = (struct ieee80211_hdr *)skb->data;
+	if (ieee80211_is_data_qos(wh->frame_control))
+		qos = le16_to_cpu(*((__le16 *)ieee80211_get_qos_ctl(wh)));
+	else
+		qos = 0;
 
-	/*
-	 * Append HW DMA header to start of packet.
-	 */
 	mwl8k_add_dma_header(skb);
+	wh = &((struct mwl8k_dma_data *)skb->data)->wh;
 
 	tx_info = IEEE80211_SKB_CB(skb);
 	mwl8k_vif = MWL8K_VIF(tx_info->control.vif);
-	tr = (struct mwl8k_dma_data *)skb->data;
-	wh = &tr->wh;
-	fc = wh->frame_control;
-	qosframe = ieee80211_is_data_qos(fc);
-	mcframe = is_multicast_ether_addr(wh->addr1);
-	ampduframe = !!(tx_info->flags & IEEE80211_TX_CTL_AMPDU);
 
 	if (tx_info->flags & IEEE80211_TX_CTL_ASSIGN_SEQ) {
 		u16 seqno = mwl8k_vif->seqno;
+
 		wh->seq_ctrl &= cpu_to_le16(IEEE80211_SCTL_FRAG);
 		wh->seq_ctrl |= cpu_to_le16(seqno << 4);
 		mwl8k_vif->seqno = seqno++ % 4096;
 	}
 
-	if (qosframe)
-		qos = le16_to_cpu(*((__le16 *)ieee80211_get_qos_ctl(wh)));
+	/* Setup firmware control bit fields for each frame type.  */
+	txstatus = 0;
+	txdatarate = 0;
+	if (ieee80211_is_mgmt(wh->frame_control) ||
+	    ieee80211_is_ctl(wh->frame_control)) {
+		txdatarate = 0;
+		qos = mwl8k_qos_setbit_eosp(qos);
+		/* Set Queue size to unspecified */
+		qos = mwl8k_qos_setbit_qlen(qos, 0xff);
+	} else if (ieee80211_is_data(wh->frame_control)) {
+		txdatarate = 1;
+		if (is_multicast_ether_addr(wh->addr1))
+			txstatus |= MWL8K_TXD_STATUS_MULTICAST_TX;
+
+		/* Send pkt in an aggregate if AMPDU frame.  */
+		if (tx_info->flags & IEEE80211_TX_CTL_AMPDU)
+			qos = mwl8k_qos_setbit_ack(qos,
+				MWL8K_TXD_ACK_POLICY_BLOCKACK);
+		else
+			qos = mwl8k_qos_setbit_ack(qos,
+				MWL8K_TXD_ACK_POLICY_NORMAL);
+
+		if (qos & IEEE80211_QOS_CONTROL_A_MSDU_PRESENT)
+			qos = mwl8k_qos_setbit_amsdu(qos);
+	}
 
 	dma = pci_map_single(priv->pdev, skb->data,
 				skb->len, PCI_DMA_TODEVICE);
@@ -1304,95 +1318,40 @@ mwl8k_txq_xmit(struct ieee80211_hw *hw, int index, struct sk_buff *skb)
 	if (pci_dma_mapping_error(priv->pdev, dma)) {
 		printk(KERN_DEBUG "%s: failed to dma map skb, "
 			"dropping TX frame.\n", priv->name);
-
-		if (skb != NULL)
-			dev_kfree_skb(skb);
+		dev_kfree_skb(skb);
 		return NETDEV_TX_OK;
 	}
 
-	/* Set desc header, cpu bit order.  */
-	tx->status = 0;
-	tx->data_rate = 0;
-	tx->tx_priority = index;
-	tx->qos_control = 0;
-	tx->rate_info = 0;
-	tx->peer_id = mwl8k_vif->peer_id;
-
-	amsduframe = !!(qos & IEEE80211_QOS_CONTROL_A_MSDU_PRESENT);
-
-	/* Setup firmware control bit fields for each frame type.  */
-	if (ieee80211_is_mgmt(fc) || ieee80211_is_ctl(fc)) {
-		tx->data_rate = 0;
-		qos = mwl8k_qos_setbit_eosp(qos);
-		/* Set Queue size to unspecified */
-		qos = mwl8k_qos_setbit_qlen(qos, 0xff);
-	} else if (ieee80211_is_data(fc)) {
-		tx->data_rate = 1;
-		if (mcframe)
-			tx->status |= MWL8K_TXD_STATUS_MULTICAST_TX;
+	spin_lock_bh(&priv->tx_lock);
 
-		/*
-		 * Tell firmware to not send EAPOL pkts in an
-		 * aggregate.  Verify against mac80211 tx path.  If
-		 * stack turns off AMPDU for an EAPOL frame this
-		 * check will be removed.
-		 */
-		if (eapolframe) {
-			qos = mwl8k_qos_setbit_ack(qos,
-				MWL8K_TXD_ACK_POLICY_NORMAL);
-		} else {
-			/* Send pkt in an aggregate if AMPDU frame.  */
-			if (ampduframe)
-				qos = mwl8k_qos_setbit_ack(qos,
-					MWL8K_TXD_ACK_POLICY_BLOCKACK);
-			else
-				qos = mwl8k_qos_setbit_ack(qos,
-					MWL8K_TXD_ACK_POLICY_NORMAL);
+	txq = priv->txq + index;
 
-			if (amsduframe)
-				qos = mwl8k_qos_setbit_amsdu(qos);
-		}
-	}
+	BUG_ON(txq->tx_skb[txq->tx_tail] != NULL);
+	txq->tx_skb[txq->tx_tail] = skb;
 
-	/* Convert to little endian */
+	tx = txq->tx_desc_area + txq->tx_tail;
+	tx->data_rate = txdatarate;
+	tx->tx_priority = index;
 	tx->qos_control = cpu_to_le16(qos);
-	tx->status = cpu_to_le32(tx->status);
 	tx->pkt_phys_addr = cpu_to_le32(dma);
 	tx->pkt_len = cpu_to_le16(skb->len);
-
-	txq->tx_skb[txq->tx_tail] = skb;
-
-	spin_lock_bh(&priv->tx_lock);
-
-	tx->status = cpu_to_le32(MWL8K_TXD_STATUS_OK |
-					MWL8K_TXD_STATUS_FW_OWNED);
+	tx->rate_info = 0;
+	tx->peer_id = mwl8k_vif->peer_id;
 	wmb();
+	tx->status = cpu_to_le32(MWL8K_TXD_STATUS_FW_OWNED | txstatus);
+
+	txq->tx_stats.count++;
 	txq->tx_stats.len++;
 	priv->pending_tx_pkts++;
-	txq->tx_stats.count++;
-	txq->tx_tail++;
 
+	txq->tx_tail++;
 	if (txq->tx_tail == MWL8K_TX_DESCS)
 		txq->tx_tail = 0;
+
 	if (txq->tx_head == txq->tx_tail)
 		ieee80211_stop_queue(hw, index);
 
-	if (priv->inconfig) {
-		/*
-		 * Silently queue packet when we are in the middle of
-		 * a config cycle.  Notify firmware only if we are
-		 * waiting for TXQs to empty.  If a packet is sent
-		 * before .config() is complete, perhaps it is better
-		 * to drop the packet, as the channel is being changed
-		 * and the packet will end up on the wrong channel.
-		 */
-		printk(KERN_ERR "%s(): WARNING TX activity while "
-			"in config\n", __func__);
-
-		if (priv->tx_wait != NULL)
-			mwl8k_tx_start(priv);
-	} else
-		mwl8k_tx_start(priv);
+	mwl8k_tx_start(priv);
 
 	spin_unlock_bh(&priv->tx_lock);
 
-- 
1.5.6.4
