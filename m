Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:9552 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751952AbbECTdS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 May 2015 15:33:18 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Luciano Coelho <luciano.coelho@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 37/42] iwlwifi: mvm: move all LMAC scan flags into a single funtion
Date: Sun,  3 May 2015 22:31:48 +0300
Message-Id: <1430681513-7838-37-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150503_213346_997924_4BD761F9)
In-Reply-To: <1430681438.3240.3.camel@intel.com>
References: <1430681438.3240.3.camel@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

Having an LMAC counterpart for the existing UMAC flags function makes
things more consistent and easy to compare and spot the differences.
The flags are the same, but are in different bits, so unfortunately we
can't use a single function for both APIs.

Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/scan.c | 57 ++++++++++++++++++---------------
 1 file changed, 32 insertions(+), 25 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/scan.c b/drivers/net/wireless/iwlwifi/mvm/scan.c
index 437adc3..277fe79 100644
--- a/drivers/net/wireless/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/iwlwifi/mvm/scan.c
@@ -798,10 +798,6 @@ iwl_mvm_build_generic_scan_cmd(struct iwl_mvm *mvm,
 	cmd->suspend_time = cpu_to_le32(params->suspend_time);
 	cmd->scan_prio = cpu_to_le32(IWL_SCAN_PRIORITY_HIGH);
 	cmd->iter_num = cpu_to_le32(1);
-
-	if (iwl_mvm_rrm_scan_needed(mvm))
-		cmd->scan_flags |=
-			cpu_to_le32(IWL_MVM_LMAC_SCAN_FLAGS_RRM_ENABLED);
 }
 
 static inline bool iwl_mvm_scan_fits(struct iwl_mvm *mvm, int n_ssids,
@@ -836,6 +832,36 @@ static int iwl_mvm_scan_total_iterations(struct iwl_mvm_scan_params *params)
 	return params->schedule[0].iterations + params->schedule[1].iterations;
 }
 
+static int iwl_mvm_scan_lmac_flags(struct iwl_mvm *mvm,
+				   struct iwl_mvm_scan_params *params)
+{
+	int flags = 0;
+
+	if (params->n_ssids == 0)
+		flags |= IWL_MVM_LMAC_SCAN_FLAG_PASSIVE;
+
+	if (params->n_ssids == 1 && params->ssids[0].ssid_len != 0)
+		flags |= IWL_MVM_LMAC_SCAN_FLAG_PRE_CONNECTION;
+
+	if (params->passive_fragmented)
+		flags |= IWL_MVM_LMAC_SCAN_FLAG_FRAGMENTED;
+
+	if (iwl_mvm_rrm_scan_needed(mvm))
+		flags |= IWL_MVM_LMAC_SCAN_FLAGS_RRM_ENABLED;
+
+	if (params->pass_all)
+		flags |= IWL_MVM_LMAC_SCAN_FLAG_PASS_ALL;
+	else
+		flags |= IWL_MVM_LMAC_SCAN_FLAG_MATCH;
+
+#ifdef CONFIG_IWLWIFI_DEBUGFS
+	if (mvm->scan_iter_notif_enabled)
+		flags |= IWL_MVM_LMAC_SCAN_FLAG_ITER_COMPLETE;
+#endif
+
+	return flags;
+}
+
 static int iwl_mvm_scan_lmac(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 			     struct iwl_mvm_scan_params *params)
 {
@@ -843,7 +869,7 @@ static int iwl_mvm_scan_lmac(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 	struct iwl_scan_probe_req *preq =
 		(void *)(cmd->data + sizeof(struct iwl_scan_channel_cfg_lmac) *
 			 mvm->fw->ucode_capa.n_scan_channels);
-	u32 flags = 0, ssid_bitmap = 0;
+	u32 ssid_bitmap = 0;
 	int n_iterations = iwl_mvm_scan_total_iterations(params);
 
 	lockdep_assert_held(&mvm->mutex);
@@ -854,26 +880,7 @@ static int iwl_mvm_scan_lmac(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 
 	cmd->delay = cpu_to_le32(params->delay);
 
-	if (params->pass_all)
-		flags |= IWL_MVM_LMAC_SCAN_FLAG_PASS_ALL;
-	else
-		flags |= IWL_MVM_LMAC_SCAN_FLAG_MATCH;
-
-	if (params->n_ssids == 1 && params->ssids[0].ssid_len != 0)
-		flags |= IWL_MVM_LMAC_SCAN_FLAG_PRE_CONNECTION;
-
-	if (params->passive_fragmented)
-		flags |= IWL_MVM_LMAC_SCAN_FLAG_FRAGMENTED;
-
-	if (params->n_ssids == 0)
-		flags |= IWL_MVM_LMAC_SCAN_FLAG_PASSIVE;
-
-#ifdef CONFIG_IWLWIFI_DEBUGFS
-	if (mvm->scan_iter_notif_enabled)
-		flags |= IWL_MVM_LMAC_SCAN_FLAG_ITER_COMPLETE;
-#endif
-
-	cmd->scan_flags |= cpu_to_le32(flags);
+	cmd->scan_flags = cpu_to_le32(iwl_mvm_scan_lmac_flags(mvm, params));
 
 	cmd->flags = iwl_mvm_scan_rxon_flags(params->channels[0]->band);
 	cmd->filter_flags = cpu_to_le32(MAC_FILTER_ACCEPT_GRP |
-- 
2.1.0

