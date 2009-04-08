Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:2471 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756188AbZDHSVF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Apr 2009 14:21:05 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Abhijeet Kolekar <abhijeet.kolekar@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 02/18] iwl3945: use iwl_mac_beacon_update
Date: Wed,  8 Apr 2009 11:26:36 -0700
Message-Id: <1239215212-1657-3-git-send-email-reinette.chatre@intel.com> (sfid-20090408_202117_285069_9CB6CC94)
In-Reply-To: <1239215212-1657-2-git-send-email-reinette.chatre@intel.com>
References: <1239215212-1657-1-git-send-email-reinette.chatre@intel.com>
 <1239215212-1657-2-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Abhijeet Kolekar <abhijeet.kolekar@intel.com>

3945 can use iwl_mac_beacon_update.

Signed-off-by: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c      |   43 -----------------------
 drivers/net/wireless/iwlwifi/iwl-core.c     |   41 ++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-core.h     |    1 +
 drivers/net/wireless/iwlwifi/iwl3945-base.c |   49 +-------------------------
 4 files changed, 44 insertions(+), 90 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 2492ec0..ea4f65e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -1443,10 +1443,6 @@ static int iwl_read_ucode(struct iwl_priv *priv)
 	return ret;
 }
 
-/* temporary */
-static int iwl_mac_beacon_update(struct ieee80211_hw *hw,
-				 struct sk_buff *skb);
-
 /**
  * iwl_alive_start - called after REPLY_ALIVE notification received
  *                   from protocol/runtime uCode (initialization uCode's
@@ -2657,45 +2653,6 @@ static void iwl_mac_reset_tsf(struct ieee80211_hw *hw)
 	IWL_DEBUG_MAC80211(priv, "leave\n");
 }
 
-static int iwl_mac_beacon_update(struct ieee80211_hw *hw, struct sk_buff *skb)
-{
-	struct iwl_priv *priv = hw->priv;
-	unsigned long flags;
-	__le64 timestamp;
-
-	IWL_DEBUG_MAC80211(priv, "enter\n");
-
-	if (!iwl_is_ready_rf(priv)) {
-		IWL_DEBUG_MAC80211(priv, "leave - RF not ready\n");
-		return -EIO;
-	}
-
-	if (priv->iw_mode != NL80211_IFTYPE_ADHOC) {
-		IWL_DEBUG_MAC80211(priv, "leave - not IBSS\n");
-		return -EIO;
-	}
-
-	spin_lock_irqsave(&priv->lock, flags);
-
-	if (priv->ibss_beacon)
-		dev_kfree_skb(priv->ibss_beacon);
-
-	priv->ibss_beacon = skb;
-
-	priv->assoc_id = 0;
-	timestamp = ((struct ieee80211_mgmt *)skb->data)->u.beacon.timestamp;
-	priv->timestamp = le64_to_cpu(timestamp);
-
-	IWL_DEBUG_MAC80211(priv, "leave\n");
-	spin_unlock_irqrestore(&priv->lock, flags);
-
-	iwl_reset_qos(priv);
-
-	priv->cfg->ops->lib->post_associate(priv);
-
-
-	return 0;
-}
 
 /*****************************************************************************
  *
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index a351a38..cb78186 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -2292,6 +2292,47 @@ void iwl_bss_info_changed(struct ieee80211_hw *hw,
 }
 EXPORT_SYMBOL(iwl_bss_info_changed);
 
+int iwl_mac_beacon_update(struct ieee80211_hw *hw, struct sk_buff *skb)
+{
+	struct iwl_priv *priv = hw->priv;
+	unsigned long flags;
+	__le64 timestamp;
+
+	IWL_DEBUG_MAC80211(priv, "enter\n");
+
+	if (!iwl_is_ready_rf(priv)) {
+		IWL_DEBUG_MAC80211(priv, "leave - RF not ready\n");
+		return -EIO;
+	}
+
+	if (priv->iw_mode != NL80211_IFTYPE_ADHOC) {
+		IWL_DEBUG_MAC80211(priv, "leave - not IBSS\n");
+		return -EIO;
+	}
+
+	spin_lock_irqsave(&priv->lock, flags);
+
+	if (priv->ibss_beacon)
+		dev_kfree_skb(priv->ibss_beacon);
+
+	priv->ibss_beacon = skb;
+
+	priv->assoc_id = 0;
+	timestamp = ((struct ieee80211_mgmt *)skb->data)->u.beacon.timestamp;
+	priv->timestamp = le64_to_cpu(timestamp);
+
+	IWL_DEBUG_MAC80211(priv, "leave\n");
+	spin_unlock_irqrestore(&priv->lock, flags);
+
+	iwl_reset_qos(priv);
+
+	priv->cfg->ops->lib->post_associate(priv);
+
+
+	return 0;
+}
+EXPORT_SYMBOL(iwl_mac_beacon_update);
+
 #ifdef CONFIG_PM
 
 int iwl_pci_suspend(struct pci_dev *pdev, pm_message_t state)
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 4ad8465..0447385 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -258,6 +258,7 @@ void iwl_bss_info_changed(struct ieee80211_hw *hw,
 				     struct ieee80211_vif *vif,
 				     struct ieee80211_bss_conf *bss_conf,
 				     u32 changes);
+int iwl_mac_beacon_update(struct ieee80211_hw *hw, struct sk_buff *skb);
 
 /*****************************************************
  * RX handlers.
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 22cd171..4ac272b 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -2792,11 +2792,6 @@ static void iwl3945_init_alive_start(struct iwl_priv *priv)
 	queue_work(priv->workqueue, &priv->restart);
 }
 
-
-/* temporary */
-static int iwl3945_mac_beacon_update(struct ieee80211_hw *hw,
-				     struct sk_buff *skb);
-
 /**
  * iwl3945_alive_start - called after REPLY_ALIVE notification received
  *                   from protocol/runtime uCode (initialization uCode's
@@ -2904,7 +2899,7 @@ static void iwl3945_alive_start(struct iwl_priv *priv)
 		struct sk_buff *beacon = ieee80211_beacon_get(priv->hw,
 								priv->vif);
 		if (beacon)
-			iwl3945_mac_beacon_update(priv->hw, beacon);
+			iwl_mac_beacon_update(priv->hw, beacon);
 	}
 
 	return;
@@ -3837,7 +3832,7 @@ static int iwl3945_mac_config_interface(struct ieee80211_hw *hw,
 		if (!beacon)
 			return -ENOMEM;
 		mutex_lock(&priv->mutex);
-		rc = iwl3945_mac_beacon_update(hw, beacon);
+		rc = iwl_mac_beacon_update(hw, beacon);
 		mutex_unlock(&priv->mutex);
 		if (rc)
 			return rc;
@@ -4089,46 +4084,6 @@ static void iwl3945_mac_reset_tsf(struct ieee80211_hw *hw)
 
 }
 
-static int iwl3945_mac_beacon_update(struct ieee80211_hw *hw, struct sk_buff *skb)
-{
-	struct iwl_priv *priv = hw->priv;
-	unsigned long flags;
-	__le64 timestamp;
-
-	IWL_DEBUG_MAC80211(priv, "enter\n");
-
-	if (!iwl_is_ready_rf(priv)) {
-		IWL_DEBUG_MAC80211(priv, "leave - RF not ready\n");
-		return -EIO;
-	}
-
-	if (priv->iw_mode != NL80211_IFTYPE_ADHOC) {
-		IWL_DEBUG_MAC80211(priv, "leave - not IBSS\n");
-		return -EIO;
-	}
-
-	spin_lock_irqsave(&priv->lock, flags);
-
-	if (priv->ibss_beacon)
-		dev_kfree_skb(priv->ibss_beacon);
-
-	priv->ibss_beacon = skb;
-
-	priv->assoc_id = 0;
-	timestamp = ((struct ieee80211_mgmt *)skb->data)->u.beacon.timestamp;
-	priv->timestamp = le64_to_cpu(timestamp);
-
-	IWL_DEBUG_MAC80211(priv, "leave\n");
-	spin_unlock_irqrestore(&priv->lock, flags);
-
-	iwl_reset_qos(priv);
-
-	priv->cfg->ops->lib->post_associate(priv);
-
-
-	return 0;
-}
-
 /*****************************************************************************
  *
  * sysfs attributes
-- 
1.5.6.3

