Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:42988 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752563AbZBMTrp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Feb 2009 14:47:45 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 3/3] iwlwifi: Fix and rework Kconfig file
Date: Fri, 13 Feb 2009 11:51:19 -0800
Message-Id: <1234554679-30186-4-git-send-email-reinette.chatre@intel.com> (sfid-20090213_204754_954995_06E61192)
In-Reply-To: <1234554679-30186-3-git-send-email-reinette.chatre@intel.com>
References: <>
 <1234554679-30186-1-git-send-email-reinette.chatre@intel.com>
 <1234554679-30186-2-git-send-email-reinette.chatre@intel.com>
 <1234554679-30186-3-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fixes:
- iwlwifi is an optional driver and should thus not default to 'y'.
- 3945 now depends on IWLCORE.

Rework:
- There is not a case when IWLCORE should not be selected. At the same time
  the driver does not use IWLWIFI or IWLCORE. We can just merge the usage of
  these two. With IWLWIFI being the driver name we proceed to use just it and
  replace instances of IWLCORE with it. The module name does not change
  and is still iwlcore.
- Both IWLAGN and IWL3945 are selecting FW_LOADER, we can thus just move
  this up to one select when IWLWIFI is selected.
- IWL5000 now supports Intel Wireless Wifi 100, 6000, and 6050 series.
- Now that 3945 depends on IWLWIFI we can also indicate its dependency on
  MAC80211_LEDS and LEDS_CLASS at this level.
- IWLAGN_LEDS is not used by driver - remove it.
- IWLAGN_SPECTRUM_MEASUREMENT actually depends on IWLWIFI as it forms part
  of iwlcore module. Move this config up in Kconfig to reflect that and also
  change name to IWLWIFI_SPECTRUM_MEASUREMENT.
- CONFIG_IWLWIFI_RFKILL is used by iwlagn as well as iwl3945, add text to
  description that indicates this.
- CONFIG_IWL3945_RFKILL does not exist - remove usage from driver.
- Add "iwlagn" to end of description of IWLAGN to help people understand
  what iwlagn means in rest of Kconfig text.
- Add "iwl3945" to end of description of IWL3945 to help people understand
  what iwlagn means in rest of Kconfig text.
- Change IWLWIFI_DEBUGFS description to indicate that only iwlagn supports
  it (for now).

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
Reported-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/net/wireless/iwlwifi/Kconfig    |   56 +++++++++++--------------------
 drivers/net/wireless/iwlwifi/Makefile   |    4 +-
 drivers/net/wireless/iwlwifi/iwl-agn.c  |    2 +-
 drivers/net/wireless/iwlwifi/iwl-core.h |    2 +-
 drivers/net/wireless/iwlwifi/iwl-dev.h  |    4 +-
 5 files changed, 26 insertions(+), 42 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/Kconfig b/drivers/net/wireless/iwlwifi/Kconfig
index 7b3bad1..6cc5a54 100644
--- a/drivers/net/wireless/iwlwifi/Kconfig
+++ b/drivers/net/wireless/iwlwifi/Kconfig
@@ -1,27 +1,31 @@
 config IWLWIFI
-	bool "Intel Wireless Wifi"
+	tristate "Intel Wireless Wifi"
 	depends on PCI && MAC80211 && WLAN_80211 && EXPERIMENTAL
-	default y
-
-config IWLCORE
-	tristate "Intel Wireless Wifi Core"
-	depends on IWLWIFI
 	select LIB80211
+	select FW_LOADER
 	select MAC80211_LEDS if IWLWIFI_LEDS
 	select LEDS_CLASS if IWLWIFI_LEDS
 	select RFKILL if IWLWIFI_RFKILL
+	select MAC80211_LEDS if IWL3945_LEDS
+	select LEDS_CLASS if IWL3945_LEDS
 
 config IWLWIFI_LEDS
 	bool "Enable LED support in iwlagn driver"
-	depends on IWLCORE
+	depends on IWLWIFI
 
 config IWLWIFI_RFKILL
-	bool "Enable RF kill support in iwlagn driver"
-	depends on IWLCORE
+	bool "Enable RF kill support in iwlagn and iwl3945 drivers"
+	depends on IWLWIFI
+
+config IWLWIFI_SPECTRUM_MEASUREMENT
+	bool "Enable Spectrum Measurement in iwlagn driver"
+	depends on IWLWIFI
+	---help---
+	  This option will enable spectrum measurement for the iwlagn driver.
 
 config IWLWIFI_DEBUG
 	bool "Enable full debugging output in iwlagn and iwl3945 drivers"
-	depends on IWLCORE
+	depends on IWLWIFI
 	---help---
 	  This option will enable debug tracing output for the iwlwifi drivers
 
@@ -45,16 +49,14 @@ config IWLWIFI_DEBUG
 	  any problems you may encounter.
 
 config IWLWIFI_DEBUGFS
-        bool "Iwlwifi debugfs support"
-        depends on IWLCORE && IWLWIFI_DEBUG && MAC80211_DEBUGFS
+        bool "iwlagn debugfs support"
+        depends on IWLWIFI && IWLWIFI_DEBUG && MAC80211_DEBUGFS
         ---help---
 	  Enable creation of debugfs files for the iwlwifi drivers.
 
 config IWLAGN
-	tristate "Intel Wireless WiFi Next Gen AGN"
+	tristate "Intel Wireless WiFi Next Gen AGN (iwlagn)"
 	depends on IWLWIFI
-	select FW_LOADER
-	select IWLCORE
 	---help---
 	  Select to build the driver supporting the:
 
@@ -77,19 +79,6 @@ config IWLAGN
 	  say M here and read <file:Documentation/kbuild/modules.txt>.  The
 	  module will be called iwlagn.ko.
 
-config IWLAGN_SPECTRUM_MEASUREMENT
-	bool "Enable Spectrum Measurement in iwlagn driver"
-	depends on IWLAGN
-	---help---
-	  This option will enable spectrum measurement for the iwlagn driver.
-
-config IWLAGN_LEDS
-	bool "Enable LEDS features in iwlagn driver"
-	depends on IWLAGN
-	select IWLWIFI_LEDS
-	---help---
-	  This option enables LEDS for the iwlagn drivers
-
 
 config IWL4965
 	bool "Intel Wireless WiFi 4965AGN"
@@ -98,19 +87,14 @@ config IWL4965
 	  This option enables support for Intel Wireless WiFi Link 4965AGN
 
 config IWL5000
-	bool "Intel Wireless WiFi 5000AGN"
+	bool "Intel Wireless WiFi 5000AGN; Intel WiFi Link 100, 6000, and 6050 Series"
 	depends on IWLAGN
 	---help---
 	  This option enables support for Intel Wireless WiFi Link 5000AGN Family
 
 config IWL3945
-	tristate "Intel PRO/Wireless 3945ABG/BG Network Connection"
+	tristate "Intel PRO/Wireless 3945ABG/BG Network Connection (iwl3945)"
 	depends on IWLWIFI
-	select FW_LOADER
-	select LIB80211
-	select MAC80211_LEDS if IWL3945_LEDS
-	select LEDS_CLASS if IWL3945_LEDS
-	select RFKILL if IWLWIFI_RFKILL
 	---help---
 	  Select to build the driver supporting the:
 
@@ -134,7 +118,7 @@ config IWL3945
 	  module will be called iwl3945.ko.
 
 config IWL3945_SPECTRUM_MEASUREMENT
-	bool "Enable Spectrum Measurement in iwl3945 drivers"
+	bool "Enable Spectrum Measurement in iwl3945 driver"
 	depends on IWL3945
 	---help---
 	  This option will enable spectrum measurement for the iwl3945 driver.
diff --git a/drivers/net/wireless/iwlwifi/Makefile b/drivers/net/wireless/iwlwifi/Makefile
index ddc8b31..48af523 100644
--- a/drivers/net/wireless/iwlwifi/Makefile
+++ b/drivers/net/wireless/iwlwifi/Makefile
@@ -1,11 +1,11 @@
-obj-$(CONFIG_IWLCORE)	+= iwlcore.o
+obj-$(CONFIG_IWLWIFI)	+= iwlcore.o
 iwlcore-objs 		:= iwl-core.o iwl-eeprom.o iwl-hcmd.o iwl-power.o
 iwlcore-objs 		+= iwl-rx.o iwl-tx.o iwl-sta.o iwl-calib.o
 iwlcore-objs 		+= iwl-scan.o
 iwlcore-$(CONFIG_IWLWIFI_DEBUGFS) += iwl-debugfs.o
 iwlcore-$(CONFIG_IWLWIFI_LEDS) += iwl-led.o
 iwlcore-$(CONFIG_IWLWIFI_RFKILL) += iwl-rfkill.o
-iwlcore-$(CONFIG_IWLAGN_SPECTRUM_MEASUREMENT) += iwl-spectrum.o
+iwlcore-$(CONFIG_IWLWIFI_SPECTRUM_MEASUREMENT) += iwl-spectrum.o
 
 obj-$(CONFIG_IWLAGN)	+= iwlagn.o
 iwlagn-objs		:= iwl-agn.o iwl-agn-rs.o
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 432aee2..a205c5f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -72,7 +72,7 @@
 #define VD
 #endif
 
-#ifdef CONFIG_IWLAGN_SPECTRUM_MEASUREMENT
+#ifdef CONFIG_IWLWIFI_SPECTRUM_MEASUREMENT
 #define VS "s"
 #else
 #define VS
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 9d464ec..10ee20c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -379,7 +379,7 @@ void iwl_calib_free_results(struct iwl_priv *priv);
 /*******************************************************************************
  * Spectrum Measureemtns in  iwl-spectrum.c
  ******************************************************************************/
-#ifdef CONFIG_IWLAGN_SPECTRUM_MEASUREMENT
+#ifdef CONFIG_IWLWIFI_SPECTRUM_MEASUREMENT
 void iwl_setup_spectrum_handlers(struct iwl_priv *priv);
 #else
 static inline void iwl_setup_spectrum_handlers(struct iwl_priv *priv) {}
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index afde713..b3e23ab 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -841,7 +841,7 @@ struct iwl_priv {
 
 	struct ieee80211_supported_band bands[IEEE80211_NUM_BANDS];
 
-#if defined(CONFIG_IWLAGN_SPECTRUM_MEASUREMENT) || defined(CONFIG_IWL3945_SPECTRUM_MEASUREMENT)
+#if defined(CONFIG_IWLWIFI_SPECTRUM_MEASUREMENT) || defined(CONFIG_IWL3945_SPECTRUM_MEASUREMENT)
 	/* spectrum measurement report caching */
 	struct iwl_spectrum_notification measure_report;
 	u8 measurement_status;
@@ -922,7 +922,7 @@ struct iwl_priv {
 	 * 4965's initialize alive response contains some calibration data. */
 	struct iwl_init_alive_resp card_alive_init;
 	struct iwl_alive_resp card_alive;
-#if defined(CONFIG_IWLWIFI_RFKILL) || defined(CONFIG_IWL3945_RFKILL)
+#if defined(CONFIG_IWLWIFI_RFKILL)
 	struct rfkill *rfkill;
 #endif
 
-- 
1.5.4.3

