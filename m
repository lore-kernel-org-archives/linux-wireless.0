Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:37368 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754824AbbHDU7H (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Aug 2015 16:59:07 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Sara Sharon <sara.sharon@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 18/37] iwlwifi: mvm: remove IWL_UCODE_TLV_API_BASIC_DWELL
Date: Tue,  4 Aug 2015 23:43:08 +0300
Message-Id: <1438721007-23283-18-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150804_230717_213555_2442190A)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E7E11FA@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32E7E11FA@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

All the supported firmwares support this API.
This includes removing dwell per band, as band is no longer a factor
in calculating the dwell. Only basic dwell is used and FW will calculate
the actual dwell time.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-fw-file.h |  4 --
 drivers/net/wireless/iwlwifi/mvm/scan.c    | 86 +++++++-----------------------
 2 files changed, 20 insertions(+), 70 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-fw-file.h b/drivers/net/wireless/iwlwifi/iwl-fw-file.h
index a9b5ae4..1c6f7b9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-fw-file.h
+++ b/drivers/net/wireless/iwlwifi/iwl-fw-file.h
@@ -247,9 +247,6 @@ typedef unsigned int __bitwise__ iwl_ucode_tlv_api_t;
  * @IWL_UCODE_TLV_API_WIFI_MCC_UPDATE: ucode supports MCC updates with source.
  * IWL_UCODE_TLV_API_HDC_PHASE_0: ucode supports finer configuration of LTR
  * @IWL_UCODE_TLV_API_TX_POWER_DEV: new API for tx power.
- * @IWL_UCODE_TLV_API_BASIC_DWELL: use only basic dwell time in scan command,
- *	regardless of the band or the number of the probes. FW will calculate
- *	the actual dwell time.
  * @IWL_UCODE_TLV_API_SCD_CFG: This firmware can configure the scheduler
  *	through the dedicated host command.
  * @IWL_UCODE_TLV_API_SINGLE_SCAN_EBS: EBS is supported for single scans too.
@@ -266,7 +263,6 @@ enum iwl_ucode_tlv_api {
 	IWL_UCODE_TLV_API_WIFI_MCC_UPDATE	= (__force iwl_ucode_tlv_api_t)9,
 	IWL_UCODE_TLV_API_HDC_PHASE_0		= (__force iwl_ucode_tlv_api_t)10,
 	IWL_UCODE_TLV_API_TX_POWER_DEV		= (__force iwl_ucode_tlv_api_t)11,
-	IWL_UCODE_TLV_API_BASIC_DWELL		= (__force iwl_ucode_tlv_api_t)13,
 	IWL_UCODE_TLV_API_SCD_CFG		= (__force iwl_ucode_tlv_api_t)15,
 	IWL_UCODE_TLV_API_SINGLE_SCAN_EBS	= (__force iwl_ucode_tlv_api_t)16,
 	IWL_UCODE_TLV_API_ASYNC_DTM		= (__force iwl_ucode_tlv_api_t)17,
diff --git a/drivers/net/wireless/iwlwifi/mvm/scan.c b/drivers/net/wireless/iwlwifi/mvm/scan.c
index 9c70118..b891fa5 100644
--- a/drivers/net/wireless/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/iwlwifi/mvm/scan.c
@@ -90,11 +90,9 @@ struct iwl_mvm_scan_params {
 	int n_match_sets;
 	struct iwl_scan_probe_req preq;
 	struct cfg80211_match_set *match_sets;
-	struct _dwell {
-		u16 passive;
-		u16 active;
-		u16 fragmented;
-	} dwell[IEEE80211_NUM_BANDS];
+	u16 passive_dwell;
+	u16 active_dwell;
+	u16 fragmented_dwell;
 	struct {
 		u8 iterations;
 		u8 full_scan_mul; /* not used for UMAC */
@@ -147,34 +145,6 @@ iwl_mvm_scan_rate_n_flags(struct iwl_mvm *mvm, enum ieee80211_band band,
 		return cpu_to_le32(IWL_RATE_6M_PLCP | tx_ant);
 }
 
-/*
- * If req->n_ssids > 0, it means we should do an active scan.
- * In case of active scan w/o directed scan, we receive a zero-length SSID
- * just to notify that this scan is active and not passive.
- * In order to notify the FW of the number of SSIDs we wish to scan (including
- * the zero-length one), we need to set the corresponding bits in chan->type,
- * one for each SSID, and set the active bit (first). If the first SSID is
- * already included in the probe template, so we need to set only
- * req->n_ssids - 1 bits in addition to the first bit.
- */
-static u16 iwl_mvm_get_active_dwell(struct iwl_mvm *mvm,
-				    enum ieee80211_band band, int n_ssids)
-{
-	if (fw_has_api(&mvm->fw->ucode_capa, IWL_UCODE_TLV_API_BASIC_DWELL))
-		return 10;
-	if (band == IEEE80211_BAND_2GHZ)
-		return 20  + 3 * (n_ssids + 1);
-	return 10  + 2 * (n_ssids + 1);
-}
-
-static u16 iwl_mvm_get_passive_dwell(struct iwl_mvm *mvm,
-				     enum ieee80211_band band)
-{
-	if (fw_has_api(&mvm->fw->ucode_capa, IWL_UCODE_TLV_API_BASIC_DWELL))
-			return 110;
-	return band == IEEE80211_BAND_2GHZ ? 100 + 20 : 100 + 10;
-}
-
 static void iwl_mvm_scan_condition_iterator(void *data, u8 *mac,
 					    struct ieee80211_vif *vif)
 {
@@ -191,7 +161,6 @@ static void iwl_mvm_scan_calc_dwell(struct iwl_mvm *mvm,
 				    struct iwl_mvm_scan_params *params)
 {
 	int global_cnt = 0;
-	enum ieee80211_band band;
 	u8 frag_passive_dwell = 0;
 
 	ieee80211_iterate_active_interfaces_atomic(mvm->hw,
@@ -227,14 +196,10 @@ static void iwl_mvm_scan_calc_dwell(struct iwl_mvm *mvm,
 		/*
 		 * P2P device scan should not be fragmented to avoid negative
 		 * impact on P2P device discovery. Configure max_out_time to be
-		 * equal to dwell time on passive channel. Take a longest
-		 * possible value, one that corresponds to 2GHz band
+		 * equal to dwell time on passive channel.
 		 */
 		if (vif->type == NL80211_IFTYPE_P2P_DEVICE) {
-			u32 passive_dwell =
-				iwl_mvm_get_passive_dwell(mvm,
-							  IEEE80211_BAND_2GHZ);
-			params->max_out_time = passive_dwell;
+			params->max_out_time = 120;
 		} else {
 			params->passive_fragmented = true;
 		}
@@ -246,30 +211,21 @@ static void iwl_mvm_scan_calc_dwell(struct iwl_mvm *mvm,
 
 not_bound:
 
-	for (band = IEEE80211_BAND_2GHZ; band < IEEE80211_NUM_BANDS; band++) {
-		if (params->passive_fragmented)
-			params->dwell[band].fragmented = frag_passive_dwell;
+	if (params->passive_fragmented)
+		params->fragmented_dwell = frag_passive_dwell;
+
+	/*
+	 * use only basic dwell time in scan command, regardless of the band or
+	 * the number of the probes. FW will calculate the actual dwell time.
+	 */
+	params->passive_dwell = 110;
+	params->active_dwell = 10;
 
-		params->dwell[band].passive = iwl_mvm_get_passive_dwell(mvm,
-									band);
-		params->dwell[band].active =
-			iwl_mvm_get_active_dwell(mvm, band, params->n_ssids);
-	}
 
 	IWL_DEBUG_SCAN(mvm,
 		       "scan parameters: max_out_time %d, suspend_time %d, passive_fragmented %d\n",
 		       params->max_out_time, params->suspend_time,
 		       params->passive_fragmented);
-	IWL_DEBUG_SCAN(mvm,
-		       "dwell[IEEE80211_BAND_2GHZ]: passive %d, active %d, fragmented %d\n",
-		       params->dwell[IEEE80211_BAND_2GHZ].passive,
-		       params->dwell[IEEE80211_BAND_2GHZ].active,
-		       params->dwell[IEEE80211_BAND_2GHZ].fragmented);
-	IWL_DEBUG_SCAN(mvm,
-		       "dwell[IEEE80211_BAND_5GHZ]: passive %d, active %d, fragmented %d\n",
-		       params->dwell[IEEE80211_BAND_5GHZ].passive,
-		       params->dwell[IEEE80211_BAND_5GHZ].active,
-		       params->dwell[IEEE80211_BAND_5GHZ].fragmented);
 }
 
 static inline bool iwl_mvm_rrm_scan_needed(struct iwl_mvm *mvm)
@@ -743,11 +699,10 @@ static void iwl_mvm_scan_lmac_dwell(struct iwl_mvm *mvm,
 				    struct iwl_scan_req_lmac *cmd,
 				    struct iwl_mvm_scan_params *params)
 {
-	cmd->active_dwell = params->dwell[IEEE80211_BAND_2GHZ].active;
-	cmd->passive_dwell = params->dwell[IEEE80211_BAND_2GHZ].passive;
+	cmd->active_dwell = params->active_dwell;
+	cmd->passive_dwell = params->passive_dwell;
 	if (params->passive_fragmented)
-		cmd->fragmented_dwell =
-				params->dwell[IEEE80211_BAND_2GHZ].fragmented;
+		cmd->fragmented_dwell = params->fragmented_dwell;
 	cmd->max_out_time = cpu_to_le32(params->max_out_time);
 	cmd->suspend_time = cpu_to_le32(params->suspend_time);
 	cmd->scan_prio = iwl_mvm_scan_priority(mvm, IWL_SCAN_PRIORITY_EXT_6);
@@ -1005,11 +960,10 @@ static void iwl_mvm_scan_umac_dwell(struct iwl_mvm *mvm,
 				    struct iwl_scan_req_umac *cmd,
 				    struct iwl_mvm_scan_params *params)
 {
-	cmd->active_dwell = params->dwell[IEEE80211_BAND_2GHZ].active;
-	cmd->passive_dwell = params->dwell[IEEE80211_BAND_2GHZ].passive;
+	cmd->active_dwell = params->active_dwell;
+	cmd->passive_dwell = params->passive_dwell;
 	if (params->passive_fragmented)
-		cmd->fragmented_dwell =
-				params->dwell[IEEE80211_BAND_2GHZ].fragmented;
+		cmd->fragmented_dwell = params->fragmented_dwell;
 	cmd->max_out_time = cpu_to_le32(params->max_out_time);
 	cmd->suspend_time = cpu_to_le32(params->suspend_time);
 	cmd->scan_priority =
-- 
2.1.4

