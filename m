Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nick.hrz.tu-chemnitz.de ([134.109.228.11]:40074 "EHLO
	nick.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756071Ab2KWUTZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Nov 2012 15:19:25 -0500
From: Marco Porsch <marco.porsch@etit.tu-chemnitz.de>
To: johannes@sipsolutions.net, javier@cozybit.com, thomas@cozybit.com
Cc: linux-wireless@vger.kernel.org,
	Marco Porsch <marco.porsch@etit.tu-chemnitz.de>
Subject: [RFCv2 09/13] mac80211: enable frame buffering for PS STA
Date: Fri, 23 Nov 2012 12:18:50 -0800
Message-Id: <1353701934-12752-10-git-send-email-marco.porsch@etit.tu-chemnitz.de> (sfid-20121123_211928_801052_A0711C42)
In-Reply-To: <1353701934-12752-1-git-send-email-marco.porsch@etit.tu-chemnitz.de>
References: <1353701934-12752-1-git-send-email-marco.porsch@etit.tu-chemnitz.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In case of a neighbor changing its power mode or peering status, call
ieee80211_mesh_sta_ps_update to set or clear the WLAN_STA_PS flag. This
triggers the frame buffering routines for individually-addressed frames in the
tx path used for client mode, which are re-used here.
Also the num_sta_ps counter is updated, which will trigger the buffering
and release of group-addressed frames after DTIM beacons.

Until drivers are adapted for mesh power save, do not inform the driver about
the neighbor STA being in PS mode towards us (as sta_ps_start would do).

Signed-off-by: Marco Porsch <marco.porsch@etit.tu-chemnitz.de>
---
 net/mac80211/mesh.h       |    1 +
 net/mac80211/mesh_plink.c |    3 +++
 net/mac80211/mesh_ps.c    |   42 ++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 46 insertions(+)

diff --git a/net/mac80211/mesh.h b/net/mac80211/mesh.h
index 2b6aee7..62ca646 100644
--- a/net/mac80211/mesh.h
+++ b/net/mac80211/mesh.h
@@ -250,6 +250,7 @@ void ieee80211_sta_mesh_local_ps_mode_timer(unsigned long data);
 void ieee80211_set_mesh_ps_flags(struct ieee80211_sub_if_data *sdata,
 				 struct sta_info *sta,
 				 struct ieee80211_hdr *hdr);
+void ieee80211_mesh_sta_ps_update(struct sta_info *sta);
 void ieee80211_set_peer_ps_mode(struct sta_info *sta,
 				struct ieee80211_hdr *hdr);
 void ieee80211_set_nonpeer_ps_mode(struct sta_info *sta,
diff --git a/net/mac80211/mesh_plink.c b/net/mac80211/mesh_plink.c
index 19994e7..0572346 100644
--- a/net/mac80211/mesh_plink.c
+++ b/net/mac80211/mesh_plink.c
@@ -179,6 +179,7 @@ static u32 __mesh_plink_deactivate(struct sta_info *sta)
 	sta->plink_state = NL80211_PLINK_BLOCKED;
 	mesh_path_flush_by_nexthop(sta);
 
+	ieee80211_mesh_sta_ps_update(sta);
 	ieee80211_mesh_local_ps_update(sdata);
 
 	return changed;
@@ -878,6 +879,7 @@ void mesh_rx_plink_frame(struct ieee80211_sub_if_data *sdata, struct ieee80211_m
 			mpl_dbg(sdata, "Mesh plink with %pM ESTABLISHED\n",
 				sta->sta.addr);
 
+			ieee80211_mesh_sta_ps_update(sta);
 			ieee80211_set_sta_mesh_local_ps_mode(sta,
 					mshcfg->power_mode, 100);
 			break;
@@ -918,6 +920,7 @@ void mesh_rx_plink_frame(struct ieee80211_sub_if_data *sdata, struct ieee80211_m
 			mesh_plink_frame_tx(sdata,
 					    WLAN_SP_MESH_PEERING_CONFIRM,
 					    sta->sta.addr, llid, plid, 0);
+			ieee80211_mesh_sta_ps_update(sta);
 			/*
 			 * we need some delay here, otherwise
 			 * the announcement Null would arrive before the CONFIRM
diff --git a/net/mac80211/mesh_ps.c b/net/mac80211/mesh_ps.c
index 2d00aea..ee72f3e 100644
--- a/net/mac80211/mesh_ps.c
+++ b/net/mac80211/mesh_ps.c
@@ -235,6 +235,44 @@ void ieee80211_set_mesh_ps_flags(struct ieee80211_sub_if_data *sdata,
 }
 
 /**
+ * ieee80211_mesh_sta_ps_update - update the buffering status for neighbor STA
+ *
+ * @sta: mesh STA
+ *
+ * called after change of peering status or non-peer/peer-specific power mode
+ */
+void ieee80211_mesh_sta_ps_update(struct sta_info *sta)
+{
+	enum nl80211_mesh_power_mode pm;
+	bool do_buffer;
+
+	/*
+	 * use peer-specific power mode if peering is established and
+	 * the peer's power mode is known
+	 */
+	if (sta->plink_state == NL80211_PLINK_ESTAB &&
+	    sta->peer_ps_mode != NL80211_MESH_POWER_UNKNOWN)
+		pm = sta->peer_ps_mode;
+	else
+		pm = sta->nonpeer_ps_mode;
+
+	do_buffer = (pm != NL80211_MESH_POWER_ACTIVE);
+
+	/* Don't let the same PS state be set twice */
+	if (test_sta_flag(sta, WLAN_STA_PS_STA) == do_buffer)
+		return;
+
+	if (do_buffer) {
+		set_sta_flag(sta, WLAN_STA_PS_STA);
+		atomic_inc(&sta->sdata->u.mesh.ps.num_sta_ps);
+		mps_dbg(sta->sdata, "start PS buffering frames towards %pM\n",
+			sta->sta.addr);
+	} else {
+		ieee80211_sta_ps_deliver_wakeup(sta);
+	}
+}
+
+/**
  * ieee80211_set_peer_ps_mode - track the link-specific power mode of peers
  *
  * @sta: STA info to update
@@ -275,6 +313,8 @@ void ieee80211_set_peer_ps_mode(struct sta_info *sta,
 		sta->sta.addr, pm);
 
 	sta->peer_ps_mode = pm;
+
+	ieee80211_mesh_sta_ps_update(sta);
 }
 
 /**
@@ -300,4 +340,6 @@ void ieee80211_set_nonpeer_ps_mode(struct sta_info *sta,
 		sta->sta.addr, pm);
 
 	sta->nonpeer_ps_mode = pm;
+
+	ieee80211_mesh_sta_ps_update(sta);
 }
-- 
1.7.9.5

