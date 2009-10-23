Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:24332 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752032AbZJWUmh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Oct 2009 16:42:37 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 10/18] iwlwifi: issue ct_kill host command based on device config
Date: Fri, 23 Oct 2009 13:42:28 -0700
Message-Id: <1256330556-20997-11-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1256330556-20997-1-git-send-email-reinette.chatre@intel.com>
References: <1256330556-20997-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

Using device configuration structure to decide how to configure
ct_kill host command.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-1000.c |    2 ++
 drivers/net/wireless/iwlwifi/iwl-6000.c |   10 ++++++++++
 drivers/net/wireless/iwlwifi/iwl-core.c |    9 ++-------
 drivers/net/wireless/iwlwifi/iwl-core.h |    2 ++
 4 files changed, 16 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-1000.c b/drivers/net/wireless/iwlwifi/iwl-1000.c
index 3da5913..3a645e4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-1000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-1000.c
@@ -171,6 +171,7 @@ struct iwl_cfg iwl1000_bgn_cfg = {
 	.ht_greenfield_support = true,
 	.led_compensation = 51,
 	.chain_noise_num_beacons = IWL_CAL_NUM_BEACONS,
+	.support_ct_kill_exit = true,
 };
 
 struct iwl_cfg iwl1000_bg_cfg = {
@@ -196,6 +197,7 @@ struct iwl_cfg iwl1000_bg_cfg = {
 	.ht_greenfield_support = true,
 	.led_compensation = 51,
 	.chain_noise_num_beacons = IWL_CAL_NUM_BEACONS,
+	.support_ct_kill_exit = true,
 };
 
 MODULE_FIRMWARE(IWL1000_MODULE_FIRMWARE(IWL1000_UCODE_API_MAX));
diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index 0873322..f585529 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -278,6 +278,7 @@ struct iwl_cfg iwl6000h_2agn_cfg = {
 	.chain_noise_num_beacons = IWL_CAL_NUM_BEACONS,
 	.supports_idle = true,
 	.adv_thermal_throttle = true,
+	.support_ct_kill_exit = true,
 };
 
 struct iwl_cfg iwl6000h_2abg_cfg = {
@@ -306,6 +307,7 @@ struct iwl_cfg iwl6000h_2abg_cfg = {
 	.chain_noise_num_beacons = IWL_CAL_NUM_BEACONS,
 	.supports_idle = true,
 	.adv_thermal_throttle = true,
+	.support_ct_kill_exit = true,
 };
 
 struct iwl_cfg iwl6000h_2bg_cfg = {
@@ -334,6 +336,7 @@ struct iwl_cfg iwl6000h_2bg_cfg = {
 	.chain_noise_num_beacons = IWL_CAL_NUM_BEACONS,
 	.supports_idle = true,
 	.adv_thermal_throttle = true,
+	.support_ct_kill_exit = true,
 };
 
 /*
@@ -366,6 +369,7 @@ struct iwl_cfg iwl6000i_2agn_cfg = {
 	.chain_noise_num_beacons = IWL_CAL_NUM_BEACONS,
 	.supports_idle = true,
 	.adv_thermal_throttle = true,
+	.support_ct_kill_exit = true,
 };
 
 struct iwl_cfg iwl6000i_2abg_cfg = {
@@ -394,6 +398,7 @@ struct iwl_cfg iwl6000i_2abg_cfg = {
 	.chain_noise_num_beacons = IWL_CAL_NUM_BEACONS,
 	.supports_idle = true,
 	.adv_thermal_throttle = true,
+	.support_ct_kill_exit = true,
 };
 
 struct iwl_cfg iwl6000i_2bg_cfg = {
@@ -422,6 +427,7 @@ struct iwl_cfg iwl6000i_2bg_cfg = {
 	.chain_noise_num_beacons = IWL_CAL_NUM_BEACONS,
 	.supports_idle = true,
 	.adv_thermal_throttle = true,
+	.support_ct_kill_exit = true,
 };
 
 struct iwl_cfg iwl6050_2agn_cfg = {
@@ -451,6 +457,7 @@ struct iwl_cfg iwl6050_2agn_cfg = {
 	.chain_noise_num_beacons = IWL_CAL_NUM_BEACONS,
 	.supports_idle = true,
 	.adv_thermal_throttle = true,
+	.support_ct_kill_exit = true,
 };
 
 struct iwl_cfg iwl6050_2abg_cfg = {
@@ -479,6 +486,7 @@ struct iwl_cfg iwl6050_2abg_cfg = {
 	.chain_noise_num_beacons = IWL_CAL_NUM_BEACONS,
 	.supports_idle = true,
 	.adv_thermal_throttle = true,
+	.support_ct_kill_exit = true,
 };
 
 struct iwl_cfg iwl6000_3agn_cfg = {
@@ -508,6 +516,7 @@ struct iwl_cfg iwl6000_3agn_cfg = {
 	.chain_noise_num_beacons = IWL_CAL_NUM_BEACONS,
 	.supports_idle = true,
 	.adv_thermal_throttle = true,
+	.support_ct_kill_exit = true,
 };
 
 struct iwl_cfg iwl6050_3agn_cfg = {
@@ -537,6 +546,7 @@ struct iwl_cfg iwl6050_3agn_cfg = {
 	.chain_noise_num_beacons = IWL_CAL_NUM_BEACONS,
 	.supports_idle = true,
 	.adv_thermal_throttle = true,
+	.support_ct_kill_exit = true,
 };
 
 MODULE_FIRMWARE(IWL6000_MODULE_FIRMWARE(IWL6000_UCODE_API_MAX));
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 77b9825..e43469c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -2165,10 +2165,7 @@ void iwl_rf_kill_ct_config(struct iwl_priv *priv)
 	spin_unlock_irqrestore(&priv->lock, flags);
 	priv->thermal_throttle.ct_kill_toggle = false;
 
-	switch (priv->hw_rev & CSR_HW_REV_TYPE_MSK) {
-	case CSR_HW_REV_TYPE_1000:
-	case CSR_HW_REV_TYPE_6x00:
-	case CSR_HW_REV_TYPE_6x50:
+	if (priv->cfg->support_ct_kill_exit) {
 		adv_cmd.critical_temperature_enter =
 			cpu_to_le32(priv->hw_params.ct_kill_threshold);
 		adv_cmd.critical_temperature_exit =
@@ -2185,8 +2182,7 @@ void iwl_rf_kill_ct_config(struct iwl_priv *priv)
 					"exit is %d\n",
 				       priv->hw_params.ct_kill_threshold,
 				       priv->hw_params.ct_kill_exit_threshold);
-		break;
-	default:
+	} else {
 		cmd.critical_temperature_R =
 			cpu_to_le32(priv->hw_params.ct_kill_threshold);
 
@@ -2199,7 +2195,6 @@ void iwl_rf_kill_ct_config(struct iwl_priv *priv)
 					"succeeded, "
 					"critical temperature is %d\n",
 					priv->hw_params.ct_kill_threshold);
-		break;
 	}
 }
 EXPORT_SYMBOL(iwl_rf_kill_ct_config);
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 9dbf598..02bacc4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -226,6 +226,7 @@ struct iwl_mod_params {
  * @use_rts_for_ht: use rts/cts protection for HT traffic
  * @chain_noise_num_beacons: number of beacons used to compute chain noise
  * @adv_thermal_throttle: support advance thermal throttle
+ * @support_ct_kill_exit: support ct kill exit condition
  *
  * We enable the driver to be backward compatible wrt API version. The
  * driver specifies which APIs it supports (with @ucode_api_max being the
@@ -280,6 +281,7 @@ struct iwl_cfg {
 	int chain_noise_num_beacons;
 	const bool supports_idle;
 	bool adv_thermal_throttle;
+	bool support_ct_kill_exit;
 };
 
 /***************************
-- 
1.5.6.3

