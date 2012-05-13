Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:38506 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751675Ab2EMNrK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 May 2012 09:47:10 -0400
Received: by wibhj8 with SMTP id hj8so876895wib.1
        for <linux-wireless@vger.kernel.org>; Sun, 13 May 2012 06:47:09 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH] mac80211: use offchannel queue only when supported
Date: Sun, 13 May 2012 16:47:05 +0300
Message-Id: <1336916826-22462-1-git-send-email-eliad@wizery.com> (sfid-20120513_154713_893546_1FFBF481)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Commit 3a25a8c ("mac80211: add improved HW queue control")
added support for offchannel queue mapping. However, this
mapping is only valid when the driver supports
IEEE80211_HW_QUEUE_CONTROL.

Check whether the driver supports IEEE80211_HW_QUEUE_CONTROL
before setting the hw_queue to the mapped offchannel queue.

(This patch doesn't have any actual effect, because
hw_queue is overridden in ieee80211_tx() anyway,
so this is merely some cleanup)

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 net/mac80211/cfg.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 6a82ae3..6b60593 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -2303,7 +2303,8 @@ static int ieee80211_mgmt_tx(struct wiphy *wiphy, struct net_device *dev,
 
 	IEEE80211_SKB_CB(skb)->flags = flags;
 
-	if (flags & IEEE80211_TX_CTL_TX_OFFCHAN)
+	if (local->hw.flags & IEEE80211_HW_QUEUE_CONTROL &&
+	    flags & IEEE80211_TX_CTL_TX_OFFCHAN)
 		IEEE80211_SKB_CB(skb)->hw_queue =
 			local->hw.offchannel_tx_hw_queue;
 
@@ -2348,8 +2349,9 @@ static int ieee80211_mgmt_tx(struct wiphy *wiphy, struct net_device *dev,
 		/* modify cookie to prevent API mismatches */
 		*cookie ^= 2;
 		IEEE80211_SKB_CB(skb)->flags |= IEEE80211_TX_CTL_TX_OFFCHAN;
-		IEEE80211_SKB_CB(skb)->hw_queue =
-			local->hw.offchannel_tx_hw_queue;
+		if (local->hw.flags & IEEE80211_HW_QUEUE_CONTROL)
+			IEEE80211_SKB_CB(skb)->hw_queue =
+				local->hw.offchannel_tx_hw_queue;
 		local->hw_roc_skb = skb;
 		local->hw_roc_skb_for_status = skb;
 		mutex_unlock(&local->mtx);
-- 
1.7.6.401.g6a319

