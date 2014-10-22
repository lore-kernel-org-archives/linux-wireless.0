Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:56672 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932079AbaJVTXQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Oct 2014 15:23:16 -0400
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, Ben Greear <greearb@candelatech.com>
Subject: [PATCH v3 3/9] cfg80211:  support creating wiphy with suggested name
Date: Wed, 22 Oct 2014 12:23:00 -0700
Message-Id: <1414005786-27572-3-git-send-email-greearb@candelatech.com> (sfid-20141022_212326_029601_D7770CB6)
In-Reply-To: <1414005786-27572-1-git-send-email-greearb@candelatech.com>
References: <1414005786-27572-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

Kernel will attempt to use the name if it is supplied,
but if name cannot be used for some reason, the default
phyX name will be used instead.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
 include/net/cfg80211.h | 23 +++++++++++++++++++-
 net/wireless/core.c    | 58 +++++++++++++++++++++++++++++++++++++++++---------
 2 files changed, 70 insertions(+), 11 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 77aa805..39d7996 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -3185,6 +3185,23 @@ static inline const char *wiphy_name(const struct wiphy *wiphy)
 }
 
 /**
+ * wiphy_new_nm - create a new wiphy for use with cfg80211
+ *
+ * @ops: The configuration operations for this device
+ * @sizeof_priv: The size of the private area to allocate
+ * @requested_name: Request a particular name.
+ *	NULL is valid value, and means use the default phy%d naming.
+ *
+ * Create a new wiphy and associate the given operations with it.
+ * @sizeof_priv bytes are allocated for private use.
+ *
+ * Return: A pointer to the new wiphy. This pointer must be
+ * assigned to each netdev's ieee80211_ptr for proper operation.
+ */
+struct wiphy *wiphy_new_nm(const struct cfg80211_ops *ops, int sizeof_priv,
+			   const char *requested_name);
+
+/**
  * wiphy_new - create a new wiphy for use with cfg80211
  *
  * @ops: The configuration operations for this device
@@ -3196,7 +3213,11 @@ static inline const char *wiphy_name(const struct wiphy *wiphy)
  * Return: A pointer to the new wiphy. This pointer must be
  * assigned to each netdev's ieee80211_ptr for proper operation.
  */
-struct wiphy *wiphy_new(const struct cfg80211_ops *ops, int sizeof_priv);
+static inline struct wiphy *wiphy_new(const struct cfg80211_ops *ops,
+				      int sizeof_priv)
+{
+	return wiphy_new_nm(ops, sizeof_priv, NULL);
+}
 
 /**
  * wiphy_register - register a wiphy with cfg80211
diff --git a/net/wireless/core.c b/net/wireless/core.c
index f52a4cd..710d47e 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -86,11 +86,11 @@ struct wiphy *wiphy_idx_to_wiphy(int wiphy_idx)
 	return &rdev->wiphy;
 }
 
-int cfg80211_dev_rename(struct cfg80211_registered_device *rdev,
-			char *newname)
+static int cfg80211_dev_check_name(struct cfg80211_registered_device *rdev,
+				   const char *newname)
 {
 	struct cfg80211_registered_device *rdev2;
-	int wiphy_idx, taken = -1, result, digits;
+	int wiphy_idx, taken = -1, digits;
 
 	ASSERT_RTNL();
 
@@ -109,15 +109,28 @@ int cfg80211_dev_rename(struct cfg80211_registered_device *rdev,
 			return -EINVAL;
 	}
 
+	/* Ensure another device does not already have this name. */
+	list_for_each_entry(rdev2, &cfg80211_rdev_list, list)
+		if (strcmp(newname, dev_name(&rdev2->wiphy.dev)) == 0)
+			return -EINVAL;
+
+	return 0;
+}
+
+int cfg80211_dev_rename(struct cfg80211_registered_device *rdev,
+			char *newname)
+{
+	int result;
+
+	ASSERT_RTNL();
 
 	/* Ignore nop renames */
 	if (strcmp(newname, dev_name(&rdev->wiphy.dev)) == 0)
 		return 0;
 
-	/* Ensure another device does not already have this name. */
-	list_for_each_entry(rdev2, &cfg80211_rdev_list, list)
-		if (strcmp(newname, dev_name(&rdev2->wiphy.dev)) == 0)
-			return -EINVAL;
+	result = cfg80211_dev_check_name(rdev, newname);
+	if (result < 0)
+		return result;
 
 	result = device_rename(&rdev->wiphy.dev, newname);
 	if (result)
@@ -309,7 +322,8 @@ static void cfg80211_destroy_iface_wk(struct work_struct *work)
 
 /* exported functions */
 
-struct wiphy *wiphy_new(const struct cfg80211_ops *ops, int sizeof_priv)
+struct wiphy *wiphy_new_nm(const struct cfg80211_ops *ops, int sizeof_priv,
+			   const char *requested_name)
 {
 	static atomic_t wiphy_counter = ATOMIC_INIT(0);
 
@@ -346,7 +360,31 @@ struct wiphy *wiphy_new(const struct cfg80211_ops *ops, int sizeof_priv)
 	rdev->wiphy_idx--;
 
 	/* give it a proper name */
-	dev_set_name(&rdev->wiphy.dev, PHY_NAME "%d", rdev->wiphy_idx);
+	if (requested_name && requested_name[0]) {
+		int rv;
+
+		rtnl_lock();
+		rv = cfg80211_dev_check_name(rdev, requested_name);
+
+		if (rv < 0) {
+			rtnl_unlock();
+			goto use_default_name;
+		}
+
+		rv = dev_set_name(&rdev->wiphy.dev, requested_name);
+		rtnl_unlock();
+		if (rv)
+			goto use_default_name;
+	} else {
+use_default_name:
+		/* NOTE:  This is *probably* safe w/out holding rtnl because of
+		 * the restrictions on phy names.  Probably this call could
+		 * fail if some other part of the kernel (re)named a device
+		 * phyX.  But, might should add some locking and check return
+		 * value, and use a different name if this one exists?
+		 */
+		dev_set_name(&rdev->wiphy.dev, PHY_NAME "%d", rdev->wiphy_idx);
+	}
 
 	INIT_LIST_HEAD(&rdev->wdev_list);
 	INIT_LIST_HEAD(&rdev->beacon_registrations);
@@ -406,7 +444,7 @@ struct wiphy *wiphy_new(const struct cfg80211_ops *ops, int sizeof_priv)
 
 	return &rdev->wiphy;
 }
-EXPORT_SYMBOL(wiphy_new);
+EXPORT_SYMBOL(wiphy_new_nm);
 
 static int wiphy_verify_combinations(struct wiphy *wiphy)
 {
-- 
1.7.11.7

