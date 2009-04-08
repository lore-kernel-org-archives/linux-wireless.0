Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:61547 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761305AbZDHSVS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Apr 2009 14:21:18 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Abhijeet Kolekar <abhijeet.kolekar@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 13/18] iwl3945: use iwl_mac_remove_interface from iwlwifi
Date: Wed,  8 Apr 2009 11:26:47 -0700
Message-Id: <1239215212-1657-14-git-send-email-reinette.chatre@intel.com> (sfid-20090408_202135_482575_02D1B1FA)
In-Reply-To: <1239215212-1657-13-git-send-email-reinette.chatre@intel.com>
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
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Abhijeet Kolekar <abhijeet.kolekar@intel.com>

3945 can now use iwl_mac_remove_interface from iwlwifi

Signed-off-by: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c      |   24 ------------------------
 drivers/net/wireless/iwlwifi/iwl-core.c     |   25 +++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-core.h     |    2 ++
 drivers/net/wireless/iwlwifi/iwl3945-base.c |   25 +------------------------
 4 files changed, 28 insertions(+), 48 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index ffa9348..facd348 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -2332,30 +2332,6 @@ static int iwl_mac_config_interface(struct ieee80211_hw *hw,
 	return 0;
 }
 
-static void iwl_mac_remove_interface(struct ieee80211_hw *hw,
-				     struct ieee80211_if_init_conf *conf)
-{
-	struct iwl_priv *priv = hw->priv;
-
-	IWL_DEBUG_MAC80211(priv, "enter\n");
-
-	mutex_lock(&priv->mutex);
-
-	if (iwl_is_ready_rf(priv)) {
-		iwl_scan_cancel_timeout(priv, 100);
-		priv->staging_rxon.filter_flags &= ~RXON_FILTER_ASSOC_MSK;
-		iwlcore_commit_rxon(priv);
-	}
-	if (priv->vif == conf->vif) {
-		priv->vif = NULL;
-		memset(priv->bssid, 0, ETH_ALEN);
-	}
-	mutex_unlock(&priv->mutex);
-
-	IWL_DEBUG_MAC80211(priv, "leave\n");
-
-}
-
 static void iwl_mac_update_tkip_key(struct ieee80211_hw *hw,
 			struct ieee80211_key_conf *keyconf, const u8 *addr,
 			u32 iv32, u16 *phase1key)
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 0a2536d..042452f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -2417,6 +2417,31 @@ int iwl_mac_add_interface(struct ieee80211_hw *hw,
 }
 EXPORT_SYMBOL(iwl_mac_add_interface);
 
+void iwl_mac_remove_interface(struct ieee80211_hw *hw,
+				     struct ieee80211_if_init_conf *conf)
+{
+	struct iwl_priv *priv = hw->priv;
+
+	IWL_DEBUG_MAC80211(priv, "enter\n");
+
+	mutex_lock(&priv->mutex);
+
+	if (iwl_is_ready_rf(priv)) {
+		iwl_scan_cancel_timeout(priv, 100);
+		priv->staging_rxon.filter_flags &= ~RXON_FILTER_ASSOC_MSK;
+		iwlcore_commit_rxon(priv);
+	}
+	if (priv->vif == conf->vif) {
+		priv->vif = NULL;
+		memset(priv->bssid, 0, ETH_ALEN);
+	}
+	mutex_unlock(&priv->mutex);
+
+	IWL_DEBUG_MAC80211(priv, "leave\n");
+
+}
+EXPORT_SYMBOL(iwl_mac_remove_interface);
+
 #ifdef CONFIG_PM
 
 int iwl_pci_suspend(struct pci_dev *pdev, pm_message_t state)
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 7df5440..5dc3306 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -276,6 +276,8 @@ int iwl_commit_rxon(struct iwl_priv *priv);
 int iwl_set_mode(struct iwl_priv *priv, int mode);
 int iwl_mac_add_interface(struct ieee80211_hw *hw,
 				 struct ieee80211_if_init_conf *conf);
+void iwl_mac_remove_interface(struct ieee80211_hw *hw,
+				 struct ieee80211_if_init_conf *conf);
 
 /*****************************************************
  * RX handlers.
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 9d9582f..896694b 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -3640,29 +3640,6 @@ static int iwl3945_mac_config_interface(struct ieee80211_hw *hw,
 	return 0;
 }
 
-static void iwl3945_mac_remove_interface(struct ieee80211_hw *hw,
-				     struct ieee80211_if_init_conf *conf)
-{
-	struct iwl_priv *priv = hw->priv;
-
-	IWL_DEBUG_MAC80211(priv, "enter\n");
-
-	mutex_lock(&priv->mutex);
-
-	if (iwl_is_ready_rf(priv)) {
-		iwl_scan_cancel_timeout(priv, 100);
-		priv->staging_rxon.filter_flags &= ~RXON_FILTER_ASSOC_MSK;
-		iwlcore_commit_rxon(priv);
-	}
-	if (priv->vif == conf->vif) {
-		priv->vif = NULL;
-		memset(priv->bssid, 0, ETH_ALEN);
-	}
-	mutex_unlock(&priv->mutex);
-
-	IWL_DEBUG_MAC80211(priv, "leave\n");
-}
-
 static int iwl3945_mac_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 			       struct ieee80211_vif *vif,
 			       struct ieee80211_sta *sta,
@@ -4338,7 +4315,7 @@ static struct ieee80211_ops iwl3945_hw_ops = {
 	.start = iwl3945_mac_start,
 	.stop = iwl3945_mac_stop,
 	.add_interface = iwl_mac_add_interface,
-	.remove_interface = iwl3945_mac_remove_interface,
+	.remove_interface = iwl_mac_remove_interface,
 	.config = iwl3945_mac_config,
 	.config_interface = iwl3945_mac_config_interface,
 	.configure_filter = iwl_configure_filter,
-- 
1.5.6.3

