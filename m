Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:43928 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731696AbeGSOKH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 19 Jul 2018 10:10:07 -0400
From: Balaji Pothunoori <bpothuno@codeaurora.org>
To: johannes@sipsolutions.net, ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
        Balaji Pothunoori <bpothuno@codeaurora.org>
Subject: [PATCH v2 2/3] mac80211: Extend avg ack rssi support for mgmt frames
Date: Thu, 19 Jul 2018 18:56:28 +0530
Message-Id: <1532006789-32454-3-git-send-email-bpothuno@codeaurora.org> (sfid-20180719_152659_455517_1AC0FADA)
In-Reply-To: <1532006789-32454-1-git-send-email-bpothuno@codeaurora.org>
References: <1532006789-32454-1-git-send-email-bpothuno@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Used defined API to make common average ack rssi
support irrespective of data or mamagement tx ack packet.

Signed-off-by: Balaji Pothunoori <bpothuno@codeaurora.org>
---
v2: Addressed Johannes comments
    Modified subject and commit log

 net/mac80211/sta_info.c | 26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index aa8fe77..1364f0b 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -2317,19 +2317,19 @@ void sta_set_sinfo(struct sta_info *sta, struct station_info *sinfo,
 		sinfo->expected_throughput = thr;
 	}
 
-	if (!(sinfo->filled & BIT_ULL(NL80211_STA_INFO_ACK_SIGNAL)) &&
-	    sta->status_stats.ack_signal_filled) {
-		sinfo->ack_signal = sta->status_stats.last_ack_signal;
-		sinfo->filled |= BIT_ULL(NL80211_STA_INFO_ACK_SIGNAL);
-	}
-
-	if (ieee80211_hw_check(&sta->local->hw, REPORTS_TX_ACK_STATUS) &&
-	    !(sinfo->filled & BIT_ULL(NL80211_STA_INFO_DATA_ACK_SIGNAL_AVG))) {
-		sinfo->avg_ack_signal =
-			-(s8)ewma_avg_signal_read(
-				&sta->status_stats.avg_ack_signal);
-		sinfo->filled |=
-			BIT_ULL(NL80211_STA_INFO_DATA_ACK_SIGNAL_AVG);
+	if (ieee80211_hw_check(&sta->local->hw, REPORTS_TX_ACK_STATUS)) {
+		if (sta->status_stats.ack_signal_filled &&
+		    (!(sinfo->filled & BIT_ULL(NL80211_STA_INFO_ACK_SIGNAL)) ||
+		    !(sinfo->filled & BIT_ULL(NL80211_STA_INFO_ACK_SIGNAL_AVG)))) {
+			sinfo->ack_signal =
+				sta->status_stats.last_ack_signal;
+			sinfo->filled |=
+				BIT_ULL(NL80211_STA_INFO_ACK_SIGNAL);
+			sinfo->avg_ack_signal =
+				-(s8)ewma_avg_signal_read(&sta->status_stats.avg_ack_signal);
+			sinfo->filled |=
+				BIT_ULL(NL80211_STA_INFO_ACK_SIGNAL_AVG);
+		}
 	}
 }
 
-- 
2.7.4
