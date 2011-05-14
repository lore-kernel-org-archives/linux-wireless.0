Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:37134 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752851Ab1ENJAz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 May 2011 05:00:55 -0400
Subject: [PATCH] mac80211: fix and simplify mesh locking
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Javier Cardona <javier@cozybit.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 14 May 2011 11:00:52 +0200
Message-ID: <1305363652.3437.8.camel@jlt3.sipsolutions.net> (sfid-20110514_110059_273421_3D561F0E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The locking in mesh_{mpath,mpp}_table_grow not only
has an rcu_read_unlock() missing, it's also racy
(though really only technically since it's invoked
from a single function only) since it obtains the
new size of the table without any locking, so two
invocations of the function could attempt the same
resize.

Additionally, it uses synchronize_rcu() which is
rather expensive and can be avoided trivially here.

Modify the functions to only use the table lock
and use call_rcu() instead of synchronize_rcu().

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/mesh.h         |    3 +++
 net/mac80211/mesh_pathtbl.c |   44 ++++++++++++++++++++++----------------------
 2 files changed, 25 insertions(+), 22 deletions(-)

--- a/net/mac80211/mesh_pathtbl.c	2011-05-14 10:47:15.000000000 +0200
+++ b/net/mac80211/mesh_pathtbl.c	2011-05-14 10:55:42.000000000 +0200
@@ -370,52 +370,52 @@ err_path_alloc:
 	return err;
 }
 
+static void mesh_table_free_rcu(struct rcu_head *rcu)
+{
+	struct mesh_table *tbl = container_of(rcu, struct mesh_table, rcu_head);
+
+	mesh_table_free(tbl, false);
+}
+
 void mesh_mpath_table_grow(void)
 {
 	struct mesh_table *oldtbl, *newtbl;
 
-	rcu_read_lock();
-	newtbl = mesh_table_alloc(rcu_dereference(mesh_paths)->size_order + 1);
-	if (!newtbl)
-		return;
 	write_lock_bh(&pathtbl_resize_lock);
+	newtbl = mesh_table_alloc(mesh_paths->size_order + 1);
+	if (!newtbl)
+		goto out;
 	oldtbl = mesh_paths;
 	if (mesh_table_grow(mesh_paths, newtbl) < 0) {
-		rcu_read_unlock();
 		__mesh_table_free(newtbl);
-		write_unlock_bh(&pathtbl_resize_lock);
-		return;
+		goto out;
 	}
-	rcu_read_unlock();
 	rcu_assign_pointer(mesh_paths, newtbl);
-	write_unlock_bh(&pathtbl_resize_lock);
 
-	synchronize_rcu();
-	mesh_table_free(oldtbl, false);
+	call_rcu(&oldtbl->rcu_head, mesh_table_free_rcu);
+
+ out:
+	write_unlock_bh(&pathtbl_resize_lock);
 }
 
 void mesh_mpp_table_grow(void)
 {
 	struct mesh_table *oldtbl, *newtbl;
 
-	rcu_read_lock();
-	newtbl = mesh_table_alloc(rcu_dereference(mpp_paths)->size_order + 1);
-	if (!newtbl)
-		return;
 	write_lock_bh(&pathtbl_resize_lock);
+	newtbl = mesh_table_alloc(mpp_paths->size_order + 1);
+	if (!newtbl)
+		goto out;
 	oldtbl = mpp_paths;
 	if (mesh_table_grow(mpp_paths, newtbl) < 0) {
-		rcu_read_unlock();
 		__mesh_table_free(newtbl);
-		write_unlock_bh(&pathtbl_resize_lock);
-		return;
+		goto out;
 	}
-	rcu_read_unlock();
 	rcu_assign_pointer(mpp_paths, newtbl);
-	write_unlock_bh(&pathtbl_resize_lock);
+	call_rcu(&oldtbl->rcu_head, mesh_table_free_rcu);
 
-	synchronize_rcu();
-	mesh_table_free(oldtbl, false);
+ out:
+	write_unlock_bh(&pathtbl_resize_lock);
 }
 
 int mpp_path_add(u8 *dst, u8 *mpp, struct ieee80211_sub_if_data *sdata)
--- a/net/mac80211/mesh.h	2011-05-14 10:52:14.000000000 +0200
+++ b/net/mac80211/mesh.h	2011-05-14 10:52:35.000000000 +0200
@@ -120,6 +120,7 @@ struct mesh_path {
  *	buckets
  * @mean_chain_len: maximum average length for the hash buckets' list, if it is
  *	reached, the table will grow
+ * rcu_head: RCU head to free the table
  */
 struct mesh_table {
 	/* Number of buckets will be 2^N */
@@ -132,6 +133,8 @@ struct mesh_table {
 	int (*copy_node) (struct hlist_node *p, struct mesh_table *newtbl);
 	int size_order;
 	int mean_chain_len;
+
+	struct rcu_head rcu_head;
 };
 
 /* Recent multicast cache */


