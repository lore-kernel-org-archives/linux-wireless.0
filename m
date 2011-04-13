Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:41219 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754959Ab1DMSKk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Apr 2011 14:10:40 -0400
Received: by iwn34 with SMTP id 34so775395iwn.19
        for <linux-wireless@vger.kernel.org>; Wed, 13 Apr 2011 11:10:39 -0700 (PDT)
From: Javier Cardona <javier@cozybit.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: cozybit Inc <javier@cozybit.com>,
	Thomas Pedersen <thomas@cozybit.com>,
	devel@lists.open80211s.org,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, jlopex@gmail.com
Subject: [PATCH] mac80211: Allocate new mesh path and portal tables before taking locks
Date: Wed, 13 Apr 2011 11:10:28 -0700
Message-Id: <1302718228-13003-1-git-send-email-javier@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: cozybit Inc <javier@cozybit.com>

It is unnecessary to hold the path table resize lock while allocating a
new table.  Allocate first and take lock later.  This resolves a
soft-lockup:

[  293.385799] BUG: soft lockup - CPU#0 stuck for 61s! [kworker/u:3:744]
(...)
[  293.386049] Call Trace:
[  293.386049]  [<c119fd04>] do_raw_read_lock+0x26/0x29
[  293.386049]  [<c14b2982>] _raw_read_lock+0x8/0xa
[  293.386049]  [<c148c178>] mesh_path_add+0xb7/0x24e
[  293.386049]  [<c148b98d>] ? mesh_path_lookup+0x1b/0xa6
[  293.386049]  [<c148ded5>] hwmp_route_info_get+0x276/0x2fd
[  293.386049]  [<c148dfb6>] mesh_rx_path_sel_frame+0x5a/0x5d9
[  293.386049]  [<c102667d>] ? update_curr+0x1cf/0x1d7
[  293.386049]  [<c148b45a>] ieee80211_mesh_rx_queued_mgmt+0x60/0x67
[  293.386049]  [<c147c374>] ieee80211_iface_work+0x1f0/0x258
(...)

Signed-off-by: Javier Cardona <javier@cozybit.com>
---
 net/mac80211/mesh_pathtbl.c |   49 ++++++++++++++++++++++---------------------
 1 files changed, 25 insertions(+), 24 deletions(-)

diff --git a/net/mac80211/mesh_pathtbl.c b/net/mac80211/mesh_pathtbl.c
index 8d65b47..7776ae5 100644
--- a/net/mac80211/mesh_pathtbl.c
+++ b/net/mac80211/mesh_pathtbl.c
@@ -65,42 +65,37 @@ void mesh_table_free(struct mesh_table *tbl, bool free_leafs)
 	__mesh_table_free(tbl);
 }
 
-static struct mesh_table *mesh_table_grow(struct mesh_table *tbl)
+static int mesh_table_grow(struct mesh_table *oldtbl,
+		struct mesh_table *newtbl)
 {
-	struct mesh_table *newtbl;
 	struct hlist_head *oldhash;
 	struct hlist_node *p, *q;
 	int i;
 
-	if (atomic_read(&tbl->entries)
-			< tbl->mean_chain_len * (tbl->hash_mask + 1))
-		goto endgrow;
+	if (atomic_read(&oldtbl->entries)
+			< oldtbl->mean_chain_len * (oldtbl->hash_mask + 1))
+		return -EAGAIN;
 
-	newtbl = mesh_table_alloc(tbl->size_order + 1);
-	if (!newtbl)
-		goto endgrow;
 
-	newtbl->free_node = tbl->free_node;
-	newtbl->mean_chain_len = tbl->mean_chain_len;
-	newtbl->copy_node = tbl->copy_node;
-	atomic_set(&newtbl->entries, atomic_read(&tbl->entries));
+	newtbl->free_node = oldtbl->free_node;
+	newtbl->mean_chain_len = oldtbl->mean_chain_len;
+	newtbl->copy_node = oldtbl->copy_node;
+	atomic_set(&newtbl->entries, atomic_read(&oldtbl->entries));
 
-	oldhash = tbl->hash_buckets;
-	for (i = 0; i <= tbl->hash_mask; i++)
+	oldhash = oldtbl->hash_buckets;
+	for (i = 0; i <= oldtbl->hash_mask; i++)
 		hlist_for_each(p, &oldhash[i])
-			if (tbl->copy_node(p, newtbl) < 0)
+			if (oldtbl->copy_node(p, newtbl) < 0)
 				goto errcopy;
 
-	return newtbl;
+	return 0;
 
 errcopy:
 	for (i = 0; i <= newtbl->hash_mask; i++) {
 		hlist_for_each_safe(p, q, &newtbl->hash_buckets[i])
-			tbl->free_node(p, 0);
+			oldtbl->free_node(p, 0);
 	}
-	__mesh_table_free(newtbl);
-endgrow:
-	return NULL;
+	return -ENOMEM;
 }
 
 
@@ -334,10 +329,13 @@ void mesh_mpath_table_grow(void)
 {
 	struct mesh_table *oldtbl, *newtbl;
 
+	newtbl = mesh_table_alloc(mesh_paths->size_order + 1);
+	if (!newtbl)
+		return;
 	write_lock(&pathtbl_resize_lock);
 	oldtbl = mesh_paths;
-	newtbl = mesh_table_grow(mesh_paths);
-	if (!newtbl) {
+	if (mesh_table_grow(mesh_paths, newtbl) < 0) {
+		__mesh_table_free(newtbl);
 		write_unlock(&pathtbl_resize_lock);
 		return;
 	}
@@ -352,10 +350,13 @@ void mesh_mpp_table_grow(void)
 {
 	struct mesh_table *oldtbl, *newtbl;
 
+	newtbl = mesh_table_alloc(mpp_paths->size_order + 1);
+	if (!newtbl)
+		return;
 	write_lock(&pathtbl_resize_lock);
 	oldtbl = mpp_paths;
-	newtbl = mesh_table_grow(mpp_paths);
-	if (!newtbl) {
+	if (mesh_table_grow(mpp_paths, newtbl) < 0) {
+		__mesh_table_free(newtbl);
 		write_unlock(&pathtbl_resize_lock);
 		return;
 	}
-- 
1.7.1

