Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:40970 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755743Ab2LCRmu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Dec 2012 12:42:50 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 2/8] regulatory: don't test list before iterating
Date: Mon,  3 Dec 2012 18:43:07 +0100
Message-Id: <1354556593-2363-3-git-send-email-johannes@sipsolutions.net> (sfid-20121203_184254_508316_598C73C3)
In-Reply-To: <1354556593-2363-1-git-send-email-johannes@sipsolutions.net>
References: <1354556593-2363-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

There's no need to test whether a list is
empty or not before iterating.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/reg.c | 45 +++++++++++++++------------------------------
 1 file changed, 15 insertions(+), 30 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index e71055b..3da03ab 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -1971,21 +1971,15 @@ static void restore_regulatory_settings(bool reset_user)
 
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
@@ -2499,30 +2493,21 @@ void /* __init_or_exit */ regulatory_exit(void)
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

