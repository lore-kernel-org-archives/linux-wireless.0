Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:55773 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752765Ab3B1WSl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Feb 2013 17:18:41 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: remove IEEE80211_KEY_FLAG_WMM_STA
Date: Thu, 28 Feb 2013 23:18:35 +0100
Message-Id: <1362089915-12075-1-git-send-email-johannes@sipsolutions.net> (sfid-20130228_231848_325408_1F97A262)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

There's no driver using this flag, so it seems
that all drivers support HW crypto with WMM or
don't support it at all. Remove the flag and
code setting it.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/mac80211.h |  3 ---
 net/mac80211/key.c     | 26 --------------------------
 2 files changed, 29 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 1568cc6..ac0272f 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1103,8 +1103,6 @@ static inline bool ieee80211_vif_is_mesh(struct ieee80211_vif *vif)
  * These flags are used for communication about keys between the driver
  * and mac80211, with the @flags parameter of &struct ieee80211_key_conf.
  *
- * @IEEE80211_KEY_FLAG_WMM_STA: Set by mac80211, this flag indicates
- *	that the STA this key will be used with could be using QoS.
  * @IEEE80211_KEY_FLAG_GENERATE_IV: This flag should be set by the
  *	driver to indicate that it requires IV generation for this
  *	particular key.
@@ -1129,7 +1127,6 @@ static inline bool ieee80211_vif_is_mesh(struct ieee80211_vif *vif)
  *	%IEEE80211_KEY_FLAG_SW_MGMT_TX flag to encrypt such frames in SW.
  */
 enum ieee80211_key_flags {
-	IEEE80211_KEY_FLAG_WMM_STA	= 1<<0,
 	IEEE80211_KEY_FLAG_GENERATE_IV	= 1<<1,
 	IEEE80211_KEY_FLAG_GENERATE_MMIC= 1<<2,
 	IEEE80211_KEY_FLAG_PAIRWISE	= 1<<3,
diff --git a/net/mac80211/key.c b/net/mac80211/key.c
index ef252eb..c4bc3bd 100644
--- a/net/mac80211/key.c
+++ b/net/mac80211/key.c
@@ -440,32 +440,6 @@ int ieee80211_key_link(struct ieee80211_key *key,
 	key->sdata = sdata;
 	key->sta = sta;
 
-	if (sta) {
-		/*
-		 * some hardware cannot handle TKIP with QoS, so
-		 * we indicate whether QoS could be in use.
-		 */
-		if (test_sta_flag(sta, WLAN_STA_WME))
-			key->conf.flags |= IEEE80211_KEY_FLAG_WMM_STA;
-	} else {
-		if (sdata->vif.type == NL80211_IFTYPE_STATION) {
-			struct sta_info *ap;
-
-			/*
-			 * We're getting a sta pointer in, so must be under
-			 * appropriate locking for sta_info_get().
-			 */
-
-			/* same here, the AP could be using QoS */
-			ap = sta_info_get(key->sdata, key->sdata->u.mgd.bssid);
-			if (ap) {
-				if (test_sta_flag(ap, WLAN_STA_WME))
-					key->conf.flags |=
-						IEEE80211_KEY_FLAG_WMM_STA;
-			}
-		}
-	}
-
 	mutex_lock(&sdata->local->key_mtx);
 
 	if (sta && pairwise)
-- 
1.8.0

