Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39234 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755866Ab0BOS7h (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Feb 2010 13:59:37 -0500
Date: Mon, 15 Feb 2010 13:59:34 -0500
From: Josef Bacik <josef@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: ivdoorn@gmail.com
Subject: [PATCH] rt2800pci: actually handle tx interrupts
Message-ID: <20100215185933.GA12592@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

The rt2800pci driver has never actually worked for me, and it turns out it's
because it doesn't handle the tx done interrupts properly.  The queue would get
full after transmitting 24 packets and be done, so I would be able to get an AP
list and then nothing else would work.  This comes down to 2 problems

1) We don't handle _any_ of the DMA_DONE interrupts, so we don't actually remove
any of the entries when the card tells us we are done.  This is easy enough to
fix.

2) Turns out we are depending on the TX_STA_FIFO register on the card to give us
per-tx statistics, but it appears to only be a sort of global statistic thing
that doesn't even work most of the time.  I seperated out all of the TX_STA_FIFO
reading stuff and either TX_STA_FIFO_VALID would be 0,
TX_STA_FIFO_TX_ACK_REQUIRED would be 0, or TX_STA_FIFO_WCID would be 254, which
is way higher than the queue limit.  So basically it gives us crap statistics.

Looking through RaLinks driver it doesn't seem there is a way to get per-tx
statistics, so you can't really tell if the tx failed or not.  So I've fixed
rt2800pci_txdone to just say the tx succeeded and call rt2x00lib_txdone and be
done with it.  I'm sure this is horribly wrong, but looking at the RaLink driver
doesn't seem to indicate anyway to fail/retry a particular packet, so I'm not
sure if there is anything else that can be done.

This patch makes it so this driver works for me finally (minus a couple of
quirks).  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>

diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c b/drivers/net/wireless/rt2x00/rt2800pci.c
index daea0b7..ccb0ac3 100644
--- a/drivers/net/wireless/rt2x00/rt2800pci.c
+++ b/drivers/net/wireless/rt2x00/rt2800pci.c
@@ -903,104 +903,19 @@ static void rt2800pci_fill_rxdone(struct queue_entry *entry,
 /*
  * Interrupt functions.
  */
-static void rt2800pci_txdone(struct rt2x00_dev *rt2x00dev)
+static void rt2800pci_txdone(struct rt2x00_dev *rt2x00dev,
+			     const enum data_queue_qid queue_idx)
 {
-	struct data_queue *queue;
+	struct data_queue *queue = rt2x00queue_get_queue(rt2x00dev, queue_idx);
 	struct queue_entry *entry;
-	struct queue_entry *entry_done;
-	struct queue_entry_priv_pci *entry_priv;
 	struct txdone_entry_desc txdesc;
-	u32 word;
-	u32 reg;
-	u32 old_reg;
-	unsigned int type;
-	unsigned int index;
-	u16 mcs, real_mcs;
-
-	/*
-	 * During each loop we will compare the freshly read
-	 * TX_STA_FIFO register value with the value read from
-	 * the previous loop. If the 2 values are equal then
-	 * we should stop processing because the chance it
-	 * quite big that the device has been unplugged and
-	 * we risk going into an endless loop.
-	 */
-	old_reg = 0;
-
-	while (1) {
-		rt2800_register_read(rt2x00dev, TX_STA_FIFO, &reg);
-		if (!rt2x00_get_field32(reg, TX_STA_FIFO_VALID))
-			break;
-
-		if (old_reg == reg)
-			break;
-		old_reg = reg;
-
-		/*
-		 * Skip this entry when it contains an invalid
-		 * queue identication number.
-		 */
-		type = rt2x00_get_field32(reg, TX_STA_FIFO_PID_TYPE) - 1;
-		if (type >= QID_RX)
-			continue;
 
-		queue = rt2x00queue_get_queue(rt2x00dev, type);
-		if (unlikely(!queue))
-			continue;
+	while (!rt2x00queue_empty(queue)) {
+		entry = rt2x00queue_get_entry(queue, Q_INDEX_DONE);
 
-		/*
-		 * Skip this entry when it contains an invalid
-		 * index number.
-		 */
-		index = rt2x00_get_field32(reg, TX_STA_FIFO_WCID) - 1;
-		if (unlikely(index >= queue->limit))
-			continue;
-
-		entry = &queue->entries[index];
-		entry_priv = entry->priv_data;
-		rt2x00_desc_read((__le32 *)entry->skb->data, 0, &word);
-
-		entry_done = rt2x00queue_get_entry(queue, Q_INDEX_DONE);
-		while (entry != entry_done) {
-			/*
-			 * Catch up.
-			 * Just report any entries we missed as failed.
-			 */
-			WARNING(rt2x00dev,
-				"TX status report missed for entry %d\n",
-				entry_done->entry_idx);
-
-			txdesc.flags = 0;
-			__set_bit(TXDONE_UNKNOWN, &txdesc.flags);
-			txdesc.retry = 0;
-
-			rt2x00lib_txdone(entry_done, &txdesc);
-			entry_done = rt2x00queue_get_entry(queue, Q_INDEX_DONE);
-		}
-
-		/*
-		 * Obtain the status about this packet.
-		 */
 		txdesc.flags = 0;
-		if (rt2x00_get_field32(reg, TX_STA_FIFO_TX_SUCCESS))
-			__set_bit(TXDONE_SUCCESS, &txdesc.flags);
-		else
-			__set_bit(TXDONE_FAILURE, &txdesc.flags);
-
-		/*
-		 * Ralink has a retry mechanism using a global fallback
-		 * table. We setup this fallback table to try immediate
-		 * lower rate for all rates. In the TX_STA_FIFO,
-		 * the MCS field contains the MCS used for the successfull
-		 * transmission. If the first transmission succeed,
-		 * we have mcs == tx_mcs. On the second transmission,
-		 * we have mcs = tx_mcs - 1. So the number of
-		 * retry is (tx_mcs - mcs).
-		 */
-		mcs = rt2x00_get_field32(word, TXWI_W0_MCS);
-		real_mcs = rt2x00_get_field32(reg, TX_STA_FIFO_MCS);
-		__set_bit(TXDONE_FALLBACK, &txdesc.flags);
-		txdesc.retry = mcs - min(mcs, real_mcs);
+		__set_bit(TXDONE_SUCCESS, &txdesc.flags);
+		txdesc.retry = 0;
 
 		rt2x00lib_txdone(entry, &txdesc);
 	}
@@ -1027,8 +942,17 @@ static irqreturn_t rt2800pci_interrupt(int irq, void *dev_instance)
 	if (rt2x00_get_field32(reg, INT_SOURCE_CSR_RX_DONE))
 		rt2x00pci_rxdone(rt2x00dev);
 
-	if (rt2x00_get_field32(reg, INT_SOURCE_CSR_TX_FIFO_STATUS))
-		rt2800pci_txdone(rt2x00dev);
+	if (rt2x00_get_field32(reg, INT_SOURCE_CSR_AC0_DMA_DONE))
+		rt2800pci_txdone(rt2x00dev, QID_AC_BE);
+
+	if (rt2x00_get_field32(reg, INT_SOURCE_CSR_AC1_DMA_DONE))
+		rt2800pci_txdone(rt2x00dev, QID_AC_BK);
+
+	if (rt2x00_get_field32(reg, INT_SOURCE_CSR_AC2_DMA_DONE))
+		rt2800pci_txdone(rt2x00dev, QID_AC_VI);
+
+	if (rt2x00_get_field32(reg, INT_SOURCE_CSR_AC3_DMA_DONE))
+		rt2800pci_txdone(rt2x00dev, QID_AC_VO);
 
 	return IRQ_HANDLED;
 }
