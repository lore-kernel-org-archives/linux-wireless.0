Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:34843 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761140AbZDHSVR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Apr 2009 14:21:17 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Abhijeet Kolekar <abhijeet.kolekar@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 12/18] iwl3945: use iwl_mac_add_interface from iwlwifi
Date: Wed,  8 Apr 2009 11:26:46 -0700
Message-Id: <1239215212-1657-13-git-send-email-reinette.chatre@intel.com> (sfid-20090408_202134_136317_D23EB0E0)
In-Reply-To: <1239215212-1657-12-git-send-email-reinette.chatre@intel.com>
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
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Abhijeet Kolekar <abhijeet.kolekar@intel.com>

Signed-off-by: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c      |   36 --------------------------
 drivers/net/wireless/iwlwifi/iwl-core.c     |   37 +++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-core.h     |    2 +
 drivers/net/wireless/iwlwifi/iwl3945-base.c |   37 +--------------------------
 4 files changed, 40 insertions(+), 72 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index f262444..ffa9348 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -2036,42 +2036,6 @@ static int iwl_mac_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 	return NETDEV_TX_OK;
 }
 
-static int iwl_mac_add_interface(struct ieee80211_hw *hw,
-				 struct ieee80211_if_init_conf *conf)
-{
-	struct iwl_priv *priv = hw->priv;
-	unsigned long flags;
-
-	IWL_DEBUG_MAC80211(priv, "enter: type %d\n", conf->type);
-
-	if (priv->vif) {
-		IWL_DEBUG_MAC80211(priv, "leave - vif != NULL\n");
-		return -EOPNOTSUPP;
-	}
-
-	spin_lock_irqsave(&priv->lock, flags);
-	priv->vif = conf->vif;
-	priv->iw_mode = conf->type;
-
-	spin_unlock_irqrestore(&priv->lock, flags);
-
-	mutex_lock(&priv->mutex);
-
-	if (conf->mac_addr) {
-		IWL_DEBUG_MAC80211(priv, "Set %pM\n", conf->mac_addr);
-		memcpy(priv->mac_addr, conf->mac_addr, ETH_ALEN);
-	}
-
-	if (iwl_set_mode(priv, conf->type) == -EAGAIN)
-		/* we are not ready, will run again when ready */
-		set_bit(STATUS_MODE_PENDING, &priv->status);
-
-	mutex_unlock(&priv->mutex);
-
-	IWL_DEBUG_MAC80211(priv, "leave\n");
-	return 0;
-}
-
 /**
  * iwl_mac_config - mac80211 config callback
  *
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 237e794..0a2536d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -2380,6 +2380,43 @@ int iwl_set_mode(struct iwl_priv *priv, int mode)
 }
 EXPORT_SYMBOL(iwl_set_mode);
 
+int iwl_mac_add_interface(struct ieee80211_hw *hw,
+				 struct ieee80211_if_init_conf *conf)
+{
+	struct iwl_priv *priv = hw->priv;
+	unsigned long flags;
+
+	IWL_DEBUG_MAC80211(priv, "enter: type %d\n", conf->type);
+
+	if (priv->vif) {
+		IWL_DEBUG_MAC80211(priv, "leave - vif != NULL\n");
+		return -EOPNOTSUPP;
+	}
+
+	spin_lock_irqsave(&priv->lock, flags);
+	priv->vif = conf->vif;
+	priv->iw_mode = conf->type;
+
+	spin_unlock_irqrestore(&priv->lock, flags);
+
+	mutex_lock(&priv->mutex);
+
+	if (conf->mac_addr) {
+		IWL_DEBUG_MAC80211(priv, "Set %pM\n", conf->mac_addr);
+		memcpy(priv->mac_addr, conf->mac_addr, ETH_ALEN);
+	}
+
+	if (iwl_set_mode(priv, conf->type) == -EAGAIN)
+		/* we are not ready, will run again when ready */
+		set_bit(STATUS_MODE_PENDING, &priv->status);
+
+	mutex_unlock(&priv->mutex);
+
+	IWL_DEBUG_MAC80211(priv, "leave\n");
+	return 0;
+}
+EXPORT_SYMBOL(iwl_mac_add_interface);
+
 #ifdef CONFIG_PM
 
 int iwl_pci_suspend(struct pci_dev *pdev, pm_message_t state)
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 49df47a..7df5440 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -274,6 +274,8 @@ void iwl_bss_info_changed(struct ieee80211_hw *hw,
 int iwl_mac_beacon_update(struct ieee80211_hw *hw, struct sk_buff *skb);
 int iwl_commit_rxon(struct iwl_priv *priv);
 int iwl_set_mode(struct iwl_priv *priv, int mode);
+int iwl_mac_add_interface(struct ieee80211_hw *hw,
+				 struct ieee80211_if_init_conf *conf);
 
 /*****************************************************
  * RX handlers.
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 82bb736..9d9582f 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -3380,41 +3380,6 @@ static int iwl3945_mac_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 	return NETDEV_TX_OK;
 }
 
-static int iwl3945_mac_add_interface(struct ieee80211_hw *hw,
-				 struct ieee80211_if_init_conf *conf)
-{
-	struct iwl_priv *priv = hw->priv;
-	unsigned long flags;
-
-	IWL_DEBUG_MAC80211(priv, "enter: type %d\n", conf->type);
-
-	if (priv->vif) {
-		IWL_DEBUG_MAC80211(priv, "leave - vif != NULL\n");
-		return -EOPNOTSUPP;
-	}
-
-	spin_lock_irqsave(&priv->lock, flags);
-	priv->vif = conf->vif;
-	priv->iw_mode = conf->type;
-
-	spin_unlock_irqrestore(&priv->lock, flags);
-
-	mutex_lock(&priv->mutex);
-
-	if (conf->mac_addr) {
-		IWL_DEBUG_MAC80211(priv, "Set: %pM\n", conf->mac_addr);
-		memcpy(priv->mac_addr, conf->mac_addr, ETH_ALEN);
-	}
-
-	if (iwl_set_mode(priv, conf->type) == -EAGAIN)
-		set_bit(STATUS_MODE_PENDING, &priv->status);
-
-	mutex_unlock(&priv->mutex);
-
-	IWL_DEBUG_MAC80211(priv, "leave\n");
-	return 0;
-}
-
 /**
  * iwl3945_mac_config - mac80211 config callback
  *
@@ -4372,7 +4337,7 @@ static struct ieee80211_ops iwl3945_hw_ops = {
 	.tx = iwl3945_mac_tx,
 	.start = iwl3945_mac_start,
 	.stop = iwl3945_mac_stop,
-	.add_interface = iwl3945_mac_add_interface,
+	.add_interface = iwl_mac_add_interface,
 	.remove_interface = iwl3945_mac_remove_interface,
 	.config = iwl3945_mac_config,
 	.config_interface = iwl3945_mac_config_interface,
-- 
1.5.6.3

