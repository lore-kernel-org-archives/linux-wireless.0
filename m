Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:45173 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756688AbbIUMsz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Sep 2015 08:48:55 -0400
From: Luca Coelho <luca@coelho.fi>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Avraham Stern <avraham.stern@intel.com>,
	Luca Coelho <luciano.coelho@intel.com>
Date: Mon, 21 Sep 2015 15:48:49 +0300
Message-Id: <1442839729-25955-1-git-send-email-luca@coelho.fi> (sfid-20150921_144859_041155_C9E93066)
Subject: [PATCH] mac80211: Do not restart scheduled scan if multiple scan plans are set
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Avraham Stern <avraham.stern@intel.com>

If multiple scan plans were set for scheduled scan, do not restart
scheduled scan on reconfig because it is possible that some scan
plans were already completed and there is no need to run them all
over again. Instead, notify userspace that scheduled scan stopped
so it can configure new scan plans for scheduled scan.

Signed-off-by: Avraham Stern <avraham.stern@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 net/mac80211/util.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 9cabf07..005fc8e 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -2041,9 +2041,13 @@ int ieee80211_reconfig(struct ieee80211_local *local)
 	if (sched_scan_sdata && sched_scan_req)
 		/*
 		 * Sched scan stopped, but we don't want to report it. Instead,
-		 * we're trying to reschedule.
+		 * we're trying to reschedule. However, if more than one scan
+		 * plan was set, we cannot reschedule since we don't know which
+		 * scan plan was currently running (and some scan plans may have
+		 * already finished).
 		 */
-		if (__ieee80211_request_sched_scan_start(sched_scan_sdata,
+		if (sched_scan_req->n_scan_plans > 1 ||
+		    __ieee80211_request_sched_scan_start(sched_scan_sdata,
 							 sched_scan_req))
 			sched_scan_stopped = true;
 	mutex_unlock(&local->mtx);
-- 
2.5.1

