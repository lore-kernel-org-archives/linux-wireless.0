Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:36654 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753108Ab3GNU5a (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 14 Jul 2013 16:57:30 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 1/4] mac80211_hwsim: use ieee80211_free_txskb
Date: Sun, 14 Jul 2013 23:57:19 +0300
Message-Id: <1373835442-3322-1-git-send-email-johannes@sipsolutions.net> (sfid-20130714_225738_869058_5E949364)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

These are only strange error cases, so it's not really
all that important, but the driver really should use
ieee80211_free_tx_skb instead of just dev_kfree_skb.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/mac80211_hwsim.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index cb34c78..11adae8 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -867,7 +867,7 @@ static void mac80211_hwsim_tx(struct ieee80211_hw *hw,
 
 	if (WARN_ON(skb->len < 10)) {
 		/* Should not happen; just a sanity check for addr1 use */
-		dev_kfree_skb(skb);
+		ieee80211_free_txskb(hw, skb);
 		return;
 	}
 
@@ -884,13 +884,13 @@ static void mac80211_hwsim_tx(struct ieee80211_hw *hw,
 	}
 
 	if (WARN(!channel, "TX w/o channel - queue = %d\n", txi->hw_queue)) {
-		dev_kfree_skb(skb);
+		ieee80211_free_txskb(hw, skb);
 		return;
 	}
 
 	if (data->idle && !data->tmp_chan) {
 		wiphy_debug(hw->wiphy, "Trying to TX when idle - reject\n");
-		dev_kfree_skb(skb);
+		ieee80211_free_txskb(hw, skb);
 		return;
 	}
 
-- 
1.8.0

