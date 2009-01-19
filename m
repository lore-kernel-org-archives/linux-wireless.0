Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.189]:8502 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758265AbZASL7E (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Jan 2009 06:59:04 -0500
Received: by nf-out-0910.google.com with SMTP id d3so405442nfc.21
        for <linux-wireless@vger.kernel.org>; Mon, 19 Jan 2009 03:59:01 -0800 (PST)
MIME-Version: 1.0
Date: Mon, 19 Jan 2009 13:50:43 +0200
Message-ID: <eb3ff54b0901190350w5ca5c3d0ocadbaa3c6cbac747@mail.gmail.com> (sfid-20090119_125907_592744_B9CD0CD6)
Subject: [PATCH 4/4] mac80211: use IEEE80211_IFSTA_MESH_CTR_INC macro to
	increment ttl.
From: Rami Rosen <ramirose@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net,
	luisca@cozybit.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch replaces decrementing ttl explicitly with the
IEEE80211_IFSTA_MESH_CTR_INC macro in mesh_hwmp.c


Signed-off-by: Rami Rosen <ramirose@gmail.com>

--
(wireless-testing)

diff --git a/net/mac80211/mesh_hwmp.c b/net/mac80211/mesh_hwmp.c
index 4f862b2..1828d80 100644
--- a/net/mac80211/mesh_hwmp.c
+++ b/net/mac80211/mesh_hwmp.c
@@ -507,7 +507,7 @@ static void hwmp_prep_frame_process(struct
ieee80211_sub_if_data *sdata,

 	ttl = PREP_IE_TTL(prep_elem);
 	if (ttl <= 1) {
-		sdata->u.mesh.mshstats.dropped_frames_ttl++;
+	IEEE80211_IFSTA_MESH_CTR_INC(&sdata->u.mesh,dropped_frames_ttl);
 		return;
 	}

@@ -735,7 +735,7 @@ void mesh_path_start_discovery(struct
ieee80211_sub_if_data *sdata)
 	lifetime = default_lifetime(sdata);
 	ttl = sdata->u.mesh.mshcfg.dot11MeshTTL;
 	if (ttl == 0) {
-		sdata->u.mesh.mshstats.dropped_frames_ttl++;
+		IEEE80211_IFSTA_MESH_CTR_INC(&sdata->u.mesh,dropped_frames_ttl);
 		spin_unlock_bh(&mpath->state_lock);
 		goto enddiscovery;
 	}
