Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:36341 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751014AbbKZK5x (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Nov 2015 05:57:53 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 2/8] mac80211: properly free TX skbs when monitor TX fails
Date: Thu, 26 Nov 2015 11:57:42 +0100
Message-Id: <1448535468-12237-2-git-send-email-johannes@sipsolutions.net> (sfid-20151126_115827_787101_0C978D8E)
In-Reply-To: <1448535468-12237-1-git-send-email-johannes@sipsolutions.net>
References: <1448535468-12237-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

We need to free all skbs here, not just the one we peeked
from the list.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/tx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index bdc224d5053a..3311ce0f3d6c 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1431,7 +1431,7 @@ static bool __ieee80211_tx(struct ieee80211_local *local,
 			info->hw_queue =
 				vif->hw_queue[skb_get_queue_mapping(skb)];
 		} else if (ieee80211_hw_check(&local->hw, QUEUE_CONTROL)) {
-			dev_kfree_skb(skb);
+			ieee80211_purge_tx_queue(&local->hw, skbs);
 			return true;
 		} else
 			vif = NULL;
-- 
2.6.2

