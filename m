Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f170.google.com ([209.85.212.170]:51390 "EHLO
	mail-px0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753938Ab1ECX5n (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 May 2011 19:57:43 -0400
Received: by mail-px0-f170.google.com with SMTP id 19so426563pxi.1
        for <linux-wireless@vger.kernel.org>; Tue, 03 May 2011 16:57:43 -0700 (PDT)
From: Javier Cardona <javier@cozybit.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Javier Cardona <javier@cozybit.com>,
	Thomas Pedersen <thomas@cozybit.com>,
	devel@lists.open80211s.org,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, jlopex@gmail.com
Subject: [PATCH 09/13] Check size of a new mesh path table for changes since allocation.
Date: Tue,  3 May 2011 16:57:15 -0700
Message-Id: <1304467039-7730-10-git-send-email-javier@cozybit.com> (sfid-20110504_015749_589118_CB6CF68F)
In-Reply-To: <1304467039-7730-1-git-send-email-javier@cozybit.com>
References: <1304467039-7730-1-git-send-email-javier@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Not sure if I'm chasing a ghost here, seems like the
mesh_path->size_order needs to be inside an RCU-read section to prevent
that value from changing between table allocation and copying.  We have
observed crashes that might be caused by this.

Signed-off-by: Javier Cardona <javier@cozybit.com>
---
 net/mac80211/mesh_pathtbl.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/mesh_pathtbl.c b/net/mac80211/mesh_pathtbl.c
index 35c715a..d4e86fd 100644
--- a/net/mac80211/mesh_pathtbl.c
+++ b/net/mac80211/mesh_pathtbl.c
@@ -76,7 +76,6 @@ static int mesh_table_grow(struct mesh_table *oldtbl,
 			< oldtbl->mean_chain_len * (oldtbl->hash_mask + 1))
 		return -EAGAIN;
 
-
 	newtbl->free_node = oldtbl->free_node;
 	newtbl->mean_chain_len = oldtbl->mean_chain_len;
 	newtbl->copy_node = oldtbl->copy_node;
@@ -329,7 +328,8 @@ void mesh_mpath_table_grow(void)
 {
 	struct mesh_table *oldtbl, *newtbl;
 
-	newtbl = mesh_table_alloc(mesh_paths->size_order + 1);
+	rcu_read_lock();
+	newtbl = mesh_table_alloc(rcu_dereference(mesh_paths)->size_order + 1);
 	if (!newtbl)
 		return;
 	write_lock(&pathtbl_resize_lock);
@@ -339,6 +339,7 @@ void mesh_mpath_table_grow(void)
 		write_unlock(&pathtbl_resize_lock);
 		return;
 	}
+	rcu_read_unlock();
 	rcu_assign_pointer(mesh_paths, newtbl);
 	write_unlock(&pathtbl_resize_lock);
 
@@ -350,7 +351,8 @@ void mesh_mpp_table_grow(void)
 {
 	struct mesh_table *oldtbl, *newtbl;
 
-	newtbl = mesh_table_alloc(mpp_paths->size_order + 1);
+	rcu_read_lock();
+	newtbl = mesh_table_alloc(rcu_dereference(mpp_paths)->size_order + 1);
 	if (!newtbl)
 		return;
 	write_lock(&pathtbl_resize_lock);
@@ -360,6 +362,7 @@ void mesh_mpp_table_grow(void)
 		write_unlock(&pathtbl_resize_lock);
 		return;
 	}
+	rcu_read_unlock();
 	rcu_assign_pointer(mpp_paths, newtbl);
 	write_unlock(&pathtbl_resize_lock);
 
-- 
1.7.1

