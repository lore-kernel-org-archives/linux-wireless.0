Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50200 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754323AbdIZKBh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 26 Sep 2017 06:01:37 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, toke@toke.dk,
        Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH] mac80211: make STA_SLOW_THRESHOLD local
Date: Tue, 26 Sep 2017 11:59:47 +0200
Message-Id: <1506419987-22995-1-git-send-email-sgruszka@redhat.com> (sfid-20170926_120321_477619_4BB249F5)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

STA_SLOW_THRESHOLD is used only in one function, so don't need to be
global define.

Patch also fixes problem of htmldocs build I encountered:

Error(.//net/mac80211/sta_info.h:416): cannot understand prototype: 'STA_SLOW_THRESHOLD 6000  '

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 net/mac80211/sta_info.c |    8 +++++++-
 net/mac80211/sta_info.h |    8 --------
 2 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 6961501..b79c2d0 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -2319,10 +2319,16 @@ unsigned long ieee80211_sta_last_active(struct sta_info *sta)
 
 static void sta_update_codel_params(struct sta_info *sta, u32 thr)
 {
+	/* The bandwidth threshold below which the per-station CoDel parameters
+	 * will be scaled to be more lenient (to prevent starvation of slow
+	 * stations). Value will be scaled by the number of active stations.
+	 */
+	const unsigned int slow_threshold = 6000; /* 6Mbps */
+
 	if (!sta->sdata->local->ops->wake_tx_queue)
 		return;
 
-	if (thr && thr < STA_SLOW_THRESHOLD * sta->local->num_sta) {
+	if (thr && thr < slow_threshold * sta->local->num_sta) {
 		sta->cparams.target = MS2TIME(50);
 		sta->cparams.interval = MS2TIME(300);
 		sta->cparams.ecn = false;
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index 3acbdfa..24eeab8 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -399,14 +399,6 @@ struct ieee80211_sta_rx_stats {
 };
 
 /**
- * The bandwidth threshold below which the per-station CoDel parameters will be
- * scaled to be more lenient (to prevent starvation of slow stations). This
- * value will be scaled by the number of active stations when it is being
- * applied.
- */
-#define STA_SLOW_THRESHOLD 6000 /* 6 Mbps */
-
-/**
  * struct sta_info - STA information
  *
  * This structure collects information about a station that
-- 
1.7.1
