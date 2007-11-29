Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:56161 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756896AbXK2DLX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Nov 2007 22:11:23 -0500
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Mohamed Abbas <mabbas@linux.intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 35/36] iwlwifi: avoid firmware command sending if rfkill is enabled
Date: Thu, 29 Nov 2007 11:10:15 +0800
Message-Id: <1196305816-23023-36-git-send-email-yi.zhu@intel.com> (sfid-20071129_033549_163606_1867F217)
In-Reply-To: <1196305816-23023-35-git-send-email-yi.zhu@intel.com>
References: <1196305816-23023-1-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-2-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-3-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-4-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-5-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-6-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-7-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-8-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-9-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-10-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-11-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-12-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-13-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-14-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-15-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-16-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-17-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-18-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-19-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-20-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-21-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-22-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-23-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-24-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-25-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-26-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-27-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-28-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-29-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-30-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-31-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-32-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-33-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-34-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-35-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohamed Abbas <mabbas@linux.intel.com>

This patch fixed a ucode timeout issue and worked code with suspend
to disk.

Signed-off-by: Mohamed Abbas <mabbas@linux.intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl3945-base.c |   54 ++++++++++++++++----------
 drivers/net/wireless/iwlwifi/iwl4965-base.c |   54 ++++++++++++++++----------
 2 files changed, 66 insertions(+), 42 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 5bef76d..963d3cd 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -2546,9 +2546,6 @@ static void iwl3945_connection_init_rx_config(struct iwl3945_priv *priv)
 
 static int iwl3945_set_mode(struct iwl3945_priv *priv, int mode)
 {
-	if (!iwl3945_is_ready_rf(priv))
-		return -EAGAIN;
-
 	if (mode == IEEE80211_IF_TYPE_IBSS) {
 		const struct iwl3945_channel_info *ch_info;
 
@@ -2563,13 +2560,6 @@ static int iwl3945_set_mode(struct iwl3945_priv *priv, int mode)
 		}
 	}
 
-	cancel_delayed_work(&priv->scan_check);
-	if (iwl3945_scan_cancel_timeout(priv, 100)) {
-		IWL_WARNING("Aborted scan still in progress after 100ms\n");
-		IWL_DEBUG_MAC80211("leaving - scan abort failed.\n");
-		return -EAGAIN;
-	}
-
 	priv->iw_mode = mode;
 
 	iwl3945_connection_init_rx_config(priv);
@@ -2577,6 +2567,17 @@ static int iwl3945_set_mode(struct iwl3945_priv *priv, int mode)
 
 	iwl3945_clear_stations_table(priv);
 
+	/* dont commit rxon if rf-kill is on*/
+	if (!iwl3945_is_ready_rf(priv))
+		return -EAGAIN;
+
+	cancel_delayed_work(&priv->scan_check);
+	if (iwl3945_scan_cancel_timeout(priv, 100)) {
+		IWL_WARNING("Aborted scan still in progress after 100ms\n");
+		IWL_DEBUG_MAC80211("leaving - scan abort failed.\n");
+		return -EAGAIN;
+	}
+
 	iwl3945_commit_rxon(priv);
 
 	return 0;
@@ -7012,6 +7013,12 @@ static void iwl3945_mac_stop(struct ieee80211_hw *hw)
 	 * RXON_FILTER_ASSOC_MSK BIT
 	 */
 	priv->is_open = 0;
+	if (!iwl3945_is_ready_rf(priv)) {
+		IWL_DEBUG_MAC80211("leave - RF not ready\n");
+		mutex_unlock(&priv->mutex);
+		return 0;
+	}
+
 	iwl3945_scan_cancel_timeout(priv, 100);
 	cancel_delayed_work(&priv->post_associate);
 	priv->staging_rxon.filter_flags &= ~RXON_FILTER_ASSOC_MSK;
@@ -7280,6 +7287,9 @@ static int iwl3945_mac_config_interface(struct ieee80211_hw *hw, int if_id,
 		priv->ibss_beacon = conf->beacon;
 	}
 
+	if (iwl3945_is_rfkill(priv))
+		goto done;
+
 	if (conf->bssid && !is_zero_ether_addr(conf->bssid) &&
 	    !is_multicast_ether_addr(conf->bssid)) {
 		/* If there is currently a HW scan going on in the background
@@ -7314,6 +7324,7 @@ static int iwl3945_mac_config_interface(struct ieee80211_hw *hw, int if_id,
 		iwl3945_commit_rxon(priv);
 	}
 
+ done:
 	spin_lock_irqsave(&priv->lock, flags);
 	if (!conf->ssid_len)
 		memset(priv->essid, 0, IW_ESSID_MAX_SIZE);
@@ -7350,11 +7361,12 @@ static void iwl3945_mac_remove_interface(struct ieee80211_hw *hw,
 
 	mutex_lock(&priv->mutex);
 
-	iwl3945_scan_cancel_timeout(priv, 100);
-	cancel_delayed_work(&priv->post_associate);
-	priv->staging_rxon.filter_flags &= ~RXON_FILTER_ASSOC_MSK;
-	iwl3945_commit_rxon(priv);
-
+	if (iwl3945_is_ready_rf(priv)) {
+		iwl3945_scan_cancel_timeout(priv, 100);
+		cancel_delayed_work(&priv->post_associate);
+		priv->staging_rxon.filter_flags &= ~RXON_FILTER_ASSOC_MSK;
+		iwl3945_commit_rxon(priv);
+	}
 	if (priv->interface_id == conf->if_id) {
 		priv->interface_id = 0;
 		memset(priv->bssid, 0, ETH_ALEN);
@@ -7625,6 +7637,12 @@ static void iwl3945_mac_reset_tsf(struct ieee80211_hw *hw)
 
 	spin_unlock_irqrestore(&priv->lock, flags);
 
+	if (!iwl3945_is_ready_rf(priv)) {
+		IWL_DEBUG_MAC80211("leave - not ready\n");
+		mutex_unlock(&priv->mutex);
+		return;
+	}
+
 	/* we are restarting association process
 	 * clear RXON_FILTER_ASSOC_MSK bit
 	*/
@@ -7642,12 +7660,6 @@ static void iwl3945_mac_reset_tsf(struct ieee80211_hw *hw)
 		return;
 	}
 
-	if (!iwl3945_is_ready_rf(priv)) {
-		IWL_DEBUG_MAC80211("leave - not ready\n");
-		mutex_unlock(&priv->mutex);
-		return;
-	}
-
 	priv->only_active_channel = 0;
 
 	iwl3945_set_rate(priv);
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index c9e5b95..98a394e 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -2649,9 +2649,6 @@ static void iwl4965_connection_init_rx_config(struct iwl4965_priv *priv)
 
 static int iwl4965_set_mode(struct iwl4965_priv *priv, int mode)
 {
-	if (!iwl4965_is_ready_rf(priv))
-		return -EAGAIN;
-
 	if (mode == IEEE80211_IF_TYPE_IBSS) {
 		const struct iwl4965_channel_info *ch_info;
 
@@ -2666,13 +2663,6 @@ static int iwl4965_set_mode(struct iwl4965_priv *priv, int mode)
 		}
 	}
 
-	cancel_delayed_work(&priv->scan_check);
-	if (iwl4965_scan_cancel_timeout(priv, 100)) {
-		IWL_WARNING("Aborted scan still in progress after 100ms\n");
-		IWL_DEBUG_MAC80211("leaving - scan abort failed.\n");
-		return -EAGAIN;
-	}
-
 	priv->iw_mode = mode;
 
 	iwl4965_connection_init_rx_config(priv);
@@ -2680,6 +2670,17 @@ static int iwl4965_set_mode(struct iwl4965_priv *priv, int mode)
 
 	iwl4965_clear_stations_table(priv);
 
+	/* dont commit rxon if rf-kill is on*/
+	if (!iwl4965_is_ready_rf(priv))
+		return -EAGAIN;
+
+	cancel_delayed_work(&priv->scan_check);
+	if (iwl4965_scan_cancel_timeout(priv, 100)) {
+		IWL_WARNING("Aborted scan still in progress after 100ms\n");
+		IWL_DEBUG_MAC80211("leaving - scan abort failed.\n");
+		return -EAGAIN;
+	}
+
 	iwl4965_commit_rxon(priv);
 
 	return 0;
@@ -7450,6 +7451,12 @@ static void iwl4965_mac_stop(struct ieee80211_hw *hw)
 	 * RXON_FILTER_ASSOC_MSK BIT
 	 */
 	priv->is_open = 0;
+	if (!iwl4965_is_ready_rf(priv)) {
+		IWL_DEBUG_MAC80211("leave - RF not ready\n");
+		mutex_unlock(&priv->mutex);
+		return 0;
+	}
+
 	iwl4965_scan_cancel_timeout(priv, 100);
 	cancel_delayed_work(&priv->post_associate);
 	priv->staging_rxon.filter_flags &= ~RXON_FILTER_ASSOC_MSK;
@@ -7733,6 +7740,9 @@ static int iwl4965_mac_config_interface(struct ieee80211_hw *hw, int if_id,
 		priv->ibss_beacon = conf->beacon;
 	}
 
+	if (iwl4965_is_rfkill(priv))
+		goto done;
+
 	if (conf->bssid && !is_zero_ether_addr(conf->bssid) &&
 	    !is_multicast_ether_addr(conf->bssid)) {
 		/* If there is currently a HW scan going on in the background
@@ -7767,6 +7777,7 @@ static int iwl4965_mac_config_interface(struct ieee80211_hw *hw, int if_id,
 		iwl4965_commit_rxon(priv);
 	}
 
+ done:
 	spin_lock_irqsave(&priv->lock, flags);
 	if (!conf->ssid_len)
 		memset(priv->essid, 0, IW_ESSID_MAX_SIZE);
@@ -7803,11 +7814,12 @@ static void iwl4965_mac_remove_interface(struct ieee80211_hw *hw,
 
 	mutex_lock(&priv->mutex);
 
-	iwl4965_scan_cancel_timeout(priv, 100);
-	cancel_delayed_work(&priv->post_associate);
-	priv->staging_rxon.filter_flags &= ~RXON_FILTER_ASSOC_MSK;
-	iwl4965_commit_rxon(priv);
-
+	if (iwl4965_is_ready_rf(priv)) {
+		iwl4965_scan_cancel_timeout(priv, 100);
+		cancel_delayed_work(&priv->post_associate);
+		priv->staging_rxon.filter_flags &= ~RXON_FILTER_ASSOC_MSK;
+		iwl4965_commit_rxon(priv);
+	}
 	if (priv->interface_id == conf->if_id) {
 		priv->interface_id = 0;
 		memset(priv->bssid, 0, ETH_ALEN);
@@ -8120,6 +8132,12 @@ static void iwl4965_mac_reset_tsf(struct ieee80211_hw *hw)
 
 	spin_unlock_irqrestore(&priv->lock, flags);
 
+	if (!iwl4965_is_ready_rf(priv)) {
+		IWL_DEBUG_MAC80211("leave - not ready\n");
+		mutex_unlock(&priv->mutex);
+		return;
+	}
+
 	/* we are restarting association process
 	 * clear RXON_FILTER_ASSOC_MSK bit
 	 */
@@ -8137,12 +8155,6 @@ static void iwl4965_mac_reset_tsf(struct ieee80211_hw *hw)
 		return;
 	}
 
-	if (!iwl4965_is_ready_rf(priv)) {
-		IWL_DEBUG_MAC80211("leave - not ready\n");
-		mutex_unlock(&priv->mutex);
-		return;
-	}
-
 	priv->only_active_channel = 0;
 
 	iwl4965_set_rate(priv);
-- 
1.5.3.6
