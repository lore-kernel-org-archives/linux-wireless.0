Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:34306 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751529AbbJLGvp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Oct 2015 02:51:45 -0400
From: Luca Coelho <luca@coelho.fi>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Avraham Stern <avraham.stern@intel.com>,
	Luca Coelho <luciano.coelho@intel.com>
Date: Mon, 12 Oct 2015 09:51:35 +0300
Message-Id: <1444632695-10505-2-git-send-email-luca@coelho.fi> (sfid-20151012_085150_128852_AEA9DD35)
In-Reply-To: <1444632695-10505-1-git-send-email-luca@coelho.fi>
References: <1444632695-10505-1-git-send-email-luca@coelho.fi>
Subject: [PATCH v2 2/2] mac80211: Do not restart scheduled scan if multiple scan plans are set
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

No changes from v1.

net/mac80211/util.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index fb6e511..8f0fa35 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -2042,9 +2042,13 @@ int ieee80211_reconfig(struct ieee80211_local *local)
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
2.5.3

