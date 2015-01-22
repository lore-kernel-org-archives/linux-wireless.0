Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:56090 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753390AbbAVVeO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Jan 2015 16:34:14 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Luciano Coelho <luciano.coelho@intel.com>
Subject: [PATCH] mac80211: complete scan work immediately if quiesced or suspended
Date: Thu, 22 Jan 2015 23:34:10 +0200
Message-Id: <1421962450-7096-1-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150122_223417_895507_CD129237)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

It is possible that a deferred scan is queued after the queues are
flushed in __ieee80211_suspend().  The deferred scan work may be
scheduled by ROC or ieee80211_stop_poll().

To make sure don't start a new scan while suspending, check whether
we're quiescing or suspended and complete the scan immediately if
that's the case.

Change-Id: I8ec2c8fb4d969833d45c77045b0f5594cc097086
Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
Reviewed-on: https://gerrit.rds.intel.com/r/51405
Tested-by: IWL Jenkins
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/scan.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index 7807fa4..05f0d71 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -828,6 +828,11 @@ void ieee80211_scan_work(struct work_struct *work)
 
 	mutex_lock(&local->mtx);
 
+	if (!ieee80211_can_run_worker(local)) {
+		aborted = true;
+		goto out_complete;
+	}
+
 	sdata = rcu_dereference_protected(local->scan_sdata,
 					  lockdep_is_held(&local->mtx));
 	scan_req = rcu_dereference_protected(local->scan_req,
-- 
1.9.1

