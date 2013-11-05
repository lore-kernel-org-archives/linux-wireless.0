Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f49.google.com ([209.85.214.49]:61357 "EHLO
	mail-bk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755281Ab3KERRd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Nov 2013 12:17:33 -0500
Received: by mail-bk0-f49.google.com with SMTP id w14so3639402bkz.8
        for <linux-wireless@vger.kernel.org>; Tue, 05 Nov 2013 09:17:32 -0800 (PST)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 10/19] cfg80211: add helper for kfree'ing last_request
Date: Tue,  5 Nov 2013 09:18:08 -0800
Message-Id: <1383671897-7746-11-git-send-email-mcgrof@do-not-panic.com> (sfid-20131105_181737_592016_C8202A72)
In-Reply-To: <1383671897-7746-1-git-send-email-mcgrof@do-not-panic.com>
References: <1383671897-7746-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is common code, this reduces the chance of making
a mistake of how we free it.

Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 net/wireless/reg.c | 42 +++++++++++++++++++-----------------------
 1 file changed, 19 insertions(+), 23 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 4d552d8..30e813f 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -202,11 +202,20 @@ static char user_alpha2[2];
 module_param(ieee80211_regdom, charp, 0444);
 MODULE_PARM_DESC(ieee80211_regdom, "IEEE 802.11 regulatory domain code");
 
+static void reg_kfree_last_request(void)
+{
+	struct regulatory_request *lr;
+
+	lr = get_last_request();
+
+	if (lr != &core_request_world && lr)
+		kfree_rcu(lr, rcu_head);
+}
+
 static void reset_regdomains(bool full_reset,
 			     const struct ieee80211_regdomain *new_regdom)
 {
 	const struct ieee80211_regdomain *r;
-	struct regulatory_request *lr;
 
 	ASSERT_RTNL();
 
@@ -229,9 +238,7 @@ static void reset_regdomains(bool full_reset,
 	if (!full_reset)
 		return;
 
-	lr = get_last_request();
-	if (lr != &core_request_world && lr)
-		kfree_rcu(lr, rcu_head);
+	reg_kfree_last_request();
 	rcu_assign_pointer(last_request, &core_request_world);
 }
 
@@ -1353,14 +1360,11 @@ static void reg_set_request_processed(void)
 static enum reg_request_treatment
 reg_process_hint_core(struct regulatory_request *core_request)
 {
-	struct regulatory_request *lr;
-
-	lr = get_last_request();
-	if (lr != &core_request_world && lr)
-		kfree_rcu(lr, rcu_head);
 
 	core_request->intersect = false;
 	core_request->processed = false;
+
+	reg_kfree_last_request();
 	rcu_assign_pointer(last_request, core_request);
 
 	if (call_crda(core_request->alpha2))
@@ -1417,7 +1421,6 @@ static enum reg_request_treatment
 reg_process_hint_user(struct regulatory_request *user_request)
 {
 	enum reg_request_treatment treatment;
-	struct regulatory_request *lr;
 
 	treatment = __reg_process_hint_user(user_request);
 	if (treatment == REG_REQ_IGNORE ||
@@ -1426,12 +1429,10 @@ reg_process_hint_user(struct regulatory_request *user_request)
 		return treatment;
 	}
 
-	lr = get_last_request();
-	if (lr != &core_request_world && lr)
-		kfree_rcu(lr, rcu_head);
-
 	user_request->intersect = treatment == REG_REQ_INTERSECT;
 	user_request->processed = false;
+
+	reg_kfree_last_request();
 	rcu_assign_pointer(last_request, user_request);
 
 	user_alpha2[0] = user_request->alpha2[0];
@@ -1480,7 +1481,6 @@ reg_process_hint_driver(struct wiphy *wiphy,
 {
 	const struct ieee80211_regdomain *regd;
 	enum reg_request_treatment treatment;
-	struct regulatory_request *lr;
 
 	treatment = __reg_process_hint_driver(driver_request);
 
@@ -1501,12 +1501,11 @@ reg_process_hint_driver(struct wiphy *wiphy,
 		rcu_assign_pointer(wiphy->regd, regd);
 	}
 
-	lr = get_last_request();
-	if (lr != &core_request_world && lr)
-		kfree_rcu(lr, rcu_head);
 
 	driver_request->intersect = treatment == REG_REQ_INTERSECT;
 	driver_request->processed = false;
+
+	reg_kfree_last_request();
 	rcu_assign_pointer(last_request, driver_request);
 
 	/*
@@ -1581,7 +1580,6 @@ reg_process_hint_country_ie(struct wiphy *wiphy,
 			    struct regulatory_request *country_ie_request)
 {
 	enum reg_request_treatment treatment;
-	struct regulatory_request *lr;
 
 	treatment = __reg_process_hint_country_ie(wiphy, country_ie_request);
 
@@ -1603,12 +1601,10 @@ reg_process_hint_country_ie(struct wiphy *wiphy,
 		return REG_REQ_IGNORE;
 	}
 
-	lr = get_last_request();
-	if (lr != &core_request_world && lr)
-		kfree_rcu(lr, rcu_head);
-
 	country_ie_request->intersect = false;
 	country_ie_request->processed = false;
+
+	reg_kfree_last_request();
 	rcu_assign_pointer(last_request, country_ie_request);
 
 	if (call_crda(country_ie_request->alpha2))
-- 
1.8.4.rc3

