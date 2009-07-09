Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f193.google.com ([209.85.216.193]:46929 "EHLO
	mail-px0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753715AbZGIV6A (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Jul 2009 17:58:00 -0400
Received: by pxi31 with SMTP id 31so294829pxi.33
        for <linux-wireless@vger.kernel.org>; Thu, 09 Jul 2009 14:57:59 -0700 (PDT)
From: Javier Cardona <javier@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: Javier Cardona <javier@cozybit.com>,
	Andrey Yurovsky <andrey@cozybit.com>,
	johannes@sipsolutions.net, linville@tuxdriver.com,
	devel@lists.open80211s.org
Subject: [PATCH v2] Assign next hop address to pending mesh frames once the path is resolved.
Date: Thu,  9 Jul 2009 14:42:16 -0700
Message-Id: <1247175736-6915-1-git-send-email-javier@cozybit.com>
In-Reply-To: <1247049613.4755.65.camel@johannes.local>
References: <1247049613.4755.65.camel@johannes.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Regression.  Frames transmitted when a mesh path was wating to be resolved were
being transmitted with an invalid Receiver Address.

[Changes since v1]

Suggested by Johannes:
 - Improved frame_queue traversal
 - Narower RCU scope

Signed-off-by: Javier Cardona <javier@cozybit.com>
Signed-off-by: Andrey Yurovsky <andrey@cozybit.com>
---
 net/mac80211/mesh_pathtbl.c |   18 ++++++++++++++++++
 1 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/mesh_pathtbl.c b/net/mac80211/mesh_pathtbl.c
index ae98766..1981af9 100644
--- a/net/mac80211/mesh_pathtbl.c
+++ b/net/mac80211/mesh_pathtbl.c
@@ -55,7 +55,25 @@ static DEFINE_RWLOCK(pathtbl_resize_lock);
  */
 void mesh_path_assign_nexthop(struct mesh_path *mpath, struct sta_info *sta)
 {
+	struct sk_buff *skb;
+	struct ieee80211_hdr *hdr;
+	struct sk_buff_head tmpq;
+	unsigned long flags;
+
 	rcu_assign_pointer(mpath->next_hop, sta);
+
+	__skb_queue_head_init(&tmpq);
+
+	spin_lock_irqsave(&mpath->frame_queue.lock, flags);
+
+	while ((skb = __skb_dequeue(&mpath->frame_queue)) != NULL) {
+		hdr = (struct ieee80211_hdr *) skb->data;
+		memcpy(hdr->addr1, sta->sta.addr, ETH_ALEN);
+		__skb_queue_tail(&tmpq, skb);
+	}
+
+	skb_queue_splice(&tmpq, &mpath->frame_queue);
+	spin_unlock_irqrestore(&mpath->frame_queue.lock, flags);
 }
 
 
-- 
1.5.4.3

