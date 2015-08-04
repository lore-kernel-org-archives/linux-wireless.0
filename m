Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:37362 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752128AbbHDU6y (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Aug 2015 16:58:54 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Eyal Shapira <eyal@wizery.com>,
	Eyal Shapira <eyalx.shapira@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 01/37] iwlwifi: mvm: rs: report last tx rate based on RSSI and caps
Date: Tue,  4 Aug 2015 23:42:51 +0300
Message-Id: <1438721007-23283-1-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150804_225901_040136_E229E977)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E7E11FA@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32E7E11FA@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eyal Shapira <eyal@wizery.com>

In scenarios where we haven't converged yet to a specific modulation
and rate it could be better to report to userspace the last tx rate
based on the STA capabilities and RSSI. This is important as sometimes
userspace displays the last tx rate as the link speed.
This avoids being presented with low legacy rates when rs just begins
its search or after an idle period in which it resets itself.

Signed-off-by: Eyal Shapira <eyalx.shapira@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/rs.c | 157 ++++++++++++++++++++++++++++++++--
 drivers/net/wireless/iwlwifi/mvm/rs.h |  10 +++
 2 files changed, 160 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/rs.c b/drivers/net/wireless/iwlwifi/mvm/rs.c
index daff1d0..19a7926 100644
--- a/drivers/net/wireless/iwlwifi/mvm/rs.c
+++ b/drivers/net/wireless/iwlwifi/mvm/rs.c
@@ -2403,7 +2403,7 @@ struct rs_init_rate_info {
 	u8 rate_idx;
 };
 
-static const struct rs_init_rate_info rs_init_rates_24ghz[] = {
+static const struct rs_init_rate_info rs_optimal_rates_24ghz_legacy[] = {
 	{ -60, IWL_RATE_54M_INDEX },
 	{ -64, IWL_RATE_48M_INDEX },
 	{ -68, IWL_RATE_36M_INDEX },
@@ -2416,7 +2416,7 @@ static const struct rs_init_rate_info rs_init_rates_24ghz[] = {
 	{ S8_MIN, IWL_RATE_1M_INDEX },
 };
 
-static const struct rs_init_rate_info rs_init_rates_5ghz[] = {
+static const struct rs_init_rate_info rs_optimal_rates_5ghz_legacy[] = {
 	{ -60, IWL_RATE_54M_INDEX },
 	{ -64, IWL_RATE_48M_INDEX },
 	{ -72, IWL_RATE_36M_INDEX },
@@ -2427,6 +2427,124 @@ static const struct rs_init_rate_info rs_init_rates_5ghz[] = {
 	{ S8_MIN, IWL_RATE_6M_INDEX },
 };
 
+static const struct rs_init_rate_info rs_optimal_rates_ht[] = {
+	{ -60, IWL_RATE_MCS_7_INDEX },
+	{ -64, IWL_RATE_MCS_6_INDEX },
+	{ -68, IWL_RATE_MCS_5_INDEX },
+	{ -72, IWL_RATE_MCS_4_INDEX },
+	{ -80, IWL_RATE_MCS_3_INDEX },
+	{ -84, IWL_RATE_MCS_2_INDEX },
+	{ -85, IWL_RATE_MCS_1_INDEX },
+	{ S8_MIN, IWL_RATE_MCS_0_INDEX},
+};
+
+static const struct rs_init_rate_info rs_optimal_rates_vht_20mhz[] = {
+	{ -60, IWL_RATE_MCS_8_INDEX },
+	{ -64, IWL_RATE_MCS_7_INDEX },
+	{ -68, IWL_RATE_MCS_6_INDEX },
+	{ -72, IWL_RATE_MCS_5_INDEX },
+	{ -80, IWL_RATE_MCS_4_INDEX },
+	{ -84, IWL_RATE_MCS_3_INDEX },
+	{ -85, IWL_RATE_MCS_2_INDEX },
+	{ -87, IWL_RATE_MCS_1_INDEX },
+	{ S8_MIN, IWL_RATE_MCS_0_INDEX},
+};
+
+static const struct rs_init_rate_info rs_optimal_rates_vht_40_80mhz[] = {
+	{ -60, IWL_RATE_MCS_9_INDEX },
+	{ -64, IWL_RATE_MCS_8_INDEX },
+	{ -68, IWL_RATE_MCS_7_INDEX },
+	{ -72, IWL_RATE_MCS_6_INDEX },
+	{ -80, IWL_RATE_MCS_5_INDEX },
+	{ -84, IWL_RATE_MCS_4_INDEX },
+	{ -85, IWL_RATE_MCS_3_INDEX },
+	{ -87, IWL_RATE_MCS_2_INDEX },
+	{ -88, IWL_RATE_MCS_1_INDEX },
+	{ S8_MIN, IWL_RATE_MCS_0_INDEX },
+};
+
+/* Init the optimal rate based on STA caps
+ * This combined with rssi is used to report the last tx rate
+ * to userspace when we haven't transmitted enough frames.
+ */
+static void rs_init_optimal_rate(struct iwl_mvm *mvm,
+				 struct ieee80211_sta *sta,
+				 struct iwl_lq_sta *lq_sta)
+{
+	struct rs_rate *rate = &lq_sta->optimal_rate;
+
+	if (lq_sta->max_mimo2_rate_idx != IWL_RATE_INVALID)
+		rate->type = lq_sta->is_vht ? LQ_VHT_MIMO2 : LQ_HT_MIMO2;
+	else if (lq_sta->max_siso_rate_idx != IWL_RATE_INVALID)
+		rate->type = lq_sta->is_vht ? LQ_VHT_SISO : LQ_HT_SISO;
+	else if (lq_sta->band == IEEE80211_BAND_5GHZ)
+		rate->type = LQ_LEGACY_A;
+	else
+		rate->type = LQ_LEGACY_G;
+
+	rate->bw = rs_bw_from_sta_bw(sta);
+	rate->sgi = rs_sgi_allow(mvm, sta, rate, NULL);
+
+	/* ANT/LDPC/STBC aren't relevant for the rate reported to userspace */
+
+	if (is_mimo(rate)) {
+		lq_sta->optimal_rate_mask = lq_sta->active_mimo2_rate;
+	} else if (is_siso(rate)) {
+		lq_sta->optimal_rate_mask = lq_sta->active_siso_rate;
+	} else {
+		lq_sta->optimal_rate_mask = lq_sta->active_legacy_rate;
+
+		if (lq_sta->band == IEEE80211_BAND_5GHZ) {
+			lq_sta->optimal_rates = rs_optimal_rates_5ghz_legacy;
+			lq_sta->optimal_nentries =
+				ARRAY_SIZE(rs_optimal_rates_5ghz_legacy);
+		} else {
+			lq_sta->optimal_rates = rs_optimal_rates_24ghz_legacy;
+			lq_sta->optimal_nentries =
+				ARRAY_SIZE(rs_optimal_rates_24ghz_legacy);
+		}
+	}
+
+	if (is_vht(rate)) {
+		if (rate->bw == RATE_MCS_CHAN_WIDTH_20) {
+			lq_sta->optimal_rates = rs_optimal_rates_vht_20mhz;
+			lq_sta->optimal_nentries =
+				ARRAY_SIZE(rs_optimal_rates_vht_20mhz);
+		} else {
+			lq_sta->optimal_rates = rs_optimal_rates_vht_40_80mhz;
+			lq_sta->optimal_nentries =
+				ARRAY_SIZE(rs_optimal_rates_vht_40_80mhz);
+		}
+	} else if (is_ht(rate)) {
+		lq_sta->optimal_rates = rs_optimal_rates_ht;
+		lq_sta->optimal_nentries = ARRAY_SIZE(rs_optimal_rates_ht);
+	}
+}
+
+/* Compute the optimal rate index based on RSSI */
+static struct rs_rate *rs_get_optimal_rate(struct iwl_mvm *mvm,
+					   struct iwl_lq_sta *lq_sta)
+{
+	struct rs_rate *rate = &lq_sta->optimal_rate;
+	int i;
+
+	rate->index = find_first_bit(&lq_sta->optimal_rate_mask,
+				     BITS_PER_LONG);
+
+	for (i = 0; i < lq_sta->optimal_nentries; i++) {
+		int rate_idx = lq_sta->optimal_rates[i].rate_idx;
+
+		if ((lq_sta->pers.last_rssi >= lq_sta->optimal_rates[i].rssi) &&
+		    (BIT(rate_idx) & lq_sta->optimal_rate_mask)) {
+			rate->index = rate_idx;
+			break;
+		}
+	}
+
+	rs_dump_rate(mvm, rate, "OPTIMAL RATE");
+	return rate;
+}
+
 /* Choose an initial legacy rate and antenna to use based on the RSSI
  * of last Rx
  */
@@ -2468,12 +2586,12 @@ static void rs_get_initial_rate(struct iwl_mvm *mvm,
 
 	if (band == IEEE80211_BAND_5GHZ) {
 		rate->type = LQ_LEGACY_A;
-		initial_rates = rs_init_rates_5ghz;
-		nentries = ARRAY_SIZE(rs_init_rates_5ghz);
+		initial_rates = rs_optimal_rates_5ghz_legacy;
+		nentries = ARRAY_SIZE(rs_optimal_rates_5ghz_legacy);
 	} else {
 		rate->type = LQ_LEGACY_G;
-		initial_rates = rs_init_rates_24ghz;
-		nentries = ARRAY_SIZE(rs_init_rates_24ghz);
+		initial_rates = rs_optimal_rates_24ghz_legacy;
+		nentries = ARRAY_SIZE(rs_optimal_rates_24ghz_legacy);
 	}
 
 	if (IWL_MVM_RS_RSSI_BASED_INIT_RATE) {
@@ -2496,10 +2614,21 @@ void rs_update_last_rssi(struct iwl_mvm *mvm,
 			 struct iwl_lq_sta *lq_sta,
 			 struct ieee80211_rx_status *rx_status)
 {
+	int i;
+
 	lq_sta->pers.chains = rx_status->chains;
 	lq_sta->pers.chain_signal[0] = rx_status->chain_signal[0];
 	lq_sta->pers.chain_signal[1] = rx_status->chain_signal[1];
 	lq_sta->pers.chain_signal[2] = rx_status->chain_signal[2];
+	lq_sta->pers.last_rssi = S8_MIN;
+
+	for (i = 0; i < ARRAY_SIZE(lq_sta->pers.chain_signal); i++) {
+		if (!(lq_sta->pers.chains & BIT(i)))
+			continue;
+
+		if (lq_sta->pers.chain_signal[i] > lq_sta->pers.last_rssi)
+			lq_sta->pers.last_rssi = lq_sta->pers.chain_signal[i];
+	}
 }
 
 /**
@@ -2538,6 +2667,7 @@ static void rs_initialize_lq(struct iwl_mvm *mvm,
 	rate = &tbl->rate;
 
 	rs_get_initial_rate(mvm, lq_sta, band, rate);
+	rs_init_optimal_rate(mvm, sta, lq_sta);
 
 	WARN_ON_ONCE(rate->ant != ANT_A && rate->ant != ANT_B);
 	if (rate->ant == ANT_A)
@@ -2560,6 +2690,8 @@ static void rs_get_rate(void *mvm_r, struct ieee80211_sta *sta, void *mvm_sta,
 	struct iwl_mvm *mvm __maybe_unused = IWL_OP_MODE_GET_MVM(op_mode);
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	struct iwl_lq_sta *lq_sta = mvm_sta;
+	struct rs_rate *optimal_rate;
+	u32 last_ucode_rate;
 
 	if (sta && !iwl_mvm_sta_from_mac80211(sta)->vif) {
 		/* if vif isn't initialized mvm doesn't know about
@@ -2583,8 +2715,18 @@ static void rs_get_rate(void *mvm_r, struct ieee80211_sta *sta, void *mvm_sta,
 
 	iwl_mvm_hwrate_to_tx_rate(lq_sta->last_rate_n_flags,
 				  info->band, &info->control.rates[0]);
-
 	info->control.rates[0].count = 1;
+
+	/* Report the optimal rate based on rssi and STA caps if we haven't
+	 * converged yet (too little traffic) or exploring other modulations
+	 */
+	if (lq_sta->rs_state != RS_STATE_STAY_IN_COLUMN) {
+		optimal_rate = rs_get_optimal_rate(mvm, lq_sta);
+		last_ucode_rate = ucode_rate_from_rs_rate(mvm,
+							  optimal_rate);
+		iwl_mvm_hwrate_to_tx_rate(last_ucode_rate, info->band,
+					  &txrc->reported_rate);
+	}
 }
 
 static void *rs_alloc_sta(void *mvm_rate, struct ieee80211_sta *sta,
@@ -2605,6 +2747,7 @@ static void *rs_alloc_sta(void *mvm_rate, struct ieee80211_sta *sta,
 #endif
 	lq_sta->pers.chains = 0;
 	memset(lq_sta->pers.chain_signal, 0, sizeof(lq_sta->pers.chain_signal));
+	lq_sta->pers.last_rssi = S8_MIN;
 
 	return &sta_priv->lq_sta;
 }
diff --git a/drivers/net/wireless/iwlwifi/mvm/rs.h b/drivers/net/wireless/iwlwifi/mvm/rs.h
index 2a3da31..81314ad 100644
--- a/drivers/net/wireless/iwlwifi/mvm/rs.h
+++ b/drivers/net/wireless/iwlwifi/mvm/rs.h
@@ -1,6 +1,7 @@
 /******************************************************************************
  *
  * Copyright(c) 2003 - 2014 Intel Corporation. All rights reserved.
+ * Copyright(c) 2015 Intel Mobile Communications GmbH
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of version 2 of the GNU General Public License as
@@ -316,6 +317,14 @@ struct iwl_lq_sta {
 	u8 max_siso_rate_idx;
 	u8 max_mimo2_rate_idx;
 
+	/* Optimal rate based on RSSI and STA caps.
+	 * Used only to reflect link speed to userspace.
+	 */
+	struct rs_rate optimal_rate;
+	unsigned long optimal_rate_mask;
+	const struct rs_init_rate_info *optimal_rates;
+	int optimal_nentries;
+
 	u8 missed_rate_counter;
 
 	struct iwl_lq_cmd lq;
@@ -341,6 +350,7 @@ struct iwl_lq_sta {
 #endif
 		u8 chains;
 		s8 chain_signal[IEEE80211_MAX_CHAINS];
+		s8 last_rssi;
 		struct rs_rate_stats tx_stats[RS_COLUMN_COUNT][IWL_RATE_COUNT];
 		struct iwl_mvm *drv;
 	} pers;
-- 
2.1.4

