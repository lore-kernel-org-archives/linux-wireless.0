Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:40036 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751979AbaAVJQ4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jan 2014 04:16:56 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:256)
	(Exim 4.82)
	(envelope-from <johannes@sipsolutions.net>)
	id 1W5tvb-0001Ue-9m
	for linux-wireless@vger.kernel.org; Wed, 22 Jan 2014 10:16:55 +0100
Message-ID: <1390382213.4334.20.camel@jlt4.sipsolutions.net> (sfid-20140122_101706_204583_550A83DC)
Subject: [PATCH] mac80211: mesh: remove mesh_id check
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless <linux-wireless@vger.kernel.org>
Date: Wed, 22 Jan 2014 10:16:53 +0100
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The mesh_id is an array so can't ever be NULL, it looks
like mesh_id_len check was intended instead. However,
since the previous patch, cfg80211 does the check, so
just remove it here.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/cfg.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index e948b38..cf961a5 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -3196,9 +3196,6 @@ int ieee80211_channel_switch(struct wiphy *wiphy, struct net_device *dev,
 	case NL80211_IFTYPE_MESH_POINT:
 		ifmsh = &sdata->u.mesh;
 
-		if (!ifmsh->mesh_id)
-			return -EINVAL;
-
 		if (params->chandef.width != sdata->vif.bss_conf.chandef.width)
 			return -EINVAL;
 
-- 
1.8.5.1



