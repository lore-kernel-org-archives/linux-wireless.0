Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52361 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752132Ab2FSOvC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Jun 2012 10:51:02 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [RFC 01/17] cfg80211: make some functions static
Date: Tue, 19 Jun 2012 16:50:40 +0200
Message-Id: <1340117456-10154-2-git-send-email-johannes@sipsolutions.net> (sfid-20120619_165130_029472_DEADFD32)
In-Reply-To: <1340117456-10154-1-git-send-email-johannes@sipsolutions.net>
References: <1340117456-10154-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Some of the functions to retrieve a device can
be static as they're used only in nl80211.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/core.c    |   63 -------------------------------------
 net/wireless/core.h    |   26 ---------------
 net/wireless/nl80211.c |   82 ++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 82 insertions(+), 89 deletions(-)

diff --git a/net/wireless/core.c b/net/wireless/core.c
index a87d435..907f62c 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -96,69 +96,6 @@ struct wiphy *wiphy_idx_to_wiphy(int wiphy_idx)
 	return &rdev->wiphy;
 }
 
-/* requires cfg80211_mutex to be held! */
-struct cfg80211_registered_device *
-__cfg80211_rdev_from_info(struct genl_info *info)
-{
-	int ifindex;
-	struct cfg80211_registered_device *bywiphyidx = NULL, *byifidx = NULL;
-	struct net_device *dev;
-	int err = -EINVAL;
-
-	assert_cfg80211_lock();
-
-	if (info->attrs[NL80211_ATTR_WIPHY]) {
-		bywiphyidx = cfg80211_rdev_by_wiphy_idx(
-				nla_get_u32(info->attrs[NL80211_ATTR_WIPHY]));
-		err = -ENODEV;
-	}
-
-	if (info->attrs[NL80211_ATTR_IFINDEX]) {
-		ifindex = nla_get_u32(info->attrs[NL80211_ATTR_IFINDEX]);
-		dev = dev_get_by_index(genl_info_net(info), ifindex);
-		if (dev) {
-			if (dev->ieee80211_ptr)
-				byifidx =
-					wiphy_to_dev(dev->ieee80211_ptr->wiphy);
-			dev_put(dev);
-		}
-		err = -ENODEV;
-	}
-
-	if (bywiphyidx && byifidx) {
-		if (bywiphyidx != byifidx)
-			return ERR_PTR(-EINVAL);
-		else
-			return bywiphyidx; /* == byifidx */
-	}
-	if (bywiphyidx)
-		return bywiphyidx;
-
-	if (byifidx)
-		return byifidx;
-
-	return ERR_PTR(err);
-}
-
-struct cfg80211_registered_device *
-cfg80211_get_dev_from_info(struct genl_info *info)
-{
-	struct cfg80211_registered_device *rdev;
-
-	mutex_lock(&cfg80211_mutex);
-	rdev = __cfg80211_rdev_from_info(info);
-
-	/* if it is not an error we grab the lock on
-	 * it to assure it won't be going away while
-	 * we operate on it */
-	if (!IS_ERR(rdev))
-		mutex_lock(&rdev->mtx);
-
-	mutex_unlock(&cfg80211_mutex);
-
-	return rdev;
-}
-
 struct cfg80211_registered_device *
 cfg80211_get_dev_from_ifindex(struct net *net, int ifindex)
 {
diff --git a/net/wireless/core.h b/net/wireless/core.h
index 9348a47..609a579 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -159,32 +159,6 @@ static inline void cfg80211_unhold_bss(struct cfg80211_internal_bss *bss)
 struct cfg80211_registered_device *cfg80211_rdev_by_wiphy_idx(int wiphy_idx);
 int get_wiphy_idx(struct wiphy *wiphy);
 
-struct cfg80211_registered_device *
-__cfg80211_rdev_from_info(struct genl_info *info);
-
-/*
- * This function returns a pointer to the driver
- * that the genl_info item that is passed refers to.
- * If successful, it returns non-NULL and also locks
- * the driver's mutex!
- *
- * This means that you need to call cfg80211_unlock_rdev()
- * before being allowed to acquire &cfg80211_mutex!
- *
- * This is necessary because we need to lock the global
- * mutex to get an item off the list safely, and then
- * we lock the rdev mutex so it doesn't go away under us.
- *
- * We don't want to keep cfg80211_mutex locked
- * for all the time in order to allow requests on
- * other interfaces to go through at the same time.
- *
- * The result of this can be a PTR_ERR and hence must
- * be checked with IS_ERR() for errors.
- */
-extern struct cfg80211_registered_device *
-cfg80211_get_dev_from_info(struct genl_info *info);
-
 /* requires cfg80211_rdev_mutex to be held! */
 struct wiphy *wiphy_idx_to_wiphy(int wiphy_idx);
 
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index a363ca1..2d3541c 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -70,6 +70,88 @@ static int get_rdev_dev_by_ifindex(struct net *netns, struct nlattr **attrs,
 	return 0;
 }
 
+static struct cfg80211_registered_device *
+__cfg80211_rdev_from_info(struct genl_info *info)
+{
+	int ifindex;
+	struct cfg80211_registered_device *bywiphyidx = NULL, *byifidx = NULL;
+	struct net_device *dev;
+	int err = -EINVAL;
+
+	assert_cfg80211_lock();
+
+	if (info->attrs[NL80211_ATTR_WIPHY]) {
+		bywiphyidx = cfg80211_rdev_by_wiphy_idx(
+				nla_get_u32(info->attrs[NL80211_ATTR_WIPHY]));
+		err = -ENODEV;
+	}
+
+	if (info->attrs[NL80211_ATTR_IFINDEX]) {
+		ifindex = nla_get_u32(info->attrs[NL80211_ATTR_IFINDEX]);
+		dev = dev_get_by_index(genl_info_net(info), ifindex);
+		if (dev) {
+			if (dev->ieee80211_ptr)
+				byifidx =
+					wiphy_to_dev(dev->ieee80211_ptr->wiphy);
+			dev_put(dev);
+		}
+		err = -ENODEV;
+	}
+
+	if (bywiphyidx && byifidx) {
+		if (bywiphyidx != byifidx)
+			return ERR_PTR(-EINVAL);
+		else
+			return bywiphyidx; /* == byifidx */
+	}
+	if (bywiphyidx)
+		return bywiphyidx;
+
+	if (byifidx)
+		return byifidx;
+
+	return ERR_PTR(err);
+}
+
+/*
+ * This function returns a pointer to the driver
+ * that the genl_info item that is passed refers to.
+ * If successful, it returns non-NULL and also locks
+ * the driver's mutex!
+ *
+ * This means that you need to call cfg80211_unlock_rdev()
+ * before being allowed to acquire &cfg80211_mutex!
+ *
+ * This is necessary because we need to lock the global
+ * mutex to get an item off the list safely, and then
+ * we lock the rdev mutex so it doesn't go away under us.
+ *
+ * We don't want to keep cfg80211_mutex locked
+ * for all the time in order to allow requests on
+ * other interfaces to go through at the same time.
+ *
+ * The result of this can be a PTR_ERR and hence must
+ * be checked with IS_ERR() for errors.
+ */
+static struct cfg80211_registered_device *
+cfg80211_get_dev_from_info(struct genl_info *info)
+{
+	struct cfg80211_registered_device *rdev;
+
+	mutex_lock(&cfg80211_mutex);
+	rdev = __cfg80211_rdev_from_info(info);
+
+	/* if it is not an error we grab the lock on
+	 * it to assure it won't be going away while
+	 * we operate on it */
+	if (!IS_ERR(rdev))
+		mutex_lock(&rdev->mtx);
+
+	mutex_unlock(&cfg80211_mutex);
+
+	return rdev;
+}
+
 /* policy for the attributes */
 static const struct nla_policy nl80211_policy[NL80211_ATTR_MAX+1] = {
 	[NL80211_ATTR_WIPHY] = { .type = NLA_U32 },
-- 
1.7.10

