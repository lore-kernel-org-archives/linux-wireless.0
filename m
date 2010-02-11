Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:24445 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756758Ab0BKSmN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Feb 2010 13:42:13 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 02/12] iwlwifi: multiple force reset mode
Date: Thu, 11 Feb 2010 10:41:55 -0800
Message-Id: <1265913725-4279-3-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1265913725-4279-1-git-send-email-reinette.chatre@intel.com>
References: <1265913725-4279-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

Provide the function to perform different type of uCode reset/reload operation.
When uCode detect error and can not fix itself, this iwl_force_reset()
function allow driver to perform the necessary reset/reload functions and help
to bring uCode back to normal operation state.

Currently only 2 type of force reset are available:
 - reset radio
 - reload firmware

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-core.c |   44 +++++++++++++++++++++++++++++-
 drivers/net/wireless/iwlwifi/iwl-core.h |    2 +-
 drivers/net/wireless/iwlwifi/iwl-dev.h  |    9 +++++-
 drivers/net/wireless/iwlwifi/iwl-rx.c   |    2 +-
 drivers/net/wireless/iwlwifi/iwl-scan.c |   10 -------
 5 files changed, 52 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index d390eef..500ced4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -3334,7 +3334,7 @@ int iwl_dump_fh(struct iwl_priv *priv, char **buf, bool display)
 }
 EXPORT_SYMBOL(iwl_dump_fh);
 
-void iwl_force_rf_reset(struct iwl_priv *priv)
+static void iwl_force_rf_reset(struct iwl_priv *priv)
 {
 	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
 		return;
@@ -3356,7 +3356,47 @@ void iwl_force_rf_reset(struct iwl_priv *priv)
 	iwl_internal_short_hw_scan(priv);
 	return;
 }
-EXPORT_SYMBOL(iwl_force_rf_reset);
+
+#define IWL_DELAY_NEXT_FORCE_RESET (HZ*3)
+
+int iwl_force_reset(struct iwl_priv *priv, int mode)
+{
+	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
+		return -EINVAL;
+
+	if (priv->last_force_reset_jiffies &&
+	    time_after(priv->last_force_reset_jiffies +
+		       IWL_DELAY_NEXT_FORCE_RESET, jiffies)) {
+		IWL_DEBUG_INFO(priv, "force reset rejected\n");
+		return -EAGAIN;
+	}
+
+	IWL_DEBUG_INFO(priv, "perform force reset (%d)\n", mode);
+
+	switch (mode) {
+	case IWL_RF_RESET:
+		iwl_force_rf_reset(priv);
+		break;
+	case IWL_FW_RESET:
+		IWL_ERR(priv, "On demand firmware reload\n");
+		/* Set the FW error flag -- cleared on iwl_down */
+		set_bit(STATUS_FW_ERROR, &priv->status);
+		wake_up_interruptible(&priv->wait_command_queue);
+		/*
+		 * Keep the restart process from trying to send host
+		 * commands by clearing the INIT status bit
+		 */
+		clear_bit(STATUS_READY, &priv->status);
+		queue_work(priv->workqueue, &priv->restart);
+		break;
+	default:
+		IWL_DEBUG_INFO(priv, "invalid reset request.\n");
+		return -EINVAL;
+	}
+	priv->last_force_reset_jiffies = jiffies;
+
+	return 0;
+}
 
 #ifdef CONFIG_PM
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 8f0c564..df55879 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -501,7 +501,7 @@ int iwl_scan_cancel(struct iwl_priv *priv);
 int iwl_scan_cancel_timeout(struct iwl_priv *priv, unsigned long ms);
 int iwl_mac_hw_scan(struct ieee80211_hw *hw, struct cfg80211_scan_request *req);
 int iwl_internal_short_hw_scan(struct iwl_priv *priv);
-void iwl_force_rf_reset(struct iwl_priv *priv);
+int iwl_force_reset(struct iwl_priv *priv, int mode);
 u16 iwl_fill_probe_req(struct iwl_priv *priv, struct ieee80211_mgmt *frame,
 		       const u8 *ie, int ie_len, int left);
 void iwl_setup_rx_scan_handlers(struct iwl_priv *priv);
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 55dc5a8..9f1d302 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -1035,6 +1035,11 @@ struct iwl_event_log {
 #define IWL_MAX_PLCP_ERR_LONG_THRESHOLD_DEF	(100)
 #define IWL_MAX_PLCP_ERR_THRESHOLD_MAX	(255)
 
+enum iwl_reset {
+	IWL_RF_RESET = 0,
+	IWL_FW_RESET,
+};
+
 struct iwl_priv {
 
 	/* ieee device used by generic ieee processing code */
@@ -1066,6 +1071,9 @@ struct iwl_priv {
 	/* storing the jiffies when the plcp error rate is received */
 	unsigned long plcp_jiffies;
 
+	/* force reset */
+	unsigned long last_force_reset_jiffies;
+
 	/* we allocate array of iwl4965_channel_info for NIC's valid channels.
 	 *    Access via channel # using indirect index array */
 	struct iwl_channel_info *channel_info;	/* channel info array */
@@ -1087,7 +1095,6 @@ struct iwl_priv {
 	unsigned long scan_start;
 	unsigned long scan_pass_start;
 	unsigned long scan_start_tsf;
-	unsigned long last_internal_scan_jiffies;
 	void *scan;
 	int scan_bands;
 	struct cfg80211_scan_request *scan_request;
diff --git a/drivers/net/wireless/iwlwifi/iwl-rx.c b/drivers/net/wireless/iwlwifi/iwl-rx.c
index 5df6638..909d9c9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-rx.c
@@ -689,7 +689,7 @@ void iwl_rx_statistics(struct iwl_priv *priv,
 			 * Reset the RF radio due to the high plcp
 			 * error rate
 			 */
-			iwl_force_rf_reset(priv);
+			iwl_force_reset(priv, IWL_RF_RESET);
 		}
 	}
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-scan.c b/drivers/net/wireless/iwlwifi/iwl-scan.c
index f786a40..5014774 100644
--- a/drivers/net/wireless/iwlwifi/iwl-scan.c
+++ b/drivers/net/wireless/iwlwifi/iwl-scan.c
@@ -250,8 +250,6 @@ static void iwl_rx_scan_complete_notif(struct iwl_priv *priv,
 
 	if (!priv->is_internal_short_scan)
 		priv->next_scan_jiffies = 0;
-	else
-		priv->last_internal_scan_jiffies = jiffies;
 
 	IWL_DEBUG_INFO(priv, "Setting scan to off\n");
 
@@ -551,8 +549,6 @@ EXPORT_SYMBOL(iwl_mac_hw_scan);
  * internal short scan, this function should only been called while associated.
  * It will reset and tune the radio to prevent possible RF related problem
  */
-#define IWL_DELAY_NEXT_INTERNAL_SCAN (HZ*1)
-
 int iwl_internal_short_hw_scan(struct iwl_priv *priv)
 {
 	int ret = 0;
@@ -572,12 +568,6 @@ int iwl_internal_short_hw_scan(struct iwl_priv *priv)
 		ret = -EAGAIN;
 		goto out;
 	}
-	if (priv->last_internal_scan_jiffies &&
-	    time_after(priv->last_internal_scan_jiffies +
-		       IWL_DELAY_NEXT_INTERNAL_SCAN, jiffies)) {
-		IWL_DEBUG_SCAN(priv, "internal scan rejected\n");
-		goto out;
-	}
 
 	priv->scan_bands = 0;
 	if (priv->band == IEEE80211_BAND_5GHZ)
-- 
1.6.3.3

