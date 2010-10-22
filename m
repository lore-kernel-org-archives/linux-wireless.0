Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:26699 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756270Ab0JVPCD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Oct 2010 11:02:03 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 6/7] iwlwifi: defer update power mode while scan
Date: Fri, 22 Oct 2010 17:04:29 +0200
Message-Id: <1287759870-5758-6-git-send-email-sgruszka@redhat.com>
In-Reply-To: <1287759870-5758-1-git-send-email-sgruszka@redhat.com>
References: <1287759870-5758-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Do not set power mode when scanning, and defer that when scan finish.
We still set power mode in force case i.e. when device is overheated.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlwifi/iwl-power.c |   95 +++++++++++++++++++-----------
 drivers/net/wireless/iwlwifi/iwl-power.h |    3 +
 drivers/net/wireless/iwlwifi/iwl-scan.c  |    1 +
 3 files changed, 64 insertions(+), 35 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-power.c b/drivers/net/wireless/iwlwifi/iwl-power.c
index 49d7788..b7abd86 100644
--- a/drivers/net/wireless/iwlwifi/iwl-power.c
+++ b/drivers/net/wireless/iwlwifi/iwl-power.c
@@ -263,70 +263,95 @@ static int iwl_set_power(struct iwl_priv *priv, struct iwl_powertable_cmd *cmd)
 				sizeof(struct iwl_powertable_cmd), cmd);
 }
 
-/* priv->mutex must be held */
-int iwl_power_update_mode(struct iwl_priv *priv, bool force)
+static void iwl_power_build_cmd(struct iwl_priv *priv,
+				struct iwl_powertable_cmd *cmd)
 {
-	int ret = 0;
 	bool enabled = priv->hw->conf.flags & IEEE80211_CONF_PS;
-	bool update_chains;
-	struct iwl_powertable_cmd cmd;
 	int dtimper;
 
-	/* Don't update the RX chain when chain noise calibration is running */
-	update_chains = priv->chain_noise_data.state == IWL_CHAIN_NOISE_DONE ||
-			priv->chain_noise_data.state == IWL_CHAIN_NOISE_ALIVE;
-
 	dtimper = priv->hw->conf.ps_dtim_period ?: 1;
 
 	if (priv->cfg->base_params->broken_powersave)
-		iwl_power_sleep_cam_cmd(priv, &cmd);
+		iwl_power_sleep_cam_cmd(priv, cmd);
 	else if (priv->cfg->base_params->supports_idle &&
 		 priv->hw->conf.flags & IEEE80211_CONF_IDLE)
-		iwl_static_sleep_cmd(priv, &cmd, IWL_POWER_INDEX_5, 20);
+		iwl_static_sleep_cmd(priv, cmd, IWL_POWER_INDEX_5, 20);
 	else if (priv->cfg->ops->lib->tt_ops.lower_power_detection &&
 		 priv->cfg->ops->lib->tt_ops.tt_power_mode &&
 		 priv->cfg->ops->lib->tt_ops.lower_power_detection(priv)) {
 		/* in thermal throttling low power state */
-		iwl_static_sleep_cmd(priv, &cmd,
+		iwl_static_sleep_cmd(priv, cmd,
 		    priv->cfg->ops->lib->tt_ops.tt_power_mode(priv), dtimper);
 	} else if (!enabled)
-		iwl_power_sleep_cam_cmd(priv, &cmd);
+		iwl_power_sleep_cam_cmd(priv, cmd);
 	else if (priv->power_data.debug_sleep_level_override >= 0)
-		iwl_static_sleep_cmd(priv, &cmd,
+		iwl_static_sleep_cmd(priv, cmd,
 				     priv->power_data.debug_sleep_level_override,
 				     dtimper);
 	else if (no_sleep_autoadjust)
-		iwl_static_sleep_cmd(priv, &cmd, IWL_POWER_INDEX_1, dtimper);
+		iwl_static_sleep_cmd(priv, cmd, IWL_POWER_INDEX_1, dtimper);
 	else
-		iwl_power_fill_sleep_cmd(priv, &cmd,
+		iwl_power_fill_sleep_cmd(priv, cmd,
 					 priv->hw->conf.dynamic_ps_timeout,
 					 priv->hw->conf.max_sleep_period);
+}
+
+int iwl_power_set_mode(struct iwl_priv *priv, struct iwl_powertable_cmd *cmd,
+		       bool force)
+{
+	int ret;
+	bool update_chains;
+
+	lockdep_assert_held(&priv->mutex);
+
+	/* Don't update the RX chain when chain noise calibration is running */
+	update_chains = priv->chain_noise_data.state == IWL_CHAIN_NOISE_DONE ||
+			priv->chain_noise_data.state == IWL_CHAIN_NOISE_ALIVE;
+
+	if (!memcmp(&priv->power_data.sleep_cmd, cmd, sizeof(*cmd)) && !force)
+		return 0;
+
+	if (!iwl_is_ready_rf(priv))
+		return -EIO;
+
+	/* scan complete use sleep_power_next, need to be updated */
+	memcpy(&priv->power_data.sleep_cmd_next, cmd, sizeof(*cmd));
+	if (test_bit(STATUS_SCANNING, &priv->status) && !force) {
+		IWL_DEBUG_INFO(priv, "Defer power set mode while scanning\n");
+		return 0;
+	}
+
+	if (cmd->flags & IWL_POWER_DRIVER_ALLOW_SLEEP_MSK)
+		set_bit(STATUS_POWER_PMI, &priv->status);
 
-	if (iwl_is_ready_rf(priv) &&
-	    (memcmp(&priv->power_data.sleep_cmd, &cmd, sizeof(cmd)) || force)) {
-		if (cmd.flags & IWL_POWER_DRIVER_ALLOW_SLEEP_MSK)
-			set_bit(STATUS_POWER_PMI, &priv->status);
-
-		ret = iwl_set_power(priv, &cmd);
-		if (!ret) {
-			if (!(cmd.flags & IWL_POWER_DRIVER_ALLOW_SLEEP_MSK))
-				clear_bit(STATUS_POWER_PMI, &priv->status);
-
-			if (priv->cfg->ops->lib->update_chain_flags &&
-			    update_chains)
-				priv->cfg->ops->lib->update_chain_flags(priv);
-			else if (priv->cfg->ops->lib->update_chain_flags)
-				IWL_DEBUG_POWER(priv,
+	ret = iwl_set_power(priv, cmd);
+	if (!ret) {
+		if (!(cmd->flags & IWL_POWER_DRIVER_ALLOW_SLEEP_MSK))
+			clear_bit(STATUS_POWER_PMI, &priv->status);
+
+		if (priv->cfg->ops->lib->update_chain_flags && update_chains)
+			priv->cfg->ops->lib->update_chain_flags(priv);
+		else if (priv->cfg->ops->lib->update_chain_flags)
+			IWL_DEBUG_POWER(priv,
 					"Cannot update the power, chain noise "
 					"calibration running: %d\n",
 					priv->chain_noise_data.state);
-			memcpy(&priv->power_data.sleep_cmd, &cmd, sizeof(cmd));
-		} else
-			IWL_ERR(priv, "set power fail, ret = %d", ret);
-	}
+
+		memcpy(&priv->power_data.sleep_cmd, cmd, sizeof(*cmd));
+	} else
+		IWL_ERR(priv, "set power fail, ret = %d", ret);
 
 	return ret;
 }
+EXPORT_SYMBOL(iwl_power_set_mode);
+
+int iwl_power_update_mode(struct iwl_priv *priv, bool force)
+{
+	struct iwl_powertable_cmd cmd;
+
+	iwl_power_build_cmd(priv, &cmd);
+	return iwl_power_set_mode(priv, &cmd, force);
+}
 EXPORT_SYMBOL(iwl_power_update_mode);
 
 /* initialize to default */
diff --git a/drivers/net/wireless/iwlwifi/iwl-power.h b/drivers/net/wireless/iwlwifi/iwl-power.h
index df81565..fe01203 100644
--- a/drivers/net/wireless/iwlwifi/iwl-power.h
+++ b/drivers/net/wireless/iwlwifi/iwl-power.h
@@ -41,10 +41,13 @@ enum iwl_power_level {
 
 struct iwl_power_mgr {
 	struct iwl_powertable_cmd sleep_cmd;
+	struct iwl_powertable_cmd sleep_cmd_next;
 	int debug_sleep_level_override;
 	bool pci_pm;
 };
 
+int iwl_power_set_mode(struct iwl_priv *priv, struct iwl_powertable_cmd *cmd,
+		       bool force);
 int iwl_power_update_mode(struct iwl_priv *priv, bool force);
 void iwl_power_initialize(struct iwl_priv *priv);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-scan.c b/drivers/net/wireless/iwlwifi/iwl-scan.c
index d63e30e..e1aa0e1 100644
--- a/drivers/net/wireless/iwlwifi/iwl-scan.c
+++ b/drivers/net/wireless/iwlwifi/iwl-scan.c
@@ -607,6 +607,7 @@ out_settings:
 	 * We do not commit power settings while scan is pending,
 	 * do it now if the settings changed.
 	 */
+	iwl_power_set_mode(priv, &priv->power_data.sleep_cmd_next, false);
 	iwl_set_tx_power(priv, priv->tx_power_next, false);
 
 	priv->cfg->ops->utils->post_scan(priv);
-- 
1.7.1

