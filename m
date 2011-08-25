Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yi0-f46.google.com ([209.85.218.46]:64004 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752179Ab1HYBWO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Aug 2011 21:22:14 -0400
Received: by mail-yi0-f46.google.com with SMTP id 30so1334527yie.19
        for <linux-wireless@vger.kernel.org>; Wed, 24 Aug 2011 18:22:13 -0700 (PDT)
From: Thomas Pedersen <thomas@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: Javier Cardona <javier@cozybit.com>, johannes@sipsolutions.net,
	linville@tuxdriver.com
Subject: [PATCH 4/8] Revert "mac80211: fix mpath timer NULL function"
Date: Wed, 24 Aug 2011 18:21:49 -0700
Message-Id: <1314235313-4564-5-git-send-email-thomas@cozybit.com> (sfid-20110825_032219_047497_2A640538)
In-Reply-To: <1314235313-4564-1-git-send-email-thomas@cozybit.com>
References: <1314235313-4564-1-git-send-email-thomas@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Javier Cardona <javier@cozybit.com>

This reverts commit 86d7f9f35dcc686d57465798201e678040916979.
---
 net/mac80211/mesh_pathtbl.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/net/mac80211/mesh_pathtbl.c b/net/mac80211/mesh_pathtbl.c
index bcf7fee..41036a2 100644
--- a/net/mac80211/mesh_pathtbl.c
+++ b/net/mac80211/mesh_pathtbl.c
@@ -619,8 +619,7 @@ static void mesh_path_node_reclaim(struct rcu_head *rp)
 	struct mpath_node *node = container_of(rp, struct mpath_node, rcu);
 	struct ieee80211_sub_if_data *sdata = node->mpath->sdata;
 
-	if (node->mpath->timer.function)
-		del_timer_sync(&node->mpath->timer);
+	del_timer_sync(&node->mpath->timer);
 	atomic_dec(&sdata->u.mesh.mpaths);
 	kfree(node->mpath);
 	kfree(node);
@@ -768,8 +767,7 @@ static void mesh_path_node_free(struct hlist_node *p, bool free_leafs)
 	mpath = node->mpath;
 	hlist_del_rcu(p);
 	if (free_leafs) {
-		if (mpath->timer.function)
-			del_timer_sync(&mpath->timer);
+		del_timer_sync(&mpath->timer);
 		kfree(mpath);
 	}
 	kfree(node);
-- 
1.7.4.1

