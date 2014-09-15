Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:55347 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750852AbaIOFNI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Sep 2014 01:13:08 -0400
Received: by mail-wi0-f181.google.com with SMTP id bs8so3438733wib.8
        for <linux-wireless@vger.kernel.org>; Sun, 14 Sep 2014 22:13:06 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Eyal Shapira <eyal@wizery.com>,
	Eyal Shapira <eyalx.shapira@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 01/28] iwlwifi: mvm: add LDPC support
Date: Mon, 15 Sep 2014 08:12:33 +0300
Message-Id: <1410757980-2138-1-git-send-email-egrumbach@gmail.com> (sfid-20140915_071312_011612_D0B72E78)
In-Reply-To: <5416742C.3070804@gmail.com>
References: <5416742C.3070804@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eyal Shapira <eyal@wizery.com>

Use LDPC for Tx and publish support for Rx in case the chip
supports LDPC. Enable it for the 7265 family.

Signed-off-by: Eyal Shapira <eyalx.shapira@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-7000.c         | 12 ++++++++---
 drivers/net/wireless/iwlwifi/iwl-config.h       |  2 ++
 drivers/net/wireless/iwlwifi/iwl-eeprom-parse.c |  3 +++
 drivers/net/wireless/iwlwifi/iwl-nvm-parse.c    |  3 +++
 drivers/net/wireless/iwlwifi/mvm/rs.c           | 27 +++++++++++++++++++------
 drivers/net/wireless/iwlwifi/mvm/rs.h           |  2 ++
 6 files changed, 40 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-7000.c b/drivers/net/wireless/iwlwifi/iwl-7000.c
index 8e99dff..79c8f74 100644
--- a/drivers/net/wireless/iwlwifi/iwl-7000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-7000.c
@@ -220,6 +220,12 @@ static const struct iwl_pwr_tx_backoff iwl7265_pwr_tx_backoffs[] = {
 	{0},
 };
 
+static const struct iwl_ht_params iwl7265_ht_params = {
+	.stbc = true,
+	.ldpc = true,
+	.ht40_bands = BIT(IEEE80211_BAND_2GHZ) | BIT(IEEE80211_BAND_5GHZ),
+};
+
 const struct iwl_cfg iwl3165_2ac_cfg = {
 	.name = "Intel(R) Dual Band Wireless AC 3165",
 	.fw_name_pre = IWL3165_FW_PRE,
@@ -234,7 +240,7 @@ const struct iwl_cfg iwl7265_2ac_cfg = {
 	.name = "Intel(R) Dual Band Wireless AC 7265",
 	.fw_name_pre = IWL7265_FW_PRE,
 	IWL_DEVICE_7000,
-	.ht_params = &iwl7000_ht_params,
+	.ht_params = &iwl7265_ht_params,
 	.nvm_ver = IWL7265_NVM_VERSION,
 	.nvm_calib_ver = IWL7265_TX_POWER_VERSION,
 	.pwr_tx_backoffs = iwl7265_pwr_tx_backoffs,
@@ -244,7 +250,7 @@ const struct iwl_cfg iwl7265_2n_cfg = {
 	.name = "Intel(R) Dual Band Wireless N 7265",
 	.fw_name_pre = IWL7265_FW_PRE,
 	IWL_DEVICE_7000,
-	.ht_params = &iwl7000_ht_params,
+	.ht_params = &iwl7265_ht_params,
 	.nvm_ver = IWL7265_NVM_VERSION,
 	.nvm_calib_ver = IWL7265_TX_POWER_VERSION,
 	.pwr_tx_backoffs = iwl7265_pwr_tx_backoffs,
@@ -254,7 +260,7 @@ const struct iwl_cfg iwl7265_n_cfg = {
 	.name = "Intel(R) Wireless N 7265",
 	.fw_name_pre = IWL7265_FW_PRE,
 	IWL_DEVICE_7000,
-	.ht_params = &iwl7000_ht_params,
+	.ht_params = &iwl7265_ht_params,
 	.nvm_ver = IWL7265_NVM_VERSION,
 	.nvm_calib_ver = IWL7265_TX_POWER_VERSION,
 	.pwr_tx_backoffs = iwl7265_pwr_tx_backoffs,
diff --git a/drivers/net/wireless/iwlwifi/iwl-config.h b/drivers/net/wireless/iwlwifi/iwl-config.h
index 3d7cc37..07c0f1f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-config.h
+++ b/drivers/net/wireless/iwlwifi/iwl-config.h
@@ -171,6 +171,7 @@ struct iwl_base_params {
 
 /*
  * @stbc: support Tx STBC and 1*SS Rx STBC
+ * @ldpc: support Tx/Rx with LDPC
  * @use_rts_for_aggregation: use rts/cts protection for HT traffic
  * @ht40_bands: bitmap of bands (using %IEEE80211_BAND_*) that support HT40
  */
@@ -178,6 +179,7 @@ struct iwl_ht_params {
 	enum ieee80211_smps_mode smps_mode;
 	const bool ht_greenfield_support; /* if used set to true */
 	const bool stbc;
+	const bool ldpc;
 	bool use_rts_for_aggregation;
 	u8 ht40_bands;
 };
diff --git a/drivers/net/wireless/iwlwifi/iwl-eeprom-parse.c b/drivers/net/wireless/iwlwifi/iwl-eeprom-parse.c
index 07ff7e0..74b796d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-eeprom-parse.c
+++ b/drivers/net/wireless/iwlwifi/iwl-eeprom-parse.c
@@ -758,6 +758,9 @@ void iwl_init_ht_hw_capab(const struct iwl_cfg *cfg,
 			ht_info->cap |= IEEE80211_HT_CAP_TX_STBC;
 	}
 
+	if (cfg->ht_params->ldpc)
+		ht_info->cap |= IEEE80211_HT_CAP_LDPC_CODING;
+
 	if (iwlwifi_mod_params.amsdu_size_8K)
 		ht_info->cap |= IEEE80211_HT_CAP_MAX_AMSDU;
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-nvm-parse.c b/drivers/net/wireless/iwlwifi/iwl-nvm-parse.c
index 40718f8..c302e74 100644
--- a/drivers/net/wireless/iwlwifi/iwl-nvm-parse.c
+++ b/drivers/net/wireless/iwlwifi/iwl-nvm-parse.c
@@ -334,6 +334,9 @@ static void iwl_init_vht_hw_capab(const struct iwl_cfg *cfg,
 		       3 << IEEE80211_VHT_CAP_BEAMFORMEE_STS_SHIFT |
 		       7 << IEEE80211_VHT_CAP_MAX_A_MPDU_LENGTH_EXPONENT_SHIFT;
 
+	if (cfg->ht_params->ldpc)
+		vht_cap->cap |= IEEE80211_VHT_CAP_RXLDPC;
+
 	if (num_tx_ants > 1)
 		vht_cap->cap |= IEEE80211_VHT_CAP_TXSTBC;
 	else
diff --git a/drivers/net/wireless/iwlwifi/mvm/rs.c b/drivers/net/wireless/iwlwifi/mvm/rs.c
index 17002cf..6a13120 100644
--- a/drivers/net/wireless/iwlwifi/mvm/rs.c
+++ b/drivers/net/wireless/iwlwifi/mvm/rs.c
@@ -505,10 +505,10 @@ static const char *rs_pretty_lq_type(enum iwl_table_type type)
 static inline void rs_dump_rate(struct iwl_mvm *mvm, const struct rs_rate *rate,
 				const char *prefix)
 {
-	IWL_DEBUG_RATE(mvm, "%s: (%s: %d) ANT: %s BW: %d SGI: %d\n",
+	IWL_DEBUG_RATE(mvm, "%s: (%s: %d) ANT: %s BW: %d SGI: %d LDPC: %d\n",
 		       prefix, rs_pretty_lq_type(rate->type),
 		       rate->index, rs_pretty_ant(rate->ant),
-		       rate->bw, rate->sgi);
+		       rate->bw, rate->sgi, rate->ldpc);
 }
 
 static void rs_rate_scale_clear_window(struct iwl_rate_scale_data *window)
@@ -742,6 +742,8 @@ static u32 ucode_rate_from_rs_rate(struct iwl_mvm *mvm,
 	ucode_rate |= rate->bw;
 	if (rate->sgi)
 		ucode_rate |= RATE_MCS_SGI_MSK;
+	if (rate->ldpc)
+		ucode_rate |= RATE_MCS_LDPC_MSK;
 
 	return ucode_rate;
 }
@@ -779,6 +781,8 @@ static int rs_rate_from_ucode_rate(const u32 ucode_rate,
 	/* HT or VHT */
 	if (ucode_rate & RATE_MCS_SGI_MSK)
 		rate->sgi = true;
+	if (ucode_rate & RATE_MCS_LDPC_MSK)
+		rate->ldpc = true;
 
 	rate->bw = ucode_rate & RATE_MCS_CHAN_WIDTH_MSK;
 
@@ -965,13 +969,13 @@ static void rs_get_lower_rate_down_column(struct iwl_lq_sta *lq_sta,
 			     rate->index > IWL_RATE_MCS_9_INDEX);
 
 		rate->index = rs_ht_to_legacy[rate->index];
+		rate->ldpc = false;
 	} else {
 		/* Downgrade to SISO with same MCS if in MIMO  */
 		rate->type = is_vht_mimo2(rate) ?
 			LQ_VHT_SISO : LQ_HT_SISO;
 	}
 
-
 	if (num_of_ant(rate->ant) > 1)
 		rate->ant = first_antenna(mvm->fw->valid_tx_ant);
 
@@ -1621,6 +1625,7 @@ static int rs_switch_to_column(struct iwl_mvm *mvm,
 	}
 
 	rate->bw = rs_bw_from_sta_bw(sta);
+	rate->ldpc = lq_sta->ldpc;
 	search_tbl->column = col_id;
 	rs_set_expected_tpt_table(lq_sta, search_tbl);
 
@@ -2342,6 +2347,7 @@ static void rs_initialize_lq(struct iwl_mvm *mvm,
 	rate->index = i;
 	rate->ant = first_antenna(valid_tx_ant);
 	rate->sgi = false;
+	rate->ldpc = false;
 	rate->bw = RATE_MCS_CHAN_WIDTH_20;
 	if (band == IEEE80211_BAND_5GHZ)
 		rate->type = LQ_LEGACY_A;
@@ -2610,9 +2616,16 @@ void iwl_mvm_rs_rate_init(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
 		lq_sta->active_mimo2_rate <<= IWL_FIRST_OFDM_RATE;
 
 		lq_sta->is_vht = false;
+		if (mvm->cfg->ht_params->ldpc &&
+		    (ht_cap->cap & IEEE80211_HT_CAP_LDPC_CODING))
+			lq_sta->ldpc = true;
 	} else {
 		rs_vht_set_enabled_rates(sta, vht_cap, lq_sta);
 		lq_sta->is_vht = true;
+
+		if (mvm->cfg->ht_params->ldpc &&
+		    (vht_cap->cap & IEEE80211_VHT_CAP_RXLDPC))
+			lq_sta->ldpc = true;
 	}
 
 	lq_sta->max_legacy_rate_idx = find_last_bit(&lq_sta->active_legacy_rate,
@@ -2622,11 +2635,12 @@ void iwl_mvm_rs_rate_init(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
 	lq_sta->max_mimo2_rate_idx = find_last_bit(&lq_sta->active_mimo2_rate,
 						   BITS_PER_LONG);
 
-	IWL_DEBUG_RATE(mvm, "RATE MASK: LEGACY=%lX SISO=%lX MIMO2=%lX VHT=%d\n",
+	IWL_DEBUG_RATE(mvm,
+		       "RATE MASK: LEGACY=%lX SISO=%lX MIMO2=%lX VHT=%d LDPC=%d\n",
 		       lq_sta->active_legacy_rate,
 		       lq_sta->active_siso_rate,
 		       lq_sta->active_mimo2_rate,
-		       lq_sta->is_vht);
+		       lq_sta->is_vht, lq_sta->ldpc);
 	IWL_DEBUG_RATE(mvm, "MAX RATE: LEGACY=%d SISO=%d MIMO2=%d\n",
 		       lq_sta->max_legacy_rate_idx,
 		       lq_sta->max_siso_rate_idx,
@@ -3032,8 +3046,9 @@ static ssize_t rs_sta_dbgfs_scale_table_read(struct file *file,
 				   (is_ht20(rate)) ? "20MHz" :
 				   (is_ht40(rate)) ? "40MHz" :
 				   (is_ht80(rate)) ? "80Mhz" : "BAD BW");
-		   desc += sprintf(buff+desc, " %s %s\n",
+		   desc += sprintf(buff+desc, " %s %s %s\n",
 				   (rate->sgi) ? "SGI" : "NGI",
+				   (rate->ldpc) ? "LDPC" : "BCC",
 				   (lq_sta->is_agg) ? "AGG on" : "");
 	}
 	desc += sprintf(buff+desc, "last tx rate=0x%X\n",
diff --git a/drivers/net/wireless/iwlwifi/mvm/rs.h b/drivers/net/wireless/iwlwifi/mvm/rs.h
index f27b9d6..824a750 100644
--- a/drivers/net/wireless/iwlwifi/mvm/rs.h
+++ b/drivers/net/wireless/iwlwifi/mvm/rs.h
@@ -207,6 +207,7 @@ struct rs_rate {
 	u8 ant;
 	u32 bw;
 	bool sgi;
+	bool ldpc;
 };
 
 
@@ -329,6 +330,7 @@ struct iwl_lq_sta {
 				 */
 	u64 last_tx;
 	bool is_vht;
+	bool ldpc;              /* LDPC Rx is supported by the STA */
 	enum ieee80211_band band;
 
 	struct rs_rate_stats tx_stats[RS_COLUMN_COUNT][IWL_RATE_COUNT];
-- 
1.9.1

