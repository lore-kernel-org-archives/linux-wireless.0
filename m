Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:38696 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751682AbbJON62 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Oct 2015 09:58:28 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 03/12] cfg80211: reg: rename reg_call_crda to reg_query_database
Date: Thu, 15 Oct 2015 15:58:14 +0200
Message-Id: <1444917503-19118-3-git-send-email-johannes@sipsolutions.net> (sfid-20151015_155834_214835_06E9DA1F)
In-Reply-To: <1444917503-19118-1-git-send-email-johannes@sipsolutions.net>
References: <1444917503-19118-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The new name is more appropriate since in the case of a built-in
database it may not really rely on CRDA.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/reg.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 862d67ccdbf8..4e14804ef51f 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -554,7 +554,7 @@ static int call_crda(const char *alpha2)
 	return kobject_uevent_env(&reg_pdev->dev.kobj, KOBJ_CHANGE, env);
 }
 
-static bool reg_call_crda(struct regulatory_request *request)
+static bool reg_query_database(struct regulatory_request *request)
 {
 	if (call_crda(request->alpha2))
 		return false;
@@ -1857,7 +1857,7 @@ static void reg_set_request_processed(void)
  */
 static void reg_process_hint_core(struct regulatory_request *core_request)
 {
-	if (reg_call_crda(core_request)) {
+	if (reg_query_database(core_request)) {
 		core_request->intersect = false;
 		core_request->processed = false;
 		reg_update_last_request(core_request);
@@ -1921,7 +1921,7 @@ static void reg_process_hint_user(struct regulatory_request *user_request)
 	user_request->intersect = treatment == REG_REQ_INTERSECT;
 	user_request->processed = false;
 
-	if (reg_call_crda(user_request)) {
+	if (reg_query_database(user_request)) {
 		reg_update_last_request(user_request);
 		user_alpha2[0] = user_request->alpha2[0];
 		user_alpha2[1] = user_request->alpha2[1];
@@ -2007,7 +2007,7 @@ reg_process_hint_driver(struct wiphy *wiphy,
 		return treatment;
 	}
 
-	if (reg_call_crda(driver_request))
+	if (reg_query_database(driver_request))
 		reg_update_last_request(driver_request);
 	else
 		reg_free_request(driver_request);
@@ -2095,7 +2095,7 @@ reg_process_hint_country_ie(struct wiphy *wiphy,
 	country_ie_request->intersect = false;
 	country_ie_request->processed = false;
 
-	if (reg_call_crda(country_ie_request))
+	if (reg_query_database(country_ie_request))
 		reg_update_last_request(country_ie_request);
 	else
 		reg_free_request(country_ie_request);
-- 
2.5.1

