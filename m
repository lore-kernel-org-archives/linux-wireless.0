Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:60815 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755092Ab1ELLiw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 May 2011 07:38:52 -0400
Subject: [PATCH] mac80211: mesh: move some code to make it static
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 12 May 2011 13:38:50 +0200
Message-ID: <1305200330.3461.15.camel@jlt3.sipsolutions.net> (sfid-20110512_133856_271100_45346CDD)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

There's no need to have table functions in one
file and all users in another, move the functions
to the right file and make them static. Also move
a static variable to the beginning of the file to
make it easier to find.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/mesh.c         |   43 -------------------------------
 net/mac80211/mesh.h         |    4 --
 net/mac80211/mesh_pathtbl.c |   60 ++++++++++++++++++++++++++++++++++++++------
 3 files changed, 53 insertions(+), 54 deletions(-)

--- a/net/mac80211/mesh.c	2011-05-12 13:32:58.000000000 +0200
+++ b/net/mac80211/mesh.c	2011-05-12 13:34:32.000000000 +0200
@@ -287,49 +287,6 @@ void mesh_mgmt_ies_add(struct sk_buff *s
 	}
 }
 
-u32 mesh_table_hash(u8 *addr, struct ieee80211_sub_if_data *sdata, struct mesh_table *tbl)
-{
-	/* Use last four bytes of hw addr and interface index as hash index */
-	return jhash_2words(*(u32 *)(addr+2), sdata->dev->ifindex, tbl->hash_rnd)
-		& tbl->hash_mask;
-}
-
-struct mesh_table *mesh_table_alloc(int size_order)
-{
-	int i;
-	struct mesh_table *newtbl;
-
-	newtbl = kmalloc(sizeof(struct mesh_table), GFP_KERNEL);
-	if (!newtbl)
-		return NULL;
-
-	newtbl->hash_buckets = kzalloc(sizeof(struct hlist_head) *
-			(1 << size_order), GFP_KERNEL);
-
-	if (!newtbl->hash_buckets) {
-		kfree(newtbl);
-		return NULL;
-	}
-
-	newtbl->hashwlock = kmalloc(sizeof(spinlock_t) *
-			(1 << size_order), GFP_KERNEL);
-	if (!newtbl->hashwlock) {
-		kfree(newtbl->hash_buckets);
-		kfree(newtbl);
-		return NULL;
-	}
-
-	newtbl->size_order = size_order;
-	newtbl->hash_mask = (1 << size_order) - 1;
-	atomic_set(&newtbl->entries,  0);
-	get_random_bytes(&newtbl->hash_rnd,
-			sizeof(newtbl->hash_rnd));
-	for (i = 0; i <= newtbl->hash_mask; i++)
-		spin_lock_init(&newtbl->hashwlock[i]);
-
-	return newtbl;
-}
-
 
 static void ieee80211_mesh_path_timer(unsigned long data)
 {
--- a/net/mac80211/mesh.h	2011-05-12 13:32:58.000000000 +0200
+++ b/net/mac80211/mesh.h	2011-05-12 13:35:01.000000000 +0200
@@ -240,12 +240,8 @@ void mesh_rx_plink_frame(struct ieee8021
 
 /* Private interfaces */
 /* Mesh tables */
-struct mesh_table *mesh_table_alloc(int size_order);
-void mesh_table_free(struct mesh_table *tbl, bool free_leafs);
 void mesh_mpath_table_grow(void);
 void mesh_mpp_table_grow(void);
-u32 mesh_table_hash(u8 *addr, struct ieee80211_sub_if_data *sdata,
-		struct mesh_table *tbl);
 /* Mesh paths */
 int mesh_path_error_tx(u8 ttl, u8 *target, __le32 target_sn, __le16 target_rcode,
 		       const u8 *ra, struct ieee80211_sub_if_data *sdata);
--- a/net/mac80211/mesh_pathtbl.c	2011-05-12 13:32:58.000000000 +0200
+++ b/net/mac80211/mesh_pathtbl.c	2011-05-12 13:36:17.000000000 +0200
@@ -40,6 +40,50 @@ static struct mesh_table *mesh_paths;
 static struct mesh_table *mpp_paths; /* Store paths for MPP&MAP */
 
 int mesh_paths_generation;
+
+/* This lock will have the grow table function as writer and add / delete nodes
+ * as readers. When reading the table (i.e. doing lookups) we are well protected
+ * by RCU
+ */
+static DEFINE_RWLOCK(pathtbl_resize_lock);
+
+
+static struct mesh_table *mesh_table_alloc(int size_order)
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
 static void __mesh_table_free(struct mesh_table *tbl)
 {
 	kfree(tbl->hash_buckets);
@@ -47,7 +91,7 @@ static void __mesh_table_free(struct mes
 	kfree(tbl);
 }
 
-void mesh_table_free(struct mesh_table *tbl, bool free_leafs)
+static void mesh_table_free(struct mesh_table *tbl, bool free_leafs)
 {
 	struct hlist_head *mesh_hash;
 	struct hlist_node *p, *q;
@@ -66,7 +110,7 @@ void mesh_table_free(struct mesh_table *
 }
 
 static int mesh_table_grow(struct mesh_table *oldtbl,
-		struct mesh_table *newtbl)
+			   struct mesh_table *newtbl)
 {
 	struct hlist_head *oldhash;
 	struct hlist_node *p, *q;
@@ -98,12 +142,14 @@ errcopy:
 	return -ENOMEM;
 }
 
+static u32 mesh_table_hash(u8 *addr, struct ieee80211_sub_if_data *sdata,
+			   struct mesh_table *tbl)
+{
+	/* Use last four bytes of hw addr and interface index as hash index */
+	return jhash_2words(*(u32 *)(addr+2), sdata->dev->ifindex, tbl->hash_rnd)
+		& tbl->hash_mask;
+}
 
-/* This lock will have the grow table function as writer and add / delete nodes
- * as readers. When reading the table (i.e. doing lookups) we are well protected
- * by RCU
- */
-static DEFINE_RWLOCK(pathtbl_resize_lock);
 
 /**
  *


