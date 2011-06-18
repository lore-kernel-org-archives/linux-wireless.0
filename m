Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:41798 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753494Ab1FRQFb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 Jun 2011 12:05:31 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 21/25] iwlagn: Add power_level module parameter
Date: Sat, 18 Jun 2011 08:34:27 -0700
Message-Id: <1308411271-26093-22-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110618_180552_010168_57D2C819)
In-Reply-To: <1308411271-26093-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1308411271-26093-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add power_level module parameter to set the default power save level.
Power save level has range from 1 - 5, default power save level is 1.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c |    1 +
 drivers/net/wireless/iwlwifi/iwl-agn.c     |    5 +++++
 drivers/net/wireless/iwlwifi/iwl-core.h    |    1 +
 drivers/net/wireless/iwlwifi/iwl-power.c   |   12 +++++++++---
 4 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index 52da539..efdab65 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -624,6 +624,7 @@ struct iwl_mod_params iwlagn_mod_params = {
 	.plcp_check = true,
 	.bt_coex_active = true,
 	.no_sleep_autoadjust = true,
+	.power_level = IWL_POWER_INDEX_1,
 	/* the rest are 0 by default */
 };
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index b719628..77ceb8d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -3831,6 +3831,11 @@ module_param_named(power_save, iwlagn_mod_params.power_save,
 MODULE_PARM_DESC(power_save,
 		 "enable WiFi power management (default: disable)");
 
+module_param_named(power_level, iwlagn_mod_params.power_level,
+		int, S_IRUGO);
+MODULE_PARM_DESC(power_level,
+		 "default power save level (range from 1 - 5, default: 1)");
+
 /*
  * For now, keep using power level 1 instead of automatically
  * adjusting ...
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 6238ac6..adf9f9b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -164,6 +164,7 @@ struct iwl_mod_params {
 	int led_mode;		/* def: 0 = system default */
 	bool no_sleep_autoadjust; /* def: true = disable autoadjust */
 	bool power_save;	/* def: false = disable power save */
+	int power_level;	/* def: 1 = power level */
 };
 
 /*
diff --git a/drivers/net/wireless/iwlwifi/iwl-power.c b/drivers/net/wireless/iwlwifi/iwl-power.c
index 970c514..565e57e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-power.c
+++ b/drivers/net/wireless/iwlwifi/iwl-power.c
@@ -358,9 +358,15 @@ static void iwl_power_build_cmd(struct iwl_priv *priv,
 		iwl_static_sleep_cmd(priv, cmd,
 				     priv->power_data.debug_sleep_level_override,
 				     dtimper);
-	else if (iwlagn_mod_params.no_sleep_autoadjust)
-		iwl_static_sleep_cmd(priv, cmd, IWL_POWER_INDEX_1, dtimper);
-	else
+	else if (iwlagn_mod_params.no_sleep_autoadjust) {
+		if (iwlagn_mod_params.power_level > IWL_POWER_INDEX_1 &&
+		    iwlagn_mod_params.power_level <= IWL_POWER_INDEX_5)
+			iwl_static_sleep_cmd(priv, cmd,
+				iwlagn_mod_params.power_level, dtimper);
+		else
+			iwl_static_sleep_cmd(priv, cmd,
+				IWL_POWER_INDEX_1, dtimper);
+	} else
 		iwl_power_fill_sleep_cmd(priv, cmd,
 					 priv->hw->conf.dynamic_ps_timeout,
 					 priv->hw->conf.max_sleep_period);
-- 
1.7.0.4

