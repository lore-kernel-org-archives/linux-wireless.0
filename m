Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:38881 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752078AbbEZTSw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 May 2015 15:18:52 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Avraham Stern <avraham.stern@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 28/39] iwlwifi: mvm: add support for 8 level scan priority API
Date: Tue, 26 May 2015 22:17:41 +0300
Message-Id: <1432667872-18092-28-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150526_211941_276168_DFBAAE04)
In-Reply-To: <1432667798.26624.3.camel@intel.com>
References: <1432667798.26624.3.camel@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Avraham Stern <avraham.stern@intel.com>

Add support for scan priority API with 8 levels instead of the
existing 3 levels. This API is needed to define the priority of
new ooc activities, e.g. gscan.
Add a TLV flag to indicate if the new API is supported so that
devices that does not support the new API will continue to use
the old one.

Signed-off-by: Avraham Stern <avraham.stern@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-fw-file.h     |  3 +++
 drivers/net/wireless/iwlwifi/mvm/fw-api-scan.h | 11 +++++++++++
 drivers/net/wireless/iwlwifi/mvm/scan.c        | 26 ++++++++++++++++++++++----
 3 files changed, 36 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-fw-file.h b/drivers/net/wireless/iwlwifi/iwl-fw-file.h
index c7cfc38..839b2c4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-fw-file.h
+++ b/drivers/net/wireless/iwlwifi/iwl-fw-file.h
@@ -255,6 +255,8 @@ enum iwl_ucode_tlv_flag {
  * @IWL_UCODE_TLV_API_LQ_SS_PARAMS: Configure STBC/BFER via LQ CMD ss_params
  * @IWL_UCODE_TLV_API_STATS_V10: uCode supports/uses statistics API version 10
  * @IWL_UCODE_TLV_API_NEW_VERSION: new versioning format
+ * @IWL_UCODE_TLV_API_EXT_SCAN_PRIORITY: scan APIs use 8-level priority
+ *	instead of 3.
  */
 enum iwl_ucode_tlv_api {
 	IWL_UCODE_TLV_API_BT_COEX_SPLIT         = BIT(3),
@@ -269,6 +271,7 @@ enum iwl_ucode_tlv_api {
 	IWL_UCODE_TLV_API_LQ_SS_PARAMS		= BIT(18),
 	IWL_UCODE_TLV_API_STATS_V10		= BIT(19),
 	IWL_UCODE_TLV_API_NEW_VERSION		= BIT(20),
+	IWL_UCODE_TLV_API_EXT_SCAN_PRIORITY	= BIT(24),
 };
 
 /**
diff --git a/drivers/net/wireless/iwlwifi/mvm/fw-api-scan.h b/drivers/net/wireless/iwlwifi/mvm/fw-api-scan.h
index 0228693..f34cf00 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw-api-scan.h
+++ b/drivers/net/wireless/iwlwifi/mvm/fw-api-scan.h
@@ -431,6 +431,17 @@ enum iwl_scan_priority {
 	IWL_SCAN_PRIORITY_HIGH,
 };
 
+enum iwl_scan_priority_ext {
+	IWL_SCAN_PRIORITY_EXT_0_LOWEST,
+	IWL_SCAN_PRIORITY_EXT_1,
+	IWL_SCAN_PRIORITY_EXT_2,
+	IWL_SCAN_PRIORITY_EXT_3,
+	IWL_SCAN_PRIORITY_EXT_4,
+	IWL_SCAN_PRIORITY_EXT_5,
+	IWL_SCAN_PRIORITY_EXT_6,
+	IWL_SCAN_PRIORITY_EXT_7_HIGHEST,
+};
+
 /**
  * iwl_scan_req_lmac - SCAN_REQUEST_CMD_API_S_VER_1
  * @reserved1: for alignment and future use
diff --git a/drivers/net/wireless/iwlwifi/mvm/scan.c b/drivers/net/wireless/iwlwifi/mvm/scan.c
index 9becece..d0312f0 100644
--- a/drivers/net/wireless/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/iwlwifi/mvm/scan.c
@@ -744,6 +744,21 @@ iwl_mvm_build_scan_probe(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 	params->preq.common_data.len = cpu_to_le16(ies->common_ie_len);
 }
 
+static __le32 iwl_mvm_scan_priority(struct iwl_mvm *mvm,
+				    enum iwl_scan_priority_ext prio)
+{
+	if (mvm->fw->ucode_capa.api[0] & IWL_UCODE_TLV_API_EXT_SCAN_PRIORITY)
+		return cpu_to_le32(prio);
+
+	if (prio <= IWL_SCAN_PRIORITY_EXT_2)
+		return cpu_to_le32(IWL_SCAN_PRIORITY_LOW);
+
+	if (prio <= IWL_SCAN_PRIORITY_EXT_4)
+		return cpu_to_le32(IWL_SCAN_PRIORITY_MEDIUM);
+
+	return cpu_to_le32(IWL_SCAN_PRIORITY_HIGH);
+}
+
 static void iwl_mvm_scan_lmac_dwell(struct iwl_mvm *mvm,
 				    struct iwl_scan_req_lmac *cmd,
 				    struct iwl_mvm_scan_params *params)
@@ -755,7 +770,7 @@ static void iwl_mvm_scan_lmac_dwell(struct iwl_mvm *mvm,
 				params->dwell[IEEE80211_BAND_2GHZ].fragmented;
 	cmd->max_out_time = cpu_to_le32(params->max_out_time);
 	cmd->suspend_time = cpu_to_le32(params->suspend_time);
-	cmd->scan_prio = cpu_to_le32(IWL_SCAN_PRIORITY_HIGH);
+	cmd->scan_prio = iwl_mvm_scan_priority(mvm, IWL_SCAN_PRIORITY_EXT_6);
 }
 
 static inline bool iwl_mvm_scan_fits(struct iwl_mvm *mvm, int n_ssids,
@@ -1070,12 +1085,15 @@ static void iwl_mvm_scan_umac_dwell(struct iwl_mvm *mvm,
 				params->dwell[IEEE80211_BAND_2GHZ].fragmented;
 	cmd->max_out_time = cpu_to_le32(params->max_out_time);
 	cmd->suspend_time = cpu_to_le32(params->suspend_time);
-	cmd->scan_priority = cpu_to_le32(IWL_SCAN_PRIORITY_HIGH);
+	cmd->scan_priority =
+		iwl_mvm_scan_priority(mvm, IWL_SCAN_PRIORITY_EXT_6);
 
 	if (iwl_mvm_scan_total_iterations(params) == 0)
-		cmd->ooc_priority = cpu_to_le32(IWL_SCAN_PRIORITY_HIGH);
+		cmd->ooc_priority =
+			iwl_mvm_scan_priority(mvm, IWL_SCAN_PRIORITY_EXT_6);
 	else
-		cmd->ooc_priority = cpu_to_le32(IWL_SCAN_PRIORITY_LOW);
+		cmd->ooc_priority =
+			iwl_mvm_scan_priority(mvm, IWL_SCAN_PRIORITY_EXT_2);
 }
 
 static void
-- 
2.1.4

