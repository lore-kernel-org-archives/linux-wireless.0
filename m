Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE377473C84
	for <linux-wireless@vger.kernel.org>; Mon,  5 Oct 2026 10:11:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791195070; cv=none; b=DCWE2METX//7wv3S9a9jDANVGFW/hMKWMyST2sFQpDaZJVDJqbLXqfDHM/R076y+8bfuDRpCMT09rduVCwEajZ1/0Q/N5XDhlGJ5HZnXh/9FsibqmB2LPFetao91zO4roG57r0VYxRRJ5FBaCtCR428VpafbHdU2vlsERjF1074=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791195070; c=relaxed/simple;
	bh=7xAoyC5ITeGgk7aadKfIcfWFMZgv5gb/mBSrJbE6tRc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uuPG70aApzxdnJldNZuzC5Dqz7bTvsos8nmTQ8Hvl9N2cxtTF5kuE1fpg32njGk0hUl5J7o11pTNoHgMV6KvUzugyGcDIcOM3o3ueSMkPbUwnFYuOwp4SJVYrm4IoWEHIOGKZGTaEF2I9c7Iqjt0jqOH+1GJAu3l4TTGgO41DyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=tNF1S5cX; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="tNF1S5cX"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=mhzNisTmUYJNFxO6vRMhdKWYFPnM7hGsdgKDI+qhgkY=;
	t=1791195068; x=1792404668; b=tNF1S5cXT10nEv13jsCh214WqXFzsxe2Fcy09UPgAgB6x9V
	vMjnNTJtbnzfSWosdxZE5P7X0m4T0fMOUHJnjXLZhAHzmfIBYHg1fjlMXnsqRKbT2fnU/wah8bnET
	L6yfBZ1EYwsK9ztSEzB8XvFDAkYa+tiHGK4lb9Qq2pJMk44eOoGNFE944DnvEyPpZ6n4RAb7lbQDy
	Qfoo2zP3Vxw67Fc3dHDzgk4iE2mRJHdhkXPYfEtCFP8GH2LlLP058dZJARFUXXD8Je0kAxGbnuJvp
	WuITbLJeQf0wP1l7+xzN7QEq+j3370l1XOWp3lVEvA78b4ow4V6bgAwfNeIAMIvw==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xDff0-00000005CGx-22kF;
	Mon, 05 Oct 2026 12:11:06 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [RFC PATCH v2 05/13] wifi: nl80211: prepare for unlocked wdev-only ops
Date: Mon,  5 Oct 2026 12:06:21 +0200
Message-ID: <20261005121057.10bb355ab9e7.If2812b7c82df39cc9ed51746f55789fc4f51d4b1@changeid>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261005101057.1992330-15-johannes@sipsolutions.net>
References: <20261005101057.1992330-15-johannes@sipsolutions.net>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

The update-beacon operation currently can fairly easily
work without extra care and without the wiphy mutex as
it holds the netdev. However, we can't do the same now
for wdevs, they could be unregistered (and destroyed)
while the operation is running.

Allow for such operations as well by giving the wdevs a
refcount as well, and waiting for that refcount to drop
to zero during wdev unregistration.

This requires some special care in nl80211, especially
for a "re-do the operation locked" implementation, but
that's contained here so drivers need not worry about
it (except if they request the operation to be retried
under lock, that might never happen).

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/cfg80211.h |  8 +++++
 net/wireless/core.c    | 11 ++++++
 net/wireless/core.h    | 21 +++++++++++
 net/wireless/nl80211.c | 82 +++++++++++++++++++++++++++++++++---------
 4 files changed, 106 insertions(+), 16 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index ba66fb45dc12..3df72d598804 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -21,6 +21,7 @@
 #include <linux/nl80211.h>
 #include <linux/if_ether.h>
 #include <linux/ieee80211.h>
+#include <linux/refcount.h>
 #include <linux/net.h>
 #include <linux/rfkill.h>
 #include <net/regulatory.h>
@@ -7216,6 +7217,9 @@ enum ieee80211_ap_reg_power {
  * @netdev: (private) Used to reference back to the netdev, may be %NULL
  * @identifier: (private) Identifier used in nl80211 to identify this
  *	wireless device if it has no netdev
+ * @refcnt: (private) references held by nl80211 if there's no netdev,
+ *	to ensure cfg80211_unregister_wdev() cannot return while
+ *	unlocked ops are running
  * @u: union containing data specific to @iftype
  * @connected: indicates if connected or not (STA mode)
  * @wext: (private) Used by the internal wireless extensions compat code
@@ -7281,6 +7285,7 @@ struct wireless_dev {
 	struct net_device *netdev;
 
 	u32 identifier;
+	refcount_t refcnt;
 
 	struct list_head mgmt_registrations;
 	u8 mgmt_registrations_need_update:1;
@@ -10159,6 +10164,9 @@ u32 cfg80211_calculate_bitrate(struct rate_info *rate);
  * when the driver wishes to unregister the wdev, e.g. when the hardware device
  * is unbound from the driver.
  *
+ * Note that unlocked operations can run concurrently until this returns, so be
+ * careful about ordering.
+ *
  * Context: Requires the RTNL and wiphy mutex to be held.
  */
 void cfg80211_unregister_wdev(struct wireless_dev *wdev);
diff --git a/net/wireless/core.c b/net/wireless/core.c
index dcade9e8c27c..589e16b0142f 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -1502,6 +1502,16 @@ static void _cfg80211_unregister_wdev(struct wireless_dev *wdev,
 
 	list_del_rcu(&wdev->list);
 	synchronize_net();
+
+	/*
+	 * After synchronize_net() any lookups under RCU either have
+	 * references (must wdev_hold() inside the critical section)
+	 * or can't find this wdev anymore. Wait for any wdev_hold()
+	 * users on a pure wdev to get to dev_put().
+	 */
+	if (!wdev->netdev && !refcount_dec_and_test(&wdev->refcnt))
+		wait_var_event(&wdev->refcnt, !refcount_read(&wdev->refcnt));
+
 	rdev->devlist_generation++;
 	wiphy_work_cancel(wdev->wiphy, &wdev->disconnect_wk);
 
@@ -1688,6 +1698,7 @@ EXPORT_SYMBOL(cfg80211_stop_link);
 
 void cfg80211_init_wdev(struct wireless_dev *wdev)
 {
+	refcount_set(&wdev->refcnt, 1);
 	INIT_LIST_HEAD(&wdev->event_list);
 	spin_lock_init(&wdev->event_lock);
 	INIT_LIST_HEAD(&wdev->mgmt_registrations);
diff --git a/net/wireless/core.h b/net/wireless/core.h
index dfcb9ed5035b..220544a6bb83 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -14,6 +14,7 @@
 #include <linux/rfkill.h>
 #include <linux/workqueue.h>
 #include <linux/rtnetlink.h>
+#include <linux/wait_bit.h>
 #include <net/genetlink.h>
 #include <net/cfg80211.h>
 #include "reg.h"
@@ -259,6 +260,26 @@ void cfg80211_init_wdev(struct wireless_dev *wdev);
 void cfg80211_register_wdev(struct cfg80211_registered_device *rdev,
 			    struct wireless_dev *wdev);
 
+static inline void wdev_hold(struct wireless_dev *wdev)
+{
+	if (wdev->netdev) {
+		dev_hold(wdev->netdev);
+		return;
+	}
+
+	/* also not RTNL, but can't check that */
+	lockdep_assert_not_held(&wdev->wiphy->mtx);
+	refcount_inc(&wdev->refcnt);
+}
+
+static inline void wdev_put(struct wireless_dev *wdev)
+{
+	if (wdev->netdev)
+		dev_put(wdev->netdev);
+	else if (refcount_dec_and_test(&wdev->refcnt))
+		wake_up_var(&wdev->refcnt);
+}
+
 static inline bool cfg80211_has_monitors_only(struct cfg80211_registered_device *rdev)
 {
 	lockdep_assert_held(&rdev->wiphy.mtx);
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index ba57d8e29cb5..5b60ce830da0 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -266,6 +266,34 @@ nl80211_lock_and_recheck(struct cfg80211_registered_device *rdev,
 	return ERR_PTR(-ENODEV);
 }
 
+/*
+ * Must have wdev_hold(), acquire the wiphy mutex. This has to
+ * look up the wdev again (otherwise it could deadlock against
+ * wdev removal), so it can return an error pointer.
+ */
+static struct wireless_dev *
+nl80211_lock_held_wdev(struct cfg80211_registered_device *rdev,
+		       struct genl_info *info, struct wireless_dev *wdev)
+{
+	u32 wdev_id = wdev->identifier;
+
+	/* the wdev reference was keeping the wiphy alive */
+	get_device(&rdev->wiphy.dev);
+	info->user_ptr[1] = NULL;
+	wdev_put(wdev);
+
+	wdev = nl80211_lock_and_recheck(rdev, genl_info_net(info), wdev_id);
+	if (IS_ERR(wdev))
+		return wdev;
+
+	if (!wdev_running(wdev)) {
+		wiphy_unlock(&rdev->wiphy);
+		return ERR_PTR(-ENETDOWN);
+	}
+
+	return wdev;
+}
+
 static int validate_beacon_head(const struct nlattr *attr,
 				struct netlink_ext_ack *extack)
 {
@@ -19869,14 +19897,10 @@ nl80211_epcs_cfg(struct sk_buff *skb, struct genl_info *info)
 
 /*
  * Note: a
- *	SELECTOR(...,
- *		 NL80211_FLAG_NO_WIPHY_MTX |
- *		 NL80211_FLAG_NEED_WDEV)
- * or
  *	SELECTOR(..., NL80211_FLAG_NO_WIPHY_MTX)
  *
- * isn't valid - nothing would ensure the device stays around,
- * need at least a netdev, the wiphy mutex, or RTNL.
+ * isn't valid - nothing would ensure the device stays around, need
+ * at least a wdev/netdev reference, the wiphy mutex, or RTNL.
  */
 
 enum nl80211_internal_flags_selector {
@@ -19891,6 +19915,13 @@ static u32 nl80211_internal_flags[] = {
 #undef SELECTOR
 };
 
+/* without RTNL or wiphy mutex, a wdev reference keeps everything alive */
+static bool nl80211_need_wdev_ref(u32 internal_flags)
+{
+	return !(internal_flags & NL80211_FLAG_NEED_RTNL) &&
+	       internal_flags & NL80211_FLAG_NO_WIPHY_MTX;
+}
+
 static int nl80211_pre_doit(const struct genl_split_ops *ops,
 			    struct sk_buff *skb,
 			    struct genl_info *info)
@@ -19899,7 +19930,7 @@ static int nl80211_pre_doit(const struct genl_split_ops *ops,
 	struct net *netns = genl_info_net(info);
 	struct wireless_dev *wdev = NULL;
 	struct net_device *dev = NULL;
-	bool need_rtnl, locked = false;
+	bool need_rtnl, wdev_ref, locked = false;
 	u32 internal_flags, wdev_id = 0;
 	int err;
 
@@ -19908,6 +19939,7 @@ static int nl80211_pre_doit(const struct genl_split_ops *ops,
 
 	internal_flags = nl80211_internal_flags[ops->internal_flags];
 	need_rtnl = internal_flags & NL80211_FLAG_NEED_RTNL;
+	wdev_ref = nl80211_need_wdev_ref(internal_flags);
 
 	if (need_rtnl)
 		rtnl_lock();
@@ -19929,7 +19961,16 @@ static int nl80211_pre_doit(const struct genl_split_ops *ops,
 		}
 
 		dev = wdev->netdev;
-		dev_hold(dev);
+		/*
+		 * Take the wdev ref only if we need it (wdev_ref is true when
+		 * the op is unlocked), we must not try to acquire this with
+		 * a wdev pointer protected by locking, it'd deadlock against
+		 * unregistration.
+		 */
+		if (wdev_ref)
+			wdev_hold(wdev);
+		else
+			dev_hold(dev);
 		rdev = wiphy_to_rdev(wdev->wiphy);
 	}
 
@@ -19962,12 +20003,12 @@ static int nl80211_pre_doit(const struct genl_split_ops *ops,
 		locked = true;
 	} else if (rdev && !need_rtnl) {
 		/*
-		 * Without any mutex need a netdev to keep it alive, see
-		 * also the note about selectors - the WARN can't happen
+		 * Without any mutex need a wdev reference to keep it alive,
+		 * see also the note about selectors - the WARN can't happen
 		 * without wrong selectors and those don't exist.
 		 */
 		put_device(&rdev->wiphy.dev);
-		if (WARN_ON(!dev)) {
+		if (WARN_ON(!wdev)) {
 			err = -EINVAL;
 			goto out;
 		}
@@ -20032,7 +20073,10 @@ static int nl80211_pre_doit(const struct genl_split_ops *ops,
 out:
 	if (locked)
 		wiphy_unlock(&rdev->wiphy);
-	dev_put(dev);
+	if (wdev_ref && wdev)
+		wdev_put(wdev);
+	else
+		dev_put(dev);
 	if (need_rtnl)
 		rtnl_unlock();
 	return err;
@@ -20049,17 +20093,23 @@ static void nl80211_post_doit(const struct genl_split_ops *ops,
 			      struct genl_info *info)
 {
 	u32 internal_flags = nl80211_internal_flags[ops->internal_flags];
+	struct wireless_dev *wdev = NULL;
+	struct net_device *dev = NULL;
 
 	if (info->user_ptr[1]) {
 		if (internal_flags & NL80211_FLAG_NEED_WDEV) {
-			struct wireless_dev *wdev = info->user_ptr[1];
-
-			dev_put(wdev->netdev);
+			wdev = info->user_ptr[1];
+			dev = wdev->netdev;
 		} else {
-			dev_put(info->user_ptr[1]);
+			dev = info->user_ptr[1];
 		}
 	}
 
+	if (wdev && nl80211_need_wdev_ref(internal_flags))
+		wdev_put(wdev);
+	else
+		dev_put(dev);
+
 	if (info->user_ptr[0] &&
 	    !(internal_flags & NL80211_FLAG_NO_WIPHY_MTX)) {
 		struct cfg80211_registered_device *rdev = info->user_ptr[0];
-- 
2.55.0

