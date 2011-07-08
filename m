Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:50973 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752201Ab1GHQUi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jul 2011 12:20:38 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Fry, Donald H" <donald.h.fry@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 09/21] iwlagn: remove the indirection for update_chain_flags
Date: Fri,  8 Jul 2011 08:46:17 -0700
Message-Id: <1310139989-27661-10-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110708_182106_629285_C70D3245)
In-Reply-To: <1310139989-27661-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1310139989-27661-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Fry, Donald H <donald.h.fry@intel.com>

Not needed since the driver split.

Signed-off-by: Don Fry <donald.h.fry@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-1000.c      |    1 -
 drivers/net/wireless/iwlwifi/iwl-2000.c      |    1 -
 drivers/net/wireless/iwlwifi/iwl-5000.c      |    2 --
 drivers/net/wireless/iwlwifi/iwl-6000.c      |    2 --
 drivers/net/wireless/iwlwifi/iwl-agn-calib.c |    3 +--
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c   |    3 +--
 drivers/net/wireless/iwlwifi/iwl-core.h      |    3 ---
 drivers/net/wireless/iwlwifi/iwl-power.c     |    6 +++---
 8 files changed, 5 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-1000.c b/drivers/net/wireless/iwlwifi/iwl-1000.c
index 9cc161d..11f10c1 100644
--- a/drivers/net/wireless/iwlwifi/iwl-1000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-1000.c
@@ -171,7 +171,6 @@ static struct iwl_lib_ops iwl1000_lib = {
 	.rx_handler_setup = iwlagn_rx_handler_setup,
 	.setup_deferred_work = iwlagn_setup_deferred_work,
 	.is_valid_rtc_data_addr = iwlagn_hw_valid_rtc_data_addr,
-	.update_chain_flags = iwl_update_chain_flags,
 	.apm_ops = {
 		.init = iwl_apm_init,
 		.config = iwl1000_nic_config,
diff --git a/drivers/net/wireless/iwlwifi/iwl-2000.c b/drivers/net/wireless/iwlwifi/iwl-2000.c
index 0c32450..953e967 100644
--- a/drivers/net/wireless/iwlwifi/iwl-2000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-2000.c
@@ -171,7 +171,6 @@ static struct iwl_lib_ops iwl2000_lib = {
 	.setup_deferred_work = iwlagn_bt_setup_deferred_work,
 	.cancel_deferred_work = iwlagn_bt_cancel_deferred_work,
 	.is_valid_rtc_data_addr = iwlagn_hw_valid_rtc_data_addr,
-	.update_chain_flags = iwl_update_chain_flags,
 	.apm_ops = {
 		.init = iwl_apm_init,
 		.config = iwl2000_nic_config,
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index 835ed7a..f6bc02f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -323,7 +323,6 @@ static struct iwl_lib_ops iwl5000_lib = {
 	.rx_handler_setup = iwlagn_rx_handler_setup,
 	.setup_deferred_work = iwlagn_setup_deferred_work,
 	.is_valid_rtc_data_addr = iwlagn_hw_valid_rtc_data_addr,
-	.update_chain_flags = iwl_update_chain_flags,
 	.set_channel_switch = iwl5000_hw_channel_switch,
 	.apm_ops = {
 		.init = iwl_apm_init,
@@ -351,7 +350,6 @@ static struct iwl_lib_ops iwl5150_lib = {
 	.rx_handler_setup = iwlagn_rx_handler_setup,
 	.setup_deferred_work = iwlagn_setup_deferred_work,
 	.is_valid_rtc_data_addr = iwlagn_hw_valid_rtc_data_addr,
-	.update_chain_flags = iwl_update_chain_flags,
 	.set_channel_switch = iwl5000_hw_channel_switch,
 	.apm_ops = {
 		.init = iwl_apm_init,
diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index f03448f..91418fa 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -263,7 +263,6 @@ static struct iwl_lib_ops iwl6000_lib = {
 	.rx_handler_setup = iwlagn_rx_handler_setup,
 	.setup_deferred_work = iwlagn_setup_deferred_work,
 	.is_valid_rtc_data_addr = iwlagn_hw_valid_rtc_data_addr,
-	.update_chain_flags = iwl_update_chain_flags,
 	.set_channel_switch = iwl6000_hw_channel_switch,
 	.apm_ops = {
 		.init = iwl_apm_init,
@@ -293,7 +292,6 @@ static struct iwl_lib_ops iwl6030_lib = {
 	.setup_deferred_work = iwlagn_bt_setup_deferred_work,
 	.cancel_deferred_work = iwlagn_bt_cancel_deferred_work,
 	.is_valid_rtc_data_addr = iwlagn_hw_valid_rtc_data_addr,
-	.update_chain_flags = iwl_update_chain_flags,
 	.set_channel_switch = iwl6000_hw_channel_switch,
 	.apm_ops = {
 		.init = iwl_apm_init,
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-calib.c b/drivers/net/wireless/iwlwifi/iwl-agn-calib.c
index 2ec3863..710ada9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-calib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-calib.c
@@ -1001,8 +1001,7 @@ void iwl_chain_noise_calibration(struct iwl_priv *priv)
 	/* Some power changes may have been made during the calibration.
 	 * Update and commit the RXON
 	 */
-	if (priv->cfg->ops->lib->update_chain_flags)
-		priv->cfg->ops->lib->update_chain_flags(priv);
+	iwl_update_chain_flags(priv);
 
 	data->state = IWL_CHAIN_NOISE_DONE;
 	iwl_power_update_mode(priv, false);
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index cfe945c..c7102bb 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -1724,8 +1724,7 @@ static void iwlagn_bt_traffic_change_work(struct work_struct *work)
 	if (test_bit(STATUS_SCAN_HW, &priv->status))
 		goto out;
 
-	if (priv->cfg->ops->lib->update_chain_flags)
-		priv->cfg->ops->lib->update_chain_flags(priv);
+	iwl_update_chain_flags(priv);
 
 	if (smps_request != -1) {
 		priv->current_ht_config.smps = smps_request;
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 3f7b921..e1ab1a1 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -121,9 +121,6 @@ struct iwl_lib_ops {
 	/* power management */
 	struct iwl_apm_ops apm_ops;
 
-	/* power */
-	void (*update_chain_flags)(struct iwl_priv *priv);
-
 	/* eeprom operations (as defined in iwl-eeprom.h) */
 	struct iwl_eeprom_ops eeprom_ops;
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-power.c b/drivers/net/wireless/iwlwifi/iwl-power.c
index 9c10462..64ff40a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-power.c
+++ b/drivers/net/wireless/iwlwifi/iwl-power.c
@@ -406,9 +406,9 @@ int iwl_power_set_mode(struct iwl_priv *priv, struct iwl_powertable_cmd *cmd,
 		if (!(cmd->flags & IWL_POWER_DRIVER_ALLOW_SLEEP_MSK))
 			clear_bit(STATUS_POWER_PMI, &priv->status);
 
-		if (priv->cfg->ops->lib->update_chain_flags && update_chains)
-			priv->cfg->ops->lib->update_chain_flags(priv);
-		else if (priv->cfg->ops->lib->update_chain_flags)
+		if (update_chains)
+			iwl_update_chain_flags(priv);
+		else
 			IWL_DEBUG_POWER(priv,
 					"Cannot update the power, chain noise "
 					"calibration running: %d\n",
-- 
1.7.0.4

