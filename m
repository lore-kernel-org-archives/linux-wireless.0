Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:54548 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752595AbaBYPBo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Feb 2014 10:01:44 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: mcgrof@do-not-panic.com, Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] cfg80211: regulatory: simplify uevent sending
Date: Tue, 25 Feb 2014 16:01:39 +0100
Message-Id: <1393340499-17006-1-git-send-email-johannes@sipsolutions.net> (sfid-20140225_160152_947217_A80D1D17)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

There's no need for the struct device_type with the uevent function
etc., just fill the country alpha2 when sending the event.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/reg.c | 37 ++++++++-----------------------------
 net/wireless/reg.h |  1 -
 2 files changed, 8 insertions(+), 30 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 6b6f33ad78f2..c9844d264312 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -91,10 +91,6 @@ static struct regulatory_request __rcu *last_request =
 /* To trigger userspace events */
 static struct platform_device *reg_pdev;
 
-static const struct device_type reg_device_type = {
-	.uevent = reg_device_uevent,
-};
-
 /*
  * Central wireless core regulatory domains, we only need two,
  * the current one and a world regulatory domain in case we have no
@@ -487,11 +483,16 @@ static inline void reg_regdb_query(const char *alpha2) {}
 
 /*
  * This lets us keep regulatory code which is updated on a regulatory
- * basis in userspace. Country information is filled in by
- * reg_device_uevent
+ * basis in userspace.
  */
 static int call_crda(const char *alpha2)
 {
+	char country[12];
+	char *env[] = { country, NULL };
+
+	snprintf(country, sizeof(country), "COUNTRY=%c%c",
+		 alpha2[0], alpha2[1]);
+
 	if (!is_world_regdom((char *) alpha2))
 		pr_info("Calling CRDA for country: %c%c\n",
 			alpha2[0], alpha2[1]);
@@ -501,7 +502,7 @@ static int call_crda(const char *alpha2)
 	/* query internal regulatory database (if it exists) */
 	reg_regdb_query(alpha2);
 
-	return kobject_uevent(&reg_pdev->dev.kobj, KOBJ_CHANGE);
+	return kobject_uevent_env(&reg_pdev->dev.kobj, KOBJ_CHANGE, env);
 }
 
 static enum reg_request_treatment
@@ -2544,26 +2545,6 @@ int set_regdom(const struct ieee80211_regdomain *rd)
 	return 0;
 }
 
-int reg_device_uevent(struct device *dev, struct kobj_uevent_env *env)
-{
-	struct regulatory_request *lr;
-	u8 alpha2[2];
-	bool add = false;
-
-	rcu_read_lock();
-	lr = get_last_request();
-	if (lr && !lr->processed) {
-		memcpy(alpha2, lr->alpha2, 2);
-		add = true;
-	}
-	rcu_read_unlock();
-
-	if (add)
-		return add_uevent_var(env, "COUNTRY=%c%c",
-				      alpha2[0], alpha2[1]);
-	return 0;
-}
-
 void wiphy_regulatory_register(struct wiphy *wiphy)
 {
 	struct regulatory_request *lr;
@@ -2614,8 +2595,6 @@ int __init regulatory_init(void)
 	if (IS_ERR(reg_pdev))
 		return PTR_ERR(reg_pdev);
 
-	reg_pdev->dev.type = &reg_device_type;
-
 	spin_lock_init(&reg_requests_lock);
 	spin_lock_init(&reg_pending_beacons_lock);
 
diff --git a/net/wireless/reg.h b/net/wireless/reg.h
index 18524617ab62..37c180df34b7 100644
--- a/net/wireless/reg.h
+++ b/net/wireless/reg.h
@@ -26,7 +26,6 @@ enum nl80211_dfs_regions reg_get_dfs_region(struct wiphy *wiphy);
 int regulatory_hint_user(const char *alpha2,
 			 enum nl80211_user_reg_hint_type user_reg_hint_type);
 
-int reg_device_uevent(struct device *dev, struct kobj_uevent_env *env);
 void wiphy_regulatory_register(struct wiphy *wiphy);
 void wiphy_regulatory_deregister(struct wiphy *wiphy);
 
-- 
1.8.5.3

