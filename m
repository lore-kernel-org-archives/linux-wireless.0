Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:50599 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754354Ab0LAB7L (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Nov 2010 20:59:11 -0500
Received: by mail-gw0-f46.google.com with SMTP id 20so3124942gwj.19
        for <linux-wireless@vger.kernel.org>; Tue, 30 Nov 2010 17:59:11 -0800 (PST)
From: Javier Cardona <javier@cozybit.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Javier Cardona <javier@cozybit.com>,
	Steve Derosier <steve@cozybit.com>, devel@lists.open80211s.org,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: [PATCH] mac80211: Support beacon configuration via nl80211 for mesh interfaces
Date: Tue, 30 Nov 2010 17:58:55 -0800
Message-Id: <1291168735-3423-1-git-send-email-javier@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds the capability to the mesh stack to receive vendor
specific information elements from userspace.  When a vendor specific
IE is set via nl80211, the mesh stack will configure the mesh beacon to
advertise that a vendor specific path selection and metric is in use.
This is accordance with the Extensible Path Selection Framework
specified in version 7.0 of the 802.11s draft.

Signed-off-by: Javier Cardona <javier@cozybit.com>
---
 net/mac80211/cfg.c         |   23 +++++++++++++++-----
 net/mac80211/ieee80211_i.h |    1 +
 net/mac80211/main.c        |    7 ++++++
 net/mac80211/mesh.c        |   49 ++++++++++++++++++++++++++++++++++++++++++-
 net/mac80211/mesh.h        |   24 +++++++++++++++++++++
 net/mac80211/tx.c          |   39 +++++++++++++---------------------
 net/wireless/nl80211.c     |    2 +
 7 files changed, 113 insertions(+), 32 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index db134b5..97fbff1 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -438,7 +438,9 @@ static int ieee80211_config_beacon(struct ieee80211_sub_if_data *sdata,
 	int size;
 	int err = -EINVAL;
 
-	old = sdata->u.ap.beacon;
+
+	old = ieee80211_vif_is_mesh(&sdata->vif) ?
+		sdata->u.mesh.beacon : sdata->u.ap.beacon;
 
 	/* head must not be zero-length */
 	if (params->head && !params->head_len)
@@ -514,7 +516,10 @@ static int ieee80211_config_beacon(struct ieee80211_sub_if_data *sdata,
 
 	sdata->vif.bss_conf.dtim_period = new->dtim_period;
 
-	rcu_assign_pointer(sdata->u.ap.beacon, new);
+	if (ieee80211_vif_is_mesh(&sdata->vif))
+		rcu_assign_pointer(sdata->u.mesh.beacon, new);
+	else
+		rcu_assign_pointer(sdata->u.ap.beacon, new);
 
 	synchronize_rcu();
 
@@ -533,7 +538,8 @@ static int ieee80211_add_beacon(struct wiphy *wiphy, struct net_device *dev,
 
 	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 
-	old = sdata->u.ap.beacon;
+	old = ieee80211_vif_is_mesh(&sdata->vif) ?
+		sdata->u.mesh.beacon : sdata->u.ap.beacon;
 
 	if (old)
 		return -EALREADY;
@@ -549,7 +555,8 @@ static int ieee80211_set_beacon(struct wiphy *wiphy, struct net_device *dev,
 
 	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 
-	old = sdata->u.ap.beacon;
+	old = ieee80211_vif_is_mesh(&sdata->vif) ?
+		sdata->u.mesh.beacon : sdata->u.ap.beacon;
 
 	if (!old)
 		return -ENOENT;
@@ -564,12 +571,16 @@ static int ieee80211_del_beacon(struct wiphy *wiphy, struct net_device *dev)
 
 	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 
-	old = sdata->u.ap.beacon;
+	old = ieee80211_vif_is_mesh(&sdata->vif) ?
+		sdata->u.mesh.beacon : sdata->u.ap.beacon;
 
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
index 66b0b52..b4c7a4f 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -454,6 +454,7 @@ struct ieee80211_if_mesh {
 
 	unsigned long wrkq_flags;
 
+	struct beacon_data *beacon;
 	u8 mesh_id[IEEE80211_MAX_MESH_ID_LEN];
 	size_t mesh_id_len;
 	/* Active Path Selection Protocol Identifier */
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 107a0cb..b953efe 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -208,6 +208,13 @@ void ieee80211_bss_info_change_notify(struct ieee80211_sub_if_data *sdata,
 		sdata->vif.bss_conf.bssid = NULL;
 	else if (ieee80211_vif_is_mesh(&sdata->vif)) {
 		sdata->vif.bss_conf.bssid = zero;
+		if (sdata->u.mesh.beacon && sdata->u.mesh.beacon->tail_len) {
+			sdata->u.mesh.mesh_pp_id = MESH_PATH_PROTOCOL_VENDOR;
+			sdata->u.mesh.mesh_pm_id = MESH_PATH_METRIC_VENDOR;
+		} else {
+			sdata->u.mesh.mesh_pp_id = MESH_PATH_PROTOCOL_HWMP;
+			sdata->u.mesh.mesh_pm_id = MESH_PATH_METRIC_AIRTIME;
+		}
 	} else {
 		WARN_ON(1);
 		return;
diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index c8a4f19..5e06d60 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -11,6 +11,7 @@
 #include <linux/slab.h>
 #include <asm/unaligned.h>
 #include "ieee80211_i.h"
+#include "cfg.h"
 #include "mesh.h"
 
 #define IEEE80211_MESH_PEER_INACTIVITY_LIMIT (1800 * HZ)
@@ -126,8 +127,8 @@ void mesh_accept_plinks_update(struct ieee80211_sub_if_data *sdata)
 
 void mesh_ids_set_default(struct ieee80211_if_mesh *sta)
 {
-	sta->mesh_pp_id = 0;	/* HWMP */
-	sta->mesh_pm_id = 0;	/* Airtime */
+	sta->mesh_pp_id = MESH_PATH_PROTOCOL_HWMP;
+	sta->mesh_pm_id = MESH_PATH_METRIC_AIRTIME;
 	sta->mesh_cc_id = 0;	/* Disabled */
 	sta->mesh_sp_id = 0;	/* Neighbor Offset */
 	sta->mesh_auth_id = 0;	/* Disabled */
@@ -512,11 +513,51 @@ void ieee80211_start_mesh(struct ieee80211_sub_if_data *sdata)
 {
 	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
 	struct ieee80211_local *local = sdata->local;
+	struct ieee80211_mgmt *bcn_head;
+	struct beacon_parameters bcn_params;
+	char *pos;
 
 	set_bit(MESH_WORK_HOUSEKEEPING, &ifmsh->wrkq_flags);
 	ieee80211_mesh_root_setup(ifmsh);
 	ieee80211_queue_work(&local->hw, &sdata->work);
+
+	/* Configure here the fixed part of the mesh beacon. */
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
@@ -524,6 +565,8 @@ void ieee80211_start_mesh(struct ieee80211_sub_if_data *sdata)
 
 void ieee80211_stop_mesh(struct ieee80211_sub_if_data *sdata)
 {
+	sdata->vif.bss_conf.enable_beacon = 0;
+	ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_BEACON_ENABLED);
 	del_timer_sync(&sdata->u.mesh.housekeeping_timer);
 	del_timer_sync(&sdata->u.mesh.mesh_path_root_timer);
 	/*
@@ -534,6 +577,8 @@ void ieee80211_stop_mesh(struct ieee80211_sub_if_data *sdata)
 	 * it no longer is.
 	 */
 	cancel_work_sync(&sdata->work);
+	if (sdata->u.mesh.beacon)
+		mac80211_config_ops.del_beacon(sdata->wdev.wiphy, sdata->dev);
 }
 
 static void ieee80211_mesh_rx_bcn_presp(struct ieee80211_sub_if_data *sdata,
diff --git a/net/mac80211/mesh.h b/net/mac80211/mesh.h
index 58e7411..eccf4c3 100644
--- a/net/mac80211/mesh.h
+++ b/net/mac80211/mesh.h
@@ -44,6 +44,30 @@ enum mesh_path_flags {
 };
 
 /**
+ * enum - mesh path selection protocol identifier
+ *
+ * @MESH_PATH_PROTOCOL_HWMP: the default path selection protocol
+ * @MESH_PATH_PROTOCOL_VENDOR: a vendor specific protocol that will be
+ * specified in a vendor specific information element
+ */
+enum {
+	MESH_PATH_PROTOCOL_HWMP = 0,
+	MESH_PATH_PROTOCOL_VENDOR = 255,
+};
+
+/**
+ * enum - mesh path selection metric identifier
+ *
+ * @MESH_PATH_METRIC_AIRTIME: the default path selection metric
+ * @MESH_PATH_METRIC_VENDOR: a vendor specific metric that will be
+ * specified in a vendor specific information element
+ */
+enum {
+	MESH_PATH_METRIC_AIRTIME = 0,
+	MESH_PATH_METRIC_VENDOR = 255,
+};
+
+/**
  * enum mesh_deferred_task_flags - mac80211 mesh deferred tasks
  *
  *
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 2ba7426..2aacfac 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -2266,32 +2266,23 @@ struct sk_buff *ieee80211_beacon_get_tim(struct ieee80211_hw *hw,
 		hdr->frame_control = cpu_to_le16(IEEE80211_FTYPE_MGMT |
 						 IEEE80211_STYPE_BEACON);
 	} else if (ieee80211_vif_is_mesh(&sdata->vif)) {
-		struct ieee80211_mgmt *mgmt;
-		u8 *pos;
+		struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
 
-		/* headroom, head length, tail length and maximum TIM length */
-		skb = dev_alloc_skb(local->tx_headroom + 400);
-		if (!skb)
-			goto out;
+		beacon = rcu_dereference(ifmsh->beacon);
+		if (ifmsh && beacon) {
+			/* headroom, head length, mesh_ies and tail length */
+			skb = dev_alloc_skb(local->tx_headroom + 400);
+			if (!skb)
+				goto out;
 
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
+			skb_reserve(skb, local->hw.extra_tx_headroom);
+			memcpy(skb_put(skb, beacon->head_len), beacon->head,
+			       beacon->head_len);
+			mesh_mgmt_ies_add(skb, sdata);
+			if (beacon->tail && beacon->tail_len)
+				memcpy(skb_put(skb, beacon->tail_len),
+				       beacon->tail, beacon->tail_len);
+		}
 	} else {
 		WARN_ON(1);
 		goto out;
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 960be4e..4831b4f 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -1709,6 +1709,7 @@ static int nl80211_addset_beacon(struct sk_buff *skb, struct genl_info *info)
 		return -EINVAL;
 
 	if (dev->ieee80211_ptr->iftype != NL80211_IFTYPE_AP &&
+	    dev->ieee80211_ptr->iftype != NL80211_IFTYPE_MESH_POINT &&
 	    dev->ieee80211_ptr->iftype != NL80211_IFTYPE_P2P_GO)
 		return -EOPNOTSUPP;
 
@@ -1776,6 +1777,7 @@ static int nl80211_del_beacon(struct sk_buff *skb, struct genl_info *info)
 		return -EOPNOTSUPP;
 
 	if (dev->ieee80211_ptr->iftype != NL80211_IFTYPE_AP &&
+	    dev->ieee80211_ptr->iftype != NL80211_IFTYPE_MESH_POINT &&
 	    dev->ieee80211_ptr->iftype != NL80211_IFTYPE_P2P_GO)
 		return -EOPNOTSUPP;
 
-- 
1.7.1

