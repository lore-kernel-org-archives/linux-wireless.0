Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:58934 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752407Ab1LSWne (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Dec 2011 17:43:34 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 2/6] iwlagn: finer-grained HT disable
Date: Mon, 19 Dec 2011 13:43:09 -0800
Message-Id: <1324330993-24476-3-git-send-email-wey-yi.w.guy@intel.com> (sfid-20111219_234348_845684_D3D65168)
In-Reply-To: <1324330993-24476-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1324330993-24476-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

At least while debugging, a lot of people use
11n_disable=1 to disable HT completely. To be
able to figure out what parts of HT cause the
problems we see, make the parameter a bitmap,
allowing to disable all of HT and aggregation
(TX/RX) separately.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c      |    7 ++++---
 drivers/net/wireless/iwlwifi/iwl-mac80211.c |    4 ++++
 drivers/net/wireless/iwlwifi/iwl-shared.h   |    9 +++++++--
 3 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index b2d95e8..9daa4d9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -1668,7 +1668,7 @@ static int iwl_set_hw_params(struct iwl_priv *priv)
 		hw_params(priv).rx_page_order =
 			get_order(IWL_RX_BUF_SIZE_4K);
 
-	if (iwlagn_mod_params.disable_11n)
+	if (iwlagn_mod_params.disable_11n & IWL_DISABLE_HT_ALL)
 		cfg(priv)->sku &= ~EEPROM_SKU_CAP_11N_ENABLE;
 
 	hw_params(priv).num_ampdu_queues =
@@ -1995,8 +1995,9 @@ module_param_named(swcrypto, iwlagn_mod_params.sw_crypto, int, S_IRUGO);
 MODULE_PARM_DESC(swcrypto, "using crypto in software (default 0 [hardware])");
 module_param_named(queues_num, iwlagn_mod_params.num_of_queues, int, S_IRUGO);
 MODULE_PARM_DESC(queues_num, "number of hw queues.");
-module_param_named(11n_disable, iwlagn_mod_params.disable_11n, int, S_IRUGO);
-MODULE_PARM_DESC(11n_disable, "disable 11n functionality");
+module_param_named(11n_disable, iwlagn_mod_params.disable_11n, uint, S_IRUGO);
+MODULE_PARM_DESC(11n_disable,
+	"disable 11n functionality, bitmap: 1: full, 2: agg TX, 4: agg RX");
 module_param_named(amsdu_size_8K, iwlagn_mod_params.amsdu_size_8K,
 		   int, S_IRUGO);
 MODULE_PARM_DESC(amsdu_size_8K, "enable 8K amsdu size");
diff --git a/drivers/net/wireless/iwlwifi/iwl-mac80211.c b/drivers/net/wireless/iwlwifi/iwl-mac80211.c
index da68958..8dc50dd 100644
--- a/drivers/net/wireless/iwlwifi/iwl-mac80211.c
+++ b/drivers/net/wireless/iwlwifi/iwl-mac80211.c
@@ -633,6 +633,8 @@ static int iwlagn_mac_ampdu_action(struct ieee80211_hw *hw,
 
 	switch (action) {
 	case IEEE80211_AMPDU_RX_START:
+		if (iwlagn_mod_params.disable_11n & IWL_DISABLE_HT_RXAGG)
+			break;
 		IWL_DEBUG_HT(priv, "start Rx\n");
 		ret = iwl_sta_rx_agg_start(priv, sta, tid, *ssn);
 		break;
@@ -643,6 +645,8 @@ static int iwlagn_mac_ampdu_action(struct ieee80211_hw *hw,
 			ret = 0;
 		break;
 	case IEEE80211_AMPDU_TX_START:
+		if (iwlagn_mod_params.disable_11n & IWL_DISABLE_HT_TXAGG)
+			break;
 		IWL_DEBUG_HT(priv, "start Tx\n");
 		ret = iwlagn_tx_agg_start(priv, vif, sta, tid, ssn);
 		break;
diff --git a/drivers/net/wireless/iwlwifi/iwl-shared.h b/drivers/net/wireless/iwlwifi/iwl-shared.h
index 8cf877e..66c6258 100644
--- a/drivers/net/wireless/iwlwifi/iwl-shared.h
+++ b/drivers/net/wireless/iwlwifi/iwl-shared.h
@@ -107,6 +107,10 @@ struct iwl_trans_ops;
 
 extern struct iwl_mod_params iwlagn_mod_params;
 
+#define IWL_DISABLE_HT_ALL	BIT(0)
+#define IWL_DISABLE_HT_TXAGG	BIT(1)
+#define IWL_DISABLE_HT_RXAGG	BIT(2)
+
 /**
  * struct iwl_mod_params
  *
@@ -114,7 +118,8 @@ extern struct iwl_mod_params iwlagn_mod_params;
  *
  * @sw_crypto: using hardware encryption, default = 0
  * @num_of_queues: number of tx queue, HW dependent
- * @disable_11n: 11n capabilities enabled, default = 0
+ * @disable_11n: disable 11n capabilities, default = 0,
+ *	use IWL_DISABLE_HT_* constants
  * @amsdu_size_8K: enable 8K amsdu size, default = 1
  * @antenna: both antennas (use diversity), default = 0
  * @restart_fw: restart firmware, default = 1
@@ -135,7 +140,7 @@ extern struct iwl_mod_params iwlagn_mod_params;
 struct iwl_mod_params {
 	int sw_crypto;
 	int num_of_queues;
-	int disable_11n;
+	unsigned int disable_11n;
 	int amsdu_size_8K;
 	int antenna;
 	int restart_fw;
-- 
1.7.0.4

