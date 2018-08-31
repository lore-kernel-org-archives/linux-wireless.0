Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:45736 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726990AbeHaOFW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 31 Aug 2018 10:05:22 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        "Dreyfuss, Haim" <haim.dreyfuss@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri, 31 Aug 2018 12:56:09 +0300
Message-Id: <20180831095614.14099-12-luca@coelho.fi> (sfid-20180831_115842_864464_502856D4)
In-Reply-To: <20180831095614.14099-1-luca@coelho.fi>
References: <20180831095614.14099-1-luca@coelho.fi>
Subject: [PATCH 11/16] iwlwifi: mvm: cleanup dead code on resume flow for non unified image.
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "Dreyfuss, Haim" <haim.dreyfuss@intel.com>

CDB support has nothing to do with non unified image.

Signed-off-by: Haim Dreyfuss <haim.dreyfuss@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c | 21 ++++++---------------
 1 file changed, 6 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/d3.c b/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
index b09446697c46..210be26aadaa 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
@@ -434,23 +434,13 @@ static int iwl_mvm_d3_reprogram(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 	u8 chains_static, chains_dynamic;
 	struct cfg80211_chan_def chandef;
 	int ret, i;
-	struct iwl_binding_cmd binding_cmd = {};
+	struct iwl_binding_cmd_v1 binding_cmd = {};
 	struct iwl_time_quota_cmd quota_cmd = {};
 	struct iwl_time_quota_data *quota;
 	u32 status;
-	int size;
-
-	if (fw_has_capa(&mvm->fw->ucode_capa,
-			IWL_UCODE_TLV_CAPA_BINDING_CDB_SUPPORT)) {
-		size = sizeof(binding_cmd);
-		if (mvmvif->phy_ctxt->channel->band == NL80211_BAND_2GHZ ||
-		    !iwl_mvm_is_cdb_supported(mvm))
-			binding_cmd.lmac_id = cpu_to_le32(IWL_LMAC_24G_INDEX);
-		else
-			binding_cmd.lmac_id = cpu_to_le32(IWL_LMAC_5G_INDEX);
-	} else {
-		size = IWL_BINDING_CMD_SIZE_V1;
-	}
+
+	if (WARN_ON_ONCE(iwl_mvm_is_cdb_supported(mvm)))
+		return -EINVAL;
 
 	/* add back the PHY */
 	if (WARN_ON(!mvmvif->phy_ctxt))
@@ -497,7 +487,8 @@ static int iwl_mvm_d3_reprogram(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 
 	status = 0;
 	ret = iwl_mvm_send_cmd_pdu_status(mvm, BINDING_CONTEXT_CMD,
-					  size, &binding_cmd, &status);
+					  IWL_BINDING_CMD_SIZE_V1, &binding_cmd,
+					  &status);
 	if (ret) {
 		IWL_ERR(mvm, "Failed to add binding: %d\n", ret);
 		return ret;
-- 
2.18.0
