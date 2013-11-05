Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f53.google.com ([209.85.214.53]:41131 "EHLO
	mail-bk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755322Ab3KERRt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Nov 2013 12:17:49 -0500
Received: by mail-bk0-f53.google.com with SMTP id w11so3005921bkz.40
        for <linux-wireless@vger.kernel.org>; Tue, 05 Nov 2013 09:17:48 -0800 (PST)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 18/19] cfg80211: set driver regulatory updates on its own
Date: Tue,  5 Nov 2013 09:18:16 -0800
Message-Id: <1383671897-7746-19-git-send-email-mcgrof@do-not-panic.com> (sfid-20131105_181754_390988_9484065C)
In-Reply-To: <1383671897-7746-1-git-send-email-mcgrof@do-not-panic.com>
References: <1383671897-7746-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This splits up the driver regulatory update on its
own, this helps simplify the reading the case.

Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 net/wireless/reg.c | 123 ++++++++++++++++++++++++-----------------------------
 1 file changed, 56 insertions(+), 67 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index fa3bcbe..2ecb0c7 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -2229,38 +2229,19 @@ static int reg_set_rd_user(const struct ieee80211_regdomain *rd,
 	return 0;
 }
 
-/* Takes ownership of rd only if it doesn't fail */
-static int __set_regdom(const struct ieee80211_regdomain *rd,
-			struct regulatory_request *lr)
+static int reg_set_rd_driver(const struct ieee80211_regdomain *rd,
+			     struct regulatory_request *driver_request)
 {
 	const struct ieee80211_regdomain *regd;
 	const struct ieee80211_regdomain *intersected_rd = NULL;
+	const struct ieee80211_regdomain *tmp;
 	struct wiphy *request_wiphy;
 
-	if (!is_alpha2_set(rd->alpha2) && !is_an_alpha2(rd->alpha2) &&
-	    !is_unknown_alpha2(rd->alpha2))
+	if (is_world_regdom(rd->alpha2))
 		return -EINVAL;
 
-	/*
-	 * Lets only bother proceeding on the same alpha2 if the current
-	 * rd is non static (it means CRDA was present and was used last)
-	 * and the pending request came in from a country IE
-	 */
-	if (lr->initiator != NL80211_REGDOM_SET_BY_COUNTRY_IE) {
-		/*
-		 * If someone else asked us to change the rd lets only bother
-		 * checking if the alpha2 changes if CRDA was already called
-		 */
-		if (!regdom_changes(rd->alpha2))
-			return -EALREADY;
-	}
-
-	/*
-	 * Now lets set the regulatory domain, update all driver channels
-	 * and finally inform them of what we have done, in case they want
-	 * to review or adjust their own settings based on their own
-	 * internal EEPROM data
-	 */
+	if (!regdom_changes(rd->alpha2))
+		return -EALREADY;
 
 	if (!is_valid_rd(rd)) {
 		pr_err("Invalid regulatory domain detected:\n");
@@ -2268,29 +2249,13 @@ static int __set_regdom(const struct ieee80211_regdomain *rd,
 		return -EINVAL;
 	}
 
-	request_wiphy = wiphy_idx_to_wiphy(lr->wiphy_idx);
-	if (!request_wiphy &&
-	    (lr->initiator == NL80211_REGDOM_SET_BY_DRIVER ||
-	     lr->initiator == NL80211_REGDOM_SET_BY_COUNTRY_IE)) {
+	request_wiphy = wiphy_idx_to_wiphy(driver_request->wiphy_idx);
+	if (!request_wiphy) {
 		schedule_delayed_work(&reg_timeout, 0);
 		return -ENODEV;
 	}
 
-	if (!lr->intersect) {
-		if (lr->initiator != NL80211_REGDOM_SET_BY_DRIVER) {
-			reset_regdomains(false, rd);
-			return 0;
-		}
-
-		/*
-		 * For a driver hint, lets copy the regulatory domain the
-		 * driver wanted to the wiphy to deal with conflicts
-		 */
-
-		/*
-		 * Userspace could have sent two replies with only
-		 * one kernel request.
-		 */
+	if (!driver_request->intersect) {
 		if (request_wiphy->regd)
 			return -EALREADY;
 
@@ -2303,38 +2268,60 @@ static int __set_regdom(const struct ieee80211_regdomain *rd,
 		return 0;
 	}
 
-	/* Intersection requires a bit more work */
+	intersected_rd = regdom_intersect(rd, get_cfg80211_regdom());
+	if (!intersected_rd)
+		return -EINVAL;
 
-	if (lr->initiator != NL80211_REGDOM_SET_BY_COUNTRY_IE) {
-		intersected_rd = regdom_intersect(rd, get_cfg80211_regdom());
-		if (!intersected_rd)
-			return -EINVAL;
+	/*
+	 * We can trash what CRDA provided now.
+	 * However if a driver requested this specific regulatory
+	 * domain we keep it for its private use
+	 */
+	tmp = get_wiphy_regdom(request_wiphy);
+	rcu_assign_pointer(request_wiphy->regd, rd);
+	rcu_free_regdom(tmp);
 
-		/*
-		 * We can trash what CRDA provided now.
-		 * However if a driver requested this specific regulatory
-		 * domain we keep it for its private use
-		 */
-		if (lr->initiator == NL80211_REGDOM_SET_BY_DRIVER) {
-			const struct ieee80211_regdomain *tmp;
+	rd = NULL;
 
-			tmp = get_wiphy_regdom(request_wiphy);
-			rcu_assign_pointer(request_wiphy->regd, rd);
-			rcu_free_regdom(tmp);
-		} else {
-			kfree(rd);
-		}
+	reset_regdomains(false, intersected_rd);
 
-		rd = NULL;
+	return 0;
+}
+
+/* Takes ownership of rd only if it doesn't fail */
+static int __set_regdom(const struct ieee80211_regdomain *rd,
+			struct regulatory_request *lr)
+{
+	struct wiphy *request_wiphy;
 
-		reset_regdomains(false, intersected_rd);
+	if (!is_alpha2_set(rd->alpha2) && !is_an_alpha2(rd->alpha2) &&
+	    !is_unknown_alpha2(rd->alpha2))
+		return -EINVAL;
 
-		return 0;
+	/*
+	 * Lets only bother proceeding on the same alpha2 if the current
+	 * rd is non static (it means CRDA was present and was used last)
+	 * and the pending request came in from a country IE
+	 */
+
+	if (!is_valid_rd(rd)) {
+		pr_err("Invalid regulatory domain detected:\n");
+		print_regdomain_info(rd);
+		return -EINVAL;
 	}
 
-	return -EINVAL;
-}
+	request_wiphy = wiphy_idx_to_wiphy(lr->wiphy_idx);
+	if (!request_wiphy) {
+		schedule_delayed_work(&reg_timeout, 0);
+		return -ENODEV;
+	}
 
+	if (lr->intersect)
+		return -EINVAL;
+
+	reset_regdomains(false, rd);
+	return 0;
+}
 
 /*
  * Use this call to set the current regulatory domain. Conflicts with
@@ -2362,6 +2349,8 @@ int set_regdom(const struct ieee80211_regdomain *rd)
 		r = reg_set_rd_user(rd, lr);
 		break;
 	case NL80211_REGDOM_SET_BY_DRIVER:
+		r = reg_set_rd_driver(rd, lr);
+		break;
 	case NL80211_REGDOM_SET_BY_COUNTRY_IE:
 		r = __set_regdom(rd, lr);
 		break;
-- 
1.8.4.rc3

