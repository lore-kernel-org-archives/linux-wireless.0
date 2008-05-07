Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sacred.ru ([62.205.161.221]:37407 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755535AbYEGP6w (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 May 2008 11:58:52 -0400
Message-ID: <4821D10F.4020702@openvz.org> (sfid-20080507_175758_956904_3249BC19)
Date: Wed, 07 May 2008 19:55:59 +0400
From: Pavel Emelyanov <xemul@openvz.org>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless@vger.kernel.org,
	Linux Netdev List <netdev@vger.kernel.org>
Subject: [PATCH 6/7][MAC80211]: Merge error paths in mesh_table_grow().
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is the first (of two) clean ups after the fixes above.

The err variable is not even required after this cleaning.

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>

---
 net/mac80211/mesh.c |   16 ++++------------
 1 files changed, 4 insertions(+), 12 deletions(-)

diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index 273f0b6..f46fbdb 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -350,20 +350,15 @@ struct mesh_table *mesh_table_grow(struct mesh_table *tbl)
 	struct mesh_table *newtbl;
 	struct hlist_head *oldhash;
 	struct hlist_node *p, *q;
-	int err = 0;
 	int i;
 
 	if (atomic_read(&tbl->entries)
-			< tbl->mean_chain_len * (tbl->hash_mask + 1)) {
-		err = -EPERM;
+			< tbl->mean_chain_len * (tbl->hash_mask + 1))
 		goto endgrow;
-	}
 
 	newtbl = mesh_table_alloc(tbl->size_order + 1);
-	if (!newtbl) {
-		err = -ENOMEM;
+	if (!newtbl)
 		goto endgrow;
-	}
 
 	newtbl->free_node = tbl->free_node;
 	newtbl->mean_chain_len = tbl->mean_chain_len;
@@ -376,11 +371,7 @@ struct mesh_table *mesh_table_grow(struct mesh_table *tbl)
 			if (tbl->copy_node(p, newtbl) < 0)
 				goto errcopy;
 
-endgrow:
-	if (err)
-		return NULL;
-	else
-		return newtbl;
+	return newtbl;
 
 errcopy:
 	for (i = 0; i <= newtbl->hash_mask; i++) {
@@ -390,6 +381,7 @@ errcopy:
 	kfree(newtbl->hash_buckets);
 	kfree(newtbl->hashwlock);
 	kfree(newtbl);
+endgrow:
 	return NULL;
 }
 
-- 
1.5.3.4

