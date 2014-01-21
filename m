Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:37707 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751014AbaAUUFG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Jan 2014 15:05:06 -0500
Message-ID: <1390334699.6199.67.camel@jlt4.sipsolutions.net> (sfid-20140121_210510_568767_3B74E274)
Subject: [PATCH] mac80211: mesh: fix mesh_id check
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: Chun-Yeow Yeoh <yeohchunyeow@cozybit.com>
Date: Tue, 21 Jan 2014 21:04:59 +0100
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The mesh_id is an array so can't ever be NULL, it looks
like mesh_id_len check was intended instead.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/cfg.c  | 2 +-
 net/mac80211/mesh.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index db17c9c..cd14bef 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -3108,7 +3108,7 @@ static int ieee80211_channel_switch(struct wiphy *wiphy, struct net_device *dev,
 	case NL80211_IFTYPE_MESH_POINT:
 		ifmsh = &sdata->u.mesh;
 
-		if (!ifmsh->mesh_id)
+		if (!ifmsh->mesh_id_len)
 			return -EINVAL;
 
 		if (params->chandef.width != sdata->vif.bss_conf.chandef.width)
diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index ba10525..59f6243 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -866,7 +866,7 @@ ieee80211_mesh_process_chnswitch(struct ieee80211_sub_if_data *sdata,
 	if (sdata->vif.csa_active)
 		return true;
 
-	if (!ifmsh->mesh_id)
+	if (!ifmsh->mesh_id_len)
 		return false;
 
 	sta_flags = IEEE80211_STA_DISABLE_VHT;
-- 
1.8.5.1


