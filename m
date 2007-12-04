Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:34359 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751095AbXLEKQ2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Dec 2007 05:16:28 -0500
Subject: [PATCH] mac80211: conditionally include timestamp in radiotap
	information
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Michael Wu <flamingice@sourmilk.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 04 Dec 2007 20:26:48 +0100
Message-Id: <1196796408.10274.30.camel@johannes.berg> (sfid-20071205_101632_340589_12AA9D8A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This makes mac80211 include the low-level MAC timestamp
in the radiotap header if the driver indicated (by a new
RX flag) that the timestamp is valid.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 include/net/mac80211.h |    3 +++
 net/mac80211/rx.c      |   45 ++++++++++++++++++++++++++++-----------------
 2 files changed, 31 insertions(+), 17 deletions(-)

--- everything.orig/net/mac80211/rx.c	2007-12-04 20:02:04.696956217 +0100
+++ everything/net/mac80211/rx.c	2007-12-04 20:16:02.486950411 +0100
@@ -80,8 +80,9 @@ ieee80211_rx_monitor(struct ieee80211_lo
 	struct ieee80211_sub_if_data *sdata;
 	struct ieee80211_rate *rate;
 	int needed_headroom = 0;
-	struct ieee80211_rtap_hdr {
-		struct ieee80211_radiotap_header hdr;
+	struct ieee80211_radiotap_header *rthdr;
+	__le64 *rttsft = NULL;
+	struct ieee80211_rtap_fixed_data {
 		u8 flags;
 		u8 rate;
 		__le16 chan_freq;
@@ -89,7 +90,7 @@ ieee80211_rx_monitor(struct ieee80211_lo
 		u8 antsignal;
 		u8 padding_for_rxflags;
 		__le16 rx_flags;
-	} __attribute__ ((packed)) *rthdr;
+	} __attribute__ ((packed)) *rtfixed;
 	struct sk_buff *skb, *skb2;
 	struct net_device *prev_dev = NULL;
 	int present_fcs_len = 0;
@@ -106,7 +107,8 @@ ieee80211_rx_monitor(struct ieee80211_lo
 	if (status->flag & RX_FLAG_RADIOTAP)
 		rtap_len = ieee80211_get_radiotap_len(origskb->data);
 	else
-		needed_headroom = sizeof(*rthdr);
+		/* room for radiotap header, always present fields and TSFT */
+		needed_headroom = sizeof(*rthdr) + sizeof(*rtfixed) + 8;
 
 	if (local->hw.flags & IEEE80211_HW_RX_INCLUDES_FCS)
 		present_fcs_len = FCS_LEN;
@@ -134,7 +136,7 @@ ieee80211_rx_monitor(struct ieee80211_lo
 		 * them allocate enough headroom to start with.
 		 */
 		if (skb_headroom(skb) < needed_headroom &&
-		    pskb_expand_head(skb, sizeof(*rthdr), 0, GFP_ATOMIC)) {
+		    pskb_expand_head(skb, needed_headroom, 0, GFP_ATOMIC)) {
 			dev_kfree_skb(skb);
 			return NULL;
 		}
@@ -153,42 +155,51 @@ ieee80211_rx_monitor(struct ieee80211_lo
 
 	/* if necessary, prepend radiotap information */
 	if (!(status->flag & RX_FLAG_RADIOTAP)) {
+		rtfixed = (void *) skb_push(skb, sizeof(*rtfixed));
+		if (status->flag & RX_FLAG_TSFT)
+			rttsft = (void *) skb_push(skb, sizeof(*rttsft));
 		rthdr = (void *) skb_push(skb, sizeof(*rthdr));
 		memset(rthdr, 0, sizeof(*rthdr));
-		rthdr->hdr.it_len = cpu_to_le16(sizeof(*rthdr));
-		rthdr->hdr.it_present =
-			cpu_to_le32((1 << IEEE80211_RADIOTAP_FLAGS) |
+		memset(rtfixed, 0, sizeof(*rtfixed));
+		rthdr->it_len = cpu_to_le16(sizeof(*rthdr));
+		rthdr->it_present =
+			cpu_to_le32((1 << IEEE80211_RADIOTAP_TSFT) |
+				    (1 << IEEE80211_RADIOTAP_FLAGS) |
 				    (1 << IEEE80211_RADIOTAP_RATE) |
 				    (1 << IEEE80211_RADIOTAP_CHANNEL) |
 				    (1 << IEEE80211_RADIOTAP_DB_ANTSIGNAL) |
 				    (1 << IEEE80211_RADIOTAP_RX_FLAGS));
-		rthdr->flags = local->hw.flags & IEEE80211_HW_RX_INCLUDES_FCS ?
-			       IEEE80211_RADIOTAP_F_FCS : 0;
+		rtfixed->flags = 0;
+		if (local->hw.flags & IEEE80211_HW_RX_INCLUDES_FCS)
+			rtfixed->flags |= IEEE80211_RADIOTAP_F_FCS;
+
+		if (rttsft)
+			*rttsft = cpu_to_le64(status->mactime);
 
 		/* FIXME: when radiotap gets a 'bad PLCP' flag use it here */
-		rthdr->rx_flags = 0;
+		rtfixed->rx_flags = 0;
 		if (status->flag &
 		    (RX_FLAG_FAILED_FCS_CRC | RX_FLAG_FAILED_PLCP_CRC))
-			rthdr->rx_flags |=
+			rtfixed->rx_flags |=
 				cpu_to_le16(IEEE80211_RADIOTAP_F_RX_BADFCS);
 
 		rate = ieee80211_get_rate(local, status->phymode,
 					  status->rate);
 		if (rate)
-			rthdr->rate = rate->rate / 5;
+			rtfixed->rate = rate->rate / 5;
 
-		rthdr->chan_freq = cpu_to_le16(status->freq);
+		rtfixed->chan_freq = cpu_to_le16(status->freq);
 
 		if (status->phymode == MODE_IEEE80211A)
-			rthdr->chan_flags =
+			rtfixed->chan_flags =
 				cpu_to_le16(IEEE80211_CHAN_OFDM |
 					    IEEE80211_CHAN_5GHZ);
 		else
-			rthdr->chan_flags =
+			rtfixed->chan_flags =
 				cpu_to_le16(IEEE80211_CHAN_DYN |
 					    IEEE80211_CHAN_2GHZ);
 
-		rthdr->antsignal = status->ssi;
+		rtfixed->antsignal = status->ssi;
 	}
 
 	skb_set_mac_header(skb, 0);
--- everything.orig/include/net/mac80211.h	2007-12-04 20:12:00.226951171 +0100
+++ everything/include/net/mac80211.h	2007-12-04 20:20:25.366949924 +0100
@@ -350,6 +350,8 @@ struct ieee80211_tx_control {
  *	the frame.
  * @RX_FLAG_FAILED_PLCP_CRC: Set this flag if the PCLP check failed on
  *	the frame.
+ * @RX_FLAG_TSFT: The timestamp passed in the RX status (@mactime field)
+ *	is valid.
  */
 enum mac80211_rx_flags {
 	RX_FLAG_MMIC_ERROR	= 1<<0,
@@ -359,6 +361,7 @@ enum mac80211_rx_flags {
 	RX_FLAG_IV_STRIPPED	= 1<<4,
 	RX_FLAG_FAILED_FCS_CRC	= 1<<5,
 	RX_FLAG_FAILED_PLCP_CRC = 1<<6,
+	RX_FLAG_TSFT		= 1<<7,
 };
 
 /**


