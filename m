Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.188]:48635 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932472AbXB1OH2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Feb 2007 09:07:28 -0500
Received: by nf-out-0910.google.com with SMTP id o25so562562nfa
        for <linux-wireless@vger.kernel.org>; Wed, 28 Feb 2007 06:07:27 -0800 (PST)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 13/28] rt2x00: Fix txdone flood in rt61pci
Date: Wed, 28 Feb 2007 15:07:13 +0100
Cc: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200702281507.13463.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Prevent rt61pci txdone register to become flooded during under stress,
immediately read the register and mark the reported entries as done.
This way the txdone handler only has to search for these particular
entries.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>

---

diff --git a/drivers/net/wireless/mac80211/rt2x00/rt2x00.h b/drivers/net/wireless/mac80211/rt2x00/rt2x00.h
index b79f860..ef84e1a 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/mac80211/rt2x00/rt2x00.h
@@ -522,7 +522,8 @@ struct data_entry {
 	 */
 	unsigned int flags;
 #define ENTRY_OWNER_NIC		0x00000001
-#define ENTRY_RTS_CTS_FRAME	0x00000002
+#define ENTRY_TXDONE		0x00000002
+#define ENTRY_RTS_CTS_FRAME	0x00000004
 
 	/*
 	 * extra register field
diff --git a/drivers/net/wireless/mac80211/rt2x00/rt61pci.c b/drivers/net/wireless/mac80211/rt2x00/rt61pci.c
index 5685871..9acae84 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/mac80211/rt2x00/rt61pci.c
@@ -2326,116 +2326,56 @@ static void rt61pci_rxdone(struct work_struct *work)
 	}
 }
 
-static void rt61pci_txdone_entry(struct data_entry *entry, u32 sta_csr4)
+static void rt61pci_txdone(struct work_struct *work)
 {
-	struct rt2x00_dev *rt2x00dev = entry->ring->rt2x00dev;
+	struct data_ring *ring =
+		container_of(work, struct data_ring, irq_work);
+	struct rt2x00_dev *rt2x00dev = ring->rt2x00dev;
+	struct data_entry *entry;
 	struct data_desc *txd;
 	u32 word;
 	int tx_status;
+	int retry;
 	int ack;
 	int rts;
 
-	txd = rt2x00_desc_addr(entry);
-	rt2x00_desc_read(txd, 0, &word);
-
-	if (rt2x00_get_field32(word, TXD_W0_OWNER_NIC) ||
-	    !rt2x00_get_field32(word, TXD_W0_VALID))
-		return;
-
-	entry->tx_status.flags = 0;
-	entry->tx_status.queue_length = entry->ring->stats.limit;
-	entry->tx_status.queue_number = entry->tx_status.control.queue;
-
-	/*
-	 * The TXD_W0_RESULT field will only be set when
-	 * we had requested an ACK. So we have received an
-	 * ACK response when ACK was requested and status
-	 * was succesfull.
-	 */
-	ack = rt2x00_get_field32(word, TXD_W0_ACK);
-	rts = GET_FLAG(entry, ENTRY_RTS_CTS_FRAME);
-	tx_status = rt2x00_get_field32(sta_csr4, STA_CSR4_TX_RESULT);
-	rt2x00_update_tx_stats(rt2x00dev, &entry->tx_status, tx_status,
-		ack, rts);
-
-	rt2x00_bbp_read(rt2x00dev, 32,
-		(u8*)&entry->tx_status.ack_signal);
-
-	entry->tx_status.retry_count = rt2x00_get_field32(
-		sta_csr4, STA_CSR4_RETRY_COUNT);
-
-	/*
-	 * If this is not an RTS frame send the tx_status to mac80211,
-	 * that method also cleans up the skb structure. When this
-	 * is a RTS frame, that it is our job to clean this structure up.
-	 */
-	if (!rts)
-		ieee80211_tx_status(rt2x00dev->hw,
-			entry->skb, &entry->tx_status);
-	else
-		dev_kfree_skb(entry->skb);
+	while (!rt2x00_ring_empty(ring)) {
+		entry = rt2x00_get_data_entry_done(ring);
+		txd = entry->priv;
+		rt2x00_desc_read(txd, 0, &word);
 
-	rt2x00_set_field32(&word, TXD_W0_VALID, 0);
-	rt2x00_desc_write(txd, 0, word);
-	CLEAR_FLAG(entry, ENTRY_RTS_CTS_FRAME);
-	entry->skb = NULL;
+		if (!GET_FLAG(entry, ENTRY_TXDONE) ||
+		    rt2x00_get_field32(word, TXD_W0_OWNER_NIC) ||
+		    !rt2x00_get_field32(word, TXD_W0_VALID))
+			return;
 
-	rt2x00_ring_index_done_inc(entry->ring);
+		ack = rt2x00_get_field32(word, TXD_W0_ACK);
+		rts = GET_FLAG(entry, ENTRY_RTS_CTS_FRAME);
+		tx_status = rt2x00_get_field32(entry->reg, STA_CSR4_TX_RESULT);
+		retry = rt2x00_get_field32(entry->reg, STA_CSR4_RETRY_COUNT);
 
-	/*
-	 * If the data ring was full before the txdone handler
-	 * we must make sure the packet queue in the mac80211 stack
-	 * is reenabled when the txdone handler has finished.
-	 */
-	if (!rt2x00_ring_full(entry->ring))
-		ieee80211_wake_queue(rt2x00dev->hw,
-			entry->tx_status.control.queue);
-}
+		rt2x00_update_tx_stats(rt2x00dev, &entry->tx_status, tx_status,
+			ack, rts);
 
-static void rt61pci_txdone(struct work_struct *work)
-{
-	struct data_ring *ring =
-		container_of(work, struct data_ring, irq_work);
-	struct rt2x00_dev *rt2x00dev = ring->rt2x00dev;
-	int index;
-	int reg;
-
-	/*
-	 * Keep looping while STA_CSR4 contains value data.
-	 * at each read the value will be reset to a new value,
-	 * which we should check since it contains the ring
-	 * and index number of the entry which has been
-	 * completely transmitted.
-	 */
-	while (1) {
 		/*
-		 * Stop looping when the entry is invalid.
+		 * If this is not an RTS frame send the tx_status to mac80211,
+		 * that method also cleans up the skb structure. When this
+		 * is a RTS frame, that it is our job to clean this structure up.
 		 */
-		rt2x00_register_read(rt2x00dev, STA_CSR4, &reg);
-		if (!rt2x00_get_field32(reg, STA_CSR4_VALID))
-			break;
+		if (!GET_FLAG(entry, ENTRY_RTS_CTS_FRAME))
+			ieee80211_tx_status(rt2x00dev->hw,
+				entry->skb, &entry->tx_status);
+		else
+			dev_kfree_skb(entry->skb);
 
-		/*
-		 * Skip this entry when it contains an invalid
-		 * ring identication number.
-		 */
-		ring = rt2x00_get_ring(rt2x00dev,
-			rt2x00_get_field32(reg, STA_CSR4_PID_TYPE));
-		if (unlikely(!ring))
-			continue;
+		rt2x00_set_field32(&word, TXD_W0_VALID, 0);
+		rt2x00_desc_write(txd, 0, word);
+		entry->skb = NULL;
 
-		/*
-		 * Skip this entry when it contains an invalid
-		 * index number.
-		 */
-		index = rt2x00_get_field32(reg, STA_CSR4_PID_SUBTYPE);
-		if (unlikely(index >= ring->stats.limit))
-			continue;
+		CLEAR_FLAG(entry, ENTRY_TXDONE);
+		CLEAR_FLAG(entry, ENTRY_RTS_CTS_FRAME);
 
-		/*
-		 * Packet received correctly, we can now process it.
-		 */
-		rt61pci_txdone_entry(&ring->entry[index], reg);
+		rt2x00_ring_index_done_inc(entry->ring);
 	}
 
 	/*
@@ -2454,6 +2394,8 @@ static void rt61pci_txdone(struct work_struct *work)
 static irqreturn_t rt61pci_interrupt(int irq, void *dev_instance)
 {
 	struct rt2x00_dev *rt2x00dev = dev_instance;
+	struct data_ring *ring;
+	int index;
 	u32 reg;
 
 	/*
@@ -2494,13 +2436,41 @@ static irqreturn_t rt61pci_interrupt(int irq, void *dev_instance)
 
 	/*
 	 * 3 - Tx ring done interrupt.
-	 * Don't care about which ring we use to schedule
-	 * work to. The handler will run for all TX
-	 * related rings except Beacon.
+	 * Keep looping while STA_CSR4 contains value data.
+	 * at each read the value will be reset to a new value,
+	 * which we should check since it contains the ring
+	 * and index number of the entry which has been
+	 * completely transmitted.
 	 */
-	if (rt2x00_get_field32(reg, INT_SOURCE_CSR_TXDONE))
-		queue_work(rt2x00dev->workqueue,
-			&rt2x00dev->ring[RING_AC_VO].irq_work);
+	if (rt2x00_get_field32(reg, INT_SOURCE_CSR_TXDONE)) {
+		while (1) {
+			rt2x00_register_read(rt2x00dev, STA_CSR4, &reg);
+			if (!rt2x00_get_field32(reg, STA_CSR4_VALID))
+				break;
+
+			/*
+			 * Skip this entry when it contains an invalid
+			 * ring identication number.
+			 */
+			ring = rt2x00_get_ring(rt2x00dev,
+				rt2x00_get_field32(reg, STA_CSR4_PID_TYPE));
+			if (unlikely(!ring))
+				continue;
+
+			/*
+			 * Skip this entry when it contains an invalid
+			 * index number.
+			 */
+			index = rt2x00_get_field32(reg, STA_CSR4_PID_SUBTYPE);
+			if (unlikely(index >= ring->stats.limit))
+				continue;
+
+			ring->entry[index].reg = reg;
+			SET_FLAG(&ring->entry[index], ENTRY_TXDONE);
+
+			queue_work(rt2x00dev->workqueue, &ring->irq_work);
+		}
+	}
 
 	return IRQ_HANDLED;
 }
