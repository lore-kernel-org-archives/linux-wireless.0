Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:58241 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753516Ab0BDGyL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Feb 2010 01:54:11 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 03 Feb 2010 22:54:11 -0800
From: Vivek Natarajan <vnatarajan@atheros.com>
To: <linux-wireless@vger.kernel.org>
CC: Vivek Natarajan <vnatarajan@atheros.com>
Subject: [RFC PATCH 1/2] mac80211: Retry null data frame for power save.
Date: Thu, 4 Feb 2010 12:24:01 +0530
Message-ID: <1265266442-6273-1-git-send-email-vnatarajan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Even if the null data frame is not acked by the AP, mac80211
goes into power save. This might lead to loss of frames
from the AP.
Prevent this by restarting dynamic_ps_timer when ack is not
received for null data frames.

Signed-off-by: Vivek Natarajan <vnatarajan@atheros.com>
---
 net/mac80211/status.c |   15 +++++++++++++--
 1 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/status.c b/net/mac80211/status.c
index e57ad6b..a0e18b4 100644
--- a/net/mac80211/status.c
+++ b/net/mac80211/status.c
@@ -188,6 +188,7 @@ void ieee80211_tx_status(struct ieee80211_hw *hw, struct sk_buff *skb)
 	rcu_read_lock();
 
 	sband = local->hw.wiphy->bands[info->band];
+	fc = hdr->frame_control;
 
 	for_each_sta_info(local, hdr->addr1, sta, tmp) {
 		/* skip wrong virtual interface */
@@ -205,8 +206,6 @@ void ieee80211_tx_status(struct ieee80211_hw *hw, struct sk_buff *skb)
 			return;
 		}
 
-		fc = hdr->frame_control;
-
 		if ((info->flags & IEEE80211_TX_STAT_AMPDU_NO_BACK) &&
 		    (ieee80211_is_data_qos(fc))) {
 			u16 tid, ssn;
@@ -275,6 +274,18 @@ void ieee80211_tx_status(struct ieee80211_hw *hw, struct sk_buff *skb)
 			local->dot11FailedCount++;
 	}
 
+	if (ieee80211_is_nullfunc(fc) && ieee80211_has_pm(fc) &&
+			(local->hw.conf.flags & IEEE80211_CONF_PS)) {
+		if (!(info->flags & IEEE80211_TX_STAT_ACK)) {
+			ieee80211_stop_queues_by_reason(&local->hw,
+					IEEE80211_QUEUE_STOP_REASON_PS);
+			ieee80211_queue_work(&local->hw,
+					&local->dynamic_ps_disable_work);
+			mod_timer(&local->dynamic_ps_timer, jiffies +
+					msecs_to_jiffies(10));
+		}
+	}
+
 	/* this was a transmitted frame, but now we want to reuse it */
 	skb_orphan(skb);
 
-- 
1.6.6.1

