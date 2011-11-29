Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:49860 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753047Ab1K2Vv1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Nov 2011 16:51:27 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>,
	Hauke Mehrtens <hauke@hauke-m.de>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 1/3] compat-wireless: fix patches/11-dev-pm-ops.patch
Date: Tue, 29 Nov 2011 16:45:18 -0500
Message-Id: <1322603120-11263-1-git-send-email-linville@tuxdriver.com> (sfid-20111129_225133_576641_5B344DC7)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

More fall-out from the refactoring of iwlegacy...

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 patches/11-dev-pm-ops.patch |  180 +++++++++++++++++++++---------------------
 1 files changed, 90 insertions(+), 90 deletions(-)

diff --git a/patches/11-dev-pm-ops.patch b/patches/11-dev-pm-ops.patch
index 294aaba..7166a28 100644
--- a/patches/11-dev-pm-ops.patch
+++ b/patches/11-dev-pm-ops.patch
@@ -9,7 +9,7 @@ calls on compat code with only slight modifications.
 
 --- a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
 +++ b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
-@@ -2897,6 +2897,9 @@ static struct pci_error_handlers atl1c_e
+@@ -2897,6 +2897,9 @@ static struct pci_error_handlers atl1c_err_handler = {
  
  static SIMPLE_DEV_PM_OPS(atl1c_pm_ops, atl1c_suspend, atl1c_resume);
  
@@ -19,7 +19,7 @@ calls on compat code with only slight modifications.
  static struct pci_driver atl1c_driver = {
  	.name     = atl1c_driver_name,
  	.id_table = atl1c_pci_tbl,
-@@ -2904,7 +2907,12 @@ static struct pci_driver atl1c_driver =
+@@ -2904,7 +2907,12 @@ static struct pci_driver atl1c_driver = {
  	.remove   = __devexit_p(atl1c_remove),
  	.shutdown = atl1c_shutdown,
  	.err_handler = &atl1c_err_handler,
@@ -34,7 +34,7 @@ calls on compat code with only slight modifications.
  /*
 --- a/drivers/net/ethernet/atheros/atlx/atl1.c
 +++ b/drivers/net/ethernet/atheros/atlx/atl1.c
-@@ -2833,6 +2833,9 @@ static int atl1_resume(struct device *de
+@@ -2833,6 +2833,9 @@ static int atl1_resume(struct device *dev)
  	return 0;
  }
  
@@ -59,7 +59,7 @@ calls on compat code with only slight modifications.
  /*
 --- a/drivers/net/wireless/ath/ath5k/pci.c
 +++ b/drivers/net/wireless/ath/ath5k/pci.c
-@@ -323,6 +323,9 @@ static int ath5k_pci_resume(struct devic
+@@ -323,6 +323,9 @@ static int ath5k_pci_resume(struct device *dev)
  	return 0;
  }
  
@@ -69,7 +69,7 @@ calls on compat code with only slight modifications.
  static SIMPLE_DEV_PM_OPS(ath5k_pm_ops, ath5k_pci_suspend, ath5k_pci_resume);
  #define ATH5K_PM_OPS	(&ath5k_pm_ops)
  #else
-@@ -334,7 +337,12 @@ static struct pci_driver ath5k_pci_drive
+@@ -334,7 +337,12 @@ static struct pci_driver ath5k_pci_driver = {
  	.id_table	= ath5k_pci_id_table,
  	.probe		= ath5k_pci_probe,
  	.remove		= __devexit_p(ath5k_pci_remove),
@@ -84,7 +84,7 @@ calls on compat code with only slight modifications.
  /*
 --- a/drivers/net/wireless/ath/ath9k/pci.c
 +++ b/drivers/net/wireless/ath/ath9k/pci.c
-@@ -353,14 +353,10 @@ static int ath_pci_resume(struct device
+@@ -353,14 +353,10 @@ static int ath_pci_resume(struct device *device)
  	return 0;
  }
  
@@ -103,7 +103,7 @@ calls on compat code with only slight modifications.
  
  #define ATH9K_PM_OPS	(&ath9k_pm_ops)
  
-@@ -378,7 +374,12 @@ static struct pci_driver ath_pci_driver
+@@ -378,7 +374,12 @@ static struct pci_driver ath_pci_driver = {
  	.id_table   = ath_pci_id_table,
  	.probe      = ath_pci_probe,
  	.remove     = ath_pci_remove,
@@ -116,110 +116,82 @@ calls on compat code with only slight modifications.
  };
  
  int ath_pci_init(void)
---- a/drivers/net/wireless/libertas/if_spi.c
-+++ b/drivers/net/wireless/libertas/if_spi.c
-@@ -1251,6 +1251,7 @@ static int __devexit libertas_spi_remove
- 	return 0;
- }
- 
+--- a/drivers/net/wireless/iwlegacy/3945-mac.c
++++ b/drivers/net/wireless/iwlegacy/3945-mac.c
+@@ -3920,7 +3920,12 @@ static struct pci_driver il3945_driver = {
+ 	.id_table = il3945_hw_card_ids,
+ 	.probe = il3945_pci_probe,
+ 	.remove = __devexit_p(il3945_pci_remove),
 +#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,29))
- static int if_spi_suspend(struct device *dev)
- {
- 	struct spi_device *spi = to_spi_device(dev);
-@@ -1284,6 +1285,7 @@ static const struct dev_pm_ops if_spi_pm
- 	.suspend	= if_spi_suspend,
- 	.resume		= if_spi_resume,
- };
+ 	.driver.pm = IL_LEGACY_PM_OPS,
++#elif defined(CONFIG_PM)
++	.suspend = il_pci_suspend_compat,
++	.resume = il_pci_resume_compat,
 +#endif
+ };
  
- static struct spi_driver libertas_spi_driver = {
- 	.probe	= if_spi_probe,
-@@ -1292,7 +1294,9 @@ static struct spi_driver libertas_spi_dr
- 		.name	= "libertas_spi",
- 		.bus	= &spi_bus_type,
- 		.owner	= THIS_MODULE,
+ static int __init
+--- a/drivers/net/wireless/iwlegacy/4965-mac.c
++++ b/drivers/net/wireless/iwlegacy/4965-mac.c
+@@ -6478,7 +6478,12 @@ static struct pci_driver il4965_driver = {
+ 	.id_table = il4965_hw_card_ids,
+ 	.probe = il4965_pci_probe,
+ 	.remove = __devexit_p(il4965_pci_remove),
 +#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,29))
- 		.pm	= &if_spi_pm_ops,
+ 	.driver.pm = IL_LEGACY_PM_OPS,
++#elif defined(CONFIG_PM)
++	.suspend = il_pci_suspend_compat,
++	.resume = il_pci_resume_compat,
 +#endif
- 	},
  };
  
---- a/drivers/net/wireless/iwlegacy/iwl-core.c
-+++ b/drivers/net/wireless/iwlegacy/iwl-core.c
-@@ -2016,15 +2016,17 @@ int iwl_legacy_pci_resume(struct device
+ static int __init
+--- a/drivers/net/wireless/iwlegacy/common.c
++++ b/drivers/net/wireless/iwlegacy/common.c
+@@ -5079,15 +5079,17 @@ il_pci_resume(struct device *device)
  }
- EXPORT_SYMBOL(iwl_legacy_pci_resume);
- 
--const struct dev_pm_ops iwl_legacy_pm_ops = {
--	.suspend = iwl_legacy_pci_suspend,
--	.resume = iwl_legacy_pci_resume,
--	.freeze = iwl_legacy_pci_suspend,
--	.thaw = iwl_legacy_pci_resume,
--	.poweroff = iwl_legacy_pci_suspend,
--	.restore = iwl_legacy_pci_resume,
+ EXPORT_SYMBOL(il_pci_resume);
+ 
+-const struct dev_pm_ops il_pm_ops = {
+-	.suspend = il_pci_suspend,
+-	.resume = il_pci_resume,
+-	.freeze = il_pci_suspend,
+-	.thaw = il_pci_resume,
+-	.poweroff = il_pci_suspend,
+-	.restore = il_pci_resume,
 -};
-+const SIMPLE_DEV_PM_OPS(iwl_legacy_pm_ops, iwl_legacy_pci_suspend, iwl_legacy_pci_resume);
++const SIMPLE_DEV_PM_OPS(il_pm_ops, il_pci_suspend, il_pci_resume);
 +
-+compat_pci_suspend(iwl_legacy_pci_suspend)
-+compat_pci_resume(iwl_legacy_pci_resume)
++compat_pci_suspend(il_pci_suspend)
++compat_pci_resume(il_pci_resume)
 +
 +#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,29))
- EXPORT_SYMBOL(iwl_legacy_pm_ops);
+ EXPORT_SYMBOL(il_pm_ops);
 +#else
-+EXPORT_SYMBOL(iwl_legacy_pci_suspend_compat);
-+EXPORT_SYMBOL(iwl_legacy_pci_resume_compat);
++EXPORT_SYMBOL(il_pci_suspend_compat);
++EXPORT_SYMBOL(il_pci_resume_compat);
 +#endif
  
  #endif /* CONFIG_PM */
  
---- a/drivers/net/wireless/iwlegacy/iwl-core.h
-+++ b/drivers/net/wireless/iwlegacy/iwl-core.h
-@@ -499,7 +499,12 @@ __le32 iwl_legacy_add_beacon_time(struct
+--- a/drivers/net/wireless/iwlegacy/common.h
++++ b/drivers/net/wireless/iwlegacy/common.h
+@@ -2027,7 +2027,12 @@ __le32 il_add_beacon_time(struct il_priv *il, u32 base, u32 addon,
  #ifdef CONFIG_PM
- int iwl_legacy_pci_suspend(struct device *device);
- int iwl_legacy_pci_resume(struct device *device);
+ int il_pci_suspend(struct device *device);
+ int il_pci_resume(struct device *device);
 +#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,29))
-+int iwl_legacy_pci_suspend_compat(struct pci_dev *pdev, pm_message_t state);
-+int iwl_legacy_pci_resume_compat(struct pci_dev *pdev);
++int il_pci_suspend_compat(struct pci_dev *pdev, pm_message_t state);
++int il_pci_resume_compat(struct pci_dev *pdev);
 +#else
- extern const struct dev_pm_ops iwl_legacy_pm_ops;
+ extern const struct dev_pm_ops il_pm_ops;
 +#endif
  
- #define IWL_LEGACY_PM_OPS	(&iwl_legacy_pm_ops)
- 
---- a/drivers/net/wireless/iwlegacy/iwl3945-base.c
-+++ b/drivers/net/wireless/iwlegacy/iwl3945-base.c
-@@ -3960,7 +3960,12 @@ static struct pci_driver iwl3945_driver
- 	.id_table = iwl3945_hw_card_ids,
- 	.probe = iwl3945_pci_probe,
- 	.remove = __devexit_p(iwl3945_pci_remove),
-+#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,29))
- 	.driver.pm = IWL_LEGACY_PM_OPS,
-+#elif defined(CONFIG_PM)
-+	.suspend = iwl_legacy_pci_suspend_compat,
-+	.resume = iwl_legacy_pci_resume_compat,
-+#endif
- };
- 
- static int __init iwl3945_init(void)
---- a/drivers/net/wireless/iwlegacy/iwl4965-base.c
-+++ b/drivers/net/wireless/iwlegacy/iwl4965-base.c
-@@ -3225,7 +3225,12 @@ static struct pci_driver iwl4965_driver
- 	.id_table = iwl4965_hw_card_ids,
- 	.probe = iwl4965_pci_probe,
- 	.remove = __devexit_p(iwl4965_pci_remove),
-+#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,29))
- 	.driver.pm = IWL_LEGACY_PM_OPS,
-+#elif defined(CONFIG_PM)
-+	.suspend = iwl_legacy_pci_suspend_compat,
-+	.resume = iwl_legacy_pci_resume_compat,
-+#endif
- };
+ #define IL_LEGACY_PM_OPS	(&il_pm_ops)
  
- static int __init iwl4965_init(void)
 --- a/drivers/net/wireless/iwlwifi/iwl-pci.c
 +++ b/drivers/net/wireless/iwlwifi/iwl-pci.c
-@@ -536,6 +536,9 @@ static int iwl_pci_resume(struct device
+@@ -520,6 +520,9 @@ static int iwl_pci_resume(struct device *device)
  
  static SIMPLE_DEV_PM_OPS(iwl_dev_pm_ops, iwl_pci_suspend, iwl_pci_resume);
  
@@ -229,7 +201,7 @@ calls on compat code with only slight modifications.
  #define IWL_PM_OPS	(&iwl_dev_pm_ops)
  
  #else
-@@ -549,7 +552,12 @@ static struct pci_driver iwl_pci_driver
+@@ -533,7 +536,12 @@ static struct pci_driver iwl_pci_driver = {
  	.id_table = iwl_hw_card_ids,
  	.probe = iwl_pci_probe,
  	.remove = __devexit_p(iwl_pci_remove),
@@ -242,9 +214,37 @@ calls on compat code with only slight modifications.
  };
  
  int __must_check iwl_pci_register_driver(void)
+--- a/drivers/net/wireless/libertas/if_spi.c
++++ b/drivers/net/wireless/libertas/if_spi.c
+@@ -1252,6 +1252,7 @@ static int __devexit libertas_spi_remove(struct spi_device *spi)
+ 	return 0;
+ }
+ 
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,29))
+ static int if_spi_suspend(struct device *dev)
+ {
+ 	struct spi_device *spi = to_spi_device(dev);
+@@ -1285,6 +1286,7 @@ static const struct dev_pm_ops if_spi_pm_ops = {
+ 	.suspend	= if_spi_suspend,
+ 	.resume		= if_spi_resume,
+ };
++#endif
+ 
+ static struct spi_driver libertas_spi_driver = {
+ 	.probe	= if_spi_probe,
+@@ -1292,7 +1294,9 @@ static struct spi_driver libertas_spi_driver = {
+ 	.driver = {
+ 		.name	= "libertas_spi",
+ 		.owner	= THIS_MODULE,
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,29))
+ 		.pm	= &if_spi_pm_ops,
++#endif
+ 	},
+ };
+ 
 --- a/drivers/net/wireless/rtlwifi/rtl8192ce/sw.c
 +++ b/drivers/net/wireless/rtlwifi/rtl8192ce/sw.c
-@@ -381,21 +381,22 @@ MODULE_PARM_DESC(swlps, "Set to 1 to use
+@@ -381,21 +381,22 @@ MODULE_PARM_DESC(swlps, "Set to 1 to use SW control power save (default 0)\n");
  MODULE_PARM_DESC(fwlps, "Set to 1 to use FW control power save (default 1)\n");
  MODULE_PARM_DESC(debug, "Set debug level (0-5) (default 0)");
  
@@ -277,7 +277,7 @@ calls on compat code with only slight modifications.
  static int __init rtl92ce_module_init(void)
 --- a/drivers/net/wireless/rtlwifi/rtl8192de/sw.c
 +++ b/drivers/net/wireless/rtlwifi/rtl8192de/sw.c
-@@ -391,21 +391,22 @@ MODULE_PARM_DESC(swlps, "Set to 1 to use
+@@ -391,21 +391,22 @@ MODULE_PARM_DESC(swlps, "Set to 1 to use SW control power save (default 0)\n");
  MODULE_PARM_DESC(fwlps, "Set to 1 to use FW control power save (default 1)\n");
  MODULE_PARM_DESC(debug, "Set debug level (0-5) (default 0)");
  
@@ -310,7 +310,7 @@ calls on compat code with only slight modifications.
  /* add global spin lock to solve the problem that
 --- a/drivers/net/wireless/rtlwifi/rtl8192se/sw.c
 +++ b/drivers/net/wireless/rtlwifi/rtl8192se/sw.c
-@@ -403,21 +403,22 @@ MODULE_PARM_DESC(swlps, "Set to 1 to use
+@@ -403,21 +403,22 @@ MODULE_PARM_DESC(swlps, "Set to 1 to use SW control power save (default 0)\n");
  MODULE_PARM_DESC(fwlps, "Set to 1 to use FW control power save (default 1)\n");
  MODULE_PARM_DESC(debug, "Set debug level (0-5) (default 0)");
  
-- 
1.7.4.4

