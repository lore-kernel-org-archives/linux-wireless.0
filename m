Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53224 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946004Ab2LFQr7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Dec 2012 11:47:59 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 23/24] regulatory: use RCU to protect last_request
Date: Thu,  6 Dec 2012 17:47:47 +0100
Message-Id: <1354812468-15709-24-git-send-email-johannes@sipsolutions.net> (sfid-20121206_174853_623239_FC60B3EA)
In-Reply-To: <1354812468-15709-1-git-send-email-johannes@sipsolutions.net>
References: <1354812468-15709-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

This will allow making freq_reg_info() lock-free.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/regulatory.h |   2 +
 net/wireless/reg.c       | 195 ++++++++++++++++++++++++++---------------------
 2 files changed, 108 insertions(+), 89 deletions(-)

diff --git a/include/net/regulatory.h b/include/net/regulatory.h
index 96b0f07..f17ed59 100644
--- a/include/net/regulatory.h
+++ b/include/net/regulatory.h
@@ -36,6 +36,7 @@ enum environment_cap {
 /**
  * struct regulatory_request - used to keep track of regulatory requests
  *
+ * @rcu_head: RCU head struct used to free the request
  * @wiphy_idx: this is set if this request's initiator is
  * 	%REGDOM_SET_BY_COUNTRY_IE or %REGDOM_SET_BY_DRIVER. This
  * 	can be used by the wireless core to deal with conflicts
@@ -73,6 +74,7 @@ enum environment_cap {
  * @list: used to insert into the reg_requests_list linked list
  */
 struct regulatory_request {
+	struct rcu_head rcu_head;
 	int wiphy_idx;
 	enum nl80211_reg_initiator initiator;
 	enum nl80211_user_reg_hint_type user_reg_hint_type;
diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 6082c68..b289131 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -82,7 +82,8 @@ static struct regulatory_request core_request_world = {
 };
 
 /* Receipt of information from last regulatory request */
-static struct regulatory_request *last_request = &core_request_world;
+static struct regulatory_request __rcu *last_request =
+	(void __rcu *)&core_request_world;
 
 /* To trigger userspace events */
 static struct platform_device *reg_pdev;
@@ -102,7 +103,7 @@ const struct ieee80211_regdomain __rcu *cfg80211_regdomain;
  * Protects static reg.c components:
  *	- cfg80211_regdomain (if not used with RCU)
  *	- cfg80211_world_regdom
- *	- last_request
+ *	- last_request (if not used with RCU)
  *	- reg_num_devs_support_basehint
  */
 static DEFINE_MUTEX(reg_mutex);
@@ -137,6 +138,12 @@ static void rcu_free_regdom(const struct ieee80211_regdomain *r)
 	kfree_rcu((struct ieee80211_regdomain *)r, rcu_head);
 }
 
+static struct regulatory_request *get_last_request(void)
+{
+	return rcu_dereference_protected(last_request,
+					 lockdep_is_held(&reg_mutex));
+}
+
 /* Used to queue up regulatory hints */
 static LIST_HEAD(reg_requests_list);
 static spinlock_t reg_requests_lock;
@@ -207,6 +214,7 @@ static void reset_regdomains(bool full_reset,
 			     const struct ieee80211_regdomain *new_regdom)
 {
 	const struct ieee80211_regdomain *r;
+	struct regulatory_request *lr;
 
 	assert_reg_lock();
 
@@ -229,9 +237,10 @@ static void reset_regdomains(bool full_reset,
 	if (!full_reset)
 		return;
 
-	if (last_request != &core_request_world)
-		kfree(last_request);
-	last_request = &core_request_world;
+	lr = get_last_request();
+	if (lr != &core_request_world && lr)
+		kfree_rcu(lr, rcu_head);
+	rcu_assign_pointer(last_request, &core_request_world);
 }
 
 /*
@@ -240,9 +249,11 @@ static void reset_regdomains(bool full_reset,
  */
 static void update_world_regdomain(const struct ieee80211_regdomain *rd)
 {
-	WARN_ON(!last_request);
+	struct regulatory_request *lr;
 
-	assert_reg_lock();
+	lr = get_last_request();
+
+	WARN_ON(!lr);
 
 	reset_regdomains(false, rd);
 
@@ -449,15 +460,12 @@ static int call_crda(const char *alpha2)
 
 static bool reg_is_valid_request(const char *alpha2)
 {
-	assert_reg_lock();
-
-	if (!last_request)
-		return false;
+	struct regulatory_request *lr = get_last_request();
 
-	if (last_request->processed)
+	if (!lr || lr->processed)
 		return false;
 
-	return alpha2_equal(last_request->alpha2, alpha2);
+	return alpha2_equal(lr->alpha2, alpha2);
 }
 
 /* Sanity check on a regulatory rule */
@@ -747,15 +755,14 @@ int freq_reg_info(struct wiphy *wiphy, u32 center_freq,
 		  const struct ieee80211_reg_rule **reg_rule)
 {
 	const struct ieee80211_regdomain *regd;
-
-	assert_reg_lock();
+	struct regulatory_request *lr = get_last_request();
 
 	/*
 	 * Follow the driver's regulatory domain, if present, unless a country
 	 * IE has been processed or a user wants to help complaince further
 	 */
-	if (last_request->initiator != NL80211_REGDOM_SET_BY_COUNTRY_IE &&
-	    last_request->initiator != NL80211_REGDOM_SET_BY_USER &&
+	if (lr->initiator != NL80211_REGDOM_SET_BY_COUNTRY_IE &&
+	    lr->initiator != NL80211_REGDOM_SET_BY_USER &&
 	    wiphy->regd)
 		regd = get_wiphy_regdom(wiphy);
 	else
@@ -829,8 +836,9 @@ static void handle_channel(struct wiphy *wiphy,
 	const struct ieee80211_power_rule *power_rule = NULL;
 	const struct ieee80211_freq_range *freq_range = NULL;
 	struct wiphy *request_wiphy = NULL;
+	struct regulatory_request *lr = get_last_request();
 
-	request_wiphy = wiphy_idx_to_wiphy(last_request->wiphy_idx);
+	request_wiphy = wiphy_idx_to_wiphy(lr->wiphy_idx);
 
 	flags = chan->orig_flags;
 
@@ -863,7 +871,7 @@ static void handle_channel(struct wiphy *wiphy,
 	if (freq_range->max_bandwidth_khz < MHZ_TO_KHZ(40))
 		bw_flags = IEEE80211_CHAN_NO_HT40;
 
-	if (last_request->initiator == NL80211_REGDOM_SET_BY_DRIVER &&
+	if (lr->initiator == NL80211_REGDOM_SET_BY_DRIVER &&
 	    request_wiphy && request_wiphy == wiphy &&
 	    request_wiphy->flags & WIPHY_FLAG_STRICT_REGULATORY) {
 		/*
@@ -928,7 +936,7 @@ bool reg_last_request_cell_base(void)
 	bool val;
 
 	mutex_lock(&reg_mutex);
-	val = reg_request_cell_base(last_request);
+	val = reg_request_cell_base(get_last_request());
 	mutex_unlock(&reg_mutex);
 
 	return val;
@@ -970,7 +978,9 @@ static bool reg_dev_ignore_cell_hint(struct wiphy *wiphy)
 static bool ignore_reg_update(struct wiphy *wiphy,
 			      enum nl80211_reg_initiator initiator)
 {
-	if (!last_request) {
+	struct regulatory_request *lr = get_last_request();
+
+	if (!lr) {
 		REG_DBG_PRINT("Ignoring regulatory request %s since last_request is not set\n",
 			      reg_initiator_name(initiator));
 		return true;
@@ -989,13 +999,13 @@ static bool ignore_reg_update(struct wiphy *wiphy,
 	 */
 	if (wiphy->flags & WIPHY_FLAG_STRICT_REGULATORY && !wiphy->regd &&
 	    initiator != NL80211_REGDOM_SET_BY_COUNTRY_IE &&
-	    !is_world_regdom(last_request->alpha2)) {
+	    !is_world_regdom(lr->alpha2)) {
 		REG_DBG_PRINT("Ignoring regulatory request %s since the driver requires its own regulatory domain to be set first\n",
 			      reg_initiator_name(initiator));
 		return true;
 	}
 
-	if (reg_request_cell_base(last_request))
+	if (reg_request_cell_base(lr))
 		return reg_dev_ignore_cell_hint(wiphy);
 
 	return false;
@@ -1081,12 +1091,12 @@ static bool reg_is_world_roaming(struct wiphy *wiphy)
 {
 	const struct ieee80211_regdomain *cr = get_cfg80211_regdom();
 	const struct ieee80211_regdomain *wr = get_wiphy_regdom(wiphy);
+	struct regulatory_request *lr = get_last_request();
 
 	if (is_world_regdom(cr->alpha2) || (wr && is_world_regdom(wr->alpha2)))
 		return true;
 
-	if (last_request &&
-	    last_request->initiator != NL80211_REGDOM_SET_BY_COUNTRY_IE &&
+	if (lr && lr->initiator != NL80211_REGDOM_SET_BY_COUNTRY_IE &&
 	    wiphy->flags & WIPHY_FLAG_CUSTOM_REGULATORY)
 		return true;
 
@@ -1185,13 +1195,12 @@ static void wiphy_update_regulatory(struct wiphy *wiphy,
 				    enum nl80211_reg_initiator initiator)
 {
 	enum ieee80211_band band;
-
-	assert_reg_lock();
+	struct regulatory_request *lr = get_last_request();
 
 	if (ignore_reg_update(wiphy, initiator))
 		return;
 
-	last_request->dfs_region = get_cfg80211_regdom()->dfs_region;
+	lr->dfs_region = get_cfg80211_regdom()->dfs_region;
 
 	for (band = 0; band < IEEE80211_NUM_BANDS; band++)
 		handle_band(wiphy, initiator, wiphy->bands[band]);
@@ -1200,7 +1209,7 @@ static void wiphy_update_regulatory(struct wiphy *wiphy,
 	reg_process_ht_flags(wiphy);
 
 	if (wiphy->reg_notifier)
-		wiphy->reg_notifier(wiphy, last_request);
+		wiphy->reg_notifier(wiphy, lr);
 }
 
 static void update_all_wiphy_regulatory(enum nl80211_reg_initiator initiator)
@@ -1221,7 +1230,7 @@ static void update_all_wiphy_regulatory(enum nl80211_reg_initiator initiator)
 		if (initiator == NL80211_REGDOM_SET_BY_CORE &&
 		    wiphy->flags & WIPHY_FLAG_CUSTOM_REGULATORY &&
 		    wiphy->reg_notifier)
-			wiphy->reg_notifier(wiphy, last_request);
+			wiphy->reg_notifier(wiphy, get_last_request());
 	}
 }
 
@@ -1301,28 +1310,28 @@ get_reg_request_treatment(struct wiphy *wiphy,
 			  struct regulatory_request *pending_request)
 {
 	struct wiphy *last_wiphy = NULL;
+	struct regulatory_request *lr = get_last_request();
 
 	/* All initial requests are respected */
-	if (!last_request)
+	if (!lr)
 		return REG_REQ_OK;
 
 	switch (pending_request->initiator) {
 	case NL80211_REGDOM_SET_BY_CORE:
 		return REG_REQ_OK;
 	case NL80211_REGDOM_SET_BY_COUNTRY_IE:
-		if (reg_request_cell_base(last_request)) {
+		if (reg_request_cell_base(lr)) {
 			/* Trust a Cell base station over the AP's country IE */
 			if (regdom_changes(pending_request->alpha2))
 				return REG_REQ_IGNORE;
 			return REG_REQ_ALREADY_SET;
 		}
 
-		last_wiphy = wiphy_idx_to_wiphy(last_request->wiphy_idx);
+		last_wiphy = wiphy_idx_to_wiphy(lr->wiphy_idx);
 
 		if (unlikely(!is_an_alpha2(pending_request->alpha2)))
 			return -EINVAL;
-		if (last_request->initiator ==
-		    NL80211_REGDOM_SET_BY_COUNTRY_IE) {
+		if (lr->initiator == NL80211_REGDOM_SET_BY_COUNTRY_IE) {
 			if (last_wiphy != wiphy) {
 				/*
 				 * Two cards with two APs claiming different
@@ -1344,7 +1353,7 @@ get_reg_request_treatment(struct wiphy *wiphy,
 		}
 		return 0;
 	case NL80211_REGDOM_SET_BY_DRIVER:
-		if (last_request->initiator == NL80211_REGDOM_SET_BY_CORE) {
+		if (lr->initiator == NL80211_REGDOM_SET_BY_CORE) {
 			if (regdom_changes(pending_request->alpha2))
 				return REG_REQ_OK;
 			return REG_REQ_ALREADY_SET;
@@ -1355,7 +1364,7 @@ get_reg_request_treatment(struct wiphy *wiphy,
 		 * back in or if you add a new device for which the previously
 		 * loaded card also agrees on the regulatory domain.
 		 */
-		if (last_request->initiator == NL80211_REGDOM_SET_BY_DRIVER &&
+		if (lr->initiator == NL80211_REGDOM_SET_BY_DRIVER &&
 		    !regdom_changes(pending_request->alpha2))
 			return REG_REQ_ALREADY_SET;
 
@@ -1364,26 +1373,26 @@ get_reg_request_treatment(struct wiphy *wiphy,
 		if (reg_request_cell_base(pending_request))
 			return reg_ignore_cell_hint(pending_request);
 
-		if (reg_request_cell_base(last_request))
+		if (reg_request_cell_base(lr))
 			return REG_REQ_IGNORE;
 
-		if (last_request->initiator == NL80211_REGDOM_SET_BY_COUNTRY_IE)
+		if (lr->initiator == NL80211_REGDOM_SET_BY_COUNTRY_IE)
 			return REG_REQ_INTERSECT;
 		/*
 		 * If the user knows better the user should set the regdom
 		 * to their country before the IE is picked up
 		 */
-		if (last_request->initiator == NL80211_REGDOM_SET_BY_USER &&
-		    last_request->intersect)
+		if (lr->initiator == NL80211_REGDOM_SET_BY_USER &&
+		    lr->intersect)
 			return REG_REQ_IGNORE;
 		/*
 		 * Process user requests only after previous user/driver/core
 		 * requests have been processed
 		 */
-		if ((last_request->initiator == NL80211_REGDOM_SET_BY_CORE ||
-		     last_request->initiator == NL80211_REGDOM_SET_BY_DRIVER ||
-		     last_request->initiator == NL80211_REGDOM_SET_BY_USER) &&
-		    regdom_changes(last_request->alpha2))
+		if ((lr->initiator == NL80211_REGDOM_SET_BY_CORE ||
+		     lr->initiator == NL80211_REGDOM_SET_BY_DRIVER ||
+		     lr->initiator == NL80211_REGDOM_SET_BY_USER) &&
+		    regdom_changes(lr->alpha2))
 			return REG_REQ_IGNORE;
 
 		if (!regdom_changes(pending_request->alpha2))
@@ -1398,15 +1407,16 @@ get_reg_request_treatment(struct wiphy *wiphy,
 static void reg_set_request_processed(void)
 {
 	bool need_more_processing = false;
+	struct regulatory_request *lr = get_last_request();
 
-	last_request->processed = true;
+	lr->processed = true;
 
 	spin_lock(&reg_requests_lock);
 	if (!list_empty(&reg_requests_list))
 		need_more_processing = true;
 	spin_unlock(&reg_requests_lock);
 
-	if (last_request->initiator == NL80211_REGDOM_SET_BY_USER)
+	if (lr->initiator == NL80211_REGDOM_SET_BY_USER)
 		cancel_delayed_work(&reg_timeout);
 
 	if (need_more_processing)
@@ -1433,6 +1443,7 @@ __regulatory_hint(struct wiphy *wiphy,
 	const struct ieee80211_regdomain *regd;
 	bool intersect = false;
 	enum reg_request_treatment treatment;
+	struct regulatory_request *lr;
 
 	treatment = get_reg_request_treatment(wiphy, pending_request);
 
@@ -1473,18 +1484,20 @@ __regulatory_hint(struct wiphy *wiphy,
 	}
 
 new_request:
-	if (last_request != &core_request_world)
-		kfree(last_request);
+	lr = get_last_request();
+	if (lr != &core_request_world && lr)
+		kfree_rcu(lr, rcu_head);
 
-	last_request = pending_request;
-	last_request->intersect = intersect;
-	last_request->processed = false;
+	pending_request->intersect = intersect;
+	pending_request->processed = false;
+	rcu_assign_pointer(last_request, pending_request);
+	lr = pending_request;
 
 	pending_request = NULL;
 
-	if (last_request->initiator == NL80211_REGDOM_SET_BY_USER) {
-		user_alpha2[0] = last_request->alpha2[0];
-		user_alpha2[1] = last_request->alpha2[1];
+	if (lr->initiator == NL80211_REGDOM_SET_BY_USER) {
+		user_alpha2[0] = lr->alpha2[0];
+		user_alpha2[1] = lr->alpha2[1];
 	}
 
 	/* When r == REG_REQ_INTERSECT we do need to call CRDA */
@@ -1495,13 +1508,13 @@ new_request:
 		 * inform userspace we have processed the request
 		 */
 		if (treatment == REG_REQ_ALREADY_SET) {
-			nl80211_send_reg_change_event(last_request);
+			nl80211_send_reg_change_event(lr);
 			reg_set_request_processed();
 		}
 		return treatment;
 	}
 
-	if (call_crda(last_request->alpha2))
+	if (call_crda(lr->alpha2))
 		return REG_REQ_IGNORE;
 	return REG_REQ_OK;
 }
@@ -1544,13 +1557,14 @@ static void reg_process_hint(struct regulatory_request *reg_request,
  */
 static void reg_process_pending_hints(void)
 {
-	struct regulatory_request *reg_request;
+	struct regulatory_request *reg_request, *lr;
 
 	mutex_lock(&cfg80211_mutex);
 	mutex_lock(&reg_mutex);
+	lr = get_last_request();
 
 	/* When last_request->processed becomes true this will be rescheduled */
-	if (last_request && !last_request->processed) {
+	if (lr && !lr->processed) {
 		REG_DBG_PRINT("Pending regulatory request, waiting for it to be processed...\n");
 		goto out;
 	}
@@ -1703,11 +1717,12 @@ void regulatory_hint_11d(struct wiphy *wiphy, enum ieee80211_band band,
 {
 	char alpha2[2];
 	enum environment_cap env = ENVIRON_ANY;
-	struct regulatory_request *request;
+	struct regulatory_request *request, *lr;
 
 	mutex_lock(&reg_mutex);
+	lr = get_last_request();
 
-	if (unlikely(!last_request))
+	if (unlikely(!lr))
 		goto out;
 
 	/* IE len must be evenly divisible by 2 */
@@ -1730,8 +1745,8 @@ void regulatory_hint_11d(struct wiphy *wiphy, enum ieee80211_band band,
 	 * We leave conflict resolution to the workqueue, where can hold
 	 * cfg80211_mutex.
 	 */
-	if (last_request->initiator == NL80211_REGDOM_SET_BY_COUNTRY_IE &&
-	    last_request->wiphy_idx != WIPHY_IDX_INVALID)
+	if (lr->initiator == NL80211_REGDOM_SET_BY_COUNTRY_IE &&
+	    lr->wiphy_idx != WIPHY_IDX_INVALID)
 		goto out;
 
 	request = kzalloc(sizeof(struct regulatory_request), GFP_KERNEL);
@@ -2022,13 +2037,12 @@ static void print_dfs_region(u8 dfs_region)
 
 static void print_regdomain(const struct ieee80211_regdomain *rd)
 {
+	struct regulatory_request *lr = get_last_request();
 
 	if (is_intersected_alpha2(rd->alpha2)) {
-		if (last_request->initiator ==
-		    NL80211_REGDOM_SET_BY_COUNTRY_IE) {
+		if (lr->initiator == NL80211_REGDOM_SET_BY_COUNTRY_IE) {
 			struct cfg80211_registered_device *rdev;
-			rdev = cfg80211_rdev_by_wiphy_idx(
-				last_request->wiphy_idx);
+			rdev = cfg80211_rdev_by_wiphy_idx(lr->wiphy_idx);
 			if (rdev) {
 				pr_info("Current regulatory domain updated by AP to: %c%c\n",
 					rdev->country_ie_alpha2[0],
@@ -2043,7 +2057,7 @@ static void print_regdomain(const struct ieee80211_regdomain *rd)
 		if (is_unknown_alpha2(rd->alpha2))
 			pr_info("Regulatory domain changed to driver built-in settings (unknown country)\n");
 		else {
-			if (reg_request_cell_base(last_request))
+			if (reg_request_cell_base(lr))
 				pr_info("Regulatory domain changed to country: %c%c by Cell Station\n",
 					rd->alpha2[0], rd->alpha2[1]);
 			else
@@ -2068,11 +2082,10 @@ static int __set_regdom(const struct ieee80211_regdomain *rd)
 	const struct ieee80211_regdomain *regd;
 	const struct ieee80211_regdomain *intersected_rd = NULL;
 	struct wiphy *request_wiphy;
+	struct regulatory_request *lr = get_last_request();
 
 	/* Some basic sanity checks first */
 
-	assert_reg_lock();
-
 	if (!reg_is_valid_request(rd->alpha2))
 		return -EINVAL;
 
@@ -2090,7 +2103,7 @@ static int __set_regdom(const struct ieee80211_regdomain *rd)
 	 * rd is non static (it means CRDA was present and was used last)
 	 * and the pending request came in from a country IE
 	 */
-	if (last_request->initiator != NL80211_REGDOM_SET_BY_COUNTRY_IE) {
+	if (lr->initiator != NL80211_REGDOM_SET_BY_COUNTRY_IE) {
 		/*
 		 * If someone else asked us to change the rd lets only bother
 		 * checking if the alpha2 changes if CRDA was already called
@@ -2112,16 +2125,16 @@ static int __set_regdom(const struct ieee80211_regdomain *rd)
 		return -EINVAL;
 	}
 
-	request_wiphy = wiphy_idx_to_wiphy(last_request->wiphy_idx);
+	request_wiphy = wiphy_idx_to_wiphy(lr->wiphy_idx);
 	if (!request_wiphy &&
-	    (last_request->initiator == NL80211_REGDOM_SET_BY_DRIVER ||
-	     last_request->initiator == NL80211_REGDOM_SET_BY_COUNTRY_IE)) {
+	    (lr->initiator == NL80211_REGDOM_SET_BY_DRIVER ||
+	     lr->initiator == NL80211_REGDOM_SET_BY_COUNTRY_IE)) {
 		schedule_delayed_work(&reg_timeout, 0);
 		return -ENODEV;
 	}
 
-	if (!last_request->intersect) {
-		if (last_request->initiator != NL80211_REGDOM_SET_BY_DRIVER) {
+	if (!lr->intersect) {
+		if (lr->initiator != NL80211_REGDOM_SET_BY_DRIVER) {
 			reset_regdomains(false, rd);
 			return 0;
 		}
@@ -2151,7 +2164,7 @@ static int __set_regdom(const struct ieee80211_regdomain *rd)
 
 	/* Intersection requires a bit more work */
 
-	if (last_request->initiator != NL80211_REGDOM_SET_BY_COUNTRY_IE) {
+	if (lr->initiator != NL80211_REGDOM_SET_BY_COUNTRY_IE) {
 		intersected_rd = regdom_intersect(rd, get_cfg80211_regdom());
 		if (!intersected_rd)
 			return -EINVAL;
@@ -2161,7 +2174,7 @@ static int __set_regdom(const struct ieee80211_regdomain *rd)
 		 * However if a driver requested this specific regulatory
 		 * domain we keep it for its private use
 		 */
-		if (last_request->initiator == NL80211_REGDOM_SET_BY_DRIVER)
+		if (lr->initiator == NL80211_REGDOM_SET_BY_DRIVER)
 			rcu_assign_pointer(request_wiphy->regd, rd);
 		else
 			kfree(rd);
@@ -2184,9 +2197,11 @@ static int __set_regdom(const struct ieee80211_regdomain *rd)
  */
 int set_regdom(const struct ieee80211_regdomain *rd)
 {
+	struct regulatory_request *lr;
 	int r;
 
 	mutex_lock(&reg_mutex);
+	lr = get_last_request();
 
 	/* Note that this doesn't update the wiphys, this is done below */
 	r = __set_regdom(rd);
@@ -2199,18 +2214,17 @@ int set_regdom(const struct ieee80211_regdomain *rd)
 	}
 
 	/* This would make this whole thing pointless */
-	if (WARN_ON(!last_request->intersect &&
-		    rd != get_cfg80211_regdom())) {
+	if (WARN_ON(!lr->intersect && rd != get_cfg80211_regdom())) {
 		r = -EINVAL;
 		goto out;
 	}
 
 	/* update all wiphys now with the new established regulatory domain */
-	update_all_wiphy_regulatory(last_request->initiator);
+	update_all_wiphy_regulatory(lr->initiator);
 
 	print_regdomain(get_cfg80211_regdom());
 
-	nl80211_send_reg_change_event(last_request);
+	nl80211_send_reg_change_event(lr);
 
 	reg_set_request_processed();
 
@@ -2223,10 +2237,11 @@ int set_regdom(const struct ieee80211_regdomain *rd)
 #ifdef CONFIG_HOTPLUG
 int reg_device_uevent(struct device *dev, struct kobj_uevent_env *env)
 {
-	if (last_request && !last_request->processed) {
+	struct regulatory_request *lr = get_last_request();
+
+	if (lr && !lr->processed) {
 		if (add_uevent_var(env, "COUNTRY=%c%c",
-				   last_request->alpha2[0],
-				   last_request->alpha2[1]))
+				   lr->alpha2[0], lr->alpha2[1]))
 			return -ENOMEM;
 	}
 
@@ -2255,8 +2270,10 @@ void wiphy_regulatory_register(struct wiphy *wiphy)
 void wiphy_regulatory_deregister(struct wiphy *wiphy)
 {
 	struct wiphy *request_wiphy = NULL;
+	struct regulatory_request *lr;
 
 	mutex_lock(&reg_mutex);
+	lr = get_last_request();
 
 	if (!reg_dev_ignore_cell_hint(wiphy))
 		reg_num_devs_support_basehint--;
@@ -2264,14 +2281,14 @@ void wiphy_regulatory_deregister(struct wiphy *wiphy)
 	rcu_free_regdom(get_wiphy_regdom(wiphy));
 	rcu_assign_pointer(wiphy->regd, NULL);
 
-	if (last_request)
-		request_wiphy = wiphy_idx_to_wiphy(last_request->wiphy_idx);
+	if (lr)
+		request_wiphy = wiphy_idx_to_wiphy(lr->wiphy_idx);
 
 	if (!request_wiphy || request_wiphy != wiphy)
 		goto out;
 
-	last_request->wiphy_idx = WIPHY_IDX_INVALID;
-	last_request->country_ie_env = ENVIRON_ANY;
+	lr->wiphy_idx = WIPHY_IDX_INVALID;
+	lr->country_ie_env = ENVIRON_ANY;
 out:
 	mutex_unlock(&reg_mutex);
 }
-- 
1.8.0

