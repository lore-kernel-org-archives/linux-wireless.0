Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:2848 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751679AbYJFIMD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Oct 2008 04:12:03 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 6/7] iwlwifi: remove STATUS_CONF_PENDING in scanning
Date: Mon,  6 Oct 2008 16:05:32 +0800
Message-Id: <1223280333-4383-7-git-send-email-yi.zhu@intel.com> (sfid-20081006_101208_941754_3EA7C316)
In-Reply-To: <1223280333-4383-6-git-send-email-yi.zhu@intel.com>
References: <1223280333-4383-1-git-send-email-yi.zhu@intel.com>
 <1223280333-4383-2-git-send-email-yi.zhu@intel.com>
 <1223280333-4383-3-git-send-email-yi.zhu@intel.com>
 <1223280333-4383-4-git-send-email-yi.zhu@intel.com>
 <1223280333-4383-5-git-send-email-yi.zhu@intel.com>
 <1223280333-4383-6-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

This patch removes STATUS_CONF_PENDING usage that called from
iwl4965_mac_config internally after scan completed.

It's called anyway from the mac80211 ieee80211_scan_completed():

	if (local->hw_scanning) {
		local->hw_scanning = false;
		if (ieee80211_hw_config(local))
		...
	}

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c  |   28 ----------------------------
 drivers/net/wireless/iwlwifi/iwl-core.h |    3 +--
 drivers/net/wireless/iwlwifi/iwl-scan.c |   23 +++++++++++++++++++++--
 3 files changed, 22 insertions(+), 32 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 204abab..24a1aeb 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -2569,30 +2569,6 @@ static void iwl4965_post_associate(struct iwl_priv *priv)
 
 }
 
-static int iwl4965_mac_config(struct ieee80211_hw *hw, struct ieee80211_conf *conf);
-
-static void iwl_bg_scan_completed(struct work_struct *work)
-{
-	struct iwl_priv *priv =
-	    container_of(work, struct iwl_priv, scan_completed);
-
-	IWL_DEBUG_SCAN("SCAN complete scan\n");
-
-	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
-		return;
-
-	if (test_bit(STATUS_CONF_PENDING, &priv->status))
-		iwl4965_mac_config(priv->hw, ieee80211_get_hw_conf(priv->hw));
-
-	ieee80211_scan_completed(priv->hw);
-
-	/* Since setting the TXPOWER may have been deferred while
-	 * performing the scan, fire one off */
-	mutex_lock(&priv->mutex);
-	iwl_set_tx_power(priv, priv->tx_power_user_lmt, true);
-	mutex_unlock(&priv->mutex);
-}
-
 /*****************************************************************************
  *
  * mac80211 entry point functions
@@ -2812,7 +2788,6 @@ static int iwl4965_mac_config(struct ieee80211_hw *hw, struct ieee80211_conf *co
 	if (unlikely(!priv->cfg->mod_params->disable_hw_scan &&
 		     test_bit(STATUS_SCANNING, &priv->status))) {
 		IWL_DEBUG_MAC80211("leave - scanning\n");
-		set_bit(STATUS_CONF_PENDING, &priv->status);
 		mutex_unlock(&priv->mutex);
 		return 0;
 	}
@@ -2898,7 +2873,6 @@ static int iwl4965_mac_config(struct ieee80211_hw *hw, struct ieee80211_conf *co
 	IWL_DEBUG_MAC80211("leave\n");
 
 out:
-	clear_bit(STATUS_CONF_PENDING, &priv->status);
 	mutex_unlock(&priv->mutex);
 	return ret;
 }
@@ -4117,8 +4091,6 @@ static void iwl_setup_deferred_work(struct iwl_priv *priv)
 	INIT_DELAYED_WORK(&priv->init_alive_start, iwl_bg_init_alive_start);
 	INIT_DELAYED_WORK(&priv->alive_start, iwl_bg_alive_start);
 
-	/* FIXME : remove when resolved PENDING */
-	INIT_WORK(&priv->scan_completed, iwl_bg_scan_completed);
 	iwl_setup_scan_deferred_work(priv);
 	iwl_setup_power_deferred_work(priv);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 55a4b58..288b6a8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -333,8 +333,7 @@ void iwl_dump_nic_event_log(struct iwl_priv *priv);
 #define STATUS_SCAN_HW		15
 #define STATUS_POWER_PMI	16
 #define STATUS_FW_ERROR		17
-#define STATUS_CONF_PENDING	18
-#define STATUS_MODE_PENDING	19
+#define STATUS_MODE_PENDING	18
 
 
 static inline int iwl_is_ready(struct iwl_priv *priv)
diff --git a/drivers/net/wireless/iwlwifi/iwl-scan.c b/drivers/net/wireless/iwlwifi/iwl-scan.c
index 639904a..3b0bee3 100644
--- a/drivers/net/wireless/iwlwifi/iwl-scan.c
+++ b/drivers/net/wireless/iwlwifi/iwl-scan.c
@@ -916,10 +916,29 @@ static void iwl_bg_abort_scan(struct work_struct *work)
 	mutex_unlock(&priv->mutex);
 }
 
+static void iwl_bg_scan_completed(struct work_struct *work)
+{
+	struct iwl_priv *priv =
+	    container_of(work, struct iwl_priv, scan_completed);
+
+	IWL_DEBUG_SCAN("SCAN complete scan\n");
+
+	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
+		return;
+
+	ieee80211_scan_completed(priv->hw);
+
+	/* Since setting the TXPOWER may have been deferred while
+	 * performing the scan, fire one off */
+	mutex_lock(&priv->mutex);
+	iwl_set_tx_power(priv, priv->tx_power_user_lmt, true);
+	mutex_unlock(&priv->mutex);
+}
+
+
 void iwl_setup_scan_deferred_work(struct iwl_priv *priv)
 {
-	/*  FIXME: move here when resolved PENDING
-	 *  INIT_WORK(&priv->scan_completed, iwl_bg_scan_completed); */
+	INIT_WORK(&priv->scan_completed, iwl_bg_scan_completed);
 	INIT_WORK(&priv->request_scan, iwl_bg_request_scan);
 	INIT_WORK(&priv->abort_scan, iwl_bg_abort_scan);
 	INIT_DELAYED_WORK(&priv->scan_check, iwl_bg_scan_check);
-- 
1.5.3.6

