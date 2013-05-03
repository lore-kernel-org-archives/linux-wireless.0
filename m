Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f48.google.com ([209.85.220.48]:59166 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756827Ab3ECCgS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 May 2013 22:36:18 -0400
Received: by mail-pa0-f48.google.com with SMTP id kp6so673614pab.35
        for <linux-wireless@vger.kernel.org>; Thu, 02 May 2013 19:36:17 -0700 (PDT)
From: Thomas Pedersen <thomas@cozybit.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wirelss <linux-wireless@vger.kernel.org>, me@bobcopeland.com,
	open80211s <devel@lists.open80211s.org>,
	Thomas Pedersen <thomas@cozybit.com>
Subject: [RFC 04/12] mac80211: assign outgoing interface with nexthop
Date: Thu,  2 May 2013 19:33:54 -0700
Message-Id: <1367548442-8229-5-git-send-email-thomas@cozybit.com> (sfid-20130503_043621_456737_4C5EA666)
In-Reply-To: <1367548442-8229-1-git-send-email-thomas@cozybit.com>
References: <1367548442-8229-1-git-send-email-thomas@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When updated mpath routing info is found, the new route
may be on a different interface (in the case of MBSS
sharing).

Signed-off-by: Thomas Pedersen <thomas@cozybit.com>
---
 net/mac80211/mesh_pathtbl.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/mesh_pathtbl.c b/net/mac80211/mesh_pathtbl.c
index 993a270..7df8f27 100644
--- a/net/mac80211/mesh_pathtbl.c
+++ b/net/mac80211/mesh_pathtbl.c
@@ -195,27 +195,34 @@ static u32 mesh_table_hash(struct mesh_local_bss *mbss, const u8 *addr,
 
 /**
  *
- * mesh_path_assign_nexthop - update mesh path next hop
+ * mesh_path_assign_nexthop - update mesh path info
  *
  * @mpath: mesh path to update
  * @sta: next hop to assign
  *
+ * Updates queued frames and outgoing interface.
+ *
  * Locking: mpath->state_lock must be held when calling this function
  */
 void mesh_path_assign_nexthop(struct mesh_path *mpath, struct sta_info *sta)
 {
+	struct ieee80211_sub_if_data *sdata = sta->sdata;
+	struct ieee80211_tx_info *info;
 	struct sk_buff *skb;
 	struct ieee80211_hdr *hdr;
 	unsigned long flags;
 
 	rcu_assign_pointer(mpath->next_hop, sta);
+	mpath->sdata = sdata;
 
 	spin_lock_irqsave(&mpath->frame_queue.lock, flags);
 	skb_queue_walk(&mpath->frame_queue, skb) {
+		info = IEEE80211_SKB_CB(skb);
 		hdr = (struct ieee80211_hdr *) skb->data;
 		memcpy(hdr->addr1, sta->sta.addr, ETH_ALEN);
-		memcpy(hdr->addr2, mpath->sdata->vif.addr, ETH_ALEN);
-		ieee80211_mps_set_frame_flags(sta->sdata, sta, hdr);
+		memcpy(hdr->addr2, sdata->vif.addr, ETH_ALEN);
+		info->control.vif = &sdata->vif;
+		ieee80211_mps_set_frame_flags(sdata, sta, hdr);
 	}
 
 	spin_unlock_irqrestore(&mpath->frame_queue.lock, flags);
-- 
1.7.10.4

