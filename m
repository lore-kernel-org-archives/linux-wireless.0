Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f42.google.com ([209.85.210.42]:44790 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751176Ab1J2FFi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 29 Oct 2011 01:05:38 -0400
Received: by pzk36 with SMTP id 36so12352067pzk.1
        for <linux-wireless@vger.kernel.org>; Fri, 28 Oct 2011 22:05:38 -0700 (PDT)
From: Thomas Pedersen <thomas@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: devel@lists.open80211s.org, Javier Cardona <javier@cozybit.com>,
	johannes@sipsolutions.net, linville@tuxdriver.com
Subject: [PATCH 1/4] mac80211: Avoid filling up mesh preq queue with redundant requests
Date: Fri, 28 Oct 2011 22:05:29 -0700
Message-Id: <1319864732-11286-1-git-send-email-thomas@cozybit.com> (sfid-20111029_070542_640178_713EC88C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Javier Cardona <javier@cozybit.com>

Don't accept redundant PREQs for a given destination. This fixes a
problem under high load:

kernel: [20386.250913] mesh_queue_preq: 235 callbacks suppressed
kernel: [20386.253335] Mesh HWMP (mesh0): PREQ node queue full
kernel: [20386.253352] Mesh HWMP (mesh0): PREQ node queue full
(...)

The 802.11s protocol has a provision to limit the rate of path requests
(PREQs) are transmitted (dot11MeshHWMPpreqMinInterval) but there was no
limit on the rate at which PREQs were being queued up.  There is a valid
reason for queuing PREQs: this way we can even out PREQ bursts.  But
queueing multiple PREQs for the same destination is useless.

Reported-by: Pedro Larbig <pedro.larbig@carhs.de>
Signed-off-by: Javier Cardona <javier@cozybit.com>
---
v2: fix merge conflict

 net/mac80211/mesh.h      |    3 +++
 net/mac80211/mesh_hwmp.c |   15 +++++++++++++--
 2 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/mesh.h b/net/mac80211/mesh.h
index 8c00e2d..b3745e8 100644
--- a/net/mac80211/mesh.h
+++ b/net/mac80211/mesh.h
@@ -31,6 +31,8 @@
  * @MESH_PATH_FIXED: the mesh path has been manually set and should not be
  * 	modified
  * @MESH_PATH_RESOLVED: the mesh path can has been resolved
+ * @MESH_PATH_REQ_QUEUED: there is an unsent path request for this destination
+ * already queued up, waiting for the discovery process to start.
  *
  * MESH_PATH_RESOLVED is used by the mesh path timer to
  * decide when to stop or cancel the mesh path discovery.
@@ -41,6 +43,7 @@ enum mesh_path_flags {
 	MESH_PATH_SN_VALID =	BIT(2),
 	MESH_PATH_FIXED	=	BIT(3),
 	MESH_PATH_RESOLVED =	BIT(4),
+	MESH_PATH_REQ_QUEUED =	BIT(5),
 };
 
 /**
diff --git a/net/mac80211/mesh_hwmp.c b/net/mac80211/mesh_hwmp.c
index 9a1f8bb..b7d9dfd 100644
--- a/net/mac80211/mesh_hwmp.c
+++ b/net/mac80211/mesh_hwmp.c
@@ -867,9 +867,19 @@ static void mesh_queue_preq(struct mesh_path *mpath, u8 flags)
 		return;
 	}
 
+	spin_lock_bh(&mpath->state_lock);
+	if (mpath->flags & MESH_PATH_REQ_QUEUED) {
+		spin_unlock_bh(&mpath->state_lock);
+		spin_unlock_bh(&ifmsh->mesh_preq_queue_lock);
+		return;
+	}
+
 	memcpy(preq_node->dst, mpath->dst, ETH_ALEN);
 	preq_node->flags = flags;
 
+	mpath->flags |= MESH_PATH_REQ_QUEUED;
+	spin_unlock_bh(&mpath->state_lock);
+
 	list_add_tail(&preq_node->list, &ifmsh->preq_queue.list);
 	++ifmsh->preq_queue_len;
 	spin_unlock_bh(&ifmsh->mesh_preq_queue_lock);
@@ -921,6 +931,7 @@ void mesh_path_start_discovery(struct ieee80211_sub_if_data *sdata)
 		goto enddiscovery;
 
 	spin_lock_bh(&mpath->state_lock);
+	mpath->flags &= ~MESH_PATH_REQ_QUEUED;
 	if (preq_node->flags & PREQ_Q_F_START) {
 		if (mpath->flags & MESH_PATH_RESOLVING) {
 			spin_unlock_bh(&mpath->state_lock);
@@ -1028,8 +1039,7 @@ int mesh_nexthop_lookup(struct sk_buff *skb,
 			mesh_queue_preq(mpath, PREQ_Q_F_START);
 		}
 
-		if (skb_queue_len(&mpath->frame_queue) >=
-				MESH_FRAME_QUEUE_LEN)
+		if (skb_queue_len(&mpath->frame_queue) >= MESH_FRAME_QUEUE_LEN)
 			skb_to_free = skb_dequeue(&mpath->frame_queue);
 
 		info->flags |= IEEE80211_TX_INTFL_NEED_TXPROCESSING;
@@ -1062,6 +1072,7 @@ void mesh_path_timer(unsigned long data)
 		++mpath->discovery_retries;
 		mpath->discovery_timeout *= 2;
 		spin_unlock_bh(&mpath->state_lock);
+		mpath->flags &= ~MESH_PATH_REQ_QUEUED;
 		mesh_queue_preq(mpath, 0);
 	} else {
 		mpath->flags = 0;
-- 
1.7.5.4

