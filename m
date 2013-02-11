Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43140 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756915Ab3BKMiY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Feb 2013 07:38:24 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 01/14] mac80211: pass station to ieee80211_vht_cap_ie_to_sta_vht_cap
Date: Mon, 11 Feb 2013 13:38:05 +0100
Message-Id: <1360586298-15028-2-git-send-email-johannes@sipsolutions.net> (sfid-20130211_133829_043937_31B34255)
In-Reply-To: <1360586298-15028-1-git-send-email-johannes@sipsolutions.net>
References: <[PATCH 00/14] mac80211: HT/VHT handling>
 <1360586298-15028-1-git-send-email-johannes@sipsolutions.net>
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
 net/mac80211/ieee80211_i.h | 3 ++-
 net/mac80211/mlme.c        | 3 +--
 net/mac80211/vht.c         | 8 +++++---
 4 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index e09c0c4..8f3e3a2 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1256,8 +1256,7 @@ static int sta_apply_parameters(struct ieee80211_local *local,
 
 	if (params->vht_capa)
 		ieee80211_vht_cap_ie_to_sta_vht_cap(sdata, sband,
-						    params->vht_capa,
-						    &sta->sta.vht_cap);
+						    params->vht_capa, sta);
 
 	if (ieee80211_vif_is_mesh(&sdata->vif)) {
 #ifdef CONFIG_MAC80211_MESH
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 817a829..2512124 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1419,7 +1419,8 @@ u8 ieee80211_mcs_to_chains(const struct ieee80211_mcs_info *mcs);
 void ieee80211_vht_cap_ie_to_sta_vht_cap(struct ieee80211_sub_if_data *sdata,
 					 struct ieee80211_supported_band *sband,
 					 struct ieee80211_vht_cap *vht_cap_ie,
-					 struct ieee80211_sta_vht_cap *vht_cap);
+					 struct sta_info *sta);
+
 /* Spectrum management */
 void ieee80211_process_measurement_req(struct ieee80211_sub_if_data *sdata,
 				       struct ieee80211_mgmt *mgmt,
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index ade324e..f1c8532 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -2200,8 +2200,7 @@ static bool ieee80211_assoc_success(struct ieee80211_sub_if_data *sdata,
 
 	if (elems.vht_cap_elem && !(ifmgd->flags & IEEE80211_STA_DISABLE_VHT))
 		ieee80211_vht_cap_ie_to_sta_vht_cap(sdata, sband,
-						    elems.vht_cap_elem,
-						    &sta->sta.vht_cap);
+						    elems.vht_cap_elem, sta);
 
 	rate_control_rate_init(sta);
 
diff --git a/net/mac80211/vht.c b/net/mac80211/vht.c
index f311388..1606aa1 100644
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

