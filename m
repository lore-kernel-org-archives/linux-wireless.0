Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:46669 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751256AbaKCN3S (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Nov 2014 08:29:18 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 3.18] mac80211: fix use-after-free in defragmentation
Date: Mon,  3 Nov 2014 14:29:09 +0100
Message-Id: <1415021349-30369-1-git-send-email-johannes@sipsolutions.net> (sfid-20141103_142921_941060_36A2DCEB)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Upon receiving the last fragment, all but the first fragment
are freed, but the multicast check for statistics at the end
of the function refers to the current skb (the last fragment)
causing a use-after-free bug.

Since multicast frames cannot be fragmented and we check for
this early in the function, just modify that check to also
do the accounting to fix the issue.

Cc: stable@vger.kernel.org
Reported-by: Yosef Khyal <yosefx.khyal@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/rx.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index b04ca4049c95..a37f9af634cb 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1678,11 +1678,14 @@ ieee80211_rx_h_defragment(struct ieee80211_rx_data *rx)
 	sc = le16_to_cpu(hdr->seq_ctrl);
 	frag = sc & IEEE80211_SCTL_FRAG;
 
-	if (likely((!ieee80211_has_morefrags(fc) && frag == 0) ||
-		   is_multicast_ether_addr(hdr->addr1))) {
-		/* not fragmented */
+	if (likely(!ieee80211_has_morefrags(fc) && frag == 0))
+		goto out;
+
+	if (is_multicast_ether_addr(hdr->addr1)) {
+		rx->local->dot11MulticastReceivedFrameCount++;
 		goto out;
 	}
+
 	I802_DEBUG_INC(rx->local->rx_handlers_fragments);
 
 	if (skb_linearize(rx->skb))
@@ -1775,10 +1778,7 @@ ieee80211_rx_h_defragment(struct ieee80211_rx_data *rx)
  out:
 	if (rx->sta)
 		rx->sta->rx_packets++;
-	if (is_multicast_ether_addr(hdr->addr1))
-		rx->local->dot11MulticastReceivedFrameCount++;
-	else
-		ieee80211_led_rx(rx->local);
+	ieee80211_led_rx(rx->local);
 	return RX_CONTINUE;
 }
 
-- 
2.1.1

