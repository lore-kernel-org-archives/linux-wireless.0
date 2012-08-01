Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44542 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752154Ab2HATQw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Aug 2012 15:16:52 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: cancel mesh path timer
Date: Wed,  1 Aug 2012 21:16:49 +0200
Message-Id: <1343848609-9615-1-git-send-email-johannes@sipsolutions.net> (sfid-20120801_211654_830436_F8E16023)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The mesh path timer needs to be canceled when
leaving the mesh as otherwise it could fire
after the interface has been removed already.

Cc: stable@vger.kernel.org
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/mesh.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index d60b3d3..8557235 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -622,6 +622,7 @@ void ieee80211_stop_mesh(struct ieee80211_sub_if_data *sdata)
 
 	del_timer_sync(&sdata->u.mesh.housekeeping_timer);
 	del_timer_sync(&sdata->u.mesh.mesh_path_root_timer);
+	del_timer_sync(&sdata->u.mesh.mesh_path_timer);
 	/*
 	 * If the timer fired while we waited for it, it will have
 	 * requeued the work. Now the work will be running again
-- 
1.7.10.4

