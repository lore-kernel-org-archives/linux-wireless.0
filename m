Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56426 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753037AbdBNMvO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 14 Feb 2017 07:51:14 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
        Felix Fietkau <nbd@nbd.name>
Subject: [PATCH 07/10] rt2x00: use txdone_nomatch on rt2800usb
Date: Tue, 14 Feb 2017 13:46:05 +0100
Message-Id: <1487076368-7020-8-git-send-email-sgruszka@redhat.com> (sfid-20170214_135218_246367_3540A940)
In-Reply-To: <1487076368-7020-1-git-send-email-sgruszka@redhat.com>
References: <1487076368-7020-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If we do not match skb entry, provide tx status via nomatch procedure.

Currently in that case we do rt2x00lib_txdone_noinfo(TXDONE_NOINFO),
which actually assume that entry->skb was posted without retries and
provide rate saved in skb desc as successful. Patch changed that to
rate read from TX_STAT_FIFO, however still do not provide correct
number of retries.

On SoC/PCI devices we keep providing status via standard txdone
procedure, no change in those devices, though we should thing about it.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/ralink/rt2x00/rt2800lib.c  | 32 ++++++++++++++++++-------
 drivers/net/wireless/ralink/rt2x00/rt2800lib.h  |  3 ++-
 drivers/net/wireless/ralink/rt2x00/rt2800mmio.c |  2 +-
 drivers/net/wireless/ralink/rt2x00/rt2800usb.c  | 18 ++++++--------
 4 files changed, 34 insertions(+), 21 deletions(-)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
index 5de21d2..8a76b27 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
@@ -852,7 +852,8 @@ void rt2800_process_rxwi(struct queue_entry *entry,
 }
 EXPORT_SYMBOL_GPL(rt2800_process_rxwi);
 
-void rt2800_txdone_entry(struct queue_entry *entry, u32 status, __le32 *txwi)
+void rt2800_txdone_entry(struct queue_entry *entry, u32 status, __le32 *txwi,
+			 bool match)
 {
 	struct rt2x00_dev *rt2x00dev = entry->queue->rt2x00dev;
 	struct rt2800_drv_data *drv_data = rt2x00dev->drv_data;
@@ -860,8 +861,7 @@ void rt2800_txdone_entry(struct queue_entry *entry, u32 status, __le32 *txwi)
 	struct txdone_entry_desc txdesc;
 	u32 word;
 	u16 mcs, real_mcs;
-	int aggr, ampdu;
-	int wcid;
+	int aggr, ampdu, wcid, ack_req;
 
 	/*
 	 * Obtain the status about this packet.
@@ -875,6 +875,7 @@ void rt2800_txdone_entry(struct queue_entry *entry, u32 status, __le32 *txwi)
 	real_mcs = rt2x00_get_field32(status, TX_STA_FIFO_MCS);
 	aggr = rt2x00_get_field32(status, TX_STA_FIFO_TX_AGGRE);
 	wcid = rt2x00_get_field32(status, TX_STA_FIFO_WCID);
+	ack_req	= rt2x00_get_field32(status, TX_STA_FIFO_TX_ACK_REQUIRED);
 
 	/*
 	 * If a frame was meant to be sent as a single non-aggregated MPDU
@@ -891,18 +892,22 @@ void rt2800_txdone_entry(struct queue_entry *entry, u32 status, __le32 *txwi)
 	 * Hence, replace the requested rate with the real tx rate to not
 	 * confuse the rate control algortihm by providing clearly wrong
 	 * data.
+	 *
+	 * FIXME: if we do not find matching entry, we tell that frame was
+	 * posted without any retries. We need to find a way to fix that
+	 * and provide retry count.
 	 */
-	if (unlikely(aggr == 1 && ampdu == 0 && real_mcs != mcs)) {
+	if (unlikely((aggr == 1 && ampdu == 0 && real_mcs != mcs)) || !match) {
 		skbdesc->tx_rate_idx = real_mcs;
 		mcs = real_mcs;
 	}
 
-	if (likely(wcid >= WCID_START && wcid <= WCID_END))
-		skbdesc->sta = drv_data->wcid_to_sta[wcid - WCID_START];
-
 	if (aggr == 1 || ampdu == 1)
 		__set_bit(TXDONE_AMPDU, &txdesc.flags);
 
+	if (ack_req)
+		__set_bit(TXDONE_ACK_REQ, &txdesc.flags);
+
 	/*
 	 * Ralink has a retry mechanism using a global fallback
 	 * table. We setup this fallback table to try the immediate
@@ -934,7 +939,18 @@ void rt2800_txdone_entry(struct queue_entry *entry, u32 status, __le32 *txwi)
 	if (txdesc.retry)
 		__set_bit(TXDONE_FALLBACK, &txdesc.flags);
 
-	rt2x00lib_txdone(entry, &txdesc);
+	if (!match) {
+		/* RCU assures non-null sta will not be freed by mac80211. */
+		rcu_read_lock();
+		if (likely(wcid >= WCID_START && wcid <= WCID_END))
+			skbdesc->sta = drv_data->wcid_to_sta[wcid - WCID_START];
+		else
+			skbdesc->sta = NULL;
+		rt2x00lib_txdone_nomatch(entry, &txdesc);
+		rcu_read_unlock();
+	} else {
+		rt2x00lib_txdone(entry, &txdesc);
+	}
 }
 EXPORT_SYMBOL_GPL(rt2800_txdone_entry);
 
diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800lib.h b/drivers/net/wireless/ralink/rt2x00/rt2800lib.h
index 6811d67..d9ef260 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800lib.h
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800lib.h
@@ -191,7 +191,8 @@ void rt2800_write_tx_data(struct queue_entry *entry,
 			  struct txentry_desc *txdesc);
 void rt2800_process_rxwi(struct queue_entry *entry, struct rxdone_entry_desc *txdesc);
 
-void rt2800_txdone_entry(struct queue_entry *entry, u32 status, __le32* txwi);
+void rt2800_txdone_entry(struct queue_entry *entry, u32 status, __le32 *txwi,
+			 bool match);
 
 void rt2800_write_beacon(struct queue_entry *entry, struct txentry_desc *txdesc);
 void rt2800_clear_beacon(struct queue_entry *entry);
diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800mmio.c b/drivers/net/wireless/ralink/rt2x00/rt2800mmio.c
index de4790b..3ab3b53 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800mmio.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800mmio.c
@@ -239,7 +239,7 @@ static bool rt2800mmio_txdone_release_entries(struct queue_entry *entry,
 {
 	if (test_bit(ENTRY_DATA_STATUS_SET, &entry->flags)) {
 		rt2800_txdone_entry(entry, entry->status,
-				    rt2800mmio_get_txwi(entry));
+				    rt2800mmio_get_txwi(entry), true);
 		return false;
 	}
 
diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800usb.c b/drivers/net/wireless/ralink/rt2x00/rt2800usb.c
index 205a7b8..f11e3f5 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800usb.c
@@ -501,8 +501,7 @@ static int rt2800usb_get_tx_data_len(struct queue_entry *entry)
 /*
  * TX control handlers
  */
-static enum txdone_entry_desc_flags
-rt2800usb_txdone_entry_check(struct queue_entry *entry, u32 reg)
+static bool rt2800usb_txdone_entry_check(struct queue_entry *entry, u32 reg)
 {
 	__le32 *txwi;
 	u32 word;
@@ -515,7 +514,7 @@ static int rt2800usb_get_tx_data_len(struct queue_entry *entry)
 	 * frame.
 	 */
 	if (test_bit(ENTRY_DATA_IO_FAILED, &entry->flags))
-		return TXDONE_FAILURE;
+		return false;
 
 	wcid	= rt2x00_get_field32(reg, TX_STA_FIFO_WCID);
 	ack	= rt2x00_get_field32(reg, TX_STA_FIFO_TX_ACK_REQUIRED);
@@ -537,10 +536,10 @@ static int rt2800usb_get_tx_data_len(struct queue_entry *entry)
 		rt2x00_dbg(entry->queue->rt2x00dev,
 			   "TX status report missed for queue %d entry %d\n",
 			   entry->queue->qid, entry->entry_idx);
-		return TXDONE_UNKNOWN;
+		return false;
 	}
 
-	return TXDONE_SUCCESS;
+	return true;
 }
 
 static void rt2800usb_txdone(struct rt2x00_dev *rt2x00dev)
@@ -549,7 +548,7 @@ static void rt2800usb_txdone(struct rt2x00_dev *rt2x00dev)
 	struct queue_entry *entry;
 	u32 reg;
 	u8 qid;
-	enum txdone_entry_desc_flags done_status;
+	bool match;
 
 	while (kfifo_get(&rt2x00dev->txstatus_fifo, &reg)) {
 		/*
@@ -574,11 +573,8 @@ static void rt2800usb_txdone(struct rt2x00_dev *rt2x00dev)
 			break;
 		}
 
-		done_status = rt2800usb_txdone_entry_check(entry, reg);
-		if (likely(done_status == TXDONE_SUCCESS))
-			rt2800_txdone_entry(entry, reg, rt2800usb_get_txwi(entry));
-		else
-			rt2x00lib_txdone_noinfo(entry, done_status);
+		match = rt2800usb_txdone_entry_check(entry, reg);
+		rt2800_txdone_entry(entry, reg, rt2800usb_get_txwi(entry), match);
 	}
 }
 
-- 
1.8.3.1
