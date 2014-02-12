Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f173.google.com ([209.85.215.173]:59645 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750726AbaBLJJl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Feb 2014 04:09:41 -0500
Received: by mail-ea0-f173.google.com with SMTP id d10so4189424eaj.18
        for <linux-wireless@vger.kernel.org>; Wed, 12 Feb 2014 01:09:40 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH] iwlwifi: disable TX AMPDU by default for iwldvm
Date: Wed, 12 Feb 2014 11:09:35 +0200
Message-Id: <1392196175-6219-1-git-send-email-egrumbach@gmail.com> (sfid-20140212_100950_717000_3303649E)
In-Reply-To: <52FB39F0.9010102@gmail.com>
References: <52FB39F0.9010102@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

We have had a bug in TX AMPDU in iwldvm for a very long
time. This bug has been raised in many bugzillas and threads
on linux-wireless mailing list.

The bug is in firmware and we won't be able to fix it in the
near future. Hence, we prefer to disable TX AMPDU by default
in iwldvm. This doesn't affect iwlmvm which supports 7160 /
3160 and up.

Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/Kconfig         |   10 ++++++++
 drivers/net/wireless/iwlwifi/dvm/mac80211.c  |    8 +++----
 drivers/net/wireless/iwlwifi/dvm/tx.c        |   32 ++++++++++++++------------
 drivers/net/wireless/iwlwifi/iwl-drv.c       |    2 +-
 drivers/net/wireless/iwlwifi/iwl-modparams.h |    1 -
 drivers/net/wireless/iwlwifi/iwl-nvm-parse.c |    2 --
 drivers/net/wireless/iwlwifi/mvm/mac80211.c  |    8 -------
 7 files changed, 32 insertions(+), 31 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/Kconfig b/drivers/net/wireless/iwlwifi/Kconfig
index 3eb2102..ec28564 100644
--- a/drivers/net/wireless/iwlwifi/Kconfig
+++ b/drivers/net/wireless/iwlwifi/Kconfig
@@ -128,3 +128,13 @@ config IWLWIFI_DEVICE_TRACING
 	  If unsure, say Y so we can help you better when problems
 	  occur.
 endmenu
+
+config IWLWIFI_TX_AMPDU
+	bool "Enable TX AMPDU (EXPERIMENTAL)"
+	depends on IWLDVM
+	help
+	  Say Y here to enable TX AMPDU. TX APMDU should give a
+	  significant boost to TX throughput but the firmware has
+	  a bug that prevents it from working properly.
+
+	  If unsure, say N which is the default.
diff --git a/drivers/net/wireless/iwlwifi/dvm/mac80211.c b/drivers/net/wireless/iwlwifi/dvm/mac80211.c
index c24d1d3..e678c83 100644
--- a/drivers/net/wireless/iwlwifi/dvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/dvm/mac80211.c
@@ -105,7 +105,6 @@ int iwlagn_mac_setup_register(struct iwl_priv *priv,
 
 	/* Tell mac80211 our characteristics */
 	hw->flags = IEEE80211_HW_SIGNAL_DBM |
-		    IEEE80211_HW_AMPDU_AGGREGATION |
 		    IEEE80211_HW_NEED_DTIM_BEFORE_ASSOC |
 		    IEEE80211_HW_SPECTRUM_MGMT |
 		    IEEE80211_HW_REPORTS_TX_ACK_STATUS |
@@ -126,7 +125,8 @@ int iwlagn_mac_setup_register(struct iwl_priv *priv,
 
 	if (priv->nvm_data->sku_cap_11n_enable)
 		hw->flags |= IEEE80211_HW_SUPPORTS_DYNAMIC_SMPS |
-			     IEEE80211_HW_SUPPORTS_STATIC_SMPS;
+			     IEEE80211_HW_SUPPORTS_STATIC_SMPS |
+			     IEEE80211_HW_AMPDU_AGGREGATION;
 
 	/*
 	 * Enable 11w if advertised by firmware and software crypto
@@ -729,10 +729,10 @@ static int iwlagn_mac_ampdu_action(struct ieee80211_hw *hw,
 	case IEEE80211_AMPDU_TX_START:
 		if (!priv->trans->ops->txq_enable)
 			break;
-		if (iwlwifi_mod_params.disable_11n & IWL_DISABLE_HT_TXAGG)
-			break;
+#ifdef CONFIG_IWLWIFI_TX_AMPDU
 		IWL_DEBUG_HT(priv, "start Tx\n");
 		ret = iwlagn_tx_agg_start(priv, vif, sta, tid, ssn);
+#endif
 		break;
 	case IEEE80211_AMPDU_TX_STOP_FLUSH:
 	case IEEE80211_AMPDU_TX_STOP_FLUSH_CONT:
diff --git a/drivers/net/wireless/iwlwifi/dvm/tx.c b/drivers/net/wireless/iwlwifi/dvm/tx.c
index a6839df..b19418c 100644
--- a/drivers/net/wireless/iwlwifi/dvm/tx.c
+++ b/drivers/net/wireless/iwlwifi/dvm/tx.c
@@ -480,21 +480,6 @@ drop_unlock_priv:
 	return -1;
 }
 
-static int iwlagn_alloc_agg_txq(struct iwl_priv *priv, int mq)
-{
-	int q;
-
-	for (q = IWLAGN_FIRST_AMPDU_QUEUE;
-	     q < priv->cfg->base_params->num_of_queues; q++) {
-		if (!test_and_set_bit(q, priv->agg_q_alloc)) {
-			priv->queue_to_mac80211[q] = mq;
-			return q;
-		}
-	}
-
-	return -ENOSPC;
-}
-
 static void iwlagn_dealloc_agg_txq(struct iwl_priv *priv, int q)
 {
 	clear_bit(q, priv->agg_q_alloc);
@@ -592,6 +577,22 @@ turn_off:
 	return 0;
 }
 
+#ifdef CONFIG_IWLWIFI_TX_AMPDU
+static int iwlagn_alloc_agg_txq(struct iwl_priv *priv, int mq)
+{
+	int q;
+
+	for (q = IWLAGN_FIRST_AMPDU_QUEUE;
+	     q < priv->cfg->base_params->num_of_queues; q++) {
+		if (!test_and_set_bit(q, priv->agg_q_alloc)) {
+			priv->queue_to_mac80211[q] = mq;
+			return q;
+		}
+	}
+
+	return -ENOSPC;
+}
+
 int iwlagn_tx_agg_start(struct iwl_priv *priv, struct ieee80211_vif *vif,
 			struct ieee80211_sta *sta, u16 tid, u16 *ssn)
 {
@@ -650,6 +651,7 @@ int iwlagn_tx_agg_start(struct iwl_priv *priv, struct ieee80211_vif *vif,
 
 	return ret;
 }
+#endif /* CONFIG_IWLWIFI_TX_AMPDU */
 
 int iwlagn_tx_agg_flush(struct iwl_priv *priv, struct ieee80211_vif *vif,
 			struct ieee80211_sta *sta, u16 tid)
diff --git a/drivers/net/wireless/iwlwifi/iwl-drv.c b/drivers/net/wireless/iwlwifi/iwl-drv.c
index c372816..2a77602 100644
--- a/drivers/net/wireless/iwlwifi/iwl-drv.c
+++ b/drivers/net/wireless/iwlwifi/iwl-drv.c
@@ -1286,7 +1286,7 @@ module_param_named(swcrypto, iwlwifi_mod_params.sw_crypto, int, S_IRUGO);
 MODULE_PARM_DESC(swcrypto, "using crypto in software (default 0 [hardware])");
 module_param_named(11n_disable, iwlwifi_mod_params.disable_11n, uint, S_IRUGO);
 MODULE_PARM_DESC(11n_disable,
-	"disable 11n functionality, bitmap: 1: full, 2: agg TX, 4: agg RX");
+	"disable 11n functionality, bitmap: 1: full, 4: agg RX");
 module_param_named(amsdu_size_8K, iwlwifi_mod_params.amsdu_size_8K,
 		   int, S_IRUGO);
 MODULE_PARM_DESC(amsdu_size_8K, "enable 8K amsdu size (default 0)");
diff --git a/drivers/net/wireless/iwlwifi/iwl-modparams.h b/drivers/net/wireless/iwlwifi/iwl-modparams.h
index 0a84ade..9589c06 100644
--- a/drivers/net/wireless/iwlwifi/iwl-modparams.h
+++ b/drivers/net/wireless/iwlwifi/iwl-modparams.h
@@ -80,7 +80,6 @@ enum iwl_power_level {
 };
 
 #define IWL_DISABLE_HT_ALL	BIT(0)
-#define IWL_DISABLE_HT_TXAGG	BIT(1)
 #define IWL_DISABLE_HT_RXAGG	BIT(2)
 
 /**
diff --git a/drivers/net/wireless/iwlwifi/iwl-nvm-parse.c b/drivers/net/wireless/iwlwifi/iwl-nvm-parse.c
index 725e954..810c76d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-nvm-parse.c
+++ b/drivers/net/wireless/iwlwifi/iwl-nvm-parse.c
@@ -369,8 +369,6 @@ iwl_parse_nvm_data(struct device *dev, const struct iwl_cfg *cfg,
 	data->sku_cap_band_24GHz_enable = sku & NVM_SKU_CAP_BAND_24GHZ;
 	data->sku_cap_band_52GHz_enable = sku & NVM_SKU_CAP_BAND_52GHZ;
 	data->sku_cap_11n_enable = sku & NVM_SKU_CAP_11N_ENABLE;
-	if (iwlwifi_mod_params.disable_11n & IWL_DISABLE_HT_ALL)
-		data->sku_cap_11n_enable = false;
 
 	/* check overrides (some devices have wrong NVM) */
 	if (cfg->valid_tx_ant)
diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index 6bf9766..b068799 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -347,20 +347,12 @@ static int iwl_mvm_mac_ampdu_action(struct ieee80211_hw *hw,
 
 	switch (action) {
 	case IEEE80211_AMPDU_RX_START:
-		if (iwlwifi_mod_params.disable_11n & IWL_DISABLE_HT_RXAGG) {
-			ret = -EINVAL;
-			break;
-		}
 		ret = iwl_mvm_sta_rx_agg(mvm, sta, tid, *ssn, true);
 		break;
 	case IEEE80211_AMPDU_RX_STOP:
 		ret = iwl_mvm_sta_rx_agg(mvm, sta, tid, 0, false);
 		break;
 	case IEEE80211_AMPDU_TX_START:
-		if (iwlwifi_mod_params.disable_11n & IWL_DISABLE_HT_TXAGG) {
-			ret = -EINVAL;
-			break;
-		}
 		ret = iwl_mvm_sta_tx_agg_start(mvm, vif, sta, tid, ssn);
 		break;
 	case IEEE80211_AMPDU_TX_STOP_CONT:
-- 
1.7.9.5

