Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:15438 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753952Ab0HWOxe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Aug 2010 10:53:34 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 17/26] iwlwifi: add bt_init_traffic_load as configurable parameter
Date: Mon, 23 Aug 2010 07:57:08 -0700
Message-Id: <1282575437-23270-18-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1282575437-23270-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1282575437-23270-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

Adding configurable parameter in .cfg for the initial Bluetooth traffic
load; set it to IWL_BT_COEX_TRAFFIC_LOAD_NONE for now, but can be change
for debugging or other reason.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-6000.c |    6 ++++++
 drivers/net/wireless/iwlwifi/iwl-agn.c  |    2 +-
 drivers/net/wireless/iwlwifi/iwl-core.h |    2 ++
 3 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index 101630b..396d80c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -832,6 +832,7 @@ struct iwl_cfg iwl6000g2b_2agn_cfg = {
 	/* Due to bluetooth, we transmit 2.4 GHz probes only on antenna A */
 	.scan_tx_antennas[IEEE80211_BAND_2GHZ] = ANT_A,
 	.advanced_bt_coexist = true,
+	.bt_init_traffic_load = IWL_BT_COEX_TRAFFIC_LOAD_NONE,
 };
 
 struct iwl_cfg iwl6000g2b_2abg_cfg = {
@@ -871,6 +872,7 @@ struct iwl_cfg iwl6000g2b_2abg_cfg = {
 	/* Due to bluetooth, we transmit 2.4 GHz probes only on antenna A */
 	.scan_tx_antennas[IEEE80211_BAND_2GHZ] = ANT_A,
 	.advanced_bt_coexist = true,
+	.bt_init_traffic_load = IWL_BT_COEX_TRAFFIC_LOAD_NONE,
 };
 
 struct iwl_cfg iwl6000g2b_2bgn_cfg = {
@@ -912,6 +914,7 @@ struct iwl_cfg iwl6000g2b_2bgn_cfg = {
 	/* Due to bluetooth, we transmit 2.4 GHz probes only on antenna A */
 	.scan_tx_antennas[IEEE80211_BAND_2GHZ] = ANT_A,
 	.advanced_bt_coexist = true,
+	.bt_init_traffic_load = IWL_BT_COEX_TRAFFIC_LOAD_NONE,
 };
 
 struct iwl_cfg iwl6000g2b_2bg_cfg = {
@@ -951,6 +954,7 @@ struct iwl_cfg iwl6000g2b_2bg_cfg = {
 	/* Due to bluetooth, we transmit 2.4 GHz probes only on antenna A */
 	.scan_tx_antennas[IEEE80211_BAND_2GHZ] = ANT_A,
 	.advanced_bt_coexist = true,
+	.bt_init_traffic_load = IWL_BT_COEX_TRAFFIC_LOAD_NONE,
 };
 
 struct iwl_cfg iwl6000g2b_bgn_cfg = {
@@ -992,6 +996,7 @@ struct iwl_cfg iwl6000g2b_bgn_cfg = {
 	/* Due to bluetooth, we transmit 2.4 GHz probes only on antenna A */
 	.scan_tx_antennas[IEEE80211_BAND_2GHZ] = ANT_A,
 	.advanced_bt_coexist = true,
+	.bt_init_traffic_load = IWL_BT_COEX_TRAFFIC_LOAD_NONE,
 };
 
 struct iwl_cfg iwl6000g2b_bg_cfg = {
@@ -1031,6 +1036,7 @@ struct iwl_cfg iwl6000g2b_bg_cfg = {
 	/* Due to bluetooth, we transmit 2.4 GHz probes only on antenna A */
 	.scan_tx_antennas[IEEE80211_BAND_2GHZ] = ANT_A,
 	.advanced_bt_coexist = true,
+	.bt_init_traffic_load = IWL_BT_COEX_TRAFFIC_LOAD_NONE,
 };
 
 /*
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 3686164..be13c79 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -2800,7 +2800,7 @@ static void __iwl_down(struct iwl_priv *priv)
 	iwl_clear_driver_stations(priv);
 
 	/* reset BT coex data */
-	priv->bt_traffic_load = 0;
+	priv->bt_traffic_load = priv->cfg->bt_init_traffic_load;
 	priv->bt_sco_active = false;
 	priv->bt_full_concurrent = false;
 	priv->bt_ci_compliance = 0;
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 146d0d5..d5dacaf 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -279,6 +279,7 @@ struct iwl_mod_params {
  *	chain noise calibration operation
  * @scan_antennas: available antenna for scan operation
  * @advanced_bt_coexist: support advanced bt coexist
+ * @bt_init_traffic_load: specify initial bt traffic load
  * @need_dc_calib: need to perform init dc calibration
  * @bt_statistics: use BT version of statistics notification
  * @agg_time_limit: maximum number of uSec in aggregation
@@ -353,6 +354,7 @@ struct iwl_cfg {
 	u8 scan_rx_antennas[IEEE80211_NUM_BANDS];
 	u8 scan_tx_antennas[IEEE80211_NUM_BANDS];
 	bool advanced_bt_coexist;
+	u8 bt_init_traffic_load;
 	const bool need_dc_calib;
 	const bool bt_statistics;
 	u16 agg_time_limit;
-- 
1.7.0.4

