Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f44.google.com ([74.125.82.44]:37285 "EHLO
	mail-wm0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754496AbcBCM6t (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Feb 2016 07:58:49 -0500
Received: by mail-wm0-f44.google.com with SMTP id l66so69082150wml.0
        for <linux-wireless@vger.kernel.org>; Wed, 03 Feb 2016 04:58:48 -0800 (PST)
From: Henning Rogge <hrogge@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"David S. Miller" <davem@davemloft.net>,
	Henning Rogge <hrogge@gmail.com>,
	Bob Copeland <me@bobcopeland.com>,
	Henning Rogge <henning.rogge@fkie.fraunhofer.de>
Subject: [PATCH v3 2/3] mac80211: let unused MPP table entries timeout
Date: Wed,  3 Feb 2016 13:58:37 +0100
Message-Id: <1454504318-24988-3-git-send-email-henning.rogge@fkie.fraunhofer.de> (sfid-20160203_135853_390501_CF87BF05)
In-Reply-To: <1454504318-24988-1-git-send-email-henning.rogge@fkie.fraunhofer.de>
References: <1454504318-24988-1-git-send-email-henning.rogge@fkie.fraunhofer.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remember the last time when a mpp table entry is used for
rx or tx and remove them after MESH_PATH_EXPIRE time.

Signed-off-by: Henning Rogge <henning.rogge@fkie.fraunhofer.de>
---
 net/mac80211/mesh_pathtbl.c | 51 +++++++++++++++++++++++++++++++++++++++++++++
 net/mac80211/rx.c           |  1 +
 net/mac80211/tx.c           |  5 ++++-
 3 files changed, 56 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/mesh_pathtbl.c b/net/mac80211/mesh_pathtbl.c
index d9424ea..0ab862a 100644
--- a/net/mac80211/mesh_pathtbl.c
+++ b/net/mac80211/mesh_pathtbl.c
@@ -942,6 +942,46 @@ enddel:
 }
 
 /**
+ * mpp_path_del - delete a mesh proxy path from the table
+ *
+ * @addr: addr address (ETH_ALEN length)
+ * @sdata: local subif
+ *
+ * Returns: 0 if successful
+ */
+static int mpp_path_del(struct ieee80211_sub_if_data *sdata, const u8 *addr)
+{
+	struct mesh_table *tbl;
+	struct mesh_path *mpath;
+	struct mpath_node *node;
+	struct hlist_head *bucket;
+	int hash_idx;
+	int err = 0;
+
+	read_lock_bh(&pathtbl_resize_lock);
+	tbl = resize_dereference_mpp_paths();
+	hash_idx = mesh_table_hash(addr, sdata, tbl);
+	bucket = &tbl->hash_buckets[hash_idx];
+
+	spin_lock(&tbl->hashwlock[hash_idx]);
+	hlist_for_each_entry(node, bucket, list) {
+		mpath = node->mpath;
+		if (mpath->sdata == sdata &&
+		    ether_addr_equal(addr, mpath->dst)) {
+			__mesh_path_del(tbl, node);
+			goto enddel;
+		}
+	}
+
+	err = -ENXIO;
+enddel:
+	mesh_paths_generation++;
+	spin_unlock(&tbl->hashwlock[hash_idx]);
+	read_unlock_bh(&pathtbl_resize_lock);
+	return err;
+}
+
+/**
  * mesh_path_tx_pending - sends pending frames in a mesh path queue
  *
  * @mpath: mesh path to activate
@@ -1157,6 +1197,17 @@ void mesh_path_expire(struct ieee80211_sub_if_data *sdata)
 		     time_after(jiffies, mpath->exp_time + MESH_PATH_EXPIRE))
 			mesh_path_del(mpath->sdata, mpath->dst);
 	}
+
+	tbl = rcu_dereference(mpp_paths);
+	for_each_mesh_entry(tbl, node, i) {
+		if (node->mpath->sdata != sdata)
+			continue;
+		mpath = node->mpath;
+		if ((!(mpath->flags & MESH_PATH_FIXED)) &&
+		    time_after(jiffies, mpath->exp_time + MESH_PATH_EXPIRE))
+			mpp_path_del(mpath->sdata, mpath->dst);
+	}
+
 	rcu_read_unlock();
 }
 
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index bc08185..d028581 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -2290,6 +2290,7 @@ ieee80211_rx_h_mesh_fwding(struct ieee80211_rx_data *rx)
 			spin_lock_bh(&mppath->state_lock);
 			if (!ether_addr_equal(mppath->mpp, mpp_addr))
 				memcpy(mppath->mpp, mpp_addr, ETH_ALEN);
+			mppath->exp_time = jiffies;
 			spin_unlock_bh(&mppath->state_lock);
 		}
 		rcu_read_unlock();
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 3311ce0..932309e 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -2099,8 +2099,11 @@ static struct sk_buff *ieee80211_build_hdr(struct ieee80211_sub_if_data *sdata,
 					mpp_lookup = true;
 			}
 
-			if (mpp_lookup)
+			if (mpp_lookup) {
 				mppath = mpp_path_lookup(sdata, skb->data);
+				if (mppath)
+					mppath->exp_time = jiffies;
+			}
 
 			if (mppath && mpath)
 				mesh_path_del(mpath->sdata, mpath->dst);
-- 
2.5.0

