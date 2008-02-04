Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.247]:37584 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753325AbYBDVYc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Feb 2008 16:24:32 -0500
Received: by an-out-0708.google.com with SMTP id d31so556800and.103
        for <linux-wireless@vger.kernel.org>; Mon, 04 Feb 2008 13:24:32 -0800 (PST)
To: linux-wireless@vger.kernel.org
From: Luis Carlos Cobo <luisca@cozybit.com>
Date: Mon, 4 Feb 2008 11:27:47 -0800
Subject: [PATCH 09/13] o11s: mesh peer link table
Message-ID: <47a7828d.070c360a.34c3.ffff9a31@mx.google.com> (sfid-20080204_212436_076286_EB226265)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This table holds an entry per each mesh peer link (a.k.a plink). The table is a
hash of linked lists protected by rcu mechanisms. Every entry contains a lock
for the finite state machine associated with each mesh plink. This file includes
support to manipulate the table through rtnl.

Signed-off-by: Luis Carlos Cobo <luisca@cozybit.com>
---
 net/mac80211/mesh_plinktbl.c |  500 ++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 500 insertions(+), 0 deletions(-)
 create mode 100644 net/mac80211/mesh_plinktbl.c

diff --git a/net/mac80211/mesh_plinktbl.c b/net/mac80211/mesh_plinktbl.c
new file mode 100644
index 0000000..976f75f
--- /dev/null
+++ b/net/mac80211/mesh_plinktbl.c
@@ -0,0 +1,500 @@
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
+/* There will be initially 2^INIT_NEIGH_SIZE_ORDER buckets */
+#define INIT_NEIGH_SIZE_ORDER	2
+
+/* Keep the mean chain length below this constant */
+#define MEAN_CHAIN_LEN		2
+
+struct mplink_node {
+	struct hlist_node list;
+	struct rcu_head rcu;
+	/* This indirection allows two different tables to point to the same
+	 * mesh_plink structures, useful when resizing
+	 */
+	struct mesh_plink *mpl;
+};
+
+static struct mesh_table *mesh_plinks;
+
+/* This lock will have the grow table function as writer and add / delete nodes
+ * as readers. When reading the table (i.e. doing lookups) we are well protected
+ * by RCU
+ */
+static DEFINE_RWLOCK(plinktbl_resize_lock);
+
+void deactivate_plink(struct mesh_plink *mpl)
+{
+	struct ieee80211_sub_if_data *sdata;
+	sdata = IEEE80211_DEV_TO_SUB_IF(mpl->dev);
+	if (mpl->state == ESTAB)
+		plink_dec(sdata);
+	mpl->state = BLOCKED;
+	deactivate_mpaths_by_nh(mpl);
+}
+
+/**
+ * mesh_plink_lookup - looks up an MP on the MP table
+ * @addr: hardware address (ETH_ALEN length) of the mesh peer
+ * @dev: local interface
+ *
+ * Returns: pointer to the mesh peer structure, or NULL if not found
+ *
+ * RCU This function must be called within a rcu_read_lock block
+ */
+struct mesh_plink *mesh_plink_lookup(u8 *hw_addr, struct net_device *dev)
+{
+	struct mesh_plink *mpl;
+	struct hlist_node *n;
+	struct hlist_head *bucket;
+	struct mesh_table *tbl;
+	struct mplink_node *node;
+
+	tbl = rcu_dereference(mesh_plinks);
+
+	bucket = &tbl->hash_buckets[mesh_hash_idx(hw_addr, dev, tbl)];
+	hlist_for_each_entry_rcu(node, n, bucket, list) {
+		mpl = node->mpl;
+		if (mpl->dev == dev && memcmp(hw_addr, mpl->ha, ETH_ALEN) == 0)
+			return mpl;
+	}
+	return NULL;
+}
+
+/**
+ * add_mesh_plink - allocate and add to the table a new MP
+ * @addr: hardware address (ETH_ALEN length)
+ * @dev: local interface
+ *
+ * Returns: 0 on success
+ *
+ * State: the initial state of the new plink is set to LISTEN
+ */
+int add_mesh_plink(u8 *hw_addr, struct net_device *dev)
+{
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	struct mesh_plink *mpl, *new_mpl;
+	struct mplink_node *node, *new_node;
+	struct hlist_head *bucket;
+	struct hlist_node *n;
+	u32 hash_idx;
+	int grow = 0;
+	int err = 0;
+
+	if (memcmp(hw_addr, dev->dev_addr, ETH_ALEN) == 0)
+		/* never add ourselves as neighbours */
+		return -ENOTSUPP;
+
+	if (is_multicast_ether_addr(hw_addr))
+		return -ENOTSUPP;
+
+	if (atomic_add_unless(&sdata->u.sta.plinks, 1, MESH_MAX_PLINKS) == 0)
+		return -ENOSPC;
+
+	read_lock(&plinktbl_resize_lock);
+
+	new_mpl = kzalloc(sizeof(struct mesh_plink), GFP_KERNEL);
+	if (!new_mpl) {
+		err = -ENOMEM;
+		atomic_dec(&sdata->u.sta.plinks);
+		goto endadd2;
+	}
+	memcpy(new_mpl->ha, hw_addr, ETH_ALEN);
+	new_mpl->dev = dev;
+	new_mpl->state = LISTEN;
+	new_mpl->last_active = jiffies;
+	new_node = kmalloc(sizeof(struct mplink_node), GFP_KERNEL);
+	new_node->mpl = new_mpl;
+	spin_lock_init(&new_mpl->state_lock);
+	init_timer(&new_mpl->timer);
+	new_mpl->hop_metric = 1;
+
+	hash_idx = mesh_hash_idx(hw_addr, dev, mesh_plinks);
+	bucket = &mesh_plinks->hash_buckets[hash_idx];
+
+	spin_lock(&mesh_plinks->hashwlock[hash_idx]);
+
+	hlist_for_each_entry(node, n, bucket, list) {
+		mpl = node->mpl;
+		if (mpl->dev == dev && memcmp(hw_addr, mpl->ha, ETH_ALEN)
+				== 0) {
+			err = -EEXIST;
+			kfree(new_node);
+			kfree(new_mpl);
+			atomic_dec(&sdata->u.sta.plinks);
+			goto endadd;
+		}
+	}
+
+	hlist_add_head_rcu(&new_node->list, bucket);
+	if (atomic_inc_return(&mesh_plinks->entries) >=
+		mesh_plinks->mean_chain_len * (mesh_plinks->hash_mask + 1))
+		grow = 1;
+
+endadd:
+	spin_unlock(&mesh_plinks->hashwlock[hash_idx]);
+endadd2:
+	read_unlock(&plinktbl_resize_lock);
+	if (!err && grow) {
+		struct mesh_table *oldtbl, *newtbl;
+
+		write_lock(&plinktbl_resize_lock);
+		oldtbl = mesh_plinks;
+		newtbl = grow_mesh_table(mesh_plinks);
+		if (!newtbl) {
+			write_unlock(&plinktbl_resize_lock);
+			return -ENOMEM;
+		}
+		rcu_assign_pointer(mesh_plinks, newtbl);
+		synchronize_rcu();
+		free_mesh_table(oldtbl, false);
+		write_unlock(&plinktbl_resize_lock);
+	}
+	return err;
+}
+
+static void mplink_node_reclaim(struct rcu_head *rp)
+{
+	struct mplink_node *node = container_of(rp, struct mplink_node, rcu);
+	struct ieee80211_sub_if_data *sdata =
+		IEEE80211_DEV_TO_SUB_IF(node->mpl->dev);
+	atomic_dec(&sdata->u.sta.plinks);
+	kfree(node->mpl);
+	kfree(node);
+}
+
+/**
+ * del_mesh_plink - Delete an MP from the table
+ * @addr: hardware address (ETH_ALEN length)
+ * @dev: local interface
+ *
+ * Returns: 0 if successful
+ *
+ * State: when calling this routine, the mesh plink has to be in HOLDING or
+ * BLOCKED state, and the timer must not be running
+ */
+int del_mesh_plink(u8 *addr, struct net_device *dev)
+{
+	struct mesh_plink *mpl;
+	struct mplink_node *node;
+	struct hlist_head *bucket;
+	struct hlist_node *n;
+	int hash_idx;
+	int err = 0;
+
+	read_lock(&plinktbl_resize_lock);
+	hash_idx = mesh_hash_idx(addr, dev, mesh_plinks);
+	bucket = &mesh_plinks->hash_buckets[hash_idx];
+
+	spin_lock(&mesh_plinks->hashwlock[hash_idx]);
+	hlist_for_each_entry(node, n, bucket, list) {
+		mpl = node->mpl;
+		if (mpl->dev == dev && memcmp(addr, mpl->ha, ETH_ALEN) == 0) {
+			hlist_del_rcu(&node->list);
+			call_rcu(&node->rcu, mplink_node_reclaim);
+			atomic_dec(&mesh_plinks->entries);
+			goto enddel;
+		}
+	}
+
+	err = -ENXIO;
+enddel:
+	spin_unlock(&mesh_plinks->hashwlock[hash_idx]);
+	read_unlock(&plinktbl_resize_lock);
+	return err;
+}
+
+void mesh_plink_gc(void)
+{
+	struct mesh_plink *mpl;
+	struct hlist_node *p;
+	struct mesh_table *tbl;
+	struct mplink_node *node;
+	int i;
+
+	rcu_read_lock();
+	tbl = rcu_dereference(mesh_plinks);
+
+	for_each_mesh_entry(mesh_plinks, p, node, i) {
+		mpl = node->mpl;
+		spin_lock_bh(&mpl->state_lock);
+		if (time_after(jiffies, mpl->last_active +
+			IEEE80211_MESH_PLINK_EXPIRATION)) {
+			/* Timer is not running, otherwise the plink
+			 * would not be expiring (expiration time >> any
+			 * timer timeout */
+				deactivate_plink(mpl);
+				spin_unlock_bh(&mpl->state_lock);
+				del_mesh_plink(mpl->ha, mpl->dev);
+		} else
+			spin_unlock_bh(&mpl->state_lock);
+	}
+
+	rcu_read_unlock();
+}
+
+/**
+ * flush_mesh_plinks - free every plink associated with a given interface
+ * @dev: interface
+ */
+void flush_mesh_plinks(struct net_device *dev)
+{
+	struct mesh_plink *mpl;
+	struct mplink_node *node;
+	struct hlist_node *p;
+	int i;
+
+	read_lock(&plinktbl_resize_lock);
+	for_each_mesh_entry(mesh_plinks, p, node, i) {
+		mpl = node->mpl;
+		if (mpl->dev == dev) {
+			spin_lock_bh(&mpl->state_lock);
+			if (mpl->state != OPN_SNT &&
+			    mpl->state != OPN_RCVD &&
+			    mpl->state != CNF_RCVD &&
+			    mpl->state != HOLDING) {
+				deactivate_plink(mpl);
+				spin_unlock_bh(&mpl->state_lock);
+				del_mesh_plink(mpl->ha, dev);
+			} else
+				/* The plink will timeout and be freed
+				 */
+				spin_unlock_bh(&mpl->state_lock);
+		}
+	}
+	read_unlock(&plinktbl_resize_lock);
+}
+
+static const struct nla_policy mpla_policy[MPLA_MAX+1] = {
+	[MPLA_PEER_ADDR]	= { .len = ETH_ALEN },
+	[MPLA_STATE]		= { .type = NLA_U8 },
+	[MPLA_LLID]		= { .type = NLA_U16 },
+	[MPLA_PLID]		= { .type = NLA_U16 },
+};
+
+static int rtnl_newmeshpl(struct sk_buff *skb, struct nlmsghdr *nlh,
+		void *arg)
+{
+	struct mplmsg *mplm;
+	struct nlattr *tb[MPLA_MAX+1];
+	struct net_device *dev;
+	struct ieee80211_sub_if_data *sdata;
+	int err;
+
+	err = nlmsg_parse(nlh, sizeof(*mplm), tb, MPLA_MAX, mpla_policy);
+	if (err < 0)
+		return err;
+
+	mplm = nlmsg_data(nlh);
+	if (!tb[MPLA_PEER_ADDR])
+		return -EINVAL;
+
+	dev = __dev_get_by_index(&init_net, mplm->ifa_index);
+
+	if (mplm->mplm_flags & MPL_F_OPEN)
+		return mesh_plink_open(nla_data(tb[MPLA_PEER_ADDR]), dev);
+
+	if (mplm->mplm_flags & MPL_F_BLOCK)
+		return mesh_plink_block(nla_data(tb[MPLA_PEER_ADDR]), dev);
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
+	return add_mesh_neighbour(nla_data(tb[MPLA_PEER_ADDR]), dev);
+}
+
+static int rtnl_delmeshpl(struct sk_buff *skb, struct nlmsghdr *nlh,
+		void *arg)
+{
+	struct mplmsg *mplm;
+	struct nlattr *tb[MPLA_MAX+1];
+	struct net_device *dev;
+	int err;
+
+	err = nlmsg_parse(nlh, sizeof(*mplm), tb, MPLA_MAX, mpla_policy);
+	if (err < 0)
+		return err;
+
+	mplm = nlmsg_data(nlh);
+	if (!tb[MPLA_PEER_ADDR])
+		return -EINVAL;
+
+	dev = __dev_get_by_index(&init_net, mplm->ifa_index);
+	err = mesh_plink_close(nla_data(tb[MPLA_PEER_ADDR]), dev);
+	return err;
+}
+
+static int rtnl_getmeshpl(struct sk_buff *skb, struct nlmsghdr *nlh,
+		void *arg)
+{
+	struct mplmsg *mplm;
+	struct nlattr *tb[MPLA_MAX+1];
+	struct mesh_plink *mpl;
+	struct net_device *dev;
+	int err;
+
+	err = nlmsg_parse(nlh, sizeof(*mplm), tb, MPLA_MAX, mpla_policy);
+	if (err < 0)
+		return err;
+
+	mplm = nlmsg_data(nlh);
+	if (!tb[MPLA_PEER_ADDR])
+		return -EINVAL;
+
+	dev = __dev_get_by_index(&init_net, mplm->ifa_index);
+	rcu_read_lock();
+	mpl = mesh_plink_lookup(nla_data(tb[MPLA_PEER_ADDR]), dev);
+	if (!mpl)
+		err = -ENXIO;
+
+	rcu_read_unlock();
+	return err;
+}
+
+static int rtnl_dumpmeshpl(struct sk_buff *skb,
+		struct netlink_callback *cb)
+{
+	int idx = 0 ;
+	int s_idx = cb->args[0];
+	int b_idx = cb->args[1];
+	struct mesh_plink *mpl;
+	struct mplink_node *node;
+	struct nlmsghdr *nlh;
+	struct mplmsg *hdr;
+	struct hlist_node *n;
+	struct mesh_table *tbl;
+	u8 state;
+	u16 llid, plid;
+
+	rcu_read_lock();
+	tbl = rcu_dereference(mesh_plinks);
+	for (; b_idx <= tbl->hash_mask; ++b_idx) {
+		hlist_for_each_entry_rcu(node, n,
+			&tbl->hash_buckets[b_idx], list) {
+			mpl = node->mpl;
+			if (idx < s_idx) {
+				idx++;
+				continue;
+			}
+			nlh = nlmsg_put(skb, NETLINK_CB(cb->skb).pid,
+					cb->nlh->nlmsg_seq, RTM_NEWMESHPEERLINK,
+					sizeof(*hdr), NLM_F_MULTI);
+			if (nlh == NULL)
+				goto nlh_failure;
+			hdr = nlmsg_data(nlh);
+			hdr->ifa_index = mpl->dev->ifindex;
+			hdr->mplm_flags = 0;
+			NLA_PUT(skb, MPLA_PEER_ADDR, ETH_ALEN, mpl->ha);
+			state = (u8) mpl->state;
+			llid = le16_to_cpu(mpl->llid);
+			plid = le16_to_cpu(mpl->plid);
+			NLA_PUT(skb, MPLA_STATE, 1, &state);
+			NLA_PUT(skb, MPLA_LLID, 2, &llid);
+			NLA_PUT(skb, MPLA_PLID, 2, &plid);
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
+static void free_plink_node(struct hlist_node *p, bool free_leafs)
+{
+	struct mesh_plink *mpl;
+	struct mplink_node *node = hlist_entry(p, struct mplink_node, list);
+	mpl = node->mpl;
+	hlist_del_rcu(p);
+	synchronize_rcu();
+	if (free_leafs) {
+		deactivate_plink(mpl);
+		kfree(mpl);
+	}
+	kfree(node);
+}
+
+static void copy_mplink_node(struct hlist_node *p, struct mesh_table *newtbl)
+{
+	struct mesh_plink *mpl;
+	struct mplink_node *node, *new_node;
+	u32 hash_idx;
+
+	node = hlist_entry(p, struct mplink_node, list);
+	mpl = node->mpl;
+	new_node = kmalloc(sizeof(struct mplink_node), GFP_KERNEL);
+	new_node->mpl = mpl;
+	hash_idx = mesh_hash_idx(mpl->ha, mpl->dev, newtbl);
+	hlist_add_head(&new_node->list,
+			&newtbl->hash_buckets[hash_idx]);
+}
+
+/**
+ * mesh_plinktbl_init - initializes the mesh peer link table
+ *
+ * Returns: 0 if sucessful
+ */
+int mesh_plinktbl_init(void)
+{
+	mesh_plinks = alloc_mesh_table(INIT_NEIGH_SIZE_ORDER);
+	if (!mesh_plinks)
+		return -ENOMEM;
+
+	mesh_plinks->free_node = &free_plink_node;
+	mesh_plinks->copy_node = &copy_mplink_node;
+	mesh_plinks->mean_chain_len = MEAN_CHAIN_LEN;
+
+	rtnl_register(PF_UNSPEC, RTM_NEWMESHPEERLINK, rtnl_newmeshpl, NULL);
+	rtnl_register(PF_UNSPEC, RTM_GETMESHPEERLINK, rtnl_getmeshpl,
+			rtnl_dumpmeshpl);
+	rtnl_register(PF_UNSPEC, RTM_DELMESHPEERLINK, rtnl_delmeshpl, NULL);
+
+	return 0;
+}
+
+
+void mesh_plinktbl_unregister(void)
+{
+	rtnl_unregister(PF_UNSPEC, RTM_NEWMESHPEERLINK);
+	rtnl_unregister(PF_UNSPEC, RTM_DELMESHPEERLINK);
+	rtnl_unregister(PF_UNSPEC, RTM_GETMESHPEERLINK);
+
+	free_mesh_table(mesh_plinks, true);
+}
-- 
1.5.2.5



