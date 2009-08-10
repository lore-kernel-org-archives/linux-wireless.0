Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f196.google.com ([209.85.222.196]:43325 "EHLO
	mail-pz0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752132AbZHJT1X (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Aug 2009 15:27:23 -0400
Received: by pzk34 with SMTP id 34so3033885pzk.4
        for <linux-wireless@vger.kernel.org>; Mon, 10 Aug 2009 12:27:24 -0700 (PDT)
From: Javier Cardona <javier@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: Javier Cardona <javier@cozybit.com>, andrey@cozybit.com,
	johannes@sipsolutions.net, linville@tuxdriver.com,
	devel@lists.open80211s.org
Subject: [PATCH 1/7] mac80211: Improve dequeing from mpath frame queue.
Date: Mon, 10 Aug 2009 12:15:46 -0700
Message-Id: <1249931752-18127-2-git-send-email-javier@cozybit.com>
In-Reply-To: <1249931752-18127-1-git-send-email-javier@cozybit.com>
References: <20090810175225.GF2733@tuxdriver.com>
 <1249931752-18127-1-git-send-email-javier@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Also, fix typo in comment.

Signed-off-by: Javier Cardona <javier@cozybit.com>
Tested-by: Andrey Yurovsky <andrey@cozybit.com>
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

