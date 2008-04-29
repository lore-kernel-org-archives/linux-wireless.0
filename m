Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:50542 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755815AbYD3OGk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Apr 2008 10:06:40 -0400
Message-Id: <20080429152041.385102000@sipsolutions.net> (sfid-20080430_160638_520893_A152CCAB)
References: <20080429151858.253229000@sipsolutions.net>
Date: Tue, 29 Apr 2008 17:19:00 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 2/3] mac80211: remove queue info from ieee80211_tx_status
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The queue info in struct ieee80211_tx_status is never used.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 drivers/net/wireless/iwlwifi/iwl4965-base.c |    7 -------
 drivers/net/wireless/rt2x00/rt2x00dev.c     |    3 ---
 include/net/mac80211.h                      |    4 ----
 3 files changed, 14 deletions(-)

--- everything.orig/include/net/mac80211.h	2008-04-29 11:20:55.000000000 +0200
+++ everything/include/net/mac80211.h	2008-04-29 11:20:59.000000000 +0200
@@ -406,8 +406,6 @@ enum ieee80211_tx_status_flags {
  * @ampdu_ack_map: block ack bit map for the aggregation.
  * 	relevant only if IEEE80211_TX_STATUS_AMPDU was set.
  * @ack_signal: signal strength of the ACK frame
- * @queue_length: ?? REMOVE
- * @queue_number: ?? REMOVE
  */
 struct ieee80211_tx_status {
 	struct ieee80211_tx_control control;
@@ -417,8 +415,6 @@ struct ieee80211_tx_status {
 	u8 ampdu_ack_len;
 	u64 ampdu_ack_map;
 	int ack_signal;
-	int queue_length;
-	int queue_number;
 };
 
 /**
--- everything.orig/drivers/net/wireless/iwlwifi/iwl4965-base.c	2008-04-29 11:20:55.000000000 +0200
+++ everything/drivers/net/wireless/iwlwifi/iwl4965-base.c	2008-04-29 11:20:59.000000000 +0200
@@ -2710,8 +2710,6 @@ static void iwl4965_txstatus_to_ieee(str
 
 	tx_sta->status.ack_signal = 0;
 	tx_sta->status.excessive_retries = 0;
-	tx_sta->status.queue_length = 0;
-	tx_sta->status.queue_number = 0;
 
 	if (in_interrupt())
 		ieee80211_tx_status_irqsafe(priv->hw,
@@ -2847,8 +2845,6 @@ static int iwl4965_tx_status_reply_tx(st
 
 		tx_status = &(priv->txq[txq_id].txb[idx].status);
 		tx_status->retry_count = tx_resp->failure_frame;
-		tx_status->queue_number = status & 0xff;
-		tx_status->queue_length = tx_resp->failure_rts;
 		tx_status->control.flags &= ~IEEE80211_TXCTL_AMPDU;
 		tx_status->flags = iwl4965_is_tx_success(status)?
 			IEEE80211_TX_STATUS_ACK : 0;
@@ -3008,9 +3004,6 @@ static void iwl4965_rx_reply_tx(struct i
 	tx_status = &(txq->txb[txq->q.read_ptr].status);
 
 	tx_status->retry_count = tx_resp->failure_frame;
-	tx_status->queue_number = status;
-	tx_status->queue_length = tx_resp->bt_kill_count;
-	tx_status->queue_length |= tx_resp->failure_rts;
 	tx_status->flags =
 	    iwl4965_is_tx_success(status) ? IEEE80211_TX_STATUS_ACK : 0;
 	iwl4965_hwrate_to_tx_control(priv, le32_to_cpu(tx_resp->rate_n_flags),
--- everything.orig/drivers/net/wireless/rt2x00/rt2x00dev.c	2008-04-29 11:20:50.000000000 +0200
+++ everything/drivers/net/wireless/rt2x00/rt2x00dev.c	2008-04-29 11:20:59.000000000 +0200
@@ -525,9 +525,6 @@ void rt2x00lib_txdone(struct queue_entry
 			rt2x00dev->low_level_stats.dot11ACKFailureCount++;
 	}
 
-	tx_status.queue_length = entry->queue->limit;
-	tx_status.queue_number = tx_status.control.queue;
-
 	if (tx_status.control.flags & IEEE80211_TXCTL_USE_RTS_CTS) {
 		if (success)
 			rt2x00dev->low_level_stats.dot11RTSSuccessCount++;

-- 

