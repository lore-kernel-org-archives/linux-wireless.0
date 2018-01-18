Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:46234 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750948AbeARMkQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 18 Jan 2018 07:40:16 -0500
From: Venkateswara Naralasetty <vnaralas@codeaurora.org>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
        Bhagavathi Perumal S <bperumal@codeaurora.org>,
        Venkateswara Naralasetty <vnaralas@codeaurora.org>
Subject: [PATCH 1/2] cfg80211: Add tx ack signal attribute in sta info
Date: Thu, 18 Jan 2018 18:10:08 +0530
Message-Id: <1516279208-16485-1-git-send-email-vnaralas@codeaurora.org> (sfid-20180118_134021_183500_3EDD0028)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Bhagavathi Perumal S <bperumal@codeaurora.org>

This patch provides support for users to get ack signal
strength of last transmitted by introducing new attribute
'NL80211_STA_INFO_ACK_SIGNAL'.

Signed-off-by: Bhagavathi Perumal S <bperumal@codeaurora.org>
Signed-off-by: Venkateswara Naralasetty <vnaralas@codeaurora.org>
---
 include/net/cfg80211.h       | 2 ++
 include/uapi/linux/nl80211.h | 2 ++
 net/wireless/nl80211.c       | 1 +
 3 files changed, 5 insertions(+)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 3a4a1a9..1236bea 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1145,6 +1145,7 @@ struct cfg80211_tid_stats {
  * @rx_duration: aggregate PPDU duration(usecs) for all the frames from a peer
  * @pertid: per-TID statistics, see &struct cfg80211_tid_stats, using the last
  *	(IEEE80211_NUM_TIDS) index for MSDUs not encapsulated in QoS-MPDUs.
+ * @ack_signal: signal strength (in dBm) of the last ACK frame.
  */
 struct station_info {
 	u64 filled;
@@ -1189,6 +1190,7 @@ struct station_info {
 	u64 rx_duration;
 	u8 rx_beacon_signal_avg;
 	struct cfg80211_tid_stats pertid[IEEE80211_NUM_TIDS + 1];
+	s8 ack_signal;
 };
 
 #if IS_ENABLED(CONFIG_CFG80211)
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index c587a61..5a1568d 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -2899,6 +2899,7 @@ enum nl80211_sta_bss_param {
  * @NL80211_STA_INFO_RX_DURATION: aggregate PPDU duration for all frames
  *	received from the station (u64, usec)
  * @NL80211_STA_INFO_PAD: attribute used for padding for 64-bit alignment
+ * @NL80211_STA_INFO_ACK_SIGNAL: signal strength of the last ACK frame(u8, dBm)
  * @__NL80211_STA_INFO_AFTER_LAST: internal
  * @NL80211_STA_INFO_MAX: highest possible station info attribute
  */
@@ -2937,6 +2938,7 @@ enum nl80211_sta_info {
 	NL80211_STA_INFO_TID_STATS,
 	NL80211_STA_INFO_RX_DURATION,
 	NL80211_STA_INFO_PAD,
+	NL80211_STA_INFO_ACK_SIGNAL,
 
 	/* keep last */
 	__NL80211_STA_INFO_AFTER_LAST,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index b3f8970..94c623e 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -4479,6 +4479,7 @@ static int nl80211_send_station(struct sk_buff *msg, u32 cmd, u32 portid,
 	PUT_SINFO_U64(RX_DROP_MISC, rx_dropped_misc);
 	PUT_SINFO_U64(BEACON_RX, rx_beacon);
 	PUT_SINFO(BEACON_SIGNAL_AVG, rx_beacon_signal_avg, u8);
+	PUT_SINFO(ACK_SIGNAL, ack_signal, u8);
 
 #undef PUT_SINFO
 #undef PUT_SINFO_U64
-- 
2.7.4
