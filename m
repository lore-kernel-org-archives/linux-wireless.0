Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:51581 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751426Ab2DCEVg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Apr 2012 00:21:36 -0400
Received: by mail-ob0-f174.google.com with SMTP id tb18so3046594obb.19
        for <linux-wireless@vger.kernel.org>; Mon, 02 Apr 2012 21:21:36 -0700 (PDT)
From: Ashok Nagarajan <ashok@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: javier@cozybit.com, thomas@cozybit.com, johannes@sipsolutions.net,
	devel@lists.open80211s.org, linville@tuxdriver.com,
	Ashok Nagarajan <ashok@cozybit.com>
Subject: [PATCH v3 4/4] mac80211: Check basic rates when peering
Date: Mon,  2 Apr 2012 21:21:22 -0700
Message-Id: <1333426882-22948-4-git-send-email-ashok@cozybit.com> (sfid-20120403_062158_378041_527A2530)
In-Reply-To: <1333426882-22948-1-git-send-email-ashok@cozybit.com>
References: <1333426882-22948-1-git-send-email-ashok@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Section 13.2.3 of IEEE 80211s standard requires BSSBasicRateSet of mesh nodes
to be identical to establish peer link.

Signed-off-by: Ashok Nagarajan <ashok@cozybit.com>
Signed-off-by: Thomas Pedersen <thomas@cozybit.com>
---
 v2:
        indicate basic_rates conditionally (Johannes)
 v3:
 	Avoid possible conflicts

 net/mac80211/mesh.c       |   15 ++++++++++-----
 net/mac80211/mesh.h       |    2 +-
 net/mac80211/mesh_plink.c |    2 +-
 3 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index e9362e4..c43026e 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -69,11 +69,13 @@ static void ieee80211_mesh_housekeeping_timer(unsigned long data)
  *
  * @ie: information elements of a management frame from the mesh peer
  * @sdata: local mesh subif
+ * @basic_rates: BSSBasicRateSet of the peer candidate
  *
  * This function checks if the mesh configuration of a mesh point matches the
  * local mesh configuration, i.e. if both nodes belong to the same mesh network.
  */
-bool mesh_matches_local(struct ieee802_11_elems *ie, struct ieee80211_sub_if_data *sdata)
+bool mesh_matches_local(struct ieee802_11_elems *ie,
+			struct ieee80211_sub_if_data *sdata, u32 basic_rates)
 {
 	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
 	struct ieee80211_local *local = sdata->local;
@@ -97,6 +99,9 @@ bool mesh_matches_local(struct ieee802_11_elems *ie, struct ieee80211_sub_if_dat
 	     (ifmsh->mesh_auth_id == ie->mesh_config->meshconf_auth)))
 		goto mismatch;
 
+	if (sdata->vif.bss_conf.basic_rates != basic_rates)
+		goto mismatch;
+
 	/* disallow peering with mismatched channel types for now */
 	if (ie->ht_info_elem &&
 	    (local->_oper_channel_type !=
@@ -653,12 +658,12 @@ static void ieee80211_mesh_rx_bcn_presp(struct ieee80211_sub_if_data *sdata,
 	if (!channel || channel->flags & IEEE80211_CHAN_DISABLED)
 		return;
 
+	supp_rates = ieee80211_sta_get_rates(local, &elems,
+					     band, &basic_rates);
+
 	if (elems.mesh_id && elems.mesh_config &&
-	    mesh_matches_local(&elems, sdata)) {
-		supp_rates = ieee80211_sta_get_rates(local, &elems,
-						     band, &basic_rates);
+	    mesh_matches_local(&elems, sdata, basic_rates))
 		mesh_neighbour_update(mgmt->sa, supp_rates, sdata, &elems);
-	}
 }
 
 static void ieee80211_mesh_rx_mgmt_action(struct ieee80211_sub_if_data *sdata,
diff --git a/net/mac80211/mesh.h b/net/mac80211/mesh.h
index 8d53b71..48b00b6 100644
--- a/net/mac80211/mesh.h
+++ b/net/mac80211/mesh.h
@@ -204,7 +204,7 @@ int ieee80211_new_mesh_header(struct ieee80211s_hdr *meshhdr,
 int mesh_rmc_check(u8 *addr, struct ieee80211s_hdr *mesh_hdr,
 		struct ieee80211_sub_if_data *sdata);
 bool mesh_matches_local(struct ieee802_11_elems *ie,
-		struct ieee80211_sub_if_data *sdata);
+			struct ieee80211_sub_if_data *sdata, u32 basic_rates);
 void mesh_ids_set_default(struct ieee80211_if_mesh *mesh);
 void mesh_mgmt_ies_add(struct sk_buff *skb,
 		struct ieee80211_sub_if_data *sdata);
diff --git a/net/mac80211/mesh_plink.c b/net/mac80211/mesh_plink.c
index 58bdb57..5fd136d 100644
--- a/net/mac80211/mesh_plink.c
+++ b/net/mac80211/mesh_plink.c
@@ -564,7 +564,7 @@ void mesh_rx_plink_frame(struct ieee80211_sub_if_data *sdata, struct ieee80211_m
 					rx_status->band, &basic_rates);
 
 	if (ftype != WLAN_SP_MESH_PEERING_CLOSE &&
-	    (!mesh_matches_local(&elems, sdata))) {
+	    (!mesh_matches_local(&elems, sdata, basic_rates))) {
 		matches_local = false;
 		switch (ftype) {
 		case WLAN_SP_MESH_PEERING_OPEN:
-- 
1.7.5.4

