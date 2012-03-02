Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:47387 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751069Ab2CBMSW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Mar 2012 07:18:22 -0500
Subject: [PATCH] mac80211: use common radiotap code for cooked monitors
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 02 Mar 2012 13:18:19 +0100
Message-ID: <1330690699.8542.13.camel@jlt3.sipsolutions.net> (sfid-20120302_131825_924334_64E9D5B6)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

There's no need to hardcode a subset of the
radiotap header for cooked monitor receive,
we can just reuse the normal monitor mode
radiotap code. This simplifies the code and
extends the information available on cooked
monitor interfaces.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/rx.c |   39 +++++++++------------------------------
 1 file changed, 9 insertions(+), 30 deletions(-)

--- a/net/mac80211/rx.c	2012-02-29 11:02:37.000000000 +0100
+++ b/net/mac80211/rx.c	2012-03-02 13:16:13.000000000 +0100
@@ -227,7 +227,7 @@ ieee80211_rx_monitor(struct ieee80211_lo
 {
 	struct ieee80211_rx_status *status = IEEE80211_SKB_RXCB(origskb);
 	struct ieee80211_sub_if_data *sdata;
-	int needed_headroom = 0;
+	int needed_headroom;
 	struct sk_buff *skb, *skb2;
 	struct net_device *prev_dev = NULL;
 	int present_fcs_len = 0;
@@ -2538,16 +2538,10 @@ static void ieee80211_rx_cooked_monitor(
 {
 	struct ieee80211_sub_if_data *sdata;
 	struct ieee80211_local *local = rx->local;
-	struct ieee80211_rtap_hdr {
-		struct ieee80211_radiotap_header hdr;
-		u8 flags;
-		u8 rate_or_pad;
-		__le16 chan_freq;
-		__le16 chan_flags;
-	} __packed *rthdr;
 	struct sk_buff *skb = rx->skb, *skb2;
 	struct net_device *prev_dev = NULL;
 	struct ieee80211_rx_status *status = IEEE80211_SKB_RXCB(skb);
+	int needed_headroom;
 
 	/*
 	 * If cooked monitor has been processed already, then
@@ -2561,30 +2555,15 @@ static void ieee80211_rx_cooked_monitor(
 	if (!local->cooked_mntrs)
 		goto out_free_skb;
 
-	if (skb_headroom(skb) < sizeof(*rthdr) &&
-	    pskb_expand_head(skb, sizeof(*rthdr), 0, GFP_ATOMIC))
+	/* room for the radiotap header based on driver features */
+	needed_headroom = ieee80211_rx_radiotap_len(local, status);
+
+	if (skb_headroom(skb) < needed_headroom &&
+	    pskb_expand_head(skb, needed_headroom, 0, GFP_ATOMIC))
 		goto out_free_skb;
 
-	rthdr = (void *)skb_push(skb, sizeof(*rthdr));
-	memset(rthdr, 0, sizeof(*rthdr));
-	rthdr->hdr.it_len = cpu_to_le16(sizeof(*rthdr));
-	rthdr->hdr.it_present =
-		cpu_to_le32((1 << IEEE80211_RADIOTAP_FLAGS) |
-			    (1 << IEEE80211_RADIOTAP_CHANNEL));
-
-	if (rate) {
-		rthdr->rate_or_pad = rate->bitrate / 5;
-		rthdr->hdr.it_present |=
-			cpu_to_le32(1 << IEEE80211_RADIOTAP_RATE);
-	}
-	rthdr->chan_freq = cpu_to_le16(status->freq);
-
-	if (status->band == IEEE80211_BAND_5GHZ)
-		rthdr->chan_flags = cpu_to_le16(IEEE80211_CHAN_OFDM |
-						IEEE80211_CHAN_5GHZ);
-	else
-		rthdr->chan_flags = cpu_to_le16(IEEE80211_CHAN_DYN |
-						IEEE80211_CHAN_2GHZ);
+	/* prepend radiotap information */
+	ieee80211_add_rx_radiotap_header(local, skb, rate, needed_headroom);
 
 	skb_set_mac_header(skb, 0);
 	skb->ip_summed = CHECKSUM_UNNECESSARY;


