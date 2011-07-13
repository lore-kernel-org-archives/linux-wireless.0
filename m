Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:46304 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752882Ab1GMXqI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jul 2011 19:46:08 -0400
Received: by mail-iy0-f174.google.com with SMTP id 12so5995000iyb.19
        for <linux-wireless@vger.kernel.org>; Wed, 13 Jul 2011 16:46:08 -0700 (PDT)
From: Thomas Pedersen <thomas@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, linville@tuxdriver.com,
	Thomas Pedersen <thomas@cozybit.com>
Subject: [PATCH 1/5] mac80211: give if_mesh a beacon
Date: Wed, 13 Jul 2011 16:45:43 -0700
Message-Id: <1310600747-9583-2-git-send-email-thomas@cozybit.com> (sfid-20110714_014612_422614_13D30599)
In-Reply-To: <1310600747-9583-1-git-send-email-thomas@cozybit.com>
References: <1310600747-9583-1-git-send-email-thomas@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Maintain a mesh beacon in the mesh interface like the AP interface does.
This will save us some work later when Probe Responses are implemented.

Based on Javier Cardona's "mac80211: Support beacon configuration via
nl80211 for mesh interfaces", which never made it upstream.

Signed-off-by: Thomas Pedersen <thomas@cozybit.com>
---
 net/mac80211/cfg.c         |   31 +++++++++++++++++++++++------
 net/mac80211/ieee80211_i.h |    1 +
 net/mac80211/mesh.c        |   44 +++++++++++++++++++++++++++++++++++++++++++
 net/mac80211/tx.c          |   45 ++++++++++++++++++-------------------------
 4 files changed, 88 insertions(+), 33 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index bfc36e9..639c287 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -466,7 +466,10 @@ static int ieee80211_config_beacon(struct ieee80211_sub_if_data *sdata,
 	int size;
 	int err = -EINVAL;
 
-	old = rtnl_dereference(sdata->u.ap.beacon);
+	if (ieee80211_vif_is_mesh(&sdata->vif))
+		old = rtnl_dereference(sdata->u.mesh.beacon);
+	else
+		old = rtnl_dereference(sdata->u.ap.beacon);
 
 	/* head must not be zero-length */
 	if (params->head && !params->head_len)
@@ -542,8 +545,10 @@ static int ieee80211_config_beacon(struct ieee80211_sub_if_data *sdata,
 
 	sdata->vif.bss_conf.dtim_period = new->dtim_period;
 
-	rcu_assign_pointer(sdata->u.ap.beacon, new);
-
+	if (ieee80211_vif_is_mesh(&sdata->vif))
+		rcu_assign_pointer(sdata->u.mesh.beacon, new);
+	else
+		rcu_assign_pointer(sdata->u.ap.beacon, new);
 	synchronize_rcu();
 
 	kfree(old);
@@ -561,7 +566,10 @@ static int ieee80211_add_beacon(struct wiphy *wiphy, struct net_device *dev,
 
 	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 
-	old = rtnl_dereference(sdata->u.ap.beacon);
+	if (ieee80211_vif_is_mesh(&sdata->vif))
+		old = rtnl_dereference(sdata->u.mesh.beacon);
+	else
+		old = rtnl_dereference(sdata->u.ap.beacon);
 	if (old)
 		return -EALREADY;
 
@@ -576,7 +584,10 @@ static int ieee80211_set_beacon(struct wiphy *wiphy, struct net_device *dev,
 
 	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 
-	old = rtnl_dereference(sdata->u.ap.beacon);
+	if (ieee80211_vif_is_mesh(&sdata->vif))
+		old = rtnl_dereference(sdata->u.mesh.beacon);
+	else
+		old = rtnl_dereference(sdata->u.ap.beacon);
 	if (!old)
 		return -ENOENT;
 
@@ -590,11 +601,17 @@ static int ieee80211_del_beacon(struct wiphy *wiphy, struct net_device *dev)
 
 	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 
-	old = rtnl_dereference(sdata->u.ap.beacon);
+	if (ieee80211_vif_is_mesh(&sdata->vif))
+		old = rtnl_dereference(sdata->u.mesh.beacon);
+	else
+		old = rtnl_dereference(sdata->u.ap.beacon);
 	if (!old)
 		return -ENOENT;
 
-	rcu_assign_pointer(sdata->u.ap.beacon, NULL);
+	if (ieee80211_vif_is_mesh(&sdata->vif))
+		rcu_assign_pointer(sdata->u.mesh.beacon, NULL);
+	else
+		rcu_assign_pointer(sdata->u.ap.beacon, NULL);
 	synchronize_rcu();
 	kfree(old);
 
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index dda0d1a..2d726b7 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -519,6 +519,7 @@ struct ieee80211_if_mesh {
 		IEEE80211_MESH_SEC_AUTHED = 0x1,
 		IEEE80211_MESH_SEC_SECURED = 0x2,
 	} security;
+	struct beacon_data *beacon;
 };
 
 #ifdef CONFIG_MAC80211_MESH
diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index 29e9980..60fd958 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -11,6 +11,7 @@
 #include <linux/slab.h>
 #include <asm/unaligned.h>
 #include "ieee80211_i.h"
+#include "cfg.h"
 #include "mesh.h"
 
 #define IEEE80211_MESH_PEER_INACTIVITY_LIMIT (1800 * HZ)
@@ -461,6 +462,9 @@ void ieee80211_start_mesh(struct ieee80211_sub_if_data *sdata)
 {
 	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
 	struct ieee80211_local *local = sdata->local;
+	struct ieee80211_mgmt *bcn_head;
+	struct beacon_parameters bcn_params;
+	u8 *pos;
 
 	local->fif_other_bss++;
 	/* mesh ifaces must set allmulti to forward mcast traffic */
@@ -473,7 +477,44 @@ void ieee80211_start_mesh(struct ieee80211_sub_if_data *sdata)
 	set_bit(MESH_WORK_HOUSEKEEPING, &ifmsh->wrkq_flags);
 	ieee80211_mesh_root_setup(ifmsh);
 	ieee80211_queue_work(&local->hw, &sdata->work);
+
+	/* Build fixed part of mesh beacon. */
+	memset(&bcn_params, 0, sizeof(struct beacon_parameters));
+
+	/* header + fixed fields + null ssid */
+	bcn_params.head_len = 24 + sizeof(bcn_head->u.beacon) + 2;
+	pos = kmalloc(bcn_params.head_len, GFP_KERNEL | __GFP_ZERO);
+	if (pos == NULL) {
+		printk(KERN_ERR "Unable to allocate mesh beacon\n");
+		return;
+	}
+
+	/* Header */
+	bcn_head = (struct ieee80211_mgmt *) pos;
+	bcn_head->frame_control =
+		cpu_to_le16(IEEE80211_FTYPE_MGMT | IEEE80211_STYPE_BEACON);
+	memset(bcn_head->da, 0xff, ETH_ALEN);
+	memcpy(bcn_head->sa, sdata->vif.addr, ETH_ALEN);
+	memcpy(bcn_head->bssid, sdata->vif.addr, ETH_ALEN);
+
+	/* Default beacon interval and capabilities */
+	bcn_head->u.beacon.beacon_int = MESH_DEFAULT_BEACON_INTERVAL;
+	bcn_head->u.beacon.capab_info = 0x0; /* 0x0 for MPs */
+
+	/* Mesh uses null SSID */
+	pos += 24 + sizeof(bcn_head->u.beacon);
+	*pos++ = WLAN_EID_SSID;
+	*pos++ = 0x0;
+
+	bcn_params.head = (char *) bcn_head;
+	bcn_params.dtim_period = 1;	/* unused for now */
+
+	if (mac80211_config_ops.add_beacon(sdata->wdev.wiphy, sdata->dev,
+				&bcn_params))
+		printk(KERN_ERR "Unable to configure mesh beacon\n");
+
 	sdata->vif.bss_conf.beacon_int = MESH_DEFAULT_BEACON_INTERVAL;
+	sdata->vif.bss_conf.enable_beacon = 1;
 	ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_BEACON |
 						BSS_CHANGED_BEACON_ENABLED |
 						BSS_CHANGED_BEACON_INT);
@@ -485,6 +526,7 @@ void ieee80211_stop_mesh(struct ieee80211_sub_if_data *sdata)
 	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
 
 	ifmsh->mesh_id_len = 0;
+	sdata->vif.bss_conf.enable_beacon = 0;
 	ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_BEACON_ENABLED);
 	sta_info_flush(local, NULL);
 
@@ -498,6 +540,8 @@ void ieee80211_stop_mesh(struct ieee80211_sub_if_data *sdata)
 	 * it no longer is.
 	 */
 	cancel_work_sync(&sdata->work);
+	if (sdata->u.mesh.beacon)
+		mac80211_config_ops.del_beacon(sdata->wdev.wiphy, sdata->dev);
 
 	local->fif_other_bss--;
 	atomic_dec(&local->iff_allmultis);
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 8cb0d2d..c406b13 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -2250,38 +2250,31 @@ struct sk_buff *ieee80211_beacon_get_tim(struct ieee80211_hw *hw,
 		hdr->frame_control = cpu_to_le16(IEEE80211_FTYPE_MGMT |
 						 IEEE80211_STYPE_BEACON);
 	} else if (ieee80211_vif_is_mesh(&sdata->vif)) {
-		struct ieee80211_mgmt *mgmt;
-		u8 *pos;
-
+		struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
 #ifdef CONFIG_MAC80211_MESH
 		if (!sdata->u.mesh.mesh_id_len)
 			goto out;
 #endif
+		beacon = rcu_dereference(ifmsh->beacon);
+		if (beacon) {
+			/* headroom, head length, tail length, mesh_ies and
+			 * maximum TIM length */
+			skb = dev_alloc_skb(local->tx_headroom +
+					    beacon->head_len +
+					    beacon->tail_len + 400);
+			if (!skb)
+				goto out;
 
-		/* headroom, head length, tail length and maximum TIM length */
-		skb = dev_alloc_skb(local->tx_headroom + 400 +
-				sdata->u.mesh.ie_len);
-		if (!skb)
-			goto out;
+			skb_reserve(skb, local->hw.extra_tx_headroom);
+			memcpy(skb_put(skb, beacon->head_len), beacon->head,
+			       beacon->head_len);
+
+			mesh_mgmt_ies_add(skb, sdata);
 
-		skb_reserve(skb, local->hw.extra_tx_headroom);
-		mgmt = (struct ieee80211_mgmt *)
-			skb_put(skb, 24 + sizeof(mgmt->u.beacon));
-		memset(mgmt, 0, 24 + sizeof(mgmt->u.beacon));
-		mgmt->frame_control =
-		    cpu_to_le16(IEEE80211_FTYPE_MGMT | IEEE80211_STYPE_BEACON);
-		memset(mgmt->da, 0xff, ETH_ALEN);
-		memcpy(mgmt->sa, sdata->vif.addr, ETH_ALEN);
-		memcpy(mgmt->bssid, sdata->vif.addr, ETH_ALEN);
-		mgmt->u.beacon.beacon_int =
-			cpu_to_le16(sdata->vif.bss_conf.beacon_int);
-		mgmt->u.beacon.capab_info = 0x0; /* 0x0 for MPs */
-
-		pos = skb_put(skb, 2);
-		*pos++ = WLAN_EID_SSID;
-		*pos++ = 0x0;
-
-		mesh_mgmt_ies_add(skb, sdata);
+			if (beacon->tail && beacon->tail_len)
+				memcpy(skb_put(skb, beacon->tail_len),
+				       beacon->tail, beacon->tail_len);
+		}
 	} else {
 		WARN_ON(1);
 		goto out;
-- 
1.7.6

