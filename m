Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.183]:34021 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751432AbYIQJAm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Sep 2008 05:00:42 -0400
Received: by py-out-1112.google.com with SMTP id p76so2329487pyb.10
        for <linux-wireless@vger.kernel.org>; Wed, 17 Sep 2008 02:00:41 -0700 (PDT)
Message-ID: <1197ff4c0809170200l701ce25bg6035734a394f8c83@mail.gmail.com> (sfid-20080917_110052_315698_78474D69)
Date: Wed, 17 Sep 2008 17:00:40 +0800
From: YanBo <dreamfly281@gmail.com>
To: wireless <linux-wireless@vger.kernel.org>
Subject: [RFC] mac80211: mesh portal functionality support
Cc: "Javier Cardona" <javier@cozybit.com>,
	"Luis Carlos Cobo" <luisca@cozybit.com>,
	"Johannes Berg" <johannes@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Currently mesh doesn't support bridge(802.1D)  mesh point  with "wired
ethernet or AP" to construct MPP or MAP. This patch add the function
of support "6 address frame format packet" to mesh point. Now the mesh
network can be used as backhaul for end to end communication.

(PS: the function of mpp_path_add() or mpp_path_lookup() are the same
as mpp_path_add() or mesh_path_lookup(), the can be merge into one
function in future)

Signed-off-by: Li YanBo <dreamfly281@gmail.com>
---
 net/mac80211/mesh.h         |    4 +
 net/mac80211/mesh_hwmp.c    |    5 ++
 net/mac80211/mesh_pathtbl.c |  136 ++++++++++++++++++++++++++++++++++++++++++-
 net/mac80211/rx.c           |   21 +++++-
 net/mac80211/tx.c           |   44 ++++++++++++--
 5 files changed, 198 insertions(+), 12 deletions(-)


diff --git a/net/mac80211/mesh.h b/net/mac80211/mesh.h
index 84ff5d8..945a511 100644
--- a/net/mac80211/mesh.h
+++ b/net/mac80211/mesh.h
@@ -71,6 +71,7 @@ enum mesh_path_flags {
  */
 struct mesh_path {
 	u8 dst[ETH_ALEN];
+	u8 mpp[ETH_ALEN];	/* used for MPP or MAP */
 	struct ieee80211_sub_if_data *sdata;
 	struct sta_info *next_hop;
 	struct timer_list timer;
@@ -221,6 +222,8 @@ int mesh_nexthop_lookup(struct sk_buff *skb,
 void mesh_path_start_discovery(struct ieee80211_sub_if_data *sdata);
 struct mesh_path *mesh_path_lookup(u8 *dst,
 		struct ieee80211_sub_if_data *sdata);
+struct mesh_path *mpp_path_lookup(u8 *dst, struct
ieee80211_sub_if_data *sdata);
+int mpp_path_add(u8 *dst, u8 *mpp, struct ieee80211_sub_if_data *sdata);
 struct mesh_path *mesh_path_lookup_by_idx(int idx,
 		struct ieee80211_sub_if_data *sdata);
 void mesh_path_fix_nexthop(struct mesh_path *mpath, struct sta_info *next_hop);
@@ -260,6 +263,7 @@ int mesh_pathtbl_init(void);
 void mesh_pathtbl_unregister(void);
 int mesh_path_del(u8 *addr, struct ieee80211_sub_if_data *sdata);
 void mesh_path_timer(unsigned long data);
+void mpp_path_timer(unsigned long data);
 void mesh_path_flush_by_nexthop(struct sta_info *sta);
 void mesh_path_discard_frame(struct sk_buff *skb,
 		struct ieee80211_sub_if_data *sdata);
diff --git a/net/mac80211/mesh_hwmp.c b/net/mac80211/mesh_hwmp.c
index eeb0ce2..3dd15a2 100644
--- a/net/mac80211/mesh_hwmp.c
+++ b/net/mac80211/mesh_hwmp.c
@@ -849,3 +849,8 @@ void mesh_path_timer(unsigned long data)
 endmpathtimer:
 	rcu_read_unlock();
 }
+
+void mpp_path_timer(unsigned long data)
+{
+	/* TODO update MPP&MAP path*/
+}
diff --git a/net/mac80211/mesh_pathtbl.c b/net/mac80211/mesh_pathtbl.c
index 0a60f55..7b95c14 100644
--- a/net/mac80211/mesh_pathtbl.c
+++ b/net/mac80211/mesh_pathtbl.c
@@ -36,6 +36,7 @@ struct mpath_node {
 };

 static struct mesh_table *mesh_paths;
+static struct mesh_table *mpp_paths; /* Store pathes for MPP&MAP */

 /* This lock will have the grow table function as writer and add / delete nodes
  * as readers. When reading the table (i.e. doing lookups) we are
well protected
@@ -94,6 +95,34 @@ struct mesh_path *mesh_path_lookup(u8 *dst, struct
ieee80211_sub_if_data *sdata)
 	return NULL;
 }

+struct mesh_path *mpp_path_lookup(u8 *dst, struct ieee80211_sub_if_data *sdata)
+{
+	struct mesh_path *mpath;
+	struct hlist_node *n;
+	struct hlist_head *bucket;
+	struct mesh_table *tbl;
+	struct mpath_node *node;
+
+	tbl = rcu_dereference(mpp_paths);
+
+	bucket = &tbl->hash_buckets[mesh_table_hash(dst, sdata, tbl)];
+	hlist_for_each_entry_rcu(node, n, bucket, list) {
+		mpath = node->mpath;
+		if (mpath->sdata == sdata &&
+		    memcmp(dst, mpath->dst, ETH_ALEN) == 0) {
+			if (MPATH_EXPIRED(mpath)) {
+				spin_lock_bh(&mpath->state_lock);
+				if (MPATH_EXPIRED(mpath))
+					mpath->flags &= ~MESH_PATH_ACTIVE;
+				spin_unlock_bh(&mpath->state_lock);
+			}
+			return mpath;
+		}
+	}
+	return NULL;
+}
+
+
 /**
  * mesh_path_lookup_by_idx - look up a path in the mesh path table by its index
  * @idx: index
@@ -226,6 +255,99 @@ err_path_alloc:
 }


+int mpp_path_add(u8 *dst, u8 *mpp, struct ieee80211_sub_if_data *sdata)
+{
+	struct mesh_path *mpath, *new_mpath;
+	struct mpath_node *node, *new_node;
+	struct hlist_head *bucket;
+	struct hlist_node *n;
+	int grow = 0;
+	int err = 0;
+	u32 hash_idx;
+
+
+	if (memcmp(dst, sdata->dev->dev_addr, ETH_ALEN) == 0)
+		/* never add ourselves as neighbours */
+		return -ENOTSUPP;
+
+	if (is_multicast_ether_addr(dst))
+		return -ENOTSUPP;
+
+/* 	if (atomic_add_unless(&sdata->u.sta.mppaths, 1, MESH_MAX_MPPATHS) == 0) */
+/*  	if (atomic_add_unless(&sdata->u.sta.mppaths, 1, 256) == 0)  */
+/*  		return -ENOSPC;  */
+
+	err = -ENOMEM;
+	new_mpath = kzalloc(sizeof(struct mesh_path), GFP_KERNEL);
+	if (!new_mpath)
+		goto err_path_alloc;
+
+	new_node = kmalloc(sizeof(struct mpath_node), GFP_KERNEL);
+	if (!new_node)
+		goto err_node_alloc;
+
+	read_lock(&pathtbl_resize_lock);
+	memcpy(new_mpath->dst, dst, ETH_ALEN);
+	memcpy(new_mpath->mpp, mpp, ETH_ALEN);
+	new_mpath->sdata = sdata;
+	new_mpath->flags = 0;
+	skb_queue_head_init(&new_mpath->frame_queue);
+	new_node->mpath = new_mpath;
+	new_mpath->timer.data = (unsigned long) new_mpath;
+	new_mpath->timer.function = mpp_path_timer;
+	new_mpath->exp_time = jiffies;
+	spin_lock_init(&new_mpath->state_lock);
+	init_timer(&new_mpath->timer);
+
+	hash_idx = mesh_table_hash(dst, sdata, mpp_paths);
+	bucket = &mpp_paths->hash_buckets[hash_idx];
+
+	spin_lock(&mpp_paths->hashwlock[hash_idx]);
+
+	err = -EEXIST;
+	hlist_for_each_entry(node, n, bucket, list) {
+		mpath = node->mpath;
+		if (mpath->sdata == sdata && memcmp(dst, mpath->dst, ETH_ALEN) == 0)
+			goto err_exists;
+	}
+
+	hlist_add_head_rcu(&new_node->list, bucket);
+	if (atomic_inc_return(&mpp_paths->entries) >=
+		mpp_paths->mean_chain_len * (mpp_paths->hash_mask + 1))
+		grow = 1;
+
+	spin_unlock(&mpp_paths->hashwlock[hash_idx]);
+	read_unlock(&pathtbl_resize_lock);
+	if (grow) {
+		struct mesh_table *oldtbl, *newtbl;
+
+		write_lock(&pathtbl_resize_lock);
+		oldtbl = mpp_paths;
+		newtbl = mesh_table_grow(mpp_paths);
+		if (!newtbl) {
+			write_unlock(&pathtbl_resize_lock);
+			return 0;
+		}
+		rcu_assign_pointer(mpp_paths, newtbl);
+		write_unlock(&pathtbl_resize_lock);
+
+		synchronize_rcu();
+		mesh_table_free(oldtbl, false);
+	}
+	return 0;
+
+err_exists:
+	spin_unlock(&mpp_paths->hashwlock[hash_idx]);
+	read_unlock(&pathtbl_resize_lock);
+	kfree(new_node);
+err_node_alloc:
+	kfree(new_mpath);
+err_path_alloc:
+	atomic_dec(&sdata->u.sta.mpaths);
+	return err;
+}
+
+
 /**
  * mesh_plink_broken - deactivates paths and sends perr when a link breaks
  *
@@ -258,6 +380,7 @@ void mesh_plink_broken(struct sta_info *sta)
 		} else
 		spin_unlock_bh(&mpath->state_lock);
 	}
+	/* TODO Also need notice MPP to update mpp path */
 	rcu_read_unlock();
 }

@@ -475,11 +598,19 @@ static int mesh_path_node_copy(struct hlist_node
*p, struct mesh_table *newtbl)
 int mesh_pathtbl_init(void)
 {
 	mesh_paths = mesh_table_alloc(INIT_PATHS_SIZE_ORDER);
+	if (!mesh_paths)
+		return -ENOMEM;
 	mesh_paths->free_node = &mesh_path_node_free;
 	mesh_paths->copy_node = &mesh_path_node_copy;
 	mesh_paths->mean_chain_len = MEAN_CHAIN_LEN;
-	if (!mesh_paths)
-		return -ENOMEM;
+
+	mpp_paths = mesh_table_alloc(INIT_PATHS_SIZE_ORDER);
+	if (!mpp_paths)
+ 		return -ENOMEM;
+	mpp_paths->free_node = &mesh_path_node_free;
+	mpp_paths->copy_node = &mesh_path_node_copy;
+	mpp_paths->mean_chain_len = MEAN_CHAIN_LEN;		
+
 	return 0;
 }

@@ -511,4 +642,5 @@ void mesh_path_expire(struct ieee80211_sub_if_data *sdata)
 void mesh_pathtbl_unregister(void)
 {
 	mesh_table_free(mesh_paths, true);
+	mesh_table_free(mpp_paths, true);
 }
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index fd83ef7..6944a0f 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1112,10 +1112,6 @@ ieee80211_data_to_8023(struct ieee80211_rx_data *rx)

 	hdrlen = ieee80211_hdrlen(hdr->frame_control);

-	if (ieee80211_vif_is_mesh(&sdata->vif))
-		hdrlen += ieee80211_get_mesh_hdrlen(
-				(struct ieee80211s_hdr *) (skb->data + hdrlen));
-
 	/* convert IEEE 802.11 header + possible LLC headers into Ethernet
 	 * header
 	 * IEEE 802.11 address fields:
@@ -1139,6 +1135,14 @@ ieee80211_data_to_8023(struct ieee80211_rx_data *rx)
 		if (unlikely(sdata->vif.type != IEEE80211_IF_TYPE_WDS &&
 			     sdata->vif.type != IEEE80211_IF_TYPE_MESH_POINT))
 			return -1;
+		if (ieee80211_vif_is_mesh(&sdata->vif)) {
+			struct ieee80211s_hdr *meshdr = skb->data + hdrlen;
+			hdrlen += ieee80211_get_mesh_hdrlen(meshdr);
+			if (meshdr->flags == 2) {
+				memcpy(dst, meshdr->eaddr1, ETH_ALEN);
+				memcpy(src, meshdr->eaddr2, ETH_ALEN);
+			}
+		}
 		break;
 	case __constant_cpu_to_le16(IEEE80211_FCTL_FROMDS):
 		if (sdata->vif.type != IEEE80211_IF_TYPE_STA ||
@@ -1397,6 +1401,15 @@ ieee80211_rx_h_mesh_fwding(struct ieee80211_rx_data *rx)
 		/* illegal frame */
 		return RX_DROP_MONITOR;

+	/* TODO store the 6 addr mesh mapping info to the MPP table */
+	if (mesh_hdr->flags == 2){
+		struct ieee80211_sub_if_data *sdata;
+
+		sdata = IEEE80211_DEV_TO_SUB_IF(rx->dev);
+		if (!mpp_path_lookup(mesh_hdr->eaddr2, sdata))
+			mpp_path_add(mesh_hdr->eaddr2, hdr->addr4, sdata);
+	}
+
 	if (compare_ether_addr(rx->dev->dev_addr, hdr->addr3) == 0)
 		return RX_CONTINUE;

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index c413d48..782ab1a 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1478,18 +1478,50 @@ int ieee80211_subif_start_xmit(struct sk_buff *skb,
 #ifdef CONFIG_MAC80211_MESH
 	case IEEE80211_IF_TYPE_MESH_POINT:
 		fc |= cpu_to_le16(IEEE80211_FCTL_FROMDS | IEEE80211_FCTL_TODS);
-		/* RA TA DA SA */
-		memset(hdr.addr1, 0, ETH_ALEN);
-		memcpy(hdr.addr2, dev->dev_addr, ETH_ALEN);
-		memcpy(hdr.addr3, skb->data, ETH_ALEN);
-		memcpy(hdr.addr4, skb->data + ETH_ALEN, ETH_ALEN);
+
 		if (!sdata->u.sta.mshcfg.dot11MeshTTL) {
 			/* Do not send frames with mesh_ttl == 0 */
 			sdata->u.sta.mshstats.dropped_frames_ttl++;
 			ret = 0;
 			goto fail;
 		}
-		meshhdrlen = ieee80211_new_mesh_header(&mesh_hdr, sdata);
+
+		if (compare_ether_addr(dev->dev_addr,
+					  skb->data + ETH_ALEN) == 0) {
+			/* RA TA DA SA */
+			memset(hdr.addr1, 0, ETH_ALEN);
+			memcpy(hdr.addr2, dev->dev_addr, ETH_ALEN);
+			memcpy(hdr.addr3, skb->data, ETH_ALEN);
+			memcpy(hdr.addr4, skb->data + ETH_ALEN, ETH_ALEN);
+			meshhdrlen = ieee80211_new_mesh_header(&mesh_hdr, sdata);
+		} else {
+			/* packet from other interface */
+			struct mesh_path *mppath;
+			u8 broadcast[ETH_ALEN] = {0xFF, 0xFF, 0xFF,
+						  0xFF, 0xFF, 0xFF};
+
+			memset(hdr.addr1, 0, ETH_ALEN);
+			memcpy(hdr.addr2, dev->dev_addr, ETH_ALEN);
+			memcpy(hdr.addr4, dev->dev_addr, ETH_ALEN);
+
+			if (is_multicast_ether_addr(skb->data))
+				memcpy(hdr.addr3, skb->data, ETH_ALEN);
+			else {
+				mppath = mpp_path_lookup(skb->data, sdata);
+				if (mppath)
+					memcpy(hdr.addr3, mppath->mpp, ETH_ALEN);
+				else
+					memcpy(hdr.addr3, broadcast, ETH_ALEN);				
+			}
+
+			mesh_hdr.flags = 2;
+			mesh_hdr.ttl = sdata->u.sta.mshcfg.dot11MeshTTL;
+			put_unaligned(cpu_to_le32(sdata->u.sta.mesh_seqnum), &mesh_hdr.seqnum);
+			memcpy(mesh_hdr.eaddr1, skb->data, ETH_ALEN);
+			memcpy(mesh_hdr.eaddr2, skb->data + ETH_ALEN, ETH_ALEN);
+			sdata->u.sta.mesh_seqnum++;
+			meshhdrlen = 18;
+		}
 		hdrlen = 30;
 		break;
 #endif
