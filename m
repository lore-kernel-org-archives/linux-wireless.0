Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f170.google.com ([209.85.212.170]:51390 "EHLO
	mail-px0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754742Ab1ECX5e (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 May 2011 19:57:34 -0400
Received: by mail-px0-f170.google.com with SMTP id 19so426563pxi.1
        for <linux-wireless@vger.kernel.org>; Tue, 03 May 2011 16:57:34 -0700 (PDT)
From: Javier Cardona <javier@cozybit.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Javier Cardona <javier@cozybit.com>,
	Thomas Pedersen <thomas@cozybit.com>,
	devel@lists.open80211s.org,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, jlopex@gmail.com
Subject: [PATCH 03/13] mac80211: Drop MESH_PLINK category and use new ANA-approved MESH_ACTION
Date: Tue,  3 May 2011 16:57:09 -0700
Message-Id: <1304467039-7730-4-git-send-email-javier@cozybit.com> (sfid-20110504_015740_729504_960AF1A3)
In-Reply-To: <1304467039-7730-1-git-send-email-javier@cozybit.com>
References: <1304467039-7730-1-git-send-email-javier@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Note: This breaks compatibility with previous mesh protocol instances.

Signed-off-by: Javier Cardona <javier@cozybit.com>
---
 include/linux/ieee80211.h |    5 ++---
 net/mac80211/mesh.c       |    2 +-
 net/mac80211/mesh_plink.c |    2 +-
 net/mac80211/rx.c         |    7 +++++--
 4 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index 79690b7..ee1c96a 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -1261,9 +1261,8 @@ enum ieee80211_category {
 	WLAN_CATEGORY_MULTIHOP_ACTION = 14,
 	WLAN_CATEGORY_SELF_PROTECTED = 15,
 	WLAN_CATEGORY_WMM = 17,
-	/* TODO: remove MESH_PLINK and MESH_PATH_SEL after */
-	/*       mesh is updated to current 802.11s draft  */
-	WLAN_CATEGORY_MESH_PLINK = 30,
+	/* TODO: remove MESH_PATH_SEL after mesh is updated
+	 * to current 802.11s draft  */
 	WLAN_CATEGORY_MESH_PATH_SEL = 32,
 	WLAN_CATEGORY_VENDOR_SPECIFIC_PROTECTED = 126,
 	WLAN_CATEGORY_VENDOR_SPECIFIC = 127,
diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index 2a59eb3..75378e8 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -600,7 +600,7 @@ static void ieee80211_mesh_rx_mgmt_action(struct ieee80211_sub_if_data *sdata,
 					  struct ieee80211_rx_status *rx_status)
 {
 	switch (mgmt->u.action.category) {
-	case WLAN_CATEGORY_MESH_PLINK:
+	case WLAN_CATEGORY_MESH_ACTION:
 		mesh_rx_plink_frame(sdata, mgmt, len, rx_status);
 		break;
 	case WLAN_CATEGORY_MESH_PATH_SEL:
diff --git a/net/mac80211/mesh_plink.c b/net/mac80211/mesh_plink.c
index 87abf8d..0120e9e 100644
--- a/net/mac80211/mesh_plink.c
+++ b/net/mac80211/mesh_plink.c
@@ -182,7 +182,7 @@ static int mesh_plink_frame_tx(struct ieee80211_sub_if_data *sdata,
 	memcpy(mgmt->da, da, ETH_ALEN);
 	memcpy(mgmt->sa, sdata->vif.addr, ETH_ALEN);
 	/* BSSID is left zeroed, wildcard value */
-	mgmt->u.action.category = WLAN_CATEGORY_MESH_PLINK;
+	mgmt->u.action.category = WLAN_CATEGORY_MESH_ACTION;
 	mgmt->u.action.u.plink_action.action_code = action;
 
 	if (action == PLINK_CLOSE)
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 13a6697..0f29bdb 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -495,8 +495,11 @@ ieee80211_rx_mesh_check(struct ieee80211_rx_data *rx)
 			return RX_DROP_MONITOR;
 
 		if (ieee80211_is_action(hdr->frame_control)) {
+			u8 category;
 			mgmt = (struct ieee80211_mgmt *)hdr;
-			if (mgmt->u.action.category != WLAN_CATEGORY_MESH_PLINK)
+			category = mgmt->u.action.category;
+			if (category != WLAN_CATEGORY_MESH_ACTION &&
+				category != WLAN_CATEGORY_SELF_PROTECTED)
 				return RX_DROP_MONITOR;
 			return RX_CONTINUE;
 		}
@@ -2205,7 +2208,7 @@ ieee80211_rx_h_action(struct ieee80211_rx_data *rx)
 			goto handled;
 		}
 		break;
-	case WLAN_CATEGORY_MESH_PLINK:
+	case WLAN_CATEGORY_MESH_ACTION:
 		if (!ieee80211_vif_is_mesh(&sdata->vif))
 			break;
 		goto queue;
-- 
1.7.1

