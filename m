Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:44827 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753539AbbJTIPF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Oct 2015 04:15:05 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 1/3] mac80211: remove sta->last_ack_signal
Date: Tue, 20 Oct 2015 10:14:56 +0200
Message-Id: <1445328898-26849-1-git-send-email-johannes@sipsolutions.net> (sfid-20151020_101514_716034_893E9BD1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

This file only feeds a debugfs file that isn't very useful, so remove
it. If necessary, we can add other ways to get this information, for
example in the NL80211_CMD_PROBE_CLIENT response.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/debugfs_sta.c | 2 --
 net/mac80211/sta_info.h    | 2 --
 net/mac80211/status.c      | 3 ---
 3 files changed, 7 deletions(-)

diff --git a/net/mac80211/debugfs_sta.c b/net/mac80211/debugfs_sta.c
index 06d52935036d..1200b6a581d2 100644
--- a/net/mac80211/debugfs_sta.c
+++ b/net/mac80211/debugfs_sta.c
@@ -50,7 +50,6 @@ static const struct file_operations sta_ ##name## _ops = {		\
 		STA_OPS(name)
 
 STA_FILE(aid, sta.aid, D);
-STA_FILE(last_ack_signal, last_ack_signal, D);
 
 static ssize_t sta_flags_read(struct file *file, char __user *userbuf,
 			      size_t count, loff_t *ppos)
@@ -366,7 +365,6 @@ void ieee80211_sta_debugfs_add(struct sta_info *sta)
 	DEBUGFS_ADD(agg_status);
 	DEBUGFS_ADD(ht_capa);
 	DEBUGFS_ADD(vht_capa);
-	DEBUGFS_ADD(last_ack_signal);
 
 	DEBUGFS_ADD_COUNTER(rx_duplicates, num_duplicates);
 	DEBUGFS_ADD_COUNTER(rx_fragments, rx_fragments);
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index ce4271406692..7bb5781b4ce2 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -373,7 +373,6 @@ DECLARE_EWMA(signal, 1024, 8)
  * @rx_dropped: number of dropped MPDUs from this STA
  * @last_signal: signal of last received frame from this STA
  * @avg_signal: moving average of signal of received frames from this STA
- * @last_ack_signal: signal of last received Ack frame from this STA
  * @last_seq_ctrl: last received seq/frag number from this STA (per TID
  *	plus one for non-QoS frames)
  * @tx_filtered_count: number of frames the hardware filtered for this STA
@@ -467,7 +466,6 @@ struct sta_info {
 	unsigned long rx_dropped;
 	int last_signal;
 	struct ewma_signal avg_signal;
-	int last_ack_signal;
 
 	u8 chains;
 	s8 chain_signal_last[IEEE80211_MAX_CHAINS];
diff --git a/net/mac80211/status.c b/net/mac80211/status.c
index 98fd04c4b2a0..da67b84905a8 100644
--- a/net/mac80211/status.c
+++ b/net/mac80211/status.c
@@ -863,9 +863,6 @@ void ieee80211_tx_status(struct ieee80211_hw *hw, struct sk_buff *skb)
 				ieee80211_lost_packet(sta, info);
 			}
 		}
-
-		if (acked)
-			sta->last_ack_signal = info->status.ack_signal;
 	}
 
 	rcu_read_unlock();
-- 
2.5.1

