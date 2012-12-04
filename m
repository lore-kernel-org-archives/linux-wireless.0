Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44570 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751731Ab2LDOsk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Dec 2012 09:48:40 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [RFC v2 07/18] regulatory: use proper enum for return values
Date: Tue,  4 Dec 2012 15:48:49 +0100
Message-Id: <1354632540-21207-8-git-send-email-johannes@sipsolutions.net> (sfid-20121204_154904_206564_1112667F)
In-Reply-To: <1354632540-21207-1-git-send-email-johannes@sipsolutions.net>
References: <1354632540-21207-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Instead of treating special error codes specially,
like -EALREADY, introduce a real enum for all the
needed possibilities and use it.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/reg.c | 133 +++++++++++++++++++++++++++--------------------------
 1 file changed, 69 insertions(+), 64 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index be6b00c..dc0ddca 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -65,6 +65,13 @@
 #define REG_DBG_PRINT(args...)
 #endif
 
+enum reg_request_treatment {
+	REG_REQ_OK,
+	REG_REQ_IGNORE,
+	REG_REQ_INTERSECT,
+	REG_REQ_ALREADY_SET,
+};
+
 static struct regulatory_request core_request_world = {
 	.initiator = NL80211_REGDOM_SET_BY_CORE,
 	.alpha2[0] = '0',
@@ -934,16 +941,17 @@ bool reg_last_request_cell_base(void)
 
 #ifdef CONFIG_CFG80211_CERTIFICATION_ONUS
 /* Core specific check */
-static int reg_ignore_cell_hint(struct regulatory_request *pending_request)
+static enum reg_request_treatment
+reg_ignore_cell_hint(struct regulatory_request *pending_request)
 {
 	if (!reg_num_devs_support_basehint)
-		return -EOPNOTSUPP;
+		return REG_REQ_IGNORE;
 
 	if (reg_request_cell_base(last_request) &&
 	    !regdom_changes(pending_request->alpha2))
-		return -EALREADY;
+		return REG_REQ_ALREADY_SET;
 
-	return 0;
+	return REG_REQ_OK;
 }
 
 /* Device specific check */
@@ -954,7 +962,7 @@ static bool reg_dev_ignore_cell_hint(struct wiphy *wiphy)
 #else
 static int reg_ignore_cell_hint(struct regulatory_request *pending_request)
 {
-	return -EOPNOTSUPP;
+	return REG_REQ_IGNORE;
 }
 
 static bool reg_dev_ignore_cell_hint(struct wiphy *wiphy)
@@ -1317,15 +1325,10 @@ void wiphy_apply_custom_regulatory(struct wiphy *wiphy,
 }
 EXPORT_SYMBOL(wiphy_apply_custom_regulatory);
 
-/*
- * Return value which can be used by ignore_request() to indicate
- * it has been determined we should intersect two regulatory domains
- */
-#define REG_INTERSECT	1
-
 /* This has the logic which determines when a new request
  * should be ignored. */
-static int ignore_request(struct wiphy *wiphy,
+static enum reg_request_treatment
+get_reg_request_treatment(struct wiphy *wiphy,
 			  struct regulatory_request *pending_request)
 {
 	struct wiphy *last_wiphy = NULL;
@@ -1334,17 +1337,17 @@ static int ignore_request(struct wiphy *wiphy,
 
 	/* All initial requests are respected */
 	if (!last_request)
-		return 0;
+		return REG_REQ_OK;
 
 	switch (pending_request->initiator) {
 	case NL80211_REGDOM_SET_BY_CORE:
-		return 0;
+		return REG_REQ_OK;
 	case NL80211_REGDOM_SET_BY_COUNTRY_IE:
 		if (reg_request_cell_base(last_request)) {
 			/* Trust a Cell base station over the AP's country IE */
 			if (regdom_changes(pending_request->alpha2))
-				return -EOPNOTSUPP;
-			return -EALREADY;
+				return REG_REQ_IGNORE;
+			return REG_REQ_ALREADY_SET;
 		}
 
 		last_wiphy = wiphy_idx_to_wiphy(last_request->wiphy_idx);
@@ -1361,23 +1364,23 @@ static int ignore_request(struct wiphy *wiphy,
 				 * to be correct. Reject second one for now.
 				 */
 				if (regdom_changes(pending_request->alpha2))
-					return -EOPNOTSUPP;
-				return -EALREADY;
+					return REG_REQ_IGNORE;
+				return REG_REQ_ALREADY_SET;
 			}
 			/*
 			 * Two consecutive Country IE hints on the same wiphy.
 			 * This should be picked up early by the driver/stack
 			 */
 			if (WARN_ON(regdom_changes(pending_request->alpha2)))
-				return 0;
-			return -EALREADY;
+				return REG_REQ_OK;
+			return REG_REQ_ALREADY_SET;
 		}
 		return 0;
 	case NL80211_REGDOM_SET_BY_DRIVER:
 		if (last_request->initiator == NL80211_REGDOM_SET_BY_CORE) {
 			if (regdom_changes(pending_request->alpha2))
-				return 0;
-			return -EALREADY;
+				return REG_REQ_OK;
+			return REG_REQ_ALREADY_SET;
 		}
 
 		/*
@@ -1387,25 +1390,25 @@ static int ignore_request(struct wiphy *wiphy,
 		 */
 		if (last_request->initiator == NL80211_REGDOM_SET_BY_DRIVER &&
 		    !regdom_changes(pending_request->alpha2))
-			return -EALREADY;
+			return REG_REQ_ALREADY_SET;
 
-		return REG_INTERSECT;
+		return REG_REQ_INTERSECT;
 	case NL80211_REGDOM_SET_BY_USER:
 		if (reg_request_cell_base(pending_request))
 			return reg_ignore_cell_hint(pending_request);
 
 		if (reg_request_cell_base(last_request))
-			return -EOPNOTSUPP;
+			return REG_REQ_IGNORE;
 
 		if (last_request->initiator == NL80211_REGDOM_SET_BY_COUNTRY_IE)
-			return REG_INTERSECT;
+			return REG_REQ_INTERSECT;
 		/*
 		 * If the user knows better the user should set the regdom
 		 * to their country before the IE is picked up
 		 */
 		if (last_request->initiator == NL80211_REGDOM_SET_BY_USER &&
 		    last_request->intersect)
-			return -EOPNOTSUPP;
+			return REG_REQ_IGNORE;
 		/*
 		 * Process user requests only after previous user/driver/core
 		 * requests have been processed
@@ -1414,15 +1417,15 @@ static int ignore_request(struct wiphy *wiphy,
 		     last_request->initiator == NL80211_REGDOM_SET_BY_DRIVER ||
 		     last_request->initiator == NL80211_REGDOM_SET_BY_USER) &&
 		    regdom_changes(last_request->alpha2))
-			return -EAGAIN;
+			return REG_REQ_IGNORE;
 
 		if (!regdom_changes(pending_request->alpha2))
-			return -EALREADY;
+			return REG_REQ_ALREADY_SET;
 
-		return 0;
+		return REG_REQ_OK;
 	}
 
-	return -EINVAL;
+	return REG_REQ_IGNORE;
 }
 
 static void reg_set_request_processed(void)
@@ -1452,23 +1455,24 @@ static void reg_set_request_processed(void)
  * The Wireless subsystem can use this function to hint to the wireless core
  * what it believes should be the current regulatory domain.
  *
- * Returns zero if all went fine, %-EALREADY if a regulatory domain had
- * already been set or other standard error codes.
+ * Returns one of the different reg request treatment values.
  *
  * Caller must hold &cfg80211_mutex and &reg_mutex
  */
-static int __regulatory_hint(struct wiphy *wiphy,
-			     struct regulatory_request *pending_request)
+static enum reg_request_treatment
+__regulatory_hint(struct wiphy *wiphy,
+		  struct regulatory_request *pending_request)
 {
 	const struct ieee80211_regdomain *regd;
 	bool intersect = false;
-	int r = 0;
+	enum reg_request_treatment treatment;
 
 	assert_cfg80211_lock();
 
-	r = ignore_request(wiphy, pending_request);
+	treatment = get_reg_request_treatment(wiphy, pending_request);
 
-	if (r == REG_INTERSECT) {
+	switch (treatment) {
+	case REG_REQ_INTERSECT:
 		if (pending_request->initiator ==
 		    NL80211_REGDOM_SET_BY_DRIVER) {
 			regd = reg_copy_regd(cfg80211_regdomain);
@@ -1479,26 +1483,28 @@ static int __regulatory_hint(struct wiphy *wiphy,
 			wiphy->regd = regd;
 		}
 		intersect = true;
-	} else if (r) {
+		break;
+	case REG_REQ_OK:
+		break;
+	default:
 		/*
 		 * If the regulatory domain being requested by the
 		 * driver has already been set just copy it to the
 		 * wiphy
 		 */
-		if (r == -EALREADY &&
-		    pending_request->initiator ==
-		    NL80211_REGDOM_SET_BY_DRIVER) {
+		if (treatment == REG_REQ_ALREADY_SET &&
+		    pending_request->initiator == NL80211_REGDOM_SET_BY_DRIVER) {
 			regd = reg_copy_regd(cfg80211_regdomain);
 			if (IS_ERR(regd)) {
 				kfree(pending_request);
-				return PTR_ERR(regd);
+				return REG_REQ_IGNORE;
 			}
-			r = -EALREADY;
+			treatment = REG_REQ_ALREADY_SET;
 			wiphy->regd = regd;
 			goto new_request;
 		}
 		kfree(pending_request);
-		return r;
+		return treatment;
 	}
 
 new_request:
@@ -1515,28 +1521,29 @@ new_request:
 		user_alpha2[1] = last_request->alpha2[1];
 	}
 
-	/* When r == REG_INTERSECT we do need to call CRDA */
-	if (r < 0) {
+	/* When r == REG_REQ_INTERSECT we do need to call CRDA */
+	if (treatment != REG_REQ_OK && treatment != REG_REQ_INTERSECT) {
 		/*
 		 * Since CRDA will not be called in this case as we already
 		 * have applied the requested regulatory domain before we just
 		 * inform userspace we have processed the request
 		 */
-		if (r == -EALREADY) {
+		if (treatment == REG_REQ_ALREADY_SET) {
 			nl80211_send_reg_change_event(last_request);
 			reg_set_request_processed();
 		}
-		return r;
+		return treatment;
 	}
 
-	return call_crda(last_request->alpha2);
+	if (call_crda(last_request->alpha2))
+		return REG_REQ_IGNORE;
+	return REG_REQ_OK;
 }
 
 /* This processes *all* regulatory hints */
 static void reg_process_hint(struct regulatory_request *reg_request,
 			     enum nl80211_reg_initiator reg_initiator)
 {
-	int r = 0;
 	struct wiphy *wiphy = NULL;
 
 	BUG_ON(!reg_request->alpha2);
@@ -1549,20 +1556,18 @@ static void reg_process_hint(struct regulatory_request *reg_request,
 		return;
 	}
 
-	r = __regulatory_hint(wiphy, reg_request);
-	/* This is required so that the orig_* parameters are saved */
-	if (r == -EALREADY && wiphy &&
-	    wiphy->flags & WIPHY_FLAG_STRICT_REGULATORY) {
-		wiphy_update_regulatory(wiphy, reg_initiator);
-		return;
+	switch (__regulatory_hint(wiphy, reg_request)) {
+	case REG_REQ_ALREADY_SET:
+		/* This is required so that the orig_* parameters are saved */
+		if (wiphy && wiphy->flags & WIPHY_FLAG_STRICT_REGULATORY)
+			wiphy_update_regulatory(wiphy, reg_initiator);
+		break;
+	default:
+		if (reg_initiator == NL80211_REGDOM_SET_BY_USER)
+			schedule_delayed_work(&reg_timeout,
+					      msecs_to_jiffies(3142));
+		break;
 	}
-
-	/*
-	 * We only time out user hints, given that they should be the only
-	 * source of bogus requests.
-	 */
-	if (r != -EALREADY && reg_initiator == NL80211_REGDOM_SET_BY_USER)
-		schedule_delayed_work(&reg_timeout, msecs_to_jiffies(3142));
 }
 
 /*
-- 
1.8.0

