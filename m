Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hs-out-0708.google.com ([64.233.178.246]:32775 "EHLO
	hs-out-2122.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754516AbYBDVYm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Feb 2008 16:24:42 -0500
Received: by hs-out-2122.google.com with SMTP id 54so2007359hsz.5
        for <linux-wireless@vger.kernel.org>; Mon, 04 Feb 2008 13:24:41 -0800 (PST)
To: linux-wireless@vger.kernel.org
From: Luis Carlos Cobo <luisca@cozybit.com>
Date: Mon, 4 Feb 2008 11:43:51 -0800
Subject: [PATCH 11/13] o11s: mesh path table support
Message-ID: <47a78297.02b38c0a.14b1.ffffc35e@mx.google.com> (sfid-20080204_213833_882201_23B56978)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The mesh path table associates destinations with the next hop to reach them. The
table is implemented like the mesh peer link table and it also includes support
for table manipulations via rtnl.

Each outgoing mesh frame requires a look up into this table. Therefore, the
table it has been designed so it is not necessary to hold any lock to find the
appropriate next hop.

If the path is determined to be active within a rcu context we can safely
dereference mpath->next_hop->ha. To achieve this, after a mesh path has been set
active for the first time its next_hop must always point to a valid peer link.
If this is not possible the mpath must be deleted or replaced in a RCU safe
fashion.

Signed-off-by: Luis Carlos Cobo <luisca@cozybit.com>
---
 net/mac80211/mesh_pathtbl.c |  648 +++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 648 insertions(+), 0 deletions(-)
 create mode 100644 net/mac80211/mesh_pathtbl.c

diff --git a/net/mac80211/mesh_pathtbl.c b/net/mac80211/mesh_pathtbl.c
new file mode 100644
index 0000000..e610651
--- /dev/null
+++ b/net/mac80211/mesh_pathtbl.c
@@ -0,0 +1,648 @@
+/*
+ * Copyright (c) 2008 open80211s Ltd.
+ * Author:     Luis Carlos Cobo <luisca@cozybit.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/etherdevice.h>
+#include <linux/list.h>
+#include <linux/netdevice.h>
+#include <linux/random.h>
+#include <linux/spinlock.h>
+#include <linux/string.h>
+#include <net/mac80211.h>
+#include <net/rtnetlink.h>
+#include "ieee80211_i.h"
+#include "mesh.h"
+
+/* There will be initially 2^INIT_PATHS_SIZE_ORDER buckets */
+#define INIT_PATHS_SIZE_ORDER 2
+
+/* Keep the mean chain length below this constant */
+#define MEAN_CHAIN_LEN 2
+
+#define MPATH_EXPIRED(mpath) ((mpath->flags & MESH_PATH_ACTIVE) && \
+				time_after(jiffies, mpath->lifetime) && \
+				!(mpath->flags & MESH_PATH_FIXED))
+
+struct mpath_node {
+	struct hlist_node list;
+	struct rcu_head rcu;
+	/* This indirection allows two different tables to point to the same
+	 * mesh_path structure, useful when resizing
+	 */
+	struct mesh_path *mpath;
+};
+
+static struct mesh_table *mesh_paths;
+
+/* This lock will have the grow table function as writer and add / delete nodes
+ * as readers. When reading the table (i.e. doing lookups) we are well protected
+ * by RCU
+ */
+static DEFINE_RWLOCK(pathtbl_resize_lock);
+
+static const struct nla_policy mpa_policy[MPA_MAX+1] = {
+	[MPA_DST]               = { .len = ETH_ALEN },
+	[MPA_NEXT_HOP]          = { .len = ETH_ALEN },
+	[MPA_FRAME_QLEN]	= { .type = NLA_U32 },
+	[MPA_DSN]		= { .type = NLA_U32 },
+	[MPA_METRIC]		= { .type = NLA_U32 },
+	[MPA_LIFETIME]		= { .type = NLA_U32 },
+	[MPA_FLAGS]		= { .type = NLA_U8 },
+	[MPA_DISCOVERY_TIMEOUT]	= { .type = NLA_U32 },
+	[MPA_DISCOVERY_RETRIES]	= { .type = NLA_U8 },
+};
+
+/**
+ * mesh_path_lookup - looks up a path in the mesh path table
+ * @dst: hardware address (ETH_ALEN length) of destination
+ * @dev: local interface
+ *
+ * Returns: pointer to the mesh path structure, or NULL if not found
+ *
+ * RCU: must be called in a read rcu section.
+ */
+struct mesh_path *mesh_path_lookup(u8 *dst, struct net_device *dev)
+{
+	struct mesh_path *mpath;
+	struct hlist_node *n;
+	struct hlist_head *bucket;
+	struct mesh_table *tbl;
+	struct mpath_node *node;
+
+	tbl = rcu_dereference(mesh_paths);
+
+	bucket = &tbl->hash_buckets[mesh_hash_idx(dst, dev, tbl)];
+	hlist_for_each_entry_rcu(node, n, bucket, list) {
+		mpath = node->mpath;
+		if (mpath->dev == dev &&
+				memcmp(dst, mpath->dst, ETH_ALEN) == 0) {
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
+/* add_mesh_path - allocate and add a new path to the mesh path table
+ * @addr: destination address of the path (ETH_ALEN length)
+ * @dev: local interface
+ *
+ * Returns: 0 on sucess
+ *
+ * State: the initial state of the new path is set to 0
+ */
+int add_mesh_path(u8 *dst, struct net_device *dev)
+{
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	struct mesh_path *mpath, *new_mpath;
+	struct mpath_node *node, *new_node;
+	struct hlist_head *bucket;
+	struct hlist_node *n;
+	int grow = 0;
+	int err = 0;
+	u32 hash_idx;
+
+	if (memcmp(dst, dev->dev_addr, ETH_ALEN) == 0)
+		/* never add ourselves as neighbours */
+		return -ENOTSUPP;
+
+	if (is_multicast_ether_addr(dst))
+		return -ENOTSUPP;
+
+	if (atomic_add_unless(&sdata->u.sta.mpaths, 1, MESH_MAX_MPATHS) == 0)
+		return -ENOSPC;
+
+	read_lock(&pathtbl_resize_lock);
+
+	new_mpath = kzalloc(sizeof(struct mesh_path), GFP_KERNEL);
+	if (!new_mpath) {
+		atomic_dec(&sdata->u.sta.mpaths);
+		err = -ENOMEM;
+		goto endadd2;
+	}
+	memcpy(new_mpath->dst, dst, ETH_ALEN);
+	new_mpath->dev = dev;
+	new_mpath->flags = 0;
+	skb_queue_head_init(&new_mpath->frame_queue);
+	new_node = kmalloc(sizeof(struct mpath_node), GFP_KERNEL);
+	new_node->mpath = new_mpath;
+	new_mpath->timer.data = (unsigned long) new_mpath;
+	new_mpath->timer.function = mpath_timer;
+	new_mpath->lifetime = jiffies;
+	spin_lock_init(&new_mpath->state_lock);
+	init_timer(&new_mpath->timer);
+
+	hash_idx = mesh_hash_idx(dst, dev, mesh_paths);
+	bucket = &mesh_paths->hash_buckets[hash_idx];
+
+	spin_lock(&mesh_paths->hashwlock[hash_idx]);
+
+	hlist_for_each_entry(node, n, bucket, list) {
+		mpath = node->mpath;
+		if (mpath->dev == dev && memcmp(dst, mpath->dst, ETH_ALEN)
+				== 0) {
+			err = -EEXIST;
+			atomic_dec(&sdata->u.sta.mpaths);
+			kfree(new_node);
+			kfree(new_mpath);
+			goto endadd;
+		}
+	}
+
+	hlist_add_head_rcu(&new_node->list, bucket);
+	if (atomic_inc_return(&mesh_paths->entries) >=
+		mesh_paths->mean_chain_len * (mesh_paths->hash_mask + 1))
+		grow = 1;
+
+endadd:
+	spin_unlock(&mesh_paths->hashwlock[hash_idx]);
+endadd2:
+	read_unlock(&pathtbl_resize_lock);
+	if (!err && grow) {
+		struct mesh_table *oldtbl, *newtbl;
+
+		write_lock(&pathtbl_resize_lock);
+		oldtbl = mesh_paths;
+		newtbl = grow_mesh_table(mesh_paths);
+		if (!newtbl) {
+			write_unlock(&pathtbl_resize_lock);
+			return -ENOMEM;
+		}
+		rcu_assign_pointer(mesh_paths, newtbl);
+		synchronize_rcu();
+		free_mesh_table(oldtbl, false);
+		write_unlock(&pathtbl_resize_lock);
+	}
+	return err;
+}
+
+
+/**
+ *  mesh_broken_link - deactivates paths and sends perr when a link breaks
+ *
+ *  Locking: it must be callend within a rcu_read_lock block
+ */
+void mesh_broken_link(u8 *dst, struct net_device *dev)
+{
+	struct mesh_plink *mpl;
+	struct mesh_path *mpath;
+	struct mpath_node *node;
+	struct hlist_node *p;
+	int i;
+
+	mpl = mesh_plink_lookup(dst, dev);
+
+	if (!mpl)
+		return;
+
+	for_each_mesh_entry(mesh_paths, p, node, i) {
+		mpath = node->mpath;
+		spin_lock_bh(&mpath->state_lock);
+		if (mpath->next_hop == mpl) {
+			mpath->flags &= ~MESH_PATH_ACTIVE;
+			mpath->flags &= ~MESH_PATH_FIXED;
+			++mpath->dsn;
+			spin_unlock_bh(&mpath->state_lock);
+			mesh_send_path_error(mpath->dst,
+					cpu_to_le32(mpath->dsn),
+					dev->broadcast, dev);
+		} else
+		spin_unlock_bh(&mpath->state_lock);
+	}
+}
+
+/**
+ * deactivate_mpaths_by_nh - Deactivate mesh paths if their next hop matches
+ *
+ * @mpl - mesh plink to match
+ *
+ * RCU notes: this function is called when a mesh plink transitions from ESTAB
+ * to any other state, since ESTAB state is the only one that allows path
+ * creation. This will happen before the plink can be freed, so any reader in a
+ * rcu read block will be protected against the plink dissapearing. The mpath is
+ * deleted, instead of just setting mpath->next_hop = NULL, this way is safe for
+ * readers to do if (mpath->state & MESH_PATH_ACTIVE) {memcpy(xxx,
+ * mpath->next_hop->ha,...)} without locks.
+ */
+void deactivate_mpaths_by_nh(struct mesh_plink *mpl)
+{
+	struct mesh_path *mpath;
+	struct mpath_node *node;
+	struct hlist_node *p;
+	int i;
+
+	for_each_mesh_entry(mesh_paths, p, node, i) {
+		mpath = node->mpath;
+		if (mpath->next_hop == mpl)
+			del_mesh_path(mpath->dst, mpath->dev);
+	}
+}
+
+
+static void mpath_node_reclaim(struct rcu_head *rp)
+{
+	struct mpath_node *node = container_of(rp, struct mpath_node, rcu);
+	struct ieee80211_sub_if_data *sdata =
+		IEEE80211_DEV_TO_SUB_IF(node->mpath->dev);
+	atomic_dec(&sdata->u.sta.mpaths);
+	kfree(node->mpath);
+	kfree(node);
+}
+
+/**
+ * del_mesh_path - Delete a mesh path from the table
+ * @addr: dst address (ETH_ALEN length)
+ * @dev: local interface
+ *
+ * Returns: 0 if succesful
+ *
+ * State: if the path is being resolved, the deletion will be postponed till the
+ * path resolution completes or times out.
+ */
+int del_mesh_path(u8 *addr, struct net_device *dev)
+{
+	struct mesh_path *mpath;
+	struct mpath_node *node;
+	struct hlist_head *bucket;
+	struct hlist_node *n;
+	int hash_idx;
+	int err = 0;
+
+	read_lock(&pathtbl_resize_lock);
+	hash_idx = mesh_hash_idx(addr, dev, mesh_paths);
+	bucket = &mesh_paths->hash_buckets[hash_idx];
+
+	spin_lock(&mesh_paths->hashwlock[hash_idx]);
+	hlist_for_each_entry(node, n, bucket, list) {
+		mpath = node->mpath;
+		if (mpath->dev == dev &&
+				memcmp(addr, mpath->dst, ETH_ALEN) == 0) {
+			spin_lock_bh(&mpath->state_lock);
+			if (mpath->flags & MESH_PATH_RESOLVING) {
+				mpath->flags |= MESH_PATH_DELETE;
+			} else {
+				mpath->flags |= MESH_PATH_RESOLVING;
+				hlist_del_rcu(&node->list);
+				call_rcu(&node->rcu, mpath_node_reclaim);
+				atomic_dec(&mesh_paths->entries);
+			}
+			spin_unlock_bh(&mpath->state_lock);
+			goto enddel;
+		}
+	}
+
+	err = -ENXIO;
+enddel:
+	spin_unlock(&mesh_paths->hashwlock[hash_idx]);
+	read_unlock(&pathtbl_resize_lock);
+	return err;
+}
+
+/**
+ * send_path_pending_frames - sends pending frames in a mesh path queue
+ *
+ * @mpath: mesh path to activate
+ *
+ * Locking: the state_lock of the mpath structure must NOT be held when calling
+ * this function.
+ */
+void send_path_pending_frames(struct mesh_path *mpath)
+{
+	struct sk_buff *skb;
+
+	while ((skb = skb_dequeue(&mpath->frame_queue)) &&
+			(mpath->flags & MESH_PATH_ACTIVE))
+		dev_queue_xmit(skb);
+}
+
+/**
+ * mesh_path_discard_frame - discard a frame whose path could not be resolved
+ *
+ * @skb: 	frame to discard
+ * @dev: network device the frame was to be sent through
+ *
+ * Locking: the function must me called withing a rcu_read_lock region
+ */
+void mesh_path_discard_frame(struct sk_buff *skb, struct net_device *dev)
+{
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	struct mesh_path *mpath;
+	u32 dsn = 0;
+
+	if (skb->pkt_type == PACKET_OTHERHOST) {
+		struct ieee80211s_hdr *prev_meshhdr;
+		int mshhdrlen;
+		u8 *ra, *da;
+
+		prev_meshhdr = ((struct ieee80211s_hdr *)skb->cb);
+		mshhdrlen = ieee80211_get_mesh_hdrlen(prev_meshhdr);
+		da = skb->data;
+		ra = MESH_PREQ(skb);
+		mpath = mesh_path_lookup(da, dev);
+		if (mpath)
+			dsn = ++mpath->dsn;
+		mesh_send_path_error(skb->data, cpu_to_le32(dsn), ra, dev);
+	}
+
+	kfree_skb(skb);
+	sdata->u.sta.mshstats.dropped_frames_no_route++;
+}
+
+/**
+ * mpath_empty_pending_queue - free the pending queue of a mesh path
+ *
+ * @mpath: mesh path whose queue has to be freed
+ *
+ * Locking: the function must me called withing a rcu_read_lock region
+ */
+void mpath_empty_pending_queue(struct mesh_path *mpath)
+{
+	struct ieee80211_sub_if_data *sdata;
+	struct sk_buff *skb;
+
+	sdata = IEEE80211_DEV_TO_SUB_IF(mpath->dev);
+
+	while ((skb = skb_dequeue(&mpath->frame_queue)) &&
+			(mpath->flags & MESH_PATH_ACTIVE))
+		mesh_path_discard_frame(skb, mpath->dev);
+}
+
+static int rtnl_newmeshpath(struct sk_buff *skb, struct nlmsghdr *nlh,
+		void *arg)
+{
+	struct mpmsg *mpm;
+	struct nlattr *tb[MPA_MAX+1];
+	struct mesh_path *mpath;
+	struct mesh_plink *mpl;
+	struct net_device *dev;
+	struct ieee80211_sub_if_data *sdata;
+	int err;
+
+	err = nlmsg_parse(nlh, sizeof(*mpm), tb, MPA_MAX, mpa_policy);
+	if (err < 0)
+		return err;
+
+	mpm = nlmsg_data(nlh);
+	if (!tb[MPA_DST] || !tb[MPA_NEXT_HOP])
+		return -EINVAL;
+
+	dev = __dev_get_by_index(&init_net, mpm->ifa_index);
+
+	if (!dev->ieee80211_ptr || !dev->ieee80211_ptr->wiphy)
+		return -ENOTSUPP;
+
+	if (dev->ieee80211_ptr->wiphy->privid != mac80211_wiphy_privid)
+		return -ENOTSUPP;
+
+	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	if (sdata->vif.type != IEEE80211_IF_TYPE_MESH_POINT ||
+			sdata->u.sta.state != IEEE80211_MESH_UP)
+		return -ENOTSUPP;
+
+	if (memcmp(nla_data(tb[MPA_DST]), dev->dev_addr, ETH_ALEN) == 0)
+		return -ENOTSUPP;
+
+	add_mesh_path(nla_data(tb[MPA_DST]), dev);
+	rcu_read_lock();
+	mpath = mesh_path_lookup(nla_data(tb[MPA_DST]), dev);
+	if (!mpath) {
+		rcu_read_unlock();
+		return -ENOMEM;
+	}
+
+	mpl = mesh_plink_lookup(nla_data(tb[MPA_NEXT_HOP]), dev);
+	if (!mpl || !(mpl->state == ESTAB)) {
+		rcu_read_unlock();
+		return -ENXIO;
+	}
+
+	spin_lock_bh(&mpath->state_lock);
+	mpath->next_hop = mpl;
+	mpath->dsn = 0xffff;
+	mpath->metric = 0;
+	mpath->hop_count = 0;
+	mpath->lifetime = 0;
+	mpath->flags |= MESH_PATH_FIXED;
+	activate_path(mpath);
+	spin_unlock_bh(&mpath->state_lock);
+	send_path_pending_frames(mpath);
+	rcu_read_unlock();
+	return 0;
+}
+
+static int rtnl_delmeshpath(struct sk_buff *skb, struct nlmsghdr *nlh,
+		void *arg)
+{
+	struct mpmsg *mpm;
+	struct nlattr *tb[MPA_MAX+1];
+	struct net_device *dev;
+	struct ieee80211_sub_if_data *sdata;
+	int err;
+
+	err = nlmsg_parse(nlh, sizeof(*mpm), tb, MPA_MAX, mpa_policy);
+	if (err < 0)
+		return err;
+
+	mpm = nlmsg_data(nlh);
+	if (!tb[MPA_DST])
+		return -EINVAL;
+
+	dev = __dev_get_by_index(&init_net, mpm->ifa_index);
+
+	if (!dev->ieee80211_ptr || !dev->ieee80211_ptr->wiphy)
+		return -ENOTSUPP;
+
+	if (dev->ieee80211_ptr->wiphy->privid != mac80211_wiphy_privid)
+		return -ENOTSUPP;
+
+	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	if (sdata->vif.type != IEEE80211_IF_TYPE_MESH_POINT ||
+			sdata->u.sta.state != IEEE80211_MESH_UP)
+		return -ENOTSUPP;
+
+	return del_mesh_path(nla_data(tb[MPA_DST]), dev);
+}
+
+static int rtnl_getmeshpath(struct sk_buff *skb, struct nlmsghdr *nlh,
+		void *arg)
+{
+	return -ENOTSUPP;
+}
+
+static int rtnl_dumpmeshpaths(struct sk_buff *skb,
+		struct netlink_callback *cb)
+{
+	int idx = 0 ;
+	int s_idx = cb->args[0];
+	int b_idx = cb->args[1];
+	struct mesh_path *mpath;
+	struct mpath_node *node;
+	struct nlmsghdr *nlh;
+	struct mpmsg *hdr;
+	struct hlist_node *n;
+	struct mesh_table *tbl;
+	u32 lifetime;
+	u8 no_nh[6] = {0x0, 0x0, 0x0, 0x0, 0x0, 0x0};
+
+	rcu_read_lock();
+	tbl = rcu_dereference(mesh_paths);
+	for (; b_idx <= tbl->hash_mask; ++b_idx) {
+		hlist_for_each_entry_rcu(node, n,
+			&tbl->hash_buckets[b_idx], list) {
+			mpath = node->mpath;
+			if (idx < s_idx) {
+				idx++;
+				continue;
+			}
+			nlh = nlmsg_put(skb, NETLINK_CB(cb->skb).pid,
+					cb->nlh->nlmsg_seq, RTM_NEWMESHPATH,
+					sizeof(*hdr), NLM_F_MULTI);
+			if (nlh == NULL)
+				goto nlh_failure;
+			hdr = nlmsg_data(nlh);
+			hdr->ifa_index = mpath->dev->ifindex;
+			hdr->mpm_flags = 0;
+			NLA_PUT(skb, MPA_DST, ETH_ALEN, mpath->dst);
+			spin_lock_bh(&mpath->state_lock);
+			if (MPATH_EXPIRED(mpath))
+				mpath->flags &= ~MESH_PATH_ACTIVE;
+			spin_unlock_bh(&mpath->state_lock);
+			if (mpath->next_hop)
+				NLA_PUT(skb, MPA_NEXT_HOP, ETH_ALEN,
+						mpath->next_hop->ha);
+			else
+				NLA_PUT(skb, MPA_NEXT_HOP, ETH_ALEN, no_nh);
+			NLA_PUT(skb, MPA_FRAME_QLEN, 4,
+					&mpath->frame_queue.qlen);
+			NLA_PUT(skb, MPA_DSN, 4, &mpath->dsn);
+			NLA_PUT(skb, MPA_METRIC, 4, &mpath->metric);
+			lifetime = (u32) (mpath->lifetime & 0xffffffff);
+			NLA_PUT(skb, MPA_LIFETIME, 4, &lifetime);
+			NLA_PUT(skb, MPA_FLAGS, 2, &mpath->flags);
+			NLA_PUT(skb, MPA_DISCOVERY_TIMEOUT, 4,
+				&mpath->discovery_timeout);
+			NLA_PUT(skb, MPA_DISCOVERY_RETRIES, 2,
+				&mpath->discovery_retries);
+			nlmsg_end(skb, nlh);
+			break;
+		}
+		if (skb->len)
+			break;
+		idx = 0;
+		s_idx = 0;
+	}
+	rcu_read_unlock();
+	cb->args[0] = idx+1;
+	cb->args[1] = b_idx;
+	return skb->len;
+
+nla_put_failure:
+	nlmsg_cancel(skb, nlh);
+nlh_failure:
+	rcu_read_unlock();
+	return -EMSGSIZE;
+}
+
+static void free_mpath_node(struct hlist_node *p, bool free_leafs)
+{
+	struct mesh_path *mpath;
+	struct mpath_node *node = hlist_entry(p, struct mpath_node, list);
+	mpath = node->mpath;
+	hlist_del_rcu(p);
+	synchronize_rcu();
+	if (free_leafs)
+		kfree(mpath);
+	kfree(node);
+}
+
+static void copy_mpath_node(struct hlist_node *p, struct mesh_table *newtbl)
+{
+	struct mesh_path *mpath;
+	struct mpath_node *node, *new_node;
+	u32 hash_idx;
+
+	node = hlist_entry(p, struct mpath_node, list);
+	mpath = node->mpath;
+	new_node = kmalloc(sizeof(struct mpath_node), GFP_KERNEL);
+	new_node->mpath = mpath;
+	hash_idx = mesh_hash_idx(mpath->dst, mpath->dev, newtbl);
+	hlist_add_head(&new_node->list,
+			&newtbl->hash_buckets[hash_idx]);
+}
+
+int mesh_pathtbl_init(void)
+{
+	mesh_paths = alloc_mesh_table(INIT_PATHS_SIZE_ORDER);
+	mesh_paths->free_node = &free_mpath_node;
+	mesh_paths->copy_node = &copy_mpath_node;
+	mesh_paths->mean_chain_len = MEAN_CHAIN_LEN;
+	if (!mesh_paths)
+		return -ENOMEM;
+	rtnl_register(PF_UNSPEC, RTM_NEWMESHPATH, rtnl_newmeshpath, NULL);
+	rtnl_register(PF_UNSPEC, RTM_GETMESHPATH, rtnl_getmeshpath,
+			rtnl_dumpmeshpaths);
+	rtnl_register(PF_UNSPEC, RTM_DELMESHPATH, rtnl_delmeshpath, NULL);
+	return 0;
+}
+
+void mesh_path_gc(void)
+{
+	struct mesh_path *mpath;
+	struct mpath_node *node;
+	struct hlist_node *p;
+	int i;
+
+	read_lock(&pathtbl_resize_lock);
+	for_each_mesh_entry(mesh_paths, p, node, i) {
+		mpath = node->mpath;
+		spin_lock_bh(&mpath->state_lock);
+		if ((!(mpath->flags & MESH_PATH_RESOLVING)) &&
+		    (!(mpath->flags & MESH_PATH_FIXED)) &&
+			time_after(jiffies,
+			 mpath->lifetime + IEEE80211_MESH_PATH_GC)) {
+			spin_unlock_bh(&mpath->state_lock);
+			del_mesh_path(mpath->dst, mpath->dev);
+		} else
+			spin_unlock_bh(&mpath->state_lock);
+	}
+	read_unlock(&pathtbl_resize_lock);
+}
+
+void flush_mesh_paths(struct net_device *dev)
+{
+	struct mesh_path *mpath;
+	struct mpath_node *node;
+	struct hlist_node *p;
+	int i;
+
+	read_lock(&pathtbl_resize_lock);
+	for_each_mesh_entry(mesh_paths, p, node, i) {
+		mpath = node->mpath;
+		spin_lock_bh(&mpath->state_lock);
+		if (mpath->dev == dev) {
+			spin_unlock_bh(&mpath->state_lock);
+			del_mesh_path(mpath->dst, mpath->dev);
+		} else
+			spin_unlock_bh(&mpath->state_lock);
+	}
+	read_unlock(&pathtbl_resize_lock);
+}
+
+void mesh_pathtbl_unregister(void)
+{
+	rtnl_unregister(PF_UNSPEC, RTM_NEWMESHPATH);
+	rtnl_unregister(PF_UNSPEC, RTM_DELMESHPATH);
+	rtnl_unregister(PF_UNSPEC, RTM_GETMESHPATH);
+
+	free_mesh_table(mesh_paths, true);
+}
-- 
1.5.2.5



