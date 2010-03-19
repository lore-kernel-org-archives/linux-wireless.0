Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:55370 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752806Ab0CSVOQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Mar 2010 17:14:16 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 3/9] iwlwifi: implement new mac80211 station add/remove calls
Date: Fri, 19 Mar 2010 14:14:05 -0700
Message-Id: <1269033251-17545-4-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1269033251-17545-1-git-send-email-reinette.chatre@intel.com>
References: <1269033251-17545-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Reinette Chatre <reinette.chatre@intel.com>

mac80211 recently implemented two new callbacks that are used to request
station add/remove from the driver. The benefot from these new callbacks
are that they enable the driver to sleep while performing this work.

This is a big patch since a few things need to be coordinated in this move.
First we need to decouple station management from rate scaling, which
caused a lot of code to be moved and/or deleted. Next we needed to tie in
with mac80211's station management callback and let it direct our station
management as well as trigger the rate scaling initialization.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945-rs.c  |   83 +++--
 drivers/net/wireless/iwlwifi/iwl-3945.c     |   10 -
 drivers/net/wireless/iwlwifi/iwl-3945.h     |    1 -
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c   |  120 +++---
 drivers/net/wireless/iwlwifi/iwl-agn-rs.h   |    7 +-
 drivers/net/wireless/iwlwifi/iwl-agn.c      |   95 +++--
 drivers/net/wireless/iwlwifi/iwl-core.c     |    1 -
 drivers/net/wireless/iwlwifi/iwl-core.h     |    2 +-
 drivers/net/wireless/iwlwifi/iwl-dev.h      |    8 +-
 drivers/net/wireless/iwlwifi/iwl-sta.c      |  528 +++++++++++++++------------
 drivers/net/wireless/iwlwifi/iwl-sta.h      |   11 +-
 drivers/net/wireless/iwlwifi/iwl3945-base.c |   45 ++-
 12 files changed, 522 insertions(+), 389 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945-rs.c b/drivers/net/wireless/iwlwifi/iwl-3945-rs.c
index b588cb6..605aca4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945-rs.c
@@ -329,16 +329,25 @@ static void iwl3945_collect_tx_data(struct iwl3945_rs_sta *rs_sta,
 
 }
 
-static void rs_rate_init(void *priv_r, struct ieee80211_supported_band *sband,
-			 struct ieee80211_sta *sta, void *priv_sta)
+/*
+ * Called after adding a new station to initialize rate scaling
+ */
+void iwl3945_rs_rate_init(struct iwl_priv *priv, struct ieee80211_sta *sta, u8 sta_id)
 {
-	struct iwl3945_rs_sta *rs_sta = priv_sta;
-	struct iwl_priv *priv = (struct iwl_priv *)priv_r;
+	struct ieee80211_hw *hw = priv->hw;
+	struct ieee80211_conf *conf = &priv->hw->conf;
+	struct iwl3945_sta_priv *psta;
+	struct iwl3945_rs_sta *rs_sta;
+	struct ieee80211_supported_band *sband;
 	int i;
 
-	IWL_DEBUG_RATE(priv, "enter\n");
+	IWL_DEBUG_INFO(priv, "enter \n");
+	if (sta_id == priv->hw_params.bcast_sta_id)
+		goto out;
 
-	spin_lock_init(&rs_sta->lock);
+	psta = (struct iwl3945_sta_priv *) sta->drv_priv;
+	rs_sta = &psta->rs_sta;
+	sband = hw->wiphy->bands[conf->channel->band];
 
 	rs_sta->priv = priv;
 
@@ -351,9 +360,7 @@ static void rs_rate_init(void *priv_r, struct ieee80211_supported_band *sband,
 	rs_sta->last_flush = jiffies;
 	rs_sta->flush_time = IWL_RATE_FLUSH;
 	rs_sta->last_tx_packets = 0;
-	rs_sta->ibss_sta_added = 0;
 
-	init_timer(&rs_sta->rate_scale_flush);
 	rs_sta->rate_scale_flush.data = (unsigned long)rs_sta;
 	rs_sta->rate_scale_flush.function = iwl3945_bg_rate_scale_flush;
 
@@ -380,8 +387,10 @@ static void rs_rate_init(void *priv_r, struct ieee80211_supported_band *sband,
 						IWL_FIRST_OFDM_RATE;
 	}
 
+out:
+	priv->stations[sta_id].used &= ~IWL_STA_UCODE_INPROGRESS;
 
-	IWL_DEBUG_RATE(priv, "leave\n");
+	IWL_DEBUG_INFO(priv, "leave\n");
 }
 
 static void *rs_alloc(struct ieee80211_hw *hw, struct dentry *debugfsdir)
@@ -405,6 +414,9 @@ static void *rs_alloc_sta(void *iwl_priv, struct ieee80211_sta *sta, gfp_t gfp)
 
 	rs_sta = &psta->rs_sta;
 
+	spin_lock_init(&rs_sta->lock);
+	init_timer(&rs_sta->rate_scale_flush);
+
 	IWL_DEBUG_RATE(priv, "leave\n");
 
 	return rs_sta;
@@ -413,13 +425,14 @@ static void *rs_alloc_sta(void *iwl_priv, struct ieee80211_sta *sta, gfp_t gfp)
 static void rs_free_sta(void *iwl_priv, struct ieee80211_sta *sta,
 			void *priv_sta)
 {
-	struct iwl3945_sta_priv *psta = (void *) sta->drv_priv;
-	struct iwl3945_rs_sta *rs_sta = &psta->rs_sta;
-	struct iwl_priv *priv __maybe_unused = rs_sta->priv;
+	struct iwl3945_rs_sta *rs_sta = priv_sta;
 
-	IWL_DEBUG_RATE(priv, "enter\n");
+	/*
+	 * Be careful not to use any members of iwl3945_rs_sta (like trying
+	 * to use iwl_priv to print out debugging) since it may not be fully
+	 * initialized at this point.
+	 */
 	del_timer_sync(&rs_sta->rate_scale_flush);
-	IWL_DEBUG_RATE(priv, "leave\n");
 }
 
 
@@ -458,6 +471,13 @@ static void rs_tx_status(void *priv_rate, struct ieee80211_supported_band *sband
 		return;
 	}
 
+	/* Treat uninitialized rate scaling data same as non-existing. */
+	if (!rs_sta->priv) {
+		IWL_DEBUG_RATE(priv, "leave: STA priv data uninitialized!\n");
+		return;
+	}
+
+
 	rs_sta->tx_packets++;
 
 	scale_rate_index = first_index;
@@ -625,7 +645,6 @@ static void rs_get_rate(void *priv_r, struct ieee80211_sta *sta,
 	u32 fail_count;
 	s8 scale_action = 0;
 	unsigned long flags;
-	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
 	u16 rate_mask = sta ? sta->supp_rates[sband->band] : 0;
 	s8 max_rate_idx = -1;
 	struct iwl_priv *priv = (struct iwl_priv *)priv_r;
@@ -633,6 +652,12 @@ static void rs_get_rate(void *priv_r, struct ieee80211_sta *sta,
 
 	IWL_DEBUG_RATE(priv, "enter\n");
 
+	/* Treat uninitialized rate scaling data same as non-existing. */
+	if (rs_sta && !rs_sta->priv) {
+		IWL_DEBUG_RATE(priv, "Rate scaling information not initialized yet.\n");
+		priv_sta = NULL;
+	}
+
 	if (rate_control_send_low(sta, priv_sta, txrc))
 		return;
 
@@ -650,20 +675,6 @@ static void rs_get_rate(void *priv_r, struct ieee80211_sta *sta,
 	if (sband->band == IEEE80211_BAND_5GHZ)
 		rate_mask = rate_mask << IWL_FIRST_OFDM_RATE;
 
-	if ((priv->iw_mode == NL80211_IFTYPE_ADHOC) &&
-	    !rs_sta->ibss_sta_added) {
-		u8 sta_id = iwl_find_station(priv, hdr->addr1);
-
-		if (sta_id == IWL_INVALID_STATION) {
-			IWL_DEBUG_RATE(priv, "LQ: ADD station %pM\n",
-				       hdr->addr1);
-			sta_id = iwl_add_station(priv, hdr->addr1, false,
-				CMD_ASYNC, NULL);
-		}
-		if (sta_id != IWL_INVALID_STATION)
-			rs_sta->ibss_sta_added = 1;
-	}
-
 	spin_lock_irqsave(&rs_sta->lock, flags);
 
 	/* for recent assoc, choose best rate regarding
@@ -883,12 +894,22 @@ static void iwl3945_remove_debugfs(void *priv, void *priv_sta)
 }
 #endif
 
+/*
+ * Initialization of rate scaling information is done by driver after
+ * the station is added. Since mac80211 calls this function before a
+ * station is added we ignore it.
+ */
+static void rs_rate_init_stub(void *priv_r, struct ieee80211_supported_band *sband,
+			      struct ieee80211_sta *sta, void *priv_sta)
+{
+}
+
 static struct rate_control_ops rs_ops = {
 	.module = NULL,
 	.name = RS_NAME,
 	.tx_status = rs_tx_status,
 	.get_rate = rs_get_rate,
-	.rate_init = rs_rate_init,
+	.rate_init = rs_rate_init_stub,
 	.alloc = rs_alloc,
 	.free = rs_free,
 	.alloc_sta = rs_alloc_sta,
@@ -899,7 +920,6 @@ static struct rate_control_ops rs_ops = {
 #endif
 
 };
-
 void iwl3945_rate_scale_init(struct ieee80211_hw *hw, s32 sta_id)
 {
 	struct iwl_priv *priv = hw->priv;
@@ -916,6 +936,7 @@ void iwl3945_rate_scale_init(struct ieee80211_hw *hw, s32 sta_id)
 	sta = ieee80211_find_sta(priv->vif,
 				 priv->stations[sta_id].sta.sta.addr);
 	if (!sta) {
+		IWL_DEBUG_RATE(priv, "Unable to find station to initialize rate scaling.\n");
 		rcu_read_unlock();
 		return;
 	}
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index 7f95f90..11785e2 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -1956,16 +1956,6 @@ static int iwl3945_commit_rxon(struct iwl_priv *priv)
 		return rc;
 	}
 
-	/* If we have set the ASSOC_MSK and we are in BSS mode then
-	 * add the IWL_AP_ID to the station rate table */
-	if (iwl_is_associated(priv) &&
-	    (priv->iw_mode == NL80211_IFTYPE_STATION))
-		if (iwl_add_station(priv, priv->active_rxon.bssid_addr,
-				true, CMD_SYNC, NULL) == IWL_INVALID_STATION) {
-			IWL_ERR(priv, "Error adding AP address for transmit\n");
-			return -EIO;
-		}
-
 	/* Init the hardware's rate fallback order based on the band */
 	rc = iwl3945_init_hw_rate_table(priv);
 	if (rc) {
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.h b/drivers/net/wireless/iwlwifi/iwl-3945.h
index 452dfd5..b892195 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.h
@@ -95,7 +95,6 @@ struct iwl3945_rs_sta {
 	u8 tgg;
 	u8 flush_pending;
 	u8 start_rate;
-	u8 ibss_sta_added;
 	struct timer_list rate_scale_flush;
 	struct iwl3945_rate_scale_data win[IWL_RATE_COUNT_3945];
 #ifdef CONFIG_MAC80211_DEBUGFS
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
index 84271cc..970eec8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
@@ -769,6 +769,15 @@ static void rs_tx_status(void *priv_r, struct ieee80211_supported_band *sband,
 
 	IWL_DEBUG_RATE_LIMIT(priv, "get frame ack response, update rate scale window\n");
 
+	/* Treat uninitialized rate scaling data same as non-existing. */
+	if (!lq_sta) {
+		IWL_DEBUG_RATE(priv, "Station rate scaling not created yet.\n");
+		return;
+	} else if (!lq_sta->drv) {
+		IWL_DEBUG_RATE(priv, "Rate scaling not initialized yet.\n");
+		return;
+	}
+
 	if (!ieee80211_is_data(hdr->frame_control) ||
 	    info->flags & IEEE80211_TX_CTL_NO_ACK)
 		return;
@@ -778,10 +787,6 @@ static void rs_tx_status(void *priv_r, struct ieee80211_supported_band *sband,
 	    !(info->flags & IEEE80211_TX_STAT_AMPDU))
 		return;
 
-	if ((priv->iw_mode == NL80211_IFTYPE_ADHOC) &&
-	    !lq_sta->ibss_sta_added)
-		return;
-
 	/*
 	 * Ignore this Tx frame response if its initial rate doesn't match
 	 * that of latest Link Quality command.  There may be stragglers
@@ -827,7 +832,7 @@ static void rs_tx_status(void *priv_r, struct ieee80211_supported_band *sband,
 		lq_sta->missed_rate_counter++;
 		if (lq_sta->missed_rate_counter > IWL_MISSED_RATE_MAX) {
 			lq_sta->missed_rate_counter = 0;
-			iwl_send_lq_cmd(priv, &lq_sta->lq, CMD_ASYNC);
+			iwl_send_lq_cmd(priv, &lq_sta->lq, CMD_ASYNC, false);
 		}
 		/* Regardless, ignore this status info for outdated rate */
 		return;
@@ -1915,7 +1920,7 @@ static u32 rs_update_rate_tbl(struct iwl_priv *priv,
 	/* Update uCode's rate table. */
 	rate = rate_n_flags_from_tbl(priv, tbl, index, is_green);
 	rs_fill_link_cmd(priv, lq_sta, rate);
-	iwl_send_lq_cmd(priv, &lq_sta->lq, CMD_ASYNC);
+	iwl_send_lq_cmd(priv, &lq_sta->lq, CMD_ASYNC, false);
 
 	return rate;
 }
@@ -2291,7 +2296,7 @@ lq_update:
 			IWL_DEBUG_RATE(priv, "Switch current  mcs: %X index: %d\n",
 				     tbl->current_rate, index);
 			rs_fill_link_cmd(priv, lq_sta, tbl->current_rate);
-			iwl_send_lq_cmd(priv, &lq_sta->lq, CMD_ASYNC);
+			iwl_send_lq_cmd(priv, &lq_sta->lq, CMD_ASYNC, false);
 		} else
 			done_search = 1;
 	}
@@ -2340,7 +2345,20 @@ out:
 	return;
 }
 
-
+/**
+ * rs_initialize_lq - Initialize a station's hardware rate table
+ *
+ * The uCode's station table contains a table of fallback rates
+ * for automatic fallback during transmission.
+ *
+ * NOTE: This sets up a default set of values.  These will be replaced later
+ *       if the driver's iwl-agn-rs rate scaling algorithm is used, instead of
+ *       rc80211_simple.
+ *
+ * NOTE: Run REPLY_ADD_STA command to set up station table entry, before
+ *       calling this function (which runs REPLY_TX_LINK_QUALITY_CMD,
+ *       which requires station table entry to exist).
+ */
 static void rs_initialize_lq(struct iwl_priv *priv,
 			     struct ieee80211_conf *conf,
 			     struct ieee80211_sta *sta,
@@ -2390,7 +2408,8 @@ static void rs_initialize_lq(struct iwl_priv *priv,
 	tbl->current_rate = rate;
 	rs_set_expected_tpt_table(lq_sta, tbl);
 	rs_fill_link_cmd(NULL, lq_sta, rate);
-	iwl_send_lq_cmd(priv, &lq_sta->lq, CMD_ASYNC);
+	priv->stations[lq_sta->lq.sta_id].lq = &lq_sta->lq;
+	iwl_send_lq_cmd(priv, &lq_sta->lq, CMD_SYNC, true);
  out:
 	return;
 }
@@ -2402,9 +2421,6 @@ static void rs_get_rate(void *priv_r, struct ieee80211_sta *sta, void *priv_sta,
 	struct sk_buff *skb = txrc->skb;
 	struct ieee80211_supported_band *sband = txrc->sband;
 	struct iwl_priv *priv = (struct iwl_priv *)priv_r;
-	struct ieee80211_conf *conf = &priv->hw->conf;
-	struct ieee80211_sta_ht_cap *ht_cap = &sta->ht_cap;
-	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	struct iwl_lq_sta *lq_sta = priv_sta;
 	int rate_idx;
@@ -2422,30 +2438,18 @@ static void rs_get_rate(void *priv_r, struct ieee80211_sta *sta, void *priv_sta,
 			lq_sta->max_rate_idx = -1;
 	}
 
+	/* Treat uninitialized rate scaling data same as non-existing. */
+	if (lq_sta && !lq_sta->drv) {
+		IWL_DEBUG_RATE(priv, "Rate scaling not initialized yet.\n");
+		priv_sta = NULL;
+	}
+
 	/* Send management frames and NO_ACK data using lowest rate. */
 	if (rate_control_send_low(sta, priv_sta, txrc))
 		return;
 
 	rate_idx  = lq_sta->last_txrate_idx;
 
-	if ((priv->iw_mode == NL80211_IFTYPE_ADHOC) &&
-	    !lq_sta->ibss_sta_added) {
-		u8 sta_id = iwl_find_station(priv, hdr->addr1);
-
-		if (sta_id == IWL_INVALID_STATION) {
-			IWL_DEBUG_RATE(priv, "LQ: ADD station %pM\n",
-				       hdr->addr1);
-			sta_id = iwl_add_station(priv, hdr->addr1,
-						false, CMD_ASYNC, ht_cap);
-		}
-		if ((sta_id != IWL_INVALID_STATION)) {
-			lq_sta->lq.sta_id = sta_id;
-			lq_sta->lq.rs_table[0].rate_n_flags = 0;
-			lq_sta->ibss_sta_added = 1;
-			rs_initialize_lq(priv, conf, sta, lq_sta);
-		}
-	}
-
 	if (lq_sta->last_rate_n_flags & RATE_MCS_HT_MSK) {
 		rate_idx -= IWL_FIRST_OFDM_RATE;
 		/* 6M and 9M shared same MCS index */
@@ -2495,16 +2499,25 @@ static void *rs_alloc_sta(void *priv_rate, struct ieee80211_sta *sta,
 	return lq_sta;
 }
 
-static void rs_rate_init(void *priv_r, struct ieee80211_supported_band *sband,
-			 struct ieee80211_sta *sta, void *priv_sta)
+/*
+ * Called after adding a new station to initialize rate scaling
+ */
+void iwl_rs_rate_init(struct iwl_priv *priv, struct ieee80211_sta *sta, u8 sta_id)
 {
 	int i, j;
-	struct iwl_priv *priv = (struct iwl_priv *)priv_r;
+	struct ieee80211_hw *hw = priv->hw;
 	struct ieee80211_conf *conf = &priv->hw->conf;
 	struct ieee80211_sta_ht_cap *ht_cap = &sta->ht_cap;
-	struct iwl_lq_sta *lq_sta = priv_sta;
+	struct iwl_station_priv *sta_priv;
+	struct iwl_lq_sta *lq_sta;
+	struct ieee80211_supported_band *sband;
+
+	sta_priv = (struct iwl_station_priv *) sta->drv_priv;
+	lq_sta = &sta_priv->lq_sta;
+	sband = hw->wiphy->bands[conf->channel->band];
 
-	lq_sta->lq.sta_id = 0xff;
+
+	lq_sta->lq.sta_id = sta_id;
 
 	for (j = 0; j < LQ_SIZE; j++)
 		for (i = 0; i < IWL_RATE_COUNT; i++)
@@ -2516,33 +2529,13 @@ static void rs_rate_init(void *priv_r, struct ieee80211_supported_band *sband,
 		for (i = 0; i < IWL_RATE_COUNT; i++)
 			rs_rate_scale_clear_window(&lq_sta->lq_info[j].win[i]);
 
-	IWL_DEBUG_RATE(priv, "LQ: *** rate scale station global init ***\n");
+	IWL_DEBUG_RATE(priv, "LQ: *** rate scale station global init for station %d ***\n",
+		       sta_id);
 	/* TODO: what is a good starting rate for STA? About middle? Maybe not
 	 * the lowest or the highest rate.. Could consider using RSSI from
 	 * previous packets? Need to have IEEE 802.1X auth succeed immediately
 	 * after assoc.. */
 
-	lq_sta->ibss_sta_added = 0;
-	if (priv->iw_mode == NL80211_IFTYPE_AP) {
-		u8 sta_id = iwl_find_station(priv,
-								sta->addr);
-
-		/* for IBSS the call are from tasklet */
-		IWL_DEBUG_RATE(priv, "LQ: ADD station %pM\n", sta->addr);
-
-		if (sta_id == IWL_INVALID_STATION) {
-			IWL_DEBUG_RATE(priv, "LQ: ADD station %pM\n", sta->addr);
-			sta_id = iwl_add_station(priv, sta->addr, false,
-						CMD_ASYNC, ht_cap);
-		}
-		if ((sta_id != IWL_INVALID_STATION)) {
-			lq_sta->lq.sta_id = sta_id;
-			lq_sta->lq.rs_table[0].rate_n_flags = 0;
-		}
-		/* FIXME: this is w/a remove it later */
-		priv->assoc_station_added = 1;
-	}
-
 	lq_sta->is_dup = 0;
 	lq_sta->max_rate_idx = -1;
 	lq_sta->missed_rate_counter = IWL_MISSED_RATE_MAX;
@@ -2795,7 +2788,7 @@ static ssize_t rs_sta_dbgfs_scale_table_write(struct file *file,
 
 	if (lq_sta->dbg_fixed_rate) {
 		rs_fill_link_cmd(NULL, lq_sta, lq_sta->dbg_fixed_rate);
-		iwl_send_lq_cmd(lq_sta->drv, &lq_sta->lq, CMD_ASYNC);
+		iwl_send_lq_cmd(lq_sta->drv, &lq_sta->lq, CMD_ASYNC, false);
 	}
 
 	return count;
@@ -2992,12 +2985,21 @@ static void rs_remove_debugfs(void *priv, void *priv_sta)
 }
 #endif
 
+/*
+ * Initialization of rate scaling information is done by driver after
+ * the station is added. Since mac80211 calls this function before a
+ * station is added we ignore it.
+ */
+static void rs_rate_init_stub(void *priv_r, struct ieee80211_supported_band *sband,
+			 struct ieee80211_sta *sta, void *priv_sta)
+{
+}
 static struct rate_control_ops rs_ops = {
 	.module = NULL,
 	.name = RS_NAME,
 	.tx_status = rs_tx_status,
 	.get_rate = rs_get_rate,
-	.rate_init = rs_rate_init,
+	.rate_init = rs_rate_init_stub,
 	.alloc = rs_alloc,
 	.free = rs_free,
 	.alloc_sta = rs_alloc_sta,
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rs.h b/drivers/net/wireless/iwlwifi/iwl-agn-rs.h
index e182f5a..8292f6d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rs.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rs.h
@@ -403,7 +403,6 @@ struct iwl_lq_sta {
 	u8 is_green;
 	u8 is_dup;
 	enum ieee80211_band band;
-	u8 ibss_sta_added;
 
 	/* The following are bitmaps of rates; IWL_RATE_6M_MASK, etc. */
 	u32 supp_rates;
@@ -478,6 +477,12 @@ static inline u8 iwl3945_get_prev_ieee_rate(u8 rate_index)
  */
 extern void iwl3945_rate_scale_init(struct ieee80211_hw *hw, s32 sta_id);
 
+/* Initialize station's rate scaling information after adding station */
+extern void iwl_rs_rate_init(struct iwl_priv *priv,
+			     struct ieee80211_sta *sta, u8 sta_id);
+extern void iwl3945_rs_rate_init(struct iwl_priv *priv,
+				 struct ieee80211_sta *sta, u8 sta_id);
+
 /**
  * iwl_rate_control_register - Register the rate control algorithm callbacks
  *
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 85ff155..4b4b476 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -144,9 +144,6 @@ int iwl_commit_rxon(struct iwl_priv *priv)
 		return 0;
 	}
 
-	/* station table will be cleared */
-	priv->assoc_station_added = 0;
-
 	/* If we are currently associated and the new config requires
 	 * an RXON_ASSOC and the new config wants the associated mask enabled,
 	 * we must clear the associated from the active configuration
@@ -198,25 +195,7 @@ int iwl_commit_rxon(struct iwl_priv *priv)
 	}
 
 	priv->start_calib = 0;
-
-	/* If we have set the ASSOC_MSK and we are in BSS mode then
-	 * add the IWL_AP_ID to the station rate table */
 	if (new_assoc) {
-		if (priv->iw_mode == NL80211_IFTYPE_STATION) {
-			ret = iwl_rxon_add_station(priv,
-					   priv->active_rxon.bssid_addr, 1);
-			if (ret == IWL_INVALID_STATION) {
-				IWL_ERR(priv,
-					"Error adding AP address for TX.\n");
-				return -EIO;
-			}
-			priv->assoc_station_added = 1;
-			if (priv->default_wep_key &&
-			    iwl_send_static_wepkey_cmd(priv, 0))
-				IWL_ERR(priv,
-					"Could not send WEP static key.\n");
-		}
-
 		/*
 		 * allow CTS-to-self if possible for new association.
 		 * this is relevant only for 5000 series and up,
@@ -2498,10 +2477,6 @@ void iwl_post_associate(struct iwl_priv *priv)
 		return;
 	}
 
-	IWL_DEBUG_ASSOC(priv, "Associated as %d to: %pM\n",
-			priv->assoc_id, priv->active_rxon.bssid_addr);
-
-
 	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
 		return;
 
@@ -2553,6 +2528,9 @@ void iwl_post_associate(struct iwl_priv *priv)
 
 	iwlcore_commit_rxon(priv);
 
+	IWL_DEBUG_ASSOC(priv, "Associated as %d to: %pM\n",
+			priv->assoc_id, priv->active_rxon.bssid_addr);
+
 	switch (priv->iw_mode) {
 	case NL80211_IFTYPE_STATION:
 		break;
@@ -2562,7 +2540,7 @@ void iwl_post_associate(struct iwl_priv *priv)
 		/* assume default assoc id */
 		priv->assoc_id = 1;
 
-		iwl_rxon_add_station(priv, priv->bssid, 0);
+		iwl_add_local_station(priv, priv->bssid, true);
 		iwl_send_beacon_cmd(priv);
 
 		break;
@@ -2573,9 +2551,6 @@ void iwl_post_associate(struct iwl_priv *priv)
 		break;
 	}
 
-	if (priv->iw_mode == NL80211_IFTYPE_ADHOC)
-		priv->assoc_station_added = 1;
-
 	spin_lock_irqsave(&priv->lock, flags);
 	iwl_activate_qos(priv, 0);
 	spin_unlock_irqrestore(&priv->lock, flags);
@@ -2974,18 +2949,7 @@ static void iwl_mac_sta_notify(struct ieee80211_hw *hw,
 	struct iwl_station_priv *sta_priv = (void *)sta->drv_priv;
 	int sta_id;
 
-	/*
-	 * TODO: We really should use this callback to
-	 *	 actually maintain the station table in
-	 *	 the device.
-	 */
-
 	switch (cmd) {
-	case STA_NOTIFY_ADD:
-		atomic_set(&sta_priv->pending_frames, 0);
-		if (vif->type == NL80211_IFTYPE_AP)
-			sta_priv->client = true;
-		break;
 	case STA_NOTIFY_SLEEP:
 		WARN_ON(!sta_priv->client);
 		sta_priv->asleep = true;
@@ -3006,6 +2970,55 @@ static void iwl_mac_sta_notify(struct ieee80211_hw *hw,
 	}
 }
 
+/**
+ * iwl_restore_wepkeys - Restore WEP keys to device
+ */
+static void iwl_restore_wepkeys(struct iwl_priv *priv)
+{
+	mutex_lock(&priv->mutex);
+	if (priv->iw_mode == NL80211_IFTYPE_STATION &&
+	    priv->default_wep_key &&
+	    iwl_send_static_wepkey_cmd(priv, 0))
+		IWL_ERR(priv, "Could not send WEP static key\n");
+	mutex_unlock(&priv->mutex);
+}
+
+static int iwlagn_mac_sta_add(struct ieee80211_hw *hw,
+			      struct ieee80211_vif *vif,
+			      struct ieee80211_sta *sta)
+{
+	struct iwl_priv *priv = hw->priv;
+	struct iwl_station_priv *sta_priv = (void *)sta->drv_priv;
+	bool is_ap = priv->iw_mode == NL80211_IFTYPE_STATION;
+	int ret;
+	u8 sta_id;
+
+	IWL_DEBUG_INFO(priv, "received request to add station %pM\n",
+			sta->addr);
+
+	atomic_set(&sta_priv->pending_frames, 0);
+	if (vif->type == NL80211_IFTYPE_AP)
+		sta_priv->client = true;
+
+	ret = iwl_add_station_common(priv, sta->addr, is_ap, &sta->ht_cap,
+				     &sta_id);
+	if (ret) {
+		IWL_ERR(priv, "Unable to add station %pM (%d)\n",
+			sta->addr, ret);
+		/* Should we return success if return code is EEXIST ? */
+		return ret;
+	}
+
+	iwl_restore_wepkeys(priv);
+
+	/* Initialize rate scaling */
+	IWL_DEBUG_INFO(priv, "Initializing rate scaling for station %pM \n",
+		       sta->addr);
+	iwl_rs_rate_init(priv, sta, sta_id);
+
+	return ret;
+}
+
 /*****************************************************************************
  *
  * sysfs attributes
@@ -3359,6 +3372,8 @@ static struct ieee80211_ops iwl_hw_ops = {
 	.ampdu_action = iwl_mac_ampdu_action,
 	.hw_scan = iwl_mac_hw_scan,
 	.sta_notify = iwl_mac_sta_notify,
+	.sta_add = iwlagn_mac_sta_add,
+	.sta_remove = iwl_mac_sta_remove,
 };
 
 static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index a33e453..d4c2a3e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -2530,7 +2530,6 @@ void iwl_mac_reset_tsf(struct ieee80211_hw *hw)
 	spin_lock_irqsave(&priv->lock, flags);
 	priv->assoc_id = 0;
 	priv->assoc_capability = 0;
-	priv->assoc_station_added = 0;
 
 	/* new association get rid of ibss beacon skb */
 	if (priv->ibss_beacon)
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index aced12f..2482a25 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -667,7 +667,7 @@ extern int iwl_send_statistics_request(struct iwl_priv *priv,
 				       u8 flags, bool clear);
 extern int iwl_verify_ucode(struct iwl_priv *priv);
 extern int iwl_send_lq_cmd(struct iwl_priv *priv,
-		struct iwl_link_quality_cmd *lq, u8 flags);
+		struct iwl_link_quality_cmd *lq, u8 flags, bool init);
 extern void iwl_rx_reply_rx(struct iwl_priv *priv,
 		struct iwl_rx_mem_buffer *rxb);
 extern void iwl_rx_reply_rx_phy(struct iwl_priv *priv,
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 2e4d47c..9c676ea 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -544,11 +544,18 @@ struct iwl_qos_info {
 	struct iwl_qosparam_cmd def_qos_parm;
 };
 
+/*
+ * Structure should be accessed with sta_lock held. When station addition
+ * is in progress (IWL_STA_UCODE_INPROGRESS) it is possible to access only
+ * the commands (iwl_addsta_cmd and iwl_link_quality_cmd) without sta_lock
+ * held.
+ */
 struct iwl_station_entry {
 	struct iwl_addsta_cmd sta;
 	struct iwl_tid_data tid[MAX_TID_COUNT];
 	u8 used;
 	struct iwl_hw_key keyinfo;
+	struct iwl_link_quality_cmd *lq;
 };
 
 /*
@@ -1163,7 +1170,6 @@ struct iwl_priv {
 
 	u16 active_rate;
 
-	u8 assoc_station_added;
 	u8 start_calib;
 	struct iwl_sensitivity_data sensitivity_data;
 	struct iwl_chain_noise_data chain_noise_data;
diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.c b/drivers/net/wireless/iwlwifi/iwl-sta.c
index 3120990..d401b6f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-sta.c
@@ -29,6 +29,7 @@
 
 #include <net/mac80211.h>
 #include <linux/etherdevice.h>
+#include <linux/sched.h>
 
 #include "iwl-dev.h"
 #include "iwl-core.h"
@@ -61,6 +62,19 @@ u8 iwl_find_station(struct iwl_priv *priv, const u8 *addr)
 			      addr, priv->num_stations);
 
  out:
+	/*
+	 * It may be possible that more commands interacting with stations
+	 * arrive before we completed processing the adding of
+	 * station
+	 */
+	if (ret != IWL_INVALID_STATION &&
+	    (!(priv->stations[ret].used & IWL_STA_UCODE_ACTIVE) ||
+	     ((priv->stations[ret].used & IWL_STA_UCODE_ACTIVE) &&
+	      (priv->stations[ret].used & IWL_STA_UCODE_INPROGRESS)))) {
+		IWL_ERR(priv, "Requested station info for sta %d before ready. \n",
+			ret);
+		ret = IWL_INVALID_STATION;
+	}
 	spin_unlock_irqrestore(&priv->sta_lock, flags);
 	return ret;
 }
@@ -155,13 +169,6 @@ static void iwl_process_add_sta_resp(struct iwl_priv *priv,
 		       priv->stations[sta_id].sta.mode ==
 		       STA_CONTROL_MODIFY_MSK ? "Modified" : "Added",
 		       addsta->sta.addr);
-
-	/*
-	 * Determine if we wanted to modify or add a station,
-	 * if adding a station succeeded we have some more initialization
-	 * to do when using station notification. TODO
-	 */
-
 	spin_unlock_irqrestore(&priv->sta_lock, flags);
 }
 
@@ -187,6 +194,10 @@ int iwl_send_add_sta(struct iwl_priv *priv,
 		.flags = flags,
 		.data = data,
 	};
+	u8 sta_id = sta->sta.sta_id;
+
+	IWL_DEBUG_INFO(priv, "Adding sta %u (%pM) %ssynchronously\n",
+		       sta_id, sta->sta.addr, flags & CMD_ASYNC ?  "a" : "");
 
 	if (flags & CMD_ASYNC)
 		cmd.callback = iwl_add_sta_callback;
@@ -260,18 +271,19 @@ static void iwl_set_ht_add_station(struct iwl_priv *priv, u8 index,
 }
 
 /**
- * iwl_add_station - Add station to tables in driver and device
+ * iwl_prep_station - Prepare station information for addition
+ *
+ * should be called with sta_lock held
  */
-u8 iwl_add_station(struct iwl_priv *priv, const u8 *addr, bool is_ap, u8 flags,
-		struct ieee80211_sta_ht_cap *ht_info)
+static u8 iwl_prep_station(struct iwl_priv *priv, const u8 *addr,
+			   bool is_ap,
+			   struct ieee80211_sta_ht_cap *ht_info)
 {
 	struct iwl_station_entry *station;
-	unsigned long flags_spin;
 	int i;
-	int sta_id = IWL_INVALID_STATION;
+	u8 sta_id = IWL_INVALID_STATION;
 	u16 rate;
 
-	spin_lock_irqsave(&priv->sta_lock, flags_spin);
 	if (is_ap)
 		sta_id = IWL_AP_ID;
 	else if (is_broadcast_ether_addr(addr))
@@ -289,20 +301,32 @@ u8 iwl_add_station(struct iwl_priv *priv, const u8 *addr, bool is_ap, u8 flags,
 				sta_id = i;
 		}
 
-	/* These two conditions have the same outcome, but keep them separate
-	   since they have different meanings */
-	if (unlikely(sta_id == IWL_INVALID_STATION)) {
-		spin_unlock_irqrestore(&priv->sta_lock, flags_spin);
+	/*
+	 * These two conditions have the same outcome, but keep them
+	 * separate
+	 */
+	if (unlikely(sta_id == IWL_INVALID_STATION))
+		return sta_id;
+
+	/*
+	 * uCode is not able to deal with multiple requests to add a
+	 * station. Keep track if one is in progress so that we do not send
+	 * another.
+	 */
+	if (priv->stations[sta_id].used & IWL_STA_UCODE_INPROGRESS) {
+		IWL_DEBUG_INFO(priv, "STA %d already in process of being added.\n",
+				sta_id);
 		return sta_id;
 	}
 
-	if (priv->stations[sta_id].used &&
+	if ((priv->stations[sta_id].used & IWL_STA_DRIVER_ACTIVE) &&
+	    (priv->stations[sta_id].used & IWL_STA_UCODE_ACTIVE) &&
 	    !compare_ether_addr(priv->stations[sta_id].sta.sta.addr, addr)) {
-		spin_unlock_irqrestore(&priv->sta_lock, flags_spin);
+		IWL_DEBUG_ASSOC(priv, "STA %d (%pM) already added, not adding again.\n",
+				sta_id, addr);
 		return sta_id;
 	}
 
-
 	station = &priv->stations[sta_id];
 	station->used = IWL_STA_DRIVER_ACTIVE;
 	IWL_DEBUG_ASSOC(priv, "Add STA to driver ID %d: %pM\n",
@@ -327,86 +351,185 @@ u8 iwl_add_station(struct iwl_priv *priv, const u8 *addr, bool is_ap, u8 flags,
 	/* Turn on both antennas for the station... */
 	station->sta.rate_n_flags = cpu_to_le16(rate | RATE_MCS_ANT_AB_MSK);
 
+	return sta_id;
+
+}
+
+#define STA_WAIT_TIMEOUT (HZ/2)
+
+/**
+ * iwl_add_station_common -
+ */
+int iwl_add_station_common(struct iwl_priv *priv, const u8 *addr,
+				  bool is_ap,
+				  struct ieee80211_sta_ht_cap *ht_info,
+				  u8 *sta_id_r)
+{
+	struct iwl_station_entry *station;
+	unsigned long flags_spin;
+	int ret = 0;
+	u8 sta_id;
+
+	*sta_id_r = 0;
+	spin_lock_irqsave(&priv->sta_lock, flags_spin);
+	sta_id = iwl_prep_station(priv, addr, is_ap, ht_info);
+	if (sta_id == IWL_INVALID_STATION) {
+		IWL_ERR(priv, "Unable to prepare station %pM for addition\n",
+			addr);
+		spin_unlock_irqrestore(&priv->sta_lock, flags_spin);
+		return -EINVAL;
+	}
+
+	/*
+	 * uCode is not able to deal with multiple requests to add a
+	 * station. Keep track if one is in progress so that we do not send
+	 * another.
+	 */
+	if (priv->stations[sta_id].used & IWL_STA_UCODE_INPROGRESS) {
+		IWL_DEBUG_INFO(priv, "STA %d already in process of being added.\n",
+			       sta_id);
+		spin_unlock_irqrestore(&priv->sta_lock, flags_spin);
+		return -EEXIST;
+	}
+
+	if ((priv->stations[sta_id].used & IWL_STA_DRIVER_ACTIVE) &&
+	    (priv->stations[sta_id].used & IWL_STA_UCODE_ACTIVE)) {
+		IWL_DEBUG_ASSOC(priv, "STA %d (%pM) already added, not adding again.\n",
+				sta_id, addr);
+		spin_unlock_irqrestore(&priv->sta_lock, flags_spin);
+		return -EEXIST;
+	}
+
+	priv->stations[sta_id].used |= IWL_STA_UCODE_INPROGRESS;
+	station = &priv->stations[sta_id];
 	spin_unlock_irqrestore(&priv->sta_lock, flags_spin);
 
 	/* Add station to device's station table */
-	iwl_send_add_sta(priv, &station->sta, flags);
-	return sta_id;
-
+	ret = iwl_send_add_sta(priv, &station->sta, CMD_SYNC);
+	if (ret) {
+		IWL_ERR(priv, "Adding station %pM failed.\n", station->sta.sta.addr);
+		spin_lock_irqsave(&priv->sta_lock, flags_spin);
+		priv->stations[sta_id].used &= ~IWL_STA_DRIVER_ACTIVE;
+		priv->stations[sta_id].used &= ~IWL_STA_UCODE_INPROGRESS;
+		spin_unlock_irqrestore(&priv->sta_lock, flags_spin);
+	}
+	*sta_id_r = sta_id;
+	return ret;
 }
-EXPORT_SYMBOL(iwl_add_station);
+EXPORT_SYMBOL(iwl_add_station_common);
 
-static void iwl_sta_ucode_deactivate(struct iwl_priv *priv, const u8 *addr)
+static void iwl_sta_init_lq(struct iwl_priv *priv, const u8 *addr, bool is_ap)
 {
-	unsigned long flags;
-	u8 sta_id = iwl_find_station(priv, addr);
+	int i, r;
+	struct iwl_link_quality_cmd link_cmd = {
+		.reserved1 = 0,
+	};
+	u32 rate_flags;
+
+	/* Set up the rate scaling to start at selected rate, fall back
+	 * all the way down to 1M in IEEE order, and then spin on 1M */
+	if (is_ap)
+		r = IWL_RATE_54M_INDEX;
+	else if (priv->band == IEEE80211_BAND_5GHZ)
+		r = IWL_RATE_6M_INDEX;
+	else
+		r = IWL_RATE_1M_INDEX;
 
-	BUG_ON(sta_id == IWL_INVALID_STATION);
+	for (i = 0; i < LINK_QUAL_MAX_RETRY_NUM; i++) {
+		rate_flags = 0;
+		if (r >= IWL_FIRST_CCK_RATE && r <= IWL_LAST_CCK_RATE)
+			rate_flags |= RATE_MCS_CCK_MSK;
 
-	IWL_DEBUG_ASSOC(priv, "Removed STA from Ucode: %pM\n", addr);
+		rate_flags |= first_antenna(priv->hw_params.valid_tx_ant) <<
+				RATE_MCS_ANT_POS;
 
-	spin_lock_irqsave(&priv->sta_lock, flags);
+		link_cmd.rs_table[i].rate_n_flags =
+			iwl_hw_set_rate_n_flags(iwl_rates[r].plcp, rate_flags);
+		r = iwl_get_prev_ieee_rate(r);
+	}
 
-	/* Ucode must be active and driver must be non active */
-	if (priv->stations[sta_id].used != IWL_STA_UCODE_ACTIVE)
-		IWL_ERR(priv, "removed non active STA %d\n", sta_id);
+	link_cmd.general_params.single_stream_ant_msk =
+				first_antenna(priv->hw_params.valid_tx_ant);
+	link_cmd.general_params.dual_stream_ant_msk = 3;
+	link_cmd.agg_params.agg_dis_start_th = LINK_QUAL_AGG_DISABLE_START_DEF;
+	link_cmd.agg_params.agg_time_limit =
+		cpu_to_le16(LINK_QUAL_AGG_TIME_LIMIT_DEF);
 
-	priv->stations[sta_id].used &= ~IWL_STA_UCODE_ACTIVE;
+	/* Update the rate scaling for control frame Tx to AP */
+	link_cmd.sta_id = is_ap ? IWL_AP_ID : priv->hw_params.bcast_sta_id;
 
-	memset(&priv->stations[sta_id], 0, sizeof(struct iwl_station_entry));
-	spin_unlock_irqrestore(&priv->sta_lock, flags);
+	iwl_send_cmd_pdu(priv, REPLY_TX_LINK_QUALITY_CMD,
+			       sizeof(link_cmd), &link_cmd);
 }
 
-static void iwl_remove_sta_callback(struct iwl_priv *priv,
-				    struct iwl_device_cmd *cmd,
-				    struct iwl_rx_packet *pkt)
+/*
+ * iwl_add_local_stations - Add stations not requested by mac80211
+ *
+ * This will be either the broadcast station or the bssid station needed by
+ * ad-hoc.
+ *
+ * Function sleeps.
+ */
+int iwl_add_local_station(struct iwl_priv *priv, const u8 *addr, bool init_rs)
 {
-	struct iwl_rem_sta_cmd *rm_sta =
-			(struct iwl_rem_sta_cmd *)cmd->cmd.payload;
-	const u8 *addr = rm_sta->addr;
+	int ret;
+	u8 sta_id;
 
-	if (pkt->hdr.flags & IWL_CMD_FAILED_MSK) {
-		IWL_ERR(priv, "Bad return from REPLY_REMOVE_STA (0x%08X)\n",
-		pkt->hdr.flags);
-		return;
+	ret = iwl_add_station_common(priv, addr, 0, NULL, &sta_id);
+	if (ret) {
+		IWL_ERR(priv, "Unable to add station %pM\n", addr);
+		return ret;
 	}
 
-	switch (pkt->u.rem_sta.status) {
-	case REM_STA_SUCCESS_MSK:
-		iwl_sta_ucode_deactivate(priv, addr);
-		break;
-	default:
-		IWL_ERR(priv, "REPLY_REMOVE_STA failed\n");
-		break;
-	}
+	if (init_rs)
+		/* Set up default rate scaling table in device's station table */
+		iwl_sta_init_lq(priv, addr, false);
+	return 0;
+}
+EXPORT_SYMBOL(iwl_add_local_station);
+
+/**
+ * iwl_sta_ucode_deactivate - deactivate ucode status for a station
+ *
+ * priv->sta_lock must be held
+ */
+static void iwl_sta_ucode_deactivate(struct iwl_priv *priv, u8 sta_id)
+{
+	/* Ucode must be active and driver must be non active */
+	if (priv->stations[sta_id].used != IWL_STA_UCODE_ACTIVE)
+		IWL_ERR(priv, "removed non active STA %u\n", sta_id);
+
+	priv->stations[sta_id].used &= ~IWL_STA_UCODE_ACTIVE;
+
+	memset(&priv->stations[sta_id], 0, sizeof(struct iwl_station_entry));
+	IWL_DEBUG_ASSOC(priv, "Removed STA %u\n", sta_id);
 }
 
-static int iwl_send_remove_station(struct iwl_priv *priv, const u8 *addr,
-				   u8 flags)
+static int iwl_send_remove_station(struct iwl_priv *priv,
+				   struct iwl_station_entry *station)
 {
 	struct iwl_rx_packet *pkt;
 	int ret;
 
+	unsigned long flags_spin;
 	struct iwl_rem_sta_cmd rm_sta_cmd;
 
 	struct iwl_host_cmd cmd = {
 		.id = REPLY_REMOVE_STA,
 		.len = sizeof(struct iwl_rem_sta_cmd),
-		.flags = flags,
+		.flags = CMD_SYNC,
 		.data = &rm_sta_cmd,
 	};
 
 	memset(&rm_sta_cmd, 0, sizeof(rm_sta_cmd));
 	rm_sta_cmd.num_sta = 1;
-	memcpy(&rm_sta_cmd.addr, addr , ETH_ALEN);
+	memcpy(&rm_sta_cmd.addr, &station->sta.sta.addr , ETH_ALEN);
+
+	cmd.flags |= CMD_WANT_SKB;
 
-	if (flags & CMD_ASYNC)
-		cmd.callback = iwl_remove_sta_callback;
-	else
-		cmd.flags |= CMD_WANT_SKB;
 	ret = iwl_send_cmd(priv, &cmd);
 
-	if (ret || (flags & CMD_ASYNC))
+	if (ret)
 		return ret;
 
 	pkt = (struct iwl_rx_packet *)cmd.reply_page;
@@ -419,7 +542,9 @@ static int iwl_send_remove_station(struct iwl_priv *priv, const u8 *addr,
 	if (!ret) {
 		switch (pkt->u.rem_sta.status) {
 		case REM_STA_SUCCESS_MSK:
-			iwl_sta_ucode_deactivate(priv, addr);
+			spin_lock_irqsave(&priv->sta_lock, flags_spin);
+			iwl_sta_ucode_deactivate(priv, station->sta.sta.sta_id);
+			spin_unlock_irqrestore(&priv->sta_lock, flags_spin);
 			IWL_DEBUG_ASSOC(priv, "REPLY_REMOVE_STA PASSED\n");
 			break;
 		default:
@@ -436,23 +561,35 @@ static int iwl_send_remove_station(struct iwl_priv *priv, const u8 *addr,
 /**
  * iwl_remove_station - Remove driver's knowledge of station.
  */
-int iwl_remove_station(struct iwl_priv *priv, const u8 *addr, bool is_ap)
+static int iwl_remove_station(struct iwl_priv *priv, struct ieee80211_sta *sta)
 {
 	int sta_id = IWL_INVALID_STATION;
 	int i, ret = -EINVAL;
 	unsigned long flags;
+	bool is_ap = priv->iw_mode == NL80211_IFTYPE_STATION;
+	struct iwl_station_entry *station;
+
+	if (!iwl_is_ready(priv)) {
+		IWL_DEBUG_INFO(priv,
+			"Unable to remove station %pM, device not ready. \n",
+			sta->addr);
+		/*
+		 * It is typical for stations to be removed when we are
+		 * going down. Return success since device will be down
+		 * soon anyway
+		 */
+		return 0;
+	}
 
 	spin_lock_irqsave(&priv->sta_lock, flags);
 
 	if (is_ap)
 		sta_id = IWL_AP_ID;
-	else if (is_broadcast_ether_addr(addr))
-		sta_id = priv->hw_params.bcast_sta_id;
 	else
 		for (i = IWL_STA_ID; i < priv->hw_params.max_stations; i++)
 			if (priv->stations[i].used &&
 			    !compare_ether_addr(priv->stations[i].sta.sta.addr,
-						addr)) {
+						sta->addr)) {
 				sta_id = i;
 				break;
 			}
@@ -461,17 +598,17 @@ int iwl_remove_station(struct iwl_priv *priv, const u8 *addr, bool is_ap)
 		goto out;
 
 	IWL_DEBUG_ASSOC(priv, "Removing STA from driver:%d  %pM\n",
-		sta_id, addr);
+		sta_id, sta->addr);
 
 	if (!(priv->stations[sta_id].used & IWL_STA_DRIVER_ACTIVE)) {
-		IWL_ERR(priv, "Removing %pM but non DRIVER active\n",
-				addr);
+		IWL_DEBUG_INFO(priv, "Removing %pM but non DRIVER active\n",
+				sta->addr);
 		goto out;
 	}
 
 	if (!(priv->stations[sta_id].used & IWL_STA_UCODE_ACTIVE)) {
-		IWL_ERR(priv, "Removing %pM but non UCODE active\n",
-				addr);
+		IWL_DEBUG_INFO(priv, "Removing %pM but non UCODE active\n",
+				sta->addr);
 		goto out;
 	}
 
@@ -482,9 +619,10 @@ int iwl_remove_station(struct iwl_priv *priv, const u8 *addr, bool is_ap)
 
 	BUG_ON(priv->num_stations < 0);
 
+	station = &priv->stations[sta_id];
 	spin_unlock_irqrestore(&priv->sta_lock, flags);
 
-	ret = iwl_send_remove_station(priv, addr, CMD_ASYNC);
+	ret = iwl_send_remove_station(priv, station);
 	return ret;
 out:
 	spin_unlock_irqrestore(&priv->sta_lock, flags);
@@ -548,12 +686,16 @@ EXPORT_SYMBOL(iwl_clear_ucode_stations);
  *
  * All stations considered active by driver, but not present in ucode, is
  * restored.
+ *
+ * Function sleeps.
  */
 void iwl_restore_stations(struct iwl_priv *priv)
 {
+	struct iwl_station_entry *station;
 	unsigned long flags_spin;
 	int i;
 	bool found = false;
+	int ret;
 
 	if (!iwl_is_ready(priv)) {
 		IWL_DEBUG_INFO(priv, "Not ready yet, not restoring any stations.\n");
@@ -575,8 +717,24 @@ void iwl_restore_stations(struct iwl_priv *priv)
 
 	for (i = 0; i < priv->hw_params.max_stations; i++) {
 		if ((priv->stations[i].used & IWL_STA_UCODE_INPROGRESS)) {
-			iwl_send_add_sta(priv, &priv->stations[i].sta,
-					 CMD_ASYNC);
+			spin_unlock_irqrestore(&priv->sta_lock, flags_spin);
+			station = &priv->stations[i];
+			ret = iwl_send_add_sta(priv, &priv->stations[i].sta, CMD_SYNC);
+			if (ret) {
+				IWL_ERR(priv, "Adding station %pM failed.\n",
+					station->sta.sta.addr);
+				spin_lock_irqsave(&priv->sta_lock, flags_spin);
+				priv->stations[i].used &= ~IWL_STA_DRIVER_ACTIVE;
+				priv->stations[i].used &= ~IWL_STA_UCODE_INPROGRESS;
+				spin_unlock_irqrestore(&priv->sta_lock, flags_spin);
+			}
+			/*
+			 * Rate scaling has already been initialized, send
+			 * current LQ command
+			 */
+			if (station->lq)
+				iwl_send_lq_cmd(priv, station->lq, CMD_SYNC, true);
+			spin_lock_irqsave(&priv->sta_lock, flags_spin);
 			priv->stations[i].used &= ~IWL_STA_UCODE_INPROGRESS;
 		}
 	}
@@ -585,7 +743,7 @@ void iwl_restore_stations(struct iwl_priv *priv)
 	if (!found)
 		IWL_DEBUG_INFO(priv, "Restoring all known stations .... no stations to be restored.\n");
 	else
-		IWL_DEBUG_INFO(priv, "Restoring all known stations .... in progress.\n");
+		IWL_DEBUG_INFO(priv, "Restoring all known stations .... complete.\n");
 }
 EXPORT_SYMBOL(iwl_restore_stations);
 
@@ -1010,9 +1168,22 @@ static inline void iwl_dump_lq_cmd(struct iwl_priv *priv,
 }
 #endif
 
+/**
+ * iwl_send_lq_cmd() - Send link quality command
+ * @init: This command is sent as part of station initialization right
+ *        after station has been added.
+ *
+ * The link quality command is sent as the last step of station creation.
+ * This is the special case in which init is set and we call a callback in
+ * this case to clear the state indicating that station creation is in
+ * progress.
+ */
 int iwl_send_lq_cmd(struct iwl_priv *priv,
-		    struct iwl_link_quality_cmd *lq, u8 flags)
+		    struct iwl_link_quality_cmd *lq, u8 flags, bool init)
 {
+	int ret = 0;
+	unsigned long flags_spin;
+
 	struct iwl_host_cmd cmd = {
 		.id = REPLY_TX_LINK_QUALITY_CMD,
 		.len = sizeof(struct iwl_link_quality_cmd),
@@ -1028,167 +1199,31 @@ int iwl_send_lq_cmd(struct iwl_priv *priv,
 		lq->sta_id = IWL_AP_ID;
 
 	iwl_dump_lq_cmd(priv, lq);
+	BUG_ON(init && (cmd.flags & CMD_ASYNC));
 
-	if (iwl_is_associated(priv) && priv->assoc_station_added)
-		return  iwl_send_cmd(priv, &cmd);
+	iwl_dump_lq_cmd(priv, lq);
+	ret = iwl_send_cmd(priv, &cmd);
+	if (ret || (cmd.flags & CMD_ASYNC))
+		return ret;
 
+	if (init) {
+		IWL_DEBUG_INFO(priv, "init LQ command complete, clearing sta addition status for sta %d \n",
+			       lq->sta_id);
+		spin_lock_irqsave(&priv->sta_lock, flags_spin);
+		priv->stations[lq->sta_id].used &= ~IWL_STA_UCODE_INPROGRESS;
+		spin_unlock_irqrestore(&priv->sta_lock, flags_spin);
+	}
 	return 0;
 }
 EXPORT_SYMBOL(iwl_send_lq_cmd);
 
 /**
- * iwl_sta_init_lq - Initialize a station's hardware rate table
- *
- * The uCode's station table contains a table of fallback rates
- * for automatic fallback during transmission.
- *
- * NOTE: This sets up a default set of values.  These will be replaced later
- *       if the driver's iwl-agn-rs rate scaling algorithm is used, instead of
- *       rc80211_simple.
- *
- * NOTE: Run REPLY_ADD_STA command to set up station table entry, before
- *       calling this function (which runs REPLY_TX_LINK_QUALITY_CMD,
- *       which requires station table entry to exist).
- */
-static void iwl_sta_init_lq(struct iwl_priv *priv, const u8 *addr, bool is_ap)
-{
-	int i, r;
-	struct iwl_link_quality_cmd link_cmd = {
-		.reserved1 = 0,
-	};
-	u32 rate_flags;
-
-	/* Set up the rate scaling to start at selected rate, fall back
-	 * all the way down to 1M in IEEE order, and then spin on 1M */
-	if (is_ap)
-		r = IWL_RATE_54M_INDEX;
-	else if (priv->band == IEEE80211_BAND_5GHZ)
-		r = IWL_RATE_6M_INDEX;
-	else
-		r = IWL_RATE_1M_INDEX;
-
-	for (i = 0; i < LINK_QUAL_MAX_RETRY_NUM; i++) {
-		rate_flags = 0;
-		if (r >= IWL_FIRST_CCK_RATE && r <= IWL_LAST_CCK_RATE)
-			rate_flags |= RATE_MCS_CCK_MSK;
-
-		rate_flags |= first_antenna(priv->hw_params.valid_tx_ant) <<
-				RATE_MCS_ANT_POS;
-
-		link_cmd.rs_table[i].rate_n_flags =
-			iwl_hw_set_rate_n_flags(iwl_rates[r].plcp, rate_flags);
-		r = iwl_get_prev_ieee_rate(r);
-	}
-
-	link_cmd.general_params.single_stream_ant_msk =
-				first_antenna(priv->hw_params.valid_tx_ant);
-	link_cmd.general_params.dual_stream_ant_msk = 3;
-	link_cmd.agg_params.agg_dis_start_th = LINK_QUAL_AGG_DISABLE_START_DEF;
-	link_cmd.agg_params.agg_time_limit =
-		cpu_to_le16(LINK_QUAL_AGG_TIME_LIMIT_DEF);
-
-	/* Update the rate scaling for control frame Tx to AP */
-	link_cmd.sta_id = is_ap ? IWL_AP_ID : priv->hw_params.bcast_sta_id;
-
-	iwl_send_cmd_pdu_async(priv, REPLY_TX_LINK_QUALITY_CMD,
-			       sizeof(link_cmd), &link_cmd, NULL);
-}
-
-/**
- * iwl_rxon_add_station - add station into station table.
- *
- * there is only one AP station with id= IWL_AP_ID
- * NOTE: mutex must be held before calling this function
- */
-int iwl_rxon_add_station(struct iwl_priv *priv, const u8 *addr, bool is_ap)
-{
-	struct ieee80211_sta *sta;
-	struct ieee80211_sta_ht_cap ht_config;
-	struct ieee80211_sta_ht_cap *cur_ht_config = NULL;
-	u8 sta_id;
-
-	/*
-	 * Set HT capabilities. It is ok to set this struct even if not using
-	 * HT config: the priv->current_ht_config.is_ht flag will just be false
-	 */
-	rcu_read_lock();
-	sta = ieee80211_find_sta(priv->vif, addr);
-	if (sta) {
-		memcpy(&ht_config, &sta->ht_cap, sizeof(ht_config));
-		cur_ht_config = &ht_config;
-	}
-	rcu_read_unlock();
-
-	/* Add station to device's station table */
-	sta_id = iwl_add_station(priv, addr, is_ap, CMD_SYNC, cur_ht_config);
-
-	/* Set up default rate scaling table in device's station table */
-	iwl_sta_init_lq(priv, addr, is_ap);
-
-	return sta_id;
-}
-EXPORT_SYMBOL(iwl_rxon_add_station);
-
-/**
- * iwl_sta_init_bcast_lq - Initialize a bcast station's hardware rate table
- *
- * NOTE: Run REPLY_ADD_STA command to set up station table entry, before
- *       calling this function (which runs REPLY_TX_LINK_QUALITY_CMD,
- *       which requires station table entry to exist).
- */
-static void iwl_sta_init_bcast_lq(struct iwl_priv *priv)
-{
-	int i, r;
-	struct iwl_link_quality_cmd link_cmd = {
-		.reserved1 = 0,
-	};
-	u32 rate_flags;
-
-	/* Set up the rate scaling to start at selected rate, fall back
-	 * all the way down to 1M in IEEE order, and then spin on 1M */
-	if (priv->band == IEEE80211_BAND_5GHZ)
-		r = IWL_RATE_6M_INDEX;
-	else
-		r = IWL_RATE_1M_INDEX;
-
-	for (i = 0; i < LINK_QUAL_MAX_RETRY_NUM; i++) {
-		rate_flags = 0;
-		if (r >= IWL_FIRST_CCK_RATE && r <= IWL_LAST_CCK_RATE)
-			rate_flags |= RATE_MCS_CCK_MSK;
-
-		rate_flags |= first_antenna(priv->hw_params.valid_tx_ant) <<
-				RATE_MCS_ANT_POS;
-
-		link_cmd.rs_table[i].rate_n_flags =
-			iwl_hw_set_rate_n_flags(iwl_rates[r].plcp, rate_flags);
-		r = iwl_get_prev_ieee_rate(r);
-	}
-
-	link_cmd.general_params.single_stream_ant_msk =
-				first_antenna(priv->hw_params.valid_tx_ant);
-	link_cmd.general_params.dual_stream_ant_msk = 3;
-	link_cmd.agg_params.agg_dis_start_th = LINK_QUAL_AGG_DISABLE_START_DEF;
-	link_cmd.agg_params.agg_time_limit =
-		cpu_to_le16(LINK_QUAL_AGG_TIME_LIMIT_DEF);
-
-	/* Update the rate scaling for control frame Tx to AP */
-	link_cmd.sta_id = priv->hw_params.bcast_sta_id;
-
-	iwl_send_cmd_pdu_async(priv, REPLY_TX_LINK_QUALITY_CMD,
-			       sizeof(link_cmd), &link_cmd, NULL);
-}
-
-
-/**
  * iwl_add_bcast_station - add broadcast station into station table.
  */
 void iwl_add_bcast_station(struct iwl_priv *priv)
 {
 	IWL_DEBUG_INFO(priv, "Adding broadcast station to station table\n");
-	iwl_add_station(priv, iwl_bcast_addr, false, CMD_SYNC, NULL);
-
-	/* Set up default rate scaling table in device's station table */
-	iwl_sta_init_bcast_lq(priv);
+	iwl_add_local_station(priv, iwl_bcast_addr, true);
 }
 EXPORT_SYMBOL(iwl_add_bcast_station);
 
@@ -1198,7 +1233,14 @@ EXPORT_SYMBOL(iwl_add_bcast_station);
 void iwl3945_add_bcast_station(struct iwl_priv *priv)
 {
 	IWL_DEBUG_INFO(priv, "Adding broadcast station to station table\n");
-	iwl_add_station(priv, iwl_bcast_addr, false, CMD_SYNC, NULL);
+	iwl_add_local_station(priv, iwl_bcast_addr, false);
+	/*
+	 * It is assumed that when station is added more initialization
+	 * needs to be done, but for 3945 it is not the case and we can
+	 * just release station table access right here.
+	 */
+	priv->stations[priv->hw_params.bcast_sta_id].used &= ~IWL_STA_UCODE_INPROGRESS;
+
 }
 EXPORT_SYMBOL(iwl3945_add_bcast_station);
 
@@ -1221,6 +1263,13 @@ int iwl_get_sta_id(struct iwl_priv *priv, struct ieee80211_hdr *hdr)
 	/* If we are a client station in a BSS network, use the special
 	 * AP station entry (that's the only station we communicate with) */
 	case NL80211_IFTYPE_STATION:
+		/*
+		 * If addition of station not complete yet, which means
+		 * that rate scaling has not been initialized, then return
+		 * the broadcast station.
+		 */
+		if (!(priv->stations[IWL_AP_ID].used & IWL_STA_UCODE_ACTIVE))
+			return priv->hw_params.bcast_sta_id;
 		return IWL_AP_ID;
 
 	/* If we are an AP, then find the station, or use BCAST */
@@ -1237,13 +1286,6 @@ int iwl_get_sta_id(struct iwl_priv *priv, struct ieee80211_hdr *hdr)
 		if (sta_id != IWL_INVALID_STATION)
 			return sta_id;
 
-		/* Create new station table entry */
-		sta_id = iwl_add_station(priv, hdr->addr1, false,
-					CMD_ASYNC, NULL);
-
-		if (sta_id != IWL_INVALID_STATION)
-			return sta_id;
-
 		IWL_DEBUG_DROP(priv, "Station %pM not in station map. "
 			       "Defaulting to broadcast...\n",
 			       hdr->addr1);
@@ -1353,3 +1395,19 @@ void iwl_sta_modify_sleep_tx_count(struct iwl_priv *priv, int sta_id, int cnt)
 
 	iwl_send_add_sta(priv, &priv->stations[sta_id].sta, CMD_ASYNC);
 }
+
+int iwl_mac_sta_remove(struct ieee80211_hw *hw,
+			       struct ieee80211_vif *vif,
+			       struct ieee80211_sta *sta)
+{
+	int ret;
+	struct iwl_priv *priv = hw->priv;
+	IWL_DEBUG_INFO(priv, "received request to remove station %pM\n",
+			sta->addr);
+	ret = iwl_remove_station(priv, sta);
+	if (ret)
+		IWL_ERR(priv, "Error removing station %pM\n",
+			sta->addr);
+	return ret;
+}
+EXPORT_SYMBOL(iwl_mac_sta_remove);
diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.h b/drivers/net/wireless/iwlwifi/iwl-sta.h
index 50367e8..87a3499 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sta.h
+++ b/drivers/net/wireless/iwlwifi/iwl-sta.h
@@ -57,10 +57,8 @@ void iwl_update_tkip_key(struct iwl_priv *priv,
 			struct ieee80211_key_conf *keyconf,
 			const u8 *addr, u32 iv32, u16 *phase1key);
 
-int iwl_rxon_add_station(struct iwl_priv *priv, const u8 *addr, bool is_ap);
 void iwl_add_bcast_station(struct iwl_priv *priv);
 void iwl3945_add_bcast_station(struct iwl_priv *priv);
-int iwl_remove_station(struct iwl_priv *priv, const u8 *addr, bool is_ap);
 void iwl_restore_stations(struct iwl_priv *priv);
 void iwl_clear_ucode_stations(struct iwl_priv *priv, bool force);
 int iwl_get_free_ucode_key_index(struct iwl_priv *priv);
@@ -68,8 +66,13 @@ int iwl_get_sta_id(struct iwl_priv *priv, struct ieee80211_hdr *hdr);
 int iwl_get_ra_sta_id(struct iwl_priv *priv, struct ieee80211_hdr *hdr);
 int iwl_send_add_sta(struct iwl_priv *priv,
 		     struct iwl_addsta_cmd *sta, u8 flags);
-u8 iwl_add_station(struct iwl_priv *priv, const u8 *addr, bool is_ap, u8 flags,
-			struct ieee80211_sta_ht_cap *ht_info);
+int iwl_add_local_station(struct iwl_priv *priv, const u8 *addr, bool init_rs);
+int iwl_add_station_common(struct iwl_priv *priv, const u8 *addr,
+				  bool is_ap,
+				  struct ieee80211_sta_ht_cap *ht_info,
+				  u8 *sta_id_r);
+int iwl_mac_sta_remove(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
+		       struct ieee80211_sta *sta);
 void iwl_sta_tx_modify_enable_tid(struct iwl_priv *priv, int sta_id, int tid);
 int iwl_sta_rx_agg_start(struct iwl_priv *priv,
 			 const u8 *addr, int tid, u16 ssn);
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 6d3e6a8..6687b94 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -3116,12 +3116,13 @@ void iwl3945_post_associate(struct iwl_priv *priv)
 	case NL80211_IFTYPE_ADHOC:
 
 		priv->assoc_id = 1;
-		iwl_add_station(priv, priv->bssid, 0, CMD_SYNC, NULL);
+		iwl_add_local_station(priv, priv->bssid, false);
 		iwl3945_sync_sta(priv, IWL_STA_ID,
-				 (priv->band == IEEE80211_BAND_5GHZ) ?
-				 IWL_RATE_6M_PLCP : IWL_RATE_1M_PLCP,
+				(priv->band == IEEE80211_BAND_5GHZ) ?
+				IWL_RATE_6M_PLCP : IWL_RATE_1M_PLCP,
 				 CMD_ASYNC);
 		iwl3945_rate_scale_init(priv->hw, IWL_STA_ID);
+
 		iwl3945_send_beacon_cmd(priv);
 
 		break;
@@ -3306,7 +3307,7 @@ void iwl3945_config_ap(struct iwl_priv *priv)
 		/* restore RXON assoc */
 		priv->staging_rxon.filter_flags |= RXON_FILTER_ASSOC_MSK;
 		iwlcore_commit_rxon(priv);
-		iwl_add_station(priv, iwl_bcast_addr, 0, CMD_SYNC, NULL);
+		iwl_add_local_station(priv, iwl_bcast_addr, false);
 	}
 	iwl3945_send_beacon_cmd(priv);
 
@@ -3373,6 +3374,38 @@ static int iwl3945_mac_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 	return ret;
 }
 
+static int iwl3945_mac_sta_add(struct ieee80211_hw *hw,
+			       struct ieee80211_vif *vif,
+			       struct ieee80211_sta *sta)
+{
+	struct iwl_priv *priv = hw->priv;
+	int ret;
+	bool is_ap = priv->iw_mode == NL80211_IFTYPE_STATION;
+	u8 sta_id;
+
+	IWL_DEBUG_INFO(priv, "received request to add station %pM\n",
+			sta->addr);
+
+	ret = iwl_add_station_common(priv, sta->addr, is_ap, &sta->ht_cap,
+				     &sta_id);
+	if (ret) {
+		IWL_ERR(priv, "Unable to add station %pM (%d)\n",
+			sta->addr, ret);
+		/* Should we return success if return code is EEXIST ? */
+		return ret;
+	}
+
+	/* Initialize rate scaling */
+	IWL_DEBUG_INFO(priv, "Initializing rate scaling for station %pM \n",
+		       sta->addr);
+	iwl3945_rs_rate_init(priv, sta, sta_id);
+
+	return 0;
+
+
+
+	return ret;
+}
 /*****************************************************************************
  *
  * sysfs attributes
@@ -3812,7 +3845,9 @@ static struct ieee80211_ops iwl3945_hw_ops = {
 	.conf_tx = iwl_mac_conf_tx,
 	.reset_tsf = iwl_mac_reset_tsf,
 	.bss_info_changed = iwl_bss_info_changed,
-	.hw_scan = iwl_mac_hw_scan
+	.hw_scan = iwl_mac_hw_scan,
+	.sta_add = iwl3945_mac_sta_add,
+	.sta_remove = iwl_mac_sta_remove,
 };
 
 static int iwl3945_init_drv(struct iwl_priv *priv)
-- 
1.6.3.3

