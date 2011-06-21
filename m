Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:40322 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751603Ab1FUPZ3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Jun 2011 11:25:29 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com, lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH] compat-wireless: make patches apply again
Date: Tue, 21 Jun 2011 17:25:21 +0200
Message-Id: <1308669921-28413-1-git-send-email-hauke@hauke-m.de> (sfid-20110621_172533_111341_552AF8C7)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 patches/11-dev-pm-ops.patch       |   59 +++++++++++++-----------------------
 patches/99-change-makefiles.patch |    3 +-
 2 files changed, 23 insertions(+), 39 deletions(-)

diff --git a/patches/11-dev-pm-ops.patch b/patches/11-dev-pm-ops.patch
index acf2dc8..b36c48b 100644
--- a/patches/11-dev-pm-ops.patch
+++ b/patches/11-dev-pm-ops.patch
@@ -84,7 +84,7 @@ calls on compat code with only slight modifications.
  /*
 --- a/drivers/net/wireless/ath/ath9k/pci.c
 +++ b/drivers/net/wireless/ath/ath9k/pci.c
-@@ -316,14 +316,11 @@ static int ath_pci_resume(struct device
+@@ -316,14 +316,10 @@ static int ath_pci_resume(struct device
  	return 0;
  }
  
@@ -96,7 +96,6 @@ calls on compat code with only slight modifications.
 -	.poweroff = ath_pci_suspend,
 -	.restore = ath_pci_resume,
 -};
-+
 +compat_pci_suspend(ath_pci_suspend)
 +compat_pci_resume(ath_pci_resume)
 +
@@ -104,7 +103,7 @@ calls on compat code with only slight modifications.
  
  #define ATH9K_PM_OPS	(&ath9k_pm_ops)
  
-@@ -341,7 +338,12 @@ static struct pci_driver ath_pci_driver
+@@ -341,7 +337,12 @@ static struct pci_driver ath_pci_driver
  	.id_table   = ath_pci_id_table,
  	.probe      = ath_pci_probe,
  	.remove     = ath_pci_remove,
@@ -218,28 +217,13 @@ calls on compat code with only slight modifications.
  };
  
  static int __init iwl4965_init(void)
---- a/drivers/net/wireless/iwlwifi/iwl-agn.c
-+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
-@@ -4001,7 +4001,12 @@ static struct pci_driver iwl_driver = {
- 	.id_table = iwl_hw_card_ids,
- 	.probe = iwl_pci_probe,
- 	.remove = __devexit_p(iwl_pci_remove),
-+#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,29))
- 	.driver.pm = IWL_PM_OPS,
-+#elif defined(CONFIG_PM)
-+	.suspend = iwl_pci_suspend_compat,
-+	.resume = iwl_pci_resume_compat,
-+#endif
- };
- 
- static int __init iwl_init(void)
---- a/drivers/net/wireless/iwlwifi/iwl-core.c
-+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
-@@ -2014,13 +2014,9 @@ int iwl_pci_resume(struct device *device
- 	return 0;
+--- a/drivers/net/wireless/iwlwifi/iwl-pci.c
++++ b/drivers/net/wireless/iwlwifi/iwl-pci.c
+@@ -530,14 +530,10 @@ static int iwl_pci_resume(struct device
+ 	return iwl_resume(priv);
  }
  
--const struct dev_pm_ops iwl_pm_ops = {
+-static const struct dev_pm_ops iwl_dev_pm_ops = {
 -	.suspend = iwl_pci_suspend,
 -	.resume = iwl_pci_resume,
 -	.freeze = iwl_pci_suspend,
@@ -247,24 +231,23 @@ calls on compat code with only slight modifications.
 -	.poweroff = iwl_pci_suspend,
 -	.restore = iwl_pci_resume,
 -};
-+const SIMPLE_DEV_PM_OPS(iwl_pm_ops, iwl_pci_suspend, iwl_pci_resume);
++const SIMPLE_DEV_PM_OPS(iwl_dev_pm_ops, iwl_pci_suspend, iwl_pci_resume);
 +
 +compat_pci_suspend(iwl_pci_suspend)
 +compat_pci_resume(iwl_pci_resume)
  
- #endif /* CONFIG_PM */
---- a/drivers/net/wireless/iwlwifi/iwl-core.h
-+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
-@@ -502,7 +502,12 @@ __le32 iwl_add_beacon_time(struct iwl_pr
- #ifdef CONFIG_PM
- int iwl_pci_suspend(struct device *device);
- int iwl_pci_resume(struct device *device);
-+#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,29))
-+int iwl_pci_suspend_compat(struct pci_dev *pdev, pm_message_t state);
-+int iwl_pci_resume_compat(struct pci_dev *pdev);
-+#else
- extern const struct dev_pm_ops iwl_pm_ops;
-+#endif
+ #define IWL_PM_OPS	(&iwl_dev_pm_ops)
  
- #define IWL_PM_OPS	(&iwl_pm_ops)
+@@ -552,7 +548,12 @@ static struct pci_driver iwl_pci_driver
+ 	.id_table = iwl_hw_card_ids,
+ 	.probe = iwl_pci_probe,
+ 	.remove = __devexit_p(iwl_pci_remove),
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,29))
+ 	.driver.pm = IWL_PM_OPS,
++#elif defined(CONFIG_PM)
++	.suspend = iwl_pci_suspend_compat,
++	.resume = iwl_pci_resume_compat,
++#endif
+ };
  
+ int __must_check iwl_pci_register_driver(void)
diff --git a/patches/99-change-makefiles.patch b/patches/99-change-makefiles.patch
index be62e28..2d5af48 100644
--- a/patches/99-change-makefiles.patch
+++ b/patches/99-change-makefiles.patch
@@ -13,7 +13,7 @@ only the wireless stuff.
  obj-$(CONFIG_EEPROM_93CX6)	+= eeprom_93cx6.o
 --- a/drivers/net/usb/Makefile
 +++ b/drivers/net/usb/Makefile
-@@ -2,30 +2,7 @@
+@@ -2,31 +2,7 @@
  # Makefile for USB Network drivers
  #
  
@@ -38,6 +38,7 @@ only the wireless stuff.
  obj-$(CONFIG_USB_COMPAT_USBNET)	+= usbnet.o
 -obj-$(CONFIG_USB_NET_INT51X1)	+= int51x1.o
 -obj-$(CONFIG_USB_CDC_PHONET)	+= cdc-phonet.o
+-obj-$(CONFIG_USB_NET_KALMIA)	+= kalmia.o
 -obj-$(CONFIG_USB_IPHETH)	+= ipheth.o
 -obj-$(CONFIG_USB_SIERRA_NET)	+= sierra_net.o
 -obj-$(CONFIG_USB_NET_CX82310_ETH)	+= cx82310_eth.o
-- 
1.7.4.1

