Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:42606 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751808Ab1KXTru (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Nov 2011 14:47:50 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com, mcgrof@qca.qualcomm.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 2/2] compat-wireless: make patches apply again
Date: Thu, 24 Nov 2011 20:47:36 +0100
Message-Id: <1322164056-22118-2-git-send-email-hauke@hauke-m.de> (sfid-20111124_204754_428223_C70BA83E)
In-Reply-To: <1322164056-22118-1-git-send-email-hauke@hauke-m.de>
References: <1322164056-22118-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

many files in iwlegacy where renamed this causes our patches not
applying any more.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 patches/08-rename-config-options.patch |   33 +++-------
 patches/11-dev-pm-ops.patch            |  110 ++++++++++++++++----------------
 patches/38-led-max-brightness.patch    |   16 ++--
 patches/39-remove_blink_set.patch      |   34 +++++-----
 4 files changed, 89 insertions(+), 104 deletions(-)

diff --git a/patches/08-rename-config-options.patch b/patches/08-rename-config-options.patch
index d22d79a..fdd39ec 100644
--- a/patches/08-rename-config-options.patch
+++ b/patches/08-rename-config-options.patch
@@ -24,41 +24,26 @@ CONFIG_BT_HIDP does not build with older kernel versions.
  obj-$(CONFIG_RTLWIFI)		+= rtlwifi/
 --- a/drivers/net/wireless/iwlegacy/Makefile
 +++ b/drivers/net/wireless/iwlegacy/Makefile
-@@ -10,7 +10,7 @@ iwl-legacy-objs += $(iwl-legacy-m)
- CFLAGS_iwl-devtrace.o := -I$(src)
+@@ -5,7 +5,7 @@ iwlegacy-$(CONFIG_IWLEGACY_DEBUGFS) += d
+ iwlegacy-objs += $(iwlegacy-m)
  
  # 4965
 -obj-$(CONFIG_IWL4965)	+= iwl4965.o
 +obj-$(CONFIG_COMPAT_IWL4965)	+= iwl4965.o
- iwl4965-objs		:= iwl-4965.o iwl4965-base.o iwl-4965-rs.o iwl-4965-led.o
- iwl4965-objs		+= iwl-4965-ucode.o iwl-4965-tx.o
- iwl4965-objs		+= iwl-4965-lib.o iwl-4965-rx.o iwl-4965-calib.o
---- a/drivers/net/wireless/iwlegacy/iwl-dev.h
-+++ b/drivers/net/wireless/iwlegacy/iwl-dev.h
-@@ -1163,7 +1163,7 @@ struct iwl_priv {
+ iwl4965-objs		:= 4965.o 4965-mac.o 4965-rs.o 4965-calib.o
+ iwl4965-$(CONFIG_IWLEGACY_DEBUGFS) += 4965-debug.o
+ 
+--- a/drivers/net/wireless/iwlegacy/common.h
++++ b/drivers/net/wireless/iwlegacy/common.h
+@@ -1411,7 +1411,7 @@ struct il_priv {
  
  		} _3945;
  #endif
 -#if defined(CONFIG_IWL4965) || defined(CONFIG_IWL4965_MODULE)
 +#if defined(CONFIG_COMPAT_IWL4965) || defined(CONFIG_COMPAT_IWL4965_MODULE)
  		struct {
- 			struct iwl_rx_phy_res last_phy_res;
+ 			struct il_rx_phy_res last_phy_res;
  			bool last_phy_res_valid;
---- a/drivers/net/wireless/iwlegacy/iwl4965-base.c
-+++ b/drivers/net/wireless/iwlegacy/iwl4965-base.c
-@@ -3211,10 +3211,10 @@ void iwl4965_txq_set_sched(struct iwl_pr
- 
- /* Hardware specific file defines the PCI IDs table for that hardware module */
- static DEFINE_PCI_DEVICE_TABLE(iwl4965_hw_card_ids) = {
--#if defined(CONFIG_IWL4965_MODULE) || defined(CONFIG_IWL4965)
-+#if defined(CONFIG_COMPAT_IWL4965_MODULE) || defined(CONFIG_COMPAT_IWL4965)
- 	{IWL_PCI_DEVICE(0x4229, PCI_ANY_ID, iwl4965_cfg)},
- 	{IWL_PCI_DEVICE(0x4230, PCI_ANY_ID, iwl4965_cfg)},
--#endif /* CONFIG_IWL4965 */
-+#endif /* CONFIG_COMPAT_IWL4965 */
- 
- 	{0}
- };
 --- a/drivers/net/wireless/libertas/Makefile
 +++ b/drivers/net/wireless/libertas/Makefile
 @@ -16,5 +16,5 @@ libertas_spi-objs += if_spi.o
diff --git a/patches/11-dev-pm-ops.patch b/patches/11-dev-pm-ops.patch
index 294aaba..756ee7d 100644
--- a/patches/11-dev-pm-ops.patch
+++ b/patches/11-dev-pm-ops.patch
@@ -9,7 +9,7 @@ calls on compat code with only slight modifications.
 
 --- a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
 +++ b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
-@@ -2897,6 +2897,9 @@ static struct pci_error_handlers atl1c_e
+@@ -2900,6 +2900,9 @@ static struct pci_error_handlers atl1c_e
  
  static SIMPLE_DEV_PM_OPS(atl1c_pm_ops, atl1c_suspend, atl1c_resume);
  
@@ -19,7 +19,7 @@ calls on compat code with only slight modifications.
  static struct pci_driver atl1c_driver = {
  	.name     = atl1c_driver_name,
  	.id_table = atl1c_pci_tbl,
-@@ -2904,7 +2907,12 @@ static struct pci_driver atl1c_driver =
+@@ -2907,7 +2910,12 @@ static struct pci_driver atl1c_driver =
  	.remove   = __devexit_p(atl1c_remove),
  	.shutdown = atl1c_shutdown,
  	.err_handler = &atl1c_err_handler,
@@ -118,7 +118,7 @@ calls on compat code with only slight modifications.
  int ath_pci_init(void)
 --- a/drivers/net/wireless/libertas/if_spi.c
 +++ b/drivers/net/wireless/libertas/if_spi.c
-@@ -1251,6 +1251,7 @@ static int __devexit libertas_spi_remove
+@@ -1252,6 +1252,7 @@ static int __devexit libertas_spi_remove
  	return 0;
  }
  
@@ -126,7 +126,7 @@ calls on compat code with only slight modifications.
  static int if_spi_suspend(struct device *dev)
  {
  	struct spi_device *spi = to_spi_device(dev);
-@@ -1284,6 +1285,7 @@ static const struct dev_pm_ops if_spi_pm
+@@ -1285,6 +1286,7 @@ static const struct dev_pm_ops if_spi_pm
  	.suspend	= if_spi_suspend,
  	.resume		= if_spi_resume,
  };
@@ -134,7 +134,7 @@ calls on compat code with only slight modifications.
  
  static struct spi_driver libertas_spi_driver = {
  	.probe	= if_spi_probe,
-@@ -1292,7 +1294,9 @@ static struct spi_driver libertas_spi_dr
+@@ -1293,7 +1295,9 @@ static struct spi_driver libertas_spi_dr
  		.name	= "libertas_spi",
  		.bus	= &spi_bus_type,
  		.owner	= THIS_MODULE,
@@ -144,82 +144,82 @@ calls on compat code with only slight modifications.
  	},
  };
  
---- a/drivers/net/wireless/iwlegacy/iwl-core.c
-+++ b/drivers/net/wireless/iwlegacy/iwl-core.c
-@@ -2016,15 +2016,17 @@ int iwl_legacy_pci_resume(struct device
+--- a/drivers/net/wireless/iwlegacy/common.c
++++ b/drivers/net/wireless/iwlegacy/common.c
+@@ -5079,15 +5079,16 @@ il_pci_resume(struct device *device)
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
-+
-+compat_pci_suspend(iwl_legacy_pci_suspend)
-+compat_pci_resume(iwl_legacy_pci_resume)
++const SIMPLE_DEV_PM_OPS(il_pm_ops, il_pci_suspend, il_pci_resume);
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
+@@ -2027,7 +2027,13 @@ __le32 il_add_beacon_time(struct il_priv
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
++
  
- #define IWL_LEGACY_PM_OPS	(&iwl_legacy_pm_ops)
+ #define IL_LEGACY_PM_OPS	(&il_pm_ops)
  
---- a/drivers/net/wireless/iwlegacy/iwl3945-base.c
-+++ b/drivers/net/wireless/iwlegacy/iwl3945-base.c
-@@ -3960,7 +3960,12 @@ static struct pci_driver iwl3945_driver
- 	.id_table = iwl3945_hw_card_ids,
- 	.probe = iwl3945_pci_probe,
- 	.remove = __devexit_p(iwl3945_pci_remove),
+--- a/drivers/net/wireless/iwlegacy/3945-mac.c
++++ b/drivers/net/wireless/iwlegacy/3945-mac.c
+@@ -3920,7 +3920,12 @@ static struct pci_driver il3945_driver =
+ 	.id_table = il3945_hw_card_ids,
+ 	.probe = il3945_pci_probe,
+ 	.remove = __devexit_p(il3945_pci_remove),
 +#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,29))
- 	.driver.pm = IWL_LEGACY_PM_OPS,
+ 	.driver.pm = IL_LEGACY_PM_OPS,
 +#elif defined(CONFIG_PM)
-+	.suspend = iwl_legacy_pci_suspend_compat,
-+	.resume = iwl_legacy_pci_resume_compat,
++	.suspend = il_pci_suspend_compat,
++	.resume = il_pci_resume_compat,
 +#endif
  };
  
- static int __init iwl3945_init(void)
---- a/drivers/net/wireless/iwlegacy/iwl4965-base.c
-+++ b/drivers/net/wireless/iwlegacy/iwl4965-base.c
-@@ -3225,7 +3225,12 @@ static struct pci_driver iwl4965_driver
- 	.id_table = iwl4965_hw_card_ids,
- 	.probe = iwl4965_pci_probe,
- 	.remove = __devexit_p(iwl4965_pci_remove),
+ static int __init
+--- a/drivers/net/wireless/iwlegacy/4965-mac.c
++++ b/drivers/net/wireless/iwlegacy/4965-mac.c
+@@ -6478,7 +6478,12 @@ static struct pci_driver il4965_driver =
+ 	.id_table = il4965_hw_card_ids,
+ 	.probe = il4965_pci_probe,
+ 	.remove = __devexit_p(il4965_pci_remove),
 +#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,29))
- 	.driver.pm = IWL_LEGACY_PM_OPS,
+ 	.driver.pm = IL_LEGACY_PM_OPS,
 +#elif defined(CONFIG_PM)
-+	.suspend = iwl_legacy_pci_suspend_compat,
-+	.resume = iwl_legacy_pci_resume_compat,
++	.suspend = il_pci_suspend_compat,
++	.resume = il_pci_resume_compat,
 +#endif
  };
  
- static int __init iwl4965_init(void)
+ static int __init
 --- a/drivers/net/wireless/iwlwifi/iwl-pci.c
 +++ b/drivers/net/wireless/iwlwifi/iwl-pci.c
-@@ -536,6 +536,9 @@ static int iwl_pci_resume(struct device
+@@ -520,6 +520,9 @@ static int iwl_pci_resume(struct device
  
  static SIMPLE_DEV_PM_OPS(iwl_dev_pm_ops, iwl_pci_suspend, iwl_pci_resume);
  
@@ -229,7 +229,7 @@ calls on compat code with only slight modifications.
  #define IWL_PM_OPS	(&iwl_dev_pm_ops)
  
  #else
-@@ -549,7 +552,12 @@ static struct pci_driver iwl_pci_driver
+@@ -533,7 +536,12 @@ static struct pci_driver iwl_pci_driver
  	.id_table = iwl_hw_card_ids,
  	.probe = iwl_pci_probe,
  	.remove = __devexit_p(iwl_pci_remove),
diff --git a/patches/38-led-max-brightness.patch b/patches/38-led-max-brightness.patch
index 64ecc9c..ec33b21 100644
--- a/patches/38-led-max-brightness.patch
+++ b/patches/38-led-max-brightness.patch
@@ -1,15 +1,15 @@
---- a/drivers/net/wireless/iwlegacy/iwl-led.c
-+++ b/drivers/net/wireless/iwlegacy/iwl-led.c
-@@ -166,7 +166,9 @@ void iwl_legacy_leds_init(struct iwl_pri
- 				   wiphy_name(priv->hw->wiphy));
- 	priv->led.brightness_set = iwl_legacy_led_brightness_set;
- 	priv->led.blink_set = iwl_legacy_led_blink_set;
+--- a/drivers/net/wireless/iwlegacy/common.c
++++ b/drivers/net/wireless/iwlegacy/common.c
+@@ -402,7 +402,9 @@ il_leds_init(struct il_priv *il)
+ 	    kasprintf(GFP_KERNEL, "%s-led", wiphy_name(il->hw->wiphy));
+ 	il->led.brightness_set = il_led_brightness_set;
+ 	il->led.blink_set = il_led_blink_set;
 +#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,30)
- 	priv->led.max_brightness = 1;
+ 	il->led.max_brightness = 1;
 +#endif
  
  	switch (mode) {
- 	case IWL_LED_DEFAULT:
+ 	case IL_LED_DEFAULT:
 --- a/drivers/net/wireless/iwlwifi/iwl-led.c
 +++ b/drivers/net/wireless/iwlwifi/iwl-led.c
 @@ -184,7 +184,9 @@ void iwl_leds_init(struct iwl_priv *priv
diff --git a/patches/39-remove_blink_set.patch b/patches/39-remove_blink_set.patch
index a39b634..ba43d8d 100644
--- a/patches/39-remove_blink_set.patch
+++ b/patches/39-remove_blink_set.patch
@@ -1,30 +1,30 @@
---- a/drivers/net/wireless/iwlegacy/iwl-led.c
-+++ b/drivers/net/wireless/iwlegacy/iwl-led.c
-@@ -145,6 +145,7 @@ static void iwl_legacy_led_brightness_se
- 	iwl_legacy_led_cmd(priv, on, 0);
+--- a/drivers/net/wireless/iwlegacy/common.c
++++ b/drivers/net/wireless/iwlegacy/common.c
+@@ -380,6 +380,7 @@ il_led_brightness_set(struct led_classde
+ 	il_led_cmd(il, on, 0);
  }
  
 +#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,25))
- static int iwl_legacy_led_blink_set(struct led_classdev *led_cdev,
- 			     unsigned long *delay_on,
- 			     unsigned long *delay_off)
-@@ -153,6 +154,7 @@ static int iwl_legacy_led_blink_set(stru
+ static int
+ il_led_blink_set(struct led_classdev *led_cdev, unsigned long *delay_on,
+ 		 unsigned long *delay_off)
+@@ -388,6 +389,7 @@ il_led_blink_set(struct led_classdev *le
  
- 	return iwl_legacy_led_cmd(priv, *delay_on, *delay_off);
+ 	return il_led_cmd(il, *delay_on, *delay_off);
  }
 +#endif
  
- void iwl_legacy_leds_init(struct iwl_priv *priv)
- {
-@@ -165,7 +167,9 @@ void iwl_legacy_leds_init(struct iwl_pri
- 	priv->led.name = kasprintf(GFP_KERNEL, "%s-led",
- 				   wiphy_name(priv->hw->wiphy));
- 	priv->led.brightness_set = iwl_legacy_led_brightness_set;
+ void
+ il_leds_init(struct il_priv *il)
+@@ -401,7 +403,9 @@ il_leds_init(struct il_priv *il)
+ 	il->led.name =
+ 	    kasprintf(GFP_KERNEL, "%s-led", wiphy_name(il->hw->wiphy));
+ 	il->led.brightness_set = il_led_brightness_set;
 +#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,25))
- 	priv->led.blink_set = iwl_legacy_led_blink_set;
+ 	il->led.blink_set = il_led_blink_set;
 +#endif
  #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,30)
- 	priv->led.max_brightness = 1;
+ 	il->led.max_brightness = 1;
  #endif
 --- a/drivers/net/wireless/iwlwifi/iwl-led.c
 +++ b/drivers/net/wireless/iwlwifi/iwl-led.c
-- 
1.7.5.4

