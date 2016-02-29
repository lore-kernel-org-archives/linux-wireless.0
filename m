Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qg0-f65.google.com ([209.85.192.65]:34535 "EHLO
	mail-qg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752020AbcB2BEI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 28 Feb 2016 20:04:08 -0500
Received: by mail-qg0-f65.google.com with SMTP id e61so9657236qgf.1
        for <linux-wireless@vger.kernel.org>; Sun, 28 Feb 2016 17:04:07 -0800 (PST)
From: Bob Copeland <me@bobcopeland.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Bob Copeland <me@bobcopeland.com>
Subject: [PATCH 3/4] mesh: factor out common mesh path allocation code
Date: Sun, 28 Feb 2016 20:03:58 -0500
Message-Id: <1456707839-19469-3-git-send-email-me@bobcopeland.com> (sfid-20160229_020421_083951_2264DDE6)
In-Reply-To: <1456707839-19469-1-git-send-email-me@bobcopeland.com>
References: <1456707839-19469-1-git-send-email-me@bobcopeland.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove duplicate code to allocate and initialize a mesh
path or mesh proxy path.

Signed-off-by: Bob Copeland <me@bobcopeland.com>
---
 net/mac80211/mesh_pathtbl.c | 51 +++++++++++++++++++++++++--------------------
 1 file changed, 28 insertions(+), 23 deletions(-)

diff --git a/net/mac80211/mesh_pathtbl.c b/net/mac80211/mesh_pathtbl.c
index fc3cc350df8c..4794240e8f94 100644
--- a/net/mac80211/mesh_pathtbl.c
+++ b/net/mac80211/mesh_pathtbl.c
@@ -501,6 +501,31 @@ int mesh_gate_num(struct ieee80211_sub_if_data *sdata)
 	return sdata->u.mesh.num_gates;
 }
 
+static
+struct mesh_path *mesh_path_new(struct ieee80211_sub_if_data *sdata,
+				const u8 *dst, gfp_t gfp_flags)
+{
+	struct mesh_path *new_mpath;
+
+	new_mpath = kzalloc(sizeof(struct mesh_path), gfp_flags);
+	if (!new_mpath)
+		return NULL;
+
+	memcpy(new_mpath->dst, dst, ETH_ALEN);
+	eth_broadcast_addr(new_mpath->rann_snd_addr);
+	new_mpath->is_root = false;
+	new_mpath->sdata = sdata;
+	new_mpath->flags = 0;
+	skb_queue_head_init(&new_mpath->frame_queue);
+	new_mpath->timer.data = (unsigned long) new_mpath;
+	new_mpath->timer.function = mesh_path_timer;
+	new_mpath->exp_time = jiffies;
+	spin_lock_init(&new_mpath->state_lock);
+	init_timer(&new_mpath->timer);
+
+	return new_mpath;
+}
+
 /**
  * mesh_path_add - allocate and add a new path to the mesh path table
  * @dst: destination address of the path (ETH_ALEN length)
@@ -548,7 +573,7 @@ struct mesh_path *mesh_path_add(struct ieee80211_sub_if_data *sdata,
 	}
 
 	err = -ENOMEM;
-	new_mpath = kzalloc(sizeof(struct mesh_path), GFP_ATOMIC);
+	new_mpath = mesh_path_new(sdata, dst, GFP_ATOMIC);
 	if (!new_mpath)
 		goto err_path_alloc;
 
@@ -556,19 +581,7 @@ struct mesh_path *mesh_path_add(struct ieee80211_sub_if_data *sdata,
 	if (!new_node)
 		goto err_node_alloc;
 
-	memcpy(new_mpath->dst, dst, ETH_ALEN);
-	eth_broadcast_addr(new_mpath->rann_snd_addr);
-	new_mpath->is_root = false;
-	new_mpath->sdata = sdata;
-	new_mpath->flags = 0;
-	skb_queue_head_init(&new_mpath->frame_queue);
 	new_node->mpath = new_mpath;
-	new_mpath->timer.data = (unsigned long) new_mpath;
-	new_mpath->timer.function = mesh_path_timer;
-	new_mpath->exp_time = jiffies;
-	spin_lock_init(&new_mpath->state_lock);
-	init_timer(&new_mpath->timer);
-
 	hlist_add_head_rcu(&new_node->list, bucket);
 	if (atomic_inc_return(&tbl->entries) >=
 	    MEAN_CHAIN_LEN * (tbl->hash_mask + 1))
@@ -664,7 +677,7 @@ int mpp_path_add(struct ieee80211_sub_if_data *sdata,
 		return -ENOTSUPP;
 
 	err = -ENOMEM;
-	new_mpath = kzalloc(sizeof(struct mesh_path), GFP_ATOMIC);
+	new_mpath = mesh_path_new(sdata, dst, GFP_ATOMIC);
 	if (!new_mpath)
 		goto err_path_alloc;
 
@@ -672,17 +685,9 @@ int mpp_path_add(struct ieee80211_sub_if_data *sdata,
 	if (!new_node)
 		goto err_node_alloc;
 
-	read_lock_bh(&sdata->u.mesh.pathtbl_resize_lock);
-	memcpy(new_mpath->dst, dst, ETH_ALEN);
 	memcpy(new_mpath->mpp, mpp, ETH_ALEN);
-	new_mpath->sdata = sdata;
-	new_mpath->flags = 0;
-	skb_queue_head_init(&new_mpath->frame_queue);
 	new_node->mpath = new_mpath;
-	init_timer(&new_mpath->timer);
-	new_mpath->exp_time = jiffies;
-	spin_lock_init(&new_mpath->state_lock);
-
+	read_lock_bh(&sdata->u.mesh.pathtbl_resize_lock);
 	tbl = resize_dereference_mpp_paths(sdata);
 
 	hash_idx = mesh_table_hash(dst, tbl);
-- 
2.6.1

