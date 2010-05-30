Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:58122 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752566Ab0E3MxG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 30 May 2010 08:53:06 -0400
Subject: [PATCH 2.6.34] mac80211: fix blockack-req processing
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Daniel Halperin <dhalperi@cs.washington.edu>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 30 May 2010 14:52:58 +0200
Message-ID: <1275223978.3599.0.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Daniel reported that the paged RX changes had
broken blockack request frame processing due
to using data that wasn't really part of the
skb data.

Fix this using skb_copy_bits() for the needed
data. As a side effect, this adds a check on
processing too short frames, which previously
this code could do.

Reported-by: Daniel Halperin <dhalperi@cs.washington.edu>
Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
Ok so maybe this patch is better than the
linearize one after all since we only ever
process this type of control frame anyway,
and unlike skb_linearize() skb_copy_bits()
cannot fail (unless the bits didn't exist
in the frame to start with).

 net/mac80211/rx.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

--- wireless-testing.orig/net/mac80211/rx.c	2010-05-28 22:25:07.000000000 +0200
+++ wireless-testing/net/mac80211/rx.c	2010-05-30 14:44:00.000000000 +0200
@@ -1819,17 +1819,26 @@ ieee80211_rx_h_ctrl(struct ieee80211_rx_
 		return RX_CONTINUE;
 
 	if (ieee80211_is_back_req(bar->frame_control)) {
+		struct {
+			__le16 control, start_seq_num;
+		} __packed bar_data;
+
 		if (!rx->sta)
 			return RX_DROP_MONITOR;
+
+		if (skb_copy_bits(skb, offsetof(struct ieee80211_bar, control),
+				  &bar_data, sizeof(bar_data)))
+			return RX_DROP_MONITOR;
+
 		spin_lock(&rx->sta->lock);
-		tid = le16_to_cpu(bar->control) >> 12;
+		tid = le16_to_cpu(bar_data.control) >> 12;
 		if (!rx->sta->ampdu_mlme.tid_active_rx[tid]) {
 			spin_unlock(&rx->sta->lock);
 			return RX_DROP_MONITOR;
 		}
 		tid_agg_rx = rx->sta->ampdu_mlme.tid_rx[tid];
 
-		start_seq_num = le16_to_cpu(bar->start_seq_num) >> 4;
+		start_seq_num = le16_to_cpu(bar_data.start_seq_num) >> 4;
 
 		/* reset session timer */
 		if (tid_agg_rx->timeout)


