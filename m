Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:46700 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753855AbeFDOLd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 4 Jun 2018 10:11:33 -0400
From: Balaji Pothunoori <bpothuno@codeaurora.org>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
        Balaji Pothunoori <bpothuno@codeaurora.org>
Subject: [PATCH v2 1/2] cfg80211: last ack signal support in station dump
Date: Mon,  4 Jun 2018 19:41:08 +0530
Message-Id: <1528121469-16450-2-git-send-email-bpothuno@codeaurora.org> (sfid-20180604_161145_300285_64643662)
In-Reply-To: <1528121469-16450-1-git-send-email-bpothuno@codeaurora.org>
References: <1528121469-16450-1-git-send-email-bpothuno@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds "last ack signal" support in station dump if
driver supports.

Signed-off-by: Balaji Pothunoori <bpothuno@codeaurora.org>
---
v2:
 - typo corrected in subject

 include/uapi/linux/nl80211.h | 14 +++++++-------
 net/wireless/nl80211.c       |  8 ++++----
 2 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 28b3654..3514bef 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -3000,8 +3000,8 @@ enum nl80211_sta_bss_param {
  *	received from the station (u64, usec)
  * @NL80211_STA_INFO_PAD: attribute used for padding for 64-bit alignment
  * @NL80211_STA_INFO_ACK_SIGNAL: signal strength of the last ACK frame(u8, dBm)
- * @NL80211_STA_INFO_DATA_ACK_SIGNAL_AVG: avg signal strength of (data)
- *	ACK frame (s8, dBm)
+ * @NL80211_STA_INFO_ACK_SIGNAL_AVG: avg signal strength of data or management
+ *	ACK frames(s8, dBm)
  * @__NL80211_STA_INFO_AFTER_LAST: internal
  * @NL80211_STA_INFO_MAX: highest possible station info attribute
  */
@@ -3041,7 +3041,7 @@ enum nl80211_sta_info {
 	NL80211_STA_INFO_RX_DURATION,
 	NL80211_STA_INFO_PAD,
 	NL80211_STA_INFO_ACK_SIGNAL,
-	NL80211_STA_INFO_DATA_ACK_SIGNAL_AVG,
+	NL80211_STA_INFO_ACK_SIGNAL_AVG,
 
 	/* keep last */
 	__NL80211_STA_INFO_AFTER_LAST,
@@ -5128,9 +5128,9 @@ enum nl80211_feature_flags {
  *	"radar detected" event.
  * @NL80211_EXT_FEATURE_CONTROL_PORT_OVER_NL80211: Driver supports sending and
  *	receiving control port frames over nl80211 instead of the netdevice.
- * @NL80211_EXT_FEATURE_DATA_ACK_SIGNAL_SUPPORT: This Driver support data ack
- *	rssi if firmware support, this flag is to intimate about ack rssi
- *	support to nl80211.
+ * @NL80211_EXT_FEATURE_ACK_SIGNAL_SUPPORT: This Driver support ack rssi if
+ *	firmware support, this flag is to intimate about ack rssi support
+ *	to nl80211.
  * @NL80211_EXT_FEATURE_TXQS: Driver supports FQ-CoDel-enabled intermediate
  *      TXQs.
  *
@@ -5165,7 +5165,7 @@ enum nl80211_ext_feature_index {
 	NL80211_EXT_FEATURE_HIGH_ACCURACY_SCAN,
 	NL80211_EXT_FEATURE_DFS_OFFLOAD,
 	NL80211_EXT_FEATURE_CONTROL_PORT_OVER_NL80211,
-	NL80211_EXT_FEATURE_DATA_ACK_SIGNAL_SUPPORT,
+	NL80211_EXT_FEATURE_ACK_SIGNAL_SUPPORT,
 	NL80211_EXT_FEATURE_TXQS,
 
 	/* add new features before the definition below */
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 07514ca..29cf5fd 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -4650,11 +4650,11 @@ static int nl80211_send_station(struct sk_buff *msg, u32 cmd, u32 portid,
 	PUT_SINFO_U64(RX_DROP_MISC, rx_dropped_misc);
 	PUT_SINFO_U64(BEACON_RX, rx_beacon);
 	PUT_SINFO(BEACON_SIGNAL_AVG, rx_beacon_signal_avg, u8);
-	PUT_SINFO(ACK_SIGNAL, ack_signal, u8);
 	if (wiphy_ext_feature_isset(&rdev->wiphy,
-				    NL80211_EXT_FEATURE_DATA_ACK_SIGNAL_SUPPORT))
-		PUT_SINFO(DATA_ACK_SIGNAL_AVG, avg_ack_signal, s8);
-
+				    NL80211_EXT_FEATURE_ACK_SIGNAL_SUPPORT)) {
+		PUT_SINFO(ACK_SIGNAL, ack_signal, u8);
+		PUT_SINFO(ACK_SIGNAL_AVG, avg_ack_signal, s8);
+	}
 #undef PUT_SINFO
 #undef PUT_SINFO_U64
 
-- 
2.7.4
