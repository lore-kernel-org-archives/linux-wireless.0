Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:34843 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761778AbZDHSVT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Apr 2009 14:21:19 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Abhijeet Kolekar <abhijeet.kolekar@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 18/18] iwl3945: use iwl_mac_reset_tsf from iwlwifi
Date: Wed,  8 Apr 2009 11:26:52 -0700
Message-Id: <1239215212-1657-19-git-send-email-reinette.chatre@intel.com> (sfid-20090408_202137_379802_5402069B)
In-Reply-To: <1239215212-1657-18-git-send-email-reinette.chatre@intel.com>
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
 <1239215212-1657-18-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Abhijeet Kolekar <abhijeet.kolekar@intel.com>

3945 can now use iwl_mac_reset_tsf from iwlwifi.

Signed-off-by: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c      |   75 ---------------------------
 drivers/net/wireless/iwlwifi/iwl-core.c     |   75 +++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-core.h     |    1 +
 drivers/net/wireless/iwlwifi/iwl3945-base.c |   60 +---------------------
 4 files changed, 77 insertions(+), 134 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 1d458ae..248b3db 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -2235,81 +2235,6 @@ static int iwl_mac_get_stats(struct ieee80211_hw *hw,
 	return 0;
 }
 
-static void iwl_mac_reset_tsf(struct ieee80211_hw *hw)
-{
-	struct iwl_priv *priv = hw->priv;
-	unsigned long flags;
-
-	mutex_lock(&priv->mutex);
-	IWL_DEBUG_MAC80211(priv, "enter\n");
-
-	spin_lock_irqsave(&priv->lock, flags);
-	memset(&priv->current_ht_config, 0, sizeof(struct iwl_ht_info));
-	spin_unlock_irqrestore(&priv->lock, flags);
-
-	iwl_reset_qos(priv);
-
-	spin_lock_irqsave(&priv->lock, flags);
-	priv->assoc_id = 0;
-	priv->assoc_capability = 0;
-	priv->assoc_station_added = 0;
-
-	/* new association get rid of ibss beacon skb */
-	if (priv->ibss_beacon)
-		dev_kfree_skb(priv->ibss_beacon);
-
-	priv->ibss_beacon = NULL;
-
-	priv->beacon_int = priv->hw->conf.beacon_int;
-	priv->timestamp = 0;
-	if ((priv->iw_mode == NL80211_IFTYPE_STATION))
-		priv->beacon_int = 0;
-
-	spin_unlock_irqrestore(&priv->lock, flags);
-
-	if (!iwl_is_ready_rf(priv)) {
-		IWL_DEBUG_MAC80211(priv, "leave - not ready\n");
-		mutex_unlock(&priv->mutex);
-		return;
-	}
-
-	/* we are restarting association process
-	 * clear RXON_FILTER_ASSOC_MSK bit
-	 */
-	if (priv->iw_mode != NL80211_IFTYPE_AP) {
-		iwl_scan_cancel_timeout(priv, 100);
-		priv->staging_rxon.filter_flags &= ~RXON_FILTER_ASSOC_MSK;
-		iwlcore_commit_rxon(priv);
-	}
-
-	iwl_power_update_mode(priv, 0);
-
-	/* Per mac80211.h: This is only used in IBSS mode... */
-	if (priv->iw_mode != NL80211_IFTYPE_ADHOC) {
-
-		/* switch to CAM during association period.
-		 * the ucode will block any association/authentication
-		 * frome during assiciation period if it can not hear
-		 * the AP because of PM. the timer enable PM back is
-		 * association do not complete
-		 */
-		if (priv->hw->conf.channel->flags & (IEEE80211_CHAN_PASSIVE_SCAN |
-						     IEEE80211_CHAN_RADAR))
-				iwl_power_disable_management(priv, 3000);
-
-		IWL_DEBUG_MAC80211(priv, "leave - not in IBSS\n");
-		mutex_unlock(&priv->mutex);
-		return;
-	}
-
-	iwl_set_rate(priv);
-
-	mutex_unlock(&priv->mutex);
-
-	IWL_DEBUG_MAC80211(priv, "leave\n");
-}
-
-
 /*****************************************************************************
  *
  * sysfs attributes
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 3a7b69d..1b66272 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -2714,6 +2714,81 @@ int iwl_mac_get_tx_stats(struct ieee80211_hw *hw,
 }
 EXPORT_SYMBOL(iwl_mac_get_tx_stats);
 
+void iwl_mac_reset_tsf(struct ieee80211_hw *hw)
+{
+	struct iwl_priv *priv = hw->priv;
+	unsigned long flags;
+
+	mutex_lock(&priv->mutex);
+	IWL_DEBUG_MAC80211(priv, "enter\n");
+
+	spin_lock_irqsave(&priv->lock, flags);
+	memset(&priv->current_ht_config, 0, sizeof(struct iwl_ht_info));
+	spin_unlock_irqrestore(&priv->lock, flags);
+
+	iwl_reset_qos(priv);
+
+	spin_lock_irqsave(&priv->lock, flags);
+	priv->assoc_id = 0;
+	priv->assoc_capability = 0;
+	priv->assoc_station_added = 0;
+
+	/* new association get rid of ibss beacon skb */
+	if (priv->ibss_beacon)
+		dev_kfree_skb(priv->ibss_beacon);
+
+	priv->ibss_beacon = NULL;
+
+	priv->beacon_int = priv->hw->conf.beacon_int;
+	priv->timestamp = 0;
+	if ((priv->iw_mode == NL80211_IFTYPE_STATION))
+		priv->beacon_int = 0;
+
+	spin_unlock_irqrestore(&priv->lock, flags);
+
+	if (!iwl_is_ready_rf(priv)) {
+		IWL_DEBUG_MAC80211(priv, "leave - not ready\n");
+		mutex_unlock(&priv->mutex);
+		return;
+	}
+
+	/* we are restarting association process
+	 * clear RXON_FILTER_ASSOC_MSK bit
+	 */
+	if (priv->iw_mode != NL80211_IFTYPE_AP) {
+		iwl_scan_cancel_timeout(priv, 100);
+		priv->staging_rxon.filter_flags &= ~RXON_FILTER_ASSOC_MSK;
+		iwlcore_commit_rxon(priv);
+	}
+
+	iwl_power_update_mode(priv, 0);
+
+	/* Per mac80211.h: This is only used in IBSS mode... */
+	if (priv->iw_mode != NL80211_IFTYPE_ADHOC) {
+
+		/* switch to CAM during association period.
+		 * the ucode will block any association/authentication
+		 * frome during assiciation period if it can not hear
+		 * the AP because of PM. the timer enable PM back is
+		 * association do not complete
+		 */
+		if (priv->hw->conf.channel->flags &
+		    (IEEE80211_CHAN_PASSIVE_SCAN | IEEE80211_CHAN_RADAR))
+				iwl_power_disable_management(priv, 3000);
+
+		IWL_DEBUG_MAC80211(priv, "leave - not in IBSS\n");
+		mutex_unlock(&priv->mutex);
+		return;
+	}
+
+	iwl_set_rate(priv);
+
+	mutex_unlock(&priv->mutex);
+
+	IWL_DEBUG_MAC80211(priv, "leave\n");
+}
+EXPORT_SYMBOL(iwl_mac_reset_tsf);
+
 #ifdef CONFIG_PM
 
 int iwl_pci_suspend(struct pci_dev *pdev, pm_message_t state)
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 7e0d0ed..df90c26 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -286,6 +286,7 @@ int iwl_mac_config_interface(struct ieee80211_hw *hw,
 				struct ieee80211_if_conf *conf);
 int iwl_mac_get_tx_stats(struct ieee80211_hw *hw,
 			 struct ieee80211_tx_queue_stats *stats);
+void iwl_mac_reset_tsf(struct ieee80211_hw *hw);
 
 /*****************************************************
  * RX handlers.
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index be762f5..5fd4aff 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -3494,64 +3494,6 @@ static int iwl3945_mac_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 	return ret;
 }
 
-static void iwl3945_mac_reset_tsf(struct ieee80211_hw *hw)
-{
-	struct iwl_priv *priv = hw->priv;
-	unsigned long flags;
-
-	mutex_lock(&priv->mutex);
-	IWL_DEBUG_MAC80211(priv, "enter\n");
-
-	iwl_reset_qos(priv);
-
-	spin_lock_irqsave(&priv->lock, flags);
-	priv->assoc_id = 0;
-	priv->assoc_capability = 0;
-
-	/* new association get rid of ibss beacon skb */
-	if (priv->ibss_beacon)
-		dev_kfree_skb(priv->ibss_beacon);
-
-	priv->ibss_beacon = NULL;
-
-	priv->beacon_int = priv->hw->conf.beacon_int;
-	priv->timestamp = 0;
-	if ((priv->iw_mode == NL80211_IFTYPE_STATION))
-		priv->beacon_int = 0;
-
-	spin_unlock_irqrestore(&priv->lock, flags);
-
-	if (!iwl_is_ready_rf(priv)) {
-		IWL_DEBUG_MAC80211(priv, "leave - not ready\n");
-		mutex_unlock(&priv->mutex);
-		return;
-	}
-
-	/* we are restarting association process
-	 * clear RXON_FILTER_ASSOC_MSK bit
-	*/
-	if (priv->iw_mode != NL80211_IFTYPE_AP) {
-		iwl_scan_cancel_timeout(priv, 100);
-		priv->staging_rxon.filter_flags &= ~RXON_FILTER_ASSOC_MSK;
-		iwlcore_commit_rxon(priv);
-	}
-
-	/* Per mac80211.h: This is only used in IBSS mode... */
-	if (priv->iw_mode != NL80211_IFTYPE_ADHOC) {
-
-		IWL_DEBUG_MAC80211(priv, "leave - not in IBSS\n");
-		mutex_unlock(&priv->mutex);
-		return;
-	}
-
-	iwl_set_rate(priv);
-
-	mutex_unlock(&priv->mutex);
-
-	IWL_DEBUG_MAC80211(priv, "leave\n");
-
-}
-
 /*****************************************************************************
  *
  * sysfs attributes
@@ -4083,7 +4025,7 @@ static struct ieee80211_ops iwl3945_hw_ops = {
 	.set_key = iwl3945_mac_set_key,
 	.get_tx_stats = iwl_mac_get_tx_stats,
 	.conf_tx = iwl_mac_conf_tx,
-	.reset_tsf = iwl3945_mac_reset_tsf,
+	.reset_tsf = iwl_mac_reset_tsf,
 	.bss_info_changed = iwl_bss_info_changed,
 	.hw_scan = iwl_mac_hw_scan
 };
-- 
1.5.6.3

