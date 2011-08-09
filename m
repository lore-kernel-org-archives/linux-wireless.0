Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f170.google.com ([209.85.210.170]:52194 "EHLO
	mail-iy0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751662Ab1HIXq0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Aug 2011 19:46:26 -0400
Received: by mail-iy0-f170.google.com with SMTP id 16so23646iye.1
        for <linux-wireless@vger.kernel.org>; Tue, 09 Aug 2011 16:46:26 -0700 (PDT)
From: Thomas Pedersen <thomas@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: Javier Cardona <javier@cozybit.com>, johannes@sipsolutions.net,
	linville@tuxdriver.com
Subject: [PATCH 2/8] mac80211: fix mpath timer NULL function
Date: Tue,  9 Aug 2011 16:45:05 -0700
Message-Id: <1312933511-9486-3-git-send-email-thomas@cozybit.com> (sfid-20110810_014630_742743_C66E2414)
In-Reply-To: <1312933511-9486-1-git-send-email-thomas@cozybit.com>
References: <1312933511-9486-1-git-send-email-thomas@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Javier Cardona <javier@cozybit.com>

If we have an mpath whose timer has not been initialized, don't try to
delete it.

Signed-off-by: Javier Cardona <javier@cozybit.com>
---
 net/mac80211/mesh_pathtbl.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/mesh_pathtbl.c b/net/mac80211/mesh_pathtbl.c
index 819d8e4..89f469b 100644
--- a/net/mac80211/mesh_pathtbl.c
+++ b/net/mac80211/mesh_pathtbl.c
@@ -619,7 +619,8 @@ static void mesh_path_node_reclaim(struct rcu_head *rp)
 	struct mpath_node *node = container_of(rp, struct mpath_node, rcu);
 	struct ieee80211_sub_if_data *sdata = node->mpath->sdata;
 
-	del_timer_sync(&node->mpath->timer);
+	if (node->mpath->timer.function)
+		del_timer_sync(&node->mpath->timer);
 	atomic_dec(&sdata->u.mesh.mpaths);
 	kfree(node->mpath);
 	kfree(node);
@@ -768,7 +769,8 @@ static void mesh_path_node_free(struct hlist_node *p, bool free_leafs)
 	mpath = node->mpath;
 	hlist_del_rcu(p);
 	if (free_leafs) {
-		del_timer_sync(&mpath->timer);
+		if (mpath->timer.function)
+			del_timer_sync(&mpath->timer);
 		kfree(mpath);
 	}
 	kfree(node);
-- 
1.7.6

