Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:27453 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751389AbZBNFem (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 Feb 2009 00:34:42 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 13 Feb 2009 21:34:42 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <johannes@sipsolutions.net>, <johannes@sipsolutions.net>,
	<linville@tuxdriver.com>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	<linux-wireless@vger.kernel.org>
Subject: [PATCH 08/10] cfg80211: make regulatory_request use wiphy_idx instead of wiphy
Date: Fri, 13 Feb 2009 21:33:45 -0800
Message-ID: <1234589627-16977-9-git-send-email-lrodriguez@atheros.com> (sfid-20090214_063448_040025_64E3936C)
In-Reply-To: <1234589627-16977-1-git-send-email-lrodriguez@atheros.com>
References: <1234589627-16977-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We do this so later on we can move the pending requests onto a
workqueue. By using the wiphy_idx instead of the wiphy we can
later easily check if the wiphy has disappeared or not.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 include/net/cfg80211.h |    6 ++--
 net/wireless/core.c    |   21 ++++++++++++--
 net/wireless/core.h    |   21 ++++++++++++++
 net/wireless/reg.c     |   70 ++++++++++++++++++++++++++++-------------------
 4 files changed, 84 insertions(+), 34 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index c0d1f5b..2a83510 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -375,9 +375,9 @@ enum environment_cap {
 };
 
 /**
- * struct regulatory_request - receipt of last regulatory request
+ * struct regulatory_request - used to keep track of regulatory requests
  *
- * @wiphy: this is set if this request's initiator is
+ * @wiphy_idx: this is set if this request's initiator is
  * 	%REGDOM_SET_BY_COUNTRY_IE or %REGDOM_SET_BY_DRIVER. This
  * 	can be used by the wireless core to deal with conflicts
  * 	and potentially inform users of which devices specifically
@@ -398,7 +398,7 @@ enum environment_cap {
  * 	indoor, or if it doesn't matter
  */
 struct regulatory_request {
-	struct wiphy *wiphy;
+	int wiphy_idx;
 	enum reg_set_by initiator;
 	char alpha2[2];
 	bool intersect;
diff --git a/net/wireless/core.c b/net/wireless/core.c
index e347093..f6b612d 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -40,9 +40,8 @@ DEFINE_MUTEX(cfg80211_mutex);
 /* for debugfs */
 static struct dentry *ieee80211_debugfs_dir;
 
-/* requires cfg80211_drv_mutex to be held! */
-static struct cfg80211_registered_device *
-cfg80211_drv_by_wiphy_idx(int wiphy_idx)
+/* requires cfg80211_mutex to be held! */
+struct cfg80211_registered_device *cfg80211_drv_by_wiphy_idx(int wiphy_idx)
 {
 	struct cfg80211_registered_device *result = NULL, *drv;
 
@@ -61,6 +60,22 @@ cfg80211_drv_by_wiphy_idx(int wiphy_idx)
 	return result;
 }
 
+/* requires cfg80211_drv_mutex to be held! */
+struct wiphy *wiphy_idx_to_wiphy(int wiphy_idx)
+{
+	struct cfg80211_registered_device *drv;
+
+	if (!wiphy_idx_valid(wiphy_idx))
+		return NULL;
+
+	assert_cfg80211_lock();
+
+	drv = cfg80211_drv_by_wiphy_idx(wiphy_idx);
+	if (!drv)
+		return NULL;
+	return &drv->wiphy;
+}
+
 /* requires cfg80211_mutex to be held! */
 static struct cfg80211_registered_device *
 __cfg80211_drv_from_info(struct genl_info *info)
diff --git a/net/wireless/core.h b/net/wireless/core.h
index 1f036f3..24f98c3 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -78,6 +78,22 @@ static inline void assert_cfg80211_lock(void)
 	BUG_ON(!mutex_is_locked(&cfg80211_mutex));
 }
 
+/*
+ * You can use this to mark a wiphy_idx as not having an associated wiphy.
+ * It guarantees cfg80211_drv_by_wiphy_idx(wiphy_idx) will return NULL
+ */
+#define WIPHY_IDX_STALE -1
+
+static inline
+int wiphy_idx(struct wiphy *wiphy)
+{
+	struct cfg80211_registered_device *drv;
+	if (!wiphy)
+		return WIPHY_IDX_STALE;
+	drv = wiphy_to_dev(wiphy);
+	return drv->wiphy_idx;
+}
+
 struct cfg80211_internal_bss {
 	struct list_head list;
 	struct rb_node rbn;
@@ -87,6 +103,8 @@ struct cfg80211_internal_bss {
 	struct cfg80211_bss pub;
 };
 
+struct cfg80211_registered_device *cfg80211_drv_by_wiphy_idx(int wiphy_idx);
+
 /*
  * This function returns a pointer to the driver
  * that the genl_info item that is passed refers to.
@@ -110,6 +128,9 @@ struct cfg80211_internal_bss {
 extern struct cfg80211_registered_device *
 cfg80211_get_dev_from_info(struct genl_info *info);
 
+/* requires cfg80211_drv_mutex to be held! */
+struct wiphy *wiphy_idx_to_wiphy(int wiphy_idx);
+
 /* identical to cfg80211_get_dev_from_info but only operate on ifindex */
 extern struct cfg80211_registered_device *
 cfg80211_get_dev_from_ifindex(int ifindex);
diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 93c197c..098e416 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -829,9 +829,12 @@ static void handle_channel(struct wiphy *wiphy, enum ieee80211_band band,
 	const struct ieee80211_power_rule *power_rule = NULL;
 	struct ieee80211_supported_band *sband;
 	struct ieee80211_channel *chan;
+	struct wiphy *request_wiphy;
 
 	assert_cfg80211_lock();
 
+	request_wiphy = wiphy_idx_to_wiphy(last_request->wiphy_idx);
+
 	sband = wiphy->bands[band];
 	BUG_ON(chan_idx >= sband->n_channels);
 	chan = &sband->channels[chan_idx];
@@ -879,8 +882,8 @@ static void handle_channel(struct wiphy *wiphy, enum ieee80211_band band,
 	power_rule = &reg_rule->power_rule;
 
 	if (last_request->initiator == REGDOM_SET_BY_DRIVER &&
-	    last_request->wiphy && last_request->wiphy == wiphy &&
-	    last_request->wiphy->strict_regulatory) {
+	    request_wiphy && request_wiphy == wiphy &&
+	    request_wiphy->strict_regulatory) {
 		/* This gaurantees the driver's requested regulatory domain
 		 * will always be used as a base for further regulatory
 		 * settings */
@@ -1044,9 +1047,9 @@ static int reg_copy_regd(const struct ieee80211_regdomain **dst_regd,
 static int ignore_request(struct wiphy *wiphy, enum reg_set_by set_by,
 			  const char *alpha2)
 {
+	struct wiphy *last_wiphy = NULL;
 
-	if (set_by != REGDOM_SET_BY_CORE)
-		assert_cfg80211_lock();
+	assert_cfg80211_lock();
 
 	/* All initial requests are respected */
 	if (!last_request)
@@ -1058,10 +1061,13 @@ static int ignore_request(struct wiphy *wiphy, enum reg_set_by set_by,
 	case REGDOM_SET_BY_CORE:
 		return -EINVAL;
 	case REGDOM_SET_BY_COUNTRY_IE:
+
+		last_wiphy = wiphy_idx_to_wiphy(last_request->wiphy_idx);
+
 		if (unlikely(!is_an_alpha2(alpha2)))
 			return -EINVAL;
 		if (last_request->initiator == REGDOM_SET_BY_COUNTRY_IE) {
-			if (last_request->wiphy != wiphy) {
+			if (last_wiphy != wiphy) {
 				/*
 				 * Two cards with two APs claiming different
 				 * different Country IE alpha2s. We could
@@ -1128,8 +1134,7 @@ int __regulatory_hint(struct wiphy *wiphy, enum reg_set_by set_by,
 	bool intersect = false;
 	int r = 0;
 
-	if (set_by != REGDOM_SET_BY_CORE)
-		assert_cfg80211_lock();
+	assert_cfg80211_lock();
 
 	r = ignore_request(wiphy, set_by, alpha2);
 
@@ -1163,7 +1168,7 @@ new_request:
 	request->alpha2[0] = alpha2[0];
 	request->alpha2[1] = alpha2[1];
 	request->initiator = set_by;
-	request->wiphy = wiphy;
+	request->wiphy_idx = wiphy_idx(wiphy);
 	request->intersect = intersect;
 	request->country_ie_checksum = country_ie_checksum;
 	request->country_ie_env = env;
@@ -1226,11 +1231,16 @@ EXPORT_SYMBOL(regulatory_hint);
 static bool reg_same_country_ie_hint(struct wiphy *wiphy,
 			u32 country_ie_checksum)
 {
+	struct wiphy *request_wiphy;
+
 	assert_cfg80211_lock();
 
-	if (!last_request->wiphy)
+	request_wiphy = wiphy_idx_to_wiphy(last_request->wiphy_idx);
+
+	if (!request_wiphy)
 		return false;
-	if (likely(last_request->wiphy != wiphy))
+
+	if (likely(request_wiphy != wiphy))
 		return !country_ie_integrity_changes(country_ie_checksum);
 	/* We should not have let these through at this point, they
 	 * should have been picked up earlier by the first alpha2 check
@@ -1278,14 +1288,15 @@ void regulatory_hint_11d(struct wiphy *wiphy,
 	/* We will run this for *every* beacon processed for the BSSID, so
 	 * we optimize an early check to exit out early if we don't have to
 	 * do anything */
-	if (likely(last_request->wiphy)) {
+	if (likely(wiphy_idx_valid(last_request->wiphy_idx))) {
 		struct cfg80211_registered_device *drv_last_ie;
 
-		drv_last_ie = wiphy_to_dev(last_request->wiphy);
+		drv_last_ie =
+			cfg80211_drv_by_wiphy_idx(last_request->wiphy_idx);
 
 		/* Lets keep this simple -- we trust the first AP
 		 * after we intersect with CRDA */
-		if (likely(last_request->wiphy == wiphy)) {
+		if (likely(&drv_last_ie->wiphy == wiphy)) {
 			/* Ignore IEs coming in on this wiphy with
 			 * the same alpha2 and environment cap */
 			if (likely(alpha2_equal(drv_last_ie->country_ie_alpha2,
@@ -1377,13 +1388,12 @@ static void print_regdomain(const struct ieee80211_regdomain *rd)
 {
 
 	if (is_intersected_alpha2(rd->alpha2)) {
-		struct wiphy *wiphy = NULL;
-		struct cfg80211_registered_device *drv;
 
 		if (last_request->initiator == REGDOM_SET_BY_COUNTRY_IE) {
-			if (last_request->wiphy) {
-				wiphy = last_request->wiphy;
-				drv = wiphy_to_dev(wiphy);
+			struct cfg80211_registered_device *drv;
+			drv = cfg80211_drv_by_wiphy_idx(
+				last_request->wiphy_idx);
+			if (drv) {
 				printk(KERN_INFO "cfg80211: Current regulatory "
 					"domain updated by AP to: %c%c\n",
 					drv->country_ie_alpha2[0],
@@ -1449,7 +1459,7 @@ static int __set_regdom(const struct ieee80211_regdomain *rd)
 {
 	const struct ieee80211_regdomain *intersected_rd = NULL;
 	struct cfg80211_registered_device *drv = NULL;
-	struct wiphy *wiphy = NULL;
+	struct wiphy *request_wiphy;
 	/* Some basic sanity checks first */
 
 	if (is_world_regdom(rd->alpha2)) {
@@ -1477,8 +1487,6 @@ static int __set_regdom(const struct ieee80211_regdomain *rd)
 			return -EINVAL;
 	}
 
-	wiphy = last_request->wiphy;
-
 	/* Now lets set the regulatory domain, update all driver channels
 	 * and finally inform them of what we have done, in case they want
 	 * to review or adjust their own settings based on their own
@@ -1494,6 +1502,8 @@ static int __set_regdom(const struct ieee80211_regdomain *rd)
 		return -EINVAL;
 	}
 
+	request_wiphy = wiphy_idx_to_wiphy(last_request->wiphy_idx);
+
 	if (!last_request->intersect) {
 		int r;
 
@@ -1506,9 +1516,9 @@ static int __set_regdom(const struct ieee80211_regdomain *rd)
 		/* For a driver hint, lets copy the regulatory domain the
 		 * driver wanted to the wiphy to deal with conflicts */
 
-		BUG_ON(last_request->wiphy->regd);
+		BUG_ON(request_wiphy->regd);
 
-		r = reg_copy_regd(&last_request->wiphy->regd, rd);
+		r = reg_copy_regd(&request_wiphy->regd, rd);
 		if (r)
 			return r;
 
@@ -1529,7 +1539,7 @@ static int __set_regdom(const struct ieee80211_regdomain *rd)
 		 * However if a driver requested this specific regulatory
 		 * domain we keep it for its private use */
 		if (last_request->initiator == REGDOM_SET_BY_DRIVER)
-			last_request->wiphy->regd = rd;
+			request_wiphy->regd = rd;
 		else
 			kfree(rd);
 
@@ -1569,7 +1579,7 @@ static int __set_regdom(const struct ieee80211_regdomain *rd)
 	if (!intersected_rd)
 		return -EINVAL;
 
-	drv = wiphy_to_dev(wiphy);
+	drv = wiphy_to_dev(request_wiphy);
 
 	drv->country_ie_alpha2[0] = rd->alpha2[0];
 	drv->country_ie_alpha2[1] = rd->alpha2[1];
@@ -1618,14 +1628,18 @@ int set_regdom(const struct ieee80211_regdomain *rd)
 /* Caller must hold cfg80211_mutex */
 void reg_device_remove(struct wiphy *wiphy)
 {
+	struct wiphy *request_wiphy;
+
 	assert_cfg80211_lock();
 
+	request_wiphy = wiphy_idx_to_wiphy(last_request->wiphy_idx);
+
 	kfree(wiphy->regd);
-	if (!last_request || !last_request->wiphy)
+	if (!last_request || !request_wiphy)
 		return;
-	if (last_request->wiphy != wiphy)
+	if (request_wiphy != wiphy)
 		return;
-	last_request->wiphy = NULL;
+	last_request->wiphy_idx = WIPHY_IDX_STALE;
 	last_request->country_ie_env = ENVIRON_ANY;
 }
 
-- 
1.6.1.2.253.ga34a

