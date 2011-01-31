Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:46204 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754301Ab1AaVxS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Jan 2011 16:53:18 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 04/11] iwlwifi: always support idle mode for agn devices
Date: Mon, 31 Jan 2011 13:40:40 -0800
Message-Id: <1296510047-24576-5-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1296510047-24576-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1296510047-24576-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

For agn devices, always support idle mode which help power
consumption in idle unassociated state.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-1000.c  |    1 -
 drivers/net/wireless/iwlwifi/iwl-2000.c  |    2 --
 drivers/net/wireless/iwlwifi/iwl-6000.c  |    3 ---
 drivers/net/wireless/iwlwifi/iwl-core.h  |    1 -
 drivers/net/wireless/iwlwifi/iwl-power.c |    3 +--
 5 files changed, 1 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-1000.c b/drivers/net/wireless/iwlwifi/iwl-1000.c
index 127723e..ba78bc8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-1000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-1000.c
@@ -270,7 +270,6 @@ static struct iwl_base_params iwl1000_base_params = {
 	.ucode_tracing = true,
 	.sensitivity_calib_by_driver = true,
 	.chain_noise_calib_by_driver = true,
-	.supports_idle = true,
 };
 static struct iwl_ht_params iwl1000_ht_params = {
 	.ht_greenfield_support = true,
diff --git a/drivers/net/wireless/iwlwifi/iwl-2000.c b/drivers/net/wireless/iwlwifi/iwl-2000.c
index ac5996f..8d637e7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-2000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-2000.c
@@ -368,7 +368,6 @@ static struct iwl_base_params iwl2000_base_params = {
 	.shadow_ram_support = true,
 	.led_compensation = 51,
 	.chain_noise_num_beacons = IWL_CAL_NUM_BEACONS,
-	.supports_idle = true,
 	.adv_thermal_throttle = true,
 	.support_ct_kill_exit = true,
 	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_THRESHOLD_DEF,
@@ -393,7 +392,6 @@ static struct iwl_base_params iwl2030_base_params = {
 	.shadow_ram_support = true,
 	.led_compensation = 57,
 	.chain_noise_num_beacons = IWL_CAL_NUM_BEACONS,
-	.supports_idle = true,
 	.adv_thermal_throttle = true,
 	.support_ct_kill_exit = true,
 	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_THRESHOLD_DEF,
diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index c195674..aa32b1e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -479,7 +479,6 @@ static struct iwl_base_params iwl6000_base_params = {
 	.shadow_ram_support = true,
 	.led_compensation = 51,
 	.chain_noise_num_beacons = IWL_CAL_NUM_BEACONS,
-	.supports_idle = true,
 	.adv_thermal_throttle = true,
 	.support_ct_kill_exit = true,
 	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_THRESHOLD_DEF,
@@ -503,7 +502,6 @@ static struct iwl_base_params iwl6050_base_params = {
 	.shadow_ram_support = true,
 	.led_compensation = 51,
 	.chain_noise_num_beacons = IWL_CAL_NUM_BEACONS,
-	.supports_idle = true,
 	.adv_thermal_throttle = true,
 	.support_ct_kill_exit = true,
 	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_THRESHOLD_DEF,
@@ -526,7 +524,6 @@ static struct iwl_base_params iwl6000_g2_base_params = {
 	.shadow_ram_support = true,
 	.led_compensation = 57,
 	.chain_noise_num_beacons = IWL_CAL_NUM_BEACONS,
-	.supports_idle = true,
 	.adv_thermal_throttle = true,
 	.support_ct_kill_exit = true,
 	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_THRESHOLD_DEF,
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index b57e739..e0ec170 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -305,7 +305,6 @@ struct iwl_base_params {
 	u16 led_compensation;
 	const bool broken_powersave;
 	int chain_noise_num_beacons;
-	const bool supports_idle;
 	bool adv_thermal_throttle;
 	bool support_ct_kill_exit;
 	const bool support_wimax_coexist;
diff --git a/drivers/net/wireless/iwlwifi/iwl-power.c b/drivers/net/wireless/iwlwifi/iwl-power.c
index 25f7d47..1d1bf32 100644
--- a/drivers/net/wireless/iwlwifi/iwl-power.c
+++ b/drivers/net/wireless/iwlwifi/iwl-power.c
@@ -356,8 +356,7 @@ static void iwl_power_build_cmd(struct iwl_priv *priv,
 
 	if (priv->cfg->base_params->broken_powersave)
 		iwl_power_sleep_cam_cmd(priv, cmd);
-	else if (priv->cfg->base_params->supports_idle &&
-		 priv->hw->conf.flags & IEEE80211_CONF_IDLE)
+	else if (priv->hw->conf.flags & IEEE80211_CONF_IDLE)
 		iwl_static_sleep_cmd(priv, cmd, IWL_POWER_INDEX_5, 20);
 	else if (priv->cfg->ops->lib->tt_ops.lower_power_detection &&
 		 priv->cfg->ops->lib->tt_ops.tt_power_mode &&
-- 
1.7.0.4

