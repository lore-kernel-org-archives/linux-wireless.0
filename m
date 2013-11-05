Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f50.google.com ([209.85.214.50]:45583 "EHLO
	mail-bk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755281Ab3KERRf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Nov 2013 12:17:35 -0500
Received: by mail-bk0-f50.google.com with SMTP id v15so337069bkz.37
        for <linux-wireless@vger.kernel.org>; Tue, 05 Nov 2013 09:17:34 -0800 (PST)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 11/19] cfg80211: add helper for kfree'ing and assigning last_request
Date: Tue,  5 Nov 2013 09:18:09 -0800
Message-Id: <1383671897-7746-12-git-send-email-mcgrof@do-not-panic.com> (sfid-20131105_181750_058696_196D23D0)
In-Reply-To: <1383671897-7746-1-git-send-email-mcgrof@do-not-panic.com>
References: <1383671897-7746-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This enforces proper RCU APIs accross the code.

Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 net/wireless/reg.c | 21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 30e813f..ddccc9a 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -212,6 +212,12 @@ static void reg_kfree_last_request(void)
 		kfree_rcu(lr, rcu_head);
 }
 
+static void reg_update_last_request(struct regulatory_request *request)
+{
+	reg_kfree_last_request();
+	rcu_assign_pointer(last_request, request);
+}
+
 static void reset_regdomains(bool full_reset,
 			     const struct ieee80211_regdomain *new_regdom)
 {
@@ -238,8 +244,7 @@ static void reset_regdomains(bool full_reset,
 	if (!full_reset)
 		return;
 
-	reg_kfree_last_request();
-	rcu_assign_pointer(last_request, &core_request_world);
+	reg_update_last_request(&core_request_world);
 }
 
 /*
@@ -1364,8 +1369,7 @@ reg_process_hint_core(struct regulatory_request *core_request)
 	core_request->intersect = false;
 	core_request->processed = false;
 
-	reg_kfree_last_request();
-	rcu_assign_pointer(last_request, core_request);
+	reg_update_last_request(core_request);
 
 	if (call_crda(core_request->alpha2))
 		return REG_REQ_IGNORE;
@@ -1432,8 +1436,7 @@ reg_process_hint_user(struct regulatory_request *user_request)
 	user_request->intersect = treatment == REG_REQ_INTERSECT;
 	user_request->processed = false;
 
-	reg_kfree_last_request();
-	rcu_assign_pointer(last_request, user_request);
+	reg_update_last_request(user_request);
 
 	user_alpha2[0] = user_request->alpha2[0];
 	user_alpha2[1] = user_request->alpha2[1];
@@ -1505,8 +1508,7 @@ reg_process_hint_driver(struct wiphy *wiphy,
 	driver_request->intersect = treatment == REG_REQ_INTERSECT;
 	driver_request->processed = false;
 
-	reg_kfree_last_request();
-	rcu_assign_pointer(last_request, driver_request);
+	reg_update_last_request(driver_request);
 
 	/*
 	 * Since CRDA will not be called in this case as we already
@@ -1604,8 +1606,7 @@ reg_process_hint_country_ie(struct wiphy *wiphy,
 	country_ie_request->intersect = false;
 	country_ie_request->processed = false;
 
-	reg_kfree_last_request();
-	rcu_assign_pointer(last_request, country_ie_request);
+	reg_update_last_request(country_ie_request);
 
 	if (call_crda(country_ie_request->alpha2))
 		return REG_REQ_IGNORE;
-- 
1.8.4.rc3

