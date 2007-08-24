Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33256 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755889AbXHXSaR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Aug 2007 14:30:17 -0400
Date: Fri, 24 Aug 2007 11:29:34 -0700
From: Stephen Hemminger <shemminger@linux-foundation.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] mac80211: use internal network device stats
Message-ID: <20070824112934.2e377bce@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Stats are now available for device usage inside network_device

Signed-off-by: Stephen Hemminger <shemminger@linux-foundation.org>
---
 net/mac80211/ieee80211.c   |   44 ++++++++++++++------------------------------
 net/mac80211/ieee80211_i.h |    2 --
 2 files changed, 14 insertions(+), 32 deletions(-)

diff --git a/net/mac80211/ieee80211.c b/net/mac80211/ieee80211.c
index 8ec5ed1..28cca19 100644
--- a/net/mac80211/ieee80211.c
+++ b/net/mac80211/ieee80211.c
@@ -1892,8 +1892,8 @@ int ieee80211_subif_start_xmit(struct sk_buff *skb,
 	pkt_data->do_not_encrypt = no_encrypt;
 
 	skb->dev = local->mdev;
-	sdata->stats.tx_packets++;
-	sdata->stats.tx_bytes += skb->len;
+	dev->stats.tx_packets++;
+	dev->stats.tx_bytes += skb->len;
 
 	/* Update skb pointers to various headers since this modified frame
 	 * is going to go through Linux networking code that may potentially
@@ -1966,8 +1966,8 @@ ieee80211_mgmt_start_xmit(struct sk_buff *skb, struct net_device *dev)
 
 	pkt_data->do_not_encrypt = !(fc & IEEE80211_FCTL_PROTECTED);
 
-	sdata->stats.tx_packets++;
-	sdata->stats.tx_bytes += skb->len;
+	dev->stats.tx_packets++;
+	dev->stats.tx_bytes += skb->len;
 
 	dev_queue_xmit(skb);
 
@@ -2492,13 +2492,6 @@ struct dev_mc_list *ieee80211_get_mc_list_item(struct ieee80211_hw *hw,
 }
 EXPORT_SYMBOL(ieee80211_get_mc_list_item);
 
-static struct net_device_stats *ieee80211_get_stats(struct net_device *dev)
-{
-	struct ieee80211_sub_if_data *sdata;
-	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
-	return &(sdata->stats);
-}
-
 static void ieee80211_if_shutdown(struct net_device *dev)
 {
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
@@ -2893,8 +2886,8 @@ ieee80211_rx_h_data(struct ieee80211_txrx_data *rx)
 
 	skb2 = NULL;
 
-	sdata->stats.rx_packets++;
-	sdata->stats.rx_bytes += skb->len;
+	dev->stats.rx_packets++;
+	dev->stats.rx_bytes += skb->len;
 
 	if (local->bridge_packets && (sdata->type == IEEE80211_IF_TYPE_AP
 	    || sdata->type == IEEE80211_IF_TYPE_VLAN) && rx->u.rx.ra_match) {
@@ -3041,11 +3034,9 @@ ieee80211_rx_mgmt(struct ieee80211_local *local, struct sk_buff *skb,
 {
 	struct ieee80211_frame_info *fi;
 	const size_t hlen = sizeof(struct ieee80211_frame_info);
-	struct ieee80211_sub_if_data *sdata;
+	struct net_device *dev = local->apdev;
 
-	skb->dev = local->apdev;
-
-	sdata = IEEE80211_DEV_TO_SUB_IF(local->apdev);
+	skb->dev = dev;
 
 	if (skb_headroom(skb) < hlen) {
 		I802_DEBUG_INC(local->rx_expand_skb_head);
@@ -3060,8 +3051,8 @@ ieee80211_rx_mgmt(struct ieee80211_local *local, struct sk_buff *skb,
 	ieee80211_fill_frame_info(local, fi, status);
 	fi->msg_type = htonl(msg_type);
 
-	sdata->stats.rx_packets++;
-	sdata->stats.rx_bytes += skb->len;
+	dev->stats.rx_packets++;
+	dev->stats.rx_bytes += skb->len;
 
 	skb_set_mac_header(skb, 0);
 	skb->ip_summed = CHECKSUM_UNNECESSARY;
@@ -3123,8 +3114,8 @@ ieee80211_rx_monitor(struct net_device *dev, struct sk_buff *skb,
 	rthdr->antsignal = status->ssi;
 
  out:
-	sdata->stats.rx_packets++;
-	sdata->stats.rx_bytes += skb->len;
+	dev->stats.rx_packets++;
+	dev->stats.rx_bytes += skb->len;
 
 	skb_set_mac_header(skb, 0);
 	skb->ip_summed = CHECKSUM_UNNECESSARY;
@@ -4784,7 +4775,7 @@ void ieee80211_if_setup(struct net_device *dev)
 	dev->wireless_handlers = &ieee80211_iw_handler_def;
 	dev->set_multicast_list = ieee80211_set_multicast_list;
 	dev->change_mtu = ieee80211_change_mtu;
-	dev->get_stats = ieee80211_get_stats;
+
 	dev->open = ieee80211_open;
 	dev->stop = ieee80211_stop;
 	dev->uninit = ieee80211_if_reinit;
@@ -4796,7 +4787,7 @@ void ieee80211_if_mgmt_setup(struct net_device *dev)
 	ether_setup(dev);
 	dev->hard_start_xmit = ieee80211_mgmt_start_xmit;
 	dev->change_mtu = ieee80211_change_mtu_apdev;
-	dev->get_stats = ieee80211_get_stats;
+
 	dev->open = ieee80211_mgmt_open;
 	dev->stop = ieee80211_mgmt_stop;
 	dev->type = ARPHRD_IEEE80211_PRISM;
@@ -5225,13 +5216,6 @@ void ieee80211_wake_queues(struct ieee80211_hw *hw)
 }
 EXPORT_SYMBOL(ieee80211_wake_queues);
 
-struct net_device_stats *ieee80211_dev_stats(struct net_device *dev)
-{
-	struct ieee80211_sub_if_data *sdata;
-	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
-	return &sdata->stats;
-}
-
 static int __init ieee80211_init(void)
 {
 	struct sk_buff *skb;
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 6f7bae7..4ffdcfe 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -285,7 +285,6 @@ struct ieee80211_sub_if_data {
 	unsigned int promisc:1;
 	unsigned int use_protection:1; /* CTS protect ERP frames */
 
-	struct net_device_stats stats;
 	int drop_unencrypted;
 	int eapol; /* 0 = process EAPOL frames as normal data frames,
 		    * 1 = send EAPOL frames through wlan#ap to hostapd
@@ -729,7 +728,6 @@ void ieee80211_if_setup(struct net_device *dev);
 void ieee80211_if_mgmt_setup(struct net_device *dev);
 int ieee80211_init_rate_ctrl_alg(struct ieee80211_local *local,
 				 const char *name);
-struct net_device_stats *ieee80211_dev_stats(struct net_device *dev);
 
 /* ieee80211_ioctl.c */
 extern const struct iw_handler_def ieee80211_iw_handler_def;
-- 
1.4.4.2

