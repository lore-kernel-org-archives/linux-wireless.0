Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f179.google.com ([209.85.192.179]:48843 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756827Ab3ECCgL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 May 2013 22:36:11 -0400
Received: by mail-pd0-f179.google.com with SMTP id q10so664941pdj.24
        for <linux-wireless@vger.kernel.org>; Thu, 02 May 2013 19:36:11 -0700 (PDT)
From: Thomas Pedersen <thomas@cozybit.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wirelss <linux-wireless@vger.kernel.org>, me@bobcopeland.com,
	open80211s <devel@lists.open80211s.org>
Subject: [RFC 01/12] mac80211: track and share mesh BSSes among interfaces
Date: Thu,  2 May 2013 19:33:51 -0700
Message-Id: <1367548442-8229-2-git-send-email-thomas@cozybit.com> (sfid-20130503_043616_005662_209D1BFA)
In-Reply-To: <1367548442-8229-1-git-send-email-thomas@cozybit.com>
References: <1367548442-8229-1-git-send-email-thomas@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Bob Copeland <me@bobcopeland.com>

Add a new global list of mesh BSSes for this host.  Each struct
mesh_local_bss contains parameters specific to a mesh instance,
as well as a list of interfaces participating in the MBSS.  This
will enable lookup of other interfaces on the host participating
in the same mesh.

Signed-off-by: Bob Copeland <bob@cozybit.com>
---
 net/mac80211/ieee80211_i.h |   33 +++++++++
 net/mac80211/mesh.c        |  172 ++++++++++++++++++++++++++++++++++++++++++++
 net/mac80211/mesh.h        |    4 ++
 3 files changed, 209 insertions(+)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 44be28c..da7fbd4 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -285,6 +285,35 @@ struct mesh_stats {
 	__u32 dropped_frames_congestion;/* Not forwarded due to congestion */
 };
 
+/**
+ * mesh_local_bss - a mesh BSS running on this host
+ *
+ * @mesh_id: the mesh id
+ * @mesh_id_len: size of mesh id in bytes
+ * @sync_method: which synchronization method to use
+ * @path_sel_proto: which path selection protocol to use
+ * @path_metric: which metric to use
+ * @is_secure: true if the mesh is secure
+ * @can_share: true if this bss can be shared (user-configurable per-if)
+ * @net: network namespace devices in this mbss belong to
+ * @list: listptr for siblings in mesh_bss_list
+ * @if_list: interfaces sharing this bss
+ */
+struct mesh_local_bss {
+	u8 mesh_id[IEEE80211_MAX_SSID_LEN];
+	u8 mesh_id_len;
+	u8 sync_method;
+	u8 path_sel_proto;
+	u8 path_metric;
+	bool is_secure;
+
+	bool can_share;
+	struct net *net;
+
+	struct list_head list;
+	struct list_head if_list;
+};
+
 #define PREQ_Q_F_START		0x1
 #define PREQ_Q_F_REFRESH	0x2
 struct mesh_preq_queue {
@@ -600,6 +629,10 @@ struct ieee80211_if_mesh {
 	int ps_peers_light_sleep;
 	int ps_peers_deep_sleep;
 	struct ps_data ps;
+
+	/* mbss sharing */
+	struct mesh_local_bss *mesh_bss;
+	struct list_head if_list;
 };
 
 #ifdef CONFIG_MAC80211_MESH
diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index 6952760..5ea4812 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -16,6 +16,10 @@
 static int mesh_allocated;
 static struct kmem_cache *rm_cache;
 
+/* mesh_bss_mtx protects updates; internal iface list uses RCU */
+static DEFINE_MUTEX(mesh_bss_mtx);
+static LIST_HEAD(mesh_bss_list);
+
 bool mesh_action_is_path_sel(struct ieee80211_mgmt *mgmt)
 {
 	return (mgmt->u.action.u.mesh_action.action_code ==
@@ -49,6 +53,154 @@ static void ieee80211_mesh_housekeeping_timer(unsigned long data)
 	ieee80211_queue_work(&local->hw, &sdata->work);
 }
 
+static inline bool
+mesh_bss_matches(struct ieee80211_sub_if_data *sdata,
+		 struct mesh_setup *setup,
+		 struct mesh_local_bss *mbss)
+{
+	return mbss->can_share &&
+	       mbss->mesh_id_len == setup->mesh_id_len &&
+	       memcmp(mbss->mesh_id, setup->mesh_id, mbss->mesh_id_len) == 0 &&
+	       mbss->path_sel_proto == setup->path_sel_proto &&
+	       mbss->path_metric == setup->path_metric &&
+	       mbss->sync_method == setup->sync_method &&
+	       mbss->is_secure == setup->is_secure &&
+	       net_eq(wiphy_net(sdata->wdev.wiphy), mbss->net);
+}
+
+static struct mesh_local_bss * __must_check
+mesh_bss_find(struct ieee80211_sub_if_data *sdata, struct mesh_setup *setup)
+{
+	struct mesh_local_bss *mbss;
+
+	if (WARN_ON(!setup->mesh_id_len))
+		return NULL;
+
+	lockdep_assert_held(&mesh_bss_mtx);
+
+	list_for_each_entry(mbss, &mesh_bss_list, list)
+		if (mesh_bss_matches(sdata, setup, mbss))
+			return mbss;
+
+	return NULL;
+}
+
+static struct mesh_local_bss * __must_check
+mesh_bss_create(struct ieee80211_sub_if_data *sdata, struct mesh_setup *setup)
+{
+	struct mesh_local_bss *mbss;
+
+	lockdep_assert_held(&mesh_bss_mtx);
+
+	if (WARN_ON(setup->mesh_id_len > IEEE80211_MAX_SSID_LEN))
+		return NULL;
+
+	mbss = kzalloc(sizeof(*mbss), GFP_KERNEL);
+	if (!mbss)
+		return NULL;
+
+	INIT_LIST_HEAD(&mbss->if_list);
+
+	mbss->mesh_id_len = setup->mesh_id_len;
+	memcpy(mbss->mesh_id, setup->mesh_id, setup->mesh_id_len);
+	mbss->can_share = false;
+	mbss->path_metric = setup->path_metric;
+	mbss->path_sel_proto = setup->path_sel_proto;
+	mbss->sync_method = setup->sync_method;
+	mbss->is_secure = setup->is_secure;
+	mbss->net = wiphy_net(sdata->wdev.wiphy);
+	return mbss;
+}
+
+static void mesh_bss_remove(struct ieee80211_sub_if_data *sdata)
+{
+	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
+	struct mesh_local_bss *mbss = ifmsh->mesh_bss;
+
+	if (!mbss)
+		return;
+
+	mutex_lock(&mesh_bss_mtx);
+	list_del_rcu(&ifmsh->if_list);
+	synchronize_rcu();
+	ifmsh->mesh_bss = NULL;
+
+	/* free when no more devs have this mbss */
+	if (list_empty(&mbss->if_list)) {
+		list_del(&mbss->list);
+		kfree(mbss);
+	}
+	mutex_unlock(&mesh_bss_mtx);
+}
+
+static
+int mesh_bss_add(struct ieee80211_sub_if_data *sdata,
+		 struct mesh_setup *setup)
+{
+	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
+	struct mesh_local_bss *mbss;
+	int ret;
+
+	if (WARN_ON(!setup->mesh_id_len))
+		return -EINVAL;
+
+	mutex_lock(&mesh_bss_mtx);
+	mbss = mesh_bss_find(sdata, setup);
+	if (!mbss) {
+		mbss = mesh_bss_create(sdata, setup);
+		if (!mbss) {
+			ret = -ENOMEM;
+			goto out_fail;
+		}
+		list_add(&mbss->list, &mesh_bss_list);
+	}
+
+	ifmsh->mesh_bss = mbss;
+	list_add_rcu(&ifmsh->if_list, &mbss->if_list);
+	ret = 0;
+
+ out_fail:
+	mutex_unlock(&mesh_bss_mtx);
+	return ret;
+}
+
+/**
+ * mesh_bss_find_if - return the interface in the local mbss matching addr
+ *
+ * @mbss: mesh bss on this host
+ * @addr: address to find in the interface list
+ *
+ * Returns an interface in mbss matching addr, or NULL if none found.
+ */
+struct ieee80211_sub_if_data *
+mesh_bss_find_if(struct mesh_local_bss *mbss, const u8 *addr)
+{
+	struct ieee80211_sub_if_data *sdata;
+
+	rcu_read_lock();
+	list_for_each_entry_rcu(sdata, &mbss->if_list, u.mesh.if_list) {
+		if (ether_addr_equal(addr, sdata->vif.addr)) {
+			rcu_read_unlock();
+			return sdata;
+		}
+	}
+	rcu_read_unlock();
+	return NULL;
+}
+
+/**
+ * mesh_bss_matches_addr - check if the specified addr is in the local mbss
+ *
+ * @mbss: mesh bss on this host
+ * @addr: address to find in the interface list
+ *
+ * Returns true if the addr is used by an interface in the mbss.
+ */
+bool mesh_bss_matches_addr(struct mesh_local_bss *mbss, const u8 *addr)
+{
+	return mesh_bss_find_if(mbss, addr) != NULL;
+}
+
 /**
  * mesh_matches_local - check if the config of a mesh point matches ours
  *
@@ -733,6 +885,9 @@ void ieee80211_mbss_info_change_notify(struct ieee80211_sub_if_data *sdata,
 
 int ieee80211_start_mesh(struct ieee80211_sub_if_data *sdata)
 {
+	struct mesh_setup setup = {};
+	int ret;
+
 	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
 	struct ieee80211_local *local = sdata->local;
 	u32 changed = BSS_CHANGED_BEACON |
@@ -769,6 +924,19 @@ int ieee80211_start_mesh(struct ieee80211_sub_if_data *sdata)
 		return -ENOMEM;
 	}
 
+	setup.mesh_id_len = ifmsh->mesh_id_len;
+	setup.mesh_id = ifmsh->mesh_id;
+	setup.path_sel_proto = ifmsh->mesh_pp_id;
+	setup.sync_method = ifmsh->mesh_pm_id;
+	setup.path_metric = ifmsh->mesh_cc_id;
+	setup.is_secure = ifmsh->security & IEEE80211_MESH_SEC_SECURED;
+
+	ret = mesh_bss_add(sdata, &setup);
+	if (ret) {
+		ieee80211_stop_mesh(sdata);
+		return ret;
+	}
+
 	ieee80211_bss_info_change_notify(sdata, changed);
 
 	netif_carrier_on(sdata->dev);
@@ -818,6 +986,10 @@ void ieee80211_stop_mesh(struct ieee80211_sub_if_data *sdata)
 	local->fif_other_bss--;
 	atomic_dec(&local->iff_allmultis);
 	ieee80211_configure_filter(local);
+
+	netif_tx_stop_all_queues(sdata->dev);
+
+	mesh_bss_remove(sdata);
 }
 
 static void
diff --git a/net/mac80211/mesh.h b/net/mac80211/mesh.h
index da15877..f23b58f 100644
--- a/net/mac80211/mesh.h
+++ b/net/mac80211/mesh.h
@@ -361,6 +361,10 @@ void ieee80211_mesh_notify_scan_completed(struct ieee80211_local *local);
 void mesh_path_flush_by_iface(struct ieee80211_sub_if_data *sdata);
 void mesh_sync_adjust_tbtt(struct ieee80211_sub_if_data *sdata);
 void ieee80211s_stop(void);
+struct ieee80211_sub_if_data *
+mesh_bss_find_if(struct mesh_local_bss *mbss, const u8 *addr);
+bool mesh_bss_matches_addr(struct mesh_local_bss *mbss, const u8 *addr);
+#define mbss(sdata) (sdata->u.mesh.mesh_bss)
 #else
 static inline void
 ieee80211_mesh_notify_scan_completed(struct ieee80211_local *local) {}
-- 
1.7.10.4

