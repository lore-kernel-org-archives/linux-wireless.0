Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:55024 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751849Ab3BGK7u (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Feb 2013 05:59:50 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: pass station to ieee80211_vht_cap_ie_to_sta_vht_cap
Date: Thu,  7 Feb 2013 12:00:13 +0100
Message-Id: <1360234813-24668-1-git-send-email-johannes@sipsolutions.net> (sfid-20130207_115953_545767_182CD7A7)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Like with HT, make things a bit simpler in future patches by
passing the station to ieee80211_vht_cap_ie_to_sta_vht_cap()
instead of the vht_cap pointer. Also disable VHT here if HT
isn't supported.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/cfg.c         | 3 +--
 net/mac80211/ieee80211_i.h | 2 +-
 net/mac80211/mlme.c        | 3 +--
 net/mac80211/vht.c         | 8 +++++---
 4 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 221db8d..799e706 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1253,8 +1253,7 @@ static int sta_apply_parameters(struct ieee80211_local *local,
 
 	if (params->vht_capa)
 		ieee80211_vht_cap_ie_to_sta_vht_cap(sdata, sband,
-						    params->vht_capa,
-						    &sta->sta.vht_cap);
+						    params->vht_capa, sta);
 
 	if (ieee80211_vif_is_mesh(&sdata->vif)) {
 #ifdef CONFIG_MAC80211_MESH
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 190915c..0583435 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1426,7 +1426,7 @@ u8 ieee80211_mcs_to_chains(const struct ieee80211_mcs_info *mcs);
 void ieee80211_vht_cap_ie_to_sta_vht_cap(struct ieee80211_sub_if_data *sdata,
 					 struct ieee80211_supported_band *sband,
 					 struct ieee80211_vht_cap *vht_cap_ie,
-					 struct ieee80211_sta_vht_cap *vht_cap);
+					 struct sta_info *sta);
 void ieee80211_sta_set_rx_nss(struct sta_info *sta);
 
 /* Spectrum management */
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 4faf785..8176bf5 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -2197,8 +2197,7 @@ static bool ieee80211_assoc_success(struct ieee80211_sub_if_data *sdata,
 
 	if (elems.vht_cap_elem && !(ifmgd->flags & IEEE80211_STA_DISABLE_VHT))
 		ieee80211_vht_cap_ie_to_sta_vht_cap(sdata, sband,
-						    elems.vht_cap_elem,
-						    &sta->sta.vht_cap);
+						    elems.vht_cap_elem, sta);
 
 	rate_control_rate_init(sta);
 
diff --git a/net/mac80211/vht.c b/net/mac80211/vht.c
index 7751867..234f408 100644
--- a/net/mac80211/vht.c
+++ b/net/mac80211/vht.c
@@ -15,13 +15,15 @@
 void ieee80211_vht_cap_ie_to_sta_vht_cap(struct ieee80211_sub_if_data *sdata,
 					 struct ieee80211_supported_band *sband,
 					 struct ieee80211_vht_cap *vht_cap_ie,
-					 struct ieee80211_sta_vht_cap *vht_cap)
+					 struct sta_info *sta)
 {
-	if (WARN_ON_ONCE(!vht_cap))
-		return;
+	struct ieee80211_sta_vht_cap *vht_cap = &sta->sta.vht_cap;
 
 	memset(vht_cap, 0, sizeof(*vht_cap));
 
+	if (!sta->sta.ht_cap.ht_supported)
+		return;
+
 	if (!vht_cap_ie || !sband->vht_cap.vht_supported)
 		return;
 
-- 
1.8.0

