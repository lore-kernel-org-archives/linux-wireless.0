Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f49.google.com ([209.85.160.49]:60530 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751422Ab3CBGEK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Mar 2013 01:04:10 -0500
Received: by mail-pb0-f49.google.com with SMTP id xa12so2131545pbc.22
        for <linux-wireless@vger.kernel.org>; Fri, 01 Mar 2013 22:04:09 -0800 (PST)
From: Thomas Pedersen <thomas@cozybit.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, devel@lists.open80211s.org,
	Thomas Pedersen <thomas@cozybit.com>
Subject: [PATCH 2/6] cfg80211: rename mesh station types
Date: Fri,  1 Mar 2013 22:02:48 -0800
Message-Id: <1362204172-28307-2-git-send-email-thomas@cozybit.com> (sfid-20130302_070420_447421_A9BBCEAC)
In-Reply-To: <1362204172-28307-1-git-send-email-thomas@cozybit.com>
References: <1362204172-28307-1-git-send-email-thomas@cozybit.com>
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
index 986556d..18e9dfe 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1433,9 +1433,9 @@ static int ieee80211_change_station(struct wiphy *wiphy,
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
index 67c96cd..e3f2489 100644
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

