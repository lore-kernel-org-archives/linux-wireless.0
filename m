Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c1.cosetrain.com ([213.239.209.213]:50009 "EHLO
	mail.cosetrain.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753286AbZBHTwe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Feb 2009 14:52:34 -0500
From: Florian Sesser <flomaillist@cosetrain.com>
To: linux-wireless@vger.kernel.org
Cc: Florian Sesser <flomaillist@cosetrain.com>
Subject: [PATCH 1/3] mac80211: Modularize Mesh path selection protocol
Date: Sun,  8 Feb 2009 20:52:20 +0100
Message-Id: <31341041c003f9a10f7ef791dc74748c0ba6b46f.1234118418.git.flomaillist@cosetrain.com> (sfid-20090208_205239_665709_8D4CC408)
In-Reply-To: <498F36B7.40806@cosetrain.com>
References: <498F36B7.40806@cosetrain.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Mesh path selection protocols should be exchangeable.
This patch includes the infrastructure needed to
enable path selection protocols to register themselves
to later be (at the moment:) manually configured for
a specific mesh device.

 * Moved enum mpath_frame_type and macro max_preq_retries(s)
   to mesh.h (from mesh_hwmp.c)

 * Moved mesh_path_timer() and ieee80211_mesh_path_timer()
   to mesh_path.c (from mesh.c)

 * New EXPORT_SYMBOLS:
   ieee80211_mesh_path_sel_proto_register,
   ieee80211_mesh_path_sel_proto_unregister,
   mesh_path_timer,
   mesh_path_tx_pending,
   mesh_path_assign_nexthop,
   mesh_path_discard_frame,
   mesh_path_add,
   mesh_path_lookup

Signed-off-by: Florian Sesser <flomaillist@cosetrain.com>
---
 net/mac80211/ieee80211_i.h  |    5 ++
 net/mac80211/mesh.c         |  152 +++++++++++++++++++++++++++++++++++++++----
 net/mac80211/mesh.h         |   64 +++++++++++++++++-
 net/mac80211/mesh_hwmp.c    |   68 +++++++++----------
 net/mac80211/mesh_pathtbl.c |   55 ++++++++++++++--
 net/mac80211/sta_info.c     |    1 +
 net/mac80211/tx.c           |    5 +-
 net/mac80211/util.c         |    2 +
 8 files changed, 294 insertions(+), 58 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 5a1f19a..8daf6a4 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -365,6 +365,8 @@ struct ieee80211_if_mesh {
 	u8 mesh_pm_id[4];
 	/* Congestion Control Mode Identifier */
 	u8 mesh_cc_id[4];
+	/* Active Path Selection Protocol */
+	struct mesh_path_sel_proto *mesh_pp;
 	/* Local mesh Destination Sequence Number */
 	u32 dsn;
 	/* Last used PREQ ID */
@@ -534,6 +536,9 @@ struct ieee80211_sub_if_data {
 		struct dentry *dot11MeshHWMPmaxPREQretries;
 		struct dentry *path_refresh_time;
 		struct dentry *min_discovery_timeout;
+		struct dentry *mesh_path_selection_protocol_id;
+		struct dentry *mesh_path_selection_metric_id;
+		struct dentry *mesh_congestion_mode_control_id;
 	} mesh_config;
 #endif
 
diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index 8a1fcae..464b3b4 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -9,6 +9,7 @@
  */
 
 #include <asm/unaligned.h>
+#include <linux/module.h>
 #include "ieee80211_i.h"
 #include "mesh.h"
 
@@ -23,6 +24,8 @@
 
 int mesh_allocated;
 static struct kmem_cache *rm_cache;
+static DEFINE_SPINLOCK(path_sel_list_lock);
+static LIST_HEAD(mesh_path_sel_proto_list);
 
 void ieee80211s_init(void)
 {
@@ -30,6 +33,8 @@ void ieee80211s_init(void)
 	mesh_allocated = 1;
 	rm_cache = kmem_cache_create("mesh_rmc", sizeof(struct rmc_entry),
 				     0, 0, NULL);
+	if (!(ieee80211_mesh_path_sel_proto_find(0x000FACFF)))
+		ieee80211_mesh_path_sel_proto_register(&mesh_path_sel_hwmp);
 }
 
 void ieee80211s_stop(void)
@@ -112,14 +117,126 @@ void mesh_accept_plinks_update(struct ieee80211_sub_if_data *sdata)
 		ieee80211_mesh_housekeeping_timer((unsigned long) sdata);
 }
 
+struct mesh_path_sel_proto *ieee80211_mesh_path_sel_proto_find(u32 id)
+{
+	struct mesh_path_sel_proto *a;
+	list_for_each_entry(a, &mesh_path_sel_proto_list, list) {
+		if (a->id == id)
+			return a;
+	}
+	return NULL;
+}
+
+void ieee80211_mesh_path_sel_proto_set(struct ieee80211_if_mesh *sta,
+				struct mesh_path_sel_proto *algo)
+{
+	/* first, check if algo has been properly registered */
+	if (ieee80211_mesh_path_sel_proto_find(algo->id)) {
+		if (!sta->mesh_pp) {
+			/* set all three locations: */
+			/* connects an interface to its mesh pp algo */
+			sta->mesh_pp = algo;
+			/* used to compare meshes (see mesh_matches_local) */
+			memcpy(sta->mesh_pp_id, &(algo->id), 4);
+			/* used by the nl80211 layer */
+			sta->mshcfg.mesh_path_selection_protocol_id = algo->id;
+
+			printk(KERN_INFO "o11s: Initial mesh path selection "
+				"algorithm %s / %08X\n", algo->name, algo->id);
+			return;
+		}
+
+		if (sta->mesh_pp == algo) {
+			printk(KERN_INFO "o11s: Mesh path selection algorithm "
+				"%s / %08X already active\n", algo->name,
+				algo->id);
+			return;
+		}
+
+		printk(KERN_INFO "o11s: Stopping mesh path selection algorithm"
+			" %s / %08X\n", sta->mesh_pp->name, sta->mesh_pp->id);
+		sta->mesh_pp->ops->path_sel_stop(sta);
+
+		sta->mesh_pp = algo;
+		memcpy(sta->mesh_pp_id, &algo->id, 4);
+		printk(KERN_INFO "o11s: Chosen mesh path selection algorithm "
+			"%s / %08X\n", sta->mesh_pp->name, sta->mesh_pp->id);
+
+		printk(KERN_INFO "o11s: Starting mesh path selection algorithm"
+			" %s / %08X\n", sta->mesh_pp->name, sta->mesh_pp->id);
+		sta->mesh_pp->ops->path_sel_start(sta);
+	}
+}
+
+void ieee80211_mesh_path_sel_proto_register(struct mesh_path_sel_proto *algo)
+{
+	/* Sanity checks */
+	BUG_ON(!algo->ops->path_start_discovery);
+	BUG_ON(!algo->ops->nexthop_lookup);
+	BUG_ON(!algo->ops->path_error_tx);
+	BUG_ON(!algo->ops->queue_preq);
+	BUG_ON(!algo->ops->rx_path_sel_frame);
+	BUG_ON(!algo->ops->path_sel_start);
+	BUG_ON(!algo->ops->path_sel_stop);
+
+	spin_lock(&path_sel_list_lock);
+	if (!ieee80211_mesh_path_sel_proto_find(algo->id)) {
+		list_add_tail(&algo->list, &mesh_path_sel_proto_list);
+		spin_unlock(&path_sel_list_lock);
+		printk(KERN_INFO "o11s: Mesh path selection algorithm %s / "
+			"%08X registered\n", algo->name, algo->id);
+	} else {
+		spin_unlock(&path_sel_list_lock);
+		printk(KERN_WARNING "o11s: Error: Path selection algorithm "
+			"%s / %08X already registered\n", algo->name,
+			algo->id);
+	}
+}
+EXPORT_SYMBOL(ieee80211_mesh_path_sel_proto_register);
+
+void ieee80211_mesh_path_sel_proto_unregister(struct mesh_path_sel_proto *algo)
+{
+	if (ieee80211_mesh_path_sel_proto_find(algo->id)) {
+		list_del(&algo->list);
+		printk(KERN_INFO "o11s: Mesh path selection algorithm %s / "
+			"%08X unregistered\n", algo->name, algo->id);
+	} else {
+		printk(KERN_WARNING "o11s: Error: Mesh path selection algorithm"
+			" %s / %08X not found\n", algo->name, algo->id);
+	}
+}
+EXPORT_SYMBOL(ieee80211_mesh_path_sel_proto_unregister);
+
 void mesh_ids_set_default(struct ieee80211_if_mesh *sta)
 {
-	u8 def_id[4] = {0x00, 0x0F, 0xAC, 0xff};
+	u8 def_id[4] = {0x00, 0x0F, 0xAC, 0xFF};
 
 	memcpy(sta->mesh_pp_id, def_id, 4);
 	memcpy(sta->mesh_pm_id, def_id, 4);
 	memcpy(sta->mesh_cc_id, def_id, 4);
 }
+/* Set path selection protocol ID: OUI followed by arbitrary 2 bytes */
+void mesh_ids_set_pp(struct ieee80211_if_mesh *sta, u32 pp)
+{
+	struct mesh_path_sel_proto *nalgo =
+		ieee80211_mesh_path_sel_proto_find(pp);
+
+	if (nalgo)
+		ieee80211_mesh_path_sel_proto_set(sta, nalgo);
+	else
+		printk(KERN_WARNING "o11s: Could not find mesh path selection "
+			"protocol with ID %08X\n", pp);
+}
+/* Set path selection metric ID: OUI followed by arbitrary 2 bytes */
+void mesh_ids_set_pm(struct ieee80211_if_mesh *sta, u32 pm)
+{
+	memcpy(sta->mesh_pm_id, &pm, 4);
+}
+/* Set congestion control mode ID: OUI followed by arbitrary 2 bytes */
+void mesh_ids_set_cc(struct ieee80211_if_mesh *sta, u32 cc)
+{
+	memcpy(sta->mesh_cc_id, &cc, 4);
+}
 
 int mesh_rmc_init(struct ieee80211_sub_if_data *sdata)
 {
@@ -246,7 +363,7 @@ void mesh_mgmt_ies_add(struct sk_buff *skb, struct ieee80211_sub_if_data *sdata)
 	memcpy(pos, sdata->u.mesh.mesh_pp_id, 4);
 	pos += 4;
 
-	/* Active path selection metric ID   */
+	/* Active path selection metric ID */
 	memcpy(pos, sdata->u.mesh.mesh_pm_id, 4);
 	pos += 4;
 
@@ -346,16 +463,6 @@ void mesh_table_free(struct mesh_table *tbl, bool free_leafs)
 	__mesh_table_free(tbl);
 }
 
-static void ieee80211_mesh_path_timer(unsigned long data)
-{
-	struct ieee80211_sub_if_data *sdata =
-		(struct ieee80211_sub_if_data *) data;
-	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
-	struct ieee80211_local *local = sdata->local;
-
-	queue_work(local->hw.workqueue, &ifmsh->work);
-}
-
 struct mesh_table *mesh_table_grow(struct mesh_table *tbl)
 {
 	struct mesh_table *newtbl;
@@ -444,6 +551,16 @@ void ieee80211_start_mesh(struct ieee80211_sub_if_data *sdata)
 	queue_work(local->hw.workqueue, &ifmsh->work);
 	ieee80211_if_config(sdata, IEEE80211_IFCC_BEACON |
 				   IEEE80211_IFCC_BEACON_ENABLED);
+
+	/* If no PS protocol has manually been set, go with the default */
+	if (!ifmsh->mesh_pp)
+		ifmsh->mesh_pp = ieee80211_mesh_path_sel_proto_find
+			(0x000FACFF);
+	/* If we still have no PS Proto, bail out */
+	if (!ifmsh->mesh_pp) {
+		printk(KERN_WARNING "o11s: Could not load HWMP, aborting\n");
+		ieee80211_stop_mesh(sdata);
+	}
 }
 
 void ieee80211_stop_mesh(struct ieee80211_sub_if_data *sdata)
@@ -523,7 +640,8 @@ static void ieee80211_mesh_rx_mgmt_action(struct ieee80211_sub_if_data *sdata,
 		mesh_rx_plink_frame(sdata, mgmt, len, rx_status);
 		break;
 	case MESH_PATH_SEL_CATEGORY:
-		mesh_rx_path_sel_frame(sdata, mgmt, len);
+		sdata->u.mesh.mesh_pp->ops->
+			rx_path_sel_frame(sdata, mgmt, len);
 		break;
 	}
 }
@@ -576,7 +694,7 @@ static void ieee80211_mesh_work(struct work_struct *work)
 	if (ifmsh->preq_queue_len &&
 	    time_after(jiffies,
 		       ifmsh->last_preq + msecs_to_jiffies(ifmsh->mshcfg.dot11MeshHWMPpreqMinInterval)))
-		mesh_path_start_discovery(sdata);
+		ifmsh->mesh_pp->ops->path_start_discovery(sdata);
 
 	if (ifmsh->housekeeping)
 		ieee80211_mesh_housekeeping(sdata, ifmsh);
@@ -617,6 +735,12 @@ void ieee80211_mesh_init_sdata(struct ieee80211_sub_if_data *sdata)
 		MESH_PREQ_MIN_INT;
 	ifmsh->mshcfg.dot11MeshHWMPnetDiameterTraversalTime =
 		MESH_DIAM_TRAVERSAL_TIME;
+	ifmsh->mshcfg.mesh_path_selection_protocol_id =
+		MESH_PATH_SELECTION_PROTOCOL_ID;
+	ifmsh->mshcfg.mesh_path_selection_metric_id =
+		MESH_PATH_SELECTION_METRIC_ID;
+	ifmsh->mshcfg.mesh_congestion_control_mode_id =
+		MESH_CONGESTION_CONTROL_MODE_ID;
 	ifmsh->mshcfg.dot11MeshHWMPmaxPREQretries =
 		MESH_MAX_PREQ_RETRIES;
 	ifmsh->mshcfg.path_refresh_time =
diff --git a/net/mac80211/mesh.h b/net/mac80211/mesh.h
index 9e064ee..714912b 100644
--- a/net/mac80211/mesh.h
+++ b/net/mac80211/mesh.h
@@ -169,6 +169,57 @@ struct mesh_rmc {
  */
 #define MESH_PREQ_MIN_INT	10
 #define MESH_DIAM_TRAVERSAL_TIME 50
+
+/* Default Path Selection, Path Metric, Congestion Control Mode */
+#define MESH_PATH_SELECTION_PROTOCOL_ID 0x000FACFF
+#define MESH_PATH_SELECTION_METRIC_ID 0x000FACFF
+#define MESH_CONGESTION_CONTROL_MODE_ID 0x000FACFF
+
+enum mpath_frame_type {
+	MPATH_PREQ = 0,
+	MPATH_PREP,
+	MPATH_PERR
+};
+
+/**
+  * struct mesh_path_sel_ops - Mesh Path Selection Protocol function pointers
+  *
+  * @path_start_discovery: Launch a path discovery from the PREQ queue
+  * @nexthop_lookup: Put the appropriate next hop on a mesh frame
+  * @queue_preq: Queue a PREQ to a given destination
+  * @path_error_tx: Sends a PERR mesh management frame
+  * @rx_path_sel_frame: Receive a path selection protocol management frame
+  * @path_sel_start: Init mesh path selection protocol callback
+  * @path_sel_stop: Exit mesh path selection protocol callback
+  *
+  * This resembles the main part of the mesh path selection protocol
+  * abstracion layer. Every new PS protocol has to define every member.
+  */
+struct mesh_path_sel_ops {
+	void (*path_start_discovery) (struct ieee80211_sub_if_data *sdata);
+	int (*nexthop_lookup) (struct sk_buff *skb,
+		struct ieee80211_sub_if_data *sdata);
+	void (*queue_preq) (struct mesh_path *mpath, u8 flags);
+	int (*path_error_tx) (u8 *dst, __le32 dst_dsn, u8 *ra,
+		struct ieee80211_sub_if_data *sdata);
+	void (*rx_path_sel_frame) (struct ieee80211_sub_if_data *sdata,
+		struct ieee80211_mgmt *mgmt, size_t len);
+	void (*path_sel_start) (struct ieee80211_if_mesh *sta);
+	void (*path_sel_stop) (struct ieee80211_if_mesh *sta);
+};
+
+#define MESH_ALGO_NAME_MAX    (16)
+struct mesh_path_sel_proto {
+	struct list_head list;
+	char name[MESH_ALGO_NAME_MAX];
+	u32 id;
+	struct mesh_path_sel_ops *ops;
+	struct module *owner;
+};
+
+void ieee80211_mesh_path_sel_proto_register(struct mesh_path_sel_proto *algo);
+void ieee80211_mesh_path_sel_proto_unregister(struct mesh_path_sel_proto *algo);
+
 /* Paths will be refreshed if they are closer than PATH_REFRESH_TIME to their
  * expiration
  */
@@ -205,6 +256,9 @@ int mesh_rmc_check(u8 *addr, struct ieee80211s_hdr *mesh_hdr,
 bool mesh_matches_local(struct ieee802_11_elems *ie,
 		struct ieee80211_sub_if_data *sdata);
 void mesh_ids_set_default(struct ieee80211_if_mesh *mesh);
+void mesh_ids_set_pp(struct ieee80211_if_mesh *sta, u32 pp);
+void mesh_ids_set_pm(struct ieee80211_if_mesh *sta, u32 pm);
+void mesh_ids_set_cc(struct ieee80211_if_mesh *sta, u32 cc);
 void mesh_mgmt_ies_add(struct sk_buff *skb,
 		struct ieee80211_sub_if_data *sdata);
 void mesh_rmc_free(struct ieee80211_sub_if_data *sdata);
@@ -219,9 +273,9 @@ void ieee80211_start_mesh(struct ieee80211_sub_if_data *sdata);
 void ieee80211_stop_mesh(struct ieee80211_sub_if_data *sdata);
 
 /* Mesh paths */
-int mesh_nexthop_lookup(struct sk_buff *skb,
-		struct ieee80211_sub_if_data *sdata);
-void mesh_path_start_discovery(struct ieee80211_sub_if_data *sdata);
+struct mesh_path_sel_proto *ieee80211_mesh_path_sel_proto_find(u32 id);
+void ieee80211_mesh_path_sel_proto_set(struct ieee80211_if_mesh *sta,
+				struct mesh_path_sel_proto *algo);
 struct mesh_path *mesh_path_lookup(u8 *dst,
 		struct ieee80211_sub_if_data *sdata);
 struct mesh_path *mpp_path_lookup(u8 *dst,
@@ -264,6 +318,7 @@ void mesh_path_tx_pending(struct mesh_path *mpath);
 int mesh_pathtbl_init(void);
 void mesh_pathtbl_unregister(void);
 int mesh_path_del(u8 *addr, struct ieee80211_sub_if_data *sdata);
+void ieee80211_mesh_path_timer(unsigned long data);
 void mesh_path_timer(unsigned long data);
 void mesh_path_flush_by_nexthop(struct sta_info *sta);
 void mesh_path_discard_frame(struct sk_buff *skb,
@@ -271,6 +326,7 @@ void mesh_path_discard_frame(struct sk_buff *skb,
 
 #ifdef CONFIG_MAC80211_MESH
 extern int mesh_allocated;
+extern struct mesh_path_sel_proto mesh_path_sel_hwmp;
 
 static inline int mesh_plink_free_count(struct ieee80211_sub_if_data *sdata)
 {
@@ -293,6 +349,8 @@ static inline void mesh_path_activate(struct mesh_path *mpath)
 	for (i = 0; i <= x->hash_mask; i++) \
 		hlist_for_each_entry_rcu(node, p, &x->hash_buckets[i], list)
 
+#define max_preq_retries(s) (s->u.mesh.mshcfg.dot11MeshHWMPmaxPREQretries)
+
 void ieee80211_mesh_notify_scan_completed(struct ieee80211_local *local);
 
 #else
diff --git a/net/mac80211/mesh_hwmp.c b/net/mac80211/mesh_hwmp.c
index 4f862b2..1b165e4 100644
--- a/net/mac80211/mesh_hwmp.c
+++ b/net/mac80211/mesh_hwmp.c
@@ -7,12 +7,17 @@
  * published by the Free Software Foundation.
  */
 
+#include <linux/module.h>
+#include <net/mac80211.h>
+#include "ieee80211_i.h"
 #include "mesh.h"
 
 #define TEST_FRAME_LEN	8192
 #define MAX_METRIC	0xffffffff
 #define ARITH_SHIFT	8
 
+struct mesh_path_sel_proto mesh_path_sel_hwmp;
+
 /* Number of frames buffered per destination for unresolved destinations */
 #define MESH_FRAME_QUEUE_LEN	10
 #define MAX_PREQ_QUEUE_LEN	64
@@ -69,16 +74,9 @@ static inline u32 u32_field_get(u8 *preq_elem, int offset, bool ae)
 	MSEC_TO_TU(s->u.mesh.mshcfg.dot11MeshHWMPactivePathTimeout)
 #define min_preq_int_jiff(s) \
 	(msecs_to_jiffies(s->u.mesh.mshcfg.dot11MeshHWMPpreqMinInterval))
-#define max_preq_retries(s) (s->u.mesh.mshcfg.dot11MeshHWMPmaxPREQretries)
 #define disc_timeout_jiff(s) \
 	msecs_to_jiffies(sdata->u.mesh.mshcfg.min_discovery_timeout)
 
-enum mpath_frame_type {
-	MPATH_PREQ = 0,
-	MPATH_PREP,
-	MPATH_PERR
-};
-
 static int mesh_path_sel_frame_tx(enum mpath_frame_type action, u8 flags,
 		u8 *orig_addr, __le32 orig_dsn, u8 dst_flags, u8 *dst,
 		__le32 dst_dsn, u8 *da, u8 hop_count, u8 ttl, __le32 lifetime,
@@ -679,7 +677,7 @@ static void mesh_queue_preq(struct mesh_path *mpath, u8 flags)
  *
  * @sdata: local mesh subif
  */
-void mesh_path_start_discovery(struct ieee80211_sub_if_data *sdata)
+static void mesh_path_start_discovery(struct ieee80211_sub_if_data *sdata)
 {
 	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
 	struct mesh_preq_queue *preq_node;
@@ -769,7 +767,7 @@ enddiscovery:
  * sent when the path is resolved. This means the caller must not free the skb
  * in this case.
  */
-int mesh_nexthop_lookup(struct sk_buff *skb,
+static int mesh_nexthop_lookup(struct sk_buff *skb,
 			struct ieee80211_sub_if_data *sdata)
 {
 	struct sk_buff *skb_to_free = NULL;
@@ -827,32 +825,32 @@ endlookup:
 	return err;
 }
 
-void mesh_path_timer(unsigned long data)
+static void hwmp_start(struct ieee80211_if_mesh *sta)
 {
-	struct ieee80211_sub_if_data *sdata;
-	struct mesh_path *mpath;
-
-	rcu_read_lock();
-	mpath = (struct mesh_path *) data;
-	mpath = rcu_dereference(mpath);
-	if (!mpath)
-		goto endmpathtimer;
-	spin_lock_bh(&mpath->state_lock);
-	sdata = mpath->sdata;
-	if (mpath->flags & MESH_PATH_RESOLVED ||
-			(!(mpath->flags & MESH_PATH_RESOLVING)))
-		mpath->flags &= ~(MESH_PATH_RESOLVING | MESH_PATH_RESOLVED);
-	else if (mpath->discovery_retries < max_preq_retries(sdata)) {
-		++mpath->discovery_retries;
-		mpath->discovery_timeout *= 2;
-		mesh_queue_preq(mpath, 0);
-	} else {
-		mpath->flags = 0;
-		mpath->exp_time = jiffies;
-		mesh_path_flush_pending(mpath);
-	}
+	/* init variables etc */
+	ieee80211_mesh_path_sel_proto_register(&mesh_path_sel_hwmp);
+	printk(KERN_INFO "hwmp_start routine called\n");
+}
 
-	spin_unlock_bh(&mpath->state_lock);
-endmpathtimer:
-	rcu_read_unlock();
+static void hwmp_stop(struct ieee80211_if_mesh *sta)
+{
+	/* finish, clean up */
 }
+
+struct mesh_path_sel_ops mesh_path_sel_hwmp_ops = {
+		.path_start_discovery = mesh_path_start_discovery,
+		.nexthop_lookup = mesh_nexthop_lookup,
+		.path_error_tx = mesh_path_error_tx,
+		.queue_preq = mesh_queue_preq,
+		.rx_path_sel_frame = mesh_rx_path_sel_frame,
+		.path_sel_start = hwmp_start,
+		.path_sel_stop = hwmp_stop,
+};
+
+struct mesh_path_sel_proto mesh_path_sel_hwmp = {
+	.name = "mesh_hwmp",
+	.id = 0x000FACFF,
+	.ops = &mesh_path_sel_hwmp_ops,
+	.owner = THIS_MODULE,
+};
+
diff --git a/net/mac80211/mesh_pathtbl.c b/net/mac80211/mesh_pathtbl.c
index 3c72557..f8a795f 100644
--- a/net/mac80211/mesh_pathtbl.c
+++ b/net/mac80211/mesh_pathtbl.c
@@ -26,7 +26,7 @@
 				time_after(jiffies, mpath->exp_time) && \
 				!(mpath->flags & MESH_PATH_FIXED))
 
-struct mpath_node {
+		struct mpath_node {
 	struct hlist_node list;
 	struct rcu_head rcu;
 	/* This indirection allows two different tables to point to the same
@@ -57,7 +57,7 @@ void mesh_path_assign_nexthop(struct mesh_path *mpath, struct sta_info *sta)
 {
 	rcu_assign_pointer(mpath->next_hop, sta);
 }
-
+EXPORT_SYMBOL(mesh_path_assign_nexthop);
 
 /**
  * mesh_path_lookup - look up a path in the mesh path table
@@ -94,6 +94,7 @@ struct mesh_path *mesh_path_lookup(u8 *dst, struct ieee80211_sub_if_data *sdata)
 	}
 	return NULL;
 }
+EXPORT_SYMBOL(mesh_path_lookup);
 
 struct mesh_path *mpp_path_lookup(u8 *dst, struct ieee80211_sub_if_data *sdata)
 {
@@ -253,7 +254,7 @@ err_path_alloc:
 	atomic_dec(&sdata->u.mesh.mpaths);
 	return err;
 }
-
+EXPORT_SYMBOL(mesh_path_add);
 
 int mpp_path_add(u8 *dst, u8 *mpp, struct ieee80211_sub_if_data *sdata)
 {
@@ -366,7 +367,7 @@ void mesh_plink_broken(struct sta_info *sta)
 			mpath->flags &= ~MESH_PATH_ACTIVE;
 			++mpath->dsn;
 			spin_unlock_bh(&mpath->state_lock);
-			mesh_path_error_tx(mpath->dst,
+			sdata->u.mesh.mesh_pp->ops->path_error_tx(mpath->dst,
 					cpu_to_le32(mpath->dsn),
 					sdata->dev->broadcast, sdata);
 		} else
@@ -484,6 +485,7 @@ void mesh_path_tx_pending(struct mesh_path *mpath)
 			(mpath->flags & MESH_PATH_ACTIVE))
 		dev_queue_xmit(skb);
 }
+EXPORT_SYMBOL(mesh_path_tx_pending);
 
 /**
  * mesh_path_discard_frame - discard a frame whose path could not be resolved
@@ -511,12 +513,14 @@ void mesh_path_discard_frame(struct sk_buff *skb,
 		mpath = mesh_path_lookup(da, sdata);
 		if (mpath)
 			dsn = ++mpath->dsn;
-		mesh_path_error_tx(skb->data, cpu_to_le32(dsn), ra, sdata);
+		sdata->u.mesh.mesh_pp->ops->path_error_tx
+			(skb->data, cpu_to_le32(dsn), ra, sdata);
 	}
 
 	kfree_skb(skb);
 	sdata->u.mesh.mshstats.dropped_frames_no_route++;
 }
+EXPORT_SYMBOL(mesh_path_discard_frame);
 
 /**
  * mesh_path_flush_pending - free the pending queue of a mesh path
@@ -637,3 +641,44 @@ void mesh_pathtbl_unregister(void)
 	mesh_table_free(mesh_paths, true);
 	mesh_table_free(mpp_paths, true);
 }
+
+void ieee80211_mesh_path_timer(unsigned long data)
+{
+	struct ieee80211_sub_if_data *sdata =
+		(struct ieee80211_sub_if_data *) data;
+	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
+	struct ieee80211_local *local = sdata->local;
+
+	queue_work(local->hw.workqueue, &ifmsh->work);
+}
+
+void mesh_path_timer(unsigned long data)
+{
+	struct ieee80211_sub_if_data *sdata;
+	struct mesh_path *mpath;
+
+	rcu_read_lock();
+	mpath = (struct mesh_path *) data;
+	mpath = rcu_dereference(mpath);
+	if (!mpath)
+		goto endmpathtimer;
+	spin_lock_bh(&mpath->state_lock);
+	sdata = mpath->sdata;
+	if (mpath->flags & MESH_PATH_RESOLVED ||
+			(!(mpath->flags & MESH_PATH_RESOLVING)))
+		mpath->flags &= ~(MESH_PATH_RESOLVING | MESH_PATH_RESOLVED);
+	else if (mpath->discovery_retries < max_preq_retries(sdata)) {
+		++mpath->discovery_retries;
+		mpath->discovery_timeout *= 2;
+		sdata->u.mesh.mesh_pp->ops->queue_preq(mpath, 0);
+	} else {
+		mpath->flags = 0;
+		mpath->exp_time = jiffies;
+		mesh_path_flush_pending(mpath);
+	}
+
+	spin_unlock_bh(&mpath->state_lock);
+endmpathtimer:
+	rcu_read_unlock();
+}
+EXPORT_SYMBOL(mesh_path_timer);
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 10c5539..b10d754 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -105,6 +105,7 @@ struct sta_info *sta_info_get(struct ieee80211_local *local, const u8 *addr)
 	}
 	return sta;
 }
+EXPORT_SYMBOL(sta_info_get);
 
 struct sta_info *sta_info_get_by_idx(struct ieee80211_local *local, int idx,
 				     struct net_device *dev)
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index f1c726d..97dde64 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1351,11 +1351,14 @@ int ieee80211_master_start_xmit(struct sk_buff *skb, struct net_device *dev)
 	    ieee80211_is_data(hdr->frame_control)) {
 		if (is_multicast_ether_addr(hdr->addr3))
 			memcpy(hdr->addr1, hdr->addr3, ETH_ALEN);
+#ifdef CONFIG_MAC80211_MESH
 		else
-			if (mesh_nexthop_lookup(skb, osdata)) {
+			if (osdata->u.mesh.mesh_pp->ops->
+				nexthop_lookup(skb, osdata)) {
 				dev_put(odev);
 				return 0;
 			}
+#endif
 		if (memcmp(odev->dev_addr, hdr->addr4, ETH_ALEN) != 0)
 			IEEE80211_IFSTA_MESH_CTR_INC(&osdata->u.mesh,
 							    fwded_frames);
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 73c7d73..c579606 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -674,6 +674,7 @@ void ieee802_11_parse_elems(u8 *start, size_t len,
 		pos += elen;
 	}
 }
+EXPORT_SYMBOL(ieee802_11_parse_elems);
 
 void ieee80211_set_wmm_default(struct ieee80211_sub_if_data *sdata)
 {
@@ -714,6 +715,7 @@ void ieee80211_tx_skb(struct ieee80211_sub_if_data *sdata, struct sk_buff *skb,
 
 	dev_queue_xmit(skb);
 }
+EXPORT_SYMBOL(ieee80211_tx_skb);
 
 int ieee80211_set_freq(struct ieee80211_sub_if_data *sdata, int freqMHz)
 {
-- 
1.5.6.5

