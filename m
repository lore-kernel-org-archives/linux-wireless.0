Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.177]:42504 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753125AbZHTQdo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Aug 2009 12:33:44 -0400
Received: by wa-out-1112.google.com with SMTP id j5so3657wah.21
        for <linux-wireless@vger.kernel.org>; Thu, 20 Aug 2009 09:33:46 -0700 (PDT)
From: Javier Cardona <javier@cozybit.com>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: Javier Cardona <javier@cozybit.com>, andrey@cozybit.com,
	johannes@sipsolutions.net, linville@tuxdriver.com,
	devel@lists.open80211s.org
Subject: [PATCH] mac80211: Update mesh config IE to 11s draft 3.02
Date: Thu, 20 Aug 2009 09:21:45 -0700
Message-Id: <1250785305-24118-1-git-send-email-javier@cozybit.com>
In-Reply-To: <>
References: <>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The mesh config information element has changed significantly since draft 1.08
This patch brings it up to date.

Thanks to Sam Leffler and Rui Paulo for identifying this.

Signed-off-by: Javier Cardona <javier@cozybit.com>
---
 include/linux/ieee80211.h  |    2 +-
 net/mac80211/ieee80211_i.h |    4 +++
 net/mac80211/mesh.c        |   49 ++++++++++++++++++++++++++++++-------------
 3 files changed, 39 insertions(+), 16 deletions(-)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index 21556a2..52e15e0 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -115,7 +115,7 @@
 #define IEEE80211_MAX_SSID_LEN		32
 
 #define IEEE80211_MAX_MESH_ID_LEN	32
-#define IEEE80211_MESH_CONFIG_LEN	19
+#define IEEE80211_MESH_CONFIG_LEN	24
 
 #define IEEE80211_QOS_CTL_LEN		2
 #define IEEE80211_QOS_CTL_TID_MASK	0x000F
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 93e618a..455cc7a 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -367,6 +367,10 @@ struct ieee80211_if_mesh {
 	u8 mesh_pm_id[4];
 	/* Congestion Control Mode Identifier */
 	u8 mesh_cc_id[4];
+	/* Synchronization Protocol Identifier */
+	u8 mesh_sp_id[4];
+	/* Authentication Protocol Identifier */
+	u8 mesh_auth_id[4];
 	/* Local mesh Destination Sequence Number */
 	u32 dsn;
 	/* Last used PREQ ID */
diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index 3185e18..f7364e5 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -18,8 +18,11 @@
 #define PP_OFFSET 	1		/* Path Selection Protocol */
 #define PM_OFFSET	5		/* Path Selection Metric   */
 #define CC_OFFSET	9		/* Congestion Control Mode */
-#define CAPAB_OFFSET 17
-#define ACCEPT_PLINKS 0x80
+#define SP_OFFSET	13		/* Synchronization Protocol */
+#define AUTH_OFFSET	17		/* Authentication Protocol */
+#define CAPAB_OFFSET 	22
+#define CAPAB_ACCEPT_PLINKS 0x80
+#define CAPAB_FORWARDING    0x10
 
 #define TMR_RUNNING_HK	0
 #define TMR_RUNNING_MP	1
@@ -84,7 +87,9 @@ bool mesh_matches_local(struct ieee802_11_elems *ie, struct ieee80211_sub_if_dat
 		memcmp(ifmsh->mesh_id, ie->mesh_id, ie->mesh_id_len) == 0 &&
 		memcmp(ifmsh->mesh_pp_id, ie->mesh_config + PP_OFFSET, 4) == 0 &&
 		memcmp(ifmsh->mesh_pm_id, ie->mesh_config + PM_OFFSET, 4) == 0 &&
-		memcmp(ifmsh->mesh_cc_id, ie->mesh_config + CC_OFFSET, 4) == 0)
+		memcmp(ifmsh->mesh_cc_id, ie->mesh_config + CC_OFFSET, 4) == 0 &&
+		memcmp(ifmsh->mesh_sp_id, ie->mesh_config + SP_OFFSET, 4) == 0 &&
+		memcmp(ifmsh->mesh_auth_id, ie->mesh_config + AUTH_OFFSET, 4) == 0)
 		return true;
 
 	return false;
@@ -97,7 +102,7 @@ bool mesh_matches_local(struct ieee802_11_elems *ie, struct ieee80211_sub_if_dat
  */
 bool mesh_peer_accepts_plinks(struct ieee802_11_elems *ie)
 {
-	return (*(ie->mesh_config + CAPAB_OFFSET) & ACCEPT_PLINKS) != 0;
+	return (*(ie->mesh_config + CAPAB_OFFSET) & CAPAB_ACCEPT_PLINKS) != 0;
 }
 
 /**
@@ -123,11 +128,18 @@ void mesh_accept_plinks_update(struct ieee80211_sub_if_data *sdata)
 
 void mesh_ids_set_default(struct ieee80211_if_mesh *sta)
 {
-	u8 def_id[4] = {0x00, 0x0F, 0xAC, 0xff};
-
-	memcpy(sta->mesh_pp_id, def_id, 4);
-	memcpy(sta->mesh_pm_id, def_id, 4);
-	memcpy(sta->mesh_cc_id, def_id, 4);
+	u8 oui[3] = {0x00, 0x0F, 0xAC};
+
+	memcpy(sta->mesh_pp_id, oui, sizeof(oui));
+	memcpy(sta->mesh_pm_id, oui, sizeof(oui));
+	memcpy(sta->mesh_cc_id, oui, sizeof(oui));
+	memcpy(sta->mesh_sp_id, oui, sizeof(oui));
+	memcpy(sta->mesh_auth_id, oui, sizeof(oui));
+	sta->mesh_pp_id[sizeof(oui)] = 0;
+	sta->mesh_pm_id[sizeof(oui)] = 0;
+	sta->mesh_cc_id[sizeof(oui)] = 0xff;
+	sta->mesh_sp_id[sizeof(oui)] = 0xff;
+	sta->mesh_auth_id[sizeof(oui)] = 0x0;
 }
 
 int mesh_rmc_init(struct ieee80211_sub_if_data *sdata)
@@ -245,7 +257,7 @@ void mesh_mgmt_ies_add(struct sk_buff *skb, struct ieee80211_sub_if_data *sdata)
 	if (sdata->u.mesh.mesh_id_len)
 		memcpy(pos, sdata->u.mesh.mesh_id, sdata->u.mesh.mesh_id_len);
 
-	pos = skb_put(skb, 21);
+	pos = skb_put(skb, 2 + IEEE80211_MESH_CONFIG_LEN);
 	*pos++ = WLAN_EID_MESH_CONFIG;
 	*pos++ = IEEE80211_MESH_CONFIG_LEN;
 	/* Version */
@@ -263,15 +275,22 @@ void mesh_mgmt_ies_add(struct sk_buff *skb, struct ieee80211_sub_if_data *sdata)
 	memcpy(pos, sdata->u.mesh.mesh_cc_id, 4);
 	pos += 4;
 
-	/* Channel precedence:
-	 * Not running simple channel unification protocol
-	 */
-	memset(pos, 0x00, 4);
+	/* Synchronization protocol identifier */
+	memcpy(pos, sdata->u.mesh.mesh_sp_id, 4);
 	pos += 4;
 
+	/* Authentication Protocol identifier */
+	memcpy(pos, sdata->u.mesh.mesh_auth_id, 4);
+	pos += 4;
+
+	/* Mesh Formation Info */
+	memset(pos, 0x00, 1);
+	pos += 1;
+
 	/* Mesh capability */
 	sdata->u.mesh.accepting_plinks = mesh_plink_availables(sdata);
-	*pos++ = sdata->u.mesh.accepting_plinks ? ACCEPT_PLINKS : 0x00;
+	*pos = CAPAB_FORWARDING;
+	*pos++ |= sdata->u.mesh.accepting_plinks ? CAPAB_ACCEPT_PLINKS : 0x00;
 	*pos++ = 0x00;
 
 	return;
-- 
1.5.4.3

