Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:44658 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965060AbeCHGwj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 8 Mar 2018 01:52:39 -0500
From: Balaji Pothunoori <bpothuno@codeaurora.org>
To: johannes@sipsolutions.net
Cc: bpothuno@qti.qualcomm.com, linux-wireless@vger.kernel.org,
        Balaji Pothunoori <bpothuno@codeaurora.org>
Subject: [PATCH] iw: avgerage ack rssi changes for data frames
Date: Thu,  8 Mar 2018 12:22:32 +0530
Message-Id: <1520491952-26289-1-git-send-email-bpothuno@codeaurora.org> (sfid-20180308_075249_625686_378AFE85)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patchset changes to display the average ack rssi
for data frames.
"avg ack signal" field diplay limited by host based on
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
 nl80211.h | 6 ++++++
 station.c | 5 +++++
 2 files changed, 11 insertions(+)

diff --git a/nl80211.h b/nl80211.h
index 56368e9..6e9614d 100644
--- a/nl80211.h
+++ b/nl80211.h
@@ -2655,6 +2655,10 @@ enum nl80211_sta_bss_param {
  * @NL80211_STA_INFO_RX_DURATION: aggregate PPDU duration for all frames
  *	received from the station (u64, usec)
  * @NL80211_STA_INFO_PAD: attribute used for padding for 64-bit alignment
+ *  @NL80211_STA_INFO_ACK_SIGNAL: signal strength of the last ACK
+ *     frame(u8, dBm)
+ * @NL80211_STA_INFO_DATA_AVG_ACK_SIGNAL: avg signal strength of data ACK
+ *     frame(u8, dBm)
  * @__NL80211_STA_INFO_AFTER_LAST: internal
  * @NL80211_STA_INFO_MAX: highest possible station info attribute
  */
@@ -2693,6 +2697,8 @@ enum nl80211_sta_info {
 	NL80211_STA_INFO_TID_STATS,
 	NL80211_STA_INFO_RX_DURATION,
 	NL80211_STA_INFO_PAD,
+	NL80211_STA_INFO_ACK_SIGNAL,
+	NL80211_STA_INFO_DATA_AVG_ACK_SIGNAL,
 
 	/* keep last */
 	__NL80211_STA_INFO_AFTER_LAST,
diff --git a/station.c b/station.c
index f3e3da8..ec1f7bc 100644
--- a/station.c
+++ b/station.c
@@ -237,6 +237,7 @@ static int print_sta_handler(struct nl_msg *msg, void *arg)
 		[NL80211_STA_INFO_TID_STATS] = { .type = NLA_NESTED },
 		[NL80211_STA_INFO_BSS_PARAM] = { .type = NLA_NESTED },
 		[NL80211_STA_INFO_RX_DURATION] = { .type = NLA_U64 },
+		[NL80211_STA_INFO_DATA_AVG_ACK_SIGNAL] = { .type = NLA_U8 },
 	};
 	char *chain;
 
@@ -338,6 +339,10 @@ static int print_sta_handler(struct nl_msg *msg, void *arg)
 		printf("\n\trx duration:\t%lld us",
 		       (unsigned long long)nla_get_u64(sinfo[NL80211_STA_INFO_RX_DURATION]));
 
+	if (sinfo[NL80211_STA_INFO_DATA_AVG_ACK_SIGNAL])
+		printf("\n\tavg ack signal:\t%d dBm",
+		       (int8_t)nla_get_u8(sinfo[NL80211_STA_INFO_DATA_AVG_ACK_SIGNAL]));
+
 	if (sinfo[NL80211_STA_INFO_EXPECTED_THROUGHPUT]) {
 		uint32_t thr;
 
-- 
2.7.4
