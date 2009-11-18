Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.25]:20184 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932263AbZKRSW6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Nov 2009 13:22:58 -0500
Received: by ey-out-2122.google.com with SMTP id 25so260330eya.19
        for <linux-wireless@vger.kernel.org>; Wed, 18 Nov 2009 10:23:03 -0800 (PST)
From: Rui Paulo <rpaulo@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>,
	Rui Paulo <rpaulo@gmail.com>
Subject: [PATCH] mac80211: use a structure to hold the mesh config information element
Date: Wed, 18 Nov 2009 18:22:58 +0000
Message-Id: <1258568579-21900-1-git-send-email-rpaulo@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Rui Paulo <rpaulo@gmail.com>
---
 include/linux/ieee80211.h  |   16 +++++++++++++++-
 net/mac80211/ieee80211_i.h |    3 +--
 net/mac80211/mesh.c        |   23 ++++++++---------------
 net/mac80211/util.c        |    1 -
 net/wireless/scan.c        |    9 +++++----
 5 files changed, 29 insertions(+), 23 deletions(-)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index 49b1abd..afa8e0a 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -115,7 +115,6 @@
 #define IEEE80211_MAX_SSID_LEN		32
 
 #define IEEE80211_MAX_MESH_ID_LEN	32
-#define IEEE80211_MESH_CONFIG_LEN	7
 
 #define IEEE80211_QOS_CTL_LEN		2
 #define IEEE80211_QOS_CTL_TID_MASK	0x000F
@@ -555,6 +554,21 @@ struct ieee80211_tim_ie {
 } __attribute__ ((packed));
 
 /**
+ * struct ieee80211_meshconf_ie
+ *
+ * This structure refers to "Mesh Configuration information element"
+ */
+struct ieee80211_meshconf_ie {
+	u8 meshconf_psel;
+	u8 meshconf_pmetric;
+	u8 meshconf_congest;
+	u8 meshconf_synch;
+	u8 meshconf_auth;
+	u8 meshconf_form;
+	u8 meshconf_cap;
+} __attribute__ ((packed));
+
+/**
  * struct ieee80211_rann_ie
  *
  * This structure refers to "Root Announcement information element"
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index a1bd4b2..0e0f76b 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -797,7 +797,7 @@ struct ieee802_11_elems {
 	u8 *wmm_param;
 	struct ieee80211_ht_cap *ht_cap_elem;
 	struct ieee80211_ht_info *ht_info_elem;
-	u8 *mesh_config;
+	struct ieee80211_meshconf_ie *mesh_config;
 	u8 *mesh_id;
 	u8 *peer_link;
 	u8 *preq;
@@ -825,7 +825,6 @@ struct ieee802_11_elems {
 	u8 ext_supp_rates_len;
 	u8 wmm_info_len;
 	u8 wmm_param_len;
-	u8 mesh_config_len;
 	u8 mesh_id_len;
 	u8 peer_link_len;
 	u8 preq_len;
diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index 3a0683b..51adb11 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -16,12 +16,6 @@
 #define IEEE80211_MESH_HOUSEKEEPING_INTERVAL (60 * HZ)
 #define IEEE80211_MESH_RANN_INTERVAL	     (1 * HZ)
 
-#define MESHCONF_PP_OFFSET 	0		/* Path Selection Protocol */
-#define MESHCONF_PM_OFFSET	1		/* Path Selection Metric   */
-#define MESHCONF_CC_OFFSET	2		/* Congestion Control Mode */
-#define MESHCONF_SP_OFFSET	3		/* Synchronization Protocol */
-#define MESHCONF_AUTH_OFFSET	4		/* Authentication Protocol */
-#define MESHCONF_CAPAB_OFFSET 	6
 #define MESHCONF_CAPAB_ACCEPT_PLINKS 0x01
 #define MESHCONF_CAPAB_FORWARDING    0x08
 
@@ -87,12 +81,11 @@ bool mesh_matches_local(struct ieee802_11_elems *ie, struct ieee80211_sub_if_dat
 	 */
 	if (ifmsh->mesh_id_len == ie->mesh_id_len &&
 		memcmp(ifmsh->mesh_id, ie->mesh_id, ie->mesh_id_len) == 0 &&
-		(ifmsh->mesh_pp_id == *(ie->mesh_config + MESHCONF_PP_OFFSET))&&
-		(ifmsh->mesh_pm_id == *(ie->mesh_config + MESHCONF_PM_OFFSET))&&
-		(ifmsh->mesh_cc_id == *(ie->mesh_config + MESHCONF_CC_OFFSET))&&
-		(ifmsh->mesh_sp_id == *(ie->mesh_config + MESHCONF_SP_OFFSET))&&
-		(ifmsh->mesh_auth_id == *(ie->mesh_config +
-		    MESHCONF_AUTH_OFFSET)))
+		(ifmsh->mesh_pp_id == ie->mesh_config->meshconf_psel) &&
+		(ifmsh->mesh_pm_id == ie->mesh_config->meshconf_pmetric) &&
+		(ifmsh->mesh_cc_id == ie->mesh_config->meshconf_congest) &&
+		(ifmsh->mesh_sp_id == ie->mesh_config->meshconf_synch) &&
+		(ifmsh->mesh_auth_id == ie->mesh_config->meshconf_auth))
 		return true;
 
 	return false;
@@ -105,7 +98,7 @@ bool mesh_matches_local(struct ieee802_11_elems *ie, struct ieee80211_sub_if_dat
  */
 bool mesh_peer_accepts_plinks(struct ieee802_11_elems *ie)
 {
-	return (*(ie->mesh_config + MESHCONF_CAPAB_OFFSET) &
+	return (ie->mesh_config->meshconf_cap &
 	    MESHCONF_CAPAB_ACCEPT_PLINKS) != 0;
 }
 
@@ -262,9 +255,9 @@ void mesh_mgmt_ies_add(struct sk_buff *skb, struct ieee80211_sub_if_data *sdata)
 	if (sdata->u.mesh.mesh_id_len)
 		memcpy(pos, sdata->u.mesh.mesh_id, sdata->u.mesh.mesh_id_len);
 
-	pos = skb_put(skb, 2 + IEEE80211_MESH_CONFIG_LEN);
+	pos = skb_put(skb, 2 + sizeof(struct ieee80211_meshconf_ie));
 	*pos++ = WLAN_EID_MESH_CONFIG;
-	*pos++ = IEEE80211_MESH_CONFIG_LEN;
+	*pos++ = sizeof(struct ieee80211_meshconf_ie);
 
 	/* Active path selection protocol ID */
 	*pos++ = sdata->u.mesh.mesh_pp_id;
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index da86e15..38f1c9b 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -667,7 +667,6 @@ u32 ieee802_11_parse_elems_crc(u8 *start, size_t len,
 			break;
 		case WLAN_EID_MESH_CONFIG:
 			elems->mesh_config = pos;
-			elems->mesh_config_len = elen;
 			break;
 		case WLAN_EID_PEER_LINK:
 			elems->peer_link = pos;
diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index e2d344f..d03447d 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -217,7 +217,7 @@ static bool is_mesh(struct cfg80211_bss *a,
 		     a->len_information_elements);
 	if (!ie)
 		return false;
-	if (ie[1] != IEEE80211_MESH_CONFIG_LEN)
+	if (ie[1] != sizeof(struct ieee80211_meshconf_ie))
 		return false;
 
 	/*
@@ -225,7 +225,8 @@ static bool is_mesh(struct cfg80211_bss *a,
 	 * comparing since that may differ between stations taking
 	 * part in the same mesh.
 	 */
-	return memcmp(ie + 2, meshcfg, IEEE80211_MESH_CONFIG_LEN - 2) == 0;
+	return memcmp(ie + 2, meshcfg,
+	    sizeof(struct ieee80211_meshconf_ie) - 2) == 0;
 }
 
 static int cmp_bss(struct cfg80211_bss *a,
@@ -399,7 +400,7 @@ cfg80211_bss_update(struct cfg80211_registered_device *dev,
 				  res->pub.information_elements,
 				  res->pub.len_information_elements);
 		if (!meshid || !meshcfg ||
-		    meshcfg[1] != IEEE80211_MESH_CONFIG_LEN) {
+		    meshcfg[1] != sizeof(struct ieee80211_meshconf_ie)) {
 			/* bogus mesh */
 			kref_put(&res->ref, bss_release);
 			return NULL;
@@ -865,7 +866,7 @@ ieee80211_bss(struct wiphy *wiphy, struct iw_request_info *info,
 			break;
 		case WLAN_EID_MESH_CONFIG:
 			ismesh = true;
-			if (ie[1] != IEEE80211_MESH_CONFIG_LEN)
+			if (ie[1] != sizeof(struct ieee80211_meshconf_ie))
 				break;
 			buf = kmalloc(50, GFP_ATOMIC);
 			if (!buf)
-- 
1.5.6.5

