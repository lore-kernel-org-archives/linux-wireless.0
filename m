Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44572 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752005Ab2LDOsl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Dec 2012 09:48:41 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [RFC v2 08/18] cfg80211: remove wiphy_idx_valid
Date: Tue,  4 Dec 2012 15:48:50 +0100
Message-Id: <1354632540-21207-9-git-send-email-johannes@sipsolutions.net> (sfid-20121204_154903_532995_85985D4C)
In-Reply-To: <1354632540-21207-1-git-send-email-johannes@sipsolutions.net>
References: <1354632540-21207-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

This is pretty much useless since get_wiphy_idx()
always returns true since it's always called with
a valid wiphy pointer.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/core.c    | 14 +++-----------
 net/wireless/core.h    | 16 +++-------------
 net/wireless/nl80211.c |  2 +-
 net/wireless/reg.c     | 14 +++++---------
 4 files changed, 12 insertions(+), 34 deletions(-)

diff --git a/net/wireless/core.c b/net/wireless/core.c
index 14d9904..747dd93 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -57,9 +57,6 @@ struct cfg80211_registered_device *cfg80211_rdev_by_wiphy_idx(int wiphy_idx)
 {
 	struct cfg80211_registered_device *result = NULL, *rdev;
 
-	if (!wiphy_idx_valid(wiphy_idx))
-		return NULL;
-
 	assert_cfg80211_lock();
 
 	list_for_each_entry(rdev, &cfg80211_rdev_list, list) {
@@ -74,10 +71,8 @@ struct cfg80211_registered_device *cfg80211_rdev_by_wiphy_idx(int wiphy_idx)
 
 int get_wiphy_idx(struct wiphy *wiphy)
 {
-	struct cfg80211_registered_device *rdev;
-	if (!wiphy)
-		return WIPHY_IDX_STALE;
-	rdev = wiphy_to_dev(wiphy);
+	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
+
 	return rdev->wiphy_idx;
 }
 
@@ -86,9 +81,6 @@ struct wiphy *wiphy_idx_to_wiphy(int wiphy_idx)
 {
 	struct cfg80211_registered_device *rdev;
 
-	if (!wiphy_idx_valid(wiphy_idx))
-		return NULL;
-
 	assert_cfg80211_lock();
 
 	rdev = cfg80211_rdev_by_wiphy_idx(wiphy_idx);
@@ -309,7 +301,7 @@ struct wiphy *wiphy_new(const struct cfg80211_ops *ops, int sizeof_priv)
 
 	rdev->wiphy_idx = wiphy_counter++;
 
-	if (unlikely(!wiphy_idx_valid(rdev->wiphy_idx))) {
+	if (unlikely(rdev->wiphy_idx < 0)) {
 		wiphy_counter--;
 		mutex_unlock(&cfg80211_mutex);
 		/* ugh, wrapped! */
diff --git a/net/wireless/core.h b/net/wireless/core.h
index 3563097..b8f4630 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -18,6 +18,9 @@
 #include <net/cfg80211.h>
 #include "reg.h"
 
+
+#define WIPHY_IDX_INVALID	-1
+
 struct cfg80211_registered_device {
 	const struct cfg80211_ops *ops;
 	struct list_head list;
@@ -96,13 +99,6 @@ struct cfg80211_registered_device *wiphy_to_dev(struct wiphy *wiphy)
 	return container_of(wiphy, struct cfg80211_registered_device, wiphy);
 }
 
-/* Note 0 is valid, hence phy0 */
-static inline
-bool wiphy_idx_valid(int wiphy_idx)
-{
-	return wiphy_idx >= 0;
-}
-
 static inline void
 cfg80211_rdev_free_wowlan(struct cfg80211_registered_device *rdev)
 {
@@ -126,12 +122,6 @@ static inline void assert_cfg80211_lock(void)
 	lockdep_assert_held(&cfg80211_mutex);
 }
 
-/*
- * You can use this to mark a wiphy_idx as not having an associated wiphy.
- * It guarantees cfg80211_rdev_by_wiphy_idx(wiphy_idx) will return NULL
- */
-#define WIPHY_IDX_STALE -1
-
 struct cfg80211_internal_bss {
 	struct list_head list;
 	struct rb_node rbn;
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index e5c2988..fb81208 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -8072,7 +8072,7 @@ void nl80211_send_reg_change_event(struct regulatory_request *request)
 			goto nla_put_failure;
 	}
 
-	if (wiphy_idx_valid(request->wiphy_idx) &&
+	if (request->wiphy_idx != WIPHY_IDX_INVALID &&
 	    nla_put_u32(msg, NL80211_ATTR_WIPHY, request->wiphy_idx))
 		goto nla_put_failure;
 
diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index dc0ddca..a934914 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -1548,7 +1548,7 @@ static void reg_process_hint(struct regulatory_request *reg_request,
 
 	BUG_ON(!reg_request->alpha2);
 
-	if (wiphy_idx_valid(reg_request->wiphy_idx))
+	if (reg_request->wiphy_idx != WIPHY_IDX_INVALID)
 		wiphy = wiphy_idx_to_wiphy(reg_request->wiphy_idx);
 
 	if (reg_initiator == NL80211_REGDOM_SET_BY_DRIVER && !wiphy) {
@@ -1693,7 +1693,7 @@ int regulatory_hint_user(const char *alpha2,
 	if (!request)
 		return -ENOMEM;
 
-	request->wiphy_idx = WIPHY_IDX_STALE;
+	request->wiphy_idx = WIPHY_IDX_INVALID;
 	request->alpha2[0] = alpha2[0];
 	request->alpha2[1] = alpha2[1];
 	request->initiator = NL80211_REGDOM_SET_BY_USER;
@@ -1718,9 +1718,6 @@ int regulatory_hint(struct wiphy *wiphy, const char *alpha2)
 
 	request->wiphy_idx = get_wiphy_idx(wiphy);
 
-	/* Must have registered wiphy first */
-	BUG_ON(!wiphy_idx_valid(request->wiphy_idx));
-
 	request->alpha2[0] = alpha2[0];
 	request->alpha2[1] = alpha2[1];
 	request->initiator = NL80211_REGDOM_SET_BY_DRIVER;
@@ -1767,9 +1764,8 @@ void regulatory_hint_11d(struct wiphy *wiphy, enum ieee80211_band band,
 	 * We leave conflict resolution to the workqueue, where can hold
 	 * cfg80211_mutex.
 	 */
-	if (likely(last_request->initiator ==
-		   NL80211_REGDOM_SET_BY_COUNTRY_IE &&
-		   wiphy_idx_valid(last_request->wiphy_idx)))
+	if (last_request->initiator == NL80211_REGDOM_SET_BY_COUNTRY_IE &&
+	    last_request->wiphy_idx != WIPHY_IDX_INVALID)
 		goto out;
 
 	request = kzalloc(sizeof(struct regulatory_request), GFP_KERNEL);
@@ -2326,7 +2322,7 @@ void wiphy_regulatory_deregister(struct wiphy *wiphy)
 	if (!request_wiphy || request_wiphy != wiphy)
 		goto out;
 
-	last_request->wiphy_idx = WIPHY_IDX_STALE;
+	last_request->wiphy_idx = WIPHY_IDX_INVALID;
 	last_request->country_ie_env = ENVIRON_ANY;
 out:
 	mutex_unlock(&reg_mutex);
-- 
1.8.0

