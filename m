Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:58980 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751143AbaKKQGH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Nov 2014 11:06:07 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: refactor duplicate detection
Date: Tue, 11 Nov 2014 17:06:02 +0100
Message-Id: <1415721962-5993-1-git-send-email-johannes@sipsolutions.net> (sfid-20141111_170611_513877_CD74D553)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Put duplicate detection into its own RX handler, and separate
out the conditions a bit to make the code more readable.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/rx.c | 25 ++++++++++++++++++++-----
 1 file changed, 20 insertions(+), 5 deletions(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index f57af5c7c12a..0f4297e2aae2 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1047,7 +1047,7 @@ static void ieee80211_rx_reorder_ampdu(struct ieee80211_rx_data *rx,
 }
 
 static ieee80211_rx_result debug_noinline
-ieee80211_rx_h_check(struct ieee80211_rx_data *rx)
+ieee80211_rx_h_check_dup(struct ieee80211_rx_data *rx)
 {
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)rx->skb->data;
 	struct ieee80211_rx_status *status = IEEE80211_SKB_RXCB(rx->skb);
@@ -1056,10 +1056,16 @@ ieee80211_rx_h_check(struct ieee80211_rx_data *rx)
 	 * Drop duplicate 802.11 retransmissions
 	 * (IEEE 802.11-2012: 9.3.2.10 "Duplicate detection and recovery")
 	 */
-	if (rx->skb->len >= 24 && rx->sta &&
-	    !ieee80211_is_ctl(hdr->frame_control) &&
-	    !ieee80211_is_qos_nullfunc(hdr->frame_control) &&
-	    !is_multicast_ether_addr(hdr->addr1)) {
+
+	if (rx->skb->len < 24)
+		return RX_CONTINUE;
+
+	if (ieee80211_is_ctl(hdr->frame_control) ||
+	    ieee80211_is_qos_nullfunc(hdr->frame_control) ||
+	    is_multicast_ether_addr(hdr->addr1))
+		return RX_CONTINUE;
+
+	if (rx->sta) {
 		if (unlikely(ieee80211_has_retry(hdr->frame_control) &&
 			     rx->sta->last_seq_ctrl[rx->seqno_idx] ==
 			     hdr->seq_ctrl)) {
@@ -1073,6 +1079,14 @@ ieee80211_rx_h_check(struct ieee80211_rx_data *rx)
 		}
 	}
 
+	return RX_CONTINUE;
+}
+
+static ieee80211_rx_result debug_noinline
+ieee80211_rx_h_check(struct ieee80211_rx_data *rx)
+{
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)rx->skb->data;
+
 	if (unlikely(rx->skb->len < 16)) {
 		I802_DEBUG_INC(rx->local->rx_handlers_drop_short);
 		return RX_DROP_MONITOR;
@@ -3110,6 +3124,7 @@ static void ieee80211_invoke_rx_handlers(struct ieee80211_rx_data *rx)
 			goto rxh_next;  \
 	} while (0);
 
+	CALL_RXH(ieee80211_rx_h_check_dup)
 	CALL_RXH(ieee80211_rx_h_check)
 
 	ieee80211_rx_reorder_ampdu(rx, &reorder_release);
-- 
2.1.1

