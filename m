Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:27448 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751093AbZBNFef (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 Feb 2009 00:34:35 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 13 Feb 2009 21:34:35 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <johannes@sipsolutions.net>, <johannes@sipsolutions.net>,
	<linville@tuxdriver.com>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	<linux-wireless@vger.kernel.org>
Subject: [PATCH 03/10] cfg80211: rename cfg80211_drv_mutex to cfg80211_mutex
Date: Fri, 13 Feb 2009 21:33:40 -0800
Message-ID: <1234589627-16977-4-git-send-email-lrodriguez@atheros.com> (sfid-20090214_063440_105560_6C61D0DB)
In-Reply-To: <1234589627-16977-1-git-send-email-lrodriguez@atheros.com>
References: <1234589627-16977-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

cfg80211_drv_mutex is protecting more than the driver list,
this renames it and documents what its currently supposed to
protect.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 net/wireless/core.c    |   35 ++++++++++++++++++++---------------
 net/wireless/core.h    |    6 +++---
 net/wireless/nl80211.c |   20 ++++++++++----------
 net/wireless/reg.c     |   18 +++++++++---------
 4 files changed, 42 insertions(+), 37 deletions(-)

diff --git a/net/wireless/core.c b/net/wireless/core.c
index 35d457b..39d40d1 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -31,7 +31,12 @@ MODULE_DESCRIPTION("wireless configuration support");
  * only read the list, and that can happen quite
  * often because we need to do it for each command */
 LIST_HEAD(cfg80211_drv_list);
-DEFINE_MUTEX(cfg80211_drv_mutex);
+
+/*
+ * This is used to protect the cfg80211_drv_list, cfg80211_regdomain, and
+ * the last reguluatory request receipt in regd.c
+ */
+DEFINE_MUTEX(cfg80211_mutex);
 
 /* for debugfs */
 static struct dentry *ieee80211_debugfs_dir;
@@ -55,7 +60,7 @@ cfg80211_drv_by_wiphy_idx(int wiphy_idx)
 	return result;
 }
 
-/* requires cfg80211_drv_mutex to be held! */
+/* requires cfg80211_mutex to be held! */
 static struct cfg80211_registered_device *
 __cfg80211_drv_from_info(struct genl_info *info)
 {
@@ -102,7 +107,7 @@ cfg80211_get_dev_from_info(struct genl_info *info)
 {
 	struct cfg80211_registered_device *drv;
 
-	mutex_lock(&cfg80211_drv_mutex);
+	mutex_lock(&cfg80211_mutex);
 	drv = __cfg80211_drv_from_info(info);
 
 	/* if it is not an error we grab the lock on
@@ -111,7 +116,7 @@ cfg80211_get_dev_from_info(struct genl_info *info)
 	if (!IS_ERR(drv))
 		mutex_lock(&drv->mtx);
 
-	mutex_unlock(&cfg80211_drv_mutex);
+	mutex_unlock(&cfg80211_mutex);
 
 	return drv;
 }
@@ -122,7 +127,7 @@ cfg80211_get_dev_from_ifindex(int ifindex)
 	struct cfg80211_registered_device *drv = ERR_PTR(-ENODEV);
 	struct net_device *dev;
 
-	mutex_lock(&cfg80211_drv_mutex);
+	mutex_lock(&cfg80211_mutex);
 	dev = dev_get_by_index(&init_net, ifindex);
 	if (!dev)
 		goto out;
@@ -133,7 +138,7 @@ cfg80211_get_dev_from_ifindex(int ifindex)
 		drv = ERR_PTR(-ENODEV);
 	dev_put(dev);
  out:
-	mutex_unlock(&cfg80211_drv_mutex);
+	mutex_unlock(&cfg80211_mutex);
 	return drv;
 }
 
@@ -149,7 +154,7 @@ int cfg80211_dev_rename(struct cfg80211_registered_device *rdev,
 	struct cfg80211_registered_device *drv;
 	int wiphy_idx, taken = -1, result, digits;
 
-	mutex_lock(&cfg80211_drv_mutex);
+	mutex_lock(&cfg80211_mutex);
 
 	/* prohibit calling the thing phy%d when %d is not its number */
 	sscanf(newname, PHY_NAME "%d%n", &wiphy_idx, &taken);
@@ -197,7 +202,7 @@ int cfg80211_dev_rename(struct cfg80211_registered_device *rdev,
 
 	result = 0;
 out_unlock:
-	mutex_unlock(&cfg80211_drv_mutex);
+	mutex_unlock(&cfg80211_mutex);
 	if (result == 0)
 		nl80211_notify_dev_rename(rdev);
 
@@ -224,19 +229,19 @@ struct wiphy *wiphy_new(struct cfg80211_ops *ops, int sizeof_priv)
 
 	drv->ops = ops;
 
-	mutex_lock(&cfg80211_drv_mutex);
+	mutex_lock(&cfg80211_mutex);
 
 	drv->wiphy_idx = wiphy_counter++;
 
 	if (unlikely(!wiphy_idx_valid(drv->wiphy_idx))) {
 		wiphy_counter--;
-		mutex_unlock(&cfg80211_drv_mutex);
+		mutex_unlock(&cfg80211_mutex);
 		/* ugh, wrapped! */
 		kfree(drv);
 		return NULL;
 	}
 
-	mutex_unlock(&cfg80211_drv_mutex);
+	mutex_unlock(&cfg80211_mutex);
 
 	/* give it a proper name */
 	dev_set_name(&drv->wiphy.dev, PHY_NAME "%d", drv->wiphy_idx);
@@ -314,7 +319,7 @@ int wiphy_register(struct wiphy *wiphy)
 	/* check and set up bitrates */
 	ieee80211_set_bitrate_flags(wiphy);
 
-	mutex_lock(&cfg80211_drv_mutex);
+	mutex_lock(&cfg80211_mutex);
 
 	/* set up regulatory info */
 	wiphy_update_regulatory(wiphy, REGDOM_SET_BY_CORE);
@@ -334,7 +339,7 @@ int wiphy_register(struct wiphy *wiphy)
 
 	res = 0;
 out_unlock:
-	mutex_unlock(&cfg80211_drv_mutex);
+	mutex_unlock(&cfg80211_mutex);
 	return res;
 }
 EXPORT_SYMBOL(wiphy_register);
@@ -344,7 +349,7 @@ void wiphy_unregister(struct wiphy *wiphy)
 	struct cfg80211_registered_device *drv = wiphy_to_dev(wiphy);
 
 	/* protect the device list */
-	mutex_lock(&cfg80211_drv_mutex);
+	mutex_lock(&cfg80211_mutex);
 
 	BUG_ON(!list_empty(&drv->netdev_list));
 
@@ -370,7 +375,7 @@ void wiphy_unregister(struct wiphy *wiphy)
 	device_del(&drv->wiphy.dev);
 	debugfs_remove(drv->wiphy.debugfsdir);
 
-	mutex_unlock(&cfg80211_drv_mutex);
+	mutex_unlock(&cfg80211_mutex);
 }
 EXPORT_SYMBOL(wiphy_unregister);
 
diff --git a/net/wireless/core.h b/net/wireless/core.h
index 505fc10..e12eab5 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -69,7 +69,7 @@ bool wiphy_idx_valid(int wiphy_idx)
 	return (wiphy_idx >= 0);
 }
 
-extern struct mutex cfg80211_drv_mutex;
+extern struct mutex cfg80211_mutex;
 extern struct list_head cfg80211_drv_list;
 
 struct cfg80211_internal_bss {
@@ -88,13 +88,13 @@ struct cfg80211_internal_bss {
  * the driver's mutex!
  *
  * This means that you need to call cfg80211_put_dev()
- * before being allowed to acquire &cfg80211_drv_mutex!
+ * before being allowed to acquire &cfg80211_mutex!
  *
  * This is necessary because we need to lock the global
  * mutex to get an item off the list safely, and then
  * we lock the drv mutex so it doesn't go away under us.
  *
- * We don't want to keep cfg80211_drv_mutex locked
+ * We don't want to keep cfg80211_mutex locked
  * for all the time in order to allow requests on
  * other interfaces to go through at the same time.
  *
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 80741c4..db973f2 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -277,7 +277,7 @@ static int nl80211_dump_wiphy(struct sk_buff *skb, struct netlink_callback *cb)
 	int start = cb->args[0];
 	struct cfg80211_registered_device *dev;
 
-	mutex_lock(&cfg80211_drv_mutex);
+	mutex_lock(&cfg80211_mutex);
 	list_for_each_entry(dev, &cfg80211_drv_list, list) {
 		if (++idx <= start)
 			continue;
@@ -288,7 +288,7 @@ static int nl80211_dump_wiphy(struct sk_buff *skb, struct netlink_callback *cb)
 			break;
 		}
 	}
-	mutex_unlock(&cfg80211_drv_mutex);
+	mutex_unlock(&cfg80211_mutex);
 
 	cb->args[0] = idx;
 
@@ -491,7 +491,7 @@ static int nl80211_dump_interface(struct sk_buff *skb, struct netlink_callback *
 	struct cfg80211_registered_device *dev;
 	struct wireless_dev *wdev;
 
-	mutex_lock(&cfg80211_drv_mutex);
+	mutex_lock(&cfg80211_mutex);
 	list_for_each_entry(dev, &cfg80211_drv_list, list) {
 		if (wp_idx < wp_start) {
 			wp_idx++;
@@ -518,7 +518,7 @@ static int nl80211_dump_interface(struct sk_buff *skb, struct netlink_callback *
 		wp_idx++;
 	}
  out:
-	mutex_unlock(&cfg80211_drv_mutex);
+	mutex_unlock(&cfg80211_mutex);
 
 	cb->args[0] = wp_idx;
 	cb->args[1] = if_idx;
@@ -1886,9 +1886,9 @@ static int nl80211_req_set_reg(struct sk_buff *skb, struct genl_info *info)
 	if (is_world_regdom(data))
 		return -EINVAL;
 #endif
-	mutex_lock(&cfg80211_drv_mutex);
+	mutex_lock(&cfg80211_mutex);
 	r = __regulatory_hint(NULL, REGDOM_SET_BY_USER, data, 0, ENVIRON_ANY);
-	mutex_unlock(&cfg80211_drv_mutex);
+	mutex_unlock(&cfg80211_mutex);
 	/* This means the regulatory domain was already set, however
 	 * we don't want to confuse userspace with a "successful error"
 	 * message so lets just treat it as a success */
@@ -2078,7 +2078,7 @@ static int nl80211_get_reg(struct sk_buff *skb, struct genl_info *info)
 	unsigned int i;
 	int err = -EINVAL;
 
-	mutex_lock(&cfg80211_drv_mutex);
+	mutex_lock(&cfg80211_mutex);
 
 	if (!cfg80211_regdomain)
 		goto out;
@@ -2141,7 +2141,7 @@ nla_put_failure:
 	genlmsg_cancel(msg, hdr);
 	err = -EMSGSIZE;
 out:
-	mutex_unlock(&cfg80211_drv_mutex);
+	mutex_unlock(&cfg80211_mutex);
 	return err;
 }
 
@@ -2200,9 +2200,9 @@ static int nl80211_set_reg(struct sk_buff *skb, struct genl_info *info)
 
 	BUG_ON(rule_idx != num_rules);
 
-	mutex_lock(&cfg80211_drv_mutex);
+	mutex_lock(&cfg80211_mutex);
 	r = set_regdom(rd);
-	mutex_unlock(&cfg80211_drv_mutex);
+	mutex_unlock(&cfg80211_mutex);
 	return r;
 
  bad_reg:
diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 2323644..ba82312 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -1116,7 +1116,7 @@ static int ignore_request(struct wiphy *wiphy, enum reg_set_by set_by,
 	return -EINVAL;
 }
 
-/* Caller must hold &cfg80211_drv_mutex */
+/* Caller must hold &cfg80211_mutex */
 int __regulatory_hint(struct wiphy *wiphy, enum reg_set_by set_by,
 			const char *alpha2,
 			u32 country_ie_checksum,
@@ -1188,13 +1188,13 @@ void regulatory_hint(struct wiphy *wiphy, const char *alpha2)
 	int r;
 	BUG_ON(!alpha2);
 
-	mutex_lock(&cfg80211_drv_mutex);
+	mutex_lock(&cfg80211_mutex);
 	r = __regulatory_hint(wiphy, REGDOM_SET_BY_DRIVER,
 		alpha2, 0, ENVIRON_ANY);
 	/* This is required so that the orig_* parameters are saved */
 	if (r == -EALREADY && wiphy->strict_regulatory)
 		wiphy_update_regulatory(wiphy, REGDOM_SET_BY_DRIVER);
-	mutex_unlock(&cfg80211_drv_mutex);
+	mutex_unlock(&cfg80211_mutex);
 }
 EXPORT_SYMBOL(regulatory_hint);
 
@@ -1225,7 +1225,7 @@ void regulatory_hint_11d(struct wiphy *wiphy,
 	if (!last_request)
 		return;
 
-	mutex_lock(&cfg80211_drv_mutex);
+	mutex_lock(&cfg80211_mutex);
 
 	/* IE len must be evenly divisible by 2 */
 	if (country_ie_len & 0x01)
@@ -1307,7 +1307,7 @@ void regulatory_hint_11d(struct wiphy *wiphy,
 		country_ie_regdomain->alpha2, checksum, env);
 
 out:
-	mutex_unlock(&cfg80211_drv_mutex);
+	mutex_unlock(&cfg80211_mutex);
 }
 EXPORT_SYMBOL(regulatory_hint_11d);
 
@@ -1562,7 +1562,7 @@ static int __set_regdom(const struct ieee80211_regdomain *rd)
 
 /* Use this call to set the current regulatory domain. Conflicts with
  * multiple drivers can be ironed out later. Caller must've already
- * kmalloc'd the rd structure. Caller must hold cfg80211_drv_mutex */
+ * kmalloc'd the rd structure. Caller must hold cfg80211_mutex */
 int set_regdom(const struct ieee80211_regdomain *rd)
 {
 	int r;
@@ -1586,7 +1586,7 @@ int set_regdom(const struct ieee80211_regdomain *rd)
 	return r;
 }
 
-/* Caller must hold cfg80211_drv_mutex */
+/* Caller must hold cfg80211_mutex */
 void reg_device_remove(struct wiphy *wiphy)
 {
 	kfree(wiphy->regd);
@@ -1633,7 +1633,7 @@ int regulatory_init(void)
 
 void regulatory_exit(void)
 {
-	mutex_lock(&cfg80211_drv_mutex);
+	mutex_lock(&cfg80211_mutex);
 
 	reset_regdomains();
 
@@ -1644,5 +1644,5 @@ void regulatory_exit(void)
 
 	platform_device_unregister(reg_pdev);
 
-	mutex_unlock(&cfg80211_drv_mutex);
+	mutex_unlock(&cfg80211_mutex);
 }
-- 
1.6.1.2.253.ga34a

