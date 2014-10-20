Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:34679 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751233AbaJTWtu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Oct 2014 18:49:50 -0400
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, Ben Greear <greearb@candelatech.com>
Subject: [PATCH v2 1/6] cfg80211:  support creating wiphy with suggested name.
Date: Mon, 20 Oct 2014 15:49:33 -0700
Message-Id: <1413845378-27837-1-git-send-email-greearb@candelatech.com> (sfid-20141021_005004_136161_3C448A61)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

Kernel will attempt to use the name if it is supplied,
but if name cannot be used for some reason, the default
phyX name will be used instead.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
 include/net/cfg80211.h | 22 +++++++++++++++++++++-
 net/wireless/core.c    | 45 ++++++++++++++++++++++++++++++++++++++++++---
 2 files changed, 63 insertions(+), 4 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index ed896c0..5252f80 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -3193,6 +3193,7 @@ static inline const char *wiphy_name(const struct wiphy *wiphy)
  *
  * @ops: The configuration operations for this device
  * @sizeof_priv: The size of the private area to allocate
+ * @requested_name Request a particular name.
  *
  * Create a new wiphy and associate the given operations with it.
  * @sizeof_priv bytes are allocated for private use.
@@ -3200,7 +3201,26 @@ static inline const char *wiphy_name(const struct wiphy *wiphy)
  * Return: A pointer to the new wiphy. This pointer must be
  * assigned to each netdev's ieee80211_ptr for proper operation.
  */
-struct wiphy *wiphy_new(const struct cfg80211_ops *ops, int sizeof_priv);
+struct wiphy *wiphy_new_nm(const struct cfg80211_ops *ops, int sizeof_priv,
+			   const char *requested_name);
+
+/**
+ * wiphy_new - create a new wiphy for use with cfg80211
+ *
+ * @ops: The configuration operations for this device
+ * @sizeof_priv: The size of the private area to allocate
+ *
+ * Create a new wiphy and associate the given operations with it.
+ * @sizeof_priv bytes are allocated for private use.
+ *
+ * Return: A pointer to the new wiphy. This pointer must be
+ * assigned to each netdev's ieee80211_ptr for proper operation.
+ */
+static inline struct wiphy *wiphy_new(const struct cfg80211_ops *ops,
+				      int sizeof_priv)
+{
+	return wiphy_new_nm(ops, sizeof_priv, NULL);
+}
 
 /**
  * wiphy_register - register a wiphy with cfg80211
diff --git a/net/wireless/core.c b/net/wireless/core.c
index f52a4cd..2013edb 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -309,7 +309,8 @@ static void cfg80211_destroy_iface_wk(struct work_struct *work)
 
 /* exported functions */
 
-struct wiphy *wiphy_new(const struct cfg80211_ops *ops, int sizeof_priv)
+struct wiphy *wiphy_new_nm(const struct cfg80211_ops *ops, int sizeof_priv,
+			   const char *requested_name)
 {
 	static atomic_t wiphy_counter = ATOMIC_INIT(0);
 
@@ -336,6 +337,7 @@ struct wiphy *wiphy_new(const struct cfg80211_ops *ops, int sizeof_priv)
 	rdev->wiphy_idx = atomic_inc_return(&wiphy_counter);
 
 	if (unlikely(rdev->wiphy_idx < 0)) {
+		/* TODO:  Fix this someday. */
 		/* ugh, wrapped! */
 		atomic_dec(&wiphy_counter);
 		kfree(rdev);
@@ -346,7 +348,44 @@ struct wiphy *wiphy_new(const struct cfg80211_ops *ops, int sizeof_priv)
 	rdev->wiphy_idx--;
 
 	/* give it a proper name */
-	dev_set_name(&rdev->wiphy.dev, PHY_NAME "%d", rdev->wiphy_idx);
+	if (requested_name && requested_name[0]) {
+		struct cfg80211_registered_device *rdev2;
+		int wiphy_idx, taken = -1, result, digits;
+
+		/* Code below is from cfg80211_dev_rename */
+		/* prohibit calling the thing phy%d when %d is not its number */
+		sscanf(requested_name, PHY_NAME "%d%n", &wiphy_idx, &taken);
+		if (taken == strlen(requested_name) &&
+		    wiphy_idx != rdev->wiphy_idx) {
+			/* count number of places needed to print wiphy_idx */
+			digits = 1;
+			while (wiphy_idx /= 10)
+				digits++;
+			/*
+			 * deny name if it is phy<idx> where <idx> is printed
+			 * without leading zeroes. taken == strlen(newname) here
+			 */
+			if (taken == strlen(PHY_NAME) + digits)
+				goto use_default_name;
+		}
+
+		rtnl_lock();
+		/* Ensure another device does not already have this name. */
+		list_for_each_entry(rdev2, &cfg80211_rdev_list, list)
+			if (strcmp(requested_name, dev_name(&rdev2->wiphy.dev))
+			    == 0) {
+				rtnl_unlock();
+				goto use_default_name;
+			}
+
+		result = dev_set_name(&rdev->wiphy.dev, requested_name);
+		rtnl_unlock();
+		if (result)
+			goto use_default_name;
+	} else {
+use_default_name:
+		dev_set_name(&rdev->wiphy.dev, PHY_NAME "%d", rdev->wiphy_idx);
+	}
 
 	INIT_LIST_HEAD(&rdev->wdev_list);
 	INIT_LIST_HEAD(&rdev->beacon_registrations);
@@ -406,7 +445,7 @@ struct wiphy *wiphy_new(const struct cfg80211_ops *ops, int sizeof_priv)
 
 	return &rdev->wiphy;
 }
-EXPORT_SYMBOL(wiphy_new);
+EXPORT_SYMBOL(wiphy_new_nm);
 
 static int wiphy_verify_combinations(struct wiphy *wiphy)
 {
-- 
1.7.11.7

