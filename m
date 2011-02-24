Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:47810 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754090Ab1BXSxX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Feb 2011 13:53:23 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com, lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 1/3] compat-wireless: updates needed for iwlwifi split
Date: Thu, 24 Feb 2011 19:53:06 +0100
Message-Id: <1298573588-2943-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This makes compat-wireless work after the iwlwifi split

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 config.mk                              |   13 +++-
 patches/08-rename-config-options.patch |   81 ++++++++++----------------
 patches/11-dev-pm-ops.patch            |  101 ++++++++++++++++++++++++--------
 patches/37-led-max-brightness.patch    |   12 ++++
 scripts/admin-update.sh                |    1 +
 5 files changed, 129 insertions(+), 79 deletions(-)

diff --git a/config.mk b/config.mk
index 2a1bf54..1fa16dd 100644
--- a/config.mk
+++ b/config.mk
@@ -233,14 +233,19 @@ ifdef CONFIG_PCI
 CONFIG_ATH5K_PCI=y
 CONFIG_ATH9K=m
 
-CONFIG_COMPAT_IWLWIFI=m
+CONFIG_IWLAGN=m
 # CONFIG_IWLWIFI_DEBUG=y
 # CONFIG_IWLWIFI_DEBUGFS=y
 # CONFIG_IWLWIFI_DEVICE_TRACING=y
-CONFIG_IWLAGN=m
-CONFIG_COMPAT_IWL4965=y
-CONFIG_IWL5000=y
+# CONFIG_IWLWIFI_DEBUG_EXPERIMENTAL_UCODE=y
+CONFIG_IWL_P2P=y
+
+CONFIG_IWLWIFI_LEGACY=m
+CONFIG_COMPAT_IWL4965=m
 CONFIG_IWL3945=m
+# CONFIG_IWLWIFI_LEGACY_DEBUG=y
+# CONFIG_IWLWIFI_LEGACY_DEBUGFS=y
+# CONFIG_IWLWIFI_LEGACY_DEVICE_TRACING=y
 
 
 CONFIG_B43=m
diff --git a/patches/08-rename-config-options.patch b/patches/08-rename-config-options.patch
index a81e0bf..b951073 100644
--- a/patches/08-rename-config-options.patch
+++ b/patches/08-rename-config-options.patch
@@ -21,63 +21,44 @@ CONFIG_BT_HIDP does not build with older kernel versions.
 +obj-$(CONFIG_COMPAT_ZD1211RW)		+= zd1211rw/
  obj-$(CONFIG_RTL8180)		+= rtl818x/
  obj-$(CONFIG_RTL8187)		+= rtl818x/
- obj-$(CONFIG_RTL8192CE)		+= rtlwifi/
-@@ -41,7 +41,7 @@ obj-$(CONFIG_ADM8211)	+= adm8211.o
+ obj-$(CONFIG_RTLWIFI)		+= rtlwifi/
+--- a/drivers/net/wireless/iwlegacy/Makefile
++++ b/drivers/net/wireless/iwlegacy/Makefile
+@@ -10,7 +10,7 @@ iwl-legacy-objs += $(iwl-legacy-m)
+ CFLAGS_iwl-devtrace.o := -I$(src)
  
- obj-$(CONFIG_MWL8K)	+= mwl8k.o
+ # 4965
+-obj-$(CONFIG_IWL4965)	+= iwl4965.o
++obj-$(CONFIG_COMPAT_IWL4965)	+= iwl4965.o
+ iwl4965-objs		:= iwl-4965.o iwl4965-base.o iwl-4965-rs.o iwl-4965-led.o
+ iwl4965-objs		+= iwl-4965-ucode.o iwl-4965-tx.o
+ iwl4965-objs		+= iwl-4965-lib.o iwl-4965-rx.o iwl-4965-calib.o
+--- a/drivers/net/wireless/iwlegacy/iwl-dev.h
++++ b/drivers/net/wireless/iwlegacy/iwl-dev.h
+@@ -1221,7 +1221,7 @@ struct iwl_priv {
  
--obj-$(CONFIG_IWLWIFI)	+= iwlwifi/
-+obj-$(CONFIG_COMPAT_IWLWIFI)	+= iwlwifi/
- obj-$(CONFIG_RT2X00)	+= rt2x00/
- 
- obj-$(CONFIG_P54_COMMON)	+= p54/
---- a/drivers/net/wireless/iwlwifi/Makefile
-+++ b/drivers/net/wireless/iwlwifi/Makefile
-@@ -1,9 +1,9 @@
--obj-$(CONFIG_IWLWIFI)	+= iwlcore.o
-+obj-$(CONFIG_COMPAT_IWLWIFI)	+= iwlcore.o
- iwlcore-objs 		:= iwl-core.o iwl-eeprom.o iwl-hcmd.o iwl-power.o
- iwlcore-objs 		+= iwl-rx.o iwl-tx.o iwl-sta.o
- iwlcore-objs 		+= iwl-scan.o iwl-led.o
- iwlcore-$(CONFIG_IWL3945) += iwl-legacy.o
--iwlcore-$(CONFIG_IWL4965) += iwl-legacy.o
-+iwlcore-$(CONFIG_COMPAT_IWL4965) += iwl-legacy.o
- iwlcore-$(CONFIG_IWLWIFI_DEBUGFS) += iwl-debugfs.o
- iwlcore-$(CONFIG_IWLWIFI_DEVICE_TRACING) += iwl-devtrace.o
- 
-@@ -21,7 +21,7 @@ iwlagn-objs		+= iwl-agn-lib.o iwl-agn-rx
- iwlagn-objs		+= iwl-agn-tt.o iwl-agn-sta.o iwl-agn-eeprom.o
- iwlagn-$(CONFIG_IWLWIFI_DEBUGFS) += iwl-agn-debugfs.o
- 
--iwlagn-$(CONFIG_IWL4965) += iwl-4965.o
-+iwlagn-$(CONFIG_COMPAT_IWL4965) += iwl-4965.o
- iwlagn-$(CONFIG_IWL5000) += iwl-agn-rxon.o iwl-agn-hcmd.o iwl-agn-ict.o
- iwlagn-$(CONFIG_IWL5000) += iwl-5000.o
- iwlagn-$(CONFIG_IWL5000) += iwl-6000.o
---- a/drivers/net/wireless/iwlwifi/iwl-agn.c
-+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
-@@ -4121,7 +4121,7 @@ static int iwl_pci_probe(struct pci_dev
- #ifdef CONFIG_IWL5000
- 		iwlagn_hw_ops.hw_scan = NULL;
+ 		} _3945;
  #endif
--#ifdef CONFIG_IWL4965
-+#ifdef CONFIG_COMPAT_IWL4965
- 		iwl4965_hw_ops.hw_scan = NULL;
- #endif
- 	}
-@@ -4502,10 +4502,10 @@ static void __devexit iwl_pci_remove(str
+-#if defined(CONFIG_IWL4965) || defined(CONFIG_IWL4965_MODULE)
++#if defined(CONFIG_COMPAT_IWL4965) || defined(CONFIG_COMPAT_IWL4965_MODULE)
+ 		struct {
+ 			/*
+ 			 * reporting the number of tids has AGG on. 0 means
+--- a/drivers/net/wireless/iwlegacy/iwl4965-base.c
++++ b/drivers/net/wireless/iwlegacy/iwl4965-base.c
+@@ -3563,10 +3563,10 @@ void iwl4965_txq_set_sched(struct iwl_pr
  
  /* Hardware specific file defines the PCI IDs table for that hardware module */
- static DEFINE_PCI_DEVICE_TABLE(iwl_hw_card_ids) = {
--#ifdef CONFIG_IWL4965
-+#ifdef CONFIG_COMPAT_IWL4965
- 	{IWL_PCI_DEVICE(0x4229, PCI_ANY_ID, iwl4965_agn_cfg)},
- 	{IWL_PCI_DEVICE(0x4230, PCI_ANY_ID, iwl4965_agn_cfg)},
+ static DEFINE_PCI_DEVICE_TABLE(iwl4965_hw_card_ids) = {
+-#if defined(CONFIG_IWL4965_MODULE) || defined(CONFIG_IWL4965)
++#if defined(CONFIG_COMPAT_IWL4965_MODULE) || defined(CONFIG_COMPAT_IWL4965)
+ 	{IWL_PCI_DEVICE(0x4229, PCI_ANY_ID, iwl4965_cfg)},
+ 	{IWL_PCI_DEVICE(0x4230, PCI_ANY_ID, iwl4965_cfg)},
 -#endif /* CONFIG_IWL4965 */
 +#endif /* CONFIG_COMPAT_IWL4965 */
- #ifdef CONFIG_IWL5000
- /* 5100 Series WiFi */
- 	{IWL_PCI_DEVICE(0x4232, 0x1201, iwl5100_agn_cfg)}, /* Mini Card */
+ 
+ 	{0}
+ };
 --- a/drivers/net/wireless/zd1211rw/Makefile
 +++ b/drivers/net/wireless/zd1211rw/Makefile
 @@ -1,4 +1,4 @@
diff --git a/patches/11-dev-pm-ops.patch b/patches/11-dev-pm-ops.patch
index 4f06028..24e72ac 100644
--- a/patches/11-dev-pm-ops.patch
+++ b/patches/11-dev-pm-ops.patch
@@ -117,9 +117,82 @@ calls on compat code with only slight modifications.
  };
  
  int ath_pci_init(void)
+--- a/drivers/net/wireless/iwlegacy/iwl-core.c
++++ b/drivers/net/wireless/iwlegacy/iwl-core.c
+@@ -2032,15 +2032,17 @@ int iwl_legacy_pci_resume(struct device
+ }
+ EXPORT_SYMBOL(iwl_legacy_pci_resume);
+ 
+-const struct dev_pm_ops iwl_legacy_pm_ops = {
+-	.suspend = iwl_legacy_pci_suspend,
+-	.resume = iwl_legacy_pci_resume,
+-	.freeze = iwl_legacy_pci_suspend,
+-	.thaw = iwl_legacy_pci_resume,
+-	.poweroff = iwl_legacy_pci_suspend,
+-	.restore = iwl_legacy_pci_resume,
+-};
++const SIMPLE_DEV_PM_OPS(iwl_legacy_pm_ops, iwl_legacy_pci_suspend, iwl_legacy_pci_resume);
++
++compat_pci_suspend(iwl_legacy_pci_suspend)
++compat_pci_resume(iwl_legacy_pci_resume)
++
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,29))
+ EXPORT_SYMBOL(iwl_legacy_pm_ops);
++#else
++EXPORT_SYMBOL(iwl_legacy_pci_suspend_compat);
++EXPORT_SYMBOL(iwl_legacy_pci_resume_compat);
++#endif
+ 
+ #endif /* CONFIG_PM */
+ 
+--- a/drivers/net/wireless/iwlegacy/iwl-core.h
++++ b/drivers/net/wireless/iwlegacy/iwl-core.h
+@@ -506,7 +506,12 @@ __le32 iwl_legacy_add_beacon_time(struct
+ #ifdef CONFIG_PM
+ int iwl_legacy_pci_suspend(struct device *device);
+ int iwl_legacy_pci_resume(struct device *device);
++#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,29))
++int iwl_legacy_pci_suspend_compat(struct pci_dev *pdev, pm_message_t state);
++int iwl_legacy_pci_resume_compat(struct pci_dev *pdev);
++#else
+ extern const struct dev_pm_ops iwl_legacy_pm_ops;
++#endif
+ 
+ #define IWL_LEGACY_PM_OPS	(&iwl_legacy_pm_ops)
+ 
+--- a/drivers/net/wireless/iwlegacy/iwl3945-base.c
++++ b/drivers/net/wireless/iwlegacy/iwl3945-base.c
+@@ -4237,7 +4237,12 @@ static struct pci_driver iwl3945_driver
+ 	.id_table = iwl3945_hw_card_ids,
+ 	.probe = iwl3945_pci_probe,
+ 	.remove = __devexit_p(iwl3945_pci_remove),
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,29))
+ 	.driver.pm = IWL_LEGACY_PM_OPS,
++#elif defined(CONFIG_PM)
++	.suspend = iwl_legacy_pci_suspend_compat,
++	.resume = iwl_legacy_pci_resume_compat,
++#endif
+ };
+ 
+ static int __init iwl3945_init(void)
+--- a/drivers/net/wireless/iwlegacy/iwl4965-base.c
++++ b/drivers/net/wireless/iwlegacy/iwl4965-base.c
+@@ -3577,7 +3577,12 @@ static struct pci_driver iwl4965_driver
+ 	.id_table = iwl4965_hw_card_ids,
+ 	.probe = iwl4965_pci_probe,
+ 	.remove = __devexit_p(iwl4965_pci_remove),
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,29))
+ 	.driver.pm = IWL_LEGACY_PM_OPS,
++#elif defined(CONFIG_PM)
++	.suspend = iwl_legacy_pci_suspend_compat,
++	.resume = iwl_legacy_pci_resume_compat,
++#endif
+ };
+ 
+ static int __init iwl4965_init(void)
 --- a/drivers/net/wireless/iwlwifi/iwl-agn.c
 +++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
-@@ -4704,7 +4704,12 @@ static struct pci_driver iwl_driver = {
+@@ -4697,7 +4697,12 @@ static struct pci_driver iwl_driver = {
  	.id_table = iwl_hw_card_ids,
  	.probe = iwl_pci_probe,
  	.remove = __devexit_p(iwl_pci_remove),
@@ -134,9 +207,9 @@ calls on compat code with only slight modifications.
  static int __init iwl_init(void)
 --- a/drivers/net/wireless/iwlwifi/iwl-core.c
 +++ b/drivers/net/wireless/iwlwifi/iwl-core.c
-@@ -2101,14 +2101,16 @@ int iwl_pci_resume(struct device *device
+@@ -2070,13 +2070,9 @@ int iwl_pci_resume(struct device *device
+ 	return 0;
  }
- EXPORT_SYMBOL(iwl_pci_resume);
  
 -const struct dev_pm_ops iwl_pm_ops = {
 -	.suspend = iwl_pci_suspend,
@@ -150,13 +223,6 @@ calls on compat code with only slight modifications.
 +
 +compat_pci_suspend(iwl_pci_suspend)
 +compat_pci_resume(iwl_pci_resume)
-+
-+#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,29))
- EXPORT_SYMBOL(iwl_pm_ops);
-+#else
-+EXPORT_SYMBOL(iwl_pci_suspend_compat);
-+EXPORT_SYMBOL(iwl_pci_resume_compat);
-+#endif
  
  #endif /* CONFIG_PM */
 --- a/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -174,18 +240,3 @@ calls on compat code with only slight modifications.
  
  #define IWL_PM_OPS	(&iwl_pm_ops)
  
---- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
-+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
-@@ -4277,7 +4277,12 @@ static struct pci_driver iwl3945_driver
- 	.id_table = iwl3945_hw_card_ids,
- 	.probe = iwl3945_pci_probe,
- 	.remove = __devexit_p(iwl3945_pci_remove),
-+#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,29))
- 	.driver.pm = IWL_PM_OPS,
-+#elif defined(CONFIG_PM)
-+	.suspend = iwl_pci_suspend_compat,
-+	.resume = iwl_pci_resume_compat,
-+#endif
- };
- 
- static int __init iwl3945_init(void)
diff --git a/patches/37-led-max-brightness.patch b/patches/37-led-max-brightness.patch
index ef684b5..ca62ca9 100644
--- a/patches/37-led-max-brightness.patch
+++ b/patches/37-led-max-brightness.patch
@@ -1,3 +1,15 @@
+--- a/drivers/net/wireless/iwlegacy/iwl-led.c
++++ b/drivers/net/wireless/iwlegacy/iwl-led.c
+@@ -149,7 +149,9 @@ void iwl_legacy_leds_init(struct iwl_pri
+ 				   wiphy_name(priv->hw->wiphy));
+ 	priv->led.brightness_set = iwl_legacy_led_brightness_set;
+ 	priv->led.blink_set = iwl_legacy_led_blink_set;
++#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,30)
+ 	priv->led.max_brightness = 1;
++#endif
+ 
+ 	switch (mode) {
+ 	case IWL_LED_DEFAULT:
 --- a/drivers/net/wireless/iwlwifi/iwl-led.c
 +++ b/drivers/net/wireless/iwlwifi/iwl-led.c
 @@ -149,7 +149,9 @@ void iwl_leds_init(struct iwl_priv *priv
diff --git a/scripts/admin-update.sh b/scripts/admin-update.sh
index d0eda2f..dd88f65 100755
--- a/scripts/admin-update.sh
+++ b/scripts/admin-update.sh
@@ -223,6 +223,7 @@ DRIVERS="$DRIVERS drivers/net/wireless/ath/ath9k"
 DRIVERS="$DRIVERS drivers/ssb"
 DRIVERS="$DRIVERS drivers/net/wireless/b43"
 DRIVERS="$DRIVERS drivers/net/wireless/b43legacy"
+DRIVERS="$DRIVERS drivers/net/wireless/iwlegacy"
 DRIVERS="$DRIVERS drivers/net/wireless/iwlwifi"
 DRIVERS="$DRIVERS drivers/net/wireless/rt2x00"
 DRIVERS="$DRIVERS drivers/net/wireless/zd1211rw"
-- 
1.7.1

