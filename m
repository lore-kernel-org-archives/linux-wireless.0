Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:39486 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761359AbYEUPeo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 May 2008 11:34:44 -0400
Subject: [PATCH] mac80211: remove channel use statistics
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 21 May 2008 17:33:42 +0200
Message-Id: <1211384022.13667.14.camel@johannes.berg> (sfid-20080521_173450_029213_07759476)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The useless channel use statistics are quite a lot of code, currently
use integer divisions in the packet fast path, are rather inaccurate
since they do not account for retries and finally nobody even cares.
Hence, remove them completely.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/debugfs_netdev.c |    9 -----
 net/mac80211/debugfs_sta.c    |    1 
 net/mac80211/ieee80211_i.h    |   32 ------------------
 net/mac80211/rx.c             |   62 +----------------------------------
 net/mac80211/sta_info.h       |    4 --
 net/mac80211/tx.c             |   73 +++++-------------------------------------
 6 files changed, 12 insertions(+), 169 deletions(-)

--- everything.orig/net/mac80211/ieee80211_i.h	2008-05-21 17:28:53.000000000 +0200
+++ everything/net/mac80211/ieee80211_i.h	2008-05-21 17:31:18.000000000 +0200
@@ -201,7 +201,6 @@ struct ieee80211_rx_data {
 	unsigned int flags;
 	int sent_ps_buffered;
 	int queue;
-	int load;
 	u32 tkip_iv32;
 	u16 tkip_iv16;
 };
@@ -448,14 +447,11 @@ struct ieee80211_sub_if_data {
 		struct ieee80211_if_sta sta;
 		u32 mntr_flags;
 	} u;
-	int channel_use;
-	int channel_use_raw;
 
 #ifdef CONFIG_MAC80211_DEBUGFS
 	struct dentry *debugfsdir;
 	union {
 		struct {
-			struct dentry *channel_use;
 			struct dentry *drop_unencrypted;
 			struct dentry *state;
 			struct dentry *bssid;
@@ -474,7 +470,6 @@ struct ieee80211_sub_if_data {
 			struct dentry *num_beacons_sta;
 		} sta;
 		struct {
-			struct dentry *channel_use;
 			struct dentry *drop_unencrypted;
 			struct dentry *num_sta_ps;
 			struct dentry *dtim_count;
@@ -484,12 +479,10 @@ struct ieee80211_sub_if_data {
 			struct dentry *num_buffered_multicast;
 		} ap;
 		struct {
-			struct dentry *channel_use;
 			struct dentry *drop_unencrypted;
 			struct dentry *peer;
 		} wds;
 		struct {
-			struct dentry *channel_use;
 			struct dentry *drop_unencrypted;
 		} vlan;
 		struct {
@@ -662,9 +655,6 @@ struct ieee80211_local {
 	     assoc_led_name[32], radio_led_name[32];
 #endif
 
-	u32 channel_use;
-	u32 channel_use_raw;
-
 #ifdef CONFIG_MAC80211_DEBUGFS
 	struct work_struct sta_debugfs_add;
 #endif
@@ -862,28 +852,6 @@ u32 ieee80211_handle_ht(struct ieee80211
 
 /* ieee80211_ioctl.c */
 extern const struct iw_handler_def ieee80211_iw_handler_def;
-
-
-/* Least common multiple of the used rates (in 100 kbps). This is used to
- * calculate rate_inv values for each rate so that only integers are needed. */
-#define CHAN_UTIL_RATE_LCM 95040
-/* 1 usec is 1/8 * (95040/10) = 1188 */
-#define CHAN_UTIL_PER_USEC 1188
-/* Amount of bits to shift the result right to scale the total utilization
- * to values that will not wrap around 32-bit integers. */
-#define CHAN_UTIL_SHIFT 9
-/* Theoretical maximum of channel utilization counter in 10 ms (stat_time=1):
- * (CHAN_UTIL_PER_USEC * 10000) >> CHAN_UTIL_SHIFT = 23203. So dividing the
- * raw value with about 23 should give utilization in 10th of a percentage
- * (1/1000). However, utilization is only estimated and not all intervals
- * between frames etc. are calculated. 18 seems to give numbers that are closer
- * to the real maximum. */
-#define CHAN_UTIL_PER_10MS 18
-#define CHAN_UTIL_HDR_LONG (202 * CHAN_UTIL_PER_USEC)
-#define CHAN_UTIL_HDR_SHORT (40 * CHAN_UTIL_PER_USEC)
-
-
-/* ieee80211_ioctl.c */
 int ieee80211_set_freq(struct ieee80211_local *local, int freq);
 /* ieee80211_sta.c */
 void ieee80211_sta_timer(unsigned long data);
--- everything.orig/net/mac80211/sta_info.h	2008-05-21 17:28:53.000000000 +0200
+++ everything/net/mac80211/sta_info.h	2008-05-21 17:31:18.000000000 +0200
@@ -245,10 +245,6 @@ struct sta_info {
 	unsigned int wme_tx_queue[NUM_RX_DATA_QUEUES];
 #endif
 
-	/* Debug counters, no locking doesn't matter */
-	int channel_use;
-	int channel_use_raw;
-
 	/*
 	 * Aggregation information, locked with lock.
 	 */
--- everything.orig/net/mac80211/rx.c	2008-05-21 17:28:53.000000000 +0200
+++ everything/net/mac80211/rx.c	2008-05-21 17:31:18.000000000 +0200
@@ -387,51 +387,9 @@ static void ieee80211_verify_ip_alignmen
 }
 
 
-static u32 ieee80211_rx_load_stats(struct ieee80211_local *local,
-				   struct sk_buff *skb,
-				   struct ieee80211_rx_status *status,
-				   struct ieee80211_rate *rate)
-{
-	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
-	u32 load = 0, hdrtime;
-
-	/* Estimate total channel use caused by this frame */
-
-	/* 1 bit at 1 Mbit/s takes 1 usec; in channel_use values,
-	 * 1 usec = 1/8 * (1080 / 10) = 13.5 */
-
-	if (status->band == IEEE80211_BAND_5GHZ ||
-	    (status->band == IEEE80211_BAND_5GHZ &&
-	     rate->flags & IEEE80211_RATE_ERP_G))
-		hdrtime = CHAN_UTIL_HDR_SHORT;
-	else
-		hdrtime = CHAN_UTIL_HDR_LONG;
-
-	load = hdrtime;
-	if (!is_multicast_ether_addr(hdr->addr1))
-		load += hdrtime;
-
-	/* TODO: optimise again */
-	load += skb->len * CHAN_UTIL_RATE_LCM / rate->bitrate;
-
-	/* Divide channel_use by 8 to avoid wrapping around the counter */
-	load >>= CHAN_UTIL_SHIFT;
-
-	return load;
-}
-
 /* rx handlers */
 
 static ieee80211_rx_result
-ieee80211_rx_h_if_stats(struct ieee80211_rx_data *rx)
-{
-	if (rx->sta)
-		rx->sta->channel_use_raw += rx->load;
-	rx->sdata->channel_use_raw += rx->load;
-	return RX_CONTINUE;
-}
-
-static ieee80211_rx_result
 ieee80211_rx_h_passive_scan(struct ieee80211_rx_data *rx)
 {
 	struct ieee80211_local *local = rx->local;
@@ -1780,7 +1738,6 @@ static void ieee80211_rx_cooked_monitor(
 typedef ieee80211_rx_result (*ieee80211_rx_handler)(struct ieee80211_rx_data *);
 static ieee80211_rx_handler ieee80211_rx_handlers[] =
 {
-	ieee80211_rx_h_if_stats,
 	ieee80211_rx_h_passive_scan,
 	ieee80211_rx_h_check,
 	ieee80211_rx_h_decrypt,
@@ -1939,7 +1896,6 @@ static int prepare_for_handlers(struct i
 static void __ieee80211_rx_handle_packet(struct ieee80211_hw *hw,
 					 struct sk_buff *skb,
 					 struct ieee80211_rx_status *status,
-					 u32 load,
 					 struct ieee80211_rate *rate)
 {
 	struct ieee80211_local *local = hw_to_local(hw);
@@ -1958,7 +1914,6 @@ static void __ieee80211_rx_handle_packet
 	rx.local = local;
 
 	rx.status = status;
-	rx.load = load;
 	rx.rate = rate;
 	rx.fc = le16_to_cpu(hdr->frame_control);
 	type = rx.fc & IEEE80211_FCTL_FTYPE;
@@ -2067,7 +2022,6 @@ u8 ieee80211_sta_manage_reorder_buf(stru
 	struct ieee80211_rx_status status;
 	u16 head_seq_num, buf_size;
 	int index;
-	u32 pkt_load;
 	struct ieee80211_supported_band *sband;
 	struct ieee80211_rate *rate;
 
@@ -2102,12 +2056,9 @@ u8 ieee80211_sta_manage_reorder_buf(stru
 					sizeof(status));
 				sband = local->hw.wiphy->bands[status.band];
 				rate = &sband->bitrates[status.rate_idx];
-				pkt_load = ieee80211_rx_load_stats(local,
-						tid_agg_rx->reorder_buf[index],
-						&status, rate);
 				__ieee80211_rx_handle_packet(hw,
 					tid_agg_rx->reorder_buf[index],
-					&status, pkt_load, rate);
+					&status, rate);
 				tid_agg_rx->stored_mpdu_num--;
 				tid_agg_rx->reorder_buf[index] = NULL;
 			}
@@ -2149,11 +2100,8 @@ u8 ieee80211_sta_manage_reorder_buf(stru
 			sizeof(status));
 		sband = local->hw.wiphy->bands[status.band];
 		rate = &sband->bitrates[status.rate_idx];
-		pkt_load = ieee80211_rx_load_stats(local,
-					tid_agg_rx->reorder_buf[index],
-					&status, rate);
 		__ieee80211_rx_handle_packet(hw, tid_agg_rx->reorder_buf[index],
-					     &status, pkt_load, rate);
+					     &status, rate);
 		tid_agg_rx->stored_mpdu_num--;
 		tid_agg_rx->reorder_buf[index] = NULL;
 		tid_agg_rx->head_seq_num = seq_inc(tid_agg_rx->head_seq_num);
@@ -2232,7 +2180,6 @@ void __ieee80211_rx(struct ieee80211_hw 
 		    struct ieee80211_rx_status *status)
 {
 	struct ieee80211_local *local = hw_to_local(hw);
-	u32 pkt_load;
 	struct ieee80211_rate *rate = NULL;
 	struct ieee80211_supported_band *sband;
 
@@ -2272,11 +2219,8 @@ void __ieee80211_rx(struct ieee80211_hw 
 		return;
 	}
 
-	pkt_load = ieee80211_rx_load_stats(local, skb, status, rate);
-	local->channel_use_raw += pkt_load;
-
 	if (!ieee80211_rx_reorder_ampdu(local, skb))
-		__ieee80211_rx_handle_packet(hw, skb, status, pkt_load, rate);
+		__ieee80211_rx_handle_packet(hw, skb, status, rate);
 
 	rcu_read_unlock();
 }
--- everything.orig/net/mac80211/debugfs_netdev.c	2008-05-21 17:28:53.000000000 +0200
+++ everything/net/mac80211/debugfs_netdev.c	2008-05-21 17:31:18.000000000 +0200
@@ -155,7 +155,6 @@ static const struct file_operations name
 		__IEEE80211_IF_WFILE(name)
 
 /* common attributes */
-IEEE80211_IF_FILE(channel_use, channel_use, DEC);
 IEEE80211_IF_FILE(drop_unencrypted, drop_unencrypted, DEC);
 
 /* STA/IBSS attributes */
@@ -248,7 +247,6 @@ IEEE80211_IF_WFILE(min_discovery_timeout
 
 static void add_sta_files(struct ieee80211_sub_if_data *sdata)
 {
-	DEBUGFS_ADD(channel_use, sta);
 	DEBUGFS_ADD(drop_unencrypted, sta);
 	DEBUGFS_ADD(state, sta);
 	DEBUGFS_ADD(bssid, sta);
@@ -269,7 +267,6 @@ static void add_sta_files(struct ieee802
 
 static void add_ap_files(struct ieee80211_sub_if_data *sdata)
 {
-	DEBUGFS_ADD(channel_use, ap);
 	DEBUGFS_ADD(drop_unencrypted, ap);
 	DEBUGFS_ADD(num_sta_ps, ap);
 	DEBUGFS_ADD(dtim_count, ap);
@@ -281,14 +278,12 @@ static void add_ap_files(struct ieee8021
 
 static void add_wds_files(struct ieee80211_sub_if_data *sdata)
 {
-	DEBUGFS_ADD(channel_use, wds);
 	DEBUGFS_ADD(drop_unencrypted, wds);
 	DEBUGFS_ADD(peer, wds);
 }
 
 static void add_vlan_files(struct ieee80211_sub_if_data *sdata)
 {
-	DEBUGFS_ADD(channel_use, vlan);
 	DEBUGFS_ADD(drop_unencrypted, vlan);
 }
 
@@ -376,7 +371,6 @@ static void add_files(struct ieee80211_s
 
 static void del_sta_files(struct ieee80211_sub_if_data *sdata)
 {
-	DEBUGFS_DEL(channel_use, sta);
 	DEBUGFS_DEL(drop_unencrypted, sta);
 	DEBUGFS_DEL(state, sta);
 	DEBUGFS_DEL(bssid, sta);
@@ -397,7 +391,6 @@ static void del_sta_files(struct ieee802
 
 static void del_ap_files(struct ieee80211_sub_if_data *sdata)
 {
-	DEBUGFS_DEL(channel_use, ap);
 	DEBUGFS_DEL(drop_unencrypted, ap);
 	DEBUGFS_DEL(num_sta_ps, ap);
 	DEBUGFS_DEL(dtim_count, ap);
@@ -409,14 +402,12 @@ static void del_ap_files(struct ieee8021
 
 static void del_wds_files(struct ieee80211_sub_if_data *sdata)
 {
-	DEBUGFS_DEL(channel_use, wds);
 	DEBUGFS_DEL(drop_unencrypted, wds);
 	DEBUGFS_DEL(peer, wds);
 }
 
 static void del_vlan_files(struct ieee80211_sub_if_data *sdata)
 {
-	DEBUGFS_DEL(channel_use, vlan);
 	DEBUGFS_DEL(drop_unencrypted, vlan);
 }
 
--- everything.orig/net/mac80211/debugfs_sta.c	2008-05-21 17:28:53.000000000 +0200
+++ everything/net/mac80211/debugfs_sta.c	2008-05-21 17:31:18.000000000 +0200
@@ -66,7 +66,6 @@ STA_FILE(tx_retry_count, tx_retry_count,
 STA_FILE(last_signal, last_signal, D);
 STA_FILE(last_qual, last_qual, D);
 STA_FILE(last_noise, last_noise, D);
-STA_FILE(channel_use, channel_use, D);
 STA_FILE(wep_weak_iv_count, wep_weak_iv_count, LU);
 
 static ssize_t sta_flags_read(struct file *file, char __user *userbuf,
--- everything.orig/net/mac80211/tx.c	2008-05-21 17:28:53.000000000 +0200
+++ everything/net/mac80211/tx.c	2008-05-21 17:32:50.000000000 +0200
@@ -761,73 +761,18 @@ ieee80211_tx_h_encrypt(struct ieee80211_
 static ieee80211_tx_result
 ieee80211_tx_h_stats(struct ieee80211_tx_data *tx)
 {
-	struct ieee80211_local *local = tx->local;
-	struct sk_buff *skb = tx->skb;
-	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
-	u32 load = 0, hdrtime;
-	struct ieee80211_rate *rate;
-	struct ieee80211_supported_band *sband;
-	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
-
-	sband = tx->local->hw.wiphy->bands[tx->channel->band];
-	rate = &sband->bitrates[tx->rate_idx];
-
-	/* TODO: this could be part of tx_status handling, so that the number
-	 * of retries would be known; TX rate should in that case be stored
-	 * somewhere with the packet */
-
-	/* Estimate total channel use caused by this frame */
-
-	/* 1 bit at 1 Mbit/s takes 1 usec; in channel_use values,
-	 * 1 usec = 1/8 * (1080 / 10) = 13.5 */
-
-	if (tx->channel->band == IEEE80211_BAND_5GHZ ||
-	    (tx->channel->band == IEEE80211_BAND_2GHZ &&
-	     rate->flags & IEEE80211_RATE_ERP_G))
-		hdrtime = CHAN_UTIL_HDR_SHORT;
-	else
-		hdrtime = CHAN_UTIL_HDR_LONG;
+	int i;
 
-	load = hdrtime;
-	if (!is_multicast_ether_addr(hdr->addr1))
-		load += hdrtime;
-
-	if (info->flags & IEEE80211_TX_CTL_USE_RTS_CTS)
-		load += 2 * hdrtime;
-	else if (info->flags & IEEE80211_TX_CTL_USE_CTS_PROTECT)
-		load += hdrtime;
-
-	/* TODO: optimise again */
-	load += skb->len * CHAN_UTIL_RATE_LCM / rate->bitrate;
+	if (!tx->sta)
+		return TX_CONTINUE;
 
+	tx->sta->tx_packets++;
+	tx->sta->tx_fragments++;
+	tx->sta->tx_bytes += tx->skb->len;
 	if (tx->extra_frag) {
-		int i;
-		for (i = 0; i < tx->num_extra_frag; i++) {
-			load += 2 * hdrtime;
-			load += tx->extra_frag[i]->len *
-				rate->bitrate;
-		}
-	}
-
-	/* Divide channel_use by 8 to avoid wrapping around the counter */
-	load >>= CHAN_UTIL_SHIFT;
-	local->channel_use_raw += load;
-	if (tx->sta)
-		tx->sta->channel_use_raw += load;
-	tx->sdata->channel_use_raw += load;
-
-	if (tx->sta) {
-		tx->sta->tx_packets++;
-		tx->sta->tx_fragments++;
-		tx->sta->tx_bytes += tx->skb->len;
-		if (tx->extra_frag) {
-			int i;
-			tx->sta->tx_fragments += tx->num_extra_frag;
-			for (i = 0; i < tx->num_extra_frag; i++) {
-				tx->sta->tx_bytes +=
-					tx->extra_frag[i]->len;
-			}
-		}
+		tx->sta->tx_fragments += tx->num_extra_frag;
+		for (i = 0; i < tx->num_extra_frag; i++)
+			tx->sta->tx_bytes += tx->extra_frag[i]->len;
 	}
 
 	return TX_CONTINUE;


