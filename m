Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-da0-f46.google.com ([209.85.210.46]:44515 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753764Ab2JUCDQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 20 Oct 2012 22:03:16 -0400
Received: by mail-da0-f46.google.com with SMTP id n41so814760dak.19
        for <linux-wireless@vger.kernel.org>; Sat, 20 Oct 2012 19:03:16 -0700 (PDT)
From: Thomas Pedersen <thomas@cozybit.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Thomas Pedersen <thomas@cozybit.com>
Subject: [PATCH] mac80211: mesh STAs only process mesh beacons
Date: Sat, 20 Oct 2012 19:03:10 -0700
Message-Id: <1350784990-14242-1-git-send-email-thomas@cozybit.com> (sfid-20121021_040320_486970_F18D8FC0)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Before, a mesh STA would execute some code on behalf of AP or IBSS
beacons. Since the mesh stack currently does not consider anything but
other mesh STAs interesting, limit processing to just these and save a
little overhead.

Signed-off-by: Thomas Pedersen <thomas@cozybit.com>
---
 net/mac80211/mesh.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index c1e6a5c..41c2d26 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -681,8 +681,12 @@ static void ieee80211_mesh_rx_bcn_presp(struct ieee80211_sub_if_data *sdata,
 	ieee802_11_parse_elems(mgmt->u.probe_resp.variable, len - baselen,
 			       &elems);
 
-	/* ignore beacons from secure mesh peers if our security is off */
-	if (elems.rsn_len && sdata->u.mesh.security == IEEE80211_MESH_SEC_NONE)
+	/* ignore non-mesh or secure / unsecure mismatch */
+	if ((!elems.mesh_id || !elems.mesh_config) ||
+	    (elems.rsn &&
+	     sdata->u.mesh.security == IEEE80211_MESH_SEC_NONE) ||
+	    (!elems.rsn &&
+	     sdata->u.mesh.security != IEEE80211_MESH_SEC_NONE))
 		return;
 
 	if (elems.ds_params && elems.ds_params_len == 1)
@@ -695,8 +699,7 @@ static void ieee80211_mesh_rx_bcn_presp(struct ieee80211_sub_if_data *sdata,
 	if (!channel || channel->flags & IEEE80211_CHAN_DISABLED)
 		return;
 
-	if (elems.mesh_id && elems.mesh_config &&
-	    mesh_matches_local(sdata, &elems))
+	if (mesh_matches_local(sdata, &elems))
 		mesh_neighbour_update(sdata, mgmt->sa, &elems);
 
 	if (ifmsh->sync_ops)
-- 
1.7.9.5

