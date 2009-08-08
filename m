Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.227]:31294 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933127AbZHHDnR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Aug 2009 23:43:17 -0400
Received: by rv-out-0506.google.com with SMTP id f6so563117rvb.1
        for <linux-wireless@vger.kernel.org>; Fri, 07 Aug 2009 20:43:18 -0700 (PDT)
From: Javier Cardona <javier@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: Andrey Yurovsky <andrey@cozybit.com>,
	Javier Cardona <javier@cozybit.com>, johannes@sipsolutions.net,
	linville@tuxdriver.com, devel@lists.open80211s.org
Subject: [PATCH] mac80211: Improve dequeing from mpath frame queue.
Date: Fri,  7 Aug 2009 20:31:47 -0700
Message-Id: <1249702314-32504-2-git-send-email-javier@cozybit.com>
In-Reply-To: <1249702314-32504-1-git-send-email-javier@cozybit.com>
References: <>
 <1249702314-32504-1-git-send-email-javier@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Andrey Yurovsky <andrey@cozybit.com>

Also, fix typo in comment.

Signed-off-by: Javier Cardona <javier@cozybit.com>
Signed-off-by: Andrey Yurovsky <andrey@cozybit.com>
---
 net/mac80211/mesh.h      |    2 +-
 net/mac80211/mesh_hwmp.c |    6 ++----
 2 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/net/mac80211/mesh.h b/net/mac80211/mesh.h
index ce53881..6aaf1ec 100644
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
diff --git a/net/mac80211/mesh_hwmp.c b/net/mac80211/mesh_hwmp.c
index e1a763e..b54c21c 100644
--- a/net/mac80211/mesh_hwmp.c
+++ b/net/mac80211/mesh_hwmp.c
@@ -810,10 +810,8 @@ int mesh_nexthop_lookup(struct sk_buff *skb,
 		}
 
 		if (skb_queue_len(&mpath->frame_queue) >=
-				MESH_FRAME_QUEUE_LEN) {
-			skb_to_free = mpath->frame_queue.next;
-			skb_unlink(skb_to_free, &mpath->frame_queue);
-		}
+				MESH_FRAME_QUEUE_LEN)
+			skb_to_free = skb_dequeue(&mpath->frame_queue);
 
 		info->flags |= IEEE80211_TX_INTFL_NEED_TXPROCESSING;
 		skb_queue_tail(&mpath->frame_queue, skb);
-- 
1.5.4.3

