Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:50641 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932603Ab0DPVwq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Apr 2010 17:52:46 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 21/21] iwlwifi: make scan antenna forcing more generic
Date: Fri, 16 Apr 2010 14:52:38 -0700
Message-Id: <1271454758-14351-22-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1271454758-14351-1-git-send-email-reinette.chatre@intel.com>
References: <1271454758-14351-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Some future hardware will also require some antenna
overrides so make the current logic more generic;
right now it is semantically based on a workaround
for off-channel reception but the reasons for the
new antenna overrides will be different.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965.c    |    7 ++++++-
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c |   10 +++-------
 drivers/net/wireless/iwlwifi/iwl-core.h    |    2 +-
 3 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 2861819..136c290 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -2261,8 +2261,13 @@ struct iwl_cfg iwl4965_agn_cfg = {
 	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_THRESHOLD_DEF,
 	.monitor_recover_period = IWL_MONITORING_PERIOD,
 	.temperature_kelvin = true,
-	.off_channel_workaround = true,
 	.max_event_log_size = 512,
+
+	/*
+	 * Force use of chains B and C for scan RX on 5 GHz band
+	 * because the device has off-channel reception on chain A.
+	 */
+	.scan_antennas[IEEE80211_BAND_5GHZ] = ANT_BC,
 };
 
 /* Module firmware */
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index ccf3357..4bd0aec 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -1405,13 +1405,6 @@ void iwlagn_request_scan(struct iwl_priv *priv)
 		 * detect transmissions.
 		 */
 		scan->good_CRC_th = is_active ? IWL_GOOD_CRC_TH : 0;
-
-		/* Force use of chains B and C (0x6) for scan Rx
-		 * Avoid A (0x1) for the device has off-channel reception
-		 * on A-band.
-		 */
-		if (priv->cfg->off_channel_workaround)
-			rx_ant = ANT_BC;
 		break;
 	default:
 		IWL_WARN(priv, "Invalid scan band count\n");
@@ -1420,6 +1413,9 @@ void iwlagn_request_scan(struct iwl_priv *priv)
 
 	band = priv->scan_band;
 
+	if (priv->cfg->scan_antennas[band])
+		rx_ant = priv->cfg->scan_antennas[band];
+
 	priv->scan_tx_ant[band] =
 			iwl_toggle_tx_ant(priv, priv->scan_tx_ant[band]);
 	rate_flags |= iwl_ant_idx_to_flags(priv->scan_tx_ant[band]);
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index e267a21..a0cc11e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -318,8 +318,8 @@ struct iwl_cfg {
 	/* timer period for monitor the driver queues */
 	u32 monitor_recover_period;
 	bool temperature_kelvin;
-	bool off_channel_workaround;
 	u32 max_event_log_size;
+	u8 scan_antennas[IEEE80211_NUM_BANDS];
 };
 
 /***************************
-- 
1.6.3.3

