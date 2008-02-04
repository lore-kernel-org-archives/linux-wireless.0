Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.247]:37584 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753997AbYBDVYM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Feb 2008 16:24:12 -0500
Received: by an-out-0708.google.com with SMTP id d31so556800and.103
        for <linux-wireless@vger.kernel.org>; Mon, 04 Feb 2008 13:24:11 -0800 (PST)
To: linux-wireless@vger.kernel.org
From: Luis Carlos Cobo <luisca@cozybit.com>
Date: Mon, 4 Feb 2008 11:11:50 -0800
Subject: [PATCH 06/13] o11s: mesh.c, support functions for mesh
Message-ID: <47a7827a.1d35640a.1895.040e@mx.google.com> (sfid-20080204_212419_996010_27841680)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The two important features coded in mesh.c are:

Recently Multicast Cache: in on-demand HWMP, multicast traffic is retransmitted
by every receiving node. Even though a mesh TTL counter avoids infinite loops,
it is also necessary to avoid traffic explosion by keeping a cache of multicast
mesh frame that have been received recently. With this feature, maximum number
of retransmissions of a multicast frame for the case of N nodes within the range
of each other would be N. Without it, the maximum number of retransmissions
would be in the order of N^(MESH_TTL - 1).

Common code for mesh peer link and mesh path tables.

Signed-off-by: Luis Carlos Cobo <luisca@cozybit.com>
---
 net/mac80211/mesh.c |  327 +++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 327 insertions(+), 0 deletions(-)
 create mode 100644 net/mac80211/mesh.c

diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
new file mode 100644
index 0000000..b808939
--- /dev/null
+++ b/net/mac80211/mesh.c
@@ -0,0 +1,327 @@
+/*
+ * Copyright (c) 2008 open80211s Ltd.
+ * Authors:    Luis Carlos Cobo <luisca@cozybit.com>
+ * 	       Javier Cardona <javier@cozybit.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include "ieee80211_i.h"
+#include "mesh.h"
+
+#define PP_OFFSET 	1		/* Path Selection Protocol */
+#define PM_OFFSET	5		/* Path Selection Metric   */
+#define CC_OFFSET	9		/* Congestion Control Mode */
+#define CAPAB_OFFSET 17
+#define ACCEPT_PLINKS 0x80
+
+int mesh_allocated;
+
+void ieee80211s_init(void)
+{
+	mesh_pathtbl_init();
+	mesh_plinktbl_init();
+	mesh_allocated = 1;
+}
+
+void ieee80211s_stop(void)
+{
+	mesh_pathtbl_unregister();
+	mesh_plinktbl_unregister();
+}
+
+void flush_mesh_interface(struct net_device *dev)
+{
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	flush_mesh_plinks(dev);
+	flush_mesh_paths(dev);
+	sdata->u.sta.accepting_plinks = available_plinks(sdata);
+}
+
+bool same_mesh(struct ieee80211_mgmt *mgmt, struct ieee802_11_elems *ie,
+		struct net_device *dev)
+{
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	struct ieee80211_if_sta *sta = &sdata->u.sta;
+
+	if (sta->mesh_id_len == ie->mesh_id_len &&
+		memcmp(sta->mesh_id, ie->mesh_id, ie->mesh_id_len) == 0 &&
+		memcmp(sta->mesh_pp_id, ie->mesh_config + PP_OFFSET, 4) == 0 &&
+		memcmp(sta->mesh_pm_id, ie->mesh_config + PM_OFFSET, 4) == 0 &&
+		memcmp(sta->mesh_cc_id, ie->mesh_config + CC_OFFSET, 4) == 0)
+	/*
+	 * As support for each feature is added, check for matching
+	 * - On mesh config capabilities
+	 *   - Power Save Support En
+	 *   - Sync support enabled
+	 *   - Sync support active
+	 *   - Sync support required from peer
+	 *   - MDA enabled
+	 * - Power management control on fc
+	 */
+		return true;
+
+	return false;
+}
+
+bool accepting_plinks(struct ieee80211_mgmt *mgmt, struct ieee802_11_elems *ie,
+		struct net_device *dev)
+{
+	return (*(ie->mesh_config + CAPAB_OFFSET) & ACCEPT_PLINKS) != 0;
+}
+
+void mesh_set_default_ids(struct ieee80211_if_sta *sta)
+{
+	u8 def_id[4] = {0x00, 0x0F, 0xAC, 0xff};
+
+	memcpy(sta->mesh_pp_id, def_id, 4);
+	memcpy(sta->mesh_pm_id, def_id, 4);
+	memcpy(sta->mesh_cc_id, def_id, 4);
+}
+
+int mesh_rmc_init(struct net_device *dev)
+{
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	int i;
+
+	sdata->u.sta.rmc = kmalloc(sizeof(struct mesh_rmc), GFP_KERNEL);
+	if (!sdata->u.sta.rmc)
+		return -ENOMEM;
+	sdata->u.sta.rmc->idx_mask = RMC_BUCKETS - 1;
+	for (i = 0; i < RMC_BUCKETS; i++)
+		INIT_LIST_HEAD(&sdata->u.sta.rmc->bucket[i].list);
+	return 0;
+}
+
+void mesh_rmc_free(struct net_device *dev)
+{
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	struct mesh_rmc *rmc = sdata->u.sta.rmc;
+	struct rmc_entry *p, *n;
+	int i;
+
+	for (i = 0; i < RMC_BUCKETS; i++)
+		list_for_each_entry_safe(p, n, &rmc->bucket[i].list, list) {
+			list_del(&p->list);
+			kfree(p);
+		}
+
+	kfree(rmc);
+}
+
+/* mesh_rmc_check - Check frame in recent multicast cache and add if absent.
+ *
+ * @sa:		source address
+ * @mesh_hdr:	mesh_header
+ *
+ * Returns: 0 if the frame is not in the cache, nonzero otherwise.
+ *
+ * Checks using the source address and the mesh sequence number if we have
+ * received this frame lately. If the frame is not in the cache, it is added to
+ * it.
+ */
+int mesh_rmc_check(u8 *sa, struct ieee80211s_hdr *mesh_hdr,
+		   struct net_device *dev)
+{
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	struct mesh_rmc *rmc = sdata->u.sta.rmc;
+	u32 seqnum = 0;
+	int entries = 0;
+	u8 idx;
+	struct rmc_entry *p, *n;
+
+	/* Don't care about endianness since only match matters */
+	memcpy(&seqnum, mesh_hdr->seqnum, sizeof(mesh_hdr->seqnum));
+	idx = mesh_hdr->seqnum[0] & rmc->idx_mask;
+	list_for_each_entry_safe(p, n, &rmc->bucket[idx].list, list) {
+		++entries;
+		if (time_after(jiffies, p->lifetime) ||
+				(entries == RMC_QUEUE_MAX_LEN)) {
+			list_del(&p->list);
+			kfree(p);
+			--entries;
+		} else if ((seqnum == p->seqnum)
+				&& (memcmp(sa, p->sa, ETH_ALEN) == 0))
+			return -1;
+	}
+
+	p = kmalloc(sizeof(struct rmc_entry), GFP_ATOMIC);
+	if (!p) {
+		printk(KERN_DEBUG "o11s: could not allocate RMC entry\n");
+		return 0;
+	}
+	p->seqnum = seqnum;
+	p->lifetime = jiffies + RMC_TIMEOUT;
+	memcpy(p->sa, sa, ETH_ALEN);
+	list_add(&p->list, &rmc->bucket[idx].list);
+	return 0;
+}
+
+void mesh_add_mgmt_ies(struct sk_buff *skb, struct net_device *dev)
+{
+	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	struct ieee80211_supported_band *sband;
+	u8 *pos;
+	int len, i, rate;
+
+	sband = local->hw.wiphy->bands[local->hw.conf.channel->band];
+	len = sband->n_bitrates;
+	if (len > 8)
+		len = 8;
+	pos = skb_put(skb, len + 2);
+	*pos++ = WLAN_EID_SUPP_RATES;
+	*pos++ = len;
+	for (i = 0; i < len; i++) {
+		rate = sband->bitrates[i].bitrate;
+		*pos++ = (u8) (rate / 5);
+	}
+
+	if (sband->n_bitrates > len) {
+		pos = skb_put(skb, sband->n_bitrates - len + 2);
+		*pos++ = WLAN_EID_EXT_SUPP_RATES;
+		*pos++ = sband->n_bitrates - len;
+		for (i = len; i < sband->n_bitrates; i++) {
+			rate = sband->bitrates[i].bitrate;
+			*pos++ = (u8) (rate / 5);
+		}
+	}
+
+	pos = skb_put(skb, 2 + sdata->u.sta.mesh_id_len);
+	*pos++ = WLAN_EID_MESH_ID;
+	*pos++ = sdata->u.sta.mesh_id_len;
+	if (sdata->u.sta.mesh_id_len)
+		memcpy(pos, sdata->u.sta.mesh_id, sdata->u.sta.mesh_id_len);
+
+	pos = skb_put(skb, 21);
+	*pos++ = WLAN_EID_MESH_CONFIG;
+	*pos++ = 19;
+	/* Version */
+	*pos++ = 1;
+
+	/* Active path selection protocol ID */
+	memcpy(pos, sdata->u.sta.mesh_pp_id, 4);
+	pos += 4;
+
+	/* Active path selection metric ID   */
+	memcpy(pos, sdata->u.sta.mesh_pm_id, 4);
+	pos += 4;
+
+	/* Congestion control mode identifier */
+	memcpy(pos, sdata->u.sta.mesh_cc_id, 4);
+	pos += 4;
+
+	/* Channel precedence:
+	 * Not running simple channel unification protocol
+	 */
+	memset(pos, 0x00, 4);
+	pos += 4;
+
+	/* Mesh capability */
+	*pos++ = sdata->u.sta.accepting_plinks ? ACCEPT_PLINKS : 0x00;
+	*pos++ = 0x00;
+
+	return;
+}
+
+u32 mesh_hash_idx(u8 *addr, struct net_device *dev, struct mesh_table *tbl)
+{
+	/* Use last four bytes of hw addr and interface index as hash index */
+	return jhash_2words(*(u32 *)(addr+2), dev->ifindex, tbl->hash_rnd)
+		& tbl->hash_mask;
+}
+
+struct mesh_table *alloc_mesh_table(int size_order)
+{
+	int i;
+	struct mesh_table *newtbl;
+
+	newtbl = kmalloc(sizeof(struct mesh_table), GFP_KERNEL);
+	if (!newtbl)
+		return NULL;
+
+	newtbl->hash_buckets = kzalloc(sizeof(struct hlist_head) *
+			(1 << size_order), GFP_KERNEL);
+
+	if (!newtbl->hash_buckets) {
+		kfree(newtbl);
+		return NULL;
+	}
+
+	newtbl->hashwlock = kmalloc(sizeof(spinlock_t) *
+			(1 << size_order), GFP_KERNEL);
+	if (!newtbl->hashwlock) {
+		kfree(newtbl->hash_buckets);
+		kfree(newtbl);
+		return NULL;
+	}
+
+	newtbl->size_order = size_order;
+	newtbl->hash_mask = (1 << size_order) - 1;
+	atomic_set(&newtbl->entries,  0);
+	get_random_bytes(&newtbl->hash_rnd,
+			sizeof(newtbl->hash_rnd));
+	for (i = 0; i <= newtbl->hash_mask; i++)
+		spin_lock_init(&newtbl->hashwlock[i]);
+
+	return newtbl;
+}
+
+void free_mesh_table(struct mesh_table *tbl, bool free_leafs)
+{
+	struct hlist_head *mesh_hash;
+	struct hlist_node *p, *q;
+	int i;
+
+	mesh_hash = tbl->hash_buckets;
+	for (i = 0; i <= tbl->hash_mask; i++) {
+		spin_lock(&tbl->hashwlock[i]);
+		hlist_for_each_safe(p, q, &mesh_hash[i]) {
+			tbl->free_node(p, free_leafs);
+			atomic_dec(&tbl->entries);
+		}
+		spin_unlock(&tbl->hashwlock[i]);
+	}
+	kfree(tbl->hash_buckets);
+	kfree(tbl->hashwlock);
+	kfree(tbl);
+}
+
+struct mesh_table *grow_mesh_table(struct mesh_table *tbl)
+{
+	struct mesh_table *newtbl;
+	struct hlist_head *oldhash;
+	struct hlist_node *p;
+	int err = 0;
+	int i;
+
+	if (atomic_read(&tbl->entries)
+			< tbl->mean_chain_len * (tbl->hash_mask + 1)) {
+		err = -EPERM;
+		goto endgrow;
+	}
+
+	newtbl = alloc_mesh_table(tbl->size_order + 1);
+	if (!newtbl) {
+		err = -ENOMEM;
+		goto endgrow;
+	}
+
+	newtbl->free_node = tbl->free_node;
+	newtbl->mean_chain_len = tbl->mean_chain_len;
+	newtbl->copy_node = tbl->copy_node;
+	atomic_set(&newtbl->entries, atomic_read(&tbl->entries));
+
+	oldhash = tbl->hash_buckets;
+	for (i = 0; i <= tbl->hash_mask; i++)
+		hlist_for_each(p, &oldhash[i])
+			tbl->copy_node(p, newtbl);
+
+endgrow:
+	if (err)
+		return NULL;
+	else
+		return newtbl;
+}
-- 
1.5.2.5



