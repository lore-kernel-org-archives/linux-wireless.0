Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:38104 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757303AbZDHSVS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Apr 2009 14:21:18 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Abhijeet Kolekar <abhijeet.kolekar@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 16/18] iwl3945: use iwl_mac_config_interface from iwlwifi
Date: Wed,  8 Apr 2009 11:26:50 -0700
Message-Id: <1239215212-1657-17-git-send-email-reinette.chatre@intel.com> (sfid-20090408_202138_974454_AEB39F28)
In-Reply-To: <1239215212-1657-16-git-send-email-reinette.chatre@intel.com>
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
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Abhijeet Kolekar <abhijeet.kolekar@intel.com>

3945 can now use iwl_mac_config_interface from iwlwifi.

Signed-off-by: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c      |  100 --------------------------
 drivers/net/wireless/iwlwifi/iwl-core.c     |  100 ++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-core.h     |    3 +
 drivers/net/wireless/iwlwifi/iwl3945-base.c |  102 +--------------------------
 4 files changed, 104 insertions(+), 201 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 049f741..8d4e9a9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -2099,106 +2099,6 @@ void iwl_config_ap(struct iwl_priv *priv)
 	 * clear sta table, add BCAST sta... */
 }
 
-
-static int iwl_mac_config_interface(struct ieee80211_hw *hw,
-					struct ieee80211_vif *vif,
-				    struct ieee80211_if_conf *conf)
-{
-	struct iwl_priv *priv = hw->priv;
-	int rc;
-
-	if (conf == NULL)
-		return -EIO;
-
-	if (priv->vif != vif) {
-		IWL_DEBUG_MAC80211(priv, "leave - priv->vif != vif\n");
-		return 0;
-	}
-
-	if (priv->iw_mode == NL80211_IFTYPE_ADHOC &&
-	    conf->changed & IEEE80211_IFCC_BEACON) {
-		struct sk_buff *beacon = ieee80211_beacon_get(hw, vif);
-		if (!beacon)
-			return -ENOMEM;
-		mutex_lock(&priv->mutex);
-		rc = iwl_mac_beacon_update(hw, beacon);
-		mutex_unlock(&priv->mutex);
-		if (rc)
-			return rc;
-	}
-
-	if (!iwl_is_alive(priv))
-		return -EAGAIN;
-
-	mutex_lock(&priv->mutex);
-
-	if (conf->bssid)
-		IWL_DEBUG_MAC80211(priv, "bssid: %pM\n", conf->bssid);
-
-/*
- * very dubious code was here; the probe filtering flag is never set:
- *
-	if (unlikely(test_bit(STATUS_SCANNING, &priv->status)) &&
-	    !(priv->hw->flags & IEEE80211_HW_NO_PROBE_FILTERING)) {
- */
-
-	if (priv->iw_mode == NL80211_IFTYPE_AP) {
-		if (!conf->bssid) {
-			conf->bssid = priv->mac_addr;
-			memcpy(priv->bssid, priv->mac_addr, ETH_ALEN);
-			IWL_DEBUG_MAC80211(priv, "bssid was set to: %pM\n",
-					   conf->bssid);
-		}
-		if (priv->ibss_beacon)
-			dev_kfree_skb(priv->ibss_beacon);
-
-		priv->ibss_beacon = ieee80211_beacon_get(hw, vif);
-	}
-
-	if (iwl_is_rfkill(priv))
-		goto done;
-
-	if (conf->bssid && !is_zero_ether_addr(conf->bssid) &&
-	    !is_multicast_ether_addr(conf->bssid)) {
-		/* If there is currently a HW scan going on in the background
-		 * then we need to cancel it else the RXON below will fail. */
-		if (iwl_scan_cancel_timeout(priv, 100)) {
-			IWL_WARN(priv, "Aborted scan still in progress "
-				    "after 100ms\n");
-			IWL_DEBUG_MAC80211(priv, "leaving - scan abort failed.\n");
-			mutex_unlock(&priv->mutex);
-			return -EAGAIN;
-		}
-		memcpy(priv->staging_rxon.bssid_addr, conf->bssid, ETH_ALEN);
-
-		/* TODO: Audit driver for usage of these members and see
-		 * if mac80211 deprecates them (priv->bssid looks like it
-		 * shouldn't be there, but I haven't scanned the IBSS code
-		 * to verify) - jpk */
-		memcpy(priv->bssid, conf->bssid, ETH_ALEN);
-
-		if (priv->iw_mode == NL80211_IFTYPE_AP)
-			iwlcore_config_ap(priv);
-		else {
-			rc = iwlcore_commit_rxon(priv);
-			if ((priv->iw_mode == NL80211_IFTYPE_STATION) && rc)
-				iwl_rxon_add_station(
-					priv, priv->active_rxon.bssid_addr, 1);
-		}
-
-	} else {
-		iwl_scan_cancel_timeout(priv, 100);
-		priv->staging_rxon.filter_flags &= ~RXON_FILTER_ASSOC_MSK;
-		iwlcore_commit_rxon(priv);
-	}
-
- done:
-	IWL_DEBUG_MAC80211(priv, "leave\n");
-	mutex_unlock(&priv->mutex);
-
-	return 0;
-}
-
 static void iwl_mac_update_tkip_key(struct ieee80211_hw *hw,
 			struct ieee80211_key_conf *keyconf, const u8 *addr,
 			u32 iv32, u16 *phase1key)
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 5876fe5..3059231 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -2578,6 +2578,106 @@ out:
 }
 EXPORT_SYMBOL(iwl_mac_config);
 
+int iwl_mac_config_interface(struct ieee80211_hw *hw,
+					struct ieee80211_vif *vif,
+				    struct ieee80211_if_conf *conf)
+{
+	struct iwl_priv *priv = hw->priv;
+	int rc;
+
+	if (conf == NULL)
+		return -EIO;
+
+	if (priv->vif != vif) {
+		IWL_DEBUG_MAC80211(priv, "leave - priv->vif != vif\n");
+		return 0;
+	}
+
+	if (priv->iw_mode == NL80211_IFTYPE_ADHOC &&
+	    conf->changed & IEEE80211_IFCC_BEACON) {
+		struct sk_buff *beacon = ieee80211_beacon_get(hw, vif);
+		if (!beacon)
+			return -ENOMEM;
+		mutex_lock(&priv->mutex);
+		rc = iwl_mac_beacon_update(hw, beacon);
+		mutex_unlock(&priv->mutex);
+		if (rc)
+			return rc;
+	}
+
+	if (!iwl_is_alive(priv))
+		return -EAGAIN;
+
+	mutex_lock(&priv->mutex);
+
+	if (conf->bssid)
+		IWL_DEBUG_MAC80211(priv, "bssid: %pM\n", conf->bssid);
+
+/*
+ * very dubious code was here; the probe filtering flag is never set:
+ *
+	if (unlikely(test_bit(STATUS_SCANNING, &priv->status)) &&
+	    !(priv->hw->flags & IEEE80211_HW_NO_PROBE_FILTERING)) {
+ */
+
+	if (priv->iw_mode == NL80211_IFTYPE_AP) {
+		if (!conf->bssid) {
+			conf->bssid = priv->mac_addr;
+			memcpy(priv->bssid, priv->mac_addr, ETH_ALEN);
+			IWL_DEBUG_MAC80211(priv, "bssid was set to: %pM\n",
+					   conf->bssid);
+		}
+		if (priv->ibss_beacon)
+			dev_kfree_skb(priv->ibss_beacon);
+
+		priv->ibss_beacon = ieee80211_beacon_get(hw, vif);
+	}
+
+	if (iwl_is_rfkill(priv))
+		goto done;
+
+	if (conf->bssid && !is_zero_ether_addr(conf->bssid) &&
+	    !is_multicast_ether_addr(conf->bssid)) {
+		/* If there is currently a HW scan going on in the background
+		 * then we need to cancel it else the RXON below will fail. */
+		if (iwl_scan_cancel_timeout(priv, 100)) {
+			IWL_WARN(priv, "Aborted scan still in progress "
+				    "after 100ms\n");
+			IWL_DEBUG_MAC80211(priv, "leaving - scan abort failed.\n");
+			mutex_unlock(&priv->mutex);
+			return -EAGAIN;
+		}
+		memcpy(priv->staging_rxon.bssid_addr, conf->bssid, ETH_ALEN);
+
+		/* TODO: Audit driver for usage of these members and see
+		 * if mac80211 deprecates them (priv->bssid looks like it
+		 * shouldn't be there, but I haven't scanned the IBSS code
+		 * to verify) - jpk */
+		memcpy(priv->bssid, conf->bssid, ETH_ALEN);
+
+		if (priv->iw_mode == NL80211_IFTYPE_AP)
+			iwlcore_config_ap(priv);
+		else {
+			rc = iwlcore_commit_rxon(priv);
+			if ((priv->iw_mode == NL80211_IFTYPE_STATION) && rc)
+				iwl_rxon_add_station(
+					priv, priv->active_rxon.bssid_addr, 1);
+		}
+
+	} else {
+		iwl_scan_cancel_timeout(priv, 100);
+		priv->staging_rxon.filter_flags &= ~RXON_FILTER_ASSOC_MSK;
+		iwlcore_commit_rxon(priv);
+	}
+
+ done:
+	IWL_DEBUG_MAC80211(priv, "leave\n");
+	mutex_unlock(&priv->mutex);
+
+	return 0;
+}
+EXPORT_SYMBOL(iwl_mac_config_interface);
+
 #ifdef CONFIG_PM
 
 int iwl_pci_suspend(struct pci_dev *pdev, pm_message_t state)
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index af559b0..92a42c8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -281,6 +281,9 @@ void iwl_mac_remove_interface(struct ieee80211_hw *hw,
 				 struct ieee80211_if_init_conf *conf);
 int iwl_mac_config(struct ieee80211_hw *hw, u32 changed);
 void iwl_config_ap(struct iwl_priv *priv);
+int iwl_mac_config_interface(struct ieee80211_hw *hw,
+				struct ieee80211_vif *vif,
+				struct ieee80211_if_conf *conf);
 
 /*****************************************************
  * RX handlers.
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 313320a..b2b2ebc 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -3436,106 +3436,6 @@ void iwl3945_config_ap(struct iwl_priv *priv)
 	 * clear sta table, add BCAST sta... */
 }
 
-static int iwl3945_mac_config_interface(struct ieee80211_hw *hw,
-					struct ieee80211_vif *vif,
-					struct ieee80211_if_conf *conf)
-{
-	struct iwl_priv *priv = hw->priv;
-	int rc;
-
-	if (conf == NULL)
-		return -EIO;
-
-	if (priv->vif != vif) {
-		IWL_DEBUG_MAC80211(priv, "leave - priv->vif != vif\n");
-		return 0;
-	}
-
-	/* handle this temporarily here */
-	if (priv->iw_mode == NL80211_IFTYPE_ADHOC &&
-	    conf->changed & IEEE80211_IFCC_BEACON) {
-		struct sk_buff *beacon = ieee80211_beacon_get(hw, vif);
-		if (!beacon)
-			return -ENOMEM;
-		mutex_lock(&priv->mutex);
-		rc = iwl_mac_beacon_update(hw, beacon);
-		mutex_unlock(&priv->mutex);
-		if (rc)
-			return rc;
-	}
-
-	if (!iwl_is_alive(priv))
-		return -EAGAIN;
-
-	mutex_lock(&priv->mutex);
-
-	if (conf->bssid)
-		IWL_DEBUG_MAC80211(priv, "bssid: %pM\n", conf->bssid);
-
-/*
- * very dubious code was here; the probe filtering flag is never set:
- *
-	if (unlikely(test_bit(STATUS_SCANNING, &priv->status)) &&
-	    !(priv->hw->flags & IEEE80211_HW_NO_PROBE_FILTERING)) {
- */
-
-	if (priv->iw_mode == NL80211_IFTYPE_AP) {
-		if (!conf->bssid) {
-			conf->bssid = priv->mac_addr;
-			memcpy(priv->bssid, priv->mac_addr, ETH_ALEN);
-			IWL_DEBUG_MAC80211(priv, "bssid was set to: %pM\n",
-					   conf->bssid);
-		}
-		if (priv->ibss_beacon)
-			dev_kfree_skb(priv->ibss_beacon);
-
-		priv->ibss_beacon = ieee80211_beacon_get(hw, vif);
-	}
-
-	if (iwl_is_rfkill(priv))
-		goto done;
-
-	if (conf->bssid && !is_zero_ether_addr(conf->bssid) &&
-	    !is_multicast_ether_addr(conf->bssid)) {
-		/* If there is currently a HW scan going on in the background
-		 * then we need to cancel it else the RXON below will fail. */
-		if (iwl_scan_cancel_timeout(priv, 100)) {
-			IWL_WARN(priv, "Aborted scan still in progress "
-				    "after 100ms\n");
-			IWL_DEBUG_MAC80211(priv, "leaving:scan abort failed\n");
-			mutex_unlock(&priv->mutex);
-			return -EAGAIN;
-		}
-		memcpy(priv->staging_rxon.bssid_addr, conf->bssid, ETH_ALEN);
-
-		/* TODO: Audit driver for usage of these members and see
-		 * if mac80211 deprecates them (priv->bssid looks like it
-		 * shouldn't be there, but I haven't scanned the IBSS code
-		 * to verify) - jpk */
-		memcpy(priv->bssid, conf->bssid, ETH_ALEN);
-
-		if (priv->iw_mode == NL80211_IFTYPE_AP)
-			iwlcore_config_ap(priv);
-		else {
-			rc = iwlcore_commit_rxon(priv);
-			if ((priv->iw_mode == NL80211_IFTYPE_STATION) && rc)
-				priv->cfg->ops->smgmt->add_station(priv,
-					priv->active_rxon.bssid_addr, 1, 0, NULL);
-		}
-
-	} else {
-		iwl_scan_cancel_timeout(priv, 100);
-		priv->staging_rxon.filter_flags &= ~RXON_FILTER_ASSOC_MSK;
-		iwlcore_commit_rxon(priv);
-	}
-
- done:
-	IWL_DEBUG_MAC80211(priv, "leave\n");
-	mutex_unlock(&priv->mutex);
-
-	return 0;
-}
-
 static int iwl3945_mac_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 			       struct ieee80211_vif *vif,
 			       struct ieee80211_sta *sta,
@@ -4213,7 +4113,7 @@ static struct ieee80211_ops iwl3945_hw_ops = {
 	.add_interface = iwl_mac_add_interface,
 	.remove_interface = iwl_mac_remove_interface,
 	.config = iwl_mac_config,
-	.config_interface = iwl3945_mac_config_interface,
+	.config_interface = iwl_mac_config_interface,
 	.configure_filter = iwl_configure_filter,
 	.set_key = iwl3945_mac_set_key,
 	.get_tx_stats = iwl3945_mac_get_tx_stats,
-- 
1.5.6.3

