Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:55887 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752494Ab1HYBWM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Aug 2011 21:22:12 -0400
Received: by ywf7 with SMTP id 7so1324861ywf.19
        for <linux-wireless@vger.kernel.org>; Wed, 24 Aug 2011 18:22:11 -0700 (PDT)
From: Thomas Pedersen <thomas@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: Javier Cardona <javier@cozybit.com>, johannes@sipsolutions.net,
	linville@tuxdriver.com
Subject: [PATCH 3/8] Revert "mac80211: mesh gate implementation"
Date: Wed, 24 Aug 2011 18:21:48 -0700
Message-Id: <1314235313-4564-4-git-send-email-thomas@cozybit.com> (sfid-20110825_032222_188045_B4A811A5)
In-Reply-To: <1314235313-4564-1-git-send-email-thomas@cozybit.com>
References: <1314235313-4564-1-git-send-email-thomas@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Javier Cardona <javier@cozybit.com>

This reverts commit 5ee68e5b39de5cefecf147c58711f8ab01c21231.
---
 include/linux/ieee80211.h   |    4 -
 net/mac80211/ieee80211_i.h  |    1 -
 net/mac80211/mesh.c         |    3 +-
 net/mac80211/mesh.h         |   11 --
 net/mac80211/mesh_hwmp.c    |   41 ++-----
 net/mac80211/mesh_pathtbl.c |  284 -------------------------------------------
 6 files changed, 9 insertions(+), 335 deletions(-)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index 37f95f2..03cfbf3 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -633,10 +633,6 @@ struct ieee80211_rann_ie {
 	u32 rann_metric;
 } __attribute__ ((packed));
 
-enum ieee80211_rann_flags {
-	RANN_FLAG_IS_GATE = 1 << 0,
-};
-
 #define WLAN_SA_QUERY_TR_ID_LEN 2
 
 struct ieee80211_mgmt {
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index c204cee..ea74190 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -514,7 +514,6 @@ struct ieee80211_if_mesh {
 	struct mesh_config mshcfg;
 	u32 mesh_seqnum;
 	bool accepting_plinks;
-	int num_gates;
 	const u8 *ie;
 	u8 ie_len;
 	enum {
diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index e120fef..ecdde6c 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -545,7 +545,7 @@ void ieee80211_mesh_quiesce(struct ieee80211_sub_if_data *sdata)
 {
 	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
 
-	/* use atomic bitops in case all timers fire at the same time */
+	/* use atomic bitops in case both timers fire at the same time */
 
 	if (del_timer_sync(&ifmsh->housekeeping_timer))
 		set_bit(TMR_RUNNING_HK, &ifmsh->timers_running);
@@ -752,7 +752,6 @@ void ieee80211_mesh_init_sdata(struct ieee80211_sub_if_data *sdata)
 	ifmsh->accepting_plinks = true;
 	ifmsh->preq_id = 0;
 	ifmsh->sn = 0;
-	ifmsh->num_gates = 0;
 	atomic_set(&ifmsh->mpaths, 0);
 	mesh_rmc_init(sdata);
 	ifmsh->last_preq = jiffies;
diff --git a/net/mac80211/mesh.h b/net/mac80211/mesh.h
index 9d9116e..3c7d0f8 100644
--- a/net/mac80211/mesh.h
+++ b/net/mac80211/mesh.h
@@ -81,7 +81,6 @@ enum mesh_deferred_task_flags {
  * @discovery_retries: number of discovery retries
  * @flags: mesh path flags, as specified on &enum mesh_path_flags
  * @state_lock: mesh path state lock
- * @is_gate: the destination station of this path is a mesh gate
  *
  *
  * The combination of dst and sdata is unique in the mesh path table. Since the
@@ -105,7 +104,6 @@ struct mesh_path {
 	u8 discovery_retries;
 	enum mesh_path_flags flags;
 	spinlock_t state_lock;
-	bool is_gate;
 };
 
 /**
@@ -122,9 +120,6 @@ struct mesh_path {
  *	buckets
  * @mean_chain_len: maximum average length for the hash buckets' list, if it is
  *	reached, the table will grow
- * @known_gates: list of known mesh gates and their mpaths by the station. The
- * gate's mpath may or may not be resolved and active.
- *
  * rcu_head: RCU head to free the table
  */
 struct mesh_table {
@@ -138,8 +133,6 @@ struct mesh_table {
 	int (*copy_node) (struct hlist_node *p, struct mesh_table *newtbl);
 	int size_order;
 	int mean_chain_len;
-	struct hlist_head *known_gates;
-	spinlock_t gates_lock;
 
 	struct rcu_head rcu_head;
 };
@@ -243,10 +236,6 @@ void mesh_path_flush(struct ieee80211_sub_if_data *sdata);
 void mesh_rx_path_sel_frame(struct ieee80211_sub_if_data *sdata,
 		struct ieee80211_mgmt *mgmt, size_t len);
 int mesh_path_add(u8 *dst, struct ieee80211_sub_if_data *sdata);
-
-int mesh_path_add_gate(struct mesh_path *mpath);
-int mesh_path_send_to_gates(struct mesh_path *mpath);
-int mesh_gate_num(struct ieee80211_sub_if_data *sdata);
 /* Mesh plinks */
 void mesh_neighbour_update(u8 *hw_addr, u32 rates,
 		struct ieee80211_sub_if_data *sdata,
diff --git a/net/mac80211/mesh_hwmp.c b/net/mac80211/mesh_hwmp.c
index 7b517c4..abd0347 100644
--- a/net/mac80211/mesh_hwmp.c
+++ b/net/mac80211/mesh_hwmp.c
@@ -696,7 +696,6 @@ static void hwmp_rann_frame_process(struct ieee80211_sub_if_data *sdata,
 	u8 *orig_addr;
 	u32 orig_sn, metric;
 	u32 interval = cpu_to_le32(IEEE80211_MESH_RANN_INTERVAL);
-	bool root_is_gate;
 
 	ttl = rann->rann_ttl;
 	if (ttl <= 1) {
@@ -705,19 +704,12 @@ static void hwmp_rann_frame_process(struct ieee80211_sub_if_data *sdata,
 	}
 	ttl--;
 	flags = rann->rann_flags;
-	root_is_gate = !!(flags & RANN_FLAG_IS_GATE);
 	orig_addr = rann->rann_addr;
 	orig_sn = rann->rann_seq;
 	hopcount = rann->rann_hopcount;
 	hopcount++;
 	metric = rann->rann_metric;
-
-	/*  Ignore our own RANNs */
-	if (memcmp(orig_addr, sdata->vif.addr, ETH_ALEN) == 0)
-		return;
-
-	mhwmp_dbg("received RANN from %pM (is_gate=%d)", orig_addr,
-			root_is_gate);
+	mhwmp_dbg("received RANN from %pM\n", orig_addr);
 
 	rcu_read_lock();
 	mpath = mesh_path_lookup(orig_addr, sdata);
@@ -729,16 +721,9 @@ static void hwmp_rann_frame_process(struct ieee80211_sub_if_data *sdata,
 			sdata->u.mesh.mshstats.dropped_frames_no_route++;
 			return;
 		}
+		mesh_queue_preq(mpath,
+				PREQ_Q_F_START | PREQ_Q_F_REFRESH);
 	}
-
-	if ((!(mpath->flags & (MESH_PATH_ACTIVE | MESH_PATH_RESOLVING)) ||
-	     time_after(jiffies, mpath->exp_time - 1*HZ)) &&
-	     !(mpath->flags & MESH_PATH_FIXED)) {
-		mhwmp_dbg("%s time to refresh root mpath %pM", sdata->name,
-							       orig_addr);
-		mesh_queue_preq(mpath, PREQ_Q_F_START | PREQ_Q_F_REFRESH);
-	}
-
 	if (mpath->sn < orig_sn) {
 		mesh_path_sel_frame_tx(MPATH_RANN, flags, orig_addr,
 				       cpu_to_le32(orig_sn),
@@ -748,9 +733,6 @@ static void hwmp_rann_frame_process(struct ieee80211_sub_if_data *sdata,
 				       0, sdata);
 		mpath->sn = orig_sn;
 	}
-	if (root_is_gate)
-		mesh_path_add_gate(mpath);
-
 	rcu_read_unlock();
 }
 
@@ -1012,32 +994,25 @@ void mesh_path_timer(unsigned long data)
 {
 	struct mesh_path *mpath = (void *) data;
 	struct ieee80211_sub_if_data *sdata = mpath->sdata;
-	int ret;
 
 	if (sdata->local->quiescing)
 		return;
 
 	spin_lock_bh(&mpath->state_lock);
 	if (mpath->flags & MESH_PATH_RESOLVED ||
-			(!(mpath->flags & MESH_PATH_RESOLVING))) {
+			(!(mpath->flags & MESH_PATH_RESOLVING)))
 		mpath->flags &= ~(MESH_PATH_RESOLVING | MESH_PATH_RESOLVED);
-		spin_unlock_bh(&mpath->state_lock);
-	} else if (mpath->discovery_retries < max_preq_retries(sdata)) {
+	else if (mpath->discovery_retries < max_preq_retries(sdata)) {
 		++mpath->discovery_retries;
 		mpath->discovery_timeout *= 2;
-		spin_unlock_bh(&mpath->state_lock);
 		mesh_queue_preq(mpath, 0);
 	} else {
 		mpath->flags = 0;
 		mpath->exp_time = jiffies;
-		spin_unlock_bh(&mpath->state_lock);
-		if (!mpath->is_gate && mesh_gate_num(sdata) > 0) {
-			ret = mesh_path_send_to_gates(mpath);
-			if (ret)
-				mhwmp_dbg("no gate was reachable");
-		} else
-			mesh_path_flush_pending(mpath);
+		mesh_path_flush_pending(mpath);
 	}
+
+	spin_unlock_bh(&mpath->state_lock);
 }
 
 void
diff --git a/net/mac80211/mesh_pathtbl.c b/net/mac80211/mesh_pathtbl.c
index 75e4b60..bcf7fee 100644
--- a/net/mac80211/mesh_pathtbl.c
+++ b/net/mac80211/mesh_pathtbl.c
@@ -66,8 +66,6 @@ static inline struct mesh_table *resize_dereference_mpp_paths(void)
 		lockdep_is_held(&pathtbl_resize_lock));
 }
 
-static int mesh_gate_add(struct mesh_table *tbl, struct mesh_path *mpath);
-
 /*
  * CAREFUL -- "tbl" must not be an expression,
  * in particular not an rcu_dereference(), since
@@ -111,7 +109,6 @@ static struct mesh_table *mesh_table_alloc(int size_order)
 			sizeof(newtbl->hash_rnd));
 	for (i = 0; i <= newtbl->hash_mask; i++)
 		spin_lock_init(&newtbl->hashwlock[i]);
-	spin_lock_init(&newtbl->gates_lock);
 
 	return newtbl;
 }
@@ -127,7 +124,6 @@ static void mesh_table_free(struct mesh_table *tbl, bool free_leafs)
 {
 	struct hlist_head *mesh_hash;
 	struct hlist_node *p, *q;
-	struct mpath_node *gate;
 	int i;
 
 	mesh_hash = tbl->hash_buckets;
@@ -139,17 +135,6 @@ static void mesh_table_free(struct mesh_table *tbl, bool free_leafs)
 		}
 		spin_unlock_bh(&tbl->hashwlock[i]);
 	}
-	if (free_leafs) {
-		spin_lock_bh(&tbl->gates_lock);
-		hlist_for_each_entry_safe(gate, p, q,
-					 tbl->known_gates, list) {
-			hlist_del(&gate->list);
-			kfree(gate);
-		}
-		kfree(tbl->known_gates);
-		spin_unlock_bh(&tbl->gates_lock);
-	}
-
 	__mesh_table_free(tbl);
 }
 
@@ -167,7 +152,6 @@ static int mesh_table_grow(struct mesh_table *oldtbl,
 	newtbl->free_node = oldtbl->free_node;
 	newtbl->mean_chain_len = oldtbl->mean_chain_len;
 	newtbl->copy_node = oldtbl->copy_node;
-	newtbl->known_gates = oldtbl->known_gates;
 	atomic_set(&newtbl->entries, atomic_read(&oldtbl->entries));
 
 	oldhash = oldtbl->hash_buckets;
@@ -227,111 +211,6 @@ void mesh_path_assign_nexthop(struct mesh_path *mpath, struct sta_info *sta)
 	spin_unlock_irqrestore(&mpath->frame_queue.lock, flags);
 }
 
-static void prepare_for_gate(struct sk_buff *skb, char *dst_addr,
-			     struct mesh_path *gate_mpath)
-{
-	struct ieee80211_hdr *hdr;
-	struct ieee80211s_hdr *mshdr;
-	int mesh_hdrlen, hdrlen;
-	char *next_hop;
-
-	hdr = (struct ieee80211_hdr *) skb->data;
-	hdrlen = ieee80211_hdrlen(hdr->frame_control);
-	mshdr = (struct ieee80211s_hdr *) (skb->data + hdrlen);
-
-	if (!(mshdr->flags & MESH_FLAGS_AE)) {
-		/* size of the fixed part of the mesh header */
-		mesh_hdrlen = 6;
-
-		/* make room for the two extended addresses */
-		skb_push(skb, 2 * ETH_ALEN);
-		memmove(skb->data, hdr, hdrlen + mesh_hdrlen);
-
-		hdr = (struct ieee80211_hdr *) skb->data;
-
-		/* we preserve the previous mesh header and only add
-		 * the new addreses */
-		mshdr = (struct ieee80211s_hdr *) (skb->data + hdrlen);
-		mshdr->flags = MESH_FLAGS_AE_A5_A6;
-		memcpy(mshdr->eaddr1, hdr->addr3, ETH_ALEN);
-		memcpy(mshdr->eaddr2, hdr->addr4, ETH_ALEN);
-	}
-
-	/* update next hop */
-	hdr = (struct ieee80211_hdr *) skb->data;
-	rcu_read_lock();
-	next_hop = rcu_dereference(gate_mpath->next_hop)->sta.addr;
-	memcpy(hdr->addr1, next_hop, ETH_ALEN);
-	rcu_read_unlock();
-	memcpy(hdr->addr3, dst_addr, ETH_ALEN);
-}
-
-/**
- *
- * mesh_path_move_to_queue - Move or copy frames from one mpath queue to another
- *
- * This function is used to transfer or copy frames from an unresolved mpath to
- * a gate mpath.  The function also adds the Address Extension field and
- * updates the next hop.
- *
- * If a frame already has an Address Extension field, only the next hop and
- * destination addresses are updated.
- *
- * The gate mpath must be an active mpath with a valid mpath->next_hop.
- *
- * @mpath: An active mpath the frames will be sent to (i.e. the gate)
- * @from_mpath: The failed mpath
- * @copy: When true, copy all the frames to the new mpath queue.  When false,
- * move them.
- */
-static void mesh_path_move_to_queue(struct mesh_path *gate_mpath,
-				    struct mesh_path *from_mpath,
-				    bool copy)
-{
-	struct sk_buff *skb, *cp_skb;
-	struct sk_buff_head gateq, failq;
-	unsigned long flags;
-	int num_skbs;
-
-	BUG_ON(gate_mpath == from_mpath);
-	BUG_ON(!gate_mpath->next_hop);
-
-	__skb_queue_head_init(&gateq);
-	__skb_queue_head_init(&failq);
-
-	spin_lock_irqsave(&from_mpath->frame_queue.lock, flags);
-	skb_queue_splice_init(&from_mpath->frame_queue, &failq);
-	spin_unlock_irqrestore(&from_mpath->frame_queue.lock, flags);
-
-	num_skbs = skb_queue_len(&failq);
-
-	while (num_skbs--) {
-		skb = __skb_dequeue(&failq);
-		if (copy)
-			cp_skb = skb_copy(skb, GFP_ATOMIC);
-
-		prepare_for_gate(skb, gate_mpath->dst, gate_mpath);
-		__skb_queue_tail(&gateq, skb);
-
-		if (copy && cp_skb)
-			__skb_queue_tail(&failq, cp_skb);
-	}
-
-	spin_lock_irqsave(&gate_mpath->frame_queue.lock, flags);
-	skb_queue_splice(&gateq, &gate_mpath->frame_queue);
-	mpath_dbg("Mpath queue for gate %pM has %d frames\n",
-			gate_mpath->dst,
-			skb_queue_len(&gate_mpath->frame_queue));
-	spin_unlock_irqrestore(&gate_mpath->frame_queue.lock, flags);
-
-	if (!copy)
-		return;
-
-	spin_lock_irqsave(&from_mpath->frame_queue.lock, flags);
-	skb_queue_splice(&failq, &from_mpath->frame_queue);
-	spin_unlock_irqrestore(&from_mpath->frame_queue.lock, flags);
-}
-
 
 /**
  * mesh_path_lookup - look up a path in the mesh path table
@@ -431,109 +310,6 @@ struct mesh_path *mesh_path_lookup_by_idx(int idx, struct ieee80211_sub_if_data
 	return NULL;
 }
 
-static void mesh_gate_node_reclaim(struct rcu_head *rp)
-{
-	struct mpath_node *node = container_of(rp, struct mpath_node, rcu);
-	kfree(node);
-}
-
-/**
- * mesh_gate_add - mark mpath as path to a mesh gate and add to known_gates
- * @mesh_tbl: table which contains known_gates list
- * @mpath: mpath to known mesh gate
- *
- * Returns: 0 on success
- *
- */
-static int mesh_gate_add(struct mesh_table *tbl, struct mesh_path *mpath)
-{
-	struct mpath_node *gate, *new_gate;
-	struct hlist_node *n;
-	int err;
-
-	rcu_read_lock();
-	tbl = rcu_dereference(tbl);
-
-	hlist_for_each_entry_rcu(gate, n, tbl->known_gates, list)
-		if (gate->mpath == mpath) {
-			err = -EEXIST;
-			goto err_rcu;
-		}
-
-	new_gate = kzalloc(sizeof(struct mpath_node), GFP_ATOMIC);
-	if (!new_gate) {
-		err = -ENOMEM;
-		goto err_rcu;
-	}
-
-	mpath->is_gate = true;
-	mpath->sdata->u.mesh.num_gates++;
-	new_gate->mpath = mpath;
-	spin_lock_bh(&tbl->gates_lock);
-	hlist_add_head_rcu(&new_gate->list, tbl->known_gates);
-	spin_unlock_bh(&tbl->gates_lock);
-	rcu_read_unlock();
-	mpath_dbg("Mesh path (%s): Recorded new gate: %pM. %d known gates\n",
-		  mpath->sdata->name, mpath->dst,
-		  mpath->sdata->u.mesh.num_gates);
-	return 0;
-err_rcu:
-	rcu_read_unlock();
-	return err;
-}
-
-/**
- * mesh_gate_del - remove a mesh gate from the list of known gates
- * @tbl: table which holds our list of known gates
- * @mpath: gate mpath
- *
- * Returns: 0 on success
- *
- * Locking: must be called inside rcu_read_lock() section
- */
-static int mesh_gate_del(struct mesh_table *tbl, struct mesh_path *mpath)
-{
-	struct mpath_node *gate;
-	struct hlist_node *p, *q;
-
-	tbl = rcu_dereference(tbl);
-
-	hlist_for_each_entry_safe(gate, p, q, tbl->known_gates, list)
-		if (gate->mpath == mpath) {
-			spin_lock_bh(&tbl->gates_lock);
-			hlist_del_rcu(&gate->list);
-			call_rcu(&gate->rcu, mesh_gate_node_reclaim);
-			spin_unlock_bh(&tbl->gates_lock);
-			mpath->sdata->u.mesh.num_gates--;
-			mpath->is_gate = false;
-			mpath_dbg("Mesh path (%s): Deleted gate: %pM. "
-				  "%d known gates\n", mpath->sdata->name,
-				  mpath->dst, mpath->sdata->u.mesh.num_gates);
-			break;
-		}
-
-	return 0;
-}
-
-/**
- *
- * mesh_path_add_gate - add the given mpath to a mesh gate to our path table
- * @mpath: gate path to add to table
- */
-int mesh_path_add_gate(struct mesh_path *mpath)
-{
-	return mesh_gate_add(mesh_paths, mpath);
-}
-
-/**
- * mesh_gate_num - number of gates known to this interface
- * @sdata: subif data
- */
-int mesh_gate_num(struct ieee80211_sub_if_data *sdata)
-{
-	return sdata->u.mesh.num_gates;
-}
-
 /**
  * mesh_path_add - allocate and add a new path to the mesh path table
  * @addr: destination address of the path (ETH_ALEN length)
@@ -879,8 +655,6 @@ int mesh_path_del(u8 *addr, struct ieee80211_sub_if_data *sdata)
 		if (mpath->sdata == sdata &&
 		    memcmp(addr, mpath->dst, ETH_ALEN) == 0) {
 			spin_lock_bh(&mpath->state_lock);
-			if (mpath->is_gate)
-				mesh_gate_del(tbl, mpath);
 			mpath->flags |= MESH_PATH_RESOLVING;
 			hlist_del_rcu(&node->list);
 			call_rcu(&node->rcu, mesh_path_node_reclaim);
@@ -914,58 +688,6 @@ void mesh_path_tx_pending(struct mesh_path *mpath)
 }
 
 /**
- * mesh_path_send_to_gates - sends pending frames to all known mesh gates
- *
- * @mpath: mesh path whose queue will be emptied
- *
- * If there is only one gate, the frames are transferred from the failed mpath
- * queue to that gate's queue.  If there are more than one gates, the frames
- * are copied from each gate to the next.  After frames are copied, the
- * mpath queues are emptied onto the transmission queue.
- */
-int mesh_path_send_to_gates(struct mesh_path *mpath)
-{
-	struct ieee80211_sub_if_data *sdata = mpath->sdata;
-	struct hlist_node *n;
-	struct mesh_table *tbl;
-	struct mesh_path *from_mpath = mpath;
-	struct mpath_node *gate = NULL;
-	bool copy = false;
-	struct hlist_head *known_gates;
-
-	rcu_read_lock();
-	tbl = rcu_dereference(mesh_paths);
-	known_gates = tbl->known_gates;
-	rcu_read_unlock();
-
-	if (!known_gates)
-		return -EHOSTUNREACH;
-
-	hlist_for_each_entry_rcu(gate, n, known_gates, list) {
-		if (gate->mpath->sdata != sdata)
-			continue;
-
-		if (gate->mpath->flags & MESH_PATH_ACTIVE) {
-			mpath_dbg("Forwarding to %pM\n", gate->mpath->dst);
-			mesh_path_move_to_queue(gate->mpath, from_mpath, copy);
-			from_mpath = gate->mpath;
-			copy = true;
-		} else {
-			mpath_dbg("Not forwarding %p\n", gate->mpath);
-			mpath_dbg("flags %x\n", gate->mpath->flags);
-		}
-	}
-
-	hlist_for_each_entry_rcu(gate, n, known_gates, list)
-		if (gate->mpath->sdata == sdata) {
-			mpath_dbg("Sending to %pM\n", gate->mpath->dst);
-			mesh_path_tx_pending(gate->mpath);
-		}
-
-	return (from_mpath == mpath) ? -EHOSTUNREACH : 0;
-}
-
-/**
  * mesh_path_discard_frame - discard a frame whose path could not be resolved
  *
  * @skb: frame to discard
@@ -1082,9 +804,6 @@ int mesh_pathtbl_init(void)
 	tbl_path->free_node = &mesh_path_node_free;
 	tbl_path->copy_node = &mesh_path_node_copy;
 	tbl_path->mean_chain_len = MEAN_CHAIN_LEN;
-	tbl_path->known_gates = kzalloc(sizeof(struct hlist_head), GFP_ATOMIC);
-	INIT_HLIST_HEAD(tbl_path->known_gates);
-
 
 	tbl_mpp = mesh_table_alloc(INIT_PATHS_SIZE_ORDER);
 	if (!tbl_mpp) {
@@ -1094,9 +813,6 @@ int mesh_pathtbl_init(void)
 	tbl_mpp->free_node = &mesh_path_node_free;
 	tbl_mpp->copy_node = &mesh_path_node_copy;
 	tbl_mpp->mean_chain_len = MEAN_CHAIN_LEN;
-	/* XXX: not needed */
-	tbl_mpp->known_gates = kzalloc(sizeof(struct hlist_head), GFP_ATOMIC);
-	INIT_HLIST_HEAD(tbl_mpp->known_gates);
 
 	/* Need no locking since this is during init */
 	RCU_INIT_POINTER(mesh_paths, tbl_path);
-- 
1.7.4.1

