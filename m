Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53206 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1945961Ab2LFQr2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Dec 2012 11:47:28 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 05/24] regulatory: don't test list before iterating
Date: Thu,  6 Dec 2012 17:47:29 +0100
Message-Id: <1354812468-15709-6-git-send-email-johannes@sipsolutions.net> (sfid-20121206_174803_900573_81DF52FD)
In-Reply-To: <1354812468-15709-1-git-send-email-johannes@sipsolutions.net>
References: <1354812468-15709-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

There's no need to test whether a list is
empty or not before iterating.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/reg.c | 66 ++++++++++++++++--------------------------------------
 1 file changed, 19 insertions(+), 47 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 45adc8f..333a921 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -1105,9 +1105,6 @@ static void wiphy_update_beacon_reg(struct wiphy *wiphy)
 
 	assert_cfg80211_lock();
 
-	if (list_empty(&reg_beacon_list))
-		return;
-
 	list_for_each_entry(reg_beacon, &reg_beacon_list, list) {
 		if (!wiphy->bands[reg_beacon->chan.band])
 			continue;
@@ -1667,11 +1664,6 @@ static void reg_process_pending_beacon_hints(void)
 	/* This goes through the _pending_ beacon list */
 	spin_lock_bh(&reg_pending_beacons_lock);
 
-	if (list_empty(&reg_pending_beacons)) {
-		spin_unlock_bh(&reg_pending_beacons_lock);
-		goto out;
-	}
-
 	list_for_each_entry_safe(pending_beacon, tmp,
 				 &reg_pending_beacons, list) {
 
@@ -1686,7 +1678,6 @@ static void reg_process_pending_beacon_hints(void)
 	}
 
 	spin_unlock_bh(&reg_pending_beacons_lock);
-out:
 	mutex_unlock(&cfg80211_mutex);
 }
 
@@ -1950,34 +1941,24 @@ static void restore_regulatory_settings(bool reset_user)
 	 * settings.
 	 */
 	spin_lock(&reg_requests_lock);
-	if (!list_empty(&reg_requests_list)) {
-		list_for_each_entry_safe(reg_request, tmp,
-					 &reg_requests_list, list) {
-			if (reg_request->initiator !=
-			    NL80211_REGDOM_SET_BY_USER)
-				continue;
-			list_move_tail(&reg_request->list, &tmp_reg_req_list);
-		}
+	list_for_each_entry_safe(reg_request, tmp, &reg_requests_list, list) {
+		if (reg_request->initiator != NL80211_REGDOM_SET_BY_USER)
+			continue;
+		list_move_tail(&reg_request->list, &tmp_reg_req_list);
 	}
 	spin_unlock(&reg_requests_lock);
 
 	/* Clear beacon hints */
 	spin_lock_bh(&reg_pending_beacons_lock);
-	if (!list_empty(&reg_pending_beacons)) {
-		list_for_each_entry_safe(reg_beacon, btmp,
-					 &reg_pending_beacons, list) {
-			list_del(&reg_beacon->list);
-			kfree(reg_beacon);
-		}
+	list_for_each_entry_safe(reg_beacon, btmp, &reg_pending_beacons, list) {
+		list_del(&reg_beacon->list);
+		kfree(reg_beacon);
 	}
 	spin_unlock_bh(&reg_pending_beacons_lock);
 
-	if (!list_empty(&reg_beacon_list)) {
-		list_for_each_entry_safe(reg_beacon, btmp,
-					 &reg_beacon_list, list) {
-			list_del(&reg_beacon->list);
-			kfree(reg_beacon);
-		}
+	list_for_each_entry_safe(reg_beacon, btmp, &reg_beacon_list, list) {
+		list_del(&reg_beacon->list);
+		kfree(reg_beacon);
 	}
 
 	/* First restore to the basic regulatory settings */
@@ -2491,30 +2472,21 @@ void /* __init_or_exit */ regulatory_exit(void)
 	platform_device_unregister(reg_pdev);
 
 	spin_lock_bh(&reg_pending_beacons_lock);
-	if (!list_empty(&reg_pending_beacons)) {
-		list_for_each_entry_safe(reg_beacon, btmp,
-					 &reg_pending_beacons, list) {
-			list_del(&reg_beacon->list);
-			kfree(reg_beacon);
-		}
+	list_for_each_entry_safe(reg_beacon, btmp, &reg_pending_beacons, list) {
+		list_del(&reg_beacon->list);
+		kfree(reg_beacon);
 	}
 	spin_unlock_bh(&reg_pending_beacons_lock);
 
-	if (!list_empty(&reg_beacon_list)) {
-		list_for_each_entry_safe(reg_beacon, btmp,
-					 &reg_beacon_list, list) {
-			list_del(&reg_beacon->list);
-			kfree(reg_beacon);
-		}
+	list_for_each_entry_safe(reg_beacon, btmp, &reg_beacon_list, list) {
+		list_del(&reg_beacon->list);
+		kfree(reg_beacon);
 	}
 
 	spin_lock(&reg_requests_lock);
-	if (!list_empty(&reg_requests_list)) {
-		list_for_each_entry_safe(reg_request, tmp,
-					 &reg_requests_list, list) {
-			list_del(&reg_request->list);
-			kfree(reg_request);
-		}
+	list_for_each_entry_safe(reg_request, tmp, &reg_requests_list, list) {
+		list_del(&reg_request->list);
+		kfree(reg_request);
 	}
 	spin_unlock(&reg_requests_lock);
 
-- 
1.8.0

