Return-Path: <SRS0=txZa=MN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0370EC43143
	for <linux-wireless@archiver.kernel.org>; Mon,  1 Oct 2018 13:29:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BC7F72084C
	for <linux-wireless@archiver.kernel.org>; Mon,  1 Oct 2018 13:29:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BC7F72084C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729286AbeJAUHY (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 1 Oct 2018 16:07:24 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:58996 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728979AbeJAUHX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 1 Oct 2018 16:07:23 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.91)
        (envelope-from <johannes@sipsolutions.net>)
        id 1g6yGQ-0005gt-Sm; Mon, 01 Oct 2018 15:29:30 +0200
From:   Johannes Berg <johannes@sipsolutions.net>
To:     linux-wireless@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] cfg80211: sort tracing properly
Date:   Mon,  1 Oct 2018 15:29:18 +0200
Message-Id: <20181001132918.23214-1-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.14.4
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

There were supposed to be two blocks - one for each direction
cfg80211 <-> driver, clean up the code to restore that.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/trace.h | 268 +++++++++++++++++++++++++--------------------------
 1 file changed, 134 insertions(+), 134 deletions(-)

diff --git a/net/wireless/trace.h b/net/wireless/trace.h
index 7e0380192445..c6a9446b4e6b 100644
--- a/net/wireless/trace.h
+++ b/net/wireless/trace.h
@@ -2368,6 +2368,140 @@ TRACE_EVENT(rdev_external_auth,
 		      __entry->bssid, __entry->ssid, __entry->status)
 );
 
+TRACE_EVENT(rdev_start_radar_detection,
+	TP_PROTO(struct wiphy *wiphy, struct net_device *netdev,
+		 struct cfg80211_chan_def *chandef,
+		 u32 cac_time_ms),
+	TP_ARGS(wiphy, netdev, chandef, cac_time_ms),
+	TP_STRUCT__entry(
+		WIPHY_ENTRY
+		NETDEV_ENTRY
+		CHAN_DEF_ENTRY
+		__field(u32, cac_time_ms)
+	),
+	TP_fast_assign(
+		WIPHY_ASSIGN;
+		NETDEV_ASSIGN;
+		CHAN_DEF_ASSIGN(chandef);
+		__entry->cac_time_ms = cac_time_ms;
+	),
+	TP_printk(WIPHY_PR_FMT ", " NETDEV_PR_FMT ", " CHAN_DEF_PR_FMT
+		  ", cac_time_ms=%u",
+		  WIPHY_PR_ARG, NETDEV_PR_ARG, CHAN_DEF_PR_ARG,
+		  __entry->cac_time_ms)
+);
+
+TRACE_EVENT(rdev_set_mcast_rate,
+	TP_PROTO(struct wiphy *wiphy, struct net_device *netdev,
+		 int *mcast_rate),
+	TP_ARGS(wiphy, netdev, mcast_rate),
+	TP_STRUCT__entry(
+		WIPHY_ENTRY
+		NETDEV_ENTRY
+		__array(int, mcast_rate, NUM_NL80211_BANDS)
+	),
+	TP_fast_assign(
+		WIPHY_ASSIGN;
+		NETDEV_ASSIGN;
+		memcpy(__entry->mcast_rate, mcast_rate,
+		       sizeof(int) * NUM_NL80211_BANDS);
+	),
+	TP_printk(WIPHY_PR_FMT ", " NETDEV_PR_FMT ", "
+		  "mcast_rates [2.4GHz=0x%x, 5.2GHz=0x%x, 60GHz=0x%x]",
+		  WIPHY_PR_ARG, NETDEV_PR_ARG,
+		  __entry->mcast_rate[NL80211_BAND_2GHZ],
+		  __entry->mcast_rate[NL80211_BAND_5GHZ],
+		  __entry->mcast_rate[NL80211_BAND_60GHZ])
+);
+
+TRACE_EVENT(rdev_set_coalesce,
+	TP_PROTO(struct wiphy *wiphy, struct cfg80211_coalesce *coalesce),
+	TP_ARGS(wiphy, coalesce),
+	TP_STRUCT__entry(
+		WIPHY_ENTRY
+		__field(int, n_rules)
+	),
+	TP_fast_assign(
+		WIPHY_ASSIGN;
+		__entry->n_rules = coalesce ? coalesce->n_rules : 0;
+	),
+	TP_printk(WIPHY_PR_FMT ", n_rules=%d",
+		  WIPHY_PR_ARG, __entry->n_rules)
+);
+
+DEFINE_EVENT(wiphy_wdev_evt, rdev_abort_scan,
+	TP_PROTO(struct wiphy *wiphy, struct wireless_dev *wdev),
+	TP_ARGS(wiphy, wdev)
+);
+
+TRACE_EVENT(rdev_set_multicast_to_unicast,
+	TP_PROTO(struct wiphy *wiphy, struct net_device *netdev,
+		 const bool enabled),
+	TP_ARGS(wiphy, netdev, enabled),
+	TP_STRUCT__entry(
+		WIPHY_ENTRY
+		NETDEV_ENTRY
+		__field(bool, enabled)
+	),
+	TP_fast_assign(
+		WIPHY_ASSIGN;
+		NETDEV_ASSIGN;
+		__entry->enabled = enabled;
+	),
+	TP_printk(WIPHY_PR_FMT ", " NETDEV_PR_FMT ", unicast: %s",
+		  WIPHY_PR_ARG, NETDEV_PR_ARG,
+		  BOOL_TO_STR(__entry->enabled))
+);
+
+DEFINE_EVENT(wiphy_wdev_evt, rdev_get_txq_stats,
+	TP_PROTO(struct wiphy *wiphy, struct wireless_dev *wdev),
+	TP_ARGS(wiphy, wdev)
+);
+
+TRACE_EVENT(rdev_get_ftm_responder_stats,
+	TP_PROTO(struct wiphy *wiphy, struct net_device *netdev,
+		 struct cfg80211_ftm_responder_stats *ftm_stats),
+
+	TP_ARGS(wiphy, netdev, ftm_stats),
+
+	TP_STRUCT__entry(
+		WIPHY_ENTRY
+		NETDEV_ENTRY
+		__field(u64, timestamp)
+		__field(u32, success_num)
+		__field(u32, partial_num)
+		__field(u32, failed_num)
+		__field(u32, asap_num)
+		__field(u32, non_asap_num)
+		__field(u64, duration)
+		__field(u32, unknown_triggers)
+		__field(u32, reschedule)
+		__field(u32, out_of_window)
+	),
+
+	TP_fast_assign(
+		WIPHY_ASSIGN;
+		NETDEV_ASSIGN;
+		__entry->success_num = ftm_stats->success_num;
+		__entry->partial_num = ftm_stats->partial_num;
+		__entry->failed_num = ftm_stats->failed_num;
+		__entry->asap_num = ftm_stats->asap_num;
+		__entry->non_asap_num = ftm_stats->non_asap_num;
+		__entry->duration = ftm_stats->total_duration_ms;
+		__entry->unknown_triggers = ftm_stats->unknown_triggers_num;
+		__entry->reschedule = ftm_stats->reschedule_requests_num;
+		__entry->out_of_window = ftm_stats->out_of_window_triggers_num;
+	),
+
+	TP_printk(WIPHY_PR_FMT "Ftm responder stats: success %u, partial %u, "
+		"failed %u, asap %u, non asap %u, total duration %llu, unknown "
+		"triggers %u, rescheduled %u, out of window %u", WIPHY_PR_ARG,
+		__entry->success_num, __entry->partial_num, __entry->failed_num,
+		__entry->asap_num, __entry->non_asap_num, __entry->duration,
+		__entry->unknown_triggers, __entry->reschedule,
+		__entry->out_of_window)
+);
+
 /*************************************************************
  *	     cfg80211 exported functions traces		     *
  *************************************************************/
@@ -3160,140 +3294,6 @@ TRACE_EVENT(cfg80211_stop_iface,
 	TP_printk(WIPHY_PR_FMT ", " WDEV_PR_FMT,
 		  WIPHY_PR_ARG, WDEV_PR_ARG)
 );
-
-TRACE_EVENT(rdev_start_radar_detection,
-	TP_PROTO(struct wiphy *wiphy, struct net_device *netdev,
-		 struct cfg80211_chan_def *chandef,
-		 u32 cac_time_ms),
-	TP_ARGS(wiphy, netdev, chandef, cac_time_ms),
-	TP_STRUCT__entry(
-		WIPHY_ENTRY
-		NETDEV_ENTRY
-		CHAN_DEF_ENTRY
-		__field(u32, cac_time_ms)
-	),
-	TP_fast_assign(
-		WIPHY_ASSIGN;
-		NETDEV_ASSIGN;
-		CHAN_DEF_ASSIGN(chandef);
-		__entry->cac_time_ms = cac_time_ms;
-	),
-	TP_printk(WIPHY_PR_FMT ", " NETDEV_PR_FMT ", " CHAN_DEF_PR_FMT
-		  ", cac_time_ms=%u",
-		  WIPHY_PR_ARG, NETDEV_PR_ARG, CHAN_DEF_PR_ARG,
-		  __entry->cac_time_ms)
-);
-
-TRACE_EVENT(rdev_set_mcast_rate,
-	TP_PROTO(struct wiphy *wiphy, struct net_device *netdev,
-		 int *mcast_rate),
-	TP_ARGS(wiphy, netdev, mcast_rate),
-	TP_STRUCT__entry(
-		WIPHY_ENTRY
-		NETDEV_ENTRY
-		__array(int, mcast_rate, NUM_NL80211_BANDS)
-	),
-	TP_fast_assign(
-		WIPHY_ASSIGN;
-		NETDEV_ASSIGN;
-		memcpy(__entry->mcast_rate, mcast_rate,
-		       sizeof(int) * NUM_NL80211_BANDS);
-	),
-	TP_printk(WIPHY_PR_FMT ", " NETDEV_PR_FMT ", "
-		  "mcast_rates [2.4GHz=0x%x, 5.2GHz=0x%x, 60GHz=0x%x]",
-		  WIPHY_PR_ARG, NETDEV_PR_ARG,
-		  __entry->mcast_rate[NL80211_BAND_2GHZ],
-		  __entry->mcast_rate[NL80211_BAND_5GHZ],
-		  __entry->mcast_rate[NL80211_BAND_60GHZ])
-);
-
-TRACE_EVENT(rdev_set_coalesce,
-	TP_PROTO(struct wiphy *wiphy, struct cfg80211_coalesce *coalesce),
-	TP_ARGS(wiphy, coalesce),
-	TP_STRUCT__entry(
-		WIPHY_ENTRY
-		__field(int, n_rules)
-	),
-	TP_fast_assign(
-		WIPHY_ASSIGN;
-		__entry->n_rules = coalesce ? coalesce->n_rules : 0;
-	),
-	TP_printk(WIPHY_PR_FMT ", n_rules=%d",
-		  WIPHY_PR_ARG, __entry->n_rules)
-);
-
-DEFINE_EVENT(wiphy_wdev_evt, rdev_abort_scan,
-	TP_PROTO(struct wiphy *wiphy, struct wireless_dev *wdev),
-	TP_ARGS(wiphy, wdev)
-);
-
-TRACE_EVENT(rdev_set_multicast_to_unicast,
-	TP_PROTO(struct wiphy *wiphy, struct net_device *netdev,
-		 const bool enabled),
-	TP_ARGS(wiphy, netdev, enabled),
-	TP_STRUCT__entry(
-		WIPHY_ENTRY
-		NETDEV_ENTRY
-		__field(bool, enabled)
-	),
-	TP_fast_assign(
-		WIPHY_ASSIGN;
-		NETDEV_ASSIGN;
-		__entry->enabled = enabled;
-	),
-	TP_printk(WIPHY_PR_FMT ", " NETDEV_PR_FMT ", unicast: %s",
-		  WIPHY_PR_ARG, NETDEV_PR_ARG,
-		  BOOL_TO_STR(__entry->enabled))
-);
-
-DEFINE_EVENT(wiphy_wdev_evt, rdev_get_txq_stats,
-	TP_PROTO(struct wiphy *wiphy, struct wireless_dev *wdev),
-	TP_ARGS(wiphy, wdev)
-);
-
-TRACE_EVENT(rdev_get_ftm_responder_stats,
-	TP_PROTO(struct wiphy *wiphy, struct net_device *netdev,
-		 struct cfg80211_ftm_responder_stats *ftm_stats),
-
-	TP_ARGS(wiphy, netdev, ftm_stats),
-
-	TP_STRUCT__entry(
-		WIPHY_ENTRY
-		NETDEV_ENTRY
-		__field(u64, timestamp)
-		__field(u32, success_num)
-		__field(u32, partial_num)
-		__field(u32, failed_num)
-		__field(u32, asap_num)
-		__field(u32, non_asap_num)
-		__field(u64, duration)
-		__field(u32, unknown_triggers)
-		__field(u32, reschedule)
-		__field(u32, out_of_window)
-	),
-
-	TP_fast_assign(
-		WIPHY_ASSIGN;
-		NETDEV_ASSIGN;
-		__entry->success_num = ftm_stats->success_num;
-		__entry->partial_num = ftm_stats->partial_num;
-		__entry->failed_num = ftm_stats->failed_num;
-		__entry->asap_num = ftm_stats->asap_num;
-		__entry->non_asap_num = ftm_stats->non_asap_num;
-		__entry->duration = ftm_stats->total_duration_ms;
-		__entry->unknown_triggers = ftm_stats->unknown_triggers_num;
-		__entry->reschedule = ftm_stats->reschedule_requests_num;
-		__entry->out_of_window = ftm_stats->out_of_window_triggers_num;
-	),
-
-	TP_printk(WIPHY_PR_FMT "Ftm responder stats: success %u, partial %u, "
-		"failed %u, asap %u, non asap %u, total duration %llu, unknown "
-		"triggers %u, rescheduled %u, out of window %u", WIPHY_PR_ARG,
-		__entry->success_num, __entry->partial_num, __entry->failed_num,
-		__entry->asap_num, __entry->non_asap_num, __entry->duration,
-		__entry->unknown_triggers, __entry->reschedule,
-		__entry->out_of_window)
-);
 #endif /* !__RDEV_OPS_TRACE || TRACE_HEADER_MULTI_READ */
 
 #undef TRACE_INCLUDE_PATH
-- 
2.14.4

