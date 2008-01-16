Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:35740 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752239AbYAPSlL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Jan 2008 13:41:11 -0500
From: Ron Rindjunsky <ron.rindjunsky@intel.com>
To: linville@tuxdriver.com
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
	flamingice@sourmilk.net, tomas.winkler@intel.com, yi.zhu@intel.com,
	Ron Rindjunsky <ron.rindjunsky@intel.com>
Subject: [RFC PATCH 12/12 v2] iwlwifi: A-MPDU Tx activation by load measures
Date: Wed, 16 Jan 2008 20:41:00 +0200
Message-Id: <12005088652234-git-send-email-ron.rindjunsky@intel.com> (sfid-20080116_184125_852757_B15913E7)
In-Reply-To: <1200508860699-git-send-email-ron.rindjunsky@intel.com>
References: <1200508860699-git-send-email-ron.rindjunsky@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch gives first heuristic for activation of the A-MPDU Tx.
As the rate scaling is rate aware, it now also measures estimated load, and
sends A-MPDU activation after a threshold has been met.

Signed-off-by: Ron Rindjunsky <ron.rindjunsky@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965-rs.c  |  188 ++++++++++++--
 drivers/net/wireless/iwlwifi/iwl-4965-rs.h  |    3 +
 drivers/net/wireless/iwlwifi/iwl-4965.c     |  396 ---------------------------
 drivers/net/wireless/iwlwifi/iwl-4965.h     |   42 +---
 drivers/net/wireless/iwlwifi/iwl4965-base.c |   20 --
 5 files changed, 174 insertions(+), 475 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965-rs.c b/drivers/net/wireless/iwlwifi/iwl-4965-rs.c
index eda0f4d..dd59535 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965-rs.c
@@ -83,7 +83,7 @@ struct iwl4965_rate_scale_data {
 /**
  * struct iwl4965_scale_tbl_info -- tx params and success history for all rates
  *
- * There are two of these in struct iwl_rate_scale_priv,
+ * There are two of these in struct iwl4965_lq_sta,
  * one for "active", and one for "search".
  */
 struct iwl4965_scale_tbl_info {
@@ -98,8 +98,23 @@ struct iwl4965_scale_tbl_info {
 	struct iwl4965_rate_scale_data win[IWL_RATE_COUNT]; /* rate histories */
 };
 
+#ifdef CONFIG_IWL4965_HT
+
+struct iwl4965_traffic_load {
+	unsigned long time_stamp;	/* age of the oldest statistics */
+	u32 packet_count[TID_QUEUE_MAX_SIZE];   /* packet count in this time */
+						/* slice */
+	u8 queue_count;				/* number of queues that has */
+					/* been used since the last cleanup */
+	u8 head;			/* start of the circular buffer */
+	u32 total;			/* total num of packets during the */
+					/* last TID_MAX_TIME_DIFF */
+};
+
+#endif /* CONFIG_IWL4965_HT */
+
 /**
- * struct iwl_rate_scale_priv -- driver's rate scaling private structure
+ * struct iwl4965_lq_sta -- driver's rate scaling private structure
  *
  * Pointer to this gets passed back and forth between driver and mac80211.
  */
@@ -136,6 +151,9 @@ struct iwl4965_lq_sta {
 
 	struct iwl4965_link_quality_cmd lq;
 	struct iwl4965_scale_tbl_info lq_info[LQ_SIZE]; /* "active", "search" */
+#ifdef CONFIG_IWL4965_HT
+	struct iwl4965_traffic_load traffic_load[TID_MAX_LOAD_COUNT];
+#endif
 #ifdef CONFIG_MAC80211_DEBUGFS
 	struct dentry *rs_sta_dbgfs_scale_table_file;
 	struct dentry *rs_sta_dbgfs_stats_table_file;
@@ -269,6 +287,135 @@ static void rs_rate_scale_clear_window(struct iwl4965_rate_scale_data *window)
 	window->stamp = 0;
 }
 
+#ifdef CONFIG_IWL4965_HT
+/*
+ *	removes the old data from the statistics. All data that is older than
+ *	TID_MAX_TIME_DIFF, will be deleted.
+ */
+static void rs_tl_rm_old_stats(struct iwl4965_traffic_load *tl, u32 curr_time)
+{
+	/* The oldest age we want to keep */
+	u32 oldest_time = curr_time - TID_MAX_TIME_DIFF;
+
+	while (tl->queue_count &&
+	       (tl->time_stamp < oldest_time)) {
+		tl->total -= tl->packet_count[tl->head];
+		tl->packet_count[tl->head] = 0;
+		tl->time_stamp += TID_QUEUE_CELL_SPACING;
+		tl->queue_count--;
+		tl->head++;
+		if (tl->head >= TID_QUEUE_MAX_SIZE)
+			tl->head = 0;
+	}
+}
+
+/*
+ *	increment traffic load value for tid and also remove
+ *	any old values if passed the certian time period
+ */
+static void rs_tl_add_packet(struct iwl4965_lq_sta *lq_data, u8 tid)
+{
+	u32 curr_time = jiffies_to_msecs(jiffies);
+	u32 time_diff;
+	s32 index;
+	struct iwl4965_traffic_load *tl = NULL;
+
+	if (tid >= TID_MAX_LOAD_COUNT)
+		return;
+
+	tl = &lq_data->traffic_load[tid];
+
+	curr_time -= curr_time % TID_ROUND_VALUE;
+
+	/* Happens only for the first packet. Initialize the data */
+	if (!(tl->queue_count)) {
+		tl->total = 1;
+		tl->time_stamp = curr_time;
+		tl->queue_count = 1;
+		tl->head = 0;
+		tl->packet_count[0] = 1;
+		return;
+	}
+
+	time_diff = TIME_WRAP_AROUND(tl->time_stamp, curr_time);
+	index = time_diff / TID_QUEUE_CELL_SPACING;
+
+	/* The history is too long: remove data that is older than */
+	/* TID_MAX_TIME_DIFF */
+	if (index >= TID_QUEUE_MAX_SIZE)
+		rs_tl_rm_old_stats(tl, curr_time);
+
+	index = (tl->head + index) % TID_QUEUE_MAX_SIZE;
+	tl->packet_count[index] = tl->packet_count[index] + 1;
+	tl->total = tl->total + 1;
+
+	if ((index + 1) > tl->queue_count)
+		tl->queue_count = index + 1;
+}
+
+/*
+	get the traffic load value for tid
+*/
+static u32 rs_tl_get_load(struct iwl4965_lq_sta *lq_data, u8 tid)
+{
+	u32 curr_time = jiffies_to_msecs(jiffies);
+	u32 time_diff;
+	s32 index;
+	struct iwl4965_traffic_load *tl = NULL;
+
+	if (tid >= TID_MAX_LOAD_COUNT)
+		return 0;
+
+	tl = &(lq_data->traffic_load[tid]);
+
+	curr_time -= curr_time % TID_ROUND_VALUE;
+
+	if (!(tl->queue_count))
+		return 0;
+
+	time_diff = TIME_WRAP_AROUND(tl->time_stamp, curr_time);
+	index = time_diff / TID_QUEUE_CELL_SPACING;
+
+	/* The history is too long: remove data that is older than */
+	/* TID_MAX_TIME_DIFF */
+	if (index >= TID_QUEUE_MAX_SIZE)
+		rs_tl_rm_old_stats(tl, curr_time);
+
+	return tl->total;
+}
+
+static void rs_tl_turn_on_agg_for_tid(struct iwl4965_priv *priv,
+				struct iwl4965_lq_sta *lq_data, u8 tid,
+				struct sta_info *sta)
+{
+	unsigned long state;
+	DECLARE_MAC_BUF(mac);
+
+	spin_lock_bh(&sta->ampdu_mlme.ampdu_tx);
+	state = sta->ampdu_mlme.tid_tx[tid].state;
+	spin_unlock_bh(&sta->ampdu_mlme.ampdu_tx);
+
+	if (state == HT_AGG_STATE_IDLE &&
+	    rs_tl_get_load(lq_data, tid) > IWL_AGG_LOAD_THRESHOLD) {
+		IWL_DEBUG_HT("Starting Tx agg: STA: %s tid: %d\n",
+				print_mac(mac, sta->addr), tid);
+		ieee80211_start_tx_ba_session(priv->hw, sta->addr, tid);
+	}
+}
+
+static void rs_tl_turn_on_agg(struct iwl4965_priv *priv, u8 tid,
+				struct iwl4965_lq_sta *lq_data,
+				struct sta_info *sta)
+{
+	if ((tid < TID_MAX_LOAD_COUNT))
+		rs_tl_turn_on_agg_for_tid(priv, lq_data, tid, sta);
+	else if (tid == TID_ALL_SPECIFIED)
+		for (tid = 0; tid < TID_MAX_LOAD_COUNT; tid++)
+			rs_tl_turn_on_agg_for_tid(priv, lq_data, tid, sta);
+}
+
+#endif /* CONFIG_IWLWIFI_HT */
+
 /**
  * rs_collect_tx_data - Update the success/failure sliding window
  *
@@ -1134,7 +1281,7 @@ static int rs_switch_to_mimo(struct iwl4965_priv *priv,
 	return 0;
 #else
 	return -1;
-#endif				/*CONFIG_IWL4965_HT */
+#endif	/*CONFIG_IWL4965_HT */
 }
 
 /*
@@ -1197,7 +1344,7 @@ static int rs_switch_to_siso(struct iwl4965_priv *priv,
 #else
 	return -1;
 
-#endif				/*CONFIG_IWL4965_HT */
+#endif	/*CONFIG_IWL4965_HT */
 }
 
 /*
@@ -1354,6 +1501,7 @@ static int rs_move_siso_to_other(struct iwl4965_priv *priv,
 			break;
 		case IWL_SISO_SWITCH_GI:
 			IWL_DEBUG_HT("LQ: SISO SWITCH TO GI\n");
+
 			memcpy(search_tbl, tbl, sz);
 			search_tbl->action = 0;
 			if (search_tbl->is_SGI)
@@ -1419,6 +1567,7 @@ static int rs_move_mimo_to_other(struct iwl4965_priv *priv,
 		case IWL_MIMO_SWITCH_ANTENNA_B:
 			IWL_DEBUG_HT("LQ: MIMO SWITCH TO SISO\n");
 
+
 			/* Set up new search table for SISO */
 			memcpy(search_tbl, tbl, sz);
 			search_tbl->lq_type = LQ_SISO;
@@ -1603,6 +1752,10 @@ static void rs_rate_scale_perform(struct iwl4965_priv *priv,
 	u8 active_tbl = 0;
 	u8 done_search = 0;
 	u16 high_low;
+#ifdef CONFIG_IWL4965_HT
+	u8 tid = MAX_TID_COUNT;
+	__le16 *qc;
+#endif
 
 	IWL_DEBUG_RATE("rate scale calculate new rate for skb\n");
 
@@ -1623,6 +1776,13 @@ static void rs_rate_scale_perform(struct iwl4965_priv *priv,
 	}
 	lq_sta = (struct iwl4965_lq_sta *)sta->rate_ctrl_priv;
 
+#ifdef CONFIG_IWL4965_HT
+	qc = ieee80211_get_qos_ctrl(hdr);
+	if (qc) {
+		tid = (u8)(le16_to_cpu(*qc) & 0xf);
+		rs_tl_add_packet(lq_sta, tid);
+	}
+#endif
 	/*
 	 * Select rate-scale / modulation-mode table to work with in
 	 * the rest of this function:  "search" if searching for better
@@ -1943,15 +2103,13 @@ static void rs_rate_scale_perform(struct iwl4965_priv *priv,
 		 * mode for a while before next round of mode comparisons. */
 		if (lq_sta->enable_counter &&
 		    (lq_sta->action_counter >= IWL_ACTION_LIMIT)) {
-#ifdef CONFIG_IWL4965_HT_AGG
-			/* If appropriate, set up aggregation! */
-			if ((lq_sta->last_tpt > TID_AGG_TPT_THREHOLD) &&
-			    (priv->lq_mngr.agg_ctrl.auto_agg)) {
-				priv->lq_mngr.agg_ctrl.tid_retry =
-				    TID_ALL_SPECIFIED;
-				schedule_work(&priv->agg_work);
+#ifdef CONFIG_IWL4965_HT
+			if (lq_sta->last_tpt > TID_AGG_TPT_THREHOLD &&
+			    tid != MAX_TID_COUNT) {
+				IWL_DEBUG_HT("try to aggregate\n");
+				rs_tl_turn_on_agg(priv, tid, lq_sta, sta);
 			}
-#endif /*CONFIG_IWL4965_HT_AGG */
+#endif /*CONFIG_IWL4965_HT */
 			lq_sta->action_counter = 0;
 			rs_set_stay_in_table(0, lq_sta);
 		}
@@ -2347,12 +2505,6 @@ static void rs_clear(void *priv_rate)
 	IWL_DEBUG_RATE("enter\n");
 
 	priv->lq_mngr.lq_ready = 0;
-#ifdef CONFIG_IWL4965_HT
-#ifdef CONFIG_IWL4965_HT_AGG
-	if (priv->lq_mngr.agg_ctrl.granted_ba)
-		iwl4965_turn_off_agg(priv, TID_ALL_SPECIFIED);
-#endif /*CONFIG_IWL4965_HT_AGG */
-#endif /* CONFIG_IWL4965_HT */
 
 	IWL_DEBUG_RATE("leave\n");
 }
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965-rs.h b/drivers/net/wireless/iwlwifi/iwl-4965-rs.h
index 31e21e2..11a1e3e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965-rs.h
+++ b/drivers/net/wireless/iwlwifi/iwl-4965-rs.h
@@ -212,6 +212,9 @@ enum {
 
 #define LQ_SIZE		2	/* 2 mode tables:  "Active" and "Search" */
 
+#define IWL_AGG_LOAD_THRESHOLD	10
+
+
 extern const struct iwl4965_rate_info iwl4965_rates[IWL_RATE_COUNT];
 
 enum iwl4965_table_type {
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index a870385..2d132c9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -2946,378 +2946,6 @@ void iwl4965_set_rxon_chain(struct iwl4965_priv *priv)
 	IWL_DEBUG_ASSOC("rx chain %X\n", priv->staging_rxon.rx_chain);
 }
 
-#ifdef CONFIG_IWL4965_HT
-#ifdef CONFIG_IWL4965_HT_AGG
-/*
-	get the traffic load value for tid
-*/
-static u32 iwl4965_tl_get_load(struct iwl4965_priv *priv, u8 tid)
-{
-	u32 load = 0;
-	u32 current_time = jiffies_to_msecs(jiffies);
-	u32 time_diff;
-	s32 index;
-	unsigned long flags;
-	struct iwl4965_traffic_load *tid_ptr = NULL;
-
-	if (tid >= TID_MAX_LOAD_COUNT)
-		return 0;
-
-	tid_ptr = &(priv->lq_mngr.agg_ctrl.traffic_load[tid]);
-
-	current_time -= current_time % TID_ROUND_VALUE;
-
-	spin_lock_irqsave(&priv->lq_mngr.lock, flags);
-	if (!(tid_ptr->queue_count))
-		goto out;
-
-	time_diff = TIME_WRAP_AROUND(tid_ptr->time_stamp, current_time);
-	index = time_diff / TID_QUEUE_CELL_SPACING;
-
-	if (index >= TID_QUEUE_MAX_SIZE) {
-		u32 oldest_time = current_time - TID_MAX_TIME_DIFF;
-
-		while (tid_ptr->queue_count &&
-		       (tid_ptr->time_stamp < oldest_time)) {
-			tid_ptr->total -= tid_ptr->packet_count[tid_ptr->head];
-			tid_ptr->packet_count[tid_ptr->head] = 0;
-			tid_ptr->time_stamp += TID_QUEUE_CELL_SPACING;
-			tid_ptr->queue_count--;
-			tid_ptr->head++;
-			if (tid_ptr->head >= TID_QUEUE_MAX_SIZE)
-				tid_ptr->head = 0;
-		}
-	}
-	load = tid_ptr->total;
-
- out:
-	spin_unlock_irqrestore(&priv->lq_mngr.lock, flags);
-	return load;
-}
-
-/*
-	increment traffic load value for tid and also remove
-	any old values if passed the certian time period
-*/
-static void iwl4965_tl_add_packet(struct iwl4965_priv *priv, u8 tid)
-{
-	u32 current_time = jiffies_to_msecs(jiffies);
-	u32 time_diff;
-	s32 index;
-	unsigned long flags;
-	struct iwl4965_traffic_load *tid_ptr = NULL;
-
-	if (tid >= TID_MAX_LOAD_COUNT)
-		return;
-
-	tid_ptr = &(priv->lq_mngr.agg_ctrl.traffic_load[tid]);
-
-	current_time -= current_time % TID_ROUND_VALUE;
-
-	spin_lock_irqsave(&priv->lq_mngr.lock, flags);
-	if (!(tid_ptr->queue_count)) {
-		tid_ptr->total = 1;
-		tid_ptr->time_stamp = current_time;
-		tid_ptr->queue_count = 1;
-		tid_ptr->head = 0;
-		tid_ptr->packet_count[0] = 1;
-		goto out;
-	}
-
-	time_diff = TIME_WRAP_AROUND(tid_ptr->time_stamp, current_time);
-	index = time_diff / TID_QUEUE_CELL_SPACING;
-
-	if (index >= TID_QUEUE_MAX_SIZE) {
-		u32 oldest_time = current_time - TID_MAX_TIME_DIFF;
-
-		while (tid_ptr->queue_count &&
-		       (tid_ptr->time_stamp < oldest_time)) {
-			tid_ptr->total -= tid_ptr->packet_count[tid_ptr->head];
-			tid_ptr->packet_count[tid_ptr->head] = 0;
-			tid_ptr->time_stamp += TID_QUEUE_CELL_SPACING;
-			tid_ptr->queue_count--;
-			tid_ptr->head++;
-			if (tid_ptr->head >= TID_QUEUE_MAX_SIZE)
-				tid_ptr->head = 0;
-		}
-	}
-
-	index = (tid_ptr->head + index) % TID_QUEUE_MAX_SIZE;
-	tid_ptr->packet_count[index] = tid_ptr->packet_count[index] + 1;
-	tid_ptr->total = tid_ptr->total + 1;
-
-	if ((index + 1) > tid_ptr->queue_count)
-		tid_ptr->queue_count = index + 1;
- out:
-	spin_unlock_irqrestore(&priv->lq_mngr.lock, flags);
-
-}
-
-#define MMAC_SCHED_MAX_NUMBER_OF_HT_BACK_FLOWS   7
-enum HT_STATUS {
-	BA_STATUS_FAILURE = 0,
-	BA_STATUS_INITIATOR_DELBA,
-	BA_STATUS_RECIPIENT_DELBA,
-	BA_STATUS_RENEW_ADDBA_REQUEST,
-	BA_STATUS_ACTIVE,
-};
-
-/**
- * iwl4964_tl_ba_avail - Find out if an unused aggregation queue is available
- */
-static u8 iwl4964_tl_ba_avail(struct iwl4965_priv *priv)
-{
-	int i;
-	struct iwl4965_lq_mngr *lq;
-	u8 count = 0;
-	u16 msk;
-
-	lq = (struct iwl4965_lq_mngr *)&(priv->lq_mngr);
-
-	/* Find out how many agg queues are in use */
-	for (i = 0; i < TID_MAX_LOAD_COUNT ; i++) {
-		msk = 1 << i;
-		if ((lq->agg_ctrl.granted_ba & msk) ||
-		    (lq->agg_ctrl.wait_for_agg_status & msk))
-			count++;
-	}
-
-	if (count < MMAC_SCHED_MAX_NUMBER_OF_HT_BACK_FLOWS)
-		return 1;
-
-	return 0;
-}
-
-static void iwl4965_ba_status(struct iwl4965_priv *priv,
-			      u8 tid, enum HT_STATUS status);
-
-static int iwl4965_perform_addba(struct iwl4965_priv *priv, u8 tid, u32 length,
-				 u32 ba_timeout)
-{
-	int rc;
-
-	rc = ieee80211_start_BA_session(priv->hw, priv->bssid, tid);
-	if (rc)
-		iwl4965_ba_status(priv, tid, BA_STATUS_FAILURE);
-
-	return rc;
-}
-
-static int iwl4965_perform_delba(struct iwl4965_priv *priv, u8 tid)
-{
-	int rc;
-
-	rc = ieee80211_stop_BA_session(priv->hw, priv->bssid, tid);
-	if (rc)
-		iwl4965_ba_status(priv, tid, BA_STATUS_FAILURE);
-
-	return rc;
-}
-
-static void iwl4965_turn_on_agg_for_tid(struct iwl4965_priv *priv,
-					struct iwl4965_lq_mngr *lq,
-					u8 auto_agg, u8 tid)
-{
-	u32 tid_msk = (1 << tid);
-	unsigned long flags;
-
-	spin_lock_irqsave(&priv->lq_mngr.lock, flags);
-/*
-	if ((auto_agg) && (!lq->enable_counter)){
-		lq->agg_ctrl.next_retry = 0;
-		lq->agg_ctrl.tid_retry = 0;
-		spin_unlock_irqrestore(&priv->lq_mngr.lock, flags);
-		return;
-	}
-*/
-	if (!(lq->agg_ctrl.granted_ba & tid_msk) &&
-	    (lq->agg_ctrl.requested_ba & tid_msk)) {
-		u8 available_queues;
-		u32 load;
-
-		spin_unlock_irqrestore(&priv->lq_mngr.lock, flags);
-		available_queues = iwl4964_tl_ba_avail(priv);
-		load = iwl4965_tl_get_load(priv, tid);
-
-		spin_lock_irqsave(&priv->lq_mngr.lock, flags);
-		if (!available_queues) {
-			if (auto_agg)
-				lq->agg_ctrl.tid_retry |= tid_msk;
-			else {
-				lq->agg_ctrl.requested_ba &= ~tid_msk;
-				lq->agg_ctrl.wait_for_agg_status &= ~tid_msk;
-			}
-		} else if ((auto_agg) &&
-			   ((load <= lq->agg_ctrl.tid_traffic_load_threshold) ||
-			    ((lq->agg_ctrl.wait_for_agg_status & tid_msk))))
-			lq->agg_ctrl.tid_retry |= tid_msk;
-		else {
-			lq->agg_ctrl.wait_for_agg_status |= tid_msk;
-			spin_unlock_irqrestore(&priv->lq_mngr.lock, flags);
-			iwl4965_perform_addba(priv, tid, 0x40,
-					      lq->agg_ctrl.ba_timeout);
-			spin_lock_irqsave(&priv->lq_mngr.lock, flags);
-		}
-	}
-	spin_unlock_irqrestore(&priv->lq_mngr.lock, flags);
-}
-
-static void iwl4965_turn_on_agg(struct iwl4965_priv *priv, u8 tid)
-{
-	struct iwl4965_lq_mngr *lq;
-	unsigned long flags;
-
-	lq = (struct iwl4965_lq_mngr *)&(priv->lq_mngr);
-
-	if ((tid < TID_MAX_LOAD_COUNT))
-		iwl4965_turn_on_agg_for_tid(priv, lq, lq->agg_ctrl.auto_agg,
-					    tid);
-	else if (tid == TID_ALL_SPECIFIED) {
-		if (lq->agg_ctrl.requested_ba) {
-			for (tid = 0; tid < TID_MAX_LOAD_COUNT; tid++)
-				iwl4965_turn_on_agg_for_tid(priv, lq,
-					lq->agg_ctrl.auto_agg, tid);
-		} else {
-			spin_lock_irqsave(&priv->lq_mngr.lock, flags);
-			lq->agg_ctrl.tid_retry = 0;
-			lq->agg_ctrl.next_retry = 0;
-			spin_unlock_irqrestore(&priv->lq_mngr.lock, flags);
-		}
-	}
-
-}
-
-void iwl4965_turn_off_agg(struct iwl4965_priv *priv, u8 tid)
-{
-	u32 tid_msk;
-	struct iwl4965_lq_mngr *lq;
-	unsigned long flags;
-
-	lq = (struct iwl4965_lq_mngr *)&(priv->lq_mngr);
-
-	if ((tid < TID_MAX_LOAD_COUNT)) {
-		tid_msk = 1 << tid;
-		spin_lock_irqsave(&priv->lq_mngr.lock, flags);
-		lq->agg_ctrl.wait_for_agg_status |= tid_msk;
-		lq->agg_ctrl.requested_ba &= ~tid_msk;
-		spin_unlock_irqrestore(&priv->lq_mngr.lock, flags);
-		iwl4965_perform_delba(priv, tid);
-	} else if (tid == TID_ALL_SPECIFIED) {
-		spin_lock_irqsave(&priv->lq_mngr.lock, flags);
-		for (tid = 0; tid < TID_MAX_LOAD_COUNT; tid++) {
-			tid_msk = 1 << tid;
-			lq->agg_ctrl.wait_for_agg_status |= tid_msk;
-			spin_unlock_irqrestore(&priv->lq_mngr.lock, flags);
-			iwl4965_perform_delba(priv, tid);
-			spin_lock_irqsave(&priv->lq_mngr.lock, flags);
-		}
-		lq->agg_ctrl.requested_ba = 0;
-		spin_unlock_irqrestore(&priv->lq_mngr.lock, flags);
-	}
-}
-
-/**
- * iwl4965_ba_status - Update driver's link quality mgr with tid's HT status
- */
-static void iwl4965_ba_status(struct iwl4965_priv *priv,
-				u8 tid, enum HT_STATUS status)
-{
-	struct iwl4965_lq_mngr *lq;
-	u32 tid_msk = (1 << tid);
-	unsigned long flags;
-
-	lq = (struct iwl4965_lq_mngr *)&(priv->lq_mngr);
-
-	if ((tid >= TID_MAX_LOAD_COUNT))
-		goto out;
-
-	spin_lock_irqsave(&priv->lq_mngr.lock, flags);
-	switch (status) {
-	case BA_STATUS_ACTIVE:
-		if (!(lq->agg_ctrl.granted_ba & tid_msk))
-			lq->agg_ctrl.granted_ba |= tid_msk;
-		break;
-	default:
-		if ((lq->agg_ctrl.granted_ba & tid_msk))
-			lq->agg_ctrl.granted_ba &= ~tid_msk;
-		break;
-	}
-
-	lq->agg_ctrl.wait_for_agg_status &= ~tid_msk;
-	if (status != BA_STATUS_ACTIVE) {
-		if (lq->agg_ctrl.auto_agg) {
-			lq->agg_ctrl.tid_retry |= tid_msk;
-			lq->agg_ctrl.next_retry =
-			    jiffies + msecs_to_jiffies(500);
-		} else
-			lq->agg_ctrl.requested_ba &= ~tid_msk;
-	}
-	spin_unlock_irqrestore(&priv->lq_mngr.lock, flags);
- out:
-	return;
-}
-
-static void iwl4965_bg_agg_work(struct work_struct *work)
-{
-	struct iwl4965_priv *priv = container_of(work, struct iwl4965_priv,
-					agg_work);
-
-	u32 tid;
-	u32 retry_tid;
-	u32 tid_msk;
-	unsigned long flags;
-	struct iwl4965_lq_mngr *lq = (struct iwl4965_lq_mngr *)&(priv->lq_mngr);
-
-	spin_lock_irqsave(&priv->lq_mngr.lock, flags);
-	retry_tid = lq->agg_ctrl.tid_retry;
-	lq->agg_ctrl.tid_retry = 0;
-	spin_unlock_irqrestore(&priv->lq_mngr.lock, flags);
-
-	if (retry_tid == TID_ALL_SPECIFIED)
-		iwl4965_turn_on_agg(priv, TID_ALL_SPECIFIED);
-	else {
-		for (tid = 0; tid < TID_MAX_LOAD_COUNT; tid++) {
-			tid_msk = (1 << tid);
-			if (retry_tid & tid_msk)
-				iwl4965_turn_on_agg(priv, tid);
-		}
-	}
-
-	spin_lock_irqsave(&priv->lq_mngr.lock, flags);
-	if (lq->agg_ctrl.tid_retry)
-		lq->agg_ctrl.next_retry = jiffies + msecs_to_jiffies(500);
-	spin_unlock_irqrestore(&priv->lq_mngr.lock, flags);
-	return;
-}
-
-/* TODO: move this functionality to rate scaling */
-void iwl4965_tl_get_stats(struct iwl4965_priv *priv,
-		   struct ieee80211_hdr *hdr)
-{
-	__le16 *qc = ieee80211_get_qos_ctrl(hdr);
-
-	if (qc &&
-	    (priv->iw_mode != IEEE80211_IF_TYPE_IBSS)) {
-		u8 tid = 0;
-		tid = (u8) (le16_to_cpu(*qc) & 0xF);
-		if (tid < TID_MAX_LOAD_COUNT)
-			iwl4965_tl_add_packet(priv, tid);
-	}
-
-	if (priv->lq_mngr.agg_ctrl.next_retry &&
-	    (time_after(priv->lq_mngr.agg_ctrl.next_retry, jiffies))) {
-		unsigned long flags;
-
-		spin_lock_irqsave(&priv->lq_mngr.lock, flags);
-		priv->lq_mngr.agg_ctrl.next_retry = 0;
-		spin_unlock_irqrestore(&priv->lq_mngr.lock, flags);
-		schedule_work(&priv->agg_work);
-	}
-}
-
-#endif /*CONFIG_IWL4965_HT_AGG */
-#endif /* CONFIG_IWL4965_HT */
-
 /**
  * sign_extend - Sign extend a value using specified bit as sign-bit
  *
@@ -4193,25 +3821,6 @@ static void iwl4965_rx_missed_beacon_notif(struct iwl4965_priv *priv,
 }
 
 #ifdef CONFIG_IWL4965_HT
-#ifdef CONFIG_IWL4965_HT_AGG
-
-/**
- * iwl4965_set_tx_status - Update driver's record of one Tx frame's status
- *
- * This will get sent to mac80211.
- */
-static void iwl4965_set_tx_status(struct iwl4965_priv *priv, int txq_id, int idx,
-				  u32 status, u32 retry_count, u32 rate)
-{
-	struct ieee80211_tx_status *tx_status =
-		&(priv->txq[txq_id].txb[idx].status);
-
-	tx_status->flags = status ? IEEE80211_TX_STATUS_ACK : 0;
-	tx_status->retry_count += retry_count;
-	tx_status->control.tx_rate = rate;
-}
-
-#endif/* CONFIG_IWL4965_HT_AGG */
 
 /**
  * iwl4965_sta_modify_enable_tid_tx - Enable Tx for this TID in station table
@@ -4973,11 +4582,6 @@ void iwl4965_hw_setup_deferred_work(struct iwl4965_priv *priv)
 #ifdef CONFIG_IWL4965_SENSITIVITY
 	INIT_WORK(&priv->sensitivity_work, iwl4965_bg_sensitivity_work);
 #endif
-#ifdef CONFIG_IWL4965_HT
-#ifdef CONFIG_IWL4965_HT_AGG
-	INIT_WORK(&priv->agg_work, iwl4965_bg_agg_work);
-#endif /* CONFIG_IWL4965_HT_AGG */
-#endif /* CONFIG_IWL4965_HT */
 	init_timer(&priv->statistics_periodic);
 	priv->statistics_periodic.data = (unsigned long)priv;
 	priv->statistics_periodic.function = iwl4965_bg_statistics_periodic;
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.h b/drivers/net/wireless/iwlwifi/iwl-4965.h
index 377f42b..4edf613 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.h
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.h
@@ -783,11 +783,6 @@ extern int iwl4965_mac_ampdu_action(struct ieee80211_hw *hw,
 				    u8 *addr, u16 tid, u16 *ssn);
 extern int iwl4965_check_empty_hw_queue(struct iwl4965_priv *priv, int sta_id,
 					u8 tid, int txq_id);
-#ifdef CONFIG_IWL4965_HT_AGG
-extern void iwl4965_turn_off_agg(struct iwl4965_priv *priv, u8 tid);
-extern void iwl4965_tl_get_stats(struct iwl4965_priv *priv,
-				struct ieee80211_hdr *hdr);
-#endif /* CONFIG_IWL4965_HT_AGG */
 #endif /*CONFIG_IWL4965_HT */
 /* Structures, enum, and defines specific to the 4965 */
 
@@ -835,37 +830,7 @@ struct iwl4965_kw {
 
 #define TX_POWER_IWL_ILLEGAL_VOLTAGE -10000
 
-struct iwl4965_traffic_load {
-	unsigned long time_stamp;
-	u32 packet_count[TID_QUEUE_MAX_SIZE];
-	u8 queue_count;
-	u8 head;
-	u32 total;
-};
-
-#ifdef CONFIG_IWL4965_HT_AGG
-/**
- * struct iwl4965_agg_control
- * @requested_ba: bit map of tids requesting aggregation/block-ack
- * @granted_ba: bit map of tids granted aggregation/block-ack
- */
-struct iwl4965_agg_control {
-	unsigned long next_retry;
-	u32 wait_for_agg_status;
-	u32 tid_retry;
-	u32 requested_ba;
-	u32 granted_ba;
-	u8 auto_agg;
-	u32 tid_traffic_load_threshold;
-	u32 ba_timeout;
-	struct iwl4965_traffic_load traffic_load[TID_MAX_LOAD_COUNT];
-};
-#endif /*CONFIG_IWL4965_HT_AGG */
-
 struct iwl4965_lq_mngr {
-#ifdef CONFIG_IWL4965_HT_AGG
-	struct iwl4965_agg_control agg_ctrl;
-#endif
 	spinlock_t lock;
 	s32 max_window_size;
 	s32 *expected_tpt;
@@ -878,7 +843,6 @@ struct iwl4965_lq_mngr {
 	u8 lq_ready;
 };
 
-
 /* Sensitivity and chain noise calibration */
 #define INTERFERENCE_DATA_AVAILABLE	__constant_cpu_to_le32(1)
 #define INITIALIZATION_VALUE		0xFFFF
@@ -1266,11 +1230,7 @@ struct iwl4965_priv {
 #endif
 	struct work_struct statistics_work;
 	struct timer_list statistics_periodic;
-
-#ifdef CONFIG_IWL4965_HT_AGG
-	struct work_struct agg_work;
-#endif
-};				/*iwl4965_priv */
+}; /*iwl4965_priv */
 
 static inline int iwl4965_is_associated(struct iwl4965_priv *priv)
 {
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index cf101d4..254ed67 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -3062,14 +3062,6 @@ static int iwl4965_tx_skb(struct iwl4965_priv *priv,
 	out_cmd->cmd.tx.dram_lsb_ptr = cpu_to_le32(scratch_phys);
 	out_cmd->cmd.tx.dram_msb_ptr = iwl_get_dma_hi_address(scratch_phys);
 
-#ifdef CONFIG_IWL4965_HT_AGG
-#ifdef CONFIG_IWL4965_HT
-	/* TODO: move this functionality to rate scaling */
-	iwl4965_tl_get_stats(priv, hdr);
-#endif /* CONFIG_IWL4965_HT_AGG */
-#endif /*CONFIG_IWL4965_HT */
-
-
 	if (!ieee80211_get_morefrag(hdr)) {
 		txq->need_update = 1;
 		if (qc) {
@@ -8054,18 +8046,6 @@ static void iwl4965_mac_reset_tsf(struct ieee80211_hw *hw)
 	spin_lock_irqsave(&priv->lock, flags);
 	memset(&priv->current_ht_config, 0, sizeof(struct iwl_ht_info));
 	spin_unlock_irqrestore(&priv->lock, flags);
-#ifdef CONFIG_IWL4965_HT_AGG
-/*	if (priv->lq_mngr.agg_ctrl.granted_ba)
-		iwl4965_turn_off_agg(priv, TID_ALL_SPECIFIED);*/
-
-	memset(&(priv->lq_mngr.agg_ctrl), 0, sizeof(struct iwl4965_agg_control));
-	priv->lq_mngr.agg_ctrl.tid_traffic_load_threshold = 10;
-	priv->lq_mngr.agg_ctrl.ba_timeout = 5000;
-	priv->lq_mngr.agg_ctrl.auto_agg = 1;
-
-	if (priv->lq_mngr.agg_ctrl.auto_agg)
-		priv->lq_mngr.agg_ctrl.requested_ba = TID_ALL_ENABLED;
-#endif /*CONFIG_IWL4965_HT_AGG */
 #endif /* CONFIG_IWL4965_HT */
 
 #ifdef CONFIG_IWL4965_QOS
-- 
1.5.3.3

