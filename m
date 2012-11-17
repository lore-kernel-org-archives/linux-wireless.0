Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nick.hrz.tu-chemnitz.de ([134.109.228.11]:39742 "EHLO
	nick.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752411Ab2KQGsu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 Nov 2012 01:48:50 -0500
From: Marco Porsch <marco.porsch@etit.tu-chemnitz.de>
To: johannes@sipsolutions.net, javier@cozybit.com
Cc: linux-wireless@vger.kernel.org,
	Marco Porsch <marco.porsch@etit.tu-chemnitz.de>
Subject: [RFC 09/14] mac80211: add power save support structure to mesh interface
Date: Fri, 16 Nov 2012 22:48:01 -0800
Message-Id: <1353134886-13256-10-git-send-email-marco.porsch@etit.tu-chemnitz.de> (sfid-20121117_074902_785166_90C7FD72)
In-Reply-To: <1353134886-13256-1-git-send-email-marco.porsch@etit.tu-chemnitz.de>
References: <1353134886-13256-1-git-send-email-marco.porsch@etit.tu-chemnitz.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This commit adds the ps_data structure to ieee80211_if_mesh. This structure
contains the TIM map, a counter how of PS neighbors and the actual
group-addressed frame buffer. Functions using this structure are modified
for mesh mode.

Signed-off-by: Marco Porsch <marco.porsch@etit.tu-chemnitz.de>
---
 net/mac80211/ieee80211_i.h |    1 +
 net/mac80211/iface.c       |    3 +++
 net/mac80211/mesh.c        |    3 +++
 net/mac80211/rx.c          |    2 ++
 net/mac80211/sta_info.c    |   13 +++++++++++--
 net/mac80211/tx.c          |   10 ++++++++--
 6 files changed, 28 insertions(+), 4 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 0364844..eec4aac 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -622,6 +622,7 @@ struct ieee80211_if_mesh {
 	enum nl80211_mesh_power_mode nonpeer_ps_mode;
 	u8 ps_peers_light_sleep;
 	u8 ps_peers_deep_sleep;
+	struct ps_data ps;
 };
 
 #ifdef CONFIG_MAC80211_MESH
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index bc3e3e1..8396602 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -769,6 +769,9 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata,
 		/* free all potentially still buffered bcast frames */
 		local->total_ps_buffered -= skb_queue_len(&sdata->u.ap.ps.bc_buf);
 		skb_queue_purge(&sdata->u.ap.ps.bc_buf);
+	} else if (sdata->vif.type == NL80211_IFTYPE_MESH_POINT) {
+		local->total_ps_buffered -= skb_queue_len(&sdata->u.mesh.ps.bc_buf);
+		skb_queue_purge(&sdata->u.mesh.ps.bc_buf);
 	} else if (sdata->vif.type == NL80211_IFTYPE_STATION) {
 		ieee80211_mgd_stop(sdata);
 	}
diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index d4f2021..86f076e 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -639,6 +639,9 @@ void ieee80211_start_mesh(struct ieee80211_sub_if_data *sdata)
 		ieee80211_mandatory_rates(sdata->local,
 					  ieee80211_get_sdata_band(sdata));
 	ieee80211_local_ps_update(sdata);
+	/* reset in case we have been in a mesh with PS peers before */
+	atomic_set(&sdata->u.mesh.ps.num_sta_ps, 0);
+	skb_queue_head_init(&ifmsh->ps.bc_buf);
 	ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_BEACON |
 						BSS_CHANGED_BEACON_ENABLED |
 						BSS_CHANGED_HT |
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 90f2ce5..741810a 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1157,6 +1157,8 @@ static void sta_ps_start(struct sta_info *sta)
 	if (sta->sdata->vif.type == NL80211_IFTYPE_AP ||
 	    sta->sdata->vif.type == NL80211_IFTYPE_AP_VLAN)
 		ps = &sdata->bss->ps;
+	else if (sta->sdata->vif.type == NL80211_IFTYPE_MESH_POINT)
+		ps = &sdata->u.mesh.ps;
 	else
 		return;
 
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index f8513a7..4c312ed 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -111,6 +111,8 @@ static void free_sta_work(struct work_struct *wk)
 		if (sta->sdata->vif.type == NL80211_IFTYPE_AP ||
 		    sta->sdata->vif.type == NL80211_IFTYPE_AP_VLAN)
 			ps = &sdata->bss->ps;
+		else if (sta->sdata->vif.type == NL80211_IFTYPE_MESH_POINT)
+			ps = &sdata->u.mesh.ps;
 		else
 			return;
 
@@ -562,6 +564,10 @@ void sta_info_recalc_tim(struct sta_info *sta)
 
 		ps = &sta->sdata->bss->ps;
 		id = sta->sta.aid;
+	} else if (sta->sdata->vif.type == NL80211_IFTYPE_MESH_POINT) {
+		ps = &sta->sdata->u.mesh.ps;
+		/* TIM map only for AID <= IEEE80211_MAX_AID */
+		id = le16_to_cpu(sta->plid) % IEEE80211_MAX_AID;
 	} else {
 		return;
 	}
@@ -720,8 +726,9 @@ static bool sta_info_cleanup_expire_buffered(struct ieee80211_local *local,
 	bool have_buffered = false;
 	int ac;
 
-	/* This is only necessary for stations on BSS interfaces */
-	if (!sta->sdata->bss)
+	/* This is only necessary for stations on BSS/MBSS interfaces */
+	if (!sta->sdata->bss &&
+	    !ieee80211_vif_is_mesh(&sta->sdata->vif))
 		return false;
 
 	for (ac = 0; ac < IEEE80211_NUM_ACS; ac++)
@@ -969,6 +976,8 @@ static void clear_sta_ps_flags(void *_sta)
 	if (sdata->vif.type == NL80211_IFTYPE_AP ||
 	    sdata->vif.type == NL80211_IFTYPE_AP_VLAN)
 		ps = &sdata->bss->ps;
+	else if (sdata->vif.type == NL80211_IFTYPE_MESH_POINT)
+		ps = &sdata->u.mesh.ps;
 	else
 		return;
 
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 5c38532..0ef5708 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -329,6 +329,8 @@ static void purge_old_ps_buffers(struct ieee80211_local *local)
 
 		if (sdata->vif.type == NL80211_IFTYPE_AP)
 			ps = &sdata->u.ap.ps;
+		else if (sdata->vif.type == NL80211_IFTYPE_MESH_POINT)
+			ps = &sdata->u.mesh.ps;
 		else
 			continue;
 
@@ -372,18 +374,20 @@ ieee80211_tx_h_multicast_ps_buf(struct ieee80211_tx_data *tx)
 	/*
 	 * broadcast/multicast frame
 	 *
-	 * If any of the associated stations is in power save mode,
+	 * If any of the associated/peer stations is in power save mode,
 	 * the frame is buffered to be sent after DTIM beacon frame.
 	 * This is done either by the hardware or us.
 	 */
 
-	/* powersaving STAs currently only in AP/VLAN mode */
+	/* powersaving STAs currently only in AP/VLAN/mesh mode */
 	if (tx->sdata->vif.type == NL80211_IFTYPE_AP ||
 	    tx->sdata->vif.type == NL80211_IFTYPE_AP_VLAN) {
 		if (!tx->sdata->bss)
 			return TX_CONTINUE;
 
 		ps = &tx->sdata->bss->ps;
+	} else if (tx->sdata->vif.type == NL80211_IFTYPE_MESH_POINT) {
+		ps = &tx->sdata->u.mesh.ps;
 	} else {
 		return TX_CONTINUE;
 	}
@@ -2732,6 +2736,8 @@ ieee80211_get_buffered_bc(struct ieee80211_hw *hw,
 			goto out;
 
 		ps = &sdata->u.ap.ps;
+	} else if (sdata->vif.type == NL80211_IFTYPE_MESH_POINT) {
+		ps = &sdata->u.mesh.ps;
 	} else {
 		goto out;
 	}
-- 
1.7.9.5

