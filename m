Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:35013 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754371Ab0A2TyK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Jan 2010 14:54:10 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 03/12] iwlwifi: fix locking in iwl_mac_add_interface
Date: Fri, 29 Jan 2010 11:53:53 -0800
Message-Id: <1264794842-8046-4-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1264794842-8046-1-git-send-email-reinette.chatre@intel.com>
References: <1264794842-8046-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The corresponding iwl_mac_remove_interface only
acquires the mutex, leading me to believe that
the spinlock is not necessary. However, this
doesn't actually acquire the mutex around the
vif pointer check and assignment, fix that.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-core.c |   15 +++++++--------
 1 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 1cfabd6..02bf17e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -2631,23 +2631,21 @@ int iwl_mac_add_interface(struct ieee80211_hw *hw,
 				 struct ieee80211_vif *vif)
 {
 	struct iwl_priv *priv = hw->priv;
-	unsigned long flags;
+	int err = 0;
 
 	IWL_DEBUG_MAC80211(priv, "enter: type %d\n", vif->type);
 
+	mutex_lock(&priv->mutex);
+
 	if (priv->vif) {
 		IWL_DEBUG_MAC80211(priv, "leave - vif != NULL\n");
-		return -EOPNOTSUPP;
+		err = -EOPNOTSUPP;
+		goto out;
 	}
 
-	spin_lock_irqsave(&priv->lock, flags);
 	priv->vif = vif;
 	priv->iw_mode = vif->type;
 
-	spin_unlock_irqrestore(&priv->lock, flags);
-
-	mutex_lock(&priv->mutex);
-
 	if (vif->addr) {
 		IWL_DEBUG_MAC80211(priv, "Set %pM\n", vif->addr);
 		memcpy(priv->mac_addr, vif->addr, ETH_ALEN);
@@ -2657,10 +2655,11 @@ int iwl_mac_add_interface(struct ieee80211_hw *hw,
 		/* we are not ready, will run again when ready */
 		set_bit(STATUS_MODE_PENDING, &priv->status);
 
+ out:
 	mutex_unlock(&priv->mutex);
 
 	IWL_DEBUG_MAC80211(priv, "leave\n");
-	return 0;
+	return err;
 }
 EXPORT_SYMBOL(iwl_mac_add_interface);
 
-- 
1.6.3.3

