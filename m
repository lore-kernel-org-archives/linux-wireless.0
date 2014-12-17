Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:36820 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751087AbaLQN6G (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Dec 2014 08:58:06 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 3/9] cfg80211: add scan time to survey data
Date: Wed, 17 Dec 2014 14:57:53 +0100
Message-Id: <1418824679-31530-4-git-send-email-johannes@sipsolutions.net> (sfid-20141217_145811_087923_090F8E71)
In-Reply-To: <1418824679-31530-1-git-send-email-johannes@sipsolutions.net>
References: <1418824679-31530-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Add the time spent scanning to the survey data so it can be
reported by drivers that collect such information.

Change-Id: Ice25ac9ddd5fb3d7dba76f20dd6eec36597e1de9
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/cfg80211.h       | 3 +++
 include/uapi/linux/nl80211.h | 3 +++
 net/wireless/nl80211.c       | 4 ++++
 net/wireless/trace.h         | 7 +++++--
 4 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 3db6a9990ebd..3fe4a20d1b60 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -525,6 +525,7 @@ ieee80211_chandef_max_power(struct cfg80211_chan_def *chandef)
  * @SURVEY_INFO_TIME_EXT_BUSY: extension channel busy time was filled in
  * @SURVEY_INFO_TIME_RX: receive time was filled in
  * @SURVEY_INFO_TIME_TX: transmit time was filled in
+ * @SURVEY_INFO_TIME_SCAN: scan time was filled in
  *
  * Used by the driver to indicate which info in &struct survey_info
  * it has filled in during the get_survey().
@@ -537,6 +538,7 @@ enum survey_info_flags {
 	SURVEY_INFO_TIME_EXT_BUSY	= BIT(4),
 	SURVEY_INFO_TIME_RX		= BIT(5),
 	SURVEY_INFO_TIME_TX		= BIT(6),
+	SURVEY_INFO_TIME_SCAN		= BIT(7),
 };
 
 /**
@@ -565,6 +567,7 @@ struct survey_info {
 	u64 time_ext_busy;
 	u64 time_rx;
 	u64 time_tx;
+	u64 time_scan;
 	u32 filled;
 	s8 noise;
 };
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 35242ad7be0b..1ddd067d19ed 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -2816,6 +2816,8 @@ enum nl80211_user_reg_hint_type {
  *	receiving data (on channel or globally)
  * @NL80211_SURVEY_INFO_TIME_TX: amount of time the radio spent
  *	transmitting data (on channel or globally)
+ * @NL80211_SURVEY_INFO_TIME_SCAN: time the radio spent for scan
+ *	(on this channel or globally)
  * @NL80211_SURVEY_INFO_MAX: highest survey info attribute number
  *	currently defined
  * @__NL80211_SURVEY_INFO_AFTER_LAST: internal use
@@ -2830,6 +2832,7 @@ enum nl80211_survey_info {
 	NL80211_SURVEY_INFO_TIME_EXT_BUSY,
 	NL80211_SURVEY_INFO_TIME_RX,
 	NL80211_SURVEY_INFO_TIME_TX,
+	NL80211_SURVEY_INFO_TIME_SCAN,
 
 	/* keep last */
 	__NL80211_SURVEY_INFO_AFTER_LAST,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 22085e0cd70a..0e2b997b44a7 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -6656,6 +6656,10 @@ static int nl80211_send_survey(struct sk_buff *msg, u32 portid, u32 seq,
 	    nla_put_u64(msg, NL80211_SURVEY_INFO_TIME_TX,
 			survey->time_tx))
 		goto nla_put_failure;
+	if ((survey->filled & SURVEY_INFO_TIME_SCAN) &&
+	    nla_put_u64(msg, NL80211_SURVEY_INFO_TIME_SCAN,
+			survey->time_scan))
+		goto nla_put_failure;
 
 	nla_nest_end(msg, infoattr);
 
diff --git a/net/wireless/trace.h b/net/wireless/trace.h
index bbb7afc264af..b17b3692f8c2 100644
--- a/net/wireless/trace.h
+++ b/net/wireless/trace.h
@@ -1609,6 +1609,7 @@ TRACE_EVENT(rdev_return_int_survey_info,
 		__field(u64, time_ext_busy)
 		__field(u64, time_rx)
 		__field(u64, time_tx)
+		__field(u64, time_scan)
 		__field(u32, filled)
 		__field(s8, noise)
 	),
@@ -1621,17 +1622,19 @@ TRACE_EVENT(rdev_return_int_survey_info,
 		__entry->time_ext_busy = info->time_ext_busy;
 		__entry->time_rx = info->time_rx;
 		__entry->time_tx = info->time_tx;
+		__entry->time_scan = info->time_scan;
 		__entry->filled = info->filled;
 		__entry->noise = info->noise;
 	),
 	TP_printk(WIPHY_PR_FMT ", returned: %d, " CHAN_PR_FMT
 		  ", channel time: %llu, channel time busy: %llu, "
 		  "channel time extension busy: %llu, channel time rx: %llu, "
-		  "channel time tx: %llu, filled: %u, noise: %d",
+		  "channel time tx: %llu, scan time: %llu, filled: %u, noise: %d",
 		  WIPHY_PR_ARG, __entry->ret, CHAN_PR_ARG,
 		  __entry->time, __entry->time_busy,
 		  __entry->time_ext_busy, __entry->time_rx,
-		  __entry->time_tx, __entry->filled, __entry->noise)
+		  __entry->time_tx, __entry->time_scan,
+		  __entry->filled, __entry->noise)
 );
 
 TRACE_EVENT(rdev_tdls_oper,
-- 
2.1.1

