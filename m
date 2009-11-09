Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f228.google.com ([209.85.219.228]:47150 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754377AbZKIXrS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Nov 2009 18:47:18 -0500
Received: by mail-ew0-f228.google.com with SMTP id 28so3974559ewy.18
        for <linux-wireless@vger.kernel.org>; Mon, 09 Nov 2009 15:47:23 -0800 (PST)
From: Rui Paulo <rpaulo@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>,
	Rui Paulo <rpaulo@gmail.com>,
	Javier Cardona <rpaulo@cozybit.com>
Subject: [PATCH v2 08/20] mac80211: allow processing of more than one HWMP IE
Date: Mon,  9 Nov 2009 23:46:46 +0000
Message-Id: <1257810418-30075-9-git-send-email-rpaulo@gmail.com>
In-Reply-To: <1257810418-30075-1-git-send-email-rpaulo@gmail.com>
References: <1257810418-30075-1-git-send-email-rpaulo@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since the HWMP IEs are now all optional and the action code is fixed,
allow the HWMP code to find and process each IE on the path
selection action frames.

Signed-off-by: Rui Paulo <rpaulo@gmail.com>
Signed-off-by: Javier Cardona <rpaulo@cozybit.com>
Reviewed-by: Andrey Yurovsky <andrey@cozybit.com>
Tested-by: Brian Cavagnolo <brian@cozybit.com>
---
 net/mac80211/mesh_hwmp.c |   47 ++++++++++++++++++++++++---------------------
 1 files changed, 25 insertions(+), 22 deletions(-)

diff --git a/net/mac80211/mesh_hwmp.c b/net/mac80211/mesh_hwmp.c
index 6dbaec5..e67e812 100644
--- a/net/mac80211/mesh_hwmp.c
+++ b/net/mac80211/mesh_hwmp.c
@@ -192,7 +192,7 @@ int mesh_path_error_tx(u8 *dst, __le32 dst_dsn, u8 *ra,
 	memcpy(mgmt->sa, sdata->dev->dev_addr, ETH_ALEN);
 	/* BSSID is left zeroed, wildcard value */
 	mgmt->u.action.category = MESH_PATH_SEL_CATEGORY;
-	mgmt->u.action.u.mesh_action.action_code = MPATH_PERR;
+	mgmt->u.action.u.mesh_action.action_code = MESH_PATH_SEL_ACTION;
 	ie_len = 12;
 	pos = skb_put(skb, 2 + ie_len);
 	*pos++ = WLAN_EID_PERR;
@@ -277,7 +277,7 @@ static u32 airtime_link_metric_get(struct ieee80211_local *local,
  */
 static u32 hwmp_route_info_get(struct ieee80211_sub_if_data *sdata,
 			    struct ieee80211_mgmt *mgmt,
-			    u8 *hwmp_ie)
+			    u8 *hwmp_ie, enum mpath_frame_type action)
 {
 	struct ieee80211_local *local = sdata->local;
 	struct mesh_path *mpath;
@@ -288,7 +288,6 @@ static u32 hwmp_route_info_get(struct ieee80211_sub_if_data *sdata,
 	unsigned long orig_lifetime, exp_time;
 	u32 last_hop_metric, new_metric;
 	bool process = true;
-	u8 action = mgmt->u.action.u.mesh_action.action_code;
 
 	rcu_read_lock();
 	sta = sta_info_get(local, mgmt->sa);
@@ -443,6 +442,7 @@ static void hwmp_preq_frame_process(struct ieee80211_sub_if_data *sdata,
 	mhwmp_dbg("received PREQ\n");
 
 	if (memcmp(dst_addr, sdata->dev->dev_addr, ETH_ALEN) == 0) {
+		mhwmp_dbg("PREQ is for us\n");
 		forward = false;
 		reply = true;
 		metric = 0;
@@ -498,6 +498,7 @@ static void hwmp_preq_frame_process(struct ieee80211_sub_if_data *sdata,
 			ifmsh->mshstats.dropped_frames_ttl++;
 			return;
 		}
+		mhwmp_dbg("forwarding the PREQ\n");
 		--ttl;
 		flags = PREQ_IE_FLAGS(preq_elem);
 		preq_id = PREQ_IE_PREQ_ID(preq_elem);
@@ -524,6 +525,8 @@ static void hwmp_prep_frame_process(struct ieee80211_sub_if_data *sdata,
 	u8 next_hop[ETH_ALEN];
 	u32 dst_dsn, orig_dsn, lifetime;
 
+	mhwmp_dbg("received PREP\n");
+
 	/* Note that we divert from the draft nomenclature and denominate
 	 * destination to what the draft refers to as origininator. So in this
 	 * function destnation refers to the final destination of the PREP,
@@ -625,32 +628,32 @@ void mesh_rx_path_sel_frame(struct ieee80211_sub_if_data *sdata,
 	ieee802_11_parse_elems(mgmt->u.action.u.mesh_action.variable,
 			len - baselen, &elems);
 
-	switch (mgmt->u.action.u.mesh_action.action_code) {
-	case MPATH_PREQ:
-		if (!elems.preq || elems.preq_len != 37)
+	mhwmp_dbg("RX path selection frame\n");
+	if (elems.preq) {
+		if (elems.preq_len != 37)
 			/* Right now we support just 1 destination and no AE */
 			return;
-		last_hop_metric = hwmp_route_info_get(sdata, mgmt, elems.preq);
-		if (!last_hop_metric)
-			return;
-		hwmp_preq_frame_process(sdata, mgmt, elems.preq, last_hop_metric);
-		break;
-	case MPATH_PREP:
-		if (!elems.prep || elems.prep_len != 31)
+		last_hop_metric = hwmp_route_info_get(sdata, mgmt, elems.preq,
+						      MPATH_PREQ);
+		if (last_hop_metric)
+			hwmp_preq_frame_process(sdata, mgmt, elems.preq,
+						last_hop_metric);
+	}
+	if (elems.prep) {
+		if (elems.prep_len != 31)
 			/* Right now we support no AE */
 			return;
-		last_hop_metric = hwmp_route_info_get(sdata, mgmt, elems.prep);
-		if (!last_hop_metric)
-			return;
-		hwmp_prep_frame_process(sdata, mgmt, elems.prep, last_hop_metric);
-		break;
-	case MPATH_PERR:
-		if (!elems.perr || elems.perr_len != 12)
+		last_hop_metric = hwmp_route_info_get(sdata, mgmt, elems.prep,
+						      MPATH_PREP);
+		if (last_hop_metric)
+			hwmp_prep_frame_process(sdata, mgmt, elems.prep,
+						last_hop_metric);
+	}
+	if (elems.perr) {
+		if (elems.perr_len != 12)
 			/* Right now we support only one destination per PERR */
 			return;
 		hwmp_perr_frame_process(sdata, mgmt, elems.perr);
-	default:
-		return;
 	}
 
 }
-- 
1.5.6.5

