Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42151 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754751Ab3BRKLQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Feb 2013 05:11:16 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] wireless: move sequence number arithmetic to ieee80211.h
Date: Mon, 18 Feb 2013 11:11:11 +0100
Message-Id: <1361182271-23692-1-git-send-email-johannes@sipsolutions.net> (sfid-20130218_111121_143638_F1463279)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Move the sequence number arithmetic code from mac80211 to
ieee80211.h so others can use it. Also rename the functions
from _seq to _sn, they operate on the sequence number, not
the sequence_control field.

Also move macros to convert the sequence control to/from
the sequence number value from various drivers.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlegacy/3945.h     |  4 ---
 drivers/net/wireless/iwlegacy/4965-mac.c | 13 ++++----
 drivers/net/wireless/iwlegacy/common.h   |  4 ---
 drivers/net/wireless/iwlwifi/dvm/tx.c    | 14 +++++----
 drivers/net/wireless/iwlwifi/iwl-trans.h |  3 --
 drivers/net/wireless/iwlwifi/mvm/sta.c   |  4 +--
 drivers/net/wireless/iwlwifi/mvm/tx.c    |  2 +-
 drivers/net/wireless/iwlwifi/pcie/tx.c   |  2 +-
 drivers/net/wireless/rtlwifi/wifi.h      |  3 --
 include/linux/ieee80211.h                | 28 +++++++++++++++++
 net/mac80211/rx.c                        | 53 +++++++++++++-------------------
 11 files changed, 68 insertions(+), 62 deletions(-)

diff --git a/drivers/net/wireless/iwlegacy/3945.h b/drivers/net/wireless/iwlegacy/3945.h
index 1d45075..9a8703d 100644
--- a/drivers/net/wireless/iwlegacy/3945.h
+++ b/drivers/net/wireless/iwlegacy/3945.h
@@ -150,10 +150,6 @@ struct il3945_frame {
 	struct list_head list;
 };
 
-#define SEQ_TO_SN(seq) (((seq) & IEEE80211_SCTL_SEQ) >> 4)
-#define SN_TO_SEQ(ssn) (((ssn) << 4) & IEEE80211_SCTL_SEQ)
-#define MAX_SN ((IEEE80211_SCTL_SEQ) >> 4)
-
 #define SUP_RATE_11A_MAX_NUM_CHANNELS  8
 #define SUP_RATE_11B_MAX_NUM_CHANNELS  4
 #define SUP_RATE_11G_MAX_NUM_CHANNELS  12
diff --git a/drivers/net/wireless/iwlegacy/4965-mac.c b/drivers/net/wireless/iwlegacy/4965-mac.c
index 835662a..06ebbef 100644
--- a/drivers/net/wireless/iwlegacy/4965-mac.c
+++ b/drivers/net/wireless/iwlegacy/4965-mac.c
@@ -2252,7 +2252,7 @@ il4965_tx_agg_start(struct il_priv *il, struct ieee80211_vif *vif,
 
 	spin_lock_irqsave(&il->sta_lock, flags);
 	tid_data = &il->stations[sta_id].tid[tid];
-	*ssn = SEQ_TO_SN(tid_data->seq_number);
+	*ssn = IEEE80211_SEQ_TO_SN(tid_data->seq_number);
 	tid_data->agg.txq_id = txq_id;
 	il_set_swq_id(&il->txq[txq_id], il4965_get_ac_from_tid(tid), txq_id);
 	spin_unlock_irqrestore(&il->sta_lock, flags);
@@ -2402,7 +2402,7 @@ il4965_txq_check_empty(struct il_priv *il, int sta_id, u8 tid, int txq_id)
 		/* aggregated HW queue */
 		if (txq_id == tid_data->agg.txq_id &&
 		    q->read_ptr == q->write_ptr) {
-			u16 ssn = SEQ_TO_SN(tid_data->seq_number);
+			u16 ssn = IEEE80211_SEQ_TO_SN(tid_data->seq_number);
 			int tx_fifo = il4965_get_fifo_from_tid(tid);
 			D_HT("HW queue empty: continue DELBA flow\n");
 			il4965_txq_agg_disable(il, txq_id, ssn, tx_fifo);
@@ -2621,7 +2621,8 @@ il4965_get_ra_sta_id(struct il_priv *il, struct ieee80211_hdr *hdr)
 static inline u32
 il4965_get_scd_ssn(struct il4965_tx_resp *tx_resp)
 {
-	return le32_to_cpup(&tx_resp->u.status + tx_resp->frame_count) & MAX_SN;
+	return le32_to_cpup(&tx_resp->u.status +
+			    tx_resp->frame_count) & IEEE80211_MAX_SN;
 }
 
 static inline u32
@@ -2711,15 +2712,15 @@ il4965_tx_status_reply_tx(struct il_priv *il, struct il_ht_agg *agg,
 			hdr = (struct ieee80211_hdr *) skb->data;
 
 			sc = le16_to_cpu(hdr->seq_ctrl);
-			if (idx != (SEQ_TO_SN(sc) & 0xff)) {
+			if (idx != (IEEE80211_SEQ_TO_SN(sc) & 0xff)) {
 				IL_ERR("BUG_ON idx doesn't match seq control"
 				       " idx=%d, seq_idx=%d, seq=%d\n", idx,
-				       SEQ_TO_SN(sc), hdr->seq_ctrl);
+				       IEEE80211_SEQ_TO_SN(sc), hdr->seq_ctrl);
 				return -1;
 			}
 
 			D_TX_REPLY("AGG Frame i=%d idx %d seq=%d\n", i, idx,
-				   SEQ_TO_SN(sc));
+				   IEEE80211_SEQ_TO_SN(sc));
 
 			sh = idx - start;
 			if (sh > 64) {
diff --git a/drivers/net/wireless/iwlegacy/common.h b/drivers/net/wireless/iwlegacy/common.h
index 853fe58..728aa13 100644
--- a/drivers/net/wireless/iwlegacy/common.h
+++ b/drivers/net/wireless/iwlegacy/common.h
@@ -541,10 +541,6 @@ struct il_frame {
 	struct list_head list;
 };
 
-#define SEQ_TO_SN(seq) (((seq) & IEEE80211_SCTL_SEQ) >> 4)
-#define SN_TO_SEQ(ssn) (((ssn) << 4) & IEEE80211_SCTL_SEQ)
-#define MAX_SN ((IEEE80211_SCTL_SEQ) >> 4)
-
 enum {
 	CMD_SYNC = 0,
 	CMD_SIZE_NORMAL = 0,
diff --git a/drivers/net/wireless/iwlwifi/dvm/tx.c b/drivers/net/wireless/iwlwifi/dvm/tx.c
index 7b0550d..74da397 100644
--- a/drivers/net/wireless/iwlwifi/dvm/tx.c
+++ b/drivers/net/wireless/iwlwifi/dvm/tx.c
@@ -418,7 +418,8 @@ int iwlagn_tx_skb(struct iwl_priv *priv,
 				" Tx flags = 0x%08x, agg.state = %d",
 				info->flags, tid_data->agg.state);
 			IWL_ERR(priv, "sta_id = %d, tid = %d seq_num = %d",
-				sta_id, tid, SEQ_TO_SN(tid_data->seq_number));
+				sta_id, tid,
+				IEEE80211_SEQ_TO_SN(tid_data->seq_number));
 			goto drop_unlock_sta;
 		}
 
@@ -569,7 +570,7 @@ int iwlagn_tx_agg_stop(struct iwl_priv *priv, struct ieee80211_vif *vif,
 		return 0;
 	}
 
-	tid_data->agg.ssn = SEQ_TO_SN(tid_data->seq_number);
+	tid_data->agg.ssn = IEEE80211_SEQ_TO_SN(tid_data->seq_number);
 
 	/* There are still packets for this RA / TID in the HW */
 	if (!test_bit(txq_id, priv->agg_q_alloc)) {
@@ -651,7 +652,7 @@ int iwlagn_tx_agg_start(struct iwl_priv *priv, struct ieee80211_vif *vif,
 
 	spin_lock_bh(&priv->sta_lock);
 	tid_data = &priv->tid_data[sta_id][tid];
-	tid_data->agg.ssn = SEQ_TO_SN(tid_data->seq_number);
+	tid_data->agg.ssn = IEEE80211_SEQ_TO_SN(tid_data->seq_number);
 	tid_data->agg.txq_id = txq_id;
 
 	*ssn = tid_data->agg.ssn;
@@ -985,7 +986,7 @@ const char *iwl_get_agg_tx_fail_reason(u16 status)
 static inline u32 iwlagn_get_scd_ssn(struct iwlagn_tx_resp *tx_resp)
 {
 	return le32_to_cpup((__le32 *)&tx_resp->status +
-			    tx_resp->frame_count) & MAX_SN;
+			    tx_resp->frame_count) & IEEE80211_MAX_SN;
 }
 
 static void iwlagn_count_tx_err_status(struct iwl_priv *priv, u16 status)
@@ -1128,7 +1129,7 @@ int iwlagn_rx_reply_tx(struct iwl_priv *priv, struct iwl_rx_cmd_buffer *rxb,
 
 	if (tx_resp->frame_count == 1) {
 		u16 next_reclaimed = le16_to_cpu(tx_resp->seq_ctl);
-		next_reclaimed = SEQ_TO_SN(next_reclaimed + 0x10);
+		next_reclaimed = IEEE80211_SEQ_TO_SN(next_reclaimed + 0x10);
 
 		if (is_agg) {
 			/* If this is an aggregation queue, we can rely on the
@@ -1202,7 +1203,8 @@ int iwlagn_rx_reply_tx(struct iwl_priv *priv, struct iwl_rx_cmd_buffer *rxb,
 			if (!is_agg && status == TX_STATUS_FAIL_FIFO_FLUSHED) {
 				next_reclaimed = le16_to_cpu(hdr->seq_ctrl);
 				next_reclaimed =
-					SEQ_TO_SN(next_reclaimed + 0x10);
+					IEEE80211_SEQ_TO_SN(next_reclaimed +
+							    0x10);
 			}
 
 			is_offchannel_skb =
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.h b/drivers/net/wireless/iwlwifi/iwl-trans.h
index 0a3d4df..55345e5 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.h
@@ -113,9 +113,6 @@
  * completely agnostic to these differences.
  * The transport does provide helper functionnality (i.e. SYNC / ASYNC mode),
  */
-#define SEQ_TO_SN(seq) (((seq) & IEEE80211_SCTL_SEQ) >> 4)
-#define SN_TO_SEQ(ssn) (((ssn) << 4) & IEEE80211_SCTL_SEQ)
-#define MAX_SN ((IEEE80211_SCTL_SEQ) >> 4)
 #define SEQ_TO_QUEUE(s)	(((s) >> 8) & 0x1f)
 #define QUEUE_TO_SEQ(q)	(((q) & 0x1f) << 8)
 #define SEQ_TO_INDEX(s)	((s) & 0xff)
diff --git a/drivers/net/wireless/iwlwifi/mvm/sta.c b/drivers/net/wireless/iwlwifi/mvm/sta.c
index 69603c3..87e7b93 100644
--- a/drivers/net/wireless/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/iwlwifi/mvm/sta.c
@@ -675,7 +675,7 @@ int iwl_mvm_sta_tx_agg_start(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 
 	spin_lock_bh(&mvmsta->lock);
 	tid_data = &mvmsta->tid_data[tid];
-	tid_data->ssn = SEQ_TO_SN(tid_data->seq_number);
+	tid_data->ssn = IEEE80211_SEQ_TO_SN(tid_data->seq_number);
 	tid_data->txq_id = txq_id;
 	*ssn = tid_data->ssn;
 
@@ -768,7 +768,7 @@ int iwl_mvm_sta_tx_agg_stop(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 
 	switch (tid_data->state) {
 	case IWL_AGG_ON:
-		tid_data->ssn = SEQ_TO_SN(tid_data->seq_number);
+		tid_data->ssn = IEEE80211_SEQ_TO_SN(tid_data->seq_number);
 
 		IWL_DEBUG_TX_QUEUES(mvm,
 				    "ssn = %d, next_recl = %d\n",
diff --git a/drivers/net/wireless/iwlwifi/mvm/tx.c b/drivers/net/wireless/iwlwifi/mvm/tx.c
index cada8ef..dfe0f8f 100644
--- a/drivers/net/wireless/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/iwlwifi/mvm/tx.c
@@ -641,7 +641,7 @@ static void iwl_mvm_rx_tx_cmd_single(struct iwl_mvm *mvm,
 		next_reclaimed = ssn;
 	} else {
 		/* The next packet to be reclaimed is the one after this one */
-		next_reclaimed = SEQ_TO_SN(seq_ctl + 0x10);
+		next_reclaimed = IEEE80211_SEQ_TO_SN(seq_ctl + 0x10);
 	}
 
 	IWL_DEBUG_TX_REPLY(mvm,
diff --git a/drivers/net/wireless/iwlwifi/pcie/tx.c b/drivers/net/wireless/iwlwifi/pcie/tx.c
index 041127a..5029f7f 100644
--- a/drivers/net/wireless/iwlwifi/pcie/tx.c
+++ b/drivers/net/wireless/iwlwifi/pcie/tx.c
@@ -1581,7 +1581,7 @@ int iwl_trans_pcie_tx(struct iwl_trans *trans, struct sk_buff *skb,
 	 * Check here that the packets are in the right place on the ring.
 	 */
 #ifdef CONFIG_IWLWIFI_DEBUG
-	wifi_seq = SEQ_TO_SN(le16_to_cpu(hdr->seq_ctrl));
+	wifi_seq = IEEE80211_SEQ_TO_SN(le16_to_cpu(hdr->seq_ctrl));
 	WARN_ONCE((iwl_read_prph(trans, SCD_AGGR_SEL) & BIT(txq_id)) &&
 		  ((wifi_seq & 0xff) != q->write_ptr),
 		  "Q: %d WiFi Seq %d tfdNum %d",
diff --git a/drivers/net/wireless/rtlwifi/wifi.h b/drivers/net/wireless/rtlwifi/wifi.h
index f13258a..c3eff32 100644
--- a/drivers/net/wireless/rtlwifi/wifi.h
+++ b/drivers/net/wireless/rtlwifi/wifi.h
@@ -2127,9 +2127,6 @@ value to host byte ordering.*/
 #define WLAN_FC_GET_TYPE(fc)	(le16_to_cpu(fc) & IEEE80211_FCTL_FTYPE)
 #define WLAN_FC_GET_STYPE(fc)	(le16_to_cpu(fc) & IEEE80211_FCTL_STYPE)
 #define WLAN_FC_MORE_DATA(fc)	(le16_to_cpu(fc) & IEEE80211_FCTL_MOREDATA)
-#define SEQ_TO_SN(seq)		(((seq) & IEEE80211_SCTL_SEQ) >> 4)
-#define SN_TO_SEQ(ssn)		(((ssn) << 4) & IEEE80211_SCTL_SEQ)
-#define MAX_SN			((IEEE80211_SCTL_SEQ) >> 4)
 
 #define	RT_RF_OFF_LEVL_ASPM		BIT(0)	/*PCI ASPM */
 #define	RT_RF_OFF_LEVL_CLK_REQ		BIT(1)	/*PCI clock request */
diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index 49255d2..226a5f4 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -113,6 +113,34 @@
 #define IEEE80211_CTL_EXT_SSW_FBACK	0x9000
 #define IEEE80211_CTL_EXT_SSW_ACK	0xa000
 
+
+#define IEEE80211_SN_MASK		((IEEE80211_SCTL_SEQ) >> 4)
+#define IEEE80211_MAX_SN		IEEE80211_SN_MASK
+#define IEEE80211_SN_MODULO		(IEEE80211_MAX_SN + 1)
+
+static inline int ieee80211_sn_less(u16 sn1, u16 sn2)
+{
+	return ((sn1 - sn2) & IEEE80211_SN_MASK) > (IEEE80211_SN_MODULO >> 1);
+}
+
+static inline u16 ieee80211_sn_add(u16 sn1, u16 sn2)
+{
+	return (sn1 + sn2) & IEEE80211_SN_MASK;
+}
+
+static inline u16 ieee80211_sn_inc(u16 sn)
+{
+	return ieee80211_sn_add(sn, 1);
+}
+
+static inline u16 ieee80211_sn_sub(u16 sn1, u16 sn2)
+{
+	return (sn1 - sn2) & IEEE80211_SN_MASK;
+}
+
+#define IEEE80211_SEQ_TO_SN(seq)	(((seq) & IEEE80211_SCTL_SEQ) >> 4)
+#define IEEE80211_SN_TO_SEQ(ssn)	(((ssn) << 4) & IEEE80211_SCTL_SEQ)
+
 /* miscellaneous IEEE 802.11 constants */
 #define IEEE80211_MAX_FRAG_THRESHOLD	2352
 #define IEEE80211_MAX_RTS_THRESHOLD	2353
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index bb73ed2d..eb76a96 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -648,24 +648,6 @@ static ieee80211_rx_result ieee80211_rx_mesh_check(struct ieee80211_rx_data *rx)
 	return RX_CONTINUE;
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
 static void ieee80211_release_reorder_frame(struct ieee80211_sub_if_data *sdata,
 					    struct tid_ampdu_rx *tid_agg_rx,
 					    int index,
@@ -687,7 +669,7 @@ static void ieee80211_release_reorder_frame(struct ieee80211_sub_if_data *sdata,
 	__skb_queue_tail(frames, skb);
 
 no_frame:
-	tid_agg_rx->head_seq_num = seq_inc(tid_agg_rx->head_seq_num);
+	tid_agg_rx->head_seq_num = ieee80211_sn_inc(tid_agg_rx->head_seq_num);
 }
 
 static void ieee80211_release_reorder_frames(struct ieee80211_sub_if_data *sdata,
@@ -699,8 +681,9 @@ static void ieee80211_release_reorder_frames(struct ieee80211_sub_if_data *sdata
 
 	lockdep_assert_held(&tid_agg_rx->reorder_lock);
 
-	while (seq_less(tid_agg_rx->head_seq_num, head_seq_num)) {
-		index = seq_sub(tid_agg_rx->head_seq_num, tid_agg_rx->ssn) %
+	while (ieee80211_sn_less(tid_agg_rx->head_seq_num, head_seq_num)) {
+		index = ieee80211_sn_sub(tid_agg_rx->head_seq_num,
+					 tid_agg_rx->ssn) %
 							tid_agg_rx->buf_size;
 		ieee80211_release_reorder_frame(sdata, tid_agg_rx, index,
 						frames);
@@ -727,8 +710,8 @@ static void ieee80211_sta_reorder_release(struct ieee80211_sub_if_data *sdata,
 	lockdep_assert_held(&tid_agg_rx->reorder_lock);
 
 	/* release the buffer until next missing frame */
-	index = seq_sub(tid_agg_rx->head_seq_num, tid_agg_rx->ssn) %
-						tid_agg_rx->buf_size;
+	index = ieee80211_sn_sub(tid_agg_rx->head_seq_num,
+				 tid_agg_rx->ssn) % tid_agg_rx->buf_size;
 	if (!tid_agg_rx->reorder_buf[index] &&
 	    tid_agg_rx->stored_mpdu_num) {
 		/*
@@ -756,19 +739,22 @@ static void ieee80211_sta_reorder_release(struct ieee80211_sub_if_data *sdata,
 			 * Increment the head seq# also for the skipped slots.
 			 */
 			tid_agg_rx->head_seq_num =
-				(tid_agg_rx->head_seq_num + skipped) & SEQ_MASK;
+				(tid_agg_rx->head_seq_num +
+				 skipped) & IEEE80211_SN_MASK;
 			skipped = 0;
 		}
 	} else while (tid_agg_rx->reorder_buf[index]) {
 		ieee80211_release_reorder_frame(sdata, tid_agg_rx, index,
 						frames);
-		index =	seq_sub(tid_agg_rx->head_seq_num, tid_agg_rx->ssn) %
+		index =	ieee80211_sn_sub(tid_agg_rx->head_seq_num,
+					 tid_agg_rx->ssn) %
 							tid_agg_rx->buf_size;
 	}
 
 	if (tid_agg_rx->stored_mpdu_num) {
-		j = index = seq_sub(tid_agg_rx->head_seq_num,
-				    tid_agg_rx->ssn) % tid_agg_rx->buf_size;
+		j = index = ieee80211_sn_sub(tid_agg_rx->head_seq_num,
+					     tid_agg_rx->ssn) %
+							tid_agg_rx->buf_size;
 
 		for (; j != (index - 1) % tid_agg_rx->buf_size;
 		     j = (j + 1) % tid_agg_rx->buf_size) {
@@ -809,7 +795,7 @@ static bool ieee80211_sta_manage_reorder_buf(struct ieee80211_sub_if_data *sdata
 	head_seq_num = tid_agg_rx->head_seq_num;
 
 	/* frame with out of date sequence number */
-	if (seq_less(mpdu_seq_num, head_seq_num)) {
+	if (ieee80211_sn_less(mpdu_seq_num, head_seq_num)) {
 		dev_kfree_skb(skb);
 		goto out;
 	}
@@ -818,8 +804,9 @@ static bool ieee80211_sta_manage_reorder_buf(struct ieee80211_sub_if_data *sdata
 	 * If frame the sequence number exceeds our buffering window
 	 * size release some previous frames to make room for this one.
 	 */
-	if (!seq_less(mpdu_seq_num, head_seq_num + buf_size)) {
-		head_seq_num = seq_inc(seq_sub(mpdu_seq_num, buf_size));
+	if (!ieee80211_sn_less(mpdu_seq_num, head_seq_num + buf_size)) {
+		head_seq_num = ieee80211_sn_inc(
+				ieee80211_sn_sub(mpdu_seq_num, buf_size));
 		/* release stored frames up to new head to stack */
 		ieee80211_release_reorder_frames(sdata, tid_agg_rx,
 						 head_seq_num, frames);
@@ -827,7 +814,8 @@ static bool ieee80211_sta_manage_reorder_buf(struct ieee80211_sub_if_data *sdata
 
 	/* Now the new frame is always in the range of the reordering buffer */
 
-	index = seq_sub(mpdu_seq_num, tid_agg_rx->ssn) % tid_agg_rx->buf_size;
+	index = ieee80211_sn_sub(mpdu_seq_num,
+				 tid_agg_rx->ssn) % tid_agg_rx->buf_size;
 
 	/* check if we already stored this frame */
 	if (tid_agg_rx->reorder_buf[index]) {
@@ -843,7 +831,8 @@ static bool ieee80211_sta_manage_reorder_buf(struct ieee80211_sub_if_data *sdata
 	 */
 	if (mpdu_seq_num == tid_agg_rx->head_seq_num &&
 	    tid_agg_rx->stored_mpdu_num == 0) {
-		tid_agg_rx->head_seq_num = seq_inc(tid_agg_rx->head_seq_num);
+		tid_agg_rx->head_seq_num =
+			ieee80211_sn_inc(tid_agg_rx->head_seq_num);
 		ret = false;
 		goto out;
 	}
-- 
1.8.0

