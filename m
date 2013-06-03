Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f50.google.com ([209.85.160.50]:58527 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759104Ab3FCQxu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Jun 2013 12:53:50 -0400
Received: by mail-pb0-f50.google.com with SMTP id wy17so5898641pbc.23
        for <linux-wireless@vger.kernel.org>; Mon, 03 Jun 2013 09:53:50 -0700 (PDT)
From: Colleen Twitty <colleen@cozybit.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wirelss <linux-wireless@vger.kernel.org>,
	open80211s <devel@lists.open80211s.org>
Subject: [PATCH 2/2] mac80211: expire mesh peers based on mesh configuration
Date: Mon,  3 Jun 2013 09:53:40 -0700
Message-Id: <1370278420-10135-2-git-send-email-colleen@cozybit.com> (sfid-20130603_185353_906709_4AD3F232)
In-Reply-To: <1370278420-10135-1-git-send-email-colleen@cozybit.com>
References: <1370278420-10135-1-git-send-email-colleen@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The time it takes to see the peer link expire may differ
by a minute since sta_expire() is run once a minute as a
mesh housekeeping task.

Signed-off-by: Colleen Twitty <colleen@cozybit.com>
---
 net/mac80211/cfg.c  |    2 ++
 net/mac80211/mesh.c |    2 +-
 net/mac80211/mesh.h |    1 -
 3 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 1a89c80..97bb950 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1856,6 +1856,8 @@ static int ieee80211_update_mesh_config(struct wiphy *wiphy,
 	if (_chg_mesh_attr(NL80211_MESHCONF_AWAKE_WINDOW, mask))
 		conf->dot11MeshAwakeWindowDuration =
 			nconf->dot11MeshAwakeWindowDuration;
+	if (_chg_mesh_attr(NL80211_MESHCONF_PLINK_TIMEOUT, mask))
+		conf->plink_timeout = nconf->plink_timeout;
 	ieee80211_mbss_info_change_notify(sdata, BSS_CHANGED_BEACON);
 	return 0;
 }
diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index 6952760..37a0533 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -573,7 +573,7 @@ static void ieee80211_mesh_housekeeping(struct ieee80211_sub_if_data *sdata)
 	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
 	u32 changed;
 
-	ieee80211_sta_expire(sdata, IEEE80211_MESH_PEER_INACTIVITY_LIMIT);
+	ieee80211_sta_expire(sdata, ifmsh->mshcfg.plink_timeout * HZ);
 	mesh_path_expire(sdata);
 
 	changed = mesh_accept_plinks_update(sdata);
diff --git a/net/mac80211/mesh.h b/net/mac80211/mesh.h
index da15877..faf6ce4 100644
--- a/net/mac80211/mesh.h
+++ b/net/mac80211/mesh.h
@@ -188,7 +188,6 @@ struct mesh_rmc {
 	u32 idx_mask;
 };
 
-#define IEEE80211_MESH_PEER_INACTIVITY_LIMIT (1800 * HZ)
 #define IEEE80211_MESH_HOUSEKEEPING_INTERVAL (60 * HZ)
 
 #define MESH_PATH_EXPIRE (600 * HZ)
-- 
1.7.9.5

