Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:42660 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757466AbcINHpJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 14 Sep 2016 03:45:09 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Felix Fietkau <nbd@openwrt.org>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: check skb_linearize() return value
Date: Wed, 14 Sep 2016 09:45:05 +0200
Message-Id: <1473839105-28006-1-git-send-email-johannes@sipsolutions.net> (sfid-20160914_095202_079983_7899CF50)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The A-MSDU TX code (within TXQs) didn't always check the return value
of skb_linearize() properly, resulting in potentially passing a frag-
list SKB down to the driver even when it said it can't handle it. Fix
that.

Fixes: 6e0456b545456 ("mac80211: add A-MSDU tx support")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/tx.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index cc8e95554b48..6a46b36149a4 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1515,8 +1515,12 @@ out:
 	spin_unlock_bh(&fq->lock);
 
 	if (skb && skb_has_frag_list(skb) &&
-	    !ieee80211_hw_check(&local->hw, TX_FRAG_LIST))
-		skb_linearize(skb);
+	    !ieee80211_hw_check(&local->hw, TX_FRAG_LIST)) {
+		if (skb_linearize(skb)) {
+			kfree(skb);
+			return NULL;
+		}
+	}
 
 	return skb;
 }
-- 
2.8.1
