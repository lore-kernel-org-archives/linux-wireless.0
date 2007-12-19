Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:40630 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755481AbXLSPrn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Dec 2007 10:47:43 -0500
Message-Id: <20071219003233.259673000@sipsolutions.net> (sfid-20071219_154801_383733_02975B4E)
References: <20071219003121.508296000@sipsolutions.net>
Date: Wed, 19 Dec 2007 01:31:22 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Michael Wu <flamingice@sourmilk.net>,
	linux-wireless@vger.kernel.org
Subject: [PATCH 1/6]  mac80211: clean up eapol frame handling/port control
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This cleans up the eapol frame handling and some related code in the
receive and transmit paths. After this patch
 * EAPOL frames addressed to us or the EAPOL group address are
   always accepted regardless of whether they are encrypted or not
 * other frames from a station are dropped if PAE is enabled and
   the station is not authorized
 * unencrypted frames (except the EAPOL frames above) are dropped if
   drop_unencrypted is enabled
 * some superfluous code that eth_type_trans handles anyway is gone
 * port control is done for transmitted packets

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
I've made a corresponding hostapd patch which is on my website
http://johannes.sipsolutions.net/patches/hostap/all/2007-12-12-17%3a18/005-eapol-on-regular-iface.patch

It works fine and is IMHO nicer than doing the eapol stuff over the
management interface.

 net/mac80211/debugfs_netdev.c  |   27 ++------
 net/mac80211/ieee80211_i.h     |   22 ++----
 net/mac80211/ieee80211_iface.c |    1 
 net/mac80211/rx.c              |  133 ++++++++++++++++++++---------------------
 net/mac80211/tx.c              |   53 ++++++++++------
 5 files changed, 119 insertions(+), 117 deletions(-)

--- everything.orig/net/mac80211/ieee80211_i.h	2007-12-19 00:39:58.193026096 +0100
+++ everything/net/mac80211/ieee80211_i.h	2007-12-19 01:09:45.373023817 +0100
@@ -306,11 +306,11 @@ struct ieee80211_sub_if_data {
 	unsigned int flags;
 
 	int drop_unencrypted;
-	int eapol; /* 0 = process EAPOL frames as normal data frames,
-		    * 1 = send EAPOL frames through wlan#ap to hostapd
-		    *     (default) */
-	int ieee802_1x; /* IEEE 802.1X PAE - drop packet to/from unauthorized
-			 * port */
+	/*
+	 * IEEE 802.1X Port access control in effect,
+	 * drop packets to/from unauthorized port
+	 */
+	int ieee802_1x_pac;
 
 	u16 sequence;
 
@@ -339,8 +339,7 @@ struct ieee80211_sub_if_data {
 		struct {
 			struct dentry *channel_use;
 			struct dentry *drop_unencrypted;
-			struct dentry *eapol;
-			struct dentry *ieee8021_x;
+			struct dentry *ieee802_1x_pac;
 			struct dentry *state;
 			struct dentry *bssid;
 			struct dentry *prev_bssid;
@@ -359,8 +358,7 @@ struct ieee80211_sub_if_data {
 		struct {
 			struct dentry *channel_use;
 			struct dentry *drop_unencrypted;
-			struct dentry *eapol;
-			struct dentry *ieee8021_x;
+			struct dentry *ieee802_1x_pac;
 			struct dentry *num_sta_ps;
 			struct dentry *dtim_period;
 			struct dentry *dtim_count;
@@ -374,15 +372,13 @@ struct ieee80211_sub_if_data {
 		struct {
 			struct dentry *channel_use;
 			struct dentry *drop_unencrypted;
-			struct dentry *eapol;
-			struct dentry *ieee8021_x;
+			struct dentry *ieee802_1x_pac;
 			struct dentry *peer;
 		} wds;
 		struct {
 			struct dentry *channel_use;
 			struct dentry *drop_unencrypted;
-			struct dentry *eapol;
-			struct dentry *ieee8021_x;
+			struct dentry *ieee802_1x_pac;
 		} vlan;
 		struct {
 			struct dentry *mode;
--- everything.orig/net/mac80211/rx.c	2007-12-19 00:39:58.343023763 +0100
+++ everything/net/mac80211/rx.c	2007-12-19 01:09:41.173023112 +0100
@@ -206,7 +206,7 @@ ieee80211_rx_monitor(struct ieee80211_lo
 		rthdr->it_len = cpu_to_le16(rtap_len);
 	}
 
-	skb_set_mac_header(skb, 0);
+	skb_reset_mac_header(skb);
 	skb->ip_summed = CHECKSUM_UNNECESSARY;
 	skb->pkt_type = PACKET_OTHERHOST;
 	skb->protocol = htons(ETH_P_802_2);
@@ -403,18 +403,6 @@ ieee80211_rx_h_check(struct ieee80211_tx
 		return TXRX_DROP;
 	}
 
-	if (!(rx->flags & IEEE80211_TXRXD_RXRA_MATCH))
-		rx->skb->pkt_type = PACKET_OTHERHOST;
-	else if (compare_ether_addr(rx->dev->dev_addr, hdr->addr1) == 0)
-		rx->skb->pkt_type = PACKET_HOST;
-	else if (is_multicast_ether_addr(hdr->addr1)) {
-		if (is_broadcast_ether_addr(hdr->addr1))
-			rx->skb->pkt_type = PACKET_BROADCAST;
-		else
-			rx->skb->pkt_type = PACKET_MULTICAST;
-	} else
-		rx->skb->pkt_type = PACKET_OTHERHOST;
-
 	/* Drop disallowed frame classes based on STA auth/assoc state;
 	 * IEEE 802.11, Chap 5.5.
 	 *
@@ -983,18 +971,10 @@ ieee80211_rx_h_remove_qos_control(struct
 }
 
 static int
-ieee80211_drop_802_1x_pae(struct ieee80211_txrx_data *rx, int hdrlen)
+ieee80211_802_1x_port_control(struct ieee80211_txrx_data *rx)
 {
-	if (rx->sdata->eapol && ieee80211_is_eapol(rx->skb, hdrlen) &&
-	    rx->sdata->type != IEEE80211_IF_TYPE_STA &&
-	    (rx->flags & IEEE80211_TXRXD_RXRA_MATCH))
-		return 0;
-
-	if (unlikely(rx->sdata->ieee802_1x &&
-		     (rx->fc & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_DATA &&
-		     (rx->fc & IEEE80211_FCTL_STYPE) != IEEE80211_STYPE_NULLFUNC &&
-		     (!rx->sta || !(rx->sta->flags & WLAN_STA_AUTHORIZED)) &&
-		     !ieee80211_is_eapol(rx->skb, hdrlen))) {
+	if (unlikely(rx->sdata->ieee802_1x_pac &&
+		     (!rx->sta || !(rx->sta->flags & WLAN_STA_AUTHORIZED)))) {
 #ifdef CONFIG_MAC80211_DEBUG
 		printk(KERN_DEBUG "%s: dropped frame "
 		       "(unauthorized port)\n", rx->dev->name);
@@ -1006,7 +986,7 @@ ieee80211_drop_802_1x_pae(struct ieee802
 }
 
 static int
-ieee80211_drop_unencrypted(struct ieee80211_txrx_data *rx, int hdrlen)
+ieee80211_drop_unencrypted(struct ieee80211_txrx_data *rx)
 {
 	/*
 	 * Pass through unencrypted frames if the hardware has
@@ -1019,9 +999,7 @@ ieee80211_drop_unencrypted(struct ieee80
 	if (unlikely(!(rx->fc & IEEE80211_FCTL_PROTECTED) &&
 		     (rx->fc & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_DATA &&
 		     (rx->fc & IEEE80211_FCTL_STYPE) != IEEE80211_STYPE_NULLFUNC &&
-		     (rx->key || rx->sdata->drop_unencrypted) &&
-		     (rx->sdata->eapol == 0 ||
-		      !ieee80211_is_eapol(rx->skb, hdrlen)))) {
+		     (rx->key || rx->sdata->drop_unencrypted))) {
 		if (net_ratelimit())
 			printk(KERN_DEBUG "%s: RX non-WEP frame, but expected "
 			       "encryption\n", rx->dev->name);
@@ -1149,6 +1127,7 @@ ieee80211_data_to_8023(struct ieee80211_
 	} else {
 		struct ethhdr *ehdr;
 		__be16 len;
+
 		skb_pull(skb, hdrlen);
 		len = htons(skb->len);
 		ehdr = (struct ethhdr *) skb_push(skb, sizeof(struct ethhdr));
@@ -1159,6 +1138,34 @@ ieee80211_data_to_8023(struct ieee80211_
 	return 0;
 }
 
+/*
+ * requires that rx->skb is a frame with ethernet header
+ */
+static bool ieee80211_frame_allowed(struct ieee80211_txrx_data *rx)
+{
+	static const u8 pae_group_addr[ETH_ALEN]
+		= { 0x01, 0x80, 0xC2, 0x00, 0x00, 0x03 };
+	struct ethhdr *ehdr = (struct ethhdr *) rx->skb->data;
+
+	/*
+	 * Allow EAPOL frames to us/the PAE group address regardless
+	 * of whether the frame was encrypted or not.
+	 */
+	if (ehdr->h_proto == htons(ETH_P_PAE) &&
+	    (compare_ether_addr(ehdr->h_dest, rx->dev->dev_addr) == 0 ||
+	     compare_ether_addr(ehdr->h_dest, pae_group_addr) == 0))
+		return true;
+
+	if (ieee80211_802_1x_port_control(rx) ||
+	    ieee80211_drop_unencrypted(rx))
+		return false;
+
+	return true;
+}
+
+/*
+ * requires that rx->skb is a frame with ethernet header
+ */
 static void
 ieee80211_deliver_skb(struct ieee80211_txrx_data *rx)
 {
@@ -1166,31 +1173,32 @@ ieee80211_deliver_skb(struct ieee80211_t
 	struct ieee80211_local *local = rx->local;
 	struct sk_buff *skb, *xmit_skb;
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	struct ethhdr *ehdr = (struct ethhdr *) rx->skb->data;
+	struct sta_info *dsta;
 
 	skb = rx->skb;
 	xmit_skb = NULL;
 
-	if (local->bridge_packets && (sdata->type == IEEE80211_IF_TYPE_AP
-	    || sdata->type == IEEE80211_IF_TYPE_VLAN) &&
+	if (local->bridge_packets && (sdata->type == IEEE80211_IF_TYPE_AP ||
+				      sdata->type == IEEE80211_IF_TYPE_VLAN) &&
 	    (rx->flags & IEEE80211_TXRXD_RXRA_MATCH)) {
-		if (is_multicast_ether_addr(skb->data)) {
-			/* send multicast frames both to higher layers in
-			 * local net stack and back to the wireless media */
+		if (is_multicast_ether_addr(ehdr->h_dest)) {
+			/*
+			 * send multicast frames both to higher layers in
+			 * local net stack and back to the wireless medium
+			 */
 			xmit_skb = skb_copy(skb, GFP_ATOMIC);
 			if (!xmit_skb && net_ratelimit())
 				printk(KERN_DEBUG "%s: failed to clone "
 				       "multicast frame\n", dev->name);
 		} else {
-			struct sta_info *dsta;
 			dsta = sta_info_get(local, skb->data);
-			if (dsta && !dsta->dev) {
-				if (net_ratelimit())
-					printk(KERN_DEBUG "Station with null "
-					       "dev structure!\n");
-			} else if (dsta && dsta->dev == dev) {
-				/* Destination station is associated to this
-				 * AP, so send the frame directly to it and
-				 * do not pass the frame to local net stack.
+			if (dsta && dsta->dev == dev) {
+				/*
+				 * The destination station is associated to
+				 * this AP (in this VLAN), so send the frame
+				 * directly to it and do not pass it to local
+				 * net stack.
 				 */
 				xmit_skb = skb;
 				skb = NULL;
@@ -1210,8 +1218,8 @@ ieee80211_deliver_skb(struct ieee80211_t
 	if (xmit_skb) {
 		/* send to wireless media */
 		xmit_skb->protocol = __constant_htons(ETH_P_802_3);
-		skb_set_network_header(xmit_skb, 0);
-		skb_set_mac_header(xmit_skb, 0);
+		skb_reset_network_header(xmit_skb);
+		skb_reset_mac_header(xmit_skb);
 		dev_queue_xmit(xmit_skb);
 	}
 }
@@ -1296,38 +1304,36 @@ ieee80211_rx_h_amsdu(struct ieee80211_tx
 			}
 		}
 
-		skb_set_network_header(frame, 0);
+		skb_reset_network_header(frame);
 		frame->dev = dev;
 		frame->priority = skb->priority;
 		rx->skb = frame;
 
-		if ((ieee80211_drop_802_1x_pae(rx, 0)) ||
-		    (ieee80211_drop_unencrypted(rx, 0))) {
-			if (skb == frame) /* last frame */
-				return TXRX_DROP;
-			dev_kfree_skb(frame);
-			continue;
-		}
-
 		payload = frame->data;
 		ethertype = (payload[6] << 8) | payload[7];
 
 		if (likely((compare_ether_addr(payload, rfc1042_header) == 0 &&
-			ethertype != ETH_P_AARP && ethertype != ETH_P_IPX) ||
-			compare_ether_addr(payload,
-					   bridge_tunnel_header) == 0)) {
+			    ethertype != ETH_P_AARP && ethertype != ETH_P_IPX) ||
+			   compare_ether_addr(payload,
+					      bridge_tunnel_header) == 0)) {
 			/* remove RFC1042 or Bridge-Tunnel
 			 * encapsulation and replace EtherType */
 			skb_pull(frame, 6);
 			memcpy(skb_push(frame, ETH_ALEN), src, ETH_ALEN);
 			memcpy(skb_push(frame, ETH_ALEN), dst, ETH_ALEN);
 		} else {
-			memcpy(skb_push(frame, sizeof(__be16)), &len,
-				sizeof(__be16));
+			memcpy(skb_push(frame, sizeof(__be16)),
+			       &len, sizeof(__be16));
 			memcpy(skb_push(frame, ETH_ALEN), src, ETH_ALEN);
 			memcpy(skb_push(frame, ETH_ALEN), dst, ETH_ALEN);
 		}
 
+		if (!ieee80211_frame_allowed(rx)) {
+			if (skb == frame) /* last frame */
+				return TXRX_DROP;
+			dev_kfree_skb(frame);
+			continue;
+		}
 
 		ieee80211_deliver_skb(rx);
 	}
@@ -1340,7 +1346,7 @@ ieee80211_rx_h_data(struct ieee80211_txr
 {
 	struct net_device *dev = rx->dev;
 	u16 fc;
-	int err, hdrlen;
+	int err;
 
 	fc = rx->fc;
 	if (unlikely((fc & IEEE80211_FCTL_FTYPE) != IEEE80211_FTYPE_DATA))
@@ -1349,16 +1355,13 @@ ieee80211_rx_h_data(struct ieee80211_txr
 	if (unlikely(!WLAN_FC_DATA_PRESENT(fc)))
 		return TXRX_DROP;
 
-	hdrlen = ieee80211_get_hdrlen(fc);
-
-	if ((ieee80211_drop_802_1x_pae(rx, hdrlen)) ||
-	    (ieee80211_drop_unencrypted(rx, hdrlen)))
-		return TXRX_DROP;
-
 	err = ieee80211_data_to_8023(rx);
 	if (unlikely(err))
 		return TXRX_DROP;
 
+	if (!ieee80211_frame_allowed(rx))
+		return TXRX_DROP;
+
 	rx->skb->dev = dev;
 
 	dev->stats.rx_packets++;
--- everything.orig/net/mac80211/debugfs_netdev.c	2007-12-19 00:39:58.463023654 +0100
+++ everything/net/mac80211/debugfs_netdev.c	2007-12-19 01:09:40.833031141 +0100
@@ -91,8 +91,7 @@ static const struct file_operations name
 /* common attributes */
 IEEE80211_IF_FILE(channel_use, channel_use, DEC);
 IEEE80211_IF_FILE(drop_unencrypted, drop_unencrypted, DEC);
-IEEE80211_IF_FILE(eapol, eapol, DEC);
-IEEE80211_IF_FILE(ieee8021_x, ieee802_1x, DEC);
+IEEE80211_IF_FILE(ieee802_1x_pac, ieee802_1x_pac, DEC);
 
 /* STA/IBSS attributes */
 IEEE80211_IF_FILE(state, u.sta.state, DEC);
@@ -170,8 +169,7 @@ static void add_sta_files(struct ieee802
 {
 	DEBUGFS_ADD(channel_use, sta);
 	DEBUGFS_ADD(drop_unencrypted, sta);
-	DEBUGFS_ADD(eapol, sta);
-	DEBUGFS_ADD(ieee8021_x, sta);
+	DEBUGFS_ADD(ieee802_1x_pac, sta);
 	DEBUGFS_ADD(state, sta);
 	DEBUGFS_ADD(bssid, sta);
 	DEBUGFS_ADD(prev_bssid, sta);
@@ -192,8 +190,7 @@ static void add_ap_files(struct ieee8021
 {
 	DEBUGFS_ADD(channel_use, ap);
 	DEBUGFS_ADD(drop_unencrypted, ap);
-	DEBUGFS_ADD(eapol, ap);
-	DEBUGFS_ADD(ieee8021_x, ap);
+	DEBUGFS_ADD(ieee802_1x_pac, ap);
 	DEBUGFS_ADD(num_sta_ps, ap);
 	DEBUGFS_ADD(dtim_period, ap);
 	DEBUGFS_ADD(dtim_count, ap);
@@ -209,8 +206,7 @@ static void add_wds_files(struct ieee802
 {
 	DEBUGFS_ADD(channel_use, wds);
 	DEBUGFS_ADD(drop_unencrypted, wds);
-	DEBUGFS_ADD(eapol, wds);
-	DEBUGFS_ADD(ieee8021_x, wds);
+	DEBUGFS_ADD(ieee802_1x_pac, wds);
 	DEBUGFS_ADD(peer, wds);
 }
 
@@ -218,8 +214,7 @@ static void add_vlan_files(struct ieee80
 {
 	DEBUGFS_ADD(channel_use, vlan);
 	DEBUGFS_ADD(drop_unencrypted, vlan);
-	DEBUGFS_ADD(eapol, vlan);
-	DEBUGFS_ADD(ieee8021_x, vlan);
+	DEBUGFS_ADD(ieee802_1x_pac, vlan);
 }
 
 static void add_monitor_files(struct ieee80211_sub_if_data *sdata)
@@ -263,8 +258,7 @@ static void del_sta_files(struct ieee802
 {
 	DEBUGFS_DEL(channel_use, sta);
 	DEBUGFS_DEL(drop_unencrypted, sta);
-	DEBUGFS_DEL(eapol, sta);
-	DEBUGFS_DEL(ieee8021_x, sta);
+	DEBUGFS_DEL(ieee802_1x_pac, sta);
 	DEBUGFS_DEL(state, sta);
 	DEBUGFS_DEL(bssid, sta);
 	DEBUGFS_DEL(prev_bssid, sta);
@@ -285,8 +279,7 @@ static void del_ap_files(struct ieee8021
 {
 	DEBUGFS_DEL(channel_use, ap);
 	DEBUGFS_DEL(drop_unencrypted, ap);
-	DEBUGFS_DEL(eapol, ap);
-	DEBUGFS_DEL(ieee8021_x, ap);
+	DEBUGFS_DEL(ieee802_1x_pac, ap);
 	DEBUGFS_DEL(num_sta_ps, ap);
 	DEBUGFS_DEL(dtim_period, ap);
 	DEBUGFS_DEL(dtim_count, ap);
@@ -302,8 +295,7 @@ static void del_wds_files(struct ieee802
 {
 	DEBUGFS_DEL(channel_use, wds);
 	DEBUGFS_DEL(drop_unencrypted, wds);
-	DEBUGFS_DEL(eapol, wds);
-	DEBUGFS_DEL(ieee8021_x, wds);
+	DEBUGFS_DEL(ieee802_1x_pac, wds);
 	DEBUGFS_DEL(peer, wds);
 }
 
@@ -311,8 +303,7 @@ static void del_vlan_files(struct ieee80
 {
 	DEBUGFS_DEL(channel_use, vlan);
 	DEBUGFS_DEL(drop_unencrypted, vlan);
-	DEBUGFS_DEL(eapol, vlan);
-	DEBUGFS_DEL(ieee8021_x, vlan);
+	DEBUGFS_DEL(ieee802_1x_pac, vlan);
 }
 
 static void del_monitor_files(struct ieee80211_sub_if_data *sdata)
--- everything.orig/net/mac80211/ieee80211_iface.c	2007-12-19 00:39:58.583023003 +0100
+++ everything/net/mac80211/ieee80211_iface.c	2007-12-19 01:09:42.613022569 +0100
@@ -22,7 +22,6 @@ void ieee80211_if_sdata_init(struct ieee
 
 	/* Default values for sub-interface parameters */
 	sdata->drop_unencrypted = 0;
-	sdata->eapol = 1;
 	for (i = 0; i < IEEE80211_FRAGMENT_MAX; i++)
 		skb_queue_head_init(&sdata->fragments[i].skb_list);
 
--- everything.orig/net/mac80211/tx.c	2007-12-19 00:39:58.623022948 +0100
+++ everything/net/mac80211/tx.c	2007-12-19 01:09:53.523023546 +0100
@@ -261,18 +261,6 @@ ieee80211_tx_h_check_assoc(struct ieee80
 		return TXRX_CONTINUE;
 	}
 
-	if (unlikely(/* !injected && */ tx->sdata->ieee802_1x &&
-		     !(sta_flags & WLAN_STA_AUTHORIZED))) {
-#ifdef CONFIG_MAC80211_VERBOSE_DEBUG
-		DECLARE_MAC_BUF(mac);
-		printk(KERN_DEBUG "%s: dropped frame to %s"
-		       " (unauthorized port)\n", tx->dev->name,
-		       print_mac(mac, hdr->addr1));
-#endif
-		I802_DEBUG_INC(tx->local->tx_handlers_drop_unauth_port);
-		return TXRX_DROP;
-	}
-
 	return TXRX_CONTINUE;
 }
 
@@ -445,8 +433,7 @@ ieee80211_tx_h_select_key(struct ieee802
 	else if ((key = rcu_dereference(tx->sdata->default_key)))
 		tx->key = key;
 	else if (tx->sdata->drop_unencrypted &&
-		 !(tx->sdata->eapol &&
-		   ieee80211_is_eapol(tx->skb, ieee80211_get_hdrlen(fc)))) {
+		 !ieee80211_is_eapol(tx->skb, ieee80211_get_hdrlen(fc))) {
 		I802_DEBUG_INC(tx->local->tx_handlers_drop_unencrypted);
 		return TXRX_DROP;
 	} else
@@ -1355,6 +1342,7 @@ int ieee80211_subif_start_xmit(struct sk
 	int encaps_len, skip_header_bytes;
 	int nh_pos, h_pos;
 	struct sta_info *sta;
+	u32 sta_flags = 0;
 
 	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	if (unlikely(skb->len < ETH_HLEN)) {
@@ -1370,7 +1358,6 @@ int ieee80211_subif_start_xmit(struct sk
 	/* convert Ethernet header to proper 802.11 header (based on
 	 * operation mode) */
 	ethertype = (skb->data[12] << 8) | skb->data[13];
-	/* TODO: handling for 802.1x authorized/unauthorized port */
 	fc = IEEE80211_FTYPE_DATA | IEEE80211_STYPE_DATA;
 
 	switch (sdata->type) {
@@ -1412,16 +1399,42 @@ int ieee80211_subif_start_xmit(struct sk
 		goto fail;
 	}
 
-	/* receiver is QoS enabled, use a QoS type frame */
 	sta = sta_info_get(local, hdr.addr1);
 	if (sta) {
-		if (sta->flags & WLAN_STA_WME) {
-			fc |= IEEE80211_STYPE_QOS_DATA;
-			hdrlen += 2;
-		}
+		sta_flags = sta->flags;
 		sta_info_put(sta);
 	}
 
+	/* receiver is QoS enabled, use a QoS type frame */
+	if (sta_flags & WLAN_STA_WME) {
+		fc |= IEEE80211_STYPE_QOS_DATA;
+		hdrlen += 2;
+	}
+
+	/*
+	 * If port access control is enabled, drop frames to unauthorised
+	 * stations unless they are EAPOL frames from the local station.
+	 */
+	if (unlikely(sdata->ieee802_1x_pac &&
+		     !(sta_flags & WLAN_STA_AUTHORIZED) &&
+		     !(ethertype == ETH_P_PAE &&
+		       compare_ether_addr(dev->dev_addr,
+		      			  skb->data + ETH_ALEN) == 0))) {
+#ifdef CONFIG_MAC80211_VERBOSE_DEBUG
+		DECLARE_MAC_BUF(mac);
+
+		if (net_ratelimit())
+			printk(KERN_DEBUG "%s: dropped frame to %s"
+			       " (unauthorized port)\n", dev->name,
+			       print_mac(mac, hdr.addr1));
+#endif
+
+		I802_DEBUG_INC(local->tx_handlers_drop_unauth_port);
+
+		ret = 0;
+		goto fail;
+	}
+
 	hdr.frame_control = cpu_to_le16(fc);
 	hdr.duration_id = 0;
 	hdr.seq_ctrl = 0;

-- 

