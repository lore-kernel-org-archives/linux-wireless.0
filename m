Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:21694 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751089AbcDGOaA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Apr 2016 10:30:00 -0400
From: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>,
	Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
Subject: [PATCH v4] cfg80211/nl80211: Add support for NL80211_STA_INFO_RX_DURATION
Date: Thu, 7 Apr 2016 19:59:34 +0530
Message-ID: <1460039374-5338-1-git-send-email-mohammed@qti.qualcomm.com> (sfid-20160407_163005_780421_67EFA4E2)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>

Add support for new netlink attribute 'NL80211_STA_INFO_RX_DURATION'.
'NL80211_STA_INFO_RX_DURATION' accounts for aggregate PPDU duration
in microseconds for all the frames from a peer. Drivers can fill
'rx_duration' field and set the flag 'NL80211_STA_INFO_RX_DURATION'.
'rx_duration' will give an idea about the total time spent by our peer
with each of its connected peers.

Also extend 'PUT_SINFO' for supporting rx_duration field

Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
---
 include/net/cfg80211.h       |    4 +++-
 include/uapi/linux/nl80211.h |    3 +++
 net/wireless/nl80211.c       |    3 ++-
 3 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 0bbfbf3..e0fe16e 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1063,11 +1063,12 @@ struct cfg80211_tid_stats {
  * @rx_beacon: number of beacons received from this peer
  * @rx_beacon_signal_avg: signal strength average (in dBm) for beacons received
  *	from this peer
+ * @rx_duration: aggregate PPDU duration(usecs) for all the frames from a peer
  * @pertid: per-TID statistics, see &struct cfg80211_tid_stats, using the last
  *	(IEEE80211_NUM_TIDS) index for MSDUs not encapsulated in QoS-MPDUs.
  */
 struct station_info {
-	u32 filled;
+	u64 filled;
 	u32 connected_time;
 	u32 inactive_time;
 	u64 rx_bytes;
@@ -1106,6 +1107,7 @@ struct station_info {
 	u32 expected_throughput;
 
 	u64 rx_beacon;
+	u64 rx_duration;
 	u8 rx_beacon_signal_avg;
 	struct cfg80211_tid_stats pertid[IEEE80211_NUM_TIDS + 1];
 };
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index b2a8d8c..e11559f 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -2482,6 +2482,8 @@ enum nl80211_sta_bss_param {
  *	TID+1 and the special TID 16 (i.e. value 17) is used for non-QoS frames;
  *	each one of those is again nested with &enum nl80211_tid_stats
  *	attributes carrying the actual values.
+ * @NL80211_STA_INFO_RX_DURATION: aggregate PPDU duration(usecs) for all the
+ *	frames from a peer
  * @__NL80211_STA_INFO_AFTER_LAST: internal
  * @NL80211_STA_INFO_MAX: highest possible station info attribute
  */
@@ -2518,6 +2520,7 @@ enum nl80211_sta_info {
 	NL80211_STA_INFO_BEACON_RX,
 	NL80211_STA_INFO_BEACON_SIGNAL_AVG,
 	NL80211_STA_INFO_TID_STATS,
+	NL80211_STA_INFO_RX_DURATION,
 
 	/* keep last */
 	__NL80211_STA_INFO_AFTER_LAST,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index d6c6449..3969d10 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -3753,7 +3753,7 @@ static int nl80211_send_station(struct sk_buff *msg, u32 cmd, u32 portid,
 		goto nla_put_failure;
 
 #define PUT_SINFO(attr, memb, type) do {				\
-	if (sinfo->filled & BIT(NL80211_STA_INFO_ ## attr) &&		\
+	if (sinfo->filled & (1ULL << NL80211_STA_INFO_ ## attr) &&	\
 	    nla_put_ ## type(msg, NL80211_STA_INFO_ ## attr,		\
 			     sinfo->memb))				\
 		goto nla_put_failure;					\
@@ -3779,6 +3779,7 @@ static int nl80211_send_station(struct sk_buff *msg, u32 cmd, u32 portid,
 	PUT_SINFO(LLID, llid, u16);
 	PUT_SINFO(PLID, plid, u16);
 	PUT_SINFO(PLINK_STATE, plink_state, u8);
+	PUT_SINFO(RX_DURATION, rx_duration, u64);
 
 	switch (rdev->wiphy.signal_type) {
 	case CFG80211_SIGNAL_TYPE_MBM:
-- 
1.7.9.5

