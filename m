Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:38957 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751462AbYIUNaH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 21 Sep 2008 09:30:07 -0400
Subject: [PATCH v3] mac80211: mesh portal functionality support
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Javier Cardona <javier@cozybit.com>,
	Luis Carlos Cobo <luisca@cozybit.com>,
	Yanbo Li <dreamfly281@gmail.com>
Content-Type: text/plain
Date: Sun, 21 Sep 2008 15:30:02 +0200
Message-Id: <1222003802.3023.26.camel@johannes.berg> (sfid-20080921_153022_013249_40F33585)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Li YanBo <dreamfly281@gmail.com>

Currently the mesh code doesn't support bridging mesh point interfaces
with wired ethernet or AP to construct an MPP or MAP. This patch adds
code to support the "6 address frame format packet" functionality to
mesh point interfaces. Now the mesh network can be used as backhaul
for end to end communication.

Signed-off-by: Li YanBo <dreamfly281@gmail.com>
Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 include/linux/ieee80211.h   |    5 ++
 net/mac80211/mesh.h         |    3 +
 net/mac80211/mesh_pathtbl.c |  129 ++++++++++++++++++++++++++++++++++++++++++-
 net/mac80211/rx.c           |   32 +++++++++-
 net/mac80211/tx.c           |   45 +++++++++++++--
 5 files changed, 202 insertions(+), 12 deletions(-)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index abc1abc..db1bb0c 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -471,6 +471,11 @@ struct ieee80211s_hdr {
 	u8 eaddr3[6];
 } __attribute__ ((packed));
 
+/* Mesh extent address flags */
+#define MESH_DATA_NO_EADDR	0x0
+#define MESH_DATA_EADD1_EADD2	0x2
+
+
 /**
  * struct ieee80211_quiet_ie
  *
diff --git a/net/mac80211/mesh.h b/net/mac80211/mesh.h
index 8ee414a..5b18d2b 100644
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
@@ -226,6 +227,8 @@ int mesh_nexthop_lookup(struct sk_buff *skb,
 void mesh_path_start_discovery(struct ieee80211_sub_if_data *sdata);
 struct mesh_path *mesh_path_lookup(u8 *dst,
 		struct ieee80211_sub_if_data *sdata);
+struct mesh_path *mpp_path_lookup(u8 *dst, struct ieee80211_sub_if_data *sdata);
+int mpp_path_add(u8 *dst, u8 *mpp, struct ieee80211_sub_if_data *sdata);
 struct mesh_path *mesh_path_lookup_by_idx(int idx,
 		struct ieee80211_sub_if_data *sdata);
 void mesh_path_fix_nexthop(struct mesh_path *mpath, struct sta_info *next_hop);
diff --git a/net/mac80211/mesh_pathtbl.c b/net/mac80211/mesh_pathtbl.c
index e4fa290..f202eac 100644
--- a/net/mac80211/mesh_pathtbl.c
+++ b/net/mac80211/mesh_pathtbl.c
@@ -36,6 +36,7 @@ struct mpath_node {
 };
 
 static struct mesh_table *mesh_paths;
+static struct mesh_table *mpp_paths; /* Store pathes for MPP&MAP */
 
 /* This lock will have the grow table function as writer and add / delete nodes
  * as readers. When reading the table (i.e. doing lookups) we are well protected
@@ -94,6 +95,34 @@ struct mesh_path *mesh_path_lookup(u8 *dst, struct ieee80211_sub_if_data *sdata)
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
@@ -226,6 +255,91 @@ err_path_alloc:
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
+	new_mpath->exp_time = jiffies;
+	spin_lock_init(&new_mpath->state_lock);
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
+	return err;
+}
+
+
 /**
  * mesh_plink_broken - deactivates paths and sends perr when a link breaks
  *
@@ -475,11 +589,21 @@ static int mesh_path_node_copy(struct hlist_node *p, struct mesh_table *newtbl)
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
+	if (!mpp_paths) {
+		mesh_table_free(mesh_paths, true);
+ 		return -ENOMEM;
+	}
+	mpp_paths->free_node = &mesh_path_node_free;
+	mpp_paths->copy_node = &mesh_path_node_copy;
+	mpp_paths->mean_chain_len = MEAN_CHAIN_LEN;		
+
 	return 0;
 }
 
@@ -511,4 +635,5 @@ void mesh_path_expire(struct ieee80211_sub_if_data *sdata)
 void mesh_pathtbl_unregister(void)
 {
 	mesh_table_free(mesh_paths, true);
+	mesh_table_free(mpp_paths, true);
 }
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 763c7ea..ff7e813 100644
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
@@ -1139,6 +1135,15 @@ ieee80211_data_to_8023(struct ieee80211_rx_data *rx)
 		if (unlikely(sdata->vif.type != NL80211_IFTYPE_WDS &&
 			     sdata->vif.type != NL80211_IFTYPE_MESH_POINT))
 			return -1;
+		if (ieee80211_vif_is_mesh(&sdata->vif)) {
+			struct ieee80211s_hdr *meshdr = (struct ieee80211s_hdr *)
+				(skb->data + hdrlen);
+			hdrlen += ieee80211_get_mesh_hdrlen(meshdr);
+			if (meshdr->flags == MESH_DATA_EADD1_EADD2) {
+				memcpy(dst, meshdr->eaddr1, ETH_ALEN);
+				memcpy(src, meshdr->eaddr2, ETH_ALEN);
+			}
+		}
 		break;
 	case __constant_cpu_to_le16(IEEE80211_FCTL_FROMDS):
 		if (sdata->vif.type != NL80211_IFTYPE_STATION ||
@@ -1398,6 +1403,25 @@ ieee80211_rx_h_mesh_fwding(struct ieee80211_rx_data *rx)
 		/* illegal frame */
 		return RX_DROP_MONITOR;
 
+	if (mesh_hdr->flags == MESH_DATA_EADD1_EADD2){
+		struct ieee80211_sub_if_data *sdata;
+		struct mesh_path *mppath;
+
+		sdata = IEEE80211_DEV_TO_SUB_IF(rx->dev);
+		rcu_read_lock();
+		mppath = mpp_path_lookup(mesh_hdr->eaddr2, sdata);
+		if (!mppath) {
+			mpp_path_add(mesh_hdr->eaddr2, hdr->addr4, sdata);
+		} else {
+			spin_lock_bh(&mppath->state_lock);
+			mppath->exp_time = jiffies;
+			if (compare_ether_addr(mppath->mpp, hdr->addr4) != 0)
+				memcpy(mppath->mpp, hdr->addr4, ETH_ALEN);
+			spin_unlock_bh(&mppath->state_lock);
+		}
+		rcu_read_unlock();
+	}
+	
 	if (compare_ether_addr(rx->dev->dev_addr, hdr->addr3) == 0)
 		return RX_CONTINUE;
 
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 20d6836..e1e11dc 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1498,18 +1498,51 @@ int ieee80211_subif_start_xmit(struct sk_buff *skb,
 #ifdef CONFIG_MAC80211_MESH
 	case NL80211_IFTYPE_MESH_POINT:
 		fc |= cpu_to_le16(IEEE80211_FCTL_FROMDS | IEEE80211_FCTL_TODS);
-		/* RA TA DA SA */
-		memset(hdr.addr1, 0, ETH_ALEN);
-		memcpy(hdr.addr2, dev->dev_addr, ETH_ALEN);
-		memcpy(hdr.addr3, skb->data, ETH_ALEN);
-		memcpy(hdr.addr4, skb->data + ETH_ALEN, ETH_ALEN);
+
 		if (!sdata->u.mesh.mshcfg.dot11MeshTTL) {
 			/* Do not send frames with mesh_ttl == 0 */
 			sdata->u.mesh.mshstats.dropped_frames_ttl++;
 			ret = 0;
 			goto fail;
 		}
-		meshhdrlen = ieee80211_new_mesh_header(&mesh_hdr, sdata);
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
+				rcu_read_lock();
+				mppath = mpp_path_lookup(skb->data, sdata);
+				if (mppath) 
+					memcpy(hdr.addr3, mppath->mpp, ETH_ALEN);
+				else 
+					memcpy(hdr.addr3, broadcast, ETH_ALEN);
+				rcu_read_unlock();
+			}
+
+			mesh_hdr.flags = MESH_DATA_EADD1_EADD2;
+			mesh_hdr.ttl = sdata->u.mesh.mshcfg.dot11MeshTTL;
+			put_unaligned(cpu_to_le32(sdata->u.mesh.mesh_seqnum), &mesh_hdr.seqnum);
+			memcpy(mesh_hdr.eaddr1, skb->data, ETH_ALEN);
+			memcpy(mesh_hdr.eaddr2, skb->data + ETH_ALEN, ETH_ALEN);
+			sdata->u.mesh.mesh_seqnum++;
+			meshhdrlen = 18;
+		}
 		hdrlen = 30;
 		break;
 #endif


