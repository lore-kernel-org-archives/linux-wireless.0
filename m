Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:47653 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932092Ab3BLPqW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Feb 2013 10:46:22 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: constify IE parsing
Date: Tue, 12 Feb 2013 16:46:14 +0100
Message-Id: <1360683974-14634-1-git-send-email-johannes@sipsolutions.net> (sfid-20130212_164627_409696_0E554CAA)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Make all the parsed IE pointers const, and propagate
the change to all the users etc.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/linux/ieee80211.h   |  2 +-
 net/mac80211/ht.c           |  2 +-
 net/mac80211/ieee80211_i.h  | 81 +++++++++++++++++++++++----------------------
 net/mac80211/mesh.h         | 11 +++---
 net/mac80211/mesh_hwmp.c    | 42 ++++++++++++-----------
 net/mac80211/mesh_pathtbl.c | 11 +++---
 net/mac80211/mlme.c         |  7 ++--
 net/mac80211/util.c         |  4 +--
 net/mac80211/vht.c          |  9 ++---
 9 files changed, 89 insertions(+), 80 deletions(-)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index 9164c45..49255d2 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -2166,7 +2166,7 @@ static inline unsigned long ieee80211_tu_to_usec(unsigned long tu)
  * @tim_len: length of the TIM IE
  * @aid: the AID to look for
  */
-static inline bool ieee80211_check_tim(struct ieee80211_tim_ie *tim,
+static inline bool ieee80211_check_tim(const struct ieee80211_tim_ie *tim,
 				       u8 tim_len, u16 aid)
 {
 	u8 mask;
diff --git a/net/mac80211/ht.c b/net/mac80211/ht.c
index c7434ee..0db25d4 100644
--- a/net/mac80211/ht.c
+++ b/net/mac80211/ht.c
@@ -94,7 +94,7 @@ void ieee80211_apply_htcap_overrides(struct ieee80211_sub_if_data *sdata,
 
 bool ieee80211_ht_cap_ie_to_sta_ht_cap(struct ieee80211_sub_if_data *sdata,
 				       struct ieee80211_supported_band *sband,
-				       struct ieee80211_ht_cap *ht_cap_ie,
+				       const struct ieee80211_ht_cap *ht_cap_ie,
 				       struct sta_info *sta)
 {
 	struct ieee80211_sta_ht_cap ht_cap;
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index ab19342..1f82abf 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1154,42 +1154,42 @@ struct ieee80211_ra_tid {
 
 /* Parsed Information Elements */
 struct ieee802_11_elems {
-	u8 *ie_start;
+	const u8 *ie_start;
 	size_t total_len;
 
 	/* pointers to IEs */
-	u8 *ssid;
-	u8 *supp_rates;
-	u8 *fh_params;
-	u8 *ds_params;
-	u8 *cf_params;
-	struct ieee80211_tim_ie *tim;
-	u8 *ibss_params;
-	u8 *challenge;
-	u8 *rsn;
-	u8 *erp_info;
-	u8 *ext_supp_rates;
-	u8 *wmm_info;
-	u8 *wmm_param;
-	struct ieee80211_ht_cap *ht_cap_elem;
-	struct ieee80211_ht_operation *ht_operation;
-	struct ieee80211_vht_cap *vht_cap_elem;
-	struct ieee80211_vht_operation *vht_operation;
-	struct ieee80211_meshconf_ie *mesh_config;
-	u8 *mesh_id;
-	u8 *peering;
-	__le16 *awake_window;
-	u8 *preq;
-	u8 *prep;
-	u8 *perr;
-	struct ieee80211_rann_ie *rann;
-	struct ieee80211_channel_sw_ie *ch_switch_ie;
-	struct ieee80211_ext_chansw_ie *ext_chansw_ie;
-	u8 *country_elem;
-	u8 *pwr_constr_elem;
-	u8 *quiet_elem;	/* first quite element */
-	u8 *timeout_int;
-	u8 *opmode_notif;
+	const u8 *ssid;
+	const u8 *supp_rates;
+	const u8 *fh_params;
+	const u8 *ds_params;
+	const u8 *cf_params;
+	const struct ieee80211_tim_ie *tim;
+	const u8 *ibss_params;
+	const u8 *challenge;
+	const u8 *rsn;
+	const u8 *erp_info;
+	const u8 *ext_supp_rates;
+	const u8 *wmm_info;
+	const u8 *wmm_param;
+	const struct ieee80211_ht_cap *ht_cap_elem;
+	const struct ieee80211_ht_operation *ht_operation;
+	const struct ieee80211_vht_cap *vht_cap_elem;
+	const struct ieee80211_vht_operation *vht_operation;
+	const struct ieee80211_meshconf_ie *mesh_config;
+	const u8 *mesh_id;
+	const u8 *peering;
+	const __le16 *awake_window;
+	const u8 *preq;
+	const u8 *prep;
+	const u8 *perr;
+	const struct ieee80211_rann_ie *rann;
+	const struct ieee80211_channel_sw_ie *ch_switch_ie;
+	const struct ieee80211_ext_chansw_ie *ext_chansw_ie;
+	const u8 *country_elem;
+	const u8 *pwr_constr_elem;
+	const u8 *quiet_elem;	/* first quite element */
+	const u8 *timeout_int;
+	const u8 *opmode_notif;
 
 	/* length of them, respectively */
 	u8 ssid_len;
@@ -1375,7 +1375,7 @@ void ieee80211_apply_htcap_overrides(struct ieee80211_sub_if_data *sdata,
 				     struct ieee80211_sta_ht_cap *ht_cap);
 bool ieee80211_ht_cap_ie_to_sta_ht_cap(struct ieee80211_sub_if_data *sdata,
 				       struct ieee80211_supported_band *sband,
-				       struct ieee80211_ht_cap *ht_cap_ie,
+				       const struct ieee80211_ht_cap *ht_cap_ie,
 				       struct sta_info *sta);
 void ieee80211_send_delba(struct ieee80211_sub_if_data *sdata,
 			  const u8 *da, u16 tid,
@@ -1416,10 +1416,11 @@ void ieee80211_release_reorder_timeout(struct sta_info *sta, int tid);
 u8 ieee80211_mcs_to_chains(const struct ieee80211_mcs_info *mcs);
 
 /* VHT */
-void ieee80211_vht_cap_ie_to_sta_vht_cap(struct ieee80211_sub_if_data *sdata,
-					 struct ieee80211_supported_band *sband,
-					 struct ieee80211_vht_cap *vht_cap_ie,
-					 struct sta_info *sta);
+void
+ieee80211_vht_cap_ie_to_sta_vht_cap(struct ieee80211_sub_if_data *sdata,
+				    struct ieee80211_supported_band *sband,
+				    const struct ieee80211_vht_cap *vht_cap_ie,
+				    struct sta_info *sta);
 enum ieee80211_sta_rx_bandwidth ieee80211_sta_cur_vht_bw(struct sta_info *sta);
 void ieee80211_sta_set_rx_nss(struct sta_info *sta);
 void ieee80211_vht_handle_opmode(struct ieee80211_sub_if_data *sdata,
@@ -1543,7 +1544,7 @@ static inline void ieee80211_add_pending_skbs(struct ieee80211_local *local,
 
 void ieee80211_send_auth(struct ieee80211_sub_if_data *sdata,
 			 u16 transaction, u16 auth_alg, u16 status,
-			 u8 *extra, size_t extra_len, const u8 *bssid,
+			 const u8 *extra, size_t extra_len, const u8 *bssid,
 			 const u8 *da, const u8 *key, u8 key_len, u8 key_idx,
 			 u32 tx_flags);
 void ieee80211_send_deauth_disassoc(struct ieee80211_sub_if_data *sdata,
@@ -1594,7 +1595,7 @@ int ieee80211_add_ext_srates_ie(struct ieee80211_sub_if_data *sdata,
 
 /* channel management */
 void ieee80211_ht_oper_to_chandef(struct ieee80211_channel *control_chan,
-				  struct ieee80211_ht_operation *ht_oper,
+				  const struct ieee80211_ht_operation *ht_oper,
 				  struct cfg80211_chan_def *chandef);
 
 int __must_check
diff --git a/net/mac80211/mesh.h b/net/mac80211/mesh.h
index 3b9d862..e3a6a1a 100644
--- a/net/mac80211/mesh.h
+++ b/net/mac80211/mesh.h
@@ -265,8 +265,8 @@ int mesh_nexthop_lookup(struct sk_buff *skb,
 int mesh_nexthop_resolve(struct sk_buff *skb,
 			 struct ieee80211_sub_if_data *sdata);
 void mesh_path_start_discovery(struct ieee80211_sub_if_data *sdata);
-struct mesh_path *mesh_path_lookup(u8 *dst,
-		struct ieee80211_sub_if_data *sdata);
+struct mesh_path *mesh_path_lookup(const u8 *dst,
+				   struct ieee80211_sub_if_data *sdata);
 struct mesh_path *mpp_path_lookup(u8 *dst,
 				  struct ieee80211_sub_if_data *sdata);
 int mpp_path_add(u8 *dst, u8 *mpp, struct ieee80211_sub_if_data *sdata);
@@ -276,7 +276,7 @@ void mesh_path_fix_nexthop(struct mesh_path *mpath, struct sta_info *next_hop);
 void mesh_path_expire(struct ieee80211_sub_if_data *sdata);
 void mesh_rx_path_sel_frame(struct ieee80211_sub_if_data *sdata,
 		struct ieee80211_mgmt *mgmt, size_t len);
-int mesh_path_add(u8 *dst, struct ieee80211_sub_if_data *sdata);
+int mesh_path_add(const u8 *dst, struct ieee80211_sub_if_data *sdata);
 
 int mesh_path_add_gate(struct mesh_path *mpath);
 int mesh_path_send_to_gates(struct mesh_path *mpath);
@@ -301,8 +301,9 @@ void mesh_sta_cleanup(struct sta_info *sta);
 void mesh_mpath_table_grow(void);
 void mesh_mpp_table_grow(void);
 /* Mesh paths */
-int mesh_path_error_tx(u8 ttl, u8 *target, __le32 target_sn, __le16 target_rcode,
-		       const u8 *ra, struct ieee80211_sub_if_data *sdata);
+int mesh_path_error_tx(u8 ttl, const u8 *target, __le32 target_sn,
+		       __le16 target_rcode, const u8 *ra,
+		       struct ieee80211_sub_if_data *sdata);
 void mesh_path_assign_nexthop(struct mesh_path *mpath, struct sta_info *sta);
 void mesh_path_flush_pending(struct mesh_path *mpath);
 void mesh_path_tx_pending(struct mesh_path *mpath);
diff --git a/net/mac80211/mesh_hwmp.c b/net/mac80211/mesh_hwmp.c
index f0dd874..585c1e2 100644
--- a/net/mac80211/mesh_hwmp.c
+++ b/net/mac80211/mesh_hwmp.c
@@ -30,14 +30,14 @@
 
 static void mesh_queue_preq(struct mesh_path *, u8);
 
-static inline u32 u32_field_get(u8 *preq_elem, int offset, bool ae)
+static inline u32 u32_field_get(const u8 *preq_elem, int offset, bool ae)
 {
 	if (ae)
 		offset += 6;
 	return get_unaligned_le32(preq_elem + offset);
 }
 
-static inline u32 u16_field_get(u8 *preq_elem, int offset, bool ae)
+static inline u32 u16_field_get(const u8 *preq_elem, int offset, bool ae)
 {
 	if (ae)
 		offset += 6;
@@ -102,10 +102,13 @@ enum mpath_frame_type {
 static const u8 broadcast_addr[ETH_ALEN] = {0xff, 0xff, 0xff, 0xff, 0xff, 0xff};
 
 static int mesh_path_sel_frame_tx(enum mpath_frame_type action, u8 flags,
-		u8 *orig_addr, __le32 orig_sn, u8 target_flags, u8 *target,
-		__le32 target_sn, const u8 *da, u8 hop_count, u8 ttl,
-		__le32 lifetime, __le32 metric, __le32 preq_id,
-		struct ieee80211_sub_if_data *sdata)
+				  const u8 *orig_addr, __le32 orig_sn,
+				  u8 target_flags, const u8 *target,
+				  __le32 target_sn, const u8 *da,
+				  u8 hop_count, u8 ttl,
+				  __le32 lifetime, __le32 metric,
+				  __le32 preq_id,
+				  struct ieee80211_sub_if_data *sdata)
 {
 	struct ieee80211_local *local = sdata->local;
 	struct sk_buff *skb;
@@ -235,7 +238,7 @@ static void prepare_frame_for_deferred_tx(struct ieee80211_sub_if_data *sdata,
  * also acquires in the TX path.  To avoid a deadlock we don't transmit the
  * frame directly but add it to the pending queue instead.
  */
-int mesh_path_error_tx(u8 ttl, u8 *target, __le32 target_sn,
+int mesh_path_error_tx(u8 ttl, const u8 *target, __le32 target_sn,
 		       __le16 target_rcode, const u8 *ra,
 		       struct ieee80211_sub_if_data *sdata)
 {
@@ -369,14 +372,14 @@ static u32 airtime_link_metric_get(struct ieee80211_local *local,
  * path routing information is updated.
  */
 static u32 hwmp_route_info_get(struct ieee80211_sub_if_data *sdata,
-			    struct ieee80211_mgmt *mgmt,
-			    u8 *hwmp_ie, enum mpath_frame_type action)
+			       struct ieee80211_mgmt *mgmt,
+			       const u8 *hwmp_ie, enum mpath_frame_type action)
 {
 	struct ieee80211_local *local = sdata->local;
 	struct mesh_path *mpath;
 	struct sta_info *sta;
 	bool fresh_info;
-	u8 *orig_addr, *ta;
+	const u8 *orig_addr, *ta;
 	u32 orig_sn, orig_metric;
 	unsigned long orig_lifetime, exp_time;
 	u32 last_hop_metric, new_metric;
@@ -511,11 +514,11 @@ static u32 hwmp_route_info_get(struct ieee80211_sub_if_data *sdata,
 
 static void hwmp_preq_frame_process(struct ieee80211_sub_if_data *sdata,
 				    struct ieee80211_mgmt *mgmt,
-				    u8 *preq_elem, u32 metric)
+				    const u8 *preq_elem, u32 metric)
 {
 	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
 	struct mesh_path *mpath = NULL;
-	u8 *target_addr, *orig_addr;
+	const u8 *target_addr, *orig_addr;
 	const u8 *da;
 	u8 target_flags, ttl, flags;
 	u32 orig_sn, target_sn, lifetime, orig_metric;
@@ -648,11 +651,11 @@ next_hop_deref_protected(struct mesh_path *mpath)
 
 static void hwmp_prep_frame_process(struct ieee80211_sub_if_data *sdata,
 				    struct ieee80211_mgmt *mgmt,
-				    u8 *prep_elem, u32 metric)
+				    const u8 *prep_elem, u32 metric)
 {
 	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
 	struct mesh_path *mpath;
-	u8 *target_addr, *orig_addr;
+	const u8 *target_addr, *orig_addr;
 	u8 ttl, hopcount, flags;
 	u8 next_hop[ETH_ALEN];
 	u32 target_sn, orig_sn, lifetime;
@@ -711,12 +714,13 @@ fail:
 }
 
 static void hwmp_perr_frame_process(struct ieee80211_sub_if_data *sdata,
-			     struct ieee80211_mgmt *mgmt, u8 *perr_elem)
+				    struct ieee80211_mgmt *mgmt,
+				    const u8 *perr_elem)
 {
 	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
 	struct mesh_path *mpath;
 	u8 ttl;
-	u8 *ta, *target_addr;
+	const u8 *ta, *target_addr;
 	u32 target_sn;
 	u16 target_rcode;
 
@@ -758,15 +762,15 @@ endperr:
 }
 
 static void hwmp_rann_frame_process(struct ieee80211_sub_if_data *sdata,
-				struct ieee80211_mgmt *mgmt,
-				struct ieee80211_rann_ie *rann)
+				    struct ieee80211_mgmt *mgmt,
+				    const struct ieee80211_rann_ie *rann)
 {
 	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
 	struct ieee80211_local *local = sdata->local;
 	struct sta_info *sta;
 	struct mesh_path *mpath;
 	u8 ttl, flags, hopcount;
-	u8 *orig_addr;
+	const u8 *orig_addr;
 	u32 orig_sn, metric, metric_txsta, interval;
 	bool root_is_gate;
 
diff --git a/net/mac80211/mesh_pathtbl.c b/net/mac80211/mesh_pathtbl.c
index d5786c3..2ce4c40 100644
--- a/net/mac80211/mesh_pathtbl.c
+++ b/net/mac80211/mesh_pathtbl.c
@@ -181,7 +181,7 @@ errcopy:
 	return -ENOMEM;
 }
 
-static u32 mesh_table_hash(u8 *addr, struct ieee80211_sub_if_data *sdata,
+static u32 mesh_table_hash(const u8 *addr, struct ieee80211_sub_if_data *sdata,
 			   struct mesh_table *tbl)
 {
 	/* Use last four bytes of hw addr and interface index as hash index */
@@ -326,8 +326,8 @@ static void mesh_path_move_to_queue(struct mesh_path *gate_mpath,
 }
 
 
-static struct mesh_path *mpath_lookup(struct mesh_table *tbl, u8 *dst,
-					  struct ieee80211_sub_if_data *sdata)
+static struct mesh_path *mpath_lookup(struct mesh_table *tbl, const u8 *dst,
+				      struct ieee80211_sub_if_data *sdata)
 {
 	struct mesh_path *mpath;
 	struct hlist_node *n;
@@ -359,7 +359,8 @@ static struct mesh_path *mpath_lookup(struct mesh_table *tbl, u8 *dst,
  *
  * Locking: must be called within a read rcu section.
  */
-struct mesh_path *mesh_path_lookup(u8 *dst, struct ieee80211_sub_if_data *sdata)
+struct mesh_path *mesh_path_lookup(const u8 *dst,
+				   struct ieee80211_sub_if_data *sdata)
 {
 	return mpath_lookup(rcu_dereference(mesh_paths), dst, sdata);
 }
@@ -494,7 +495,7 @@ int mesh_gate_num(struct ieee80211_sub_if_data *sdata)
  *
  * State: the initial state of the new path is set to 0
  */
-int mesh_path_add(u8 *dst, struct ieee80211_sub_if_data *sdata)
+int mesh_path_add(const u8 *dst, struct ieee80211_sub_if_data *sdata)
 {
 	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
 	struct ieee80211_local *local = sdata->local;
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index c307cd1..63784c6 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1465,13 +1465,14 @@ void ieee80211_dynamic_ps_timer(unsigned long data)
 /* MLME */
 static bool ieee80211_sta_wmm_params(struct ieee80211_local *local,
 				     struct ieee80211_sub_if_data *sdata,
-				     u8 *wmm_param, size_t wmm_param_len)
+				     const u8 *wmm_param, size_t wmm_param_len)
 {
 	struct ieee80211_tx_queue_params params;
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 	size_t left;
 	int count;
-	u8 *pos, uapsd_queues = 0;
+	const u8 *pos;
+	u8 uapsd_queues = 0;
 
 	if (!local->ops->conf_tx)
 		return false;
@@ -2657,7 +2658,7 @@ static void ieee80211_rx_bss_info(struct ieee80211_sub_if_data *sdata,
 		need_ps = sdata->u.mgd.associated && !sdata->u.mgd.dtim_period;
 
 		if (elems->tim && !elems->parse_error) {
-			struct ieee80211_tim_ie *tim_ie = elems->tim;
+			const struct ieee80211_tim_ie *tim_ie = elems->tim;
 			sdata->u.mgd.dtim_period = tim_ie->dtim_period;
 		}
 	}
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 858ca57..091ef08 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1042,7 +1042,7 @@ u32 ieee80211_mandatory_rates(struct ieee80211_local *local,
 
 void ieee80211_send_auth(struct ieee80211_sub_if_data *sdata,
 			 u16 transaction, u16 auth_alg, u16 status,
-			 u8 *extra, size_t extra_len, const u8 *da,
+			 const u8 *extra, size_t extra_len, const u8 *da,
 			 const u8 *bssid, const u8 *key, u8 key_len, u8 key_idx,
 			 u32 tx_flags)
 {
@@ -1954,7 +1954,7 @@ u8 *ieee80211_ie_build_ht_oper(u8 *pos, struct ieee80211_sta_ht_cap *ht_cap,
 }
 
 void ieee80211_ht_oper_to_chandef(struct ieee80211_channel *control_chan,
-				  struct ieee80211_ht_operation *ht_oper,
+				  const struct ieee80211_ht_operation *ht_oper,
 				  struct cfg80211_chan_def *chandef)
 {
 	enum nl80211_channel_type channel_type;
diff --git a/net/mac80211/vht.c b/net/mac80211/vht.c
index a9549fc..a2c2258 100644
--- a/net/mac80211/vht.c
+++ b/net/mac80211/vht.c
@@ -13,10 +13,11 @@
 #include "rate.h"
 
 
-void ieee80211_vht_cap_ie_to_sta_vht_cap(struct ieee80211_sub_if_data *sdata,
-					 struct ieee80211_supported_band *sband,
-					 struct ieee80211_vht_cap *vht_cap_ie,
-					 struct sta_info *sta)
+void
+ieee80211_vht_cap_ie_to_sta_vht_cap(struct ieee80211_sub_if_data *sdata,
+				    struct ieee80211_supported_band *sband,
+				    const struct ieee80211_vht_cap *vht_cap_ie,
+				    struct sta_info *sta)
 {
 	struct ieee80211_sta_vht_cap *vht_cap = &sta->sta.vht_cap;
 
-- 
1.8.0

