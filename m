Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f53.google.com ([209.85.220.53]:38281 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760354Ab3ECTMX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 May 2013 15:12:23 -0400
Received: by mail-pa0-f53.google.com with SMTP id kq12so1069673pab.26
        for <linux-wireless@vger.kernel.org>; Fri, 03 May 2013 12:12:23 -0700 (PDT)
From: Colleen Twitty <colleen@cozybit.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: open80211s <devel@lists.open80211s.org>,
	linux-wirelss <linux-wireless@vger.kernel.org>
Subject: [PATCH 2/2] mac80211: enable Auth Protocol Identifier on mesh config.
Date: Fri,  3 May 2013 12:11:48 -0700
Message-Id: <1367608308-588-2-git-send-email-colleen@cozybit.com> (sfid-20130503_211227_624177_5F41C55C)
In-Reply-To: <1367608308-588-1-git-send-email-colleen@cozybit.com>
References: <1367608308-588-1-git-send-email-colleen@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Previously the mesh_auth_id was disabled.  Instead set the
correct mesh authentication bit based on the mesh setup.

Signed-off-by: Colleen Twitty <colleen@cozybit.com>
---
 net/mac80211/cfg.c  |    1 +
 net/mac80211/mesh.c |    1 -
 2 files changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 1f51bdf..65b9cab 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1746,6 +1746,7 @@ static int copy_mesh_setup(struct ieee80211_if_mesh *ifmsh,
 	ifmsh->mesh_pp_id = setup->path_sel_proto;
 	ifmsh->mesh_pm_id = setup->path_metric;
 	ifmsh->user_mpm = setup->user_mpm;
+	ifmsh->mesh_auth_id = setup->auth_id;
 	ifmsh->security = IEEE80211_MESH_SEC_NONE;
 	if (setup->is_authenticated)
 		ifmsh->security |= IEEE80211_MESH_SEC_AUTHED;
diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index 6952760..c13db9a 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -748,7 +748,6 @@ int ieee80211_start_mesh(struct ieee80211_sub_if_data *sdata)
 	ieee80211_configure_filter(local);
 
 	ifmsh->mesh_cc_id = 0;	/* Disabled */
-	ifmsh->mesh_auth_id = 0;	/* Disabled */
 	/* register sync ops from extensible synchronization framework */
 	ifmsh->sync_ops = ieee80211_mesh_sync_ops_get(ifmsh->mesh_sp_id);
 	ifmsh->adjusting_tbtt = false;
-- 
1.7.9.5

