Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:17575 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752551Ab0FFG4p (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Jun 2010 02:56:45 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 19/23] iwlwifi: generic scan TX antenna forcing
Date: Sat,  5 Jun 2010 23:56:34 -0700
Message-Id: <1275807398-18184-20-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1275807398-18184-1-git-send-email-reinette.chatre@intel.com>
References: <1275807398-18184-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

In "iwlwifi: make scan antenna forcing more generic"
I introduced generic scan RX antenna forcing, which
here I rename to make it more evident. Also add scan
TX antenna forcing, since I will need that as well.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965.c    |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c |   12 ++++++++----
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c  |    3 ++-
 drivers/net/wireless/iwlwifi/iwl-agn.c     |    3 ++-
 drivers/net/wireless/iwlwifi/iwl-core.c    |    5 +++--
 drivers/net/wireless/iwlwifi/iwl-core.h    |    5 +++--
 6 files changed, 19 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index a51c4b8..83e6a42 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -2326,7 +2326,7 @@ struct iwl_cfg iwl4965_agn_cfg = {
 	 * Force use of chains B and C for scan RX on 5 GHz band
 	 * because the device has off-channel reception on chain A.
 	 */
-	.scan_antennas[IEEE80211_BAND_5GHZ] = ANT_BC,
+	.scan_rx_antennas[IEEE80211_BAND_5GHZ] = ANT_BC,
 };
 
 /* Module firmware */
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index 5bec72a..d339881 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -1150,6 +1150,7 @@ void iwlagn_request_scan(struct iwl_priv *priv, struct ieee80211_vif *vif)
 	bool is_active = false;
 	int  chan_mod;
 	u8 active_chains;
+	u8 scan_tx_antennas = priv->hw_params.valid_tx_ant;
 
 	conf = ieee80211_get_hw_conf(priv->hw);
 
@@ -1301,11 +1302,14 @@ void iwlagn_request_scan(struct iwl_priv *priv, struct ieee80211_vif *vif)
 
 	band = priv->scan_band;
 
-	if (priv->cfg->scan_antennas[band])
-		rx_ant = priv->cfg->scan_antennas[band];
+	if (priv->cfg->scan_rx_antennas[band])
+		rx_ant = priv->cfg->scan_rx_antennas[band];
 
-	priv->scan_tx_ant[band] =
-			iwl_toggle_tx_ant(priv, priv->scan_tx_ant[band]);
+	if (priv->cfg->scan_tx_antennas[band])
+		scan_tx_antennas = priv->cfg->scan_tx_antennas[band];
+
+	priv->scan_tx_ant[band] = iwl_toggle_tx_ant(priv, priv->scan_tx_ant[band],
+						    scan_tx_antennas);
 	rate_flags |= iwl_ant_idx_to_flags(priv->scan_tx_ant[band]);
 	scan->tx_cmd.rate_n_flags = iwl_hw_set_rate_n_flags(rate, rate_flags);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
index 0037a52..0d3e13b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
@@ -469,7 +469,8 @@ static void iwlagn_tx_cmd_build_rate(struct iwl_priv *priv,
 	}
 
 	/* Set up antennas */
-	priv->mgmt_tx_ant = iwl_toggle_tx_ant(priv, priv->mgmt_tx_ant);
+	priv->mgmt_tx_ant = iwl_toggle_tx_ant(priv, priv->mgmt_tx_ant,
+					      priv->hw_params.valid_tx_ant);
 	rate_flags |= iwl_ant_idx_to_flags(priv->mgmt_tx_ant);
 
 	/* Set the rate in the TX cmd */
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index a0e995e..ac5fade 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -367,7 +367,8 @@ static unsigned int iwl_hw_get_beacon_cmd(struct iwl_priv *priv,
 
 	/* Set up packet rate and flags */
 	rate = iwl_rate_get_lowest_plcp(priv);
-	priv->mgmt_tx_ant = iwl_toggle_tx_ant(priv, priv->mgmt_tx_ant);
+	priv->mgmt_tx_ant = iwl_toggle_tx_ant(priv, priv->mgmt_tx_ant,
+					      priv->hw_params.valid_tx_ant);
 	rate_flags = iwl_ant_idx_to_flags(priv->mgmt_tx_ant);
 	if ((rate >= IWL_FIRST_CCK_RATE) && (rate <= IWL_LAST_CCK_RATE))
 		rate_flags |= RATE_MCS_CCK_MSK;
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index ec0f39c..00b2cdd 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -141,13 +141,14 @@ int iwl_hwrate_to_plcp_idx(u32 rate_n_flags)
 }
 EXPORT_SYMBOL(iwl_hwrate_to_plcp_idx);
 
-u8 iwl_toggle_tx_ant(struct iwl_priv *priv, u8 ant)
+u8 iwl_toggle_tx_ant(struct iwl_priv *priv, u8 ant, u8 valid)
 {
 	int i;
 	u8 ind = ant;
+
 	for (i = 0; i < RATE_ANT_NUM - 1; i++) {
 		ind = (ind + 1) < RATE_ANT_NUM ?  ind + 1 : 0;
-		if (priv->hw_params.valid_tx_ant & BIT(ind))
+		if (valid & BIT(ind))
 			return ind;
 	}
 	return ant;
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 9fe08ec..87dd573 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -328,7 +328,8 @@ struct iwl_cfg {
 	const bool ucode_tracing;
 	const bool sensitivity_calib_by_driver;
 	const bool chain_noise_calib_by_driver;
-	u8 scan_antennas[IEEE80211_NUM_BANDS];
+	u8 scan_rx_antennas[IEEE80211_NUM_BANDS];
+	u8 scan_tx_antennas[IEEE80211_NUM_BANDS];
 };
 
 /***************************
@@ -499,7 +500,7 @@ int iwl_hwrate_to_plcp_idx(u32 rate_n_flags);
 
 u8 iwl_rate_get_lowest_plcp(struct iwl_priv *priv);
 
-u8 iwl_toggle_tx_ant(struct iwl_priv *priv, u8 ant_idx);
+u8 iwl_toggle_tx_ant(struct iwl_priv *priv, u8 ant_idx, u8 valid);
 
 static inline u32 iwl_ant_idx_to_flags(u8 ant_idx)
 {
-- 
1.7.0.4

