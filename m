Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f172.google.com ([209.85.211.172]:46074 "EHLO
	mail-yw0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754152Ab0C2SAm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Mar 2010 14:00:42 -0400
Received: by ywh2 with SMTP id 2so5153610ywh.33
        for <linux-wireless@vger.kernel.org>; Mon, 29 Mar 2010 11:00:41 -0700 (PDT)
From: Javier Cardona <javier@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: Javier Cardona <javier@cozybit.com>,
	Steve Derosier <steve@cozybit.com>, devel@lists.open80211s.org
Subject: [PATCH 2/2] mac80211: Moved mesh action codes to a more visible location
Date: Mon, 29 Mar 2010 11:00:21 -0700
Message-Id: <1269885621-10257-2-git-send-email-javier@cozybit.com>
In-Reply-To: <1269885621-10257-1-git-send-email-javier@cozybit.com>
References: <1269844239.4131.3.camel@jlt3.sipsolutions.net>
 <1269885621-10257-1-git-send-email-javier@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Grouped mesh action codes together with the other action codes in
ieee80211.h.

Signed-off-by: Javier Cardona <javier@cozybit.com>
---
 include/linux/ieee80211.h |    2 ++
 net/mac80211/mesh.c       |    4 ++--
 net/mac80211/mesh.h       |    2 --
 net/mac80211/mesh_hwmp.c  |    4 ++--
 net/mac80211/mesh_plink.c |    2 +-
 net/mac80211/rx.c         |    6 +++---
 6 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index 1998495..e0f528e 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -1211,6 +1211,8 @@ enum ieee80211_category {
 	WLAN_CATEGORY_SA_QUERY = 8,
 	WLAN_CATEGORY_PROTECTED_DUAL_OF_ACTION = 9,
 	WLAN_CATEGORY_WMM = 17,
+	WLAN_CATEGORY_MESH_PLINK = 30,		/* Pending ANA approval */
+	WLAN_CATEGORY_MESH_PATH_SEL = 32,	/* Pending ANA approval */
 	WLAN_CATEGORY_VENDOR_SPECIFIC_PROTECTED = 126,
 	WLAN_CATEGORY_VENDOR_SPECIFIC = 127,
 };
diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index 7a6bebc..2669fbf 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -600,10 +600,10 @@ static void ieee80211_mesh_rx_mgmt_action(struct ieee80211_sub_if_data *sdata,
 					  struct ieee80211_rx_status *rx_status)
 {
 	switch (mgmt->u.action.category) {
-	case MESH_PLINK_CATEGORY:
+	case WLAN_CATEGORY_MESH_PLINK:
 		mesh_rx_plink_frame(sdata, mgmt, len, rx_status);
 		break;
-	case MESH_PATH_SEL_CATEGORY:
+	case WLAN_CATEGORY_MESH_PATH_SEL:
 		mesh_rx_path_sel_frame(sdata, mgmt, len);
 		break;
 	}
diff --git a/net/mac80211/mesh.h b/net/mac80211/mesh.h
index 85562c5..c88087f 100644
--- a/net/mac80211/mesh.h
+++ b/net/mac80211/mesh.h
@@ -209,8 +209,6 @@ struct mesh_rmc {
 #define MESH_MAX_MPATHS		1024
 
 /* Pending ANA approval */
-#define MESH_PLINK_CATEGORY	30
-#define MESH_PATH_SEL_CATEGORY	32
 #define MESH_PATH_SEL_ACTION	0
 
 /* PERR reason codes */
diff --git a/net/mac80211/mesh_hwmp.c b/net/mac80211/mesh_hwmp.c
index ccff613..36141d6 100644
--- a/net/mac80211/mesh_hwmp.c
+++ b/net/mac80211/mesh_hwmp.c
@@ -131,7 +131,7 @@ static int mesh_path_sel_frame_tx(enum mpath_frame_type action, u8 flags,
 	memcpy(mgmt->sa, sdata->vif.addr, ETH_ALEN);
 	/* BSSID == SA */
 	memcpy(mgmt->bssid, sdata->vif.addr, ETH_ALEN);
-	mgmt->u.action.category = MESH_PATH_SEL_CATEGORY;
+	mgmt->u.action.category = WLAN_CATEGORY_MESH_PATH_SEL;
 	mgmt->u.action.u.mesh_action.action_code = MESH_PATH_SEL_ACTION;
 
 	switch (action) {
@@ -224,7 +224,7 @@ int mesh_path_error_tx(u8 ttl, u8 *target, __le32 target_sn,
 	memcpy(mgmt->da, ra, ETH_ALEN);
 	memcpy(mgmt->sa, sdata->vif.addr, ETH_ALEN);
 	/* BSSID is left zeroed, wildcard value */
-	mgmt->u.action.category = MESH_PATH_SEL_CATEGORY;
+	mgmt->u.action.category = WLAN_CATEGORY_MESH_PATH_SEL;
 	mgmt->u.action.u.mesh_action.action_code = MESH_PATH_SEL_ACTION;
 	ie_len = 15;
 	pos = skb_put(skb, 2 + ie_len);
diff --git a/net/mac80211/mesh_plink.c b/net/mac80211/mesh_plink.c
index 1a29c4a..8517f88 100644
--- a/net/mac80211/mesh_plink.c
+++ b/net/mac80211/mesh_plink.c
@@ -171,7 +171,7 @@ static int mesh_plink_frame_tx(struct ieee80211_sub_if_data *sdata,
 	memcpy(mgmt->da, da, ETH_ALEN);
 	memcpy(mgmt->sa, sdata->vif.addr, ETH_ALEN);
 	/* BSSID is left zeroed, wildcard value */
-	mgmt->u.action.category = MESH_PLINK_CATEGORY;
+	mgmt->u.action.category = WLAN_CATEGORY_MESH_PLINK;
 	mgmt->u.action.u.plink_action.action_code = action;
 
 	if (action == PLINK_CLOSE)
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 1e03972..43c0310 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -484,7 +484,7 @@ ieee80211_rx_mesh_check(struct ieee80211_rx_data *rx)
 
 		if (ieee80211_is_action(hdr->frame_control)) {
 			mgmt = (struct ieee80211_mgmt *)hdr;
-			if (mgmt->u.action.category != MESH_PLINK_CATEGORY)
+			if (mgmt->u.action.category != WLAN_CATEGORY_MESH_PLINK)
 				return RX_DROP_MONITOR;
 			return RX_CONTINUE;
 		}
@@ -1964,8 +1964,8 @@ ieee80211_rx_h_action(struct ieee80211_rx_data *rx)
 			goto handled;
 		}
 		break;
-	case MESH_PLINK_CATEGORY:
-	case MESH_PATH_SEL_CATEGORY:
+	case WLAN_CATEGORY_MESH_PLINK:
+	case WLAN_CATEGORY_MESH_PATH_SEL:
 		if (ieee80211_vif_is_mesh(&sdata->vif))
 			return ieee80211_mesh_rx_mgmt(sdata, rx->skb);
 		break;
-- 
1.6.3.3

