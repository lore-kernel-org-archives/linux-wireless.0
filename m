Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:43814 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754316AbYICDbI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Sep 2008 23:31:08 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Abhijeet Kolekar <abhijeet.kolekar@intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 10/39] iwl3945: removed bg_post_associate work
Date: Wed,  3 Sep 2008 11:26:30 +0800
Message-Id: <1220412419-15404-11-git-send-email-yi.zhu@intel.com> (sfid-20080903_053115_442638_7924DCED)
In-Reply-To: <1220412419-15404-10-git-send-email-yi.zhu@intel.com>
References: <1220412419-15404-1-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-2-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-3-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-4-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-5-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-6-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-7-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-8-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-9-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-10-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Abhijeet Kolekar <abhijeet.kolekar@intel.com>

This patch removes bg_post_associate work. A direct call
iwl3945_post_associate is made to avoid the waiting by
userspace programs.

Signed-off-by: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945.h     |    1 -
 drivers/net/wireless/iwlwifi/iwl3945-base.c |   18 +-----------------
 2 files changed, 1 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.h b/drivers/net/wireless/iwlwifi/iwl-3945.h
index 4dd3f0d..9bbbc9d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.h
@@ -894,7 +894,6 @@ struct iwl3945_priv {
 	struct delayed_work thermal_periodic;
 	struct delayed_work gather_stats;
 	struct delayed_work scan_check;
-	struct delayed_work post_associate;
 
 #define IWL_DEFAULT_TX_POWER 0x0F
 	s8 user_txpower_limit;
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 85581b6..70dfe9d 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -6415,16 +6415,6 @@ static void iwl3945_post_associate(struct iwl3945_priv *priv)
 	priv->next_scan_jiffies = jiffies + IWL_DELAY_NEXT_SCAN;
 }
 
-static void iwl3945_bg_post_associate(struct work_struct *data)
-{
-	struct iwl3945_priv *priv = container_of(data, struct iwl3945_priv,
-					     post_associate.work);
-
-	mutex_lock(&priv->mutex);
-	iwl3945_post_associate(priv);
-	mutex_unlock(&priv->mutex);
-}
-
 static void iwl3945_bg_abort_scan(struct work_struct *work)
 {
 	struct iwl3945_priv *priv = container_of(work, struct iwl3945_priv, abort_scan);
@@ -6570,7 +6560,6 @@ static void iwl3945_mac_stop(struct ieee80211_hw *hw)
 		 */
 		mutex_lock(&priv->mutex);
 		iwl3945_scan_cancel_timeout(priv, 100);
-		cancel_delayed_work(&priv->post_associate);
 		mutex_unlock(&priv->mutex);
 	}
 
@@ -6936,7 +6925,6 @@ static void iwl3945_mac_remove_interface(struct ieee80211_hw *hw,
 
 	if (iwl3945_is_ready_rf(priv)) {
 		iwl3945_scan_cancel_timeout(priv, 100);
-		cancel_delayed_work(&priv->post_associate);
 		priv->staging_rxon.filter_flags &= ~RXON_FILTER_ASSOC_MSK;
 		iwl3945_commit_rxon(priv);
 	}
@@ -7240,8 +7228,6 @@ static void iwl3945_mac_reset_tsf(struct ieee80211_hw *hw)
 
 	iwl3945_reset_qos(priv);
 
-	cancel_delayed_work(&priv->post_associate);
-
 	spin_lock_irqsave(&priv->lock, flags);
 	priv->assoc_id = 0;
 	priv->assoc_capability = 0;
@@ -7326,7 +7312,7 @@ static int iwl3945_mac_beacon_update(struct ieee80211_hw *hw, struct sk_buff *sk
 
 	iwl3945_reset_qos(priv);
 
-	queue_work(priv->workqueue, &priv->post_associate.work);
+	iwl3945_post_associate(priv);
 
 	mutex_unlock(&priv->mutex);
 
@@ -7825,7 +7811,6 @@ static void iwl3945_setup_deferred_work(struct iwl3945_priv *priv)
 	INIT_WORK(&priv->rf_kill, iwl3945_bg_rf_kill);
 	INIT_WORK(&priv->beacon_update, iwl3945_bg_beacon_update);
 	INIT_WORK(&priv->set_monitor, iwl3945_bg_set_monitor);
-	INIT_DELAYED_WORK(&priv->post_associate, iwl3945_bg_post_associate);
 	INIT_DELAYED_WORK(&priv->init_alive_start, iwl3945_bg_init_alive_start);
 	INIT_DELAYED_WORK(&priv->alive_start, iwl3945_bg_alive_start);
 	INIT_DELAYED_WORK(&priv->scan_check, iwl3945_bg_scan_check);
@@ -7843,7 +7828,6 @@ static void iwl3945_cancel_deferred_work(struct iwl3945_priv *priv)
 	cancel_delayed_work_sync(&priv->init_alive_start);
 	cancel_delayed_work(&priv->scan_check);
 	cancel_delayed_work(&priv->alive_start);
-	cancel_delayed_work(&priv->post_associate);
 	cancel_work_sync(&priv->beacon_update);
 }
 
-- 
1.5.3.6

