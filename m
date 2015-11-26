Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:36343 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751301AbbKZK5x (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Nov 2015 05:57:53 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 1/8] mac80211: properly free skb when r-o-c for TX fails
Date: Thu, 26 Nov 2015 11:57:41 +0100
Message-Id: <1448535468-12237-1-git-send-email-johannes@sipsolutions.net> (sfid-20151126_115827_182052_E068529F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When freeing the TX skb for an off-channel TX, use the correct
API to also free the ACK skb that might have been allocated.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/cfg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index c2bd1b6a6922..25199e2d9b50 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -3475,7 +3475,7 @@ static int ieee80211_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
 				       params->wait, cookie, skb,
 				       IEEE80211_ROC_TYPE_MGMT_TX);
 	if (ret)
-		kfree_skb(skb);
+		ieee80211_free_txskb(&local->hw, skb);
  out_unlock:
 	mutex_unlock(&local->mtx);
 	return ret;
-- 
2.6.2

