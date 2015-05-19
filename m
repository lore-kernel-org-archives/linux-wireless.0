Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:59482 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755399AbbESNqO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 May 2015 09:46:14 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: don't use napi_gro_receive() outside NAPI context
Date: Tue, 19 May 2015 15:46:11 +0200
Message-Id: <1432043171-756-1-git-send-email-johannes@sipsolutions.net> (sfid-20150519_154617_762656_8E8F87B0)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

No matter how the driver manages its NAPI context, there's no way
sending frames to it from a timer can be correct, since it would
corrupt the internal GRO lists.

To avoid that, always use the non-NAPI path when releasing frames
from the timer.

Cc: stable@vger.kernel.org
Reported-by: Jean Trivelly <jean.trivelly@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/ieee80211_i.h | 3 +++
 net/mac80211/rx.c          | 5 +++--
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 2c4fe45ea38a..caacd83cff18 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -202,6 +202,8 @@ enum ieee80211_packet_rx_flags {
  * @IEEE80211_RX_CMNTR: received on cooked monitor already
  * @IEEE80211_RX_BEACON_REPORTED: This frame was already reported
  *	to cfg80211_report_obss_beacon().
+ * @IEEE80211_RX_REORDER_TIMER: this frame is released by the
+ *	reorder buffer timeout timer, not the normal RX path
  *
  * These flags are used across handling multiple interfaces
  * for a single frame.
@@ -209,6 +211,7 @@ enum ieee80211_packet_rx_flags {
 enum ieee80211_rx_flags {
 	IEEE80211_RX_CMNTR		= BIT(0),
 	IEEE80211_RX_BEACON_REPORTED	= BIT(1),
+	IEEE80211_RX_REORDER_TIMER	= BIT(2),
 };
 
 struct ieee80211_rx_data {
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index aa35977a9c4d..7d85f7516324 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -2108,7 +2108,8 @@ ieee80211_deliver_skb(struct ieee80211_rx_data *rx)
 		/* deliver to local stack */
 		skb->protocol = eth_type_trans(skb, dev);
 		memset(skb->cb, 0, sizeof(skb->cb));
-		if (rx->local->napi)
+		if (!(rx->flags & IEEE80211_RX_REORDER_TIMER) &&
+		    rx->local->napi)
 			napi_gro_receive(rx->local->napi, skb);
 		else
 			netif_receive_skb(skb);
@@ -3215,7 +3216,7 @@ void ieee80211_release_reorder_timeout(struct sta_info *sta, int tid)
 		/* This is OK -- must be QoS data frame */
 		.security_idx = tid,
 		.seqno_idx = tid,
-		.flags = 0,
+		.flags = IEEE80211_RX_REORDER_TIMER,
 	};
 	struct tid_ampdu_rx *tid_agg_rx;
 
-- 
2.1.4

