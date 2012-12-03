Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:40976 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755875Ab2LCRmw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Dec 2012 12:42:52 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5/8] regulatory: remove useless locking on exit
Date: Mon,  3 Dec 2012 18:43:10 +0100
Message-Id: <1354556593-2363-6-git-send-email-johannes@sipsolutions.net> (sfid-20121203_184310_178462_76876D08)
In-Reply-To: <1354556593-2363-1-git-send-email-johannes@sipsolutions.net>
References: <1354556593-2363-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

It would be a major problem if anything were to run
concurrently while the module is being unloaded so
remove the locking that doesn't help anything.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/reg.c | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 6cece2d..9de3360 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -2406,34 +2406,24 @@ void regulatory_exit(void)
 	cancel_work_sync(&reg_work);
 	cancel_delayed_work_sync(&reg_timeout);
 
-	mutex_lock(&cfg80211_mutex);
-	mutex_lock(&reg_mutex);
-
 	reset_regdomains(true);
 
 	dev_set_uevent_suppress(&reg_pdev->dev, true);
 
 	platform_device_unregister(reg_pdev);
 
-	spin_lock_bh(&reg_pending_beacons_lock);
 	list_for_each_entry_safe(reg_beacon, btmp, &reg_pending_beacons, list) {
 		list_del(&reg_beacon->list);
 		kfree(reg_beacon);
 	}
-	spin_unlock_bh(&reg_pending_beacons_lock);
 
 	list_for_each_entry_safe(reg_beacon, btmp, &reg_beacon_list, list) {
 		list_del(&reg_beacon->list);
 		kfree(reg_beacon);
 	}
 
-	spin_lock(&reg_requests_lock);
 	list_for_each_entry_safe(reg_request, tmp, &reg_requests_list, list) {
 		list_del(&reg_request->list);
 		kfree(reg_request);
 	}
-	spin_unlock(&reg_requests_lock);
-
-	mutex_unlock(&reg_mutex);
-	mutex_unlock(&cfg80211_mutex);
 }
-- 
1.8.0

