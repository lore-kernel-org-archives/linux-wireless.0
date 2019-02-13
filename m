Return-Path: <SRS0=xkZe=QU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29C17C282C2
	for <linux-wireless@archiver.kernel.org>; Wed, 13 Feb 2019 05:16:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ED88E222BA
	for <linux-wireless@archiver.kernel.org>; Wed, 13 Feb 2019 05:16:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726309AbfBMFQY (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 13 Feb 2019 00:16:24 -0500
Received: from orcrist.hmeau.com ([104.223.48.154]:57666 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726091AbfBMFQX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 13 Feb 2019 00:16:23 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1gtmuB-0005Dt-CN; Wed, 13 Feb 2019 13:16:19 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1gtmu5-0001Vb-LI; Wed, 13 Feb 2019 13:16:13 +0800
Subject: [PATCH 1/2] mac80211: Use linked list instead of rhashtable walk for mesh tables
References: <20190213050551.x3jffq3ipghw6g2m@gondor.apana.org.au>
To:     David Miller <davem@davemloft.net>, johannes@sipsolutions.net,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org, j@w1.fi,
        tgraf@suug.ch, johannes.berg@intel.com
Message-Id: <E1gtmu5-0001Vb-LI@gondobar>
From:   Herbert Xu <herbert@gondor.apana.org.au>
Date:   Wed, 13 Feb 2019 13:16:13 +0800
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

The mesh table code walks over hash tables for two purposes.  First of
all it's used as part of a netlink dump process, but it is also used
for looking up entries to delete using criteria other than the hash
key.

The second purpose is directly contrary to the design specification
of rhashtable walks.  It is only meant for use by netlink dumps.

This is because rhashtable is resizable and you cannot obtain a
stable walk over it during a resize process.

In fact mesh's use of rhashtable for dumping is bogus too.  Rather
than using rhashtable walk's iterator to keep track of the current
position, it always converts the current position to an integer
which defeats the purpose of the iterator.

Therefore this patch converts all uses of rhashtable walk into a
simple linked list.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 net/mac80211/mesh.h         |    4 +
 net/mac80211/mesh_pathtbl.c |  119 +++++++-------------------------------------
 2 files changed, 24 insertions(+), 99 deletions(-)

diff --git a/net/mac80211/mesh.h b/net/mac80211/mesh.h
index cad6592c52a1..d8e626d66055 100644
--- a/net/mac80211/mesh.h
+++ b/net/mac80211/mesh.h
@@ -70,6 +70,7 @@ enum mesh_deferred_task_flags {
  * @dst: mesh path destination mac address
  * @mpp: mesh proxy mac address
  * @rhash: rhashtable list pointer
+ * @walk_list: linked list containing all mesh_path objects.
  * @gate_list: list pointer for known gates list
  * @sdata: mesh subif
  * @next_hop: mesh neighbor to which frames for this destination will be
@@ -105,6 +106,7 @@ struct mesh_path {
 	u8 dst[ETH_ALEN];
 	u8 mpp[ETH_ALEN];	/* used for MPP or MAP */
 	struct rhash_head rhash;
+	struct hlist_node walk_list;
 	struct hlist_node gate_list;
 	struct ieee80211_sub_if_data *sdata;
 	struct sta_info __rcu *next_hop;
@@ -133,12 +135,14 @@ struct mesh_path {
  * gate's mpath may or may not be resolved and active.
  * @gates_lock: protects updates to known_gates
  * @rhead: the rhashtable containing struct mesh_paths, keyed by dest addr
+ * @walk_head: linked list containging all mesh_path objects
  * @entries: number of entries in the table
  */
 struct mesh_table {
 	struct hlist_head known_gates;
 	spinlock_t gates_lock;
 	struct rhashtable rhead;
+	struct hlist_head walk_head;
 	atomic_t entries;		/* Up to MAX_MESH_NEIGHBOURS */
 };
 
diff --git a/net/mac80211/mesh_pathtbl.c b/net/mac80211/mesh_pathtbl.c
index a5125624a76d..984ed433a8bc 100644
--- a/net/mac80211/mesh_pathtbl.c
+++ b/net/mac80211/mesh_pathtbl.c
@@ -249,28 +249,15 @@ mpp_path_lookup(struct ieee80211_sub_if_data *sdata, const u8 *dst)
 static struct mesh_path *
 __mesh_path_lookup_by_idx(struct mesh_table *tbl, int idx)
 {
-	int i = 0, ret;
-	struct mesh_path *mpath = NULL;
-	struct rhashtable_iter iter;
-
-	ret = rhashtable_walk_init(&tbl->rhead, &iter, GFP_ATOMIC);
-	if (ret)
-		return NULL;
-
-	rhashtable_walk_start(&iter);
+	int i = 0;
+	struct mesh_path *mpath;
 
-	while ((mpath = rhashtable_walk_next(&iter))) {
-		if (IS_ERR(mpath) && PTR_ERR(mpath) == -EAGAIN)
-			continue;
-		if (IS_ERR(mpath))
-			break;
+	hlist_for_each_entry(mpath, &tbl->walk_head, walk_list) {
 		if (i++ == idx)
 			break;
 	}
-	rhashtable_walk_stop(&iter);
-	rhashtable_walk_exit(&iter);
 
-	if (IS_ERR(mpath) || !mpath)
+	if (!mpath)
 		return NULL;
 
 	if (mpath_expired(mpath)) {
@@ -441,7 +428,8 @@ struct mesh_path *mesh_path_add(struct ieee80211_sub_if_data *sdata,
 			mpath = rhashtable_lookup_fast(&tbl->rhead,
 						       dst,
 						       mesh_rht_params);
-
+		else if (!ret)
+			hlist_add_head(&new_mpath->walk_list, &tbl->walk_head);
 	} while (unlikely(ret == -EEXIST && !mpath));
 
 	if (ret && ret != -EEXIST)
@@ -483,6 +471,8 @@ int mpp_path_add(struct ieee80211_sub_if_data *sdata,
 	ret = rhashtable_lookup_insert_fast(&tbl->rhead,
 					    &new_mpath->rhash,
 					    mesh_rht_params);
+	if (!ret)
+		hlist_add_head(&new_mpath->walk_list, &tbl->walk_head);
 
 	sdata->u.mesh.mpp_paths_generation++;
 	return ret;
@@ -503,20 +493,8 @@ void mesh_plink_broken(struct sta_info *sta)
 	struct mesh_table *tbl = sdata->u.mesh.mesh_paths;
 	static const u8 bcast[ETH_ALEN] = {0xff, 0xff, 0xff, 0xff, 0xff, 0xff};
 	struct mesh_path *mpath;
-	struct rhashtable_iter iter;
-	int ret;
-
-	ret = rhashtable_walk_init(&tbl->rhead, &iter, GFP_ATOMIC);
-	if (ret)
-		return;
-
-	rhashtable_walk_start(&iter);
 
-	while ((mpath = rhashtable_walk_next(&iter))) {
-		if (IS_ERR(mpath) && PTR_ERR(mpath) == -EAGAIN)
-			continue;
-		if (IS_ERR(mpath))
-			break;
+	hlist_for_each_entry(mpath, &tbl->walk_head, walk_list) {
 		if (rcu_access_pointer(mpath->next_hop) == sta &&
 		    mpath->flags & MESH_PATH_ACTIVE &&
 		    !(mpath->flags & MESH_PATH_FIXED)) {
@@ -530,8 +508,6 @@ void mesh_plink_broken(struct sta_info *sta)
 				WLAN_REASON_MESH_PATH_DEST_UNREACHABLE, bcast);
 		}
 	}
-	rhashtable_walk_stop(&iter);
-	rhashtable_walk_exit(&iter);
 }
 
 static void mesh_path_free_rcu(struct mesh_table *tbl,
@@ -551,6 +527,7 @@ static void mesh_path_free_rcu(struct mesh_table *tbl,
 
 static void __mesh_path_del(struct mesh_table *tbl, struct mesh_path *mpath)
 {
+	hlist_del(&mpath->walk_list);
 	rhashtable_remove_fast(&tbl->rhead, &mpath->rhash, mesh_rht_params);
 	mesh_path_free_rcu(tbl, mpath);
 }
@@ -571,27 +548,12 @@ void mesh_path_flush_by_nexthop(struct sta_info *sta)
 	struct ieee80211_sub_if_data *sdata = sta->sdata;
 	struct mesh_table *tbl = sdata->u.mesh.mesh_paths;
 	struct mesh_path *mpath;
-	struct rhashtable_iter iter;
-	int ret;
-
-	ret = rhashtable_walk_init(&tbl->rhead, &iter, GFP_ATOMIC);
-	if (ret)
-		return;
-
-	rhashtable_walk_start(&iter);
-
-	while ((mpath = rhashtable_walk_next(&iter))) {
-		if (IS_ERR(mpath) && PTR_ERR(mpath) == -EAGAIN)
-			continue;
-		if (IS_ERR(mpath))
-			break;
+	struct hlist_node *n;
 
+	hlist_for_each_entry_safe(mpath, n, &tbl->walk_head, walk_list) {
 		if (rcu_access_pointer(mpath->next_hop) == sta)
 			__mesh_path_del(tbl, mpath);
 	}
-
-	rhashtable_walk_stop(&iter);
-	rhashtable_walk_exit(&iter);
 }
 
 static void mpp_flush_by_proxy(struct ieee80211_sub_if_data *sdata,
@@ -599,51 +561,22 @@ static void mpp_flush_by_proxy(struct ieee80211_sub_if_data *sdata,
 {
 	struct mesh_table *tbl = sdata->u.mesh.mpp_paths;
 	struct mesh_path *mpath;
-	struct rhashtable_iter iter;
-	int ret;
-
-	ret = rhashtable_walk_init(&tbl->rhead, &iter, GFP_ATOMIC);
-	if (ret)
-		return;
-
-	rhashtable_walk_start(&iter);
-
-	while ((mpath = rhashtable_walk_next(&iter))) {
-		if (IS_ERR(mpath) && PTR_ERR(mpath) == -EAGAIN)
-			continue;
-		if (IS_ERR(mpath))
-			break;
+	struct hlist_node *n;
 
+	hlist_for_each_entry_safe(mpath, n, &tbl->walk_head, walk_list) {
 		if (ether_addr_equal(mpath->mpp, proxy))
 			__mesh_path_del(tbl, mpath);
 	}
-
-	rhashtable_walk_stop(&iter);
-	rhashtable_walk_exit(&iter);
 }
 
 static void table_flush_by_iface(struct mesh_table *tbl)
 {
 	struct mesh_path *mpath;
-	struct rhashtable_iter iter;
-	int ret;
-
-	ret = rhashtable_walk_init(&tbl->rhead, &iter, GFP_ATOMIC);
-	if (ret)
-		return;
-
-	rhashtable_walk_start(&iter);
+	struct hlist_node *n;
 
-	while ((mpath = rhashtable_walk_next(&iter))) {
-		if (IS_ERR(mpath) && PTR_ERR(mpath) == -EAGAIN)
-			continue;
-		if (IS_ERR(mpath))
-			break;
+	hlist_for_each_entry_safe(mpath, n, &tbl->walk_head, walk_list) {
 		__mesh_path_del(tbl, mpath);
 	}
-
-	rhashtable_walk_stop(&iter);
-	rhashtable_walk_exit(&iter);
 }
 
 /**
@@ -838,6 +771,8 @@ int mesh_pathtbl_init(struct ieee80211_sub_if_data *sdata)
 
 	rhashtable_init(&tbl_path->rhead, &mesh_rht_params);
 	rhashtable_init(&tbl_mpp->rhead, &mesh_rht_params);
+	INIT_HLIST_HEAD(&tbl_path->walk_head);
+	INIT_HLIST_HEAD(&tbl_mpp->walk_head);
 
 	sdata->u.mesh.mesh_paths = tbl_path;
 	sdata->u.mesh.mpp_paths = tbl_mpp;
@@ -854,28 +789,14 @@ void mesh_path_tbl_expire(struct ieee80211_sub_if_data *sdata,
 			  struct mesh_table *tbl)
 {
 	struct mesh_path *mpath;
-	struct rhashtable_iter iter;
-	int ret;
-
-	ret = rhashtable_walk_init(&tbl->rhead, &iter, GFP_KERNEL);
-	if (ret)
-		return;
-
-	rhashtable_walk_start(&iter);
+	struct hlist_node *n;
 
-	while ((mpath = rhashtable_walk_next(&iter))) {
-		if (IS_ERR(mpath) && PTR_ERR(mpath) == -EAGAIN)
-			continue;
-		if (IS_ERR(mpath))
-			break;
+	hlist_for_each_entry_safe(mpath, n, &tbl->walk_head, walk_list) {
 		if ((!(mpath->flags & MESH_PATH_RESOLVING)) &&
 		    (!(mpath->flags & MESH_PATH_FIXED)) &&
 		     time_after(jiffies, mpath->exp_time + MESH_PATH_EXPIRE))
 			__mesh_path_del(tbl, mpath);
 	}
-
-	rhashtable_walk_stop(&iter);
-	rhashtable_walk_exit(&iter);
 }
 
 void mesh_path_expire(struct ieee80211_sub_if_data *sdata)
