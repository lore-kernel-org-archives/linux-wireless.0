Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:60012 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754808Ab0F2TPP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jun 2010 15:15:15 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: Holger Schurig <holgerschurig@gmail.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] mac80211: add basic tracing to drv_get_survey
Date: Tue, 29 Jun 2010 15:00:30 -0400
Message-Id: <1277838030-13869-1-git-send-email-linville@tuxdriver.com>
In-Reply-To: <1274906612.3658.58.camel@jlt3.sipsolutions.net>
References: <1274906612.3658.58.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Reported-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 net/mac80211/driver-ops.h   |    7 ++++++-
 net/mac80211/driver-trace.h |   22 ++++++++++++++++++++++
 2 files changed, 28 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index c333173..14123dc 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -375,9 +375,14 @@ static inline int drv_get_survey(struct ieee80211_local *local, int idx,
 				struct survey_info *survey)
 {
 	int ret = -EOPNOTSUPP;
+
+	trace_drv_get_survey(local, idx, survey);
+
 	if (local->ops->get_survey)
 		ret = local->ops->get_survey(&local->hw, idx, survey);
-	/* trace_drv_get_survey(local, idx, survey, ret); */
+
+	trace_drv_return_int(local, ret);
+
 	return ret;
 }
 
diff --git a/net/mac80211/driver-trace.h b/net/mac80211/driver-trace.h
index 8da31ca..5d5d2a9 100644
--- a/net/mac80211/driver-trace.h
+++ b/net/mac80211/driver-trace.h
@@ -761,6 +761,28 @@ TRACE_EVENT(drv_ampdu_action,
 	)
 );
 
+TRACE_EVENT(drv_get_survey,
+	TP_PROTO(struct ieee80211_local *local, int idx,
+		 struct survey_info *survey),
+
+	TP_ARGS(local, idx, survey),
+
+	TP_STRUCT__entry(
+		LOCAL_ENTRY
+		__field(int, idx)
+	),
+
+	TP_fast_assign(
+		LOCAL_ASSIGN;
+		__entry->idx = idx;
+	),
+
+	TP_printk(
+		LOCAL_PR_FMT " idx:%d",
+		LOCAL_PR_ARG, __entry->idx
+	)
+);
+
 TRACE_EVENT(drv_flush,
 	TP_PROTO(struct ieee80211_local *local, bool drop),
 
-- 
1.7.0.1

