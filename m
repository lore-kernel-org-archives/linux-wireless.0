Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cora.hrz.tu-chemnitz.de ([134.109.228.40]:48694 "EHLO
	cora.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753172Ab2KQGsw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 Nov 2012 01:48:52 -0500
From: Marco Porsch <marco.porsch@etit.tu-chemnitz.de>
To: johannes@sipsolutions.net, javier@cozybit.com
Cc: linux-wireless@vger.kernel.org,
	Marco Porsch <marco.porsch@etit.tu-chemnitz.de>
Subject: [RFC 10/14] mac80211: enable frame buffering for PS STA
Date: Fri, 16 Nov 2012 22:48:02 -0800
Message-Id: <1353134886-13256-11-git-send-email-marco.porsch@etit.tu-chemnitz.de> (sfid-20121117_074909_903130_E4E230B0)
In-Reply-To: <1353134886-13256-1-git-send-email-marco.porsch@etit.tu-chemnitz.de>
References: <1353134886-13256-1-git-send-email-marco.porsch@etit.tu-chemnitz.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In case of a neighbor changing its power mode or peering status,
ieee80211_sta_ps_transition is called, which sets or clears the
WLAN_STA_PS flag. This triggers the frame buffering routines for
individually-addressed frames in the tx path used for client mode, which are
re-used here.
Also the num_sta_ps counter is updated, which will trigger the buffering
and release of group-addressed frames after DTIM beacons.

Until drivers are adapted for mesh power save, do not inform the driver about
the neighbor STA being in PS mode towards us.

Signed-off-by: Marco Porsch <marco.porsch@etit.tu-chemnitz.de>
---
 net/mac80211/mesh.h       |    1 +
 net/mac80211/mesh_plink.c |    3 +++
 net/mac80211/mesh_ps.c    |   34 ++++++++++++++++++++++++++++++++++
 net/mac80211/rx.c         |    6 ++++--
 4 files changed, 42 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/mesh.h b/net/mac80211/mesh.h
index 0e80ea7..a9406b6 100644
--- a/net/mac80211/mesh.h
+++ b/net/mac80211/mesh.h
@@ -264,6 +264,7 @@ void ieee80211_set_local_ps_mode(struct sta_info *sta,
 void ieee80211_set_mesh_ps_flags(struct ieee80211_sub_if_data *sdata,
 				 struct sta_info *sta,
 				 struct ieee80211_hdr *hdr);
+void ieee80211_sta_ps_update(struct sta_info *sta);
 void ieee80211_set_peer_ps_mode(struct sta_info *sta,
 				struct ieee80211_hdr *hdr);
 void ieee80211_set_nonpeer_ps_mode(struct sta_info *sta,
diff --git a/net/mac80211/mesh_plink.c b/net/mac80211/mesh_plink.c
index 795f8c7..74d4da5 100644
--- a/net/mac80211/mesh_plink.c
+++ b/net/mac80211/mesh_plink.c
@@ -186,6 +186,7 @@ static u32 __mesh_plink_deactivate(struct sta_info *sta)
 	sta->plink_state = NL80211_PLINK_BLOCKED;
 	mesh_path_flush_by_nexthop(sta);
 
+	ieee80211_sta_ps_update(sta);
 	ieee80211_local_ps_update(sdata);
 
 	return changed;
@@ -881,6 +882,7 @@ void mesh_rx_plink_frame(struct ieee80211_sub_if_data *sdata, struct ieee80211_m
 			mpl_dbg(sdata, "Mesh plink with %pM ESTABLISHED\n",
 				sta->sta.addr);
 
+			ieee80211_sta_ps_update(sta);
 			ieee80211_set_local_ps_mode(sta,
 						    default_ps_mode(sdata),
 						    100);
@@ -922,6 +924,7 @@ void mesh_rx_plink_frame(struct ieee80211_sub_if_data *sdata, struct ieee80211_m
 			mesh_plink_frame_tx(sdata,
 					    WLAN_SP_MESH_PEERING_CONFIRM,
 					    sta->sta.addr, llid, plid, 0);
+			ieee80211_sta_ps_update(sta);
 			/*
 			 * we need some delay here, otherwise
 			 * the announcement Null would arrive before the CONFIRM
diff --git a/net/mac80211/mesh_ps.c b/net/mac80211/mesh_ps.c
index 2d147d2..e98d80c 100644
--- a/net/mac80211/mesh_ps.c
+++ b/net/mac80211/mesh_ps.c
@@ -234,6 +234,36 @@ void ieee80211_set_mesh_ps_flags(struct ieee80211_sub_if_data *sdata,
 }
 
 /**
+ * ieee80211_sta_ps_update - update the buffering status for a neighbor STA
+ * after peering change or non-peer/peer-specific power mode change
+ *
+ * @sta: mesh STA
+ */
+void ieee80211_sta_ps_update(struct sta_info *sta)
+{
+	enum nl80211_mesh_power_mode pm;
+	bool do_buffer;
+
+	/*
+	 * use peer-specific power mode if peering is established and
+	 * the peer's power mode is known
+	 */
+	if (sta->plink_state == NL80211_PLINK_ESTAB &&
+	    (sta->peer_ps_mode == NL80211_MESH_POWER_ACTIVE ||
+	     sta->peer_ps_mode == NL80211_MESH_POWER_LIGHT_SLEEP ||
+	     sta->peer_ps_mode == NL80211_MESH_POWER_DEEP_SLEEP))
+		pm = sta->peer_ps_mode;
+	else
+		pm = sta->nonpeer_ps_mode;
+
+	do_buffer = (pm == NL80211_MESH_POWER_LIGHT_SLEEP ||
+		     pm == NL80211_MESH_POWER_DEEP_SLEEP);
+
+	/* enable frame buffering for powersave STA */
+	ieee80211_sta_ps_transition_ni(&sta->sta, do_buffer);
+}
+
+/**
  * ieee80211_set_peer_ps_mode - track the neighbor mesh STA's peer-specific
  * power mode towards the local STA
  *
@@ -280,6 +310,8 @@ void ieee80211_set_peer_ps_mode(struct sta_info *sta,
 		sta->sta.addr, modes[pm]);
 
 	sta->peer_ps_mode = pm;
+
+	ieee80211_sta_ps_update(sta);
 }
 
 /**
@@ -310,4 +342,6 @@ void ieee80211_set_nonpeer_ps_mode(struct sta_info *sta,
 		sta->sta.addr, modes[pm]);
 
 	sta->nonpeer_ps_mode = pm;
+
+	ieee80211_sta_ps_update(sta);
 }
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 741810a..d56889f 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1164,7 +1164,8 @@ static void sta_ps_start(struct sta_info *sta)
 
 	atomic_inc(&ps->num_sta_ps);
 	set_sta_flag(sta, WLAN_STA_PS_STA);
-	if (!(local->hw.flags & IEEE80211_HW_AP_LINK_PS))
+	if (!(local->hw.flags & IEEE80211_HW_AP_LINK_PS) &&
+	    !ieee80211_vif_is_mesh(&sta->sdata->vif))
 		drv_sta_notify(local, sdata, STA_NOTIFY_SLEEP, &sta->sta);
 	ps_dbg(sdata, "STA %pM aid %d enters power save mode\n",
 	       sta->sta.addr, sta->sta.aid);
@@ -1189,7 +1190,8 @@ int ieee80211_sta_ps_transition(struct ieee80211_sta *sta, bool start)
 	struct sta_info *sta_inf = container_of(sta, struct sta_info, sta);
 	bool in_ps;
 
-	WARN_ON(!(sta_inf->local->hw.flags & IEEE80211_HW_AP_LINK_PS));
+	WARN_ON(!(sta_inf->local->hw.flags & IEEE80211_HW_AP_LINK_PS) &&
+		!ieee80211_vif_is_mesh(&sta_inf->sdata->vif));
 
 	/* Don't let the same PS state be set twice */
 	in_ps = test_sta_flag(sta_inf, WLAN_STA_PS_STA);
-- 
1.7.9.5

