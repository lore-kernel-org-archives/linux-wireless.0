Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f182.google.com ([74.125.82.182]:49309 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751885AbaIUTWk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 21 Sep 2014 15:22:40 -0400
Received: by mail-we0-f182.google.com with SMTP id u57so32208wes.13
        for <linux-wireless@vger.kernel.org>; Sun, 21 Sep 2014 12:22:38 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Eyal Shapira <eyal@wizery.com>,
	Eyal Shapira <eyalx.shapira@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 09/17] iwlwifi: mvm: rs: refactor to allow direct rs updating
Date: Sun, 21 Sep 2014 22:22:10 +0300
Message-Id: <1411327338-23099-9-git-send-email-egrumbach@gmail.com> (sfid-20140921_212244_630919_CE4A42A1)
In-Reply-To: <541F23D2.90600@gmail.com>
References: <541F23D2.90600@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eyal Shapira <eyal@wizery.com>

Enable RS to get updated directly via iwl_mvm_rs_tx_status
which will be called by the driver and not via mac80211
rate control. This is required for a following patch to
report on BAs which do not cause the BA window to progress.
Also this is a first step in decoupling rs from the
mac80211 rate control.

Signed-off-by: Eyal Shapira <eyalx.shapira@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/rs.c | 98 +++++++++++++++++------------------
 drivers/net/wireless/iwlwifi/mvm/rs.h |  4 ++
 2 files changed, 52 insertions(+), 50 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/rs.c b/drivers/net/wireless/iwlwifi/mvm/rs.c
index d179a8e..1865ba6 100644
--- a/drivers/net/wireless/iwlwifi/mvm/rs.c
+++ b/drivers/net/wireless/iwlwifi/mvm/rs.c
@@ -377,9 +377,9 @@ static int iwl_hwrate_to_plcp_idx(u32 rate_n_flags)
 }
 
 static void rs_rate_scale_perform(struct iwl_mvm *mvm,
-				   struct sk_buff *skb,
-				   struct ieee80211_sta *sta,
-				   struct iwl_lq_sta *lq_sta);
+				  struct ieee80211_sta *sta,
+				  struct iwl_lq_sta *lq_sta,
+				  int tid);
 static void rs_fill_lq_cmd(struct iwl_mvm *mvm,
 			   struct ieee80211_sta *sta,
 			   struct iwl_lq_sta *lq_sta,
@@ -1007,27 +1007,35 @@ static u32 rs_ch_width_from_mac_flags(enum mac80211_rate_control_flags flags)
 	return RATE_MCS_CHAN_WIDTH_20;
 }
 
-/*
- * mac80211 sends us Tx status
- */
-static void rs_tx_status(void *mvm_r, struct ieee80211_supported_band *sband,
-			 struct ieee80211_sta *sta, void *priv_sta,
-			 struct sk_buff *skb)
+static u8 rs_get_tid(struct ieee80211_hdr *hdr)
+{
+	u8 tid = IWL_MAX_TID_COUNT;
+
+	if (ieee80211_is_data_qos(hdr->frame_control)) {
+		u8 *qc = ieee80211_get_qos_ctl(hdr);
+		tid = qc[0] & 0xf;
+	}
+
+	if (unlikely(tid > IWL_MAX_TID_COUNT))
+		tid = IWL_MAX_TID_COUNT;
+
+	return tid;
+}
+
+void iwl_mvm_rs_tx_status(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
+			  int tid, struct ieee80211_tx_info *info)
 {
 	int legacy_success;
 	int retries;
 	int mac_index, i;
-	struct iwl_lq_sta *lq_sta = priv_sta;
 	struct iwl_lq_cmd *table;
-	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
-	struct iwl_op_mode *op_mode = (struct iwl_op_mode *)mvm_r;
-	struct iwl_mvm *mvm = IWL_OP_MODE_GET_MVM(op_mode);
-	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	enum mac80211_rate_control_flags mac_flags;
 	u32 ucode_rate;
 	struct rs_rate rate;
 	struct iwl_scale_tbl_info *curr_tbl, *other_tbl, *tmp_tbl;
 	u8 reduced_txp = (uintptr_t)info->status.status_driver_data[0];
+	struct iwl_mvm_sta *mvmsta = iwl_mvm_sta_from_mac80211(sta);
+	struct iwl_lq_sta *lq_sta = &mvmsta->lq_sta;
 
 	/* Treat uninitialized rate scaling data same as non-existing. */
 	if (!lq_sta) {
@@ -1045,10 +1053,6 @@ static void rs_tx_status(void *mvm_r, struct ieee80211_supported_band *sband,
 		return;
 	}
 #endif
-	if (!ieee80211_is_data(hdr->frame_control) ||
-	    info->flags & IEEE80211_TX_CTL_NO_ACK)
-		return;
-
 	/* This packet was aggregated but doesn't carry status info */
 	if ((info->flags & IEEE80211_TX_CTL_AMPDU) &&
 	    !(info->flags & IEEE80211_TX_STAT_AMPDU))
@@ -1094,7 +1098,7 @@ static void rs_tx_status(void *mvm_r, struct ieee80211_supported_band *sband,
 		for (tid = 0; tid < IWL_MAX_TID_COUNT; tid++)
 			ieee80211_stop_tx_ba_session(sta, tid);
 
-		iwl_mvm_rs_rate_init(mvm, sta, sband->band, false);
+		iwl_mvm_rs_rate_init(mvm, sta, info->band, false);
 		return;
 	}
 	lq_sta->last_tx = jiffies;
@@ -1221,8 +1225,28 @@ static void rs_tx_status(void *mvm_r, struct ieee80211_supported_band *sband,
 	IWL_DEBUG_RATE(mvm, "reduced txpower: %d\n", reduced_txp);
 done:
 	/* See if there's a better rate or modulation mode to try. */
-	if (sta && sta->supp_rates[sband->band])
-		rs_rate_scale_perform(mvm, skb, sta, lq_sta);
+	if (sta && sta->supp_rates[info->band])
+		rs_rate_scale_perform(mvm, sta, lq_sta, tid);
+}
+
+/*
+ * mac80211 sends us Tx status
+ */
+static void rs_mac80211_tx_status(void *mvm_r,
+				  struct ieee80211_supported_band *sband,
+				  struct ieee80211_sta *sta, void *priv_sta,
+				  struct sk_buff *skb)
+{
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
+	struct iwl_op_mode *op_mode = (struct iwl_op_mode *)mvm_r;
+	struct iwl_mvm *mvm = IWL_OP_MODE_GET_MVM(op_mode);
+	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+
+	if (!ieee80211_is_data(hdr->frame_control) ||
+	    info->flags & IEEE80211_TX_CTL_NO_ACK)
+		return;
+
+	iwl_mvm_rs_tx_status(mvm, sta, rs_get_tid(hdr), info);
 }
 
 /*
@@ -1493,22 +1517,6 @@ static void rs_update_rate_tbl(struct iwl_mvm *mvm,
 	iwl_mvm_send_lq_cmd(mvm, &lq_sta->lq, false);
 }
 
-static u8 rs_get_tid(struct iwl_lq_sta *lq_data,
-		     struct ieee80211_hdr *hdr)
-{
-	u8 tid = IWL_MAX_TID_COUNT;
-
-	if (ieee80211_is_data_qos(hdr->frame_control)) {
-		u8 *qc = ieee80211_get_qos_ctl(hdr);
-		tid = qc[0] & 0xf;
-	}
-
-	if (unlikely(tid > IWL_MAX_TID_COUNT))
-		tid = IWL_MAX_TID_COUNT;
-
-	return tid;
-}
-
 static enum rs_column rs_get_next_column(struct iwl_mvm *mvm,
 					 struct iwl_lq_sta *lq_sta,
 					 struct ieee80211_sta *sta,
@@ -1947,12 +1955,10 @@ static bool rs_tpc_perform(struct iwl_mvm *mvm,
  * Do rate scaling and search for new modulation mode.
  */
 static void rs_rate_scale_perform(struct iwl_mvm *mvm,
-				  struct sk_buff *skb,
 				  struct ieee80211_sta *sta,
-				  struct iwl_lq_sta *lq_sta)
+				  struct iwl_lq_sta *lq_sta,
+				  int tid)
 {
-	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
-	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
 	int low = IWL_RATE_INVALID;
 	int high = IWL_RATE_INVALID;
 	int index;
@@ -1969,19 +1975,11 @@ static void rs_rate_scale_perform(struct iwl_mvm *mvm,
 	u8 done_search = 0;
 	u16 high_low;
 	s32 sr;
-	u8 tid = IWL_MAX_TID_COUNT;
 	u8 prev_agg = lq_sta->is_agg;
 	struct iwl_mvm_sta *sta_priv = (void *)sta->drv_priv;
 	struct iwl_mvm_tid_data *tid_data;
 	struct rs_rate *rate;
 
-	/* Send management frames and NO_ACK data using lowest rate. */
-	/* TODO: this could probably be improved.. */
-	if (!ieee80211_is_data(hdr->frame_control) ||
-	    info->flags & IEEE80211_TX_CTL_NO_ACK)
-		return;
-
-	tid = rs_get_tid(lq_sta, hdr);
 	if ((tid != IWL_MAX_TID_COUNT) &&
 	    (lq_sta->tx_agg_tid_en & (1 << tid))) {
 		tid_data = &sta_priv->tid_data[tid];
@@ -3323,7 +3321,7 @@ static void rs_rate_init_stub(void *mvm_r,
 
 static const struct rate_control_ops rs_mvm_ops = {
 	.name = RS_NAME,
-	.tx_status = rs_tx_status,
+	.tx_status = rs_mac80211_tx_status,
 	.get_rate = rs_get_rate,
 	.rate_init = rs_rate_init_stub,
 	.alloc = rs_alloc,
diff --git a/drivers/net/wireless/iwlwifi/mvm/rs.h b/drivers/net/wireless/iwlwifi/mvm/rs.h
index 95c4b96..eb34c12 100644
--- a/drivers/net/wireless/iwlwifi/mvm/rs.h
+++ b/drivers/net/wireless/iwlwifi/mvm/rs.h
@@ -376,6 +376,10 @@ struct iwl_lq_sta {
 void iwl_mvm_rs_rate_init(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
 			  enum ieee80211_band band, bool init);
 
+/* Notify RS about Tx status */
+void iwl_mvm_rs_tx_status(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
+			  int tid, struct ieee80211_tx_info *info);
+
 /**
  * iwl_rate_control_register - Register the rate control algorithm callbacks
  *
-- 
1.9.1

