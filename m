Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:18470 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751609AbaCKOSO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Mar 2014 10:18:14 -0400
From: Luciano Coelho <luciano.coelho@intel.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, michal.kazior@tieto.com,
	sw@simonwunderlich.de, andrei.otcheretianski@intel.com,
	eliad@wizery.com
Subject: [PATCH v10 5/5] cfg80211/mac80211: move more combination checks to mac80211
Date: Tue, 11 Mar 2014 16:16:34 +0200
Message-Id: <1394547394-3910-6-git-send-email-luciano.coelho@intel.com> (sfid-20140311_151817_761503_F27EE18F)
In-Reply-To: <1394547394-3910-1-git-send-email-luciano.coelho@intel.com>
References: <1394547394-3910-1-git-send-email-luciano.coelho@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Get rid of the cfg80211_can_add_interface() and
cfg80211_can_change_interface() functions by moving that functionality
to mac80211.  With this patch all interface combination checks are now
out of cfg80211 (except for the channel switch case which will be
addressed in a future commit).

Additionally, modify the ieee80211_check_combinations() function so
that an undefined chandef can be passed, in order to use it before a
channel is defined.

Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
---
 net/mac80211/cfg.c     |  9 +++++++++
 net/mac80211/iface.c   |  6 +++++-
 net/mac80211/util.c    | 10 +++++++---
 net/wireless/core.c    | 11 +++--------
 net/wireless/core.h    | 22 ----------------------
 net/wireless/nl80211.c |  5 ++---
 net/wireless/util.c    |  5 -----
 7 files changed, 26 insertions(+), 42 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 9b555e0..fae76f7 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -109,6 +109,15 @@ static int ieee80211_change_iface(struct wiphy *wiphy,
 static int ieee80211_start_p2p_device(struct wiphy *wiphy,
 				      struct wireless_dev *wdev)
 {
+	struct ieee80211_sub_if_data *sdata = IEEE80211_WDEV_TO_SUB_IF(wdev);
+	int ret;
+
+	mutex_lock(&sdata->local->chanctx_mtx);
+	ret = ieee80211_check_combinations(sdata, NULL, 0, 0);
+	mutex_unlock(&sdata->local->chanctx_mtx);
+	if (ret < 0)
+		return ret;
+
 	return ieee80211_do_open(wdev, true);
 }
 
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index be198f4..4c55481 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -250,6 +250,7 @@ static int ieee80211_check_concurrent_iface(struct ieee80211_sub_if_data *sdata,
 {
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_sub_if_data *nsdata;
+	int ret;
 
 	ASSERT_RTNL();
 
@@ -300,7 +301,10 @@ static int ieee80211_check_concurrent_iface(struct ieee80211_sub_if_data *sdata,
 		}
 	}
 
-	return 0;
+	mutex_lock(&local->chanctx_mtx);
+	ret = ieee80211_check_combinations(sdata, NULL, 0, 0);
+	mutex_unlock(&local->chanctx_mtx);
+	return ret;
 }
 
 static int ieee80211_check_queues(struct ieee80211_sub_if_data *sdata,
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 3972b64..955b043 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -2812,7 +2812,7 @@ int ieee80211_check_combinations(struct ieee80211_sub_if_data *sdata,
 	enum nl80211_iftype iftype = sdata->wdev.iftype;
 	int num[NUM_NL80211_IFTYPES];
 	struct ieee80211_chanctx *ctx;
-	int num_different_channels = 1;
+	int num_different_channels = 0;
 	int total = 1;
 
 	lockdep_assert_held(&local->chanctx_mtx);
@@ -2820,9 +2820,13 @@ int ieee80211_check_combinations(struct ieee80211_sub_if_data *sdata,
 	if (WARN_ON(hweight32(radar_detect) > 1))
 		return -EINVAL;
 
-	if (WARN_ON(chanmode == IEEE80211_CHANCTX_SHARED && !chandef->chan))
+	if (WARN_ON(chandef && chanmode == IEEE80211_CHANCTX_SHARED &&
+		    !chandef->chan))
 		return -EINVAL;
 
+	if (chandef)
+		num_different_channels = 1;
+
 	if (WARN_ON(iftype >= NUM_NL80211_IFTYPES))
 		return -EINVAL;
 
@@ -2845,7 +2849,7 @@ int ieee80211_check_combinations(struct ieee80211_sub_if_data *sdata,
 			num_different_channels++;
 			continue;
 		}
-		if ((chanmode == IEEE80211_CHANCTX_SHARED) &&
+		if (chandef && chanmode == IEEE80211_CHANCTX_SHARED &&
 		    cfg80211_chandef_compatible(chandef,
 						&ctx->conf.def))
 			continue;
diff --git a/net/wireless/core.c b/net/wireless/core.c
index 276cf93..7fca03e 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -396,10 +396,7 @@ static int wiphy_verify_combinations(struct wiphy *wiphy)
 		for (j = 0; j < c->n_limits; j++) {
 			u16 types = c->limits[j].types;
 
-			/*
-			 * interface types shouldn't overlap, this is
-			 * used in cfg80211_can_change_interface()
-			 */
+			/* interface types shouldn't overlap */
 			if (WARN_ON(types & all_iftypes))
 				return -EINVAL;
 			all_iftypes |= types;
@@ -798,7 +795,6 @@ static int cfg80211_netdev_notifier_call(struct notifier_block *nb,
 	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	struct cfg80211_registered_device *rdev;
-	int ret;
 
 	if (!wdev)
 		return NOTIFY_DONE;
@@ -961,9 +957,8 @@ static int cfg80211_netdev_notifier_call(struct notifier_block *nb,
 	case NETDEV_PRE_UP:
 		if (!(wdev->wiphy->interface_modes & BIT(wdev->iftype)))
 			return notifier_from_errno(-EOPNOTSUPP);
-		ret = cfg80211_can_add_interface(rdev, wdev->iftype);
-		if (ret)
-			return notifier_from_errno(ret);
+		if (rfkill_blocked(rdev->rfkill))
+			return notifier_from_errno(-ERFKILL);
 		break;
 	}
 
diff --git a/net/wireless/core.h b/net/wireless/core.h
index 4a930ef..53f1996 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -406,28 +406,6 @@ unsigned int
 cfg80211_chandef_dfs_cac_time(struct wiphy *wiphy,
 			      const struct cfg80211_chan_def *chandef);
 
-static inline int
-cfg80211_can_change_interface(struct cfg80211_registered_device *rdev,
-			      struct wireless_dev *wdev,
-			      enum nl80211_iftype iftype)
-{
-	/* TODO: For this function, we'll probably need to keep some
-	 * kind of interface combination check in cfg80211...
-	 */
-	return cfg80211_can_use_iftype_chan(rdev, wdev, iftype, NULL,
-					    CHAN_MODE_UNDEFINED, 0);
-}
-
-static inline int
-cfg80211_can_add_interface(struct cfg80211_registered_device *rdev,
-			   enum nl80211_iftype iftype)
-{
-	if (rfkill_blocked(rdev->rfkill))
-		return -ERFKILL;
-
-	return cfg80211_can_change_interface(rdev, NULL, iftype);
-}
-
 static inline unsigned int elapsed_jiffies_msecs(unsigned long start)
 {
 	unsigned long end = jiffies;
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 07253bf..5465e0e 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -8957,9 +8957,8 @@ static int nl80211_start_p2p_device(struct sk_buff *skb, struct genl_info *info)
 	if (wdev->p2p_started)
 		return 0;
 
-	err = cfg80211_can_add_interface(rdev, wdev->iftype);
-	if (err)
-		return err;
+	if (rfkill_blocked(rdev->rfkill))
+		return -ERFKILL;
 
 	err = rdev_start_p2p_device(rdev, wdev);
 	if (err)
diff --git a/net/wireless/util.c b/net/wireless/util.c
index 1069a24..b9deec2 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -873,11 +873,6 @@ int cfg80211_change_iface(struct cfg80211_registered_device *rdev,
 		return -EBUSY;
 
 	if (ntype != otype && netif_running(dev)) {
-		err = cfg80211_can_change_interface(rdev, dev->ieee80211_ptr,
-						    ntype);
-		if (err)
-			return err;
-
 		dev->ieee80211_ptr->use_4addr = false;
 		dev->ieee80211_ptr->mesh_id_up_len = 0;
 		wdev_lock(dev->ieee80211_ptr);
-- 
1.9.0

