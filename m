Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:56387 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751017AbZK2Wpc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 29 Nov 2009 17:45:32 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 2/2] [compat-2.6] Refresh patches
Date: Sun, 29 Nov 2009 23:44:44 +0100
Message-Id: <1259534684-29079-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Refresh patches and add CONFIG_ATH9K_DEBUGFS

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 compat/patches/03-rfkill.patch                     |    8 ++++----
 compat/patches/08-rename-iwl4965-config.patch      |    6 +++---
 .../patches/10-add-wext-handlers-to-netdev.patch   |    2 +-
 compat/patches/12-iw_handler-changes.patch         |    2 +-
 compat/patches/13-trace.patch                      |    4 ++--
 compat/patches/15-symbol-export-conflicts.patch    |    2 +-
 config.mk                                          |    2 +-
 7 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/compat/patches/03-rfkill.patch b/compat/patches/03-rfkill.patch
index e87f69c..a444a65 100644
--- a/compat/patches/03-rfkill.patch
+++ b/compat/patches/03-rfkill.patch
@@ -137,7 +137,7 @@ This would do the policing from within mac80211.
  static long rfkill_fop_ioctl(struct file *file, unsigned int cmd,
  			     unsigned long arg)
  {
-@@ -1196,7 +1196,7 @@
+@@ -1197,7 +1197,7 @@
  	.write		= rfkill_fop_write,
  	.poll		= rfkill_fop_poll,
  	.release	= rfkill_fop_release,
@@ -146,7 +146,7 @@ This would do the policing from within mac80211.
  	.unlocked_ioctl	= rfkill_fop_ioctl,
  	.compat_ioctl	= rfkill_fop_ioctl,
  #endif
-@@ -1226,7 +1226,7 @@
+@@ -1227,7 +1227,7 @@
  		goto out;
  	}
  
@@ -155,7 +155,7 @@ This would do the policing from within mac80211.
  	error = rfkill_handler_init();
  	if (error) {
  		misc_deregister(&rfkill_miscdev);
-@@ -1242,7 +1242,7 @@
+@@ -1243,7 +1243,7 @@
  
  static void __exit rfkill_exit(void)
  {
@@ -208,7 +208,7 @@ This would do the policing from within mac80211.
  #include <net/cfg80211.h>
 --- a/drivers/net/wireless/ath/ath9k/hw.c	2009-11-02 08:06:38.000000000 -0800
 +++ b/drivers/net/wireless/ath/ath9k/hw.c	2009-11-02 08:06:39.000000000 -0800
-@@ -3246,7 +3246,7 @@
+@@ -3251,7 +3251,7 @@
  
  	pCap->hw_caps |= ATH9K_HW_CAP_ENHANCEDPM;
  
diff --git a/compat/patches/08-rename-iwl4965-config.patch b/compat/patches/08-rename-iwl4965-config.patch
index 475c15f..f896939 100644
--- a/compat/patches/08-rename-iwl4965-config.patch
+++ b/compat/patches/08-rename-iwl4965-config.patch
@@ -16,7 +16,7 @@ CONFIG_IWL4965 has to be set to y, to build correctly.
  iwlagn-$(CONFIG_IWL5000) += iwl-1000.o
 --- a/drivers/net/wireless/iwlwifi/iwl-agn.c	2009-11-13 11:38:35.000000000 -0800
 +++ b/drivers/net/wireless/iwlwifi/iwl-agn.c	2009-11-13 11:38:36.000000000 -0800
-@@ -3534,10 +3534,10 @@
+@@ -3586,10 +3586,10 @@
  
  /* Hardware specific file defines the PCI IDs table for that hardware module */
  static struct pci_device_id iwl_hw_card_ids[] = {
@@ -27,5 +27,5 @@ CONFIG_IWL4965 has to be set to y, to build correctly.
 -#endif /* CONFIG_IWL4965 */
 +#endif /* CONFIG_COMPAT_IWL4965 */
  #ifdef CONFIG_IWL5000
- 	{IWL_PCI_DEVICE(0x4232, 0x1205, iwl5100_bg_cfg)},
- 	{IWL_PCI_DEVICE(0x4232, 0x1305, iwl5100_bg_cfg)},
+ /* 5100 Series WiFi */
+ 	{IWL_PCI_DEVICE(0x4232, 0x1201, iwl5100_agn_cfg)}, /* Mini Card */
diff --git a/compat/patches/10-add-wext-handlers-to-netdev.patch b/compat/patches/10-add-wext-handlers-to-netdev.patch
index 9159613..e5112e3 100644
--- a/compat/patches/10-add-wext-handlers-to-netdev.patch
+++ b/compat/patches/10-add-wext-handlers-to-netdev.patch
@@ -13,7 +13,7 @@ the struct wiphy wireless handler.
 
 --- a/net/wireless/core.c	2009-11-02 08:08:20.000000000 -0800
 +++ b/net/wireless/core.c	2009-11-02 08:08:21.000000000 -0800
-@@ -673,6 +673,10 @@
+@@ -676,6 +676,10 @@
  		wdev->sme_state = CFG80211_SME_IDLE;
  		mutex_unlock(&rdev->devlist_mtx);
  #ifdef CONFIG_CFG80211_WEXT
diff --git a/compat/patches/12-iw_handler-changes.patch b/compat/patches/12-iw_handler-changes.patch
index 7a700b1..fb97af5 100644
--- a/compat/patches/12-iw_handler-changes.patch
+++ b/compat/patches/12-iw_handler-changes.patch
@@ -1,6 +1,6 @@
 --- a/drivers/net/wireless/ipw2x00/ipw2100.c	2009-10-08 11:01:52.000000000 -0400
 +++ b/drivers/net/wireless/ipw2x00/ipw2100.c	2009-10-08 11:01:43.000000000 -0400
-@@ -6057,7 +6057,11 @@
+@@ -6140,7 +6140,11 @@
  
  	dev->ethtool_ops = &ipw2100_ethtool_ops;
  	dev->wireless_handlers = &ipw2100_wx_handler_def;
diff --git a/compat/patches/13-trace.patch b/compat/patches/13-trace.patch
index d3a3dcd..7668d50 100644
--- a/compat/patches/13-trace.patch
+++ b/compat/patches/13-trace.patch
@@ -16,7 +16,7 @@ in or compat headers.
  #include "iwl-dev.h"
  
  #if !defined(CONFIG_IWLWIFI_DEVICE_TRACING) || defined(__CHECKER__)
-@@ -175,4 +175,6 @@
+@@ -194,4 +196,6 @@ TRACE_EVENT(iwlwifi_dev_ucode_event,
  #define TRACE_INCLUDE_PATH .
  #undef TRACE_INCLUDE_FILE
  #define TRACE_INCLUDE_FILE iwl-devtrace
@@ -35,7 +35,7 @@ in or compat headers.
  #include <net/mac80211.h>
  #include "ieee80211_i.h"
  
-@@ -672,4 +674,6 @@ TRACE_EVENT(drv_ampdu_action,
+@@ -694,4 +696,6 @@ TRACE_EVENT(drv_ampdu_action,
  #define TRACE_INCLUDE_PATH .
  #undef TRACE_INCLUDE_FILE
  #define TRACE_INCLUDE_FILE driver-trace
diff --git a/compat/patches/15-symbol-export-conflicts.patch b/compat/patches/15-symbol-export-conflicts.patch
index 2cc25cc..0538671 100644
--- a/compat/patches/15-symbol-export-conflicts.patch
+++ b/compat/patches/15-symbol-export-conflicts.patch
@@ -3,7 +3,7 @@ To avoid conflicts with the other export we rename our.
 
 --- a/net/mac80211/rx.c	2009-11-13 11:41:29.000000000 -0800
 +++ b/net/mac80211/rx.c	2009-11-13 11:41:30.000000000 -0800
-@@ -2516,7 +2516,12 @@
+@@ -2537,7 +2537,12 @@
   drop:
  	kfree_skb(skb);
  }
diff --git a/config.mk b/config.mk
index e9e85d7..4008a01 100644
--- a/config.mk
+++ b/config.mk
@@ -155,7 +155,7 @@ CONFIG_ATH9K=m
 # CONFIG_ATH9K_COMMON to an area that doesn't depend on PCI
 # as you could then have ath9k disabled but ath9k_htc enabled.
 CONFIG_ATH9K_COMMON=m
-# CONFIG_ATH9K_DEBUG=y
+# CONFIG_ATH9K_DEBUGFS=y
 
 
 CONFIG_IWLWIFI=m
-- 
1.6.3.3

