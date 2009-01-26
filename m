Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c1.cosetrain.com ([213.239.209.213]:40890 "EHLO
	mail.cosetrain.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752009AbZAZUjS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Jan 2009 15:39:18 -0500
From: Florian Sesser <flomaillist@cosetrain.com>
To: linux-wireless@vger.kernel.org
Cc: Florian Sesser <flomaillist@cosetrain.com>
Subject: [PATCH 2/6] mac80211: Registration of path selection protocols
Date: Mon, 26 Jan 2009 21:39:11 +0100
Message-Id: <3202b18e8531aa78c29636c163de20875ae1a9cf.1233001802.git.flomaillist@cosetrain.com> (sfid-20090126_213926_605732_6CF3BE60)
In-Reply-To: <abd4234c03d59a65d3eb9259821d705899a08612.1233001802.git.flomaillist@cosetrain.com>
References: <497E1B90.4060803@cosetrain.com>
 <abd4234c03d59a65d3eb9259821d705899a08612.1233001802.git.flomaillist@cosetrain.com>
In-Reply-To: <abd4234c03d59a65d3eb9259821d705899a08612.1233001802.git.flomaillist@cosetrain.com>
References: <abd4234c03d59a65d3eb9259821d705899a08612.1233001802.git.flomaillist@cosetrain.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

(Un)registering of path selection protocols
and some other functions for supporting the
change of PP at runtime.

Signed-off-by: Florian Sesser <flomaillist@cosetrain.com>
---
 net/mac80211/mesh.c |  162 +++++++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 158 insertions(+), 4 deletions(-)

diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index 8a1fcae..c0aaabd 100644
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
+static LIST_HEAD(mesh_path_sel_algo_list);
 
 void ieee80211s_init(void)
 {
@@ -112,14 +115,149 @@ void mesh_accept_plinks_update(struct ieee80211_sub_if_data *sdata)
 		ieee80211_mesh_housekeeping_timer((unsigned long) sdata);
 }
 
+struct mesh_path_sel_algo* mesh_path_sel_algo_find_by_name (const char* name)
+{
+	struct mesh_path_sel_algo *a;
+
+	list_for_each_entry(a, &mesh_path_sel_algo_list, list) {
+		if (!strcmp(a->name, name))
+			return a;
+	}
+
+	return NULL;
+}
+EXPORT_SYMBOL(mesh_path_sel_algo_find_by_name);
+
+struct mesh_path_sel_algo* mesh_path_sel_algo_find_by_id (u32 id)
+{
+	struct mesh_path_sel_algo *a;
+
+	list_for_each_entry(a, &mesh_path_sel_algo_list, list) {
+		if (a->id == id)
+			return a;
+	}
+
+	return NULL;
+}
+EXPORT_SYMBOL(mesh_path_sel_algo_find_by_id);
+
+static struct mesh_path_sel_algo* mesh_path_sel_algo_load(const char *name)
+{
+	struct mesh_path_sel_algo *a;
+	spin_lock(&path_sel_list_lock);
+	a = mesh_path_sel_algo_find_by_name(name);
+	if (!a) {
+		spin_unlock(&path_sel_list_lock);
+		request_module("%s", name);
+		spin_lock(&path_sel_list_lock);
+		a = mesh_path_sel_algo_find_by_name(name);
+	}
+
+	if (a && !try_module_get(a->owner))
+		a = NULL;
+	spin_unlock(&path_sel_list_lock);
+	return a;
+}
+
+void mesh_path_sel_algo_set (struct ieee80211_if_mesh *sta, struct mesh_path_sel_algo* algo)
+{
+	/* first, check if algo has been properly registered */
+	if (mesh_path_sel_algo_find_by_name(algo->name)) {
+
+		if (!sta->mesh_pp) {
+			/* set all three locations (duh): */
+			/* this connects an interface to its mesh pp algo */
+			sta->mesh_pp = algo;
+			/* this is used to compare mesh configs (see mesh_matches_local) */
+			memcpy(sta->mesh_pp_id, &(algo->id), 4);
+			/* this is used by the nl80211 layer */
+			sta->mshcfg.mesh_path_selection_protocol_id = algo->id;
+
+			printk(KERN_INFO "Initial mesh path selection algorithm %s / %08X.\n", algo->name, algo->id);
+			return;
+		}
+
+		if (sta->mesh_pp == algo) {
+			printk(KERN_INFO "Mesh path selection algorithm %s / %08X already active.\n", algo->name, algo->id);
+			return;
+		}
+
+		printk(KERN_INFO "Stopping mesh path selection algorithm %s / %08X ...\n", sta->mesh_pp->name, sta->mesh_pp->id);
+		sta->mesh_pp->ops->path_sel_stop_fn(sta);
+
+		sta->mesh_pp = algo;
+		memcpy(sta->mesh_pp_id, &algo->id, 4);
+		printk(KERN_INFO "Chosen mesh path selection algorithm %s / %08X.\n", sta->mesh_pp->name, sta->mesh_pp->id);
+
+		printk(KERN_INFO "Starting mesh path selection algorithm %s / %08X ...\n", sta->mesh_pp->name, sta->mesh_pp->id);
+		sta->mesh_pp->ops->path_sel_start_fn(sta);
+	}
+}
+EXPORT_SYMBOL(mesh_path_sel_algo_set);
+
+void mesh_path_sel_algo_register (struct mesh_path_sel_algo* algo)
+{
+	/* Sanity checks */
+	BUG_ON(!algo->ops->path_start_discovery_fn);
+	BUG_ON(!algo->ops->nexthop_lookup_fn);
+	BUG_ON(!algo->ops->path_error_tx_fn);
+	BUG_ON(!algo->ops->path_timer_fn);
+	BUG_ON(!algo->ops->queue_preq_fn);
+	BUG_ON(!algo->ops->rx_path_sel_frame_fn);
+	BUG_ON(!algo->ops->path_sel_start_fn);
+	BUG_ON(!algo->ops->path_sel_stop_fn);
+
+	spin_lock(&path_sel_list_lock);
+	if (!mesh_path_sel_algo_find_by_name(algo->name)) {
+		list_add_tail(&algo->list, &mesh_path_sel_algo_list);
+		spin_unlock(&path_sel_list_lock);
+		printk(KERN_INFO "Mesh path selection algorithm %s / %08X registered.\n", algo->name, algo->id);
+	} else {
+		spin_unlock(&path_sel_list_lock);
+		printk(KERN_WARNING "Error: Couldn't register mesh path selection algorithm %s / %08X.\n", algo->name, algo->id);
+	}
+}
+EXPORT_SYMBOL(mesh_path_sel_algo_register);
+
+void mesh_path_sel_algo_unregister (struct mesh_path_sel_algo *algo) {
+	if (mesh_path_sel_algo_find_by_name(algo->name)) {
+		list_del(&algo->list);
+		printk(KERN_INFO "Mesh path selection algorithm %s / %08X unregistered.\n", algo->name, algo->id);
+	} else {
+		printk(KERN_WARNING "Error: Couldn't unregister mesh path selection algorithm %s / %08X.\n", algo->name, algo->id);
+	}
+}
+EXPORT_SYMBOL(mesh_path_sel_algo_unregister);
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
+	struct mesh_path_sel_algo *nalgo = mesh_path_sel_algo_find_by_id(pp);
+
+	if(nalgo) {
+		mesh_path_sel_algo_set(sta, nalgo);
+	} else {
+		printk(KERN_WARNING "Could not find mesh path selection protocol with ID %08X.\n", pp);
+	}
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
@@ -246,7 +384,7 @@ void mesh_mgmt_ies_add(struct sk_buff *skb, struct ieee80211_sub_if_data *sdata)
 	memcpy(pos, sdata->u.mesh.mesh_pp_id, 4);
 	pos += 4;
 
-	/* Active path selection metric ID   */
+	/* Active path selection metric ID */
 	memcpy(pos, sdata->u.mesh.mesh_pm_id, 4);
 	pos += 4;
 
@@ -444,6 +582,16 @@ void ieee80211_start_mesh(struct ieee80211_sub_if_data *sdata)
 	queue_work(local->hw.workqueue, &ifmsh->work);
 	ieee80211_if_config(sdata, IEEE80211_IFCC_BEACON |
 				   IEEE80211_IFCC_BEACON_ENABLED);
+
+	/* Register default path selection algorithm */
+	if (!ifmsh->mesh_pp) {
+		if(!(ifmsh->mesh_pp = mesh_path_sel_algo_find_by_name("mesh_hwmp"))) {
+			if (!(ifmsh->mesh_pp = mesh_path_sel_algo_load("mesh_hwmp"))) {
+				printk(KERN_WARNING "Could not load mesh_hwmp, aborting.\n");
+				ieee80211_stop_mesh(sdata);
+			}
+		}
+	}
 }
 
 void ieee80211_stop_mesh(struct ieee80211_sub_if_data *sdata)
@@ -523,7 +671,7 @@ static void ieee80211_mesh_rx_mgmt_action(struct ieee80211_sub_if_data *sdata,
 		mesh_rx_plink_frame(sdata, mgmt, len, rx_status);
 		break;
 	case MESH_PATH_SEL_CATEGORY:
-		mesh_rx_path_sel_frame(sdata, mgmt, len);
+		sdata->u.mesh.mesh_pp->ops->rx_path_sel_frame_fn(sdata, mgmt, len);
 		break;
 	}
 }
@@ -576,7 +724,7 @@ static void ieee80211_mesh_work(struct work_struct *work)
 	if (ifmsh->preq_queue_len &&
 	    time_after(jiffies,
 		       ifmsh->last_preq + msecs_to_jiffies(ifmsh->mshcfg.dot11MeshHWMPpreqMinInterval)))
-		mesh_path_start_discovery(sdata);
+		ifmsh->mesh_pp->ops->path_start_discovery_fn(sdata);
 
 	if (ifmsh->housekeeping)
 		ieee80211_mesh_housekeeping(sdata, ifmsh);
@@ -617,6 +765,12 @@ void ieee80211_mesh_init_sdata(struct ieee80211_sub_if_data *sdata)
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
-- 
1.5.6.5

