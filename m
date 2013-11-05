Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f45.google.com ([209.85.214.45]:53389 "EHLO
	mail-bk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755259Ab3KERR3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Nov 2013 12:17:29 -0500
Received: by mail-bk0-f45.google.com with SMTP id r7so3058575bkg.18
        for <linux-wireless@vger.kernel.org>; Tue, 05 Nov 2013 09:17:28 -0800 (PST)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 08/19] cfg80211: process country IE regulatory requests on their own
Date: Tue,  5 Nov 2013 09:18:06 -0800
Message-Id: <1383671897-7746-9-git-send-email-mcgrof@do-not-panic.com> (sfid-20131105_181732_406768_3A42D285)
In-Reply-To: <1383671897-7746-1-git-send-email-mcgrof@do-not-panic.com>
References: <1383671897-7746-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is the last split up of the old unified __regultory_hint()
processing set of functionality, it moves the country IE processing
all on its own. This makes it easier to follow and read what exactly
is going on for the case of processing country IEs.

Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 net/wireless/reg.c | 201 ++++++++++++++++++-----------------------------------
 1 file changed, 68 insertions(+), 133 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index bf2ef37..20e64bd 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -1322,62 +1322,6 @@ void wiphy_apply_custom_regulatory(struct wiphy *wiphy,
 }
 EXPORT_SYMBOL(wiphy_apply_custom_regulatory);
 
-/* This has the logic which determines when a new request
- * should be ignored. */
-static enum reg_request_treatment
-get_reg_request_treatment(struct wiphy *wiphy,
-			  struct regulatory_request *pending_request)
-{
-	struct wiphy *last_wiphy = NULL;
-	struct regulatory_request *lr = get_last_request();
-
-	/* All initial requests are respected */
-	if (!lr)
-		return REG_REQ_OK;
-
-	switch (pending_request->initiator) {
-	case NL80211_REGDOM_SET_BY_CORE:
-	case NL80211_REGDOM_SET_BY_USER:
-	case NL80211_REGDOM_SET_BY_DRIVER:
-		return REG_REQ_IGNORE;
-	case NL80211_REGDOM_SET_BY_COUNTRY_IE:
-		if (reg_request_cell_base(lr)) {
-			/* Trust a Cell base station over the AP's country IE */
-			if (regdom_changes(pending_request->alpha2))
-				return REG_REQ_IGNORE;
-			return REG_REQ_ALREADY_SET;
-		}
-
-		last_wiphy = wiphy_idx_to_wiphy(lr->wiphy_idx);
-
-		if (unlikely(!is_an_alpha2(pending_request->alpha2)))
-			return -EINVAL;
-		if (lr->initiator == NL80211_REGDOM_SET_BY_COUNTRY_IE) {
-			if (last_wiphy != wiphy) {
-				/*
-				 * Two cards with two APs claiming different
-				 * Country IE alpha2s. We could
-				 * intersect them, but that seems unlikely
-				 * to be correct. Reject second one for now.
-				 */
-				if (regdom_changes(pending_request->alpha2))
-					return REG_REQ_IGNORE;
-				return REG_REQ_ALREADY_SET;
-			}
-			/*
-			 * Two consecutive Country IE hints on the same wiphy.
-			 * This should be picked up early by the driver/stack
-			 */
-			if (WARN_ON(regdom_changes(pending_request->alpha2)))
-				return REG_REQ_OK;
-			return REG_REQ_ALREADY_SET;
-		}
-		return REG_REQ_OK;
-	}
-
-	return REG_REQ_IGNORE;
-}
-
 static void reg_set_request_processed(void)
 {
 	bool need_more_processing = false;
@@ -1581,96 +1525,92 @@ reg_process_hint_driver(struct wiphy *wiphy,
 	return REG_REQ_OK;
 }
 
+static enum reg_request_treatment
+__reg_process_hint_country_ie(struct wiphy *wiphy,
+			      struct regulatory_request *country_ie_request)
+{
+	struct wiphy *last_wiphy = NULL;
+	struct regulatory_request *lr = get_last_request();
+
+	if (reg_request_cell_base(lr)) {
+		/* Trust a Cell base station over the AP's country IE */
+		if (regdom_changes(country_ie_request->alpha2))
+			return REG_REQ_IGNORE;
+		return REG_REQ_ALREADY_SET;
+	}
+
+	last_wiphy = wiphy_idx_to_wiphy(lr->wiphy_idx);
+
+	if (unlikely(!is_an_alpha2(country_ie_request->alpha2)))
+		return -EINVAL;
+	if (lr->initiator == NL80211_REGDOM_SET_BY_COUNTRY_IE) {
+		if (last_wiphy != wiphy) {
+			/*
+			 * Two cards with two APs claiming different
+			 * Country IE alpha2s. We could
+			 * intersect them, but that seems unlikely
+			 * to be correct. Reject second one for now.
+			 */
+			if (regdom_changes(country_ie_request->alpha2))
+				return REG_REQ_IGNORE;
+			return REG_REQ_ALREADY_SET;
+		}
+		/*
+		 * Two consecutive Country IE hints on the same wiphy.
+		 * This should be picked up early by the driver/stack
+		 */
+		if (WARN_ON(regdom_changes(country_ie_request->alpha2)))
+			return REG_REQ_OK;
+		return REG_REQ_ALREADY_SET;
+	}
+	return REG_REQ_OK;
+}
+
 /**
- * __regulatory_hint - hint to the wireless core a regulatory domain
- * @wiphy: if the hint comes from country information from an AP, this
- *	is required to be set to the wiphy that received the information
- * @pending_request: the regulatory request currently being processed
+ * reg_process_hint_country_ie - process regulatory requests from country IEs
+ * @country_ie_request: a regulatory request from a country IE
  *
- * The Wireless subsystem can use this function to hint to the wireless core
- * what it believes should be the current regulatory domain.
+ * The wireless subsystem can use this function to process
+ * a regulatory request issued by a country Information Element.
  *
  * Returns one of the different reg request treatment values.
  */
 static enum reg_request_treatment
-__regulatory_hint(struct wiphy *wiphy,
-		  struct regulatory_request *pending_request)
+reg_process_hint_country_ie(struct wiphy *wiphy,
+			    struct regulatory_request *country_ie_request)
 {
-	const struct ieee80211_regdomain *regd;
-	bool intersect = false;
 	enum reg_request_treatment treatment;
 	struct regulatory_request *lr;
 
-	treatment = get_reg_request_treatment(wiphy, pending_request);
+	treatment = __reg_process_hint_country_ie(wiphy, country_ie_request);
 
 	switch (treatment) {
-	case REG_REQ_INTERSECT:
-		if (pending_request->initiator ==
-		    NL80211_REGDOM_SET_BY_DRIVER) {
-			regd = reg_copy_regd(get_cfg80211_regdom());
-			if (IS_ERR(regd)) {
-				kfree(pending_request);
-				return PTR_ERR(regd);
-			}
-			rcu_assign_pointer(wiphy->regd, regd);
-		}
-		intersect = true;
-		break;
 	case REG_REQ_OK:
 		break;
-	default:
+	case REG_REQ_IGNORE:
+		/* fall through */
+	case REG_REQ_ALREADY_SET:
+		kfree(country_ie_request);
+		return treatment;
+	case REG_REQ_INTERSECT:
+		kfree(country_ie_request);
 		/*
-		 * If the regulatory domain being requested by the
-		 * driver has already been set just copy it to the
-		 * wiphy
+		 * This doesn't happen yet, not sure we
+		 * ever want to support it for this case.
 		 */
-		if (treatment == REG_REQ_ALREADY_SET &&
-		    pending_request->initiator == NL80211_REGDOM_SET_BY_DRIVER) {
-			regd = reg_copy_regd(get_cfg80211_regdom());
-			if (IS_ERR(regd)) {
-				kfree(pending_request);
-				return REG_REQ_IGNORE;
-			}
-			treatment = REG_REQ_ALREADY_SET;
-			rcu_assign_pointer(wiphy->regd, regd);
-			goto new_request;
-		}
-		kfree(pending_request);
-		return treatment;
+		WARN_ONCE(1, "Unexpected intersection for country IEs");
+		return REG_REQ_IGNORE;
 	}
 
-new_request:
 	lr = get_last_request();
 	if (lr != &core_request_world && lr)
 		kfree_rcu(lr, rcu_head);
 
-	pending_request->intersect = intersect;
-	pending_request->processed = false;
-	rcu_assign_pointer(last_request, pending_request);
-	lr = pending_request;
-
-	pending_request = NULL;
+	country_ie_request->intersect = false;
+	country_ie_request->processed = false;
+	rcu_assign_pointer(last_request, country_ie_request);
 
-	if (lr->initiator == NL80211_REGDOM_SET_BY_USER) {
-		user_alpha2[0] = lr->alpha2[0];
-		user_alpha2[1] = lr->alpha2[1];
-	}
-
-	/* When r == REG_REQ_INTERSECT we do need to call CRDA */
-	if (treatment != REG_REQ_OK && treatment != REG_REQ_INTERSECT) {
-		/*
-		 * Since CRDA will not be called in this case as we already
-		 * have applied the requested regulatory domain before we just
-		 * inform userspace we have processed the request
-		 */
-		if (treatment == REG_REQ_ALREADY_SET) {
-			nl80211_send_reg_change_event(lr);
-			reg_set_request_processed();
-		}
-		return treatment;
-	}
-
-	if (call_crda(lr->alpha2))
+	if (call_crda(country_ie_request->alpha2))
 		return REG_REQ_IGNORE;
 	return REG_REQ_OK;
 }
@@ -1707,19 +1647,14 @@ static void reg_process_hint(struct regulatory_request *reg_request)
 		treatment = reg_process_hint_driver(wiphy, reg_request);
 		break;
 	case NL80211_REGDOM_SET_BY_COUNTRY_IE:
-		treatment = __regulatory_hint(wiphy, reg_request);
+		treatment = reg_process_hint_country_ie(wiphy, reg_request);
 		break;
 	}
 
-	switch (treatment) {
-	case REG_REQ_ALREADY_SET:
-		/* This is required so that the orig_* parameters are saved */
-		if (wiphy && wiphy->flags & WIPHY_FLAG_STRICT_REGULATORY)
-			wiphy_update_regulatory(wiphy, reg_request->initiator);
-		break;
-	default:
-		break;
-	}
+	/* This is required so that the orig_* parameters are saved */
+	if (treatment == REG_REQ_ALREADY_SET && wiphy &&
+	    wiphy->flags & WIPHY_FLAG_STRICT_REGULATORY)
+		wiphy_update_regulatory(wiphy, reg_request->initiator);
 }
 
 /*
-- 
1.8.4.rc3

