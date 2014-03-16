Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:38275 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750837AbaCPIwa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 16 Mar 2014 04:52:30 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Alexander Bondar <alexander.bondar@intel.com>
Subject: [PATCH] mac80211: Release sched_scan_sdata when stopping sched scan
Date: Sun, 16 Mar 2014 10:49:54 +0200
Message-Id: <1394959794-19215-1-git-send-email-emmanuel.grumbach@intel.com> (sfid-20140316_095258_616081_44CC1D8C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Alexander Bondar <alexander.bondar@intel.com>


Assuming sched_scan_stop operation is synchronous the driver may not
necessary call ieee80211_sched_scan_stopped_work. Since this work is
the only place where sched_scan_sdata is released we can possibly run
into situation when it is never released. Fix this by releasing it
just after calling drv_sched_scan_stop.

Signed-off-by: Alexander Bondar <alexander.bondar@intel.com>
---
 net/mac80211/scan.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index 836f500..3ce7f2c 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -1055,9 +1055,11 @@ int ieee80211_request_sched_scan_stop(struct ieee80211_sub_if_data *sdata)
 	/* We don't want to restart sched scan anymore. */
 	local->sched_scan_req = NULL;
 
-	if (rcu_access_pointer(local->sched_scan_sdata))
+	if (rcu_access_pointer(local->sched_scan_sdata)) {
 		ret = drv_sched_scan_stop(local, sdata);
-
+		if (!ret)
+			rcu_assign_pointer(local->sched_scan_sdata, NULL);
+	}
 out:
 	mutex_unlock(&local->mtx);
 
-- 
1.8.3.2

