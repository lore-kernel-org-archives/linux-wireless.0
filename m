Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:55942 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755349AbaKUN2a (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Nov 2014 08:28:30 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [RFC 1/2] nl80211: support MSDU statistics
Date: Fri, 21 Nov 2014 14:28:24 +0100
Message-Id: <1416576505-15023-1-git-send-email-johannes@sipsolutions.net> (sfid-20141121_142834_070138_2793BA04)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The base for the current statistics is pretty mixed up, support
exporting RX/TX statistics for MSDUs.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/cfg80211.h       | 10 +++++++++-
 include/uapi/linux/nl80211.h | 12 ++++++++++++
 net/wireless/nl80211.c       | 12 ++++++++++++
 3 files changed, 33 insertions(+), 1 deletion(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 4db4f47c9745..6e4ee9ceb482 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -964,6 +964,10 @@ struct sta_bss_parameters {
  * @txrate: current unicast bitrate from this station
  * @rxrate: current unicast bitrate to this station
  * @rx_packets: packets (MSDUs & MMPDUs) received from this station
+ * @rx_qos_msdu: QoS-MSDUs received from this station (per TID)
+ * @rx_nonqos_msdu: non-QoS-MSDUs received from this station
+ * @tx_qos_msdu: QoS-MSDUs sent to this station (per TID)
+ * @tx_nonqos_msdu: non-QoS-MSDUs sent to this station
  * @tx_packets: packets (MSDUs & MMPDUs) transmitted to this station
  * @tx_retries: cumulative retry counts (MPDUs)
  * @tx_failed: number of failed transmissions (MPDUs) (retries exceeded, no ACK)
@@ -991,7 +995,7 @@ struct sta_bss_parameters {
  *	from this peer
  */
 struct station_info {
-	u32 filled;
+	u64 filled;
 	u32 connected_time;
 	u32 inactive_time;
 	u64 rx_bytes;
@@ -1013,6 +1017,10 @@ struct station_info {
 	u32 tx_retries;
 	u32 tx_failed;
 	u32 rx_dropped_misc;
+	u64 rx_qos_msdu[IEEE80211_NUM_TIDS];
+	u64 rx_nonqos_msdu;
+	u64 tx_qos_msdu[IEEE80211_NUM_TIDS];
+	u64 tx_nonqos_msdu;
 	struct sta_bss_parameters bss_param;
 	struct nl80211_sta_flag_update sta_flags;
 
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 945a17e019b2..21a0cc79b221 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -2342,6 +2342,14 @@ enum nl80211_sta_bss_param {
  * @NL80211_STA_INFO_BEACON_RX: number of beacons received from this peer (u64)
  * @NL80211_STA_INFO_BEACON_SIGNAL_AVG: signal strength average
  *	for beacons only (u8, dBm)
+ * @NL80211_STA_INFO_RX_QOS_MSDU: number of QoS-MSDUs received from this
+ *	station, per TID (array of 16 u64 values)
+ * @NL80211_STA_INFO_RX_NONQOS_MSDU: number of non-QoS-MSDUs received from this
+ *	station (u64)
+ * @NL80211_STA_INFO_TX_QOS_MSDU: number of QoS-MSDUs sent to this station,
+ *	per TID (array of 16 u64 values)
+ * @NL80211_STA_INFO_TX_NONQOS_MSDU: number of non-QoS-MSDUs sent to this
+ *	station (u64)
  * @__NL80211_STA_INFO_AFTER_LAST: internal
  * @NL80211_STA_INFO_MAX: highest possible station info attribute
  */
@@ -2377,6 +2385,10 @@ enum nl80211_sta_info {
 	NL80211_STA_INFO_RX_DROP_MISC,
 	NL80211_STA_INFO_BEACON_RX,
 	NL80211_STA_INFO_BEACON_SIGNAL_AVG,
+	NL80211_STA_INFO_RX_QOS_MSDU,
+	NL80211_STA_INFO_RX_NONQOS_MSDU,
+	NL80211_STA_INFO_TX_QOS_MSDU,
+	NL80211_STA_INFO_TX_NONQOS_MSDU,
 
 	/* keep last */
 	__NL80211_STA_INFO_AFTER_LAST,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 0e3ffaf2ce94..4891c5240acd 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -3660,6 +3660,14 @@ static int nl80211_send_station(struct sk_buff *msg, u32 cmd, u32 portid,
 		goto nla_put_failure;					\
 	} while (0)
 
+#define PUT_SINFO_TIDS(attr, memb) do {					\
+	BUILD_BUG_ON(sizeof(sinfo->memb) != sizeof(u64) * IEEE80211_NUM_TIDS);\
+	if (sinfo->filled & BIT(NL80211_STA_INFO_ ## attr) &&		\
+	    nla_put(msg, NL80211_STA_INFO_ ## attr,			\
+		    sizeof(sinfo->memb), sinfo->memb))			\
+		goto nla_put_failure;					\
+	} while (0)
+
 	PUT_SINFO(CONNECTED_TIME, connected_time, u32);
 	PUT_SINFO(INACTIVE_TIME, inactive_time, u32);
 
@@ -3751,6 +3759,10 @@ static int nl80211_send_station(struct sk_buff *msg, u32 cmd, u32 portid,
 	PUT_SINFO(RX_DROP_MISC, rx_dropped_misc, u64);
 	PUT_SINFO(BEACON_RX, rx_beacon, u64);
 	PUT_SINFO(BEACON_SIGNAL_AVG, rx_beacon_signal_avg, u8);
+	PUT_SINFO_TIDS(RX_QOS_MSDU, rx_qos_msdu);
+	PUT_SINFO(RX_NONQOS_MSDU, rx_nonqos_msdu, u64);
+	PUT_SINFO_TIDS(TX_QOS_MSDU, tx_qos_msdu);
+	PUT_SINFO(TX_NONQOS_MSDU, tx_nonqos_msdu, u64);
 
 #undef PUT_SINFO
 	nla_nest_end(msg, sinfoattr);
-- 
2.1.1

