Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:46432 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750948AbeARMkr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 18 Jan 2018 07:40:47 -0500
From: Venkateswara Naralasetty <vnaralas@codeaurora.org>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
        Bhagavathi Perumal S <bperumal@codeaurora.org>,
        Venkateswara Naralasetty <vnaralas@codeaurora.org>
Subject: [PATCH 2/2] mac80211: Add tx ack signal support in sta info
Date: Thu, 18 Jan 2018 18:10:41 +0530
Message-Id: <1516279241-16536-1-git-send-email-vnaralas@codeaurora.org> (sfid-20180118_134051_171937_0778C32B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Bhagavathi Perumal S <bperumal@codeaurora.org>

This allows users to get ack signal strength of
last transmitted frame.

Signed-off-by: Bhagavathi Perumal S <bperumal@codeaurora.org>
Signed-off-by: Venkateswara Naralasetty <vnaralas@codeaurora.org>
---
 net/mac80211/sta_info.c | 6 ++++++
 net/mac80211/sta_info.h | 1 +
 net/mac80211/status.c   | 5 ++++-
 3 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 0c5627f..b20b9f3 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -2287,6 +2287,12 @@ void sta_set_sinfo(struct sta_info *sta, struct station_info *sinfo)
 		sinfo->filled |= BIT(NL80211_STA_INFO_EXPECTED_THROUGHPUT);
 		sinfo->expected_throughput = thr;
 	}
+
+	if (!(sinfo->filled & BIT_ULL(NL80211_STA_INFO_ACK_SIGNAL)) &&
+	    sta->status_stats.last_ack_signal) {
+		sinfo->ack_signal = sta->status_stats.last_ack_signal;
+		sinfo->filled |= BIT_ULL(NL80211_STA_INFO_ACK_SIGNAL);
+	}
 }
 
 u32 sta_get_expected_throughput(struct sta_info *sta)
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index cd53619..f4bf0c3 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -548,6 +548,7 @@ struct sta_info {
 		u64 msdu_retries[IEEE80211_NUM_TIDS + 1];
 		u64 msdu_failed[IEEE80211_NUM_TIDS + 1];
 		unsigned long last_ack;
+		s8 last_ack_signal;
 	} status_stats;
 
 	/* Updated from TX path only, no locking requirements */
diff --git a/net/mac80211/status.c b/net/mac80211/status.c
index da7427a..3180f02 100644
--- a/net/mac80211/status.c
+++ b/net/mac80211/status.c
@@ -187,9 +187,12 @@ static void ieee80211_frame_acked(struct sta_info *sta, struct sk_buff *skb)
 	struct ieee80211_mgmt *mgmt = (void *) skb->data;
 	struct ieee80211_local *local = sta->local;
 	struct ieee80211_sub_if_data *sdata = sta->sdata;
+	struct ieee80211_tx_info *txinfo = IEEE80211_SKB_CB(skb);
 
-	if (ieee80211_hw_check(&local->hw, REPORTS_TX_ACK_STATUS))
+	if (ieee80211_hw_check(&local->hw, REPORTS_TX_ACK_STATUS)) {
 		sta->status_stats.last_ack = jiffies;
+		sta->status_stats.last_ack_signal = (s8)txinfo->status.ack_signal;
+	}
 
 	if (ieee80211_is_data_qos(mgmt->frame_control)) {
 		struct ieee80211_hdr *hdr = (void *) skb->data;
-- 
2.7.4
