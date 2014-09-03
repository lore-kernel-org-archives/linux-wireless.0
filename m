Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f172.google.com ([74.125.82.172]:40075 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755502AbaICT5B (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Sep 2014 15:57:01 -0400
Received: by mail-we0-f172.google.com with SMTP id q59so9212640wes.3
        for <linux-wireless@vger.kernel.org>; Wed, 03 Sep 2014 12:57:00 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: David Spinadel <david.spinadel@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 21/36] iwlwifi: mvm: enable passive fragmented scan changes
Date: Wed,  3 Sep 2014 22:56:09 +0300
Message-Id: <1409774184-24665-21-git-send-email-egrumbach@gmail.com> (sfid-20140903_220113_772010_7E083219)
In-Reply-To: <540771E5.6080908@gmail.com>
References: <540771E5.6080908@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: David Spinadel <david.spinadel@intel.com>

Enable fragmented scan that was diabled due to a FW bug.
New fixed FWs use a TLV bit to advertise fragmented scan support.

Signed-off-by: David Spinadel <david.spinadel@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-fw.h   |  3 +++
 drivers/net/wireless/iwlwifi/mvm/scan.c | 48 ++++++++++++++++++++++++++-------
 2 files changed, 42 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-fw.h b/drivers/net/wireless/iwlwifi/iwl-fw.h
index 1bb5193..99e0ec4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-fw.h
+++ b/drivers/net/wireless/iwlwifi/iwl-fw.h
@@ -125,6 +125,8 @@ enum iwl_ucode_tlv_flag {
  * @IWL_UCODE_TLV_API_CSA_FLOW: ucode can do unbind-bind flow for CSA.
  * @IWL_UCODE_TLV_API_DISABLE_STA_TX: ucode supports tx_disable bit.
  * @IWL_UCODE_TLV_API_LMAC_SCAN: This ucode uses LMAC unified scan API.
+ * @IWL_UCODE_TLV_API_FRAGMENTED_SCAN: This ucode supports active dwell time
+ *	longer than the passive one, which is essential for fragmented scan.
  */
 enum iwl_ucode_tlv_api {
 	IWL_UCODE_TLV_API_WOWLAN_CONFIG_TID	= BIT(0),
@@ -133,6 +135,7 @@ enum iwl_ucode_tlv_api {
 	IWL_UCODE_TLV_API_CSA_FLOW		= BIT(4),
 	IWL_UCODE_TLV_API_DISABLE_STA_TX	= BIT(5),
 	IWL_UCODE_TLV_API_LMAC_SCAN		= BIT(6),
+	IWL_UCODE_TLV_API_FRAGMENTED_SCAN	= BIT(8),
 };
 
 /**
diff --git a/drivers/net/wireless/iwlwifi/mvm/scan.c b/drivers/net/wireless/iwlwifi/mvm/scan.c
index 004b1f5..d01954d 100644
--- a/drivers/net/wireless/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/iwlwifi/mvm/scan.c
@@ -279,6 +279,7 @@ static void iwl_mvm_scan_calc_params(struct iwl_mvm *mvm,
 {
 	bool global_bound = false;
 	enum ieee80211_band band;
+	u8 frag_passive_dwell = 0;
 
 	ieee80211_iterate_active_interfaces_atomic(mvm->hw,
 					    IEEE80211_IFACE_ITER_NORMAL,
@@ -288,12 +289,36 @@ static void iwl_mvm_scan_calc_params(struct iwl_mvm *mvm,
 	if (!global_bound)
 		goto not_bound;
 
-	params->suspend_time = 100;
-	params->max_out_time = 600;
+	params->suspend_time = 30;
+	params->max_out_time = 170;
 
 	if (iwl_mvm_low_latency(mvm)) {
-		params->suspend_time = 250;
-		params->max_out_time = 250;
+		if (mvm->fw->ucode_capa.api[0] &
+		    IWL_UCODE_TLV_API_FRAGMENTED_SCAN) {
+			params->suspend_time = 105;
+			params->max_out_time = 70;
+			frag_passive_dwell = 20;
+		} else {
+			params->suspend_time = 120;
+			params->max_out_time = 120;
+		}
+	}
+
+	if (frag_passive_dwell && (mvm->fw->ucode_capa.api[0] &
+				   IWL_UCODE_TLV_API_FRAGMENTED_SCAN)) {
+		/*
+		 * P2P device scan should not be fragmented to avoid negative
+		 * impact on P2P device discovery. Configure max_out_time to be
+		 * equal to dwell time on passive channel. Take a longest
+		 * possible value, one that corresponds to 2GHz band
+		 */
+		if (vif->type == NL80211_IFTYPE_P2P_DEVICE) {
+			u32 passive_dwell =
+				iwl_mvm_get_passive_dwell(IEEE80211_BAND_2GHZ);
+			params->max_out_time = passive_dwell;
+		} else {
+			params->passive_fragmented = true;
+		}
 	}
 
 	if (flags & NL80211_SCAN_FLAG_LOW_PRIORITY)
@@ -302,7 +327,11 @@ static void iwl_mvm_scan_calc_params(struct iwl_mvm *mvm,
 not_bound:
 
 	for (band = IEEE80211_BAND_2GHZ; band < IEEE80211_NUM_BANDS; band++) {
-		params->dwell[band].passive = iwl_mvm_get_passive_dwell(band);
+		if (params->passive_fragmented)
+			params->dwell[band].passive = frag_passive_dwell;
+		else
+			params->dwell[band].passive =
+				iwl_mvm_get_passive_dwell(band);
 		params->dwell[band].active = iwl_mvm_get_active_dwell(band,
 								      n_ssids);
 	}
@@ -1100,10 +1129,11 @@ iwl_mvm_build_generic_unified_scan_cmd(struct iwl_mvm *mvm,
 				       struct iwl_mvm_scan_params *params)
 {
 	memset(cmd, 0, ksize(cmd));
-	cmd->active_dwell = (u8)params->dwell[IEEE80211_BAND_2GHZ].active;
-	cmd->passive_dwell = (u8)params->dwell[IEEE80211_BAND_2GHZ].passive;
-	/* TODO: Use params; now fragmented isn't used. */
-	cmd->fragmented_dwell = 0;
+	cmd->active_dwell = params->dwell[IEEE80211_BAND_2GHZ].active;
+	cmd->passive_dwell = params->dwell[IEEE80211_BAND_2GHZ].passive;
+	if (params->passive_fragmented)
+		cmd->fragmented_dwell =
+				params->dwell[IEEE80211_BAND_2GHZ].passive;
 	cmd->rx_chain_select = iwl_mvm_scan_rx_chain(mvm);
 	cmd->max_out_time = cpu_to_le32(params->max_out_time);
 	cmd->suspend_time = cpu_to_le32(params->suspend_time);
-- 
1.9.1

