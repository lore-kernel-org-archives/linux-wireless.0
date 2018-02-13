Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:56714 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751237AbeBMFex (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 13 Feb 2018 00:34:53 -0500
From: Venkateswara Naralasetty <vnaralas@codeaurora.org>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
        Venkateswara Naralasetty <vnaralas@codeaurora.org>
Subject: [PATCHv2 2/3] mac80211: Add tx ack signal support in sta info
Date: Tue, 13 Feb 2018 11:04:46 +0530
Message-Id: <1518500086-10778-1-git-send-email-vnaralas@codeaurora.org> (sfid-20180213_063619_791544_4FC11981)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This allows users to get ack signal strength of
last transmitted frame.

Signed-off-by: Venkateswara Naralasetty <vnaralas@codeaurora.org>
---
V2:
 * added one bool variable to validate ack_signal is valid or not.

 include/net/mac80211.h  |  1 +
 net/mac80211/sta_info.c |  6 ++++++
 net/mac80211/sta_info.h |  2 ++
 net/mac80211/status.c   | 11 ++++++++++-
 4 files changed, 19 insertions(+), 1 deletion(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 906e902..854037b 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -934,6 +934,7 @@ struct ieee80211_tx_info {
 			u8 ampdu_len;
 			u8 antenna;
 			u16 tx_time;
+			bool is_valid_ack_signal;
 			void *status_driver_data[19 / sizeof(void *)];
 		} status;
 		struct {
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 0c5627f..0bc40c7 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -2287,6 +2287,12 @@ void sta_set_sinfo(struct sta_info *sta, struct station_info *sinfo)
 		sinfo->filled |= BIT(NL80211_STA_INFO_EXPECTED_THROUGHPUT);
 		sinfo->expected_throughput = thr;
 	}
+
+	if (!(sinfo->filled & BIT_ULL(NL80211_STA_INFO_ACK_SIGNAL)) &&
+	    sta->status_stats.ack_signal_filled) {
+		sinfo->ack_signal = sta->status_stats.last_ack_signal;
+		sinfo->filled |= BIT_ULL(NL80211_STA_INFO_ACK_SIGNAL);
+	}
 }
 
 u32 sta_get_expected_throughput(struct sta_info *sta)
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index cd53619..f64eb86 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -548,6 +548,8 @@ struct sta_info {
 		u64 msdu_retries[IEEE80211_NUM_TIDS + 1];
 		u64 msdu_failed[IEEE80211_NUM_TIDS + 1];
 		unsigned long last_ack;
+		s8 last_ack_signal;
+		bool ack_signal_filled;
 	} status_stats;
 
 	/* Updated from TX path only, no locking requirements */
diff --git a/net/mac80211/status.c b/net/mac80211/status.c
index da7427a..743e89c 100644
--- a/net/mac80211/status.c
+++ b/net/mac80211/status.c
@@ -187,9 +187,16 @@ static void ieee80211_frame_acked(struct sta_info *sta, struct sk_buff *skb)
 	struct ieee80211_mgmt *mgmt = (void *) skb->data;
 	struct ieee80211_local *local = sta->local;
 	struct ieee80211_sub_if_data *sdata = sta->sdata;
+	struct ieee80211_tx_info *txinfo = IEEE80211_SKB_CB(skb);
 
-	if (ieee80211_hw_check(&local->hw, REPORTS_TX_ACK_STATUS))
+	if (ieee80211_hw_check(&local->hw, REPORTS_TX_ACK_STATUS)) {
 		sta->status_stats.last_ack = jiffies;
+		if (txinfo->status.is_valid_ack_signal) {
+			sta->status_stats.last_ack_signal =
+					 (s8)txinfo->status.ack_signal;
+			sta->status_stats.ack_signal_filled = true;
+		}
+	}
 
 	if (ieee80211_is_data_qos(mgmt->frame_control)) {
 		struct ieee80211_hdr *hdr = (void *) skb->data;
@@ -487,6 +494,8 @@ static void ieee80211_report_ack_skb(struct ieee80211_local *local,
 			    ieee80211_is_qos_nullfunc(hdr->frame_control))
 				cfg80211_probe_status(sdata->dev, hdr->addr1,
 						      cookie, acked,
+						      info->status.ack_signal,
+						      info->status.is_valid_ack_signal,
 						      GFP_ATOMIC);
 			else
 				cfg80211_mgmt_tx_status(&sdata->wdev, cookie,
-- 
2.7.4
