Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yi0-f46.google.com ([209.85.218.46]:61573 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754643Ab1H0ASn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Aug 2011 20:18:43 -0400
Received: by mail-yi0-f46.google.com with SMTP id 30so2047705yie.19
        for <linux-wireless@vger.kernel.org>; Fri, 26 Aug 2011 17:18:43 -0700 (PDT)
From: Javier Cardona <javier@cozybit.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Javier Cardona <javier@cozybit.com>,
	Thomas Pedersen <thomas@cozybit.com>,
	devel@lists.open80211s.org,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, jlopex@gmail.com
Subject: [PATCH v2 7/8] mac80211: Don't take the mesh path resize lock when deleting an mpath
Date: Fri, 26 Aug 2011 17:18:13 -0700
Message-Id: <1314404294-4233-8-git-send-email-javier@cozybit.com> (sfid-20110827_021846_756125_00AAD2D2)
In-Reply-To: <1314404294-4233-1-git-send-email-javier@cozybit.com>
References: <1314236452-7226-1-git-send-email-thomas@cozybit.com>
 <1314404294-4233-1-git-send-email-javier@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The mesh path resize lock is only needed to protect addition or removal
of buckets on the hash table, not nodes on those buckets.

Signed-off-by: Javier Cardona <javier@cozybit.com>
---
 net/mac80211/mesh_pathtbl.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/mesh_pathtbl.c b/net/mac80211/mesh_pathtbl.c
index 3c03be9..216bd2f 100644
--- a/net/mac80211/mesh_pathtbl.c
+++ b/net/mac80211/mesh_pathtbl.c
@@ -905,8 +905,8 @@ int mesh_path_del(u8 *addr, struct ieee80211_sub_if_data *sdata)
 	int hash_idx;
 	int err = 0;
 
-	read_lock_bh(&pathtbl_resize_lock);
-	tbl = resize_dereference_mesh_paths();
+	rcu_read_lock();
+	tbl = rcu_dereference(mesh_paths);
 	hash_idx = mesh_table_hash(addr, sdata, tbl);
 	bucket = &tbl->hash_buckets[hash_idx];
 
@@ -924,7 +924,7 @@ int mesh_path_del(u8 *addr, struct ieee80211_sub_if_data *sdata)
 enddel:
 	mesh_paths_generation++;
 	spin_unlock_bh(&tbl->hashwlock[hash_idx]);
-	read_unlock_bh(&pathtbl_resize_lock);
+	rcu_read_unlock();
 	return err;
 }
 
-- 
1.7.6

