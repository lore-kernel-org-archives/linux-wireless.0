Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:42069 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751116AbaLRQL3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Dec 2014 11:11:29 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 1/2] nl80211: support MSDU statistics
Date: Thu, 18 Dec 2014 17:11:22 +0100
Message-Id: <1418919083-28297-1-git-send-email-johannes@sipsolutions.net> (sfid-20141218_171132_119479_078E1815)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The base for the current statistics is pretty mixed up, support
exporting RX/TX statistics for MSDUs per TID.

This makes sense because it's symmetric - we could export per-AC
statistics for all frames (which AC we used for transmission can
be determined also for management frames) but per TID is better
and usually data frames are really the ones we care about. Also,
on RX we can't determine the AC - but we do know the TID for any
QoS MSDU we received.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/cfg80211.h       | 10 +++++++++-
 include/uapi/linux/nl80211.h | 12 ++++++++++++
 net/wireless/nl80211.c       | 14 +++++++++++++-
 3 files changed, 34 insertions(+), 2 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 729f9e0bcf38..d1d0894ff302 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -965,6 +965,10 @@ struct sta_bss_parameters {
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
@@ -992,7 +996,7 @@ struct sta_bss_parameters {
  *	from this peer
  */
 struct station_info {
-	u32 filled;
+	u64 filled;
 	u32 connected_time;
 	u32 inactive_time;
 	u64 rx_bytes;
@@ -1014,6 +1018,10 @@ struct station_info {
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
index 9e5797d00096..6cd33c02113a 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -2365,6 +2365,14 @@ enum nl80211_sta_bss_param {
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
@@ -2400,6 +2408,10 @@ enum nl80211_sta_info {
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
index d7e21a27aef3..f565d8073758 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -3668,12 +3668,20 @@ static int nl80211_send_station(struct sk_buff *msg, u32 cmd, u32 portid,
 		goto nla_put_failure;
 
 #define PUT_SINFO(attr, memb, type) do {				\
-	if (sinfo->filled & BIT(NL80211_STA_INFO_ ## attr) &&		\
+	if (sinfo->filled & BIT_ULL(NL80211_STA_INFO_ ## attr) &&	\
 	    nla_put_ ## type(msg, NL80211_STA_INFO_ ## attr,		\
 			     sinfo->memb))				\
 		goto nla_put_failure;					\
 	} while (0)
 
+#define PUT_SINFO_TIDS(attr, memb) do {					\
+	BUILD_BUG_ON(sizeof(sinfo->memb) != sizeof(u64) * IEEE80211_NUM_TIDS);\
+	if (sinfo->filled & BIT_ULL(NL80211_STA_INFO_ ## attr) &&	\
+	    nla_put(msg, NL80211_STA_INFO_ ## attr,			\
+		    sizeof(sinfo->memb), sinfo->memb))			\
+		goto nla_put_failure;					\
+	} while (0)
+
 	PUT_SINFO(CONNECTED_TIME, connected_time, u32);
 	PUT_SINFO(INACTIVE_TIME, inactive_time, u32);
 
@@ -3765,6 +3773,10 @@ static int nl80211_send_station(struct sk_buff *msg, u32 cmd, u32 portid,
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

