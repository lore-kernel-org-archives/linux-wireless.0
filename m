Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.181]:15129 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753273AbZGHGCJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Jul 2009 02:02:09 -0400
Received: by wa-out-1112.google.com with SMTP id j5so1029833wah.21
        for <linux-wireless@vger.kernel.org>; Tue, 07 Jul 2009 23:02:09 -0700 (PDT)
From: Javier Cardona <javier@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: devel@lists.open80211s.org, johannes@sipsolutions.net,
	Javier Cardona <javier@cozybit.com>
Subject: [PATCH] Assign next hop address to pending mesh frames once the path is resolved.
Date: Tue,  7 Jul 2009 22:53:23 -0700
Message-Id: <1247032403-8312-1-git-send-email-javier@cozybit.com>
In-Reply-To: <>
References: <>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Regression.  Frames transmitted when a mesh path was wating to be resolved were
being transmitted with an invalid Receiver Address.

Signed-off-by: Javier Cardona <javier@cozybit.com>
---
 net/mac80211/mesh.h         |    2 +-
 net/mac80211/mesh_pathtbl.c |   18 +++++++++++++++++-
 2 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/mesh.h b/net/mac80211/mesh.h
index 2a2ed18..1827725 100644
--- a/net/mac80211/mesh.h
+++ b/net/mac80211/mesh.h
@@ -61,7 +61,7 @@ enum mesh_path_flags {
  * 	retry
  * @discovery_retries: number of discovery retries
  * @flags: mesh path flags, as specified on &enum mesh_path_flags
- * @state_lock: mesh pat state lock
+ * @state_lock: mesh path state lock
  *
  *
  * The combination of dst and sdata is unique in the mesh path table. Since the
diff --git a/net/mac80211/mesh_pathtbl.c b/net/mac80211/mesh_pathtbl.c
index ae98766..75a13ee 100644
--- a/net/mac80211/mesh_pathtbl.c
+++ b/net/mac80211/mesh_pathtbl.c
@@ -55,7 +55,23 @@ static DEFINE_RWLOCK(pathtbl_resize_lock);
  */
 void mesh_path_assign_nexthop(struct mesh_path *mpath, struct sta_info *sta)
 {
-	rcu_assign_pointer(mpath->next_hop, sta);
+	struct sk_buff *skb, *skb_first = NULL;
+	struct ieee80211_hdr *hdr;
+
+	rcu_read_lock();
+	mpath->next_hop = sta;
+
+	while ((skb = skb_dequeue(&mpath->frame_queue)) != skb_first) {
+		if (!skb_first)
+			skb_first = skb;
+		hdr = (struct ieee80211_hdr *) skb->data;
+		memcpy(hdr->addr1, sta->sta.addr, ETH_ALEN);
+		skb_queue_tail(&mpath->frame_queue, skb);
+	}
+	if (skb_first)
+		skb_queue_tail(&mpath->frame_queue, skb_first);
+
+	rcu_read_unlock();
 }
 
 
-- 
1.5.4.3

