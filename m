Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53234 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946007Ab2LFQsI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Dec 2012 11:48:08 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 18/24] regulatory: fix reg_is_valid_request handling
Date: Thu,  6 Dec 2012 17:47:42 +0100
Message-Id: <1354812468-15709-19-git-send-email-johannes@sipsolutions.net> (sfid-20121206_174856_467409_500EEA32)
In-Reply-To: <1354812468-15709-1-git-send-email-johannes@sipsolutions.net>
References: <1354812468-15709-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

There's a bug with the world regulatory domain, it
can be updated any time which is different from all
other regdomains that can only be updated once after
a request for them. Fix this by adding a check for
"processed" to the reg_is_valid_request() function
and clear that when doing a request.

While looking at this I also found another locking
bug, last_request is protected by the reg_mutex not
the cfg80211_mutex so the code in nl80211 is racy.
Remove that code as it only tries to prevent an
allocation in an error case, which isn't necessary.
Then the function can also become static and locking
in nl80211 can have a smaller scope.

Also change __set_regdom() to do the checks earlier
and not different for world/other regdomains.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/nl80211.c |  9 ++-------
 net/wireless/reg.c     | 21 +++++++++++----------
 net/wireless/reg.h     |  1 -
 3 files changed, 13 insertions(+), 18 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 260b5d8..370cd31 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -4289,13 +4289,6 @@ static int nl80211_set_reg(struct sk_buff *skb, struct genl_info *info)
 			return -EINVAL;
 	}
 
-	mutex_lock(&cfg80211_mutex);
-
-	if (!reg_is_valid_request(alpha2)) {
-		r = -EINVAL;
-		goto bad_reg;
-	}
-
 	size_of_regd = sizeof(struct ieee80211_regdomain) +
 		       num_rules * sizeof(struct ieee80211_reg_rule);
 
@@ -4333,6 +4326,8 @@ static int nl80211_set_reg(struct sk_buff *skb, struct genl_info *info)
 		}
 	}
 
+	mutex_lock(&cfg80211_mutex);
+
 	r = set_regdom(rd);
 	rd = NULL;
 
diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index dfab71b..10d8edb 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -426,12 +426,16 @@ static int call_crda(const char *alpha2)
 	return kobject_uevent(&reg_pdev->dev.kobj, KOBJ_CHANGE);
 }
 
-/* Used by nl80211 before kmalloc'ing our regulatory domain */
-bool reg_is_valid_request(const char *alpha2)
+static bool reg_is_valid_request(const char *alpha2)
 {
+	assert_reg_lock();
+
 	if (!last_request)
 		return false;
 
+	if (last_request->processed)
+		return false;
+
 	return alpha2_equal(last_request->alpha2, alpha2);
 }
 
@@ -1471,6 +1475,7 @@ new_request:
 
 	last_request = pending_request;
 	last_request->intersect = intersect;
+	last_request->processed = false;
 
 	pending_request = NULL;
 
@@ -2061,11 +2066,13 @@ static int __set_regdom(const struct ieee80211_regdomain *rd)
 	const struct ieee80211_regdomain *regd;
 	const struct ieee80211_regdomain *intersected_rd = NULL;
 	struct wiphy *request_wiphy;
+
 	/* Some basic sanity checks first */
 
+	if (!reg_is_valid_request(rd->alpha2))
+		return -EINVAL;
+
 	if (is_world_regdom(rd->alpha2)) {
-		if (WARN_ON(!reg_is_valid_request(rd->alpha2)))
-			return -EINVAL;
 		update_world_regdomain(rd);
 		return 0;
 	}
@@ -2074,9 +2081,6 @@ static int __set_regdom(const struct ieee80211_regdomain *rd)
 	    !is_unknown_alpha2(rd->alpha2))
 		return -EINVAL;
 
-	if (!last_request)
-		return -EINVAL;
-
 	/*
 	 * Lets only bother proceeding on the same alpha2 if the current
 	 * rd is non static (it means CRDA was present and was used last)
@@ -2098,9 +2102,6 @@ static int __set_regdom(const struct ieee80211_regdomain *rd)
 	 * internal EEPROM data
 	 */
 
-	if (WARN_ON(!reg_is_valid_request(rd->alpha2)))
-		return -EINVAL;
-
 	if (!is_valid_rd(rd)) {
 		pr_err("Invalid regulatory domain detected:\n");
 		print_regdomain_info(rd);
diff --git a/net/wireless/reg.h b/net/wireless/reg.h
index 37891e8..d391b50 100644
--- a/net/wireless/reg.h
+++ b/net/wireless/reg.h
@@ -19,7 +19,6 @@
 extern const struct ieee80211_regdomain *cfg80211_regdomain;
 
 bool is_world_regdom(const char *alpha2);
-bool reg_is_valid_request(const char *alpha2);
 bool reg_supported_dfs_region(u8 dfs_region);
 
 int regulatory_hint_user(const char *alpha2,
-- 
1.8.0

