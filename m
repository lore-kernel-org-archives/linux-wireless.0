Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:54091 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751643AbYGRF4R (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Jul 2008 01:56:17 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Mohamed Abbas <mohamed.abbas@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 01/13] iwlwifi: add power save to 5000 HW
Date: Fri, 18 Jul 2008 13:52:57 +0800
Message-Id: <1216360389-5352-2-git-send-email-yi.zhu@intel.com> (sfid-20080718_075625_218492_84EBE78A)
In-Reply-To: <1216360389-5352-1-git-send-email-yi.zhu@intel.com>
References: <1216360389-5352-1-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohamed Abbas <mohamed.abbas@intel.com>

This patch adds support for power save for 5000 HW.

Signed-off-by: Mohamed Abbas <mohamed.abbas@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965.c     |   13 -------------
 drivers/net/wireless/iwlwifi/iwl-5000.c     |    1 +
 drivers/net/wireless/iwlwifi/iwl-commands.h |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-core.h     |    1 -
 drivers/net/wireless/iwlwifi/iwl-dev.h      |    3 ++-
 drivers/net/wireless/iwlwifi/iwl-power.c    |   18 ++++++++++++------
 drivers/net/wireless/iwlwifi/iwl-power.h    |    2 +-
 7 files changed, 18 insertions(+), 24 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 9afecb8..a419aee 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -875,18 +875,6 @@ static int iwl4965_hw_set_hw_params(struct iwl_priv *priv)
 	return 0;
 }
 
-/* set card power command */
-static int iwl4965_set_power(struct iwl_priv *priv,
-		      void *cmd)
-{
-	int ret = 0;
-
-	ret = iwl_send_cmd_pdu_async(priv, POWER_TABLE_CMD,
-				    sizeof(struct iwl4965_powertable_cmd),
-				    cmd, NULL);
-	return ret;
-}
-
 static s32 iwl4965_math_div_round(s32 num, s32 denom, s32 *res)
 {
 	s32 sign = 1;
@@ -2440,7 +2428,6 @@ static struct iwl_lib_ops iwl4965_lib = {
 		.check_version = iwl4965_eeprom_check_version,
 		.query_addr = iwlcore_eeprom_query_addr,
 	},
-	.set_power = iwl4965_set_power,
 	.send_tx_power	= iwl4965_send_tx_power,
 	.update_chain_flags = iwl4965_update_chain_flags,
 	.temperature = iwl4965_temperature_calib,
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index 878d619..f91c54b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -1474,6 +1474,7 @@ static struct iwl_lib_ops iwl5000_lib = {
 	.alive_notify = iwl5000_alive_notify,
 	.send_tx_power = iwl5000_send_tx_power,
 	.temperature = iwl5000_temperature,
+	.update_chain_flags = iwl4965_update_chain_flags,
 	.apm_ops = {
 		.init =	iwl5000_apm_init,
 		.reset = iwl5000_apm_reset,
diff --git a/drivers/net/wireless/iwlwifi/iwl-commands.h b/drivers/net/wireless/iwlwifi/iwl-commands.h
index e9bb1de..6f3555f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-commands.h
@@ -1993,7 +1993,7 @@ struct iwl4965_spectrum_notification {
  *****************************************************************************/
 
 /**
- * struct iwl4965_powertable_cmd - Power Table Command
+ * struct iwl_powertable_cmd - Power Table Command
  * @flags: See below:
  *
  * POWER_TABLE_CMD = 0x77 (command, has simple generic response)
@@ -2027,7 +2027,7 @@ struct iwl4965_spectrum_notification {
 #define IWL_POWER_PCI_PM_MSK			__constant_cpu_to_le16(1 << 3)
 #define IWL_POWER_FAST_PD			__constant_cpu_to_le16(1 << 4)
 
-struct iwl4965_powertable_cmd {
+struct iwl_powertable_cmd {
 	__le16 flags;
 	u8 keep_alive_seconds;
 	u8 debug_flags;
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index db66114..eaefa42 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -139,7 +139,6 @@ struct iwl_lib_ops {
 		int (*set_pwr_src)(struct iwl_priv *priv, enum iwl_pwr_src src);
 	} apm_ops;
 	/* power */
-	int (*set_power)(struct iwl_priv *priv, void *cmd);
 	int (*send_tx_power) (struct iwl_priv *priv);
 	void (*update_chain_flags)(struct iwl_priv *priv);
 	void (*temperature) (struct iwl_priv *priv);
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 4d789e3..010ed69 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -283,7 +283,7 @@ struct iwl_cmd {
 		u32 val32;
 		struct iwl4965_bt_cmd bt;
 		struct iwl4965_rxon_time_cmd rxon_time;
-		struct iwl4965_powertable_cmd powertable;
+		struct iwl_powertable_cmd powertable;
 		struct iwl_qosparam_cmd qosparam;
 		struct iwl_tx_cmd tx;
 		struct iwl4965_tx_beacon_cmd tx_beacon;
@@ -590,6 +590,7 @@ extern unsigned int iwl4965_fill_beacon_frame(struct iwl_priv *priv,
 					const u8 *dest, int left);
 extern void iwl4965_update_chain_flags(struct iwl_priv *priv);
 int iwl4965_set_pwr_src(struct iwl_priv *priv, enum iwl_pwr_src src);
+extern int iwl4965_set_power(struct iwl_priv *priv, void *cmd);
 
 extern const u8 iwl_bcast_addr[ETH_ALEN];
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-power.c b/drivers/net/wireless/iwlwifi/iwl-power.c
index 2e71803..e3c71be 100644
--- a/drivers/net/wireless/iwlwifi/iwl-power.c
+++ b/drivers/net/wireless/iwlwifi/iwl-power.c
@@ -112,6 +112,13 @@ static struct iwl_power_vec_entry range_2[IWL_POWER_AC] = {
 	{{SLP, SLP_TOUT(25), SLP_TOUT(25), SLP_VEC(4, 7, 10, 10, 0xFF)}, 0}
 };
 
+/* set card power command */
+static int iwl_set_power(struct iwl_priv *priv, void *cmd)
+{
+	return iwl_send_cmd_pdu_async(priv, POWER_TABLE_CMD,
+				      sizeof(struct iwl_powertable_cmd),
+				      cmd, NULL);
+}
 /* decide the right power level according to association status
  * and battery status
  */
@@ -162,7 +169,7 @@ static int iwl_power_init_handle(struct iwl_priv *priv)
 	if (ret != 0)
 		return 0;
 	else {
-		struct iwl4965_powertable_cmd *cmd;
+		struct iwl_powertable_cmd *cmd;
 
 		IWL_DEBUG_POWER("adjust power command flags\n");
 
@@ -180,7 +187,7 @@ static int iwl_power_init_handle(struct iwl_priv *priv)
 
 /* adjust power command according to dtim period and power level*/
 static int iwl_update_power_command(struct iwl_priv *priv,
-				    struct iwl4965_powertable_cmd *cmd,
+				    struct iwl_powertable_cmd *cmd,
 				    u16 mode)
 {
 	int ret = 0, i;
@@ -204,7 +211,7 @@ static int iwl_update_power_command(struct iwl_priv *priv,
 		range = &pow_data->pwr_range_2[0];
 
 	period = pow_data->dtim_period;
-	memcpy(cmd, &range[mode].cmd, sizeof(struct iwl4965_powertable_cmd));
+	memcpy(cmd, &range[mode].cmd, sizeof(struct iwl_powertable_cmd));
 
 	if (period == 0) {
 		period = 1;
@@ -280,7 +287,7 @@ int iwl_power_update_mode(struct iwl_priv *priv, u8 refresh)
 
 	if (!iwl_is_rfkill(priv) && !setting->power_disabled &&
 	    ((setting->power_mode != final_mode) || refresh)) {
-		struct iwl4965_powertable_cmd cmd;
+		struct iwl_powertable_cmd cmd;
 
 		if (final_mode != IWL_POWER_MODE_CAM)
 			set_bit(STATUS_POWER_PMI, &priv->status);
@@ -291,8 +298,7 @@ int iwl_power_update_mode(struct iwl_priv *priv, u8 refresh)
 		if (final_mode == IWL_POWER_INDEX_5)
 			cmd.flags |= IWL_POWER_FAST_PD;
 
-		if (priv->cfg->ops->lib->set_power)
-			ret = priv->cfg->ops->lib->set_power(priv, &cmd);
+		ret = iwl_set_power(priv, &cmd);
 
 		if (final_mode == IWL_POWER_MODE_CAM)
 			clear_bit(STATUS_POWER_PMI, &priv->status);
diff --git a/drivers/net/wireless/iwlwifi/iwl-power.h b/drivers/net/wireless/iwlwifi/iwl-power.h
index b066724..801f614 100644
--- a/drivers/net/wireless/iwlwifi/iwl-power.h
+++ b/drivers/net/wireless/iwlwifi/iwl-power.h
@@ -46,7 +46,7 @@ struct iwl_priv;
 /* Power management (not Tx power) structures */
 
 struct iwl_power_vec_entry {
-	struct iwl4965_powertable_cmd cmd;
+	struct iwl_powertable_cmd cmd;
 	u8 no_dtim;
 };
 
-- 
1.5.3.6

