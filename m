Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:45398 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752264Ab2HMTlo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Aug 2012 15:41:44 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com
Cc: linux-wireless@vger.kernel.org,
	lf_driver_backport@lists.linux-foundation.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH] compat-wireless: make patches apply again
Date: Mon, 13 Aug 2012 21:41:26 +0200
Message-Id: <1344886886-17983-1-git-send-email-hauke@hauke-m.de> (sfid-20120813_214920_247798_D7B33171)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some parts of 11-dev-pm-ops.patch for iwlegacy went upstream in:
commit 450e9038ee65e3246b2a942669fc79001466f9be
Author: Johannes Berg <johannes.berg@intel.com>
Date:   Tue Aug 7 21:46:44 2012 +0200

    iwlegacy: clean up suspend/resume

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 patches/11-dev-pm-ops.patch |   30 +++++++++++-------------------
 1 file changed, 11 insertions(+), 19 deletions(-)

diff --git a/patches/11-dev-pm-ops.patch b/patches/11-dev-pm-ops.patch
index 411b2d5..15af08c 100644
--- a/patches/11-dev-pm-ops.patch
+++ b/patches/11-dev-pm-ops.patch
@@ -9,7 +9,7 @@ calls on compat code with only slight modifications.
 
 --- a/drivers/bcma/host_pci.c
 +++ b/drivers/bcma/host_pci.c
-@@ -256,6 +256,9 @@ static int bcma_host_pci_resume(struct d
+@@ -257,6 +257,9 @@ static int bcma_host_pci_resume(struct d
  	return bcma_bus_resume(bus);
  }
  
@@ -19,7 +19,7 @@ calls on compat code with only slight modifications.
  static SIMPLE_DEV_PM_OPS(bcma_pm_ops, bcma_host_pci_suspend,
  			 bcma_host_pci_resume);
  #define BCMA_PM_OPS	(&bcma_pm_ops)
-@@ -283,7 +286,12 @@ static struct pci_driver bcma_pci_bridge
+@@ -284,7 +287,12 @@ static struct pci_driver bcma_pci_bridge
  	.id_table = bcma_pci_bridge_tbl,
  	.probe = bcma_host_pci_probe,
  	.remove = __devexit_p(bcma_host_pci_remove),
@@ -109,7 +109,7 @@ calls on compat code with only slight modifications.
  module_pci_driver(ath5k_pci_driver);
 --- a/drivers/net/wireless/ath/ath9k/pci.c
 +++ b/drivers/net/wireless/ath/ath9k/pci.c
-@@ -344,14 +344,10 @@ static int ath_pci_resume(struct device
+@@ -345,14 +345,10 @@ static int ath_pci_resume(struct device
  	return 0;
  }
  
@@ -128,7 +128,7 @@ calls on compat code with only slight modifications.
  
  #define ATH9K_PM_OPS	(&ath9k_pm_ops)
  
-@@ -369,7 +365,12 @@ static struct pci_driver ath_pci_driver
+@@ -370,7 +366,12 @@ static struct pci_driver ath_pci_driver
  	.id_table   = ath_pci_id_table,
  	.probe      = ath_pci_probe,
  	.remove     = ath_pci_remove,
@@ -173,22 +173,14 @@ calls on compat code with only slight modifications.
  static int __init
 --- a/drivers/net/wireless/iwlegacy/common.c
 +++ b/drivers/net/wireless/iwlegacy/common.c
-@@ -4908,15 +4908,17 @@ il_pci_resume(struct device *device)
+@@ -4906,8 +4906,17 @@ il_pci_resume(struct device *device)
+ 	return 0;
  }
- EXPORT_SYMBOL(il_pci_resume);
- 
--const struct dev_pm_ops il_pm_ops = {
--	.suspend = il_pci_suspend,
--	.resume = il_pci_resume,
--	.freeze = il_pci_suspend,
--	.thaw = il_pci_resume,
--	.poweroff = il_pci_suspend,
--	.restore = il_pci_resume,
--};
+ 
 +compat_pci_suspend(il_pci_suspend)
 +compat_pci_resume(il_pci_resume)
 +
-+SIMPLE_DEV_PM_OPS(il_pm_ops, il_pci_suspend, il_pci_resume);
+ SIMPLE_DEV_PM_OPS(il_pm_ops, il_pci_suspend, il_pci_resume);
 +
 +#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,29))
  EXPORT_SYMBOL(il_pm_ops);
@@ -201,10 +193,10 @@ calls on compat code with only slight modifications.
  
 --- a/drivers/net/wireless/iwlegacy/common.h
 +++ b/drivers/net/wireless/iwlegacy/common.h
-@@ -1847,7 +1847,14 @@ __le32 il_add_beacon_time(struct il_priv
+@@ -1845,7 +1845,14 @@ __le32 il_add_beacon_time(struct il_priv
+ 			  u32 beacon_interval);
+ 
  #ifdef CONFIG_PM
- int il_pci_suspend(struct device *device);
- int il_pci_resume(struct device *device);
 +#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,29))
 +int il_pci_suspend_compat(struct pci_dev *pdev, pm_message_t state);
 +int il_pci_resume_compat(struct pci_dev *pdev);
-- 
1.7.9.5

