Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:12459 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751985Ab1HMSSo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Aug 2011 14:18:44 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 25/60] iwlagn: more comments for bt channel inhibition
Date: Sat, 13 Aug 2011 10:38:01 -0700
Message-Id: <1313257116-2697-26-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110813_201944_472279_1EDD9C5D)
In-Reply-To: <1313257116-2697-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1313257116-2697-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add comments for better description

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn.c     |    2 +-
 drivers/net/wireless/iwlwifi/iwl-shared.h  |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index 6cfd236..57839ca 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -610,7 +610,7 @@ struct iwl_mod_params iwlagn_mod_params = {
 	.bt_coex_active = true,
 	.no_sleep_autoadjust = true,
 	.power_level = IWL_POWER_INDEX_1,
-	.bt_ch_announce = 1,
+	.bt_ch_announce = true,
 	.wanted_ucode_alternative = 1,
 	.auto_agg = true,
 	/* the rest are 0 by default */
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 2764c7a..cdb6bd6 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -3606,7 +3606,7 @@ MODULE_PARM_DESC(antenna_coupling,
 module_param_named(bt_ch_inhibition, iwlagn_mod_params.bt_ch_announce,
 		   bool, S_IRUGO);
 MODULE_PARM_DESC(bt_ch_inhibition,
-		 "Disable BT channel inhibition (default: enable)");
+		 "Enable BT channel inhibition (default: enable)");
 
 module_param_named(plcp_check, iwlagn_mod_params.plcp_check, bool, S_IRUGO);
 MODULE_PARM_DESC(plcp_check, "Check plcp health (default: 1 [enabled])");
diff --git a/drivers/net/wireless/iwlwifi/iwl-shared.h b/drivers/net/wireless/iwlwifi/iwl-shared.h
index ec71ec7..6c20d03 100644
--- a/drivers/net/wireless/iwlwifi/iwl-shared.h
+++ b/drivers/net/wireless/iwlwifi/iwl-shared.h
@@ -91,7 +91,7 @@ struct iwl_mod_params {
 	int power_level;	/* def: 1 = power level */
 	u32 debug_level;	/* levels are IWL_DL_* */
 	int ant_coupling;
-	bool bt_ch_announce;
+	bool bt_ch_announce;	/* def: enable = BT channel inhibition */
 	int wanted_ucode_alternative;
 	bool auto_agg;		/* def: true = enable agg. without check */
 };
-- 
1.7.0.4

