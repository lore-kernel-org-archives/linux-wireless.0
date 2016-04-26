Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:42933 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752194AbcDZHyP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Apr 2016 03:54:15 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Nicolas Dichtel <nicolas.dichtel@6wind.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] nl80211: use nla_put_u64_64bit() for the remaining u64 attributes
Date: Tue, 26 Apr 2016 09:54:11 +0200
Message-Id: <1461657251-12528-1-git-send-email-johannes@sipsolutions.net> (sfid-20160426_095418_739977_BC8D0DBD)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Nicolas converted most users, but didn't realize some were generated
by macros. Convert those over as well.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/uapi/linux/nl80211.h |  4 ++++
 net/wireless/nl80211.c       | 36 ++++++++++++++++++++++--------------
 2 files changed, 26 insertions(+), 14 deletions(-)

diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index f958a7173eb4..e23d78685a01 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -2517,6 +2517,7 @@ enum nl80211_sta_bss_param {
  *	attributes carrying the actual values.
  * @NL80211_STA_INFO_RX_DURATION: aggregate PPDU duration for all frames
  *	received from the station (u64, usec)
+ * @NL80211_STA_INFO_PAD: attribute used for padding for 64-bit alignment
  * @__NL80211_STA_INFO_AFTER_LAST: internal
  * @NL80211_STA_INFO_MAX: highest possible station info attribute
  */
@@ -2554,6 +2555,7 @@ enum nl80211_sta_info {
 	NL80211_STA_INFO_BEACON_SIGNAL_AVG,
 	NL80211_STA_INFO_TID_STATS,
 	NL80211_STA_INFO_RX_DURATION,
+	NL80211_STA_INFO_PAD,
 
 	/* keep last */
 	__NL80211_STA_INFO_AFTER_LAST,
@@ -2570,6 +2572,7 @@ enum nl80211_sta_info {
  *	transmitted MSDUs (not counting the first attempt; u64)
  * @NL80211_TID_STATS_TX_MSDU_FAILED: number of failed transmitted
  *	MSDUs (u64)
+ * @NL80211_TID_STATS_PAD: attribute used for padding for 64-bit alignment
  * @NUM_NL80211_TID_STATS: number of attributes here
  * @NL80211_TID_STATS_MAX: highest numbered attribute here
  */
@@ -2579,6 +2582,7 @@ enum nl80211_tid_stats {
 	NL80211_TID_STATS_TX_MSDU,
 	NL80211_TID_STATS_TX_MSDU_RETRIES,
 	NL80211_TID_STATS_TX_MSDU_FAILED,
+	NL80211_TID_STATS_PAD,
 
 	/* keep last */
 	NUM_NL80211_TID_STATS,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 5b0d2c8c2165..9bc84a2ddd34 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -3755,11 +3755,18 @@ static int nl80211_send_station(struct sk_buff *msg, u32 cmd, u32 portid,
 		goto nla_put_failure;
 
 #define PUT_SINFO(attr, memb, type) do {				\
+	BUILD_BUG_ON(sizeof(type) == sizeof(u64));			\
 	if (sinfo->filled & (1ULL << NL80211_STA_INFO_ ## attr) &&	\
 	    nla_put_ ## type(msg, NL80211_STA_INFO_ ## attr,		\
 			     sinfo->memb))				\
 		goto nla_put_failure;					\
 	} while (0)
+#define PUT_SINFO_U64(attr, memb) do {					\
+	if (sinfo->filled & (1ULL << NL80211_STA_INFO_ ## attr) &&	\
+	    nla_put_u64_64bit(msg, NL80211_STA_INFO_ ## attr,		\
+			      sinfo->memb, NL80211_STA_INFO_PAD))	\
+		goto nla_put_failure;					\
+	} while (0)
 
 	PUT_SINFO(CONNECTED_TIME, connected_time, u32);
 	PUT_SINFO(INACTIVE_TIME, inactive_time, u32);
@@ -3776,12 +3783,12 @@ static int nl80211_send_station(struct sk_buff *msg, u32 cmd, u32 portid,
 			(u32)sinfo->tx_bytes))
 		goto nla_put_failure;
 
-	PUT_SINFO(RX_BYTES64, rx_bytes, u64);
-	PUT_SINFO(TX_BYTES64, tx_bytes, u64);
+	PUT_SINFO_U64(RX_BYTES64, rx_bytes);
+	PUT_SINFO_U64(TX_BYTES64, tx_bytes);
 	PUT_SINFO(LLID, llid, u16);
 	PUT_SINFO(PLID, plid, u16);
 	PUT_SINFO(PLINK_STATE, plink_state, u8);
-	PUT_SINFO(RX_DURATION, rx_duration, u64);
+	PUT_SINFO_U64(RX_DURATION, rx_duration);
 
 	switch (rdev->wiphy.signal_type) {
 	case CFG80211_SIGNAL_TYPE_MBM:
@@ -3849,12 +3856,13 @@ static int nl80211_send_station(struct sk_buff *msg, u32 cmd, u32 portid,
 		    &sinfo->sta_flags))
 		goto nla_put_failure;
 
-	PUT_SINFO(T_OFFSET, t_offset, u64);
-	PUT_SINFO(RX_DROP_MISC, rx_dropped_misc, u64);
-	PUT_SINFO(BEACON_RX, rx_beacon, u64);
+	PUT_SINFO_U64(T_OFFSET, t_offset);
+	PUT_SINFO_U64(RX_DROP_MISC, rx_dropped_misc);
+	PUT_SINFO_U64(BEACON_RX, rx_beacon);
 	PUT_SINFO(BEACON_SIGNAL_AVG, rx_beacon_signal_avg, u8);
 
 #undef PUT_SINFO
+#undef PUT_SINFO_U64
 
 	if (sinfo->filled & BIT(NL80211_STA_INFO_TID_STATS)) {
 		struct nlattr *tidsattr;
@@ -3877,19 +3885,19 @@ static int nl80211_send_station(struct sk_buff *msg, u32 cmd, u32 portid,
 			if (!tidattr)
 				goto nla_put_failure;
 
-#define PUT_TIDVAL(attr, memb, type) do {				\
+#define PUT_TIDVAL_U64(attr, memb) do {					\
 	if (tidstats->filled & BIT(NL80211_TID_STATS_ ## attr) &&	\
-	    nla_put_ ## type(msg, NL80211_TID_STATS_ ## attr,		\
-			     tidstats->memb))				\
+	    nla_put_u64_64bit(msg, NL80211_TID_STATS_ ## attr,		\
+			      tidstats->memb, NL80211_TID_STATS_PAD))	\
 		goto nla_put_failure;					\
 	} while (0)
 
-			PUT_TIDVAL(RX_MSDU, rx_msdu, u64);
-			PUT_TIDVAL(TX_MSDU, tx_msdu, u64);
-			PUT_TIDVAL(TX_MSDU_RETRIES, tx_msdu_retries, u64);
-			PUT_TIDVAL(TX_MSDU_FAILED, tx_msdu_failed, u64);
+			PUT_TIDVAL_U64(RX_MSDU, rx_msdu);
+			PUT_TIDVAL_U64(TX_MSDU, tx_msdu);
+			PUT_TIDVAL_U64(TX_MSDU_RETRIES, tx_msdu_retries);
+			PUT_TIDVAL_U64(TX_MSDU_FAILED, tx_msdu_failed);
 
-#undef PUT_TIDVAL
+#undef PUT_TIDVAL_U64
 			nla_nest_end(msg, tidattr);
 		}
 
-- 
2.8.0.rc3

