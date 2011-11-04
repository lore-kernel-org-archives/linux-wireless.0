Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:40086 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750924Ab1KDEL1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Nov 2011 00:11:27 -0400
Received: by ywf7 with SMTP id 7so2077492ywf.19
        for <linux-wireless@vger.kernel.org>; Thu, 03 Nov 2011 21:11:26 -0700 (PDT)
From: Thomas Pedersen <thomas@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: Javier Cardona <javier@cozybit.com>, johannes@sipsolutions.net,
	linville@tuxdriver.com
Subject: [PATCH v4 1/4] mac80211: Avoid filling up mesh preq queue with redundant requests
Date: Thu,  3 Nov 2011 21:11:10 -0700
Message-Id: <1320379873-30884-1-git-send-email-thomas@cozybit.com> (sfid-20111104_051131_487290_8216E5FD)
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
v3: move mpath flag update inside state_lock (Johannes)

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
index 9a1f8bb..b22b223 100644
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
@@ -1061,6 +1071,7 @@ void mesh_path_timer(unsigned long data)
 	} else if (mpath->discovery_retries < max_preq_retries(sdata)) {
 		++mpath->discovery_retries;
 		mpath->discovery_timeout *= 2;
+		mpath->flags &= ~MESH_PATH_REQ_QUEUED;
 		spin_unlock_bh(&mpath->state_lock);
 		mesh_queue_preq(mpath, 0);
 	} else {
-- 
1.7.5.4

