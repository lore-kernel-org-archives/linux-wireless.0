Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:55233 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752499Ab1KFVYH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Nov 2011 16:24:07 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com, mcgrof@qca.qualcomm.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH] compat-wireless: backport rtlwifi PM
Date: Sun,  6 Nov 2011 22:23:41 +0100
Message-Id: <1320614621-27547-1-git-send-email-hauke@hauke-m.de> (sfid-20111106_222412_302993_260DC003)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 patches/11-dev-pm-ops.patch |  103 ++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 101 insertions(+), 2 deletions(-)

diff --git a/patches/11-dev-pm-ops.patch b/patches/11-dev-pm-ops.patch
index 1e2e38f..294aaba 100644
--- a/patches/11-dev-pm-ops.patch
+++ b/patches/11-dev-pm-ops.patch
@@ -34,7 +34,7 @@ calls on compat code with only slight modifications.
  /*
 --- a/drivers/net/ethernet/atheros/atlx/atl1.c
 +++ b/drivers/net/ethernet/atheros/atlx/atl1.c
-@@ -2835,6 +2835,9 @@ static int atl1_resume(struct device *de
+@@ -2833,6 +2833,9 @@ static int atl1_resume(struct device *de
  	return 0;
  }
  
@@ -44,7 +44,7 @@ calls on compat code with only slight modifications.
  static SIMPLE_DEV_PM_OPS(atl1_pm_ops, atl1_suspend, atl1_resume);
  #define ATL1_PM_OPS	(&atl1_pm_ops)
  
-@@ -3104,7 +3107,12 @@ static struct pci_driver atl1_driver = {
+@@ -3102,7 +3105,12 @@ static struct pci_driver atl1_driver = {
  	.probe = atl1_probe,
  	.remove = __devexit_p(atl1_remove),
  	.shutdown = atl1_shutdown,
@@ -242,3 +242,102 @@ calls on compat code with only slight modifications.
  };
  
  int __must_check iwl_pci_register_driver(void)
+--- a/drivers/net/wireless/rtlwifi/rtl8192ce/sw.c
++++ b/drivers/net/wireless/rtlwifi/rtl8192ce/sw.c
+@@ -381,21 +381,22 @@ MODULE_PARM_DESC(swlps, "Set to 1 to use
+ MODULE_PARM_DESC(fwlps, "Set to 1 to use FW control power save (default 1)\n");
+ MODULE_PARM_DESC(debug, "Set debug level (0-5) (default 0)");
+ 
+-static const struct dev_pm_ops rtlwifi_pm_ops = {
+-	.suspend = rtl_pci_suspend,
+-	.resume = rtl_pci_resume,
+-	.freeze = rtl_pci_suspend,
+-	.thaw = rtl_pci_resume,
+-	.poweroff = rtl_pci_suspend,
+-	.restore = rtl_pci_resume,
+-};
++static const SIMPLE_DEV_PM_OPS(rtlwifi_pm_ops, rtl_pci_suspend, rtl_pci_resume);
++
++compat_pci_suspend(rtl_pci_suspend)
++compat_pci_resume(rtl_pci_resume)
+ 
+ static struct pci_driver rtl92ce_driver = {
+ 	.name = KBUILD_MODNAME,
+ 	.id_table = rtl92ce_pci_ids,
+ 	.probe = rtl_pci_probe,
+ 	.remove = rtl_pci_disconnect,
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,29))
+ 	.driver.pm = &rtlwifi_pm_ops,
++#elif defined(CONFIG_PM)
++	.suspend    = rtl_pci_suspend_compat,
++	.resume     = rtl_pci_resume_compat,
++#endif
+ };
+ 
+ static int __init rtl92ce_module_init(void)
+--- a/drivers/net/wireless/rtlwifi/rtl8192de/sw.c
++++ b/drivers/net/wireless/rtlwifi/rtl8192de/sw.c
+@@ -391,21 +391,22 @@ MODULE_PARM_DESC(swlps, "Set to 1 to use
+ MODULE_PARM_DESC(fwlps, "Set to 1 to use FW control power save (default 1)\n");
+ MODULE_PARM_DESC(debug, "Set debug level (0-5) (default 0)");
+ 
+-static const struct dev_pm_ops rtlwifi_pm_ops = {
+-	.suspend = rtl_pci_suspend,
+-	.resume = rtl_pci_resume,
+-	.freeze = rtl_pci_suspend,
+-	.thaw = rtl_pci_resume,
+-	.poweroff = rtl_pci_suspend,
+-	.restore = rtl_pci_resume,
+-};
++static const SIMPLE_DEV_PM_OPS(rtlwifi_pm_ops, rtl_pci_suspend, rtl_pci_resume);
++
++compat_pci_suspend(rtl_pci_suspend)
++compat_pci_resume(rtl_pci_resume)
+ 
+ static struct pci_driver rtl92de_driver = {
+ 	.name = KBUILD_MODNAME,
+ 	.id_table = rtl92de_pci_ids,
+ 	.probe = rtl_pci_probe,
+ 	.remove = rtl_pci_disconnect,
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,29))
+ 	.driver.pm = &rtlwifi_pm_ops,
++#elif defined(CONFIG_PM)
++	.suspend    = rtl_pci_suspend_compat,
++	.resume     = rtl_pci_resume_compat,
++#endif
+ };
+ 
+ /* add global spin lock to solve the problem that
+--- a/drivers/net/wireless/rtlwifi/rtl8192se/sw.c
++++ b/drivers/net/wireless/rtlwifi/rtl8192se/sw.c
+@@ -403,21 +403,22 @@ MODULE_PARM_DESC(swlps, "Set to 1 to use
+ MODULE_PARM_DESC(fwlps, "Set to 1 to use FW control power save (default 1)\n");
+ MODULE_PARM_DESC(debug, "Set debug level (0-5) (default 0)");
+ 
+-static const struct dev_pm_ops rtlwifi_pm_ops = {
+-	.suspend = rtl_pci_suspend,
+-	.resume = rtl_pci_resume,
+-	.freeze = rtl_pci_suspend,
+-	.thaw = rtl_pci_resume,
+-	.poweroff = rtl_pci_suspend,
+-	.restore = rtl_pci_resume,
+-};
++static const SIMPLE_DEV_PM_OPS(rtlwifi_pm_ops, rtl_pci_suspend, rtl_pci_resume);
++
++compat_pci_suspend(rtl_pci_suspend)
++compat_pci_resume(rtl_pci_resume)
+ 
+ static struct pci_driver rtl92se_driver = {
+ 	.name = KBUILD_MODNAME,
+ 	.id_table = rtl92se_pci_ids,
+ 	.probe = rtl_pci_probe,
+ 	.remove = rtl_pci_disconnect,
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,29))
+ 	.driver.pm = &rtlwifi_pm_ops,
++#elif defined(CONFIG_PM)
++	.suspend    = rtl_pci_suspend_compat,
++	.resume     = rtl_pci_resume_compat,
++#endif
+ };
+ 
+ static int __init rtl92se_module_init(void)
-- 
1.7.4.1

