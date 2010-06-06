Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:22880 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752448Ab0FFG4o (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Jun 2010 02:56:44 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 12/23] iwlwifi: remove priv->mac_addr
Date: Sat,  5 Jun 2010 23:56:27 -0700
Message-Id: <1275807398-18184-13-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1275807398-18184-1-git-send-email-reinette.chatre@intel.com>
References: <1275807398-18184-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

This variable is now no longer used, so it
can be removed completely.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-core.c |    6 ++----
 drivers/net/wireless/iwlwifi/iwl-dev.h  |    1 -
 2 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 56bcf0e..ec0f39c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -1907,7 +1907,8 @@ int iwl_mac_add_interface(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 	struct iwl_priv *priv = hw->priv;
 	int err = 0;
 
-	IWL_DEBUG_MAC80211(priv, "enter: type %d\n", vif->type);
+	IWL_DEBUG_MAC80211(priv, "enter: type %d, addr %pM\n",
+			   vif->type, vif->addr);
 
 	mutex_lock(&priv->mutex);
 
@@ -1925,9 +1926,6 @@ int iwl_mac_add_interface(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 	priv->vif = vif;
 	priv->iw_mode = vif->type;
 
-	IWL_DEBUG_MAC80211(priv, "Set %pM\n", vif->addr);
-	memcpy(priv->mac_addr, vif->addr, ETH_ALEN);
-
 	err = iwl_set_mode(priv, vif);
 	if (err)
 		goto out_err;
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 6663df2..4abc24e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -1232,7 +1232,6 @@ struct iwl_priv {
 
 	/* context information */
 	u8 bssid[ETH_ALEN]; /* used only on 3945 but filled by core */
-	u8 mac_addr[ETH_ALEN];
 
 	/* station table variables */
 
-- 
1.7.0.4

