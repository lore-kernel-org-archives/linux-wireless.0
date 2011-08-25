Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:48375 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753085Ab1HYBld (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Aug 2011 21:41:33 -0400
Received: by mail-yw0-f46.google.com with SMTP id 7so1335324ywf.19
        for <linux-wireless@vger.kernel.org>; Wed, 24 Aug 2011 18:41:33 -0700 (PDT)
From: Thomas Pedersen <thomas@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: Javier Cardona <javier@cozybit.com>, johannes@sipsolutions.net,
	linville@tuxdriver.com
Subject: [PATCH 8/9] mac80211: Don't take the mesh path resize lock when deleting an mpath
Date: Wed, 24 Aug 2011 18:40:51 -0700
Message-Id: <1314236452-7226-9-git-send-email-thomas@cozybit.com> (sfid-20110825_034135_559740_5A0AB59C)
In-Reply-To: <1314236452-7226-1-git-send-email-thomas@cozybit.com>
References: <1314236452-7226-1-git-send-email-thomas@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Javier Cardona <javier@cozybit.com>

The mesh path resize lock is only needed to protect addition or removal
of buckets on the hash table, not nodes on those buckets.

Signed-off-by: Javier Cardona <javier@cozybit.com>
---
 net/mac80211/mesh_pathtbl.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/mesh_pathtbl.c b/net/mac80211/mesh_pathtbl.c
index 9d9e1ac..4bfbe31 100644
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
1.7.4.1

