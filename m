Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailrelayi.jaist.ac.jp ([150.65.19.7]:42761 "EHLO
	mailrelayi.jaist.ac.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751082Ab2H0NiC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Aug 2012 09:38:02 -0400
From: LEO Airwarosu Yoichi Shinoda <shinoda@jaist.ac.jp>
Content-Type: text/plain; charset=us-ascii
Subject: [PATCH] mac80211: Various small fixes for cfg.c: mpath_set_pinfo()
Date: Mon, 27 Aug 2012 22:28:16 +0900
Message-Id: <5811BCFB-A140-4A91-BF85-8074242B6000@jaist.ac.jp> (sfid-20120827_153807_127465_CC0D8428)
Cc: linux-wireless@vger.kernel.org, devel@lists.open80211s.org
To: linville@tuxdriver.com
Mime-Version: 1.0 (Apple Message framework v1278)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Various small fixes for net/mac80211/cfg.c:mpath_set_pinfo():
Initialize *pinfo before filling members in, handle MESH_PATH_RESOLVED
correctly, and remove bogus assignment; result in correct display
of FLAGS values and meaningful EXPTIME for expired paths in iw utility.

Signed-off-by: Yoichi Shinoda <shinoda@jaist.ac.jp>
---
 net/mac80211/cfg.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index d41974a..d69e38b 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1378,6 +1378,8 @@ static void mpath_set_pinfo(struct mesh_path *mpath, u8 *next_hop,
 	else
 		memset(next_hop, 0, ETH_ALEN);
 
+	memset(pinfo, 0, sizeof(struct mpath_info));
+
 	pinfo->generation = mesh_paths_generation;
 
 	pinfo->filled = MPATH_INFO_FRAME_QLEN |
@@ -1396,7 +1398,6 @@ static void mpath_set_pinfo(struct mesh_path *mpath, u8 *next_hop,
 	pinfo->discovery_timeout =
 			jiffies_to_msecs(mpath->discovery_timeout);
 	pinfo->discovery_retries = mpath->discovery_retries;
-	pinfo->flags = 0;
 	if (mpath->flags & MESH_PATH_ACTIVE)
 		pinfo->flags |= NL80211_MPATH_FLAG_ACTIVE;
 	if (mpath->flags & MESH_PATH_RESOLVING)
@@ -1405,10 +1406,8 @@ static void mpath_set_pinfo(struct mesh_path *mpath, u8 *next_hop,
 		pinfo->flags |= NL80211_MPATH_FLAG_SN_VALID;
 	if (mpath->flags & MESH_PATH_FIXED)
 		pinfo->flags |= NL80211_MPATH_FLAG_FIXED;
-	if (mpath->flags & MESH_PATH_RESOLVING)
-		pinfo->flags |= NL80211_MPATH_FLAG_RESOLVING;
-
-	pinfo->flags = mpath->flags;
+	if (mpath->flags & MESH_PATH_RESOLVED)
+		pinfo->flags |= NL80211_MPATH_FLAG_RESOLVED;
 }
 
 static int ieee80211_get_mpath(struct wiphy *wiphy, struct net_device *dev,
-- 
1.7.4.1


