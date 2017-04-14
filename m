Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:51704 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753548AbdDNJCk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 14 Apr 2017 05:02:40 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Luca Coelho <luciano.coelho@intel.com>
Date: Fri, 14 Apr 2017 12:01:52 +0300
Message-Id: <20170414090210.31397-9-luca@coelho.fi> (sfid-20170414_110249_748324_8F638C26)
In-Reply-To: <20170414090210.31397-1-luca@coelho.fi>
References: <20170414090210.31397-1-luca@coelho.fi>
Subject: [PATCH v2 08/26] iwlwifi: mvm: spin off SAR profile selection function
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luca Coelho <luciano.coelho@intel.com>

For dynamic SAR, we will need to select the current profile from
different places.  In preparation for that, spin the profile selection
code out of iwl_mvm_sar_init().

Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c  |  4 ++
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c  | 73 +++++++++++++++++++---------
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h |  1 +
 3 files changed, 56 insertions(+), 22 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/d3.c b/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
index d74ae15b2d85..119a3bd92c50 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
@@ -2116,6 +2116,10 @@ static int __iwl_mvm_resume(struct iwl_mvm *mvm, bool test)
 	 */
 	iwl_mvm_update_changed_regdom(mvm);
 
+	if (!unified_image)
+		/*  Re-configure default SAR profile */
+		iwl_mvm_sar_select_profile(mvm, 1, 1);
+
 	if (mvm->net_detect) {
 		/* If this is a non-unified image, we restart the FW,
 		 * so no need to stop the netdetect scan.  If that
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
index 1679104e19e9..6360361c576d 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
@@ -1123,49 +1123,78 @@ static int iwl_mvm_sar_get_wrds_table(struct iwl_mvm *mvm)
 	return ret;
 }
 
-static int iwl_mvm_sar_init(struct iwl_mvm *mvm)
+int iwl_mvm_sar_select_profile(struct iwl_mvm *mvm, int prof_a, int prof_b)
 {
 	struct iwl_dev_tx_power_cmd cmd = {
 		.v3.set_mode = cpu_to_le32(IWL_TX_POWER_MODE_SET_CHAINS),
 	};
-	int ret, i, j, idx;
+	int i, j, idx;
+	int profs[IWL_NUM_CHAIN_LIMITS] = { prof_a, prof_b };
 	int len = sizeof(cmd);
 
+	BUILD_BUG_ON(IWL_NUM_CHAIN_LIMITS < 2);
+	BUILD_BUG_ON(IWL_NUM_CHAIN_LIMITS * IWL_NUM_SUB_BANDS !=
+		     IWL_MVM_SAR_TABLE_SIZE);
+
 	if (!fw_has_capa(&mvm->fw->ucode_capa, IWL_UCODE_TLV_CAPA_TX_POWER_ACK))
 		len = sizeof(cmd.v3);
 
-	ret = iwl_mvm_sar_get_wrds_table(mvm);
-	if (ret < 0) {
-		IWL_DEBUG_RADIO(mvm,
-				"SAR BIOS table invalid or unavailable. (%d)\n",
-				ret);
-		/* we don't fail if the table is not available */
-		return 0;
-	}
+	for (i = 0; i < IWL_NUM_CHAIN_LIMITS; i++) {
+		struct iwl_mvm_sar_profile *prof;
 
-	/* if profile 0 is disabled, there's nothing else to do here */
-	if (!mvm->sar_profiles[0].enabled)
-		return 0;
+		/* don't allow SAR to be disabled (profile 0 means disable) */
+		if (profs[i] == 0)
+			return -EPERM;
 
-	IWL_DEBUG_RADIO(mvm, "Sending REDUCE_TX_POWER_CMD per chain\n");
+		/* we are off by one, so allow up to IWL_MVM_SAR_PROFILE_NUM */
+		if (profs[i] > IWL_MVM_SAR_PROFILE_NUM)
+			return -EINVAL;
 
-	BUILD_BUG_ON(IWL_NUM_CHAIN_LIMITS * IWL_NUM_SUB_BANDS !=
-		     IWL_MVM_SAR_TABLE_SIZE);
+		/* profiles go from 1 to 4, so decrement to access the array */
+		prof = &mvm->sar_profiles[profs[i] - 1];
+
+		/* if the profile is disabled, do nothing */
+		if (!prof->enabled) {
+			IWL_DEBUG_RADIO(mvm, "SAR profile %d is disabled.\n",
+					profs[i]);
+			/* if one of the profiles is disabled, we fail all */
+			return -ENOENT;
+		}
 
-	for (i = 0; i < IWL_NUM_CHAIN_LIMITS; i++) {
 		IWL_DEBUG_RADIO(mvm, "  Chain[%d]:\n", i);
 		for (j = 0; j < IWL_NUM_SUB_BANDS; j++) {
 			idx = (i * IWL_NUM_SUB_BANDS) + j;
 			cmd.v3.per_chain_restriction[i][j] =
-				cpu_to_le16(mvm->sar_profiles[0].table[idx]);
+				cpu_to_le16(prof->table[idx]);
 			IWL_DEBUG_RADIO(mvm, "    Band[%d] = %d * .125dBm\n",
-					j, mvm->sar_profiles[0].table[idx]);
+					j, prof->table[idx]);
 		}
 	}
 
-	ret = iwl_mvm_send_cmd_pdu(mvm, REDUCE_TX_POWER_CMD, 0, len, &cmd);
-	if (ret)
-		IWL_ERR(mvm, "failed to set per-chain TX power: %d\n", ret);
+	IWL_DEBUG_RADIO(mvm, "Sending REDUCE_TX_POWER_CMD per chain\n");
+
+	return iwl_mvm_send_cmd_pdu(mvm, REDUCE_TX_POWER_CMD, 0, len, &cmd);
+}
+
+static int iwl_mvm_sar_init(struct iwl_mvm *mvm)
+{
+	int ret;
+
+	ret = iwl_mvm_sar_get_wrds_table(mvm);
+	if (ret < 0) {
+		IWL_DEBUG_RADIO(mvm,
+				"SAR BIOS table invalid or unavailable. (%d)\n",
+				ret);
+		/* we don't fail if the table is not available */
+		return 0;
+	}
+
+	/* choose profile 1 (WRDS) as default for both chains */
+	ret = iwl_mvm_sar_select_profile(mvm, 1, 1);
+
+	/* if we don't have profile 0 from BIOS, just skip it */
+	if (ret == -ENOENT)
+		return 0;
 
 	return ret;
 }
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
index 0c35d9ebd4ac..f4e8fa3765fa 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
@@ -1818,5 +1818,6 @@ int iwl_mvm_send_lqm_cmd(struct ieee80211_vif *vif,
 			 enum iwl_lqm_cmd_operatrions operation,
 			 u32 duration, u32 timeout);
 bool iwl_mvm_lqm_active(struct iwl_mvm *mvm);
+int iwl_mvm_sar_select_profile(struct iwl_mvm *mvm, int prof_a, int prof_b);
 
 #endif /* __IWL_MVM_H__ */
-- 
2.11.0
