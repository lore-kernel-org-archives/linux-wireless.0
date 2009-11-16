Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:53882 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752705AbZKPNBu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Nov 2009 08:01:50 -0500
Message-Id: <20091116130052.969527134@sipsolutions.net>
Date: Mon, 16 Nov 2009 13:58:21 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 2/2] mac80211: improve rate handling
References: <20091116125819.757434347@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some code currently assumes that there's a valid
rate pointer even in the HT case, but there can't
be. To reduce reliance on that, remove the rate
pointer from the RX data struct and pass it where
it's needed.

Also, for now, in radiotap announce HT frames as
having a DYN channel type, and remove their rate
from cooked monitor radiotap completely (it isn't
present in the regular monitor radiotap either.)

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/ieee80211_i.h |    1 -
 net/mac80211/rx.c          |   35 ++++++++++++++++++-----------------
 2 files changed, 18 insertions(+), 18 deletions(-)

--- wireless-testing.orig/net/mac80211/ieee80211_i.h	2009-11-16 13:49:10.000000000 +0100
+++ wireless-testing/net/mac80211/ieee80211_i.h	2009-11-16 13:49:13.000000000 +0100
@@ -171,7 +171,6 @@ struct ieee80211_rx_data {
 	struct ieee80211_sub_if_data *sdata;
 	struct sta_info *sta;
 	struct ieee80211_key *key;
-	struct ieee80211_rate *rate;
 
 	unsigned int flags;
 	int queue;
--- wireless-testing.orig/net/mac80211/rx.c	2009-11-16 13:34:46.000000000 +0100
+++ wireless-testing/net/mac80211/rx.c	2009-11-16 13:52:28.000000000 +0100
@@ -163,6 +163,9 @@ ieee80211_add_rx_radiotap_header(struct 
 	if (status->band == IEEE80211_BAND_5GHZ)
 		put_unaligned_le16(IEEE80211_CHAN_OFDM | IEEE80211_CHAN_5GHZ,
 				   pos);
+	else if (status->flag & RX_FLAG_HT)
+		put_unaligned_le16(IEEE80211_CHAN_DYN | IEEE80211_CHAN_2GHZ,
+				   pos);
 	else if (rate->flags & IEEE80211_RATE_ERP_G)
 		put_unaligned_le16(IEEE80211_CHAN_OFDM | IEEE80211_CHAN_2GHZ,
 				   pos);
@@ -1845,14 +1848,15 @@ static void ieee80211_rx_michael_mic_rep
 }
 
 /* TODO: use IEEE80211_RX_FRAGMENTED */
-static void ieee80211_rx_cooked_monitor(struct ieee80211_rx_data *rx)
+static void ieee80211_rx_cooked_monitor(struct ieee80211_rx_data *rx,
+					struct ieee80211_rate *rate)
 {
 	struct ieee80211_sub_if_data *sdata;
 	struct ieee80211_local *local = rx->local;
 	struct ieee80211_rtap_hdr {
 		struct ieee80211_radiotap_header hdr;
 		u8 flags;
-		u8 rate;
+		u8 rate_or_pad;
 		__le16 chan_freq;
 		__le16 chan_flags;
 	} __attribute__ ((packed)) *rthdr;
@@ -1872,10 +1876,13 @@ static void ieee80211_rx_cooked_monitor(
 	rthdr->hdr.it_len = cpu_to_le16(sizeof(*rthdr));
 	rthdr->hdr.it_present =
 		cpu_to_le32((1 << IEEE80211_RADIOTAP_FLAGS) |
-			    (1 << IEEE80211_RADIOTAP_RATE) |
 			    (1 << IEEE80211_RADIOTAP_CHANNEL));
 
-	rthdr->rate = rx->rate->bitrate / 5;
+	if (rate) {
+		rthdr->rate_or_pad = rate->bitrate / 5;
+		rthdr->hdr.it_present |=
+			cpu_to_le32(1 << IEEE80211_RADIOTAP_RATE);
+	}
 	rthdr->chan_freq = cpu_to_le16(status->freq);
 
 	if (status->band == IEEE80211_BAND_5GHZ)
@@ -1928,7 +1935,8 @@ static void ieee80211_rx_cooked_monitor(
 
 static void ieee80211_invoke_rx_handlers(struct ieee80211_sub_if_data *sdata,
 					 struct ieee80211_rx_data *rx,
-					 struct sk_buff *skb)
+					 struct sk_buff *skb,
+					 struct ieee80211_rate *rate)
 {
 	ieee80211_rx_result res = RX_DROP_MONITOR;
 
@@ -1972,7 +1980,7 @@ static void ieee80211_invoke_rx_handlers
 			rx->sta->rx_dropped++;
 		/* fall through */
 	case RX_CONTINUE:
-		ieee80211_rx_cooked_monitor(rx);
+		ieee80211_rx_cooked_monitor(rx, rate);
 		break;
 	case RX_DROP_UNUSABLE:
 		I802_DEBUG_INC(sdata->local->rx_handlers_drop);
@@ -2095,7 +2103,6 @@ static void __ieee80211_rx_handle_packet
 	memset(&rx, 0, sizeof(rx));
 	rx.skb = skb;
 	rx.local = local;
-	rx.rate = rate;
 
 	if (ieee80211_is_data(hdr->frame_control) || ieee80211_is_mgmt(hdr->frame_control))
 		local->dot11ReceivedFragmentCount++;
@@ -2167,11 +2174,11 @@ static void __ieee80211_rx_handle_packet
 				       prev->dev->name);
 			continue;
 		}
-		ieee80211_invoke_rx_handlers(prev, &rx, skb_new);
+		ieee80211_invoke_rx_handlers(prev, &rx, skb_new, rate);
 		prev = sdata;
 	}
 	if (prev)
-		ieee80211_invoke_rx_handlers(prev, &rx, skb);
+		ieee80211_invoke_rx_handlers(prev, &rx, skb, rate);
 	else
 		dev_kfree_skb(skb);
 }
@@ -2200,7 +2207,7 @@ static void ieee80211_release_reorder_fr
 					    int index)
 {
 	struct ieee80211_supported_band *sband;
-	struct ieee80211_rate *rate;
+	struct ieee80211_rate *rate = NULL;
 	struct sk_buff *skb = tid_agg_rx->reorder_buf[index];
 	struct ieee80211_rx_status *status;
 
@@ -2211,9 +2218,7 @@ static void ieee80211_release_reorder_fr
 
 	/* release the reordered frames to stack */
 	sband = hw->wiphy->bands[status->band];
-	if (status->flag & RX_FLAG_HT)
-		rate = sband->bitrates; /* TODO: HT rates */
-	else
+	if (!(status->flag & RX_FLAG_HT))
 		rate = &sband->bitrates[status->rate_idx];
 	__ieee80211_rx_handle_packet(hw, skb, rate);
 	tid_agg_rx->stored_mpdu_num--;
@@ -2460,10 +2465,6 @@ void ieee80211_rx(struct ieee80211_hw *h
 			 status->rate_idx,
 			 status->rate_idx))
 			goto drop;
-		/* HT rates are not in the table - use the highest legacy rate
-		 * for now since other parts of mac80211 may not yet be fully
-		 * MCS aware. */
-		rate = &sband->bitrates[sband->n_bitrates - 1];
 	} else {
 		if (WARN_ON(status->rate_idx < 0 ||
 			    status->rate_idx >= sband->n_bitrates))


