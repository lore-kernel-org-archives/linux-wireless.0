Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:57973 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751540AbZFTLRU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 20 Jun 2009 07:17:20 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH] [compat-2.6] change symbol rfkill_unregister to backport_rfkill_unregister
Date: Sat, 20 Jun 2009 13:17:15 +0200
Message-Id: <1245496635-13560-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In include/linux/rfkill_backport.h "backport_" in front of rfkill_unregister was missing.
Update compat.diff

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 compat/compat.diff |   27 ++++++++++++++-------------
 1 files changed, 14 insertions(+), 13 deletions(-)

diff --git a/compat/compat.diff b/compat/compat.diff
index cff2479..0797d79 100644
--- a/compat/compat.diff
+++ b/compat/compat.diff
@@ -442,7 +442,7 @@
  
 --- a/drivers/net/wireless/mac80211_hwsim.c
 +++ b/drivers/net/wireless/mac80211_hwsim.c
-@@ -734,16 +734,22 @@ static struct device_driver mac80211_hwsim_driver = {
+@@ -744,16 +744,22 @@ static struct device_driver mac80211_hwsim_driver = {
  	.name = "mac80211_hwsim"
  };
  
@@ -633,7 +633,7 @@
  	     struct device *parent,
  	     const enum rfkill_type type,
  	     const struct rfkill_ops *ops,
-@@ -293,18 +293,18 @@ rfkill_alloc(const char *name,
+@@ -293,61 +293,61 @@ rfkill_alloc(const char *name,
  	return ERR_PTR(-ENODEV);
  }
  
@@ -655,7 +655,8 @@
  {
  }
  
-@@ -312,42 +312,42 @@ static inline void rfkill_unregister(struct rfkill *rfkill)
+-static inline void rfkill_unregister(struct rfkill *rfkill)
++static inline void backport_rfkill_unregister(struct rfkill *rfkill)
  {
  }
  
@@ -1231,7 +1232,7 @@
  
  	if (!drv->rfkill) {
  		kfree(drv);
-@@ -399,7 +409,11 @@ int wiphy_register(struct wiphy *wiphy)
+@@ -396,7 +406,11 @@ int wiphy_register(struct wiphy *wiphy)
  	if (res)
  		return res;
  
@@ -1243,7 +1244,7 @@
  	if (res)
  		goto out_rm_dev;
  
-@@ -447,7 +461,11 @@ void wiphy_rfkill_start_polling(struct wiphy *wiphy)
+@@ -444,7 +458,11 @@ void wiphy_rfkill_start_polling(struct wiphy *wiphy)
  	if (!drv->ops->rfkill_poll)
  		return;
  	drv->rfkill_ops.poll = cfg80211_rfkill_poll;
@@ -1255,7 +1256,7 @@
  }
  EXPORT_SYMBOL(wiphy_rfkill_start_polling);
  
-@@ -455,7 +473,11 @@ void wiphy_rfkill_stop_polling(struct wiphy *wiphy)
+@@ -452,7 +470,11 @@ void wiphy_rfkill_stop_polling(struct wiphy *wiphy)
  {
  	struct cfg80211_registered_device *drv = wiphy_to_dev(wiphy);
  
@@ -1267,7 +1268,7 @@
  }
  EXPORT_SYMBOL(wiphy_rfkill_stop_polling);
  
-@@ -463,7 +485,11 @@ void wiphy_unregister(struct wiphy *wiphy)
+@@ -460,7 +482,11 @@ void wiphy_unregister(struct wiphy *wiphy)
  {
  	struct cfg80211_registered_device *drv = wiphy_to_dev(wiphy);
  
@@ -1279,7 +1280,7 @@
  
  	/* protect the device list */
  	mutex_lock(&cfg80211_mutex);
-@@ -501,7 +527,11 @@ EXPORT_SYMBOL(wiphy_unregister);
+@@ -498,7 +524,11 @@ EXPORT_SYMBOL(wiphy_unregister);
  void cfg80211_dev_free(struct cfg80211_registered_device *drv)
  {
  	struct cfg80211_internal_bss *scan, *tmp;
@@ -1291,7 +1292,7 @@
  	mutex_destroy(&drv->mtx);
  	mutex_destroy(&drv->devlist_mtx);
  	list_for_each_entry_safe(scan, tmp, &drv->bss_list, list)
-@@ -519,7 +549,11 @@ void wiphy_rfkill_set_hw_state(struct wiphy *wiphy, bool blocked)
+@@ -516,7 +546,11 @@ void wiphy_rfkill_set_hw_state(struct wiphy *wiphy, bool blocked)
  {
  	struct cfg80211_registered_device *drv = wiphy_to_dev(wiphy);
  
@@ -1303,7 +1304,7 @@
  		schedule_work(&drv->rfkill_sync);
  }
  EXPORT_SYMBOL(wiphy_rfkill_set_hw_state);
-@@ -579,7 +613,11 @@ static int cfg80211_netdev_notifier_call(struct notifier_block * nb,
+@@ -576,7 +610,11 @@ static int cfg80211_netdev_notifier_call(struct notifier_block * nb,
  		mutex_unlock(&rdev->devlist_mtx);
  		break;
  	case NETDEV_PRE_UP:
@@ -1393,7 +1394,7 @@
  		/* this "consumes" the reference */
 --- a/net/wireless/wext-compat.c
 +++ b/net/wireless/wext-compat.c
-@@ -764,7 +764,11 @@ int cfg80211_wext_siwtxpower(struct net_device *dev,
+@@ -783,7 +783,11 @@ int cfg80211_wext_siwtxpower(struct net_device *dev,
  
  	/* only change when not disabling */
  	if (!data->txpower.disabled) {
@@ -1405,7 +1406,7 @@
  
  		if (data->txpower.fixed) {
  			/*
-@@ -789,7 +793,11 @@ int cfg80211_wext_siwtxpower(struct net_device *dev,
+@@ -808,7 +812,11 @@ int cfg80211_wext_siwtxpower(struct net_device *dev,
  			}
  		}
  	} else {
@@ -1417,7 +1418,7 @@
  		schedule_work(&rdev->rfkill_sync);
  		return 0;
  	}
-@@ -820,7 +828,11 @@ int cfg80211_wext_giwtxpower(struct net_device *dev,
+@@ -839,7 +847,11 @@ int cfg80211_wext_giwtxpower(struct net_device *dev,
  
  	/* well... oh well */
  	data->txpower.fixed = 1;
-- 
1.6.2.1

