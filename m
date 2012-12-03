Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:40969 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753567Ab2LCRmu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Dec 2012 12:42:50 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 1/8] regulatory: clean up reg_copy_regd()
Date: Mon,  3 Dec 2012 18:43:06 +0100
Message-Id: <1354556593-2363-2-git-send-email-johannes@sipsolutions.net> (sfid-20121203_184257_742431_02862755)
In-Reply-To: <1354556593-2363-1-git-send-email-johannes@sipsolutions.net>
References: <1354556593-2363-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Use ERR_PTR/IS_ERR to return the result or errors
and fix the allocation to not allocate too much.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/reg.c | 51 +++++++++++++++++++++++++--------------------------
 1 file changed, 25 insertions(+), 26 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index b6c7ea6..e71055b 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -312,19 +312,20 @@ static bool is_user_regdom_saved(void)
 	return true;
 }
 
-static int reg_copy_regd(const struct ieee80211_regdomain **dst_regd,
-			 const struct ieee80211_regdomain *src_regd)
+static const struct ieee80211_regdomain *
+reg_copy_regd(const struct ieee80211_regdomain *src_regd)
 {
 	struct ieee80211_regdomain *regd;
-	int size_of_regd = 0;
+	int size_of_regd;
 	unsigned int i;
 
-	size_of_regd = sizeof(struct ieee80211_regdomain) +
-	  ((src_regd->n_reg_rules + 1) * sizeof(struct ieee80211_reg_rule));
+	size_of_regd =
+		sizeof(struct ieee80211_regdomain) +
+		(src_regd->n_reg_rules * sizeof(struct ieee80211_reg_rule));
 
 	regd = kzalloc(size_of_regd, GFP_KERNEL);
 	if (!regd)
-		return -ENOMEM;
+		return ERR_PTR(-ENOMEM);
 
 	memcpy(regd, src_regd, sizeof(struct ieee80211_regdomain));
 
@@ -332,8 +333,7 @@ static int reg_copy_regd(const struct ieee80211_regdomain **dst_regd,
 		memcpy(&regd->reg_rules[i], &src_regd->reg_rules[i],
 			sizeof(struct ieee80211_reg_rule));
 
-	*dst_regd = regd;
-	return 0;
+	return regd;
 }
 
 #ifdef CONFIG_CFG80211_INTERNAL_REGDB
@@ -348,9 +348,8 @@ static DEFINE_MUTEX(reg_regdb_search_mutex);
 static void reg_regdb_search(struct work_struct *work)
 {
 	struct reg_regdb_search_request *request;
-	const struct ieee80211_regdomain *curdom, *regdom;
+	const struct ieee80211_regdomain *curdom, *regdom = NULL;
 	int i, r;
-	bool set_reg = false;
 
 	mutex_lock(&cfg80211_mutex);
 
@@ -365,10 +364,7 @@ static void reg_regdb_search(struct work_struct *work)
 			curdom = reg_regdb[i];
 
 			if (!memcmp(request->alpha2, curdom->alpha2, 2)) {
-				r = reg_copy_regd(&regdom, curdom);
-				if (r)
-					break;
-				set_reg = true;
+				regdom = reg_copy_regd(curdom);
 				break;
 			}
 		}
@@ -377,7 +373,7 @@ static void reg_regdb_search(struct work_struct *work)
 	}
 	mutex_unlock(&reg_regdb_search_mutex);
 
-	if (set_reg)
+	if (!IS_ERR_OR_NULL(regdom))
 		set_regdom(regdom);
 
 	mutex_unlock(&cfg80211_mutex);
@@ -1517,6 +1513,7 @@ static void reg_set_request_processed(void)
 static int __regulatory_hint(struct wiphy *wiphy,
 			     struct regulatory_request *pending_request)
 {
+	const struct ieee80211_regdomain *regd;
 	bool intersect = false;
 	int r = 0;
 
@@ -1527,11 +1524,12 @@ static int __regulatory_hint(struct wiphy *wiphy,
 	if (r == REG_INTERSECT) {
 		if (pending_request->initiator ==
 		    NL80211_REGDOM_SET_BY_DRIVER) {
-			r = reg_copy_regd(&wiphy->regd, cfg80211_regdomain);
-			if (r) {
+			regd = reg_copy_regd(cfg80211_regdomain);
+			if (IS_ERR(regd)) {
 				kfree(pending_request);
-				return r;
+				return PTR_ERR(regd);
 			}
+			wiphy->regd = regd;
 		}
 		intersect = true;
 	} else if (r) {
@@ -1543,12 +1541,13 @@ static int __regulatory_hint(struct wiphy *wiphy,
 		if (r == -EALREADY &&
 		    pending_request->initiator ==
 		    NL80211_REGDOM_SET_BY_DRIVER) {
-			r = reg_copy_regd(&wiphy->regd, cfg80211_regdomain);
-			if (r) {
+			regd = reg_copy_regd(cfg80211_regdomain);
+			if (IS_ERR(regd)) {
 				kfree(pending_request);
-				return r;
+				return PTR_ERR(regd);
 			}
 			r = -EALREADY;
+			wiphy->regd = regd;
 			goto new_request;
 		}
 		kfree(pending_request);
@@ -2208,6 +2207,7 @@ static void print_regdomain_info(const struct ieee80211_regdomain *rd)
 /* Takes ownership of rd only if it doesn't fail */
 static int __set_regdom(const struct ieee80211_regdomain *rd)
 {
+	const struct ieee80211_regdomain *regd;
 	const struct ieee80211_regdomain *intersected_rd = NULL;
 	struct wiphy *request_wiphy;
 	/* Some basic sanity checks first */
@@ -2265,8 +2265,6 @@ static int __set_regdom(const struct ieee80211_regdomain *rd)
 	}
 
 	if (!last_request->intersect) {
-		int r;
-
 		if (last_request->initiator != NL80211_REGDOM_SET_BY_DRIVER) {
 			reset_regdomains(false);
 			cfg80211_regdomain = rd;
@@ -2285,10 +2283,11 @@ static int __set_regdom(const struct ieee80211_regdomain *rd)
 		if (request_wiphy->regd)
 			return -EALREADY;
 
-		r = reg_copy_regd(&request_wiphy->regd, rd);
-		if (r)
-			return r;
+		regd = reg_copy_regd(rd);
+		if (IS_ERR(regd))
+			return PTR_ERR(regd);
 
+		request_wiphy->regd = regd;
 		reset_regdomains(false);
 		cfg80211_regdomain = rd;
 		return 0;
-- 
1.8.0

