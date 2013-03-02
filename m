Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f45.google.com ([209.85.160.45]:63662 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751115Ab3CBGEL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Mar 2013 01:04:11 -0500
Received: by mail-pb0-f45.google.com with SMTP id ro8so2147576pbb.32
        for <linux-wireless@vger.kernel.org>; Fri, 01 Mar 2013 22:04:11 -0800 (PST)
From: Thomas Pedersen <thomas@cozybit.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, devel@lists.open80211s.org,
	Thomas Pedersen <thomas@cozybit.com>
Subject: [PATCH 3/6] mac80211: support userspace MPM
Date: Fri,  1 Mar 2013 22:02:49 -0800
Message-Id: <1362204172-28307-3-git-send-email-thomas@cozybit.com> (sfid-20130302_070424_760474_D21B22DF)
In-Reply-To: <1362204172-28307-1-git-send-email-thomas@cozybit.com>
References: <1362204172-28307-1-git-send-email-thomas@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Earlier mac80211 would check whether some kind of mesh
security was enabled, when the real question was "is the
MPM in userspace"?

Signed-off-by: Thomas Pedersen <thomas@cozybit.com>
---
 net/mac80211/cfg.c         |    3 ++-
 net/mac80211/ieee80211_i.h |    1 +
 net/mac80211/main.c        |    3 ++-
 net/mac80211/mesh.c        |    2 +-
 net/mac80211/mesh_plink.c  |   11 ++++++++---
 net/mac80211/rx.c          |    2 +-
 6 files changed, 15 insertions(+), 7 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 18e9dfe..cd9c222 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1432,7 +1432,7 @@ static int ieee80211_change_station(struct wiphy *wiphy,
 
 	switch (sdata->vif.type) {
 	case NL80211_IFTYPE_MESH_POINT:
-		if (sdata->u.mesh.security & IEEE80211_MESH_SEC_SECURED)
+		if (sdata->u.mesh.user_mpm)
 			statype = CFG80211_STA_MESH_PEER_USER;
 		else
 			statype = CFG80211_STA_MESH_PEER_KERNEL;
@@ -1726,6 +1726,7 @@ static int copy_mesh_setup(struct ieee80211_if_mesh *ifmsh,
 	ifmsh->mesh_sp_id = setup->sync_method;
 	ifmsh->mesh_pp_id = setup->path_sel_proto;
 	ifmsh->mesh_pm_id = setup->path_metric;
+	ifmsh->user_mpm = setup->user_mpm;
 	ifmsh->security = IEEE80211_MESH_SEC_NONE;
 	if (setup->is_authenticated)
 		ifmsh->security |= IEEE80211_MESH_SEC_AUTHED;
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 2518f04..88b34cc 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -593,6 +593,7 @@ struct ieee80211_if_mesh {
 		IEEE80211_MESH_SEC_AUTHED = 0x1,
 		IEEE80211_MESH_SEC_SECURED = 0x2,
 	} security;
+	bool user_mpm;
 	/* Extensible Synchronization Framework */
 	const struct ieee80211_mesh_sync_ops *sync_ops;
 	s64 sync_offset_clockdrift_max;
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 29502b1..d830637 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -593,7 +593,8 @@ struct ieee80211_hw *ieee80211_alloc_hw(size_t priv_data_len,
 	wiphy->features |= NL80211_FEATURE_SK_TX_STATUS |
 			   NL80211_FEATURE_SAE |
 			   NL80211_FEATURE_HT_IBSS |
-			   NL80211_FEATURE_VIF_TXPOWER;
+			   NL80211_FEATURE_VIF_TXPOWER |
+			   NL80211_FEATURE_USERSPACE_MPM;
 
 	if (!ops->hw_scan)
 		wiphy->features |= NL80211_FEATURE_LOW_PRIORITY_SCAN |
diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index 29ce2aa..65e9e4d 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -165,7 +165,7 @@ void mesh_sta_cleanup(struct sta_info *sta)
 	 * an update.
 	 */
 	changed = mesh_accept_plinks_update(sdata);
-	if (sdata->u.mesh.security == IEEE80211_MESH_SEC_NONE) {
+	if (!sdata->u.mesh.user_mpm) {
 		changed |= mesh_plink_deactivate(sta);
 		del_timer_sync(&sta->plink_timer);
 	}
diff --git a/net/mac80211/mesh_plink.c b/net/mac80211/mesh_plink.c
index 07d396d..635d643 100644
--- a/net/mac80211/mesh_plink.c
+++ b/net/mac80211/mesh_plink.c
@@ -437,8 +437,9 @@ mesh_sta_info_alloc(struct ieee80211_sub_if_data *sdata, u8 *addr,
 {
 	struct sta_info *sta = NULL;
 
-	/* Userspace handles peer allocation when security is enabled */
-	if (sdata->u.mesh.security & IEEE80211_MESH_SEC_AUTHED)
+	/* Userspace handles station allocation */
+	if (sdata->u.mesh.user_mpm ||
+	    sdata->u.mesh.security & IEEE80211_MESH_SEC_AUTHED)
 		cfg80211_notify_new_peer_candidate(sdata->dev, addr,
 						   elems->ie_start,
 						   elems->total_len,
@@ -605,7 +606,7 @@ void mesh_plink_quiesce(struct sta_info *sta)
 		return;
 
 	/* no kernel mesh sta timers have been initialized */
-	if (sta->sdata->u.mesh.security != IEEE80211_MESH_SEC_NONE)
+	if (sta->sdata->u.mesh.user_mpm)
 		return;
 
 	if (del_timer_sync(&sta->plink_timer))
@@ -695,6 +696,10 @@ void mesh_rx_plink_frame(struct ieee80211_sub_if_data *sdata,
 	if (len < IEEE80211_MIN_ACTION_SIZE + 3)
 		return;
 
+	if (sdata->u.mesh.user_mpm)
+		/* userspace must register for these */
+		return;
+
 	if (is_multicast_ether_addr(mgmt->da)) {
 		mpl_dbg(sdata,
 			"Mesh plink: ignore frame from multicast address\n");
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 1f940e2..5b4492a 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -2543,7 +2543,7 @@ ieee80211_rx_h_action(struct ieee80211_rx_data *rx)
 		case WLAN_SP_MESH_PEERING_CONFIRM:
 			if (!ieee80211_vif_is_mesh(&sdata->vif))
 				goto invalid;
-			if (sdata->u.mesh.security != IEEE80211_MESH_SEC_NONE)
+			if (sdata->u.mesh.user_mpm)
 				/* userspace handles this frame */
 				break;
 			goto queue;
-- 
1.7.10.4

