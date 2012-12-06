Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53212 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1945968Ab2LFQra (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Dec 2012 11:47:30 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 08/24] regulatory: remove useless locking on exit
Date: Thu,  6 Dec 2012 17:47:32 +0100
Message-Id: <1354812468-15709-9-git-send-email-johannes@sipsolutions.net> (sfid-20121206_174801_474210_29E864CA)
In-Reply-To: <1354812468-15709-1-git-send-email-johannes@sipsolutions.net>
References: <1354812468-15709-1-git-send-email-johannes@sipsolutions.net>
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
index 7391624..4bb953f 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -2383,34 +2383,29 @@ void regulatory_exit(void)
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

