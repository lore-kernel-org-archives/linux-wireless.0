Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:1101 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965181AbbBCHOy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Feb 2015 02:14:54 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Eyal Shapira <eyal@wizery.com>,
	Eyal Shapira <eyalx.shapira@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 06/19] iwlwifi: mvm: add beamformer support
Date: Tue,  3 Feb 2015 09:14:25 +0200
Message-Id: <1422947678-16917-6-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150203_081458_858106_DC2659CE)
In-Reply-To: <1422947482.30742.8.camel@egrumbacBox>
References: <1422947482.30742.8.camel@egrumbacBox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eyal Shapira <eyal@wizery.com>

VHT Beamformer (BFER) will be used if the peer supports it
and there's a benefit to use it vs. STBC or SISO.
The driver now tells the FW whether BFER and/or STBC are
allowed but the FW will make the decision to use either
or stick to SISO on its own.
BFER is limited to a single remote peer. The driver takes
care of ensuring this to the FW and prioritizes with which
peer BFER will be used.

Signed-off-by: Eyal Shapira <eyalx.shapira@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-fw-file.h   |   2 +
 drivers/net/wireless/iwlwifi/mvm/fw-api-rs.h |  35 ++++--
 drivers/net/wireless/iwlwifi/mvm/mac80211.c  |   7 +-
 drivers/net/wireless/iwlwifi/mvm/rs.c        | 157 ++++++++++++++++++++++++---
 drivers/net/wireless/iwlwifi/mvm/rs.h        |   4 +-
 5 files changed, 177 insertions(+), 28 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-fw-file.h b/drivers/net/wireless/iwlwifi/iwl-fw-file.h
index e4f5898..016d913 100644
--- a/drivers/net/wireless/iwlwifi/iwl-fw-file.h
+++ b/drivers/net/wireless/iwlwifi/iwl-fw-file.h
@@ -270,6 +270,7 @@ enum iwl_ucode_tlv_api {
  * @IWL_UCODE_TLV_CAPA_D0I3_SUPPORT: supports D0i3
  * @IWL_UCODE_TLV_CAPA_LAR_SUPPORT: supports Location Aware Regulatory
  * @IWL_UCODE_TLV_CAPA_UMAC_SCAN: supports UMAC scan.
+ * @IWL_UCODE_TLV_CAPA_BEAMFORMER: supports Beamformer
  * @IWL_UCODE_TLV_CAPA_TDLS_SUPPORT: support basic TDLS functionality
  * @IWL_UCODE_TLV_CAPA_TXPOWER_INSERTION_SUPPORT: supports insertion of current
  *	tx power value into TPC Report action frame and Link Measurement Report
@@ -288,6 +289,7 @@ enum iwl_ucode_tlv_capa {
 	IWL_UCODE_TLV_CAPA_D0I3_SUPPORT			= BIT(0),
 	IWL_UCODE_TLV_CAPA_LAR_SUPPORT			= BIT(1),
 	IWL_UCODE_TLV_CAPA_UMAC_SCAN			= BIT(2),
+	IWL_UCODE_TLV_CAPA_BEAMFORMER			= BIT(3),
 	IWL_UCODE_TLV_CAPA_TDLS_SUPPORT			= BIT(6),
 	IWL_UCODE_TLV_CAPA_TXPOWER_INSERTION_SUPPORT	= BIT(8),
 	IWL_UCODE_TLV_CAPA_DS_PARAM_SET_IE_SUPPORT	= BIT(9),
diff --git a/drivers/net/wireless/iwlwifi/mvm/fw-api-rs.h b/drivers/net/wireless/iwlwifi/mvm/fw-api-rs.h
index 6a2a6b0..4c33f27 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw-api-rs.h
+++ b/drivers/net/wireless/iwlwifi/mvm/fw-api-rs.h
@@ -308,16 +308,33 @@ enum {
 #define LQ_FLAG_DYNAMIC_BW_POS          6
 #define LQ_FLAG_DYNAMIC_BW_MSK          (1 << LQ_FLAG_DYNAMIC_BW_POS)
 
-/* Single Stream Parameters
- * SS_STBC/BFER_ALLOWED - Controls whether STBC or Beamformer (BFER) is allowed
- * ucode will make a smart decision between SISO/STBC/BFER
- * SS_PARAMS_VALID - if not set ignore the ss_params field.
+/* Single Stream Tx Parameters (lq_cmd->ss_params)
+ * Flags to control a smart FW decision about whether BFER/STBC/SISO will be
+ * used for single stream Tx.
  */
-enum {
-	RS_SS_STBC_ALLOWED = BIT(0),
-	RS_SS_BFER_ALLOWED = BIT(1),
-	RS_SS_PARAMS_VALID = BIT(31),
-};
+
+/* Bit 0-1: Max STBC streams allowed. Can be 0-3.
+ * (0) - No STBC allowed
+ * (1) - 2x1 STBC allowed (HT/VHT)
+ * (2) - 4x2 STBC allowed (HT/VHT)
+ * (3) - 3x2 STBC allowed (HT only)
+ * All our chips are at most 2 antennas so only (1) is valid for now.
+ */
+#define LQ_SS_STBC_ALLOWED_POS          0
+#define LQ_SS_STBC_ALLOWED_MSK		(3 << LQ_SS_STBC_ALLOWED_MSK)
+
+/* 2x1 STBC is allowed */
+#define LQ_SS_STBC_1SS_ALLOWED		(1 << LQ_SS_STBC_ALLOWED_POS)
+
+/* Bit 2: Beamformer (VHT only) is allowed */
+#define LQ_SS_BFER_ALLOWED_POS		2
+#define LQ_SS_BFER_ALLOWED		(1 << LQ_SS_BFER_ALLOWED_POS)
+
+/* Bit 31: ss_params field is valid. Used for FW backward compatibility
+ * with other drivers which don't support the ss_params API yet
+ */
+#define LQ_SS_PARAMS_VALID_POS		31
+#define LQ_SS_PARAMS_VALID		(1 << LQ_SS_PARAMS_VALID_POS)
 
 /**
  * struct iwl_lq_cmd - link quality command
diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index cfd7bfc..51e02e6 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -401,10 +401,15 @@ int iwl_mvm_mac_setup_register(struct iwl_mvm *mvm)
 	if (mvm->nvm_data->bands[IEEE80211_BAND_2GHZ].n_channels)
 		hw->wiphy->bands[IEEE80211_BAND_2GHZ] =
 			&mvm->nvm_data->bands[IEEE80211_BAND_2GHZ];
-	if (mvm->nvm_data->bands[IEEE80211_BAND_5GHZ].n_channels)
+	if (mvm->nvm_data->bands[IEEE80211_BAND_5GHZ].n_channels) {
 		hw->wiphy->bands[IEEE80211_BAND_5GHZ] =
 			&mvm->nvm_data->bands[IEEE80211_BAND_5GHZ];
 
+		if (mvm->fw->ucode_capa.capa[0] & IWL_UCODE_TLV_CAPA_BEAMFORMER)
+			hw->wiphy->bands[IEEE80211_BAND_5GHZ]->vht_cap.cap |=
+				IEEE80211_VHT_CAP_SU_BEAMFORMER_CAPABLE;
+	}
+
 	hw->wiphy->hw_version = mvm->trans->hw_id;
 
 	if (iwlmvm_mod_params.power_scheme != IWL_POWER_SCHEME_CAM)
diff --git a/drivers/net/wireless/iwlwifi/mvm/rs.c b/drivers/net/wireless/iwlwifi/mvm/rs.c
index 9f32f2d..95b718b 100644
--- a/drivers/net/wireless/iwlwifi/mvm/rs.c
+++ b/drivers/net/wireless/iwlwifi/mvm/rs.c
@@ -1805,7 +1805,7 @@ static bool rs_stbc_allow(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
 	/* Our chip supports Tx STBC and the peer is an HT/VHT STA which
 	 * supports STBC of at least 1*SS
 	 */
-	if (!lq_sta->stbc)
+	if (!lq_sta->stbc_capable)
 		return false;
 
 	if (!iwl_mvm_bt_coex_is_mimo_allowed(mvm, sta))
@@ -2626,7 +2626,7 @@ static void rs_ht_init(struct iwl_mvm *mvm,
 	if (mvm->cfg->ht_params->stbc &&
 	    (num_of_ant(iwl_mvm_get_valid_tx_ant(mvm)) > 1) &&
 	    (ht_cap->cap & IEEE80211_HT_CAP_RX_STBC))
-		lq_sta->stbc = true;
+		lq_sta->stbc_capable = true;
 
 	lq_sta->is_vht = false;
 }
@@ -2645,7 +2645,12 @@ static void rs_vht_init(struct iwl_mvm *mvm,
 	if (mvm->cfg->ht_params->stbc &&
 	    (num_of_ant(iwl_mvm_get_valid_tx_ant(mvm)) > 1) &&
 	    (vht_cap->cap & IEEE80211_VHT_CAP_RXSTBC_MASK))
-		lq_sta->stbc = true;
+		lq_sta->stbc_capable = true;
+
+	if ((mvm->fw->ucode_capa.capa[0] & IWL_UCODE_TLV_CAPA_BEAMFORMER) &&
+	    (num_of_ant(iwl_mvm_get_valid_tx_ant(mvm)) > 1) &&
+	    (vht_cap->cap & IEEE80211_VHT_CAP_SU_BEAMFORMEE_CAPABLE))
+		lq_sta->bfer_capable = true;
 
 	lq_sta->is_vht = true;
 }
@@ -2778,11 +2783,12 @@ void iwl_mvm_rs_rate_init(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
 		rs_get_max_rate_from_mask(lq_sta->active_mimo2_rate);
 
 	IWL_DEBUG_RATE(mvm,
-		       "RATE MASK: LEGACY=%lX SISO=%lX MIMO2=%lX VHT=%d LDPC=%d STBC=%d\n",
+		       "LEGACY=%lX SISO=%lX MIMO2=%lX VHT=%d LDPC=%d STBC=%d BFER=%d\n",
 		       lq_sta->active_legacy_rate,
 		       lq_sta->active_siso_rate,
 		       lq_sta->active_mimo2_rate,
-		       lq_sta->is_vht, lq_sta->ldpc, lq_sta->stbc);
+		       lq_sta->is_vht, lq_sta->ldpc, lq_sta->stbc_capable,
+		       lq_sta->bfer_capable);
 	IWL_DEBUG_RATE(mvm, "MAX RATE: LEGACY=%d SISO=%d MIMO2=%d\n",
 		       lq_sta->max_legacy_rate_idx,
 		       lq_sta->max_siso_rate_idx,
@@ -2916,23 +2922,15 @@ static void rs_build_rates_table(struct iwl_mvm *mvm,
 	u8 valid_tx_ant = 0;
 	struct iwl_lq_cmd *lq_cmd = &lq_sta->lq;
 	bool toggle_ant = false;
-	bool stbc_allowed = false;
 
 	memcpy(&rate, initial_rate, sizeof(rate));
 
 	valid_tx_ant = iwl_mvm_get_valid_tx_ant(mvm);
 
-	stbc_allowed = rs_stbc_allow(mvm, sta, lq_sta);
-	if (mvm->fw->ucode_capa.api[0] & IWL_UCODE_TLV_API_LQ_SS_PARAMS) {
-		u32 ss_params = RS_SS_PARAMS_VALID;
-
-		if (stbc_allowed)
-			ss_params |= RS_SS_STBC_ALLOWED;
-		lq_cmd->ss_params = cpu_to_le32(ss_params);
-	} else {
-		/* TODO: remove old API when min FW API hits 14 */
-		rate.stbc = stbc_allowed;
-	}
+	/* TODO: remove old API when min FW API hits 14 */
+	if (!(mvm->fw->ucode_capa.api[0] & IWL_UCODE_TLV_API_LQ_SS_PARAMS) &&
+	    rs_stbc_allow(mvm, sta, lq_sta))
+		rate.stbc = true;
 
 	if (is_siso(&rate)) {
 		num_rates = IWL_MVM_RS_INITIAL_SISO_NUM_RATES;
@@ -2980,6 +2978,128 @@ static void rs_build_rates_table(struct iwl_mvm *mvm,
 
 }
 
+struct rs_bfer_active_iter_data {
+	struct ieee80211_sta *exclude_sta;
+	struct iwl_mvm_sta *bfer_mvmsta;
+};
+
+static void rs_bfer_active_iter(void *_data,
+				struct ieee80211_sta *sta)
+{
+	struct rs_bfer_active_iter_data *data = _data;
+	struct iwl_mvm_sta *mvmsta = iwl_mvm_sta_from_mac80211(sta);
+	struct iwl_lq_cmd *lq_cmd = &mvmsta->lq_sta.lq;
+	u32 ss_params = le32_to_cpu(lq_cmd->ss_params);
+
+	if (sta == data->exclude_sta)
+		return;
+
+	/* The current sta has BFER allowed */
+	if (ss_params & LQ_SS_BFER_ALLOWED) {
+		WARN_ON_ONCE(data->bfer_mvmsta != NULL);
+
+		data->bfer_mvmsta = mvmsta;
+	}
+}
+
+static int rs_bfer_priority(struct iwl_mvm_sta *sta)
+{
+	int prio = -1;
+	enum nl80211_iftype viftype = ieee80211_vif_type_p2p(sta->vif);
+
+	switch (viftype) {
+	case NL80211_IFTYPE_AP:
+	case NL80211_IFTYPE_P2P_GO:
+		prio = 3;
+		break;
+	case NL80211_IFTYPE_P2P_CLIENT:
+		prio = 2;
+		break;
+	case NL80211_IFTYPE_STATION:
+		prio = 1;
+		break;
+	default:
+		WARN_ONCE(true, "viftype %d sta_id %d", viftype, sta->sta_id);
+		prio = -1;
+	}
+
+	return prio;
+}
+
+/* Returns >0 if sta1 has a higher BFER priority compared to sta2 */
+static int rs_bfer_priority_cmp(struct iwl_mvm_sta *sta1,
+				struct iwl_mvm_sta *sta2)
+{
+	int prio1 = rs_bfer_priority(sta1);
+	int prio2 = rs_bfer_priority(sta2);
+
+	if (prio1 > prio2)
+		return 1;
+	if (prio1 < prio2)
+		return -1;
+	return 0;
+}
+
+static void rs_set_lq_ss_params(struct iwl_mvm *mvm,
+				struct ieee80211_sta *sta,
+				struct iwl_lq_sta *lq_sta,
+				const struct rs_rate *initial_rate)
+{
+	struct iwl_lq_cmd *lq_cmd = &lq_sta->lq;
+	struct iwl_mvm_sta *mvmsta = iwl_mvm_sta_from_mac80211(sta);
+	struct rs_bfer_active_iter_data data = {
+		.exclude_sta = sta,
+		.bfer_mvmsta = NULL,
+	};
+	struct iwl_mvm_sta *bfer_mvmsta = NULL;
+	u32 ss_params = LQ_SS_PARAMS_VALID;
+
+	if (!iwl_mvm_bt_coex_is_mimo_allowed(mvm, sta))
+		goto out;
+
+	if (lq_sta->stbc_capable)
+		ss_params |= LQ_SS_STBC_1SS_ALLOWED;
+
+	if (!lq_sta->bfer_capable)
+		goto out;
+
+	ieee80211_iterate_stations_atomic(mvm->hw,
+					  rs_bfer_active_iter,
+					  &data);
+	bfer_mvmsta = data.bfer_mvmsta;
+
+	/* This code is safe as it doesn't run concurrently for different
+	 * stations. This is guaranteed by the fact that calls to
+	 * ieee80211_tx_status wouldn't run concurrently for a single HW.
+	 */
+	if (!bfer_mvmsta) {
+		IWL_DEBUG_RATE(mvm, "No sta with BFER allowed found. Allow\n");
+
+		ss_params |= LQ_SS_BFER_ALLOWED;
+		goto out;
+	}
+
+	IWL_DEBUG_RATE(mvm, "Found existing sta %d with BFER activated\n",
+		       bfer_mvmsta->sta_id);
+
+	/* Disallow BFER on another STA if active and we're a higher priority */
+	if (rs_bfer_priority_cmp(mvmsta, bfer_mvmsta) > 0) {
+		struct iwl_lq_cmd *bfersta_lq_cmd = &bfer_mvmsta->lq_sta.lq;
+		u32 bfersta_ss_params = le32_to_cpu(bfersta_lq_cmd->ss_params);
+
+		bfersta_ss_params &= ~LQ_SS_BFER_ALLOWED;
+		bfersta_lq_cmd->ss_params = cpu_to_le32(bfersta_ss_params);
+		iwl_mvm_send_lq_cmd(mvm, bfersta_lq_cmd, false);
+
+		ss_params |= LQ_SS_BFER_ALLOWED;
+		IWL_DEBUG_RATE(mvm,
+			       "Lower priority BFER sta found (%d). Switch BFER\n",
+			       bfer_mvmsta->sta_id);
+	}
+out:
+	lq_cmd->ss_params = cpu_to_le32(ss_params);
+}
+
 static void rs_fill_lq_cmd(struct iwl_mvm *mvm,
 			   struct ieee80211_sta *sta,
 			   struct iwl_lq_sta *lq_sta,
@@ -3006,6 +3126,9 @@ static void rs_fill_lq_cmd(struct iwl_mvm *mvm,
 
 	rs_build_rates_table(mvm, sta, lq_sta, initial_rate);
 
+	if (mvm->fw->ucode_capa.api[0] & IWL_UCODE_TLV_API_LQ_SS_PARAMS)
+		rs_set_lq_ss_params(mvm, sta, lq_sta, initial_rate);
+
 	if (num_of_ant(initial_rate->ant) == 1)
 		lq_cmd->single_stream_ant_msk = initial_rate->ant;
 
diff --git a/drivers/net/wireless/iwlwifi/mvm/rs.h b/drivers/net/wireless/iwlwifi/mvm/rs.h
index f8f5bf2..ba57f5a 100644
--- a/drivers/net/wireless/iwlwifi/mvm/rs.h
+++ b/drivers/net/wireless/iwlwifi/mvm/rs.h
@@ -293,7 +293,9 @@ struct iwl_lq_sta {
 	u64 last_tx;
 	bool is_vht;
 	bool ldpc;              /* LDPC Rx is supported by the STA */
-	bool stbc;              /* Tx STBC is supported by chip and Rx by STA */
+	bool stbc_capable;      /* Tx STBC is supported by chip and Rx by STA */
+	bool bfer_capable;      /* Remote supports beamformee and we BFer */
+
 	enum ieee80211_band band;
 
 	/* The following are bitmaps of rates; IWL_RATE_6M_MASK, etc. */
-- 
1.9.1

