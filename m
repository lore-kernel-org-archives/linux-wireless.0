Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:36738 "EHLO
	mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753848AbcA2KJG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Jan 2016 05:09:06 -0500
Received: by mail-wm0-f65.google.com with SMTP id 128so6685761wmz.3
        for <linux-wireless@vger.kernel.org>; Fri, 29 Jan 2016 02:09:05 -0800 (PST)
From: Henning Rogge <hrogge@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"David S. Miller" <davem@davemloft.net>,
	Henning Rogge <hrogge@gmail.com>,
	Henning Rogge <henning.rogge@fkie.fraunhofer.de>
Subject: [PATCH v2 1/3] mac80211: Remove MPP table entries with MPath
Date: Fri, 29 Jan 2016 11:08:56 +0100
Message-Id: <1454062138-18012-2-git-send-email-henning.rogge@fkie.fraunhofer.de> (sfid-20160129_110915_447473_AEC6B5A9)
In-Reply-To: <1454062138-18012-1-git-send-email-henning.rogge@fkie.fraunhofer.de>
References: <1454062138-18012-1-git-send-email-henning.rogge@fkie.fraunhofer.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Make the mesh_path_del() function remove all mpp table entries
that are proxied by the removed mesh path.

Signed-off-by: Henning Rogge <henning.rogge@fkie.fraunhofer.de>
---
 net/mac80211/mesh_pathtbl.c | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/net/mac80211/mesh_pathtbl.c b/net/mac80211/mesh_pathtbl.c
index dadf8dc..d9424ea 100644
--- a/net/mac80211/mesh_pathtbl.c
+++ b/net/mac80211/mesh_pathtbl.c
@@ -835,6 +835,29 @@ void mesh_path_flush_by_nexthop(struct sta_info *sta)
 	rcu_read_unlock();
 }
 
+static void mpp_flush_by_proxy(struct ieee80211_sub_if_data *sdata,
+			       const u8 *proxy)
+{
+	struct mesh_table *tbl;
+	struct mesh_path *mpp;
+	struct mpath_node *node;
+	int i;
+
+	rcu_read_lock();
+	read_lock_bh(&pathtbl_resize_lock);
+	tbl = resize_dereference_mpp_paths();
+	for_each_mesh_entry(tbl, node, i) {
+		mpp = node->mpath;
+		if (ether_addr_equal(mpp->mpp, proxy)) {
+			spin_lock(&tbl->hashwlock[i]);
+			__mesh_path_del(tbl, node);
+			spin_unlock(&tbl->hashwlock[i]);
+		}
+	}
+	read_unlock_bh(&pathtbl_resize_lock);
+	rcu_read_unlock();
+}
+
 static void table_flush_by_iface(struct mesh_table *tbl,
 				 struct ieee80211_sub_if_data *sdata)
 {
@@ -892,6 +915,9 @@ int mesh_path_del(struct ieee80211_sub_if_data *sdata, const u8 *addr)
 	int hash_idx;
 	int err = 0;
 
+	/* flush relevant mpp entries first */
+	mpp_flush_by_proxy(sdata, addr);
+
 	read_lock_bh(&pathtbl_resize_lock);
 	tbl = resize_dereference_mesh_paths();
 	hash_idx = mesh_table_hash(addr, sdata, tbl);
-- 
2.5.0

