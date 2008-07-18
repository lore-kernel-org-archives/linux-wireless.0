Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:54091 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751771AbYGRF40 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Jul 2008 01:56:26 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 06/13] iwlwifi: move iwl4965_mac_ampdu_action to iwl4965-base.c
Date: Fri, 18 Jul 2008 13:53:02 +0800
Message-Id: <1216360389-5352-7-git-send-email-yi.zhu@intel.com> (sfid-20080718_075629_234893_2E1B45CB)
In-Reply-To: <1216360389-5352-6-git-send-email-yi.zhu@intel.com>
References: <1216360389-5352-1-git-send-email-yi.zhu@intel.com>
 <1216360389-5352-2-git-send-email-yi.zhu@intel.com>
 <1216360389-5352-3-git-send-email-yi.zhu@intel.com>
 <1216360389-5352-4-git-send-email-yi.zhu@intel.com>
 <1216360389-5352-5-git-send-email-yi.zhu@intel.com>
 <1216360389-5352-6-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

This patch moves iwl4965_mac_ampdu_action to iwl4965-base.c.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965.c     |   33 -------------------------
 drivers/net/wireless/iwlwifi/iwl-dev.h      |    4 ---
 drivers/net/wireless/iwlwifi/iwl4965-base.c |   35 ++++++++++++++++++++++++++-
 3 files changed, 34 insertions(+), 38 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index a419aee..39107c9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -2067,39 +2067,6 @@ static int iwl4965_txq_agg_enable(struct iwl_priv *priv, int txq_id,
 	return 0;
 }
 
-int iwl4965_mac_ampdu_action(struct ieee80211_hw *hw,
-			     enum ieee80211_ampdu_mlme_action action,
-			     const u8 *addr, u16 tid, u16 *ssn)
-{
-	struct iwl_priv *priv = hw->priv;
-	DECLARE_MAC_BUF(mac);
-
-	IWL_DEBUG_HT("A-MPDU action on addr %s tid %d\n",
-		     print_mac(mac, addr), tid);
-
-	if (!(priv->cfg->sku & IWL_SKU_N))
-		return -EACCES;
-
-	switch (action) {
-	case IEEE80211_AMPDU_RX_START:
-		IWL_DEBUG_HT("start Rx\n");
-		return iwl_rx_agg_start(priv, addr, tid, *ssn);
-	case IEEE80211_AMPDU_RX_STOP:
-		IWL_DEBUG_HT("stop Rx\n");
-		return iwl_rx_agg_stop(priv, addr, tid);
-	case IEEE80211_AMPDU_TX_START:
-		IWL_DEBUG_HT("start Tx\n");
-		return iwl_tx_agg_start(priv, addr, tid, ssn);
-	case IEEE80211_AMPDU_TX_STOP:
-		IWL_DEBUG_HT("stop Tx\n");
-		return iwl_tx_agg_stop(priv, addr, tid);
-	default:
-		IWL_DEBUG_HT("unknown\n");
-		return -EINVAL;
-		break;
-	}
-	return 0;
-}
 
 static u16 iwl4965_get_hcmd_size(u8 cmd_id, u16 len)
 {
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 010ed69..d2d4bea 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -643,10 +643,6 @@ struct iwl_priv;
  * Forward declare iwl-4965.c functions for iwl-base.c
  */
 extern void iwl4965_rf_kill_ct_config(struct iwl_priv *priv);
-
-int iwl4965_mac_ampdu_action(struct ieee80211_hw *hw,
-				    enum ieee80211_ampdu_mlme_action action,
-				    const u8 *addr, u16 tid, u16 *ssn);
 int iwl4965_check_empty_hw_queue(struct iwl_priv *priv, int sta_id,
 					u8 tid, int txq_id);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index 217d6c7..d3ed3ca 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -65,7 +65,7 @@
  * NOTE: DRV_NAME is defined in iwlwifi.h for use by iwl-debug.h and printk
  */
 
-#define DRV_DESCRIPTION	"Intel(R) Wireless WiFi Link 4965AGN driver for Linux"
+#define DRV_DESCRIPTION	"Intel(R) Wireless WiFi Link AGN driver for Linux"
 
 #ifdef CONFIG_IWLWIFI_DEBUG
 #define VD "d"
@@ -3346,6 +3346,39 @@ static int iwl4965_mac_conf_tx(struct ieee80211_hw *hw, u16 queue,
 	return 0;
 }
 
+static int iwl4965_mac_ampdu_action(struct ieee80211_hw *hw,
+			     enum ieee80211_ampdu_mlme_action action,
+			     const u8 *addr, u16 tid, u16 *ssn)
+{
+	struct iwl_priv *priv = hw->priv;
+	DECLARE_MAC_BUF(mac);
+
+	IWL_DEBUG_HT("A-MPDU action on addr %s tid %d\n",
+		     print_mac(mac, addr), tid);
+
+	if (!(priv->cfg->sku & IWL_SKU_N))
+		return -EACCES;
+
+	switch (action) {
+	case IEEE80211_AMPDU_RX_START:
+		IWL_DEBUG_HT("start Rx\n");
+		return iwl_rx_agg_start(priv, addr, tid, *ssn);
+	case IEEE80211_AMPDU_RX_STOP:
+		IWL_DEBUG_HT("stop Rx\n");
+		return iwl_rx_agg_stop(priv, addr, tid);
+	case IEEE80211_AMPDU_TX_START:
+		IWL_DEBUG_HT("start Tx\n");
+		return iwl_tx_agg_start(priv, addr, tid, ssn);
+	case IEEE80211_AMPDU_TX_STOP:
+		IWL_DEBUG_HT("stop Tx\n");
+		return iwl_tx_agg_stop(priv, addr, tid);
+	default:
+		IWL_DEBUG_HT("unknown\n");
+		return -EINVAL;
+		break;
+	}
+	return 0;
+}
 static int iwl4965_mac_get_tx_stats(struct ieee80211_hw *hw,
 				struct ieee80211_tx_queue_stats *stats)
 {
-- 
1.5.3.6

