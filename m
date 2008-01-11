Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:42123 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755407AbYAKLjR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Jan 2008 06:39:17 -0500
Subject: [PATCH] mac80211: fix alignment warning
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Tomas Winkler <tomasw@gmail.com>
Content-Type: text/plain
Date: Fri, 11 Jan 2008 02:02:51 +0100
Message-Id: <1200013371.3861.132.camel@johannes.berg> (sfid-20080111_113920_418590_38E71484)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When I introduced the alignment warning I forgot the A-MSDU case which
has a different requirement because each frame contains 14-byte 802.3
headers in front of the IP payload. This patch moves the alignment
warning to a place where we know whether we're dealing with an A-MSDU
frame and adjusts it accordingly.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
Hmm. This alignment isn't strictly necessary because we actually copy
all the payload within an A-MSDU frame. I think we can get rid of that
though if we're a bit more careful what we do with the frame, i.e. if we
copy it before passing it back to mac80211 for multicast frames we can
optimise the common non-multicast case by using only a clone.

 net/mac80211/rx.c |   46 +++++++++++++++++++++++++++++++++-------------
 1 file changed, 33 insertions(+), 13 deletions(-)

--- everything.orig/net/mac80211/rx.c	2008-01-11 01:38:57.271030816 +0100
+++ everything/net/mac80211/rx.c	2008-01-11 01:49:41.221020074 +0100
@@ -340,9 +340,42 @@ u32 ieee80211_rx_load_stats(struct ieee8
 	return load;
 }
 
+static ieee80211_txrx_result
+ieee80211_rx_h_verify_ip_alignment(struct ieee80211_txrx_data *rx)
+{
+	int hdrlen;
+
+	/*
+	 * Drivers are required to align the payload data in a way that
+	 * guarantees that the contained IP header is aligned to a four-
+	 * byte boundary. In the case of regular frames, this simply means
+	 * aligning the payload to a four-byte boundary (because either
+	 * the IP header is directly contained, or IV/RFC1042 headers that
+	 * have a length divisible by four are in front of it.
+	 *
+	 * With A-MSDU frames, however, the payload data address must
+	 * yield two modulo four because there are 14-byte 802.3 headers
+	 * within the A-MSDU frames that push the IP header further back
+	 * to a multiple of four again. Thankfully, the specs were sane
+	 * enough this time around to require padding each A-MSDU subframe
+	 * to a length that is a multiple of four.
+	 *
+	 * Padding like atheros hardware adds which is inbetween the 802.11
+	 * header and the payload is not supported, the driver is required
+	 * to move the 802.11 header further back in that case.
+	 */
+	hdrlen = ieee80211_get_hdrlen(rx->fc);
+	if (rx->flags & IEEE80211_TXRXD_RX_AMSDU)
+		hdrlen += ETH_HLEN;
+	WARN_ON_ONCE(((unsigned long)(rx->skb->data + hdrlen)) & 3);
+
+	return TXRX_CONTINUE;
+}
+
 ieee80211_rx_handler ieee80211_rx_pre_handlers[] =
 {
 	ieee80211_rx_h_parse_qos,
+	ieee80211_rx_h_verify_ip_alignment,
 	NULL
 };
 
@@ -1677,7 +1710,6 @@ void __ieee80211_rx_handle_packet(struct
 	struct ieee80211_sub_if_data *prev = NULL;
 	struct sk_buff *skb_new;
 	u8 *bssid;
-	int hdrlen;
 
 	hdr = (struct ieee80211_hdr *) skb->data;
 	memset(&rx, 0, sizeof(rx));
@@ -1689,18 +1721,6 @@ void __ieee80211_rx_handle_packet(struct
 	rx.fc = le16_to_cpu(hdr->frame_control);
 	type = rx.fc & IEEE80211_FCTL_FTYPE;
 
-	/*
-	 * Drivers are required to align the payload data to a four-byte
-	 * boundary, so the last two bits of the address where it starts
-	 * may not be set. The header is required to be directly before
-	 * the payload data, padding like atheros hardware adds which is
-	 * inbetween the 802.11 header and the payload is not supported,
-	 * the driver is required to move the 802.11 header further back
-	 * in that case.
-	 */
-	hdrlen = ieee80211_get_hdrlen(rx.fc);
-	WARN_ON_ONCE(((unsigned long)(skb->data + hdrlen)) & 3);
-
 	if (type == IEEE80211_FTYPE_DATA || type == IEEE80211_FTYPE_MGMT)
 		local->dot11ReceivedFragmentCount++;
 


