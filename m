Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41890 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751077AbdBOJaN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 15 Feb 2017 04:30:13 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
        Felix Fietkau <nbd@nbd.name>
Subject: [PATCH v2 03/10] rt2x00: separte filling tx status from rt2x00lib_txdone
Date: Wed, 15 Feb 2017 10:25:06 +0100
Message-Id: <1487150713-3510-4-git-send-email-sgruszka@redhat.com> (sfid-20170215_103018_477863_CBAB8EDF)
In-Reply-To: <1487150713-3510-1-git-send-email-sgruszka@redhat.com>
References: <1487150713-3510-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This makes rt2x00lib_txdone a bit simpler and will allow to reuse code
in different variant of txdone which I'm preparing.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/ralink/rt2x00/rt2x00dev.c | 141 +++++++++++++------------
 1 file changed, 76 insertions(+), 65 deletions(-)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00dev.c b/drivers/net/wireless/ralink/rt2x00/rt2x00dev.c
index dd66781..b5d90fe 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2x00dev.c
@@ -313,73 +313,14 @@ static inline int rt2x00lib_txdone_bar_status(struct queue_entry *entry)
 	return ret;
 }
 
-void rt2x00lib_txdone(struct queue_entry *entry,
-		      struct txdone_entry_desc *txdesc)
+static void rt2x00lib_fill_tx_status(struct rt2x00_dev *rt2x00dev,
+				     struct ieee80211_tx_info *tx_info,
+				     struct skb_frame_desc *skbdesc,
+				     struct txdone_entry_desc *txdesc,
+				     bool success)
 {
-	struct rt2x00_dev *rt2x00dev = entry->queue->rt2x00dev;
-	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(entry->skb);
-	struct skb_frame_desc *skbdesc = get_skb_frame_desc(entry->skb);
-	unsigned int header_length, i;
 	u8 rate_idx, rate_flags, retry_rates;
-	u8 skbdesc_flags = skbdesc->flags;
-	bool success;
-
-	/*
-	 * Unmap the skb.
-	 */
-	rt2x00queue_unmap_skb(entry);
-
-	/*
-	 * Remove the extra tx headroom from the skb.
-	 */
-	skb_pull(entry->skb, rt2x00dev->extra_tx_headroom);
-
-	/*
-	 * Signal that the TX descriptor is no longer in the skb.
-	 */
-	skbdesc->flags &= ~SKBDESC_DESC_IN_SKB;
-
-	/*
-	 * Determine the length of 802.11 header.
-	 */
-	header_length = ieee80211_get_hdrlen_from_skb(entry->skb);
-
-	/*
-	 * Remove L2 padding which was added during
-	 */
-	if (rt2x00_has_cap_flag(rt2x00dev, REQUIRE_L2PAD))
-		rt2x00queue_remove_l2pad(entry->skb, header_length);
-
-	/*
-	 * If the IV/EIV data was stripped from the frame before it was
-	 * passed to the hardware, we should now reinsert it again because
-	 * mac80211 will expect the same data to be present it the
-	 * frame as it was passed to us.
-	 */
-	if (rt2x00_has_cap_hw_crypto(rt2x00dev))
-		rt2x00crypto_tx_insert_iv(entry->skb, header_length);
-
-	/*
-	 * Send frame to debugfs immediately, after this call is completed
-	 * we are going to overwrite the skb->cb array.
-	 */
-	rt2x00debug_dump_frame(rt2x00dev, DUMP_FRAME_TXDONE, entry);
-
-	/*
-	 * Determine if the frame has been successfully transmitted and
-	 * remove BARs from our check list while checking for their
-	 * TX status.
-	 */
-	success =
-	    rt2x00lib_txdone_bar_status(entry) ||
-	    test_bit(TXDONE_SUCCESS, &txdesc->flags) ||
-	    test_bit(TXDONE_UNKNOWN, &txdesc->flags);
-
-	/*
-	 * Update TX statistics.
-	 */
-	rt2x00dev->link.qual.tx_success += success;
-	rt2x00dev->link.qual.tx_failed += !success;
+	int i;
 
 	rate_idx = skbdesc->tx_rate_idx;
 	rate_flags = skbdesc->tx_rate_flags;
@@ -448,6 +389,76 @@ void rt2x00lib_txdone(struct queue_entry *entry,
 		else
 			rt2x00dev->low_level_stats.dot11RTSFailureCount++;
 	}
+}
+
+void rt2x00lib_txdone(struct queue_entry *entry,
+		      struct txdone_entry_desc *txdesc)
+{
+	struct rt2x00_dev *rt2x00dev = entry->queue->rt2x00dev;
+	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(entry->skb);
+	struct skb_frame_desc *skbdesc = get_skb_frame_desc(entry->skb);
+	u8 skbdesc_flags = skbdesc->flags;
+	unsigned int header_length;
+	bool success;
+
+	/*
+	 * Unmap the skb.
+	 */
+	rt2x00queue_unmap_skb(entry);
+
+	/*
+	 * Remove the extra tx headroom from the skb.
+	 */
+	skb_pull(entry->skb, rt2x00dev->extra_tx_headroom);
+
+	/*
+	 * Signal that the TX descriptor is no longer in the skb.
+	 */
+	skbdesc->flags &= ~SKBDESC_DESC_IN_SKB;
+
+	/*
+	 * Determine the length of 802.11 header.
+	 */
+	header_length = ieee80211_get_hdrlen_from_skb(entry->skb);
+
+	/*
+	 * Remove L2 padding which was added during
+	 */
+	if (rt2x00_has_cap_flag(rt2x00dev, REQUIRE_L2PAD))
+		rt2x00queue_remove_l2pad(entry->skb, header_length);
+
+	/*
+	 * If the IV/EIV data was stripped from the frame before it was
+	 * passed to the hardware, we should now reinsert it again because
+	 * mac80211 will expect the same data to be present it the
+	 * frame as it was passed to us.
+	 */
+	if (rt2x00_has_cap_hw_crypto(rt2x00dev))
+		rt2x00crypto_tx_insert_iv(entry->skb, header_length);
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
+	    test_bit(TXDONE_SUCCESS, &txdesc->flags) ||
+	    test_bit(TXDONE_UNKNOWN, &txdesc->flags);
+
+	/*
+	 * Update TX statistics.
+	 */
+	rt2x00dev->link.qual.tx_success += success;
+	rt2x00dev->link.qual.tx_failed += !success;
+
+	rt2x00lib_fill_tx_status(rt2x00dev, tx_info, skbdesc, txdesc, success);
 
 	/*
 	 * Only send the status report to mac80211 when it's a frame
-- 
1.8.3.1
