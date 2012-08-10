Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:40521 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755860Ab2HJBPx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Aug 2012 21:15:53 -0400
Received: by mail-pb0-f46.google.com with SMTP id rr13so1807450pbb.19
        for <linux-wireless@vger.kernel.org>; Thu, 09 Aug 2012 18:15:53 -0700 (PDT)
From: Thomas Pedersen <thomas@cozybit.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Thomas Pedersen <thomas@cozybit.com>
Subject: [PATCH v2 2/2] mac80211: clean up mpath_move_to_queue()
Date: Thu,  9 Aug 2012 18:15:40 -0700
Message-Id: <1344561340-32409-2-git-send-email-thomas@cozybit.com> (sfid-20120810_031607_460940_BC2A4CC9)
In-Reply-To: <1344561340-32409-1-git-send-email-thomas@cozybit.com>
References: <1344561340-32409-1-git-send-email-thomas@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use skb_queue_walk_safe instead, and fix a few issues:

	- didn't free old skbs on moving
	- didn't react to failed skb alloc
	- needlessly held a local pointer to the destination frame queue
	- didn't check destination queue length before adding skb

Signed-off-by: Thomas Pedersen <thomas@cozybit.com>
---
 net/mac80211/mesh.h         |    3 +++
 net/mac80211/mesh_hwmp.c    |    2 --
 net/mac80211/mesh_pathtbl.c |   34 ++++++++++++++++++----------------
 3 files changed, 21 insertions(+), 18 deletions(-)

diff --git a/net/mac80211/mesh.h b/net/mac80211/mesh.h
index faaa39b..e4d911f 100644
--- a/net/mac80211/mesh.h
+++ b/net/mac80211/mesh.h
@@ -215,6 +215,9 @@ struct mesh_rmc {
 /* Maximum number of paths per interface */
 #define MESH_MAX_MPATHS		1024
 
+/* Number of frames buffered per destination for unresolved destinations */
+#define MESH_FRAME_QUEUE_LEN	10
+
 /* Public interfaces */
 /* Various */
 int ieee80211_fill_mesh_addresses(struct ieee80211_hdr *hdr, __le16 *fc,
diff --git a/net/mac80211/mesh_hwmp.c b/net/mac80211/mesh_hwmp.c
index 494bc39..47aeee2 100644
--- a/net/mac80211/mesh_hwmp.c
+++ b/net/mac80211/mesh_hwmp.c
@@ -17,8 +17,6 @@
 #define MAX_METRIC	0xffffffff
 #define ARITH_SHIFT	8
 
-/* Number of frames buffered per destination for unresolved destinations */
-#define MESH_FRAME_QUEUE_LEN	10
 #define MAX_PREQ_QUEUE_LEN	64
 
 /* Destination only */
diff --git a/net/mac80211/mesh_pathtbl.c b/net/mac80211/mesh_pathtbl.c
index 3ca1e17..7f9630d 100644
--- a/net/mac80211/mesh_pathtbl.c
+++ b/net/mac80211/mesh_pathtbl.c
@@ -279,40 +279,42 @@ static void mesh_path_move_to_queue(struct mesh_path *gate_mpath,
 				    struct mesh_path *from_mpath,
 				    bool copy)
 {
-	struct sk_buff *skb, *cp_skb = NULL;
-	struct sk_buff_head gateq, failq;
+	struct sk_buff *skb, *fskb, *tmp;
+	struct sk_buff_head failq;
 	unsigned long flags;
-	int num_skbs;
 
 	BUG_ON(gate_mpath == from_mpath);
 	BUG_ON(!gate_mpath->next_hop);
 
-	__skb_queue_head_init(&gateq);
 	__skb_queue_head_init(&failq);
 
 	spin_lock_irqsave(&from_mpath->frame_queue.lock, flags);
 	skb_queue_splice_init(&from_mpath->frame_queue, &failq);
 	spin_unlock_irqrestore(&from_mpath->frame_queue.lock, flags);
 
-	num_skbs = skb_queue_len(&failq);
-
-	while (num_skbs--) {
-		skb = __skb_dequeue(&failq);
-		if (copy) {
-			cp_skb = skb_copy(skb, GFP_ATOMIC);
-			if (cp_skb)
-				__skb_queue_tail(&failq, cp_skb);
+	skb_queue_walk_safe(&failq, fskb, tmp) {
+		if (skb_queue_len(&gate_mpath->frame_queue) >=
+				  MESH_FRAME_QUEUE_LEN) {
+			mpath_dbg(gate_mpath->sdata, "mpath queue full!\n");
+			break;
 		}
 
+		skb = skb_copy(fskb, GFP_ATOMIC);
+		if (WARN_ON(!skb))
+			break;
+
 		prepare_for_gate(skb, gate_mpath->dst, gate_mpath);
-		__skb_queue_tail(&gateq, skb);
+		skb_queue_tail(&gate_mpath->frame_queue, skb);
+
+		if (copy)
+			continue;
+
+		__skb_unlink(fskb, &failq);
+		kfree_skb(fskb);
 	}
 
-	spin_lock_irqsave(&gate_mpath->frame_queue.lock, flags);
-	skb_queue_splice(&gateq, &gate_mpath->frame_queue);
 	mpath_dbg(gate_mpath->sdata, "Mpath queue for gate %pM has %d frames\n",
 		  gate_mpath->dst, skb_queue_len(&gate_mpath->frame_queue));
-	spin_unlock_irqrestore(&gate_mpath->frame_queue.lock, flags);
 
 	if (!copy)
 		return;
-- 
1.7.5.4

