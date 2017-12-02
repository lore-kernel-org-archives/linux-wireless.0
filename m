Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:48532 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751960AbdLBQ3F (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 2 Dec 2017 11:29:05 -0500
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Avraham Stern <avraham.stern@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Sat,  2 Dec 2017 18:28:44 +0200
Message-Id: <20171202162858.4167-2-luca@coelho.fi> (sfid-20171202_172909_084641_E73B0D39)
In-Reply-To: <20171202162858.4167-1-luca@coelho.fi>
References: <20171202162858.4167-1-luca@coelho.fi>
Subject: [PATCH 01/15] iwlwifi: mvm: add WFA vendor specific TPC report IE to probe request
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Avraham Stern <avraham.stern@intel.com>

Add the WFA vendor specific TPC report IE to probe requests
when it is not added by the FW. The FW will still need to set
the tx power field.

Signed-off-by: Avraham Stern <avraham.stern@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c | 35 ++++++++++++++++++++++++---
 1 file changed, 32 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/scan.c b/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
index e4fd476e9ccb..356b16f40e78 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
@@ -664,6 +664,22 @@ static u8 *iwl_mvm_copy_and_insert_ds_elem(struct iwl_mvm *mvm, const u8 *ies,
 	return newpos;
 }
 
+#define WFA_TPC_IE_LEN	9
+
+static void iwl_mvm_add_tpc_report_ie(u8 *pos)
+{
+	pos[0] = WLAN_EID_VENDOR_SPECIFIC;
+	pos[1] = WFA_TPC_IE_LEN - 2;
+	pos[2] = (WLAN_OUI_MICROSOFT >> 16) & 0xff;
+	pos[3] = (WLAN_OUI_MICROSOFT >> 8) & 0xff;
+	pos[4] = WLAN_OUI_MICROSOFT & 0xff;
+	pos[5] = WLAN_OUI_TYPE_MICROSOFT_TPC;
+	pos[6] = 0;
+	/* pos[7] - tx power will be inserted by the FW */
+	pos[7] = 0;
+	pos[8] = 0;
+}
+
 static void
 iwl_mvm_build_scan_probe(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 			 struct ieee80211_scan_ies *ies,
@@ -716,7 +732,16 @@ iwl_mvm_build_scan_probe(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 
 	memcpy(pos, ies->common_ies, ies->common_ie_len);
 	params->preq.common_data.offset = cpu_to_le16(pos - params->preq.buf);
-	params->preq.common_data.len = cpu_to_le16(ies->common_ie_len);
+
+	if (iwl_mvm_rrm_scan_needed(mvm) &&
+	    !fw_has_capa(&mvm->fw->ucode_capa,
+			 IWL_UCODE_TLV_CAPA_WFA_TPC_REP_IE_SUPPORT)) {
+		iwl_mvm_add_tpc_report_ie(pos + ies->common_ie_len);
+		params->preq.common_data.len = cpu_to_le16(ies->common_ie_len +
+							   WFA_TPC_IE_LEN);
+	} else {
+		params->preq.common_data.len = cpu_to_le16(ies->common_ie_len);
+	}
 }
 
 static void iwl_mvm_scan_lmac_dwell(struct iwl_mvm *mvm,
@@ -781,7 +806,9 @@ static int iwl_mvm_scan_lmac_flags(struct iwl_mvm *mvm,
 	if (params->type == IWL_SCAN_TYPE_FRAGMENTED)
 		flags |= IWL_MVM_LMAC_SCAN_FLAG_FRAGMENTED;
 
-	if (iwl_mvm_rrm_scan_needed(mvm))
+	if (iwl_mvm_rrm_scan_needed(mvm) &&
+	    fw_has_capa(&mvm->fw->ucode_capa,
+			IWL_UCODE_TLV_CAPA_WFA_TPC_REP_IE_SUPPORT))
 		flags |= IWL_MVM_LMAC_SCAN_FLAGS_RRM_ENABLED;
 
 	if (params->pass_all)
@@ -1183,7 +1210,9 @@ static u16 iwl_mvm_scan_umac_flags(struct iwl_mvm *mvm,
 			flags |= IWL_UMAC_SCAN_GEN_FLAGS_LMAC2_FRAGMENTED;
 	}
 
-	if (iwl_mvm_rrm_scan_needed(mvm))
+	if (iwl_mvm_rrm_scan_needed(mvm) &&
+	    fw_has_capa(&mvm->fw->ucode_capa,
+			IWL_UCODE_TLV_CAPA_WFA_TPC_REP_IE_SUPPORT))
 		flags |= IWL_UMAC_SCAN_GEN_FLAGS_RRM_ENABLED;
 
 	if (params->pass_all)
-- 
2.15.0
