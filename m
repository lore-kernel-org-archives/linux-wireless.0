Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:60055 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756401Ab0KJVEl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Nov 2010 16:04:41 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 1/2] compat-wireless: make patches apply again
Date: Wed, 10 Nov 2010 22:04:27 +0100
Message-Id: <1289423068-9107-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 patches/03-rfkill.patch                |   27 +++++++++------------------
 patches/08-rename-iwl4965-config.patch |   14 ++++++++++----
 2 files changed, 19 insertions(+), 22 deletions(-)

diff --git a/patches/03-rfkill.patch b/patches/03-rfkill.patch
index 0ac3758..673ebd0 100644
--- a/patches/03-rfkill.patch
+++ b/patches/03-rfkill.patch
@@ -92,7 +92,7 @@ This would do the policing from within mac80211.
  static void rfkill_led_trigger_event(struct rfkill *rfkill)
  {
  	struct led_trigger *trigger;
-@@ -318,7 +318,7 @@ static void rfkill_set_block(struct rfki
+@@ -304,7 +304,7 @@ static void rfkill_set_block(struct rfki
  	rfkill_event(rfkill);
  }
  
@@ -101,7 +101,7 @@ This would do the policing from within mac80211.
  static atomic_t rfkill_input_disabled = ATOMIC_INIT(0);
  
  /**
-@@ -819,7 +819,7 @@ static int rfkill_resume(struct device *
+@@ -805,7 +805,7 @@ static int rfkill_resume(struct device *
  }
  
  static struct class rfkill_class = {
@@ -110,7 +110,7 @@ This would do the policing from within mac80211.
  	.dev_release	= rfkill_release,
  	.dev_attrs	= rfkill_dev_attrs,
  	.dev_uevent	= rfkill_dev_uevent,
-@@ -965,7 +965,7 @@ int __must_check rfkill_register(struct
+@@ -951,7 +951,7 @@ int __must_check rfkill_register(struct
  	if (!rfkill->persistent || rfkill_epo_lock_active) {
  		schedule_work(&rfkill->sync_work);
  	} else {
@@ -119,7 +119,7 @@ This would do the policing from within mac80211.
  		bool soft_blocked = !!(rfkill->state & RFKILL_BLOCK_SW);
  
  		if (!atomic_read(&rfkill_input_disabled))
-@@ -1193,7 +1193,7 @@ static int rfkill_fop_release(struct ino
+@@ -1179,7 +1179,7 @@ static int rfkill_fop_release(struct ino
  	list_for_each_entry_safe(ev, tmp, &data->events, list)
  		kfree(ev);
  
@@ -128,7 +128,7 @@ This would do the policing from within mac80211.
  	if (data->input_handler)
  		if (atomic_dec_return(&rfkill_input_disabled) == 0)
  			printk(KERN_DEBUG "rfkill: input handler enabled\n");
-@@ -1204,7 +1204,7 @@ static int rfkill_fop_release(struct ino
+@@ -1190,7 +1190,7 @@ static int rfkill_fop_release(struct ino
  	return 0;
  }
  
@@ -137,7 +137,7 @@ This would do the policing from within mac80211.
  static long rfkill_fop_ioctl(struct file *file, unsigned int cmd,
  			     unsigned long arg)
  {
-@@ -1237,7 +1237,7 @@ static const struct file_operations rfki
+@@ -1223,7 +1223,7 @@ static const struct file_operations rfki
  	.write		= rfkill_fop_write,
  	.poll		= rfkill_fop_poll,
  	.release	= rfkill_fop_release,
@@ -146,7 +146,7 @@ This would do the policing from within mac80211.
  	.unlocked_ioctl	= rfkill_fop_ioctl,
  	.compat_ioctl	= rfkill_fop_ioctl,
  #endif
-@@ -1268,7 +1268,7 @@ static int __init rfkill_init(void)
+@@ -1254,7 +1254,7 @@ static int __init rfkill_init(void)
  		goto out;
  	}
  
@@ -155,7 +155,7 @@ This would do the policing from within mac80211.
  	error = rfkill_handler_init();
  	if (error) {
  		misc_deregister(&rfkill_miscdev);
-@@ -1284,7 +1284,7 @@ subsys_initcall(rfkill_init);
+@@ -1270,7 +1270,7 @@ subsys_initcall(rfkill_init);
  
  static void __exit rfkill_exit(void)
  {
@@ -183,15 +183,6 @@ This would do the policing from within mac80211.
  /**
   * rfkill_alloc - allocate rfkill structure
   * @name: name of the struct -- the string is not copied internally
-@@ -355,7 +356,7 @@ static inline bool rfkill_blocked(struct
- #endif /* RFKILL || RFKILL_MODULE */
- 
- 
--#ifdef CONFIG_RFKILL_LEDS
-+#ifdef CONFIG_RFKILL_BACKPORT_LEDS
- /**
-  * rfkill_get_led_trigger_name - Get the LED trigger name for the button's LED.
-  * This function might return a NULL pointer if registering of the
 --- a/net/wireless/core.h
 +++ b/net/wireless/core.h
 @@ -11,7 +11,11 @@
@@ -208,7 +199,7 @@ This would do the policing from within mac80211.
  #include <net/cfg80211.h>
 --- a/drivers/net/wireless/ath/ath9k/hw.c
 +++ b/drivers/net/wireless/ath/ath9k/hw.c
-@@ -1872,7 +1872,7 @@ int ath9k_hw_fill_cap_info(struct ath_hw
+@@ -1883,7 +1883,7 @@ int ath9k_hw_fill_cap_info(struct ath_hw
  
  	pCap->hw_caps |= ATH9K_HW_CAP_ENHANCEDPM;
  
diff --git a/patches/08-rename-iwl4965-config.patch b/patches/08-rename-iwl4965-config.patch
index 46d8bf9..a2354e9 100644
--- a/patches/08-rename-iwl4965-config.patch
+++ b/patches/08-rename-iwl4965-config.patch
@@ -16,24 +16,30 @@ CONFIG_IWL4965 has to be set to y, to build correctly.
  obj-$(CONFIG_P54_COMMON)	+= p54/
 --- a/drivers/net/wireless/iwlwifi/Makefile
 +++ b/drivers/net/wireless/iwlwifi/Makefile
-@@ -1,4 +1,4 @@
+@@ -1,9 +1,9 @@
 -obj-$(CONFIG_IWLWIFI)	+= iwlcore.o
 +obj-$(CONFIG_COMPAT_IWLWIFI)	+= iwlcore.o
  iwlcore-objs 		:= iwl-core.o iwl-eeprom.o iwl-hcmd.o iwl-power.o
  iwlcore-objs 		+= iwl-rx.o iwl-tx.o iwl-sta.o
  iwlcore-objs 		+= iwl-scan.o iwl-led.o
-@@ -15,7 +15,7 @@ iwlagn-objs		+= iwl-agn-lib.o iwl-agn-rx
+ iwlcore-$(CONFIG_IWL3945) += iwl-legacy.o
+-iwlcore-$(CONFIG_IWL4965) += iwl-legacy.o
++iwlcore-$(CONFIG_COMPAT_IWL4965) += iwl-legacy.o
+ iwlcore-$(CONFIG_IWLWIFI_DEBUGFS) += iwl-debugfs.o
+ iwlcore-$(CONFIG_IWLWIFI_DEVICE_TRACING) += iwl-devtrace.o
+ 
+@@ -17,7 +17,7 @@ iwlagn-objs		+= iwl-agn-lib.o iwl-agn-rx
  iwlagn-objs		+= iwl-agn-tt.o iwl-agn-sta.o iwl-agn-eeprom.o
  iwlagn-$(CONFIG_IWLWIFI_DEBUGFS) += iwl-agn-debugfs.o
  
 -iwlagn-$(CONFIG_IWL4965) += iwl-4965.o
 +iwlagn-$(CONFIG_COMPAT_IWL4965) += iwl-4965.o
+ iwlagn-$(CONFIG_IWL5000) += iwl-agn-rxon.o
  iwlagn-$(CONFIG_IWL5000) += iwl-5000.o
  iwlagn-$(CONFIG_IWL5000) += iwl-6000.o
- iwlagn-$(CONFIG_IWL5000) += iwl-1000.o
 --- a/drivers/net/wireless/iwlwifi/iwl-agn.c
 +++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
-@@ -4659,10 +4659,10 @@ static void __devexit iwl_pci_remove(str
+@@ -4357,10 +4357,10 @@ static void __devexit iwl_pci_remove(str
  
  /* Hardware specific file defines the PCI IDs table for that hardware module */
  static DEFINE_PCI_DEVICE_TABLE(iwl_hw_card_ids) = {
-- 
1.7.1

