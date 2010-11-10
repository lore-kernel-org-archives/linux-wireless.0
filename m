Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:60050 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753971Ab0KJVEl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Nov 2010 16:04:41 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 2/2] compat-wireless: Backport pci power management
Date: Wed, 10 Nov 2010 22:04:28 +0100
Message-Id: <1289423068-9107-2-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1289423068-9107-1-git-send-email-hauke@hauke-m.de>
References: <1289423068-9107-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The new PCI power management is now also used by iwl and ath9k.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 patches/11-dev-pm-ops.patch |  162 ++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 160 insertions(+), 2 deletions(-)

diff --git a/patches/11-dev-pm-ops.patch b/patches/11-dev-pm-ops.patch
index 2a7cb3c..8931276 100644
--- a/patches/11-dev-pm-ops.patch
+++ b/patches/11-dev-pm-ops.patch
@@ -9,7 +9,7 @@ calls on compat code with only slight modifications.
 
 --- a/drivers/net/wireless/ath/ath5k/base.c
 +++ b/drivers/net/wireless/ath/ath5k/base.c
-@@ -3714,6 +3714,34 @@ static int ath5k_pci_resume(struct devic
+@@ -3732,6 +3732,34 @@ static int ath5k_pci_resume(struct devic
  	return 0;
  }
  
@@ -44,7 +44,7 @@ calls on compat code with only slight modifications.
  static SIMPLE_DEV_PM_OPS(ath5k_pm_ops, ath5k_pci_suspend, ath5k_pci_resume);
  #define ATH5K_PM_OPS	(&ath5k_pm_ops)
  #else
-@@ -3725,7 +3753,12 @@ static struct pci_driver ath5k_pci_drive
+@@ -3743,7 +3771,12 @@ static struct pci_driver ath5k_pci_drive
  	.id_table	= ath5k_pci_id_table,
  	.probe		= ath5k_pci_probe,
  	.remove		= __devexit_p(ath5k_pci_remove),
@@ -57,3 +57,161 @@ calls on compat code with only slight modifications.
  };
  
  /*
+--- a/drivers/net/wireless/ath/ath9k/pci.c
++++ b/drivers/net/wireless/ath/ath9k/pci.c
+@@ -284,14 +284,36 @@ static int ath_pci_resume(struct device
+ 	return 0;
+ }
+ 
+-static const struct dev_pm_ops ath9k_pm_ops = {
+-	.suspend = ath_pci_suspend,
+-	.resume = ath_pci_resume,
+-	.freeze = ath_pci_suspend,
+-	.thaw = ath_pci_resume,
+-	.poweroff = ath_pci_suspend,
+-	.restore = ath_pci_resume,
+-};
++#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,29))
++static int ath_pci_suspend_compat(struct pci_dev *pdev, pm_message_t state)
++{
++	int r;
++
++	r = ath_pci_suspend(&pdev->dev);
++	if (r)
++		return r;
++
++	pci_save_state(pdev);
++	pci_disable_device(pdev);
++	pci_set_power_state(pdev, PCI_D3hot);
++
++	return 0;
++}
++
++static int ath_pci_resume_compat(struct pci_dev *pdev)
++{
++	int r;
++
++	pci_restore_state(pdev);
++	r = pci_enable_device(pdev);
++	if (r)
++		return r;
++
++	return ath_pci_resume(&pdev->dev);
++}
++#endif
++
++static SIMPLE_DEV_PM_OPS(ath9k_pm_ops, ath_pci_suspend, ath_pci_resume);
+ 
+ #define ATH9K_PM_OPS	(&ath9k_pm_ops)
+ 
+@@ -309,7 +331,12 @@ static struct pci_driver ath_pci_driver
+ 	.id_table   = ath_pci_id_table,
+ 	.probe      = ath_pci_probe,
+ 	.remove     = ath_pci_remove,
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,29))
+ 	.driver.pm  = ATH9K_PM_OPS,
++#elif defined(CONFIG_PM_SLEEP)
++	.suspend    = ath_pci_suspend_compat,
++	.resume     = ath_pci_resume_compat,
++#endif
+ };
+ 
+ int ath_pci_init(void)
+--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
++++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
+@@ -4534,7 +4534,12 @@ static struct pci_driver iwl_driver = {
+ 	.id_table = iwl_hw_card_ids,
+ 	.probe = iwl_pci_probe,
+ 	.remove = __devexit_p(iwl_pci_remove),
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,29))
+ 	.driver.pm = IWL_PM_OPS,
++#elif defined(CONFIG_PM_SLEEP)
++	.suspend = iwl_pci_suspend_compat,
++	.resume = iwl_pci_resume_compat,
++#endif
+ };
+ 
+ static int __init iwl_init(void)
+--- a/drivers/net/wireless/iwlwifi/iwl-core.c
++++ b/drivers/net/wireless/iwlwifi/iwl-core.c
+@@ -2188,14 +2188,42 @@ int iwl_pci_resume(struct device *device
+ }
+ EXPORT_SYMBOL(iwl_pci_resume);
+ 
+-const struct dev_pm_ops iwl_pm_ops = {
+-	.suspend = iwl_pci_suspend,
+-	.resume = iwl_pci_resume,
+-	.freeze = iwl_pci_suspend,
+-	.thaw = iwl_pci_resume,
+-	.poweroff = iwl_pci_suspend,
+-	.restore = iwl_pci_resume,
+-};
++#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,29))
++int iwl_pci_suspend_compat(struct pci_dev *pdev, pm_message_t state)
++{
++	int r;
++
++	r = iwl_pci_suspend(&pdev->dev);
++	if (r)
++		return r;
++
++	pci_save_state(pdev);
++	pci_disable_device(pdev);
++	pci_set_power_state(pdev, PCI_D3hot);
++
++	return 0;
++}
++EXPORT_SYMBOL(iwl_pci_suspend_compat);
++
++int iwl_pci_resume_compat(struct pci_dev *pdev)
++{
++	int r;
++
++	pci_set_power_state(pdev, PCI_D0);
++	r = pci_enable_device(pdev);
++	if (r)
++		return r;
++	pci_restore_state(pdev);
++
++	return iwl_pci_resume(&pdev->dev);
++}
++EXPORT_SYMBOL(iwl_pci_resume_compat);
++#endif
++
++SIMPLE_DEV_PM_OPS(iwl_pm_ops, iwl_pci_suspend, iwl_pci_resume);
++
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,29))
+ EXPORT_SYMBOL(iwl_pm_ops);
++#endif
+ 
+ #endif /* CONFIG_PM */
+--- a/drivers/net/wireless/iwlwifi/iwl-core.h
++++ b/drivers/net/wireless/iwlwifi/iwl-core.h
+@@ -615,7 +615,12 @@ __le32 iwl_add_beacon_time(struct iwl_pr
+ #ifdef CONFIG_PM
+ int iwl_pci_suspend(struct device *device);
+ int iwl_pci_resume(struct device *device);
++#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,29))
++int iwl_pci_suspend_compat(struct pci_dev *pdev, pm_message_t state);
++int iwl_pci_resume_compat(struct pci_dev *pdev);
++#else
+ extern const struct dev_pm_ops iwl_pm_ops;
++#endif
+ 
+ #define IWL_PM_OPS	(&iwl_pm_ops)
+ 
+--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
++++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
+@@ -4279,7 +4279,12 @@ static struct pci_driver iwl3945_driver
+ 	.id_table = iwl3945_hw_card_ids,
+ 	.probe = iwl3945_pci_probe,
+ 	.remove = __devexit_p(iwl3945_pci_remove),
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,29))
+ 	.driver.pm = IWL_PM_OPS,
++#elif defined(CONFIG_PM_SLEEP)
++	.suspend = iwl_pci_suspend_compat,
++	.resume = iwl_pci_resume_compat,
++#endif
+ };
+ 
+ static int __init iwl3945_init(void)
-- 
1.7.1

