Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f195.google.com ([209.85.213.195]:35107 "EHLO
	mail-ig0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752199AbcCBPJd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Mar 2016 10:09:33 -0500
Received: by mail-ig0-f195.google.com with SMTP id ww10so5129547igb.2
        for <linux-wireless@vger.kernel.org>; Wed, 02 Mar 2016 07:09:32 -0800 (PST)
From: Bob Copeland <me@bobcopeland.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, Bob Copeland <me@bobcopeland.com>,
	Thomas Graf <tgraf@suug.ch>, netdev@vger.kernel.org
Subject: [PATCH 1/2] rhashtable: accept GFP flags in rhashtable_walk_init
Date: Wed,  2 Mar 2016 10:09:19 -0500
Message-Id: <1456931360-2846-1-git-send-email-me@bobcopeland.com> (sfid-20160302_160953_704835_847F8DC4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In certain cases, the 802.11 mesh pathtable code wants to
iterate over all of the entries in the forwarding table from
the receive path, which is inside an RCU read-side critical
section.  Enable walks inside atomic sections by allowing
GFP_ATOMIC allocations for the walker state.

Change all existing callsites to pass in GFP_KERNEL.

Cc: Thomas Graf <tgraf@suug.ch>
Cc: netdev@vger.kernel.org
Acked-by: Thomas Graf <tgraf@suug.ch>
Signed-off-by: Bob Copeland <me@bobcopeland.com>
---
(-RFC, +Thomas's Ack)

 include/linux/rhashtable.h | 3 ++-
 lib/rhashtable.c           | 6 ++++--
 net/ipv6/ila/ila_xlat.c    | 3 ++-
 net/netfilter/nft_hash.c   | 4 ++--
 net/netlink/af_netlink.c   | 3 ++-
 net/sctp/proc.c            | 3 ++-
 6 files changed, 14 insertions(+), 8 deletions(-)

diff --git a/include/linux/rhashtable.h b/include/linux/rhashtable.h
index 63bd7601b6de..3eef0802a0cd 100644
--- a/include/linux/rhashtable.h
+++ b/include/linux/rhashtable.h
@@ -346,7 +346,8 @@ struct bucket_table *rhashtable_insert_slow(struct rhashtable *ht,
 					    struct bucket_table *old_tbl);
 int rhashtable_insert_rehash(struct rhashtable *ht, struct bucket_table *tbl);
 
-int rhashtable_walk_init(struct rhashtable *ht, struct rhashtable_iter *iter);
+int rhashtable_walk_init(struct rhashtable *ht, struct rhashtable_iter *iter,
+			 gfp_t gfp);
 void rhashtable_walk_exit(struct rhashtable_iter *iter);
 int rhashtable_walk_start(struct rhashtable_iter *iter) __acquires(RCU);
 void *rhashtable_walk_next(struct rhashtable_iter *iter);
diff --git a/lib/rhashtable.c b/lib/rhashtable.c
index cc808707d1cf..5d845ffd7982 100644
--- a/lib/rhashtable.c
+++ b/lib/rhashtable.c
@@ -487,6 +487,7 @@ EXPORT_SYMBOL_GPL(rhashtable_insert_slow);
  * rhashtable_walk_init - Initialise an iterator
  * @ht:		Table to walk over
  * @iter:	Hash table Iterator
+ * @gfp:	GFP flags for allocations
  *
  * This function prepares a hash table walk.
  *
@@ -504,14 +505,15 @@ EXPORT_SYMBOL_GPL(rhashtable_insert_slow);
  * You must call rhashtable_walk_exit if this function returns
  * successfully.
  */
-int rhashtable_walk_init(struct rhashtable *ht, struct rhashtable_iter *iter)
+int rhashtable_walk_init(struct rhashtable *ht, struct rhashtable_iter *iter,
+			 gfp_t gfp)
 {
 	iter->ht = ht;
 	iter->p = NULL;
 	iter->slot = 0;
 	iter->skip = 0;
 
-	iter->walker = kmalloc(sizeof(*iter->walker), GFP_KERNEL);
+	iter->walker = kmalloc(sizeof(*iter->walker), gfp);
 	if (!iter->walker)
 		return -ENOMEM;
 
diff --git a/net/ipv6/ila/ila_xlat.c b/net/ipv6/ila/ila_xlat.c
index 295ca29a23c3..0b03533453e4 100644
--- a/net/ipv6/ila/ila_xlat.c
+++ b/net/ipv6/ila/ila_xlat.c
@@ -501,7 +501,8 @@ static int ila_nl_dump_start(struct netlink_callback *cb)
 	struct ila_net *ilan = net_generic(net, ila_net_id);
 	struct ila_dump_iter *iter = (struct ila_dump_iter *)cb->args;
 
-	return rhashtable_walk_init(&ilan->rhash_table, &iter->rhiter);
+	return rhashtable_walk_init(&ilan->rhash_table, &iter->rhiter,
+				    GFP_KERNEL);
 }
 
 static int ila_nl_dump_done(struct netlink_callback *cb)
diff --git a/net/netfilter/nft_hash.c b/net/netfilter/nft_hash.c
index 3f9d45d3d9b7..6fa016564f90 100644
--- a/net/netfilter/nft_hash.c
+++ b/net/netfilter/nft_hash.c
@@ -192,7 +192,7 @@ static void nft_hash_walk(const struct nft_ctx *ctx, const struct nft_set *set,
 	u8 genmask = nft_genmask_cur(read_pnet(&set->pnet));
 	int err;
 
-	err = rhashtable_walk_init(&priv->ht, &hti);
+	err = rhashtable_walk_init(&priv->ht, &hti, GFP_KERNEL);
 	iter->err = err;
 	if (err)
 		return;
@@ -248,7 +248,7 @@ static void nft_hash_gc(struct work_struct *work)
 	priv = container_of(work, struct nft_hash, gc_work.work);
 	set  = nft_set_container_of(priv);
 
-	err = rhashtable_walk_init(&priv->ht, &hti);
+	err = rhashtable_walk_init(&priv->ht, &hti, GFP_KERNEL);
 	if (err)
 		goto schedule;
 
diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index c8416792cce0..6e0cbdeb21d3 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -2335,7 +2335,8 @@ static int netlink_walk_start(struct nl_seq_iter *iter)
 {
 	int err;
 
-	err = rhashtable_walk_init(&nl_table[iter->link].hash, &iter->hti);
+	err = rhashtable_walk_init(&nl_table[iter->link].hash, &iter->hti,
+				   GFP_KERNEL);
 	if (err) {
 		iter->link = MAX_LINKS;
 		return err;
diff --git a/net/sctp/proc.c b/net/sctp/proc.c
index cfc3c7101a38..c5991e5e5daf 100644
--- a/net/sctp/proc.c
+++ b/net/sctp/proc.c
@@ -319,7 +319,8 @@ static int sctp_transport_walk_start(struct seq_file *seq)
 	struct sctp_ht_iter *iter = seq->private;
 	int err;
 
-	err = rhashtable_walk_init(&sctp_transport_hashtable, &iter->hti);
+	err = rhashtable_walk_init(&sctp_transport_hashtable, &iter->hti,
+				   GFP_KERNEL);
 	if (err)
 		return err;
 
-- 
2.6.1

