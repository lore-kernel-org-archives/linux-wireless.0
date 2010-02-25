Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp109.plus.mail.re1.yahoo.com ([69.147.102.72]:46699 "HELO
	smtp109.plus.mail.re1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758640Ab0BYA7H (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Feb 2010 19:59:07 -0500
Message-ID: <4B85C9C5.5060909@yahoo.com>
Date: Thu, 25 Feb 2010 01:52:21 +0100
From: Alban Browaeys <prahal@yahoo.com>
Reply-To: prahal@yahoo.com
MIME-Version: 1.0
To: John Linville <linville@tuxdriver.com>
CC: rt2x00 Users List <users@rt2x00.serialmonkey.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Ivo van Doorn <ivdoorn@gmail.com>
Subject: [PATCH 1/2] rt2x00 : hw support tdone implementation.
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an implementation that support WCID being the key_index coming
from benoit and a change in the meaning of the tx fallback flag.

Signed-off-by: Alban Browaeys <prahal@yahoo.com>
---
  drivers/net/wireless/rt2x00/rt2800pci.c   |  116 ++++++++++++++---------------
  drivers/net/wireless/rt2x00/rt2x00dev.c   |   51 +++++++++++--
  drivers/net/wireless/rt2x00/rt2x00queue.h |    6 +-
  3 files changed, 103 insertions(+), 70 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c b/drivers/net/wireless/rt2x00/rt2800pci.c
index 7899789..3ac1df0 100644
--- a/drivers/net/wireless/rt2x00/rt2800pci.c
+++ b/drivers/net/wireless/rt2x00/rt2800pci.c
@@ -920,100 +920,96 @@ static void rt2800pci_txdone(struct rt2x00_dev *rt2x00dev)
  {
  	struct data_queue *queue;
  	struct queue_entry *entry;
-	struct queue_entry *entry_done;
-	struct queue_entry_priv_pci *entry_priv;
+	__le32 *txwi;
  	struct txdone_entry_desc txdesc;
  	u32 word;
  	u32 reg;
-	u32 old_reg;
-	unsigned int type;
-	unsigned int index;
-	u16 mcs, real_mcs;
-
+	int i;
+	int wcid, ack, pid, tx_wcid, tx_ack, tx_pid;
+	u16 mcs, tx_mcs;
+	
  	/*
-	 * During each loop we will compare the freshly read
-	 * TX_STA_FIFO register value with the value read from
-	 * the previous loop. If the 2 values are equal then
-	 * we should stop processing because the chance it
-	 * quite big that the device has been unplugged and
-	 * we risk going into an endless loop.
+	 * To avoid an endlees loop, we only read the TX_STA_FIFO register up
+	 * to 256 times (this is enought to get all values from the FIFO). In
+	 * normal situation, the loop is terminated when we reach a value with
+	 * TX_STA_FIFO_VALID bit is 0.
  	 */
-	old_reg = 0;
-
-	while (1) {
+	
+	for (i=0; i<256; i++) {
  		rt2800_register_read(rt2x00dev, TX_STA_FIFO, &reg);
  		if (!rt2x00_get_field32(reg, TX_STA_FIFO_VALID))
  			break;
  
-		if (old_reg == reg)
-			break;
-		old_reg = reg;
+		wcid    = rt2x00_get_field32(reg, TX_STA_FIFO_WCID);
+		ack     = rt2x00_get_field32(reg, TX_STA_FIFO_TX_ACK_REQUIRED);
+		pid     = rt2x00_get_field32(reg, TX_STA_FIFO_PID_TYPE);
  
  		/*
  		 * Skip this entry when it contains an invalid
  		 * queue identication number.
  		 */
-		type = rt2x00_get_field32(reg, TX_STA_FIFO_PID_TYPE) - 1;
-		if (type >= QID_RX)
+		if (pid < 1)
  			continue;
  
-		queue = rt2x00queue_get_queue(rt2x00dev, type);
+		queue = rt2x00queue_get_queue(rt2x00dev, pid - 1);
  		if (unlikely(!queue))
  			continue;
  
  		/*
-		 * Skip this entry when it contains an invalid
-		 * index number.
+		 * Inside each queue, we process each entry in a chronological
+		 * order. We first check that the queue is not empty.
  		 */
-		index = rt2x00_get_field32(reg, TX_STA_FIFO_WCID) - 1;
-		if (unlikely(index >= queue->limit))
+		if (queue->length == 0)
  			continue;
+		entry = rt2x00queue_get_entry(queue, Q_INDEX_DONE);
  
-		entry = &queue->entries[index];
-		entry_priv = entry->priv_data;
-		rt2x00_desc_read((__le32 *)entry->skb->data, 0, &word);
+		/* Check if we got a match by looking at WCID/ACK/PID
+		 * fields */
+		txwi = (__le32 *)(entry->skb->data -
+				  rt2x00dev->hw->extra_tx_headroom);
  
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
+		rt2x00_desc_read(txwi, 1, &word);
+		tx_wcid = rt2x00_get_field32(word, TXWI_W1_WIRELESS_CLI_ID);
+		tx_ack  = rt2x00_get_field32(word, TXWI_W1_ACK);
+		tx_pid  = rt2x00_get_field32(word, TXWI_W1_PACKETID);
  
-			rt2x00lib_txdone(entry_done, &txdesc);
-			entry_done = rt2x00queue_get_entry(queue, Q_INDEX_DONE);
-		}
+		if ((wcid != tx_wcid) || (ack != tx_ack) || (pid != tx_pid))
+			WARNING(rt2x00dev, "invalid TX_STA_FIFO content\n");
  
  		/*
  		 * Obtain the status about this packet.
  		 */
-		txdesc.flags = 0;
-		if (rt2x00_get_field32(reg, TX_STA_FIFO_TX_SUCCESS))
-			__set_bit(TXDONE_SUCCESS, &txdesc.flags);
-		else
-			__set_bit(TXDONE_FAILURE, &txdesc.flags);
+		mcs = rt2x00_get_field32(reg, TX_STA_FIFO_MCS);
+		rt2x00_desc_read(txwi, 0, &word);
+		tx_mcs = rt2x00_get_field32(word, TXWI_W0_MCS);
  
  		/*
  		 * Ralink has a retry mechanism using a global fallback
-		 * table. We setup this fallback table to try immediate
-		 * lower rate for all rates. In the TX_STA_FIFO,
-		 * the MCS field contains the MCS used for the successfull
-		 * transmission. If the first transmission succeed,
-		 * we have mcs == tx_mcs. On the second transmission,
-		 * we have mcs = tx_mcs - 1. So the number of
-		 * retry is (tx_mcs - mcs).
+		 * table. We setup this fallback table to try the immediate
+		 * lower rate for all rates. In the TX_STA_FIFO, the MCS field
+		 * always contains the MCS used for the last transmission, be
+		 * it successful or not.
  		 */
-		mcs = rt2x00_get_field32(word, TXWI_W0_MCS);
-		real_mcs = rt2x00_get_field32(reg, TX_STA_FIFO_MCS);
+
+		txdesc.flags = 0;
+		if (rt2x00_get_field32(reg, TX_STA_FIFO_TX_SUCCESS)) {
+			/*
+			 * Transmission succeeded. The number of retries is
+			 * tx_mcs - mcs
+			 */
+			__set_bit(TXDONE_SUCCESS, &txdesc.flags);
+			txdesc.retry = ((tx_mcs > mcs) ? tx_mcs - mcs : 0);
+		} else {
+			/*
+			 * Transmission failed. The number of retries is
+			 * always 7 in this case (for a total number of 8
+			 * frames sent).
+			 */
+			__set_bit(TXDONE_FAILURE, &txdesc.flags);
+			txdesc.retry = 7;
+		}
+
  		__set_bit(TXDONE_FALLBACK, &txdesc.flags);
-		txdesc.retry = mcs - min(mcs, real_mcs);
  
  		rt2x00lib_txdone(entry, &txdesc);
  	}
diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index b93731b..506b052 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -251,8 +251,7 @@ void rt2x00lib_txdone(struct queue_entry *entry,
  
  	rate_idx = skbdesc->tx_rate_idx;
  	rate_flags = skbdesc->tx_rate_flags;
-	retry_rates = test_bit(TXDONE_FALLBACK, &txdesc->flags) ?
-	    (txdesc->retry + 1) : 1;
+	retry_rates = txdesc->retry + 1;
  
  	/*
  	 * Initialize TX status
@@ -265,13 +264,49 @@ void rt2x00lib_txdone(struct queue_entry *entry,
  	 * different rates to send out the frame, at each
  	 * retry it lowered the rate 1 step.
  	 */
-	for (i = 0; i < retry_rates && i < IEEE80211_TX_MAX_RATES; i++) {
-		tx_info->status.rates[i].idx = rate_idx - i;
-		tx_info->status.rates[i].flags = rate_flags;
-		tx_info->status.rates[i].count = 1;
+	if (test_bit(TXDONE_FALLBACK, &txdesc->flags)) {
+		/*
+		 * Fill in a multiple rate entries, ie frame was sent once at
+		 * each rates. We use rate_idx as an index into
+		 * rt2x00_supported_rates array. Since we can have up to 8
+		 * transmissions at different rates and since
+		 * IEEE80211_TX_MAX_RATES is only 5, the array can be
+		 * truncated.
+		 */
+		for (i=0; (i < retry_rates) && (i < IEEE80211_TX_MAX_RATES); i++) {
+			/*
+			 * check if we reach the lowest rates for this
+			 * modulation ie 1 Mbits for CCK and 6 Mbits for
+			 * OFDM.
+			 *
+			 * FIXME : This code needs to be checked for MCS
+			 */
+
+			int idx = rate_idx - i;
+			if ((idx == 0) /* 1 Mbits CCK rate index */ ||
+			(idx == 4) /* 6 Mbits OFDM rate index */) {
+				tx_info->status.rates[i].idx = idx;
+				tx_info->status.rates[i].flags = rate_flags;
+				tx_info->status.rates[i].count = retry_rates - i;
+				/* move to the next entry */
+				i++;
+				break;
+			} else {
+				tx_info->status.rates[i].idx = idx;
+				tx_info->status.rates[i].flags = rate_flags;
+				tx_info->status.rates[i].count = 1;
+			}
+		}
+		if (i < IEEE80211_TX_MAX_RATES)
+			tx_info->status.rates[i].idx = -1; /* terminate */
+	} else {
+		/* Fill in a single rate entry, ie frame was sent
+		 * (txdesc->retry+1) times at the same rate */
+		tx_info->status.rates[0].idx = rate_idx;
+		tx_info->status.rates[0].flags = rate_flags;
+		tx_info->status.rates[0].count = retry_rates;
+		tx_info->status.rates[1].idx = -1; /* terminate */
  	}
-	if (i < (IEEE80211_TX_MAX_RATES - 1))
-		tx_info->status.rates[i].idx = -1; /* terminate */
  
  	if (!(tx_info->flags & IEEE80211_TX_CTL_NO_ACK)) {
  		if (success)
diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.h b/drivers/net/wireless/rt2x00/rt2x00queue.h
index c1e482b..4e801c3 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.h
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.h
@@ -214,7 +214,7 @@ struct rxdone_entry_desc {
   *
   * @TXDONE_UNKNOWN: Hardware could not determine success of transmission.
   * @TXDONE_SUCCESS: Frame was successfully send
- * @TXDONE_FALLBACK: Frame was successfully send using a fallback rate.
+ * @TXDONE_FALLBACK: Frame was sent using a fallback rate table.
   * @TXDONE_FAILURE: Frame was not successfully send
   * @TXDONE_EXCESSIVE_RETRY: In addition to &TXDONE_FAILURE, the
   *	frame transmission failed due to excessive retries.
@@ -234,7 +234,9 @@ enum txdone_entry_desc_flags {
   * after the device is done with transmission.
   *
   * @flags: TX done flags (See &enum txdone_entry_desc_flags).
- * @retry: Retry count.
+ * @retry: Retry count. If TXDONE_FALLBACK is not set, the frame was sent
+ * (retry+1) times at the same rate. If TXDONE_FALLBACK is set, the frame was
+ * sent once for each lower rates, up to (retry+1) times in total.
   */
  struct txdone_entry_desc {
  	unsigned long flags;
-- 
1.7.0


