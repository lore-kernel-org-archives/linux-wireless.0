Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:30374 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751364AbYKGR6O (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Nov 2008 12:58:14 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Mohamed Abbas <mohamed.abbas@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 02/13] iwl3945: fix resume for ADHOC network
Date: Fri,  7 Nov 2008 09:58:35 -0800
Message-Id: <1226080726-24860-3-git-send-email-reinette.chatre@intel.com> (sfid-20081107_185820_585033_1C192917)
In-Reply-To: <1226080726-24860-2-git-send-email-reinette.chatre@intel.com>
References: <>
 <1226080726-24860-1-git-send-email-reinette.chatre@intel.com>
 <1226080726-24860-2-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohamed Abbas <mohamed.abbas@intel.com>

 ieee80211_notify_mac only reconnect BSS networks. Since IBSS does
 not need any auth or assoc steps we can just resume to the same
 condition before suspend. This patch will reestablish the ad-hoc
 network once it comes back from resume.

http://www.intellinuxwireless.org/bugzilla/show_bug.cgi?id=1774

Signed-off-by: Mohamed Abbas <mohamed.abbas@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl3945-base.c |   21 ++++++++++++++-------
 1 files changed, 14 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 5dd53a1..3e4c652 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -5611,6 +5611,10 @@ static void iwl3945_init_alive_start(struct iwl3945_priv *priv)
 }
 
 
+/* temporary */
+static int iwl3945_mac_beacon_update(struct ieee80211_hw *hw,
+				     struct sk_buff *skb);
+
 /**
  * iwl3945_alive_start - called after REPLY_ALIVE notification received
  *                   from protocol/runtime uCode (initialization uCode's
@@ -5714,6 +5718,14 @@ static void iwl3945_alive_start(struct iwl3945_priv *priv)
 	if (priv->error_recovering)
 		iwl3945_error_recovery(priv);
 
+	/* reassociate for ADHOC mode */
+	if (priv->vif && (priv->iw_mode == NL80211_IFTYPE_ADHOC)) {
+		struct sk_buff *beacon = ieee80211_beacon_get(priv->hw,
+								priv->vif);
+		if (beacon)
+			iwl3945_mac_beacon_update(priv->hw, beacon);
+	}
+
 	return;
 
  restart:
@@ -6725,9 +6737,6 @@ static void iwl3945_config_ap(struct iwl3945_priv *priv)
 	 * clear sta table, add BCAST sta... */
 }
 
-/* temporary */
-static int iwl3945_mac_beacon_update(struct ieee80211_hw *hw, struct sk_buff *skb);
-
 static int iwl3945_mac_config_interface(struct ieee80211_hw *hw,
 					struct ieee80211_vif *vif,
 				    struct ieee80211_if_conf *conf)
@@ -6750,7 +6759,9 @@ static int iwl3945_mac_config_interface(struct ieee80211_hw *hw,
 		struct sk_buff *beacon = ieee80211_beacon_get(hw, vif);
 		if (!beacon)
 			return -ENOMEM;
+		mutex_lock(&priv->mutex);
 		rc = iwl3945_mac_beacon_update(hw, beacon);
+		mutex_unlock(&priv->mutex);
 		if (rc)
 			return rc;
 	}
@@ -7207,18 +7218,15 @@ static int iwl3945_mac_beacon_update(struct ieee80211_hw *hw, struct sk_buff *sk
 	struct iwl3945_priv *priv = hw->priv;
 	unsigned long flags;
 
-	mutex_lock(&priv->mutex);
 	IWL_DEBUG_MAC80211("enter\n");
 
 	if (!iwl3945_is_ready_rf(priv)) {
 		IWL_DEBUG_MAC80211("leave - RF not ready\n");
-		mutex_unlock(&priv->mutex);
 		return -EIO;
 	}
 
 	if (priv->iw_mode != NL80211_IFTYPE_ADHOC) {
 		IWL_DEBUG_MAC80211("leave - not IBSS\n");
-		mutex_unlock(&priv->mutex);
 		return -EIO;
 	}
 
@@ -7238,7 +7246,6 @@ static int iwl3945_mac_beacon_update(struct ieee80211_hw *hw, struct sk_buff *sk
 
 	iwl3945_post_associate(priv);
 
-	mutex_unlock(&priv->mutex);
 
 	return 0;
 }
-- 
1.5.4.3

