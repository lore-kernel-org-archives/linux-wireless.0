Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:22348 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752460Ab1LSWnh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Dec 2011 17:43:37 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Venkataraman, Meenakshi" <meenakshi.venkataraman@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 6/6] iwlwifi: Execute runtime calibration always
Date: Mon, 19 Dec 2011 13:43:13 -0800
Message-Id: <1324330993-24476-7-git-send-email-wey-yi.w.guy@intel.com> (sfid-20111219_234350_606645_80D136D1)
In-Reply-To: <1324330993-24476-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1324330993-24476-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Venkataraman, Meenakshi <meenakshi.venkataraman@intel.com>

Runtime DC calibration was previously conditional. Remove this
behaviour, as new devices support runtime DC calibration,
while older devices ignore the runtime DC calibration request.

This patch addresses low TX throughput issues seen with the 6205.

Signed-off-by: Meenakshi Venkataraman <meenakshi.venkataraman@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c    |    7 ++++---
 drivers/net/wireless/iwlwifi/iwl-shared.h |    2 --
 2 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 9daa4d9..b5c7c5f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -1253,9 +1253,10 @@ int iwl_alive_start(struct iwl_priv *priv)
 		iwl_send_bt_config(priv);
 	}
 
-	if (hw_params(priv).calib_rt_cfg)
-		iwlagn_send_calib_cfg_rt(priv,
-					 hw_params(priv).calib_rt_cfg);
+	/*
+	 * Perform runtime calibrations, including DC calibration.
+	 */
+	iwlagn_send_calib_cfg_rt(priv, IWL_CALIB_CFG_DC_IDX);
 
 	ieee80211_wake_queues(priv->hw);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-shared.h b/drivers/net/wireless/iwlwifi/iwl-shared.h
index 66c6258..dc55cc4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-shared.h
+++ b/drivers/net/wireless/iwlwifi/iwl-shared.h
@@ -179,7 +179,6 @@ struct iwl_mod_params {
  * @ct_kill_exit_threshold: when to reeable the device - in hw dependent unit
  *	relevant for 1000, 6000 and up
  * @wd_timeout: TX queues watchdog timeout
- * @calib_rt_cfg: setup runtime calibrations for the hw
  * @struct iwl_sensitivity_ranges: range of sensitivity values
  */
 struct iwl_hw_params {
@@ -199,7 +198,6 @@ struct iwl_hw_params {
 	u32 ct_kill_exit_threshold;
 	unsigned int wd_timeout;
 
-	u32 calib_rt_cfg;
 	const struct iwl_sensitivity_ranges *sens;
 };
 
-- 
1.7.0.4

