Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:24343 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752106AbZJWUmg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Oct 2009 16:42:36 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 09/18] iwlwifi: choose thermal throttle method based on device config
Date: Fri, 23 Oct 2009 13:42:27 -0700
Message-Id: <1256330556-20997-10-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1256330556-20997-1-git-send-email-reinette.chatre@intel.com>
References: <1256330556-20997-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

Using device configuration structure to decide the type of thermal
throttle method for the device.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-6000.c  |   10 ++++++++++
 drivers/net/wireless/iwlwifi/iwl-core.h  |    2 ++
 drivers/net/wireless/iwlwifi/iwl-power.c |    8 ++------
 3 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index 5211872..0873322 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -277,6 +277,7 @@ struct iwl_cfg iwl6000h_2agn_cfg = {
 	.use_rts_for_ht = true, /* use rts/cts protection */
 	.chain_noise_num_beacons = IWL_CAL_NUM_BEACONS,
 	.supports_idle = true,
+	.adv_thermal_throttle = true,
 };
 
 struct iwl_cfg iwl6000h_2abg_cfg = {
@@ -304,6 +305,7 @@ struct iwl_cfg iwl6000h_2abg_cfg = {
 	.led_compensation = 51,
 	.chain_noise_num_beacons = IWL_CAL_NUM_BEACONS,
 	.supports_idle = true,
+	.adv_thermal_throttle = true,
 };
 
 struct iwl_cfg iwl6000h_2bg_cfg = {
@@ -331,6 +333,7 @@ struct iwl_cfg iwl6000h_2bg_cfg = {
 	.led_compensation = 51,
 	.chain_noise_num_beacons = IWL_CAL_NUM_BEACONS,
 	.supports_idle = true,
+	.adv_thermal_throttle = true,
 };
 
 /*
@@ -362,6 +365,7 @@ struct iwl_cfg iwl6000i_2agn_cfg = {
 	.use_rts_for_ht = true, /* use rts/cts protection */
 	.chain_noise_num_beacons = IWL_CAL_NUM_BEACONS,
 	.supports_idle = true,
+	.adv_thermal_throttle = true,
 };
 
 struct iwl_cfg iwl6000i_2abg_cfg = {
@@ -389,6 +393,7 @@ struct iwl_cfg iwl6000i_2abg_cfg = {
 	.led_compensation = 51,
 	.chain_noise_num_beacons = IWL_CAL_NUM_BEACONS,
 	.supports_idle = true,
+	.adv_thermal_throttle = true,
 };
 
 struct iwl_cfg iwl6000i_2bg_cfg = {
@@ -416,6 +421,7 @@ struct iwl_cfg iwl6000i_2bg_cfg = {
 	.led_compensation = 51,
 	.chain_noise_num_beacons = IWL_CAL_NUM_BEACONS,
 	.supports_idle = true,
+	.adv_thermal_throttle = true,
 };
 
 struct iwl_cfg iwl6050_2agn_cfg = {
@@ -444,6 +450,7 @@ struct iwl_cfg iwl6050_2agn_cfg = {
 	.use_rts_for_ht = true, /* use rts/cts protection */
 	.chain_noise_num_beacons = IWL_CAL_NUM_BEACONS,
 	.supports_idle = true,
+	.adv_thermal_throttle = true,
 };
 
 struct iwl_cfg iwl6050_2abg_cfg = {
@@ -471,6 +478,7 @@ struct iwl_cfg iwl6050_2abg_cfg = {
 	.led_compensation = 51,
 	.chain_noise_num_beacons = IWL_CAL_NUM_BEACONS,
 	.supports_idle = true,
+	.adv_thermal_throttle = true,
 };
 
 struct iwl_cfg iwl6000_3agn_cfg = {
@@ -499,6 +507,7 @@ struct iwl_cfg iwl6000_3agn_cfg = {
 	.use_rts_for_ht = true, /* use rts/cts protection */
 	.chain_noise_num_beacons = IWL_CAL_NUM_BEACONS,
 	.supports_idle = true,
+	.adv_thermal_throttle = true,
 };
 
 struct iwl_cfg iwl6050_3agn_cfg = {
@@ -527,6 +536,7 @@ struct iwl_cfg iwl6050_3agn_cfg = {
 	.use_rts_for_ht = true, /* use rts/cts protection */
 	.chain_noise_num_beacons = IWL_CAL_NUM_BEACONS,
 	.supports_idle = true,
+	.adv_thermal_throttle = true,
 };
 
 MODULE_FIRMWARE(IWL6000_MODULE_FIRMWARE(IWL6000_UCODE_API_MAX));
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index a2d526a..9dbf598 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -225,6 +225,7 @@ struct iwl_mod_params {
  *	The detail algorithm is described in iwl-led.c
  * @use_rts_for_ht: use rts/cts protection for HT traffic
  * @chain_noise_num_beacons: number of beacons used to compute chain noise
+ * @adv_thermal_throttle: support advance thermal throttle
  *
  * We enable the driver to be backward compatible wrt API version. The
  * driver specifies which APIs it supports (with @ucode_api_max being the
@@ -278,6 +279,7 @@ struct iwl_cfg {
 	bool use_rts_for_ht;
 	int chain_noise_num_beacons;
 	const bool supports_idle;
+	bool adv_thermal_throttle;
 };
 
 /***************************
diff --git a/drivers/net/wireless/iwlwifi/iwl-power.c b/drivers/net/wireless/iwlwifi/iwl-power.c
index 150ff87..432f465 100644
--- a/drivers/net/wireless/iwlwifi/iwl-power.c
+++ b/drivers/net/wireless/iwlwifi/iwl-power.c
@@ -893,9 +893,7 @@ void iwl_tt_initialize(struct iwl_priv *priv)
 	INIT_WORK(&priv->ct_enter, iwl_bg_ct_enter);
 	INIT_WORK(&priv->ct_exit, iwl_bg_ct_exit);
 
-	switch (priv->hw_rev & CSR_HW_REV_TYPE_MSK) {
-	case CSR_HW_REV_TYPE_6x00:
-	case CSR_HW_REV_TYPE_6x50:
+	if (priv->cfg->adv_thermal_throttle) {
 		IWL_DEBUG_POWER(priv, "Advanced Thermal Throttling\n");
 		tt->restriction = kzalloc(sizeof(struct iwl_tt_restriction) *
 					 IWL_TI_STATE_MAX, GFP_KERNEL);
@@ -928,11 +926,9 @@ void iwl_tt_initialize(struct iwl_priv *priv)
 				&restriction_range[0], size);
 			priv->thermal_throttle.advanced_tt = true;
 		}
-		break;
-	default:
+	} else {
 		IWL_DEBUG_POWER(priv, "Legacy Thermal Throttling\n");
 		priv->thermal_throttle.advanced_tt = false;
-		break;
 	}
 }
 EXPORT_SYMBOL(iwl_tt_initialize);
-- 
1.5.6.3

