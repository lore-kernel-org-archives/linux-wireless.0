Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:63520 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753898Ab0JBJfQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Oct 2010 05:35:16 -0400
Received: by mail-wy0-f174.google.com with SMTP id 28so3658520wyb.19
        for <linux-wireless@vger.kernel.org>; Sat, 02 Oct 2010 02:35:15 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 02/20] rt2x00: Split out parts of the rt2800_txdone function for easier reuse
Date: Sat, 2 Oct 2010 11:27:03 +0200
Cc: users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org,
	Helmut Schaa <helmut.schaa@googlemail.com>
References: <201010021126.18748.IvDoorn@gmail.com>
In-Reply-To: <201010021126.18748.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201010021127.04544.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Helmut Schaa <helmut.schaa@googlemail.com>

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800lib.c |  100 ++++++++++++++++--------------
 drivers/net/wireless/rt2x00/rt2800lib.h |    1 +
 2 files changed, 54 insertions(+), 47 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index daa32ae..19534f2 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -630,15 +630,63 @@ static bool rt2800_txdone_entry_check(struct queue_entry *entry, u32 reg)
 	return true;
 }
 
+void rt2800_txdone_entry(struct queue_entry *entry, u32 status)
+{
+	struct rt2x00_dev *rt2x00dev = entry->queue->rt2x00dev;
+	struct txdone_entry_desc txdesc;
+	u32 word;
+	u16 mcs, real_mcs;
+	__le32 *txwi;
+
+	/*
+	 * Obtain the status about this packet.
+	 */
+	txdesc.flags = 0;
+	txwi = rt2800_drv_get_txwi(entry);
+	rt2x00_desc_read(txwi, 0, &word);
+	mcs = rt2x00_get_field32(word, TXWI_W0_MCS);
+	real_mcs = rt2x00_get_field32(status, TX_STA_FIFO_MCS);
+
+	/*
+	 * Ralink has a retry mechanism using a global fallback
+	 * table. We setup this fallback table to try the immediate
+	 * lower rate for all rates. In the TX_STA_FIFO, the MCS field
+	 * always contains the MCS used for the last transmission, be
+	 * it successful or not.
+	 */
+	if (rt2x00_get_field32(status, TX_STA_FIFO_TX_SUCCESS)) {
+		/*
+		 * Transmission succeeded. The number of retries is
+		 * mcs - real_mcs
+		 */
+		__set_bit(TXDONE_SUCCESS, &txdesc.flags);
+		txdesc.retry = ((mcs > real_mcs) ? mcs - real_mcs : 0);
+	} else {
+		/*
+		 * Transmission failed. The number of retries is
+		 * always 7 in this case (for a total number of 8
+		 * frames sent).
+		 */
+		__set_bit(TXDONE_FAILURE, &txdesc.flags);
+		txdesc.retry = rt2x00dev->long_retry;
+	}
+
+	/*
+	 * the frame was retried at least once
+	 * -> hw used fallback rates
+	 */
+	if (txdesc.retry)
+		__set_bit(TXDONE_FALLBACK, &txdesc.flags);
+
+	rt2x00lib_txdone(entry, &txdesc);
+}
+EXPORT_SYMBOL_GPL(rt2800_txdone_entry);
+
 void rt2800_txdone(struct rt2x00_dev *rt2x00dev)
 {
 	struct data_queue *queue;
 	struct queue_entry *entry;
-	__le32 *txwi;
-	struct txdone_entry_desc txdesc;
-	u32 word;
 	u32 reg;
-	u16 mcs, real_mcs;
 	u8 pid;
 	int i;
 
@@ -673,7 +721,6 @@ void rt2800_txdone(struct rt2x00_dev *rt2x00dev)
 		 * order. We first check that the queue is not empty.
 		 */
 		entry = NULL;
-		txwi = NULL;
 		while (!rt2x00queue_empty(queue)) {
 			entry = rt2x00queue_get_entry(queue, Q_INDEX_DONE);
 			if (rt2800_txdone_entry_check(entry, reg))
@@ -683,48 +730,7 @@ void rt2800_txdone(struct rt2x00_dev *rt2x00dev)
 		if (!entry || rt2x00queue_empty(queue))
 			break;
 
-
-		/*
-		 * Obtain the status about this packet.
-		 */
-		txdesc.flags = 0;
-		txwi = rt2800_drv_get_txwi(entry);
-		rt2x00_desc_read(txwi, 0, &word);
-		mcs = rt2x00_get_field32(word, TXWI_W0_MCS);
-		real_mcs = rt2x00_get_field32(reg, TX_STA_FIFO_MCS);
-
-		/*
-		 * Ralink has a retry mechanism using a global fallback
-		 * table. We setup this fallback table to try the immediate
-		 * lower rate for all rates. In the TX_STA_FIFO, the MCS field
-		 * always contains the MCS used for the last transmission, be
-		 * it successful or not.
-		 */
-		if (rt2x00_get_field32(reg, TX_STA_FIFO_TX_SUCCESS)) {
-			/*
-			 * Transmission succeeded. The number of retries is
-			 * mcs - real_mcs
-			 */
-			__set_bit(TXDONE_SUCCESS, &txdesc.flags);
-			txdesc.retry = ((mcs > real_mcs) ? mcs - real_mcs : 0);
-		} else {
-			/*
-			 * Transmission failed. The number of retries is
-			 * always 7 in this case (for a total number of 8
-			 * frames sent).
-			 */
-			__set_bit(TXDONE_FAILURE, &txdesc.flags);
-			txdesc.retry = rt2x00dev->long_retry;
-		}
-
-		/*
-		 * the frame was retried at least once
-		 * -> hw used fallback rates
-		 */
-		if (txdesc.retry)
-			__set_bit(TXDONE_FALLBACK, &txdesc.flags);
-
-		rt2x00lib_txdone(entry, &txdesc);
+		rt2800_txdone_entry(entry, reg);
 	}
 }
 EXPORT_SYMBOL_GPL(rt2800_txdone);
diff --git a/drivers/net/wireless/rt2x00/rt2800lib.h b/drivers/net/wireless/rt2x00/rt2800lib.h
index 600c5eb..81cbc92 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.h
+++ b/drivers/net/wireless/rt2x00/rt2800lib.h
@@ -153,6 +153,7 @@ void rt2800_write_tx_data(struct queue_entry *entry,
 void rt2800_process_rxwi(struct queue_entry *entry, struct rxdone_entry_desc *txdesc);
 
 void rt2800_txdone(struct rt2x00_dev *rt2x00dev);
+void rt2800_txdone_entry(struct queue_entry *entry, u32 status);
 
 void rt2800_write_beacon(struct queue_entry *entry, struct txentry_desc *txdesc);
 
-- 
1.7.2.3

