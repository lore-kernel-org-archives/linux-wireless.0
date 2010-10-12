Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:9253 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932740Ab0JLPzL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Oct 2010 11:55:11 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 2/3] iwlagn: prio_tbl need to download before calibration
Date: Tue, 12 Oct 2010 08:53:54 -0700
Message-Id: <1286898835-31812-3-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1286898835-31812-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1286898835-31812-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

For WiFi/BT combo devices, priority table always need to download
before perform any calibration operation.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 4470e8c..6771c40 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -2809,9 +2809,6 @@ static void iwl_alive_start(struct iwl_priv *priv)
 		goto restart;
 	}
 
-	if (priv->hw_params.calib_rt_cfg)
-		iwlagn_send_calib_cfg_rt(priv, priv->hw_params.calib_rt_cfg);
-
 
 	/* After the ALIVE response, we can send host commands to the uCode */
 	set_bit(STATUS_ALIVE, &priv->status);
@@ -2827,6 +2824,7 @@ static void iwl_alive_start(struct iwl_priv *priv)
 	if (iwl_is_rfkill(priv))
 		return;
 
+	/* download priority table before any calibration request */
 	if (priv->cfg->bt_params &&
 	    priv->cfg->bt_params->advanced_bt_coexist) {
 		/* Configure Bluetooth device coexistence support */
@@ -2843,6 +2841,9 @@ static void iwl_alive_start(struct iwl_priv *priv)
 		iwlagn_send_bt_env(priv, IWL_BT_COEX_ENV_CLOSE,
 			BT_COEX_PRIO_TBL_EVT_INIT_CALIB2);
 	}
+	if (priv->hw_params.calib_rt_cfg)
+		iwlagn_send_calib_cfg_rt(priv, priv->hw_params.calib_rt_cfg);
+
 	ieee80211_wake_queues(priv->hw);
 
 	priv->active_rate = IWL_RATES_MASK;
-- 
1.7.0.4

