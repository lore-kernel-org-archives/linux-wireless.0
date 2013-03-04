Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f53.google.com ([209.85.160.53]:39359 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932328Ab3CDVH4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Mar 2013 16:07:56 -0500
Received: by mail-pb0-f53.google.com with SMTP id un1so3422470pbc.12
        for <linux-wireless@vger.kernel.org>; Mon, 04 Mar 2013 13:07:55 -0800 (PST)
From: Thomas Pedersen <thomas@cozybit.com>
To: johannes@sipsolution.net
Cc: linux-wireless@vger.kernel.org,
	Thomas Pedersen <thomas@cozybit.com>
Subject: [PATCH v2 2/5] cfg80211: rename mesh station types
Date: Mon,  4 Mar 2013 13:06:11 -0800
Message-Id: <1362431174-4747-2-git-send-email-thomas@cozybit.com> (sfid-20130304_220801_241820_3D66856C)
In-Reply-To: <1362431174-4747-1-git-send-email-thomas@cozybit.com>
References: <1362431174-4747-1-git-send-email-thomas@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The mesh station types used to refer to whether the
station was secure or nonsecure. Really the salient
information is whether it is managed by the kernel or
userspace

Signed-off-by: Thomas Pedersen <thomas@cozybit.com>
---
 include/net/cfg80211.h |    8 ++++----
 net/mac80211/cfg.c     |    4 ++--
 net/wireless/nl80211.c |    8 ++++----
 3 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index b6be55e..6a61237 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -690,8 +690,8 @@ struct station_parameters {
  *	supported/used)
  * @CFG80211_STA_TDLS_PEER_ACTIVE: TDLS peer on managed interface (active
  *	entry that is operating, has been marked authorized by userspace)
- * @CFG80211_STA_MESH_PEER_NONSEC: peer on mesh interface (non-secured)
- * @CFG80211_STA_MESH_PEER_SECURE: peer on mesh interface (secured)
+ * @CFG80211_STA_MESH_PEER_KERNEL: peer on mesh interface (kernel managed)
+ * @CFG80211_STA_MESH_PEER_USER: peer on mesh interface (user managed)
  */
 enum cfg80211_station_type {
 	CFG80211_STA_AP_CLIENT,
@@ -700,8 +700,8 @@ enum cfg80211_station_type {
 	CFG80211_STA_IBSS,
 	CFG80211_STA_TDLS_PEER_SETUP,
 	CFG80211_STA_TDLS_PEER_ACTIVE,
-	CFG80211_STA_MESH_PEER_NONSEC,
-	CFG80211_STA_MESH_PEER_SECURE,
+	CFG80211_STA_MESH_PEER_KERNEL,
+	CFG80211_STA_MESH_PEER_USER,
 };
 
 /**
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 8259a5b..b5f0a93 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1436,9 +1436,9 @@ static int ieee80211_change_station(struct wiphy *wiphy,
 	switch (sdata->vif.type) {
 	case NL80211_IFTYPE_MESH_POINT:
 		if (sdata->u.mesh.security & IEEE80211_MESH_SEC_SECURED)
-			statype = CFG80211_STA_MESH_PEER_SECURE;
+			statype = CFG80211_STA_MESH_PEER_USER;
 		else
-			statype = CFG80211_STA_MESH_PEER_NONSEC;
+			statype = CFG80211_STA_MESH_PEER_KERNEL;
 		break;
 	case NL80211_IFTYPE_ADHOC:
 		statype = CFG80211_STA_IBSS;
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 167fd83..eca897a 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -3595,8 +3595,8 @@ int cfg80211_check_station_change(struct wiphy *wiphy,
 	BUILD_BUG_ON(NL80211_STA_FLAG_MAX != 7);
 
 	switch (statype) {
-	case CFG80211_STA_MESH_PEER_NONSEC:
-	case CFG80211_STA_MESH_PEER_SECURE:
+	case CFG80211_STA_MESH_PEER_KERNEL:
+	case CFG80211_STA_MESH_PEER_USER:
 		/*
 		 * No ignoring the TDLS flag here -- the userspace mesh
 		 * code doesn't have the bug of including TDLS in the
@@ -3698,11 +3698,11 @@ int cfg80211_check_station_change(struct wiphy *wiphy,
 	case CFG80211_STA_TDLS_PEER_ACTIVE:
 		/* reject any changes */
 		return -EINVAL;
-	case CFG80211_STA_MESH_PEER_NONSEC:
+	case CFG80211_STA_MESH_PEER_KERNEL:
 		if (params->sta_modify_mask & STATION_PARAM_APPLY_PLINK_STATE)
 			return -EINVAL;
 		break;
-	case CFG80211_STA_MESH_PEER_SECURE:
+	case CFG80211_STA_MESH_PEER_USER:
 		if (params->plink_action != NL80211_PLINK_ACTION_NO_ACTION)
 			return -EINVAL;
 		break;
-- 
1.7.10.4

