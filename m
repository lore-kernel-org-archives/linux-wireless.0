Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:37278 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730919AbeGSPN1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 19 Jul 2018 11:13:27 -0400
From: Balaji Pothunoori <bpothuno@codeaurora.org>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
        Balaji Pothunoori <bpothuno@codeaurora.org>
Subject: [PATCH v5] iw: ack signal support for tx ack packets
Date: Thu, 19 Jul 2018 19:59:50 +0530
Message-Id: <1532010590-475-1-git-send-email-bpothuno@codeaurora.org> (sfid-20180719_163003_991323_18418E4F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch is to display the average ack signal,
last ack signal of tx ack packets.

Signed-off-by: Balaji Pothunoori <bpothuno@codeaurora.org>
---
v5:
 * Rebased, No changes
v4:
 * Changed the subject
 * Added last ack signal support and renamed avg ack signal macro
v3:
 * Added version no
v2:
 * Removed nl80211.h changes and modified the commit log

 station.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/station.c b/station.c
index 38c5f91..fd38043 100644
--- a/station.c
+++ b/station.c
@@ -308,6 +308,8 @@ static int print_sta_handler(struct nl_msg *msg, void *arg)
 		[NL80211_STA_INFO_TID_STATS] = { .type = NLA_NESTED },
 		[NL80211_STA_INFO_BSS_PARAM] = { .type = NLA_NESTED },
 		[NL80211_STA_INFO_RX_DURATION] = { .type = NLA_U64 },
+		[NL80211_STA_INFO_ACK_SIGNAL] = {.type = NLA_U8 },
+		[NL80211_STA_INFO_ACK_SIGNAL_AVG] = { .type = NLA_U8 },
 	};
 	char *chain;
 
@@ -409,6 +411,14 @@ static int print_sta_handler(struct nl_msg *msg, void *arg)
 		printf("\n\trx duration:\t%lld us",
 		       (unsigned long long)nla_get_u64(sinfo[NL80211_STA_INFO_RX_DURATION]));
 
+	if (sinfo[NL80211_STA_INFO_ACK_SIGNAL])
+		printf("\n\tlast ack signal:%d dBm",
+			(int8_t)nla_get_u8(sinfo[NL80211_STA_INFO_ACK_SIGNAL]));
+
+	if (sinfo[NL80211_STA_INFO_ACK_SIGNAL_AVG])
+		printf("\n\tavg ack signal:\t%d dBm",
+			(int8_t)nla_get_u8(sinfo[NL80211_STA_INFO_ACK_SIGNAL_AVG]));
+
 	if (sinfo[NL80211_STA_INFO_EXPECTED_THROUGHPUT]) {
 		uint32_t thr;
 
-- 
2.7.4
