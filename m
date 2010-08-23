Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:24115 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753953Ab0HWOxe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Aug 2010 10:53:34 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 18/26] iwlagn: add bt prio_boost to .cfg
Date: Mon, 23 Aug 2010 07:57:09 -0700
Message-Id: <1282575437-23270-19-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1282575437-23270-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1282575437-23270-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

Use .cfg to configure the default bt priority boost value;
the default bt priority boost is 0xf0

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-6000.c     |   11 ++++++++++-
 drivers/net/wireless/iwlwifi/iwl-commands.h |    2 +-
 drivers/net/wireless/iwlwifi/iwl-core.h     |    2 ++
 3 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index 396d80c..54b59da 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -219,7 +219,6 @@ static const __le32 iwl6000g2b_concurrent_lookup[12] = {
 static void iwl6000g2b_send_bt_config(struct iwl_priv *priv)
 {
 	struct iwl6000g2b_bt_cmd bt_cmd = {
-		.prio_boost = IWL6000G2B_BT_PRIO_BOOST_DEFAULT,
 		.max_kill = IWL6000G2B_BT_MAX_KILL_DEFAULT,
 		.bt3_timer_t7_value = IWL6000G2B_BT3_T7_DEFAULT,
 		.kill_ack_mask = IWL6000G2B_BT_KILL_ACK_MASK_DEFAULT,
@@ -232,6 +231,8 @@ static void iwl6000g2b_send_bt_config(struct iwl_priv *priv)
 	BUILD_BUG_ON(sizeof(iwl6000g2b_def_3w_lookup) !=
 			sizeof(bt_cmd.bt3_lookup_table));
 
+	bt_cmd.prio_boost = priv->cfg->bt_prio_boost;
+
 	/*
 	 * Configure BT coex mode to "no coexistence" when the
 	 * user disabled BT coexistence, we have no interface
@@ -488,6 +489,8 @@ static void iwl6000g2b_bt_coex_profile_notif(struct iwl_priv *priv,
 				       sizeof(sco_cmd), &sco_cmd, NULL);
 	}
 
+	/* FIXME: based on notification, adjust the prio_boost */
+
 	spin_lock_irqsave(&priv->lock, flags);
 	priv->bt_ci_compliance = coex->bt_ci_compliance;
 	spin_unlock_irqrestore(&priv->lock, flags);
@@ -833,6 +836,7 @@ struct iwl_cfg iwl6000g2b_2agn_cfg = {
 	.scan_tx_antennas[IEEE80211_BAND_2GHZ] = ANT_A,
 	.advanced_bt_coexist = true,
 	.bt_init_traffic_load = IWL_BT_COEX_TRAFFIC_LOAD_NONE,
+	.bt_prio_boost = IWL6000G2B_BT_PRIO_BOOST_DEFAULT,
 };
 
 struct iwl_cfg iwl6000g2b_2abg_cfg = {
@@ -873,6 +877,7 @@ struct iwl_cfg iwl6000g2b_2abg_cfg = {
 	.scan_tx_antennas[IEEE80211_BAND_2GHZ] = ANT_A,
 	.advanced_bt_coexist = true,
 	.bt_init_traffic_load = IWL_BT_COEX_TRAFFIC_LOAD_NONE,
+	.bt_prio_boost = IWL6000G2B_BT_PRIO_BOOST_DEFAULT,
 };
 
 struct iwl_cfg iwl6000g2b_2bgn_cfg = {
@@ -915,6 +920,7 @@ struct iwl_cfg iwl6000g2b_2bgn_cfg = {
 	.scan_tx_antennas[IEEE80211_BAND_2GHZ] = ANT_A,
 	.advanced_bt_coexist = true,
 	.bt_init_traffic_load = IWL_BT_COEX_TRAFFIC_LOAD_NONE,
+	.bt_prio_boost = IWL6000G2B_BT_PRIO_BOOST_DEFAULT,
 };
 
 struct iwl_cfg iwl6000g2b_2bg_cfg = {
@@ -955,6 +961,7 @@ struct iwl_cfg iwl6000g2b_2bg_cfg = {
 	.scan_tx_antennas[IEEE80211_BAND_2GHZ] = ANT_A,
 	.advanced_bt_coexist = true,
 	.bt_init_traffic_load = IWL_BT_COEX_TRAFFIC_LOAD_NONE,
+	.bt_prio_boost = IWL6000G2B_BT_PRIO_BOOST_DEFAULT,
 };
 
 struct iwl_cfg iwl6000g2b_bgn_cfg = {
@@ -997,6 +1004,7 @@ struct iwl_cfg iwl6000g2b_bgn_cfg = {
 	.scan_tx_antennas[IEEE80211_BAND_2GHZ] = ANT_A,
 	.advanced_bt_coexist = true,
 	.bt_init_traffic_load = IWL_BT_COEX_TRAFFIC_LOAD_NONE,
+	.bt_prio_boost = IWL6000G2B_BT_PRIO_BOOST_DEFAULT,
 };
 
 struct iwl_cfg iwl6000g2b_bg_cfg = {
@@ -1037,6 +1045,7 @@ struct iwl_cfg iwl6000g2b_bg_cfg = {
 	.scan_tx_antennas[IEEE80211_BAND_2GHZ] = ANT_A,
 	.advanced_bt_coexist = true,
 	.bt_init_traffic_load = IWL_BT_COEX_TRAFFIC_LOAD_NONE,
+	.bt_prio_boost = IWL6000G2B_BT_PRIO_BOOST_DEFAULT,
 };
 
 /*
diff --git a/drivers/net/wireless/iwlwifi/iwl-commands.h b/drivers/net/wireless/iwlwifi/iwl-commands.h
index b45882a..e742f99 100644
--- a/drivers/net/wireless/iwlwifi/iwl-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-commands.h
@@ -2409,7 +2409,7 @@ struct iwl_bt_cmd {
 
 #define IWL6000G2B_BT_PRIO_BOOST_MAX		0xFF
 #define IWL6000G2B_BT_PRIO_BOOST_MIN		0x00
-#define IWL6000G2B_BT_PRIO_BOOST_DEFAULT	0x00
+#define IWL6000G2B_BT_PRIO_BOOST_DEFAULT	0xF0
 
 #define IWL6000G2B_BT_MAX_KILL_DEFAULT		5
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index d5dacaf..de2e39f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -280,6 +280,7 @@ struct iwl_mod_params {
  * @scan_antennas: available antenna for scan operation
  * @advanced_bt_coexist: support advanced bt coexist
  * @bt_init_traffic_load: specify initial bt traffic load
+ * @bt_prio_boost: default bt priority boost value
  * @need_dc_calib: need to perform init dc calibration
  * @bt_statistics: use BT version of statistics notification
  * @agg_time_limit: maximum number of uSec in aggregation
@@ -355,6 +356,7 @@ struct iwl_cfg {
 	u8 scan_tx_antennas[IEEE80211_NUM_BANDS];
 	bool advanced_bt_coexist;
 	u8 bt_init_traffic_load;
+	u8 bt_prio_boost;
 	const bool need_dc_calib;
 	const bool bt_statistics;
 	u16 agg_time_limit;
-- 
1.7.0.4

