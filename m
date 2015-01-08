Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:41362 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756088AbbAHO3q (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Jan 2015 09:29:46 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 1/2] nl80211: support per-TID station statistics
Date: Thu,  8 Jan 2015 15:29:36 +0100
Message-Id: <1420727377-11170-1-git-send-email-johannes@sipsolutions.net> (sfid-20150108_152950_128952_60246320)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The base for the current statistics is pretty mixed up, support
exporting RX/TX statistics for MSDUs per TID. This (currently)
covers received MSDUs, transmitted MSDUs and retries/failures
thereof.

Doing it per TID for MSDUs makes more sense than say only per AC
because it's symmetric - we could export per-AC statistics for all
frames (which AC we used for transmission can be determined also
for management frames) but per TID is better and usually data
frames are really the ones we care about. Also, on RX we can't
determine the AC - but we do know the TID for any QoS MPDU we
received.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/cfg80211.h       | 21 +++++++++++++++++++++
 include/uapi/linux/nl80211.h | 31 +++++++++++++++++++++++++++++++
 net/wireless/nl80211.c       | 41 +++++++++++++++++++++++++++++++++++++++++
 3 files changed, 93 insertions(+)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 95420fb61600..197735788f18 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -939,6 +939,24 @@ struct sta_bss_parameters {
 	u16 beacon_interval;
 };
 
+/**
+ * struct cfg80211_tid_stats - per-TID statistics
+ * @filled: bitmap of flags using the bits of &enum nl80211_tid_stats to
+ *	indicate the relevant values in this struct are filled
+ * @rx_msdu: number of received MSDUs
+ * @tx_msdu: number of (attempted) transmitted MSDUs
+ * @tx_msdu_retries: number of retries (not counting the first) for
+ *	transmitted MSDUs
+ * @tx_msdu_failed: number of failed transmitted MSDUs
+ */
+struct cfg80211_tid_stats {
+	u32 filled;
+	u64 rx_msdu;
+	u64 tx_msdu;
+	u64 tx_msdu_retries;
+	u64 tx_msdu_failed;
+};
+
 #define IEEE80211_MAX_CHAINS	4
 
 /**
@@ -990,6 +1008,8 @@ struct sta_bss_parameters {
  * @rx_beacon: number of beacons received from this peer
  * @rx_beacon_signal_avg: signal strength average (in dBm) for beacons received
  *	from this peer
+ * @pertid: per-TID statistics, see &struct cfg80211_tid_stats, using the last
+ *	(IEEE80211_NUM_TIDS) index for MSDUs not encapsulated in QoS-MPDUs.
  */
 struct station_info {
 	u32 filled;
@@ -1032,6 +1052,7 @@ struct station_info {
 
 	u64 rx_beacon;
 	u8 rx_beacon_signal_avg;
+	struct cfg80211_tid_stats pertid[IEEE80211_NUM_TIDS + 1];
 };
 
 /**
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index b0fb5d598250..a963d4824c51 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -2384,6 +2384,11 @@ enum nl80211_sta_bss_param {
  * @NL80211_STA_INFO_BEACON_RX: number of beacons received from this peer (u64)
  * @NL80211_STA_INFO_BEACON_SIGNAL_AVG: signal strength average
  *	for beacons only (u8, dBm)
+ * @NL80211_STA_INFO_TID_STATS: per-TID statistics (see &enum nl80211_tid_stats)
+ *	This is a nested attribute where each the inner attribute number is the
+ *	TID+1 and the special TID 16 (i.e. value 17) is used for non-QoS frames;
+ *	each one of those is again nested with &enum nl80211_tid_stats
+ *	attributes carrying the actual values.
  * @__NL80211_STA_INFO_AFTER_LAST: internal
  * @NL80211_STA_INFO_MAX: highest possible station info attribute
  */
@@ -2419,6 +2424,7 @@ enum nl80211_sta_info {
 	NL80211_STA_INFO_RX_DROP_MISC,
 	NL80211_STA_INFO_BEACON_RX,
 	NL80211_STA_INFO_BEACON_SIGNAL_AVG,
+	NL80211_STA_INFO_TID_STATS,
 
 	/* keep last */
 	__NL80211_STA_INFO_AFTER_LAST,
@@ -2426,6 +2432,31 @@ enum nl80211_sta_info {
 };
 
 /**
+ * enum nl80211_tid_stats - per TID statistics attributes
+ * @__NL80211_TID_STATS_INVALID: attribute number 0 is reserved
+ * @NL80211_TID_STATS_RX_MSDU: number of MSDUs received (u64)
+ * @NL80211_TID_STATS_TX_MSDU: number of MSDUs transmitted (or
+ *	attempted to transmit; u64)
+ * @NL80211_TID_STATS_TX_MSDU_RETRIES: number of retries for
+ *	transmitted MSDUs (not counting the first attempt; u64)
+ * @NL80211_TID_STATS_TX_MSDU_FAILED: number of failed transmitted
+ *	MSDUs (u64)
+ * @NUM_NL80211_TID_STATS: number of attributes here
+ * @NL80211_TID_STATS_MAX: highest numbered attribute here
+ */
+enum nl80211_tid_stats {
+	__NL80211_TID_STATS_INVALID,
+	NL80211_TID_STATS_RX_MSDU,
+	NL80211_TID_STATS_TX_MSDU,
+	NL80211_TID_STATS_TX_MSDU_RETRIES,
+	NL80211_TID_STATS_TX_MSDU_FAILED,
+
+	/* keep last */
+	NUM_NL80211_TID_STATS,
+	NL80211_TID_STATS_MAX = NUM_NL80211_TID_STATS - 1
+};
+
+/**
  * enum nl80211_mpath_flags - nl80211 mesh path flags
  *
  * @NL80211_MPATH_FLAG_ACTIVE: the mesh path is active
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 42b968a1f994..7c2ce26e22de 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -3772,6 +3772,47 @@ static int nl80211_send_station(struct sk_buff *msg, u32 cmd, u32 portid,
 	PUT_SINFO(BEACON_SIGNAL_AVG, rx_beacon_signal_avg, u8);
 
 #undef PUT_SINFO
+
+	if (sinfo->filled & BIT(NL80211_STA_INFO_TID_STATS)) {
+		struct nlattr *tidsattr;
+		int tid;
+
+		tidsattr = nla_nest_start(msg, NL80211_STA_INFO_TID_STATS);
+		if (!tidsattr)
+			goto nla_put_failure;
+
+		for (tid = 0; tid < IEEE80211_NUM_TIDS + 1; tid++) {
+			struct cfg80211_tid_stats *tidstats;
+			struct nlattr *tidattr;
+
+			tidstats = &sinfo->pertid[tid];
+
+			if (!tidstats->filled)
+				continue;
+
+			tidattr = nla_nest_start(msg, tid + 1);
+			if (!tidattr)
+				goto nla_put_failure;
+
+#define PUT_TIDVAL(attr, memb, type) do {				\
+	if (tidstats->filled & BIT(NL80211_TID_STATS_ ## attr) &&	\
+	    nla_put_ ## type(msg, NL80211_TID_STATS_ ## attr,		\
+			     tidstats->memb))				\
+		goto nla_put_failure;					\
+	} while (0)
+
+			PUT_TIDVAL(RX_MSDU, rx_msdu, u64);
+			PUT_TIDVAL(TX_MSDU, tx_msdu, u64);
+			PUT_TIDVAL(TX_MSDU_RETRIES, tx_msdu_retries, u64);
+			PUT_TIDVAL(TX_MSDU_FAILED, tx_msdu_failed, u64);
+
+#undef PUT_TIDVAL
+			nla_nest_end(msg, tidattr);
+		}
+
+		nla_nest_end(msg, tidsattr);
+	}
+
 	nla_nest_end(msg, sinfoattr);
 
 	if (sinfo->assoc_req_ies_len &&
-- 
2.1.1

