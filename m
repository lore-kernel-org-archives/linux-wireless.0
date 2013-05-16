Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:59218 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753391Ab3EPVDq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 May 2013 17:03:46 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 7/9] regulatory: remove reg_mutex
Date: Thu, 16 May 2013 23:03:36 +0200
Message-Id: <1368738218-7597-8-git-send-email-johannes@sipsolutions.net> (sfid-20130516_230357_419755_BF830F0A)
In-Reply-To: <1368738218-7597-1-git-send-email-johannes@sipsolutions.net>
References: <1368738218-7597-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The reg_mutex is similar to the ones I just removed in
cfg80211 but even less useful since it protects global
data, and we hold the RTNL in all places (except module
unload) already.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/reg.c | 76 ++++++++++++++----------------------------------------
 1 file changed, 19 insertions(+), 57 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index a06412fb..9bd4b01 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -81,7 +81,10 @@ static struct regulatory_request core_request_world = {
 	.country_ie_env = ENVIRON_ANY,
 };
 
-/* Receipt of information from last regulatory request */
+/*
+ * Receipt of information from last regulatory request,
+ * protected by RTNL (and can be accessed with RCU protection)
+ */
 static struct regulatory_request __rcu *last_request =
 	(void __rcu *)&core_request_world;
 
@@ -96,39 +99,25 @@ static struct device_type reg_device_type = {
  * Central wireless core regulatory domains, we only need two,
  * the current one and a world regulatory domain in case we have no
  * information to give us an alpha2.
+ * (protected by RTNL, can be read under RCU)
  */
 const struct ieee80211_regdomain __rcu *cfg80211_regdomain;
 
 /*
- * Protects static reg.c components:
- *	- cfg80211_regdomain (if not used with RCU)
- *	- cfg80211_world_regdom
- *	- last_request (if not used with RCU)
- *	- reg_num_devs_support_basehint
- */
-static DEFINE_MUTEX(reg_mutex);
-
-/*
  * Number of devices that registered to the core
  * that support cellular base station regulatory hints
+ * (protected by RTNL)
  */
 static int reg_num_devs_support_basehint;
 
-static inline void assert_reg_lock(void)
-{
-	lockdep_assert_held(&reg_mutex);
-}
-
 static const struct ieee80211_regdomain *get_cfg80211_regdom(void)
 {
-	return rcu_dereference_protected(cfg80211_regdomain,
-					 lockdep_is_held(&reg_mutex));
+	return rtnl_dereference(cfg80211_regdomain);
 }
 
 static const struct ieee80211_regdomain *get_wiphy_regdom(struct wiphy *wiphy)
 {
-	return rcu_dereference_protected(wiphy->regd,
-					 lockdep_is_held(&reg_mutex));
+	return rtnl_dereference(wiphy->regd);
 }
 
 static void rcu_free_regdom(const struct ieee80211_regdomain *r)
@@ -140,8 +129,7 @@ static void rcu_free_regdom(const struct ieee80211_regdomain *r)
 
 static struct regulatory_request *get_last_request(void)
 {
-	return rcu_dereference_check(last_request,
-				     lockdep_is_held(&reg_mutex));
+	return rcu_dereference_rtnl(last_request);
 }
 
 /* Used to queue up regulatory hints */
@@ -210,6 +198,7 @@ static const struct ieee80211_regdomain world_regdom = {
 	}
 };
 
+/* protected by RTNL */
 static const struct ieee80211_regdomain *cfg80211_world_regdom =
 	&world_regdom;
 
@@ -225,7 +214,7 @@ static void reset_regdomains(bool full_reset,
 	const struct ieee80211_regdomain *r;
 	struct regulatory_request *lr;
 
-	assert_reg_lock();
+	ASSERT_RTNL();
 
 	r = get_cfg80211_regdom();
 
@@ -946,13 +935,7 @@ static bool reg_request_cell_base(struct regulatory_request *request)
 
 bool reg_last_request_cell_base(void)
 {
-	bool val;
-
-	mutex_lock(&reg_mutex);
-	val = reg_request_cell_base(get_last_request());
-	mutex_unlock(&reg_mutex);
-
-	return val;
+	return reg_request_cell_base(get_last_request());
 }
 
 #ifdef CONFIG_CFG80211_CERTIFICATION_ONUS
@@ -1454,8 +1437,6 @@ static void reg_set_request_processed(void)
  * what it believes should be the current regulatory domain.
  *
  * Returns one of the different reg request treatment values.
- *
- * Caller must hold &reg_mutex
  */
 static enum reg_request_treatment
 __regulatory_hint(struct wiphy *wiphy,
@@ -1632,10 +1613,8 @@ static void reg_process_pending_beacon_hints(void)
 static void reg_todo(struct work_struct *work)
 {
 	rtnl_lock();
-	mutex_lock(&reg_mutex);
 	reg_process_pending_hints();
 	reg_process_pending_beacon_hints();
-	mutex_unlock(&reg_mutex);
 	rtnl_unlock();
 }
 
@@ -1861,8 +1840,6 @@ static void restore_regulatory_settings(bool reset_user)
 
 	ASSERT_RTNL();
 
-	mutex_lock(&reg_mutex);
-
 	reset_regdomains(true, &world_regdom);
 	restore_alpha2(alpha2, reset_user);
 
@@ -1916,8 +1893,6 @@ static void restore_regulatory_settings(bool reset_user)
 	list_splice_tail_init(&tmp_reg_req_list, &reg_requests_list);
 	spin_unlock(&reg_requests_lock);
 
-	mutex_unlock(&reg_mutex);
-
 	REG_DBG_PRINT("Kicking the queue\n");
 
 	schedule_work(&reg_work);
@@ -2232,7 +2207,6 @@ int set_regdom(const struct ieee80211_regdomain *rd)
 	struct regulatory_request *lr;
 	int r;
 
-	mutex_lock(&reg_mutex);
 	lr = get_last_request();
 
 	/* Note that this doesn't update the wiphys, this is done below */
@@ -2242,14 +2216,12 @@ int set_regdom(const struct ieee80211_regdomain *rd)
 			reg_set_request_processed();
 
 		kfree(rd);
-		goto out;
+		return r;
 	}
 
 	/* This would make this whole thing pointless */
-	if (WARN_ON(!lr->intersect && rd != get_cfg80211_regdom())) {
-		r = -EINVAL;
-		goto out;
-	}
+	if (WARN_ON(!lr->intersect && rd != get_cfg80211_regdom()))
+		return -EINVAL;
 
 	/* update all wiphys now with the new established regulatory domain */
 	update_all_wiphy_regulatory(lr->initiator);
@@ -2260,10 +2232,7 @@ int set_regdom(const struct ieee80211_regdomain *rd)
 
 	reg_set_request_processed();
 
- out:
-	mutex_unlock(&reg_mutex);
-
-	return r;
+	return 0;
 }
 
 int reg_device_uevent(struct device *dev, struct kobj_uevent_env *env)
@@ -2288,14 +2257,10 @@ int reg_device_uevent(struct device *dev, struct kobj_uevent_env *env)
 
 void wiphy_regulatory_register(struct wiphy *wiphy)
 {
-	mutex_lock(&reg_mutex);
-
 	if (!reg_dev_ignore_cell_hint(wiphy))
 		reg_num_devs_support_basehint++;
 
 	wiphy_update_regulatory(wiphy, NL80211_REGDOM_SET_BY_CORE);
-
-	mutex_unlock(&reg_mutex);
 }
 
 void wiphy_regulatory_deregister(struct wiphy *wiphy)
@@ -2303,7 +2268,6 @@ void wiphy_regulatory_deregister(struct wiphy *wiphy)
 	struct wiphy *request_wiphy = NULL;
 	struct regulatory_request *lr;
 
-	mutex_lock(&reg_mutex);
 	lr = get_last_request();
 
 	if (!reg_dev_ignore_cell_hint(wiphy))
@@ -2316,12 +2280,10 @@ void wiphy_regulatory_deregister(struct wiphy *wiphy)
 		request_wiphy = wiphy_idx_to_wiphy(lr->wiphy_idx);
 
 	if (!request_wiphy || request_wiphy != wiphy)
-		goto out;
+		return;
 
 	lr->wiphy_idx = WIPHY_IDX_INVALID;
 	lr->country_ie_env = ENVIRON_ANY;
-out:
-	mutex_unlock(&reg_mutex);
 }
 
 static void reg_timeout_work(struct work_struct *work)
@@ -2385,9 +2347,9 @@ void regulatory_exit(void)
 	cancel_delayed_work_sync(&reg_timeout);
 
 	/* Lock to suppress warnings */
-	mutex_lock(&reg_mutex);
+	rtnl_lock();
 	reset_regdomains(true, NULL);
-	mutex_unlock(&reg_mutex);
+	rtnl_unlock();
 
 	dev_set_uevent_suppress(&reg_pdev->dev, true);
 
-- 
1.8.0

