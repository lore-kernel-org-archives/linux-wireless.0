Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c1.cosetrain.com ([213.239.209.213]:40887 "EHLO
	mail.cosetrain.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751768AbZAZUjS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Jan 2009 15:39:18 -0500
From: Florian Sesser <flomaillist@cosetrain.com>
To: linux-wireless@vger.kernel.org
Cc: Florian Sesser <flomaillist@cosetrain.com>
Subject: [PATCH 1/6] mac80211: Virtualize mesh path selection ops
Date: Mon, 26 Jan 2009 21:39:10 +0100
Message-Id: <abd4234c03d59a65d3eb9259821d705899a08612.1233001802.git.flomaillist@cosetrain.com> (sfid-20090126_213923_880048_39A8C833)
In-Reply-To: <497E1B90.4060803@cosetrain.com>
References: <497E1B90.4060803@cosetrain.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Struct mesh_path_sel_ops, central to the abstraction
of the Path Selection Protocol.

Signed-off-by: Florian Sesser <flomaillist@cosetrain.com>
---
 net/mac80211/mesh.h |   78 +++++++++++++++++++++++++++++++++++++++++++++++++--
 1 files changed, 75 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/mesh.h b/net/mac80211/mesh.h
index 9e064ee..a4141d8 100644
--- a/net/mac80211/mesh.h
+++ b/net/mac80211/mesh.h
@@ -169,6 +169,72 @@ struct mesh_rmc {
  */
 #define MESH_PREQ_MIN_INT	10
 #define MESH_DIAM_TRAVERSAL_TIME 50
+
+/* Default Path Selection, Path Metric, Congestion Control Mode */
+#define MESH_PATH_SELECTION_PROTOCOL_ID 0x000FACFF
+#define MESH_PATH_SELECTION_METRIC_ID 0x000FACFF
+#define MESH_CONGESTION_CONTROL_MODE_ID 0x000FACFF
+
+/* From mesh_hwmp.c: */
+enum mpath_frame_type {
+	MPATH_PREQ = 0,
+	MPATH_PREP,
+	MPATH_PERR
+};
+/* Function pointer typedefs for struct mesh_path_sel_ops */
+typedef void (mesh_path_start_discovery_fn) (struct ieee80211_sub_if_data *sdata);
+typedef int (mesh_nexthop_lookup_fn) (struct sk_buff *skb, struct ieee80211_sub_if_data *sdata);
+typedef void (mesh_queue_preq_fn) (struct mesh_path *mpath, u8 flags);
+typedef int (mesh_path_sel_frame_tx_fn) (enum mpath_frame_type action, u8 flags,
+		u8 *orig_addr, __le32 orig_dsn, u8 dst_flags, u8 *dst, __le32 dst_dsn, u8 *da,
+		u8 hop_count, u8 ttl, __le32 lifetime, __le32 metric, __le32 preq_id,
+		struct ieee80211_sub_if_data *sdata);
+typedef int (mesh_path_error_tx_fn) (u8 *dst, __le32 dst_dsn, u8 *ra,
+		struct ieee80211_sub_if_data *sdata);
+typedef void (mesh_path_timer_fn) (unsigned long data);
+typedef u32 (mesh_route_info_get_fn) (struct ieee80211_sub_if_data *sdata,
+		struct ieee80211_mgmt *mgmt, u8 *ie);
+typedef void (mesh_rx_path_sel_frame_fn) (struct ieee80211_sub_if_data *sdata,
+		struct ieee80211_mgmt *mgmt, size_t len);
+typedef void (mesh_preq_frame_process_fn) (struct ieee80211_sub_if_data *sdata,
+		struct ieee80211_mgmt *mgmt, u8 *preq_elem, u32 metric);
+typedef void (mesh_prep_frame_process_fn) (struct ieee80211_sub_if_data *sdata,
+		struct ieee80211_mgmt *mgmt, u8 *prep_elem, u32 metric);
+typedef void (mesh_perr_frame_process_fn) (struct ieee80211_sub_if_data *sdata,
+		struct ieee80211_mgmt *mgmt, u8 *perr_elem);
+typedef void (mesh_path_sel_start_fn) (struct ieee80211_if_mesh *sta);
+typedef void (mesh_path_sel_stop_fn) (struct ieee80211_if_mesh *sta);
+struct mesh_path_sel_ops {
+	mesh_path_start_discovery_fn *path_start_discovery_fn;
+	mesh_nexthop_lookup_fn *nexthop_lookup_fn;
+	/* Needed by mesh_path_timer from mesh_pathtbl.c */
+	mesh_queue_preq_fn *queue_preq_fn;
+	/* To my surprise this seems to not be needed:
+	mesh_path_sel_frame_tx_fn *path_sel_frame_tx_fn; */
+	mesh_path_error_tx_fn *path_error_tx_fn;
+	/* Doesn't this timer belong into mesh.c? */
+	mesh_path_timer_fn *path_timer_fn;
+	mesh_rx_path_sel_frame_fn *rx_path_sel_frame_fn;
+	/* Belongs into the mesh routing protocol module
+	mesh_preq_frame_process_fn *preq_frame_process_fn;
+	mesh_prep_frame_process_fn *prep_frame_process_fn;
+	mesh_perr_frame_process_fn *perr_frame_process_fn; */
+	mesh_path_sel_start_fn *path_sel_start_fn;
+	mesh_path_sel_stop_fn *path_sel_stop_fn;
+};
+
+#define MESH_ALGO_NAME_MAX    (16)
+struct mesh_path_sel_algo {
+	struct list_head list;
+	char name[MESH_ALGO_NAME_MAX];
+	u32 id;
+	struct mesh_path_sel_ops* ops;
+	struct module* owner;
+};
+
+void mesh_path_sel_algo_register (struct mesh_path_sel_algo *algo);
+void mesh_path_sel_algo_unregister (struct mesh_path_sel_algo *algo);
+
 /* Paths will be refreshed if they are closer than PATH_REFRESH_TIME to their
  * expiration
  */
@@ -205,6 +271,9 @@ int mesh_rmc_check(u8 *addr, struct ieee80211s_hdr *mesh_hdr,
 bool mesh_matches_local(struct ieee802_11_elems *ie,
 		struct ieee80211_sub_if_data *sdata);
 void mesh_ids_set_default(struct ieee80211_if_mesh *mesh);
+void mesh_ids_set_pp(struct ieee80211_if_mesh *sta, u32 pp);
+void mesh_ids_set_pm(struct ieee80211_if_mesh *sta, u32 pm);
+void mesh_ids_set_cc(struct ieee80211_if_mesh *sta, u32 cc);
 void mesh_mgmt_ies_add(struct sk_buff *skb,
 		struct ieee80211_sub_if_data *sdata);
 void mesh_rmc_free(struct ieee80211_sub_if_data *sdata);
@@ -219,9 +288,9 @@ void ieee80211_start_mesh(struct ieee80211_sub_if_data *sdata);
 void ieee80211_stop_mesh(struct ieee80211_sub_if_data *sdata);
 
 /* Mesh paths */
-int mesh_nexthop_lookup(struct sk_buff *skb,
-		struct ieee80211_sub_if_data *sdata);
-void mesh_path_start_discovery(struct ieee80211_sub_if_data *sdata);
+struct mesh_path_sel_algo* mesh_path_sel_algo_find_by_name (const char* name);
+struct mesh_path_sel_algo* mesh_path_sel_algo_find_by_id (u32 id);
+void mesh_path_sel_algo_set (struct ieee80211_if_mesh *sta, struct mesh_path_sel_algo* algo);
 struct mesh_path *mesh_path_lookup(u8 *dst,
 		struct ieee80211_sub_if_data *sdata);
 struct mesh_path *mpp_path_lookup(u8 *dst,
@@ -293,6 +362,9 @@ static inline void mesh_path_activate(struct mesh_path *mpath)
 	for (i = 0; i <= x->hash_mask; i++) \
 		hlist_for_each_entry_rcu(node, p, &x->hash_buckets[i], list)
 
+/* Moved here from mesh_hwmp.c */
+#define max_preq_retries(s) (s->u.mesh.mshcfg.dot11MeshHWMPmaxPREQretries)
+
 void ieee80211_mesh_notify_scan_completed(struct ieee80211_local *local);
 
 #else
-- 
1.5.6.5

