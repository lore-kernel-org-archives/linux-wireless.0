Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f173.google.com ([209.85.212.173]:61300 "EHLO
	mail-px0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756543Ab1EMVQQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 May 2011 17:16:16 -0400
Received: by pxi16 with SMTP id 16so1912055pxi.4
        for <linux-wireless@vger.kernel.org>; Fri, 13 May 2011 14:16:16 -0700 (PDT)
From: Javier Cardona <javier@cozybit.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Javier Cardona <javier@cozybit.com>,
	Thomas Pedersen <thomas@cozybit.com>,
	devel@lists.open80211s.org,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, jlopex@gmail.com
Subject: [PATCH] mac80211: Deactivate mesh path timers when freeing nodes
Date: Fri, 13 May 2011 14:16:07 -0700
Message-Id: <1305321367-2850-1-git-send-email-javier@cozybit.com> (sfid-20110513_231620_116063_7DC4796D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Mesh paths are deleted via mesh_path_del() which properly
deactivates the timer associated to a mesh path.  But if paths were
deleted by mesh_table_free(..., true) timers would not be deactivated.
This fixes this case.

Reported-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Javier Cardona <javier@cozybit.com>
---
 net/mac80211/mesh_pathtbl.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/mesh_pathtbl.c b/net/mac80211/mesh_pathtbl.c
index a1d59bd..2a0302a 100644
--- a/net/mac80211/mesh_pathtbl.c
+++ b/net/mac80211/mesh_pathtbl.c
@@ -673,8 +673,10 @@ static void mesh_path_node_free(struct hlist_node *p, bool free_leafs)
 	struct mpath_node *node = hlist_entry(p, struct mpath_node, list);
 	mpath = node->mpath;
 	hlist_del_rcu(p);
-	if (free_leafs)
+	if (free_leafs) {
+		del_timer_sync(&mpath->timer);
 		kfree(mpath);
+	}
 	kfree(node);
 }
 
-- 
1.7.1

