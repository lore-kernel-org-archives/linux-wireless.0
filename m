Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:4998 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753500AbZASX2P (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Jan 2009 18:28:15 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	"Winkler, Tomas" <tomas.winkler@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 03/15] iwlwifi: kill iwl3945_scan_cancel and iwl3945_scan_cancel_timeout
Date: Mon, 19 Jan 2009 15:30:23 -0800
Message-Id: <1232407835-19451-4-git-send-email-reinette.chatre@intel.com> (sfid-20090120_002825_376998_55AB8EE1)
In-Reply-To: <1232407835-19451-3-git-send-email-reinette.chatre@intel.com>
References: <>
 <1232407835-19451-1-git-send-email-reinette.chatre@intel.com>
 <1232407835-19451-2-git-send-email-reinette.chatre@intel.com>
 <1232407835-19451-3-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Winkler, Tomas <tomas.winkler@intel.com>

This patch removes iwl3945_scan_cancel and iwl3945_scan_cancel_timeout
because iwl_scan_cancel iwl_scan_cancel_timeout are just same.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl3945-base.c |   76 ++++----------------------
 1 files changed, 12 insertions(+), 64 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 313f874..b033650 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -1734,58 +1734,6 @@ static int iwl3945_send_power_mode(struct iwl_priv *priv, u32 mode)
 	return rc;
 }
 
-/**
- * iwl3945_scan_cancel - Cancel any currently executing HW scan
- *
- * NOTE: priv->mutex is not required before calling this function
- */
-static int iwl3945_scan_cancel(struct iwl_priv *priv)
-{
-	if (!test_bit(STATUS_SCAN_HW, &priv->status)) {
-		clear_bit(STATUS_SCANNING, &priv->status);
-		return 0;
-	}
-
-	if (test_bit(STATUS_SCANNING, &priv->status)) {
-		if (!test_bit(STATUS_SCAN_ABORTING, &priv->status)) {
-			IWL_DEBUG_SCAN("Queuing scan abort.\n");
-			set_bit(STATUS_SCAN_ABORTING, &priv->status);
-			queue_work(priv->workqueue, &priv->abort_scan);
-
-		} else
-			IWL_DEBUG_SCAN("Scan abort already in progress.\n");
-
-		return test_bit(STATUS_SCANNING, &priv->status);
-	}
-
-	return 0;
-}
-
-/**
- * iwl3945_scan_cancel_timeout - Cancel any currently executing HW scan
- * @ms: amount of time to wait (in milliseconds) for scan to abort
- *
- * NOTE: priv->mutex must be held before calling this function
- */
-static int iwl3945_scan_cancel_timeout(struct iwl_priv *priv, unsigned long ms)
-{
-	unsigned long now = jiffies;
-	int ret;
-
-	ret = iwl3945_scan_cancel(priv);
-	if (ret && ms) {
-		mutex_unlock(&priv->mutex);
-		while (!time_after(jiffies, now + msecs_to_jiffies(ms)) &&
-				test_bit(STATUS_SCANNING, &priv->status))
-			msleep(1);
-		mutex_lock(&priv->mutex);
-
-		return test_bit(STATUS_SCANNING, &priv->status);
-	}
-
-	return ret;
-}
-
 #define MAX_UCODE_BEACON_INTERVAL	1024
 #define INTEL_CONN_LISTEN_INTERVAL	__constant_cpu_to_le16(0xA)
 
@@ -2022,7 +1970,7 @@ static int iwl3945_set_mode(struct iwl_priv *priv, int mode)
 		return -EAGAIN;
 
 	cancel_delayed_work(&priv->scan_check);
-	if (iwl3945_scan_cancel_timeout(priv, 100)) {
+	if (iwl_scan_cancel_timeout(priv, 100)) {
 		IWL_WARN(priv, "Aborted scan still in progress after 100ms\n");
 		IWL_DEBUG_MAC80211("leaving - scan abort failed.\n");
 		return -EAGAIN;
@@ -2502,7 +2450,7 @@ static void iwl3945_radio_kill_sw(struct iwl_priv *priv, int disable_radio)
 			  disable_radio ? "OFF" : "ON");
 
 	if (disable_radio) {
-		iwl3945_scan_cancel(priv);
+		iwl_scan_cancel(priv);
 		/* FIXME: This is a workaround for AP */
 		if (priv->iw_mode != NL80211_IFTYPE_AP) {
 			spin_lock_irqsave(&priv->lock, flags);
@@ -3008,7 +2956,7 @@ static void iwl3945_rx_card_state_notif(struct iwl_priv *priv,
 	else
 		clear_bit(STATUS_RF_KILL_SW, &priv->status);
 
-	iwl3945_scan_cancel(priv);
+	iwl_scan_cancel(priv);
 
 	if ((test_bit(STATUS_RF_KILL_HW, &status) !=
 	     test_bit(STATUS_RF_KILL_HW, &priv->status)) ||
@@ -5794,7 +5742,7 @@ static void iwl3945_post_associate(struct iwl_priv *priv)
 	if (!priv->vif || !priv->is_open)
 		return;
 
-	iwl3945_scan_cancel_timeout(priv, 200);
+	iwl_scan_cancel_timeout(priv, 200);
 
 	conf = ieee80211_get_hw_conf(priv->hw);
 
@@ -5995,7 +5943,7 @@ static void iwl3945_mac_stop(struct ieee80211_hw *hw)
 		 * RXON_FILTER_ASSOC_MSK BIT
 		 */
 		mutex_lock(&priv->mutex);
-		iwl3945_scan_cancel_timeout(priv, 100);
+		iwl_scan_cancel_timeout(priv, 100);
 		mutex_unlock(&priv->mutex);
 	}
 
@@ -6273,7 +6221,7 @@ static int iwl3945_mac_config_interface(struct ieee80211_hw *hw,
 	    !is_multicast_ether_addr(conf->bssid)) {
 		/* If there is currently a HW scan going on in the background
 		 * then we need to cancel it else the RXON below will fail. */
-		if (iwl3945_scan_cancel_timeout(priv, 100)) {
+		if (iwl_scan_cancel_timeout(priv, 100)) {
 			IWL_WARN(priv, "Aborted scan still in progress "
 				    "after 100ms\n");
 			IWL_DEBUG_MAC80211("leaving - scan abort failed.\n");
@@ -6298,7 +6246,7 @@ static int iwl3945_mac_config_interface(struct ieee80211_hw *hw,
 		}
 
 	} else {
-		iwl3945_scan_cancel_timeout(priv, 100);
+		iwl_scan_cancel_timeout(priv, 100);
 		priv->staging39_rxon.filter_flags &= ~RXON_FILTER_ASSOC_MSK;
 		iwl3945_commit_rxon(priv);
 	}
@@ -6366,7 +6314,7 @@ static void iwl3945_mac_remove_interface(struct ieee80211_hw *hw,
 	mutex_lock(&priv->mutex);
 
 	if (iwl_is_ready_rf(priv)) {
-		iwl3945_scan_cancel_timeout(priv, 100);
+		iwl_scan_cancel_timeout(priv, 100);
 		priv->staging39_rxon.filter_flags &= ~RXON_FILTER_ASSOC_MSK;
 		iwl3945_commit_rxon(priv);
 	}
@@ -6514,7 +6462,7 @@ static int iwl3945_mac_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 
 	mutex_lock(&priv->mutex);
 
-	iwl3945_scan_cancel_timeout(priv, 100);
+	iwl_scan_cancel_timeout(priv, 100);
 
 	switch (cmd) {
 	case  SET_KEY:
@@ -6664,7 +6612,7 @@ static void iwl3945_mac_reset_tsf(struct ieee80211_hw *hw)
 	 * clear RXON_FILTER_ASSOC_MSK bit
 	*/
 	if (priv->iw_mode != NL80211_IFTYPE_AP) {
-		iwl3945_scan_cancel_timeout(priv, 100);
+		iwl_scan_cancel_timeout(priv, 100);
 		priv->staging39_rxon.filter_flags &= ~RXON_FILTER_ASSOC_MSK;
 		iwl3945_commit_rxon(priv);
 	}
@@ -6823,7 +6771,7 @@ static ssize_t store_flags(struct device *d,
 	mutex_lock(&priv->mutex);
 	if (le32_to_cpu(priv->staging39_rxon.flags) != flags) {
 		/* Cancel any currently running scans... */
-		if (iwl3945_scan_cancel_timeout(priv, 100))
+		if (iwl_scan_cancel_timeout(priv, 100))
 			IWL_WARN(priv, "Could not cancel scan.\n");
 		else {
 			IWL_DEBUG_INFO("Committing rxon.flags = 0x%04X\n",
@@ -6858,7 +6806,7 @@ static ssize_t store_filter_flags(struct device *d,
 	mutex_lock(&priv->mutex);
 	if (le32_to_cpu(priv->staging39_rxon.filter_flags) != filter_flags) {
 		/* Cancel any currently running scans... */
-		if (iwl3945_scan_cancel_timeout(priv, 100))
+		if (iwl_scan_cancel_timeout(priv, 100))
 			IWL_WARN(priv, "Could not cancel scan.\n");
 		else {
 			IWL_DEBUG_INFO("Committing rxon.filter_flags = "
-- 
1.5.4.3

