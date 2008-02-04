Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0910.google.com ([209.85.198.188]:44294 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754348AbYBDVYS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Feb 2008 16:24:18 -0500
Received: by rv-out-0910.google.com with SMTP id k20so1548589rvb.1
        for <linux-wireless@vger.kernel.org>; Mon, 04 Feb 2008 13:24:18 -0800 (PST)
To: linux-wireless@vger.kernel.org
From: Luis Carlos Cobo <luisca@cozybit.com>
Date: Mon, 4 Feb 2008 11:17:06 -0800
Subject: [PATCH 07/13] o11s: support for mesh interfaces in mac80211 data path
Message-ID: <47a78281.03b48c0a.7362.5d39@mx.google.com> (sfid-20080204_212421_865811_21908028)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since mesh interfaces are not yet using the sta_info structure, a couple of
changes in this patch are a bit ugly ("if mesh, ignore security"), but this will
be resolved when mesh peer link table and sta integration is achieved.

Signed-off-by: Luis Carlos Cobo <luisca@cozybit.com>
---
 net/mac80211/rx.c |  119 ++++++++++++++++++++++++++++++++++++++++++++++++++--
 net/mac80211/tx.c |   51 ++++++++++++++++++++--
 2 files changed, 160 insertions(+), 10 deletions(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index beda1bf..40c8824 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -19,6 +19,7 @@
 
 #include "ieee80211_i.h"
 #include "ieee80211_led.h"
+#include "mesh.h"
 #include "wep.h"
 #include "wpa.h"
 #include "tkip.h"
@@ -390,6 +391,8 @@ static ieee80211_txrx_result
 ieee80211_rx_h_check(struct ieee80211_txrx_data *rx)
 {
 	struct ieee80211_hdr *hdr;
+	int hdrlen = ieee80211_get_hdrlen(rx->fc);
+
 	hdr = (struct ieee80211_hdr *) rx->skb->data;
 
 	/* Drop duplicate 802.11 retransmissions (IEEE 802.11 Chap. 9.2.9) */
@@ -419,6 +422,54 @@ ieee80211_rx_h_check(struct ieee80211_txrx_data *rx)
 	 * deauth/disassoc frames when needed. In addition, hostapd is
 	 * responsible for filtering on both auth and assoc states.
 	 */
+
+	if (rx->sdata->vif.type == IEEE80211_IF_TYPE_MESH_POINT) {
+		if ((rx->fc & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_DATA) {
+			if (!((rx->fc & IEEE80211_FCTL_FROMDS) &&
+					(rx->fc & IEEE80211_FCTL_TODS)))
+				return TXRX_DROP;
+			if (memcmp(hdr->addr4,
+					rx->dev->dev_addr, ETH_ALEN) == 0)
+				return TXRX_DROP;
+		}
+
+		/* If there is not an established peer link and this is
+		 * not a peer link establisment frame, beacon or probe,
+		 * drop the frame.
+		 */
+		if (!is_estab_plink(hdr->addr2, rx->dev)) {
+			if ((rx->fc & IEEE80211_FCTL_FTYPE) !=
+				IEEE80211_FTYPE_MGMT)
+				return TXRX_DROP;
+			else {
+				struct ieee80211_mgmt *mgmt;
+				switch (rx->fc & IEEE80211_FCTL_STYPE) {
+				case IEEE80211_STYPE_ACTION:
+					mgmt = (struct ieee80211_mgmt *)hdr;
+					if (mgmt->u.action.category !=
+						PLINK_CATEGORY)
+						return TXRX_DROP;
+					/* fall through on else */
+				case IEEE80211_STYPE_PROBE_REQ:
+				case IEEE80211_STYPE_PROBE_RESP:
+				case IEEE80211_STYPE_BEACON:
+					return TXRX_CONTINUE;
+					break;
+				default:
+					return TXRX_DROP;
+				}
+			}
+		 } else if ((rx->fc & IEEE80211_FCTL_FTYPE)
+				 == IEEE80211_FTYPE_DATA &&
+				 (is_broadcast_ether_addr(hdr->addr1)) &&
+			 mesh_rmc_check(hdr->addr4, (struct ieee80211s_hdr *)
+				 (rx->skb->data + hdrlen), rx->dev))
+			return TXRX_DROP;
+
+		else
+			return TXRX_CONTINUE;
+	}
+
 	if (unlikely(((rx->fc & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_DATA ||
 		      ((rx->fc & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_CTL &&
 		       (rx->fc & IEEE80211_FCTL_STYPE) == IEEE80211_STYPE_PSPOLL)) &&
@@ -987,7 +1038,8 @@ ieee80211_rx_h_remove_qos_control(struct ieee80211_txrx_data *rx)
 static int
 ieee80211_802_1x_port_control(struct ieee80211_txrx_data *rx)
 {
-	if (unlikely(!rx->sta || !(rx->sta->flags & WLAN_STA_AUTHORIZED))) {
+	if (rx->sdata->vif.type != IEEE80211_IF_TYPE_MESH_POINT &&
+	    (!rx->sta || !(rx->sta->flags & WLAN_STA_AUTHORIZED))) {
 #ifdef CONFIG_MAC80211_DEBUG
 		if (net_ratelimit())
 			printk(KERN_DEBUG "%s: dropped frame "
@@ -1045,6 +1097,21 @@ ieee80211_data_to_8023(struct ieee80211_txrx_data *rx)
 
 	hdrlen = ieee80211_get_hdrlen(fc);
 
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
+
 	/* convert IEEE 802.11 header + possible LLC headers into Ethernet
 	 * header
 	 * IEEE 802.11 address fields:
@@ -1078,9 +1145,10 @@ ieee80211_data_to_8023(struct ieee80211_txrx_data *rx)
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
@@ -1222,6 +1290,36 @@ ieee80211_deliver_skb(struct ieee80211_txrx_data *rx)
 		}
 	}
 
+	/* Mesh forwarding */
+	if (sdata->vif.type == IEEE80211_IF_TYPE_MESH_POINT) {
+		u8 *mesh_ttl = &((struct ieee80211s_hdr *)skb->cb)->ttl;
+		(*mesh_ttl)--;
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
+		} else if (skb->pkt_type != PACKET_OTHERHOST &&
+			compare_ether_addr(sdata->dev->dev_addr, skb->data)
+						!= 0) {
+			if (*mesh_ttl == 0) {
+				sdata->u.sta.mshstats.dropped_frames_ttl++;
+				dev_kfree_skb(skb);
+				skb = NULL;
+			} else {
+				xmit_skb = skb;
+				xmit_skb->pkt_type = PACKET_OTHERHOST;
+				if (!(sdata->dev->flags & IFF_PROMISC))
+					skb  = NULL;
+			}
+		}
+	}
+
 	if (skb) {
 		/* deliver to local stack */
 		skb->protocol = eth_type_trans(skb, dev);
@@ -1439,7 +1537,8 @@ ieee80211_rx_h_mgmt(struct ieee80211_txrx_data *rx)
 
 	sdata = IEEE80211_DEV_TO_SUB_IF(rx->dev);
 	if ((sdata->vif.type == IEEE80211_IF_TYPE_STA ||
-	     sdata->vif.type == IEEE80211_IF_TYPE_IBSS) &&
+	     sdata->vif.type == IEEE80211_IF_TYPE_IBSS ||
+	     sdata->vif.type == IEEE80211_IF_TYPE_MESH_POINT) &&
 	    !(sdata->flags & IEEE80211_SDATA_USERSPACE_MLME))
 		ieee80211_sta_rx_mgmt(rx->dev, rx->skb, rx->u.rx.status);
 	else
@@ -1626,6 +1725,16 @@ static int prepare_for_handlers(struct ieee80211_sub_if_data *sdata,
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
index 2b47464..58b026a 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -26,6 +26,7 @@
 
 #include "ieee80211_i.h"
 #include "ieee80211_led.h"
+#include "mesh.h"
 #include "wep.h"
 #include "wpa.h"
 #include "wme.h"
@@ -249,6 +250,9 @@ ieee80211_tx_h_check_assoc(struct ieee80211_txrx_data *tx)
 	     (tx->fc & IEEE80211_FCTL_STYPE) != IEEE80211_STYPE_PROBE_REQ))
 		return TXRX_DROP;
 
+	if (tx->sdata->vif.type == IEEE80211_IF_TYPE_MESH_POINT)
+		return TXRX_CONTINUE;
+
 	if (tx->flags & IEEE80211_TXRXD_TXPS_BUFFERED)
 		return TXRX_CONTINUE;
 
@@ -1388,8 +1392,9 @@ int ieee80211_subif_start_xmit(struct sk_buff *skb,
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
@@ -1431,6 +1436,35 @@ int ieee80211_subif_start_xmit(struct sk_buff *skb,
 		memcpy(hdr.addr4, skb->data + ETH_ALEN, ETH_ALEN);
 		hdrlen = 30;
 		break;
+	case IEEE80211_IF_TYPE_MESH_POINT:
+		fc |= IEEE80211_FCTL_FROMDS | IEEE80211_FCTL_TODS;
+		/* RA TA DA SA */
+		if (is_multicast_ether_addr(skb->data))
+			memcpy(hdr.addr1, skb->data, ETH_ALEN);
+		else if (mesh_lookup_nexthop(hdr.addr1, skb, dev))
+			return 0;
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
 	case IEEE80211_IF_TYPE_STA:
 		fc |= IEEE80211_FCTL_TODS;
 		/* BSSID SA DA */
@@ -1474,9 +1508,10 @@ int ieee80211_subif_start_xmit(struct sk_buff *skb,
 	 * Drop unicast frames to unauthorised stations unless they are
 	 * EAPOL frames from the local station.
 	 */
-	if (unlikely(!is_multicast_ether_addr(hdr.addr1) &&
-		     !(sta_flags & WLAN_STA_AUTHORIZED) &&
-		     !(ethertype == ETH_P_PAE &&
+	if (sdata->vif.type != IEEE80211_IF_TYPE_MESH_POINT &&
+	    (!is_multicast_ether_addr(hdr.addr1) &&
+		      !(sta_flags & WLAN_STA_AUTHORIZED) &&
+		      !(ethertype == ETH_P_PAE &&
 		       compare_ether_addr(dev->dev_addr,
 					  skb->data + ETH_ALEN) == 0))) {
 #ifdef CONFIG_MAC80211_VERBOSE_DEBUG
@@ -1529,7 +1564,7 @@ int ieee80211_subif_start_xmit(struct sk_buff *skb,
 	 * build in headroom in __dev_alloc_skb() (linux/skbuff.h) and
 	 * alloc_skb() (net/core/skbuff.c)
 	 */
-	head_need = hdrlen + encaps_len + local->tx_headroom;
+	head_need = hdrlen + encaps_len + meshhdrlen + local->tx_headroom;
 	head_need -= skb_headroom(skb);
 
 	/* We are going to modify skb data, so make a copy of it if happens to
@@ -1563,6 +1598,12 @@ int ieee80211_subif_start_xmit(struct sk_buff *skb,
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
 
-- 
1.5.2.5



