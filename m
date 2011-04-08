Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:56990 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757372Ab1DHPuO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Apr 2011 11:50:14 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 12/16] iwlagn: all _agn devices support power save mode
Date: Fri,  8 Apr 2011 08:30:32 -0700
Message-Id: <1302276636-12802-13-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1302276636-12802-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1302276636-12802-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove broken_power_save checking

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c     |    5 ++---
 drivers/net/wireless/iwlwifi/iwl-core.h    |    1 -
 drivers/net/wireless/iwlwifi/iwl-debugfs.c |    7 ++-----
 drivers/net/wireless/iwlwifi/iwl-power.c   |    4 +---
 4 files changed, 5 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 60bfde7..23b89c2 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -2828,9 +2828,8 @@ static int iwl_mac_setup_register(struct iwl_priv *priv,
 
 	hw->max_tx_aggregation_subframes = LINK_QUAL_AGG_FRAME_LIMIT_DEF;
 
-	if (!priv->cfg->base_params->broken_powersave)
-		hw->flags |= IEEE80211_HW_SUPPORTS_PS |
-			     IEEE80211_HW_SUPPORTS_DYNAMIC_PS;
+	hw->flags |= IEEE80211_HW_SUPPORTS_PS |
+		     IEEE80211_HW_SUPPORTS_DYNAMIC_PS;
 
 	if (priv->cfg->sku & IWL_SKU_N)
 		hw->flags |= IEEE80211_HW_SUPPORTS_DYNAMIC_SMPS |
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 7d303ac..a0530d0 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -269,7 +269,6 @@ struct iwl_base_params {
 	const u16 max_ll_items;
 	const bool shadow_ram_support;
 	u16 led_compensation;
-	const bool broken_powersave;
 	int chain_noise_num_beacons;
 	bool adv_thermal_throttle;
 	bool support_ct_kill_exit;
diff --git a/drivers/net/wireless/iwlwifi/iwl-debugfs.c b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
index 93a8699..2c58980 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debugfs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
@@ -1723,11 +1723,8 @@ int iwl_dbgfs_register(struct iwl_priv *priv, const char *name)
 	DEBUGFS_ADD_FILE(status, dir_data, S_IRUSR);
 	DEBUGFS_ADD_FILE(interrupt, dir_data, S_IWUSR | S_IRUSR);
 	DEBUGFS_ADD_FILE(qos, dir_data, S_IRUSR);
-	if (!priv->cfg->base_params->broken_powersave) {
-		DEBUGFS_ADD_FILE(sleep_level_override, dir_data,
-				 S_IWUSR | S_IRUSR);
-		DEBUGFS_ADD_FILE(current_sleep_command, dir_data, S_IRUSR);
-	}
+	DEBUGFS_ADD_FILE(sleep_level_override, dir_data, S_IWUSR | S_IRUSR);
+	DEBUGFS_ADD_FILE(current_sleep_command, dir_data, S_IRUSR);
 	DEBUGFS_ADD_FILE(thermal_throttling, dir_data, S_IRUSR);
 	DEBUGFS_ADD_FILE(disable_ht40, dir_data, S_IWUSR | S_IRUSR);
 	DEBUGFS_ADD_FILE(rx_statistics, dir_debug, S_IRUSR);
diff --git a/drivers/net/wireless/iwlwifi/iwl-power.c b/drivers/net/wireless/iwlwifi/iwl-power.c
index c43c8e6..ae176d8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-power.c
+++ b/drivers/net/wireless/iwlwifi/iwl-power.c
@@ -354,9 +354,7 @@ static void iwl_power_build_cmd(struct iwl_priv *priv,
 
 	dtimper = priv->hw->conf.ps_dtim_period ?: 1;
 
-	if (priv->cfg->base_params->broken_powersave)
-		iwl_power_sleep_cam_cmd(priv, cmd);
-	else if (priv->hw->conf.flags & IEEE80211_CONF_IDLE)
+	if (priv->hw->conf.flags & IEEE80211_CONF_IDLE)
 		iwl_static_sleep_cmd(priv, cmd, IWL_POWER_INDEX_5, 20);
 	else if (priv->cfg->ops->lib->tt_ops.lower_power_detection &&
 		 priv->cfg->ops->lib->tt_ops.tt_power_mode &&
-- 
1.7.0.4

