Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f43.google.com ([209.85.220.43]:61501 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934815Ab3BNTVc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Feb 2013 14:21:32 -0500
Received: by mail-pa0-f43.google.com with SMTP id bh2so1404461pad.2
        for <linux-wireless@vger.kernel.org>; Thu, 14 Feb 2013 11:21:31 -0800 (PST)
From: Thomas Pedersen <thomas@cozybit.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, devel@lists.open80211s.org,
	Thomas Pedersen <thomas@cozybit.com>
Subject: [PATCH v3 1/2] mac80211: cache mesh beacon
Date: Thu, 14 Feb 2013 11:20:13 -0800
Message-Id: <1360869614-29297-1-git-send-email-thomas@cozybit.com> (sfid-20130214_202141_028195_022B4077)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Previously, the entire mesh beacon would be generated each
time the beacon timer fired. Instead generate a beacon
head and tail (so the TIM can easily be inserted when mesh
power save is on) when starting a mesh or the MBSS
parameters change.

Also add a mutex for protecting beacon updates and
preventing leaks.

Signed-off-by: Thomas Pedersen <thomas@cozybit.com>
---

v2:
	less verbose, fix RCU usage (Johannes)
	protect beacon updates (Johannes)

v3:
	don't drop ieee80211_mps_set_frame_flags (Marco)
	fix sparse RCU warnings (Johannes)
	propagate mesh start failure reason (Johannes)

 net/mac80211/cfg.c         |    9 +--
 net/mac80211/ieee80211_i.h |    3 +
 net/mac80211/mesh.c        |  153 +++++++++++++++++++++++++++++++++++++++++++-
 net/mac80211/mesh.h        |    5 +-
 net/mac80211/mesh_plink.c  |    4 +-
 net/mac80211/tx.c          |   61 +++---------------
 6 files changed, 170 insertions(+), 65 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index c3869ba..0800fb3 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1800,11 +1800,10 @@ static int ieee80211_update_mesh_config(struct wiphy *wiphy,
 		conf->power_mode = nconf->power_mode;
 		ieee80211_mps_local_status_update(sdata);
 	}
-	if (_chg_mesh_attr(NL80211_MESHCONF_AWAKE_WINDOW, mask)) {
+	if (_chg_mesh_attr(NL80211_MESHCONF_AWAKE_WINDOW, mask))
 		conf->dot11MeshAwakeWindowDuration =
 			nconf->dot11MeshAwakeWindowDuration;
-		ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_BEACON);
-	}
+	ieee80211_mbss_info_change_notify(sdata, BSS_CHANGED_BEACON);
 	return 0;
 }
 
@@ -1830,9 +1829,7 @@ static int ieee80211_join_mesh(struct wiphy *wiphy, struct net_device *dev,
 	if (err)
 		return err;
 
-	ieee80211_start_mesh(sdata);
-
-	return 0;
+	return ieee80211_start_mesh(sdata);
 }
 
 static int ieee80211_leave_mesh(struct wiphy *wiphy, struct net_device *dev)
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index d702f7d..388580a 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -580,6 +580,9 @@ struct ieee80211_if_mesh {
 	u32 mesh_seqnum;
 	bool accepting_plinks;
 	int num_gates;
+	struct beacon_data __rcu *beacon;
+	/* just protects beacon updates for now */
+	struct mutex mtx;
 	const u8 *ie;
 	u8 ie_len;
 	enum {
diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index 0adec3d..2eee2f1 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -171,7 +171,7 @@ void mesh_sta_cleanup(struct sta_info *sta)
 	}
 
 	if (changed)
-		ieee80211_bss_info_change_notify(sdata, changed);
+		ieee80211_mbss_info_change_notify(sdata, changed);
 }
 
 int mesh_rmc_init(struct ieee80211_sub_if_data *sdata)
@@ -593,7 +593,7 @@ static void ieee80211_mesh_housekeeping(struct ieee80211_sub_if_data *sdata,
 	mesh_path_expire(sdata);
 
 	changed = mesh_accept_plinks_update(sdata);
-	ieee80211_bss_info_change_notify(sdata, changed);
+	ieee80211_mbss_info_change_notify(sdata, changed);
 
 	mod_timer(&ifmsh->housekeeping_timer,
 		  round_jiffies(jiffies + IEEE80211_MESH_HOUSEKEEPING_INTERVAL));
@@ -644,7 +644,140 @@ void ieee80211_mesh_restart(struct ieee80211_sub_if_data *sdata)
 }
 #endif
 
-void ieee80211_start_mesh(struct ieee80211_sub_if_data *sdata)
+static int
+ieee80211_mesh_build_beacon(struct ieee80211_if_mesh *ifmsh)
+{
+	struct beacon_data *bcn;
+	int head_len, tail_len;
+	struct sk_buff *skb;
+	struct ieee80211_mgmt *mgmt;
+	struct ieee80211_chanctx_conf *chanctx_conf;
+	enum ieee80211_band band;
+	u8 *pos;
+	struct ieee80211_sub_if_data *sdata;
+	int hdr_len = offsetof(struct ieee80211_mgmt, u.beacon) +
+		      sizeof(mgmt->u.beacon);
+
+	sdata = container_of(ifmsh, struct ieee80211_sub_if_data, u.mesh);
+	rcu_read_lock();
+	chanctx_conf = rcu_dereference(sdata->vif.chanctx_conf);
+	band = chanctx_conf->def.chan->band;
+	rcu_read_unlock();
+
+	head_len = hdr_len +
+		   2 + /* NULL SSID */
+		   2 + 8 + /* supported rates */
+		   2 + 3; /* DS params */
+	tail_len = 2 + (IEEE80211_MAX_SUPP_RATES - 8) +
+		   2 + sizeof(struct ieee80211_ht_cap) +
+		   2 + sizeof(struct ieee80211_ht_operation) +
+		   2 + ifmsh->mesh_id_len +
+		   2 + sizeof(struct ieee80211_meshconf_ie) +
+		   2 + sizeof(__le16) + /* awake window */
+		   ifmsh->ie_len;
+
+	bcn = kzalloc(sizeof(*bcn) + head_len + tail_len, GFP_KERNEL);
+	/* need an skb for IE builders to operate on */
+	skb = dev_alloc_skb(max(head_len, tail_len));
+
+	if (!bcn || !skb)
+		goto out_free;
+
+	/*
+	 * pointers go into the block we allocated,
+	 * memory is | beacon_data | head | tail |
+	 */
+	bcn->head = ((u8 *) bcn) + sizeof(*bcn);
+
+	/* fill in the head */
+	mgmt = (struct ieee80211_mgmt *) skb_put(skb, hdr_len);
+	memset(mgmt, 0, hdr_len);
+	mgmt->frame_control = cpu_to_le16(IEEE80211_FTYPE_MGMT |
+					  IEEE80211_STYPE_BEACON);
+	eth_broadcast_addr(mgmt->da);
+	memcpy(mgmt->sa, sdata->vif.addr, ETH_ALEN);
+	memcpy(mgmt->bssid, sdata->vif.addr, ETH_ALEN);
+	ieee80211_mps_set_frame_flags(sdata, NULL, (void *) mgmt);
+	mgmt->u.beacon.beacon_int =
+		cpu_to_le16(sdata->vif.bss_conf.beacon_int);
+	mgmt->u.beacon.capab_info |= cpu_to_le16(
+		sdata->u.mesh.security ? WLAN_CAPABILITY_PRIVACY : 0);
+
+	pos = skb_put(skb, 2);
+	*pos++ = WLAN_EID_SSID;
+	*pos++ = 0x0;
+
+	if (ieee80211_add_srates_ie(sdata, skb, true, band) ||
+	    mesh_add_ds_params_ie(skb, sdata))
+		goto out_free;
+
+	bcn->head_len = skb->len;
+	memcpy(bcn->head, skb->data, bcn->head_len);
+
+	/* now the tail */
+	skb_trim(skb, 0);
+	bcn->tail = bcn->head + bcn->head_len;
+
+	if (ieee80211_add_ext_srates_ie(sdata, skb, true, band) ||
+	    mesh_add_rsn_ie(skb, sdata) ||
+	    mesh_add_ht_cap_ie(skb, sdata) ||
+	    mesh_add_ht_oper_ie(skb, sdata) ||
+	    mesh_add_meshid_ie(skb, sdata) ||
+	    mesh_add_meshconf_ie(skb, sdata) ||
+	    mesh_add_awake_window_ie(skb, sdata) ||
+	    mesh_add_vendor_ies(skb, sdata))
+		goto out_free;
+
+	bcn->tail_len = skb->len;
+	memcpy(bcn->tail, skb->data, bcn->tail_len);
+
+	dev_kfree_skb(skb);
+	rcu_assign_pointer(ifmsh->beacon, bcn);
+	return 0;
+out_free:
+	kfree(bcn);
+	dev_kfree_skb(skb);
+	return -ENOMEM;
+}
+
+static int
+ieee80211_mesh_rebuild_beacon(struct ieee80211_if_mesh *ifmsh)
+{
+	struct ieee80211_sub_if_data *sdata;
+	struct beacon_data *old_bcn;
+	int ret;
+	sdata = container_of(ifmsh, struct ieee80211_sub_if_data, u.mesh);
+
+	mutex_lock(&ifmsh->mtx);
+
+	old_bcn = rcu_dereference_protected(ifmsh->beacon,
+					    lockdep_is_held(&ifmsh->mtx));
+	ret = ieee80211_mesh_build_beacon(ifmsh);
+	if (ret)
+		/* just reuse old beacon */
+		goto out;
+
+	if (old_bcn)
+		kfree_rcu(old_bcn, rcu_head);
+out:
+	mutex_unlock(&ifmsh->mtx);
+	return ret;
+}
+
+void ieee80211_mbss_info_change_notify(struct ieee80211_sub_if_data *sdata,
+				       u32 changed)
+{
+	if (sdata->vif.bss_conf.enable_beacon &&
+	    (changed & (BSS_CHANGED_BEACON |
+			BSS_CHANGED_HT |
+			BSS_CHANGED_BASIC_RATES |
+			BSS_CHANGED_BEACON_INT)))
+		if (ieee80211_mesh_rebuild_beacon(&sdata->u.mesh))
+			return;
+	ieee80211_bss_info_change_notify(sdata, changed);
+}
+
+int ieee80211_start_mesh(struct ieee80211_sub_if_data *sdata)
 {
 	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
 	struct ieee80211_local *local = sdata->local;
@@ -677,9 +810,15 @@ void ieee80211_start_mesh(struct ieee80211_sub_if_data *sdata)
 
 	changed |= ieee80211_mps_local_status_update(sdata);
 
+	if (ieee80211_mesh_build_beacon(ifmsh)) {
+		ieee80211_stop_mesh(sdata);
+		return -ENOMEM;
+	}
+
 	ieee80211_bss_info_change_notify(sdata, changed);
 
 	netif_carrier_on(sdata->dev);
+	return 0;
 }
 
 void ieee80211_stop_mesh(struct ieee80211_sub_if_data *sdata)
@@ -694,6 +833,12 @@ void ieee80211_stop_mesh(struct ieee80211_sub_if_data *sdata)
 	sdata->vif.bss_conf.enable_beacon = false;
 	clear_bit(SDATA_STATE_OFFCHANNEL_BEACON_STOPPED, &sdata->state);
 	ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_BEACON_ENABLED);
+	mutex_lock(&ifmsh->mtx);
+	kfree_rcu(rcu_dereference_protected(ifmsh->beacon,
+					    lockdep_is_held(&ifmsh->mtx)),
+		  rcu_head);
+	rcu_assign_pointer(ifmsh->beacon, NULL);
+	mutex_unlock(&ifmsh->mtx);
 
 	/* flush STAs and mpaths on this iface */
 	sta_info_flush(sdata);
@@ -883,6 +1028,8 @@ void ieee80211_mesh_init_sdata(struct ieee80211_sub_if_data *sdata)
 	skb_queue_head_init(&ifmsh->ps.bc_buf);
 	spin_lock_init(&ifmsh->mesh_preq_queue_lock);
 	spin_lock_init(&ifmsh->sync_offset_lock);
+	RCU_INIT_POINTER(ifmsh->beacon, NULL);
+	mutex_init(&ifmsh->mtx);
 
 	sdata->vif.bss_conf.bssid = zero_addr;
 }
diff --git a/net/mac80211/mesh.h b/net/mac80211/mesh.h
index a1bad31..1a1da87 100644
--- a/net/mac80211/mesh.h
+++ b/net/mac80211/mesh.h
@@ -239,10 +239,13 @@ void ieee80211s_update_metric(struct ieee80211_local *local,
 		struct sta_info *sta, struct sk_buff *skb);
 void ieee80211s_stop(void);
 void ieee80211_mesh_init_sdata(struct ieee80211_sub_if_data *sdata);
-void ieee80211_start_mesh(struct ieee80211_sub_if_data *sdata);
+int ieee80211_start_mesh(struct ieee80211_sub_if_data *sdata);
 void ieee80211_stop_mesh(struct ieee80211_sub_if_data *sdata);
 void ieee80211_mesh_root_setup(struct ieee80211_if_mesh *ifmsh);
 const struct ieee80211_mesh_sync_ops *ieee80211_mesh_sync_ops_get(u8 method);
+/* wrapper for ieee80211_bss_info_change_notify() */
+void ieee80211_mbss_info_change_notify(struct ieee80211_sub_if_data *sdata,
+				       u32 changed);
 
 /* mesh power save */
 u32 ieee80211_mps_local_status_update(struct ieee80211_sub_if_data *sdata);
diff --git a/net/mac80211/mesh_plink.c b/net/mac80211/mesh_plink.c
index 7765139..f7526e5 100644
--- a/net/mac80211/mesh_plink.c
+++ b/net/mac80211/mesh_plink.c
@@ -508,7 +508,7 @@ void mesh_neighbour_update(struct ieee80211_sub_if_data *sdata,
 	ieee80211_mps_frame_release(sta, elems);
 out:
 	rcu_read_unlock();
-	ieee80211_bss_info_change_notify(sdata, changed);
+	ieee80211_mbss_info_change_notify(sdata, changed);
 }
 
 static void mesh_plink_timer(unsigned long data)
@@ -1090,5 +1090,5 @@ void mesh_rx_plink_frame(struct ieee80211_sub_if_data *sdata, struct ieee80211_m
 	rcu_read_unlock();
 
 	if (changed)
-		ieee80211_bss_info_change_notify(sdata, changed);
+		ieee80211_mbss_info_change_notify(sdata, changed);
 }
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 7d8c629..fe644f9 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -2444,71 +2444,26 @@ struct sk_buff *ieee80211_beacon_get_tim(struct ieee80211_hw *hw,
 		hdr->frame_control = cpu_to_le16(IEEE80211_FTYPE_MGMT |
 						 IEEE80211_STYPE_BEACON);
 	} else if (ieee80211_vif_is_mesh(&sdata->vif)) {
-		struct ieee80211_mgmt *mgmt;
 		struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
-		u8 *pos;
-		int hdr_len = offsetof(struct ieee80211_mgmt, u.beacon) +
-			      sizeof(mgmt->u.beacon);
+		struct beacon_data *bcn = rcu_dereference(ifmsh->beacon);
 
-#ifdef CONFIG_MAC80211_MESH
-		if (!sdata->u.mesh.mesh_id_len)
+		if (!bcn)
 			goto out;
-#endif
 
 		if (ifmsh->sync_ops)
 			ifmsh->sync_ops->adjust_tbtt(
 						sdata);
 
 		skb = dev_alloc_skb(local->tx_headroom +
-				    hdr_len +
-				    2 + /* NULL SSID */
-				    2 + 8 + /* supported rates */
-				    2 + 3 + /* DS params */
+				    bcn->head_len +
 				    256 + /* TIM IE */
-				    2 + (IEEE80211_MAX_SUPP_RATES - 8) +
-				    2 + sizeof(struct ieee80211_ht_cap) +
-				    2 + sizeof(struct ieee80211_ht_operation) +
-				    2 + sdata->u.mesh.mesh_id_len +
-				    2 + sizeof(struct ieee80211_meshconf_ie) +
-				    sdata->u.mesh.ie_len +
-				    2 + sizeof(__le16)); /* awake window */
+				    bcn->tail_len);
 		if (!skb)
 			goto out;
-
-		skb_reserve(skb, local->hw.extra_tx_headroom);
-		mgmt = (struct ieee80211_mgmt *) skb_put(skb, hdr_len);
-		memset(mgmt, 0, hdr_len);
-		mgmt->frame_control =
-		    cpu_to_le16(IEEE80211_FTYPE_MGMT | IEEE80211_STYPE_BEACON);
-		eth_broadcast_addr(mgmt->da);
-		memcpy(mgmt->sa, sdata->vif.addr, ETH_ALEN);
-		memcpy(mgmt->bssid, sdata->vif.addr, ETH_ALEN);
-		ieee80211_mps_set_frame_flags(sdata, NULL, (void *) mgmt);
-		mgmt->u.beacon.beacon_int =
-			cpu_to_le16(sdata->vif.bss_conf.beacon_int);
-		mgmt->u.beacon.capab_info |= cpu_to_le16(
-			sdata->u.mesh.security ? WLAN_CAPABILITY_PRIVACY : 0);
-
-		pos = skb_put(skb, 2);
-		*pos++ = WLAN_EID_SSID;
-		*pos++ = 0x0;
-
-		band = chanctx_conf->def.chan->band;
-
-		if (ieee80211_add_srates_ie(sdata, skb, true, band) ||
-		    mesh_add_ds_params_ie(skb, sdata) ||
-		    ieee80211_beacon_add_tim(sdata, &ifmsh->ps, skb) ||
-		    ieee80211_add_ext_srates_ie(sdata, skb, true, band) ||
-		    mesh_add_rsn_ie(skb, sdata) ||
-		    mesh_add_ht_cap_ie(skb, sdata) ||
-		    mesh_add_ht_oper_ie(skb, sdata) ||
-		    mesh_add_meshid_ie(skb, sdata) ||
-		    mesh_add_meshconf_ie(skb, sdata) ||
-		    mesh_add_awake_window_ie(skb, sdata) ||
-		    mesh_add_vendor_ies(skb, sdata)) {
-			pr_err("o11s: couldn't add ies!\n");
-			goto out;
-		}
+		skb_reserve(skb, local->tx_headroom);
+		memcpy(skb_put(skb, bcn->head_len), bcn->head, bcn->head_len);
+		ieee80211_beacon_add_tim(sdata, &ifmsh->ps, skb);
+		memcpy(skb_put(skb, bcn->tail_len), bcn->tail, bcn->tail_len);
 	} else {
 		WARN_ON(1);
 		goto out;
-- 
1.7.10.4

