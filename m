Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nick.hrz.tu-chemnitz.de ([134.109.228.11]:40038 "EHLO
	nick.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756071Ab2KWUTO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Nov 2012 15:19:14 -0500
From: Marco Porsch <marco.porsch@etit.tu-chemnitz.de>
To: johannes@sipsolutions.net, javier@cozybit.com, thomas@cozybit.com
Cc: linux-wireless@vger.kernel.org,
	Marco Porsch <marco.porsch@etit.tu-chemnitz.de>,
	Ivan Bezyazychnyy <ivan.bezyazychnyy@gmail.com>,
	Mike Krinkin <krinkin.m.u@gmail.com>,
	Max Filippov <jcmvbkbc@gmail.com>
Subject: [RFCv2 04/13] mac80211: mesh power mode indication in transmitted frames
Date: Fri, 23 Nov 2012 12:18:45 -0800
Message-Id: <1353701934-12752-5-git-send-email-marco.porsch@etit.tu-chemnitz.de> (sfid-20121123_211923_637141_C24A5DC0)
In-Reply-To: <1353701934-12752-1-git-send-email-marco.porsch@etit.tu-chemnitz.de>
References: <1353701934-12752-1-git-send-email-marco.porsch@etit.tu-chemnitz.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

According to IEEE802.11-2012 a mesh STA shall indicate the current power mode
in transmitted frames. This differs for individually addressed frames and
group addressed frames as well as whether the frames are addressed to peers
or non-peers.

Indicate the link-specific power mode with the Power Management field in the
Frame Control field and the Mesh Power Save Level field in the QoS Control
field in all individually addressed Mesh Data frames.
Especially indicate a peer-specific mesh power mode transition with an
individually-addressed QoS Null frame to the respective peer.

  | PM | PSL| Mesh Power Mode |
  +----+----+-----------------+
  | 0  |Rsrv|    Active       |
  | 1  | 0  |    Light        |
  | 1  | 1  |    Deep         |

Indicate the non-peer mesh power mode in frames transmitted to non-peer STA
and in management frames in the Power Management field of the Frame Control
field.
In group addressed Mesh QoS Data frames the Mesh Power Save Level field
in the QoS Control field indicates whether the local STA has any deep
sleep peers.
In beacon (and probe response) frames indicate whether we have any deep sleep
peers, by setting the Mesh Power Save Level field of the Mesh Capability field.

For performance reasons, calls to the function setting the frame flags are
placed in HWMP routing routines, as there the STA pointer is already availible.

Signed-off-by: Marco Porsch <marco.porsch@etit.tu-chemnitz.de>
Signed-off-by: Ivan Bezyazychnyy <ivan.bezyazychnyy@gmail.com>
Signed-off-by: Mike Krinkin <krinkin.m.u@gmail.com>
Signed-off-by: Max Filippov <jcmvbkbc@gmail.com>
---
 include/linux/ieee80211.h   |    6 +++
 net/mac80211/mesh.c         |    3 ++
 net/mac80211/mesh.h         |    3 ++
 net/mac80211/mesh_hwmp.c    |   10 ++++
 net/mac80211/mesh_pathtbl.c |    1 +
 net/mac80211/mesh_ps.c      |  111 +++++++++++++++++++++++++++++++++++++++++++
 net/mac80211/rx.c           |    3 ++
 net/mac80211/tx.c           |   18 ++++---
 net/mac80211/wme.c          |   13 ++++-
 9 files changed, 160 insertions(+), 8 deletions(-)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index 9a85397..2ba972c 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -149,6 +149,9 @@
 /* Mesh Control 802.11s */
 #define IEEE80211_QOS_CTL_MESH_CONTROL_PRESENT  0x0100
 
+/* mesh power save level subfield mask */
+#define IEEE80211_QOS_CTL_MESH_PS_LEVEL 	0x0200
+
 /* U-APSD queue for WMM IEs sent by AP */
 #define IEEE80211_WMM_IE_AP_QOSINFO_UAPSD	(1<<7)
 #define IEEE80211_WMM_IE_AP_QOSINFO_PARAM_SET_CNT_MASK	0x0f
@@ -672,11 +675,14 @@ struct ieee80211_meshconf_ie {
  *	additional mesh peerings with other mesh STAs
  * @MESHCONF_CAPAB_FORWARDING: the STA forwards MSDUs
  * @MESHCONF_CAPAB_TBTT_ADJUSTING: TBTT adjustment procedure is ongoing
+ * @MESHCONF_CAPAB_POWER_SAVE_LEVEL: STA is in deep sleep mode or has
+ *	neighbors in deep sleep mode
  */
 enum mesh_config_capab_flags {
 	MESHCONF_CAPAB_ACCEPT_PLINKS =		0x01,
 	MESHCONF_CAPAB_FORWARDING =		0x08,
 	MESHCONF_CAPAB_TBTT_ADJUSTING =		0x20,
+	MESHCONF_CAPAB_POWER_SAVE_LEVEL	=	0x40,
 };
 
 /**
diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index d4e90ba..5f72739 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -272,6 +272,9 @@ mesh_add_meshconf_ie(struct sk_buff *skb, struct ieee80211_sub_if_data *sdata)
 	*pos = MESHCONF_CAPAB_FORWARDING;
 	*pos |= ifmsh->accepting_plinks ?
 	    MESHCONF_CAPAB_ACCEPT_PLINKS : 0x00;
+	/* Mesh PS mode. See IEEE802.11-2012 8.4.2.100.8 */
+	*pos |= ifmsh->ps_peers_deep_sleep ?
+	    MESHCONF_CAPAB_POWER_SAVE_LEVEL : 0x00;
 	*pos++ |= ifmsh->adjusting_tbtt ?
 	    MESHCONF_CAPAB_TBTT_ADJUSTING : 0x00;
 	*pos++ = 0x00;
diff --git a/net/mac80211/mesh.h b/net/mac80211/mesh.h
index 64781dd..49a3114 100644
--- a/net/mac80211/mesh.h
+++ b/net/mac80211/mesh.h
@@ -247,6 +247,9 @@ void ieee80211_mesh_local_ps_update(struct ieee80211_sub_if_data *sdata);
 void ieee80211_set_sta_mesh_local_ps_mode(struct sta_info *sta,
 		enum nl80211_mesh_power_mode pm, u32 delay);
 void ieee80211_sta_mesh_local_ps_mode_timer(unsigned long data);
+void ieee80211_set_mesh_ps_flags(struct ieee80211_sub_if_data *sdata,
+				 struct sta_info *sta,
+				 struct ieee80211_hdr *hdr);
 
 /* Mesh paths */
 int mesh_nexthop_lookup(struct sk_buff *skb,
diff --git a/net/mac80211/mesh_hwmp.c b/net/mac80211/mesh_hwmp.c
index 47aeee2..fe1d83c 100644
--- a/net/mac80211/mesh_hwmp.c
+++ b/net/mac80211/mesh_hwmp.c
@@ -205,6 +205,7 @@ static void prepare_frame_for_deferred_tx(struct ieee80211_sub_if_data *sdata,
 		struct sk_buff *skb)
 {
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
 
 	skb_set_mac_header(skb, 0);
 	skb_set_network_header(skb, 0);
@@ -216,6 +217,7 @@ static void prepare_frame_for_deferred_tx(struct ieee80211_sub_if_data *sdata,
 
 	info->control.vif = &sdata->vif;
 	ieee80211_set_qos_hdr(sdata, skb);
+	ieee80211_set_mesh_ps_flags(sdata, NULL, hdr);
 }
 
 /**
@@ -1074,6 +1076,13 @@ int mesh_nexthop_resolve(struct sk_buff *skb,
 	u8 *target_addr = hdr->addr3;
 	int err = 0;
 
+	/*
+	 * Nulls are only sent to direct peers for PS and
+	 * should already be addressed
+	 */
+	if (ieee80211_is_qos_nullfunc(hdr->frame_control))
+		return err;
+
 	rcu_read_lock();
 	err = mesh_nexthop_lookup(skb, sdata);
 	if (!err)
@@ -1145,6 +1154,7 @@ int mesh_nexthop_lookup(struct sk_buff *skb,
 	if (next_hop) {
 		memcpy(hdr->addr1, next_hop->sta.addr, ETH_ALEN);
 		memcpy(hdr->addr2, sdata->vif.addr, ETH_ALEN);
+		ieee80211_set_mesh_ps_flags(sdata, next_hop, hdr);
 		err = 0;
 	}
 
diff --git a/net/mac80211/mesh_pathtbl.c b/net/mac80211/mesh_pathtbl.c
index aa74981..a8e4040 100644
--- a/net/mac80211/mesh_pathtbl.c
+++ b/net/mac80211/mesh_pathtbl.c
@@ -212,6 +212,7 @@ void mesh_path_assign_nexthop(struct mesh_path *mpath, struct sta_info *sta)
 		hdr = (struct ieee80211_hdr *) skb->data;
 		memcpy(hdr->addr1, sta->sta.addr, ETH_ALEN);
 		memcpy(hdr->addr2, mpath->sdata->vif.addr, ETH_ALEN);
+		ieee80211_set_mesh_ps_flags(sta->sdata, sta, hdr);
 	}
 
 	spin_unlock_irqrestore(&mpath->frame_queue.lock, flags);
diff --git a/net/mac80211/mesh_ps.c b/net/mac80211/mesh_ps.c
index 14bf65b..0d496fe 100644
--- a/net/mac80211/mesh_ps.c
+++ b/net/mac80211/mesh_ps.c
@@ -10,6 +10,60 @@
 #include "mesh.h"
 
 /**
+ * ieee80211_mesh_null_get - create pre-addressed QoS Null frame
+ *
+ * Returns the created sk_buff
+ *
+ * @sta: mesh STA
+ */
+static struct sk_buff *ieee80211_mesh_null_get(struct sta_info *sta)
+{
+	struct ieee80211_sub_if_data *sdata = sta->sdata;
+	struct ieee80211_local *local = sdata->local;
+	struct ieee80211_hdr *nullfunc; /* use 4addr header */
+	struct sk_buff *skb;
+	int size = sizeof(*nullfunc);
+	__le16 fc;
+
+	skb = dev_alloc_skb(local->hw.extra_tx_headroom + size + 2);
+	if (!skb)
+		return NULL;
+	skb_reserve(skb, local->hw.extra_tx_headroom);
+
+	nullfunc = (struct ieee80211_hdr *) skb_put(skb, size);
+	fc = cpu_to_le16(IEEE80211_FTYPE_DATA | IEEE80211_STYPE_QOS_NULLFUNC);
+	ieee80211_fill_mesh_addresses(nullfunc, &fc, sta->sta.addr,
+				      sdata->vif.addr);
+	nullfunc->frame_control = fc;
+	nullfunc->duration_id = 0;
+	/* no address resolution for this frame -> set addr 1 immediately */
+	memcpy(nullfunc->addr1, sta->sta.addr, ETH_ALEN);
+	skb_put(skb, 2); /* append QoS control field */
+	ieee80211_set_mesh_ps_flags(sdata, sta, nullfunc);
+
+	return skb;
+}
+
+/**
+ * ieee80211_send_mesh_null - send a QoS Null to peer to indicate power mode
+ *
+ * @sta: mesh STA to inform
+ */
+static void ieee80211_send_mesh_null(struct sta_info *sta)
+{
+	struct sk_buff *skb;
+
+	skb = ieee80211_mesh_null_get(sta);
+	if (!skb)
+		return;
+
+	mps_dbg(sta->sdata, "announcing peer-specific power mode to %pM\n",
+		sta->sta.addr);
+
+	ieee80211_tx_skb(sta->sdata, skb);
+}
+
+/**
  * ieee80211_mesh_local_ps_update - keep track of link-specific PS modes
  *
  * @sdata: local mesh subif
@@ -107,6 +161,13 @@ void ieee80211_set_sta_mesh_local_ps_mode(struct sta_info *sta,
 
 	sta->local_ps_mode = pm;
 
+	/*
+	 * announce peer-specific power mode transition
+	 * see IEEE802.11-2012 13.14.3.2 and 13.14.3.3
+	 */
+	if (sta->plink_state == NL80211_PLINK_ESTAB)
+		ieee80211_send_mesh_null(sta);
+
 	ieee80211_mesh_local_ps_update(sdata);
 }
 
@@ -122,3 +183,53 @@ void ieee80211_sta_mesh_local_ps_mode_timer(unsigned long data)
 	ieee80211_set_sta_mesh_local_ps_mode(sta, sta->local_ps_mode_delayed,
 					     0);
 }
+
+/**
+ * ieee80211_set_mesh_ps_flags - set mesh PS flags in FC (and QoS Control)
+ *
+ * @sdata: local mesh subif
+ * @sta: mesh STA
+ * @hdr: 802.11 frame header
+ *
+ * see IEEE802.11-2012 8.2.4.1.7 and 8.2.4.5.11
+ *
+ * NOTE: sta must be given when an individually-addressed QoS frame header
+ * is handed, for group-addressed and management frames it not used
+ */
+void ieee80211_set_mesh_ps_flags(struct ieee80211_sub_if_data *sdata,
+				 struct sta_info *sta,
+				 struct ieee80211_hdr *hdr)
+{
+	enum nl80211_mesh_power_mode pm;
+	__le16 *qc;
+
+	if (WARN_ON(is_unicast_ether_addr(hdr->addr1) &&
+	       ieee80211_is_data_qos(hdr->frame_control) &&
+	       !sta))
+		return;
+
+	if (is_unicast_ether_addr(hdr->addr1) &&
+	    ieee80211_is_data_qos(hdr->frame_control) &&
+	    sta->plink_state == NL80211_PLINK_ESTAB)
+		pm = sta->local_ps_mode;
+	else
+		pm = sdata->u.mesh.nonpeer_ps_mode;
+
+	if (pm == NL80211_MESH_POWER_ACTIVE)
+		hdr->frame_control &= cpu_to_le16(~IEEE80211_FCTL_PM);
+	else
+		hdr->frame_control |= cpu_to_le16(IEEE80211_FCTL_PM);
+
+	if (!ieee80211_is_data_qos(hdr->frame_control))
+		return;
+
+	qc = (__le16 *) ieee80211_get_qos_ctl(hdr);
+
+	if ((is_unicast_ether_addr(hdr->addr1) &&
+	     pm == NL80211_MESH_POWER_DEEP_SLEEP) ||
+	    (is_multicast_ether_addr(hdr->addr1) &&
+	     sdata->u.mesh.ps_peers_deep_sleep > 0))
+		*qc |= cpu_to_le16(IEEE80211_QOS_CTL_MESH_PS_LEVEL);
+	else
+		*qc &= cpu_to_le16(~IEEE80211_QOS_CTL_MESH_PS_LEVEL);
+}
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 8c1f152..67aa26c 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1998,7 +1998,10 @@ ieee80211_rx_h_mesh_fwding(struct ieee80211_rx_data *rx)
 	if (is_multicast_ether_addr(fwd_hdr->addr1)) {
 		IEEE80211_IFSTA_MESH_CTR_INC(ifmsh, fwded_mcast);
 		memcpy(fwd_hdr->addr2, sdata->vif.addr, ETH_ALEN);
+		/* update power mode indication when forwarding */
+		ieee80211_set_mesh_ps_flags(sdata, NULL, fwd_hdr);
 	} else if (!mesh_nexthop_lookup(fwd_skb, sdata)) {
+		/* mesh power mode flags updated in mesh_nexthop_lookup */
 		IEEE80211_IFSTA_MESH_CTR_INC(ifmsh, fwded_unicast);
 	} else {
 		/* unable to resolve next hop */
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 6f19818..70aa64f 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1472,12 +1472,16 @@ void ieee80211_xmit(struct ieee80211_sub_if_data *sdata, struct sk_buff *skb,
 	hdr = (struct ieee80211_hdr *) skb->data;
 	info->control.vif = &sdata->vif;
 
-	if (ieee80211_vif_is_mesh(&sdata->vif) &&
-	    ieee80211_is_data(hdr->frame_control) &&
-	    !is_multicast_ether_addr(hdr->addr1) &&
-	    mesh_nexthop_resolve(skb, sdata)) {
-		/* skb queued: don't free */
-		return;
+	if (ieee80211_vif_is_mesh(&sdata->vif)) {
+		if (ieee80211_is_data(hdr->frame_control) &&
+		    is_unicast_ether_addr(hdr->addr1)) {
+			if (mesh_nexthop_resolve(skb, sdata)) {
+				/* skb queued: don't free */
+				return;
+			}
+		} else {
+			ieee80211_set_mesh_ps_flags(sdata, NULL, hdr);
+		}
 	}
 
 	ieee80211_set_qos_hdr(sdata, skb);
@@ -2448,6 +2452,8 @@ struct sk_buff *ieee80211_beacon_get_tim(struct ieee80211_hw *hw,
 		eth_broadcast_addr(mgmt->da);
 		memcpy(mgmt->sa, sdata->vif.addr, ETH_ALEN);
 		memcpy(mgmt->bssid, sdata->vif.addr, ETH_ALEN);
+		ieee80211_set_mesh_ps_flags(sdata, NULL,
+					    (struct ieee80211_hdr *) mgmt);
 		mgmt->u.beacon.beacon_int =
 			cpu_to_le16(sdata->vif.bss_conf.beacon_int);
 		mgmt->u.beacon.capab_info |= cpu_to_le16(
diff --git a/net/mac80211/wme.c b/net/mac80211/wme.c
index 906f00c..afba19c 100644
--- a/net/mac80211/wme.c
+++ b/net/mac80211/wme.c
@@ -191,6 +191,15 @@ void ieee80211_set_qos_hdr(struct ieee80211_sub_if_data *sdata,
 
 	/* qos header is 2 bytes */
 	*p++ = ack_policy | tid;
-	*p = ieee80211_vif_is_mesh(&sdata->vif) ?
-		(IEEE80211_QOS_CTL_MESH_CONTROL_PRESENT >> 8) : 0;
+	if (ieee80211_vif_is_mesh(&sdata->vif)) {
+		/* preserve RSPI and Mesh PS Level bit */
+		*p &= ((IEEE80211_QOS_CTL_RSPI |
+			IEEE80211_QOS_CTL_MESH_PS_LEVEL) >> 8);
+
+		/* Nulls don't have a mesh header (frame body) */
+		if (!ieee80211_is_qos_nullfunc(hdr->frame_control))
+			*p |= (IEEE80211_QOS_CTL_MESH_CONTROL_PRESENT >> 8);
+	} else {
+		*p = 0;
+	}
 }
-- 
1.7.9.5

