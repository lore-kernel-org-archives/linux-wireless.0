Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:38707 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751820AbbJON63 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Oct 2015 09:58:29 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 09/12] cfg80211: reg: centralize freeing ignored requests
Date: Thu, 15 Oct 2015 15:58:20 +0200
Message-Id: <1444917503-19118-9-git-send-email-johannes@sipsolutions.net> (sfid-20151015_155841_161917_B0970454)
In-Reply-To: <1444917503-19118-1-git-send-email-johannes@sipsolutions.net>
References: <1444917503-19118-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Instead of having a lot of places that free ignored requests
and then return REG_REQ_OK, make reg_process_hint() process
REG_REQ_IGNORE by freeing the request, and let functions it
calls return that instead of freeing.

This also fixes a leak when a second (different) country IE
hint was ignored.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/reg.c | 64 +++++++++++++++++++++++++++++-------------------------
 1 file changed, 35 insertions(+), 29 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 6118c1e664be..b1638c9c0798 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -273,6 +273,9 @@ MODULE_PARM_DESC(ieee80211_regdom, "IEEE 802.11 regulatory domain code");
 
 static void reg_free_request(struct regulatory_request *request)
 {
+	if (request == &core_request_world)
+		return;
+
 	if (request != get_last_request())
 		kfree(request);
 }
@@ -1905,13 +1908,17 @@ static void reg_set_request_processed(void)
  * The wireless subsystem can use this function to process
  * a regulatory request issued by the regulatory core.
  */
-static void reg_process_hint_core(struct regulatory_request *core_request)
+static enum reg_request_treatment
+reg_process_hint_core(struct regulatory_request *core_request)
 {
 	if (reg_query_database(core_request)) {
 		core_request->intersect = false;
 		core_request->processed = false;
 		reg_update_last_request(core_request);
+		return REG_REQ_OK;
 	}
+
+	return REG_REQ_IGNORE;
 }
 
 static enum reg_request_treatment
@@ -1957,16 +1964,15 @@ __reg_process_hint_user(struct regulatory_request *user_request)
  * The wireless subsystem can use this function to process
  * a regulatory request initiated by userspace.
  */
-static void reg_process_hint_user(struct regulatory_request *user_request)
+static enum reg_request_treatment
+reg_process_hint_user(struct regulatory_request *user_request)
 {
 	enum reg_request_treatment treatment;
 
 	treatment = __reg_process_hint_user(user_request);
 	if (treatment == REG_REQ_IGNORE ||
-	    treatment == REG_REQ_ALREADY_SET) {
-		reg_free_request(user_request);
-		return;
-	}
+	    treatment == REG_REQ_ALREADY_SET)
+		return REG_REQ_IGNORE;
 
 	user_request->intersect = treatment == REG_REQ_INTERSECT;
 	user_request->processed = false;
@@ -1975,9 +1981,10 @@ static void reg_process_hint_user(struct regulatory_request *user_request)
 		reg_update_last_request(user_request);
 		user_alpha2[0] = user_request->alpha2[0];
 		user_alpha2[1] = user_request->alpha2[1];
-	} else {
-		reg_free_request(user_request);
+		return REG_REQ_OK;
 	}
+
+	return REG_REQ_IGNORE;
 }
 
 static enum reg_request_treatment
@@ -2025,15 +2032,12 @@ reg_process_hint_driver(struct wiphy *wiphy,
 	case REG_REQ_OK:
 		break;
 	case REG_REQ_IGNORE:
-		reg_free_request(driver_request);
-		return REG_REQ_OK;
+		return REG_REQ_IGNORE;
 	case REG_REQ_INTERSECT:
 	case REG_REQ_ALREADY_SET:
 		regd = reg_copy_regd(get_cfg80211_regdom());
-		if (IS_ERR(regd)) {
-			reg_free_request(driver_request);
-			return REG_REQ_OK;
-		}
+		if (IS_ERR(regd))
+			return REG_REQ_IGNORE;
 
 		tmp = get_wiphy_regdom(wiphy);
 		rcu_assign_pointer(wiphy->regd, regd);
@@ -2056,12 +2060,12 @@ reg_process_hint_driver(struct wiphy *wiphy,
 		return REG_REQ_ALREADY_SET;
 	}
 
-	if (reg_query_database(driver_request))
+	if (reg_query_database(driver_request)) {
 		reg_update_last_request(driver_request);
-	else
-		reg_free_request(driver_request);
+		return REG_REQ_OK;
+	}
 
-	return REG_REQ_OK;
+	return REG_REQ_IGNORE;
 }
 
 static enum reg_request_treatment
@@ -2127,29 +2131,28 @@ reg_process_hint_country_ie(struct wiphy *wiphy,
 	case REG_REQ_OK:
 		break;
 	case REG_REQ_IGNORE:
-		return REG_REQ_OK;
+		return REG_REQ_IGNORE;
 	case REG_REQ_ALREADY_SET:
 		reg_free_request(country_ie_request);
 		return REG_REQ_ALREADY_SET;
 	case REG_REQ_INTERSECT:
-		reg_free_request(country_ie_request);
 		/*
 		 * This doesn't happen yet, not sure we
 		 * ever want to support it for this case.
 		 */
 		WARN_ONCE(1, "Unexpected intersection for country IEs");
-		return REG_REQ_OK;
+		return REG_REQ_IGNORE;
 	}
 
 	country_ie_request->intersect = false;
 	country_ie_request->processed = false;
 
-	if (reg_query_database(country_ie_request))
+	if (reg_query_database(country_ie_request)) {
 		reg_update_last_request(country_ie_request);
-	else
-		reg_free_request(country_ie_request);
+		return REG_REQ_OK;
+	}
 
-	return REG_REQ_OK;
+	return REG_REQ_IGNORE;
 }
 
 /* This processes *all* regulatory hints */
@@ -2163,11 +2166,11 @@ static void reg_process_hint(struct regulatory_request *reg_request)
 
 	switch (reg_request->initiator) {
 	case NL80211_REGDOM_SET_BY_CORE:
-		reg_process_hint_core(reg_request);
-		return;
+		treatment = reg_process_hint_core(reg_request);
+		break;
 	case NL80211_REGDOM_SET_BY_USER:
-		reg_process_hint_user(reg_request);
-		return;
+		treatment = reg_process_hint_user(reg_request);
+		break;
 	case NL80211_REGDOM_SET_BY_DRIVER:
 		if (!wiphy)
 			goto out_free;
@@ -2183,6 +2186,9 @@ static void reg_process_hint(struct regulatory_request *reg_request)
 		goto out_free;
 	}
 
+	if (treatment == REG_REQ_IGNORE)
+		goto out_free;
+
 	WARN(treatment != REG_REQ_OK && treatment != REG_REQ_ALREADY_SET,
 	     "unexpected treatment value %d\n", treatment);
 
-- 
2.5.1

