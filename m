Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f52.google.com ([209.85.210.52]:47133 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751180Ab2DSCXv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Apr 2012 22:23:51 -0400
Received: by dake40 with SMTP id e40so10673360dak.11
        for <linux-wireless@vger.kernel.org>; Wed, 18 Apr 2012 19:23:51 -0700 (PDT)
From: Thomas Pedersen <thomas@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: devel@lists.open80211s.org, Thomas Pedersen <thomas@cozybit.com>,
	johannes@sipsolutions.net, linville@tuxdriver.com
Subject: [PATCH 2/2] mac80211: refactor mesh peer rate handling
Date: Wed, 18 Apr 2012 19:23:43 -0700
Message-Id: <1334802223-4603-2-git-send-email-thomas@cozybit.com> (sfid-20120419_042425_259272_D4D55B43)
In-Reply-To: <1334802223-4603-1-git-send-email-thomas@cozybit.com>
References: <1334802223-4603-1-git-send-email-thomas@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

To avoid passing supp_rates and basic_rates around all the time, just
derive these when needed in mesh_matches_local() and mesh_peer_init().

Signed-off-by: Thomas Pedersen <thomas@cozybit.com>
---
 net/mac80211/mesh.c       |   19 +++++++++----------
 net/mac80211/mesh.h       |   10 +++++-----
 net/mac80211/mesh_plink.c |   25 +++++++++++--------------
 3 files changed, 25 insertions(+), 29 deletions(-)

diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index 133c118..598a96a 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -64,18 +64,18 @@ static void ieee80211_mesh_housekeeping_timer(unsigned long data)
 /**
  * mesh_matches_local - check if the config of a mesh point matches ours
  *
- * @ie: information elements of a management frame from the mesh peer
  * @sdata: local mesh subif
- * @basic_rates: BSSBasicRateSet of the peer candidate
+ * @ie: information elements of a management frame from the mesh peer
  *
  * This function checks if the mesh configuration of a mesh point matches the
  * local mesh configuration, i.e. if both nodes belong to the same mesh network.
  */
-bool mesh_matches_local(struct ieee802_11_elems *ie,
-			struct ieee80211_sub_if_data *sdata, u32 basic_rates)
+bool mesh_matches_local(struct ieee80211_sub_if_data *sdata,
+			struct ieee802_11_elems *ie)
 {
 	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
 	struct ieee80211_local *local = sdata->local;
+	u32 basic_rates = 0;
 
 	/*
 	 * As support for each feature is added, check for matching
@@ -96,6 +96,9 @@ bool mesh_matches_local(struct ieee802_11_elems *ie,
 	     (ifmsh->mesh_auth_id == ie->mesh_config->meshconf_auth)))
 		goto mismatch;
 
+	ieee80211_sta_get_rates(local, ie, local->oper_channel->band,
+				&basic_rates);
+
 	if (sdata->vif.bss_conf.basic_rates != basic_rates)
 		goto mismatch;
 
@@ -630,7 +633,6 @@ static void ieee80211_mesh_rx_bcn_presp(struct ieee80211_sub_if_data *sdata,
 	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
 	struct ieee802_11_elems elems;
 	struct ieee80211_channel *channel;
-	u32 supp_rates = 0, basic_rates = 0;
 	size_t baselen;
 	int freq;
 	enum ieee80211_band band = rx_status->band;
@@ -661,12 +663,9 @@ static void ieee80211_mesh_rx_bcn_presp(struct ieee80211_sub_if_data *sdata,
 	if (!channel || channel->flags & IEEE80211_CHAN_DISABLED)
 		return;
 
-	supp_rates = ieee80211_sta_get_rates(local, &elems,
-					     band, &basic_rates);
-
 	if (elems.mesh_id && elems.mesh_config &&
-	    mesh_matches_local(&elems, sdata, basic_rates))
-		mesh_neighbour_update(mgmt->sa, supp_rates, sdata, &elems);
+	    mesh_matches_local(sdata, &elems))
+		mesh_neighbour_update(sdata, mgmt->sa, &elems);
 
 	if (ifmsh->sync_ops)
 		ifmsh->sync_ops->rx_bcn_presp(sdata,
diff --git a/net/mac80211/mesh.h b/net/mac80211/mesh.h
index 4ad7389..345f0e7 100644
--- a/net/mac80211/mesh.h
+++ b/net/mac80211/mesh.h
@@ -222,8 +222,8 @@ int ieee80211_new_mesh_header(struct ieee80211s_hdr *meshhdr,
 		char *addr6);
 int mesh_rmc_check(u8 *addr, struct ieee80211s_hdr *mesh_hdr,
 		struct ieee80211_sub_if_data *sdata);
-bool mesh_matches_local(struct ieee802_11_elems *ie,
-			struct ieee80211_sub_if_data *sdata, u32 basic_rates);
+bool mesh_matches_local(struct ieee80211_sub_if_data *sdata,
+			struct ieee802_11_elems *ie);
 void mesh_ids_set_default(struct ieee80211_if_mesh *mesh);
 void mesh_mgmt_ies_add(struct sk_buff *skb,
 		struct ieee80211_sub_if_data *sdata);
@@ -276,9 +276,9 @@ int mesh_path_add_gate(struct mesh_path *mpath);
 int mesh_path_send_to_gates(struct mesh_path *mpath);
 int mesh_gate_num(struct ieee80211_sub_if_data *sdata);
 /* Mesh plinks */
-void mesh_neighbour_update(u8 *hw_addr, u32 rates,
-		struct ieee80211_sub_if_data *sdata,
-		struct ieee802_11_elems *ie);
+void mesh_neighbour_update(struct ieee80211_sub_if_data *sdata,
+			   u8 *hw_addr,
+			   struct ieee802_11_elems *ie);
 bool mesh_peer_accepts_plinks(struct ieee802_11_elems *ie);
 void mesh_accept_plinks_update(struct ieee80211_sub_if_data *sdata);
 void mesh_plink_broken(struct sta_info *sta);
diff --git a/net/mac80211/mesh_plink.c b/net/mac80211/mesh_plink.c
index c3a0b0a..c2af7b3 100644
--- a/net/mac80211/mesh_plink.c
+++ b/net/mac80211/mesh_plink.c
@@ -268,20 +268,22 @@ static int mesh_plink_frame_tx(struct ieee80211_sub_if_data *sdata,
  *
  * @sdata: local meshif
  * @addr: peer's address
- * @rates: station's supported rates
  * @elems: IEs from beacon or mesh peering frame
  *
  * call under RCU
  */
 static struct sta_info *mesh_peer_init(struct ieee80211_sub_if_data *sdata,
-				       u8 *addr, u32 rates,
+				       u8 *addr,
 				       struct ieee802_11_elems *elems)
 {
 	struct ieee80211_local *local = sdata->local;
+	enum ieee80211_band band = local->oper_channel->band;
 	struct ieee80211_supported_band *sband;
+	u32 rates, basic_rates = 0;
 	struct sta_info *sta;
 
-	sband = local->hw.wiphy->bands[local->oper_channel->band];
+	sband = local->hw.wiphy->bands[band];
+	rates = ieee80211_sta_get_rates(local, elems, band, &basic_rates);
 
 	sta = sta_info_get(sdata, addr);
 	if (!sta) {
@@ -292,7 +294,7 @@ static struct sta_info *mesh_peer_init(struct ieee80211_sub_if_data *sdata,
 
 	spin_lock_bh(&sta->lock);
 	sta->last_rx = jiffies;
-	sta->sta.supp_rates[local->hw.conf.channel->band] = rates;
+	sta->sta.supp_rates[band] = rates;
 	if (elems->ht_cap_elem)
 		ieee80211_ht_cap_ie_to_sta_ht_cap(sdata, sband,
 						  elems->ht_cap_elem,
@@ -306,8 +308,8 @@ static struct sta_info *mesh_peer_init(struct ieee80211_sub_if_data *sdata,
 	return sta;
 }
 
-void mesh_neighbour_update(u8 *hw_addr, u32 rates,
-			   struct ieee80211_sub_if_data *sdata,
+void mesh_neighbour_update(struct ieee80211_sub_if_data *sdata,
+			   u8 *hw_addr,
 			   struct ieee802_11_elems *elems)
 {
 	struct sta_info *sta;
@@ -322,7 +324,7 @@ void mesh_neighbour_update(u8 *hw_addr, u32 rates,
 	}
 
 	rcu_read_lock();
-	sta = mesh_peer_init(sdata, hw_addr, rates, elems);
+	sta = mesh_peer_init(sdata, hw_addr, elems);
 	if (!sta)
 		goto out;
 
@@ -479,7 +481,6 @@ void mesh_plink_block(struct sta_info *sta)
 void mesh_rx_plink_frame(struct ieee80211_sub_if_data *sdata, struct ieee80211_mgmt *mgmt,
 			 size_t len, struct ieee80211_rx_status *rx_status)
 {
-	struct ieee80211_local *local = sdata->local;
 	struct ieee802_11_elems elems;
 	struct sta_info *sta;
 	enum plink_event event;
@@ -488,7 +489,6 @@ void mesh_rx_plink_frame(struct ieee80211_sub_if_data *sdata, struct ieee80211_m
 	bool deactivated, matches_local = true;
 	u8 ie_len;
 	u8 *baseaddr;
-	u32 rates, basic_rates = 0;
 	__le16 plid, llid, reason;
 #ifdef CONFIG_MAC80211_VERBOSE_MPL_DEBUG
 	static const char *mplstates[] = {
@@ -583,11 +583,8 @@ void mesh_rx_plink_frame(struct ieee80211_sub_if_data *sdata, struct ieee80211_m
 
 	/* Now we will figure out the appropriate event... */
 	event = PLINK_UNDEFINED;
-	rates = ieee80211_sta_get_rates(local, &elems,
-					rx_status->band, &basic_rates);
-
 	if (ftype != WLAN_SP_MESH_PEERING_CLOSE &&
-	    (!mesh_matches_local(&elems, sdata, basic_rates))) {
+	    !mesh_matches_local(sdata, &elems)) {
 		matches_local = false;
 		switch (ftype) {
 		case WLAN_SP_MESH_PEERING_OPEN:
@@ -660,7 +657,7 @@ void mesh_rx_plink_frame(struct ieee80211_sub_if_data *sdata, struct ieee80211_m
 
 	if (event == OPN_ACPT) {
 		/* allocate sta entry if necessary and update info */
-		sta = mesh_peer_init(sdata, mgmt->sa, rates, &elems);
+		sta = mesh_peer_init(sdata, mgmt->sa, &elems);
 		if (!sta) {
 			mpl_dbg("Mesh plink: failed to init peer!\n");
 			rcu_read_unlock();
-- 
1.7.5.4

