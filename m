Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f176.google.com ([209.85.213.176]:35324 "EHLO
	mail-ig0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751447AbbFETop (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Jun 2015 15:44:45 -0400
Received: by igbzc4 with SMTP id zc4so23719664igb.0
        for <linux-wireless@vger.kernel.org>; Fri, 05 Jun 2015 12:44:45 -0700 (PDT)
Message-ID: <5571FBFA.9060902@cococorp.com> (sfid-20150605_214449_177319_757996A5)
Date: Fri, 05 Jun 2015 12:43:54 -0700
From: Alexis Green <agreen@cococorp.com>
Reply-To: agreen@cococorp.com
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org, Jesse Jones <jjones@cococorp.com>
Subject: [PATCH] mac80211: Fix incorrectly named last_hop_metric variable
 in mesh_rx_path_sel_frame
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The last hop metric should refer to link cost (this is how
hwmp_route_info_get uses it for example). But in mesh_rx_path_sel_frame
we are not dealing with link cost but with the total cost to the origin
of a PREQ or PREP.

Signed-off-by: Alexis Green <agreen@cococorp.com>
CC: Jesse Jones <jjones@cococorp.com>

---

diff --git a/net/mac80211/mesh_hwmp.c b/net/mac80211/mesh_hwmp.c
index 214e63b..be33e41 100644
--- a/net/mac80211/mesh_hwmp.c
+++ b/net/mac80211/mesh_hwmp.c
@@ -854,7 +854,7 @@ void mesh_rx_path_sel_frame(struct ieee80211_sub_if_data *sdata,
 {
 	struct ieee802_11_elems elems;
 	size_t baselen;
-	u32 last_hop_metric;
+	u32 path_metric;
 	struct sta_info *sta;
 
 	/* need action_code */
@@ -877,21 +877,21 @@ void mesh_rx_path_sel_frame(struct ieee80211_sub_if_data *sdata,
 		if (elems.preq_len != 37)
 			/* Right now we support just 1 destination and no AE */
 			return;
-		last_hop_metric = hwmp_route_info_get(sdata, mgmt, elems.preq,
-						      MPATH_PREQ);
-		if (last_hop_metric)
+		path_metric = hwmp_route_info_get(sdata, mgmt, elems.preq,
+						  MPATH_PREQ);
+		if (path_metric)
 			hwmp_preq_frame_process(sdata, mgmt, elems.preq,
-						last_hop_metric);
+						path_metric);
 	}
 	if (elems.prep) {
 		if (elems.prep_len != 31)
 			/* Right now we support no AE */
 			return;
-		last_hop_metric = hwmp_route_info_get(sdata, mgmt, elems.prep,
-						      MPATH_PREP);
-		if (last_hop_metric)
+		path_metric = hwmp_route_info_get(sdata, mgmt, elems.prep,
+						  MPATH_PREP);
+		if (path_metric)
 			hwmp_prep_frame_process(sdata, mgmt, elems.prep,
-						last_hop_metric);
+						path_metric);
 	}
 	if (elems.perr) {
 		if (elems.perr_len != 15)
