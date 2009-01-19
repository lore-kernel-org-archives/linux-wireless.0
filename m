Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:4998 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753404AbZASX2O (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Jan 2009 18:28:14 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	"Winkler, Tomas" <tomas.winkler@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 01/15] iwlwifi: make iwl-power.c more readable
Date: Mon, 19 Jan 2009 15:30:21 -0800
Message-Id: <1232407835-19451-2-git-send-email-reinette.chatre@intel.com> (sfid-20090120_002824_950057_63F5A679)
In-Reply-To: <1232407835-19451-1-git-send-email-reinette.chatre@intel.com>
References: <>
 <1232407835-19451-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Winkler, Tomas <tomas.winkler@intel.com>

This patch rearrange code in iwl-power.c function to make it a little more
readable. No functional changes.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-power.c |   51 ++++++++++++++----------------
 1 files changed, 24 insertions(+), 27 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-power.c b/drivers/net/wireless/iwlwifi/iwl-power.c
index a9f9ffe..0276d51 100644
--- a/drivers/net/wireless/iwlwifi/iwl-power.c
+++ b/drivers/net/wireless/iwlwifi/iwl-power.c
@@ -149,7 +149,7 @@ static u16 iwl_get_auto_power_mode(struct iwl_priv *priv)
 }
 
 /* initialize to default */
-static int iwl_power_init_handle(struct iwl_priv *priv)
+static void iwl_power_init_handle(struct iwl_priv *priv)
 {
 	struct iwl_power_mgr *pow_data;
 	int size = sizeof(struct iwl_power_vec_entry) * IWL_POWER_MAX;
@@ -159,7 +159,7 @@ static int iwl_power_init_handle(struct iwl_priv *priv)
 
 	IWL_DEBUG_POWER("Initialize power \n");
 
-	pow_data = &(priv->power_data);
+	pow_data = &priv->power_data;
 
 	memset(pow_data, 0, sizeof(*pow_data));
 
@@ -179,26 +179,25 @@ static int iwl_power_init_handle(struct iwl_priv *priv)
 		else
 			cmd->flags |= IWL_POWER_PCI_PM_MSK;
 	}
-	return 0;
 }
 
 /* adjust power command according to DTIM period and power level*/
-static int iwl_update_power_command(struct iwl_priv *priv,
-				    struct iwl_powertable_cmd *cmd,
-				    u16 mode)
+static int iwl_update_power_cmd(struct iwl_priv *priv,
+				struct iwl_powertable_cmd *cmd, u16 mode)
 {
-	int ret = 0, i;
-	u8 skip;
-	u32 max_sleep = 0;
 	struct iwl_power_vec_entry *range;
-	u8 period = 0;
 	struct iwl_power_mgr *pow_data;
+	int i;
+	u32 max_sleep = 0;
+	u8 period;
+	bool skip;
 
 	if (mode > IWL_POWER_INDEX_5) {
 		IWL_DEBUG_POWER("Error invalid power mode \n");
-		return -1;
+		return -EINVAL;
 	}
-	pow_data = &(priv->power_data);
+
+	pow_data = &priv->power_data;
 
 	if (pow_data->dtim_period <= IWL_POWER_RANGE_0_MAX)
 		range = &pow_data->pwr_range_0[0];
@@ -212,14 +211,12 @@ static int iwl_update_power_command(struct iwl_priv *priv,
 
 	if (period == 0) {
 		period = 1;
-		skip = 0;
-	} else
-		skip = range[mode].no_dtim;
-
-	if (skip == 0) {
-		max_sleep = period;
-		cmd->flags &= ~IWL_POWER_SLEEP_OVER_DTIM_MSK;
+		skip = false;
 	} else {
+		skip = !!range[mode].no_dtim;
+	}
+
+	if (skip) {
 		__le32 slp_itrvl = cmd->sleep_interval[IWL_POWER_VEC_SIZE - 1];
 		max_sleep = le32_to_cpu(slp_itrvl);
 		if (max_sleep == 0xFF)
@@ -227,12 +224,14 @@ static int iwl_update_power_command(struct iwl_priv *priv,
 		else if (max_sleep >  period)
 			max_sleep = (le32_to_cpu(slp_itrvl) / period) * period;
 		cmd->flags |= IWL_POWER_SLEEP_OVER_DTIM_MSK;
+	} else {
+		max_sleep = period;
+		cmd->flags &= ~IWL_POWER_SLEEP_OVER_DTIM_MSK;
 	}
 
-	for (i = 0; i < IWL_POWER_VEC_SIZE; i++) {
+	for (i = 0; i < IWL_POWER_VEC_SIZE; i++)
 		if (le32_to_cpu(cmd->sleep_interval[i]) > max_sleep)
 			cmd->sleep_interval[i] = cpu_to_le32(max_sleep);
-	}
 
 	IWL_DEBUG_POWER("Flags value = 0x%08X\n", cmd->flags);
 	IWL_DEBUG_POWER("Tx timeout = %u\n", le32_to_cpu(cmd->tx_data_timeout));
@@ -244,7 +243,7 @@ static int iwl_update_power_command(struct iwl_priv *priv,
 			le32_to_cpu(cmd->sleep_interval[3]),
 			le32_to_cpu(cmd->sleep_interval[4]));
 
-	return ret;
+	return 0;
 }
 
 
@@ -295,7 +294,7 @@ int iwl_power_update_mode(struct iwl_priv *priv, bool force)
 		if (final_mode != IWL_POWER_MODE_CAM)
 			set_bit(STATUS_POWER_PMI, &priv->status);
 
-		iwl_update_power_command(priv, &cmd, final_mode);
+		iwl_update_power_cmd(priv, &cmd, final_mode);
 		cmd.keep_alive_beacons = 0;
 
 		if (final_mode == IWL_POWER_INDEX_5)
@@ -392,13 +391,11 @@ EXPORT_SYMBOL(iwl_power_set_system_mode);
 /* initialize to default */
 void iwl_power_initialize(struct iwl_priv *priv)
 {
-
 	iwl_power_init_handle(priv);
 	priv->power_data.user_power_setting = IWL_POWER_AUTO;
-	priv->power_data.power_disabled = 0;
 	priv->power_data.system_power_setting = IWL_POWER_SYS_AUTO;
-	priv->power_data.is_battery_active = 0;
 	priv->power_data.power_disabled = 0;
+	priv->power_data.is_battery_active = 0;
 	priv->power_data.critical_power_setting = 0;
 }
 EXPORT_SYMBOL(iwl_power_initialize);
@@ -407,8 +404,8 @@ EXPORT_SYMBOL(iwl_power_initialize);
 int iwl_power_temperature_change(struct iwl_priv *priv)
 {
 	int ret = 0;
-	u16 new_critical = priv->power_data.critical_power_setting;
 	s32 temperature = KELVIN_TO_CELSIUS(priv->last_temperature);
+	u16 new_critical = priv->power_data.critical_power_setting;
 
 	if (temperature > IWL_CT_KILL_TEMPERATURE)
 		return 0;
-- 
1.5.4.3

