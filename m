Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:39088 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757989AbYBAMJb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Feb 2008 07:09:31 -0500
Message-Id: <20080131185055.439338000@sipsolutions.net> (sfid-20080201_120943_298689_C47E1E21)
References: <20080131184819.103174000@sipsolutions.net>
Date: Thu, 31 Jan 2008 19:48:27 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Michael Wu <flamingice@sourmilk.net>
Subject: [PATCH 8/8] mac80211: Add cooked monitor mode support
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Michael Wu <flamingice@sourmilk.net>

This adds "cooked" monitor mode to mac80211. A monitor interface
in "cooked" mode will see all frames that mac80211 has not used
internally.

Signed-off-by: Michael Wu <flamingice@sourmilk.net>
Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---

 net/mac80211/ieee80211.c   |   67 +++++++++++++++++++---------------
 net/mac80211/ieee80211_i.h |    3 +
 net/mac80211/rx.c          |   87 ++++++++++++++++++++++++++++++++++++++++++++-
 3 files changed, 126 insertions(+), 31 deletions(-)

--- everything.orig/net/mac80211/ieee80211.c	2008-01-31 19:35:26.042291125 +0100
+++ everything/net/mac80211/ieee80211.c	2008-01-31 19:35:27.942268936 +0100
@@ -238,6 +238,11 @@ static int ieee80211_open(struct net_dev
 		/* no need to tell driver */
 		break;
 	case IEEE80211_IF_TYPE_MNTR:
+		if (sdata->u.mntr_flags & MONITOR_FLAG_COOK_FRAMES) {
+			local->cooked_mntrs++;
+			break;
+		}
+
 		/* must be before the call to ieee80211_configure_filter */
 		local->monitors++;
 		if (local->monitors == 1)
@@ -367,6 +372,11 @@ static int ieee80211_stop(struct net_dev
 		/* no need to tell driver */
 		break;
 	case IEEE80211_IF_TYPE_MNTR:
+		if (sdata->u.mntr_flags & MONITOR_FLAG_COOK_FRAMES) {
+			local->cooked_mntrs--;
+			break;
+		}
+
 		local->monitors--;
 		if (local->monitors == 0)
 			local->hw.conf.flags &= ~IEEE80211_CONF_RADIOTAP;
@@ -1174,7 +1184,7 @@ void ieee80211_tx_status(struct ieee8021
 	u16 frag, type;
 	struct ieee80211_tx_status_rtap_hdr *rthdr;
 	struct ieee80211_sub_if_data *sdata;
-	int monitors;
+	struct net_device *prev_dev = NULL;
 
 	if (!status) {
 		printk(KERN_ERR
@@ -1287,7 +1297,11 @@ void ieee80211_tx_status(struct ieee8021
 	/* this was a transmitted frame, but now we want to reuse it */
 	skb_orphan(skb);
 
-	if (!local->monitors) {
+	/*
+	 * This is a bit racy but we can avoid a lot of work
+	 * with this test...
+	 */
+	if (!local->monitors && !local->cooked_mntrs) {
 		dev_kfree_skb(skb);
 		return;
 	}
@@ -1321,42 +1335,37 @@ void ieee80211_tx_status(struct ieee8021
 
 	rthdr->data_retries = status->retry_count;
 
+	/* XXX: is this sufficient for BPF? */
+	skb_set_mac_header(skb, 0);
+	skb->ip_summed = CHECKSUM_UNNECESSARY;
+	skb->pkt_type = PACKET_OTHERHOST;
+	skb->protocol = htons(ETH_P_802_2);
+	memset(skb->cb, 0, sizeof(skb->cb));
+
 	rcu_read_lock();
-	monitors = local->monitors;
 	list_for_each_entry_rcu(sdata, &local->interfaces, list) {
-		/*
-		 * Using the monitors counter is possibly racy, but
-		 * if the value is wrong we simply either clone the skb
-		 * once too much or forget sending it to one monitor iface
-		 * The latter case isn't nice but fixing the race is much
-		 * more complicated.
-		 */
-		if (!monitors || !skb)
-			goto out;
-
 		if (sdata->vif.type == IEEE80211_IF_TYPE_MNTR) {
 			if (!netif_running(sdata->dev))
 				continue;
-			monitors--;
-			if (monitors)
+
+			if (prev_dev) {
 				skb2 = skb_clone(skb, GFP_ATOMIC);
-			else
-				skb2 = NULL;
-			skb->dev = sdata->dev;
-			/* XXX: is this sufficient for BPF? */
-			skb_set_mac_header(skb, 0);
-			skb->ip_summed = CHECKSUM_UNNECESSARY;
-			skb->pkt_type = PACKET_OTHERHOST;
-			skb->protocol = htons(ETH_P_802_2);
-			memset(skb->cb, 0, sizeof(skb->cb));
-			netif_rx(skb);
-			skb = skb2;
+				if (skb2) {
+					skb2->dev = prev_dev;
+					netif_rx(skb2);
+				}
+			}
+
+			prev_dev = sdata->dev;
 		}
 	}
- out:
+	if (prev_dev) {
+		skb->dev = prev_dev;
+		netif_rx(skb);
+		skb = NULL;
+	}
 	rcu_read_unlock();
-	if (skb)
-		dev_kfree_skb(skb);
+	dev_kfree_skb(skb);
 }
 EXPORT_SYMBOL(ieee80211_tx_status);
 
--- everything.orig/net/mac80211/ieee80211_i.h	2008-01-31 19:35:26.042291125 +0100
+++ everything/net/mac80211/ieee80211_i.h	2008-01-31 19:35:27.942268936 +0100
@@ -131,6 +131,7 @@ typedef unsigned __bitwise__ ieee80211_r
 #define IEEE80211_TXRXD_RXRA_MATCH		BIT(5)
 #define IEEE80211_TXRXD_TX_INJECTED		BIT(6)
 #define IEEE80211_TXRXD_RX_AMSDU		BIT(7)
+#define IEEE80211_TXRXD_RX_CMNTR_REPORTED	BIT(8)
 struct ieee80211_txrx_data {
 	struct sk_buff *skb;
 	struct net_device *dev;
@@ -419,7 +420,7 @@ struct ieee80211_local {
 
 	struct net_device *mdev; /* wmaster# - "master" 802.11 device */
 	int open_count;
-	int monitors;
+	int monitors, cooked_mntrs;
 	/* number of interfaces with corresponding FIF_ flags */
 	int fif_fcsfail, fif_plcpfail, fif_control, fif_other_bss;
 	unsigned int filter_flags; /* FIF_* */
--- everything.orig/net/mac80211/rx.c	2008-01-31 19:35:27.002268610 +0100
+++ everything/net/mac80211/rx.c	2008-01-31 19:35:27.952268013 +0100
@@ -223,6 +223,9 @@ ieee80211_rx_monitor(struct ieee80211_lo
 		if (sdata->vif.type != IEEE80211_IF_TYPE_MNTR)
 			continue;
 
+		if (sdata->u.mntr_flags & MONITOR_FLAG_COOK_FRAMES)
+			continue;
+
 		if (prev_dev) {
 			skb2 = skb_clone(skb, GFP_ATOMIC);
 			if (skb2) {
@@ -1520,6 +1523,86 @@ static void ieee80211_rx_michael_mic_rep
 	rx->skb = NULL;
 }
 
+static void ieee80211_rx_cooked_monitor(struct ieee80211_txrx_data *rx)
+{
+	struct ieee80211_sub_if_data *sdata;
+	struct ieee80211_local *local = rx->local;
+	struct ieee80211_rtap_hdr {
+		struct ieee80211_radiotap_header hdr;
+		u8 flags;
+		u8 rate;
+		__le16 chan_freq;
+		__le16 chan_flags;
+	} __attribute__ ((packed)) *rthdr;
+	struct sk_buff *skb = rx->skb, *skb2;
+	struct net_device *prev_dev = NULL;
+	struct ieee80211_rx_status *status = rx->u.rx.status;
+
+	if (rx->flags & IEEE80211_TXRXD_RX_CMNTR_REPORTED)
+		goto out_free_skb;
+
+	if (skb_headroom(skb) < sizeof(*rthdr) &&
+	    pskb_expand_head(skb, sizeof(*rthdr), 0, GFP_ATOMIC))
+		goto out_free_skb;
+
+	rthdr = (void *)skb_push(skb, sizeof(*rthdr));
+	memset(rthdr, 0, sizeof(*rthdr));
+	rthdr->hdr.it_len = cpu_to_le16(sizeof(*rthdr));
+	rthdr->hdr.it_present =
+		cpu_to_le32((1 << IEEE80211_RADIOTAP_FLAGS) |
+			    (1 << IEEE80211_RADIOTAP_RATE) |
+			    (1 << IEEE80211_RADIOTAP_CHANNEL));
+
+	rthdr->rate = rx->u.rx.rate->bitrate / 5;
+	rthdr->chan_freq = cpu_to_le16(status->freq);
+
+	if (status->band == IEEE80211_BAND_5GHZ)
+		rthdr->chan_flags = cpu_to_le16(IEEE80211_CHAN_OFDM |
+						IEEE80211_CHAN_5GHZ);
+	else
+		rthdr->chan_flags = cpu_to_le16(IEEE80211_CHAN_DYN |
+						IEEE80211_CHAN_2GHZ);
+
+	skb_set_mac_header(skb, 0);
+	skb->ip_summed = CHECKSUM_UNNECESSARY;
+	skb->pkt_type = PACKET_OTHERHOST;
+	skb->protocol = htons(ETH_P_802_2);
+
+	list_for_each_entry_rcu(sdata, &local->interfaces, list) {
+		if (!netif_running(sdata->dev))
+			continue;
+
+		if (sdata->vif.type != IEEE80211_IF_TYPE_MNTR ||
+		    !(sdata->u.mntr_flags & MONITOR_FLAG_COOK_FRAMES))
+			continue;
+
+		if (prev_dev) {
+			skb2 = skb_clone(skb, GFP_ATOMIC);
+			if (skb2) {
+				skb2->dev = prev_dev;
+				netif_rx(skb2);
+			}
+		}
+
+		prev_dev = sdata->dev;
+		sdata->dev->stats.rx_packets++;
+		sdata->dev->stats.rx_bytes += skb->len;
+	}
+
+	if (prev_dev) {
+		skb->dev = prev_dev;
+		netif_rx(skb);
+		skb = NULL;
+	} else
+		goto out_free_skb;
+
+	rx->flags |= IEEE80211_TXRXD_RX_CMNTR_REPORTED;
+	return;
+
+ out_free_skb:
+	dev_kfree_skb(skb);
+}
+
 typedef ieee80211_rx_result (*ieee80211_rx_handler)(struct ieee80211_txrx_data *);
 static ieee80211_rx_handler ieee80211_rx_handlers[] =
 {
@@ -1574,9 +1657,11 @@ static void ieee80211_invoke_rx_handlers
 	}
 
 	switch (res) {
+	case RX_CONTINUE:
 	case RX_DROP_MONITOR:
+		ieee80211_rx_cooked_monitor(rx);
+		break;
 	case RX_DROP_UNUSABLE:
-	case RX_CONTINUE:
 		dev_kfree_skb(rx->skb);
 		break;
 	}

-- 

