Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:53795 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755218Ab3KERR1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Nov 2013 12:17:27 -0500
Received: by mail-bk0-f46.google.com with SMTP id e11so1357848bkh.33
        for <linux-wireless@vger.kernel.org>; Tue, 05 Nov 2013 09:17:26 -0800 (PST)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 07/19] cfg80211: process driver regulatory requests on its own
Date: Tue,  5 Nov 2013 09:18:05 -0800
Message-Id: <1383671897-7746-8-git-send-email-mcgrof@do-not-panic.com> (sfid-20131105_181730_186062_8C77FA7E)
In-Reply-To: <1383671897-7746-1-git-send-email-mcgrof@do-not-panic.com>
References: <1383671897-7746-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This makes the code easier to read and follow.

Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 net/wireless/reg.c | 103 ++++++++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 86 insertions(+), 17 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index ed893ab..bf2ef37 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -1338,6 +1338,7 @@ get_reg_request_treatment(struct wiphy *wiphy,
 	switch (pending_request->initiator) {
 	case NL80211_REGDOM_SET_BY_CORE:
 	case NL80211_REGDOM_SET_BY_USER:
+	case NL80211_REGDOM_SET_BY_DRIVER:
 		return REG_REQ_IGNORE;
 	case NL80211_REGDOM_SET_BY_COUNTRY_IE:
 		if (reg_request_cell_base(lr)) {
@@ -1372,23 +1373,6 @@ get_reg_request_treatment(struct wiphy *wiphy,
 			return REG_REQ_ALREADY_SET;
 		}
 		return REG_REQ_OK;
-	case NL80211_REGDOM_SET_BY_DRIVER:
-		if (lr->initiator == NL80211_REGDOM_SET_BY_CORE) {
-			if (regdom_changes(pending_request->alpha2))
-				return REG_REQ_OK;
-			return REG_REQ_ALREADY_SET;
-		}
-
-		/*
-		 * This would happen if you unplug and plug your card
-		 * back in or if you add a new device for which the previously
-		 * loaded card also agrees on the regulatory domain.
-		 */
-		if (lr->initiator == NL80211_REGDOM_SET_BY_DRIVER &&
-		    !regdom_changes(pending_request->alpha2))
-			return REG_REQ_ALREADY_SET;
-
-		return REG_REQ_INTERSECT;
 	}
 
 	return REG_REQ_IGNORE;
@@ -1514,6 +1498,89 @@ reg_process_hint_user(struct regulatory_request *user_request)
 	return REG_REQ_OK;
 }
 
+static enum reg_request_treatment
+__reg_process_hint_driver(struct regulatory_request *driver_request)
+{
+	struct regulatory_request *lr = get_last_request();
+
+	if (lr->initiator == NL80211_REGDOM_SET_BY_CORE) {
+		if (regdom_changes(driver_request->alpha2))
+			return REG_REQ_OK;
+		return REG_REQ_ALREADY_SET;
+	}
+
+	/*
+	 * This would happen if you unplug and plug your card
+	 * back in or if you add a new device for which the previously
+	 * loaded card also agrees on the regulatory domain.
+	 */
+	if (lr->initiator == NL80211_REGDOM_SET_BY_DRIVER &&
+	    !regdom_changes(driver_request->alpha2))
+		return REG_REQ_ALREADY_SET;
+
+	return REG_REQ_INTERSECT;
+}
+
+/**
+ * reg_process_hint_driver - process driver regulatory requests
+ * @driver_request: a pending driver regulatory request
+ *
+ * The wireless subsystem can use this function to process
+ * a regulatory request issued by an 802.11 driver.
+ *
+ * Returns one of the different reg request treatment values.
+ */
+static enum reg_request_treatment
+reg_process_hint_driver(struct wiphy *wiphy,
+			struct regulatory_request *driver_request)
+{
+	const struct ieee80211_regdomain *regd;
+	enum reg_request_treatment treatment;
+	struct regulatory_request *lr;
+
+	treatment = __reg_process_hint_driver(driver_request);
+
+	switch (treatment) {
+	case REG_REQ_OK:
+		break;
+	case REG_REQ_IGNORE:
+		kfree(driver_request);
+		return treatment;
+	case REG_REQ_INTERSECT:
+		/* fall through */
+	case REG_REQ_ALREADY_SET:
+		regd = reg_copy_regd(get_cfg80211_regdom());
+		if (IS_ERR(regd)) {
+			kfree(driver_request);
+			return REG_REQ_IGNORE;
+		}
+		rcu_assign_pointer(wiphy->regd, regd);
+	}
+
+	lr = get_last_request();
+	if (lr != &core_request_world && lr)
+		kfree_rcu(lr, rcu_head);
+
+	driver_request->intersect = treatment == REG_REQ_INTERSECT;
+	driver_request->processed = false;
+	rcu_assign_pointer(last_request, driver_request);
+
+	/*
+	 * Since CRDA will not be called in this case as we already
+	 * have applied the requested regulatory domain before we just
+	 * inform userspace we have processed the request
+	 */
+	if (treatment == REG_REQ_ALREADY_SET) {
+		nl80211_send_reg_change_event(driver_request);
+		reg_set_request_processed();
+		return treatment;
+	}
+
+	if (call_crda(driver_request->alpha2))
+		return REG_REQ_IGNORE;
+	return REG_REQ_OK;
+}
+
 /**
  * __regulatory_hint - hint to the wireless core a regulatory domain
  * @wiphy: if the hint comes from country information from an AP, this
@@ -1637,6 +1704,8 @@ static void reg_process_hint(struct regulatory_request *reg_request)
 		schedule_delayed_work(&reg_timeout, msecs_to_jiffies(3142));
 		return;
 	case NL80211_REGDOM_SET_BY_DRIVER:
+		treatment = reg_process_hint_driver(wiphy, reg_request);
+		break;
 	case NL80211_REGDOM_SET_BY_COUNTRY_IE:
 		treatment = __regulatory_hint(wiphy, reg_request);
 		break;
-- 
1.8.4.rc3

