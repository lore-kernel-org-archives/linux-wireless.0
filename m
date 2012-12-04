Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44568 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753990Ab2LDOsk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Dec 2012 09:48:40 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [RFC v2 06/18] regulatory: remove useless locking on exit
Date: Tue,  4 Dec 2012 15:48:48 +0100
Message-Id: <1354632540-21207-7-git-send-email-johannes@sipsolutions.net> (sfid-20121204_154904_902731_478227B9)
In-Reply-To: <1354632540-21207-1-git-send-email-johannes@sipsolutions.net>
References: <1354632540-21207-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

It would be a major problem if anything were to run
concurrently while the module is being unloaded so
remove the locking that doesn't help anything.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/reg.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 10ba185..be6b00c 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -2391,34 +2391,29 @@ void regulatory_exit(void)
 	cancel_work_sync(&reg_work);
 	cancel_delayed_work_sync(&reg_timeout);
 
+	/* Lock to suppress warnings */
 	mutex_lock(&cfg80211_mutex);
 	mutex_lock(&reg_mutex);
-
 	reset_regdomains(true);
+	mutex_unlock(&cfg80211_mutex);
+	mutex_unlock(&reg_mutex);
 
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

