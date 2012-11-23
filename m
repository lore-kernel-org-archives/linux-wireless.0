Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nick.hrz.tu-chemnitz.de ([134.109.228.11]:40067 "EHLO
	nick.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756024Ab2KWUTX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Nov 2012 15:19:23 -0500
From: Marco Porsch <marco.porsch@etit.tu-chemnitz.de>
To: johannes@sipsolutions.net, javier@cozybit.com, thomas@cozybit.com
Cc: linux-wireless@vger.kernel.org,
	Marco Porsch <marco.porsch@etit.tu-chemnitz.de>
Subject: [RFCv2 08/13] mac80211: add power save support structure to mesh interface
Date: Fri, 23 Nov 2012 12:18:49 -0800
Message-Id: <1353701934-12752-9-git-send-email-marco.porsch@etit.tu-chemnitz.de> (sfid-20121123_211927_620630_582EC3B3)
In-Reply-To: <1353701934-12752-1-git-send-email-marco.porsch@etit.tu-chemnitz.de>
References: <1353701934-12752-1-git-send-email-marco.porsch@etit.tu-chemnitz.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This commit adds the ps_data structure to ieee80211_if_mesh. This structure
contains the TIM map, a counter how of PS neighbors and the actual
group-addressed frame buffer. Functions using this structure are modified
for mesh mode.

Signed-off-by: Marco Porsch <marco.porsch@etit.tu-chemnitz.de>
---
 net/mac80211/ieee80211_i.h |    1 +
 net/mac80211/mesh.c        |    7 +++++++
 net/mac80211/sta_info.c    |   15 +++++++++++++--
 net/mac80211/tx.c          |   10 ++++++++--
 4 files changed, 29 insertions(+), 4 deletions(-)

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
diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index 5f72739..c61bbc0 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -657,10 +657,16 @@ void ieee80211_stop_mesh(struct ieee80211_sub_if_data *sdata)
 	ifmsh->mesh_id_len = 0;
 	ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_BEACON_ENABLED);
 
+	/* free all potentially still buffered group-addressed frames */
+	local->total_ps_buffered -= skb_queue_len(&ifmsh->ps.bc_buf);
+	skb_queue_purge(&ifmsh->ps.bc_buf);
+
 	/* flush STAs and mpaths on this iface */
 	sta_info_flush(sdata->local, sdata);
 	mesh_path_flush_by_iface(sdata);
 
+	atomic_set(&ifmsh->ps.num_sta_ps, 0); /* not reset by sta_info_flush */
+
 	del_timer_sync(&sdata->u.mesh.housekeeping_timer);
 	del_timer_sync(&sdata->u.mesh.mesh_path_root_timer);
 	del_timer_sync(&sdata->u.mesh.mesh_path_timer);
@@ -839,4 +845,5 @@ void ieee80211_mesh_init_sdata(struct ieee80211_sub_if_data *sdata)
 	INIT_LIST_HEAD(&ifmsh->preq_queue.list);
 	spin_lock_init(&ifmsh->mesh_preq_queue_lock);
 	spin_lock_init(&ifmsh->sync_offset_lock);
+	skb_queue_head_init(&ifmsh->ps.bc_buf);
 }
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 09e350a..3fd3a5a 100644
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
 
@@ -564,6 +566,12 @@ void sta_info_recalc_tim(struct sta_info *sta)
 
 		ps = &sta->sdata->bss->ps;
 		id = sta->sta.aid;
+#ifdef CONFIG_MAC80211_MESH
+	} else if (sta->sdata->vif.type == NL80211_IFTYPE_MESH_POINT) {
+		ps = &sta->sdata->u.mesh.ps;
+		/* TIM map only for PLID <= IEEE80211_MAX_AID */
+		id = le16_to_cpu(sta->plid) % IEEE80211_MAX_AID;
+#endif
 	} else {
 		return;
 	}
@@ -722,8 +730,9 @@ static bool sta_info_cleanup_expire_buffered(struct ieee80211_local *local,
 	bool have_buffered = false;
 	int ac;
 
-	/* This is only necessary for stations on BSS interfaces */
-	if (!sta->sdata->bss)
+	/* This is only necessary for stations on BSS/MBSS interfaces */
+	if (!sta->sdata->bss &&
+	    !ieee80211_vif_is_mesh(&sta->sdata->vif))
 		return false;
 
 	for (ac = 0; ac < IEEE80211_NUM_ACS; ac++)
@@ -971,6 +980,8 @@ static void clear_sta_ps_flags(void *_sta)
 	if (sdata->vif.type == NL80211_IFTYPE_AP ||
 	    sdata->vif.type == NL80211_IFTYPE_AP_VLAN)
 		ps = &sdata->bss->ps;
+	else if (sdata->vif.type == NL80211_IFTYPE_MESH_POINT)
+		ps = &sdata->u.mesh.ps;
 	else
 		return;
 
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 70aa64f..88994dc 100644
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
@@ -2731,6 +2735,8 @@ ieee80211_get_buffered_bc(struct ieee80211_hw *hw,
 			goto out;
 
 		ps = &sdata->u.ap.ps;
+	} else if (sdata->vif.type == NL80211_IFTYPE_MESH_POINT) {
+		ps = &sdata->u.mesh.ps;
 	} else {
 		goto out;
 	}
-- 
1.7.9.5

