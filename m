Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f228.google.com ([209.85.219.228]:47150 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754134AbZKIXrA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Nov 2009 18:47:00 -0500
Received: by mail-ew0-f228.google.com with SMTP id 28so3974559ewy.18
        for <linux-wireless@vger.kernel.org>; Mon, 09 Nov 2009 15:47:05 -0800 (PST)
From: Rui Paulo <rpaulo@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>,
	Rui Paulo <rpaulo@gmail.com>,
	Javier Cardona <javier@cozybit.com>
Subject: [PATCH v2 01/20] mac80211: update meshconf IE
Date: Mon,  9 Nov 2009 23:46:39 +0000
Message-Id: <1257810418-30075-2-git-send-email-rpaulo@gmail.com>
In-Reply-To: <1257810418-30075-1-git-send-email-rpaulo@gmail.com>
References: <1257810418-30075-1-git-send-email-rpaulo@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This updates the Mesh Configuration IE according to the latest
draft (3.03).
Notable changes include the simplified protocol IDs.

Signed-off-by: Rui Paulo <rpaulo@gmail.com>
Signed-off-by: Javier Cardona <javier@cozybit.com>
Reviewed-by: Andrey Yurovsky <andrey@cozybit.com>
Tested-by: Brian Cavagnolo <brian@cozybit.com>
---
 include/linux/ieee80211.h  |    2 +-
 net/mac80211/ieee80211_i.h |   10 +++---
 net/mac80211/mesh.c        |   69 ++++++++++++++++++-------------------------
 3 files changed, 35 insertions(+), 46 deletions(-)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index 0aa8314..50c684d 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -115,7 +115,7 @@
 #define IEEE80211_MAX_SSID_LEN		32
 
 #define IEEE80211_MAX_MESH_ID_LEN	32
-#define IEEE80211_MESH_CONFIG_LEN	24
+#define IEEE80211_MESH_CONFIG_LEN	7
 
 #define IEEE80211_QOS_CTL_LEN		2
 #define IEEE80211_QOS_CTL_TID_MASK	0x000F
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 1ef7673..1f4f88a 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -361,15 +361,15 @@ struct ieee80211_if_mesh {
 	u8 mesh_id[IEEE80211_MAX_MESH_ID_LEN];
 	size_t mesh_id_len;
 	/* Active Path Selection Protocol Identifier */
-	u8 mesh_pp_id[4];
+	u8 mesh_pp_id;
 	/* Active Path Selection Metric Identifier */
-	u8 mesh_pm_id[4];
+	u8 mesh_pm_id;
 	/* Congestion Control Mode Identifier */
-	u8 mesh_cc_id[4];
+	u8 mesh_cc_id;
 	/* Synchronization Protocol Identifier */
-	u8 mesh_sp_id[4];
+	u8 mesh_sp_id;
 	/* Authentication Protocol Identifier */
-	u8 mesh_auth_id[4];
+	u8 mesh_auth_id;
 	/* Local mesh Destination Sequence Number */
 	u32 dsn;
 	/* Last used PREQ ID */
diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index 9a73389..a49a337 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -15,14 +15,14 @@
 #define IEEE80211_MESH_PEER_INACTIVITY_LIMIT (1800 * HZ)
 #define IEEE80211_MESH_HOUSEKEEPING_INTERVAL (60 * HZ)
 
-#define PP_OFFSET 	1		/* Path Selection Protocol */
-#define PM_OFFSET	5		/* Path Selection Metric   */
-#define CC_OFFSET	9		/* Congestion Control Mode */
-#define SP_OFFSET	13		/* Synchronization Protocol */
-#define AUTH_OFFSET	17		/* Authentication Protocol */
-#define CAPAB_OFFSET 	22
-#define CAPAB_ACCEPT_PLINKS 0x80
-#define CAPAB_FORWARDING    0x10
+#define MESHCONF_PP_OFFSET 	0		/* Path Selection Protocol */
+#define MESHCONF_PM_OFFSET	1		/* Path Selection Metric   */
+#define MESHCONF_CC_OFFSET	2		/* Congestion Control Mode */
+#define MESHCONF_SP_OFFSET	3		/* Synchronization Protocol */
+#define MESHCONF_AUTH_OFFSET	4		/* Authentication Protocol */
+#define MESHCONF_CAPAB_OFFSET 	6
+#define MESHCONF_CAPAB_ACCEPT_PLINKS 0x01
+#define MESHCONF_CAPAB_FORWARDING    0x08
 
 #define TMR_RUNNING_HK	0
 #define TMR_RUNNING_MP	1
@@ -85,11 +85,12 @@ bool mesh_matches_local(struct ieee802_11_elems *ie, struct ieee80211_sub_if_dat
 	 */
 	if (ifmsh->mesh_id_len == ie->mesh_id_len &&
 		memcmp(ifmsh->mesh_id, ie->mesh_id, ie->mesh_id_len) == 0 &&
-		memcmp(ifmsh->mesh_pp_id, ie->mesh_config + PP_OFFSET, 4) == 0 &&
-		memcmp(ifmsh->mesh_pm_id, ie->mesh_config + PM_OFFSET, 4) == 0 &&
-		memcmp(ifmsh->mesh_cc_id, ie->mesh_config + CC_OFFSET, 4) == 0 &&
-		memcmp(ifmsh->mesh_sp_id, ie->mesh_config + SP_OFFSET, 4) == 0 &&
-		memcmp(ifmsh->mesh_auth_id, ie->mesh_config + AUTH_OFFSET, 4) == 0)
+		(ifmsh->mesh_pp_id == *(ie->mesh_config + MESHCONF_PP_OFFSET))&&
+		(ifmsh->mesh_pm_id == *(ie->mesh_config + MESHCONF_PM_OFFSET))&&
+		(ifmsh->mesh_cc_id == *(ie->mesh_config + MESHCONF_CC_OFFSET))&&
+		(ifmsh->mesh_sp_id == *(ie->mesh_config + MESHCONF_SP_OFFSET))&&
+		(ifmsh->mesh_auth_id == *(ie->mesh_config +
+		    MESHCONF_AUTH_OFFSET)))
 		return true;
 
 	return false;
@@ -102,7 +103,8 @@ bool mesh_matches_local(struct ieee802_11_elems *ie, struct ieee80211_sub_if_dat
  */
 bool mesh_peer_accepts_plinks(struct ieee802_11_elems *ie)
 {
-	return (*(ie->mesh_config + CAPAB_OFFSET) & CAPAB_ACCEPT_PLINKS) != 0;
+	return (*(ie->mesh_config + MESHCONF_CAPAB_OFFSET) &
+	    MESHCONF_CAPAB_ACCEPT_PLINKS) != 0;
 }
 
 /**
@@ -128,18 +130,11 @@ void mesh_accept_plinks_update(struct ieee80211_sub_if_data *sdata)
 
 void mesh_ids_set_default(struct ieee80211_if_mesh *sta)
 {
-	u8 oui[3] = {0x00, 0x0F, 0xAC};
-
-	memcpy(sta->mesh_pp_id, oui, sizeof(oui));
-	memcpy(sta->mesh_pm_id, oui, sizeof(oui));
-	memcpy(sta->mesh_cc_id, oui, sizeof(oui));
-	memcpy(sta->mesh_sp_id, oui, sizeof(oui));
-	memcpy(sta->mesh_auth_id, oui, sizeof(oui));
-	sta->mesh_pp_id[sizeof(oui)] = 0;
-	sta->mesh_pm_id[sizeof(oui)] = 0;
-	sta->mesh_cc_id[sizeof(oui)] = 0xff;
-	sta->mesh_sp_id[sizeof(oui)] = 0xff;
-	sta->mesh_auth_id[sizeof(oui)] = 0x0;
+	sta->mesh_pp_id = 0;	/* HWMP */
+	sta->mesh_pm_id = 0;	/* Airtime */
+	sta->mesh_cc_id = 0;	/* Disabled */
+	sta->mesh_sp_id = 0;	/* Neighbor Offset */
+	sta->mesh_auth_id = 0;	/* Disabled */
 }
 
 int mesh_rmc_init(struct ieee80211_sub_if_data *sdata)
@@ -260,28 +255,21 @@ void mesh_mgmt_ies_add(struct sk_buff *skb, struct ieee80211_sub_if_data *sdata)
 	pos = skb_put(skb, 2 + IEEE80211_MESH_CONFIG_LEN);
 	*pos++ = WLAN_EID_MESH_CONFIG;
 	*pos++ = IEEE80211_MESH_CONFIG_LEN;
-	/* Version */
-	*pos++ = 1;
 
 	/* Active path selection protocol ID */
-	memcpy(pos, sdata->u.mesh.mesh_pp_id, 4);
-	pos += 4;
+	*pos++ = sdata->u.mesh.mesh_pp_id;
 
 	/* Active path selection metric ID   */
-	memcpy(pos, sdata->u.mesh.mesh_pm_id, 4);
-	pos += 4;
+	*pos++ = sdata->u.mesh.mesh_pm_id;
 
 	/* Congestion control mode identifier */
-	memcpy(pos, sdata->u.mesh.mesh_cc_id, 4);
-	pos += 4;
+	*pos++ = sdata->u.mesh.mesh_cc_id;
 
 	/* Synchronization protocol identifier */
-	memcpy(pos, sdata->u.mesh.mesh_sp_id, 4);
-	pos += 4;
+	*pos++ = sdata->u.mesh.mesh_sp_id;
 
 	/* Authentication Protocol identifier */
-	memcpy(pos, sdata->u.mesh.mesh_auth_id, 4);
-	pos += 4;
+	*pos++ = sdata->u.mesh.mesh_auth_id;
 
 	/* Mesh Formation Info */
 	memset(pos, 0x00, 1);
@@ -289,8 +277,9 @@ void mesh_mgmt_ies_add(struct sk_buff *skb, struct ieee80211_sub_if_data *sdata)
 
 	/* Mesh capability */
 	sdata->u.mesh.accepting_plinks = mesh_plink_availables(sdata);
-	*pos = CAPAB_FORWARDING;
-	*pos++ |= sdata->u.mesh.accepting_plinks ? CAPAB_ACCEPT_PLINKS : 0x00;
+	*pos = MESHCONF_CAPAB_FORWARDING;
+	*pos++ |= sdata->u.mesh.accepting_plinks ?
+	    MESHCONF_CAPAB_ACCEPT_PLINKS : 0x00;
 	*pos++ = 0x00;
 
 	return;
-- 
1.5.6.5

