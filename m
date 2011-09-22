Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:7986 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753984Ab1IVXBU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Sep 2011 19:01:20 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 08/12] iwlagn: remove Kelvin support
Date: Thu, 22 Sep 2011 15:14:56 -0700
Message-Id: <1316729700-1770-9-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110923_010133_676468_020640F5)
In-Reply-To: <1316729700-1770-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1316729700-1770-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Only 5150 series devices report their temperature
in Kelvin, and for those we already convert it to
Celsius when storing into priv->temperature, so
there's no way priv->temperature will ever be in
Kelvin. Remove support for this.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-tt.c |    6 ------
 drivers/net/wireless/iwlwifi/iwl-core.h   |    2 --
 drivers/net/wireless/iwlwifi/iwl-dev.h    |    2 +-
 3 files changed, 1 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-tt.c b/drivers/net/wireless/iwlwifi/iwl-agn-tt.c
index 289e5d8..c27180a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-tt.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-tt.c
@@ -114,9 +114,6 @@ static bool iwl_within_ct_kill_margin(struct iwl_priv *priv)
 	s32 temp = priv->temperature; /* degrees CELSIUS except specified */
 	bool within_margin = false;
 
-	if (priv->cfg->base_params->temperature_kelvin)
-		temp = KELVIN_TO_CELSIUS(priv->temperature);
-
 	if (!priv->thermal_throttle.advanced_tt)
 		within_margin = ((temp + IWL_TT_CT_KILL_MARGIN) >=
 				CT_KILL_THRESHOLD_LEGACY) ? true : false;
@@ -591,9 +588,6 @@ static void iwl_bg_tt_work(struct work_struct *work)
 	if (test_bit(STATUS_EXIT_PENDING, &priv->shrd->status))
 		return;
 
-	if (priv->cfg->base_params->temperature_kelvin)
-		temp = KELVIN_TO_CELSIUS(priv->temperature);
-
 	if (!priv->thermal_throttle.advanced_tt)
 		iwl_legacy_tt_handler(priv, temp, false);
 	else
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 74d4cff..8ed72e8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -108,7 +108,6 @@ struct iwl_lib_ops {
  *	radio tuning when there is a high receiving plcp error rate
  * @chain_noise_scale: default chain noise scale used for gain computation
  * @wd_timeout: TX queues watchdog timeout
- * @temperature_kelvin: temperature report by uCode in kelvin
  * @max_event_log_size: size of event log buffer size for ucode event logging
  * @shadow_reg_enable: HW shadhow register bit
  * @no_idle_support: do not support idle mode
@@ -130,7 +129,6 @@ struct iwl_base_params {
 	u8 plcp_delta_threshold;
 	s32 chain_noise_scale;
 	unsigned int wd_timeout;
-	bool temperature_kelvin;
 	u32 max_event_log_size;
 	const bool shadow_reg_enable;
 	const bool no_idle_support;
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 4ddaf2c..257aa9a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -877,7 +877,7 @@ struct iwl_priv {
 	u8 channel_count;	/* # of channels */
 
 	/* thermal calibration */
-	s32 temperature;	/* degrees Kelvin */
+	s32 temperature;	/* Celsius */
 	s32 last_temperature;
 
 	/* init calibration results */
-- 
1.7.0.4

