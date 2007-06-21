Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:33599 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752285AbXFVIfB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jun 2007 04:35:01 -0400
Subject: [PATCH] mac80211: separate monitor/subif_start_xmit
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: Andy Green <andy@warmcat.com>
Content-Type: text/plain
Date: Thu, 21 Jun 2007 15:39:04 +0200
Message-Id: <1182433144.21939.6.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch separates the monitor interface start_xmit from the
subif start xmit (those other devices have 802.3 framing, monitor
interfaces have radiotap framing)

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

---
 net/mac80211/ieee80211.c       |  224 ++++++++++++++++++++++++++++-------------
 net/mac80211/ieee80211_i.h     |    2 
 net/mac80211/ieee80211_iface.c |    3 
 3 files changed, 159 insertions(+), 70 deletions(-)

--- wireless-dev.orig/net/mac80211/ieee80211.c	2007-06-20 23:16:05.387345639 +0200
+++ wireless-dev/net/mac80211/ieee80211.c	2007-06-21 10:38:48.157343928 +0200
@@ -1654,9 +1676,59 @@ static int ieee80211_master_start_xmit(s
 }
 
 
+int ieee80211_monitor_start_xmit(struct sk_buff *skb,
+				 struct net_device *dev)
+{
+	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
+	struct ieee80211_tx_packet_data *pkt_data;
+	struct ieee80211_radiotap_header *prthdr =
+		(struct ieee80211_radiotap_header *)skb->data;
+	u16 len;
+
+	/*
+	 * there must be a radiotap header at the
+	 * start in this case
+	 */
+	if (unlikely(prthdr->it_version)) {
+		/* only version 0 is supported */
+		dev_kfree_skb(skb);
+		return NETDEV_TX_OK;
+	}
+
+	skb->dev = local->mdev;
+
+	pkt_data = (struct ieee80211_tx_packet_data *)skb->cb;
+	memset(pkt_data, 0, sizeof(*pkt_data));
+	pkt_data->ifindex = dev->ifindex;
+	pkt_data->mgmt_iface = 0;
+	pkt_data->do_not_encrypt = 1;
+
+	/* above needed because we set skb device to master */
+
+	/*
+	 * fix up the pointers accounting for the radiotap
+	 * header still being in there.  We are being given
+	 * a precooked IEEE80211 header so no need for
+	 * normal processing
+	 */
+	len = le16_to_cpu(get_unaligned(&prthdr->it_len));
+	skb_set_mac_header(skb, len);
+	skb_set_network_header(skb, len + sizeof(struct ieee80211_hdr));
+	skb_set_transport_header(skb, len + sizeof(struct ieee80211_hdr));
+
+	/*
+	 * pass the radiotap header up to
+	 * the next stage intact
+	 */
+	dev_queue_xmit(skb);
+
+	return NETDEV_TX_OK;
+}
+
+
 /**
  * ieee80211_subif_start_xmit - netif start_xmit function for Ethernet-type
- * interfaces (wlan#, WDS, and VLAN) and the radiotap-based monitor interfaces.
+ * interfaces (wlan#, WDS, and VLAN).
  * @skb: packet to be sent
  * @dev: incoming interface
  *
@@ -1669,8 +1741,8 @@ static int ieee80211_master_start_xmit(s
  * encapsulated packet will then be passed to master interface, wlan#.11, for
  * transmission (through low-level driver).
  */
-static int ieee80211_subif_start_xmit(struct sk_buff *skb,
-				      struct net_device *dev)
+int ieee80211_subif_start_xmit(struct sk_buff *skb,
+			       struct net_device *dev)
 {
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
 	struct ieee80211_tx_packet_data *pkt_data;
@@ -1691,51 +1763,6 @@ static int ieee80211_subif_start_xmit(st
 		goto fail;
 	}
 
-	if (unlikely(sdata->type == IEEE80211_IF_TYPE_MNTR)) {
-		struct ieee80211_radiotap_header *prthdr =
-			(struct ieee80211_radiotap_header *)skb->data;
-		u16 len;
-
-		/*
-		 * there must be a radiotap header at the
-		 * start in this case
-		 */
-		if (unlikely(prthdr->it_version)) {
-			/* only version 0 is supported  */
-			ret = 0;
-			goto fail;
-		}
-
-		skb->dev = local->mdev;
-
-		pkt_data = (struct ieee80211_tx_packet_data *)skb->cb;
-		memset(pkt_data, 0, sizeof(*pkt_data));
-		pkt_data->ifindex = sdata->dev->ifindex;
-		pkt_data->mgmt_iface = 0;
-		pkt_data->do_not_encrypt = 1;
-
-		/* above needed because we set skb device to master */
-
-		/*
-		 * fix up the pointers accounting for the radiotap
-		 * header still being in there.  We are being given
-		 * a precooked IEEE80211 header so no need for
-		 * normal processing
-		 */
-		len = le16_to_cpu(get_unaligned(&prthdr->it_len));
-		skb_set_mac_header(skb, len);
-		skb_set_network_header(skb, len + sizeof(hdr));
-		skb_set_transport_header(skb, len + sizeof(hdr));
-
-		/*
-		 * pass the radiotap header up to
-		 * the next stage intact
-		 */
-		dev_queue_xmit(skb);
-
-		return 0;
-	}
-
 	nh_pos = skb_network_header(skb) - skb->data;
 	h_pos = skb_transport_header(skb) - skb->data;
 
@@ -1870,7 +1898,7 @@ static int ieee80211_subif_start_xmit(st
 
 	pkt_data = (struct ieee80211_tx_packet_data *)skb->cb;
 	memset(pkt_data, 0, sizeof(struct ieee80211_tx_packet_data));
-	pkt_data->ifindex = sdata->dev->ifindex;
+	pkt_data->ifindex = dev->ifindex;
 	pkt_data->mgmt_iface = (sdata->type == IEEE80211_IF_TYPE_MGMT);
 	pkt_data->do_not_encrypt = no_encrypt;
 
--- wireless-dev.orig/net/mac80211/ieee80211_i.h	2007-06-20 23:15:59.527345639 +0200
+++ wireless-dev/net/mac80211/ieee80211_i.h	2007-06-21 10:35:45.247343928 +0200
@@ -798,6 +798,8 @@ void ieee80211_prepare_rates(struct ieee
 			     struct ieee80211_hw_mode *mode);
 void ieee80211_tx_set_iswep(struct ieee80211_txrx_data *tx);
 int ieee80211_if_update_wds(struct net_device *dev, u8 *remote_addr);
+int ieee80211_monitor_start_xmit(struct sk_buff *skb, struct net_device *dev);
+int ieee80211_subif_start_xmit(struct sk_buff *skb, struct net_device *dev);
 void ieee80211_if_setup(struct net_device *dev);
 void ieee80211_if_mgmt_setup(struct net_device *dev);
 int ieee80211_init_rate_ctrl_alg(struct ieee80211_local *local,
--- wireless-dev.orig/net/mac80211/ieee80211_iface.c	2007-06-20 23:15:59.427345639 +0200
+++ wireless-dev/net/mac80211/ieee80211_iface.c	2007-06-21 10:35:45.307343928 +0200
@@ -157,6 +157,8 @@ void ieee80211_if_set_type(struct net_de
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
 	int oldtype = sdata->type;
 
+	dev->hard_start_xmit = ieee80211_subif_start_xmit;
+
 	sdata->type = type;
 	switch (type) {
 	case IEEE80211_IF_TYPE_WDS:
@@ -213,6 +215,7 @@ void ieee80211_if_set_type(struct net_de
 	}
 	case IEEE80211_IF_TYPE_MNTR:
 		dev->type = ARPHRD_IEEE80211_RADIOTAP;
+		dev->hard_start_xmit = ieee80211_monitor_start_xmit;
 		break;
 	default:
 		printk(KERN_WARNING "%s: %s: Unknown interface type 0x%x",


