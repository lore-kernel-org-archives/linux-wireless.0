Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh05.mail.saunalahti.fi ([62.142.5.111]:39521 "EHLO
	emh05.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755257Ab1FMWhv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Jun 2011 18:37:51 -0400
Received: from saunalahti-vams (vs3-11.mail.saunalahti.fi [62.142.5.95])
	by emh05-2.mail.saunalahti.fi (Postfix) with SMTP id EBE9A8BE63
	for <linux-wireless@vger.kernel.org>; Tue, 14 Jun 2011 01:37:49 +0300 (EEST)
Received: from localhost6.localdomain6 (a88-115-184-248.elisa-laajakaista.fi [88.115.184.248])
	by emh07.mail.saunalahti.fi (Postfix) with ESMTP id AD6191C6383
	for <linux-wireless@vger.kernel.org>; Tue, 14 Jun 2011 01:37:48 +0300 (EEST)
Subject: [PATCH v2 21/27] mac80211: rename ieee80211_if_mesh to
	mac80211_if_mesh
To: linux-wireless@vger.kernel.org
From: Kalle Valo <kvalo@adurom.com>
Date: Tue, 14 Jun 2011 01:37:48 +0300
Message-ID: <20110613223748.10517.7085.stgit@localhost6.localdomain6> (sfid-20110614_005723_562181_754E5487)
In-Reply-To: <20110613223029.10517.52197.stgit@localhost6.localdomain6>
References: <20110613223029.10517.52197.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Kalle Valo <kvalo@adurom.com>
---
 net/mac80211/cfg.c          |    6 +++---
 net/mac80211/mac80211_i.h   |    4 ++--
 net/mac80211/mesh.c         |   26 +++++++++++++-------------
 net/mac80211/mesh.h         |    4 ++--
 net/mac80211/mesh_hwmp.c    |   12 ++++++------
 net/mac80211/mesh_pathtbl.c |    4 ++--
 6 files changed, 28 insertions(+), 28 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 22d8ccb..71ae366 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1047,7 +1047,7 @@ static inline bool _chg_mesh_attr(enum nl80211_meshconf_params parm, u32 mask)
 	return (mask >> (parm-1)) & 0x1;
 }
 
-static int copy_mesh_setup(struct ieee80211_if_mesh *ifmsh,
+static int copy_mesh_setup(struct mac80211_if_mesh *ifmsh,
 		const struct mesh_setup *setup)
 {
 	u8 *new_ie;
@@ -1087,7 +1087,7 @@ static int ieee80211_update_mesh_config(struct wiphy *wiphy,
 {
 	struct mesh_config *conf;
 	struct ieee80211_sub_if_data *sdata;
-	struct ieee80211_if_mesh *ifmsh;
+	struct mac80211_if_mesh *ifmsh;
 
 	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	ifmsh = &sdata->u.mesh;
@@ -1139,7 +1139,7 @@ static int ieee80211_join_mesh(struct wiphy *wiphy, struct net_device *dev,
 			       const struct mesh_setup *setup)
 {
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
-	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
+	struct mac80211_if_mesh *ifmsh = &sdata->u.mesh;
 	int err;
 
 	memcpy(&ifmsh->mshcfg, conf, sizeof(struct mesh_config));
diff --git a/net/mac80211/mac80211_i.h b/net/mac80211/mac80211_i.h
index d079142..cd80074 100644
--- a/net/mac80211/mac80211_i.h
+++ b/net/mac80211/mac80211_i.h
@@ -451,7 +451,7 @@ struct mac80211_if_ibss {
 	} state;
 };
 
-struct ieee80211_if_mesh {
+struct mac80211_if_mesh {
 	struct timer_list housekeeping_timer;
 	struct timer_list mesh_path_timer;
 	struct timer_list mesh_path_root_timer;
@@ -598,7 +598,7 @@ struct ieee80211_sub_if_data {
 		struct mac80211_if_vlan vlan;
 		struct mac80211_if_managed mgd;
 		struct mac80211_if_ibss ibss;
-		struct ieee80211_if_mesh mesh;
+		struct mac80211_if_mesh mesh;
 		u32 mntr_flags;
 	} u;
 
diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index f39a6ef..b86f02e 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -45,7 +45,7 @@ static void ieee80211_mesh_housekeeping_timer(unsigned long data)
 {
 	struct ieee80211_sub_if_data *sdata = (void *) data;
 	struct mac80211_local *local = sdata->local;
-	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
+	struct mac80211_if_mesh *ifmsh = &sdata->u.mesh;
 
 	set_bit(MESH_WORK_HOUSEKEEPING, &ifmsh->wrkq_flags);
 
@@ -68,7 +68,7 @@ static void ieee80211_mesh_housekeeping_timer(unsigned long data)
  */
 bool mesh_matches_local(struct ieee802_11_elems *ie, struct ieee80211_sub_if_data *sdata)
 {
-	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
+	struct mac80211_if_mesh *ifmsh = &sdata->u.mesh;
 
 	/*
 	 * As support for each feature is added, check for matching
@@ -292,7 +292,7 @@ static void ieee80211_mesh_path_timer(unsigned long data)
 {
 	struct ieee80211_sub_if_data *sdata =
 		(struct ieee80211_sub_if_data *) data;
-	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
+	struct mac80211_if_mesh *ifmsh = &sdata->u.mesh;
 	struct mac80211_local *local = sdata->local;
 
 	if (local->quiescing) {
@@ -307,7 +307,7 @@ static void ieee80211_mesh_path_root_timer(unsigned long data)
 {
 	struct ieee80211_sub_if_data *sdata =
 		(struct ieee80211_sub_if_data *) data;
-	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
+	struct mac80211_if_mesh *ifmsh = &sdata->u.mesh;
 	struct mac80211_local *local = sdata->local;
 
 	set_bit(MESH_WORK_ROOT, &ifmsh->wrkq_flags);
@@ -320,7 +320,7 @@ static void ieee80211_mesh_path_root_timer(unsigned long data)
 	ieee80211_queue_work(&local->hw, &sdata->work);
 }
 
-void ieee80211_mesh_root_setup(struct ieee80211_if_mesh *ifmsh)
+void ieee80211_mesh_root_setup(struct mac80211_if_mesh *ifmsh)
 {
 	if (ifmsh->mshcfg.dot11MeshHWMPRootMode)
 		set_bit(MESH_WORK_ROOT, &ifmsh->wrkq_flags);
@@ -399,7 +399,7 @@ int ieee80211_new_mesh_header(struct ieee80211s_hdr *meshhdr,
 }
 
 static void ieee80211_mesh_housekeeping(struct ieee80211_sub_if_data *sdata,
-			   struct ieee80211_if_mesh *ifmsh)
+			   struct mac80211_if_mesh *ifmsh)
 {
 	bool free_plinks;
 
@@ -421,7 +421,7 @@ static void ieee80211_mesh_housekeeping(struct ieee80211_sub_if_data *sdata,
 
 static void ieee80211_mesh_rootpath(struct ieee80211_sub_if_data *sdata)
 {
-	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
+	struct mac80211_if_mesh *ifmsh = &sdata->u.mesh;
 
 	mesh_path_tx_root_frame(sdata);
 	mod_timer(&ifmsh->mesh_path_root_timer,
@@ -431,7 +431,7 @@ static void ieee80211_mesh_rootpath(struct ieee80211_sub_if_data *sdata)
 #ifdef CONFIG_PM
 void ieee80211_mesh_quiesce(struct ieee80211_sub_if_data *sdata)
 {
-	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
+	struct mac80211_if_mesh *ifmsh = &sdata->u.mesh;
 
 	/* use atomic bitops in case both timers fire at the same time */
 
@@ -445,7 +445,7 @@ void ieee80211_mesh_quiesce(struct ieee80211_sub_if_data *sdata)
 
 void ieee80211_mesh_restart(struct ieee80211_sub_if_data *sdata)
 {
-	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
+	struct mac80211_if_mesh *ifmsh = &sdata->u.mesh;
 
 	if (test_and_clear_bit(TMR_RUNNING_HK, &ifmsh->timers_running))
 		add_timer(&ifmsh->housekeeping_timer);
@@ -459,7 +459,7 @@ void ieee80211_mesh_restart(struct ieee80211_sub_if_data *sdata)
 
 void ieee80211_start_mesh(struct ieee80211_sub_if_data *sdata)
 {
-	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
+	struct mac80211_if_mesh *ifmsh = &sdata->u.mesh;
 	struct mac80211_local *local = sdata->local;
 
 	local->fif_other_bss++;
@@ -482,7 +482,7 @@ void ieee80211_start_mesh(struct ieee80211_sub_if_data *sdata)
 void ieee80211_stop_mesh(struct ieee80211_sub_if_data *sdata)
 {
 	struct mac80211_local *local = sdata->local;
-	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
+	struct mac80211_if_mesh *ifmsh = &sdata->u.mesh;
 
 	ifmsh->mesh_id_len = 0;
 	ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_BEACON_ENABLED);
@@ -591,7 +591,7 @@ void ieee80211_mesh_rx_queued_mgmt(struct ieee80211_sub_if_data *sdata,
 
 void ieee80211_mesh_work(struct ieee80211_sub_if_data *sdata)
 {
-	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
+	struct mac80211_if_mesh *ifmsh = &sdata->u.mesh;
 
 	if (ifmsh->preq_queue_len &&
 	    time_after(jiffies,
@@ -624,7 +624,7 @@ void ieee80211_mesh_notify_scan_completed(struct mac80211_local *local)
 
 void ieee80211_mesh_init_sdata(struct ieee80211_sub_if_data *sdata)
 {
-	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
+	struct mac80211_if_mesh *ifmsh = &sdata->u.mesh;
 
 	setup_timer(&ifmsh->housekeeping_timer,
 		    ieee80211_mesh_housekeeping_timer,
diff --git a/net/mac80211/mesh.h b/net/mac80211/mesh.h
index d3b0201..db38d57 100644
--- a/net/mac80211/mesh.h
+++ b/net/mac80211/mesh.h
@@ -196,7 +196,7 @@ int mesh_rmc_check(u8 *addr, struct ieee80211s_hdr *mesh_hdr,
 		struct ieee80211_sub_if_data *sdata);
 bool mesh_matches_local(struct ieee802_11_elems *ie,
 		struct ieee80211_sub_if_data *sdata);
-void mesh_ids_set_default(struct ieee80211_if_mesh *mesh);
+void mesh_ids_set_default(struct mac80211_if_mesh *mesh);
 void mesh_mgmt_ies_add(struct sk_buff *skb,
 		struct ieee80211_sub_if_data *sdata);
 void mesh_rmc_free(struct ieee80211_sub_if_data *sdata);
@@ -208,7 +208,7 @@ void ieee80211s_stop(void);
 void ieee80211_mesh_init_sdata(struct ieee80211_sub_if_data *sdata);
 void ieee80211_start_mesh(struct ieee80211_sub_if_data *sdata);
 void ieee80211_stop_mesh(struct ieee80211_sub_if_data *sdata);
-void ieee80211_mesh_root_setup(struct ieee80211_if_mesh *ifmsh);
+void ieee80211_mesh_root_setup(struct mac80211_if_mesh *ifmsh);
 
 /* Mesh paths */
 int mesh_nexthop_lookup(struct sk_buff *skb,
diff --git a/net/mac80211/mesh_hwmp.c b/net/mac80211/mesh_hwmp.c
index dc8746f..4eca250 100644
--- a/net/mac80211/mesh_hwmp.c
+++ b/net/mac80211/mesh_hwmp.c
@@ -469,7 +469,7 @@ static void hwmp_preq_frame_process(struct ieee80211_sub_if_data *sdata,
 				    struct ieee80211_mgmt *mgmt,
 				    u8 *preq_elem, u32 metric)
 {
-	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
+	struct mac80211_if_mesh *ifmsh = &sdata->u.mesh;
 	struct mesh_path *mpath;
 	u8 *target_addr, *orig_addr;
 	u8 target_flags, ttl;
@@ -636,7 +636,7 @@ fail:
 static void hwmp_perr_frame_process(struct ieee80211_sub_if_data *sdata,
 			     struct ieee80211_mgmt *mgmt, u8 *perr_elem)
 {
-	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
+	struct mac80211_if_mesh *ifmsh = &sdata->u.mesh;
 	struct mesh_path *mpath;
 	u8 ttl;
 	u8 *ta, *target_addr;
@@ -679,7 +679,7 @@ static void hwmp_rann_frame_process(struct ieee80211_sub_if_data *sdata,
 				struct ieee80211_mgmt *mgmt,
 				struct ieee80211_rann_ie *rann)
 {
-	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
+	struct mac80211_if_mesh *ifmsh = &sdata->u.mesh;
 	struct mesh_path *mpath;
 	u8 ttl, flags, hopcount;
 	u8 *orig_addr;
@@ -783,7 +783,7 @@ void mesh_rx_path_sel_frame(struct ieee80211_sub_if_data *sdata,
 static void mesh_queue_preq(struct mesh_path *mpath, u8 flags)
 {
 	struct ieee80211_sub_if_data *sdata = mpath->sdata;
-	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
+	struct mac80211_if_mesh *ifmsh = &sdata->u.mesh;
 	struct mesh_preq_queue *preq_node;
 
 	preq_node = kmalloc(sizeof(struct mesh_preq_queue), GFP_ATOMIC);
@@ -829,7 +829,7 @@ static void mesh_queue_preq(struct mesh_path *mpath, u8 flags)
  */
 void mesh_path_start_discovery(struct ieee80211_sub_if_data *sdata)
 {
-	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
+	struct mac80211_if_mesh *ifmsh = &sdata->u.mesh;
 	struct mesh_preq_queue *preq_node;
 	struct mesh_path *mpath;
 	u8 ttl, target_flags;
@@ -1006,7 +1006,7 @@ void mesh_path_timer(unsigned long data)
 void
 mesh_path_tx_root_frame(struct ieee80211_sub_if_data *sdata)
 {
-	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
+	struct mac80211_if_mesh *ifmsh = &sdata->u.mesh;
 
 	mesh_path_sel_frame_tx(MPATH_RANN, 0, sdata->vif.addr,
 			       cpu_to_le32(++ifmsh->sn),
diff --git a/net/mac80211/mesh_pathtbl.c b/net/mac80211/mesh_pathtbl.c
index c99fb89..c52b981 100644
--- a/net/mac80211/mesh_pathtbl.c
+++ b/net/mac80211/mesh_pathtbl.c
@@ -315,7 +315,7 @@ struct mesh_path *mesh_path_lookup_by_idx(int idx, struct ieee80211_sub_if_data
  */
 int mesh_path_add(u8 *dst, struct ieee80211_sub_if_data *sdata)
 {
-	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
+	struct mac80211_if_mesh *ifmsh = &sdata->u.mesh;
 	struct mac80211_local *local = sdata->local;
 	struct mesh_table *tbl;
 	struct mesh_path *mpath, *new_mpath;
@@ -447,7 +447,7 @@ void mesh_mpp_table_grow(void)
 
 int mpp_path_add(u8 *dst, u8 *mpp, struct ieee80211_sub_if_data *sdata)
 {
-	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
+	struct mac80211_if_mesh *ifmsh = &sdata->u.mesh;
 	struct mac80211_local *local = sdata->local;
 	struct mesh_table *tbl;
 	struct mesh_path *mpath, *new_mpath;

