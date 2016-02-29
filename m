Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qg0-f65.google.com ([209.85.192.65]:32782 "EHLO
	mail-qg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752115AbcB2BEI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 28 Feb 2016 20:04:08 -0500
Received: by mail-qg0-f65.google.com with SMTP id y89so9652817qge.0
        for <linux-wireless@vger.kernel.org>; Sun, 28 Feb 2016 17:04:07 -0800 (PST)
From: Bob Copeland <me@bobcopeland.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Bob Copeland <me@bobcopeland.com>
Subject: [PATCH 2/4] mac80211: mesh: don't hash sdata in mpath tables
Date: Sun, 28 Feb 2016 20:03:57 -0500
Message-Id: <1456707839-19469-2-git-send-email-me@bobcopeland.com> (sfid-20160229_020421_784951_6FA3158F)
In-Reply-To: <1456707839-19469-1-git-send-email-me@bobcopeland.com>
References: <1456707839-19469-1-git-send-email-me@bobcopeland.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Now that the sdata pointer is the same for all entries of a
path table, hashing it is pointless, so hash only the address.

Signed-off-by: Bob Copeland <me@bobcopeland.com>
---
 net/mac80211/mesh_pathtbl.c | 18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff --git a/net/mac80211/mesh_pathtbl.c b/net/mac80211/mesh_pathtbl.c
index 0508b37b0471..fc3cc350df8c 100644
--- a/net/mac80211/mesh_pathtbl.c
+++ b/net/mac80211/mesh_pathtbl.c
@@ -177,12 +177,10 @@ errcopy:
 	return -ENOMEM;
 }
 
-static u32 mesh_table_hash(const u8 *addr, struct ieee80211_sub_if_data *sdata,
-			   struct mesh_table *tbl)
+static u32 mesh_table_hash(const u8 *addr, struct mesh_table *tbl)
 {
-	/* Use last four bytes of hw addr and interface index as hash index */
-	return jhash_2words(*(u32 *)(addr+2), sdata->dev->ifindex,
-			    tbl->hash_rnd) & tbl->hash_mask;
+	/* Use last four bytes of hw addr as hash index */
+	return jhash_1word(*(u32 *)(addr+2), tbl->hash_rnd) & tbl->hash_mask;
 }
 
 
@@ -331,7 +329,7 @@ static struct mesh_path *mpath_lookup(struct mesh_table *tbl, const u8 *dst,
 	struct hlist_head *bucket;
 	struct mpath_node *node;
 
-	bucket = &tbl->hash_buckets[mesh_table_hash(dst, sdata, tbl)];
+	bucket = &tbl->hash_buckets[mesh_table_hash(dst, tbl)];
 	hlist_for_each_entry_rcu(node, bucket, list) {
 		mpath = node->mpath;
 		if (ether_addr_equal(dst, mpath->dst)) {
@@ -538,7 +536,7 @@ struct mesh_path *mesh_path_add(struct ieee80211_sub_if_data *sdata,
 	read_lock_bh(&sdata->u.mesh.pathtbl_resize_lock);
 	tbl = resize_dereference_mesh_paths(sdata);
 
-	hash_idx = mesh_table_hash(dst, sdata, tbl);
+	hash_idx = mesh_table_hash(dst, tbl);
 	bucket = &tbl->hash_buckets[hash_idx];
 
 	spin_lock(&tbl->hashwlock[hash_idx]);
@@ -687,7 +685,7 @@ int mpp_path_add(struct ieee80211_sub_if_data *sdata,
 
 	tbl = resize_dereference_mpp_paths(sdata);
 
-	hash_idx = mesh_table_hash(dst, sdata, tbl);
+	hash_idx = mesh_table_hash(dst, tbl);
 	bucket = &tbl->hash_buckets[hash_idx];
 
 	spin_lock(&tbl->hashwlock[hash_idx]);
@@ -905,7 +903,7 @@ static int table_path_del(struct mesh_table __rcu *rcu_tbl,
 	int err = 0;
 
 	tbl = resize_dereference_paths(sdata, rcu_tbl);
-	hash_idx = mesh_table_hash(addr, sdata, tbl);
+	hash_idx = mesh_table_hash(addr, tbl);
 	bucket = &tbl->hash_buckets[hash_idx];
 
 	spin_lock(&tbl->hashwlock[hash_idx]);
@@ -1107,7 +1105,7 @@ static int mesh_path_node_copy(struct hlist_node *p, struct mesh_table *newtbl)
 	node = hlist_entry(p, struct mpath_node, list);
 	mpath = node->mpath;
 	new_node->mpath = mpath;
-	hash_idx = mesh_table_hash(mpath->dst, mpath->sdata, newtbl);
+	hash_idx = mesh_table_hash(mpath->dst, newtbl);
 	hlist_add_head(&new_node->list,
 			&newtbl->hash_buckets[hash_idx]);
 	return 0;
-- 
2.6.1

