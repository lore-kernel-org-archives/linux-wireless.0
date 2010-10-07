Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:59924 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753630Ab0JGXIu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Oct 2010 19:08:50 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 11/22] iwlwifi: move iwl_toggle_rx_ant to agn
Date: Thu,  7 Oct 2010 16:07:50 -0700
Message-Id: <1286492881-15743-12-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1286492881-15743-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1286492881-15743-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The iwl_toggle_tx_ant function is only used
by agn code, so it can be moved into the
agn module instead of being exported from
the core.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c |   17 +++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-agn.h     |    2 ++
 drivers/net/wireless/iwlwifi/iwl-core.c    |   18 ------------------
 drivers/net/wireless/iwlwifi/iwl-core.h    |    2 --
 4 files changed, 19 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index 3eeab0a..9f1c93b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -2205,3 +2205,20 @@ void iwlagn_set_rxon_chain(struct iwl_priv *priv, struct iwl_rxon_context *ctx)
 	WARN_ON(active_rx_cnt == 0 || idle_rx_cnt == 0 ||
 		active_rx_cnt < idle_rx_cnt);
 }
+
+u8 iwl_toggle_tx_ant(struct iwl_priv *priv, u8 ant, u8 valid)
+{
+	int i;
+	u8 ind = ant;
+
+	if (priv->band == IEEE80211_BAND_2GHZ &&
+	    priv->bt_traffic_load >= IWL_BT_COEX_TRAFFIC_LOAD_HIGH)
+		return 0;
+
+	for (i = 0; i < RATE_ANT_NUM - 1; i++) {
+		ind = (ind + 1) < RATE_ANT_NUM ?  ind + 1 : 0;
+		if (valid & BIT(ind))
+			return ind;
+	}
+	return ant;
+}
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.h b/drivers/net/wireless/iwlwifi/iwl-agn.h
index d6645ec..cc7a3b5 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.h
@@ -216,6 +216,8 @@ static inline bool iwl_is_tx_success(u32 status)
 	       (status == TX_STATUS_DIRECT_DONE);
 }
 
+u8 iwl_toggle_tx_ant(struct iwl_priv *priv, u8 ant_idx, u8 valid);
+
 /* rx */
 void iwl_rx_missed_beacon_notif(struct iwl_priv *priv,
 				struct iwl_rx_mem_buffer *rxb);
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 2950384..88c1ed5 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -72,24 +72,6 @@ MODULE_PARM_DESC(bt_coex_active, "enable wifi/bluetooth co-exist");
 u32 iwl_debug_level;
 EXPORT_SYMBOL(iwl_debug_level);
 
-u8 iwl_toggle_tx_ant(struct iwl_priv *priv, u8 ant, u8 valid)
-{
-	int i;
-	u8 ind = ant;
-
-	if (priv->band == IEEE80211_BAND_2GHZ &&
-	    priv->bt_traffic_load >= IWL_BT_COEX_TRAFFIC_LOAD_HIGH)
-		return 0;
-
-	for (i = 0; i < RATE_ANT_NUM - 1; i++) {
-		ind = (ind + 1) < RATE_ANT_NUM ?  ind + 1 : 0;
-		if (valid & BIT(ind))
-			return ind;
-	}
-	return ant;
-}
-EXPORT_SYMBOL(iwl_toggle_tx_ant);
-
 const u8 iwl_bcast_addr[ETH_ALEN] = { 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF };
 EXPORT_SYMBOL(iwl_bcast_addr);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 56251de..0bc7b7a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -550,8 +550,6 @@ int iwl_set_tx_power(struct iwl_priv *priv, s8 tx_power, bool force);
 u8 iwl_rate_get_lowest_plcp(struct iwl_priv *priv,
 			    struct iwl_rxon_context *ctx);
 
-u8 iwl_toggle_tx_ant(struct iwl_priv *priv, u8 ant_idx, u8 valid);
-
 static inline u32 iwl_ant_idx_to_flags(u8 ant_idx)
 {
 	return BIT(ant_idx) << RATE_MCS_ANT_POS;
-- 
1.7.0.4

