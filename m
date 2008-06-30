Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:19551 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758876AbYF3J1N (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Jun 2008 05:27:13 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Ron Rindjunsky <ron.rindjunsky@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 21/33] iwlwifi: control 11n capabilities through module param
Date: Mon, 30 Jun 2008 17:23:21 +0800
Message-Id: <1214817813-17639-22-git-send-email-yi.zhu@intel.com> (sfid-20080630_113813_328566_59A238CE)
In-Reply-To: <1214817813-17639-21-git-send-email-yi.zhu@intel.com>
References: <1214817813-17639-1-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-2-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-3-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-4-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-5-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-6-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-7-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-8-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-9-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-10-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-11-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-12-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-13-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-14-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-15-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-16-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-17-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-18-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-19-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-20-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-21-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ron Rindjunsky <ron.rindjunsky@intel.com>

This patch adds module param 11n_disable to allow configuration of 11n
capabilities. The default value of this param is 11n enabled (value 0).

Signed-off-by: Ron Rindjunsky <ron.rindjunsky@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965.c |    8 +++++++-
 drivers/net/wireless/iwlwifi/iwl-5000.c |    2 ++
 drivers/net/wireless/iwlwifi/iwl-core.c |   16 ++++++++++++----
 drivers/net/wireless/iwlwifi/iwl-core.h |    1 +
 4 files changed, 22 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 7f6713f..e4eab51 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -2075,6 +2075,9 @@ int iwl4965_mac_ampdu_action(struct ieee80211_hw *hw,
 	IWL_DEBUG_HT("A-MPDU action on addr %s tid %d\n",
 		     print_mac(mac, addr), tid);
 
+	if (!(priv->cfg->sku & IWL_SKU_N))
+		return -EACCES;
+
 	switch (action) {
 	case IEEE80211_AMPDU_RX_START:
 		IWL_DEBUG_HT("start Rx\n");
@@ -2457,11 +2460,14 @@ MODULE_PARM_DESC(disable_hw_scan, "disable hardware scanning (default 0)");
 
 module_param_named(queues_num, iwl4965_mod_params.num_of_queues, int, 0444);
 MODULE_PARM_DESC(queues_num, "number of hw queues.");
-
 /* QoS */
 module_param_named(qos_enable, iwl4965_mod_params.enable_qos, int, 0444);
 MODULE_PARM_DESC(qos_enable, "enable all QoS functionality");
+/* 11n */
+module_param_named(11n_disable, iwl4965_mod_params.disable_11n, int, 0444);
+MODULE_PARM_DESC(11n_disable, "disable 11n functionality");
 module_param_named(amsdu_size_8K, iwl4965_mod_params.amsdu_size_8K, int, 0444);
 MODULE_PARM_DESC(amsdu_size_8K, "enable 8K amsdu size");
+
 module_param_named(fw_restart4965, iwl4965_mod_params.restart_fw, int, 0444);
 MODULE_PARM_DESC(fw_restart4965, "restart firmware in case of error");
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index 75283fb..099983f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -1540,6 +1540,8 @@ module_param_named(queues_num50, iwl50_mod_params.num_of_queues, int, 0444);
 MODULE_PARM_DESC(queues_num50, "number of hw queues in 50xx series");
 module_param_named(qos_enable50, iwl50_mod_params.enable_qos, int, 0444);
 MODULE_PARM_DESC(qos_enable50, "enable all 50XX QoS functionality");
+module_param_named(11n_disable50, iwl50_mod_params.disable_11n, int, 0444);
+MODULE_PARM_DESC(11n_disable50, "disable 50XX 11n functionality");
 module_param_named(amsdu_size_8K50, iwl50_mod_params.amsdu_size_8K, int, 0444);
 MODULE_PARM_DESC(amsdu_size_8K50, "enable 8K amsdu size in 50XX series");
 module_param_named(fw_restart50, iwl50_mod_params.restart_fw, int, 0444);
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 97447df..08a42a7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -495,7 +495,9 @@ static int iwlcore_init_geos(struct iwl_priv *priv)
 	sband->bitrates = &rates[IWL_FIRST_OFDM_RATE];
 	sband->n_bitrates = IWL_RATE_COUNT - IWL_FIRST_OFDM_RATE;
 
-	iwlcore_init_ht_hw_capab(priv, &sband->ht_info, IEEE80211_BAND_5GHZ);
+	if (priv->cfg->sku & IWL_SKU_N)
+		iwlcore_init_ht_hw_capab(priv, &sband->ht_info,
+					 IEEE80211_BAND_5GHZ);
 
 	sband = &priv->bands[IEEE80211_BAND_2GHZ];
 	sband->channels = channels;
@@ -503,7 +505,9 @@ static int iwlcore_init_geos(struct iwl_priv *priv)
 	sband->bitrates = rates;
 	sband->n_bitrates = IWL_RATE_COUNT;
 
-	iwlcore_init_ht_hw_capab(priv, &sband->ht_info, IEEE80211_BAND_2GHZ);
+	if (priv->cfg->sku & IWL_SKU_N)
+		iwlcore_init_ht_hw_capab(priv, &sband->ht_info,
+					 IEEE80211_BAND_2GHZ);
 
 	priv->ieee_channels = channels;
 	priv->ieee_rates = rates;
@@ -819,8 +823,9 @@ int iwl_setup_mac(struct iwl_priv *priv)
 		    IEEE80211_HW_NOISE_DBM;
 	/* Default value; 4 EDCA QOS priorities */
 	hw->queues = 4;
-	/* Enhanced value; more queues, to support 11n aggregation */
-	hw->ampdu_queues = 12;
+	/* queues to support 11n aggregation */
+	if (priv->cfg->sku & IWL_SKU_N)
+		hw->ampdu_queues = 12;
 
 	hw->conf.beacon_int = 100;
 
@@ -853,6 +858,9 @@ int iwl_set_hw_params(struct iwl_priv *priv)
 		priv->hw_params.rx_buf_size = IWL_RX_BUF_SIZE_4K;
 	priv->hw_params.max_pkt_size = priv->hw_params.rx_buf_size - 256;
 
+	if (priv->cfg->mod_params->disable_11n)
+		priv->cfg->sku &= ~IWL_SKU_N;
+
 	/* Device-specific setup */
 	return priv->cfg->ops->lib->set_hw_params(priv);
 }
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index f156d27..d7562c3 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -159,6 +159,7 @@ struct iwl_mod_params {
 	int disable_hw_scan;	/* def: 0 = use h/w scan */
 	int num_of_queues;	/* def: HW dependent */
 	int enable_qos;		/* def: 1 = use quality of service */
+	int disable_11n;	/* def: 0 = disable 11n capabilities */
 	int amsdu_size_8K;	/* def: 1 = enable 8K amsdu size */
 	int antenna;  		/* def: 0 = both antennas (use diversity) */
 	int restart_fw;		/* def: 1 = restart firmware */
-- 
1.5.3.6

