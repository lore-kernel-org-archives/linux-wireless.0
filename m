Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-da0-f49.google.com ([209.85.210.49]:44130 "EHLO
	mail-da0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751462Ab3BCBD2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Feb 2013 20:03:28 -0500
Received: by mail-da0-f49.google.com with SMTP id v40so2188385dad.8
        for <linux-wireless@vger.kernel.org>; Sat, 02 Feb 2013 17:03:28 -0800 (PST)
From: Thomas Pedersen <thomas@cozybit.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, devel@lists.open80211s.org,
	Thomas Pedersen <thomas@cozybit.com>
Subject: [PATCH 1/3] mac80211: cache mesh beacon
Date: Sat,  2 Feb 2013 17:02:19 -0800
Message-Id: <1359853341-29237-2-git-send-email-thomas@cozybit.com> (sfid-20130203_020337_666867_3463F837)
In-Reply-To: <1359853341-29237-1-git-send-email-thomas@cozybit.com>
References: <1359853341-29237-1-git-send-email-thomas@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Previously, the entire mesh beacon would be generated each
time the beacon timer fired. Instead generate a beacon
head and tail (so the TIM can easily be inserted when mesh
power save is on) when starting a mesh or the MBSS
parameters change.

Signed-off-by: Thomas Pedersen <thomas@cozybit.com>
---
 net/mac80211/cfg.c         |    2 +
 net/mac80211/ieee80211_i.h |    1 +
 net/mac80211/mesh.c        |  136 +++++++++++++++++++++++++++++++++++++++++++-
 net/mac80211/mesh.h        |    3 +
 net/mac80211/mesh_plink.c  |    6 +-
 net/mac80211/tx.c          |   57 +++----------------
 6 files changed, 151 insertions(+), 54 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 661b878..f3ca170 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1777,6 +1777,8 @@ static int ieee80211_update_mesh_config(struct wiphy *wiphy,
 	if (_chg_mesh_attr(NL80211_MESHCONF_HWMP_CONFIRMATION_INTERVAL, mask))
 		conf->dot11MeshHWMPconfirmationInterval =
 			nconf->dot11MeshHWMPconfirmationInterval;
+	/* need to update the IEs as well */
+	ieee80211_mbss_info_change_notify(sdata, BSS_CHANGED_BEACON);
 	return 0;
 }
 
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index c9c66de..48efad8 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -581,6 +581,7 @@ struct ieee80211_if_mesh {
 	u32 mesh_seqnum;
 	bool accepting_plinks;
 	int num_gates;
+	struct beacon_data __rcu *beacon;
 	const u8 *ie;
 	u8 ie_len;
 	enum {
diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index f920da1..e08abc0 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -547,7 +547,7 @@ static void ieee80211_mesh_housekeeping(struct ieee80211_sub_if_data *sdata,
 	mesh_path_expire(sdata);
 
 	changed = mesh_accept_plinks_update(sdata);
-	ieee80211_bss_info_change_notify(sdata, changed);
+	ieee80211_mbss_info_change_notify(sdata, changed);
 
 	mod_timer(&ifmsh->housekeeping_timer,
 		  round_jiffies(jiffies + IEEE80211_MESH_HOUSEKEEPING_INTERVAL));
@@ -598,6 +598,136 @@ void ieee80211_mesh_restart(struct ieee80211_sub_if_data *sdata)
 }
 #endif
 
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
+	RCU_INIT_POINTER(ifmsh->beacon, NULL);
+	synchronize_rcu();
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
+	    mesh_add_ds_params_ie(skb, sdata)) {
+		mpl_dbg(sdata, "couldn't add beacon head IEs\n");
+		goto out_free;
+	}
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
+	    mesh_add_vendor_ies(skb, sdata)) {
+		mpl_dbg(sdata, "couldn't add beacon tail IEs!\n");
+		goto out_free;
+	}
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
+	sdata = container_of(ifmsh, struct ieee80211_sub_if_data, u.mesh);
+
+	rcu_read_lock();
+	kfree(rcu_dereference(ifmsh->beacon));
+	rcu_read_unlock();
+
+	if (WARN_ON(ieee80211_mesh_build_beacon(ifmsh))) {
+		mpl_dbg(sdata, "couldn't rebuild mesh beacon, stopping!\n");
+		ieee80211_stop_mesh(sdata);
+		return -1;
+	}
+	return 0;
+}
+
+int ieee80211_mbss_info_change_notify(struct ieee80211_sub_if_data *sdata,
+				       u32 changed)
+{
+	if (sdata->vif.bss_conf.enable_beacon &&
+	    (changed & (BSS_CHANGED_BEACON |
+			BSS_CHANGED_HT |
+			BSS_CHANGED_BASIC_RATES |
+			BSS_CHANGED_BEACON_INT)))
+		if (ieee80211_mesh_rebuild_beacon(&sdata->u.mesh))
+			return -1;
+	ieee80211_bss_info_change_notify(sdata, changed);
+	return 0;
+}
+
 void ieee80211_start_mesh(struct ieee80211_sub_if_data *sdata)
 {
 	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
@@ -629,7 +759,8 @@ void ieee80211_start_mesh(struct ieee80211_sub_if_data *sdata)
 	sdata->vif.bss_conf.basic_rates =
 		ieee80211_mandatory_rates(local, band);
 
-	ieee80211_bss_info_change_notify(sdata, changed);
+	if (ieee80211_mbss_info_change_notify(sdata, changed))
+		return;
 
 	netif_carrier_on(sdata->dev);
 }
@@ -646,6 +777,7 @@ void ieee80211_stop_mesh(struct ieee80211_sub_if_data *sdata)
 	sdata->vif.bss_conf.enable_beacon = false;
 	clear_bit(SDATA_STATE_OFFCHANNEL_BEACON_STOPPED, &sdata->state);
 	ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_BEACON_ENABLED);
+	kfree(ifmsh->beacon);
 
 	/* flush STAs and mpaths on this iface */
 	sta_info_flush(sdata);
diff --git a/net/mac80211/mesh.h b/net/mac80211/mesh.h
index aff3015..e6377ec 100644
--- a/net/mac80211/mesh.h
+++ b/net/mac80211/mesh.h
@@ -241,6 +241,9 @@ void ieee80211_start_mesh(struct ieee80211_sub_if_data *sdata);
 void ieee80211_stop_mesh(struct ieee80211_sub_if_data *sdata);
 void ieee80211_mesh_root_setup(struct ieee80211_if_mesh *ifmsh);
 const struct ieee80211_mesh_sync_ops *ieee80211_mesh_sync_ops_get(u8 method);
+/* wrapper for ieee80211_bss_info_change_notify() */
+int ieee80211_mbss_info_change_notify(struct ieee80211_sub_if_data *sdata,
+				      u32 changed);
 
 /* Mesh paths */
 int mesh_nexthop_lookup(struct sk_buff *skb,
diff --git a/net/mac80211/mesh_plink.c b/net/mac80211/mesh_plink.c
index 6787d69..4708170 100644
--- a/net/mac80211/mesh_plink.c
+++ b/net/mac80211/mesh_plink.c
@@ -224,7 +224,7 @@ void mesh_plink_deactivate(struct sta_info *sta)
 			    sta->reason);
 	spin_unlock_bh(&sta->lock);
 
-	ieee80211_bss_info_change_notify(sdata, changed);
+	ieee80211_mbss_info_change_notify(sdata, changed);
 }
 
 static int mesh_plink_frame_tx(struct ieee80211_sub_if_data *sdata,
@@ -647,7 +647,7 @@ void mesh_plink_block(struct sta_info *sta)
 	sta->plink_state = NL80211_PLINK_BLOCKED;
 	spin_unlock_bh(&sta->lock);
 
-	ieee80211_bss_info_change_notify(sdata, changed);
+	ieee80211_mbss_info_change_notify(sdata, changed);
 }
 
 
@@ -1065,5 +1065,5 @@ void mesh_rx_plink_frame(struct ieee80211_sub_if_data *sdata, struct ieee80211_m
 	rcu_read_unlock();
 
 	if (changed)
-		ieee80211_bss_info_change_notify(sdata, changed);
+		ieee80211_mbss_info_change_notify(sdata, changed);
 }
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index a2cb6a3..01dc001 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -2424,66 +2424,25 @@ struct sk_buff *ieee80211_beacon_get_tim(struct ieee80211_hw *hw,
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
-				    2 + (IEEE80211_MAX_SUPP_RATES - 8) +
-				    2 + sizeof(struct ieee80211_ht_cap) +
-				    2 + sizeof(struct ieee80211_ht_operation) +
-				    2 + sdata->u.mesh.mesh_id_len +
-				    2 + sizeof(struct ieee80211_meshconf_ie) +
-				    sdata->u.mesh.ie_len);
+				    bcn->head_len +
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
-		    ieee80211_add_ext_srates_ie(sdata, skb, true, band) ||
-		    mesh_add_rsn_ie(skb, sdata) ||
-		    mesh_add_ht_cap_ie(skb, sdata) ||
-		    mesh_add_ht_oper_ie(skb, sdata) ||
-		    mesh_add_meshid_ie(skb, sdata) ||
-		    mesh_add_meshconf_ie(skb, sdata) ||
-		    mesh_add_vendor_ies(skb, sdata)) {
-			pr_err("o11s: couldn't add ies!\n");
-			goto out;
-		}
+		skb_reserve(skb, local->tx_headroom);
+		memcpy(skb_put(skb, bcn->head_len), bcn->head, bcn->head_len);
+		/* TODO: add TIM */
+		memcpy(skb_put(skb, bcn->tail_len), bcn->tail, bcn->tail_len);
 	} else {
 		WARN_ON(1);
 		goto out;
-- 
1.7.10.4

