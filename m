Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:56073 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751197AbZBUFEn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 21 Feb 2009 00:04:43 -0500
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH v6 08/15] cfg80211: make regulatory_request use wiphy_idx instead of wiphy
Date: Sat, 21 Feb 2009 00:04:26 -0500
Message-Id: <1235192673-6314-9-git-send-email-lrodriguez@atheros.com> (sfid-20090221_062318_461394_8B46437D)
In-Reply-To: <1235192673-6314-1-git-send-email-lrodriguez@atheros.com>
References: <1235192673-6314-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We do this so later on we can move the pending requests onto a
workqueue. By using the wiphy_idx instead of the wiphy we can
later easily check if the wiphy has disappeared or not.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 include/net/cfg80211.h |    6 ++--
 net/wireless/core.c    |   30 ++++++++++++++++++++--
 net/wireless/core.h    |   12 +++++++++
 net/wireless/reg.c     |   64 ++++++++++++++++++++++++++++++------------------
 4 files changed, 82 insertions(+), 30 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 43ac90d..bb9129f 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -383,9 +383,9 @@ enum environment_cap {
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
@@ -406,7 +406,7 @@ enum environment_cap {
  * 	indoor, or if it doesn't matter
  */
 struct regulatory_request {
-	struct wiphy *wiphy;
+	int wiphy_idx;
 	enum reg_set_by initiator;
 	char alpha2[2];
 	bool intersect;
diff --git a/net/wireless/core.c b/net/wireless/core.c
index e347093..b1a354b 100644
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
 
@@ -61,6 +60,31 @@ cfg80211_drv_by_wiphy_idx(int wiphy_idx)
 	return result;
 }
 
+int get_wiphy_idx(struct wiphy *wiphy)
+{
+	struct cfg80211_registered_device *drv;
+	if (!wiphy)
+		return WIPHY_IDX_STALE;
+	drv = wiphy_to_dev(wiphy);
+	return drv->wiphy_idx;
+}
+
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
index 982cc6b..cd8e6e3 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -79,6 +79,12 @@ static inline void assert_cfg80211_lock(void)
 	BUG_ON(!mutex_is_locked(&cfg80211_mutex));
 }
 
+/*
+ * You can use this to mark a wiphy_idx as not having an associated wiphy.
+ * It guarantees cfg80211_drv_by_wiphy_idx(wiphy_idx) will return NULL
+ */
+#define WIPHY_IDX_STALE -1
+
 struct cfg80211_internal_bss {
 	struct list_head list;
 	struct rb_node rbn;
@@ -88,6 +94,9 @@ struct cfg80211_internal_bss {
 	struct cfg80211_bss pub;
 };
 
+struct cfg80211_registered_device *cfg80211_drv_by_wiphy_idx(int wiphy_idx);
+int get_wiphy_idx(struct wiphy *wiphy);
+
 /*
  * This function returns a pointer to the driver
  * that the genl_info item that is passed refers to.
@@ -111,6 +120,9 @@ struct cfg80211_internal_bss {
 extern struct cfg80211_registered_device *
 cfg80211_get_dev_from_info(struct genl_info *info);
 
+/* requires cfg80211_drv_mutex to be held! */
+struct wiphy *wiphy_idx_to_wiphy(int wiphy_idx);
+
 /* identical to cfg80211_get_dev_from_info but only operate on ifindex */
 extern struct cfg80211_registered_device *
 cfg80211_get_dev_from_ifindex(int ifindex);
diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index e49ac9b..d44f3b5 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -831,9 +831,12 @@ static void handle_channel(struct wiphy *wiphy, enum ieee80211_band band,
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
@@ -881,8 +884,8 @@ static void handle_channel(struct wiphy *wiphy, enum ieee80211_band band,
 	power_rule = &reg_rule->power_rule;
 
 	if (last_request->initiator == REGDOM_SET_BY_DRIVER &&
-	    last_request->wiphy && last_request->wiphy == wiphy &&
-	    last_request->wiphy->strict_regulatory) {
+	    request_wiphy && request_wiphy == wiphy &&
+	    request_wiphy->strict_regulatory) {
 		/* This gaurantees the driver's requested regulatory domain
 		 * will always be used as a base for further regulatory
 		 * settings */
@@ -1046,6 +1049,7 @@ static int reg_copy_regd(const struct ieee80211_regdomain **dst_regd,
 static int ignore_request(struct wiphy *wiphy, enum reg_set_by set_by,
 			  const char *alpha2)
 {
+	struct wiphy *last_wiphy = NULL;
 
 	assert_cfg80211_lock();
 
@@ -1059,10 +1063,13 @@ static int ignore_request(struct wiphy *wiphy, enum reg_set_by set_by,
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
@@ -1163,7 +1170,7 @@ new_request:
 	request->alpha2[0] = alpha2[0];
 	request->alpha2[1] = alpha2[1];
 	request->initiator = set_by;
-	request->wiphy = wiphy;
+	request->wiphy_idx = get_wiphy_idx(wiphy);
 	request->intersect = intersect;
 	request->country_ie_checksum = country_ie_checksum;
 	request->country_ie_env = env;
@@ -1226,11 +1233,16 @@ EXPORT_SYMBOL(regulatory_hint);
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
@@ -1278,14 +1290,15 @@ void regulatory_hint_11d(struct wiphy *wiphy,
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
@@ -1377,13 +1390,12 @@ static void print_regdomain(const struct ieee80211_regdomain *rd)
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
@@ -1449,7 +1461,7 @@ static int __set_regdom(const struct ieee80211_regdomain *rd)
 {
 	const struct ieee80211_regdomain *intersected_rd = NULL;
 	struct cfg80211_registered_device *drv = NULL;
-	struct wiphy *wiphy = NULL;
+	struct wiphy *request_wiphy;
 	/* Some basic sanity checks first */
 
 	if (is_world_regdom(rd->alpha2)) {
@@ -1477,8 +1489,6 @@ static int __set_regdom(const struct ieee80211_regdomain *rd)
 			return -EINVAL;
 	}
 
-	wiphy = last_request->wiphy;
-
 	/* Now lets set the regulatory domain, update all driver channels
 	 * and finally inform them of what we have done, in case they want
 	 * to review or adjust their own settings based on their own
@@ -1494,6 +1504,8 @@ static int __set_regdom(const struct ieee80211_regdomain *rd)
 		return -EINVAL;
 	}
 
+	request_wiphy = wiphy_idx_to_wiphy(last_request->wiphy_idx);
+
 	if (!last_request->intersect) {
 		int r;
 
@@ -1506,9 +1518,9 @@ static int __set_regdom(const struct ieee80211_regdomain *rd)
 		/* For a driver hint, lets copy the regulatory domain the
 		 * driver wanted to the wiphy to deal with conflicts */
 
-		BUG_ON(last_request->wiphy->regd);
+		BUG_ON(request_wiphy->regd);
 
-		r = reg_copy_regd(&last_request->wiphy->regd, rd);
+		r = reg_copy_regd(&request_wiphy->regd, rd);
 		if (r)
 			return r;
 
@@ -1529,7 +1541,7 @@ static int __set_regdom(const struct ieee80211_regdomain *rd)
 		 * However if a driver requested this specific regulatory
 		 * domain we keep it for its private use */
 		if (last_request->initiator == REGDOM_SET_BY_DRIVER)
-			last_request->wiphy->regd = rd;
+			request_wiphy->regd = rd;
 		else
 			kfree(rd);
 
@@ -1569,7 +1581,7 @@ static int __set_regdom(const struct ieee80211_regdomain *rd)
 	if (!intersected_rd)
 		return -EINVAL;
 
-	drv = wiphy_to_dev(wiphy);
+	drv = wiphy_to_dev(request_wiphy);
 
 	drv->country_ie_alpha2[0] = rd->alpha2[0];
 	drv->country_ie_alpha2[1] = rd->alpha2[1];
@@ -1618,14 +1630,18 @@ int set_regdom(const struct ieee80211_regdomain *rd)
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
1.6.0.3

