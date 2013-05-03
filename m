Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f47.google.com ([209.85.160.47]:35383 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753873Ab3ECCgZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 May 2013 22:36:25 -0400
Received: by mail-pb0-f47.google.com with SMTP id uo1so657105pbc.34
        for <linux-wireless@vger.kernel.org>; Thu, 02 May 2013 19:36:24 -0700 (PDT)
From: Thomas Pedersen <thomas@cozybit.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wirelss <linux-wireless@vger.kernel.org>, me@bobcopeland.com,
	open80211s <devel@lists.open80211s.org>,
	Thomas Pedersen <thomas@cozybit.com>
Subject: [RFC 07/12] mac80211: make RMC per-mbss
Date: Thu,  2 May 2013 19:33:57 -0700
Message-Id: <1367548442-8229-8-git-send-email-thomas@cozybit.com> (sfid-20130503_043628_422026_BC6B9CFA)
In-Reply-To: <1367548442-8229-1-git-send-email-thomas@cozybit.com>
References: <1367548442-8229-1-git-send-email-thomas@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The RMC was previously per-sdata, but it is sufficient for
one of the interfaces in a local mbss to receive a
multicast frame once.

Once multiple interfaces share the same mesh data forwarding
duties, we may inadvertently create a multicast routing loop
and have a corner case where a multicast frame is
retransmitted a few times too many.

Signed-off-by: Thomas Pedersen <thomas@cozybit.com>
---
 net/mac80211/ieee80211_i.h |    3 ++-
 net/mac80211/iface.c       |    3 ---
 net/mac80211/mesh.c        |   56 ++++++++++++++++++++++++++++++--------------
 net/mac80211/mesh.h        |    7 +++---
 net/mac80211/rx.c          |    2 +-
 5 files changed, 45 insertions(+), 26 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index da7fbd4..a8b33d2 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -296,6 +296,7 @@ struct mesh_stats {
  * @is_secure: true if the mesh is secure
  * @can_share: true if this bss can be shared (user-configurable per-if)
  * @net: network namespace devices in this mbss belong to
+ * @rmc: Recent Multicast Cache for this mbss
  * @list: listptr for siblings in mesh_bss_list
  * @if_list: interfaces sharing this bss
  */
@@ -310,6 +311,7 @@ struct mesh_local_bss {
 	bool can_share;
 	struct net *net;
 
+	struct mesh_rmc *rmc;
 	struct list_head list;
 	struct list_head if_list;
 };
@@ -598,7 +600,6 @@ struct ieee80211_if_mesh {
 	unsigned long next_perr;
 	/* Timestamp of last PREQ sent */
 	unsigned long last_preq;
-	struct mesh_rmc *rmc;
 	spinlock_t mesh_preq_queue_lock;
 	struct mesh_preq_queue preq_queue;
 	int preq_queue_len;
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 9daa64e..652fb40 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -994,9 +994,6 @@ static void ieee80211_teardown_sdata(struct ieee80211_sub_if_data *sdata)
 		__skb_queue_purge(&sdata->fragments[i].skb_list);
 	sdata->fragment_next = 0;
 
-	if (ieee80211_vif_is_mesh(&sdata->vif))
-		mesh_rmc_free(sdata);
-
 	flushed = sta_info_flush(sdata);
 	WARN_ON(flushed);
 }
diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index 271ddc9..9445f02 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -100,6 +100,11 @@ mesh_bss_create(struct ieee80211_sub_if_data *sdata, struct mesh_setup *setup)
 	if (!mbss)
 		return NULL;
 
+	if (mesh_rmc_init(mbss)) {
+		kfree(mbss);
+		return NULL;
+	}
+
 	INIT_LIST_HEAD(&mbss->if_list);
 
 	mbss->mesh_id_len = setup->mesh_id_len;
@@ -129,6 +134,7 @@ static void mesh_bss_remove(struct ieee80211_sub_if_data *sdata)
 	/* free when no more devs have this mbss */
 	if (list_empty(&mbss->if_list)) {
 		list_del(&mbss->list);
+		mesh_rmc_free(mbss);
 		kfree(mbss);
 	}
 	mutex_unlock(&mesh_bss_mtx);
@@ -360,26 +366,31 @@ void mesh_sta_cleanup(struct sta_info *sta)
 		ieee80211_mbss_info_change_notify(sdata, changed);
 }
 
-int mesh_rmc_init(struct ieee80211_sub_if_data *sdata)
+int mesh_rmc_init(struct mesh_local_bss *mbss)
 {
+	struct mesh_rmc *rmc;
 	int i;
 
-	sdata->u.mesh.rmc = kmalloc(sizeof(struct mesh_rmc), GFP_KERNEL);
-	if (!sdata->u.mesh.rmc)
+	rmc = kmalloc(sizeof(struct mesh_rmc), GFP_KERNEL);
+	if (!rmc)
 		return -ENOMEM;
-	sdata->u.mesh.rmc->idx_mask = RMC_BUCKETS - 1;
-	for (i = 0; i < RMC_BUCKETS; i++)
-		INIT_LIST_HEAD(&sdata->u.mesh.rmc->bucket[i]);
+	rmc->idx_mask = RMC_BUCKETS - 1;
+	for (i = 0; i < RMC_BUCKETS; i++) {
+		INIT_LIST_HEAD(&rmc->bucket[i]);
+		rwlock_init(&rmc->bucket_lock[i]);
+	}
+
+	mbss->rmc = rmc;
 	return 0;
 }
 
-void mesh_rmc_free(struct ieee80211_sub_if_data *sdata)
+void mesh_rmc_free(struct mesh_local_bss *mbss)
 {
-	struct mesh_rmc *rmc = sdata->u.mesh.rmc;
+	struct mesh_rmc *rmc = mbss->rmc;
 	struct rmc_entry *p, *n;
 	int i;
 
-	if (!sdata->u.mesh.rmc)
+	if (!rmc)
 		return;
 
 	for (i = 0; i < RMC_BUCKETS; i++) {
@@ -390,13 +401,12 @@ void mesh_rmc_free(struct ieee80211_sub_if_data *sdata)
 	}
 
 	kfree(rmc);
-	sdata->u.mesh.rmc = NULL;
+	mbss->rmc = NULL;
 }
 
 /**
  * mesh_rmc_check - Check frame in recent multicast cache and add if absent.
  *
- * @sdata:	interface
  * @sa:		source address
  * @mesh_hdr:	mesh_header
  *
@@ -406,18 +416,20 @@ void mesh_rmc_free(struct ieee80211_sub_if_data *sdata)
  * received this frame lately. If the frame is not in the cache, it is added to
  * it.
  */
-int mesh_rmc_check(struct ieee80211_sub_if_data *sdata,
+int mesh_rmc_check(struct mesh_local_bss *mbss,
 		   const u8 *sa, struct ieee80211s_hdr *mesh_hdr)
 {
-	struct mesh_rmc *rmc = sdata->u.mesh.rmc;
+	struct mesh_rmc *rmc = mbss->rmc;
 	u32 seqnum = 0;
-	int entries = 0;
+	int entries = 0, ret = 0;
 	u8 idx;
 	struct rmc_entry *p, *n;
 
 	/* Don't care about endianness since only match matters */
 	memcpy(&seqnum, &mesh_hdr->seqnum, sizeof(mesh_hdr->seqnum));
 	idx = le32_to_cpu(mesh_hdr->seqnum) & rmc->idx_mask;
+
+	read_lock(&rmc->bucket_lock[idx]);
 	list_for_each_entry_safe(p, n, &rmc->bucket[idx], list) {
 		++entries;
 		if (time_after(jiffies, p->exp_time) ||
@@ -425,19 +437,28 @@ int mesh_rmc_check(struct ieee80211_sub_if_data *sdata,
 			list_del(&p->list);
 			kmem_cache_free(rm_cache, p);
 			--entries;
-		} else if ((seqnum == p->seqnum) && ether_addr_equal(sa, p->sa))
-			return -1;
+		} else if ((seqnum == p->seqnum) &&
+			    ether_addr_equal(sa, p->sa)) {
+			ret = -1;
+			break;
+		}
 	}
+	read_unlock(&rmc->bucket_lock[idx]);
+
+	if (ret)
+		return ret;
 
 	p = kmem_cache_alloc(rm_cache, GFP_ATOMIC);
 	if (!p)
 		return 0;
 
+	write_lock(&rmc->bucket_lock[idx]);
 	p->seqnum = seqnum;
 	p->exp_time = jiffies + RMC_TIMEOUT;
 	memcpy(p->sa, sa, ETH_ALEN);
 	list_add(&p->list, &rmc->bucket[idx]);
-	return 0;
+	write_unlock(&rmc->bucket_lock[idx]);
+	return ret;
 }
 
 int mesh_add_meshconf_ie(struct ieee80211_sub_if_data *sdata,
@@ -1242,7 +1263,6 @@ void ieee80211_mesh_init_sdata(struct ieee80211_sub_if_data *sdata)
 	ifmsh->sn = 0;
 	ifmsh->num_gates = 0;
 	atomic_set(&ifmsh->mpaths, 0);
-	mesh_rmc_init(sdata);
 	ifmsh->last_preq = jiffies;
 	ifmsh->next_perr = jiffies;
 	/* Allocate all mesh structures when creating the first mesh interface. */
diff --git a/net/mac80211/mesh.h b/net/mac80211/mesh.h
index 2f83e8c..bf108ef 100644
--- a/net/mac80211/mesh.h
+++ b/net/mac80211/mesh.h
@@ -185,6 +185,7 @@ struct rmc_entry {
 
 struct mesh_rmc {
 	struct list_head bucket[RMC_BUCKETS];
+	rwlock_t bucket_lock[RMC_BUCKETS];
 	u32 idx_mask;
 };
 
@@ -209,7 +210,7 @@ int ieee80211_fill_mesh_addresses(struct ieee80211_hdr *hdr, __le16 *fc,
 int ieee80211_new_mesh_header(struct ieee80211_sub_if_data *sdata,
 			      struct ieee80211s_hdr *meshhdr,
 			      const char *addr4or5, const char *addr6);
-int mesh_rmc_check(struct ieee80211_sub_if_data *sdata,
+int mesh_rmc_check(struct mesh_local_bss *mbss,
 		   const u8 *addr, struct ieee80211s_hdr *mesh_hdr);
 bool mesh_matches_local(struct ieee80211_sub_if_data *sdata,
 			struct ieee802_11_elems *ie);
@@ -228,8 +229,8 @@ int mesh_add_ht_cap_ie(struct ieee80211_sub_if_data *sdata,
 		       struct sk_buff *skb);
 int mesh_add_ht_oper_ie(struct ieee80211_sub_if_data *sdata,
 			struct sk_buff *skb);
-void mesh_rmc_free(struct ieee80211_sub_if_data *sdata);
-int mesh_rmc_init(struct ieee80211_sub_if_data *sdata);
+void mesh_rmc_free(struct mesh_local_bss *mbss);
+int mesh_rmc_init(struct mesh_local_bss *mbss);
 void ieee80211s_init(void);
 void ieee80211s_update_metric(struct ieee80211_local *local,
 			      struct sta_info *sta, struct sk_buff *skb);
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index d86f0df..0c5f870 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -2033,7 +2033,7 @@ ieee80211_rx_h_mesh_fwding(struct ieee80211_rx_data *rx)
 	/* frame is in RMC, don't forward */
 	if (ieee80211_is_data(hdr->frame_control) &&
 	    is_multicast_ether_addr(hdr->addr1) &&
-	    mesh_rmc_check(rx->sdata, hdr->addr3, mesh_hdr))
+	    mesh_rmc_check(mbss(sdata), hdr->addr3, mesh_hdr))
 		return RX_DROP_MONITOR;
 
 	if (!ieee80211_is_data(hdr->frame_control) ||
-- 
1.7.10.4

