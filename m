Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:59244 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752833AbbBYPov (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Feb 2015 10:44:51 -0500
From: Ilan Peer <ilan.peer@intel.com>
To: linux-wireless@vger.kernel.org
Cc: mcgrof@suse.com, Ilan Peer <ilan.peer@intel.com>
Subject: [PATCH v7 1/3] cfg80211: Simplify the handling of regulatory indoor setting
Date: Wed, 25 Feb 2015 04:47:02 -0500
Message-Id: <1424857624-24944-1-git-send-email-ilan.peer@intel.com> (sfid-20150225_164454_917736_761DD1B3)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Directly update the indoor setting without wrapping it as
a regulatory request, to simplify the processing.

Signed-off-by: Ilan Peer <ilan.peer@intel.com>
---
 net/wireless/reg.c | 34 +++-------------------------------
 1 file changed, 3 insertions(+), 31 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index b586d0d..c24c8bf 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -82,17 +82,12 @@
  *	be intersected with the current one.
  * @REG_REQ_ALREADY_SET: the regulatory request will not change the current
  *	regulatory settings, and no further processing is required.
- * @REG_REQ_USER_HINT_HANDLED: a non alpha2  user hint was handled and no
- *	further processing is required, i.e., not need to update last_request
- *	etc. This should be used for user hints that do not provide an alpha2
- *	but some other type of regulatory hint, i.e., indoor operation.
  */
 enum reg_request_treatment {
 	REG_REQ_OK,
 	REG_REQ_IGNORE,
 	REG_REQ_INTERSECT,
 	REG_REQ_ALREADY_SET,
-	REG_REQ_USER_HINT_HANDLED,
 };
 
 static struct regulatory_request core_request_world = {
@@ -1248,13 +1243,6 @@ static bool reg_request_cell_base(struct regulatory_request *request)
 	return request->user_reg_hint_type == NL80211_USER_REG_HINT_CELL_BASE;
 }
 
-static bool reg_request_indoor(struct regulatory_request *request)
-{
-	if (request->initiator != NL80211_REGDOM_SET_BY_USER)
-		return false;
-	return request->user_reg_hint_type == NL80211_USER_REG_HINT_INDOOR;
-}
-
 bool reg_last_request_cell_base(void)
 {
 	return reg_request_cell_base(get_last_request());
@@ -1833,11 +1821,6 @@ __reg_process_hint_user(struct regulatory_request *user_request)
 {
 	struct regulatory_request *lr = get_last_request();
 
-	if (reg_request_indoor(user_request)) {
-		reg_is_indoor = true;
-		return REG_REQ_USER_HINT_HANDLED;
-	}
-
 	if (reg_request_cell_base(user_request))
 		return reg_ignore_cell_hint(user_request);
 
@@ -1885,8 +1868,7 @@ reg_process_hint_user(struct regulatory_request *user_request)
 
 	treatment = __reg_process_hint_user(user_request);
 	if (treatment == REG_REQ_IGNORE ||
-	    treatment == REG_REQ_ALREADY_SET ||
-	    treatment == REG_REQ_USER_HINT_HANDLED) {
+	    treatment == REG_REQ_ALREADY_SET) {
 		reg_free_request(user_request);
 		return treatment;
 	}
@@ -1947,7 +1929,6 @@ reg_process_hint_driver(struct wiphy *wiphy,
 	case REG_REQ_OK:
 		break;
 	case REG_REQ_IGNORE:
-	case REG_REQ_USER_HINT_HANDLED:
 		reg_free_request(driver_request);
 		return treatment;
 	case REG_REQ_INTERSECT:
@@ -2047,7 +2028,6 @@ reg_process_hint_country_ie(struct wiphy *wiphy,
 	case REG_REQ_OK:
 		break;
 	case REG_REQ_IGNORE:
-	case REG_REQ_USER_HINT_HANDLED:
 		/* fall through */
 	case REG_REQ_ALREADY_SET:
 		reg_free_request(country_ie_request);
@@ -2086,8 +2066,7 @@ static void reg_process_hint(struct regulatory_request *reg_request)
 	case NL80211_REGDOM_SET_BY_USER:
 		treatment = reg_process_hint_user(reg_request);
 		if (treatment == REG_REQ_IGNORE ||
-		    treatment == REG_REQ_ALREADY_SET ||
-		    treatment == REG_REQ_USER_HINT_HANDLED)
+		    treatment == REG_REQ_ALREADY_SET)
 			return;
 		queue_delayed_work(system_power_efficient_wq,
 				   &reg_timeout, msecs_to_jiffies(3142));
@@ -2311,16 +2290,9 @@ int regulatory_hint_user(const char *alpha2,
 
 int regulatory_hint_indoor_user(void)
 {
-	struct regulatory_request *request;
 
-	request = kzalloc(sizeof(struct regulatory_request), GFP_KERNEL);
-	if (!request)
-		return -ENOMEM;
 
-	request->wiphy_idx = WIPHY_IDX_INVALID;
-	request->initiator = NL80211_REGDOM_SET_BY_USER;
-	request->user_reg_hint_type = NL80211_USER_REG_HINT_INDOOR;
-	queue_regulatory_request(request);
+	reg_is_indoor = true;
 
 	return 0;
 }
-- 
1.8.3.2

