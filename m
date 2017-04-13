Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:51298 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1754623AbdDMPZ3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 13 Apr 2017 11:25:29 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Luca Coelho <luciano.coelho@intel.com>
Date: Thu, 13 Apr 2017 18:24:49 +0300
Message-Id: <20170413152507.9648-9-luca@coelho.fi> (sfid-20170413_172535_256030_1A09B9D5)
In-Reply-To: <20170413152507.9648-1-luca@coelho.fi>
References: <20170413152507.9648-1-luca@coelho.fi>
Subject: [PATCH 08/26] iwlwifi: mvm: spin off SAR profile selection function
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luca Coelho <luciano.coelho@intel.com>

For dynamic SAR, we will need to select the current profile from
different places.  In preparation for that, spin the profile selection
code out of iwl_mvm_sar_init().

Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c | 68 +++++++++++++++++++----------
 1 file changed, 46 insertions(+), 22 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
index e94b50df74bc..df9a721c58c2 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
@@ -1127,49 +1127,73 @@ static int iwl_mvm_sar_get_wrds_table(struct iwl_mvm *mvm)
 }
 #endif /* CONFIG_ACPI */
 
-static int iwl_mvm_sar_init(struct iwl_mvm *mvm)
+static int
+iwl_mvm_sar_select_profile(struct iwl_mvm *mvm, int prof_a, int prof_b)
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
+		if (profs[i] >= IWL_MVM_SAR_PROFILE_NUM)
+			return -EINVAL;
 
-	IWL_DEBUG_RADIO(mvm, "Sending REDUCE_TX_POWER_CMD per chain\n");
+		prof = &mvm->sar_profiles[profs[i]];
 
-	BUILD_BUG_ON(IWL_NUM_CHAIN_LIMITS * IWL_NUM_SUB_BANDS !=
-		     IWL_MVM_SAR_TABLE_SIZE);
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
+	/* choose profile 0 as default for both chains */
+	ret = iwl_mvm_sar_select_profile(mvm, 0, 0);
+
+	/* if we don't have profile 0 from BIOS, just skip it */
+	if (ret == -ENOENT)
+		return 0;
 
 	return ret;
 }
-- 
2.11.0
