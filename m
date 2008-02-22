Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wx-out-0506.google.com ([66.249.82.234]:15256 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750981AbYBVHSU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Feb 2008 02:18:20 -0500
Received: by wx-out-0506.google.com with SMTP id h31so290544wxd.4
        for <linux-wireless@vger.kernel.org>; Thu, 21 Feb 2008 23:18:19 -0800 (PST)
To: linux-wireless@vger.kernel.org
From: Luis Carlos Cobo <luisca@cozybit.com>
Date: Thu, 21 Feb 2008 20:11:07 -0800
Subject: [PATCH 06/13 v2] o11s: support for mesh interfaces in mac80211 data path
Message-ID: <47be773a.29578c0a.41e9.ffffa95d@mx.google.com> (sfid-20080222_071823_283753_CB1EE72E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Luis Carlos Cobo <luisca@cozybit.com>
---
 net/mac80211/rx.c |  131 ++++++++++++++++++++++++++++++++++++++++++-
 net/mac80211/tx.c |  158 +++++++++++++++++++++++++++++++++++++++++++----------
 2 files changed, 256 insertions(+), 33 deletions(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 943ba90..897765f 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -19,6 +19,9 @@
 
 #include "ieee80211_i.h"
 #include "ieee80211_led.h"
+#ifdef CONFIG_MAC80211_MESH
+#include "mesh.h"
+#endif
 #include "wep.h"
 #include "wpa.h"
 #include "tkip.h"
@@ -389,10 +392,60 @@ ieee80211_rx_h_passive_scan(struct ieee80211_txrx_data *rx)
 	return RX_CONTINUE;
 }
 
+#ifdef CONFIG_MAC80211_MESH
+#define msh_h_get(h, l) ((struct ieee80211s_hdr *) ((u8 *)h + l))
+static ieee80211_rx_result
+ieee80211_rx_mesh_check(struct ieee80211_txrx_data *rx)
+{
+	int hdrlen = ieee80211_get_hdrlen(rx->fc);
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) rx->skb->data;
+	if ((rx->fc & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_DATA) {
+		if (!((rx->fc & IEEE80211_FCTL_FROMDS) &&
+		      (rx->fc & IEEE80211_FCTL_TODS)))
+			return RX_DROP_MONITOR;
+		if (memcmp(hdr->addr4, rx->dev->dev_addr, ETH_ALEN) == 0)
+			return RX_DROP_MONITOR;
+	}
+
+	/* If there is not an established peer link and this is not a peer link
+	 * establisment frame, beacon or probe, drop the frame.
+	 */
+
+	if (!rx->sta || rx->sta->plink_state != ESTAB) {
+		struct ieee80211_mgmt *mgmt;
+		if ((rx->fc & IEEE80211_FCTL_FTYPE) != IEEE80211_FTYPE_MGMT)
+			return RX_DROP_MONITOR;
+
+		switch (rx->fc & IEEE80211_FCTL_STYPE) {
+		case IEEE80211_STYPE_ACTION:
+			mgmt = (struct ieee80211_mgmt *)hdr;
+			if (mgmt->u.action.category != PLINK_CATEGORY)
+				return RX_DROP_MONITOR;
+			/* fall through on else */
+		case IEEE80211_STYPE_PROBE_REQ:
+		case IEEE80211_STYPE_PROBE_RESP:
+		case IEEE80211_STYPE_BEACON:
+			return RX_CONTINUE;
+			break;
+		default:
+			return RX_DROP_MONITOR;
+		}
+
+	 } else if ((rx->fc & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_DATA &&
+		    is_broadcast_ether_addr(hdr->addr1) &&
+		    mesh_rmc_check(hdr->addr4, msh_h_get(hdr, hdrlen), rx->dev))
+		return RX_DROP_MONITOR;
+	else
+		return RX_CONTINUE;
+}
+#endif
+
+
 static ieee80211_rx_result
 ieee80211_rx_h_check(struct ieee80211_txrx_data *rx)
 {
 	struct ieee80211_hdr *hdr;
+
 	hdr = (struct ieee80211_hdr *) rx->skb->data;
 
 	/* Drop duplicate 802.11 retransmissions (IEEE 802.11 Chap. 9.2.9) */
@@ -422,6 +475,12 @@ ieee80211_rx_h_check(struct ieee80211_txrx_data *rx)
 	 * deauth/disassoc frames when needed. In addition, hostapd is
 	 * responsible for filtering on both auth and assoc states.
 	 */
+
+#ifdef CONFIG_MAC80211_MESH
+	if (rx->sdata->vif.type == IEEE80211_IF_TYPE_MESH_POINT)
+		return ieee80211_rx_mesh_check(rx);
+#endif
+
 	if (unlikely(((rx->fc & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_DATA ||
 		      ((rx->fc & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_CTL &&
 		       (rx->fc & IEEE80211_FCTL_STYPE) == IEEE80211_STYPE_PSPOLL)) &&
@@ -656,6 +715,8 @@ ieee80211_rx_h_sta_process(struct ieee80211_txrx_data *rx)
 		/* Update last_rx only for unicast frames in order to prevent
 		 * the Probe Request frames (the only broadcast frames from a
 		 * STA in infrastructure mode) from keeping a connection alive.
+		 * Mesh beacons will update last_rx when if they are found to
+		 * match the current local configuration when processed.
 		 */
 		sta->last_rx = jiffies;
 	}
@@ -1048,6 +1109,23 @@ ieee80211_data_to_8023(struct ieee80211_txrx_data *rx)
 
 	hdrlen = ieee80211_get_hdrlen(fc);
 
+#ifdef CONFIG_MAC80211_MESH
+	if (sdata->vif.type == IEEE80211_IF_TYPE_MESH_POINT) {
+		int meshhdrlen = ieee80211_get_mesh_hdrlen(
+				(struct ieee80211s_hdr *) (skb->data + hdrlen));
+		/* Copy on cb:
+		 *  - mesh header: to be used for mesh forwarding
+		 * decision. It will also be used as mesh header template at
+		 * tx.c:ieee80211_subif_start_xmit() if interface
+		 * type is mesh and skb->pkt_type == PACKET_OTHERHOST
+		 *  - ta: to be used if a RERR needs to be sent.
+		 */
+		memcpy(skb->cb, skb->data + hdrlen, meshhdrlen);
+		memcpy(MESH_PREQ(skb), hdr->addr2, ETH_ALEN);
+		hdrlen += meshhdrlen;
+	}
+#endif
+
 	/* convert IEEE 802.11 header + possible LLC headers into Ethernet
 	 * header
 	 * IEEE 802.11 address fields:
@@ -1081,9 +1159,10 @@ ieee80211_data_to_8023(struct ieee80211_txrx_data *rx)
 		memcpy(dst, hdr->addr3, ETH_ALEN);
 		memcpy(src, hdr->addr4, ETH_ALEN);
 
-		if (unlikely(sdata->vif.type != IEEE80211_IF_TYPE_WDS)) {
-			if (net_ratelimit())
-				printk(KERN_DEBUG "%s: dropped FromDS&ToDS "
+		 if (unlikely(sdata->vif.type != IEEE80211_IF_TYPE_WDS &&
+			     sdata->vif.type != IEEE80211_IF_TYPE_MESH_POINT)) {
+			 if (net_ratelimit())
+				 printk(KERN_DEBUG "%s: dropped FromDS&ToDS "
 				       "frame (RA=%s TA=%s DA=%s SA=%s)\n",
 				       rx->dev->name,
 				       print_mac(mac, hdr->addr1),
@@ -1225,6 +1304,39 @@ ieee80211_deliver_skb(struct ieee80211_txrx_data *rx)
 		}
 	}
 
+#ifdef CONFIG_MAC80211_MESH
+	/* Mesh forwarding */
+	if (sdata->vif.type == IEEE80211_IF_TYPE_MESH_POINT) {
+		u8 *mesh_ttl = &((struct ieee80211s_hdr *)skb->cb)->ttl;
+		(*mesh_ttl)--;
+
+		if (is_multicast_ether_addr(skb->data)) {
+			if (*mesh_ttl > 0) {
+				xmit_skb = skb_copy(skb, GFP_ATOMIC);
+				if (!xmit_skb && net_ratelimit())
+					printk(KERN_DEBUG "%s: failed to clone "
+					       "multicast frame\n", dev->name);
+				else
+					xmit_skb->pkt_type = PACKET_OTHERHOST;
+			} else
+				sdata->u.sta.mshstats.dropped_frames_ttl++;
+
+		} else if (skb->pkt_type != PACKET_OTHERHOST &&
+			compare_ether_addr(dev->dev_addr, skb->data) != 0) {
+			if (*mesh_ttl == 0) {
+				sdata->u.sta.mshstats.dropped_frames_ttl++;
+				dev_kfree_skb(skb);
+				skb = NULL;
+			} else {
+				xmit_skb = skb;
+				xmit_skb->pkt_type = PACKET_OTHERHOST;
+				if (!(dev->flags & IFF_PROMISC))
+					skb  = NULL;
+			}
+		}
+	}
+#endif
+
 	if (skb) {
 		/* deliver to local stack */
 		skb->protocol = eth_type_trans(skb, dev);
@@ -1442,7 +1554,8 @@ ieee80211_rx_h_mgmt(struct ieee80211_txrx_data *rx)
 
 	sdata = IEEE80211_DEV_TO_SUB_IF(rx->dev);
 	if ((sdata->vif.type == IEEE80211_IF_TYPE_STA ||
-	     sdata->vif.type == IEEE80211_IF_TYPE_IBSS) &&
+	     sdata->vif.type == IEEE80211_IF_TYPE_IBSS ||
+	     sdata->vif.type == IEEE80211_IF_TYPE_MESH_POINT) &&
 	    !(sdata->flags & IEEE80211_SDATA_USERSPACE_MLME))
 		ieee80211_sta_rx_mgmt(rx->dev, rx->skb, rx->u.rx.status);
 	else
@@ -1708,6 +1821,16 @@ static int prepare_for_handlers(struct ieee80211_sub_if_data *sdata,
 			rx->sta = ieee80211_ibss_add_sta(sdata->dev, rx->skb,
 							 bssid, hdr->addr2);
 		break;
+
+	case IEEE80211_IF_TYPE_MESH_POINT:
+		if (!multicast &&
+		   compare_ether_addr(sdata->dev->dev_addr,
+				      hdr->addr1) != 0) {
+			if (!(sdata->dev->flags & IFF_PROMISC))
+				return 0;
+			rx->flags &= ~IEEE80211_TXRXD_RXRA_MATCH;
+		}
+		break;
 	case IEEE80211_IF_TYPE_VLAN:
 	case IEEE80211_IF_TYPE_AP:
 		if (!bssid) {
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 181d970..e8f2591 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -26,6 +26,9 @@
 
 #include "ieee80211_i.h"
 #include "ieee80211_led.h"
+#ifdef CONFIG_MAC80211_MESH
+#include "mesh.h"
+#endif
 #include "wep.h"
 #include "wpa.h"
 #include "wme.h"
@@ -249,6 +252,9 @@ ieee80211_tx_h_check_assoc(struct ieee80211_txrx_data *tx)
 	     (tx->fc & IEEE80211_FCTL_STYPE) != IEEE80211_STYPE_PROBE_REQ))
 		return TX_DROP;
 
+	if (tx->sdata->vif.type == IEEE80211_IF_TYPE_MESH_POINT)
+		return TX_CONTINUE;
+
 	if (tx->flags & IEEE80211_TXRXD_TXPS_BUFFERED)
 		return TX_CONTINUE;
 
@@ -1387,8 +1393,9 @@ int ieee80211_subif_start_xmit(struct sk_buff *skb,
 	struct ieee80211_tx_packet_data *pkt_data;
 	struct ieee80211_sub_if_data *sdata;
 	int ret = 1, head_need;
-	u16 ethertype, hdrlen, fc;
+	u16 ethertype, hdrlen,  meshhdrlen = 0, fc;
 	struct ieee80211_hdr hdr;
+	struct ieee80211s_hdr mesh_hdr;
 	const u8 *encaps_data;
 	int encaps_len, skip_header_bytes;
 	int nh_pos, h_pos;
@@ -1430,6 +1437,37 @@ int ieee80211_subif_start_xmit(struct sk_buff *skb,
 		memcpy(hdr.addr4, skb->data + ETH_ALEN, ETH_ALEN);
 		hdrlen = 30;
 		break;
+#ifdef CONFIG_MAC80211_MESH
+	case IEEE80211_IF_TYPE_MESH_POINT:
+		fc |= IEEE80211_FCTL_FROMDS | IEEE80211_FCTL_TODS;
+		/* RA TA DA SA */
+		if (is_multicast_ether_addr(skb->data))
+			memcpy(hdr.addr1, skb->data, ETH_ALEN);
+		else if (mesh_nexthop_lookup(hdr.addr1, skb, dev))
+				return 0;
+		memcpy(hdr.addr2, dev->dev_addr, ETH_ALEN);
+		memcpy(hdr.addr3, skb->data, ETH_ALEN);
+		memcpy(hdr.addr4, skb->data + ETH_ALEN, ETH_ALEN);
+		if (skb->pkt_type == PACKET_OTHERHOST) {
+			/* Forwarded frame, keep mesh ttl and seqnum */
+			struct ieee80211s_hdr *prev_meshhdr;
+			prev_meshhdr = ((struct ieee80211s_hdr *)skb->cb);
+			meshhdrlen = ieee80211_get_mesh_hdrlen(prev_meshhdr);
+			memcpy(&mesh_hdr, prev_meshhdr, meshhdrlen);
+			sdata->u.sta.mshstats.fwded_frames++;
+		} else {
+			if (!sdata->u.sta.mshcfg.dot11MeshTTL) {
+				/* Do not send frames with mesh_ttl == 0 */
+				sdata->u.sta.mshstats.dropped_frames_ttl++;
+				ret = 0;
+				goto fail;
+			}
+			meshhdrlen = ieee80211_new_mesh_header(&mesh_hdr,
+					sdata);
+		}
+		hdrlen = 30;
+		break;
+#endif
 	case IEEE80211_IF_TYPE_STA:
 		fc |= IEEE80211_FCTL_TODS;
 		/* BSSID SA DA */
@@ -1474,8 +1512,8 @@ int ieee80211_subif_start_xmit(struct sk_buff *skb,
 	 * EAPOL frames from the local station.
 	 */
 	if (unlikely(!is_multicast_ether_addr(hdr.addr1) &&
-		     !(sta_flags & WLAN_STA_AUTHORIZED) &&
-		     !(ethertype == ETH_P_PAE &&
+		      !(sta_flags & WLAN_STA_AUTHORIZED) &&
+		      !(ethertype == ETH_P_PAE &&
 		       compare_ether_addr(dev->dev_addr,
 					  skb->data + ETH_ALEN) == 0))) {
 #ifdef CONFIG_MAC80211_VERBOSE_DEBUG
@@ -1528,7 +1566,7 @@ int ieee80211_subif_start_xmit(struct sk_buff *skb,
 	 * build in headroom in __dev_alloc_skb() (linux/skbuff.h) and
 	 * alloc_skb() (net/core/skbuff.c)
 	 */
-	head_need = hdrlen + encaps_len + local->tx_headroom;
+	head_need = hdrlen + encaps_len + meshhdrlen + local->tx_headroom;
 	head_need -= skb_headroom(skb);
 
 	/* We are going to modify skb data, so make a copy of it if happens to
@@ -1562,6 +1600,12 @@ int ieee80211_subif_start_xmit(struct sk_buff *skb,
 		h_pos += encaps_len;
 	}
 
+	if (meshhdrlen > 0) {
+		memcpy(skb_push(skb, meshhdrlen), &mesh_hdr, meshhdrlen);
+		nh_pos += meshhdrlen;
+		h_pos += meshhdrlen;
+	}
+
 	if (fc & IEEE80211_STYPE_QOS_DATA) {
 		__le16 *qos_control;
 
@@ -1737,6 +1781,40 @@ static void ieee80211_beacon_add_tim(struct ieee80211_local *local,
 	read_unlock_bh(&local->sta_lock);
 }
 
+#ifdef CONFIG_MAC80211_MESH
+static struct sk_buff *ieee80211_mesh_beacon_get(struct net_device *dev)
+{
+	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
+	struct sk_buff *skb = dev_alloc_skb(local->hw.extra_tx_headroom + 400);
+	struct ieee80211_mgmt *mgmt;
+	u8 *pos;
+
+	if (!skb)
+		return NULL;
+	skb_reserve(skb, local->hw.extra_tx_headroom);
+	mgmt = (struct ieee80211_mgmt *)
+		skb_put(skb, 24 + sizeof(mgmt->u.beacon));
+	memset(mgmt, 0, 24 + sizeof(mgmt->u.beacon));
+	mgmt->frame_control = IEEE80211_FC(IEEE80211_FTYPE_MGMT,
+					   IEEE80211_STYPE_BEACON);
+	memset(mgmt->da, 0xff, ETH_ALEN);
+	memcpy(mgmt->sa, dev->dev_addr, ETH_ALEN);
+	/* BSSID is left zeroed, wildcard value */
+	mgmt->u.beacon.beacon_int =
+		cpu_to_le16(local->hw.conf.beacon_int);
+	mgmt->u.beacon.capab_info = 0x0; /* 0x0 for MPs */
+
+	pos = skb_put(skb, 2);
+	*pos++ = WLAN_EID_SSID;
+	*pos++ = 0x0;
+
+	mesh_mgmt_ies_add(skb, dev);
+
+	return skb;
+}
+#endif
+
+
 struct sk_buff *ieee80211_beacon_get(struct ieee80211_hw *hw,
 				     struct ieee80211_vif *vif,
 				     struct ieee80211_tx_control *control)
@@ -1749,6 +1827,8 @@ struct sk_buff *ieee80211_beacon_get(struct ieee80211_hw *hw,
 	struct rate_selection rsel;
 	struct beacon_data *beacon;
 	struct ieee80211_supported_band *sband;
+	int *num_beacons;
+	int err = 0;
 
 	sband = local->hw.wiphy->bands[local->hw.conf.channel->band];
 
@@ -1756,11 +1836,51 @@ struct sk_buff *ieee80211_beacon_get(struct ieee80211_hw *hw,
 
 	sdata = vif_to_sdata(vif);
 	bdev = sdata->dev;
-	ap = &sdata->u.ap;
 
-	beacon = rcu_dereference(ap->beacon);
+	switch (sdata->vif.type) {
+	case IEEE80211_IF_TYPE_AP:
+		ap = &sdata->u.ap;
+		beacon = rcu_dereference(ap->beacon);
+		if (!ap || !beacon) {
+			err = -1;
+			break;
+		}
+
+		/* headroom, head length, tail length and maximum TIM length */
+		skb = dev_alloc_skb(local->tx_headroom + beacon->head_len +
+				    beacon->tail_len + 256);
+		if (!skb)
+			goto out;
+
+		skb_reserve(skb, local->tx_headroom);
+		memcpy(skb_put(skb, beacon->head_len), beacon->head,
+		       beacon->head_len);
 
-	if (!ap || sdata->vif.type != IEEE80211_IF_TYPE_AP || !beacon) {
+		ieee80211_include_sequence(sdata,
+					   (struct ieee80211_hdr *)skb->data);
+
+		ieee80211_beacon_add_tim(local, ap, skb, beacon);
+
+		if (beacon->tail)
+			memcpy(skb_put(skb, beacon->tail_len), beacon->tail,
+			       beacon->tail_len);
+
+		num_beacons = &ap->num_beacons;
+		break;
+
+#ifdef CONFIG_MAC80211_MESH
+	case IEEE80211_IF_TYPE_MESH_POINT:
+		skb = ieee80211_mesh_beacon_get(bdev);
+		num_beacons = &sdata->u.sta.num_beacons;
+		break;
+#endif
+
+	default:
+		err = -1;
+		break;
+	}
+
+	if (err) {
 #ifdef CONFIG_MAC80211_VERBOSE_DEBUG
 		if (net_ratelimit())
 			printk(KERN_DEBUG "no beacon data avail for %s\n",
@@ -1770,24 +1890,6 @@ struct sk_buff *ieee80211_beacon_get(struct ieee80211_hw *hw,
 		goto out;
 	}
 
-	/* headroom, head length, tail length and maximum TIM length */
-	skb = dev_alloc_skb(local->tx_headroom + beacon->head_len +
-			    beacon->tail_len + 256);
-	if (!skb)
-		goto out;
-
-	skb_reserve(skb, local->tx_headroom);
-	memcpy(skb_put(skb, beacon->head_len), beacon->head,
-	       beacon->head_len);
-
-	ieee80211_include_sequence(sdata, (struct ieee80211_hdr *)skb->data);
-
-	ieee80211_beacon_add_tim(local, ap, skb, beacon);
-
-	if (beacon->tail)
-		memcpy(skb_put(skb, beacon->tail_len), beacon->tail,
-		       beacon->tail_len);
-
 	if (control) {
 		rate_control_get_rate(local->mdev, sband, skb, &rsel);
 		if (!rsel.rate) {
@@ -1811,10 +1913,8 @@ struct sk_buff *ieee80211_beacon_get(struct ieee80211_hw *hw,
 		control->retry_limit = 1;
 		control->flags |= IEEE80211_TXCTL_CLEAR_DST_MASK;
 	}
-
-	ap->num_beacons++;
-
- out:
+	(*num_beacons)++;
+out:
 	rcu_read_unlock();
 	return skb;
 }
-- 
1.5.2.5



