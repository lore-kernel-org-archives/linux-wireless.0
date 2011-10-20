Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:37571 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755774Ab1JTBDi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Oct 2011 21:03:38 -0400
Received: by mail-iy0-f174.google.com with SMTP id k3so2770432iae.19
        for <linux-wireless@vger.kernel.org>; Wed, 19 Oct 2011 18:03:38 -0700 (PDT)
From: Thomas Pedersen <thomas@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: anagar6@uic.edu, devel@lists.open80211s.org,
	Thomas Pedersen <thomas@cozybit.com>,
	johannes@sipsolutions.net, linville@tuxdriver.com
Subject: [PATCH 3/6] mac80211: set HT capabilities for mesh peer
Date: Wed, 19 Oct 2011 18:03:23 -0700
Message-Id: <1319072606-28291-4-git-send-email-thomas@cozybit.com> (sfid-20111020_030341_605288_5A881619)
In-Reply-To: <1319072606-28291-1-git-send-email-thomas@cozybit.com>
References: <1319072606-28291-1-git-send-email-thomas@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Set peer's HT capabilities, and disallow peering if we're on a different
channel type.

Signed-off-by: Thomas Pedersen <thomas@cozybit.com>
Signed-off-by: Ashok Nagarajan <anagar6@uic.edu>
---
 net/mac80211/mesh.c       |   25 +++++++++++++++++--------
 net/mac80211/mesh_plink.c |   13 ++++++++++---
 2 files changed, 27 insertions(+), 11 deletions(-)

diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index 2dc76a9..b3a125f 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -76,6 +76,7 @@ static void ieee80211_mesh_housekeeping_timer(unsigned long data)
 bool mesh_matches_local(struct ieee802_11_elems *ie, struct ieee80211_sub_if_data *sdata)
 {
 	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
+	struct ieee80211_local *local = sdata->local;
 
 	/*
 	 * As support for each feature is added, check for matching
@@ -87,15 +88,23 @@ bool mesh_matches_local(struct ieee802_11_elems *ie, struct ieee80211_sub_if_dat
 	 *   - MDA enabled
 	 * - Power management control on fc
 	 */
-	if (ifmsh->mesh_id_len == ie->mesh_id_len &&
-		memcmp(ifmsh->mesh_id, ie->mesh_id, ie->mesh_id_len) == 0 &&
-		(ifmsh->mesh_pp_id == ie->mesh_config->meshconf_psel) &&
-		(ifmsh->mesh_pm_id == ie->mesh_config->meshconf_pmetric) &&
-		(ifmsh->mesh_cc_id == ie->mesh_config->meshconf_congest) &&
-		(ifmsh->mesh_sp_id == ie->mesh_config->meshconf_synch) &&
-		(ifmsh->mesh_auth_id == ie->mesh_config->meshconf_auth))
-		return true;
-
+	if (!(ifmsh->mesh_id_len == ie->mesh_id_len &&
+	     memcmp(ifmsh->mesh_id, ie->mesh_id, ie->mesh_id_len) == 0 &&
+	     (ifmsh->mesh_pp_id == ie->mesh_config->meshconf_psel) &&
+	     (ifmsh->mesh_pm_id == ie->mesh_config->meshconf_pmetric) &&
+	     (ifmsh->mesh_cc_id == ie->mesh_config->meshconf_congest) &&
+	     (ifmsh->mesh_sp_id == ie->mesh_config->meshconf_synch) &&
+	     (ifmsh->mesh_auth_id == ie->mesh_config->meshconf_auth)))
+		goto mismatch;
+
+	/* disallow peering with mismatched channel types for now */
+	if (ie->ht_info_elem &&
+	    (local->_oper_channel_type !=
+	     ieee80211_ht_info_to_channel_type(ie->ht_info_elem)))
+		goto mismatch;
+
+	return true;
+mismatch:
 	return false;
 }
 
diff --git a/net/mac80211/mesh_plink.c b/net/mac80211/mesh_plink.c
index bbfbd45..f0705e6 100644
--- a/net/mac80211/mesh_plink.c
+++ b/net/mac80211/mesh_plink.c
@@ -80,11 +80,15 @@ static inline void mesh_plink_fsm_restart(struct sta_info *sta)
  *       on it in the lifecycle management section!
  */
 static struct sta_info *mesh_plink_alloc(struct ieee80211_sub_if_data *sdata,
-					 u8 *hw_addr, u32 rates)
+					 u8 *hw_addr, u32 rates,
+					 struct ieee802_11_elems *elems)
 {
 	struct ieee80211_local *local = sdata->local;
+	struct ieee80211_supported_band *sband;
 	struct sta_info *sta;
 
+	sband = local->hw.wiphy->bands[local->oper_channel->band];
+
 	if (local->num_sta >= MESH_MAX_PLINKS)
 		return NULL;
 
@@ -96,6 +100,9 @@ static struct sta_info *mesh_plink_alloc(struct ieee80211_sub_if_data *sdata,
 	set_sta_flag(sta, WLAN_STA_AUTHORIZED);
 	set_sta_flag(sta, WLAN_STA_WME);
 	sta->sta.supp_rates[local->hw.conf.channel->band] = rates;
+	if (elems->ht_cap_elem)
+		ieee80211_ht_cap_ie_to_sta_ht_cap(sband, elems->ht_cap_elem,
+						  &sta->sta.ht_cap);
 	rate_control_rate_init(sta);
 
 	return sta;
@@ -279,7 +286,7 @@ void mesh_neighbour_update(u8 *hw_addr, u32 rates,
 					elems->ie_start, elems->total_len,
 					GFP_KERNEL);
 		else
-			sta = mesh_plink_alloc(sdata, hw_addr, rates);
+			sta = mesh_plink_alloc(sdata, hw_addr, rates, elems);
 		if (!sta)
 			return;
 		if (sta_info_insert_rcu(sta)) {
@@ -570,7 +577,7 @@ void mesh_rx_plink_frame(struct ieee80211_sub_if_data *sdata, struct ieee80211_m
 		}
 
 		rates = ieee80211_sta_get_rates(local, &elems, rx_status->band);
-		sta = mesh_plink_alloc(sdata, mgmt->sa, rates);
+		sta = mesh_plink_alloc(sdata, mgmt->sa, rates, &elems);
 		if (!sta) {
 			mpl_dbg("Mesh plink error: plink table full\n");
 			return;
-- 
1.7.5.4

