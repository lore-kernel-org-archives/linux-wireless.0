Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qg0-f46.google.com ([209.85.192.46]:33548 "EHLO
	mail-qg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752523AbcA1OY3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Jan 2016 09:24:29 -0500
Received: by mail-qg0-f46.google.com with SMTP id b35so39292565qge.0
        for <linux-wireless@vger.kernel.org>; Thu, 28 Jan 2016 06:24:29 -0800 (PST)
From: Bob Copeland <me@bobcopeland.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, Bob Copeland <me@bobcopeland.com>
Subject: [PATCH] mac80211: mesh: drop write-only var mean_chain_len
Date: Thu, 28 Jan 2016 09:24:12 -0500
Message-Id: <1453991052-11899-1-git-send-email-me@bobcopeland.com> (sfid-20160128_152436_639416_C61E279B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

mean_chain_len is copied into mesh path table
structures, but only ever has the value 2 and
is never read, so just remove it.

Signed-off-by: Bob Copeland <me@bobcopeland.com>
---

Sending this by itself as it's pretty trivial and doesn't conflict with
other outstanding patches.

 net/mac80211/mesh.h         | 3 ---
 net/mac80211/mesh_pathtbl.c | 9 +++------
 2 files changed, 3 insertions(+), 9 deletions(-)

diff --git a/net/mac80211/mesh.h b/net/mac80211/mesh.h
index 4a8019f..87c017a 100644
--- a/net/mac80211/mesh.h
+++ b/net/mac80211/mesh.h
@@ -137,8 +137,6 @@ struct mesh_path {
  * @copy_node: function to copy nodes of the table
  * @size_order: determines size of the table, there will be 2^size_order hash
  *	buckets
- * @mean_chain_len: maximum average length for the hash buckets' list, if it is
- *	reached, the table will grow
  * @known_gates: list of known mesh gates and their mpaths by the station. The
  * gate's mpath may or may not be resolved and active.
  *
@@ -154,7 +152,6 @@ struct mesh_table {
 	void (*free_node) (struct hlist_node *p, bool free_leafs);
 	int (*copy_node) (struct hlist_node *p, struct mesh_table *newtbl);
 	int size_order;
-	int mean_chain_len;
 	struct hlist_head *known_gates;
 	spinlock_t gates_lock;
 
diff --git a/net/mac80211/mesh_pathtbl.c b/net/mac80211/mesh_pathtbl.c
index dadf8dc..c95bdb8 100644
--- a/net/mac80211/mesh_pathtbl.c
+++ b/net/mac80211/mesh_pathtbl.c
@@ -160,11 +160,10 @@ static int mesh_table_grow(struct mesh_table *oldtbl,
 	int i;
 
 	if (atomic_read(&oldtbl->entries)
-			< oldtbl->mean_chain_len * (oldtbl->hash_mask + 1))
+			< MEAN_CHAIN_LEN * (oldtbl->hash_mask + 1))
 		return -EAGAIN;
 
 	newtbl->free_node = oldtbl->free_node;
-	newtbl->mean_chain_len = oldtbl->mean_chain_len;
 	newtbl->copy_node = oldtbl->copy_node;
 	newtbl->known_gates = oldtbl->known_gates;
 	atomic_set(&newtbl->entries, atomic_read(&oldtbl->entries));
@@ -585,7 +584,7 @@ struct mesh_path *mesh_path_add(struct ieee80211_sub_if_data *sdata,
 
 	hlist_add_head_rcu(&new_node->list, bucket);
 	if (atomic_inc_return(&tbl->entries) >=
-	    tbl->mean_chain_len * (tbl->hash_mask + 1))
+	    MEAN_CHAIN_LEN * (tbl->hash_mask + 1))
 		grow = 1;
 
 	mesh_paths_generation++;
@@ -714,7 +713,7 @@ int mpp_path_add(struct ieee80211_sub_if_data *sdata,
 
 	hlist_add_head_rcu(&new_node->list, bucket);
 	if (atomic_inc_return(&tbl->entries) >=
-	    tbl->mean_chain_len * (tbl->hash_mask + 1))
+	    MEAN_CHAIN_LEN * (tbl->hash_mask + 1))
 		grow = 1;
 
 	spin_unlock(&tbl->hashwlock[hash_idx]);
@@ -1076,7 +1075,6 @@ int mesh_pathtbl_init(void)
 		return -ENOMEM;
 	tbl_path->free_node = &mesh_path_node_free;
 	tbl_path->copy_node = &mesh_path_node_copy;
-	tbl_path->mean_chain_len = MEAN_CHAIN_LEN;
 	tbl_path->known_gates = kzalloc(sizeof(struct hlist_head), GFP_ATOMIC);
 	if (!tbl_path->known_gates) {
 		ret = -ENOMEM;
@@ -1092,7 +1090,6 @@ int mesh_pathtbl_init(void)
 	}
 	tbl_mpp->free_node = &mesh_path_node_free;
 	tbl_mpp->copy_node = &mesh_path_node_copy;
-	tbl_mpp->mean_chain_len = MEAN_CHAIN_LEN;
 	tbl_mpp->known_gates = kzalloc(sizeof(struct hlist_head), GFP_ATOMIC);
 	if (!tbl_mpp->known_gates) {
 		ret = -ENOMEM;
-- 
2.1.4

