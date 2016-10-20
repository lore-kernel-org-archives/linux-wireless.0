Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:50347 "EHLO
        mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752793AbcJTTI3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 20 Oct 2016 15:08:29 -0400
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH] cfg80211: add generic helper to check interface is running
Date: Thu, 20 Oct 2016 20:08:22 +0100
Message-Id: <1476990502-32472-1-git-send-email-arend.vanspriel@broadcom.com> (sfid-20161020_210833_470096_4F107B78)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Adding a helper using wdev to check if interface is running. This
deals with both non-netdev and netdev interfaces. In struct
wireless_dev replacing 'p2p_started' and 'nan_started' by
'is_running' as those are mutual exclusive anyway.

Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
 include/net/cfg80211.h | 13 +++++++++---
 net/wireless/core.c    |  8 ++++----
 net/wireless/nl80211.c | 54 +++++++++++++++-----------------------------------
 3 files changed, 30 insertions(+), 45 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 2bbbcc3..0010e5a 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -3781,8 +3781,8 @@ static inline struct wiphy *wiphy_new(const struct cfg80211_ops *ops,
  * @beacon_interval: beacon interval used on this device for transmitting
  *	beacons, 0 when not valid
  * @address: The address for this device, valid only if @netdev is %NULL
- * @p2p_started: true if this is a P2P Device that has been started
- * @nan_started: true if this is a NAN interface that has been started
+ * @is_running: true if this is a non-netdev device that has been started, eg.
+ *	like the P2P Device.
  * @cac_started: true if DFS channel availability check has been started
  * @cac_start_time: timestamp (jiffies) when the dfs state was entered.
  * @cac_time_ms: CAC time in ms
@@ -3814,7 +3814,7 @@ struct wireless_dev {
 
 	struct mutex mtx;
 
-	bool use_4addr, p2p_started, nan_started;
+	bool use_4addr, is_running;
 
 	u8 address[ETH_ALEN] __aligned(sizeof(u16));
 
@@ -3871,6 +3871,13 @@ static inline u8 *wdev_address(struct wireless_dev *wdev)
 	return wdev->address;
 }
 
+static inline bool wdev_is_running(struct wireless_dev *wdev)
+{
+	if (wdev->netdev)
+		return netif_running(wdev->netdev);
+	return wdev->is_running;
+}
+
 /**
  * wdev_priv - return wiphy priv from wireless_dev
  *
diff --git a/net/wireless/core.c b/net/wireless/core.c
index f433f15..088ba44 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -210,11 +210,11 @@ void cfg80211_stop_p2p_device(struct cfg80211_registered_device *rdev,
 	if (WARN_ON(wdev->iftype != NL80211_IFTYPE_P2P_DEVICE))
 		return;
 
-	if (!wdev->p2p_started)
+	if (!wdev_is_running(wdev))
 		return;
 
 	rdev_stop_p2p_device(rdev, wdev);
-	wdev->p2p_started = false;
+	wdev->is_running = false;
 
 	rdev->opencount--;
 
@@ -233,11 +233,11 @@ void cfg80211_stop_nan(struct cfg80211_registered_device *rdev,
 	if (WARN_ON(wdev->iftype != NL80211_IFTYPE_NAN))
 		return;
 
-	if (!wdev->nan_started)
+	if (!wdev_is_running(wdev))
 		return;
 
 	rdev_stop_nan(rdev, wdev);
-	wdev->nan_started = false;
+	wdev->is_running = false;
 
 	rdev->opencount--;
 }
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index fcf5b4f..e37801e 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -10528,7 +10528,7 @@ static int nl80211_start_p2p_device(struct sk_buff *skb, struct genl_info *info)
 	if (wdev->iftype != NL80211_IFTYPE_P2P_DEVICE)
 		return -EOPNOTSUPP;
 
-	if (wdev->p2p_started)
+	if (wdev_is_running(wdev))
 		return 0;
 
 	if (rfkill_blocked(rdev->rfkill))
@@ -10538,7 +10538,7 @@ static int nl80211_start_p2p_device(struct sk_buff *skb, struct genl_info *info)
 	if (err)
 		return err;
 
-	wdev->p2p_started = true;
+	wdev->is_running = true;
 	rdev->opencount++;
 
 	return 0;
@@ -10570,7 +10570,7 @@ static int nl80211_start_nan(struct sk_buff *skb, struct genl_info *info)
 	if (wdev->iftype != NL80211_IFTYPE_NAN)
 		return -EOPNOTSUPP;
 
-	if (wdev->nan_started)
+	if (!wdev_is_running(wdev))
 		return -EEXIST;
 
 	if (rfkill_blocked(rdev->rfkill))
@@ -10593,7 +10593,7 @@ static int nl80211_start_nan(struct sk_buff *skb, struct genl_info *info)
 	if (err)
 		return err;
 
-	wdev->nan_started = true;
+	wdev->is_running = true;
 	rdev->opencount++;
 
 	return 0;
@@ -10678,7 +10678,7 @@ static int nl80211_nan_add_func(struct sk_buff *skb,
 	if (wdev->iftype != NL80211_IFTYPE_NAN)
 		return -EOPNOTSUPP;
 
-	if (!wdev->nan_started)
+	if (!wdev_is_running(wdev))
 		return -ENOTCONN;
 
 	if (!info->attrs[NL80211_ATTR_NAN_FUNC])
@@ -10915,7 +10915,7 @@ static int nl80211_nan_del_func(struct sk_buff *skb,
 	if (wdev->iftype != NL80211_IFTYPE_NAN)
 		return -EOPNOTSUPP;
 
-	if (!wdev->nan_started)
+	if (!wdev_is_running(wdev))
 		return -ENOTCONN;
 
 	if (!info->attrs[NL80211_ATTR_COOKIE])
@@ -10943,7 +10943,7 @@ static int nl80211_nan_change_config(struct sk_buff *skb,
 	if (wdev->iftype != NL80211_IFTYPE_NAN)
 		return -EOPNOTSUPP;
 
-	if (!wdev->nan_started)
+	if (!wdev_is_running(wdev))
 		return -ENOTCONN;
 
 	if (info->attrs[NL80211_ATTR_NAN_MASTER_PREF]) {
@@ -11255,11 +11255,7 @@ static int nl80211_vendor_cmd(struct sk_buff *skb, struct genl_info *info)
 				return -EINVAL;
 
 			if (vcmd->flags & WIPHY_VENDOR_CMD_NEED_RUNNING) {
-				if (wdev->netdev &&
-				    !netif_running(wdev->netdev))
-					return -ENETDOWN;
-				if (!wdev->netdev && !wdev->p2p_started &&
-				    !wdev->nan_started)
+				if (!wdev_is_running(wdev))
 					return -ENETDOWN;
 			}
 
@@ -11422,10 +11418,7 @@ static int nl80211_vendor_cmd_dump(struct sk_buff *skb,
 			return -EINVAL;
 
 		if (vcmd->flags & WIPHY_VENDOR_CMD_NEED_RUNNING) {
-			if (wdev->netdev &&
-			    !netif_running(wdev->netdev))
-				return -ENETDOWN;
-			if (!wdev->netdev && !wdev->p2p_started)
+			if (!wdev_is_running(wdev))
 				return -ENETDOWN;
 		}
 	}
@@ -11796,29 +11789,14 @@ static int nl80211_pre_doit(const struct genl_ops *ops, struct sk_buff *skb,
 			info->user_ptr[1] = wdev;
 		}
 
-		if (dev) {
-			if (ops->internal_flags & NL80211_FLAG_CHECK_NETDEV_UP &&
-			    !netif_running(dev)) {
-				if (rtnl)
-					rtnl_unlock();
-				return -ENETDOWN;
-			}
-
-			dev_hold(dev);
-		} else if (ops->internal_flags & NL80211_FLAG_CHECK_NETDEV_UP) {
-			if (wdev->iftype == NL80211_IFTYPE_P2P_DEVICE &&
-			    !wdev->p2p_started) {
-				if (rtnl)
-					rtnl_unlock();
-				return -ENETDOWN;
-			}
-			if (wdev->iftype == NL80211_IFTYPE_NAN &&
-			    !wdev->nan_started) {
-				if (rtnl)
-					rtnl_unlock();
-				return -ENETDOWN;
-			}
+		if (ops->internal_flags & NL80211_FLAG_CHECK_NETDEV_UP &&
+		    !wdev_is_running(wdev)) {
+			if (rtnl)
+				rtnl_unlock();
+			return -ENETDOWN;
 		}
+		if (dev)
+			dev_hold(dev);
 
 		info->user_ptr[0] = rdev;
 	}
-- 
1.9.1
