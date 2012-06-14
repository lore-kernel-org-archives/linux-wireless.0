Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gg0-f174.google.com ([209.85.161.174]:64823 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756077Ab2FNQZF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Jun 2012 12:25:05 -0400
Received: by gglu4 with SMTP id u4so1534378ggl.19
        for <linux-wireless@vger.kernel.org>; Thu, 14 Jun 2012 09:25:04 -0700 (PDT)
From: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, linville@tuxdriver.com,
	devel@lists.open80211s.org, Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
Subject: [PATCH] mac80211: fix the assignment of mesh element TTL
Date: Fri, 15 Jun 2012 00:23:53 +0800
Message-Id: <1339691033-13316-1-git-send-email-yeohchunyeow@gmail.com> (sfid-20120614_182509_669934_DD26F585)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes the wrong assignment of mesh element TTL.

Signed-off-by: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
---
 net/mac80211/cfg.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 85ac364..43eb8d9 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1529,7 +1529,7 @@ static int ieee80211_update_mesh_config(struct wiphy *wiphy,
 	if (_chg_mesh_attr(NL80211_MESHCONF_TTL, mask))
 		conf->dot11MeshTTL = nconf->dot11MeshTTL;
 	if (_chg_mesh_attr(NL80211_MESHCONF_ELEMENT_TTL, mask))
-		conf->dot11MeshTTL = nconf->element_ttl;
+		conf->element_ttl = nconf->element_ttl;
 	if (_chg_mesh_attr(NL80211_MESHCONF_AUTO_OPEN_PLINKS, mask))
 		conf->auto_open_plinks = nconf->auto_open_plinks;
 	if (_chg_mesh_attr(NL80211_MESHCONF_SYNC_OFFSET_MAX_NEIGHBOR, mask))
-- 
1.7.0.4

