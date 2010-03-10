Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:11397 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751261Ab0CJFWE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Mar 2010 00:22:04 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 07/24] iwlwifi: remove frame dropping
Date: Tue,  9 Mar 2010 21:21:35 -0800
Message-Id: <1268198512-6572-8-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1268198512-6572-1-git-send-email-reinette.chatre@intel.com>
References: <1268198512-6572-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

With some of the new code in mac80211, public action
frames can be exchanged as non-injected frames even
while not associated.

Aside from that, dropping frames here is pointless
since we do deal with arbitrary frames that were
injected already, so let mac80211 make the decision
about which frames to allow or not.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-tx.c       |   10 ----------
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    9 ---------
 2 files changed, 0 insertions(+), 19 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-tx.c b/drivers/net/wireless/iwlwifi/iwl-tx.c
index 1ed5206..08b33fc 100644
--- a/drivers/net/wireless/iwlwifi/iwl-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-tx.c
@@ -761,16 +761,6 @@ int iwl_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 		IWL_DEBUG_TX(priv, "Sending REASSOC frame\n");
 #endif
 
-	/* drop all non-injected data frame if we are not associated */
-	if (ieee80211_is_data(fc) &&
-	    !(info->flags & IEEE80211_TX_CTL_INJECTED) &&
-	    (!iwl_is_associated(priv) ||
-	     ((priv->iw_mode == NL80211_IFTYPE_STATION) && !priv->assoc_id) ||
-	     !priv->assoc_station_added)) {
-		IWL_DEBUG_DROP(priv, "Dropping - !iwl_is_associated\n");
-		goto drop_unlock;
-	}
-
 	hdr_len = ieee80211_hdrlen(fc);
 
 	/* Find (or create) index into station table for destination station */
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index a825092..2b2c96b 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -504,15 +504,6 @@ static int iwl3945_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 		IWL_DEBUG_TX(priv, "Sending REASSOC frame\n");
 #endif
 
-	/* drop all non-injected data frame if we are not associated */
-	if (ieee80211_is_data(fc) &&
-	    !(info->flags & IEEE80211_TX_CTL_INJECTED) &&
-	    (!iwl_is_associated(priv) ||
-	     ((priv->iw_mode == NL80211_IFTYPE_STATION) && !priv->assoc_id))) {
-		IWL_DEBUG_DROP(priv, "Dropping - !iwl_is_associated\n");
-		goto drop_unlock;
-	}
-
 	spin_unlock_irqrestore(&priv->lock, flags);
 
 	hdr_len = ieee80211_hdrlen(fc);
-- 
1.6.3.3

