Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:40596 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763966AbYBVOI7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Feb 2008 09:08:59 -0500
Message-Id: <20080222111750.156391000@sipsolutions.net> (sfid-20080222_140906_567902_0339A3B8)
References: <20080222111644.183587000@sipsolutions.net>
Date: Fri, 22 Feb 2008 12:16:49 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Ron Rindjunsky <ron.rindjunsky@intel.com>
Subject: [PATCH 5/8] mac80211: split ieee80211_txrx_data
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Split it into ieee80211_tx_data and ieee80211_rx_data to clarify
usage/flag usage and remove the stupid union thing.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/ieee80211_i.h |   86 ++++++++-------
 net/mac80211/rx.c          |  159 ++++++++++++++---------------
 net/mac80211/tx.c          |  244 ++++++++++++++++++++++-----------------------
 net/mac80211/util.c        |    8 -
 net/mac80211/wep.c         |   24 ++--
 net/mac80211/wep.h         |    4 
 net/mac80211/wpa.c         |   80 +++++++-------
 net/mac80211/wpa.h         |   12 +-
 8 files changed, 313 insertions(+), 304 deletions(-)

--- everything.orig/net/mac80211/ieee80211_i.h	2008-02-21 22:09:30.000000000 +0100
+++ everything/net/mac80211/ieee80211_i.h	2008-02-21 22:09:32.000000000 +0100
@@ -113,26 +113,51 @@ typedef unsigned __bitwise__ ieee80211_t
 #define TX_DROP		((__force ieee80211_tx_result) 1u)
 #define TX_QUEUED	((__force ieee80211_tx_result) 2u)
 
+#define IEEE80211_TX_FRAGMENTED		BIT(0)
+#define IEEE80211_TX_UNICAST		BIT(1)
+#define IEEE80211_TX_PS_BUFFERED	BIT(2)
+#define IEEE80211_TX_PROBE_LAST_FRAG	BIT(3)
+#define IEEE80211_TX_INJECTED		BIT(4)
+
+struct ieee80211_tx_data {
+	struct sk_buff *skb;
+	struct net_device *dev;
+	struct ieee80211_local *local;
+	struct ieee80211_sub_if_data *sdata;
+	struct sta_info *sta;
+	u16 fc, ethertype;
+	struct ieee80211_key *key;
+	unsigned int flags;
+
+	struct ieee80211_tx_control *control;
+	struct ieee80211_channel *channel;
+	struct ieee80211_rate *rate;
+	/* use this rate (if set) for last fragment; rate can
+	 * be set to lower rate for the first fragments, e.g.,
+	 * when using CTS protection with IEEE 802.11g. */
+	struct ieee80211_rate *last_frag_rate;
+
+	/* Extra fragments (in addition to the first fragment
+	 * in skb) */
+	int num_extra_frag;
+	struct sk_buff **extra_frag;
+};
+
+
 typedef unsigned __bitwise__ ieee80211_rx_result;
 #define RX_CONTINUE		((__force ieee80211_rx_result) 0u)
 #define RX_DROP_UNUSABLE	((__force ieee80211_rx_result) 1u)
 #define RX_DROP_MONITOR		((__force ieee80211_rx_result) 2u)
 #define RX_QUEUED		((__force ieee80211_rx_result) 3u)
 
-
-/* flags used in struct ieee80211_txrx_data.flags */
-/* whether the MSDU was fragmented */
-#define IEEE80211_TXRXD_FRAGMENTED		BIT(0)
-#define IEEE80211_TXRXD_TXUNICAST		BIT(1)
-#define IEEE80211_TXRXD_TXPS_BUFFERED		BIT(2)
-#define IEEE80211_TXRXD_TXPROBE_LAST_FRAG	BIT(3)
-#define IEEE80211_TXRXD_RXIN_SCAN		BIT(4)
+#define IEEE80211_RX_IN_SCAN		BIT(0)
 /* frame is destined to interface currently processed (incl. multicast frames) */
-#define IEEE80211_TXRXD_RXRA_MATCH		BIT(5)
-#define IEEE80211_TXRXD_TX_INJECTED		BIT(6)
-#define IEEE80211_TXRXD_RX_AMSDU		BIT(7)
-#define IEEE80211_TXRXD_RX_CMNTR_REPORTED	BIT(8)
-struct ieee80211_txrx_data {
+#define IEEE80211_RX_RA_MATCH		BIT(1)
+#define IEEE80211_RX_AMSDU		BIT(2)
+#define IEEE80211_RX_CMNTR_REPORTED	BIT(3)
+#define IEEE80211_RX_FRAGMENTED		BIT(4)
+
+struct ieee80211_rx_data {
 	struct sk_buff *skb;
 	struct net_device *dev;
 	struct ieee80211_local *local;
@@ -141,31 +166,14 @@ struct ieee80211_txrx_data {
 	u16 fc, ethertype;
 	struct ieee80211_key *key;
 	unsigned int flags;
-	union {
-		struct {
-			struct ieee80211_tx_control *control;
-			struct ieee80211_channel *channel;
-			struct ieee80211_rate *rate;
-			/* use this rate (if set) for last fragment; rate can
-			 * be set to lower rate for the first fragments, e.g.,
-			 * when using CTS protection with IEEE 802.11g. */
-			struct ieee80211_rate *last_frag_rate;
-
-			/* Extra fragments (in addition to the first fragment
-			 * in skb) */
-			int num_extra_frag;
-			struct sk_buff **extra_frag;
-		} tx;
-		struct {
-			struct ieee80211_rx_status *status;
-			struct ieee80211_rate *rate;
-			int sent_ps_buffered;
-			int queue;
-			int load;
-			u32 tkip_iv32;
-			u16 tkip_iv16;
-		} rx;
-	} u;
+
+	struct ieee80211_rx_status *status;
+	struct ieee80211_rate *rate;
+	int sent_ps_buffered;
+	int queue;
+	int load;
+	u32 tkip_iv32;
+	u16 tkip_iv16;
 };
 
 /* flags used in struct ieee80211_tx_packet_data.flags */
@@ -658,7 +666,7 @@ static inline int ieee80211_bssid_match(
 int ieee80211_hw_config(struct ieee80211_local *local);
 int ieee80211_if_config(struct net_device *dev);
 int ieee80211_if_config_beacon(struct net_device *dev);
-void ieee80211_tx_set_iswep(struct ieee80211_txrx_data *tx);
+void ieee80211_tx_set_protected(struct ieee80211_tx_data *tx);
 int ieee80211_if_update_wds(struct net_device *dev, u8 *remote_addr);
 void ieee80211_if_setup(struct net_device *dev);
 int ieee80211_hw_config_ht(struct ieee80211_local *local, int enable_ht,
--- everything.orig/net/mac80211/rx.c	2008-02-21 22:09:30.000000000 +0100
+++ everything/net/mac80211/rx.c	2008-02-21 22:09:32.000000000 +0100
@@ -250,7 +250,7 @@ ieee80211_rx_monitor(struct ieee80211_lo
 }
 
 
-static void ieee80211_parse_qos(struct ieee80211_txrx_data *rx)
+static void ieee80211_parse_qos(struct ieee80211_rx_data *rx)
 {
 	u8 *data = rx->skb->data;
 	int tid;
@@ -261,9 +261,9 @@ static void ieee80211_parse_qos(struct i
 		/* frame has qos control */
 		tid = qc[0] & QOS_CONTROL_TID_MASK;
 		if (qc[0] & IEEE80211_QOS_CONTROL_A_MSDU_PRESENT)
-			rx->flags |= IEEE80211_TXRXD_RX_AMSDU;
+			rx->flags |= IEEE80211_RX_AMSDU;
 		else
-			rx->flags &= ~IEEE80211_TXRXD_RX_AMSDU;
+			rx->flags &= ~IEEE80211_RX_AMSDU;
 	} else {
 		if (unlikely((rx->fc & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_MGMT)) {
 			/* Separate TID for management frames */
@@ -279,13 +279,13 @@ static void ieee80211_parse_qos(struct i
 	if (rx->sta)
 		I802_DEBUG_INC(rx->sta->wme_rx_queue[tid]);
 
-	rx->u.rx.queue = tid;
+	rx->queue = tid;
 	/* Set skb->priority to 1d tag if highest order bit of TID is not set.
 	 * For now, set skb->priority to 0 for other cases. */
 	rx->skb->priority = (tid > 7) ? 0 : tid;
 }
 
-static void ieee80211_verify_ip_alignment(struct ieee80211_txrx_data *rx)
+static void ieee80211_verify_ip_alignment(struct ieee80211_rx_data *rx)
 {
 #ifdef CONFIG_MAC80211_DEBUG_PACKET_ALIGNMENT
 	int hdrlen;
@@ -313,7 +313,7 @@ static void ieee80211_verify_ip_alignmen
 	 * to move the 802.11 header further back in that case.
 	 */
 	hdrlen = ieee80211_get_hdrlen(rx->fc);
-	if (rx->flags & IEEE80211_TXRXD_RX_AMSDU)
+	if (rx->flags & IEEE80211_RX_AMSDU)
 		hdrlen += ETH_HLEN;
 	WARN_ON_ONCE(((unsigned long)(rx->skb->data + hdrlen)) & 3);
 #endif
@@ -356,32 +356,32 @@ static u32 ieee80211_rx_load_stats(struc
 /* rx handlers */
 
 static ieee80211_rx_result
-ieee80211_rx_h_if_stats(struct ieee80211_txrx_data *rx)
+ieee80211_rx_h_if_stats(struct ieee80211_rx_data *rx)
 {
 	if (rx->sta)
-		rx->sta->channel_use_raw += rx->u.rx.load;
-	rx->sdata->channel_use_raw += rx->u.rx.load;
+		rx->sta->channel_use_raw += rx->load;
+	rx->sdata->channel_use_raw += rx->load;
 	return RX_CONTINUE;
 }
 
 static ieee80211_rx_result
-ieee80211_rx_h_passive_scan(struct ieee80211_txrx_data *rx)
+ieee80211_rx_h_passive_scan(struct ieee80211_rx_data *rx)
 {
 	struct ieee80211_local *local = rx->local;
 	struct sk_buff *skb = rx->skb;
 
 	if (unlikely(local->sta_hw_scanning))
-		return ieee80211_sta_rx_scan(rx->dev, skb, rx->u.rx.status);
+		return ieee80211_sta_rx_scan(rx->dev, skb, rx->status);
 
 	if (unlikely(local->sta_sw_scanning)) {
 		/* drop all the other packets during a software scan anyway */
-		if (ieee80211_sta_rx_scan(rx->dev, skb, rx->u.rx.status)
+		if (ieee80211_sta_rx_scan(rx->dev, skb, rx->status)
 		    != RX_QUEUED)
 			dev_kfree_skb(skb);
 		return RX_QUEUED;
 	}
 
-	if (unlikely(rx->flags & IEEE80211_TXRXD_RXIN_SCAN)) {
+	if (unlikely(rx->flags & IEEE80211_RX_IN_SCAN)) {
 		/* scanning finished during invoking of handlers */
 		I802_DEBUG_INC(local->rx_handlers_drop_passive_scan);
 		return RX_DROP_UNUSABLE;
@@ -391,7 +391,7 @@ ieee80211_rx_h_passive_scan(struct ieee8
 }
 
 static ieee80211_rx_result
-ieee80211_rx_h_check(struct ieee80211_txrx_data *rx)
+ieee80211_rx_h_check(struct ieee80211_rx_data *rx)
 {
 	struct ieee80211_hdr *hdr;
 	hdr = (struct ieee80211_hdr *) rx->skb->data;
@@ -399,15 +399,15 @@ ieee80211_rx_h_check(struct ieee80211_tx
 	/* Drop duplicate 802.11 retransmissions (IEEE 802.11 Chap. 9.2.9) */
 	if (rx->sta && !is_multicast_ether_addr(hdr->addr1)) {
 		if (unlikely(rx->fc & IEEE80211_FCTL_RETRY &&
-			     rx->sta->last_seq_ctrl[rx->u.rx.queue] ==
+			     rx->sta->last_seq_ctrl[rx->queue] ==
 			     hdr->seq_ctrl)) {
-			if (rx->flags & IEEE80211_TXRXD_RXRA_MATCH) {
+			if (rx->flags & IEEE80211_RX_RA_MATCH) {
 				rx->local->dot11FrameDuplicateCount++;
 				rx->sta->num_duplicates++;
 			}
 			return RX_DROP_MONITOR;
 		} else
-			rx->sta->last_seq_ctrl[rx->u.rx.queue] = hdr->seq_ctrl;
+			rx->sta->last_seq_ctrl[rx->queue] = hdr->seq_ctrl;
 	}
 
 	if (unlikely(rx->skb->len < 16)) {
@@ -431,7 +431,7 @@ ieee80211_rx_h_check(struct ieee80211_tx
 		if ((!(rx->fc & IEEE80211_FCTL_FROMDS) &&
 		     !(rx->fc & IEEE80211_FCTL_TODS) &&
 		     (rx->fc & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_DATA)
-		    || !(rx->flags & IEEE80211_TXRXD_RXRA_MATCH)) {
+		    || !(rx->flags & IEEE80211_RX_RA_MATCH)) {
 			/* Drop IBSS frames and frames for other hosts
 			 * silently. */
 			return RX_DROP_MONITOR;
@@ -445,7 +445,7 @@ ieee80211_rx_h_check(struct ieee80211_tx
 
 
 static ieee80211_rx_result
-ieee80211_rx_h_decrypt(struct ieee80211_txrx_data *rx)
+ieee80211_rx_h_decrypt(struct ieee80211_rx_data *rx)
 {
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) rx->skb->data;
 	int keyidx;
@@ -486,7 +486,7 @@ ieee80211_rx_h_decrypt(struct ieee80211_
 	 * No point in finding a key and decrypting if the frame is neither
 	 * addressed to us nor a multicast frame.
 	 */
-	if (!(rx->flags & IEEE80211_TXRXD_RXRA_MATCH))
+	if (!(rx->flags & IEEE80211_RX_RA_MATCH))
 		return RX_CONTINUE;
 
 	if (rx->sta)
@@ -504,8 +504,8 @@ ieee80211_rx_h_decrypt(struct ieee80211_
 		 * we somehow allow the driver to tell us which key
 		 * the hardware used if this flag is set?
 		 */
-		if ((rx->u.rx.status->flag & RX_FLAG_DECRYPTED) &&
-		    (rx->u.rx.status->flag & RX_FLAG_IV_STRIPPED))
+		if ((rx->status->flag & RX_FLAG_DECRYPTED) &&
+		    (rx->status->flag & RX_FLAG_IV_STRIPPED))
 			return RX_CONTINUE;
 
 		hdrlen = ieee80211_get_hdrlen(rx->fc);
@@ -546,8 +546,8 @@ ieee80211_rx_h_decrypt(struct ieee80211_
 	/* Check for weak IVs if possible */
 	if (rx->sta && rx->key->conf.alg == ALG_WEP &&
 	    ((rx->fc & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_DATA) &&
-	    (!(rx->u.rx.status->flag & RX_FLAG_IV_STRIPPED) ||
-	     !(rx->u.rx.status->flag & RX_FLAG_DECRYPTED)) &&
+	    (!(rx->status->flag & RX_FLAG_IV_STRIPPED) ||
+	     !(rx->status->flag & RX_FLAG_DECRYPTED)) &&
 	    ieee80211_wep_is_weak_iv(rx->skb, rx->key))
 		rx->sta->wep_weak_iv_count++;
 
@@ -564,7 +564,7 @@ ieee80211_rx_h_decrypt(struct ieee80211_
 	}
 
 	/* either the frame has been decrypted or will be dropped */
-	rx->u.rx.status->flag |= RX_FLAG_DECRYPTED;
+	rx->status->flag |= RX_FLAG_DECRYPTED;
 
 	return result;
 }
@@ -634,7 +634,7 @@ static int ap_sta_ps_end(struct net_devi
 }
 
 static ieee80211_rx_result
-ieee80211_rx_h_sta_process(struct ieee80211_txrx_data *rx)
+ieee80211_rx_h_sta_process(struct ieee80211_rx_data *rx)
 {
 	struct sta_info *sta = rx->sta;
 	struct net_device *dev = rx->dev;
@@ -661,20 +661,20 @@ ieee80211_rx_h_sta_process(struct ieee80
 		sta->last_rx = jiffies;
 	}
 
-	if (!(rx->flags & IEEE80211_TXRXD_RXRA_MATCH))
+	if (!(rx->flags & IEEE80211_RX_RA_MATCH))
 		return RX_CONTINUE;
 
 	sta->rx_fragments++;
 	sta->rx_bytes += rx->skb->len;
-	sta->last_rssi = rx->u.rx.status->ssi;
-	sta->last_signal = rx->u.rx.status->signal;
-	sta->last_noise = rx->u.rx.status->noise;
+	sta->last_rssi = rx->status->ssi;
+	sta->last_signal = rx->status->signal;
+	sta->last_noise = rx->status->noise;
 
 	if (!(rx->fc & IEEE80211_FCTL_MOREFRAGS)) {
 		/* Change STA power saving mode only in the end of a frame
 		 * exchange sequence */
 		if ((sta->flags & WLAN_STA_PS) && !(rx->fc & IEEE80211_FCTL_PM))
-			rx->u.rx.sent_ps_buffered += ap_sta_ps_end(dev, sta);
+			rx->sent_ps_buffered += ap_sta_ps_end(dev, sta);
 		else if (!(sta->flags & WLAN_STA_PS) &&
 			 (rx->fc & IEEE80211_FCTL_PM))
 			ap_sta_ps_start(dev, sta);
@@ -779,7 +779,7 @@ ieee80211_reassemble_find(struct ieee802
 }
 
 static ieee80211_rx_result
-ieee80211_rx_h_defragment(struct ieee80211_txrx_data *rx)
+ieee80211_rx_h_defragment(struct ieee80211_rx_data *rx)
 {
 	struct ieee80211_hdr *hdr;
 	u16 sc;
@@ -805,14 +805,14 @@ ieee80211_rx_h_defragment(struct ieee802
 	if (frag == 0) {
 		/* This is the first fragment of a new frame. */
 		entry = ieee80211_reassemble_add(rx->sdata, frag, seq,
-						 rx->u.rx.queue, &(rx->skb));
+						 rx->queue, &(rx->skb));
 		if (rx->key && rx->key->conf.alg == ALG_CCMP &&
 		    (rx->fc & IEEE80211_FCTL_PROTECTED)) {
 			/* Store CCMP PN so that we can verify that the next
 			 * fragment has a sequential PN value. */
 			entry->ccmp = 1;
 			memcpy(entry->last_pn,
-			       rx->key->u.ccmp.rx_pn[rx->u.rx.queue],
+			       rx->key->u.ccmp.rx_pn[rx->queue],
 			       CCMP_PN_LEN);
 		}
 		return RX_QUEUED;
@@ -822,7 +822,7 @@ ieee80211_rx_h_defragment(struct ieee802
 	 * fragment cache. Add this fragment to the end of the pending entry.
 	 */
 	entry = ieee80211_reassemble_find(rx->sdata, rx->fc, frag, seq,
-					  rx->u.rx.queue, hdr);
+					  rx->queue, hdr);
 	if (!entry) {
 		I802_DEBUG_INC(rx->local->rx_handlers_drop_defrag);
 		return RX_DROP_MONITOR;
@@ -841,7 +841,7 @@ ieee80211_rx_h_defragment(struct ieee802
 			if (pn[i])
 				break;
 		}
-		rpn = rx->key->u.ccmp.rx_pn[rx->u.rx.queue];
+		rpn = rx->key->u.ccmp.rx_pn[rx->queue];
 		if (memcmp(pn, rpn, CCMP_PN_LEN) != 0) {
 			if (net_ratelimit())
 				printk(KERN_DEBUG "%s: defrag: CCMP PN not "
@@ -882,7 +882,7 @@ ieee80211_rx_h_defragment(struct ieee802
 	}
 
 	/* Complete frame has been reassembled - process it now */
-	rx->flags |= IEEE80211_TXRXD_FRAGMENTED;
+	rx->flags |= IEEE80211_RX_FRAGMENTED;
 
  out:
 	if (rx->sta)
@@ -895,7 +895,7 @@ ieee80211_rx_h_defragment(struct ieee802
 }
 
 static ieee80211_rx_result
-ieee80211_rx_h_ps_poll(struct ieee80211_txrx_data *rx)
+ieee80211_rx_h_ps_poll(struct ieee80211_rx_data *rx)
 {
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(rx->dev);
 	struct sk_buff *skb;
@@ -905,7 +905,7 @@ ieee80211_rx_h_ps_poll(struct ieee80211_
 	if (likely(!rx->sta ||
 		   (rx->fc & IEEE80211_FCTL_FTYPE) != IEEE80211_FTYPE_CTL ||
 		   (rx->fc & IEEE80211_FCTL_STYPE) != IEEE80211_STYPE_PSPOLL ||
-		   !(rx->flags & IEEE80211_TXRXD_RXRA_MATCH)))
+		   !(rx->flags & IEEE80211_RX_RA_MATCH)))
 		return RX_CONTINUE;
 
 	if ((sdata->vif.type != IEEE80211_IF_TYPE_AP) &&
@@ -949,7 +949,7 @@ ieee80211_rx_h_ps_poll(struct ieee80211_
 		if (no_pending_pkts)
 			sta_info_clear_tim_bit(rx->sta);
 #ifdef CONFIG_MAC80211_VERBOSE_PS_DEBUG
-	} else if (!rx->u.rx.sent_ps_buffered) {
+	} else if (!rx->sent_ps_buffered) {
 		/*
 		 * FIXME: This can be the result of a race condition between
 		 *	  us expiring a frame and the station polling for it.
@@ -970,7 +970,7 @@ ieee80211_rx_h_ps_poll(struct ieee80211_
 }
 
 static ieee80211_rx_result
-ieee80211_rx_h_remove_qos_control(struct ieee80211_txrx_data *rx)
+ieee80211_rx_h_remove_qos_control(struct ieee80211_rx_data *rx)
 {
 	u16 fc = rx->fc;
 	u8 *data = rx->skb->data;
@@ -990,7 +990,7 @@ ieee80211_rx_h_remove_qos_control(struct
 }
 
 static int
-ieee80211_802_1x_port_control(struct ieee80211_txrx_data *rx)
+ieee80211_802_1x_port_control(struct ieee80211_rx_data *rx)
 {
 	if (unlikely(!rx->sta || !(rx->sta->flags & WLAN_STA_AUTHORIZED))) {
 #ifdef CONFIG_MAC80211_DEBUG
@@ -1005,13 +1005,13 @@ ieee80211_802_1x_port_control(struct iee
 }
 
 static int
-ieee80211_drop_unencrypted(struct ieee80211_txrx_data *rx)
+ieee80211_drop_unencrypted(struct ieee80211_rx_data *rx)
 {
 	/*
 	 * Pass through unencrypted frames if the hardware has
 	 * decrypted them already.
 	 */
-	if (rx->u.rx.status->flag & RX_FLAG_DECRYPTED)
+	if (rx->status->flag & RX_FLAG_DECRYPTED)
 		return 0;
 
 	/* Drop unencrypted frames if key is set. */
@@ -1028,7 +1028,7 @@ ieee80211_drop_unencrypted(struct ieee80
 }
 
 static int
-ieee80211_data_to_8023(struct ieee80211_txrx_data *rx)
+ieee80211_data_to_8023(struct ieee80211_rx_data *rx)
 {
 	struct net_device *dev = rx->dev;
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) rx->skb->data;
@@ -1160,7 +1160,7 @@ ieee80211_data_to_8023(struct ieee80211_
 /*
  * requires that rx->skb is a frame with ethernet header
  */
-static bool ieee80211_frame_allowed(struct ieee80211_txrx_data *rx)
+static bool ieee80211_frame_allowed(struct ieee80211_rx_data *rx)
 {
 	static const u8 pae_group_addr[ETH_ALEN]
 		= { 0x01, 0x80, 0xC2, 0x00, 0x00, 0x03 };
@@ -1186,7 +1186,7 @@ static bool ieee80211_frame_allowed(stru
  * requires that rx->skb is a frame with ethernet header
  */
 static void
-ieee80211_deliver_skb(struct ieee80211_txrx_data *rx)
+ieee80211_deliver_skb(struct ieee80211_rx_data *rx)
 {
 	struct net_device *dev = rx->dev;
 	struct ieee80211_local *local = rx->local;
@@ -1200,7 +1200,7 @@ ieee80211_deliver_skb(struct ieee80211_t
 
 	if (local->bridge_packets && (sdata->vif.type == IEEE80211_IF_TYPE_AP ||
 				      sdata->vif.type == IEEE80211_IF_TYPE_VLAN) &&
-	    (rx->flags & IEEE80211_TXRXD_RXRA_MATCH)) {
+	    (rx->flags & IEEE80211_RX_RA_MATCH)) {
 		if (is_multicast_ether_addr(ehdr->h_dest)) {
 			/*
 			 * send multicast frames both to higher layers in
@@ -1242,7 +1242,7 @@ ieee80211_deliver_skb(struct ieee80211_t
 }
 
 static ieee80211_rx_result
-ieee80211_rx_h_amsdu(struct ieee80211_txrx_data *rx)
+ieee80211_rx_h_amsdu(struct ieee80211_rx_data *rx)
 {
 	struct net_device *dev = rx->dev;
 	struct ieee80211_local *local = rx->local;
@@ -1262,7 +1262,7 @@ ieee80211_rx_h_amsdu(struct ieee80211_tx
 	if (unlikely(!WLAN_FC_DATA_PRESENT(fc)))
 		return RX_DROP_MONITOR;
 
-	if (!(rx->flags & IEEE80211_TXRXD_RX_AMSDU))
+	if (!(rx->flags & IEEE80211_RX_AMSDU))
 		return RX_CONTINUE;
 
 	err = ieee80211_data_to_8023(rx);
@@ -1359,7 +1359,7 @@ ieee80211_rx_h_amsdu(struct ieee80211_tx
 }
 
 static ieee80211_rx_result
-ieee80211_rx_h_data(struct ieee80211_txrx_data *rx)
+ieee80211_rx_h_data(struct ieee80211_rx_data *rx)
 {
 	struct net_device *dev = rx->dev;
 	u16 fc;
@@ -1390,7 +1390,7 @@ ieee80211_rx_h_data(struct ieee80211_txr
 }
 
 static ieee80211_rx_result
-ieee80211_rx_h_ctrl(struct ieee80211_txrx_data *rx)
+ieee80211_rx_h_ctrl(struct ieee80211_rx_data *rx)
 {
 	struct ieee80211_local *local = rx->local;
 	struct ieee80211_hw *hw = &local->hw;
@@ -1433,18 +1433,18 @@ ieee80211_rx_h_ctrl(struct ieee80211_txr
 }
 
 static ieee80211_rx_result
-ieee80211_rx_h_mgmt(struct ieee80211_txrx_data *rx)
+ieee80211_rx_h_mgmt(struct ieee80211_rx_data *rx)
 {
 	struct ieee80211_sub_if_data *sdata;
 
-	if (!(rx->flags & IEEE80211_TXRXD_RXRA_MATCH))
+	if (!(rx->flags & IEEE80211_RX_RA_MATCH))
 		return RX_DROP_MONITOR;
 
 	sdata = IEEE80211_DEV_TO_SUB_IF(rx->dev);
 	if ((sdata->vif.type == IEEE80211_IF_TYPE_STA ||
 	     sdata->vif.type == IEEE80211_IF_TYPE_IBSS) &&
 	    !(sdata->flags & IEEE80211_SDATA_USERSPACE_MLME))
-		ieee80211_sta_rx_mgmt(rx->dev, rx->skb, rx->u.rx.status);
+		ieee80211_sta_rx_mgmt(rx->dev, rx->skb, rx->status);
 	else
 		return RX_DROP_MONITOR;
 
@@ -1453,7 +1453,7 @@ ieee80211_rx_h_mgmt(struct ieee80211_txr
 
 static void ieee80211_rx_michael_mic_report(struct net_device *dev,
 					    struct ieee80211_hdr *hdr,
-					    struct ieee80211_txrx_data *rx)
+					    struct ieee80211_rx_data *rx)
 {
 	int keyidx, hdrlen;
 	DECLARE_MAC_BUF(mac);
@@ -1523,7 +1523,8 @@ static void ieee80211_rx_michael_mic_rep
 	rx->skb = NULL;
 }
 
-static void ieee80211_rx_cooked_monitor(struct ieee80211_txrx_data *rx)
+/* TODO: use IEEE80211_RX_FRAGMENTED */
+static void ieee80211_rx_cooked_monitor(struct ieee80211_rx_data *rx)
 {
 	struct ieee80211_sub_if_data *sdata;
 	struct ieee80211_local *local = rx->local;
@@ -1536,9 +1537,9 @@ static void ieee80211_rx_cooked_monitor(
 	} __attribute__ ((packed)) *rthdr;
 	struct sk_buff *skb = rx->skb, *skb2;
 	struct net_device *prev_dev = NULL;
-	struct ieee80211_rx_status *status = rx->u.rx.status;
+	struct ieee80211_rx_status *status = rx->status;
 
-	if (rx->flags & IEEE80211_TXRXD_RX_CMNTR_REPORTED)
+	if (rx->flags & IEEE80211_RX_CMNTR_REPORTED)
 		goto out_free_skb;
 
 	if (skb_headroom(skb) < sizeof(*rthdr) &&
@@ -1553,7 +1554,7 @@ static void ieee80211_rx_cooked_monitor(
 			    (1 << IEEE80211_RADIOTAP_RATE) |
 			    (1 << IEEE80211_RADIOTAP_CHANNEL));
 
-	rthdr->rate = rx->u.rx.rate->bitrate / 5;
+	rthdr->rate = rx->rate->bitrate / 5;
 	rthdr->chan_freq = cpu_to_le16(status->freq);
 
 	if (status->band == IEEE80211_BAND_5GHZ)
@@ -1596,14 +1597,14 @@ static void ieee80211_rx_cooked_monitor(
 	} else
 		goto out_free_skb;
 
-	rx->flags |= IEEE80211_TXRXD_RX_CMNTR_REPORTED;
+	rx->flags |= IEEE80211_RX_CMNTR_REPORTED;
 	return;
 
  out_free_skb:
 	dev_kfree_skb(skb);
 }
 
-typedef ieee80211_rx_result (*ieee80211_rx_handler)(struct ieee80211_txrx_data *);
+typedef ieee80211_rx_result (*ieee80211_rx_handler)(struct ieee80211_rx_data *);
 static ieee80211_rx_handler ieee80211_rx_handlers[] =
 {
 	ieee80211_rx_h_if_stats,
@@ -1627,7 +1628,7 @@ static ieee80211_rx_handler ieee80211_rx
 };
 
 static void ieee80211_invoke_rx_handlers(struct ieee80211_sub_if_data *sdata,
-					 struct ieee80211_txrx_data *rx,
+					 struct ieee80211_rx_data *rx,
 					 struct sk_buff *skb)
 {
 	ieee80211_rx_handler *handler;
@@ -1670,7 +1671,7 @@ static void ieee80211_invoke_rx_handlers
 /* main receive path */
 
 static int prepare_for_handlers(struct ieee80211_sub_if_data *sdata,
-				u8 *bssid, struct ieee80211_txrx_data *rx,
+				u8 *bssid, struct ieee80211_rx_data *rx,
 				struct ieee80211_hdr *hdr)
 {
 	int multicast = is_multicast_ether_addr(hdr->addr1);
@@ -1680,15 +1681,15 @@ static int prepare_for_handlers(struct i
 		if (!bssid)
 			return 0;
 		if (!ieee80211_bssid_match(bssid, sdata->u.sta.bssid)) {
-			if (!(rx->flags & IEEE80211_TXRXD_RXIN_SCAN))
+			if (!(rx->flags & IEEE80211_RX_IN_SCAN))
 				return 0;
-			rx->flags &= ~IEEE80211_TXRXD_RXRA_MATCH;
+			rx->flags &= ~IEEE80211_RX_RA_MATCH;
 		} else if (!multicast &&
 			   compare_ether_addr(sdata->dev->dev_addr,
 					      hdr->addr1) != 0) {
 			if (!(sdata->dev->flags & IFF_PROMISC))
 				return 0;
-			rx->flags &= ~IEEE80211_TXRXD_RXRA_MATCH;
+			rx->flags &= ~IEEE80211_RX_RA_MATCH;
 		}
 		break;
 	case IEEE80211_IF_TYPE_IBSS:
@@ -1698,15 +1699,15 @@ static int prepare_for_handlers(struct i
 		    (rx->fc & IEEE80211_FCTL_STYPE) == IEEE80211_STYPE_BEACON)
 			return 1;
 		else if (!ieee80211_bssid_match(bssid, sdata->u.sta.bssid)) {
-			if (!(rx->flags & IEEE80211_TXRXD_RXIN_SCAN))
+			if (!(rx->flags & IEEE80211_RX_IN_SCAN))
 				return 0;
-			rx->flags &= ~IEEE80211_TXRXD_RXRA_MATCH;
+			rx->flags &= ~IEEE80211_RX_RA_MATCH;
 		} else if (!multicast &&
 			   compare_ether_addr(sdata->dev->dev_addr,
 					      hdr->addr1) != 0) {
 			if (!(sdata->dev->flags & IFF_PROMISC))
 				return 0;
-			rx->flags &= ~IEEE80211_TXRXD_RXRA_MATCH;
+			rx->flags &= ~IEEE80211_RX_RA_MATCH;
 		} else if (!rx->sta)
 			rx->sta = ieee80211_ibss_add_sta(sdata->dev, rx->skb,
 							 bssid, hdr->addr2);
@@ -1719,12 +1720,12 @@ static int prepare_for_handlers(struct i
 				return 0;
 		} else if (!ieee80211_bssid_match(bssid,
 					sdata->dev->dev_addr)) {
-			if (!(rx->flags & IEEE80211_TXRXD_RXIN_SCAN))
+			if (!(rx->flags & IEEE80211_RX_IN_SCAN))
 				return 0;
-			rx->flags &= ~IEEE80211_TXRXD_RXRA_MATCH;
+			rx->flags &= ~IEEE80211_RX_RA_MATCH;
 		}
 		if (sdata->dev == sdata->local->mdev &&
-		    !(rx->flags & IEEE80211_TXRXD_RXIN_SCAN))
+		    !(rx->flags & IEEE80211_RX_IN_SCAN))
 			/* do not receive anything via
 			 * master device when not scanning */
 			return 0;
@@ -1761,7 +1762,7 @@ static void __ieee80211_rx_handle_packet
 	struct ieee80211_local *local = hw_to_local(hw);
 	struct ieee80211_sub_if_data *sdata;
 	struct ieee80211_hdr *hdr;
-	struct ieee80211_txrx_data rx;
+	struct ieee80211_rx_data rx;
 	u16 type;
 	int prepares;
 	struct ieee80211_sub_if_data *prev = NULL;
@@ -1773,9 +1774,9 @@ static void __ieee80211_rx_handle_packet
 	rx.skb = skb;
 	rx.local = local;
 
-	rx.u.rx.status = status;
-	rx.u.rx.load = load;
-	rx.u.rx.rate = rate;
+	rx.status = status;
+	rx.load = load;
+	rx.rate = rate;
 	rx.fc = le16_to_cpu(hdr->frame_control);
 	type = rx.fc & IEEE80211_FCTL_FTYPE;
 
@@ -1794,7 +1795,7 @@ static void __ieee80211_rx_handle_packet
 	}
 
 	if (unlikely(local->sta_sw_scanning || local->sta_hw_scanning))
-		rx.flags |= IEEE80211_TXRXD_RXIN_SCAN;
+		rx.flags |= IEEE80211_RX_IN_SCAN;
 
 	ieee80211_parse_qos(&rx);
 	ieee80211_verify_ip_alignment(&rx);
@@ -1809,7 +1810,7 @@ static void __ieee80211_rx_handle_packet
 			continue;
 
 		bssid = ieee80211_get_bssid(hdr, skb->len, sdata->vif.type);
-		rx.flags |= IEEE80211_TXRXD_RXRA_MATCH;
+		rx.flags |= IEEE80211_RX_RA_MATCH;
 		prepares = prepare_for_handlers(sdata, bssid, &rx, hdr);
 
 		if (!prepares)
--- everything.orig/net/mac80211/tx.c	2008-02-21 22:09:30.000000000 +0100
+++ everything/net/mac80211/tx.c	2008-02-21 22:09:32.000000000 +0100
@@ -86,11 +86,11 @@ static inline void ieee80211_dump_frame(
 }
 #endif /* CONFIG_MAC80211_LOWTX_FRAME_DUMP */
 
-static u16 ieee80211_duration(struct ieee80211_txrx_data *tx, int group_addr,
+static u16 ieee80211_duration(struct ieee80211_tx_data *tx, int group_addr,
 			      int next_frag_len)
 {
 	int rate, mrate, erp, dur, i;
-	struct ieee80211_rate *txrate = tx->u.tx.rate;
+	struct ieee80211_rate *txrate = tx->rate;
 	struct ieee80211_local *local = tx->local;
 	struct ieee80211_supported_band *sband;
 
@@ -233,7 +233,7 @@ static int inline is_ieee80211_device(st
 /* tx handlers */
 
 static ieee80211_tx_result
-ieee80211_tx_h_check_assoc(struct ieee80211_txrx_data *tx)
+ieee80211_tx_h_check_assoc(struct ieee80211_tx_data *tx)
 {
 #ifdef CONFIG_MAC80211_VERBOSE_DEBUG
 	struct sk_buff *skb = tx->skb;
@@ -241,7 +241,7 @@ ieee80211_tx_h_check_assoc(struct ieee80
 #endif /* CONFIG_MAC80211_VERBOSE_DEBUG */
 	u32 sta_flags;
 
-	if (unlikely(tx->flags & IEEE80211_TXRXD_TX_INJECTED))
+	if (unlikely(tx->flags & IEEE80211_TX_INJECTED))
 		return TX_CONTINUE;
 
 	if (unlikely(tx->local->sta_sw_scanning) &&
@@ -249,12 +249,12 @@ ieee80211_tx_h_check_assoc(struct ieee80
 	     (tx->fc & IEEE80211_FCTL_STYPE) != IEEE80211_STYPE_PROBE_REQ))
 		return TX_DROP;
 
-	if (tx->flags & IEEE80211_TXRXD_TXPS_BUFFERED)
+	if (tx->flags & IEEE80211_TX_PS_BUFFERED)
 		return TX_CONTINUE;
 
 	sta_flags = tx->sta ? tx->sta->flags : 0;
 
-	if (likely(tx->flags & IEEE80211_TXRXD_TXUNICAST)) {
+	if (likely(tx->flags & IEEE80211_TX_UNICAST)) {
 		if (unlikely(!(sta_flags & WLAN_STA_ASSOC) &&
 			     tx->sdata->vif.type != IEEE80211_IF_TYPE_IBSS &&
 			     (tx->fc & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_DATA)) {
@@ -284,7 +284,7 @@ ieee80211_tx_h_check_assoc(struct ieee80
 }
 
 static ieee80211_tx_result
-ieee80211_tx_h_sequence(struct ieee80211_txrx_data *tx)
+ieee80211_tx_h_sequence(struct ieee80211_tx_data *tx)
 {
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)tx->skb->data;
 
@@ -341,7 +341,7 @@ static void purge_old_ps_buffers(struct 
 }
 
 static ieee80211_tx_result
-ieee80211_tx_h_multicast_ps_buf(struct ieee80211_txrx_data *tx)
+ieee80211_tx_h_multicast_ps_buf(struct ieee80211_tx_data *tx)
 {
 	/*
 	 * broadcast/multicast frame
@@ -378,13 +378,13 @@ ieee80211_tx_h_multicast_ps_buf(struct i
 	}
 
 	/* buffered in hardware */
-	tx->u.tx.control->flags |= IEEE80211_TXCTL_SEND_AFTER_DTIM;
+	tx->control->flags |= IEEE80211_TXCTL_SEND_AFTER_DTIM;
 
 	return TX_CONTINUE;
 }
 
 static ieee80211_tx_result
-ieee80211_tx_h_unicast_ps_buf(struct ieee80211_txrx_data *tx)
+ieee80211_tx_h_unicast_ps_buf(struct ieee80211_tx_data *tx)
 {
 	struct sta_info *sta = tx->sta;
 	DECLARE_MAC_BUF(mac);
@@ -438,32 +438,32 @@ ieee80211_tx_h_unicast_ps_buf(struct iee
 }
 
 static ieee80211_tx_result
-ieee80211_tx_h_ps_buf(struct ieee80211_txrx_data *tx)
+ieee80211_tx_h_ps_buf(struct ieee80211_tx_data *tx)
 {
-	if (unlikely(tx->flags & IEEE80211_TXRXD_TXPS_BUFFERED))
+	if (unlikely(tx->flags & IEEE80211_TX_PS_BUFFERED))
 		return TX_CONTINUE;
 
-	if (tx->flags & IEEE80211_TXRXD_TXUNICAST)
+	if (tx->flags & IEEE80211_TX_UNICAST)
 		return ieee80211_tx_h_unicast_ps_buf(tx);
 	else
 		return ieee80211_tx_h_multicast_ps_buf(tx);
 }
 
 static ieee80211_tx_result
-ieee80211_tx_h_select_key(struct ieee80211_txrx_data *tx)
+ieee80211_tx_h_select_key(struct ieee80211_tx_data *tx)
 {
 	struct ieee80211_key *key;
 	u16 fc = tx->fc;
 
-	if (unlikely(tx->u.tx.control->flags & IEEE80211_TXCTL_DO_NOT_ENCRYPT))
+	if (unlikely(tx->control->flags & IEEE80211_TXCTL_DO_NOT_ENCRYPT))
 		tx->key = NULL;
 	else if (tx->sta && (key = rcu_dereference(tx->sta->key)))
 		tx->key = key;
 	else if ((key = rcu_dereference(tx->sdata->default_key)))
 		tx->key = key;
 	else if (tx->sdata->drop_unencrypted &&
-		 !(tx->u.tx.control->flags & IEEE80211_TXCTL_EAPOL_FRAME) &&
-		 !(tx->flags & IEEE80211_TXRXD_TX_INJECTED)) {
+		 !(tx->control->flags & IEEE80211_TXCTL_EAPOL_FRAME) &&
+		 !(tx->flags & IEEE80211_TX_INJECTED)) {
 		I802_DEBUG_INC(tx->local->tx_handlers_drop_unencrypted);
 		return TX_DROP;
 	} else
@@ -492,13 +492,13 @@ ieee80211_tx_h_select_key(struct ieee802
 	}
 
 	if (!tx->key || !(tx->key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE))
-		tx->u.tx.control->flags |= IEEE80211_TXCTL_DO_NOT_ENCRYPT;
+		tx->control->flags |= IEEE80211_TXCTL_DO_NOT_ENCRYPT;
 
 	return TX_CONTINUE;
 }
 
 static ieee80211_tx_result
-ieee80211_tx_h_fragment(struct ieee80211_txrx_data *tx)
+ieee80211_tx_h_fragment(struct ieee80211_tx_data *tx)
 {
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) tx->skb->data;
 	size_t hdrlen, per_fragm, num_fragm, payload_len, left;
@@ -508,7 +508,7 @@ ieee80211_tx_h_fragment(struct ieee80211
 	u8 *pos;
 	int frag_threshold = tx->local->fragmentation_threshold;
 
-	if (!(tx->flags & IEEE80211_TXRXD_FRAGMENTED))
+	if (!(tx->flags & IEEE80211_TX_FRAGMENTED))
 		return TX_CONTINUE;
 
 	first = tx->skb;
@@ -560,8 +560,8 @@ ieee80211_tx_h_fragment(struct ieee80211
 	}
 	skb_trim(first, hdrlen + per_fragm);
 
-	tx->u.tx.num_extra_frag = num_fragm - 1;
-	tx->u.tx.extra_frag = frags;
+	tx->num_extra_frag = num_fragm - 1;
+	tx->extra_frag = frags;
 
 	return TX_CONTINUE;
 
@@ -578,7 +578,7 @@ ieee80211_tx_h_fragment(struct ieee80211
 }
 
 static ieee80211_tx_result
-ieee80211_tx_h_encrypt(struct ieee80211_txrx_data *tx)
+ieee80211_tx_h_encrypt(struct ieee80211_tx_data *tx)
 {
 	if (!tx->key)
 		return TX_CONTINUE;
@@ -598,56 +598,56 @@ ieee80211_tx_h_encrypt(struct ieee80211_
 }
 
 static ieee80211_tx_result
-ieee80211_tx_h_rate_ctrl(struct ieee80211_txrx_data *tx)
+ieee80211_tx_h_rate_ctrl(struct ieee80211_tx_data *tx)
 {
 	struct rate_selection rsel;
 	struct ieee80211_supported_band *sband;
 
 	sband = tx->local->hw.wiphy->bands[tx->local->hw.conf.channel->band];
 
-	if (likely(!tx->u.tx.rate)) {
+	if (likely(!tx->rate)) {
 		rate_control_get_rate(tx->dev, sband, tx->skb, &rsel);
-		tx->u.tx.rate = rsel.rate;
+		tx->rate = rsel.rate;
 		if (unlikely(rsel.probe)) {
-			tx->u.tx.control->flags |=
+			tx->control->flags |=
 				IEEE80211_TXCTL_RATE_CTRL_PROBE;
-			tx->flags |= IEEE80211_TXRXD_TXPROBE_LAST_FRAG;
-			tx->u.tx.control->alt_retry_rate = tx->u.tx.rate;
-			tx->u.tx.rate = rsel.probe;
+			tx->flags |= IEEE80211_TX_PROBE_LAST_FRAG;
+			tx->control->alt_retry_rate = tx->rate;
+			tx->rate = rsel.probe;
 		} else
-			tx->u.tx.control->alt_retry_rate = NULL;
+			tx->control->alt_retry_rate = NULL;
 
-		if (!tx->u.tx.rate)
+		if (!tx->rate)
 			return TX_DROP;
 	} else
-		tx->u.tx.control->alt_retry_rate = NULL;
+		tx->control->alt_retry_rate = NULL;
 
 	if (tx->sdata->bss_conf.use_cts_prot &&
-	    (tx->flags & IEEE80211_TXRXD_FRAGMENTED) && rsel.nonerp) {
-		tx->u.tx.last_frag_rate = tx->u.tx.rate;
+	    (tx->flags & IEEE80211_TX_FRAGMENTED) && rsel.nonerp) {
+		tx->last_frag_rate = tx->rate;
 		if (rsel.probe)
-			tx->flags &= ~IEEE80211_TXRXD_TXPROBE_LAST_FRAG;
+			tx->flags &= ~IEEE80211_TX_PROBE_LAST_FRAG;
 		else
-			tx->flags |= IEEE80211_TXRXD_TXPROBE_LAST_FRAG;
-		tx->u.tx.rate = rsel.nonerp;
-		tx->u.tx.control->tx_rate = rsel.nonerp;
-		tx->u.tx.control->flags &= ~IEEE80211_TXCTL_RATE_CTRL_PROBE;
+			tx->flags |= IEEE80211_TX_PROBE_LAST_FRAG;
+		tx->rate = rsel.nonerp;
+		tx->control->tx_rate = rsel.nonerp;
+		tx->control->flags &= ~IEEE80211_TXCTL_RATE_CTRL_PROBE;
 	} else {
-		tx->u.tx.last_frag_rate = tx->u.tx.rate;
-		tx->u.tx.control->tx_rate = tx->u.tx.rate;
+		tx->last_frag_rate = tx->rate;
+		tx->control->tx_rate = tx->rate;
 	}
-	tx->u.tx.control->tx_rate = tx->u.tx.rate;
+	tx->control->tx_rate = tx->rate;
 
 	return TX_CONTINUE;
 }
 
 static ieee80211_tx_result
-ieee80211_tx_h_misc(struct ieee80211_txrx_data *tx)
+ieee80211_tx_h_misc(struct ieee80211_tx_data *tx)
 {
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) tx->skb->data;
 	u16 fc = le16_to_cpu(hdr->frame_control);
 	u16 dur;
-	struct ieee80211_tx_control *control = tx->u.tx.control;
+	struct ieee80211_tx_control *control = tx->control;
 
 	if (!control->retry_limit) {
 		if (!is_multicast_ether_addr(hdr->addr1)) {
@@ -669,7 +669,7 @@ ieee80211_tx_h_misc(struct ieee80211_txr
 		}
 	}
 
-	if (tx->flags & IEEE80211_TXRXD_FRAGMENTED) {
+	if (tx->flags & IEEE80211_TX_FRAGMENTED) {
 		/* Do not use multiple retry rates when sending fragmented
 		 * frames.
 		 * TODO: The last fragment could still use multiple retry
@@ -681,8 +681,8 @@ ieee80211_tx_h_misc(struct ieee80211_txr
 	 * there are associated non-ERP stations and RTS/CTS is not configured
 	 * for the frame. */
 	if ((tx->sdata->flags & IEEE80211_SDATA_OPERATING_GMODE) &&
-	    (tx->u.tx.rate->flags & IEEE80211_RATE_ERP_G) &&
-	    (tx->flags & IEEE80211_TXRXD_TXUNICAST) &&
+	    (tx->rate->flags & IEEE80211_RATE_ERP_G) &&
+	    (tx->flags & IEEE80211_TX_UNICAST) &&
 	    tx->sdata->bss_conf.use_cts_prot &&
 	    !(control->flags & IEEE80211_TXCTL_USE_RTS_CTS))
 		control->flags |= IEEE80211_TXCTL_USE_CTS_PROTECT;
@@ -691,18 +691,18 @@ ieee80211_tx_h_misc(struct ieee80211_txr
 	 * short preambles at the selected rate and short preambles are
 	 * available on the network at the current point in time. */
 	if (((fc & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_DATA) &&
-	    (tx->u.tx.rate->flags & IEEE80211_RATE_SHORT_PREAMBLE) &&
+	    (tx->rate->flags & IEEE80211_RATE_SHORT_PREAMBLE) &&
 	    tx->sdata->bss_conf.use_short_preamble &&
 	    (!tx->sta || (tx->sta->flags & WLAN_STA_SHORT_PREAMBLE))) {
-		tx->u.tx.control->flags |= IEEE80211_TXCTL_SHORT_PREAMBLE;
+		tx->control->flags |= IEEE80211_TXCTL_SHORT_PREAMBLE;
 	}
 
 	/* Setup duration field for the first fragment of the frame. Duration
 	 * for remaining fragments will be updated when they are being sent
 	 * to low-level driver in ieee80211_tx(). */
 	dur = ieee80211_duration(tx, is_multicast_ether_addr(hdr->addr1),
-				 (tx->flags & IEEE80211_TXRXD_FRAGMENTED) ?
-				 tx->u.tx.extra_frag[0]->len : 0);
+				 (tx->flags & IEEE80211_TX_FRAGMENTED) ?
+				 tx->extra_frag[0]->len : 0);
 	hdr->duration_id = cpu_to_le16(dur);
 
 	if ((control->flags & IEEE80211_TXCTL_USE_RTS_CTS) ||
@@ -718,7 +718,7 @@ ieee80211_tx_h_misc(struct ieee80211_txr
 		control->alt_retry_rate = NULL;
 
 		/* Use min(data rate, max base rate) as CTS/RTS rate */
-		rate = tx->u.tx.rate;
+		rate = tx->rate;
 		baserate = NULL;
 
 		for (idx = 0; idx < sband->n_bitrates; idx++) {
@@ -740,12 +740,12 @@ ieee80211_tx_h_misc(struct ieee80211_txr
 		tx->sta->tx_packets++;
 		tx->sta->tx_fragments++;
 		tx->sta->tx_bytes += tx->skb->len;
-		if (tx->u.tx.extra_frag) {
+		if (tx->extra_frag) {
 			int i;
-			tx->sta->tx_fragments += tx->u.tx.num_extra_frag;
-			for (i = 0; i < tx->u.tx.num_extra_frag; i++) {
+			tx->sta->tx_fragments += tx->num_extra_frag;
+			for (i = 0; i < tx->num_extra_frag; i++) {
 				tx->sta->tx_bytes +=
-					tx->u.tx.extra_frag[i]->len;
+					tx->extra_frag[i]->len;
 			}
 		}
 	}
@@ -754,13 +754,13 @@ ieee80211_tx_h_misc(struct ieee80211_txr
 }
 
 static ieee80211_tx_result
-ieee80211_tx_h_load_stats(struct ieee80211_txrx_data *tx)
+ieee80211_tx_h_load_stats(struct ieee80211_tx_data *tx)
 {
 	struct ieee80211_local *local = tx->local;
 	struct sk_buff *skb = tx->skb;
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
 	u32 load = 0, hdrtime;
-	struct ieee80211_rate *rate = tx->u.tx.rate;
+	struct ieee80211_rate *rate = tx->rate;
 
 	/* TODO: this could be part of tx_status handling, so that the number
 	 * of retries would be known; TX rate should in that case be stored
@@ -771,8 +771,8 @@ ieee80211_tx_h_load_stats(struct ieee802
 	/* 1 bit at 1 Mbit/s takes 1 usec; in channel_use values,
 	 * 1 usec = 1/8 * (1080 / 10) = 13.5 */
 
-	if (tx->u.tx.channel->band == IEEE80211_BAND_5GHZ ||
-	    (tx->u.tx.channel->band == IEEE80211_BAND_2GHZ &&
+	if (tx->channel->band == IEEE80211_BAND_5GHZ ||
+	    (tx->channel->band == IEEE80211_BAND_2GHZ &&
 	     rate->flags & IEEE80211_RATE_ERP_G))
 		hdrtime = CHAN_UTIL_HDR_SHORT;
 	else
@@ -782,20 +782,20 @@ ieee80211_tx_h_load_stats(struct ieee802
 	if (!is_multicast_ether_addr(hdr->addr1))
 		load += hdrtime;
 
-	if (tx->u.tx.control->flags & IEEE80211_TXCTL_USE_RTS_CTS)
+	if (tx->control->flags & IEEE80211_TXCTL_USE_RTS_CTS)
 		load += 2 * hdrtime;
-	else if (tx->u.tx.control->flags & IEEE80211_TXCTL_USE_CTS_PROTECT)
+	else if (tx->control->flags & IEEE80211_TXCTL_USE_CTS_PROTECT)
 		load += hdrtime;
 
 	/* TODO: optimise again */
 	load += skb->len * CHAN_UTIL_RATE_LCM / rate->bitrate;
 
-	if (tx->u.tx.extra_frag) {
+	if (tx->extra_frag) {
 		int i;
-		for (i = 0; i < tx->u.tx.num_extra_frag; i++) {
+		for (i = 0; i < tx->num_extra_frag; i++) {
 			load += 2 * hdrtime;
-			load += tx->u.tx.extra_frag[i]->len *
-				tx->u.tx.rate->bitrate;
+			load += tx->extra_frag[i]->len *
+				tx->rate->bitrate;
 		}
 	}
 
@@ -810,7 +810,7 @@ ieee80211_tx_h_load_stats(struct ieee802
 }
 
 
-typedef ieee80211_tx_result (*ieee80211_tx_handler)(struct ieee80211_txrx_data *);
+typedef ieee80211_tx_result (*ieee80211_tx_handler)(struct ieee80211_tx_data *);
 static ieee80211_tx_handler ieee80211_tx_handlers[] =
 {
 	ieee80211_tx_h_check_assoc,
@@ -833,7 +833,7 @@ static ieee80211_tx_handler ieee80211_tx
  * with Radiotap Header -- only called for monitor mode interface
  */
 static ieee80211_tx_result
-__ieee80211_parse_tx_radiotap(struct ieee80211_txrx_data *tx,
+__ieee80211_parse_tx_radiotap(struct ieee80211_tx_data *tx,
 			      struct sk_buff *skb)
 {
 	/*
@@ -849,13 +849,13 @@ __ieee80211_parse_tx_radiotap(struct iee
 		(struct ieee80211_radiotap_header *) skb->data;
 	struct ieee80211_supported_band *sband;
 	int ret = ieee80211_radiotap_iterator_init(&iterator, rthdr, skb->len);
-	struct ieee80211_tx_control *control = tx->u.tx.control;
+	struct ieee80211_tx_control *control = tx->control;
 
 	sband = tx->local->hw.wiphy->bands[tx->local->hw.conf.channel->band];
 
 	control->flags |= IEEE80211_TXCTL_DO_NOT_ENCRYPT;
-	tx->flags |= IEEE80211_TXRXD_TX_INJECTED;
-	tx->flags &= ~IEEE80211_TXRXD_FRAGMENTED;
+	tx->flags |= IEEE80211_TX_INJECTED;
+	tx->flags &= ~IEEE80211_TX_FRAGMENTED;
 
 	/*
 	 * for every radiotap entry that is present
@@ -891,7 +891,7 @@ __ieee80211_parse_tx_radiotap(struct iee
 				r = &sband->bitrates[i];
 
 				if (r->bitrate == target_rate) {
-					tx->u.tx.rate = r;
+					tx->rate = r;
 					break;
 				}
 			}
@@ -929,7 +929,7 @@ __ieee80211_parse_tx_radiotap(struct iee
 				control->flags &=
 					~IEEE80211_TXCTL_DO_NOT_ENCRYPT;
 			if (*iterator.this_arg & IEEE80211_RADIOTAP_F_FRAG)
-				tx->flags |= IEEE80211_TXRXD_FRAGMENTED;
+				tx->flags |= IEEE80211_TX_FRAGMENTED;
 			break;
 
 		/*
@@ -960,7 +960,7 @@ __ieee80211_parse_tx_radiotap(struct iee
  * initialises @tx
  */
 static ieee80211_tx_result
-__ieee80211_tx_prepare(struct ieee80211_txrx_data *tx,
+__ieee80211_tx_prepare(struct ieee80211_tx_data *tx,
 		       struct sk_buff *skb,
 		       struct net_device *dev,
 		       struct ieee80211_tx_control *control)
@@ -976,12 +976,12 @@ __ieee80211_tx_prepare(struct ieee80211_
 	tx->dev = dev; /* use original interface */
 	tx->local = local;
 	tx->sdata = IEEE80211_DEV_TO_SUB_IF(dev);
-	tx->u.tx.control = control;
+	tx->control = control;
 	/*
 	 * Set this flag (used below to indicate "automatic fragmentation"),
 	 * it will be cleared/left by radiotap as desired.
 	 */
-	tx->flags |= IEEE80211_TXRXD_FRAGMENTED;
+	tx->flags |= IEEE80211_TX_FRAGMENTED;
 
 	/* process and remove the injection radiotap header */
 	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
@@ -1002,20 +1002,20 @@ __ieee80211_tx_prepare(struct ieee80211_
 	tx->fc = le16_to_cpu(hdr->frame_control);
 
 	if (is_multicast_ether_addr(hdr->addr1)) {
-		tx->flags &= ~IEEE80211_TXRXD_TXUNICAST;
+		tx->flags &= ~IEEE80211_TX_UNICAST;
 		control->flags |= IEEE80211_TXCTL_NO_ACK;
 	} else {
-		tx->flags |= IEEE80211_TXRXD_TXUNICAST;
+		tx->flags |= IEEE80211_TX_UNICAST;
 		control->flags &= ~IEEE80211_TXCTL_NO_ACK;
 	}
 
-	if (tx->flags & IEEE80211_TXRXD_FRAGMENTED) {
-		if ((tx->flags & IEEE80211_TXRXD_TXUNICAST) &&
+	if (tx->flags & IEEE80211_TX_FRAGMENTED) {
+		if ((tx->flags & IEEE80211_TX_UNICAST) &&
 		    skb->len + FCS_LEN > local->fragmentation_threshold &&
 		    !local->ops->set_frag_threshold)
-			tx->flags |= IEEE80211_TXRXD_FRAGMENTED;
+			tx->flags |= IEEE80211_TX_FRAGMENTED;
 		else
-			tx->flags &= ~IEEE80211_TXRXD_FRAGMENTED;
+			tx->flags &= ~IEEE80211_TX_FRAGMENTED;
 	}
 
 	if (!tx->sta)
@@ -1038,7 +1038,7 @@ __ieee80211_tx_prepare(struct ieee80211_
 /*
  * NB: @tx is uninitialised when passed in here
  */
-static int ieee80211_tx_prepare(struct ieee80211_txrx_data *tx,
+static int ieee80211_tx_prepare(struct ieee80211_tx_data *tx,
 				struct sk_buff *skb,
 				struct net_device *mdev,
 				struct ieee80211_tx_control *control)
@@ -1061,9 +1061,9 @@ static int ieee80211_tx_prepare(struct i
 }
 
 static int __ieee80211_tx(struct ieee80211_local *local, struct sk_buff *skb,
-			  struct ieee80211_txrx_data *tx)
+			  struct ieee80211_tx_data *tx)
 {
-	struct ieee80211_tx_control *control = tx->u.tx.control;
+	struct ieee80211_tx_control *control = tx->control;
 	int ret, i;
 
 	if (!ieee80211_qdisc_installed(local->mdev) &&
@@ -1080,20 +1080,20 @@ static int __ieee80211_tx(struct ieee802
 		local->mdev->trans_start = jiffies;
 		ieee80211_led_tx(local, 1);
 	}
-	if (tx->u.tx.extra_frag) {
+	if (tx->extra_frag) {
 		control->flags &= ~(IEEE80211_TXCTL_USE_RTS_CTS |
 				    IEEE80211_TXCTL_USE_CTS_PROTECT |
 				    IEEE80211_TXCTL_CLEAR_PS_FILT |
 				    IEEE80211_TXCTL_FIRST_FRAGMENT);
-		for (i = 0; i < tx->u.tx.num_extra_frag; i++) {
-			if (!tx->u.tx.extra_frag[i])
+		for (i = 0; i < tx->num_extra_frag; i++) {
+			if (!tx->extra_frag[i])
 				continue;
 			if (__ieee80211_queue_stopped(local, control->queue))
 				return IEEE80211_TX_FRAG_AGAIN;
-			if (i == tx->u.tx.num_extra_frag) {
-				control->tx_rate = tx->u.tx.last_frag_rate;
+			if (i == tx->num_extra_frag) {
+				control->tx_rate = tx->last_frag_rate;
 
-				if (tx->flags & IEEE80211_TXRXD_TXPROBE_LAST_FRAG)
+				if (tx->flags & IEEE80211_TX_PROBE_LAST_FRAG)
 					control->flags |=
 						IEEE80211_TXCTL_RATE_CTRL_PROBE;
 				else
@@ -1103,18 +1103,18 @@ static int __ieee80211_tx(struct ieee802
 
 			ieee80211_dump_frame(wiphy_name(local->hw.wiphy),
 					     "TX to low-level driver",
-					     tx->u.tx.extra_frag[i]);
+					     tx->extra_frag[i]);
 			ret = local->ops->tx(local_to_hw(local),
-					    tx->u.tx.extra_frag[i],
+					    tx->extra_frag[i],
 					    control);
 			if (ret)
 				return IEEE80211_TX_FRAG_AGAIN;
 			local->mdev->trans_start = jiffies;
 			ieee80211_led_tx(local, 1);
-			tx->u.tx.extra_frag[i] = NULL;
+			tx->extra_frag[i] = NULL;
 		}
-		kfree(tx->u.tx.extra_frag);
-		tx->u.tx.extra_frag = NULL;
+		kfree(tx->extra_frag);
+		tx->extra_frag = NULL;
 	}
 	return IEEE80211_TX_OK;
 }
@@ -1125,7 +1125,7 @@ static int ieee80211_tx(struct net_devic
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
 	struct sta_info *sta;
 	ieee80211_tx_handler *handler;
-	struct ieee80211_txrx_data tx;
+	struct ieee80211_tx_data tx;
 	ieee80211_tx_result res = TX_DROP, res_prepare;
 	int ret, i;
 
@@ -1148,7 +1148,7 @@ static int ieee80211_tx(struct net_devic
 	}
 
 	sta = tx.sta;
-	tx.u.tx.channel = local->hw.conf.channel;
+	tx.channel = local->hw.conf.channel;
 
 	for (handler = ieee80211_tx_handlers; *handler != NULL;
 	     handler++) {
@@ -1170,18 +1170,18 @@ static int ieee80211_tx(struct net_devic
 		return 0;
 	}
 
-	if (tx.u.tx.extra_frag) {
-		for (i = 0; i < tx.u.tx.num_extra_frag; i++) {
+	if (tx.extra_frag) {
+		for (i = 0; i < tx.num_extra_frag; i++) {
 			int next_len, dur;
 			struct ieee80211_hdr *hdr =
 				(struct ieee80211_hdr *)
-				tx.u.tx.extra_frag[i]->data;
+				tx.extra_frag[i]->data;
 
-			if (i + 1 < tx.u.tx.num_extra_frag) {
-				next_len = tx.u.tx.extra_frag[i + 1]->len;
+			if (i + 1 < tx.num_extra_frag) {
+				next_len = tx.extra_frag[i + 1]->len;
 			} else {
 				next_len = 0;
-				tx.u.tx.rate = tx.u.tx.last_frag_rate;
+				tx.rate = tx.last_frag_rate;
 			}
 			dur = ieee80211_duration(&tx, 0, next_len);
 			hdr->duration_id = cpu_to_le16(dur);
@@ -1216,11 +1216,11 @@ retry:
 		memcpy(&store->control, control,
 		       sizeof(struct ieee80211_tx_control));
 		store->skb = skb;
-		store->extra_frag = tx.u.tx.extra_frag;
-		store->num_extra_frag = tx.u.tx.num_extra_frag;
-		store->last_frag_rate = tx.u.tx.last_frag_rate;
+		store->extra_frag = tx.extra_frag;
+		store->num_extra_frag = tx.num_extra_frag;
+		store->last_frag_rate = tx.last_frag_rate;
 		store->last_frag_rate_ctrl_probe =
-			!!(tx.flags & IEEE80211_TXRXD_TXPROBE_LAST_FRAG);
+			!!(tx.flags & IEEE80211_TX_PROBE_LAST_FRAG);
 	}
 	rcu_read_unlock();
 	return 0;
@@ -1228,10 +1228,10 @@ retry:
  drop:
 	if (skb)
 		dev_kfree_skb(skb);
-	for (i = 0; i < tx.u.tx.num_extra_frag; i++)
-		if (tx.u.tx.extra_frag[i])
-			dev_kfree_skb(tx.u.tx.extra_frag[i]);
-	kfree(tx.u.tx.extra_frag);
+	for (i = 0; i < tx.num_extra_frag; i++)
+		if (tx.extra_frag[i])
+			dev_kfree_skb(tx.extra_frag[i]);
+	kfree(tx.extra_frag);
 	rcu_read_unlock();
 	return 0;
 }
@@ -1621,7 +1621,7 @@ void ieee80211_tx_pending(unsigned long 
 	struct ieee80211_local *local = (struct ieee80211_local *)data;
 	struct net_device *dev = local->mdev;
 	struct ieee80211_tx_stored_packet *store;
-	struct ieee80211_txrx_data tx;
+	struct ieee80211_tx_data tx;
 	int i, ret, reschedule = 0;
 
 	netif_tx_lock_bh(dev);
@@ -1633,13 +1633,13 @@ void ieee80211_tx_pending(unsigned long 
 			continue;
 		}
 		store = &local->pending_packet[i];
-		tx.u.tx.control = &store->control;
-		tx.u.tx.extra_frag = store->extra_frag;
-		tx.u.tx.num_extra_frag = store->num_extra_frag;
-		tx.u.tx.last_frag_rate = store->last_frag_rate;
+		tx.control = &store->control;
+		tx.extra_frag = store->extra_frag;
+		tx.num_extra_frag = store->num_extra_frag;
+		tx.last_frag_rate = store->last_frag_rate;
 		tx.flags = 0;
 		if (store->last_frag_rate_ctrl_probe)
-			tx.flags |= IEEE80211_TXRXD_TXPROBE_LAST_FRAG;
+			tx.flags |= IEEE80211_TX_PROBE_LAST_FRAG;
 		ret = __ieee80211_tx(local, store->skb, &tx);
 		if (ret) {
 			if (ret == IEEE80211_TX_FRAG_AGAIN)
@@ -1865,7 +1865,7 @@ ieee80211_get_buffered_bc(struct ieee802
 	struct sk_buff *skb;
 	struct sta_info *sta;
 	ieee80211_tx_handler *handler;
-	struct ieee80211_txrx_data tx;
+	struct ieee80211_tx_data tx;
 	ieee80211_tx_result res = TX_DROP;
 	struct net_device *bdev;
 	struct ieee80211_sub_if_data *sdata;
@@ -1912,8 +1912,8 @@ ieee80211_get_buffered_bc(struct ieee802
 		dev_kfree_skb_any(skb);
 	}
 	sta = tx.sta;
-	tx.flags |= IEEE80211_TXRXD_TXPS_BUFFERED;
-	tx.u.tx.channel = local->hw.conf.channel;
+	tx.flags |= IEEE80211_TX_PS_BUFFERED;
+	tx.channel = local->hw.conf.channel;
 
 	for (handler = ieee80211_tx_handlers; *handler != NULL; handler++) {
 		res = (*handler)(&tx);
--- everything.orig/net/mac80211/wep.c	2008-02-21 22:09:12.000000000 +0100
+++ everything/net/mac80211/wep.c	2008-02-21 22:09:32.000000000 +0100
@@ -306,14 +306,14 @@ u8 * ieee80211_wep_is_weak_iv(struct sk_
 }
 
 ieee80211_rx_result
-ieee80211_crypto_wep_decrypt(struct ieee80211_txrx_data *rx)
+ieee80211_crypto_wep_decrypt(struct ieee80211_rx_data *rx)
 {
 	if ((rx->fc & IEEE80211_FCTL_FTYPE) != IEEE80211_FTYPE_DATA &&
 	    ((rx->fc & IEEE80211_FCTL_FTYPE) != IEEE80211_FTYPE_MGMT ||
 	     (rx->fc & IEEE80211_FCTL_STYPE) != IEEE80211_STYPE_AUTH))
 		return RX_CONTINUE;
 
-	if (!(rx->u.rx.status->flag & RX_FLAG_DECRYPTED)) {
+	if (!(rx->status->flag & RX_FLAG_DECRYPTED)) {
 		if (ieee80211_wep_decrypt(rx->local, rx->skb, rx->key)) {
 #ifdef CONFIG_MAC80211_DEBUG
 			if (net_ratelimit())
@@ -322,7 +322,7 @@ ieee80211_crypto_wep_decrypt(struct ieee
 #endif /* CONFIG_MAC80211_DEBUG */
 			return RX_DROP_UNUSABLE;
 		}
-	} else if (!(rx->u.rx.status->flag & RX_FLAG_IV_STRIPPED)) {
+	} else if (!(rx->status->flag & RX_FLAG_IV_STRIPPED)) {
 		ieee80211_wep_remove_iv(rx->local, rx->skb, rx->key);
 		/* remove ICV */
 		skb_trim(rx->skb, rx->skb->len - 4);
@@ -331,13 +331,13 @@ ieee80211_crypto_wep_decrypt(struct ieee
 	return RX_CONTINUE;
 }
 
-static int wep_encrypt_skb(struct ieee80211_txrx_data *tx, struct sk_buff *skb)
+static int wep_encrypt_skb(struct ieee80211_tx_data *tx, struct sk_buff *skb)
 {
 	if (!(tx->key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE)) {
 		if (ieee80211_wep_encrypt(tx->local, skb, tx->key))
 			return -1;
 	} else {
-		tx->u.tx.control->key_idx = tx->key->conf.hw_key_idx;
+		tx->control->key_idx = tx->key->conf.hw_key_idx;
 		if (tx->key->conf.flags & IEEE80211_KEY_FLAG_GENERATE_IV) {
 			if (!ieee80211_wep_add_iv(tx->local, skb, tx->key))
 				return -1;
@@ -347,21 +347,21 @@ static int wep_encrypt_skb(struct ieee80
 }
 
 ieee80211_tx_result
-ieee80211_crypto_wep_encrypt(struct ieee80211_txrx_data *tx)
+ieee80211_crypto_wep_encrypt(struct ieee80211_tx_data *tx)
 {
-	tx->u.tx.control->iv_len = WEP_IV_LEN;
-	tx->u.tx.control->icv_len = WEP_ICV_LEN;
-	ieee80211_tx_set_iswep(tx);
+	tx->control->iv_len = WEP_IV_LEN;
+	tx->control->icv_len = WEP_ICV_LEN;
+	ieee80211_tx_set_protected(tx);
 
 	if (wep_encrypt_skb(tx, tx->skb) < 0) {
 		I802_DEBUG_INC(tx->local->tx_handlers_drop_wep);
 		return TX_DROP;
 	}
 
-	if (tx->u.tx.extra_frag) {
+	if (tx->extra_frag) {
 		int i;
-		for (i = 0; i < tx->u.tx.num_extra_frag; i++) {
-			if (wep_encrypt_skb(tx, tx->u.tx.extra_frag[i]) < 0) {
+		for (i = 0; i < tx->num_extra_frag; i++) {
+			if (wep_encrypt_skb(tx, tx->extra_frag[i]) < 0) {
 				I802_DEBUG_INC(tx->local->
 					       tx_handlers_drop_wep);
 				return TX_DROP;
--- everything.orig/net/mac80211/wep.h	2008-02-21 22:09:12.000000000 +0100
+++ everything/net/mac80211/wep.h	2008-02-21 22:09:32.000000000 +0100
@@ -29,8 +29,8 @@ int ieee80211_wep_decrypt(struct ieee802
 u8 * ieee80211_wep_is_weak_iv(struct sk_buff *skb, struct ieee80211_key *key);
 
 ieee80211_rx_result
-ieee80211_crypto_wep_decrypt(struct ieee80211_txrx_data *rx);
+ieee80211_crypto_wep_decrypt(struct ieee80211_rx_data *rx);
 ieee80211_tx_result
-ieee80211_crypto_wep_encrypt(struct ieee80211_txrx_data *tx);
+ieee80211_crypto_wep_encrypt(struct ieee80211_tx_data *tx);
 
 #endif /* WEP_H */
--- everything.orig/net/mac80211/wpa.c	2008-02-21 22:09:12.000000000 +0100
+++ everything/net/mac80211/wpa.c	2008-02-21 22:09:32.000000000 +0100
@@ -71,7 +71,7 @@ static int ieee80211_get_hdr_info(const 
 
 
 ieee80211_tx_result
-ieee80211_tx_h_michael_mic_add(struct ieee80211_txrx_data *tx)
+ieee80211_tx_h_michael_mic_add(struct ieee80211_tx_data *tx)
 {
 	u8 *data, *sa, *da, *key, *mic, qos_tid;
 	size_t data_len;
@@ -90,7 +90,7 @@ ieee80211_tx_h_michael_mic_add(struct ie
 		return TX_DROP;
 
 	if ((tx->key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE) &&
-	    !(tx->flags & IEEE80211_TXRXD_FRAGMENTED) &&
+	    !(tx->flags & IEEE80211_TX_FRAGMENTED) &&
 	    !(tx->key->conf.flags & IEEE80211_KEY_FLAG_GENERATE_MMIC) &&
 	    !wpa_test) {
 		/* hwaccel - with no need for preallocated room for Michael MIC
@@ -124,7 +124,7 @@ ieee80211_tx_h_michael_mic_add(struct ie
 
 
 ieee80211_rx_result
-ieee80211_rx_h_michael_mic_verify(struct ieee80211_txrx_data *rx)
+ieee80211_rx_h_michael_mic_verify(struct ieee80211_rx_data *rx)
 {
 	u8 *data, *sa, *da, *key = NULL, qos_tid;
 	size_t data_len;
@@ -139,7 +139,7 @@ ieee80211_rx_h_michael_mic_verify(struct
 	/*
 	 * No way to verify the MIC if the hardware stripped it
 	 */
-	if (rx->u.rx.status->flag & RX_FLAG_MMIC_STRIPPED)
+	if (rx->status->flag & RX_FLAG_MMIC_STRIPPED)
 		return RX_CONTINUE;
 
 	if (!rx->key || rx->key->conf.alg != ALG_TKIP ||
@@ -161,7 +161,7 @@ ieee80211_rx_h_michael_mic_verify(struct
 				 ALG_TKIP_TEMP_AUTH_TX_MIC_KEY];
 	michael_mic(key, da, sa, qos_tid & 0x0f, data, data_len, mic);
 	if (memcmp(mic, data + data_len, MICHAEL_MIC_LEN) != 0 || wpa_test) {
-		if (!(rx->flags & IEEE80211_TXRXD_RXRA_MATCH))
+		if (!(rx->flags & IEEE80211_RX_RA_MATCH))
 			return RX_DROP_UNUSABLE;
 
 		printk(KERN_DEBUG "%s: invalid Michael MIC in data frame from "
@@ -176,14 +176,14 @@ ieee80211_rx_h_michael_mic_verify(struct
 	skb_trim(skb, skb->len - MICHAEL_MIC_LEN);
 
 	/* update IV in key information to be able to detect replays */
-	rx->key->u.tkip.iv32_rx[rx->u.rx.queue] = rx->u.rx.tkip_iv32;
-	rx->key->u.tkip.iv16_rx[rx->u.rx.queue] = rx->u.rx.tkip_iv16;
+	rx->key->u.tkip.iv32_rx[rx->queue] = rx->tkip_iv32;
+	rx->key->u.tkip.iv16_rx[rx->queue] = rx->tkip_iv16;
 
 	return RX_CONTINUE;
 }
 
 
-static int tkip_encrypt_skb(struct ieee80211_txrx_data *tx,
+static int tkip_encrypt_skb(struct ieee80211_tx_data *tx,
 			    struct sk_buff *skb, int test)
 {
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
@@ -228,7 +228,7 @@ static int tkip_encrypt_skb(struct ieee8
 					    0x7f),
 				      (u8) key->u.tkip.iv16);
 
-		tx->u.tx.control->key_idx = tx->key->conf.hw_key_idx;
+		tx->control->key_idx = tx->key->conf.hw_key_idx;
 		return 0;
 	}
 
@@ -243,30 +243,30 @@ static int tkip_encrypt_skb(struct ieee8
 
 
 ieee80211_tx_result
-ieee80211_crypto_tkip_encrypt(struct ieee80211_txrx_data *tx)
+ieee80211_crypto_tkip_encrypt(struct ieee80211_tx_data *tx)
 {
 	struct sk_buff *skb = tx->skb;
 	int wpa_test = 0, test = 0;
 
-	tx->u.tx.control->icv_len = TKIP_ICV_LEN;
-	tx->u.tx.control->iv_len = TKIP_IV_LEN;
-	ieee80211_tx_set_iswep(tx);
+	tx->control->icv_len = TKIP_ICV_LEN;
+	tx->control->iv_len = TKIP_IV_LEN;
+	ieee80211_tx_set_protected(tx);
 
 	if ((tx->key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE) &&
 	    !(tx->key->conf.flags & IEEE80211_KEY_FLAG_GENERATE_IV) &&
 	    !wpa_test) {
 		/* hwaccel - with no need for preallocated room for IV/ICV */
-		tx->u.tx.control->key_idx = tx->key->conf.hw_key_idx;
+		tx->control->key_idx = tx->key->conf.hw_key_idx;
 		return TX_CONTINUE;
 	}
 
 	if (tkip_encrypt_skb(tx, skb, test) < 0)
 		return TX_DROP;
 
-	if (tx->u.tx.extra_frag) {
+	if (tx->extra_frag) {
 		int i;
-		for (i = 0; i < tx->u.tx.num_extra_frag; i++) {
-			if (tkip_encrypt_skb(tx, tx->u.tx.extra_frag[i], test)
+		for (i = 0; i < tx->num_extra_frag; i++) {
+			if (tkip_encrypt_skb(tx, tx->extra_frag[i], test)
 			    < 0)
 				return TX_DROP;
 		}
@@ -277,7 +277,7 @@ ieee80211_crypto_tkip_encrypt(struct iee
 
 
 ieee80211_rx_result
-ieee80211_crypto_tkip_decrypt(struct ieee80211_txrx_data *rx)
+ieee80211_crypto_tkip_decrypt(struct ieee80211_rx_data *rx)
 {
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) rx->skb->data;
 	u16 fc;
@@ -295,8 +295,8 @@ ieee80211_crypto_tkip_decrypt(struct iee
 	if (!rx->sta || skb->len - hdrlen < 12)
 		return RX_DROP_UNUSABLE;
 
-	if (rx->u.rx.status->flag & RX_FLAG_DECRYPTED) {
-		if (rx->u.rx.status->flag & RX_FLAG_IV_STRIPPED) {
+	if (rx->status->flag & RX_FLAG_DECRYPTED) {
+		if (rx->status->flag & RX_FLAG_IV_STRIPPED) {
 			/*
 			 * Hardware took care of all processing, including
 			 * replay protection, and stripped the ICV/IV so
@@ -312,9 +312,9 @@ ieee80211_crypto_tkip_decrypt(struct iee
 	res = ieee80211_tkip_decrypt_data(rx->local->wep_rx_tfm,
 					  key, skb->data + hdrlen,
 					  skb->len - hdrlen, rx->sta->addr,
-					  hwaccel, rx->u.rx.queue,
-					  &rx->u.rx.tkip_iv32,
-					  &rx->u.rx.tkip_iv16);
+					  hwaccel, rx->queue,
+					  &rx->tkip_iv32,
+					  &rx->tkip_iv16);
 	if (res != TKIP_DECRYPT_OK || wpa_test) {
 #ifdef CONFIG_MAC80211_DEBUG
 		if (net_ratelimit())
@@ -429,7 +429,7 @@ static inline int ccmp_hdr2pn(u8 *pn, u8
 }
 
 
-static int ccmp_encrypt_skb(struct ieee80211_txrx_data *tx,
+static int ccmp_encrypt_skb(struct ieee80211_tx_data *tx,
 			    struct sk_buff *skb, int test)
 {
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
@@ -478,7 +478,7 @@ static int ccmp_encrypt_skb(struct ieee8
 
 	if (key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE) {
 		/* hwaccel - with preallocated room for CCMP header */
-		tx->u.tx.control->key_idx = key->conf.hw_key_idx;
+		tx->control->key_idx = key->conf.hw_key_idx;
 		return 0;
 	}
 
@@ -492,30 +492,30 @@ static int ccmp_encrypt_skb(struct ieee8
 
 
 ieee80211_tx_result
-ieee80211_crypto_ccmp_encrypt(struct ieee80211_txrx_data *tx)
+ieee80211_crypto_ccmp_encrypt(struct ieee80211_tx_data *tx)
 {
 	struct sk_buff *skb = tx->skb;
 	int test = 0;
 
-	tx->u.tx.control->icv_len = CCMP_MIC_LEN;
-	tx->u.tx.control->iv_len = CCMP_HDR_LEN;
-	ieee80211_tx_set_iswep(tx);
+	tx->control->icv_len = CCMP_MIC_LEN;
+	tx->control->iv_len = CCMP_HDR_LEN;
+	ieee80211_tx_set_protected(tx);
 
 	if ((tx->key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE) &&
 	    !(tx->key->conf.flags & IEEE80211_KEY_FLAG_GENERATE_IV)) {
 		/* hwaccel - with no need for preallocated room for CCMP "
 		 * header or MIC fields */
-		tx->u.tx.control->key_idx = tx->key->conf.hw_key_idx;
+		tx->control->key_idx = tx->key->conf.hw_key_idx;
 		return TX_CONTINUE;
 	}
 
 	if (ccmp_encrypt_skb(tx, skb, test) < 0)
 		return TX_DROP;
 
-	if (tx->u.tx.extra_frag) {
+	if (tx->extra_frag) {
 		int i;
-		for (i = 0; i < tx->u.tx.num_extra_frag; i++) {
-			if (ccmp_encrypt_skb(tx, tx->u.tx.extra_frag[i], test)
+		for (i = 0; i < tx->num_extra_frag; i++) {
+			if (ccmp_encrypt_skb(tx, tx->extra_frag[i], test)
 			    < 0)
 				return TX_DROP;
 		}
@@ -526,7 +526,7 @@ ieee80211_crypto_ccmp_encrypt(struct iee
 
 
 ieee80211_rx_result
-ieee80211_crypto_ccmp_decrypt(struct ieee80211_txrx_data *rx)
+ieee80211_crypto_ccmp_decrypt(struct ieee80211_rx_data *rx)
 {
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) rx->skb->data;
 	u16 fc;
@@ -547,15 +547,15 @@ ieee80211_crypto_ccmp_decrypt(struct iee
 	if (!rx->sta || data_len < 0)
 		return RX_DROP_UNUSABLE;
 
-	if ((rx->u.rx.status->flag & RX_FLAG_DECRYPTED) &&
-	    (rx->u.rx.status->flag & RX_FLAG_IV_STRIPPED))
+	if ((rx->status->flag & RX_FLAG_DECRYPTED) &&
+	    (rx->status->flag & RX_FLAG_IV_STRIPPED))
 		return RX_CONTINUE;
 
 	(void) ccmp_hdr2pn(pn, skb->data + hdrlen);
 
-	if (memcmp(pn, key->u.ccmp.rx_pn[rx->u.rx.queue], CCMP_PN_LEN) <= 0) {
+	if (memcmp(pn, key->u.ccmp.rx_pn[rx->queue], CCMP_PN_LEN) <= 0) {
 #ifdef CONFIG_MAC80211_DEBUG
-		u8 *ppn = key->u.ccmp.rx_pn[rx->u.rx.queue];
+		u8 *ppn = key->u.ccmp.rx_pn[rx->queue];
 
 		printk(KERN_DEBUG "%s: CCMP replay detected for RX frame from "
 		       "%s (RX PN %02x%02x%02x%02x%02x%02x <= prev. PN "
@@ -568,7 +568,7 @@ ieee80211_crypto_ccmp_decrypt(struct iee
 		return RX_DROP_UNUSABLE;
 	}
 
-	if (!(rx->u.rx.status->flag & RX_FLAG_DECRYPTED)) {
+	if (!(rx->status->flag & RX_FLAG_DECRYPTED)) {
 		/* hardware didn't decrypt/verify MIC */
 		u8 *scratch, *b_0, *aad;
 
@@ -593,7 +593,7 @@ ieee80211_crypto_ccmp_decrypt(struct iee
 		}
 	}
 
-	memcpy(key->u.ccmp.rx_pn[rx->u.rx.queue], pn, CCMP_PN_LEN);
+	memcpy(key->u.ccmp.rx_pn[rx->queue], pn, CCMP_PN_LEN);
 
 	/* Remove CCMP header and MIC */
 	skb_trim(skb, skb->len - CCMP_MIC_LEN);
--- everything.orig/net/mac80211/wpa.h	2008-02-21 22:09:12.000000000 +0100
+++ everything/net/mac80211/wpa.h	2008-02-21 22:09:32.000000000 +0100
@@ -14,18 +14,18 @@
 #include "ieee80211_i.h"
 
 ieee80211_tx_result
-ieee80211_tx_h_michael_mic_add(struct ieee80211_txrx_data *tx);
+ieee80211_tx_h_michael_mic_add(struct ieee80211_tx_data *tx);
 ieee80211_rx_result
-ieee80211_rx_h_michael_mic_verify(struct ieee80211_txrx_data *rx);
+ieee80211_rx_h_michael_mic_verify(struct ieee80211_rx_data *rx);
 
 ieee80211_tx_result
-ieee80211_crypto_tkip_encrypt(struct ieee80211_txrx_data *tx);
+ieee80211_crypto_tkip_encrypt(struct ieee80211_tx_data *tx);
 ieee80211_rx_result
-ieee80211_crypto_tkip_decrypt(struct ieee80211_txrx_data *rx);
+ieee80211_crypto_tkip_decrypt(struct ieee80211_rx_data *rx);
 
 ieee80211_tx_result
-ieee80211_crypto_ccmp_encrypt(struct ieee80211_txrx_data *tx);
+ieee80211_crypto_ccmp_encrypt(struct ieee80211_tx_data *tx);
 ieee80211_rx_result
-ieee80211_crypto_ccmp_decrypt(struct ieee80211_txrx_data *rx);
+ieee80211_crypto_ccmp_decrypt(struct ieee80211_rx_data *rx);
 
 #endif /* WPA_H */
--- everything.orig/net/mac80211/util.c	2008-02-21 22:09:27.000000000 +0100
+++ everything/net/mac80211/util.c	2008-02-21 22:09:41.000000000 +0100
@@ -146,17 +146,17 @@ int ieee80211_get_hdrlen_from_skb(const 
 }
 EXPORT_SYMBOL(ieee80211_get_hdrlen_from_skb);
 
-void ieee80211_tx_set_iswep(struct ieee80211_txrx_data *tx)
+void ieee80211_tx_set_protected(struct ieee80211_tx_data *tx)
 {
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) tx->skb->data;
 
 	hdr->frame_control |= cpu_to_le16(IEEE80211_FCTL_PROTECTED);
-	if (tx->u.tx.extra_frag) {
+	if (tx->extra_frag) {
 		struct ieee80211_hdr *fhdr;
 		int i;
-		for (i = 0; i < tx->u.tx.num_extra_frag; i++) {
+		for (i = 0; i < tx->num_extra_frag; i++) {
 			fhdr = (struct ieee80211_hdr *)
-				tx->u.tx.extra_frag[i]->data;
+				tx->extra_frag[i]->data;
 			fhdr->frame_control |= cpu_to_le16(IEEE80211_FCTL_PROTECTED);
 		}
 	}

-- 

