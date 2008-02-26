Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:43603 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757943AbYBZPjr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Feb 2008 10:39:47 -0500
Subject: [PATCH] mac80211: don't clear next_hop in path reclaim
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Luis Carlos Cobo <luisca@cozybit.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 26 Feb 2008 10:53:57 +0100
Message-Id: <1204019637.13162.216.camel@johannes.berg> (sfid-20080226_154004_098373_DE47E43D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luis pointed out that this path is going to be freed right
away anyway so there's no point in assigning next_hop.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Cc: Luis Carlos Cobo <luisca@cozybit.com>
---
 net/mac80211/mesh_pathtbl.c |    1 -
 1 file changed, 1 deletion(-)

--- everything.orig/net/mac80211/mesh_pathtbl.c	2008-02-26 10:51:22.000000000 +0100
+++ everything/net/mac80211/mesh_pathtbl.c	2008-02-26 10:51:40.000000000 +0100
@@ -301,7 +301,6 @@ static void mesh_path_node_reclaim(struc
 	struct ieee80211_sub_if_data *sdata =
 		IEEE80211_DEV_TO_SUB_IF(node->mpath->dev);
 
-	rcu_assign_pointer(node->mpath->next_hop, NULL);
 	atomic_dec(&sdata->u.sta.mpaths);
 	kfree(node->mpath);
 	kfree(node);


