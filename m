Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:37501 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752270AbbJOJrD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Oct 2015 05:47:03 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 3/6] cfg80211: reg: search built-in database directly
Date: Thu, 15 Oct 2015 11:46:55 +0200
Message-Id: <1444902418-25668-3-git-send-email-johannes@sipsolutions.net> (sfid-20151015_114713_547758_A9569403)
In-Reply-To: <1444902418-25668-1-git-send-email-johannes@sipsolutions.net>
References: <1444902418-25668-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Instead of searching the built-in database only in the worker,
search it directly and return an error if the entry cannot be
found (or memory cannot be allocated.) This means that builtin
database queries no longer rely on the timeout.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/reg.c | 102 ++++++++++++++++++++++++++++++-----------------------
 1 file changed, 58 insertions(+), 44 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index c63a13185905..6ad01b264eb0 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -453,65 +453,70 @@ reg_copy_regd(const struct ieee80211_regdomain *src_regd)
 }
 
 #ifdef CONFIG_CFG80211_INTERNAL_REGDB
-struct reg_regdb_search_request {
-	char alpha2[2];
+struct reg_regdb_apply_request {
 	struct list_head list;
+	const struct ieee80211_regdomain *regdom;
 };
 
-static LIST_HEAD(reg_regdb_search_list);
-static DEFINE_MUTEX(reg_regdb_search_mutex);
+static LIST_HEAD(reg_regdb_apply_list);
+static DEFINE_MUTEX(reg_regdb_apply_mutex);
 
-static void reg_regdb_search(struct work_struct *work)
+static void reg_regdb_apply(struct work_struct *work)
 {
-	struct reg_regdb_search_request *request;
-	const struct ieee80211_regdomain *curdom, *regdom = NULL;
-	int i;
+	struct reg_regdb_apply_request *request;
 
 	rtnl_lock();
 
-	mutex_lock(&reg_regdb_search_mutex);
-	while (!list_empty(&reg_regdb_search_list)) {
-		request = list_first_entry(&reg_regdb_search_list,
-					   struct reg_regdb_search_request,
+	mutex_lock(&reg_regdb_apply_mutex);
+	while (!list_empty(&reg_regdb_apply_list)) {
+		request = list_first_entry(&reg_regdb_apply_list,
+					   struct reg_regdb_apply_request,
 					   list);
 		list_del(&request->list);
 
-		for (i = 0; i < reg_regdb_size; i++) {
-			curdom = reg_regdb[i];
-
-			if (alpha2_equal(request->alpha2, curdom->alpha2)) {
-				regdom = reg_copy_regd(curdom);
-				break;
-			}
-		}
-
+		set_regdom(request->regdom, REGD_SOURCE_INTERNAL_DB);
 		kfree(request);
 	}
-	mutex_unlock(&reg_regdb_search_mutex);
-
-	if (!IS_ERR_OR_NULL(regdom))
-		set_regdom(regdom, REGD_SOURCE_INTERNAL_DB);
+	mutex_unlock(&reg_regdb_apply_mutex);
 
 	rtnl_unlock();
 }
 
-static DECLARE_WORK(reg_regdb_work, reg_regdb_search);
+static DECLARE_WORK(reg_regdb_work, reg_regdb_apply);
 
-static void reg_regdb_query(const char *alpha2)
+static int reg_regdb_query(const char *alpha2)
 {
-	struct reg_regdb_search_request *request;
+	const struct ieee80211_regdomain *regdom = NULL;
+	struct reg_regdb_apply_request *request;
+	unsigned int i;
+
+	for (i = 0; i < reg_regdb_size; i++) {
+		if (alpha2_equal(alpha2, reg_regdb[i]->alpha2)) {
+			regdom = reg_regdb[i];
+			break;
+		}
+	}
+
+	if (!regdom)
+		return -ENODATA;
 
-	request = kzalloc(sizeof(struct reg_regdb_search_request), GFP_KERNEL);
+	request = kzalloc(sizeof(struct reg_regdb_apply_request), GFP_KERNEL);
 	if (!request)
-		return;
+		return -ENOMEM;
 
-	memcpy(request->alpha2, alpha2, 2);
+	request->regdom = reg_copy_regd(regdom);
+	if (IS_ERR_OR_NULL(request->regdom)) {
+		kfree(request);
+		return -ENOMEM;
+	}
 
-	mutex_lock(&reg_regdb_search_mutex);
-	list_add_tail(&request->list, &reg_regdb_search_list);
-	mutex_unlock(&reg_regdb_search_mutex);
+	mutex_lock(&reg_regdb_apply_mutex);
+	list_add_tail(&request->list, &reg_regdb_apply_list);
+	mutex_unlock(&reg_regdb_apply_mutex);
 
 	schedule_work(&reg_regdb_work);
+
+	return 0;
 }
 
 /* Feel free to add any other sanity checks here */
@@ -522,7 +527,10 @@ static void reg_regdb_size_check(void)
 }
 #else
 static inline void reg_regdb_size_check(void) {}
-static inline void reg_regdb_query(const char *alpha2) {}
+static inline int reg_regdb_query(const char *alpha2)
+{
+	return -ENODATA;
+}
 #endif /* CONFIG_CFG80211_INTERNAL_REGDB */
 
 /*
@@ -533,13 +541,11 @@ static int call_crda(const char *alpha2)
 {
 	char country[12];
 	char *env[] = { country, NULL };
+	int ret;
 
 	snprintf(country, sizeof(country), "COUNTRY=%c%c",
 		 alpha2[0], alpha2[1]);
 
-	/* query internal regulatory database (if it exists) */
-	reg_regdb_query(alpha2);
-
 	if (reg_crda_timeouts > REG_MAX_CRDA_TIMEOUTS) {
 		pr_debug("Exceeded CRDA call max attempts. Not calling CRDA\n");
 		return -EINVAL;
@@ -551,18 +557,26 @@ static int call_crda(const char *alpha2)
 	else
 		pr_debug("Calling CRDA to update world regulatory domain\n");
 
-	return kobject_uevent_env(&reg_pdev->dev.kobj, KOBJ_CHANGE, env);
+	ret = kobject_uevent_env(&reg_pdev->dev.kobj, KOBJ_CHANGE, env);
+	if (ret)
+		return ret;
+
+	queue_delayed_work(system_power_efficient_wq,
+			   &reg_timeout, msecs_to_jiffies(3142));
+	return 0;
 }
 
 static enum reg_request_treatment
 reg_query_database(struct regulatory_request *request)
 {
-	if (call_crda(request->alpha2))
-		return REG_REQ_IGNORE;
+	/* query internal regulatory database (if it exists) */
+	if (reg_regdb_query(request->alpha2) == 0)
+		return REG_REQ_OK;
 
-	queue_delayed_work(system_power_efficient_wq,
-			   &reg_timeout, msecs_to_jiffies(3142));
-	return REG_REQ_OK;
+	if (call_crda(request->alpha2) == 0)
+		return REG_REQ_OK;
+
+	return REG_REQ_IGNORE;
 }
 
 bool reg_is_valid_request(const char *alpha2)
-- 
2.5.1

