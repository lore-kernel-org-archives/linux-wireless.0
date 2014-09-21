Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f51.google.com ([74.125.82.51]:36016 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751826AbaIUTWi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 21 Sep 2014 15:22:38 -0400
Received: by mail-wg0-f51.google.com with SMTP id m15so1785220wgh.10
        for <linux-wireless@vger.kernel.org>; Sun, 21 Sep 2014 12:22:37 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Eyal Shapira <eyal@wizery.com>,
	Eyal Shapira <eyalx.shapira@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 08/17] iwlwifi: mvm: choose an initial tx rate based on rssi conditions
Date: Sun, 21 Sep 2014 22:22:09 +0300
Message-Id: <1411327338-23099-8-git-send-email-egrumbach@gmail.com> (sfid-20140921_213113_787790_8115DCE7)
In-Reply-To: <541F23D2.90600@gmail.com>
References: <541F23D2.90600@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eyal Shapira <eyal@wizery.com>

Improve the initial tx rate and antenna selection to be based on
the rssi of the last rx. This avoids starting at the lowest legacy
rate always and requiring more tx traffic to "climb" up the rates.
Since this option might cause trouble in certain setups, allow to
disable it by default.

Signed-off-by: Eyal Shapira <eyalx.shapira@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/constants.h |   1 +
 drivers/net/wireless/iwlwifi/mvm/mvm.h       |   3 +
 drivers/net/wireless/iwlwifi/mvm/rs.c        | 131 ++++++++++++++++++++++-----
 drivers/net/wireless/iwlwifi/mvm/rx.c        |  41 +++++----
 4 files changed, 136 insertions(+), 40 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/constants.h b/drivers/net/wireless/iwlwifi/mvm/constants.h
index a355788..f47f458 100644
--- a/drivers/net/wireless/iwlwifi/mvm/constants.h
+++ b/drivers/net/wireless/iwlwifi/mvm/constants.h
@@ -94,5 +94,6 @@
 #define IWL_MVM_BT_COEX_MPLUT			1
 #define IWL_MVM_FW_MCAST_FILTER_PASS_ALL	0
 #define IWL_MVM_QUOTA_THRESHOLD			8
+#define IWL_MVM_RS_RSSI_BASED_INIT_RATE         0
 
 #endif /* __MVM_CONSTANTS_H */
diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index c913d5e..7d0194b 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -989,6 +989,9 @@ void iwl_mvm_update_frame_stats(struct iwl_mvm *mvm,
 				struct iwl_mvm_frame_stats *stats,
 				u32 rate, bool agg);
 int rs_pretty_print_rate(char *buf, const u32 rate);
+void rs_update_last_rssi(struct iwl_mvm *mvm,
+			 struct iwl_lq_sta *lq_sta,
+			 struct ieee80211_rx_status *rx_status);
 
 /* power management */
 int iwl_mvm_power_update_device(struct iwl_mvm *mvm);
diff --git a/drivers/net/wireless/iwlwifi/mvm/rs.c b/drivers/net/wireless/iwlwifi/mvm/rs.c
index f77dfe4..d179a8e 100644
--- a/drivers/net/wireless/iwlwifi/mvm/rs.c
+++ b/drivers/net/wireless/iwlwifi/mvm/rs.c
@@ -2288,6 +2288,110 @@ out:
 	lq_sta->last_txrate_idx = index;
 }
 
+struct rs_init_rate_info {
+	s8 rssi;
+	u8 rate_idx;
+};
+
+static const struct rs_init_rate_info rs_init_rates_24ghz[] = {
+	{ -60, IWL_RATE_54M_INDEX },
+	{ -64, IWL_RATE_48M_INDEX },
+	{ -68, IWL_RATE_36M_INDEX },
+	{ -80, IWL_RATE_24M_INDEX },
+	{ -84, IWL_RATE_18M_INDEX },
+	{ -85, IWL_RATE_12M_INDEX },
+	{ -86, IWL_RATE_11M_INDEX },
+	{ -88, IWL_RATE_5M_INDEX  },
+	{ -90, IWL_RATE_2M_INDEX  },
+	{ S8_MIN, IWL_RATE_1M_INDEX },
+};
+
+static const struct rs_init_rate_info rs_init_rates_5ghz[] = {
+	{ -60, IWL_RATE_54M_INDEX },
+	{ -64, IWL_RATE_48M_INDEX },
+	{ -72, IWL_RATE_36M_INDEX },
+	{ -80, IWL_RATE_24M_INDEX },
+	{ -84, IWL_RATE_18M_INDEX },
+	{ -85, IWL_RATE_12M_INDEX },
+	{ -87, IWL_RATE_9M_INDEX  },
+	{ S8_MIN, IWL_RATE_6M_INDEX },
+};
+
+/* Choose an initial legacy rate and antenna to use based on the RSSI
+ * of last Rx
+ */
+static void rs_get_initial_rate(struct iwl_mvm *mvm,
+				struct iwl_lq_sta *lq_sta,
+				enum ieee80211_band band,
+				struct rs_rate *rate)
+{
+	int i, nentries;
+	s8 best_rssi = S8_MIN;
+	u8 best_ant = ANT_NONE;
+	u8 valid_tx_ant = mvm->fw->valid_tx_ant;
+	const struct rs_init_rate_info *initial_rates;
+
+	for (i = 0; i < ARRAY_SIZE(lq_sta->pers.chain_signal); i++) {
+		if (!(lq_sta->pers.chains & BIT(i)))
+			continue;
+
+		if (lq_sta->pers.chain_signal[i] > best_rssi) {
+			best_rssi = lq_sta->pers.chain_signal[i];
+			best_ant = BIT(i);
+		}
+	}
+
+	IWL_DEBUG_RATE(mvm, "Best ANT: %s Best RSSI: %d\n",
+		       rs_pretty_ant(best_ant), best_rssi);
+
+	if (best_ant != ANT_A && best_ant != ANT_B)
+		rate->ant = first_antenna(valid_tx_ant);
+	else
+		rate->ant = best_ant;
+
+	rate->sgi = false;
+	rate->ldpc = false;
+	rate->bw = RATE_MCS_CHAN_WIDTH_20;
+
+	rate->index = find_first_bit(&lq_sta->active_legacy_rate,
+				     BITS_PER_LONG);
+
+	if (band == IEEE80211_BAND_5GHZ) {
+		rate->type = LQ_LEGACY_A;
+		initial_rates = rs_init_rates_5ghz;
+		nentries = ARRAY_SIZE(rs_init_rates_5ghz);
+	} else {
+		rate->type = LQ_LEGACY_G;
+		initial_rates = rs_init_rates_24ghz;
+		nentries = ARRAY_SIZE(rs_init_rates_24ghz);
+	}
+
+	if (IWL_MVM_RS_RSSI_BASED_INIT_RATE) {
+		for (i = 0; i < nentries; i++) {
+			int rate_idx = initial_rates[i].rate_idx;
+			if ((best_rssi >= initial_rates[i].rssi) &&
+			    (BIT(rate_idx) & lq_sta->active_legacy_rate)) {
+				rate->index = rate_idx;
+				break;
+			}
+		}
+	}
+
+	IWL_DEBUG_RATE(mvm, "rate_idx %d ANT %s\n", rate->index,
+		       rs_pretty_ant(rate->ant));
+}
+
+/* Save info about RSSI of last Rx */
+void rs_update_last_rssi(struct iwl_mvm *mvm,
+			 struct iwl_lq_sta *lq_sta,
+			 struct ieee80211_rx_status *rx_status)
+{
+	lq_sta->pers.chains = rx_status->chains;
+	lq_sta->pers.chain_signal[0] = rx_status->chain_signal[0];
+	lq_sta->pers.chain_signal[1] = rx_status->chain_signal[1];
+	lq_sta->pers.chain_signal[2] = rx_status->chain_signal[2];
+}
+
 /**
  * rs_initialize_lq - Initialize a station's hardware rate table
  *
@@ -2310,17 +2414,11 @@ static void rs_initialize_lq(struct iwl_mvm *mvm,
 {
 	struct iwl_scale_tbl_info *tbl;
 	struct rs_rate *rate;
-	int i;
 	u8 active_tbl = 0;
-	u8 valid_tx_ant;
 
 	if (!sta || !lq_sta)
 		return;
 
-	i = lq_sta->last_txrate_idx;
-
-	valid_tx_ant = mvm->fw->valid_tx_ant;
-
 	if (!lq_sta->search_better_tbl)
 		active_tbl = lq_sta->active_tbl;
 	else
@@ -2329,18 +2427,8 @@ static void rs_initialize_lq(struct iwl_mvm *mvm,
 	tbl = &(lq_sta->lq_info[active_tbl]);
 	rate = &tbl->rate;
 
-	if ((i < 0) || (i >= IWL_RATE_COUNT))
-		i = 0;
-
-	rate->index = i;
-	rate->ant = first_antenna(valid_tx_ant);
-	rate->sgi = false;
-	rate->ldpc = false;
-	rate->bw = RATE_MCS_CHAN_WIDTH_20;
-	if (band == IEEE80211_BAND_5GHZ)
-		rate->type = LQ_LEGACY_A;
-	else
-		rate->type = LQ_LEGACY_G;
+	rs_get_initial_rate(mvm, lq_sta, band, rate);
+	lq_sta->last_txrate_idx = rate->index;
 
 	WARN_ON_ONCE(rate->ant != ANT_A && rate->ant != ANT_B);
 	if (rate->ant == ANT_A)
@@ -2397,6 +2485,8 @@ static void *rs_alloc_sta(void *mvm_rate, struct ieee80211_sta *sta,
 	lq_sta->pers.dbg_fixed_rate = 0;
 	lq_sta->pers.dbg_fixed_txp_reduction = TPC_INVALID;
 #endif
+	lq_sta->pers.chains = 0;
+	memset(lq_sta->pers.chain_signal, 0, sizeof(lq_sta->pers.chain_signal));
 
 	return &sta_priv->lq_sta;
 }
@@ -2630,11 +2720,6 @@ void iwl_mvm_rs_rate_init(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
 
 	/* as default allow aggregation for all tids */
 	lq_sta->tx_agg_tid_en = IWL_AGG_ALL_TID;
-
-	/* Set last_txrate_idx to lowest rate */
-	lq_sta->last_txrate_idx = rate_lowest_index(sband, sta);
-	if (sband->band == IEEE80211_BAND_5GHZ)
-		lq_sta->last_txrate_idx += IWL_FIRST_OFDM_RATE;
 	lq_sta->is_agg = 0;
 #ifdef CONFIG_IWLWIFI_DEBUGFS
 	iwl_mvm_reset_frame_stats(mvm, &mvm->drv_rx_stats);
diff --git a/drivers/net/wireless/iwlwifi/mvm/rx.c b/drivers/net/wireless/iwlwifi/mvm/rx.c
index a6cb84e..3cf40f3 100644
--- a/drivers/net/wireless/iwlwifi/mvm/rx.c
+++ b/drivers/net/wireless/iwlwifi/mvm/rx.c
@@ -246,6 +246,7 @@ int iwl_mvm_rx_rx_mpdu(struct iwl_mvm *mvm, struct iwl_rx_cmd_buffer *rxb,
 	struct iwl_rx_packet *pkt = rxb_addr(rxb);
 	struct iwl_rx_phy_info *phy_info;
 	struct iwl_rx_mpdu_res_start *rx_res;
+	struct ieee80211_sta *sta;
 	u32 len;
 	u32 ampdu_status;
 	u32 rate_n_flags;
@@ -261,23 +262,6 @@ int iwl_mvm_rx_rx_mpdu(struct iwl_mvm *mvm, struct iwl_rx_cmd_buffer *rxb,
 	memset(&rx_status, 0, sizeof(rx_status));
 
 	/*
-	 * We have tx blocked stations (with CS bit). If we heard frames from
-	 * a blocked station on a new channel we can TX to it again.
-	 */
-	if (unlikely(mvm->csa_tx_block_bcn_timeout)) {
-		struct ieee80211_sta *sta;
-
-		rcu_read_lock();
-
-		sta = ieee80211_find_sta(
-			rcu_dereference(mvm->csa_tx_blocked_vif), hdr->addr2);
-		if (sta)
-			iwl_mvm_sta_modify_disable_tx_ap(mvm, sta, false);
-
-		rcu_read_unlock();
-	}
-
-	/*
 	 * drop the packet if it has failed being decrypted by HW
 	 */
 	if (iwl_mvm_set_mac80211_rx_flag(mvm, hdr, &rx_status, rx_pkt_status)) {
@@ -325,6 +309,29 @@ int iwl_mvm_rx_rx_mpdu(struct iwl_mvm *mvm, struct iwl_rx_cmd_buffer *rxb,
 	IWL_DEBUG_STATS_LIMIT(mvm, "Rssi %d, TSF %llu\n", rx_status.signal,
 			      (unsigned long long)rx_status.mactime);
 
+	rcu_read_lock();
+	/*
+	 * We have tx blocked stations (with CS bit). If we heard frames from
+	 * a blocked station on a new channel we can TX to it again.
+	 */
+	if (unlikely(mvm->csa_tx_block_bcn_timeout)) {
+		sta = ieee80211_find_sta(
+			rcu_dereference(mvm->csa_tx_blocked_vif), hdr->addr2);
+		if (sta)
+			iwl_mvm_sta_modify_disable_tx_ap(mvm, sta, false);
+	}
+
+	/* This is fine since we don't support multiple AP interfaces */
+	sta = ieee80211_find_sta_by_ifaddr(mvm->hw, hdr->addr2, NULL);
+	if (sta) {
+		struct iwl_mvm_sta *mvmsta;
+		mvmsta = iwl_mvm_sta_from_mac80211(sta);
+		rs_update_last_rssi(mvm, &mvmsta->lq_sta,
+				    &rx_status);
+	}
+
+	rcu_read_unlock();
+
 	/* set the preamble flag if appropriate */
 	if (phy_info->phy_flags & cpu_to_le16(RX_RES_PHY_FLAGS_SHORT_PREAMBLE))
 		rx_status.flag |= RX_FLAG_SHORTPRE;
-- 
1.9.1

