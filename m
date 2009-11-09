Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f228.google.com ([209.85.219.228]:47150 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755534AbZKIXrN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Nov 2009 18:47:13 -0500
Received: by mail-ew0-f228.google.com with SMTP id 28so3974559ewy.18
        for <linux-wireless@vger.kernel.org>; Mon, 09 Nov 2009 15:47:18 -0800 (PST)
From: Rui Paulo <rpaulo@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>,
	Rui Paulo <rpaulo@gmail.com>,
	Javier Cardona <javier@cozybit.com>
Subject: [PATCH v2 06/20] mac80211: update the format of path selection frames
Date: Mon,  9 Nov 2009 23:46:44 +0000
Message-Id: <1257810418-30075-7-git-send-email-rpaulo@gmail.com>
In-Reply-To: <1257810418-30075-1-git-send-email-rpaulo@gmail.com>
References: <1257810418-30075-1-git-send-email-rpaulo@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Update the format of path selection frames according to latest
draft (3.03).

Signed-off-by: Rui Paulo <rpaulo@gmail.com>
Signed-off-by: Javier Cardona <javier@cozybit.com>
Reviewed-by: Andrey Yurovsky <andrey@cozybit.com>
Tested-by: Brian Cavagnolo <brian@cozybit.com>
---
 net/mac80211/mesh.h      |    1 +
 net/mac80211/mesh_hwmp.c |    2 +-
 2 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/mesh.h b/net/mac80211/mesh.h
index 536d5c0..2fd3e20 100644
--- a/net/mac80211/mesh.h
+++ b/net/mac80211/mesh.h
@@ -208,6 +208,7 @@ struct mesh_rmc {
 /* Pending ANA approval */
 #define MESH_PLINK_CATEGORY	30
 #define MESH_PATH_SEL_CATEGORY	32
+#define MESH_PATH_SEL_ACTION	0
 
 /* Public interfaces */
 /* Various */
diff --git a/net/mac80211/mesh_hwmp.c b/net/mac80211/mesh_hwmp.c
index 29b82e9..c291cdb 100644
--- a/net/mac80211/mesh_hwmp.c
+++ b/net/mac80211/mesh_hwmp.c
@@ -105,7 +105,7 @@ static int mesh_path_sel_frame_tx(enum mpath_frame_type action, u8 flags,
 	memcpy(mgmt->sa, sdata->dev->dev_addr, ETH_ALEN);
 	/* BSSID is left zeroed, wildcard value */
 	mgmt->u.action.category = MESH_PATH_SEL_CATEGORY;
-	mgmt->u.action.u.mesh_action.action_code = action;
+	mgmt->u.action.u.mesh_action.action_code = MESH_PATH_SEL_ACTION;
 
 	switch (action) {
 	case MPATH_PREQ:
-- 
1.5.6.5

