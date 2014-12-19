Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:46991 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751801AbaLSP6J (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Dec 2014 10:58:09 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: nbd@openwrt.org, j@w1.fi, Johannes Berg <johannes.berg@intel.com>
Subject: [RFC 1/3] nl80211: support per-TID station statistics
Date: Fri, 19 Dec 2014 16:58:01 +0100
Message-Id: <1419004683-25369-1-git-send-email-johannes@sipsolutions.net> (sfid-20141219_165814_500210_8072218A)
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

Change-Id: I22d8a889ef73c603a968bed15afa66710aef61e7
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/cfg80211.h       | 21 +++++++++++++++++++++
 include/uapi/linux/nl80211.h | 29 +++++++++++++++++++++++++++++
 net/wireless/nl80211.c       | 41 +++++++++++++++++++++++++++++++++++++++++
 3 files changed, 91 insertions(+)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index e62ac77da365..43cc58652185 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -938,6 +938,24 @@ struct sta_bss_parameters {
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
@@ -989,6 +1007,8 @@ struct sta_bss_parameters {
  * @rx_beacon: number of beacons received from this peer
  * @rx_beacon_signal_avg: signal strength average (in dBm) for beacons received
  *	from this peer
+ * @pertid: per-TID statistics, see &struct cfg80211_tid_stats, using the last
+ *	(IEEE80211_NUM_TIDS) index for MSDUs not encapsulated in QoS-MPDUs.
  */
 struct station_info {
 	u32 filled;
@@ -1031,6 +1051,7 @@ struct station_info {
 
 	u64 rx_beacon;
 	u8 rx_beacon_signal_avg;
+	struct cfg80211_tid_stats pertid[IEEE80211_NUM_TIDS + 1];
 };
 
 /**
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index e25af350962d..ef99b90e9241 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -2367,6 +2367,11 @@ enum nl80211_sta_bss_param {
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
@@ -2402,6 +2407,7 @@ enum nl80211_sta_info {
 	NL80211_STA_INFO_RX_DROP_MISC,
 	NL80211_STA_INFO_BEACON_RX,
 	NL80211_STA_INFO_BEACON_SIGNAL_AVG,
+	NL80211_STA_INFO_TID_STATS,
 
 	/* keep last */
 	__NL80211_STA_INFO_AFTER_LAST,
@@ -2409,6 +2415,29 @@ enum nl80211_sta_info {
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
index 80ba3e6f4c15..379dfc0ae384 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -3801,6 +3801,47 @@ static int nl80211_send_station(struct sk_buff *msg, u32 cmd, u32 portid,
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

