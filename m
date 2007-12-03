Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:54550 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753481AbXLCLph (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Dec 2007 06:45:37 -0500
From: Tomas Winkler <tomas.winkler@intel.com>
To: linville@tuxdriver.com, yi.zhu@intel.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Mohamed Abbas <mabbas@linux.intel.com>
Subject: [PATCH 33/34] iwlwifi: avoid firmware command sending if rfkill is enabled
Date: Mon,  3 Dec 2007 13:43:45 +0200
Message-Id: <1196682233111-git-send-email-tomas.winkler@intel.com> (sfid-20071203_120556_407646_23CD2E85)
In-Reply-To: <11966822332622-git-send-email-tomas.winkler@intel.com>
References: <11966822261109-git-send-email-tomas.winkler@intel.com>
 <11966822291406-git-send-email-tomas.winkler@intel.com>
 <1196682229843-git-send-email-tomas.winkler@intel.com>
 <11966822293932-git-send-email-tomas.winkler@intel.com>
 <11966822291956-git-send-email-tomas.winkler@intel.com>
 <119668222978-git-send-email-tomas.winkler@intel.com>
 <11966822293340-git-send-email-tomas.winkler@intel.com>
 <11966822291143-git-send-email-tomas.winkler@intel.com>
 <11966822301152-git-send-email-tomas.winkler@intel.com>
 <11966822302864-git-send-email-tomas.winkler@intel.com>
 <1196682230902-git-send-email-tomas.winkler@intel.com>
 <11966822302932-git-send-email-tomas.winkler@intel.com>
 <11966822302681-git-send-email-tomas.winkler@intel.com>
 <11966822301936-git-send-email-tomas.winkler@intel.com>
 <11966822302007-git-send-email-tomas.winkler@intel.com>
 <1196682230754-git-send-email-tomas.winkler@intel.com>
 <1196682231211-git-send-email-tomas.winkler@intel.com>
 <11966822313647-git-send-email-tomas.winkler@intel.com>
 <11966822312049-git-send-email-tomas.winkler@intel.com>
 <11966822311588-git-send-email-tomas.winkler@intel.com>
 <11966822314158-git-send-email-tomas.winkler@intel.com>
 <11966822311498-git-send-email-tomas.winkler@intel.com>
 <11966822311945-git-send-email-tomas.winkler@intel.com>
 <11966822312882-git-send-email-tomas.winkler@intel.com>
 <11966822323269-git-send-email-tomas.winkler@intel.com>
 <11966822321249-git-send-email-tomas.winkler@intel.com>
 <11966822324036-git-send-email-tomas.winkler@intel.com>
 <11966822321616-git-send-email-tomas.winkler@intel.com>
 <1196682232443-git-send-email-tomas.winkler@intel.com>
 <11966822323588-git-send-email-tomas.winkler@intel.com>
 <11966822321066-git-send-email-tomas.winkler@intel.com>
 <1196682232185-git-send-email-tomas.winkler@intel.com>
 <11966822332622-git-send-email-tomas.winkler@intel.com>
Content-Type: text/plain; charset="us-ascii"
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
index 8abde7e..7183cdb 100644
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
@@ -7017,6 +7018,12 @@ static void iwl3945_mac_stop(struct ieee80211_hw *hw)
 	 * RXON_FILTER_ASSOC_MSK BIT
 	 */
 	priv->is_open = 0;
+	if (!iwl3945_is_ready_rf(priv)) {
+		IWL_DEBUG_MAC80211("leave - RF not ready\n");
+		mutex_unlock(&priv->mutex);
+		return;
+	}
+
 	iwl3945_scan_cancel_timeout(priv, 100);
 	cancel_delayed_work(&priv->post_associate);
 	priv->staging_rxon.filter_flags &= ~RXON_FILTER_ASSOC_MSK;
@@ -7305,6 +7312,9 @@ static int iwl3945_mac_config_interface(struct ieee80211_hw *hw, int if_id,
 		priv->ibss_beacon = conf->beacon;
 	}
 
+	if (iwl3945_is_rfkill(priv))
+		goto done;
+
 	if (conf->bssid && !is_zero_ether_addr(conf->bssid) &&
 	    !is_multicast_ether_addr(conf->bssid)) {
 		/* If there is currently a HW scan going on in the background
@@ -7339,6 +7349,7 @@ static int iwl3945_mac_config_interface(struct ieee80211_hw *hw, int if_id,
 		iwl3945_commit_rxon(priv);
 	}
 
+ done:
 	spin_lock_irqsave(&priv->lock, flags);
 	if (!conf->ssid_len)
 		memset(priv->essid, 0, IW_ESSID_MAX_SIZE);
@@ -7375,11 +7386,12 @@ static void iwl3945_mac_remove_interface(struct ieee80211_hw *hw,
 
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
@@ -7650,6 +7662,12 @@ static void iwl3945_mac_reset_tsf(struct ieee80211_hw *hw)
 
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
@@ -7667,12 +7685,6 @@ static void iwl3945_mac_reset_tsf(struct ieee80211_hw *hw)
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
index bcc65ff..a740e80 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -2664,9 +2664,6 @@ static void iwl4965_connection_init_rx_config(struct iwl4965_priv *priv)
 
 static int iwl4965_set_mode(struct iwl4965_priv *priv, int mode)
 {
-	if (!iwl4965_is_ready_rf(priv))
-		return -EAGAIN;
-
 	if (mode == IEEE80211_IF_TYPE_IBSS) {
 		const struct iwl4965_channel_info *ch_info;
 
@@ -2681,13 +2678,6 @@ static int iwl4965_set_mode(struct iwl4965_priv *priv, int mode)
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
@@ -2695,6 +2685,17 @@ static int iwl4965_set_mode(struct iwl4965_priv *priv, int mode)
 
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
@@ -7460,6 +7461,12 @@ static void iwl4965_mac_stop(struct ieee80211_hw *hw)
 	 * RXON_FILTER_ASSOC_MSK BIT
 	 */
 	priv->is_open = 0;
+	if (!iwl4965_is_ready_rf(priv)) {
+		IWL_DEBUG_MAC80211("leave - RF not ready\n");
+		mutex_unlock(&priv->mutex);
+		return;
+	}
+
 	iwl4965_scan_cancel_timeout(priv, 100);
 	cancel_delayed_work(&priv->post_associate);
 	priv->staging_rxon.filter_flags &= ~RXON_FILTER_ASSOC_MSK;
@@ -7762,6 +7769,9 @@ static int iwl4965_mac_config_interface(struct ieee80211_hw *hw, int if_id,
 		priv->ibss_beacon = conf->beacon;
 	}
 
+	if (iwl4965_is_rfkill(priv))
+		goto done;
+
 	if (conf->bssid && !is_zero_ether_addr(conf->bssid) &&
 	    !is_multicast_ether_addr(conf->bssid)) {
 		/* If there is currently a HW scan going on in the background
@@ -7796,6 +7806,7 @@ static int iwl4965_mac_config_interface(struct ieee80211_hw *hw, int if_id,
 		iwl4965_commit_rxon(priv);
 	}
 
+ done:
 	spin_lock_irqsave(&priv->lock, flags);
 	if (!conf->ssid_len)
 		memset(priv->essid, 0, IW_ESSID_MAX_SIZE);
@@ -7832,11 +7843,12 @@ static void iwl4965_mac_remove_interface(struct ieee80211_hw *hw,
 
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
@@ -8149,6 +8161,12 @@ static void iwl4965_mac_reset_tsf(struct ieee80211_hw *hw)
 
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
@@ -8166,12 +8184,6 @@ static void iwl4965_mac_reset_tsf(struct ieee80211_hw *hw)
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
1.5.2.2
---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.
