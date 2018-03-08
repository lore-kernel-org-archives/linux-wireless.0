Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:60664 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754752AbeCHHTr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 8 Mar 2018 02:19:47 -0500
From: Balaji Pothunoori <bpothuno@codeaurora.org>
To: johannes@sipsolutions.net
Cc: bpothuno@qti.qualcomm.com, linux-wireless@vger.kernel.org,
        Balaji Pothunoori <bpothuno@codeaurora.org>
Subject: [PATCH v3] iw: avgerage ack rssi changes for data frames
Date: Thu,  8 Mar 2018 12:49:41 +0530
Message-Id: <1520493581-26708-1-git-send-email-bpothuno@codeaurora.org> (sfid-20180308_081951_386106_7F70384D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch is to display the average ack rssi for data
frames. "avg ack signal" field diplay limited by host based on
firmware capablities.

Example output:

localhost ~ #iw dev wlan-5000mhz station dump
Station 34:f3:9a:aa:3b:29 (on wlan-5000mhz)
        inactive time:  5370 ms
        rx bytes:       85321
        rx packets:     576
        tx bytes:       14225
        tx packets:     71
        tx retries:     0
        tx failed:      2
        beacon loss:    0
        rx drop misc:   0
        signal:         -54 dBm
        signal avg:     -53 dBm
        tx bitrate:     866.7 MBit/s VHT-MCS 9 80MHz short GI VHT-NSS 2
        rx bitrate:     866.7 MBit/s VHT-MCS 9 80MHz short GI VHT-NSS 2
        avg ack signal: -56 dBm
        authorized:     yes
        authenticated:  yes
        associated:     yes
        preamble:       short
        WMM/WME:        yes
        MFP:            no
        TDLS peer:      no
        DTIM period:    2
        beacon interval:100
        short preamble: yes
        short slot time:yes
        connected time: 203 seconds

Signed-off-by: Balaji Pothunoori <bpothuno@codeaurora.org>
---
V2:
   -Removed nl80211.h changes and modified the commit log.
V3:
   -Adding version.
---
 station.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/station.c b/station.c
index f3e3da8..6c567bc 100644
--- a/station.c
+++ b/station.c
@@ -237,6 +237,7 @@ static int print_sta_handler(struct nl_msg *msg, void *arg)
 		[NL80211_STA_INFO_TID_STATS] = { .type = NLA_NESTED },
 		[NL80211_STA_INFO_BSS_PARAM] = { .type = NLA_NESTED },
 		[NL80211_STA_INFO_RX_DURATION] = { .type = NLA_U64 },
+		[NL80211_STA_INFO_DATA_AVG_ACK_SIGNAL] = { .type = NLA_U8 },
 	};
 	char *chain;
 
@@ -338,6 +339,9 @@ static int print_sta_handler(struct nl_msg *msg, void *arg)
 		printf("\n\trx duration:\t%lld us",
 		       (unsigned long long)nla_get_u64(sinfo[NL80211_STA_INFO_RX_DURATION]));
 
+	if (sinfo[NL80211_STA_INFO_DATA_AVG_ACK_SIGNAL])
+		printf("\n\tavg ack signal:\t%d dBm",
+		       (int8_t)nla_get_u8(sinfo[NL80211_STA_INFO_DATA_AVG_ACK_SIGNAL]));
 	if (sinfo[NL80211_STA_INFO_EXPECTED_THROUGHPUT]) {
 		uint32_t thr;
 
-- 
2.7.4
