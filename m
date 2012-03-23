Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:65066 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753830Ab2CWCM4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Mar 2012 22:12:56 -0400
Received: by pbcun15 with SMTP id un15so2087868pbc.19
        for <linux-wireless@vger.kernel.org>; Thu, 22 Mar 2012 19:12:55 -0700 (PDT)
From: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, javier@cozybit.com, thomas@cozybit.com,
	linville@tuxdriver.com, devel@lists.open80211s.org,
	lindner_marek@yahoo.de, Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
Subject: [PATCH v3] mac80211: fix the RANN propagation issues
Date: Fri, 23 Mar 2012 18:48:51 +0800
Message-Id: <1332499731-28311-1-git-send-email-yeohchunyeow@gmail.com> (sfid-20120323_031310_782473_A8F80D96)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch is intended to solve the follwing issues in RANN propagation:
[1] The interval in propagated RANN should be based on the interval of received RANN.
[2] The aggregated path metric for propagated RANN is as received plus own link metric
    towards the transmitting mesh STA (not root mesh STA).
[3] The comparison of path metric for RANN with same sequence number should be done
    before deciding whether to propagate or not.

Signed-off-by: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
---
v2:
revert back to plain conditionals (Javier and Thomas)

v3:
SN comparison in modulo 2^32 (Javier and Marek)

 net/mac80211/mesh.h      |    2 ++
 net/mac80211/mesh_hwmp.c |   24 ++++++++++++++++++------
 2 files changed, 20 insertions(+), 6 deletions(-)

diff --git a/net/mac80211/mesh.h b/net/mac80211/mesh.h
index 8d53b71..adf1be3 100644
--- a/net/mac80211/mesh.h
+++ b/net/mac80211/mesh.h
@@ -86,6 +86,7 @@ enum mesh_deferred_task_flags {
  * mpath itself.  No need to take this lock when adding or removing
  * an mpath to a hash bucket on a path table.
  * @rann_snd_addr: the RANN sender address
+ * @rann_metric: the aggregated path metric towards the root node
  * @is_root: the destination station of this path is a root node
  * @is_gate: the destination station of this path is a mesh gate
  *
@@ -112,6 +113,7 @@ struct mesh_path {
 	enum mesh_path_flags flags;
 	spinlock_t state_lock;
 	u8 rann_snd_addr[ETH_ALEN];
+	u32 rann_metric;
 	bool is_root;
 	bool is_gate;
 };
diff --git a/net/mac80211/mesh_hwmp.c b/net/mac80211/mesh_hwmp.c
index f80a9e3..a80da37 100644
--- a/net/mac80211/mesh_hwmp.c
+++ b/net/mac80211/mesh_hwmp.c
@@ -86,8 +86,8 @@ static inline u32 u16_field_get(u8 *preq_elem, int offset, bool ae)
 #define PERR_IE_TARGET_RCODE(x)	u16_field_get(x, 13, 0)
 
 #define MSEC_TO_TU(x) (x*1000/1024)
-#define SN_GT(x, y) ((long) (y) - (long) (x) < 0)
-#define SN_LT(x, y) ((long) (x) - (long) (y) < 0)
+#define SN_GT(x, y) ((s32)(y - x) < 0)
+#define SN_LT(x, y) ((s32)(x - y) < 0)
 
 #define net_traversal_jiffies(s) \
 	msecs_to_jiffies(s->u.mesh.mshcfg.dot11MeshHWMPnetDiameterTraversalTime)
@@ -732,11 +732,12 @@ static void hwmp_rann_frame_process(struct ieee80211_sub_if_data *sdata,
 				struct ieee80211_rann_ie *rann)
 {
 	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
+	struct ieee80211_local *local = sdata->local;
+	struct sta_info *sta;
 	struct mesh_path *mpath;
 	u8 ttl, flags, hopcount;
 	u8 *orig_addr;
-	u32 orig_sn, metric;
-	u32 interval = ifmsh->mshcfg.dot11MeshHWMPRannInterval;
+	u32 orig_sn, metric, metric_txsta, interval;
 	bool root_is_gate;
 
 	ttl = rann->rann_ttl;
@@ -749,6 +750,7 @@ static void hwmp_rann_frame_process(struct ieee80211_sub_if_data *sdata,
 	root_is_gate = !!(flags & RANN_FLAG_IS_GATE);
 	orig_addr = rann->rann_addr;
 	orig_sn = le32_to_cpu(rann->rann_seq);
+	interval = le32_to_cpu(rann->rann_interval);
 	hopcount = rann->rann_hopcount;
 	hopcount++;
 	metric = le32_to_cpu(rann->rann_metric);
@@ -761,6 +763,14 @@ static void hwmp_rann_frame_process(struct ieee80211_sub_if_data *sdata,
 			orig_addr, mgmt->sa, root_is_gate);
 
 	rcu_read_lock();
+	sta = sta_info_get(sdata, mgmt->sa);
+	if (!sta) {
+		rcu_read_unlock();
+		return;
+	}
+
+	metric_txsta = airtime_link_metric_get(local, sta);
+
 	mpath = mesh_path_lookup(orig_addr, sdata);
 	if (!mpath) {
 		mesh_path_add(orig_addr, sdata);
@@ -780,14 +790,16 @@ static void hwmp_rann_frame_process(struct ieee80211_sub_if_data *sdata,
 		mesh_queue_preq(mpath, PREQ_Q_F_START | PREQ_Q_F_REFRESH);
 	}
 
-	if (mpath->sn < orig_sn && ifmsh->mshcfg.dot11MeshForwarding) {
+	if ((SN_LT(mpath->sn, orig_sn) || (mpath->sn == orig_sn &&
+	   metric < mpath->rann_metric)) && ifmsh->mshcfg.dot11MeshForwarding) {
 		mesh_path_sel_frame_tx(MPATH_RANN, flags, orig_addr,
 				       cpu_to_le32(orig_sn),
 				       0, NULL, 0, broadcast_addr,
 				       hopcount, ttl, cpu_to_le32(interval),
-				       cpu_to_le32(metric + mpath->metric),
+				       cpu_to_le32(metric + metric_txsta),
 				       0, sdata);
 		mpath->sn = orig_sn;
+		mpath->rann_metric = metric + metric_txsta;
 	}
 
 	/* Using individually addressed PREQ for root node */
-- 
1.7.0.4

