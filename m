Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:24824 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758277AbZDHSVR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Apr 2009 14:21:17 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Abhijeet Kolekar <abhijeet.kolekar@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 17/18] iwl3945: use iwl_mac_get_tx_stats from iwlwifi
Date: Wed,  8 Apr 2009 11:26:51 -0700
Message-Id: <1239215212-1657-18-git-send-email-reinette.chatre@intel.com> (sfid-20090408_202128_700261_FF6ED7E2)
In-Reply-To: <1239215212-1657-17-git-send-email-reinette.chatre@intel.com>
References: <1239215212-1657-1-git-send-email-reinette.chatre@intel.com>
 <1239215212-1657-2-git-send-email-reinette.chatre@intel.com>
 <1239215212-1657-3-git-send-email-reinette.chatre@intel.com>
 <1239215212-1657-4-git-send-email-reinette.chatre@intel.com>
 <1239215212-1657-5-git-send-email-reinette.chatre@intel.com>
 <1239215212-1657-6-git-send-email-reinette.chatre@intel.com>
 <1239215212-1657-7-git-send-email-reinette.chatre@intel.com>
 <1239215212-1657-8-git-send-email-reinette.chatre@intel.com>
 <1239215212-1657-9-git-send-email-reinette.chatre@intel.com>
 <1239215212-1657-10-git-send-email-reinette.chatre@intel.com>
 <1239215212-1657-11-git-send-email-reinette.chatre@intel.com>
 <1239215212-1657-12-git-send-email-reinette.chatre@intel.com>
 <1239215212-1657-13-git-send-email-reinette.chatre@intel.com>
 <1239215212-1657-14-git-send-email-reinette.chatre@intel.com>
 <1239215212-1657-15-git-send-email-reinette.chatre@intel.com>
 <1239215212-1657-16-git-send-email-reinette.chatre@intel.com>
 <1239215212-1657-17-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Abhijeet Kolekar <abhijeet.kolekar@intel.com>

3945 can now use iwl_mac_get_tx_stats from iwlwifi.

Signed-off-by: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c      |   35 -------------------------
 drivers/net/wireless/iwlwifi/iwl-core.c     |   36 ++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-core.h     |    2 +
 drivers/net/wireless/iwlwifi/iwl3945-base.c |   37 +--------------------------
 4 files changed, 39 insertions(+), 71 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 8d4e9a9..1d458ae 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -2223,41 +2223,6 @@ static int iwl_mac_ampdu_action(struct ieee80211_hw *hw,
 	return 0;
 }
 
-static int iwl_mac_get_tx_stats(struct ieee80211_hw *hw,
-				struct ieee80211_tx_queue_stats *stats)
-{
-	struct iwl_priv *priv = hw->priv;
-	int i, avail;
-	struct iwl_tx_queue *txq;
-	struct iwl_queue *q;
-	unsigned long flags;
-
-	IWL_DEBUG_MAC80211(priv, "enter\n");
-
-	if (!iwl_is_ready_rf(priv)) {
-		IWL_DEBUG_MAC80211(priv, "leave - RF not ready\n");
-		return -EIO;
-	}
-
-	spin_lock_irqsave(&priv->lock, flags);
-
-	for (i = 0; i < AC_NUM; i++) {
-		txq = &priv->txq[i];
-		q = &txq->q;
-		avail = iwl_queue_space(q);
-
-		stats[i].len = q->n_window - avail;
-		stats[i].limit = q->n_window - q->high_mark;
-		stats[i].count = q->n_window;
-
-	}
-	spin_unlock_irqrestore(&priv->lock, flags);
-
-	IWL_DEBUG_MAC80211(priv, "leave\n");
-
-	return 0;
-}
-
 static int iwl_mac_get_stats(struct ieee80211_hw *hw,
 			     struct ieee80211_low_level_stats *stats)
 {
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 3059231..3a7b69d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -2678,6 +2678,42 @@ int iwl_mac_config_interface(struct ieee80211_hw *hw,
 }
 EXPORT_SYMBOL(iwl_mac_config_interface);
 
+int iwl_mac_get_tx_stats(struct ieee80211_hw *hw,
+			 struct ieee80211_tx_queue_stats *stats)
+{
+	struct iwl_priv *priv = hw->priv;
+	int i, avail;
+	struct iwl_tx_queue *txq;
+	struct iwl_queue *q;
+	unsigned long flags;
+
+	IWL_DEBUG_MAC80211(priv, "enter\n");
+
+	if (!iwl_is_ready_rf(priv)) {
+		IWL_DEBUG_MAC80211(priv, "leave - RF not ready\n");
+		return -EIO;
+	}
+
+	spin_lock_irqsave(&priv->lock, flags);
+
+	for (i = 0; i < AC_NUM; i++) {
+		txq = &priv->txq[i];
+		q = &txq->q;
+		avail = iwl_queue_space(q);
+
+		stats[i].len = q->n_window - avail;
+		stats[i].limit = q->n_window - q->high_mark;
+		stats[i].count = q->n_window;
+
+	}
+	spin_unlock_irqrestore(&priv->lock, flags);
+
+	IWL_DEBUG_MAC80211(priv, "leave\n");
+
+	return 0;
+}
+EXPORT_SYMBOL(iwl_mac_get_tx_stats);
+
 #ifdef CONFIG_PM
 
 int iwl_pci_suspend(struct pci_dev *pdev, pm_message_t state)
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 92a42c8..7e0d0ed 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -284,6 +284,8 @@ void iwl_config_ap(struct iwl_priv *priv);
 int iwl_mac_config_interface(struct ieee80211_hw *hw,
 				struct ieee80211_vif *vif,
 				struct ieee80211_if_conf *conf);
+int iwl_mac_get_tx_stats(struct ieee80211_hw *hw,
+			 struct ieee80211_tx_queue_stats *stats);
 
 /*****************************************************
  * RX handlers.
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index b2b2ebc..be762f5 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -3494,41 +3494,6 @@ static int iwl3945_mac_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 	return ret;
 }
 
-static int iwl3945_mac_get_tx_stats(struct ieee80211_hw *hw,
-				struct ieee80211_tx_queue_stats *stats)
-{
-	struct iwl_priv *priv = hw->priv;
-	int i, avail;
-	struct iwl_tx_queue *txq;
-	struct iwl_queue *q;
-	unsigned long flags;
-
-	IWL_DEBUG_MAC80211(priv, "enter\n");
-
-	if (!iwl_is_ready_rf(priv)) {
-		IWL_DEBUG_MAC80211(priv, "leave - RF not ready\n");
-		return -EIO;
-	}
-
-	spin_lock_irqsave(&priv->lock, flags);
-
-	for (i = 0; i < AC_NUM; i++) {
-		txq = &priv->txq[i];
-		q = &txq->q;
-		avail = iwl_queue_space(q);
-
-		stats[i].len = q->n_window - avail;
-		stats[i].limit = q->n_window - q->high_mark;
-		stats[i].count = q->n_window;
-
-	}
-	spin_unlock_irqrestore(&priv->lock, flags);
-
-	IWL_DEBUG_MAC80211(priv, "leave\n");
-
-	return 0;
-}
-
 static void iwl3945_mac_reset_tsf(struct ieee80211_hw *hw)
 {
 	struct iwl_priv *priv = hw->priv;
@@ -4116,7 +4081,7 @@ static struct ieee80211_ops iwl3945_hw_ops = {
 	.config_interface = iwl_mac_config_interface,
 	.configure_filter = iwl_configure_filter,
 	.set_key = iwl3945_mac_set_key,
-	.get_tx_stats = iwl3945_mac_get_tx_stats,
+	.get_tx_stats = iwl_mac_get_tx_stats,
 	.conf_tx = iwl_mac_conf_tx,
 	.reset_tsf = iwl3945_mac_reset_tsf,
 	.bss_info_changed = iwl_bss_info_changed,
-- 
1.5.6.3

