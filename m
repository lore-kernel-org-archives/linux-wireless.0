Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:40521 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756316Ab2HJBPw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Aug 2012 21:15:52 -0400
Received: by mail-pb0-f46.google.com with SMTP id rr13so1807450pbb.19
        for <linux-wireless@vger.kernel.org>; Thu, 09 Aug 2012 18:15:52 -0700 (PDT)
From: Thomas Pedersen <thomas@cozybit.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Thomas Pedersen <thomas@cozybit.com>
Subject: [PATCH v2 1/2] mac80211: use skb_queue_walk() in mesh_path_assign_nexthop
Date: Thu,  9 Aug 2012 18:15:39 -0700
Message-Id: <1344561340-32409-1-git-send-email-thomas@cozybit.com> (sfid-20120810_031606_770499_553721AE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since all we really want is just to iterate over all skbs, do just that
and avoid (de)queueing to a clusmy tmpq.

Signed-off-by: Thomas Pedersen <thomas@cozybit.com>
---
 net/mac80211/mesh_pathtbl.c |    8 +-------
 1 files changed, 1 insertions(+), 7 deletions(-)

diff --git a/net/mac80211/mesh_pathtbl.c b/net/mac80211/mesh_pathtbl.c
index 075bc53..3ca1e17 100644
--- a/net/mac80211/mesh_pathtbl.c
+++ b/net/mac80211/mesh_pathtbl.c
@@ -203,23 +203,17 @@ void mesh_path_assign_nexthop(struct mesh_path *mpath, struct sta_info *sta)
 {
 	struct sk_buff *skb;
 	struct ieee80211_hdr *hdr;
-	struct sk_buff_head tmpq;
 	unsigned long flags;
 
 	rcu_assign_pointer(mpath->next_hop, sta);
 
-	__skb_queue_head_init(&tmpq);
-
 	spin_lock_irqsave(&mpath->frame_queue.lock, flags);
-
-	while ((skb = __skb_dequeue(&mpath->frame_queue)) != NULL) {
+	skb_queue_walk(&mpath->frame_queue, skb) {
 		hdr = (struct ieee80211_hdr *) skb->data;
 		memcpy(hdr->addr1, sta->sta.addr, ETH_ALEN);
 		memcpy(hdr->addr2, mpath->sdata->vif.addr, ETH_ALEN);
-		__skb_queue_tail(&tmpq, skb);
 	}
 
-	skb_queue_splice(&tmpq, &mpath->frame_queue);
 	spin_unlock_irqrestore(&mpath->frame_queue.lock, flags);
 }
 
-- 
1.7.5.4

