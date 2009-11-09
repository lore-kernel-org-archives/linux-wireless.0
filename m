Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f207.google.com ([209.85.219.207]:56174 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755274AbZKIMkK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Nov 2009 07:40:10 -0500
Received: by ewy3 with SMTP id 3so3048161ewy.37
        for <linux-wireless@vger.kernel.org>; Mon, 09 Nov 2009 04:40:15 -0800 (PST)
From: Rui Paulo <rpaulo@gmail.com>
To: linville@tuxdriver.com
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, Rui Paulo <rpaulo@gmail.com>,
	Javier Cardona <javier@cozybit.com>
Subject: [PATCH 05/21] mac80211: update peer link management IE and action frames
Date: Mon,  9 Nov 2009 12:39:25 +0000
Message-Id: <1257770381-7680-6-git-send-email-rpaulo@gmail.com>
In-Reply-To: <1257770381-7680-1-git-send-email-rpaulo@gmail.com>
References: <1257770381-7680-1-git-send-email-rpaulo@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Update the length and format of the peer link management action frames.

Signed-off-by: Rui Paulo <rpaulo@gmail.com>
Signed-off-by: Javier Cardona <javier@cozybit.com>
Reviewed-by: Andrey Yurovsky <andrey@cozybit.com>
Tested-by: Brian Cavagnolo <brian@cozybit.com>
---
 net/mac80211/mesh.c       |    2 +-
 net/mac80211/mesh.h       |    2 +-
 net/mac80211/mesh_plink.c |   32 +++++++++++++++++---------------
 net/mac80211/rx.c         |    2 +-
 4 files changed, 20 insertions(+), 18 deletions(-)

diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index 7942518..63427d9 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -553,7 +553,7 @@ static void ieee80211_mesh_rx_mgmt_action(struct ieee80211_sub_if_data *sdata,
 					  struct ieee80211_rx_status *rx_status)
 {
 	switch (mgmt->u.action.category) {
-	case PLINK_CATEGORY:
+	case MESH_PLINK_CATEGORY:
 		mesh_rx_plink_frame(sdata, mgmt, len, rx_status);
 		break;
 	case MESH_PATH_SEL_CATEGORY:
diff --git a/net/mac80211/mesh.h b/net/mac80211/mesh.h
index 9948107..536d5c0 100644
--- a/net/mac80211/mesh.h
+++ b/net/mac80211/mesh.h
@@ -206,7 +206,7 @@ struct mesh_rmc {
 #define MESH_MAX_MPATHS		1024
 
 /* Pending ANA approval */
-#define PLINK_CATEGORY		30
+#define MESH_PLINK_CATEGORY	30
 #define MESH_PATH_SEL_CATEGORY	32
 
 /* Public interfaces */
diff --git a/net/mac80211/mesh_plink.c b/net/mac80211/mesh_plink.c
index 4188752..8a54bc8 100644
--- a/net/mac80211/mesh_plink.c
+++ b/net/mac80211/mesh_plink.c
@@ -18,9 +18,8 @@
 #define mpl_dbg(fmt, args...)	do { (void)(0); } while (0)
 #endif
 
-#define PLINK_GET_FRAME_SUBTYPE(p) (p)
-#define PLINK_GET_LLID(p) (p + 1)
-#define PLINK_GET_PLID(p) (p + 3)
+#define PLINK_GET_LLID(p) (p + 4)
+#define PLINK_GET_PLID(p) (p + 6)
 
 #define mod_plink_timer(s, t) (mod_timer(&s->plink_timer, \
 				jiffies + HZ * t / 1000))
@@ -154,6 +153,7 @@ static int mesh_plink_frame_tx(struct ieee80211_sub_if_data *sdata,
 	struct sk_buff *skb = dev_alloc_skb(local->hw.extra_tx_headroom + 400);
 	struct ieee80211_mgmt *mgmt;
 	bool include_plid = false;
+	static const u8 meshpeeringproto[] = { 0x00, 0x0F, 0xAC, 0x2A };
 	u8 *pos;
 	int ie_len;
 
@@ -171,7 +171,7 @@ static int mesh_plink_frame_tx(struct ieee80211_sub_if_data *sdata,
 	memcpy(mgmt->da, da, ETH_ALEN);
 	memcpy(mgmt->sa, sdata->dev->dev_addr, ETH_ALEN);
 	/* BSSID is left zeroed, wildcard value */
-	mgmt->u.action.category = PLINK_CATEGORY;
+	mgmt->u.action.category = MESH_PLINK_CATEGORY;
 	mgmt->u.action.u.plink_action.action_code = action;
 
 	if (action == PLINK_CLOSE)
@@ -189,18 +189,18 @@ static int mesh_plink_frame_tx(struct ieee80211_sub_if_data *sdata,
 	/* Add Peer Link Management element */
 	switch (action) {
 	case PLINK_OPEN:
-		ie_len = 3;
+		ie_len = 6;
 		break;
 	case PLINK_CONFIRM:
-		ie_len = 5;
+		ie_len = 8;
 		include_plid = true;
 		break;
 	case PLINK_CLOSE:
 	default:
 		if (!plid)
-			ie_len = 5;
+			ie_len = 8;
 		else {
-			ie_len = 7;
+			ie_len = 10;
 			include_plid = true;
 		}
 		break;
@@ -209,7 +209,8 @@ static int mesh_plink_frame_tx(struct ieee80211_sub_if_data *sdata,
 	pos = skb_put(skb, 2 + ie_len);
 	*pos++ = WLAN_EID_PEER_LINK;
 	*pos++ = ie_len;
-	*pos++ = action;
+	memcpy(pos, meshpeeringproto, sizeof(meshpeeringproto));
+	pos += 4;
 	memcpy(pos, &llid, 2);
 	if (include_plid) {
 		pos += 2;
@@ -419,12 +420,13 @@ void mesh_rx_plink_frame(struct ieee80211_sub_if_data *sdata, struct ieee80211_m
 		return;
 	}
 
-	ftype = *((u8 *)PLINK_GET_FRAME_SUBTYPE(elems.peer_link));
+	ftype = mgmt->u.action.u.plink_action.action_code;
 	ie_len = elems.peer_link_len;
-	if ((ftype == PLINK_OPEN && ie_len != 3) ||
-	    (ftype == PLINK_CONFIRM && ie_len != 5) ||
-	    (ftype == PLINK_CLOSE && ie_len != 5 && ie_len != 7)) {
-		mpl_dbg("Mesh plink: incorrect plink ie length\n");
+	if ((ftype == PLINK_OPEN && ie_len != 6) ||
+	    (ftype == PLINK_CONFIRM && ie_len != 8) ||
+	    (ftype == PLINK_CLOSE && ie_len != 8 && ie_len != 10)) {
+		mpl_dbg("Mesh plink: incorrect plink ie length %d %d\n",
+		    ftype, ie_len);
 		return;
 	}
 
@@ -436,7 +438,7 @@ void mesh_rx_plink_frame(struct ieee80211_sub_if_data *sdata, struct ieee80211_m
 	 * from the point of view of this host.
 	 */
 	memcpy(&plid, PLINK_GET_LLID(elems.peer_link), 2);
-	if (ftype == PLINK_CONFIRM || (ftype == PLINK_CLOSE && ie_len == 7))
+	if (ftype == PLINK_CONFIRM || (ftype == PLINK_CLOSE && ie_len == 10))
 		memcpy(&llid, PLINK_GET_PLID(elems.peer_link), 2);
 
 	rcu_read_lock();
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index c06496f..2cddd02 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -507,7 +507,7 @@ ieee80211_rx_mesh_check(struct ieee80211_rx_data *rx)
 
 		if (ieee80211_is_action(hdr->frame_control)) {
 			mgmt = (struct ieee80211_mgmt *)hdr;
-			if (mgmt->u.action.category != PLINK_CATEGORY)
+			if (mgmt->u.action.category != MESH_PLINK_CATEGORY)
 				return RX_DROP_MONITOR;
 			return RX_CONTINUE;
 		}
-- 
1.5.6.5

