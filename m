Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.177]:23981 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759093AbYCCUUn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Mar 2008 15:20:43 -0500
Received: by wa-out-1112.google.com with SMTP id v27so277416wah.23
        for <linux-wireless@vger.kernel.org>; Mon, 03 Mar 2008 12:20:42 -0800 (PST)
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
	John Linville <linville@tuxdriver.com>
From: Luis Carlos Cobo <luisca@cozybit.com>
Date: Fri, 29 Feb 2008 14:49:37 -0800
Subject: [PATCH 06/10] mac80211: delete mesh_path timer on mesh_path removal
Message-ID: <47cc5d9a.16bc720a.25a2.ffffac2c@mx.google.com> (sfid-20080303_202058_957426_CF4FBCC2)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This avoids dereferencing a no longer existing struct mesh_path.

Signed-off-by: Luis Carlos Cobo <luisca@cozybit.com>
---
 net/mac80211/mesh_pathtbl.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/mesh_pathtbl.c b/net/mac80211/mesh_pathtbl.c
index ab4d757..bd58849 100644
--- a/net/mac80211/mesh_pathtbl.c
+++ b/net/mac80211/mesh_pathtbl.c
@@ -301,6 +301,7 @@ static void mesh_path_node_reclaim(struct rcu_head *rp)
 	struct ieee80211_sub_if_data *sdata =
 		IEEE80211_DEV_TO_SUB_IF(node->mpath->dev);
 
+	del_timer_sync(&node->mpath->timer);
 	atomic_dec(&sdata->u.sta.mpaths);
 	kfree(node->mpath);
 	kfree(node);
-- 
1.5.2.5



