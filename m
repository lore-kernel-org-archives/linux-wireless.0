Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:46198 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752065AbXBWAMT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Feb 2007 19:12:19 -0500
Received: from shell0.pdx.osdl.net (fw.osdl.org [65.172.181.6])
	by smtp.osdl.org (8.12.8/8.12.8) with ESMTP id l1N0CEhB022699
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <linux-wireless@vger.kernel.org>; Thu, 22 Feb 2007 16:12:14 -0800
Received: from freekitty (unknown-230.office.pdx.osdl.net [10.8.0.230])
	by shell0.pdx.osdl.net (8.13.1/8.11.6) with ESMTP id l1N0CDKB030536
	for <linux-wireless@vger.kernel.org>; Thu, 22 Feb 2007 16:12:14 -0800
Date: Thu, 22 Feb 2007 16:12:10 -0800
From: Stephen Hemminger <shemminger@linux-foundation.org>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 3/3] d80211: convert to use compare_ether_addr
Message-ID: <20070222161210.270f2905@freekitty>
In-Reply-To: <20070222161014.62d064a6@freekitty>
References: <20070222161014.62d064a6@freekitty>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

compare_ether_addr is faster than memcmp()

Signed-off-by: Stephen Hemminger <shemminger@linux-foundation.org>
---
 net/d80211/ieee80211.c |   45 ++++++++++++++++++++++-----------------------
 1 files changed, 22 insertions(+), 23 deletions(-)

diff --git a/net/d80211/ieee80211.c b/net/d80211/ieee80211.c
index 73e34a0..6ffba74 100644
--- a/net/d80211/ieee80211.c
+++ b/net/d80211/ieee80211.c
@@ -2310,15 +2310,14 @@ static int ieee80211_open(struct net_dev
 	list_for_each_entry(nsdata, &local->sub_if_list, list) {
 		struct net_device *ndev = nsdata->dev;
 
-		if (ndev != dev && ndev != local->mdev &&
-		    netif_running(ndev) &&
-		    memcmp(dev->dev_addr, ndev->dev_addr, ETH_ALEN) == 0 &&
-		    !identical_mac_addr_allowed(sdata->type, nsdata->type)) {
+		if (ndev != dev && ndev != local->mdev && netif_running(ndev) &&
+		    compare_ether_addr(dev->dev_addr, ndev->dev_addr) == 0 &&
+		    !identical_mac_addr_allowed(sdata->type, nsdata->type))
 			return -ENOTUNIQ;
-		}
 	}
-	if (sdata->type == IEEE80211_IF_TYPE_WDS &&
-	    memcmp(sdata->u.wds.remote_addr, "\0\0\0\0\0\0", ETH_ALEN) == 0)
+
+	if (sdata->type == IEEE80211_IF_TYPE_WDS && 
+	    is_zero_ether_addr(sdata->u.wds.remote_addr))
 		return -ENOLINK;
 
 	if (sdata->type == IEEE80211_IF_TYPE_MNTR && local->open_count &&
@@ -2436,9 +2435,9 @@ static int header_parse_80211(struct sk_
 	return ETH_ALEN;
 }
 
-static inline int ieee80211_bssid_match(u8 *raddr, u8 *addr)
+static inline int ieee80211_bssid_match(const u8 *raddr, const u8 *addr)
 {
-	return memcmp(raddr, addr, ETH_ALEN) == 0 ||
+	return compare_ether_addr(raddr, addr) == 0 ||
 	       is_broadcast_ether_addr(raddr);
 }
 
@@ -2545,9 +2544,9 @@ ieee80211_rx_h_data(struct ieee80211_txr
 
 	ethertype = (payload[6] << 8) | payload[7];
 
-	if (likely((memcmp(payload, rfc1042_header, 6) == 0 &&
+	if (likely((compare_ether_addr(payload, rfc1042_header) == 0 &&
 		    ethertype != ETH_P_AARP && ethertype != ETH_P_IPX) ||
-		   memcmp(payload, bridge_tunnel_header, 6) == 0)) {
+		   compare_ether_addr(payload, bridge_tunnel_header) == 0)) {
 		/* remove RFC1042 or Bridge-Tunnel encapsulation and
 		 * replace EtherType */
 		skb_pull(skb, hdrlen + 6);
@@ -3038,8 +3037,8 @@ ieee80211_reassemble_find(struct ieee802
 		f_fc = le16_to_cpu(f_hdr->frame_control);
 
 		if ((fc & IEEE80211_FCTL_FTYPE) != (f_fc & IEEE80211_FCTL_FTYPE) ||
-		    memcmp(hdr->addr1, f_hdr->addr1, ETH_ALEN) != 0 ||
-		    memcmp(hdr->addr2, f_hdr->addr2, ETH_ALEN) != 0)
+		    compare_ether_addr(hdr->addr1, f_hdr->addr1) != 0 ||
+		    compare_ether_addr(hdr->addr2, f_hdr->addr2) != 0)
 			continue;
 
 		if (entry->first_frag_time + 2 * HZ < jiffies) {
@@ -3208,7 +3207,7 @@ ieee80211_rx_h_check(struct ieee80211_tx
 
 	if (!rx->u.rx.ra_match)
 		rx->skb->pkt_type = PACKET_OTHERHOST;
-	else if (memcmp(rx->dev->dev_addr, hdr->addr1, ETH_ALEN) == 0)
+	else if (compare_ether_addr(rx->dev->dev_addr, hdr->addr1) == 0)
 		rx->skb->pkt_type = PACKET_HOST;
 	else if (is_multicast_ether_addr(hdr->addr1)) {
 		if (is_broadcast_ether_addr(hdr->addr1))
@@ -3318,7 +3317,7 @@ ieee80211_rx_h_sta_process(struct ieee80
 	 * other STAs are using different BSSID. */
 	if (rx->sdata->type == IEEE80211_IF_TYPE_IBSS) {
 		u8 *bssid = ieee80211_get_bssid(hdr, rx->skb->len);
-		if (memcmp(bssid, rx->sdata->u.sta.bssid, ETH_ALEN) == 0)
+		if (compare_ether_addr(bssid, rx->sdata->u.sta.bssid) == 0)
 			sta->last_rx = jiffies;
 	} else
 	if (!is_multicast_ether_addr(hdr->addr1) ||
@@ -3797,8 +3796,8 @@ void __ieee80211_rx(struct ieee80211_hw 
 						continue;
 					rx.u.rx.ra_match = 0;
 				} else if (!multicast &&
-					   memcmp(sdata->dev->dev_addr,
-						  hdr->addr1, ETH_ALEN) != 0) {
+					   compare_ether_addr(sdata->dev->dev_addr,
+							      hdr->addr1) != 0) {
 					if (!sdata->promisc)
 						continue;
 					rx.u.rx.ra_match = 0;
@@ -3813,8 +3812,8 @@ void __ieee80211_rx(struct ieee80211_hw 
 						continue;
 					rx.u.rx.ra_match = 0;
 				} else if (!multicast &&
-					   memcmp(sdata->dev->dev_addr,
-						  hdr->addr1, ETH_ALEN) != 0) {
+					   compare_ether_addr(sdata->dev->dev_addr,
+							      hdr->addr1) != 0) {
 					if (!sdata->promisc)
 						continue;
 					rx.u.rx.ra_match = 0;
@@ -3827,8 +3826,8 @@ void __ieee80211_rx(struct ieee80211_hw 
 				break;
 			case IEEE80211_IF_TYPE_AP:
 				if (!bssid) {
-					if (memcmp(sdata->dev->dev_addr,
-						   hdr->addr1, ETH_ALEN) != 0)
+					if (compare_ether_addr(sdata->dev->dev_addr,
+							       hdr->addr1) != 0)
 						continue;
 				} else if (!ieee80211_bssid_match(bssid,
 							sdata->dev->dev_addr)) {
@@ -3846,8 +3845,8 @@ void __ieee80211_rx(struct ieee80211_hw 
 				if (bssid ||
 				    (rx.fc & IEEE80211_FCTL_FTYPE) != IEEE80211_FTYPE_DATA)
 					continue;
-				if (memcmp(sdata->u.wds.remote_addr,
-					   hdr->addr2, ETH_ALEN) != 0)
+				if (compare_ether_addr(sdata->u.wds.remote_addr,
+						       hdr->addr2) != 0)
 					continue;
 				break;
 			}
-- 
1.4.1

