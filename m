Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:36355 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753530Ab0ILVJt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 12 Sep 2010 17:09:49 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org,
	johannes@sipsolutions.net, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 6/8] compat-wireless: Add warning if wext is deactivated
Date: Sun, 12 Sep 2010 23:09:20 +0200
Message-Id: <1284325760-929-1-git-send-email-hauke@hauke-m.de>
In-Reply-To: <4C8D397F.4000608@hauke-m.de>
References: <4C8D397F.4000608@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add a build warning if CONFIG_CFG80211_WEXT can not be activated.

wireless_handlers is only avaliable if the kernel was build with
CONFIG_WIRELESS_EXT. Add a kernel log warning if CONFIG_CFG80211_WEXT
is activated but we do not have CONFIG_WIRELESS_EXT, so we ware unable
to attach the wireless_handlers for wext.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 config.mk                                    |    2 ++
 patches/10-add-wext-handlers-to-netdev.patch |    8 +++++++-
 2 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/config.mk b/config.mk
index b7ef1ce..464a769 100644
--- a/config.mk
+++ b/config.mk
@@ -196,6 +196,8 @@ endif #CONFIG_PCMCIA
 # autoconf.h
 ifdef CONFIG_WIRELESS_EXT
  CONFIG_CFG80211_WEXT=y
+else #CONFIG_CFG80211_WEXT
+$(warning "WARNING: CONFIG_CFG80211_WEXT will be deactivated or not working because kernel was compiled with CONFIG_WIRELESS_EXT=n. Tools using wext interface like iwconfig will not work. To activate it build your kernel e.g. with CONFIG_LIBIPW=m.")
 endif #CONFIG_WIRELESS_EXT
 
 ifneq ($(CONFIG_STAGING),)
diff --git a/patches/10-add-wext-handlers-to-netdev.patch b/patches/10-add-wext-handlers-to-netdev.patch
index 8a5c6e5..7f31c73 100644
--- a/patches/10-add-wext-handlers-to-netdev.patch
+++ b/patches/10-add-wext-handlers-to-netdev.patch
@@ -29,12 +29,18 @@ CONFIG_WIRELESS_EXT in compat-wireless.
  	device_initialize(&rdev->wiphy.dev);
  	rdev->wiphy.dev.class = &ieee80211_class;
  	rdev->wiphy.dev.platform_data = rdev;
-@@ -712,6 +708,8 @@ static int cfg80211_netdev_notifier_call
+@@ -712,6 +708,14 @@ static int cfg80211_netdev_notifier_call
  		wdev->sme_state = CFG80211_SME_IDLE;
  		mutex_unlock(&rdev->devlist_mtx);
  #ifdef CONFIG_CFG80211_WEXT
++#ifdef CONFIG_WIRELESS_EXT
 +		if (!dev->wireless_handlers)
 +			dev->wireless_handlers = &cfg80211_wext_handler;
++#else
++		printk(KERN_WARNING "cfg80211: wext will not work because "
++			"kernel was compiled with CONFIG_WIRELESS_EXT=n. Tools "
++			"using wext interface like iwconfig will not work.\n");
++#endif
  		wdev->wext.default_key = -1;
  		wdev->wext.default_mgmt_key = -1;
  		wdev->wext.connect.auth_type = NL80211_AUTHTYPE_AUTOMATIC;
-- 
1.7.0.4

