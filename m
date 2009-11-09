Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.24]:19838 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755680AbZKIXrW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Nov 2009 18:47:22 -0500
Received: by ey-out-2122.google.com with SMTP id 4so87855eyf.19
        for <linux-wireless@vger.kernel.org>; Mon, 09 Nov 2009 15:47:27 -0800 (PST)
From: Rui Paulo <rpaulo@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>,
	Rui Paulo <rpaulo@gmail.com>,
	Javier Cardona <javier@cozybit.com>
Subject: [PATCH v2 09/20] mac80211: improve HWMP debugging
Date: Mon,  9 Nov 2009 23:46:47 +0000
Message-Id: <1257810418-30075-10-git-send-email-rpaulo@gmail.com>
In-Reply-To: <1257810418-30075-1-git-send-email-rpaulo@gmail.com>
References: <1257810418-30075-1-git-send-email-rpaulo@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Rui Paulo <rpaulo@gmail.com>
Signed-off-by: Javier Cardona <javier@cozybit.com>
Reviewed-by: Andrey Yurovsky <andrey@cozybit.com>
Tested-by: Brian Cavagnolo <brian@cozybit.com>
---
 net/mac80211/mesh_hwmp.c |   11 +++++------
 1 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/net/mac80211/mesh_hwmp.c b/net/mac80211/mesh_hwmp.c
index e67e812..db1a330 100644
--- a/net/mac80211/mesh_hwmp.c
+++ b/net/mac80211/mesh_hwmp.c
@@ -115,13 +115,13 @@ static int mesh_path_sel_frame_tx(enum mpath_frame_type action, u8 flags,
 
 	switch (action) {
 	case MPATH_PREQ:
-		mhwmp_dbg("sending PREQ\n");
+		mhwmp_dbg("sending PREQ to %pM\n", dst);
 		ie_len = 37;
 		pos = skb_put(skb, 2 + ie_len);
 		*pos++ = WLAN_EID_PREQ;
 		break;
 	case MPATH_PREP:
-		mhwmp_dbg("sending PREP\n");
+		mhwmp_dbg("sending PREP to %pM\n", dst);
 		ie_len = 31;
 		pos = skb_put(skb, 2 + ie_len);
 		*pos++ = WLAN_EID_PREP;
@@ -439,7 +439,7 @@ static void hwmp_preq_frame_process(struct ieee80211_sub_if_data *sdata,
 	orig_dsn = PREQ_IE_ORIG_DSN(preq_elem);
 	dst_flags = PREQ_IE_DST_F(preq_elem);
 
-	mhwmp_dbg("received PREQ\n");
+	mhwmp_dbg("received PREQ from %pM\n", orig_addr);
 
 	if (memcmp(dst_addr, sdata->dev->dev_addr, ETH_ALEN) == 0) {
 		mhwmp_dbg("PREQ is for us\n");
@@ -498,7 +498,7 @@ static void hwmp_preq_frame_process(struct ieee80211_sub_if_data *sdata,
 			ifmsh->mshstats.dropped_frames_ttl++;
 			return;
 		}
-		mhwmp_dbg("forwarding the PREQ\n");
+		mhwmp_dbg("forwarding the PREQ from %pM\n", orig_addr);
 		--ttl;
 		flags = PREQ_IE_FLAGS(preq_elem);
 		preq_id = PREQ_IE_PREQ_ID(preq_elem);
@@ -525,7 +525,7 @@ static void hwmp_prep_frame_process(struct ieee80211_sub_if_data *sdata,
 	u8 next_hop[ETH_ALEN];
 	u32 dst_dsn, orig_dsn, lifetime;
 
-	mhwmp_dbg("received PREP\n");
+	mhwmp_dbg("received PREP from %pM\n", PREP_IE_ORIG_ADDR(prep_elem));
 
 	/* Note that we divert from the draft nomenclature and denominate
 	 * destination to what the draft refers to as origininator. So in this
@@ -628,7 +628,6 @@ void mesh_rx_path_sel_frame(struct ieee80211_sub_if_data *sdata,
 	ieee802_11_parse_elems(mgmt->u.action.u.mesh_action.variable,
 			len - baselen, &elems);
 
-	mhwmp_dbg("RX path selection frame\n");
 	if (elems.preq) {
 		if (elems.preq_len != 37)
 			/* Right now we support just 1 destination and no AE */
-- 
1.5.6.5

