Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:60116 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750943Ab2LOJSt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 15 Dec 2012 04:18:49 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: remove a bit of dead mesh code
Date: Sat, 15 Dec 2012 10:19:07 +0100
Message-Id: <1355563147-10288-1-git-send-email-johannes@sipsolutions.net> (sfid-20121215_101857_701129_D81DC541)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

In a file that's only built when CONFIG_MAC80211_MESH
is defined, having an #ifdef on the same is entirely
pointless, so remove it.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/mesh.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index 776536a..51e5bb9 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -20,16 +20,11 @@
 int mesh_allocated;
 static struct kmem_cache *rm_cache;
 
-#ifdef CONFIG_MAC80211_MESH
 bool mesh_action_is_path_sel(struct ieee80211_mgmt *mgmt)
 {
 	return (mgmt->u.action.u.mesh_action.action_code ==
 			WLAN_MESH_ACTION_HWMP_PATH_SELECTION);
 }
-#else
-bool mesh_action_is_path_sel(struct ieee80211_mgmt *mgmt)
-{ return false; }
-#endif
 
 void ieee80211s_init(void)
 {
-- 
1.8.0

