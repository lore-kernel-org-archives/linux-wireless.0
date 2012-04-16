Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:57140 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755573Ab2DPWB1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Apr 2012 18:01:27 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 01/16] iwlwifi: remove no_sleep_autoadjust
Date: Mon, 16 Apr 2012 14:56:55 -0700
Message-Id: <1334613430-30720-2-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120417_000207_581018_D21E25B8)
In-Reply-To: <1334613430-30720-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1334613430-30720-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

My original idea with this was to adjust the sleep
pattern of the uCode based on the maximum network
latency userspace asked for. Due to nobody wanting
to test it, this logic was disabled by default. It
seems the time has come to remove it, since it's
not only always disabled but there also don't seem
to be any applications that actually request a max
network latency.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c |    1 -
 drivers/net/wireless/iwlwifi/iwl-agn.c     |   10 ----
 drivers/net/wireless/iwlwifi/iwl-power.c   |   62 +---------------------------
 drivers/net/wireless/iwlwifi/iwl-shared.h  |    2 -
 4 files changed, 2 insertions(+), 73 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index da023fd..8834b1b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -99,7 +99,6 @@ struct iwl_mod_params iwlagn_mod_params = {
 	.restart_fw = 1,
 	.plcp_check = true,
 	.bt_coex_active = true,
-	.no_sleep_autoadjust = true,
 	.power_level = IWL_POWER_INDEX_1,
 	.bt_ch_announce = true,
 	.wanted_ucode_alternative = 1,
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 500eaa3..6cea8a7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -2471,13 +2471,3 @@ module_param_named(auto_agg, iwlagn_mod_params.auto_agg,
 		bool, S_IRUGO);
 MODULE_PARM_DESC(auto_agg,
 		 "enable agg w/o check traffic load (default: enable)");
-
-/*
- * For now, keep using power level 1 instead of automatically
- * adjusting ...
- */
-module_param_named(no_sleep_autoadjust, iwlagn_mod_params.no_sleep_autoadjust,
-		bool, S_IRUGO);
-MODULE_PARM_DESC(no_sleep_autoadjust,
-		 "don't automatically adjust sleep level "
-		 "according to maximum network latency (default: true)");
diff --git a/drivers/net/wireless/iwlwifi/iwl-power.c b/drivers/net/wireless/iwlwifi/iwl-power.c
index 7bc7a82..174a0f7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-power.c
+++ b/drivers/net/wireless/iwlwifi/iwl-power.c
@@ -268,61 +268,6 @@ static void iwl_power_sleep_cam_cmd(struct iwl_priv *priv,
 	IWL_DEBUG_POWER(priv, "Sleep command for CAM\n");
 }
 
-static void iwl_power_fill_sleep_cmd(struct iwl_priv *priv,
-				     struct iwl_powertable_cmd *cmd,
-				     int dynps_ms, int wakeup_period)
-{
-	/*
-	 * These are the original power level 3 sleep successions. The
-	 * device may behave better with such succession and was also
-	 * only tested with that. Just like the original sleep commands,
-	 * also adjust the succession here to the wakeup_period below.
-	 * The ranges are the same as for the sleep commands, 0-2, 3-9
-	 * and >10, which is selected based on the DTIM interval for
-	 * the sleep index but here we use the wakeup period since that
-	 * is what we need to do for the latency requirements.
-	 */
-	static const u8 slp_succ_r0[IWL_POWER_VEC_SIZE] = { 2, 2, 2, 2, 2 };
-	static const u8 slp_succ_r1[IWL_POWER_VEC_SIZE] = { 2, 4, 6, 7, 9 };
-	static const u8 slp_succ_r2[IWL_POWER_VEC_SIZE] = { 2, 7, 9, 9, 0xFF };
-	const u8 *slp_succ = slp_succ_r0;
-	int i;
-
-	if (wakeup_period > IWL_DTIM_RANGE_0_MAX)
-		slp_succ = slp_succ_r1;
-	if (wakeup_period > IWL_DTIM_RANGE_1_MAX)
-		slp_succ = slp_succ_r2;
-
-	memset(cmd, 0, sizeof(*cmd));
-
-	cmd->flags = IWL_POWER_DRIVER_ALLOW_SLEEP_MSK |
-		     IWL_POWER_FAST_PD; /* no use seeing frames for others */
-
-	if (priv->power_data.bus_pm)
-		cmd->flags |= IWL_POWER_PCI_PM_MSK;
-
-	if (cfg(priv)->base_params->shadow_reg_enable)
-		cmd->flags |= IWL_POWER_SHADOW_REG_ENA;
-	else
-		cmd->flags &= ~IWL_POWER_SHADOW_REG_ENA;
-
-	if (iwl_advanced_bt_coexist(priv)) {
-		if (!cfg(priv)->bt_params->bt_sco_disable)
-			cmd->flags |= IWL_POWER_BT_SCO_ENA;
-		else
-			cmd->flags &= ~IWL_POWER_BT_SCO_ENA;
-	}
-
-	cmd->rx_data_timeout = cpu_to_le32(1000 * dynps_ms);
-	cmd->tx_data_timeout = cpu_to_le32(1000 * dynps_ms);
-
-	for (i = 0; i < IWL_POWER_VEC_SIZE; i++)
-		cmd->sleep_interval[i] =
-			cpu_to_le32(min_t(int, slp_succ[i], wakeup_period));
-
-	IWL_DEBUG_POWER(priv, "Automatic sleep command\n");
-}
-
 static int iwl_set_power(struct iwl_priv *priv, struct iwl_powertable_cmd *cmd)
 {
 	IWL_DEBUG_POWER(priv, "Sending power/sleep command\n");
@@ -363,7 +308,7 @@ static void iwl_power_build_cmd(struct iwl_priv *priv,
 		iwl_static_sleep_cmd(priv, cmd,
 				     priv->power_data.debug_sleep_level_override,
 				     dtimper);
-	else if (iwlagn_mod_params.no_sleep_autoadjust) {
+	else {
 		if (iwlagn_mod_params.power_level > IWL_POWER_INDEX_1 &&
 		    iwlagn_mod_params.power_level <= IWL_POWER_INDEX_5)
 			iwl_static_sleep_cmd(priv, cmd,
@@ -371,10 +316,7 @@ static void iwl_power_build_cmd(struct iwl_priv *priv,
 		else
 			iwl_static_sleep_cmd(priv, cmd,
 				IWL_POWER_INDEX_1, dtimper);
-	} else
-		iwl_power_fill_sleep_cmd(priv, cmd,
-					 priv->hw->conf.dynamic_ps_timeout,
-					 priv->hw->conf.max_sleep_period);
+	}
 }
 
 int iwl_power_set_mode(struct iwl_priv *priv, struct iwl_powertable_cmd *cmd,
diff --git a/drivers/net/wireless/iwlwifi/iwl-shared.h b/drivers/net/wireless/iwlwifi/iwl-shared.h
index 4b764d7..00543d9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-shared.h
+++ b/drivers/net/wireless/iwlwifi/iwl-shared.h
@@ -124,7 +124,6 @@ extern struct iwl_mod_params iwlagn_mod_params;
  * @wd_disable: enable stuck queue check, default = 0
  * @bt_coex_active: enable bt coex, default = true
  * @led_mode: system default, default = 0
- * @no_sleep_autoadjust: disable autoadjust, default = true
  * @power_save: disable power save, default = false
  * @power_level: power level, default = 1
  * @debug_level: levels are IWL_DL_*
@@ -143,7 +142,6 @@ struct iwl_mod_params {
 	int  wd_disable;
 	bool bt_coex_active;
 	int led_mode;
-	bool no_sleep_autoadjust;
 	bool power_save;
 	int power_level;
 	u32 debug_level;
-- 
1.7.0.4

