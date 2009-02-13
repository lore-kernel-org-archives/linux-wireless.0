Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:33445 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750923AbZBMFg4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Feb 2009 00:36:56 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 12 Feb 2009 21:36:56 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <johannes@sipsolutions.net>, <johannes@sipsolutions.net>,
	<linville@tuxdriver.com>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	<linux-wireless@vger.kernel.org>
Subject: [PATCH 5/6] cfg80211: make regulatory_request use wiphy_idx instead of wiphy
Date: Thu, 12 Feb 2009 21:36:02 -0800
Message-ID: <1234503363-11014-6-git-send-email-lrodriguez@atheros.com> (sfid-20090213_063700_589901_58324ABE)
In-Reply-To: <1234503363-11014-5-git-send-email-lrodriguez@atheros.com>
References: <1234503363-11014-1-git-send-email-lrodriguez@atheros.com>
 <1234503363-11014-2-git-send-email-lrodriguez@atheros.com>
 <1234503363-11014-3-git-send-email-lrodriguez@atheros.com>
 <1234503363-11014-4-git-send-email-lrodriguez@atheros.com>
 <1234503363-11014-5-git-send-email-lrodriguez@atheros.com>
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
 net/wireless/core.c    |   18 ++++++++++-
 net/wireless/core.h    |   21 ++++++++++++++
 net/wireless/reg.c     |   73 ++++++++++++++++++++++++++++++++----------------
 4 files changed, 89 insertions(+), 29 deletions(-)

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
index 6807538..2024664 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -41,13 +41,14 @@ DEFINE_MUTEX(cfg80211_mutex);
 static struct dentry *ieee80211_debugfs_dir;
 
 /* requires cfg80211_drv_mutex to be held! */
-static struct cfg80211_registered_device *
-cfg80211_drv_by_wiphy_idx(int wiphy_idx)
+struct cfg80211_registered_device *cfg80211_drv_by_wiphy_idx(int wiphy_idx)
 {
 	struct cfg80211_registered_device *result = NULL, *drv;
 
 	assert_cfg80211_lock();
 
+	WARN_ON(!wiphy_idx_valid(wiphy_idx));
+
 	list_for_each_entry(drv, &cfg80211_drv_list, list) {
 		if (drv->wiphy_idx == wiphy_idx) {
 			result = drv;
@@ -58,6 +59,19 @@ cfg80211_drv_by_wiphy_idx(int wiphy_idx)
 	return result;
 }
 
+/* requires cfg80211_drv_mutex to be held! */
+struct wiphy *wiphy_idx_to_wiphy(int wiphy_idx)
+{
+	struct cfg80211_registered_device *drv;
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
index 2500dbc..df1e9ff 100644
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
index aab1c69..316b2e4 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -829,9 +829,13 @@ static void handle_channel(struct wiphy *wiphy, enum ieee80211_band band,
 	const struct ieee80211_power_rule *power_rule = NULL;
 	struct ieee80211_supported_band *sband;
 	struct ieee80211_channel *chan;
+	struct wiphy *request_wiphy;
 
 	assert_cfg80211_lock();
 
+	if (wiphy_idx_valid(last_request->wiphy_idx))
+		request_wiphy = wiphy_idx_to_wiphy(last_request->wiphy_idx);
+
 	sband = wiphy->bands[band];
 	BUG_ON(chan_idx >= sband->n_channels);
 	chan = &sband->channels[chan_idx];
@@ -879,8 +883,8 @@ static void handle_channel(struct wiphy *wiphy, enum ieee80211_band band,
 	power_rule = &reg_rule->power_rule;
 
 	if (last_request->initiator == REGDOM_SET_BY_DRIVER &&
-	    last_request->wiphy && last_request->wiphy == wiphy &&
-	    last_request->wiphy->strict_regulatory) {
+	    request_wiphy && request_wiphy == wiphy &&
+	    request_wiphy->strict_regulatory) {
 		/* This gaurantees the driver's requested regulatory domain
 		 * will always be used as a base for further regulatory
 		 * settings */
@@ -1044,6 +1048,11 @@ static int reg_copy_regd(const struct ieee80211_regdomain **dst_regd,
 static int ignore_request(struct wiphy *wiphy, enum reg_set_by set_by,
 			  const char *alpha2)
 {
+	/*
+	 * NB: there should be no need to use request_wiphy when in
+	 * REGDOM_SET_BY_CORE, as no wiphys should have sent hints by then
+	 */
+	struct wiphy *request_wiphy;
 
 	if (set_by != REGDOM_SET_BY_CORE)
 		assert_cfg80211_lock();
@@ -1062,10 +1071,15 @@ static int ignore_request(struct wiphy *wiphy, enum reg_set_by set_by,
 		 */
 		return 0;
 	case REGDOM_SET_BY_COUNTRY_IE:
+
+		if (wiphy_idx_valid(last_request->wiphy_idx))
+			request_wiphy =
+				wiphy_idx_to_wiphy(last_request->wiphy_idx);
+
 		if (unlikely(!is_an_alpha2(alpha2)))
 			return -EINVAL;
 		if (last_request->initiator == REGDOM_SET_BY_COUNTRY_IE) {
-			if (last_request->wiphy != wiphy) {
+			if (request_wiphy != wiphy) {
 				/*
 				 * Two cards with two APs claiming different
 				 * different Country IE alpha2s. We could
@@ -1167,7 +1181,7 @@ new_request:
 	request->alpha2[0] = alpha2[0];
 	request->alpha2[1] = alpha2[1];
 	request->initiator = set_by;
-	request->wiphy = wiphy;
+	request->wiphy_idx = wiphy_idx(wiphy);
 	request->intersect = intersect;
 	request->country_ie_checksum = country_ie_checksum;
 	request->country_ie_env = env;
@@ -1210,11 +1224,17 @@ EXPORT_SYMBOL(regulatory_hint);
 static bool reg_same_country_ie_hint(struct wiphy *wiphy,
 			u32 country_ie_checksum)
 {
+	struct wiphy *request_wiphy;
+
 	assert_cfg80211_lock();
 
-	if (!last_request->wiphy)
+	if (wiphy_idx_valid(last_request->wiphy_idx))
+		request_wiphy = wiphy_idx_to_wiphy(last_request->wiphy_idx);
+
+	if (!request_wiphy)
 		return false;
-	if (likely(last_request->wiphy != wiphy))
+
+	if (likely(request_wiphy != wiphy))
 		return !country_ie_integrity_changes(country_ie_checksum);
 	/* We should not have let these through at this point, they
 	 * should have been picked up earlier by the first alpha2 check
@@ -1262,14 +1282,15 @@ void regulatory_hint_11d(struct wiphy *wiphy,
 	/* We will run this for *every* beacon processed for the BSSID, so
 	 * we optimize an early check to exit out early if we don't have to
 	 * do anything */
-	if (likely(last_request->wiphy)) {
+	if (wiphy_idx_valid(last_request->wiphy_idx)) {
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
@@ -1361,13 +1382,12 @@ static void print_regdomain(const struct ieee80211_regdomain *rd)
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
@@ -1433,7 +1453,7 @@ static int __set_regdom(const struct ieee80211_regdomain *rd)
 {
 	const struct ieee80211_regdomain *intersected_rd = NULL;
 	struct cfg80211_registered_device *drv = NULL;
-	struct wiphy *wiphy = NULL;
+	struct wiphy *request_wiphy;
 	/* Some basic sanity checks first */
 
 	if (is_world_regdom(rd->alpha2)) {
@@ -1461,8 +1481,6 @@ static int __set_regdom(const struct ieee80211_regdomain *rd)
 			return -EINVAL;
 	}
 
-	wiphy = last_request->wiphy;
-
 	/* Now lets set the regulatory domain, update all driver channels
 	 * and finally inform them of what we have done, in case they want
 	 * to review or adjust their own settings based on their own
@@ -1478,6 +1496,9 @@ static int __set_regdom(const struct ieee80211_regdomain *rd)
 		return -EINVAL;
 	}
 
+	if (wiphy_idx_valid(last_request->wiphy_idx))
+		request_wiphy = wiphy_idx_to_wiphy(last_request->wiphy_idx);
+
 	if (!last_request->intersect) {
 		int r;
 
@@ -1490,9 +1511,9 @@ static int __set_regdom(const struct ieee80211_regdomain *rd)
 		/* For a driver hint, lets copy the regulatory domain the
 		 * driver wanted to the wiphy to deal with conflicts */
 
-		BUG_ON(last_request->wiphy->regd);
+		BUG_ON(request_wiphy->regd);
 
-		r = reg_copy_regd(&last_request->wiphy->regd, rd);
+		r = reg_copy_regd(&request_wiphy->regd, rd);
 		if (r)
 			return r;
 
@@ -1513,7 +1534,7 @@ static int __set_regdom(const struct ieee80211_regdomain *rd)
 		 * However if a driver requested this specific regulatory
 		 * domain we keep it for its private use */
 		if (last_request->initiator == REGDOM_SET_BY_DRIVER)
-			last_request->wiphy->regd = rd;
+			request_wiphy->regd = rd;
 		else
 			kfree(rd);
 
@@ -1553,7 +1574,7 @@ static int __set_regdom(const struct ieee80211_regdomain *rd)
 	if (!intersected_rd)
 		return -EINVAL;
 
-	drv = wiphy_to_dev(wiphy);
+	drv = wiphy_to_dev(request_wiphy);
 
 	drv->country_ie_alpha2[0] = rd->alpha2[0];
 	drv->country_ie_alpha2[1] = rd->alpha2[1];
@@ -1602,14 +1623,18 @@ int set_regdom(const struct ieee80211_regdomain *rd)
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

