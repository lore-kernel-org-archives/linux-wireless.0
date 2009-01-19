Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.24]:4420 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757919AbZASLua (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Jan 2009 06:50:30 -0500
Received: by ey-out-2122.google.com with SMTP id 22so496562eye.37
        for <linux-wireless@vger.kernel.org>; Mon, 19 Jan 2009 03:50:27 -0800 (PST)
MIME-Version: 1.0
Date: Mon, 19 Jan 2009 13:50:27 +0200
Message-ID: <eb3ff54b0901190350p1ac95afdpdb0c937a66c6c00e@mail.gmail.com> (sfid-20090119_125032_898289_CAF7EAA4)
Subject: [PATCH 1/4] mac80211: remove mesh_plink_close() method.
From: Rami Rosen <ramirose@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net,
	luisca@cozybit.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes mesh_plink_close() method as it is unused.

Signed-off-by: Rami Rosen <ramirose@gmail.com>

--
(wireless-testing)

diff --git a/net/mac80211/mesh.h b/net/mac80211/mesh.h
index c197ab5..c5b0b58 100644
--- a/net/mac80211/mesh.h
+++ b/net/mac80211/mesh.h
@@ -243,7 +243,6 @@ void mesh_accept_plinks_update(struct
ieee80211_sub_if_data *sdata);
 void mesh_plink_broken(struct sta_info *sta);
 void mesh_plink_deactivate(struct sta_info *sta);
 int mesh_plink_open(struct sta_info *sta);
-int mesh_plink_close(struct sta_info *sta);
 void mesh_plink_block(struct sta_info *sta);
 void mesh_rx_plink_frame(struct ieee80211_sub_if_data *sdata,
 			 struct ieee80211_mgmt *mgmt, size_t len,
diff --git a/net/mac80211/mesh_plink.c b/net/mac80211/mesh_plink.c
index 8a6c02b..c140a1b 100644
--- a/net/mac80211/mesh_plink.c
+++ b/net/mac80211/mesh_plink.c
@@ -361,36 +361,6 @@ void mesh_plink_block(struct sta_info *sta)
 	spin_unlock_bh(&sta->lock);
 }

-int mesh_plink_close(struct sta_info *sta)
-{
-	struct ieee80211_sub_if_data *sdata = sta->sdata;
-	__le16 llid, plid, reason;
-
-	mpl_dbg("Mesh plink: closing link with %pM\n", sta->sta.addr);
-	spin_lock_bh(&sta->lock);
-	sta->reason = cpu_to_le16(MESH_LINK_CANCELLED);
-	reason = sta->reason;
-
-	if (sta->plink_state == PLINK_LISTEN ||
-	    sta->plink_state == PLINK_BLOCKED) {
-		mesh_plink_fsm_restart(sta);
-		spin_unlock_bh(&sta->lock);
-		return 0;
-	} else if (sta->plink_state == PLINK_ESTAB) {
-		__mesh_plink_deactivate(sta);
-		/* The timer should not be running */
-		mod_plink_timer(sta, dot11MeshHoldingTimeout(sdata));
-	} else if (!mod_plink_timer(sta, dot11MeshHoldingTimeout(sdata)))
-		sta->ignore_plink_timer = true;
-
-	sta->plink_state = PLINK_HOLDING;
-	llid = sta->llid;
-	plid = sta->plid;
-	spin_unlock_bh(&sta->lock);
-	mesh_plink_frame_tx(sta->sdata, PLINK_CLOSE, sta->sta.addr, llid,
-			    plid, reason);
-	return 0;
-}

 void mesh_rx_plink_frame(struct ieee80211_sub_if_data *sdata, struct
ieee80211_mgmt *mgmt,
 			 size_t len, struct ieee80211_rx_status *rx_status)
