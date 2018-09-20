Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.62]:38856 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732139AbeITPgq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 20 Sep 2018 11:36:46 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] cfg80211: tracing: reuse wiphy_wdev_evt for rdev_get_txq_stats
Date: Thu, 20 Sep 2018 11:53:55 +0200
Message-Id: <20180920095355.14806-1-johannes@sipsolutions.net> (sfid-20180920_115410_371908_F75C39A4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

A simple cleanup, reuse the event definition that we already have.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/trace.h | 13 ++-----------
 1 file changed, 2 insertions(+), 11 deletions(-)

diff --git a/net/wireless/trace.h b/net/wireless/trace.h
index 5e7eec849200..e51348e24ff5 100644
--- a/net/wireless/trace.h
+++ b/net/wireless/trace.h
@@ -3246,18 +3246,9 @@ TRACE_EVENT(rdev_set_multicast_to_unicast,
 		  BOOL_TO_STR(__entry->enabled))
 );
 
-TRACE_EVENT(rdev_get_txq_stats,
+DEFINE_EVENT(wiphy_wdev_evt, rdev_get_txq_stats,
 	TP_PROTO(struct wiphy *wiphy, struct wireless_dev *wdev),
-	TP_ARGS(wiphy, wdev),
-	TP_STRUCT__entry(
-		WIPHY_ENTRY
-		WDEV_ENTRY
-	),
-	TP_fast_assign(
-		WIPHY_ASSIGN;
-		WDEV_ASSIGN;
-	),
-	TP_printk(WIPHY_PR_FMT ", " WDEV_PR_FMT, WIPHY_PR_ARG, WDEV_PR_ARG)
+	TP_ARGS(wiphy, wdev)
 );
 #endif /* !__RDEV_OPS_TRACE || TRACE_HEADER_MULTI_READ */
 
-- 
2.14.4
