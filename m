Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:32983 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753640AbYGTXkY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Jul 2008 19:40:24 -0400
From: Tomas Winkler <tomas.winkler@intel.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net, yi.zhu@intel.com
Cc: linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 3/3] iwlwifi: rename 4965 to AGN
Date: Mon, 21 Jul 2008 02:40:15 +0300
Message-Id: <1216597215-19708-4-git-send-email-tomas.winkler@intel.com> (sfid-20080721_014029_348063_E93F3EE1)
In-Reply-To: <1216597215-19708-3-git-send-email-tomas.winkler@intel.com>
References: <1216597215-19708-1-git-send-email-tomas.winkler@intel.com>
 <1216597215-19708-2-git-send-email-tomas.winkler@intel.com>
 <1216597215-19708-3-git-send-email-tomas.winkler@intel.com>
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch renames driver name from 4965 to AGN
The driver supports both 4965AGN and 5000AGN family

The driver binary module meanwhile retains it's original iwl4965.ko
name mainly because of usage in compat-wireless on platforms that already
has 4965 udev/hal settings.

This patch also cleanups iwlwifi Kconfig. 

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/net/wireless/iwlwifi/Kconfig   |   98 ++++++++++++++++---------------
 drivers/net/wireless/iwlwifi/Makefile  |   11 ++--
 drivers/net/wireless/iwlwifi/iwl-agn.c |   14 +++--
 drivers/net/wireless/iwlwifi/iwl-dev.h |    7 +--
 4 files changed, 67 insertions(+), 63 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/Kconfig b/drivers/net/wireless/iwlwifi/Kconfig
index 82b66a3..b0ac0ce 100644
--- a/drivers/net/wireless/iwlwifi/Kconfig
+++ b/drivers/net/wireless/iwlwifi/Kconfig
@@ -14,18 +14,49 @@ config IWLWIFI_LEDS
 	default n
 
 config IWLWIFI_RFKILL
-	boolean "IWLWIFI RF kill support"
+	boolean "Iwlwifi RF kill support"
 	depends on IWLCORE
 
-config IWL4965
-	tristate "Intel Wireless WiFi 4965AGN"
+config IWLWIFI_DEBUG
+	bool "Enable full debugging output in iwlagn driver"
+	depends on IWLCORE
+	---help---
+	  This option will enable debug tracing output for the iwlwifi drivers
+
+	  This will result in the kernel module being ~100k larger.  You can
+	  control which debug output is sent to the kernel log by setting the
+	  value in
+
+		/sys/class/net/wlan0/device/debug_level
+
+	  This entry will only exist if this option is enabled.
+
+	  To set a value, simply echo an 8-byte hex value to the same file:
+
+		  % echo 0x43fff > /sys/class/net/wlan0/device/debug_level
+
+	  You can find the list of debug mask values in:
+		  drivers/net/wireless/iwlwifi/iwl-debug.h
+
+	  If this is your first time using this driver, you should say Y here
+	  as the debug information can assist others in helping you resolve
+	  any problems you may encounter.
+
+config IWLWIFI_DEBUGFS
+        bool "Iwlwifi debugfs support"
+        depends on IWLCORE && IWLWIFI_DEBUG && MAC80211_DEBUGFS
+        ---help---
+	  Enable creation of debugfs files for the iwlwifi drivers.
+
+config IWLAGN
+	tristate "Intel Wireless WiFi Next Gen AGN"
 	depends on PCI && MAC80211 && WLAN_80211 && EXPERIMENTAL
 	select FW_LOADER
 	select IWLCORE
 	---help---
 	  Select to build the driver supporting the:
 
-	  Intel Wireless WiFi Link 4965AGN
+	  Intel Wireless WiFi Link Next-Gen AGN
 
 	  This driver uses the kernel's mac80211 subsystem.
 
@@ -42,60 +73,33 @@ config IWL4965
 	  If you want to compile the driver as a module ( = code which can be
 	  inserted in and removed from the running kernel whenever you want),
 	  say M here and read <file:Documentation/kbuild/modules.txt>.  The
-	  module will be called iwl4965.ko.
-
-config IWL4965_LEDS
-	bool "Enable LEDS features in iwl4965 driver"
-	depends on IWL4965
-	select IWLWIFI_LEDS
-	---help---
-	  This option enables LEDS for the iwlwifi drivers
+	  module will be called iwlagn.ko.
 
-
-config IWL4965_SPECTRUM_MEASUREMENT
-	bool "Enable Spectrum Measurement in iwl4965 driver"
-	depends on IWL4965
+config IWLAGN_SPECTRUM_MEASUREMENT
+	bool "Enable Spectrum Measurement in iwlagn driver"
+	depends on IWLAGN
 	---help---
-	  This option will enable spectrum measurement for the iwl4965 driver.
+	  This option will enable spectrum measurement for the iwlagn driver.
 
-config IWLWIFI_DEBUG
-	bool "Enable full debugging output in iwl4965 driver"
-	depends on IWL4965
+config IWLAGN_LEDS
+	bool "Enable LEDS features in iwlagn driver"
+	depends on IWLAGN
+	select IWLWIFI_LEDS
 	---help---
-	  This option will enable debug tracing output for the iwl4965
-	  driver.
-
-	  This will result in the kernel module being ~100k larger.  You can
-	  control which debug output is sent to the kernel log by setting the
-	  value in
-
-		/sys/class/net/wlan0/device/debug_level
-
-	  This entry will only exist if this option is enabled.
-
-	  To set a value, simply echo an 8-byte hex value to the same file:
-
-		  % echo 0x43fff > /sys/class/net/wlan0/device/debug_level
+	  This option enables LEDS for the iwlagn drivers
 
-	  You can find the list of debug mask values in:
-		  drivers/net/wireless/iwlwifi/iwl-4965-debug.h
 
-	  If this is your first time using this driver, you should say Y here
-	  as the debug information can assist others in helping you resolve
-	  any problems you may encounter.
+config IWL4965
+	bool "Intel Wireless WiFi 4965AGN"
+	depends on IWLAGN
+	---help---
+	  This option enables support for Intel Wireless WiFi Link 4965AGN
 
 config IWL5000
 	bool "Intel Wireless WiFi 5000AGN"
-	depends on IWL4965
+	depends on IWLAGN
 	---help---
 	  This option enables support for Intel Wireless WiFi Link 5000AGN Family
-	  Dependency on 4965 is temporary
-
-config IWLWIFI_DEBUGFS
-        bool "Iwlwifi debugfs support"
-        depends on IWLCORE && IWLWIFI_DEBUG && MAC80211_DEBUGFS
-        ---help---
-	  Enable creation of debugfs files for the iwlwifi drivers.
 
 config IWL3945
 	tristate "Intel PRO/Wireless 3945ABG/BG Network Connection"
diff --git a/drivers/net/wireless/iwlwifi/Makefile b/drivers/net/wireless/iwlwifi/Makefile
index 6bf3998..e7bbcca 100644
--- a/drivers/net/wireless/iwlwifi/Makefile
+++ b/drivers/net/wireless/iwlwifi/Makefile
@@ -6,13 +6,14 @@ iwlcore-$(CONFIG_IWLWIFI_DEBUGFS) += iwl-debugfs.o
 iwlcore-$(CONFIG_IWLWIFI_LEDS) += iwl-led.o
 iwlcore-$(CONFIG_IWLWIFI_RFKILL) += iwl-rfkill.o
 
+obj-$(CONFIG_IWLAGN)	+= iwl4965.o
+iwl4965-objs		:= iwl-agn.o iwl-agn-rs.o
+
+iwl4965-$(CONFIG_IWL4965) += iwl-4965.o
+iwl4965-$(CONFIG_IWL5000) += iwl-5000.o
+
 obj-$(CONFIG_IWL3945)	+= iwl3945.o
 iwl3945-objs		:= iwl3945-base.o iwl-3945.o iwl-3945-rs.o
 iwl3945-$(CONFIG_IWL3945_LEDS) += iwl-3945-led.o
 
-obj-$(CONFIG_IWL4965)	+= iwl4965.o
-iwl4965-objs		:= iwl-agn.o iwl-4965.o iwl-agn-rs.o
-
-iwl4965-$(CONFIG_IWL5000) += iwl-5000.o
-
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 3639607..c62f7b7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -73,7 +73,7 @@
 #define VD
 #endif
 
-#ifdef CONFIG_IWL4965_SPECTRUM_MEASUREMENT
+#ifdef CONFIG_IWLAGN_SPECTRUM_MEASUREMENT
 #define VS "s"
 #else
 #define VS
@@ -884,7 +884,7 @@ static void iwl4965_set_rate(struct iwl_priv *priv)
 		   (IWL_OFDM_BASIC_RATES_MASK >> IWL_FIRST_OFDM_RATE) & 0xFF;
 }
 
-#ifdef CONFIG_IWL4965_SPECTRUM_MEASUREMENT
+#ifdef CONFIG_IWLAGN_SPECTRUM_MEASUREMENT
 
 #include "iwl-spectrum.h"
 
@@ -1088,7 +1088,7 @@ static void iwl4965_rx_csa(struct iwl_priv *priv, struct iwl_rx_mem_buffer *rxb)
 static void iwl4965_rx_spectrum_measure_notif(struct iwl_priv *priv,
 					  struct iwl_rx_mem_buffer *rxb)
 {
-#ifdef CONFIG_IWL4965_SPECTRUM_MEASUREMENT
+#ifdef CONFIG_IWLAGN_SPECTRUM_MEASUREMENT
 	struct iwl_rx_packet *pkt = (struct iwl_rx_packet *)rxb->skb->data;
 	struct iwl4965_spectrum_notification *report = &(pkt->u.spectrum_notif);
 
@@ -3773,7 +3773,7 @@ static ssize_t store_filter_flags(struct device *d,
 static DEVICE_ATTR(filter_flags, S_IWUSR | S_IRUGO, show_filter_flags,
 		   store_filter_flags);
 
-#ifdef CONFIG_IWL4965_SPECTRUM_MEASUREMENT
+#ifdef CONFIG_IWLAGN_SPECTRUM_MEASUREMENT
 
 static ssize_t show_measurement(struct device *d,
 				struct device_attribute *attr, char *buf)
@@ -3844,7 +3844,7 @@ static ssize_t store_measurement(struct device *d,
 
 static DEVICE_ATTR(measurement, S_IRUSR | S_IWUSR,
 		   show_measurement, store_measurement);
-#endif /* CONFIG_IWL4965_SPECTRUM_MEASUREMENT */
+#endif /* CONFIG_IWLAGN_SPECTRUM_MEASUREMENT */
 
 static ssize_t store_retry_rate(struct device *d,
 				struct device_attribute *attr,
@@ -4092,7 +4092,7 @@ static struct attribute *iwl4965_sysfs_entries[] = {
 	&dev_attr_channels.attr,
 	&dev_attr_flags.attr,
 	&dev_attr_filter_flags.attr,
-#ifdef CONFIG_IWL4965_SPECTRUM_MEASUREMENT
+#ifdef CONFIG_IWLAGN_SPECTRUM_MEASUREMENT
 	&dev_attr_measurement.attr,
 #endif
 	&dev_attr_power_level.attr,
@@ -4445,8 +4445,10 @@ static int iwl4965_pci_resume(struct pci_dev *pdev)
 
 /* Hardware specific file defines the PCI IDs table for that hardware module */
 static struct pci_device_id iwl_hw_card_ids[] = {
+#ifdef CONFIG_IWL4965
 	{IWL_PCI_DEVICE(0x4229, PCI_ANY_ID, iwl4965_agn_cfg)},
 	{IWL_PCI_DEVICE(0x4230, PCI_ANY_ID, iwl4965_agn_cfg)},
+#endif /* CONFIG_IWL4965 */
 #ifdef CONFIG_IWL5000
 	{IWL_PCI_DEVICE(0x4232, 0x1205, iwl5100_bg_cfg)},
 	{IWL_PCI_DEVICE(0x4232, 0x1305, iwl5100_bg_cfg)},
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 7ac56b1..848786a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -36,7 +36,7 @@
 #include <linux/kernel.h>
 #include <net/ieee80211_radiotap.h>
 
-#define DRV_NAME        "iwl4965"
+#define DRV_NAME        "iwlagn"
 #include "iwl-rfkill.h"
 #include "iwl-eeprom.h"
 #include "iwl-4965-hw.h"
@@ -808,14 +808,11 @@ struct iwl_chain_noise_data {
 #define EEPROM_SEM_RETRY_LIMIT 1000	/* number of attempts (not time) */
 
 
-#ifdef CONFIG_IWL4965_SPECTRUM_MEASUREMENT
-
 enum {
 	MEASUREMENT_READY = (1 << 0),
 	MEASUREMENT_ACTIVE = (1 << 1),
 };
 
-#endif
 
 #define IWL_MAX_NUM_QUEUES	20 /* FIXME: do dynamic allocation */
 
@@ -840,7 +837,7 @@ struct iwl_priv {
 
 	struct ieee80211_supported_band bands[IEEE80211_NUM_BANDS];
 
-#ifdef CONFIG_IWL4965_SPECTRUM_MEASUREMENT
+#ifdef CONFIG_IWLAGN_SPECTRUM_MEASUREMENT
 	/* spectrum measurement report caching */
 	struct iwl4965_spectrum_notification measure_report;
 	u8 measurement_status;
-- 
1.5.4.1

---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

