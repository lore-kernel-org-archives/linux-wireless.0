Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.247]:37584 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752083AbYBDVYF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Feb 2008 16:24:05 -0500
Received: by an-out-0708.google.com with SMTP id d31so556800and.103
        for <linux-wireless@vger.kernel.org>; Mon, 04 Feb 2008 13:24:05 -0800 (PST)
To: linux-wireless@vger.kernel.org
From: Luis Carlos Cobo <luisca@cozybit.com>
Date: Mon, 4 Feb 2008 10:58:54 -0800
Subject: [PATCH 05/13] o11s: added mesh.h, mesh function and data structures definitions
Message-ID: <47a78274.12025a0a.0fb8.67db@mx.google.com> (sfid-20080204_212415_776178_13DE2F2C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Luis Carlos Cobo <luisca@cozybit.com>
---
 net/mac80211/mesh.h |  240 +++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 240 insertions(+), 0 deletions(-)
 create mode 100644 net/mac80211/mesh.h

diff --git a/net/mac80211/mesh.h b/net/mac80211/mesh.h
new file mode 100644
index 0000000..8ff7a92
--- /dev/null
+++ b/net/mac80211/mesh.h
@@ -0,0 +1,240 @@
+/*
+ * Copyright (c) 2008 open80211s Ltd.
+ * Authors:    Luis Carlos Cobo <luisca@cozybit.com>
+ *             Javier Cardona <javier@cozybit.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef IEEE80211S_H
+#define IEEE80211S_H
+
+#include "ieee80211_i.h"
+#include <linux/jhash.h>
+
+extern int mesh_allocated;
+
+/* Data structures */
+struct ieee80211s_hdr {
+	u8 flags;
+	u8 ttl;
+	u8 seqnum[3];
+	u8 eaddr1[6];
+	u8 eaddr2[6];
+	u8 eaddr3[6];
+} __attribute__ ((packed));
+
+enum plink_state {
+	LISTEN,
+	OPN_SNT,
+	OPN_RCVD,
+	CNF_RCVD,
+	ESTAB,
+	HOLDING,
+	BLOCKED
+};
+
+/* plink is short for peer link */
+struct mesh_plink {
+	u8 ha[ETH_ALEN];	/* Hardware address */
+	__le16 llid;		/* Local link ID */
+	__le16 plid;		/* Peer link ID */
+	__le16 reason;		/* Buffer for cancel reason on HOLDING state */
+	u8 retries;		/* Retries in establishment */
+	enum plink_state state;
+	u32 timeout;
+	struct timer_list timer;
+	bool ignore_timer;
+	spinlock_t state_lock;	/* For peer_state reads / updates and other
+				   updates in the structure. Ensures robust
+				   trasitions for the peerlink FSM */
+	struct net_device *dev;	/* Local mesh interface */
+	u32 hop_metric;
+	struct ieee80211_channel channel;
+	u32 channel_precedence;
+	unsigned long last_active;/* timestamp updated at when traffic from the
+				   peer is received */
+};
+
+#define MESH_PATH_ACTIVE	1
+#define MESH_PATH_RESOLVING	2
+#define MESH_PATH_DSN_VALID	4
+#define MESH_PATH_FIXED		8
+#define MESH_PATH_DELETE	16
+#define MESH_PATH_RESOLVED	32
+
+struct mesh_path {
+	u8 dst[ETH_ALEN];
+	struct net_device *dev;
+	struct mesh_plink *next_hop;
+	struct timer_list timer;
+	struct sk_buff_head frame_queue;
+	struct rcu_head rcu; /* used for safe next_hop dereferencing */
+	u32 dsn;
+	u32 metric;
+	u8 hop_count;
+	unsigned long lifetime;
+	u32 discovery_timeout;
+	u8 discovery_retries;
+	u8 flags;
+	spinlock_t state_lock;
+};
+struct mesh_table {
+	/* Number of buckets will be 2^N */
+	struct hlist_head *hash_buckets;
+	spinlock_t *hashwlock;		/* One per bucket, for add/del */
+	unsigned int hash_mask;		/* (2^size_order) - 1 */
+	__u32 hash_rnd;			/* Used for hash generation */
+	atomic_t entries;		/* Up to MAX_MESH_NEIGHBOURS */
+	void (*free_node) (struct hlist_node *p, bool free_leafs);
+	void (*copy_node) (struct hlist_node *p, struct mesh_table *newtbl);
+	int size_order;
+	int mean_chain_len;
+};
+
+/* Recent multicast cache */
+/* RMC_BUCKETS must be a power of 2, maximum 256 */
+#define RMC_BUCKETS		256
+#define RMC_QUEUE_MAX_LEN	4
+#define RMC_TIMEOUT		(3 * HZ)
+
+struct rmc_entry {
+	struct list_head list;
+	u8 sa[ETH_ALEN];
+	u32 seqnum;
+	unsigned long lifetime;
+};
+
+struct mesh_rmc {
+	struct rmc_entry bucket[RMC_BUCKETS];
+	u8 idx_mask;
+};
+
+
+/* Public interfaces */
+int ieee80211_get_mesh_hdrlen(struct ieee80211s_hdr *meshhdr);
+int ieee80211_new_mesh_header(struct ieee80211s_hdr *meshhdr,
+		struct ieee80211_sub_if_data *sdata);
+int mesh_rmc_check(u8 *addr, struct ieee80211s_hdr *mesh_hdr,
+		struct net_device *dev);
+void mesh_start_path_discovery(struct net_device *dev);
+int mesh_lookup_nexthop(u8 *next_hop, struct sk_buff *skb,
+		struct net_device *dev);
+void update_mesh_neighbour(u8 *hw_addr, struct net_device *dev, bool add);
+int mesh_plinktbl_capacity(void);
+bool is_estab_plink(u8 *hw_addr, struct net_device *dev);
+bool accepting_plinks(struct ieee80211_mgmt *mgmt, struct ieee802_11_elems *ie,
+		struct net_device *dev);
+void mesh_broken_link(u8 *dst, struct net_device *dev);
+void mesh_set_default_ids(struct ieee80211_if_sta *sta);
+void mesh_add_mgmt_ies(struct sk_buff *skb, struct net_device *dev);
+void mesh_rx_plink_frame(struct net_device *dev, struct ieee80211_mgmt *mgmt,
+		size_t len);
+void mesh_rx_path_sel_frame(struct net_device *dev, struct ieee80211_mgmt *mgmt,
+		size_t len);
+
+void flush_mesh_interface(struct net_device *dev);
+void mesh_rmc_free(struct net_device *dev);
+int mesh_rmc_init(struct net_device *dev);
+void ieee80211s_init(void);
+void ieee80211s_stop(void);
+void mesh_path_gc(void);
+void mesh_plink_gc(void);
+
+
+/* Private interfaces */
+/* Mesh tables */
+struct mesh_table *alloc_mesh_table(int size_order);
+void free_mesh_table(struct mesh_table *tbl, bool free_leafs);
+struct mesh_table *grow_mesh_table(struct mesh_table *tbl);
+u32 mesh_hash_idx(u8 *addr, struct net_device *dev, struct mesh_table *tbl);
+/* Mesh peer links */
+int mesh_plink_open(u8 *hw_addr, struct net_device *dev);
+void deactivate_plink(struct mesh_plink *mpl);
+int mesh_plink_close(u8 *hw_addr, struct net_device *dev);
+int mesh_plink_block(u8 *hw_addr, struct net_device *dev);
+int add_mesh_neighbour(u8 *hw_addr, struct net_device *dev);
+int mesh_plinktbl_init(void);
+void mesh_plinktbl_unregister(void);
+void flush_mesh_plinks(struct net_device *dev);
+int add_mesh_plink(u8 *hw_addr, struct net_device *dev);
+struct mesh_plink *mesh_plink_lookup(u8 *hw_addr, struct net_device *dev);
+int del_mesh_plink(u8 *addr, struct net_device *dev);
+/* Mesh paths */
+struct mesh_path *mesh_path_lookup(u8 *dst, struct net_device *dev);
+int mesh_send_path_error(u8 *dest, __le32 dest_dsn, u8 *ra,
+		struct net_device *dev);
+void mpath_empty_pending_queue(struct mesh_path *mpath);
+int add_mesh_path(u8 *dst, struct net_device *dev);
+void send_path_pending_frames(struct mesh_path *mpath);
+int mesh_pathtbl_init(void);
+void mesh_pathtbl_unregister(void);
+void flush_mesh_paths(struct net_device *dev);
+int del_mesh_path(u8 *addr, struct net_device *dev);
+void mpath_timer(unsigned long data);
+void deactivate_mpaths_by_nh(struct mesh_plink *mpl);
+void mesh_path_discard_frame(struct sk_buff *skb, struct net_device *dev);
+
+bool same_mesh(struct ieee80211_mgmt *mgmt, struct ieee802_11_elems *ie,
+		struct net_device *dev);
+
+#define plink_inc(s) 	atomic_inc(&s->u.sta.mshstats.estab_plinks)
+#define plink_dec(s) 	atomic_dec(&s->u.sta.mshstats.estab_plinks)
+#define plink_capacity(s)   (s->u.sta.mshcfg.dot11MeshMaxPeerLinks - \
+				atomic_read(&s->u.sta.mshstats.estab_plinks))
+#define available_plinks(s) (min(plink_capacity(s), MESH_MAX_PLINKS - \
+			atomic_read(&s->u.sta.plinks)) > 0)
+
+#define activate_path(mpath) (mpath->flags |= \
+				(MESH_PATH_ACTIVE | MESH_PATH_RESOLVED))
+
+#define for_each_mesh_entry(x, p, node, i) \
+	for (i = 0; i <= x->hash_mask; i++) \
+		hlist_for_each_entry_rcu(node, p, &x->hash_buckets[i], list)
+
+#define MESH_PREQ(skb)	(skb->cb + 30)
+
+/* Default values, timeouts in ms */
+#define MESH_TTL 		5
+#define MESH_MAX_RETR	 	3
+#define MESH_RET_T 		100
+#define MESH_CONF_T 		100
+#define MESH_HOLD_T 		100
+
+#define MESH_PATH_TIMEOUT	5000
+/* Minimum interval between two consecutive PREQs originated by the same
+ * interface
+ */
+#define MESH_PREQ_MIN_INT	10
+#define MESH_DIAM_TRAVERSAL_TIME 50
+/* Paths will be refreshed if they are closer than PATH_REFRESH_TIME to their
+ * expiration
+ */
+#define MESH_PATH_REFRESH_TIME			1000
+#define MESH_MIN_DISCOVERY_TIMEOUT (2 * MESH_DIAM_TRAVERSAL_TIME)
+
+#define MESH_MAX_PREQ_RETRIES 4
+
+/* Default maximum number of established plinks per interface */
+#define MESH_MAX_ESTAB_PLINKS	32
+
+/* Default maximum number of plinks per interface */
+#define MESH_MAX_PLINKS		256
+
+/* Maximum number of paths per interface */
+#define MESH_MAX_MPATHS		1024
+
+/* Pending ANA approval */
+#define PLINK_CATEGORY 30
+#define MESH_PATH_SEL_CATEGORY 32
+
+/* Mesh Header Flags */
+#define IEEE80211S_FLAGS_AE 0x3
+
+
+#define IEEE80211_MESH_PLINK_EXPIRATION (1800 * HZ)
+#define IEEE80211_MESH_PATH_GC (600 * HZ)
+
+#endif /* IEEE80211S_H */
-- 
1.5.2.5



