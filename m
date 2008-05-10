Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.184]:20731 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752934AbYEJMKV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 May 2008 08:10:21 -0400
Received: by nf-out-0910.google.com with SMTP id d3so883151nfc.21
        for <linux-wireless@vger.kernel.org>; Sat, 10 May 2008 05:10:20 -0700 (PDT)
To: linville@tuxdriver.com
Subject: [PATCH 14/16] rt2x00: Merge RX and TX entry private data
Date: Sat, 10 May 2008 13:46:03 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200805101337.14536.IvDoorn@gmail.com>
In-Reply-To: <200805101337.14536.IvDoorn@gmail.com>
MIME-Version: 1.0
Message-Id: <200805101346.03694.IvDoorn@gmail.com> (sfid-20080510_141036_295617_26B661E6)
Content-Type: text/plain;
  charset="utf-8"
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

With the pending removal of the tx_control structure
we can merge the RX and TX entry private data structure
in advance. This will temporarily increase the required
memory for the queue, but that overhead will only be limited.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2400pci.c |   78 ++++++++--------
 drivers/net/wireless/rt2x00/rt2500pci.c |   72 ++++++++--------
 drivers/net/wireless/rt2x00/rt2500usb.c |   33 ++++----
 drivers/net/wireless/rt2x00/rt2x00pci.c |   89 ++++++-------------
 drivers/net/wireless/rt2x00/rt2x00pci.h |   22 +----
 drivers/net/wireless/rt2x00/rt2x00usb.c |  144 +++++++++++++------------------
 drivers/net/wireless/rt2x00/rt2x00usb.h |   17 +---
 drivers/net/wireless/rt2x00/rt61pci.c   |   69 +++++++--------
 drivers/net/wireless/rt2x00/rt73usb.c   |    6 +-
 9 files changed, 223 insertions(+), 307 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2400pci.c b/drivers/net/wireless/rt2x00/rt2400pci.c
index 8c9f961..33e7750 100644
--- a/drivers/net/wireless/rt2x00/rt2400pci.c
+++ b/drivers/net/wireless/rt2x00/rt2400pci.c
@@ -620,39 +620,38 @@ static void rt2400pci_link_tuner(struct rt2x00_dev *rt2x00dev)
 static void rt2400pci_init_rxentry(struct rt2x00_dev *rt2x00dev,
 				   struct queue_entry *entry)
 {
-	struct queue_entry_priv_pci_rx *priv_rx = entry->priv_data;
+	struct queue_entry_priv_pci *entry_priv = entry->priv_data;
 	u32 word;
 
-	rt2x00_desc_read(priv_rx->desc, 2, &word);
+	rt2x00_desc_read(entry_priv->desc, 2, &word);
 	rt2x00_set_field32(&word, RXD_W2_BUFFER_LENGTH,
 			   entry->queue->data_size);
-	rt2x00_desc_write(priv_rx->desc, 2, word);
+	rt2x00_desc_write(entry_priv->desc, 2, word);
 
-	rt2x00_desc_read(priv_rx->desc, 1, &word);
-	rt2x00_set_field32(&word, RXD_W1_BUFFER_ADDRESS, priv_rx->data_dma);
-	rt2x00_desc_write(priv_rx->desc, 1, word);
+	rt2x00_desc_read(entry_priv->desc, 1, &word);
+	rt2x00_set_field32(&word, RXD_W1_BUFFER_ADDRESS, entry_priv->data_dma);
+	rt2x00_desc_write(entry_priv->desc, 1, word);
 
-	rt2x00_desc_read(priv_rx->desc, 0, &word);
+	rt2x00_desc_read(entry_priv->desc, 0, &word);
 	rt2x00_set_field32(&word, RXD_W0_OWNER_NIC, 1);
-	rt2x00_desc_write(priv_rx->desc, 0, word);
+	rt2x00_desc_write(entry_priv->desc, 0, word);
 }
 
 static void rt2400pci_init_txentry(struct rt2x00_dev *rt2x00dev,
 				   struct queue_entry *entry)
 {
-	struct queue_entry_priv_pci_tx *priv_tx = entry->priv_data;
+	struct queue_entry_priv_pci *entry_priv = entry->priv_data;
 	u32 word;
 
-	rt2x00_desc_read(priv_tx->desc, 0, &word);
+	rt2x00_desc_read(entry_priv->desc, 0, &word);
 	rt2x00_set_field32(&word, TXD_W0_VALID, 0);
 	rt2x00_set_field32(&word, TXD_W0_OWNER_NIC, 0);
-	rt2x00_desc_write(priv_tx->desc, 0, word);
+	rt2x00_desc_write(entry_priv->desc, 0, word);
 }
 
 static int rt2400pci_init_queues(struct rt2x00_dev *rt2x00dev)
 {
-	struct queue_entry_priv_pci_rx *priv_rx;
-	struct queue_entry_priv_pci_tx *priv_tx;
+	struct queue_entry_priv_pci *entry_priv;
 	u32 reg;
 
 	/*
@@ -665,28 +664,28 @@ static int rt2400pci_init_queues(struct rt2x00_dev *rt2x00dev)
 	rt2x00_set_field32(&reg, TXCSR2_NUM_PRIO, rt2x00dev->tx[0].limit);
 	rt2x00pci_register_write(rt2x00dev, TXCSR2, reg);
 
-	priv_tx = rt2x00dev->tx[1].entries[0].priv_data;
+	entry_priv = rt2x00dev->tx[1].entries[0].priv_data;
 	rt2x00pci_register_read(rt2x00dev, TXCSR3, &reg);
 	rt2x00_set_field32(&reg, TXCSR3_TX_RING_REGISTER,
-			   priv_tx->desc_dma);
+			   entry_priv->desc_dma);
 	rt2x00pci_register_write(rt2x00dev, TXCSR3, reg);
 
-	priv_tx = rt2x00dev->tx[0].entries[0].priv_data;
+	entry_priv = rt2x00dev->tx[0].entries[0].priv_data;
 	rt2x00pci_register_read(rt2x00dev, TXCSR5, &reg);
 	rt2x00_set_field32(&reg, TXCSR5_PRIO_RING_REGISTER,
-			   priv_tx->desc_dma);
+			   entry_priv->desc_dma);
 	rt2x00pci_register_write(rt2x00dev, TXCSR5, reg);
 
-	priv_tx = rt2x00dev->bcn[1].entries[0].priv_data;
+	entry_priv = rt2x00dev->bcn[1].entries[0].priv_data;
 	rt2x00pci_register_read(rt2x00dev, TXCSR4, &reg);
 	rt2x00_set_field32(&reg, TXCSR4_ATIM_RING_REGISTER,
-			   priv_tx->desc_dma);
+			   entry_priv->desc_dma);
 	rt2x00pci_register_write(rt2x00dev, TXCSR4, reg);
 
-	priv_tx = rt2x00dev->bcn[0].entries[0].priv_data;
+	entry_priv = rt2x00dev->bcn[0].entries[0].priv_data;
 	rt2x00pci_register_read(rt2x00dev, TXCSR6, &reg);
 	rt2x00_set_field32(&reg, TXCSR6_BEACON_RING_REGISTER,
-			   priv_tx->desc_dma);
+			   entry_priv->desc_dma);
 	rt2x00pci_register_write(rt2x00dev, TXCSR6, reg);
 
 	rt2x00pci_register_read(rt2x00dev, RXCSR1, &reg);
@@ -694,9 +693,10 @@ static int rt2400pci_init_queues(struct rt2x00_dev *rt2x00dev)
 	rt2x00_set_field32(&reg, RXCSR1_NUM_RXD, rt2x00dev->rx->limit);
 	rt2x00pci_register_write(rt2x00dev, RXCSR1, reg);
 
-	priv_rx = rt2x00dev->rx->entries[0].priv_data;
+	entry_priv = rt2x00dev->rx->entries[0].priv_data;
 	rt2x00pci_register_read(rt2x00dev, RXCSR2, &reg);
-	rt2x00_set_field32(&reg, RXCSR2_RX_RING_REGISTER, priv_rx->desc_dma);
+	rt2x00_set_field32(&reg, RXCSR2_RX_RING_REGISTER,
+			   entry_priv->desc_dma);
 	rt2x00pci_register_write(rt2x00dev, RXCSR2, reg);
 
 	return 0;
@@ -995,7 +995,7 @@ static void rt2400pci_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 				    struct txentry_desc *txdesc)
 {
 	struct skb_frame_desc *skbdesc = get_skb_frame_desc(skb);
-	struct queue_entry_priv_pci_tx *entry_priv = skbdesc->entry->priv_data;
+	struct queue_entry_priv_pci *entry_priv = skbdesc->entry->priv_data;
 	__le32 *txd = skbdesc->desc;
 	u32 word;
 
@@ -1078,14 +1078,14 @@ static void rt2400pci_kick_tx_queue(struct rt2x00_dev *rt2x00dev,
 static void rt2400pci_fill_rxdone(struct queue_entry *entry,
 				  struct rxdone_entry_desc *rxdesc)
 {
-	struct queue_entry_priv_pci_rx *priv_rx = entry->priv_data;
+	struct queue_entry_priv_pci *entry_priv = entry->priv_data;
 	u32 word0;
 	u32 word2;
 	u32 word3;
 
-	rt2x00_desc_read(priv_rx->desc, 0, &word0);
-	rt2x00_desc_read(priv_rx->desc, 2, &word2);
-	rt2x00_desc_read(priv_rx->desc, 3, &word3);
+	rt2x00_desc_read(entry_priv->desc, 0, &word0);
+	rt2x00_desc_read(entry_priv->desc, 2, &word2);
+	rt2x00_desc_read(entry_priv->desc, 3, &word3);
 
 	if (rt2x00_get_field32(word0, RXD_W0_CRC_ERROR))
 		rxdesc->flags |= RX_FLAG_FAILED_FCS_CRC;
@@ -1114,15 +1114,15 @@ static void rt2400pci_txdone(struct rt2x00_dev *rt2x00dev,
 			     const enum data_queue_qid queue_idx)
 {
 	struct data_queue *queue = rt2x00queue_get_queue(rt2x00dev, queue_idx);
-	struct queue_entry_priv_pci_tx *priv_tx;
+	struct queue_entry_priv_pci *entry_priv;
 	struct queue_entry *entry;
 	struct txdone_entry_desc txdesc;
 	u32 word;
 
 	while (!rt2x00queue_empty(queue)) {
 		entry = rt2x00queue_get_entry(queue, Q_INDEX_DONE);
-		priv_tx = entry->priv_data;
-		rt2x00_desc_read(priv_tx->desc, 0, &word);
+		entry_priv = entry->priv_data;
+		rt2x00_desc_read(entry_priv->desc, 0, &word);
 
 		if (rt2x00_get_field32(word, TXD_W0_OWNER_NIC) ||
 		    !rt2x00_get_field32(word, TXD_W0_VALID))
@@ -1490,14 +1490,14 @@ static int rt2400pci_beacon_update(struct ieee80211_hw *hw, struct sk_buff *skb,
 {
 	struct rt2x00_dev *rt2x00dev = hw->priv;
 	struct rt2x00_intf *intf = vif_to_intf(control->vif);
-	struct queue_entry_priv_pci_tx *priv_tx;
+	struct queue_entry_priv_pci *entry_priv;
 	struct skb_frame_desc *skbdesc;
 	struct txentry_desc txdesc;
 	u32 reg;
 
 	if (unlikely(!intf->beacon))
 		return -ENOBUFS;
-	priv_tx = intf->beacon->priv_data;
+	entry_priv = intf->beacon->priv_data;
 
 	/*
 	 * Copy all TX descriptor information into txdesc,
@@ -1515,7 +1515,7 @@ static int rt2400pci_beacon_update(struct ieee80211_hw *hw, struct sk_buff *skb,
 	skbdesc->flags |= FRAME_DESC_DRIVER_GENERATED;
 	skbdesc->data = skb->data;
 	skbdesc->data_len = skb->len;
-	skbdesc->desc = priv_tx->desc;
+	skbdesc->desc = entry_priv->desc;
 	skbdesc->desc_len = intf->beacon->queue->desc_size;
 	skbdesc->entry = intf->beacon;
 
@@ -1534,7 +1534,7 @@ static int rt2400pci_beacon_update(struct ieee80211_hw *hw, struct sk_buff *skb,
 	 * Write entire beacon with descriptor to register,
 	 * and kick the beacon generator.
 	 */
-	memcpy(priv_tx->data, skb->data, skb->len);
+	memcpy(entry_priv->data, skb->data, skb->len);
 	rt2x00queue_write_tx_descriptor(intf->beacon, &txdesc);
 	rt2x00dev->ops->lib->kick_tx_queue(rt2x00dev, QID_BEACON);
 
@@ -1595,28 +1595,28 @@ static const struct data_queue_desc rt2400pci_queue_rx = {
 	.entry_num		= RX_ENTRIES,
 	.data_size		= DATA_FRAME_SIZE,
 	.desc_size		= RXD_DESC_SIZE,
-	.priv_size		= sizeof(struct queue_entry_priv_pci_rx),
+	.priv_size		= sizeof(struct queue_entry_priv_pci),
 };
 
 static const struct data_queue_desc rt2400pci_queue_tx = {
 	.entry_num		= TX_ENTRIES,
 	.data_size		= DATA_FRAME_SIZE,
 	.desc_size		= TXD_DESC_SIZE,
-	.priv_size		= sizeof(struct queue_entry_priv_pci_tx),
+	.priv_size		= sizeof(struct queue_entry_priv_pci),
 };
 
 static const struct data_queue_desc rt2400pci_queue_bcn = {
 	.entry_num		= BEACON_ENTRIES,
 	.data_size		= MGMT_FRAME_SIZE,
 	.desc_size		= TXD_DESC_SIZE,
-	.priv_size		= sizeof(struct queue_entry_priv_pci_tx),
+	.priv_size		= sizeof(struct queue_entry_priv_pci),
 };
 
 static const struct data_queue_desc rt2400pci_queue_atim = {
 	.entry_num		= ATIM_ENTRIES,
 	.data_size		= DATA_FRAME_SIZE,
 	.desc_size		= TXD_DESC_SIZE,
-	.priv_size		= sizeof(struct queue_entry_priv_pci_tx),
+	.priv_size		= sizeof(struct queue_entry_priv_pci),
 };
 
 static const struct rt2x00_ops rt2400pci_ops = {
diff --git a/drivers/net/wireless/rt2x00/rt2500pci.c b/drivers/net/wireless/rt2x00/rt2500pci.c
index ed8797a..c159da1 100644
--- a/drivers/net/wireless/rt2x00/rt2500pci.c
+++ b/drivers/net/wireless/rt2x00/rt2500pci.c
@@ -715,34 +715,33 @@ dynamic_cca_tune:
 static void rt2500pci_init_rxentry(struct rt2x00_dev *rt2x00dev,
 				   struct queue_entry *entry)
 {
-	struct queue_entry_priv_pci_rx *priv_rx = entry->priv_data;
+	struct queue_entry_priv_pci *entry_priv = entry->priv_data;
 	u32 word;
 
-	rt2x00_desc_read(priv_rx->desc, 1, &word);
-	rt2x00_set_field32(&word, RXD_W1_BUFFER_ADDRESS, priv_rx->data_dma);
-	rt2x00_desc_write(priv_rx->desc, 1, word);
+	rt2x00_desc_read(entry_priv->desc, 1, &word);
+	rt2x00_set_field32(&word, RXD_W1_BUFFER_ADDRESS, entry_priv->data_dma);
+	rt2x00_desc_write(entry_priv->desc, 1, word);
 
-	rt2x00_desc_read(priv_rx->desc, 0, &word);
+	rt2x00_desc_read(entry_priv->desc, 0, &word);
 	rt2x00_set_field32(&word, RXD_W0_OWNER_NIC, 1);
-	rt2x00_desc_write(priv_rx->desc, 0, word);
+	rt2x00_desc_write(entry_priv->desc, 0, word);
 }
 
 static void rt2500pci_init_txentry(struct rt2x00_dev *rt2x00dev,
 				   struct queue_entry *entry)
 {
-	struct queue_entry_priv_pci_tx *priv_tx = entry->priv_data;
+	struct queue_entry_priv_pci *entry_priv = entry->priv_data;
 	u32 word;
 
-	rt2x00_desc_read(priv_tx->desc, 0, &word);
+	rt2x00_desc_read(entry_priv->desc, 0, &word);
 	rt2x00_set_field32(&word, TXD_W0_VALID, 0);
 	rt2x00_set_field32(&word, TXD_W0_OWNER_NIC, 0);
-	rt2x00_desc_write(priv_tx->desc, 0, word);
+	rt2x00_desc_write(entry_priv->desc, 0, word);
 }
 
 static int rt2500pci_init_queues(struct rt2x00_dev *rt2x00dev)
 {
-	struct queue_entry_priv_pci_rx *priv_rx;
-	struct queue_entry_priv_pci_tx *priv_tx;
+	struct queue_entry_priv_pci *entry_priv;
 	u32 reg;
 
 	/*
@@ -755,28 +754,28 @@ static int rt2500pci_init_queues(struct rt2x00_dev *rt2x00dev)
 	rt2x00_set_field32(&reg, TXCSR2_NUM_PRIO, rt2x00dev->tx[0].limit);
 	rt2x00pci_register_write(rt2x00dev, TXCSR2, reg);
 
-	priv_tx = rt2x00dev->tx[1].entries[0].priv_data;
+	entry_priv = rt2x00dev->tx[1].entries[0].priv_data;
 	rt2x00pci_register_read(rt2x00dev, TXCSR3, &reg);
 	rt2x00_set_field32(&reg, TXCSR3_TX_RING_REGISTER,
-			   priv_tx->desc_dma);
+			   entry_priv->desc_dma);
 	rt2x00pci_register_write(rt2x00dev, TXCSR3, reg);
 
-	priv_tx = rt2x00dev->tx[0].entries[0].priv_data;
+	entry_priv = rt2x00dev->tx[0].entries[0].priv_data;
 	rt2x00pci_register_read(rt2x00dev, TXCSR5, &reg);
 	rt2x00_set_field32(&reg, TXCSR5_PRIO_RING_REGISTER,
-			   priv_tx->desc_dma);
+			   entry_priv->desc_dma);
 	rt2x00pci_register_write(rt2x00dev, TXCSR5, reg);
 
-	priv_tx = rt2x00dev->bcn[1].entries[0].priv_data;
+	entry_priv = rt2x00dev->bcn[1].entries[0].priv_data;
 	rt2x00pci_register_read(rt2x00dev, TXCSR4, &reg);
 	rt2x00_set_field32(&reg, TXCSR4_ATIM_RING_REGISTER,
-			   priv_tx->desc_dma);
+			   entry_priv->desc_dma);
 	rt2x00pci_register_write(rt2x00dev, TXCSR4, reg);
 
-	priv_tx = rt2x00dev->bcn[0].entries[0].priv_data;
+	entry_priv = rt2x00dev->bcn[0].entries[0].priv_data;
 	rt2x00pci_register_read(rt2x00dev, TXCSR6, &reg);
 	rt2x00_set_field32(&reg, TXCSR6_BEACON_RING_REGISTER,
-			   priv_tx->desc_dma);
+			   entry_priv->desc_dma);
 	rt2x00pci_register_write(rt2x00dev, TXCSR6, reg);
 
 	rt2x00pci_register_read(rt2x00dev, RXCSR1, &reg);
@@ -784,9 +783,10 @@ static int rt2500pci_init_queues(struct rt2x00_dev *rt2x00dev)
 	rt2x00_set_field32(&reg, RXCSR1_NUM_RXD, rt2x00dev->rx->limit);
 	rt2x00pci_register_write(rt2x00dev, RXCSR1, reg);
 
-	priv_rx = rt2x00dev->rx->entries[0].priv_data;
+	entry_priv = rt2x00dev->rx->entries[0].priv_data;
 	rt2x00pci_register_read(rt2x00dev, RXCSR2, &reg);
-	rt2x00_set_field32(&reg, RXCSR2_RX_RING_REGISTER, priv_rx->desc_dma);
+	rt2x00_set_field32(&reg, RXCSR2_RX_RING_REGISTER,
+			   entry_priv->desc_dma);
 	rt2x00pci_register_write(rt2x00dev, RXCSR2, reg);
 
 	return 0;
@@ -1154,7 +1154,7 @@ static void rt2500pci_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 				    struct txentry_desc *txdesc)
 {
 	struct skb_frame_desc *skbdesc = get_skb_frame_desc(skb);
-	struct queue_entry_priv_pci_tx *entry_priv = skbdesc->entry->priv_data;
+	struct queue_entry_priv_pci *entry_priv = skbdesc->entry->priv_data;
 	__le32 *txd = skbdesc->desc;
 	u32 word;
 
@@ -1235,12 +1235,12 @@ static void rt2500pci_kick_tx_queue(struct rt2x00_dev *rt2x00dev,
 static void rt2500pci_fill_rxdone(struct queue_entry *entry,
 				  struct rxdone_entry_desc *rxdesc)
 {
-	struct queue_entry_priv_pci_rx *priv_rx = entry->priv_data;
+	struct queue_entry_priv_pci *entry_priv = entry->priv_data;
 	u32 word0;
 	u32 word2;
 
-	rt2x00_desc_read(priv_rx->desc, 0, &word0);
-	rt2x00_desc_read(priv_rx->desc, 2, &word2);
+	rt2x00_desc_read(entry_priv->desc, 0, &word0);
+	rt2x00_desc_read(entry_priv->desc, 2, &word2);
 
 	if (rt2x00_get_field32(word0, RXD_W0_CRC_ERROR))
 		rxdesc->flags |= RX_FLAG_FAILED_FCS_CRC;
@@ -1271,15 +1271,15 @@ static void rt2500pci_txdone(struct rt2x00_dev *rt2x00dev,
 			     const enum data_queue_qid queue_idx)
 {
 	struct data_queue *queue = rt2x00queue_get_queue(rt2x00dev, queue_idx);
-	struct queue_entry_priv_pci_tx *priv_tx;
+	struct queue_entry_priv_pci *entry_priv;
 	struct queue_entry *entry;
 	struct txdone_entry_desc txdesc;
 	u32 word;
 
 	while (!rt2x00queue_empty(queue)) {
 		entry = rt2x00queue_get_entry(queue, Q_INDEX_DONE);
-		priv_tx = entry->priv_data;
-		rt2x00_desc_read(priv_tx->desc, 0, &word);
+		entry_priv = entry->priv_data;
+		rt2x00_desc_read(entry_priv->desc, 0, &word);
 
 		if (rt2x00_get_field32(word, TXD_W0_OWNER_NIC) ||
 		    !rt2x00_get_field32(word, TXD_W0_VALID))
@@ -1804,7 +1804,7 @@ static int rt2500pci_beacon_update(struct ieee80211_hw *hw, struct sk_buff *skb,
 {
 	struct rt2x00_dev *rt2x00dev = hw->priv;
 	struct rt2x00_intf *intf = vif_to_intf(control->vif);
-	struct queue_entry_priv_pci_tx *priv_tx;
+	struct queue_entry_priv_pci *entry_priv;
 	struct skb_frame_desc *skbdesc;
 	struct txentry_desc txdesc;
 	u32 reg;
@@ -1812,7 +1812,7 @@ static int rt2500pci_beacon_update(struct ieee80211_hw *hw, struct sk_buff *skb,
 	if (unlikely(!intf->beacon))
 		return -ENOBUFS;
 
-	priv_tx = intf->beacon->priv_data;
+	entry_priv = intf->beacon->priv_data;
 
 	/*
 	 * Copy all TX descriptor information into txdesc,
@@ -1830,7 +1830,7 @@ static int rt2500pci_beacon_update(struct ieee80211_hw *hw, struct sk_buff *skb,
 	skbdesc->flags |= FRAME_DESC_DRIVER_GENERATED;
 	skbdesc->data = skb->data;
 	skbdesc->data_len = skb->len;
-	skbdesc->desc = priv_tx->desc;
+	skbdesc->desc = entry_priv->desc;
 	skbdesc->desc_len = intf->beacon->queue->desc_size;
 	skbdesc->entry = intf->beacon;
 
@@ -1849,7 +1849,7 @@ static int rt2500pci_beacon_update(struct ieee80211_hw *hw, struct sk_buff *skb,
 	 * Write entire beacon with descriptor to register,
 	 * and kick the beacon generator.
 	 */
-	memcpy(priv_tx->data, skb->data, skb->len);
+	memcpy(entry_priv->data, skb->data, skb->len);
 	rt2x00queue_write_tx_descriptor(intf->beacon, &txdesc);
 	rt2x00dev->ops->lib->kick_tx_queue(rt2x00dev, QID_BEACON);
 
@@ -1910,28 +1910,28 @@ static const struct data_queue_desc rt2500pci_queue_rx = {
 	.entry_num		= RX_ENTRIES,
 	.data_size		= DATA_FRAME_SIZE,
 	.desc_size		= RXD_DESC_SIZE,
-	.priv_size		= sizeof(struct queue_entry_priv_pci_rx),
+	.priv_size		= sizeof(struct queue_entry_priv_pci),
 };
 
 static const struct data_queue_desc rt2500pci_queue_tx = {
 	.entry_num		= TX_ENTRIES,
 	.data_size		= DATA_FRAME_SIZE,
 	.desc_size		= TXD_DESC_SIZE,
-	.priv_size		= sizeof(struct queue_entry_priv_pci_tx),
+	.priv_size		= sizeof(struct queue_entry_priv_pci),
 };
 
 static const struct data_queue_desc rt2500pci_queue_bcn = {
 	.entry_num		= BEACON_ENTRIES,
 	.data_size		= MGMT_FRAME_SIZE,
 	.desc_size		= TXD_DESC_SIZE,
-	.priv_size		= sizeof(struct queue_entry_priv_pci_tx),
+	.priv_size		= sizeof(struct queue_entry_priv_pci),
 };
 
 static const struct data_queue_desc rt2500pci_queue_atim = {
 	.entry_num		= ATIM_ENTRIES,
 	.data_size		= DATA_FRAME_SIZE,
 	.desc_size		= TXD_DESC_SIZE,
-	.priv_size		= sizeof(struct queue_entry_priv_pci_tx),
+	.priv_size		= sizeof(struct queue_entry_priv_pci),
 };
 
 static const struct rt2x00_ops rt2500pci_ops = {
diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c b/drivers/net/wireless/rt2x00/rt2500usb.c
index c3673ff..a006eb0 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/rt2x00/rt2500usb.c
@@ -1124,11 +1124,12 @@ static void rt2500usb_kick_tx_queue(struct rt2x00_dev *rt2x00dev,
 static void rt2500usb_fill_rxdone(struct queue_entry *entry,
 				  struct rxdone_entry_desc *rxdesc)
 {
-	struct queue_entry_priv_usb_rx *priv_rx = entry->priv_data;
+	struct queue_entry_priv_usb *entry_priv = entry->priv_data;
 	struct skb_frame_desc *skbdesc = get_skb_frame_desc(entry->skb);
 	__le32 *rxd =
 	    (__le32 *)(entry->skb->data +
-		       (priv_rx->urb->actual_length - entry->queue->desc_size));
+		       (entry_priv->urb->actual_length -
+			entry->queue->desc_size));
 	u32 word0;
 	u32 word1;
 
@@ -1184,7 +1185,7 @@ static void rt2500usb_fill_rxdone(struct queue_entry *entry,
 static void rt2500usb_beacondone(struct urb *urb)
 {
 	struct queue_entry *entry = (struct queue_entry *)urb->context;
-	struct queue_entry_priv_usb_bcn *priv_bcn = entry->priv_data;
+	struct queue_entry_priv_usb_bcn *bcn_priv = entry->priv_data;
 
 	if (!test_bit(DEVICE_ENABLED_RADIO, &entry->queue->rt2x00dev->flags))
 		return;
@@ -1195,9 +1196,9 @@ static void rt2500usb_beacondone(struct urb *urb)
 	 * Otherwise we should free the sk_buffer, the device
 	 * should be doing the rest of the work now.
 	 */
-	if (priv_bcn->guardian_urb == urb) {
-		usb_submit_urb(priv_bcn->urb, GFP_ATOMIC);
-	} else if (priv_bcn->urb == urb) {
+	if (bcn_priv->guardian_urb == urb) {
+		usb_submit_urb(bcn_priv->urb, GFP_ATOMIC);
+	} else if (bcn_priv->urb == urb) {
 		dev_kfree_skb(entry->skb);
 		entry->skb = NULL;
 	}
@@ -1672,7 +1673,7 @@ static int rt2500usb_beacon_update(struct ieee80211_hw *hw,
 	struct rt2x00_dev *rt2x00dev = hw->priv;
 	struct usb_device *usb_dev = rt2x00dev_usb_dev(rt2x00dev);
 	struct rt2x00_intf *intf = vif_to_intf(control->vif);
-	struct queue_entry_priv_usb_bcn *priv_bcn;
+	struct queue_entry_priv_usb_bcn *bcn_priv;
 	struct skb_frame_desc *skbdesc;
 	struct txentry_desc txdesc;
 	int pipe = usb_sndbulkpipe(usb_dev, 1);
@@ -1682,7 +1683,7 @@ static int rt2500usb_beacon_update(struct ieee80211_hw *hw,
 	if (unlikely(!intf->beacon))
 		return -ENOBUFS;
 
-	priv_bcn = intf->beacon->priv_data;
+	bcn_priv = intf->beacon->priv_data;
 
 	/*
 	 * Copy all TX descriptor information into txdesc,
@@ -1729,7 +1730,7 @@ static int rt2500usb_beacon_update(struct ieee80211_hw *hw,
 	 */
 	length = rt2500usb_get_tx_data_len(rt2x00dev, skb);
 
-	usb_fill_bulk_urb(priv_bcn->urb, usb_dev, pipe,
+	usb_fill_bulk_urb(bcn_priv->urb, usb_dev, pipe,
 			  skb->data, length, rt2500usb_beacondone,
 			  intf->beacon);
 
@@ -1738,15 +1739,15 @@ static int rt2500usb_beacon_update(struct ieee80211_hw *hw,
 	 * We only need a single byte, so lets recycle
 	 * the 'flags' field we are not using for beacons.
 	 */
-	priv_bcn->guardian_data = 0;
-	usb_fill_bulk_urb(priv_bcn->guardian_urb, usb_dev, pipe,
-			  &priv_bcn->guardian_data, 1, rt2500usb_beacondone,
+	bcn_priv->guardian_data = 0;
+	usb_fill_bulk_urb(bcn_priv->guardian_urb, usb_dev, pipe,
+			  &bcn_priv->guardian_data, 1, rt2500usb_beacondone,
 			  intf->beacon);
 
 	/*
 	 * Send out the guardian byte.
 	 */
-	usb_submit_urb(priv_bcn->guardian_urb, GFP_ATOMIC);
+	usb_submit_urb(bcn_priv->guardian_urb, GFP_ATOMIC);
 
 	/*
 	 * Enable beacon generation.
@@ -1797,14 +1798,14 @@ static const struct data_queue_desc rt2500usb_queue_rx = {
 	.entry_num		= RX_ENTRIES,
 	.data_size		= DATA_FRAME_SIZE,
 	.desc_size		= RXD_DESC_SIZE,
-	.priv_size		= sizeof(struct queue_entry_priv_usb_rx),
+	.priv_size		= sizeof(struct queue_entry_priv_usb),
 };
 
 static const struct data_queue_desc rt2500usb_queue_tx = {
 	.entry_num		= TX_ENTRIES,
 	.data_size		= DATA_FRAME_SIZE,
 	.desc_size		= TXD_DESC_SIZE,
-	.priv_size		= sizeof(struct queue_entry_priv_usb_tx),
+	.priv_size		= sizeof(struct queue_entry_priv_usb),
 };
 
 static const struct data_queue_desc rt2500usb_queue_bcn = {
@@ -1818,7 +1819,7 @@ static const struct data_queue_desc rt2500usb_queue_atim = {
 	.entry_num		= ATIM_ENTRIES,
 	.data_size		= DATA_FRAME_SIZE,
 	.desc_size		= TXD_DESC_SIZE,
-	.priv_size		= sizeof(struct queue_entry_priv_usb_tx),
+	.priv_size		= sizeof(struct queue_entry_priv_usb),
 };
 
 static const struct rt2x00_ops rt2500usb_ops = {
diff --git a/drivers/net/wireless/rt2x00/rt2x00pci.c b/drivers/net/wireless/rt2x00/rt2x00pci.c
index a056b12..fa7de41 100644
--- a/drivers/net/wireless/rt2x00/rt2x00pci.c
+++ b/drivers/net/wireless/rt2x00/rt2x00pci.c
@@ -39,7 +39,7 @@ int rt2x00pci_write_tx_data(struct rt2x00_dev *rt2x00dev,
 			    struct ieee80211_tx_control *control)
 {
 	struct queue_entry *entry = rt2x00queue_get_entry(queue, Q_INDEX);
-	struct queue_entry_priv_pci_tx *priv_tx = entry->priv_data;
+	struct queue_entry_priv_pci *entry_priv = entry->priv_data;
 	struct skb_frame_desc *skbdesc;
 	struct txentry_desc txdesc;
 	u32 word;
@@ -47,7 +47,7 @@ int rt2x00pci_write_tx_data(struct rt2x00_dev *rt2x00dev,
 	if (rt2x00queue_full(queue))
 		return -EINVAL;
 
-	rt2x00_desc_read(priv_tx->desc, 0, &word);
+	rt2x00_desc_read(entry_priv->desc, 0, &word);
 
 	if (rt2x00_get_field32(word, TXD_ENTRY_OWNER_NIC) ||
 	    rt2x00_get_field32(word, TXD_ENTRY_VALID)) {
@@ -72,12 +72,12 @@ int rt2x00pci_write_tx_data(struct rt2x00_dev *rt2x00dev,
 	skbdesc = get_skb_frame_desc(skb);
 	skbdesc->data = skb->data;
 	skbdesc->data_len = skb->len;
-	skbdesc->desc = priv_tx->desc;
+	skbdesc->desc = entry_priv->desc;
 	skbdesc->desc_len = queue->desc_size;
 	skbdesc->entry = entry;
 
-	memcpy(&priv_tx->control, control, sizeof(priv_tx->control));
-	memcpy(priv_tx->data, skb->data, skb->len);
+	memcpy(&entry_priv->control, control, sizeof(entry_priv->control));
+	memcpy(entry_priv->data, skb->data, skb->len);
 
 	rt2x00queue_write_tx_descriptor(entry, &txdesc);
 	rt2x00queue_index_inc(queue, Q_INDEX);
@@ -93,7 +93,7 @@ void rt2x00pci_rxdone(struct rt2x00_dev *rt2x00dev)
 {
 	struct data_queue *queue = rt2x00dev->rx;
 	struct queue_entry *entry;
-	struct queue_entry_priv_pci_rx *priv_rx;
+	struct queue_entry_priv_pci *entry_priv;
 	struct ieee80211_hdr *hdr;
 	struct skb_frame_desc *skbdesc;
 	struct rxdone_entry_desc rxdesc;
@@ -103,8 +103,8 @@ void rt2x00pci_rxdone(struct rt2x00_dev *rt2x00dev)
 
 	while (1) {
 		entry = rt2x00queue_get_entry(queue, Q_INDEX);
-		priv_rx = entry->priv_data;
-		rt2x00_desc_read(priv_rx->desc, 0, &word);
+		entry_priv = entry->priv_data;
+		rt2x00_desc_read(entry_priv->desc, 0, &word);
 
 		if (rt2x00_get_field32(word, RXD_ENTRY_OWNER_NIC))
 			break;
@@ -112,7 +112,7 @@ void rt2x00pci_rxdone(struct rt2x00_dev *rt2x00dev)
 		memset(&rxdesc, 0, sizeof(rxdesc));
 		rt2x00dev->ops->lib->fill_rxdone(entry, &rxdesc);
 
-		hdr = (struct ieee80211_hdr *)priv_rx->data;
+		hdr = (struct ieee80211_hdr *)entry_priv->data;
 		header_size =
 		    ieee80211_get_hdrlen(le16_to_cpu(hdr->frame_control));
 
@@ -132,7 +132,7 @@ void rt2x00pci_rxdone(struct rt2x00_dev *rt2x00dev)
 
 		skb_reserve(entry->skb, align);
 		memcpy(skb_put(entry->skb, rxdesc.size),
-		       priv_rx->data, rxdesc.size);
+		       entry_priv->data, rxdesc.size);
 
 		/*
 		 * Fill in skb descriptor
@@ -141,7 +141,7 @@ void rt2x00pci_rxdone(struct rt2x00_dev *rt2x00dev)
 		memset(skbdesc, 0, sizeof(*skbdesc));
 		skbdesc->data = entry->skb->data;
 		skbdesc->data_len = entry->skb->len;
-		skbdesc->desc = priv_rx->desc;
+		skbdesc->desc = entry_priv->desc;
 		skbdesc->desc_len = queue->desc_size;
 		skbdesc->entry = entry;
 
@@ -152,7 +152,7 @@ void rt2x00pci_rxdone(struct rt2x00_dev *rt2x00dev)
 
 		if (test_bit(DEVICE_ENABLED_RADIO, &queue->rt2x00dev->flags)) {
 			rt2x00_set_field32(&word, RXD_ENTRY_OWNER_NIC, 1);
-			rt2x00_desc_write(priv_rx->desc, 0, word);
+			rt2x00_desc_write(entry_priv->desc, 0, word);
 		}
 
 		rt2x00queue_index_inc(queue, Q_INDEX);
@@ -163,10 +163,10 @@ EXPORT_SYMBOL_GPL(rt2x00pci_rxdone);
 void rt2x00pci_txdone(struct rt2x00_dev *rt2x00dev, struct queue_entry *entry,
 		      struct txdone_entry_desc *txdesc)
 {
-	struct queue_entry_priv_pci_tx *priv_tx = entry->priv_data;
+	struct queue_entry_priv_pci *entry_priv = entry->priv_data;
 	u32 word;
 
-	txdesc->control = &priv_tx->control;
+	txdesc->control = &entry_priv->control;
 	rt2x00lib_txdone(entry, txdesc);
 
 	/*
@@ -174,10 +174,10 @@ void rt2x00pci_txdone(struct rt2x00_dev *rt2x00dev, struct queue_entry *entry,
 	 */
 	entry->flags = 0;
 
-	rt2x00_desc_read(priv_tx->desc, 0, &word);
+	rt2x00_desc_read(entry_priv->desc, 0, &word);
 	rt2x00_set_field32(&word, TXD_ENTRY_OWNER_NIC, 0);
 	rt2x00_set_field32(&word, TXD_ENTRY_VALID, 0);
-	rt2x00_desc_write(priv_tx->desc, 0, word);
+	rt2x00_desc_write(entry_priv->desc, 0, word);
 
 	rt2x00queue_index_inc(entry->queue, Q_INDEX_DONE);
 
@@ -187,7 +187,7 @@ void rt2x00pci_txdone(struct rt2x00_dev *rt2x00dev, struct queue_entry *entry,
 	 * is reenabled when the txdone handler has finished.
 	 */
 	if (!rt2x00queue_full(entry->queue))
-		ieee80211_wake_queue(rt2x00dev->hw, priv_tx->control.queue);
+		ieee80211_wake_queue(rt2x00dev->hw, entry_priv->control.queue);
 
 }
 EXPORT_SYMBOL_GPL(rt2x00pci_txdone);
@@ -226,14 +226,9 @@ static int rt2x00pci_alloc_queue_dma(struct rt2x00_dev *rt2x00dev,
 				     struct data_queue *queue)
 {
 	struct pci_dev *pci_dev = rt2x00dev_pci(rt2x00dev);
-	struct queue_entry_priv_pci_rx *priv_rx;
-	struct queue_entry_priv_pci_tx *priv_tx;
+	struct queue_entry_priv_pci *entry_priv;
 	void *addr;
 	dma_addr_t dma;
-	void *desc_addr;
-	dma_addr_t desc_dma;
-	void *data_addr;
-	dma_addr_t data_dma;
 	unsigned int i;
 
 	/*
@@ -249,24 +244,11 @@ static int rt2x00pci_alloc_queue_dma(struct rt2x00_dev *rt2x00dev,
 	 * Initialize all queue entries to contain valid addresses.
 	 */
 	for (i = 0; i < queue->limit; i++) {
-		desc_addr = desc_offset(queue, addr, i);
-		desc_dma = desc_offset(queue, dma, i);
-		data_addr = data_offset(queue, addr, i);
-		data_dma = data_offset(queue, dma, i);
-
-		if (queue->qid == QID_RX) {
-			priv_rx = queue->entries[i].priv_data;
-			priv_rx->desc = desc_addr;
-			priv_rx->desc_dma = desc_dma;
-			priv_rx->data = data_addr;
-			priv_rx->data_dma = data_dma;
-		} else {
-			priv_tx = queue->entries[i].priv_data;
-			priv_tx->desc = desc_addr;
-			priv_tx->desc_dma = desc_dma;
-			priv_tx->data = data_addr;
-			priv_tx->data_dma = data_dma;
-		}
+		entry_priv = queue->entries[i].priv_data;
+		entry_priv->desc = desc_offset(queue, addr, i);
+		entry_priv->desc_dma = desc_offset(queue, dma, i);
+		entry_priv->data = data_offset(queue, addr, i);
+		entry_priv->data_dma = data_offset(queue, dma, i);
 	}
 
 	return 0;
@@ -276,28 +258,13 @@ static void rt2x00pci_free_queue_dma(struct rt2x00_dev *rt2x00dev,
 				     struct data_queue *queue)
 {
 	struct pci_dev *pci_dev = rt2x00dev_pci(rt2x00dev);
-	struct queue_entry_priv_pci_rx *priv_rx;
-	struct queue_entry_priv_pci_tx *priv_tx;
-	void *data_addr;
-	dma_addr_t data_dma;
-
-	if (queue->qid == QID_RX) {
-		priv_rx = queue->entries[0].priv_data;
-		data_addr = priv_rx->data;
-		data_dma = priv_rx->data_dma;
-
-		priv_rx->data = NULL;
-	} else {
-		priv_tx = queue->entries[0].priv_data;
-		data_addr = priv_tx->data;
-		data_dma = priv_tx->data_dma;
-
-		priv_tx->data = NULL;
-	}
+	struct queue_entry_priv_pci *entry_priv =
+	    queue->entries[0].priv_data;
 
-	if (data_addr)
+	if (entry_priv->data)
 		pci_free_consistent(pci_dev, dma_size(queue),
-				    data_addr, data_dma);
+				    entry_priv->data, entry_priv->data_dma);
+	entry_priv->data = NULL;
 }
 
 int rt2x00pci_initialize(struct rt2x00_dev *rt2x00dev)
diff --git a/drivers/net/wireless/rt2x00/rt2x00pci.h b/drivers/net/wireless/rt2x00/rt2x00pci.h
index 2b0ef17..557d15a 100644
--- a/drivers/net/wireless/rt2x00/rt2x00pci.h
+++ b/drivers/net/wireless/rt2x00/rt2x00pci.h
@@ -95,31 +95,15 @@ int rt2x00pci_write_tx_data(struct rt2x00_dev *rt2x00dev,
 			    struct ieee80211_tx_control *control);
 
 /**
- * struct queue_entry_priv_pci_rx: Per RX entry PCI specific information
- *
- * @desc: Pointer to device descriptor.
- * @desc_dma: DMA pointer to @desc.
- * @data: Pointer to device's entry memory.
- * @data_dma: DMA pointer to &data.
- */
-struct queue_entry_priv_pci_rx {
-	__le32 *desc;
-	dma_addr_t desc_dma;
-
-	void *data;
-	dma_addr_t data_dma;
-};
-
-/**
- * struct queue_entry_priv_pci_tx: Per TX entry PCI specific information
+ * struct queue_entry_priv_pci: Per entry PCI specific information
  *
  * @desc: Pointer to device descriptor
- * @desc_dma: DMA pointer to @desc.
+ * @desc_dma: DMA pointer to &desc.
  * @data: Pointer to device's entry memory.
  * @data_dma: DMA pointer to &data.
  * @control: mac80211 control structure used to transmit data.
  */
-struct queue_entry_priv_pci_tx {
+struct queue_entry_priv_pci {
 	__le32 *desc;
 	dma_addr_t desc_dma;
 
diff --git a/drivers/net/wireless/rt2x00/rt2x00usb.c b/drivers/net/wireless/rt2x00/rt2x00usb.c
index e85372d..957078a 100644
--- a/drivers/net/wireless/rt2x00/rt2x00usb.c
+++ b/drivers/net/wireless/rt2x00/rt2x00usb.c
@@ -129,7 +129,7 @@ static void rt2x00usb_interrupt_txdone(struct urb *urb)
 {
 	struct queue_entry *entry = (struct queue_entry *)urb->context;
 	struct rt2x00_dev *rt2x00dev = entry->queue->rt2x00dev;
-	struct queue_entry_priv_usb_tx *priv_tx = entry->priv_data;
+	struct queue_entry_priv_usb *entry_priv = entry->priv_data;
 	struct txdone_entry_desc txdesc;
 	__le32 *txd = (__le32 *)entry->skb->data;
 	u32 word;
@@ -159,7 +159,7 @@ static void rt2x00usb_interrupt_txdone(struct urb *urb)
 	else
 		__set_bit(TXDONE_FAILURE, &txdesc.flags);
 	txdesc.retry = 0;
-	txdesc.control = &priv_tx->control;
+	txdesc.control = &entry_priv->control;
 
 	rt2x00lib_txdone(entry, &txdesc);
 
@@ -175,7 +175,7 @@ static void rt2x00usb_interrupt_txdone(struct urb *urb)
 	 * is reenabled when the txdone handler has finished.
 	 */
 	if (!rt2x00queue_full(entry->queue))
-		ieee80211_wake_queue(rt2x00dev->hw, priv_tx->control.queue);
+		ieee80211_wake_queue(rt2x00dev->hw, entry_priv->control.queue);
 }
 
 int rt2x00usb_write_tx_data(struct rt2x00_dev *rt2x00dev,
@@ -184,7 +184,7 @@ int rt2x00usb_write_tx_data(struct rt2x00_dev *rt2x00dev,
 {
 	struct usb_device *usb_dev = rt2x00dev_usb_dev(rt2x00dev);
 	struct queue_entry *entry = rt2x00queue_get_entry(queue, Q_INDEX);
-	struct queue_entry_priv_usb_tx *priv_tx = entry->priv_data;
+	struct queue_entry_priv_usb *entry_priv = entry->priv_data;
 	struct skb_frame_desc *skbdesc;
 	struct txentry_desc txdesc;
 	u32 length;
@@ -224,7 +224,7 @@ int rt2x00usb_write_tx_data(struct rt2x00_dev *rt2x00dev,
 	skbdesc->desc_len = queue->desc_size;
 	skbdesc->entry = entry;
 
-	memcpy(&priv_tx->control, control, sizeof(priv_tx->control));
+	memcpy(&entry_priv->control, control, sizeof(entry_priv->control));
 	rt2x00queue_write_tx_descriptor(entry, &txdesc);
 
 	/*
@@ -238,9 +238,9 @@ int rt2x00usb_write_tx_data(struct rt2x00_dev *rt2x00dev,
 	 * Initialize URB and send the frame to the device.
 	 */
 	__set_bit(ENTRY_OWNER_DEVICE_DATA, &entry->flags);
-	usb_fill_bulk_urb(priv_tx->urb, usb_dev, usb_sndbulkpipe(usb_dev, 1),
+	usb_fill_bulk_urb(entry_priv->urb, usb_dev, usb_sndbulkpipe(usb_dev, 1),
 			  skb->data, length, rt2x00usb_interrupt_txdone, entry);
-	usb_submit_urb(priv_tx->urb, GFP_ATOMIC);
+	usb_submit_urb(entry_priv->urb, GFP_ATOMIC);
 
 	rt2x00queue_index_inc(queue, Q_INDEX);
 
@@ -380,10 +380,8 @@ skip_entry:
  */
 void rt2x00usb_disable_radio(struct rt2x00_dev *rt2x00dev)
 {
-	struct queue_entry_priv_usb_rx *priv_rx;
-	struct queue_entry_priv_usb_tx *priv_tx;
-	struct queue_entry_priv_usb_bcn *priv_bcn;
-	struct data_queue *queue;
+	struct queue_entry_priv_usb *entry_priv;
+	struct queue_entry_priv_usb_bcn *bcn_priv;
 	unsigned int i;
 
 	rt2x00usb_vendor_request_sw(rt2x00dev, USB_RX_CONTROL, 0, 0,
@@ -393,31 +391,17 @@ void rt2x00usb_disable_radio(struct rt2x00_dev *rt2x00dev)
 	 * Cancel all queues.
 	 */
 	for (i = 0; i < rt2x00dev->rx->limit; i++) {
-		priv_rx = rt2x00dev->rx->entries[i].priv_data;
-		usb_kill_urb(priv_rx->urb);
-	}
-
-	tx_queue_for_each(rt2x00dev, queue) {
-		for (i = 0; i < queue->limit; i++) {
-			priv_tx = queue->entries[i].priv_data;
-			usb_kill_urb(priv_tx->urb);
-		}
+		entry_priv = rt2x00dev->rx->entries[i].priv_data;
+		usb_kill_urb(entry_priv->urb);
 	}
 
+	/*
+	 * Kill guardian urb.
+	 */
 	for (i = 0; i < rt2x00dev->bcn->limit; i++) {
-		priv_bcn = rt2x00dev->bcn->entries[i].priv_data;
-		usb_kill_urb(priv_bcn->urb);
-
-		if (priv_bcn->guardian_urb)
-			usb_kill_urb(priv_bcn->guardian_urb);
-	}
-
-	if (!test_bit(DRIVER_REQUIRE_ATIM_QUEUE, &rt2x00dev->flags))
-		return;
-
-	for (i = 0; i < rt2x00dev->bcn[1].limit; i++) {
-		priv_tx = rt2x00dev->bcn[1].entries[i].priv_data;
-		usb_kill_urb(priv_tx->urb);
+		bcn_priv = rt2x00dev->bcn->entries[i].priv_data;
+		if (bcn_priv->guardian_urb)
+			usb_kill_urb(bcn_priv->guardian_urb);
 	}
 }
 EXPORT_SYMBOL_GPL(rt2x00usb_disable_radio);
@@ -429,15 +413,15 @@ void rt2x00usb_init_rxentry(struct rt2x00_dev *rt2x00dev,
 			    struct queue_entry *entry)
 {
 	struct usb_device *usb_dev = rt2x00dev_usb_dev(rt2x00dev);
-	struct queue_entry_priv_usb_rx *priv_rx = entry->priv_data;
+	struct queue_entry_priv_usb *entry_priv = entry->priv_data;
 
-	usb_fill_bulk_urb(priv_rx->urb, usb_dev,
+	usb_fill_bulk_urb(entry_priv->urb, usb_dev,
 			  usb_rcvbulkpipe(usb_dev, 1),
 			  entry->skb->data, entry->skb->len,
 			  rt2x00usb_interrupt_rxdone, entry);
 
 	__set_bit(ENTRY_OWNER_DEVICE_DATA, &entry->flags);
-	usb_submit_urb(priv_rx->urb, GFP_ATOMIC);
+	usb_submit_urb(entry_priv->urb, GFP_ATOMIC);
 }
 EXPORT_SYMBOL_GPL(rt2x00usb_init_rxentry);
 
@@ -451,38 +435,31 @@ EXPORT_SYMBOL_GPL(rt2x00usb_init_txentry);
 static int rt2x00usb_alloc_urb(struct rt2x00_dev *rt2x00dev,
 			       struct data_queue *queue)
 {
-	struct queue_entry_priv_usb_rx *priv_rx;
-	struct queue_entry_priv_usb_tx *priv_tx;
-	struct queue_entry_priv_usb_bcn *priv_bcn;
-	struct urb *urb;
-	unsigned int guardian =
-	    test_bit(DRIVER_REQUIRE_BEACON_GUARD, &rt2x00dev->flags);
+	struct queue_entry_priv_usb *entry_priv;
+	struct queue_entry_priv_usb_bcn *bcn_priv;
 	unsigned int i;
 
+	for (i = 0; i < queue->limit; i++) {
+		entry_priv = queue->entries[i].priv_data;
+		entry_priv->urb = usb_alloc_urb(0, GFP_KERNEL);
+		if (!entry_priv->urb)
+			return -ENOMEM;
+	}
+
 	/*
-	 * Allocate the URB's
+	 * If this is not the beacon queue or
+	 * no guardian byte was required for the beacon,
+	 * then we are done.
 	 */
+	if (rt2x00dev->bcn != queue ||
+	    !test_bit(DRIVER_REQUIRE_BEACON_GUARD, &rt2x00dev->flags))
+		return 0;
+
 	for (i = 0; i < queue->limit; i++) {
-		urb = usb_alloc_urb(0, GFP_KERNEL);
-		if (!urb)
+		bcn_priv = queue->entries[i].priv_data;
+		bcn_priv->guardian_urb = usb_alloc_urb(0, GFP_KERNEL);
+		if (!bcn_priv->guardian_urb)
 			return -ENOMEM;
-
-		if (queue->qid == QID_RX) {
-			priv_rx = queue->entries[i].priv_data;
-			priv_rx->urb = urb;
-		} else if (queue->qid == QID_MGMT && guardian) {
-			priv_bcn = queue->entries[i].priv_data;
-			priv_bcn->urb = urb;
-
-			urb = usb_alloc_urb(0, GFP_KERNEL);
-			if (!urb)
-				return -ENOMEM;
-
-			priv_bcn->guardian_urb = urb;
-		} else {
-			priv_tx = queue->entries[i].priv_data;
-			priv_tx->urb = urb;
-		}
 	}
 
 	return 0;
@@ -491,38 +468,35 @@ static int rt2x00usb_alloc_urb(struct rt2x00_dev *rt2x00dev,
 static void rt2x00usb_free_urb(struct rt2x00_dev *rt2x00dev,
 			       struct data_queue *queue)
 {
-	struct queue_entry_priv_usb_rx *priv_rx;
-	struct queue_entry_priv_usb_tx *priv_tx;
-	struct queue_entry_priv_usb_bcn *priv_bcn;
-	struct urb *urb;
-	unsigned int guardian =
-	    test_bit(DRIVER_REQUIRE_BEACON_GUARD, &rt2x00dev->flags);
+	struct queue_entry_priv_usb *entry_priv;
+	struct queue_entry_priv_usb_bcn *bcn_priv;
 	unsigned int i;
 
 	if (!queue->entries)
 		return;
 
 	for (i = 0; i < queue->limit; i++) {
-		if (queue->qid == QID_RX) {
-			priv_rx = queue->entries[i].priv_data;
-			urb = priv_rx->urb;
-		} else if (queue->qid == QID_MGMT && guardian) {
-			priv_bcn = queue->entries[i].priv_data;
-
-			usb_kill_urb(priv_bcn->guardian_urb);
-			usb_free_urb(priv_bcn->guardian_urb);
-
-			urb = priv_bcn->urb;
-		} else {
-			priv_tx = queue->entries[i].priv_data;
-			urb = priv_tx->urb;
-		}
-
-		usb_kill_urb(urb);
-		usb_free_urb(urb);
+		entry_priv = queue->entries[i].priv_data;
+		usb_kill_urb(entry_priv->urb);
+		usb_free_urb(entry_priv->urb);
 		if (queue->entries[i].skb)
 			kfree_skb(queue->entries[i].skb);
 	}
+
+	/*
+	 * If this is not the beacon queue or
+	 * no guardian byte was required for the beacon,
+	 * then we are done.
+	 */
+	if (rt2x00dev->bcn != queue ||
+	    !test_bit(DRIVER_REQUIRE_BEACON_GUARD, &rt2x00dev->flags))
+		return;
+
+	for (i = 0; i < queue->limit; i++) {
+		bcn_priv = queue->entries[i].priv_data;
+		usb_kill_urb(bcn_priv->guardian_urb);
+		usb_free_urb(bcn_priv->guardian_urb);
+	}
 }
 
 int rt2x00usb_initialize(struct rt2x00_dev *rt2x00dev)
diff --git a/drivers/net/wireless/rt2x00/rt2x00usb.h b/drivers/net/wireless/rt2x00/rt2x00usb.h
index 4da9eb3..15b404a 100644
--- a/drivers/net/wireless/rt2x00/rt2x00usb.h
+++ b/drivers/net/wireless/rt2x00/rt2x00usb.h
@@ -220,30 +220,21 @@ int rt2x00usb_write_tx_data(struct rt2x00_dev *rt2x00dev,
 			    struct ieee80211_tx_control *control);
 
 /**
- * struct queue_entry_priv_usb_rx: Per RX entry USB specific information
- *
- * @urb: Urb structure used for device communication.
- */
-struct queue_entry_priv_usb_rx {
-	struct urb *urb;
-};
-
-/**
- * struct queue_entry_priv_usb_tx: Per TX entry USB specific information
+ * struct queue_entry_priv_usb: Per entry USB specific information
  *
  * @urb: Urb structure used for device communication.
  * @control: mac80211 control structure used to transmit data.
  */
-struct queue_entry_priv_usb_tx {
+struct queue_entry_priv_usb {
 	struct urb *urb;
 
 	struct ieee80211_tx_control control;
 };
 
 /**
- * struct queue_entry_priv_usb_tx: Per TX entry USB specific information
+ * struct queue_entry_priv_usb_bcn: Per TX entry USB specific information
  *
- * The first section should match &struct queue_entry_priv_usb_tx exactly.
+ * The first section should match &struct queue_entry_priv_usb exactly.
  * rt2500usb can use this structure to send a guardian byte when working
  * with beacons.
  *
diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index fe5f79d..ffd5a4c 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -1018,35 +1018,34 @@ static int rt61pci_load_firmware(struct rt2x00_dev *rt2x00dev, void *data,
 static void rt61pci_init_rxentry(struct rt2x00_dev *rt2x00dev,
 				 struct queue_entry *entry)
 {
-	struct queue_entry_priv_pci_rx *priv_rx = entry->priv_data;
+	struct queue_entry_priv_pci *entry_priv = entry->priv_data;
 	u32 word;
 
-	rt2x00_desc_read(priv_rx->desc, 5, &word);
+	rt2x00_desc_read(entry_priv->desc, 5, &word);
 	rt2x00_set_field32(&word, RXD_W5_BUFFER_PHYSICAL_ADDRESS,
-			   priv_rx->data_dma);
-	rt2x00_desc_write(priv_rx->desc, 5, word);
+			   entry_priv->data_dma);
+	rt2x00_desc_write(entry_priv->desc, 5, word);
 
-	rt2x00_desc_read(priv_rx->desc, 0, &word);
+	rt2x00_desc_read(entry_priv->desc, 0, &word);
 	rt2x00_set_field32(&word, RXD_W0_OWNER_NIC, 1);
-	rt2x00_desc_write(priv_rx->desc, 0, word);
+	rt2x00_desc_write(entry_priv->desc, 0, word);
 }
 
 static void rt61pci_init_txentry(struct rt2x00_dev *rt2x00dev,
 				 struct queue_entry *entry)
 {
-	struct queue_entry_priv_pci_tx *priv_tx = entry->priv_data;
+	struct queue_entry_priv_pci *entry_priv = entry->priv_data;
 	u32 word;
 
-	rt2x00_desc_read(priv_tx->desc, 0, &word);
+	rt2x00_desc_read(entry_priv->desc, 0, &word);
 	rt2x00_set_field32(&word, TXD_W0_VALID, 0);
 	rt2x00_set_field32(&word, TXD_W0_OWNER_NIC, 0);
-	rt2x00_desc_write(priv_tx->desc, 0, word);
+	rt2x00_desc_write(entry_priv->desc, 0, word);
 }
 
 static int rt61pci_init_queues(struct rt2x00_dev *rt2x00dev)
 {
-	struct queue_entry_priv_pci_rx *priv_rx;
-	struct queue_entry_priv_pci_tx *priv_tx;
+	struct queue_entry_priv_pci *entry_priv;
 	u32 reg;
 
 	/*
@@ -1068,28 +1067,28 @@ static int rt61pci_init_queues(struct rt2x00_dev *rt2x00dev)
 			   rt2x00dev->tx[0].desc_size / 4);
 	rt2x00pci_register_write(rt2x00dev, TX_RING_CSR1, reg);
 
-	priv_tx = rt2x00dev->tx[0].entries[0].priv_data;
+	entry_priv = rt2x00dev->tx[0].entries[0].priv_data;
 	rt2x00pci_register_read(rt2x00dev, AC0_BASE_CSR, &reg);
 	rt2x00_set_field32(&reg, AC0_BASE_CSR_RING_REGISTER,
-			   priv_tx->desc_dma);
+			   entry_priv->desc_dma);
 	rt2x00pci_register_write(rt2x00dev, AC0_BASE_CSR, reg);
 
-	priv_tx = rt2x00dev->tx[1].entries[0].priv_data;
+	entry_priv = rt2x00dev->tx[1].entries[0].priv_data;
 	rt2x00pci_register_read(rt2x00dev, AC1_BASE_CSR, &reg);
 	rt2x00_set_field32(&reg, AC1_BASE_CSR_RING_REGISTER,
-			   priv_tx->desc_dma);
+			   entry_priv->desc_dma);
 	rt2x00pci_register_write(rt2x00dev, AC1_BASE_CSR, reg);
 
-	priv_tx = rt2x00dev->tx[2].entries[0].priv_data;
+	entry_priv = rt2x00dev->tx[2].entries[0].priv_data;
 	rt2x00pci_register_read(rt2x00dev, AC2_BASE_CSR, &reg);
 	rt2x00_set_field32(&reg, AC2_BASE_CSR_RING_REGISTER,
-			   priv_tx->desc_dma);
+			   entry_priv->desc_dma);
 	rt2x00pci_register_write(rt2x00dev, AC2_BASE_CSR, reg);
 
-	priv_tx = rt2x00dev->tx[3].entries[0].priv_data;
+	entry_priv = rt2x00dev->tx[3].entries[0].priv_data;
 	rt2x00pci_register_read(rt2x00dev, AC3_BASE_CSR, &reg);
 	rt2x00_set_field32(&reg, AC3_BASE_CSR_RING_REGISTER,
-			   priv_tx->desc_dma);
+			   entry_priv->desc_dma);
 	rt2x00pci_register_write(rt2x00dev, AC3_BASE_CSR, reg);
 
 	rt2x00pci_register_read(rt2x00dev, RX_RING_CSR, &reg);
@@ -1099,10 +1098,10 @@ static int rt61pci_init_queues(struct rt2x00_dev *rt2x00dev)
 	rt2x00_set_field32(&reg, RX_RING_CSR_RXD_WRITEBACK_SIZE, 4);
 	rt2x00pci_register_write(rt2x00dev, RX_RING_CSR, reg);
 
-	priv_rx = rt2x00dev->rx->entries[0].priv_data;
+	entry_priv = rt2x00dev->rx->entries[0].priv_data;
 	rt2x00pci_register_read(rt2x00dev, RX_BASE_CSR, &reg);
 	rt2x00_set_field32(&reg, RX_BASE_CSR_RING_REGISTER,
-			   priv_rx->desc_dma);
+			   entry_priv->desc_dma);
 	rt2x00pci_register_write(rt2x00dev, RX_BASE_CSR, reg);
 
 	rt2x00pci_register_read(rt2x00dev, TX_DMA_DST_CSR, &reg);
@@ -1515,7 +1514,7 @@ static void rt61pci_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 				    struct txentry_desc *txdesc)
 {
 	struct skb_frame_desc *skbdesc = get_skb_frame_desc(skb);
-	struct queue_entry_priv_pci_tx *entry_priv = skbdesc->entry->priv_data;
+	struct queue_entry_priv_pci *entry_priv = skbdesc->entry->priv_data;
 	__le32 *txd = skbdesc->desc;
 	u32 word;
 
@@ -1661,12 +1660,12 @@ static int rt61pci_agc_to_rssi(struct rt2x00_dev *rt2x00dev, int rxd_w1)
 static void rt61pci_fill_rxdone(struct queue_entry *entry,
 			        struct rxdone_entry_desc *rxdesc)
 {
-	struct queue_entry_priv_pci_rx *priv_rx = entry->priv_data;
+	struct queue_entry_priv_pci *entry_priv = entry->priv_data;
 	u32 word0;
 	u32 word1;
 
-	rt2x00_desc_read(priv_rx->desc, 0, &word0);
-	rt2x00_desc_read(priv_rx->desc, 1, &word1);
+	rt2x00_desc_read(entry_priv->desc, 0, &word0);
+	rt2x00_desc_read(entry_priv->desc, 1, &word1);
 
 	if (rt2x00_get_field32(word0, RXD_W0_CRC_ERROR))
 		rxdesc->flags |= RX_FLAG_FAILED_FCS_CRC;
@@ -1695,7 +1694,7 @@ static void rt61pci_txdone(struct rt2x00_dev *rt2x00dev)
 	struct data_queue *queue;
 	struct queue_entry *entry;
 	struct queue_entry *entry_done;
-	struct queue_entry_priv_pci_tx *priv_tx;
+	struct queue_entry_priv_pci *entry_priv;
 	struct txdone_entry_desc txdesc;
 	u32 word;
 	u32 reg;
@@ -1740,8 +1739,8 @@ static void rt61pci_txdone(struct rt2x00_dev *rt2x00dev)
 			continue;
 
 		entry = &queue->entries[index];
-		priv_tx = entry->priv_data;
-		rt2x00_desc_read(priv_tx->desc, 0, &word);
+		entry_priv = entry->priv_data;
+		rt2x00_desc_read(entry_priv->desc, 0, &word);
 
 		if (rt2x00_get_field32(word, TXD_W0_OWNER_NIC) ||
 		    !rt2x00_get_field32(word, TXD_W0_VALID))
@@ -2364,7 +2363,7 @@ static int rt61pci_beacon_update(struct ieee80211_hw *hw, struct sk_buff *skb,
 {
 	struct rt2x00_dev *rt2x00dev = hw->priv;
 	struct rt2x00_intf *intf = vif_to_intf(control->vif);
-	struct queue_entry_priv_pci_tx *priv_tx;
+	struct queue_entry_priv_pci *entry_priv;
 	struct skb_frame_desc *skbdesc;
 	struct txentry_desc txdesc;
 	unsigned int beacon_base;
@@ -2381,8 +2380,8 @@ static int rt61pci_beacon_update(struct ieee80211_hw *hw, struct sk_buff *skb,
 	intf->beacon->skb = skb;
 	rt2x00queue_create_tx_descriptor(intf->beacon, &txdesc, control);
 
-	priv_tx = intf->beacon->priv_data;
-	memset(priv_tx->desc, 0, intf->beacon->queue->desc_size);
+	entry_priv = intf->beacon->priv_data;
+	memset(entry_priv->desc, 0, intf->beacon->queue->desc_size);
 
 	/*
 	 * Fill in skb descriptor
@@ -2392,7 +2391,7 @@ static int rt61pci_beacon_update(struct ieee80211_hw *hw, struct sk_buff *skb,
 	skbdesc->flags |= FRAME_DESC_DRIVER_GENERATED;
 	skbdesc->data = skb->data;
 	skbdesc->data_len = skb->len;
-	skbdesc->desc = priv_tx->desc;
+	skbdesc->desc = entry_priv->desc;
 	skbdesc->desc_len = intf->beacon->queue->desc_size;
 	skbdesc->entry = intf->beacon;
 
@@ -2469,21 +2468,21 @@ static const struct data_queue_desc rt61pci_queue_rx = {
 	.entry_num		= RX_ENTRIES,
 	.data_size		= DATA_FRAME_SIZE,
 	.desc_size		= RXD_DESC_SIZE,
-	.priv_size		= sizeof(struct queue_entry_priv_pci_rx),
+	.priv_size		= sizeof(struct queue_entry_priv_pci),
 };
 
 static const struct data_queue_desc rt61pci_queue_tx = {
 	.entry_num		= TX_ENTRIES,
 	.data_size		= DATA_FRAME_SIZE,
 	.desc_size		= TXD_DESC_SIZE,
-	.priv_size		= sizeof(struct queue_entry_priv_pci_tx),
+	.priv_size		= sizeof(struct queue_entry_priv_pci),
 };
 
 static const struct data_queue_desc rt61pci_queue_bcn = {
 	.entry_num		= 4 * BEACON_ENTRIES,
 	.data_size		= 0, /* No DMA required for beacons */
 	.desc_size		= TXINFO_SIZE,
-	.priv_size		= sizeof(struct queue_entry_priv_pci_tx),
+	.priv_size		= sizeof(struct queue_entry_priv_pci),
 };
 
 static const struct rt2x00_ops rt61pci_ops = {
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index b65a1be..6d59d41 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -2059,21 +2059,21 @@ static const struct data_queue_desc rt73usb_queue_rx = {
 	.entry_num		= RX_ENTRIES,
 	.data_size		= DATA_FRAME_SIZE,
 	.desc_size		= RXD_DESC_SIZE,
-	.priv_size		= sizeof(struct queue_entry_priv_usb_rx),
+	.priv_size		= sizeof(struct queue_entry_priv_usb),
 };
 
 static const struct data_queue_desc rt73usb_queue_tx = {
 	.entry_num		= TX_ENTRIES,
 	.data_size		= DATA_FRAME_SIZE,
 	.desc_size		= TXD_DESC_SIZE,
-	.priv_size		= sizeof(struct queue_entry_priv_usb_tx),
+	.priv_size		= sizeof(struct queue_entry_priv_usb),
 };
 
 static const struct data_queue_desc rt73usb_queue_bcn = {
 	.entry_num		= 4 * BEACON_ENTRIES,
 	.data_size		= MGMT_FRAME_SIZE,
 	.desc_size		= TXINFO_SIZE,
-	.priv_size		= sizeof(struct queue_entry_priv_usb_tx),
+	.priv_size		= sizeof(struct queue_entry_priv_usb),
 };
 
 static const struct rt2x00_ops rt73usb_ops = {
-- 
1.5.5.1

