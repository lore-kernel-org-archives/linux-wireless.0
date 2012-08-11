Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:40845 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755998Ab2HKAat (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Aug 2012 20:30:49 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com
Cc: linux-wireless@vger.kernel.org,
	lf_driver_backport@lists.linux-foundation.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 2/2] compat-wireless: do not add const before SIMPLE_DEV_PM_OPS
Date: Sat, 11 Aug 2012 02:30:25 +0200
Message-Id: <1344645025-26796-2-git-send-email-hauke@hauke-m.de> (sfid-20120811_023052_514201_04AB86C1)
In-Reply-To: <1344645025-26796-1-git-send-email-hauke@hauke-m.de>
References: <1344645025-26796-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

For kernel < 2.6.32 .driver.pm in struct pci_driver is not const, but
for later kernel versions it is const. This const should not be added
manually, but by SIMPLE_DEV_PM_OPS(), so remove it from this patch.

In addition compat_pci_suspend and compat_pci_resume are now in front
of SIMPLE_DEV_PM_OPS to make make it possible to use a function created
by them in SIMPLE_DEV_PM_OPS(), which is needed for kernel 2.6.29.

This is partly based on work done by Johannes Berg.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 crap/0002-backport-alx.patch |   10 +++----
 patches/11-dev-pm-ops.patch  |   61 +++++++++++++++++++++---------------------
 2 files changed, 36 insertions(+), 35 deletions(-)

diff --git a/crap/0002-backport-alx.patch b/crap/0002-backport-alx.patch
index 1eae431..7570057 100644
--- a/crap/0002-backport-alx.patch
+++ b/crap/0002-backport-alx.patch
@@ -109,15 +109,15 @@ This should go into patches/01-netdev.patch
  
  	/* get mac addr and perm mac addr, set to register */
  	if (hw->cbs.get_mac_addr)
-@@ -3862,6 +3896,8 @@ static struct pci_error_handlers alx_err
+@@ -3860,6 +3894,8 @@ static struct pci_error_handlers alx_err
+ 
+ 
  #ifdef CONFIG_PM_SLEEP
- static SIMPLE_DEV_PM_OPS(alx_pm_ops, alx_suspend, alx_resume);
- #define ALX_PM_OPS      (&alx_pm_ops)
 +compat_pci_suspend(alx_suspend)
 +compat_pci_resume(alx_resume)
+ static SIMPLE_DEV_PM_OPS(alx_pm_ops, alx_suspend, alx_resume);
+ #define ALX_PM_OPS      (&alx_pm_ops)
  #else
- #define ALX_PM_OPS      NULL
- #endif
 @@ -3874,7 +3910,12 @@ static struct pci_driver alx_driver = {
  	.remove      = __devexit_p(alx_remove),
  	.shutdown    = alx_shutdown,
diff --git a/patches/11-dev-pm-ops.patch b/patches/11-dev-pm-ops.patch
index 8ddc74b..411b2d5 100644
--- a/patches/11-dev-pm-ops.patch
+++ b/patches/11-dev-pm-ops.patch
@@ -9,18 +9,17 @@ calls on compat code with only slight modifications.
 
 --- a/drivers/bcma/host_pci.c
 +++ b/drivers/bcma/host_pci.c
-@@ -258,6 +258,10 @@ static int bcma_host_pci_resume(struct d
+@@ -256,6 +256,9 @@ static int bcma_host_pci_resume(struct d
+ 	return bcma_bus_resume(bus);
+ }
  
- static SIMPLE_DEV_PM_OPS(bcma_pm_ops, bcma_host_pci_suspend,
- 			 bcma_host_pci_resume);
-+
 +compat_pci_suspend(bcma_host_pci_suspend)
 +compat_pci_resume(bcma_host_pci_resume)
 +
+ static SIMPLE_DEV_PM_OPS(bcma_pm_ops, bcma_host_pci_suspend,
+ 			 bcma_host_pci_resume);
  #define BCMA_PM_OPS	(&bcma_pm_ops)
- 
- #else /* CONFIG_PM */
-@@ -282,7 +286,12 @@ static struct pci_driver bcma_pci_bridge
+@@ -283,7 +286,12 @@ static struct pci_driver bcma_pci_bridge
  	.id_table = bcma_pci_bridge_tbl,
  	.probe = bcma_host_pci_probe,
  	.remove = __devexit_p(bcma_host_pci_remove),
@@ -35,16 +34,16 @@ calls on compat code with only slight modifications.
  int __init bcma_host_pci_init(void)
 --- a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
 +++ b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
-@@ -2693,6 +2693,9 @@ static struct pci_error_handlers atl1c_e
- 
- static SIMPLE_DEV_PM_OPS(atl1c_pm_ops, atl1c_suspend, atl1c_resume);
+@@ -2691,6 +2691,9 @@ static struct pci_error_handlers atl1c_e
+ 	.resume = atl1c_io_resume,
+ };
  
 +compat_pci_suspend(atl1c_suspend)
 +compat_pci_resume(atl1c_resume)
 +
+ static SIMPLE_DEV_PM_OPS(atl1c_pm_ops, atl1c_suspend, atl1c_resume);
+ 
  static struct pci_driver atl1c_driver = {
- 	.name     = atl1c_driver_name,
- 	.id_table = atl1c_pci_tbl,
 @@ -2700,7 +2703,12 @@ static struct pci_driver atl1c_driver =
  	.remove   = __devexit_p(atl1c_remove),
  	.shutdown = atl1c_shutdown,
@@ -110,7 +109,7 @@ calls on compat code with only slight modifications.
  module_pci_driver(ath5k_pci_driver);
 --- a/drivers/net/wireless/ath/ath9k/pci.c
 +++ b/drivers/net/wireless/ath/ath9k/pci.c
-@@ -343,14 +343,10 @@ static int ath_pci_resume(struct device
+@@ -344,14 +344,10 @@ static int ath_pci_resume(struct device
  	return 0;
  }
  
@@ -129,7 +128,7 @@ calls on compat code with only slight modifications.
  
  #define ATH9K_PM_OPS	(&ath9k_pm_ops)
  
-@@ -368,7 +364,12 @@ static struct pci_driver ath_pci_driver
+@@ -369,7 +365,12 @@ static struct pci_driver ath_pci_driver
  	.id_table   = ath_pci_id_table,
  	.probe      = ath_pci_probe,
  	.remove     = ath_pci_remove,
@@ -186,11 +185,11 @@ calls on compat code with only slight modifications.
 -	.poweroff = il_pci_suspend,
 -	.restore = il_pci_resume,
 -};
-+const SIMPLE_DEV_PM_OPS(il_pm_ops, il_pci_suspend, il_pci_resume);
-+
 +compat_pci_suspend(il_pci_suspend)
 +compat_pci_resume(il_pci_resume)
 +
++SIMPLE_DEV_PM_OPS(il_pm_ops, il_pci_suspend, il_pci_resume);
++
 +#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,29))
  EXPORT_SYMBOL(il_pm_ops);
 +#else
@@ -202,13 +201,15 @@ calls on compat code with only slight modifications.
  
 --- a/drivers/net/wireless/iwlegacy/common.h
 +++ b/drivers/net/wireless/iwlegacy/common.h
-@@ -1847,7 +1847,12 @@ __le32 il_add_beacon_time(struct il_priv
+@@ -1847,7 +1847,14 @@ __le32 il_add_beacon_time(struct il_priv
  #ifdef CONFIG_PM
  int il_pci_suspend(struct device *device);
  int il_pci_resume(struct device *device);
 +#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,29))
 +int il_pci_suspend_compat(struct pci_dev *pdev, pm_message_t state);
 +int il_pci_resume_compat(struct pci_dev *pdev);
++#elif (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,32))
++extern struct dev_pm_ops il_pm_ops;
 +#else
  extern const struct dev_pm_ops il_pm_ops;
 +#endif
@@ -217,16 +218,16 @@ calls on compat code with only slight modifications.
  
 --- a/drivers/net/wireless/iwlwifi/pcie/drv.c
 +++ b/drivers/net/wireless/iwlwifi/pcie/drv.c
-@@ -339,6 +339,9 @@ static int iwl_pci_resume(struct device
- 
- static SIMPLE_DEV_PM_OPS(iwl_dev_pm_ops, iwl_pci_suspend, iwl_pci_resume);
+@@ -337,6 +337,9 @@ static int iwl_pci_resume(struct device
+ 	return iwl_trans_resume(iwl_trans);
+ }
  
 +compat_pci_suspend(iwl_pci_suspend)
 +compat_pci_resume(iwl_pci_resume)
 +
- #define IWL_PM_OPS	(&iwl_dev_pm_ops)
+ static SIMPLE_DEV_PM_OPS(iwl_dev_pm_ops, iwl_pci_suspend, iwl_pci_resume);
  
- #else
+ #define IWL_PM_OPS	(&iwl_dev_pm_ops)
 @@ -361,7 +364,12 @@ static struct pci_driver iwl_pci_driver
  	.id_table = iwl_hw_card_ids,
  	.probe = iwl_pci_probe,
@@ -282,10 +283,10 @@ calls on compat code with only slight modifications.
 -	.poweroff = rtl_pci_suspend,
 -	.restore = rtl_pci_resume,
 -};
-+static const SIMPLE_DEV_PM_OPS(rtlwifi_pm_ops, rtl_pci_suspend, rtl_pci_resume);
-+
 +compat_pci_suspend(rtl_pci_suspend)
 +compat_pci_resume(rtl_pci_resume)
++
++static SIMPLE_DEV_PM_OPS(rtlwifi_pm_ops, rtl_pci_suspend, rtl_pci_resume);
  
  static struct pci_driver rtl92ce_driver = {
  	.name = KBUILD_MODNAME,
@@ -315,10 +316,10 @@ calls on compat code with only slight modifications.
 -	.poweroff = rtl_pci_suspend,
 -	.restore = rtl_pci_resume,
 -};
-+static const SIMPLE_DEV_PM_OPS(rtlwifi_pm_ops, rtl_pci_suspend, rtl_pci_resume);
-+
 +compat_pci_suspend(rtl_pci_suspend)
 +compat_pci_resume(rtl_pci_resume)
++
++static SIMPLE_DEV_PM_OPS(rtlwifi_pm_ops, rtl_pci_suspend, rtl_pci_resume);
  
  static struct pci_driver rtl92de_driver = {
  	.name = KBUILD_MODNAME,
@@ -348,10 +349,10 @@ calls on compat code with only slight modifications.
 -	.poweroff = rtl_pci_suspend,
 -	.restore = rtl_pci_resume,
 -};
-+static const SIMPLE_DEV_PM_OPS(rtlwifi_pm_ops, rtl_pci_suspend, rtl_pci_resume);
-+
 +compat_pci_suspend(rtl_pci_suspend)
 +compat_pci_resume(rtl_pci_resume)
++
++static SIMPLE_DEV_PM_OPS(rtlwifi_pm_ops, rtl_pci_suspend, rtl_pci_resume);
  
  static struct pci_driver rtl92se_driver = {
  	.name = KBUILD_MODNAME,
@@ -369,7 +370,7 @@ calls on compat code with only slight modifications.
  module_pci_driver(rtl92se_driver);
 --- a/drivers/net/wireless/p54/p54pci.c
 +++ b/drivers/net/wireless/p54/p54pci.c
-@@ -645,14 +645,10 @@ static int p54p_resume(struct device *de
+@@ -681,14 +681,10 @@ static int p54p_resume(struct device *de
  	return pci_set_power_state(pdev, PCI_D0);
  }
  
@@ -388,7 +389,7 @@ calls on compat code with only slight modifications.
  
  #define P54P_PM_OPS (&p54pci_pm_ops)
  #else
-@@ -664,7 +660,12 @@ static struct pci_driver p54p_driver = {
+@@ -700,7 +696,12 @@ static struct pci_driver p54p_driver = {
  	.id_table	= p54p_table,
  	.probe		= p54p_probe,
  	.remove		= __devexit_p(p54p_remove),
-- 
1.7.9.5

