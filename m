Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:22722 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753954Ab0CYUpB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Mar 2010 16:45:01 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 19/22] iwlwifi: Generic approach to measure temperature
Date: Thu, 25 Mar 2010 13:44:47 -0700
Message-Id: <1269549890-19195-20-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1269549890-19195-1-git-send-email-reinette.chatre@intel.com>
References: <1269549890-19195-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

In stead of checking for 4965 and do KELVIN_TO_CELSIUS conversation, add
.cfg parameter for more generic approach.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965.c  |    1 +
 drivers/net/wireless/iwlwifi/iwl-core.h  |    1 +
 drivers/net/wireless/iwlwifi/iwl-power.c |    8 ++++----
 3 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index af48d07..1b5ced5 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -2258,6 +2258,7 @@ struct iwl_cfg iwl4965_agn_cfg = {
 	.chain_noise_num_beacons = IWL4965_CAL_NUM_BEACONS,
 	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_THRESHOLD_DEF,
 	.monitor_recover_period = IWL_MONITORING_PERIOD,
+	.temperature_kelvin = true,
 };
 
 /* Module firmware */
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 22f84f3..e9b0411 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -305,6 +305,7 @@ struct iwl_cfg {
 	s32 chain_noise_scale;
 	/* timer period for monitor the driver queues */
 	u32 monitor_recover_period;
+	bool temperature_kelvin;
 };
 
 /***************************
diff --git a/drivers/net/wireless/iwlwifi/iwl-power.c b/drivers/net/wireless/iwlwifi/iwl-power.c
index 1a1a9f0..e0581a7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-power.c
+++ b/drivers/net/wireless/iwlwifi/iwl-power.c
@@ -383,10 +383,10 @@ EXPORT_SYMBOL(iwl_ht_enabled);
 
 bool iwl_within_ct_kill_margin(struct iwl_priv *priv)
 {
-	s32 temp = priv->temperature; /* degrees CELSIUS except 4965 */
+	s32 temp = priv->temperature; /* degrees CELSIUS except specified */
 	bool within_margin = false;
 
-	if ((priv->hw_rev & CSR_HW_REV_TYPE_MSK) == CSR_HW_REV_TYPE_4965)
+	if (priv->cfg->temperature_kelvin)
 		temp = KELVIN_TO_CELSIUS(priv->temperature);
 
 	if (!priv->thermal_throttle.advanced_tt)
@@ -839,12 +839,12 @@ EXPORT_SYMBOL(iwl_tt_exit_ct_kill);
 static void iwl_bg_tt_work(struct work_struct *work)
 {
 	struct iwl_priv *priv = container_of(work, struct iwl_priv, tt_work);
-	s32 temp = priv->temperature; /* degrees CELSIUS except 4965 */
+	s32 temp = priv->temperature; /* degrees CELSIUS except specified */
 
 	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
 		return;
 
-	if ((priv->hw_rev & CSR_HW_REV_TYPE_MSK) == CSR_HW_REV_TYPE_4965)
+	if (priv->cfg->temperature_kelvin)
 		temp = KELVIN_TO_CELSIUS(priv->temperature);
 
 	if (!priv->thermal_throttle.advanced_tt)
-- 
1.6.3.3

