Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:46230 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751901Ab2JIU16 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Oct 2012 16:27:58 -0400
Received: by mail-pb0-f46.google.com with SMTP id rr4so5629278pbb.19
        for <linux-wireless@vger.kernel.org>; Tue, 09 Oct 2012 13:27:58 -0700 (PDT)
From: Ashok Nagarajan <ashok@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, linville@tuxdriver.com,
	javier@cozybit.com, devel@lists.open80211s.org,
	Ashok Nagarajan <ashok@cozybit.com>
Subject: [PATCH 1/2] mac80211: move out the non-statistics variable estab_plinks from mesh_stat
Date: Tue,  9 Oct 2012 13:27:47 -0700
Message-Id: <1349814468-6512-1-git-send-email-ashok@cozybit.com> (sfid-20121009_222802_595792_88EF8B4E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

estab_plinks is not a statistics member. Hence move estab_plinks from
struct mesh_stat to struct ieee80211_if_mesh

Signed-off-by: Ashok Nagarajan <ashok@cozybit.com>
---
 net/mac80211/debugfs_netdev.c |    2 +-
 net/mac80211/ieee80211_i.h    |    2 +-
 net/mac80211/mesh.c           |    2 +-
 net/mac80211/mesh.h           |    2 +-
 net/mac80211/mesh_plink.c     |    4 ++--
 5 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/net/mac80211/debugfs_netdev.c b/net/mac80211/debugfs_netdev.c
index 6d5aec9..34f0ca4 100644
--- a/net/mac80211/debugfs_netdev.c
+++ b/net/mac80211/debugfs_netdev.c
@@ -471,7 +471,7 @@ IEEE80211_IF_FILE(dropped_frames_congestion,
 		  u.mesh.mshstats.dropped_frames_congestion, DEC);
 IEEE80211_IF_FILE(dropped_frames_no_route,
 		  u.mesh.mshstats.dropped_frames_no_route, DEC);
-IEEE80211_IF_FILE(estab_plinks, u.mesh.mshstats.estab_plinks, ATOMIC);
+IEEE80211_IF_FILE(estab_plinks, u.mesh.estab_plinks, ATOMIC);
 
 /* Mesh parameters */
 IEEE80211_IF_FILE(dot11MeshMaxRetries,
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 8c80455..34f3cda 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -316,7 +316,6 @@ struct mesh_stats {
 	__u32 dropped_frames_ttl;	/* Not transmitted since mesh_ttl == 0*/
 	__u32 dropped_frames_no_route;	/* Not transmitted, no route found */
 	__u32 dropped_frames_congestion;/* Not forwarded due to congestion */
-	atomic_t estab_plinks;
 };
 
 #define PREQ_Q_F_START		0x1
@@ -599,6 +598,7 @@ struct ieee80211_if_mesh {
 	int preq_queue_len;
 	struct mesh_stats mshstats;
 	struct mesh_config mshcfg;
+	atomic_t estab_plinks;
 	u32 mesh_seqnum;
 	bool accepting_plinks;
 	int num_gates;
diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index ff0296c..5cc7a91 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -264,7 +264,7 @@ mesh_add_meshconf_ie(struct sk_buff *skb, struct ieee80211_sub_if_data *sdata)
 	/* Authentication Protocol identifier */
 	*pos++ = ifmsh->mesh_auth_id;
 	/* Mesh Formation Info - number of neighbors */
-	neighbors = atomic_read(&ifmsh->mshstats.estab_plinks);
+	neighbors = atomic_read(&ifmsh->estab_plinks);
 	/* Number of neighbor mesh STAs or 15 whichever is smaller */
 	neighbors = (neighbors > 15) ? 15 : neighbors;
 	*pos++ = neighbors << 1;
diff --git a/net/mac80211/mesh.h b/net/mac80211/mesh.h
index 25d0f17..8334e94 100644
--- a/net/mac80211/mesh.h
+++ b/net/mac80211/mesh.h
@@ -324,7 +324,7 @@ extern int mesh_allocated;
 static inline int mesh_plink_free_count(struct ieee80211_sub_if_data *sdata)
 {
 	return sdata->u.mesh.mshcfg.dot11MeshMaxPeerLinks -
-	       atomic_read(&sdata->u.mesh.mshstats.estab_plinks);
+	       atomic_read(&sdata->u.mesh.estab_plinks);
 }
 
 static inline bool mesh_plink_availables(struct ieee80211_sub_if_data *sdata)
diff --git a/net/mac80211/mesh_plink.c b/net/mac80211/mesh_plink.c
index 3ab34d8..0f45ac9 100644
--- a/net/mac80211/mesh_plink.c
+++ b/net/mac80211/mesh_plink.c
@@ -50,14 +50,14 @@ static int mesh_plink_frame_tx(struct ieee80211_sub_if_data *sdata,
 static inline
 u32 mesh_plink_inc_estab_count(struct ieee80211_sub_if_data *sdata)
 {
-	atomic_inc(&sdata->u.mesh.mshstats.estab_plinks);
+	atomic_inc(&sdata->u.mesh.estab_plinks);
 	return mesh_accept_plinks_update(sdata);
 }
 
 static inline
 u32 mesh_plink_dec_estab_count(struct ieee80211_sub_if_data *sdata)
 {
-	atomic_dec(&sdata->u.mesh.mshstats.estab_plinks);
+	atomic_dec(&sdata->u.mesh.estab_plinks);
 	return mesh_accept_plinks_update(sdata);
 }
 
-- 
1.7.5.4

