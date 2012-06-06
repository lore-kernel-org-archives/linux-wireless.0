Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:57038 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751410Ab2FFKVL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jun 2012 06:21:11 -0400
Received: by mail-pb0-f46.google.com with SMTP id rp8so8745290pbb.19
        for <linux-wireless@vger.kernel.org>; Wed, 06 Jun 2012 03:21:11 -0700 (PDT)
From: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, javier@cozybit.com,
	linville@tuxdriver.com, devel@lists.open80211s.org,
	Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
Subject: [PATCH 4/4] mac80211: invoke the timer only with correct dot11MeshHWMPRootMode value
Date: Wed,  6 Jun 2012 18:20:39 +0800
Message-Id: <1338978039-4269-5-git-send-email-yeohchunyeow@gmail.com> (sfid-20120606_122114_951073_D5D8AB00)
In-Reply-To: <1338978039-4269-1-git-send-email-yeohchunyeow@gmail.com>
References: <1338978039-4269-1-git-send-email-yeohchunyeow@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

mesh_path_root_timer is invoked once the dot11MeshHWMPRootMode is larger than 1. This patch
also adds the backward compatible to the previous setting on dot11MeshHWMPRootMode. If the
user configures as follow, it will still trigger the proactive RANN with Gate Announcement.

iw mesh0 set mesh_param mesh_hwmp_rootmode 1
iw mesh0 set mesh_param mesh_gate_announcements 1

similar to the following setting:

iw mesh0 set mesh_param mesh_hwmp_rootmode 4
iw mesh0 set mesh_param mesh_gate_announcements 1

Signed-off-by: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
---
 net/mac80211/cfg.c  |    4 ++--
 net/mac80211/mesh.c |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 626baa2..31ffab1 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1561,8 +1561,8 @@ static int ieee80211_update_mesh_config(struct wiphy *wiphy,
 		 * announcements, so require this ifmsh to also be a root node
 		 * */
 		if (nconf->dot11MeshGateAnnouncementProtocol &&
-		    !conf->dot11MeshHWMPRootMode) {
-			conf->dot11MeshHWMPRootMode = 1;
+		    !(conf->dot11MeshHWMPRootMode > 1)) {
+			conf->dot11MeshHWMPRootMode = 4;
 			ieee80211_mesh_root_setup(ifmsh);
 		}
 		conf->dot11MeshGateAnnouncementProtocol =
diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index 5e19e0d..5b42598 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -443,7 +443,7 @@ static void ieee80211_mesh_path_root_timer(unsigned long data)
 
 void ieee80211_mesh_root_setup(struct ieee80211_if_mesh *ifmsh)
 {
-	if (ifmsh->mshcfg.dot11MeshHWMPRootMode)
+	if (ifmsh->mshcfg.dot11MeshHWMPRootMode > 1)
 		set_bit(MESH_WORK_ROOT, &ifmsh->wrkq_flags);
 	else {
 		clear_bit(MESH_WORK_ROOT, &ifmsh->wrkq_flags);
-- 
1.7.0.4

