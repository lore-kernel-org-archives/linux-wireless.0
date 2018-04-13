Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:39548 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754416AbeDMLeU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 13 Apr 2018 07:34:20 -0400
From: Balaji Pothunoori <bpothuno@codeaurora.org>
To: linux-wireless@vger.kernel.org
Cc: bpothuno@codeaurora.org
Subject: [PATCH 2/3] mac80211: average ack rssi support for data frames
Date: Fri, 13 Apr 2018 17:04:02 +0530
Message-Id: <1523619243-1898-3-git-send-email-bpothuno@codeaurora.org> (sfid-20180413_133435_071888_0E36CCD4)
In-Reply-To: <1523619243-1898-2-git-send-email-bpothuno@codeaurora.org>
References: <1523619243-1898-2-git-send-email-bpothuno@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The driver will process the RSSI if available and send it to mac80211.
mac80211 will compute the weighted average of ack RSSI for stations.

Signed-off-by: Balaji Pothunoori <bpothuno@codeaurora.org>
---
 net/mac80211/sta_info.c | 10 ++++++++++
 net/mac80211/sta_info.h |  2 ++
 net/mac80211/status.c   |  2 ++
 3 files changed, 14 insertions(+)

diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 655c3d8..fad6a84 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -357,6 +357,7 @@ struct sta_info *sta_info_alloc(struct ieee80211_sub_if_data *sdata,
 
 	sta->last_connected = ktime_get_seconds();
 	ewma_signal_init(&sta->rx_stats_avg.signal);
+	ewma_avg_signal_init(&sta->avg_ack_signal);
 	for (i = 0; i < ARRAY_SIZE(sta->rx_stats_avg.chain_signal); i++)
 		ewma_signal_init(&sta->rx_stats_avg.chain_signal[i]);
 
@@ -2294,6 +2295,15 @@ void sta_set_sinfo(struct sta_info *sta, struct station_info *sinfo)
 		sinfo->ack_signal = sta->status_stats.last_ack_signal;
 		sinfo->filled |= BIT_ULL(NL80211_STA_INFO_ACK_SIGNAL);
 	}
+	if (ieee80211_hw_check(&sta->local->hw, REPORTS_TX_ACK_STATUS)) {
+		if (!(sinfo->filled &
+			BIT_ULL(NL80211_STA_INFO_DATA_ACK_SIGNAL_AVG))) {
+			sinfo->avg_ack_signal =
+			-(s8)ewma_avg_signal_read(&sta->avg_ack_signal);
+			sinfo->filled |=
+				BIT_ULL(NL80211_STA_INFO_DATA_ACK_SIGNAL_AVG);
+		}
+	}
 }
 
 u32 sta_get_expected_throughput(struct sta_info *sta)
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index f64eb86..1028924 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -119,6 +119,7 @@ enum ieee80211_sta_info_flags {
 #define HT_AGG_STATE_START_CB		6
 #define HT_AGG_STATE_STOP_CB		7
 
+DECLARE_EWMA(avg_signal, 10, 8)
 enum ieee80211_agg_stop_reason {
 	AGG_STOP_DECLINED,
 	AGG_STOP_LOCAL_REQUEST,
@@ -581,6 +582,7 @@ struct sta_info {
 
 	struct cfg80211_chan_def tdls_chandef;
 
+	struct ewma_avg_signal avg_ack_signal;
 	/* keep last! */
 	struct ieee80211_sta sta;
 };
diff --git a/net/mac80211/status.c b/net/mac80211/status.c
index 743e89c..93dc971 100644
--- a/net/mac80211/status.c
+++ b/net/mac80211/status.c
@@ -195,6 +195,8 @@ static void ieee80211_frame_acked(struct sta_info *sta, struct sk_buff *skb)
 			sta->status_stats.last_ack_signal =
 					 (s8)txinfo->status.ack_signal;
 			sta->status_stats.ack_signal_filled = true;
+			ewma_avg_signal_add(&sta->avg_ack_signal,
+					    -(txinfo->status.ack_signal));
 		}
 	}
 
-- 
2.7.4
