Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:33099 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932562AbbLPNqL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Dec 2015 08:46:11 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, Eliad Peller <eliad@wizery.com>,
	Eliad Peller <eliadx.peller@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH] mac80211: clear local->sched_scan_req properly on reconfig
Date: Wed, 16 Dec 2015 15:45:45 +0200
Message-Id: <1450273545-16081-1-git-send-email-emmanuel.grumbach@intel.com> (sfid-20151216_144618_337528_EFA7C9F2)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eliad Peller <eliad@wizery.com>

On reconfig, in case of sched_scan_req->n_scan_plans > 1,
local->sched_scan_req was never cleared, although
cfg80211_sched_scan_stopped_rtnl() was called, resulting
in local->sched_scan_req holding a stale and preventing
further scheduled scan requests.

Clear it explicitly in this case.

Fixes: 42a7e82c6792 ("mac80211: Do not restart scheduled scan if multiple scan plans are set")
Signed-off-by: Eliad Peller <eliadx.peller@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 net/mac80211/util.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 0186178..884033e 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -2046,8 +2046,11 @@ int ieee80211_reconfig(struct ieee80211_local *local)
 		 */
 		if (sched_scan_req->n_scan_plans > 1 ||
 		    __ieee80211_request_sched_scan_start(sched_scan_sdata,
-							 sched_scan_req))
+							 sched_scan_req)) {
+			RCU_INIT_POINTER(local->sched_scan_sdata, NULL);
+			RCU_INIT_POINTER(local->sched_scan_req, NULL);
 			sched_scan_stopped = true;
+		}
 	mutex_unlock(&local->mtx);
 
 	if (sched_scan_stopped)
-- 
2.5.0

