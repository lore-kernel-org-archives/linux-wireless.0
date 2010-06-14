Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:7575 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751916Ab0FNSYl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Jun 2010 14:24:41 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 1/2] iwlwifi: serialize station management actions
Date: Mon, 14 Jun 2010 11:24:31 -0700
Message-Id: <1276539872-12440-2-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1276539872-12440-1-git-send-email-reinette.chatre@intel.com>
References: <1276539872-12440-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Reinette Chatre <reinette.chatre@intel.com>

We are seeing some race conditions between incoming station management
requests (station add/remove) and the internal unassoc RXON command that
modifies station table. Modify these flows to require the mutex to be held
and thus serializing them.

This fixes http://bugzilla.intellinuxwireless.org/show_bug.cgi?id=2207

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c      |    8 ++++++--
 drivers/net/wireless/iwlwifi/iwl-sta.c      |    4 ++++
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    9 +++++++--
 3 files changed, 17 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 7726e67..24aff65 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -3391,10 +3391,12 @@ static int iwlagn_mac_sta_add(struct ieee80211_hw *hw,
 	int ret;
 	u8 sta_id;
 
-	sta_priv->common.sta_id = IWL_INVALID_STATION;
-
 	IWL_DEBUG_INFO(priv, "received request to add station %pM\n",
 			sta->addr);
+	mutex_lock(&priv->mutex);
+	IWL_DEBUG_INFO(priv, "proceeding to add station %pM\n",
+			sta->addr);
+	sta_priv->common.sta_id = IWL_INVALID_STATION;
 
 	atomic_set(&sta_priv->pending_frames, 0);
 	if (vif->type == NL80211_IFTYPE_AP)
@@ -3406,6 +3408,7 @@ static int iwlagn_mac_sta_add(struct ieee80211_hw *hw,
 		IWL_ERR(priv, "Unable to add station %pM (%d)\n",
 			sta->addr, ret);
 		/* Should we return success if return code is EEXIST ? */
+		mutex_unlock(&priv->mutex);
 		return ret;
 	}
 
@@ -3415,6 +3418,7 @@ static int iwlagn_mac_sta_add(struct ieee80211_hw *hw,
 	IWL_DEBUG_INFO(priv, "Initializing rate scaling for station %pM\n",
 		       sta->addr);
 	iwl_rs_rate_init(priv, sta, sta_id);
+	mutex_unlock(&priv->mutex);
 
 	return 0;
 }
diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.c b/drivers/net/wireless/iwlwifi/iwl-sta.c
index 83a2636..c27c13f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-sta.c
@@ -1373,10 +1373,14 @@ int iwl_mac_sta_remove(struct ieee80211_hw *hw,
 
 	IWL_DEBUG_INFO(priv, "received request to remove station %pM\n",
 			sta->addr);
+	mutex_lock(&priv->mutex);
+	IWL_DEBUG_INFO(priv, "proceeding to remove station %pM\n",
+			sta->addr);
 	ret = iwl_remove_station(priv, sta_common->sta_id, sta->addr);
 	if (ret)
 		IWL_ERR(priv, "Error removing station %pM\n",
 			sta->addr);
+	mutex_unlock(&priv->mutex);
 	return ret;
 }
 EXPORT_SYMBOL(iwl_mac_sta_remove);
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 6c353ca..a27872d 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -3437,10 +3437,13 @@ static int iwl3945_mac_sta_add(struct ieee80211_hw *hw,
 	bool is_ap = vif->type == NL80211_IFTYPE_STATION;
 	u8 sta_id;
 
-	sta_priv->common.sta_id = IWL_INVALID_STATION;
-
 	IWL_DEBUG_INFO(priv, "received request to add station %pM\n",
 			sta->addr);
+	mutex_lock(&priv->mutex);
+	IWL_DEBUG_INFO(priv, "proceeding to add station %pM\n",
+			sta->addr);
+	sta_priv->common.sta_id = IWL_INVALID_STATION;
+
 
 	ret = iwl_add_station_common(priv, sta->addr, is_ap, &sta->ht_cap,
 				     &sta_id);
@@ -3448,6 +3451,7 @@ static int iwl3945_mac_sta_add(struct ieee80211_hw *hw,
 		IWL_ERR(priv, "Unable to add station %pM (%d)\n",
 			sta->addr, ret);
 		/* Should we return success if return code is EEXIST ? */
+		mutex_unlock(&priv->mutex);
 		return ret;
 	}
 
@@ -3457,6 +3461,7 @@ static int iwl3945_mac_sta_add(struct ieee80211_hw *hw,
 	IWL_DEBUG_INFO(priv, "Initializing rate scaling for station %pM\n",
 		       sta->addr);
 	iwl3945_rs_rate_init(priv, sta, sta_id);
+	mutex_unlock(&priv->mutex);
 
 	return 0;
 }
-- 
1.7.0.4

