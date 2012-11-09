Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:54708 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753079Ab2KITtK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Nov 2012 14:49:10 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 2/2] iwlwifi: use ieee80211_free_txskb
Date: Fri,  9 Nov 2012 20:49:43 +0100
Message-Id: <1352490583-28609-2-git-send-email-johannes@sipsolutions.net> (sfid-20121109_204913_789591_EF73D75C)
In-Reply-To: <1352490583-28609-1-git-send-email-johannes@sipsolutions.net>
References: <1352490162.9238.23.camel@jlt4.sipsolutions.net>
 <1352490583-28609-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

To let mac80211 clean up any TX information when
a frame is dropped, use ieee80211_free_txskb().

Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/dvm/mac80211.c | 2 +-
 drivers/net/wireless/iwlwifi/dvm/main.c     | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/dvm/mac80211.c b/drivers/net/wireless/iwlwifi/dvm/mac80211.c
index ff8162d..fa4d1b8 100644
--- a/drivers/net/wireless/iwlwifi/dvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/dvm/mac80211.c
@@ -521,7 +521,7 @@ static void iwlagn_mac_tx(struct ieee80211_hw *hw,
 		     ieee80211_get_tx_rate(hw, IEEE80211_SKB_CB(skb))->bitrate);
 
 	if (iwlagn_tx_skb(priv, control->sta, skb))
-		dev_kfree_skb_any(skb);
+		ieee80211_free_txskb(hw, skb);
 }
 
 static void iwlagn_mac_update_tkip_key(struct ieee80211_hw *hw,
diff --git a/drivers/net/wireless/iwlwifi/dvm/main.c b/drivers/net/wireless/iwlwifi/dvm/main.c
index 7ff3f14..408132c 100644
--- a/drivers/net/wireless/iwlwifi/dvm/main.c
+++ b/drivers/net/wireless/iwlwifi/dvm/main.c
@@ -2114,7 +2114,7 @@ static void iwl_free_skb(struct iwl_op_mode *op_mode, struct sk_buff *skb)
 
 	info = IEEE80211_SKB_CB(skb);
 	iwl_trans_free_tx_cmd(priv->trans, info->driver_data[1]);
-	dev_kfree_skb_any(skb);
+	ieee80211_free_txskb(priv->hw, skb);
 }
 
 static void iwl_set_hw_rfkill_state(struct iwl_op_mode *op_mode, bool state)
-- 
1.8.0

