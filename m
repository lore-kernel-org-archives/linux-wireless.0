Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:41867 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757477Ab3CDOA6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Mar 2013 09:00:58 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Dor Shaish <dor.shaish@intel.com>
Subject: [PATCH 07/11] iwlwifi: mvm: Take the phy_cfg from the TLV value
Date: Mon,  4 Mar 2013 15:00:47 +0100
Message-Id: <1362405651-26456-7-git-send-email-johannes@sipsolutions.net> (sfid-20130304_150117_524133_65D52C47)
In-Reply-To: <1362405651-26456-1-git-send-email-johannes@sipsolutions.net>
References: <1362405609.21028.12.camel@jlt4.sipsolutions.net>
 <1362405651-26456-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Dor Shaish <dor.shaish@intel.com>

The phy_cfg is given from the TLV value and does not have to be
built by us.

Signed-off-by: Dor Shaish <dor.shaish@intel.com>
Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/fw.c | 16 +---------------
 1 file changed, 1 insertion(+), 15 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/fw.c b/drivers/net/wireless/iwlwifi/mvm/fw.c
index e6d51a9..d3c067e 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/iwlwifi/mvm/fw.c
@@ -241,20 +241,6 @@ static int iwl_mvm_load_ucode_wait_alive(struct iwl_mvm *mvm,
 
 	return 0;
 }
-#define IWL_HW_REV_ID_RAINBOW	0x2
-#define IWL_PROJ_TYPE_LHP	0x5
-
-static u32 iwl_mvm_build_phy_cfg(struct iwl_mvm *mvm)
-{
-	struct iwl_nvm_data *data = mvm->nvm_data;
-	/* Temp calls to static definitions, will be changed to CSR calls */
-	u8 hw_rev_id = IWL_HW_REV_ID_RAINBOW;
-	u8 project_type = IWL_PROJ_TYPE_LHP;
-
-	return data->radio_cfg_dash | (data->radio_cfg_step << 2) |
-		(hw_rev_id << 4) | ((project_type & 0x7f) << 6) |
-		(data->valid_tx_ant << 16) | (data->valid_rx_ant << 20);
-}
 
 static int iwl_send_phy_cfg_cmd(struct iwl_mvm *mvm)
 {
@@ -262,7 +248,7 @@ static int iwl_send_phy_cfg_cmd(struct iwl_mvm *mvm)
 	enum iwl_ucode_type ucode_type = mvm->cur_ucode;
 
 	/* Set parameters */
-	phy_cfg_cmd.phy_cfg = cpu_to_le32(iwl_mvm_build_phy_cfg(mvm));
+	phy_cfg_cmd.phy_cfg = cpu_to_le32(mvm->fw->phy_config);
 	phy_cfg_cmd.calib_control.event_trigger =
 		mvm->fw->default_calib[ucode_type].event_trigger;
 	phy_cfg_cmd.calib_control.flow_trigger =
-- 
1.8.0

