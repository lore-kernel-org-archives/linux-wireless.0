Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:65350 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754362Ab0EJW2X (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 May 2010 18:28:23 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 05/47] iwlwifi: use vif iwl_bss_info_changed
Date: Mon, 10 May 2010 15:27:36 -0700
Message-Id: <1273530498-11876-6-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1273530498-11876-1-git-send-email-reinette.chatre@intel.com>
References: <1273530498-11876-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The iw_mode will always follow the only vif we
have, but using the vif directly seems easier.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-core.c |    8 +++-----
 1 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 1e11706..d8ee528 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -1857,8 +1857,7 @@ void iwl_bss_info_changed(struct ieee80211_hw *hw,
 
 	mutex_lock(&priv->mutex);
 
-	if (changes & BSS_CHANGED_BEACON &&
-	    priv->iw_mode == NL80211_IFTYPE_AP) {
+	if (changes & BSS_CHANGED_BEACON && vif->type == NL80211_IFTYPE_AP) {
 		dev_kfree_skb(priv->ibss_beacon);
 		priv->ibss_beacon = ieee80211_beacon_get(hw, vif);
 	}
@@ -1884,8 +1883,7 @@ void iwl_bss_info_changed(struct ieee80211_hw *hw,
 		}
 
 		/* mac80211 only sets assoc when in STATION mode */
-		if (priv->iw_mode == NL80211_IFTYPE_ADHOC ||
-		    bss_conf->assoc) {
+		if (vif->type == NL80211_IFTYPE_ADHOC || bss_conf->assoc) {
 			memcpy(priv->staging_rxon.bssid_addr,
 			       bss_conf->bssid, ETH_ALEN);
 
@@ -1903,7 +1901,7 @@ void iwl_bss_info_changed(struct ieee80211_hw *hw,
 	 * mac80211 decides to do both changes at once because
 	 * it will invoke post_associate.
 	 */
-	if (priv->iw_mode == NL80211_IFTYPE_ADHOC &&
+	if (vif->type == NL80211_IFTYPE_ADHOC &&
 	    changes & BSS_CHANGED_BEACON) {
 		struct sk_buff *beacon = ieee80211_beacon_get(hw, vif);
 
-- 
1.6.3.3

