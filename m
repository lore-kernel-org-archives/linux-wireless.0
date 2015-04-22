Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:55107 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933659AbbDVOqi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Apr 2015 10:46:38 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: don't update dev->trans_start
Date: Wed, 22 Apr 2015 16:46:34 +0200
Message-Id: <1429713994-17828-1-git-send-email-johannes@sipsolutions.net> (sfid-20150422_164641_174664_8FD2972C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

This isn't necessary any more as the stack will automatically
update the TXQ's trans_start after calling ndo_start_xmit().

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/tx.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index df62942653ad..83e3261dbf67 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -2729,7 +2729,6 @@ static bool ieee80211_xmit_fast(struct ieee80211_sub_if_data *sdata,
 
 	dev->stats.tx_packets++;
 	dev->stats.tx_bytes += skb->len + extra_head;
-	dev->trans_start = jiffies;
 
 	/* will not be crypto-handled beyond what we do here, so use false
 	 * as the may-encrypt argument for the resize to not account for
@@ -2912,7 +2911,6 @@ void __ieee80211_subif_start_xmit(struct sk_buff *skb,
 
 		dev->stats.tx_packets++;
 		dev->stats.tx_bytes += skb->len;
-		dev->trans_start = jiffies;
 
 		ieee80211_xmit(sdata, sta, skb);
 	}
-- 
2.1.4

