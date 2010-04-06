Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:34939 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753744Ab0DFUnw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Apr 2010 16:43:52 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org,
	michael-dev@fami-braun.de, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH] compat-wireless: use wireless_handlers for wext functions.
Date: Tue,  6 Apr 2010 22:43:44 +0200
Message-Id: <1270586624-11410-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The struct wiphy changes in kernel versions so old kernels compiled with
a different version of struct wiphy than compat-wireless are unable to
dereference the pointer to the functions in cfg80211_wext_handler
correctly. This causes oops on kernel >= 2.6.33 when using wext with
cfg80211.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
This was tested with kernel 2.6.33 with and without this patch.
 config.mk                                    |   13 -------------
 patches/10-add-wext-handlers-to-netdev.patch |   24 +++++++++++++++++++-----
 patches/14-device-type.patch                 |    2 +-
 3 files changed, 20 insertions(+), 19 deletions(-)

diff --git a/config.mk b/config.mk
index a34fcb6..6a7c5c9 100644
--- a/config.mk
+++ b/config.mk
@@ -161,22 +161,9 @@ CONFIG_BT_CMTP=m
 endif
 CONFIG_BT_HIDP=m
 
-ifdef CONFIG_COMPAT_KERNEL_32
-# Old kernels stil do depend on CONFIG_WIRELESS_EXT
-# as we add the wireless handler back to the struct
-# netdevice
 ifneq ($(CONFIG_WIRELESS_EXT),)
 CONFIG_CFG80211_WEXT=y
 endif
-else
-# 2.6.33 and above do not need CONFIG_WIRELESS_EXT, but the
-# reality is we should select CONFIG_WIRELESS_EXT only if a
-# driver claims for it (one of the old non-cfg80211 drivers).
-# Then users could either have this on or off but we leave it
-# on in case users on >= 2.6.33 still have iwconfig and other
-# old deprecated userspace applications.
-CONFIG_CFG80211_WEXT=y
-endif # CONFIG_COMPAT_KERNEL_32
 
 # mac80211 test driver
 CONFIG_MAC80211_HWSIM=m
diff --git a/patches/10-add-wext-handlers-to-netdev.patch b/patches/10-add-wext-handlers-to-netdev.patch
index 31bc421..31971a7 100644
--- a/patches/10-add-wext-handlers-to-netdev.patch
+++ b/patches/10-add-wext-handlers-to-netdev.patch
@@ -8,19 +8,33 @@ anymore when backporting code, this adds the wext handler
 back to the netdevice wireless_handlers to let compat
 users use wext again.
 
-We only do this for kernels <= 2.6.32 as 2.6.33 will use
-the struct wiphy wireless handler.
+We do this for every kernel version because the struct wiphy
+is changing from kernel version to version. At least the
+struct from kernel 2.6.33 and 2.6.34 are incompatible and
+the kernel would dereference some wrong type in the struct
+and oops. The old interface is not affected by this. This
+will cause that CONFIG_CFG80211_WEXT still depends on
+CONFIG_WIRELESS_EXT in compat-wireless.
 
 --- a/net/wireless/core.c
 +++ b/net/wireless/core.c
-@@ -702,6 +702,10 @@ static int cfg80211_netdev_notifier_call
+@@ -361,10 +361,6 @@ struct wiphy *wiphy_new(const struct cfg
+ 	INIT_LIST_HEAD(&rdev->bss_list);
+ 	INIT_WORK(&rdev->scan_done_wk, __cfg80211_scan_done);
+ 
+-#ifdef CONFIG_CFG80211_WEXT
+-	rdev->wiphy.wext = &cfg80211_wext_handler;
+-#endif
+-
+ 	device_initialize(&rdev->wiphy.dev);
+ 	rdev->wiphy.dev.class = &ieee80211_class;
+ 	rdev->wiphy.dev.platform_data = rdev;
+@@ -702,6 +698,8 @@ static int cfg80211_netdev_notifier_call
  		wdev->sme_state = CFG80211_SME_IDLE;
  		mutex_unlock(&rdev->devlist_mtx);
  #ifdef CONFIG_CFG80211_WEXT
-+#if (LINUX_VERSION_CODE <= KERNEL_VERSION(2,6,32))
 +		if (!dev->wireless_handlers)
 +			dev->wireless_handlers = &cfg80211_wext_handler;
-+#endif
  		wdev->wext.default_key = -1;
  		wdev->wext.default_mgmt_key = -1;
  		wdev->wext.connect.auth_type = NL80211_AUTHTYPE_AUTOMATIC;
diff --git a/patches/14-device-type.patch b/patches/14-device-type.patch
index b0b2216..f6f41c7 100644
--- a/patches/14-device-type.patch
+++ b/patches/14-device-type.patch
@@ -8,7 +8,7 @@ compile warning.
 
 --- a/net/wireless/core.c
 +++ b/net/wireless/core.c
-@@ -649,9 +649,11 @@ static void wdev_cleanup_work(struct wor
+@@ -645,9 +645,11 @@ static void wdev_cleanup_work(struct wor
  	dev_put(wdev->netdev);
  }
  
-- 
1.6.3.3

