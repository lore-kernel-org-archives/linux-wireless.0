Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:34496 "EHLO
	mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751786AbcASIE5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Jan 2016 03:04:57 -0500
Received: by mail-wm0-f67.google.com with SMTP id b14so21500238wmb.1
        for <linux-wireless@vger.kernel.org>; Tue, 19 Jan 2016 00:04:57 -0800 (PST)
From: Henning Rogge <hrogge@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"David S. Miller" <davem@davemloft.net>,
	Henning Rogge <hrogge@gmail.com>,
	Henning Rogge <henning.rogge@fkie.fraunhofer.de>
Subject: [PATCH 1/2] mac80211: Remove connected MPP table entries with MPath
Date: Tue, 19 Jan 2016 09:04:31 +0100
Message-Id: <1453190672-9748-2-git-send-email-henning.rogge@fkie.fraunhofer.de> (sfid-20160119_090500_435048_643FCD5B)
In-Reply-To: <1453190672-9748-1-git-send-email-henning.rogge@fkie.fraunhofer.de>
References: <1453190672-9748-1-git-send-email-henning.rogge@fkie.fraunhofer.de>
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

