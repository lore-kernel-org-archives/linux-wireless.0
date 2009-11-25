Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:53879 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757948AbZKYQuz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Nov 2009 11:50:55 -0500
Message-Id: <20091125164821.018412090@sipsolutions.net>
Date: Wed, 25 Nov 2009 17:46:16 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH v2 2/5] mac80211: move aMPDU RX reorder code
References: <20091125164614.427835023@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This code should be part of RX handlers, so move it
to the place where it belongs without changing it.
A follow-up patch will do the changes to hook it up.
The sole purpose of this code move is to make the
other patch readable, it doesn't change the code at
all except that it now requires a different static
function declaration (which will go away too).

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/rx.c |  459 ++++++++++++++++++++++++++----------------------------
 1 file changed, 229 insertions(+), 230 deletions(-)

--- wireless-testing.orig/net/mac80211/rx.c	2009-11-19 01:14:17.000000000 +0100
+++ wireless-testing/net/mac80211/rx.c	2009-11-19 01:14:21.000000000 +0100
@@ -27,9 +27,9 @@
 #include "tkip.h"
 #include "wme.h"
 
-static void ieee80211_release_reorder_frames(struct ieee80211_hw *hw,
-					     struct tid_ampdu_rx *tid_agg_rx,
-					     u16 head_seq_num);
+static void __ieee80211_rx_handle_packet(struct ieee80211_hw *hw,
+					 struct sk_buff *skb,
+					 struct ieee80211_rate *rate);
 
 /*
  * monitor mode reception
@@ -534,6 +534,232 @@ ieee80211_rx_mesh_check(struct ieee80211
 	return RX_CONTINUE;
 }
 
+#define SEQ_MODULO 0x1000
+#define SEQ_MASK   0xfff
+
+static inline int seq_less(u16 sq1, u16 sq2)
+{
+	return ((sq1 - sq2) & SEQ_MASK) > (SEQ_MODULO >> 1);
+}
+
+static inline u16 seq_inc(u16 sq)
+{
+	return (sq + 1) & SEQ_MASK;
+}
+
+static inline u16 seq_sub(u16 sq1, u16 sq2)
+{
+	return (sq1 - sq2) & SEQ_MASK;
+}
+
+
+static void ieee80211_release_reorder_frame(struct ieee80211_hw *hw,
+					    struct tid_ampdu_rx *tid_agg_rx,
+					    int index)
+{
+	struct ieee80211_supported_band *sband;
+	struct ieee80211_rate *rate = NULL;
+	struct sk_buff *skb = tid_agg_rx->reorder_buf[index];
+	struct ieee80211_rx_status *status;
+
+	if (!skb)
+		goto no_frame;
+
+	status = IEEE80211_SKB_RXCB(skb);
+
+	/* release the reordered frames to stack */
+	sband = hw->wiphy->bands[status->band];
+	if (!(status->flag & RX_FLAG_HT))
+		rate = &sband->bitrates[status->rate_idx];
+	__ieee80211_rx_handle_packet(hw, skb, rate);
+	tid_agg_rx->stored_mpdu_num--;
+	tid_agg_rx->reorder_buf[index] = NULL;
+
+no_frame:
+	tid_agg_rx->head_seq_num = seq_inc(tid_agg_rx->head_seq_num);
+}
+
+static void ieee80211_release_reorder_frames(struct ieee80211_hw *hw,
+					     struct tid_ampdu_rx *tid_agg_rx,
+					     u16 head_seq_num)
+{
+	int index;
+
+	while (seq_less(tid_agg_rx->head_seq_num, head_seq_num)) {
+		index = seq_sub(tid_agg_rx->head_seq_num, tid_agg_rx->ssn) %
+							tid_agg_rx->buf_size;
+		ieee80211_release_reorder_frame(hw, tid_agg_rx, index);
+	}
+}
+
+/*
+ * Timeout (in jiffies) for skb's that are waiting in the RX reorder buffer. If
+ * the skb was added to the buffer longer than this time ago, the earlier
+ * frames that have not yet been received are assumed to be lost and the skb
+ * can be released for processing. This may also release other skb's from the
+ * reorder buffer if there are no additional gaps between the frames.
+ */
+#define HT_RX_REORDER_BUF_TIMEOUT (HZ / 10)
+
+/*
+ * As this function belongs to the RX path it must be under
+ * rcu_read_lock protection. It returns false if the frame
+ * can be processed immediately, true if it was consumed.
+ */
+static bool ieee80211_sta_manage_reorder_buf(struct ieee80211_hw *hw,
+					     struct tid_ampdu_rx *tid_agg_rx,
+					     struct sk_buff *skb)
+{
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
+	u16 sc = le16_to_cpu(hdr->seq_ctrl);
+	u16 mpdu_seq_num = (sc & IEEE80211_SCTL_SEQ) >> 4;
+	u16 head_seq_num, buf_size;
+	int index;
+
+	buf_size = tid_agg_rx->buf_size;
+	head_seq_num = tid_agg_rx->head_seq_num;
+
+	/* frame with out of date sequence number */
+	if (seq_less(mpdu_seq_num, head_seq_num)) {
+		dev_kfree_skb(skb);
+		return true;
+	}
+
+	/*
+	 * If frame the sequence number exceeds our buffering window
+	 * size release some previous frames to make room for this one.
+	 */
+	if (!seq_less(mpdu_seq_num, head_seq_num + buf_size)) {
+		head_seq_num = seq_inc(seq_sub(mpdu_seq_num, buf_size));
+		/* release stored frames up to new head to stack */
+		ieee80211_release_reorder_frames(hw, tid_agg_rx, head_seq_num);
+	}
+
+	/* Now the new frame is always in the range of the reordering buffer */
+
+	index = seq_sub(mpdu_seq_num, tid_agg_rx->ssn) % tid_agg_rx->buf_size;
+
+	/* check if we already stored this frame */
+	if (tid_agg_rx->reorder_buf[index]) {
+		dev_kfree_skb(skb);
+		return true;
+	}
+
+	/*
+	 * If the current MPDU is in the right order and nothing else
+	 * is stored we can process it directly, no need to buffer it.
+	 */
+	if (mpdu_seq_num == tid_agg_rx->head_seq_num &&
+	    tid_agg_rx->stored_mpdu_num == 0) {
+		tid_agg_rx->head_seq_num = seq_inc(tid_agg_rx->head_seq_num);
+		return false;
+	}
+
+	/* put the frame in the reordering buffer */
+	tid_agg_rx->reorder_buf[index] = skb;
+	tid_agg_rx->reorder_time[index] = jiffies;
+	tid_agg_rx->stored_mpdu_num++;
+	/* release the buffer until next missing frame */
+	index = seq_sub(tid_agg_rx->head_seq_num, tid_agg_rx->ssn) %
+						tid_agg_rx->buf_size;
+	if (!tid_agg_rx->reorder_buf[index] &&
+	    tid_agg_rx->stored_mpdu_num > 1) {
+		/*
+		 * No buffers ready to be released, but check whether any
+		 * frames in the reorder buffer have timed out.
+		 */
+		int j;
+		int skipped = 1;
+		for (j = (index + 1) % tid_agg_rx->buf_size; j != index;
+		     j = (j + 1) % tid_agg_rx->buf_size) {
+			if (!tid_agg_rx->reorder_buf[j]) {
+				skipped++;
+				continue;
+			}
+			if (!time_after(jiffies, tid_agg_rx->reorder_time[j] +
+					HT_RX_REORDER_BUF_TIMEOUT))
+				break;
+
+#ifdef CONFIG_MAC80211_HT_DEBUG
+			if (net_ratelimit())
+				printk(KERN_DEBUG "%s: release an RX reorder "
+				       "frame due to timeout on earlier "
+				       "frames\n",
+				       wiphy_name(hw->wiphy));
+#endif
+			ieee80211_release_reorder_frame(hw, tid_agg_rx, j);
+
+			/*
+			 * Increment the head seq# also for the skipped slots.
+			 */
+			tid_agg_rx->head_seq_num =
+				(tid_agg_rx->head_seq_num + skipped) & SEQ_MASK;
+			skipped = 0;
+		}
+	} else while (tid_agg_rx->reorder_buf[index]) {
+		ieee80211_release_reorder_frame(hw, tid_agg_rx, index);
+		index =	seq_sub(tid_agg_rx->head_seq_num, tid_agg_rx->ssn) %
+							tid_agg_rx->buf_size;
+	}
+
+	return true;
+}
+
+/*
+ * Reorder MPDUs from A-MPDUs, keeping them on a buffer. Returns
+ * true if the MPDU was buffered, false if it should be processed.
+ */
+static bool ieee80211_rx_reorder_ampdu(struct ieee80211_local *local,
+				       struct sk_buff *skb)
+{
+	struct ieee80211_hw *hw = &local->hw;
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
+	struct sta_info *sta;
+	struct tid_ampdu_rx *tid_agg_rx;
+	u16 sc;
+	int tid;
+
+	if (!ieee80211_is_data_qos(hdr->frame_control))
+		return false;
+
+	/*
+	 * filter the QoS data rx stream according to
+	 * STA/TID and check if this STA/TID is on aggregation
+	 */
+
+	sta = sta_info_get(local, hdr->addr2);
+	if (!sta)
+		return false;
+
+	tid = *ieee80211_get_qos_ctl(hdr) & IEEE80211_QOS_CTL_TID_MASK;
+
+	if (sta->ampdu_mlme.tid_state_rx[tid] != HT_AGG_STATE_OPERATIONAL)
+		return false;
+
+	tid_agg_rx = sta->ampdu_mlme.tid_rx[tid];
+
+	/* qos null data frames are excluded */
+	if (unlikely(hdr->frame_control & cpu_to_le16(IEEE80211_STYPE_NULLFUNC)))
+		return false;
+
+	/* new, potentially un-ordered, ampdu frame - process it */
+
+	/* reset session timer */
+	if (tid_agg_rx->timeout)
+		mod_timer(&tid_agg_rx->session_timer,
+			  TU_TO_EXP_TIME(tid_agg_rx->timeout));
+
+	/* if this mpdu is fragmented - terminate rx aggregation session */
+	sc = le16_to_cpu(hdr->seq_ctrl);
+	if (sc & IEEE80211_SCTL_FRAG) {
+		ieee80211_sta_stop_rx_ba_session(sta->sdata, sta->sta.addr,
+			tid, 0, WLAN_REASON_QSTA_REQUIRE_SETUP);
+		dev_kfree_skb(skb);
+		return true;
+	}
+
+	return ieee80211_sta_manage_reorder_buf(hw, tid_agg_rx, skb);
+}
 
 static ieee80211_rx_result debug_noinline
 ieee80211_rx_h_check(struct ieee80211_rx_data *rx)
@@ -2187,233 +2413,6 @@ static void __ieee80211_rx_handle_packet
 		dev_kfree_skb(skb);
 }
 
-#define SEQ_MODULO 0x1000
-#define SEQ_MASK   0xfff
-
-static inline int seq_less(u16 sq1, u16 sq2)
-{
-	return ((sq1 - sq2) & SEQ_MASK) > (SEQ_MODULO >> 1);
-}
-
-static inline u16 seq_inc(u16 sq)
-{
-	return (sq + 1) & SEQ_MASK;
-}
-
-static inline u16 seq_sub(u16 sq1, u16 sq2)
-{
-	return (sq1 - sq2) & SEQ_MASK;
-}
-
-
-static void ieee80211_release_reorder_frame(struct ieee80211_hw *hw,
-					    struct tid_ampdu_rx *tid_agg_rx,
-					    int index)
-{
-	struct ieee80211_supported_band *sband;
-	struct ieee80211_rate *rate = NULL;
-	struct sk_buff *skb = tid_agg_rx->reorder_buf[index];
-	struct ieee80211_rx_status *status;
-
-	if (!skb)
-		goto no_frame;
-
-	status = IEEE80211_SKB_RXCB(skb);
-
-	/* release the reordered frames to stack */
-	sband = hw->wiphy->bands[status->band];
-	if (!(status->flag & RX_FLAG_HT))
-		rate = &sband->bitrates[status->rate_idx];
-	__ieee80211_rx_handle_packet(hw, skb, rate);
-	tid_agg_rx->stored_mpdu_num--;
-	tid_agg_rx->reorder_buf[index] = NULL;
-
-no_frame:
-	tid_agg_rx->head_seq_num = seq_inc(tid_agg_rx->head_seq_num);
-}
-
-static void ieee80211_release_reorder_frames(struct ieee80211_hw *hw,
-					     struct tid_ampdu_rx *tid_agg_rx,
-					     u16 head_seq_num)
-{
-	int index;
-
-	while (seq_less(tid_agg_rx->head_seq_num, head_seq_num)) {
-		index = seq_sub(tid_agg_rx->head_seq_num, tid_agg_rx->ssn) %
-							tid_agg_rx->buf_size;
-		ieee80211_release_reorder_frame(hw, tid_agg_rx, index);
-	}
-}
-
-/*
- * Timeout (in jiffies) for skb's that are waiting in the RX reorder buffer. If
- * the skb was added to the buffer longer than this time ago, the earlier
- * frames that have not yet been received are assumed to be lost and the skb
- * can be released for processing. This may also release other skb's from the
- * reorder buffer if there are no additional gaps between the frames.
- */
-#define HT_RX_REORDER_BUF_TIMEOUT (HZ / 10)
-
-/*
- * As this function belongs to the RX path it must be under
- * rcu_read_lock protection. It returns false if the frame
- * can be processed immediately, true if it was consumed.
- */
-static bool ieee80211_sta_manage_reorder_buf(struct ieee80211_hw *hw,
-					     struct tid_ampdu_rx *tid_agg_rx,
-					     struct sk_buff *skb)
-{
-	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
-	u16 sc = le16_to_cpu(hdr->seq_ctrl);
-	u16 mpdu_seq_num = (sc & IEEE80211_SCTL_SEQ) >> 4;
-	u16 head_seq_num, buf_size;
-	int index;
-
-	buf_size = tid_agg_rx->buf_size;
-	head_seq_num = tid_agg_rx->head_seq_num;
-
-	/* frame with out of date sequence number */
-	if (seq_less(mpdu_seq_num, head_seq_num)) {
-		dev_kfree_skb(skb);
-		return true;
-	}
-
-	/*
-	 * If frame the sequence number exceeds our buffering window
-	 * size release some previous frames to make room for this one.
-	 */
-	if (!seq_less(mpdu_seq_num, head_seq_num + buf_size)) {
-		head_seq_num = seq_inc(seq_sub(mpdu_seq_num, buf_size));
-		/* release stored frames up to new head to stack */
-		ieee80211_release_reorder_frames(hw, tid_agg_rx, head_seq_num);
-	}
-
-	/* Now the new frame is always in the range of the reordering buffer */
-
-	index = seq_sub(mpdu_seq_num, tid_agg_rx->ssn) % tid_agg_rx->buf_size;
-
-	/* check if we already stored this frame */
-	if (tid_agg_rx->reorder_buf[index]) {
-		dev_kfree_skb(skb);
-		return true;
-	}
-
-	/*
-	 * If the current MPDU is in the right order and nothing else
-	 * is stored we can process it directly, no need to buffer it.
-	 */
-	if (mpdu_seq_num == tid_agg_rx->head_seq_num &&
-	    tid_agg_rx->stored_mpdu_num == 0) {
-		tid_agg_rx->head_seq_num = seq_inc(tid_agg_rx->head_seq_num);
-		return false;
-	}
-
-	/* put the frame in the reordering buffer */
-	tid_agg_rx->reorder_buf[index] = skb;
-	tid_agg_rx->reorder_time[index] = jiffies;
-	tid_agg_rx->stored_mpdu_num++;
-	/* release the buffer until next missing frame */
-	index = seq_sub(tid_agg_rx->head_seq_num, tid_agg_rx->ssn) %
-						tid_agg_rx->buf_size;
-	if (!tid_agg_rx->reorder_buf[index] &&
-	    tid_agg_rx->stored_mpdu_num > 1) {
-		/*
-		 * No buffers ready to be released, but check whether any
-		 * frames in the reorder buffer have timed out.
-		 */
-		int j;
-		int skipped = 1;
-		for (j = (index + 1) % tid_agg_rx->buf_size; j != index;
-		     j = (j + 1) % tid_agg_rx->buf_size) {
-			if (!tid_agg_rx->reorder_buf[j]) {
-				skipped++;
-				continue;
-			}
-			if (!time_after(jiffies, tid_agg_rx->reorder_time[j] +
-					HT_RX_REORDER_BUF_TIMEOUT))
-				break;
-
-#ifdef CONFIG_MAC80211_HT_DEBUG
-			if (net_ratelimit())
-				printk(KERN_DEBUG "%s: release an RX reorder "
-				       "frame due to timeout on earlier "
-				       "frames\n",
-				       wiphy_name(hw->wiphy));
-#endif
-			ieee80211_release_reorder_frame(hw, tid_agg_rx, j);
-
-			/*
-			 * Increment the head seq# also for the skipped slots.
-			 */
-			tid_agg_rx->head_seq_num =
-				(tid_agg_rx->head_seq_num + skipped) & SEQ_MASK;
-			skipped = 0;
-		}
-	} else while (tid_agg_rx->reorder_buf[index]) {
-		ieee80211_release_reorder_frame(hw, tid_agg_rx, index);
-		index =	seq_sub(tid_agg_rx->head_seq_num, tid_agg_rx->ssn) %
-							tid_agg_rx->buf_size;
-	}
-
-	return true;
-}
-
-/*
- * Reorder MPDUs from A-MPDUs, keeping them on a buffer. Returns
- * true if the MPDU was buffered, false if it should be processed.
- */
-static bool ieee80211_rx_reorder_ampdu(struct ieee80211_local *local,
-				       struct sk_buff *skb)
-{
-	struct ieee80211_hw *hw = &local->hw;
-	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
-	struct sta_info *sta;
-	struct tid_ampdu_rx *tid_agg_rx;
-	u16 sc;
-	int tid;
-
-	if (!ieee80211_is_data_qos(hdr->frame_control))
-		return false;
-
-	/*
-	 * filter the QoS data rx stream according to
-	 * STA/TID and check if this STA/TID is on aggregation
-	 */
-
-	sta = sta_info_get(local, hdr->addr2);
-	if (!sta)
-		return false;
-
-	tid = *ieee80211_get_qos_ctl(hdr) & IEEE80211_QOS_CTL_TID_MASK;
-
-	if (sta->ampdu_mlme.tid_state_rx[tid] != HT_AGG_STATE_OPERATIONAL)
-		return false;
-
-	tid_agg_rx = sta->ampdu_mlme.tid_rx[tid];
-
-	/* qos null data frames are excluded */
-	if (unlikely(hdr->frame_control & cpu_to_le16(IEEE80211_STYPE_NULLFUNC)))
-		return false;
-
-	/* new, potentially un-ordered, ampdu frame - process it */
-
-	/* reset session timer */
-	if (tid_agg_rx->timeout)
-		mod_timer(&tid_agg_rx->session_timer,
-			  TU_TO_EXP_TIME(tid_agg_rx->timeout));
-
-	/* if this mpdu is fragmented - terminate rx aggregation session */
-	sc = le16_to_cpu(hdr->seq_ctrl);
-	if (sc & IEEE80211_SCTL_FRAG) {
-		ieee80211_sta_stop_rx_ba_session(sta->sdata, sta->sta.addr,
-			tid, 0, WLAN_REASON_QSTA_REQUIRE_SETUP);
-		dev_kfree_skb(skb);
-		return true;
-	}
-
-	return ieee80211_sta_manage_reorder_buf(hw, tid_agg_rx, skb);
-}
-
 /*
  * This is the receive path handler. It is called by a low level driver when an
  * 802.11 MPDU is received from the hardware.


