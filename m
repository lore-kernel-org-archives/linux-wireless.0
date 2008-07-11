Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:40615 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752986AbYGKD4v (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Jul 2008 23:56:51 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 04/14] iwlwifi: remove post associate work
Date: Fri, 11 Jul 2008 11:53:32 +0800
Message-Id: <1215748422-12672-5-git-send-email-yi.zhu@intel.com> (sfid-20080711_055655_116521_C21EB9B1)
In-Reply-To: <1215748422-12672-4-git-send-email-yi.zhu@intel.com>
References: <1215748422-12672-1-git-send-email-yi.zhu@intel.com>
 <1215748422-12672-2-git-send-email-yi.zhu@intel.com>
 <1215748422-12672-3-git-send-email-yi.zhu@intel.com>
 <1215748422-12672-4-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

This patch removes post associate work. It wasn't used.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-dev.h      |    1 -
 drivers/net/wireless/iwlwifi/iwl4965-base.c |   18 ------------------
 2 files changed, 0 insertions(+), 19 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 0177a1d..81a57cb 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -1065,7 +1065,6 @@ struct iwl_priv {
 	struct delayed_work init_alive_start;
 	struct delayed_work alive_start;
 	struct delayed_work scan_check;
-	struct delayed_work post_associate;
 	/* TX Power */
 	s8 tx_power_user_lmt;
 	s8 tx_power_channel_lmt;
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index aea00d5..95ec61a 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -2520,18 +2520,6 @@ static void iwl4965_post_associate(struct iwl_priv *priv)
 	priv->next_scan_jiffies = jiffies + IWL_DELAY_NEXT_SCAN;
 }
 
-
-static void iwl4965_bg_post_associate(struct work_struct *data)
-{
-	struct iwl_priv *priv = container_of(data, struct iwl_priv,
-					     post_associate.work);
-
-	mutex_lock(&priv->mutex);
-	iwl4965_post_associate(priv);
-	mutex_unlock(&priv->mutex);
-
-}
-
 static int iwl4965_mac_config(struct ieee80211_hw *hw, struct ieee80211_conf *conf);
 
 static void iwl_bg_scan_completed(struct work_struct *work)
@@ -2662,7 +2650,6 @@ static void iwl4965_mac_stop(struct ieee80211_hw *hw)
 		 */
 		mutex_lock(&priv->mutex);
 		iwl_scan_cancel_timeout(priv, 100);
-		cancel_delayed_work(&priv->post_associate);
 		mutex_unlock(&priv->mutex);
 	}
 
@@ -3051,7 +3038,6 @@ static void iwl4965_mac_remove_interface(struct ieee80211_hw *hw,
 
 	if (iwl_is_ready_rf(priv)) {
 		iwl_scan_cancel_timeout(priv, 100);
-		cancel_delayed_work(&priv->post_associate);
 		priv->staging_rxon.filter_flags &= ~RXON_FILTER_ASSOC_MSK;
 		iwl4965_commit_rxon(priv);
 	}
@@ -3416,8 +3402,6 @@ static void iwl4965_mac_reset_tsf(struct ieee80211_hw *hw)
 
 	iwl_reset_qos(priv);
 
-	cancel_delayed_work(&priv->post_associate);
-
 	spin_lock_irqsave(&priv->lock, flags);
 	priv->assoc_id = 0;
 	priv->assoc_capability = 0;
@@ -4019,7 +4003,6 @@ static void iwl_setup_deferred_work(struct iwl_priv *priv)
 	INIT_WORK(&priv->beacon_update, iwl4965_bg_beacon_update);
 	INIT_WORK(&priv->set_monitor, iwl4965_bg_set_monitor);
 	INIT_WORK(&priv->run_time_calib_work, iwl_bg_run_time_calib_work);
-	INIT_DELAYED_WORK(&priv->post_associate, iwl4965_bg_post_associate);
 	INIT_DELAYED_WORK(&priv->init_alive_start, iwl_bg_init_alive_start);
 	INIT_DELAYED_WORK(&priv->alive_start, iwl_bg_alive_start);
 
@@ -4046,7 +4029,6 @@ static void iwl_cancel_deferred_work(struct iwl_priv *priv)
 	cancel_delayed_work_sync(&priv->init_alive_start);
 	cancel_delayed_work(&priv->scan_check);
 	cancel_delayed_work(&priv->alive_start);
-	cancel_delayed_work(&priv->post_associate);
 	cancel_work_sync(&priv->beacon_update);
 	del_timer_sync(&priv->statistics_periodic);
 }
-- 
1.5.3.6

