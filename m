Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:42015 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753830AbYA2RoX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jan 2008 12:44:23 -0500
Subject: [PATCH] mac80211: dissolve pre-rx handlers
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 29 Jan 2008 17:07:43 +0100
Message-Id: <1201622863.4394.31.camel@johannes.berg> (sfid-20080129_174432_568085_93BF40E5)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These handlers do not really return a status and the compiler
can do a much better job when they're simply static functions
that it can inline if appropriate. Also makes the code shorter.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/ieee80211.c   |    1 
 net/mac80211/ieee80211_i.h |    2 
 net/mac80211/rx.c          |   96 +++++++++++++++++----------------------------
 3 files changed, 37 insertions(+), 62 deletions(-)

--- everything.orig/net/mac80211/rx.c	2008-01-29 16:58:08.255592231 +0100
+++ everything/net/mac80211/rx.c	2008-01-29 17:05:37.005588976 +0100
@@ -246,15 +246,7 @@ ieee80211_rx_monitor(struct ieee80211_lo
 }
 
 
-/* pre-rx handlers
- *
- * these don't have dev/sdata fields in the rx data
- * The sta value should also not be used because it may
- * be NULL even though a STA (in IBSS mode) will be added.
- */
-
-static ieee80211_txrx_result
-ieee80211_rx_h_parse_qos(struct ieee80211_txrx_data *rx)
+static void ieee80211_parse_qos(struct ieee80211_txrx_data *rx)
 {
 	u8 *data = rx->skb->data;
 	int tid;
@@ -287,8 +279,40 @@ ieee80211_rx_h_parse_qos(struct ieee8021
 	/* Set skb->priority to 1d tag if highest order bit of TID is not set.
 	 * For now, set skb->priority to 0 for other cases. */
 	rx->skb->priority = (tid > 7) ? 0 : tid;
+}
 
-	return TXRX_CONTINUE;
+static void ieee80211_verify_ip_alignment(struct ieee80211_txrx_data *rx)
+{
+#ifdef CONFIG_MAC80211_DEBUG_PACKET_ALIGNMENT
+	int hdrlen;
+
+	if (!WLAN_FC_DATA_PRESENT(rx->fc))
+		return;
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
+#endif
 }
 
 
@@ -325,52 +349,6 @@ static u32 ieee80211_rx_load_stats(struc
 	return load;
 }
 
-#ifdef CONFIG_MAC80211_DEBUG_PACKET_ALIGNMENT
-static ieee80211_txrx_result
-ieee80211_rx_h_verify_ip_alignment(struct ieee80211_txrx_data *rx)
-{
-	int hdrlen;
-
-	if (!WLAN_FC_DATA_PRESENT(rx->fc))
-		return TXRX_CONTINUE;
-
-	/*
-	 * Drivers are required to align the payload data in a way that
-	 * guarantees that the contained IP header is aligned to a four-
-	 * byte boundary. In the case of regular frames, this simply means
-	 * aligning the payload to a four-byte boundary (because either
-	 * the IP header is directly contained, or IV/RFC1042 headers that
-	 * have a length divisible by four are in front of it.
-	 *
-	 * With A-MSDU frames, however, the payload data address must
-	 * yield two modulo four because there are 14-byte 802.3 headers
-	 * within the A-MSDU frames that push the IP header further back
-	 * to a multiple of four again. Thankfully, the specs were sane
-	 * enough this time around to require padding each A-MSDU subframe
-	 * to a length that is a multiple of four.
-	 *
-	 * Padding like atheros hardware adds which is inbetween the 802.11
-	 * header and the payload is not supported, the driver is required
-	 * to move the 802.11 header further back in that case.
-	 */
-	hdrlen = ieee80211_get_hdrlen(rx->fc);
-	if (rx->flags & IEEE80211_TXRXD_RX_AMSDU)
-		hdrlen += ETH_HLEN;
-	WARN_ON_ONCE(((unsigned long)(rx->skb->data + hdrlen)) & 3);
-
-	return TXRX_CONTINUE;
-}
-#endif
-
-ieee80211_rx_handler ieee80211_rx_pre_handlers[] =
-{
-	ieee80211_rx_h_parse_qos,
-#ifdef CONFIG_MAC80211_DEBUG_PACKET_ALIGNMENT
-	ieee80211_rx_h_verify_ip_alignment,
-#endif
-	NULL
-};
-
 /* rx handlers */
 
 static ieee80211_txrx_result
@@ -1734,9 +1712,9 @@ static void __ieee80211_rx_handle_packet
 	if (unlikely(local->sta_sw_scanning || local->sta_hw_scanning))
 		rx.flags |= IEEE80211_TXRXD_RXIN_SCAN;
 
-	if (__ieee80211_invoke_rx_handlers(local, local->rx_pre_handlers, &rx,
-					   sta) != TXRX_CONTINUE)
-		goto end;
+	ieee80211_parse_qos(&rx);
+	ieee80211_verify_ip_alignment(&rx);
+
 	skb = rx.skb;
 
 	if (sta && !(sta->flags & (WLAN_STA_WDS | WLAN_STA_ASSOC_AP)) &&
--- everything.orig/net/mac80211/ieee80211_i.h	2008-01-29 17:02:07.365594944 +0100
+++ everything/net/mac80211/ieee80211_i.h	2008-01-29 17:02:36.195591146 +0100
@@ -463,7 +463,6 @@ struct ieee80211_local {
 			     * deliver multicast frames both back to wireless
 			     * media and to the local net stack */
 
-	ieee80211_rx_handler *rx_pre_handlers;
 	ieee80211_rx_handler *rx_handlers;
 	ieee80211_tx_handler *tx_handlers;
 
@@ -755,7 +754,6 @@ void ieee80211_if_free(struct net_device
 void ieee80211_if_sdata_init(struct ieee80211_sub_if_data *sdata);
 
 /* rx handling */
-extern ieee80211_rx_handler ieee80211_rx_pre_handlers[];
 extern ieee80211_rx_handler ieee80211_rx_handlers[];
 
 /* tx handling */
--- everything.orig/net/mac80211/ieee80211.c	2008-01-29 17:02:23.715592611 +0100
+++ everything/net/mac80211/ieee80211.c	2008-01-29 17:02:28.645589627 +0100
@@ -1064,7 +1064,6 @@ struct ieee80211_hw *ieee80211_alloc_hw(
 	local->hw.queues = 1; /* default */
 
 	local->mdev = mdev;
-	local->rx_pre_handlers = ieee80211_rx_pre_handlers;
 	local->rx_handlers = ieee80211_rx_handlers;
 	local->tx_handlers = ieee80211_tx_handlers;
 


