Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:42828 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726809AbeHUJzy (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 21 Aug 2018 05:55:54 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Ayala Beker <ayala.beker@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Tue, 21 Aug 2018 09:36:45 +0300
Message-Id: <20180821063657.30071-4-luca@coelho.fi> (sfid-20180821_083711_920233_01A609F5)
In-Reply-To: <20180821063657.30071-1-luca@coelho.fi>
References: <20180821063657.30071-1-luca@coelho.fi>
Subject: [PATCH 03/15] iwlwifi: mvm: skip EBS in low latency mode while fragmented scan isn't supported
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ayala Beker <ayala.beker@intel.com>

While associated in low latency mode, or when traffic load is high,
don't enable EBS in scan request if fragmented EBS is not supported
by the FW.

Signed-off-by: Ayala Beker <ayala.beker@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/fw/file.h  |  2 ++
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h  |  5 +++++
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c | 11 ++++++++++-
 3 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/file.h b/drivers/net/wireless/intel/iwlwifi/fw/file.h
index c116dc3fbffe..c7e296a5dda9 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/file.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/file.h
@@ -258,6 +258,7 @@ typedef unsigned int __bitwise iwl_ucode_tlv_api_t;
  *	deprecated.
  * @IWL_UCODE_TLV_API_ADAPTIVE_DWELL_V2: This ucode supports version 8
  *	of scan request: SCAN_REQUEST_CMD_UMAC_API_S_VER_8
+ * @IWL_UCODE_TLV_API_FRAG_EBS: This ucode supports fragmented EBS
  *
  * @NUM_IWL_UCODE_TLV_API: number of bits used
  */
@@ -280,6 +281,7 @@ enum iwl_ucode_tlv_api {
 	IWL_UCODE_TLV_API_QUOTA_LOW_LATENCY	= (__force iwl_ucode_tlv_api_t)38,
 	IWL_UCODE_TLV_API_DEPRECATE_TTAK	= (__force iwl_ucode_tlv_api_t)41,
 	IWL_UCODE_TLV_API_ADAPTIVE_DWELL_V2	= (__force iwl_ucode_tlv_api_t)42,
+	IWL_UCODE_TLV_API_FRAG_EBS		= (__force iwl_ucode_tlv_api_t)44,
 
 	NUM_IWL_UCODE_TLV_API
 #ifdef __CHECKER__
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
index 09d94aaa7d1e..762abfc42b62 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
@@ -1245,6 +1245,11 @@ static inline bool iwl_mvm_is_oce_supported(struct iwl_mvm *mvm)
 	return fw_has_api(&mvm->fw->ucode_capa, IWL_UCODE_TLV_API_OCE);
 }
 
+static inline bool iwl_mvm_is_frag_ebs_supported(struct iwl_mvm *mvm)
+{
+	return fw_has_api(&mvm->fw->ucode_capa, IWL_UCODE_TLV_API_FRAG_EBS);
+}
+
 static inline bool iwl_mvm_enter_d0i3_on_suspend(struct iwl_mvm *mvm)
 {
 	/* For now we only use this mode to differentiate between
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/scan.c b/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
index 11ecdf63b732..8a89989f59fd 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
@@ -836,16 +836,25 @@ static inline bool iwl_mvm_scan_use_ebs(struct iwl_mvm *mvm,
 					struct ieee80211_vif *vif)
 {
 	const struct iwl_ucode_capabilities *capa = &mvm->fw->ucode_capa;
+	bool low_latency;
+
+	if (iwl_mvm_is_cdb_supported(mvm))
+		low_latency = iwl_mvm_low_latency_band(mvm, NL80211_BAND_5GHZ);
+	else
+		low_latency = iwl_mvm_low_latency(mvm);
 
 	/* We can only use EBS if:
 	 *	1. the feature is supported;
 	 *	2. the last EBS was successful;
 	 *	3. if only single scan, the single scan EBS API is supported;
 	 *	4. it's not a p2p find operation.
+	 *	5. we are not in low latency mode,
+	 *	   or if fragmented ebs is supported by the FW
 	 */
 	return ((capa->flags & IWL_UCODE_TLV_FLAGS_EBS_SUPPORT) &&
 		mvm->last_ebs_successful && IWL_MVM_ENABLE_EBS &&
-		vif->type != NL80211_IFTYPE_P2P_DEVICE);
+		vif->type != NL80211_IFTYPE_P2P_DEVICE &&
+		(!low_latency || iwl_mvm_is_frag_ebs_supported(mvm)));
 }
 
 static inline bool iwl_mvm_is_regular_scan(struct iwl_mvm_scan_params *params)
-- 
2.18.0
