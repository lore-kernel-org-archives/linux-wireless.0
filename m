Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:46812 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753331AbeFDOLu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 4 Jun 2018 10:11:50 -0400
From: Balaji Pothunoori <bpothuno@codeaurora.org>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
        Balaji Pothunoori <bpothuno@codeaurora.org>
Subject: [PATCH v2 2/2] mac80211: last ack signal support in station dump
Date: Mon,  4 Jun 2018 19:41:09 +0530
Message-Id: <1528121469-16450-3-git-send-email-bpothuno@codeaurora.org> (sfid-20180604_161158_453948_A0CEBEF0)
In-Reply-To: <1528121469-16450-1-git-send-email-bpothuno@codeaurora.org>
References: <1528121469-16450-1-git-send-email-bpothuno@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds "last ack signal" and "avg ack signal" support
in station dump for valid ack rssi.

Signed-off-by: Balaji Pothunoori <bpothuno@codeaurora.org>
---
v2:
 - typo corrected in subject

 net/mac80211/sta_info.c | 20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 6428f1a..12b618e 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -2310,13 +2310,21 @@ void sta_set_sinfo(struct sta_info *sta, struct station_info *sinfo,
 		sinfo->filled |= BIT_ULL(NL80211_STA_INFO_ACK_SIGNAL);
 	}
 
-	if (ieee80211_hw_check(&sta->local->hw, REPORTS_TX_ACK_STATUS) &&
-	    !(sinfo->filled & BIT_ULL(NL80211_STA_INFO_DATA_ACK_SIGNAL_AVG))) {
-		sinfo->avg_ack_signal =
-			-(s8)ewma_avg_signal_read(
+	if (ieee80211_hw_check(&sta->local->hw, REPORTS_TX_ACK_STATUS)) {
+		if (sta->status_stats.ack_signal_filled && ((!(sinfo->filled &
+		    BIT_ULL(NL80211_STA_INFO_ACK_SIGNAL))) ||
+		    (!(sinfo->filled &
+		    BIT_ULL(NL80211_STA_INFO_ACK_SIGNAL_AVG))))) {
+			sinfo->ack_signal =
+				sta->status_stats.last_ack_signal;
+			sinfo->filled |=
+				BIT_ULL(NL80211_STA_INFO_ACK_SIGNAL);
+			sinfo->avg_ack_signal =
+				-(s8)ewma_avg_signal_read(
 				&sta->status_stats.avg_ack_signal);
-		sinfo->filled |=
-			BIT_ULL(NL80211_STA_INFO_DATA_ACK_SIGNAL_AVG);
+			sinfo->filled |=
+				BIT_ULL(NL80211_STA_INFO_ACK_SIGNAL_AVG);
+		}
 	}
 }
 
-- 
2.7.4
