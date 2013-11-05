Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f45.google.com ([209.85.214.45]:40989 "EHLO
	mail-bk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755218Ab3KERRZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Nov 2013 12:17:25 -0500
Received: by mail-bk0-f45.google.com with SMTP id r7so3088201bkg.32
        for <linux-wireless@vger.kernel.org>; Tue, 05 Nov 2013 09:17:24 -0800 (PST)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 06/19] cfg80211: process user regulatory requests on its own
Date: Tue,  5 Nov 2013 09:18:04 -0800
Message-Id: <1383671897-7746-7-git-send-email-mcgrof@do-not-panic.com> (sfid-20131105_181728_573742_AF6F79C8)
In-Reply-To: <1383671897-7746-1-git-send-email-mcgrof@do-not-panic.com>
References: <1383671897-7746-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This makes the code path easier to read and lets us
split out some functionality that is only user specific,
that makes it easier to read the other types of requests.

Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 net/wireless/reg.c | 114 +++++++++++++++++++++++++++++++++++++----------------
 1 file changed, 81 insertions(+), 33 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index d242af0..ed893ab 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -1337,6 +1337,7 @@ get_reg_request_treatment(struct wiphy *wiphy,
 
 	switch (pending_request->initiator) {
 	case NL80211_REGDOM_SET_BY_CORE:
+	case NL80211_REGDOM_SET_BY_USER:
 		return REG_REQ_IGNORE;
 	case NL80211_REGDOM_SET_BY_COUNTRY_IE:
 		if (reg_request_cell_base(lr)) {
@@ -1388,36 +1389,6 @@ get_reg_request_treatment(struct wiphy *wiphy,
 			return REG_REQ_ALREADY_SET;
 
 		return REG_REQ_INTERSECT;
-	case NL80211_REGDOM_SET_BY_USER:
-		if (reg_request_cell_base(pending_request))
-			return reg_ignore_cell_hint(pending_request);
-
-		if (reg_request_cell_base(lr))
-			return REG_REQ_IGNORE;
-
-		if (lr->initiator == NL80211_REGDOM_SET_BY_COUNTRY_IE)
-			return REG_REQ_INTERSECT;
-		/*
-		 * If the user knows better the user should set the regdom
-		 * to their country before the IE is picked up
-		 */
-		if (lr->initiator == NL80211_REGDOM_SET_BY_USER &&
-		    lr->intersect)
-			return REG_REQ_IGNORE;
-		/*
-		 * Process user requests only after previous user/driver/core
-		 * requests have been processed
-		 */
-		if ((lr->initiator == NL80211_REGDOM_SET_BY_CORE ||
-		     lr->initiator == NL80211_REGDOM_SET_BY_DRIVER ||
-		     lr->initiator == NL80211_REGDOM_SET_BY_USER) &&
-		    regdom_changes(lr->alpha2))
-			return REG_REQ_IGNORE;
-
-		if (!regdom_changes(pending_request->alpha2))
-			return REG_REQ_ALREADY_SET;
-
-		return REG_REQ_OK;
 	}
 
 	return REG_REQ_IGNORE;
@@ -1469,6 +1440,80 @@ reg_process_hint_core(struct regulatory_request *core_request)
 	return REG_REQ_OK;
 }
 
+static enum reg_request_treatment
+__reg_process_hint_user(struct regulatory_request *user_request)
+{
+	struct regulatory_request *lr = get_last_request();
+
+	if (reg_request_cell_base(user_request))
+		return reg_ignore_cell_hint(user_request);
+
+	if (reg_request_cell_base(lr))
+		return REG_REQ_IGNORE;
+
+	if (lr->initiator == NL80211_REGDOM_SET_BY_COUNTRY_IE)
+		return REG_REQ_INTERSECT;
+	/*
+	 * If the user knows better the user should set the regdom
+	 * to their country before the IE is picked up
+	 */
+	if (lr->initiator == NL80211_REGDOM_SET_BY_USER &&
+	    lr->intersect)
+		return REG_REQ_IGNORE;
+	/*
+	 * Process user requests only after previous user/driver/core
+	 * requests have been processed
+	 */
+	if ((lr->initiator == NL80211_REGDOM_SET_BY_CORE ||
+	     lr->initiator == NL80211_REGDOM_SET_BY_DRIVER ||
+	     lr->initiator == NL80211_REGDOM_SET_BY_USER) &&
+	    regdom_changes(lr->alpha2))
+		return REG_REQ_IGNORE;
+
+	if (!regdom_changes(user_request->alpha2))
+		return REG_REQ_ALREADY_SET;
+
+	return REG_REQ_OK;
+}
+
+/**
+ * reg_process_hint_user - process user regulatory requests
+ * @user_request: a pending user regulatory request
+ *
+ * The wireless subsystem can use this function to process
+ * a regulatory request initiated by userspace.
+ *
+ * Returns one of the different reg request treatment values.
+ */
+static enum reg_request_treatment
+reg_process_hint_user(struct regulatory_request *user_request)
+{
+	enum reg_request_treatment treatment;
+	struct regulatory_request *lr;
+
+	treatment = __reg_process_hint_user(user_request);
+	if (treatment == REG_REQ_IGNORE ||
+	    treatment == REG_REQ_ALREADY_SET) {
+		kfree(user_request);
+		return treatment;
+	}
+
+	lr = get_last_request();
+	if (lr != &core_request_world && lr)
+		kfree_rcu(lr, rcu_head);
+
+	user_request->intersect = treatment == REG_REQ_INTERSECT;
+	user_request->processed = false;
+	rcu_assign_pointer(last_request, user_request);
+
+	user_alpha2[0] = user_request->alpha2[0];
+	user_alpha2[1] = user_request->alpha2[1];
+
+	if (call_crda(user_request->alpha2))
+		return REG_REQ_IGNORE;
+	return REG_REQ_OK;
+}
+
 /**
  * __regulatory_hint - hint to the wireless core a regulatory domain
  * @wiphy: if the hint comes from country information from an AP, this
@@ -1585,6 +1630,12 @@ static void reg_process_hint(struct regulatory_request *reg_request)
 		reg_process_hint_core(reg_request);
 		return;
 	case NL80211_REGDOM_SET_BY_USER:
+		treatment = reg_process_hint_user(reg_request);
+		if (treatment == REG_REQ_OK ||
+		    treatment == REG_REQ_ALREADY_SET)
+			return;
+		schedule_delayed_work(&reg_timeout, msecs_to_jiffies(3142));
+		return;
 	case NL80211_REGDOM_SET_BY_DRIVER:
 	case NL80211_REGDOM_SET_BY_COUNTRY_IE:
 		treatment = __regulatory_hint(wiphy, reg_request);
@@ -1598,9 +1649,6 @@ static void reg_process_hint(struct regulatory_request *reg_request)
 			wiphy_update_regulatory(wiphy, reg_request->initiator);
 		break;
 	default:
-		if (reg_request->initiator == NL80211_REGDOM_SET_BY_USER)
-			schedule_delayed_work(&reg_timeout,
-					      msecs_to_jiffies(3142));
 		break;
 	}
 }
-- 
1.8.4.rc3

