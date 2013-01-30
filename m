Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:49388 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750737Ab3A3Hyp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Jan 2013 02:54:45 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] cfg80211: remove unused cfg80211_get_mesh
Date: Wed, 30 Jan 2013 08:55:05 +0100
Message-Id: <1359532505-25658-1-git-send-email-johannes@sipsolutions.net> (sfid-20130130_085448_265760_6247680B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

As Thomas pointed out, cfg80211_get_mesh() is
unused and can be removed.

Cc: Thomas Pedersen <thomas@cozybit.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/cfg80211.h |  4 ----
 net/wireless/scan.c    | 65 --------------------------------------------------
 2 files changed, 69 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 5eb20bc..7533f0d 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -3172,10 +3172,6 @@ cfg80211_get_ibss(struct wiphy *wiphy,
 				WLAN_CAPABILITY_IBSS, WLAN_CAPABILITY_IBSS);
 }
 
-struct cfg80211_bss *cfg80211_get_mesh(struct wiphy *wiphy,
-				       struct ieee80211_channel *channel,
-				       const u8 *meshid, size_t meshidlen,
-				       const u8 *meshcfg);
 /**
  * cfg80211_ref_bss - reference BSS struct
  * @bss: the BSS struct to reference
diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index 46351ba..d220313 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -311,43 +311,6 @@ static bool is_bss(struct cfg80211_bss *a, const u8 *bssid,
 	return memcmp(ssidie + 2, ssid, ssid_len) == 0;
 }
 
-static bool is_mesh(struct cfg80211_bss *a,
-		    const u8 *meshid, size_t meshidlen,
-		    const u8 *meshcfg)
-{
-	const struct cfg80211_bss_ies *ies;
-	const u8 *ie;
-
-	if (!WLAN_CAPABILITY_IS_STA_BSS(a->capability))
-		return false;
-
-	ies = rcu_access_pointer(a->ies);
-	if (!ies)
-		return false;
-
-	ie = cfg80211_find_ie(WLAN_EID_MESH_ID, ies->data, ies->len);
-	if (!ie)
-		return false;
-	if (ie[1] != meshidlen)
-		return false;
-	if (memcmp(ie + 2, meshid, meshidlen))
-		return false;
-
-	ie = cfg80211_find_ie(WLAN_EID_MESH_CONFIG, ies->data, ies->len);
-	if (!ie)
-		return false;
-	if (ie[1] != sizeof(struct ieee80211_meshconf_ie))
-		return false;
-
-	/*
-	 * Ignore mesh capability (last two bytes of the IE) when
-	 * comparing since that may differ between stations taking
-	 * part in the same mesh.
-	 */
-	return memcmp(ie + 2, meshcfg,
-		      sizeof(struct ieee80211_meshconf_ie) - 2) == 0;
-}
-
 static int cmp_bss(struct cfg80211_bss *a,
 		   struct cfg80211_bss *b,
 		   bool hide_ssid)
@@ -482,34 +445,6 @@ struct cfg80211_bss *cfg80211_get_bss(struct wiphy *wiphy,
 }
 EXPORT_SYMBOL(cfg80211_get_bss);
 
-struct cfg80211_bss *cfg80211_get_mesh(struct wiphy *wiphy,
-				       struct ieee80211_channel *channel,
-				       const u8 *meshid, size_t meshidlen,
-				       const u8 *meshcfg)
-{
-	struct cfg80211_registered_device *dev = wiphy_to_dev(wiphy);
-	struct cfg80211_internal_bss *bss, *res = NULL;
-
-	spin_lock_bh(&dev->bss_lock);
-
-	list_for_each_entry(bss, &dev->bss_list, list) {
-		if (channel && bss->pub.channel != channel)
-			continue;
-		if (is_mesh(&bss->pub, meshid, meshidlen, meshcfg)) {
-			res = bss;
-			kref_get(&res->ref);
-			break;
-		}
-	}
-
-	spin_unlock_bh(&dev->bss_lock);
-	if (!res)
-		return NULL;
-	return &res->pub;
-}
-EXPORT_SYMBOL(cfg80211_get_mesh);
-
-
 static void rb_insert_bss(struct cfg80211_registered_device *dev,
 			  struct cfg80211_internal_bss *bss)
 {
-- 
1.8.0

