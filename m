Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:31244 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751119AbYKGR6O (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Nov 2008 12:58:14 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Mohamed Abbas <mohamed.abbas@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 01/13] iwlagn: fix resume for ADHOC network
Date: Fri,  7 Nov 2008 09:58:34 -0800
Message-Id: <1226080726-24860-2-git-send-email-reinette.chatre@intel.com> (sfid-20081107_185819_873292_6E3A05A1)
In-Reply-To: <1226080726-24860-1-git-send-email-reinette.chatre@intel.com>
References: <>
 <1226080726-24860-1-git-send-email-reinette.chatre@intel.com>
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
 drivers/net/wireless/iwlwifi/iwl-agn.c |   21 +++++++++++++++------
 1 files changed, 15 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index b4fca99..2395a3e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -2006,6 +2006,10 @@ static int iwl_read_ucode(struct iwl_priv *priv)
 	return ret;
 }
 
+/* temporary */
+static int iwl_mac_beacon_update(struct ieee80211_hw *hw,
+				 struct sk_buff *skb);
+
 /**
  * iwl_alive_start - called after REPLY_ALIVE notification received
  *                   from protocol/runtime uCode (initialization uCode's
@@ -2088,6 +2092,15 @@ static void iwl_alive_start(struct iwl_priv *priv)
 
 	iwl_power_update_mode(priv, 1);
 
+	/* reassociate for ADHOC mode */
+	if (priv->vif && (priv->iw_mode == NL80211_IFTYPE_ADHOC)) {
+		struct sk_buff *beacon = ieee80211_beacon_get(priv->hw,
+								priv->vif);
+		if (beacon)
+			iwl_mac_beacon_update(priv->hw, beacon);
+	}
+
+
 	if (test_and_clear_bit(STATUS_MODE_PENDING, &priv->status))
 		iwl_set_mode(priv, priv->iw_mode);
 
@@ -2939,8 +2952,6 @@ static void iwl_config_ap(struct iwl_priv *priv)
 	 * clear sta table, add BCAST sta... */
 }
 
-/* temporary */
-static int iwl_mac_beacon_update(struct ieee80211_hw *hw, struct sk_buff *skb);
 
 static int iwl_mac_config_interface(struct ieee80211_hw *hw,
 					struct ieee80211_vif *vif,
@@ -2963,7 +2974,9 @@ static int iwl_mac_config_interface(struct ieee80211_hw *hw,
 		struct sk_buff *beacon = ieee80211_beacon_get(hw, vif);
 		if (!beacon)
 			return -ENOMEM;
+		mutex_lock(&priv->mutex);
 		rc = iwl_mac_beacon_update(hw, beacon);
+		mutex_unlock(&priv->mutex);
 		if (rc)
 			return rc;
 	}
@@ -3543,18 +3556,15 @@ static int iwl_mac_beacon_update(struct ieee80211_hw *hw, struct sk_buff *skb)
 	unsigned long flags;
 	__le64 timestamp;
 
-	mutex_lock(&priv->mutex);
 	IWL_DEBUG_MAC80211("enter\n");
 
 	if (!iwl_is_ready_rf(priv)) {
 		IWL_DEBUG_MAC80211("leave - RF not ready\n");
-		mutex_unlock(&priv->mutex);
 		return -EIO;
 	}
 
 	if (priv->iw_mode != NL80211_IFTYPE_ADHOC) {
 		IWL_DEBUG_MAC80211("leave - not IBSS\n");
-		mutex_unlock(&priv->mutex);
 		return -EIO;
 	}
 
@@ -3576,7 +3586,6 @@ static int iwl_mac_beacon_update(struct ieee80211_hw *hw, struct sk_buff *skb)
 
 	iwl_post_associate(priv);
 
-	mutex_unlock(&priv->mutex);
 
 	return 0;
 }
-- 
1.5.4.3

