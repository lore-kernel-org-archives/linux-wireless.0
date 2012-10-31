Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:46457 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935724Ab2JaQEC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Oct 2012 12:04:02 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: David Spinadel <david.spinadel@intel.com>
Subject: [PATCH] mac80211: init sched_scan_ies
Date: Wed, 31 Oct 2012 17:04:34 +0100
Message-Id: <1351699474-17481-1-git-send-email-johannes@sipsolutions.net> (sfid-20121031_170407_266009_0955A2F7)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: David Spinadel <david.spinadel@intel.com>

In case that there is an unsupported band, the ie will be
unallocated and the free will crash.

Cc: stable@vger.kernel.org
Signed-off-by: David Spinadel <david.spinadel@intel.com>
Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/scan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index c4cdbde..43e60b5 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -917,7 +917,7 @@ int ieee80211_request_sched_scan_start(struct ieee80211_sub_if_data *sdata,
 				       struct cfg80211_sched_scan_request *req)
 {
 	struct ieee80211_local *local = sdata->local;
-	struct ieee80211_sched_scan_ies sched_scan_ies;
+	struct ieee80211_sched_scan_ies sched_scan_ies = {};
 	int ret, i;
 
 	mutex_lock(&local->mtx);
-- 
1.7.10.4

