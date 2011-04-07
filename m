Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:48174 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752624Ab1DGXJk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Apr 2011 19:09:40 -0400
Received: by mail-iy0-f174.google.com with SMTP id 14so2935734iyb.19
        for <linux-wireless@vger.kernel.org>; Thu, 07 Apr 2011 16:09:40 -0700 (PDT)
From: Thomas Pedersen <thomas@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: johannes.berg@sipsolutions.net, linville@tuxdriver.com,
	javier@cozybit.com
Subject: [PATCH] v8 mac80211: send notification on new peer candidate for our secure mesh
Date: Thu,  7 Apr 2011 15:08:35 -0700
Message-Id: <1302214115-3688-10-git-send-email-thomas@cozybit.com>
In-Reply-To: <1302214115-3688-1-git-send-email-thomas@cozybit.com>
References: <1302214115-3688-1-git-send-email-thomas@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Javier Cardona <javier@cozybit.com>

Also, advertise support for mesh authentication.

Signed-off-by: Javier Cardona <javier@cozybit.com>
---
 net/mac80211/main.c       |    5 +++++
 net/mac80211/mesh.c       |    4 +---
 net/mac80211/mesh.h       |    3 ++-
 net/mac80211/mesh_plink.c |   18 +++++++++++++-----
 4 files changed, 21 insertions(+), 9 deletions(-)

diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index e2db3dc..0ab2a8d 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -762,6 +762,11 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 	local->hw.wiphy->interface_modes &= ~BIT(NL80211_IFTYPE_MESH_POINT);
 #endif
 
+	/* if the underlying driver supports mesh, mac80211 will (at least)
+	 * provide routing of mesh authentication frames to userspace */
+	if (local->hw.wiphy->interface_modes & BIT(NL80211_IFTYPE_MESH_POINT))
+		local->hw.wiphy->flags |= WIPHY_FLAG_MESH_AUTH;
+
 	/* mac80211 supports control port protocol changing */
 	local->hw.wiphy->flags |= WIPHY_FLAG_CONTROL_PORT_PROTOCOL;
 
diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index 47a26c0..1120797 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -590,9 +590,7 @@ static void ieee80211_mesh_rx_bcn_presp(struct ieee80211_sub_if_data *sdata,
 	if (elems.mesh_id && elems.mesh_config &&
 	    mesh_matches_local(&elems, sdata)) {
 		supp_rates = ieee80211_sta_get_rates(local, &elems, band);
-
-		mesh_neighbour_update(mgmt->sa, supp_rates, sdata,
-				      mesh_peer_accepts_plinks(&elems));
+		mesh_neighbour_update(mgmt->sa, supp_rates, sdata, &elems);
 	}
 }
 
diff --git a/net/mac80211/mesh.h b/net/mac80211/mesh.h
index b99e230..10acf1c 100644
--- a/net/mac80211/mesh.h
+++ b/net/mac80211/mesh.h
@@ -226,7 +226,8 @@ void mesh_rx_path_sel_frame(struct ieee80211_sub_if_data *sdata,
 int mesh_path_add(u8 *dst, struct ieee80211_sub_if_data *sdata);
 /* Mesh plinks */
 void mesh_neighbour_update(u8 *hw_addr, u32 rates,
-		struct ieee80211_sub_if_data *sdata, bool add);
+		struct ieee80211_sub_if_data *sdata,
+		struct ieee802_11_elems *ie);
 bool mesh_peer_accepts_plinks(struct ieee802_11_elems *ie);
 void mesh_accept_plinks_update(struct ieee80211_sub_if_data *sdata);
 void mesh_plink_broken(struct sta_info *sta);
diff --git a/net/mac80211/mesh_plink.c b/net/mac80211/mesh_plink.c
index b327e0e..84e5b05 100644
--- a/net/mac80211/mesh_plink.c
+++ b/net/mac80211/mesh_plink.c
@@ -237,8 +237,9 @@ static int mesh_plink_frame_tx(struct ieee80211_sub_if_data *sdata,
 	return 0;
 }
 
-void mesh_neighbour_update(u8 *hw_addr, u32 rates, struct ieee80211_sub_if_data *sdata,
-			   bool peer_accepting_plinks)
+void mesh_neighbour_update(u8 *hw_addr, u32 rates,
+		struct ieee80211_sub_if_data *sdata,
+		struct ieee802_11_elems *elems)
 {
 	struct ieee80211_local *local = sdata->local;
 	struct sta_info *sta;
@@ -248,8 +249,14 @@ void mesh_neighbour_update(u8 *hw_addr, u32 rates, struct ieee80211_sub_if_data
 	sta = sta_info_get(sdata, hw_addr);
 	if (!sta) {
 		rcu_read_unlock();
-
-		sta = mesh_plink_alloc(sdata, hw_addr, rates);
+		/* Userspace handles peer allocation when security is enabled
+		 * */
+		if (sdata->u.mesh.is_secure)
+			cfg80211_notify_new_peer_candidate(sdata->dev, hw_addr,
+					elems->ie_start, elems->total_len,
+					GFP_KERNEL);
+		else
+			sta = mesh_plink_alloc(sdata, hw_addr, rates);
 		if (!sta)
 			return;
 		if (sta_info_insert_rcu(sta)) {
@@ -260,7 +267,8 @@ void mesh_neighbour_update(u8 *hw_addr, u32 rates, struct ieee80211_sub_if_data
 
 	sta->last_rx = jiffies;
 	sta->sta.supp_rates[local->hw.conf.channel->band] = rates;
-	if (peer_accepting_plinks && sta->plink_state == PLINK_LISTEN &&
+	if (mesh_peer_accepts_plinks(elems) &&
+			sta->plink_state == PLINK_LISTEN &&
 			sdata->u.mesh.accepting_plinks &&
 			sdata->u.mesh.mshcfg.auto_open_plinks)
 		mesh_plink_open(sta);
-- 
1.7.4.4

