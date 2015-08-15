Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:10293 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754151AbbHOTEL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 15 Aug 2015 15:04:11 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Andrei Otcheretianski <andrei.otcheretianski@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH] mac80211: process skb_queue while scanning in HW
Date: Sat, 15 Aug 2015 22:04:01 +0300
Message-Id: <1439665441-4406-1-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150815_210420_709979_744DD5A5)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Andrei Otcheretianski <andrei.otcheretianski@intel.com>

Queued frames aren't processed during scan, which results in an inability
to complete the BA session establishment until the scan ends. Since we
can't tx frames until the BA agreement setup is complete, it might result
in a very large latency during scan.
Fix this by allowing to process queued skbs while scanning in HW. This
should be ok since the devices which support hw scan should be able
to handle tx/rx while scanning.
During SW scan, mac80211 drops any txed frames besides probes and NDPs,
so it is still needed to delay processing of the queued frames till the
SW scan is done.

Signed-off-by: Andrei Otcheretianski <andrei.otcheretianski@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 net/mac80211/iface.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 553ac6d..1e1829f 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -1204,7 +1204,7 @@ static void ieee80211_iface_work(struct work_struct *work)
 	if (!ieee80211_sdata_running(sdata))
 		return;
 
-	if (local->scanning)
+	if (test_bit(SCAN_SW_SCANNING, &local->scanning))
 		return;
 
 	if (!ieee80211_can_run_worker(local))
-- 
2.1.4

