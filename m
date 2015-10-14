Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:33039 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753504AbbJNQ1k (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Oct 2015 12:27:40 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: clean up ieee80211_rx_h_check_dup code
Date: Wed, 14 Oct 2015 18:27:37 +0200
Message-Id: <1444840057-13228-1-git-send-email-johannes@sipsolutions.net> (sfid-20151014_182743_306303_C403AAA1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Reduce indentation a bit to make the condition more readable.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/rx.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 5bc0b88d9eb1..60692d964380 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1113,16 +1113,16 @@ ieee80211_rx_h_check_dup(struct ieee80211_rx_data *rx)
 	    is_multicast_ether_addr(hdr->addr1))
 		return RX_CONTINUE;
 
-	if (rx->sta) {
-		if (unlikely(ieee80211_has_retry(hdr->frame_control) &&
-			     rx->sta->last_seq_ctrl[rx->seqno_idx] ==
-			     hdr->seq_ctrl)) {
-			I802_DEBUG_INC(rx->local->dot11FrameDuplicateCount);
-			rx->sta->num_duplicates++;
-			return RX_DROP_UNUSABLE;
-		} else if (!(status->flag & RX_FLAG_AMSDU_MORE)) {
-			rx->sta->last_seq_ctrl[rx->seqno_idx] = hdr->seq_ctrl;
-		}
+	if (!rx->sta)
+		return RX_CONTINUE;
+
+	if (unlikely(ieee80211_has_retry(hdr->frame_control) &&
+		     rx->sta->last_seq_ctrl[rx->seqno_idx] == hdr->seq_ctrl)) {
+		I802_DEBUG_INC(rx->local->dot11FrameDuplicateCount);
+		rx->sta->num_duplicates++;
+		return RX_DROP_UNUSABLE;
+	} else if (!(status->flag & RX_FLAG_AMSDU_MORE)) {
+		rx->sta->last_seq_ctrl[rx->seqno_idx] = hdr->seq_ctrl;
 	}
 
 	return RX_CONTINUE;
-- 
2.5.1

