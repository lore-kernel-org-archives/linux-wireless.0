Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49728 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751077AbdBOJaQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 15 Feb 2017 04:30:16 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
        Felix Fietkau <nbd@nbd.name>
Subject: [PATCH v2 05/10] rt2x00: add txdone nomatch function
Date: Wed, 15 Feb 2017 10:25:08 +0100
Message-Id: <1487150713-3510-6-git-send-email-sgruszka@redhat.com> (sfid-20170215_103023_034353_4BE07393)
In-Reply-To: <1487150713-3510-1-git-send-email-sgruszka@redhat.com>
References: <1487150713-3510-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This txdone nomatch function will be used when we get status from the HW,
but we could not match it with any sent skb.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/ralink/rt2x00/rt2x00.h    |  2 ++
 drivers/net/wireless/ralink/rt2x00/rt2x00dev.c | 50 ++++++++++++++++++++++++++
 2 files changed, 52 insertions(+)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00.h b/drivers/net/wireless/ralink/rt2x00/rt2x00.h
index 26869b3..efd6914 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/ralink/rt2x00/rt2x00.h
@@ -1425,6 +1425,8 @@ u32 rt2x00lib_get_bssidx(struct rt2x00_dev *rt2x00dev,
 void rt2x00lib_dmadone(struct queue_entry *entry);
 void rt2x00lib_txdone(struct queue_entry *entry,
 		      struct txdone_entry_desc *txdesc);
+void rt2x00lib_txdone_nomatch(struct queue_entry *entry,
+			      struct txdone_entry_desc *txdesc);
 void rt2x00lib_txdone_noinfo(struct queue_entry *entry, u32 status);
 void rt2x00lib_rxdone(struct queue_entry *entry, gfp_t gfp);
 
diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00dev.c b/drivers/net/wireless/ralink/rt2x00/rt2x00dev.c
index 03b368a..90fc259 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2x00dev.c
@@ -417,6 +417,56 @@ static void rt2x00lib_clear_entry(struct rt2x00_dev *rt2x00dev,
 	spin_unlock_bh(&entry->queue->tx_lock);
 }
 
+void rt2x00lib_txdone_nomatch(struct queue_entry *entry,
+			      struct txdone_entry_desc *txdesc)
+{
+	struct rt2x00_dev *rt2x00dev = entry->queue->rt2x00dev;
+	struct skb_frame_desc *skbdesc = get_skb_frame_desc(entry->skb);
+	struct ieee80211_tx_info txinfo = {};
+	bool success;
+
+	/*
+	 * Unmap the skb.
+	 */
+	rt2x00queue_unmap_skb(entry);
+
+	/*
+	 * Signal that the TX descriptor is no longer in the skb.
+	 */
+	skbdesc->flags &= ~SKBDESC_DESC_IN_SKB;
+
+	/*
+	 * Send frame to debugfs immediately, after this call is completed
+	 * we are going to overwrite the skb->cb array.
+	 */
+	rt2x00debug_dump_frame(rt2x00dev, DUMP_FRAME_TXDONE, entry);
+
+	/*
+	 * Determine if the frame has been successfully transmitted and
+	 * remove BARs from our check list while checking for their
+	 * TX status.
+	 */
+	success =
+	    rt2x00lib_txdone_bar_status(entry) ||
+	    test_bit(TXDONE_SUCCESS, &txdesc->flags);
+
+	if (!test_bit(TXDONE_UNKNOWN, &txdesc->flags)) {
+		/*
+		 * Update TX statistics.
+		 */
+		rt2x00dev->link.qual.tx_success += success;
+		rt2x00dev->link.qual.tx_failed += !success;
+
+		rt2x00lib_fill_tx_status(rt2x00dev, &txinfo, skbdesc, txdesc,
+					 success);
+		ieee80211_tx_status_noskb(rt2x00dev->hw, skbdesc->sta, &txinfo);
+	}
+
+	dev_kfree_skb_any(entry->skb);
+	rt2x00lib_clear_entry(rt2x00dev, entry);
+}
+EXPORT_SYMBOL_GPL(rt2x00lib_txdone_nomatch);
+
 void rt2x00lib_txdone(struct queue_entry *entry,
 		      struct txdone_entry_desc *txdesc)
 {
-- 
1.8.3.1
