Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:22722 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754122Ab0CYUpE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Mar 2010 16:45:04 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 22/22] iwlwifi: avoid device type checking in generic code
Date: Thu, 25 Mar 2010 13:44:50 -0700
Message-Id: <1269549890-19195-23-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1269549890-19195-1-git-send-email-reinette.chatre@intel.com>
References: <1269549890-19195-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

Avoid checking for specified device type to perform certain function,
switch to .cfg approach as more generic and better implementation
method.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965.c |    1 +
 drivers/net/wireless/iwlwifi/iwl-core.c |    6 +++---
 drivers/net/wireless/iwlwifi/iwl-core.h |    1 +
 drivers/net/wireless/iwlwifi/iwl-scan.c |    7 ++++---
 4 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 1b5ced5..1808c97 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -2259,6 +2259,7 @@ struct iwl_cfg iwl4965_agn_cfg = {
 	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_THRESHOLD_DEF,
 	.monitor_recover_period = IWL_MONITORING_PERIOD,
 	.temperature_kelvin = true,
+	.off_channel_workaround = true,
 };
 
 /* Module firmware */
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 9e48352..1b4408a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -992,12 +992,12 @@ void iwl_set_rxon_chain(struct iwl_priv *priv)
 	rx_chain |= idle_rx_cnt  << RXON_RX_CHAIN_CNT_POS;
 
 	/* copied from 'iwl_bg_request_scan()' */
-	/* Force use of chains B and C (0x6) for Rx for 4965
-	 * Avoid A (0x1) because of its off-channel reception on A-band.
+	/* Force use of chains B and C (0x6) for Rx
+	 * Avoid A (0x1) for the device has off-channel reception on A-band.
 	 * MIMO is not used here, but value is required */
 	if (iwl_is_monitor_mode(priv) &&
 	    !(priv->staging_rxon.flags & RXON_FLG_BAND_24G_MSK) &&
-	    ((priv->hw_rev & CSR_HW_REV_TYPE_MSK) == CSR_HW_REV_TYPE_4965)) {
+	    priv->cfg->off_channel_workaround) {
 		rx_chain = ANT_ABC << RXON_RX_CHAIN_VALID_POS;
 		rx_chain |= ANT_BC << RXON_RX_CHAIN_FORCE_SEL_POS;
 		rx_chain |= ANT_ABC << RXON_RX_CHAIN_FORCE_MIMO_SEL_POS;
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index e9b0411..9d7a68f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -306,6 +306,7 @@ struct iwl_cfg {
 	/* timer period for monitor the driver queues */
 	u32 monitor_recover_period;
 	bool temperature_kelvin;
+	bool off_channel_workaround;
 };
 
 /***************************
diff --git a/drivers/net/wireless/iwlwifi/iwl-scan.c b/drivers/net/wireless/iwlwifi/iwl-scan.c
index 1544d75..5ecfc7f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-scan.c
+++ b/drivers/net/wireless/iwlwifi/iwl-scan.c
@@ -830,10 +830,11 @@ static void iwl_bg_request_scan(struct work_struct *data)
 		 */
 		scan->good_CRC_th = is_active ? IWL_GOOD_CRC_TH : 0;
 
-		/* Force use of chains B and C (0x6) for scan Rx for 4965
-		 * Avoid A (0x1) because of its off-channel reception on A-band.
+		/* Force use of chains B and C (0x6) for scan Rx
+		 * Avoid A (0x1) for the device has off-channel reception
+		 * on A-band.
 		 */
-		if ((priv->hw_rev & CSR_HW_REV_TYPE_MSK) == CSR_HW_REV_TYPE_4965)
+		if (priv->cfg->off_channel_workaround)
 			rx_ant = ANT_BC;
 	} else {
 		IWL_WARN(priv, "Invalid scan band count\n");
-- 
1.6.3.3

