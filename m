Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:38527 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753616AbXIZNYZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Sep 2007 09:24:25 -0400
Message-Id: <20070926132131.329791000@sipsolutions.net>
References: <20070926131938.575572000@sipsolutions.net>
Date: Wed, 26 Sep 2007 15:19:39 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, flamingice@sourmilk.net
Subject: [patch 01/12] mac80211: pass frames to monitor interfaces early
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This makes mac80211 pass all frames to monitor interfaces early
before all receive processing with the benefit that only a single
copy needs to be made, all monitors can receive clones of the skb
and if the frame will be discarded we don't even need to make a
single copy.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

---
 net/mac80211/rx.c |  350 ++++++++++++++++++++++++++++++++++--------------------
 1 file changed, 226 insertions(+), 124 deletions(-)

--- wireless-dev.orig/net/mac80211/rx.c	2007-09-25 23:28:22.951572917 +0200
+++ wireless-dev/net/mac80211/rx.c	2007-09-25 23:29:33.141601345 +0200
@@ -25,6 +25,207 @@
 #include "tkip.h"
 #include "wme.h"
 
+/*
+ * monitor mode reception
+ *
+ * This function cleans up the SKB, i.e. it removes all the stuff
+ * only useful for monitoring.
+ */
+static struct sk_buff *remove_monitor_info(struct ieee80211_local *local,
+					   struct sk_buff *skb,
+					   int rtap_len)
+{
+	skb_pull(skb, rtap_len);
+
+	if (local->hw.flags & IEEE80211_HW_RX_INCLUDES_FCS) {
+		if (likely(skb->len > FCS_LEN))
+			skb_trim(skb, skb->len - FCS_LEN);
+		else {
+			/* driver bug */
+			WARN_ON(1);
+			dev_kfree_skb(skb);
+			skb = NULL;
+		}
+	}
+
+	return skb;
+}
+
+static inline int should_drop_frame(struct ieee80211_rx_status *status,
+				    struct sk_buff *skb,
+				    int present_fcs_len,
+				    int radiotap_len)
+{
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
+
+	if (status->flag & (RX_FLAG_FAILED_FCS_CRC | RX_FLAG_FAILED_PLCP_CRC))
+		return 1;
+	if (unlikely(skb->len < 16 + present_fcs_len + radiotap_len))
+		return 1;
+	if ((hdr->frame_control & cpu_to_le16(IEEE80211_FCTL_FTYPE)) ==
+			cpu_to_le16(IEEE80211_FTYPE_CTL))
+		return 1;
+	return 0;
+}
+
+/*
+ * This function copies a received frame to all monitor interfaces and
+ * returns a cleaned-up SKB that no longer includes the FCS nor the
+ * radiotap header the driver might have added.
+ */
+static struct sk_buff *
+ieee80211_rx_monitor(struct ieee80211_local *local, struct sk_buff *origskb,
+		     struct ieee80211_rx_status *status)
+{
+	struct ieee80211_sub_if_data *sdata;
+	struct ieee80211_rate *rate;
+	int needed_headroom = 0;
+	struct ieee80211_rtap_hdr {
+		struct ieee80211_radiotap_header hdr;
+		u8 flags;
+		u8 rate;
+		__le16 chan_freq;
+		__le16 chan_flags;
+		u8 antsignal;
+		u8 padding_for_rxflags;
+		__le16 rx_flags;
+	} __attribute__ ((packed)) *rthdr;
+	struct sk_buff *skb, *skb2;
+	struct net_device *prev_dev = NULL;
+	int present_fcs_len = 0;
+	int rtap_len = 0;
+
+	/*
+	 * First, we may need to make a copy of the skb because
+	 *  (1) we need to modify it for radiotap (if not present), and
+	 *  (2) the other RX handlers will modify the skb we got.
+	 *
+	 * We don't need to, of course, if we aren't going to return
+	 * the SKB because it has a bad FCS/PLCP checksum.
+	 */
+	if (status->flag & RX_FLAG_RADIOTAP)
+		rtap_len = ieee80211_get_radiotap_len(origskb->data);
+	else
+		needed_headroom = sizeof(*rthdr);
+
+	if (local->hw.flags & IEEE80211_HW_RX_INCLUDES_FCS)
+		present_fcs_len = FCS_LEN;
+
+	if (!local->monitors) {
+		if (should_drop_frame(status, origskb, present_fcs_len,
+				      rtap_len)) {
+			dev_kfree_skb(origskb);
+			return NULL;
+		}
+
+		return remove_monitor_info(local, origskb, rtap_len);
+	}
+
+	if (should_drop_frame(status, origskb, present_fcs_len, rtap_len)) {
+		/* only need to expand headroom if necessary */
+		skb = origskb;
+		origskb = NULL;
+
+		/*
+		 * This shouldn't trigger often because most devices have an
+		 * RX header they pull before we get here, and that should
+		 * be big enough for our radiotap information. We should
+		 * probably export the length to drivers so that we can have
+		 * them allocate enough headroom to start with.
+		 */
+		if (skb_headroom(skb) < needed_headroom &&
+		    pskb_expand_head(skb, sizeof(*rthdr), 0, GFP_ATOMIC)) {
+		    	dev_kfree_skb(skb);
+			return NULL;
+		}
+	} else {
+		/*
+		 * Need to make a copy and possibly remove radiotap header
+		 * and FCS from the original.
+		 */
+		skb = skb_copy_expand(origskb, needed_headroom, 0, GFP_ATOMIC);
+
+		origskb = remove_monitor_info(local, origskb, rtap_len);
+
+		if (!skb)
+			return origskb;
+	}
+
+	/* if necessary, prepend radiotap information */
+	if (!(status->flag & RX_FLAG_RADIOTAP)) {
+		rthdr = (void *) skb_push(skb, sizeof(*rthdr));
+		memset(rthdr, 0, sizeof(*rthdr));
+		rthdr->hdr.it_len = cpu_to_le16(sizeof(*rthdr));
+		rthdr->hdr.it_present =
+			cpu_to_le32((1 << IEEE80211_RADIOTAP_FLAGS) |
+				    (1 << IEEE80211_RADIOTAP_RATE) |
+				    (1 << IEEE80211_RADIOTAP_CHANNEL) |
+				    (1 << IEEE80211_RADIOTAP_DB_ANTSIGNAL) |
+				    (1 << IEEE80211_RADIOTAP_RX_FLAGS));
+		rthdr->flags = local->hw.flags & IEEE80211_HW_RX_INCLUDES_FCS ?
+			       IEEE80211_RADIOTAP_F_FCS : 0;
+
+		/* FIXME: when radiotap gets a 'bad PLCP' flag use it here */
+		rthdr->rx_flags = 0;
+		if (status->flag &
+		    (RX_FLAG_FAILED_FCS_CRC | RX_FLAG_FAILED_PLCP_CRC))
+			rthdr->rx_flags |=
+				cpu_to_le16(IEEE80211_RADIOTAP_F_RX_BADFCS);
+
+		rate = ieee80211_get_rate(local, status->phymode,
+					  status->rate);
+		if (rate)
+			rthdr->rate = rate->rate / 5;
+
+		rthdr->chan_freq = cpu_to_le16(status->freq);
+
+		if (status->phymode == MODE_IEEE80211A)
+			rthdr->chan_flags =
+				cpu_to_le16(IEEE80211_CHAN_OFDM |
+					    IEEE80211_CHAN_5GHZ);
+		else
+			rthdr->chan_flags =
+				cpu_to_le16(IEEE80211_CHAN_DYN |
+					    IEEE80211_CHAN_2GHZ);
+
+		rthdr->antsignal = status->ssi;
+	}
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
+		if (sdata->type != IEEE80211_IF_TYPE_MNTR)
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
+	} else
+		dev_kfree_skb(skb);
+
+	return origskb;
+}
+
+
 /* pre-rx handlers
  *
  * these don't have dev/sdata fields in the rx data
@@ -132,100 +333,6 @@ ieee80211_rx_h_if_stats(struct ieee80211
 	return TXRX_CONTINUE;
 }
 
-static void
-ieee80211_rx_monitor(struct net_device *dev, struct sk_buff *skb,
-		     struct ieee80211_rx_status *status)
-{
-	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
-	struct ieee80211_rate *rate;
-	struct ieee80211_rtap_hdr {
-		struct ieee80211_radiotap_header hdr;
-		u8 flags;
-		u8 rate;
-		__le16 chan_freq;
-		__le16 chan_flags;
-		u8 antsignal;
-		u8 padding_for_rxflags;
-		__le16 rx_flags;
-	} __attribute__ ((packed)) *rthdr;
-
-	skb->dev = dev;
-
-	if (status->flag & RX_FLAG_RADIOTAP)
-		goto out;
-
-	if (skb_headroom(skb) < sizeof(*rthdr)) {
-		I802_DEBUG_INC(local->rx_expand_skb_head);
-		if (pskb_expand_head(skb, sizeof(*rthdr), 0, GFP_ATOMIC)) {
-			dev_kfree_skb(skb);
-			return;
-		}
-	}
-
-	rthdr = (struct ieee80211_rtap_hdr *) skb_push(skb, sizeof(*rthdr));
-	memset(rthdr, 0, sizeof(*rthdr));
-	rthdr->hdr.it_len = cpu_to_le16(sizeof(*rthdr));
-	rthdr->hdr.it_present =
-		cpu_to_le32((1 << IEEE80211_RADIOTAP_FLAGS) |
-			    (1 << IEEE80211_RADIOTAP_RATE) |
-			    (1 << IEEE80211_RADIOTAP_CHANNEL) |
-			    (1 << IEEE80211_RADIOTAP_DB_ANTSIGNAL) |
-			    (1 << IEEE80211_RADIOTAP_RX_FLAGS));
-	rthdr->flags = local->hw.flags & IEEE80211_HW_RX_INCLUDES_FCS ?
-		       IEEE80211_RADIOTAP_F_FCS : 0;
-
-	/* FIXME: when radiotap gets a 'bad PLCP' flag use it here */
-	rthdr->rx_flags = 0;
-	if (status->flag &
-	    (RX_FLAG_FAILED_FCS_CRC | RX_FLAG_FAILED_PLCP_CRC))
-		rthdr->rx_flags |= cpu_to_le16(IEEE80211_RADIOTAP_F_RX_BADFCS);
-
-	rate = ieee80211_get_rate(local, status->phymode, status->rate);
-	if (rate)
-		rthdr->rate = rate->rate / 5;
-
-	rthdr->chan_freq = cpu_to_le16(status->freq);
-	rthdr->chan_flags =
-		status->phymode == MODE_IEEE80211A ?
-		cpu_to_le16(IEEE80211_CHAN_OFDM | IEEE80211_CHAN_5GHZ) :
-		cpu_to_le16(IEEE80211_CHAN_DYN | IEEE80211_CHAN_2GHZ);
-	rthdr->antsignal = status->ssi;
-
- out:
-	dev->stats.rx_packets++;
-	dev->stats.rx_bytes += skb->len;
-
-	skb_set_mac_header(skb, 0);
-	skb->ip_summed = CHECKSUM_UNNECESSARY;
-	skb->pkt_type = PACKET_OTHERHOST;
-	skb->protocol = htons(ETH_P_802_2);
-	memset(skb->cb, 0, sizeof(skb->cb));
-	netif_rx(skb);
-}
-
-static ieee80211_txrx_result
-ieee80211_rx_h_monitor(struct ieee80211_txrx_data *rx)
-{
-	if (rx->sdata->type == IEEE80211_IF_TYPE_MNTR) {
-		ieee80211_rx_monitor(rx->dev, rx->skb, rx->u.rx.status);
-		return TXRX_QUEUED;
-	}
-
-	/*
-	 * Drop frames with failed FCS/PLCP checksums here, they are only
-	 * relevant for monitor mode, the rest of the stack should never
-	 * see them.
-	 */
-	if (rx->u.rx.status->flag &
-	    (RX_FLAG_FAILED_FCS_CRC | RX_FLAG_FAILED_PLCP_CRC))
-		return TXRX_DROP;
-
-	if (rx->u.rx.status->flag & RX_FLAG_RADIOTAP)
-		skb_pull(rx->skb, ieee80211_get_radiotap_len(rx->skb->data));
-
-	return TXRX_CONTINUE;
-}
-
 static ieee80211_txrx_result
 ieee80211_rx_h_passive_scan(struct ieee80211_txrx_data *rx)
 {
@@ -266,10 +373,6 @@ ieee80211_rx_h_check(struct ieee80211_tx
 			rx->sta->last_seq_ctrl[rx->u.rx.queue] = hdr->seq_ctrl;
 	}
 
-	if ((rx->local->hw.flags & IEEE80211_HW_RX_INCLUDES_FCS) &&
-	    rx->skb->len > FCS_LEN)
-		skb_trim(rx->skb, rx->skb->len - FCS_LEN);
-
 	if (unlikely(rx->skb->len < 16)) {
 		I802_DEBUG_INC(rx->local->rx_handlers_drop_short);
 		return TXRX_DROP;
@@ -1264,7 +1367,6 @@ static void ieee80211_rx_michael_mic_rep
 ieee80211_rx_handler ieee80211_rx_handlers[] =
 {
 	ieee80211_rx_h_if_stats,
-	ieee80211_rx_h_monitor,
 	ieee80211_rx_h_passive_scan,
 	ieee80211_rx_h_check,
 	ieee80211_rx_h_load_key,
@@ -1371,16 +1473,10 @@ void __ieee80211_rx(struct ieee80211_hw 
 	struct ieee80211_hdr *hdr;
 	struct ieee80211_txrx_data rx;
 	u16 type;
-	int radiotap_len = 0, prepres;
+	int prepres;
 	struct ieee80211_sub_if_data *prev = NULL;
 	struct sk_buff *skb_new;
 	u8 *bssid;
-	int bogon;
-
-	if (status->flag & RX_FLAG_RADIOTAP) {
-		radiotap_len = ieee80211_get_radiotap_len(skb->data);
-		skb_pull(skb, radiotap_len);
-	}
 
 	/*
 	 * key references and virtual interfaces are protected using RCU
@@ -1389,30 +1485,35 @@ void __ieee80211_rx(struct ieee80211_hw 
 	 */
 	rcu_read_lock();
 
+	/*
+	 * Frames with failed FCS/PLCP checksum are not returned,
+	 * all other frames are returned without radiotap header
+	 * if it was previously present.
+	 * Also, frames with less than 16 bytes are dropped.
+	 */
+	skb = ieee80211_rx_monitor(local, skb, status);
+	if (!skb) {
+		rcu_read_unlock();
+		return;
+	}
+
 	hdr = (struct ieee80211_hdr *) skb->data;
 	memset(&rx, 0, sizeof(rx));
 	rx.skb = skb;
 	rx.local = local;
 
 	rx.u.rx.status = status;
-	rx.fc = skb->len >= 2 ? le16_to_cpu(hdr->frame_control) : 0;
+	rx.fc = le16_to_cpu(hdr->frame_control);
 	type = rx.fc & IEEE80211_FCTL_FTYPE;
 
-	bogon = status->flag & (RX_FLAG_FAILED_FCS_CRC |
-				RX_FLAG_FAILED_PLCP_CRC);
-
-	if (!bogon && (type == IEEE80211_FTYPE_DATA ||
-		       type == IEEE80211_FTYPE_MGMT))
+	if (type == IEEE80211_FTYPE_DATA || type == IEEE80211_FTYPE_MGMT)
 		local->dot11ReceivedFragmentCount++;
 
-	if (!bogon && skb->len >= 16) {
-		sta = rx.sta = sta_info_get(local, hdr->addr2);
-		if (sta) {
-			rx.dev = rx.sta->dev;
-			rx.sdata = IEEE80211_DEV_TO_SUB_IF(rx.dev);
-		}
-	} else
-		sta = rx.sta = NULL;
+	sta = rx.sta = sta_info_get(local, hdr->addr2);
+	if (sta) {
+		rx.dev = rx.sta->dev;
+		rx.sdata = IEEE80211_DEV_TO_SUB_IF(rx.dev);
+	}
 
 	if ((status->flag & RX_FLAG_MMIC_ERROR)) {
 		ieee80211_rx_michael_mic_report(local->mdev, hdr, sta, &rx);
@@ -1427,7 +1528,6 @@ void __ieee80211_rx(struct ieee80211_hw 
 		goto end;
 	skb = rx.skb;
 
-	skb_push(skb, radiotap_len);
 	if (sta && !(sta->flags & (WLAN_STA_WDS | WLAN_STA_ASSOC_AP)) &&
 	    !local->iff_promiscs && !is_multicast_ether_addr(hdr->addr1)) {
 		rx.flags |= IEEE80211_TXRXD_RXRA_MATCH;
@@ -1438,14 +1538,16 @@ void __ieee80211_rx(struct ieee80211_hw 
 		return;
 	}
 
-	bssid = ieee80211_get_bssid(hdr, skb->len - radiotap_len);
+	bssid = ieee80211_get_bssid(hdr, skb->len);
 
 	list_for_each_entry_rcu(sdata, &local->interfaces, list) {
-		rx.flags |= IEEE80211_TXRXD_RXRA_MATCH;
-
 		if (!netif_running(sdata->dev))
 			continue;
 
+		if (sdata->type == IEEE80211_IF_TYPE_MNTR)
+			continue;
+
+		rx.flags |= IEEE80211_TXRXD_RXRA_MATCH;
 		prepres = prepare_for_handlers(sdata, bssid, &rx, hdr);
 		/* prepare_for_handlers can change sta */
 		sta = rx.sta;

-- 

