Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:38478 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755072Ab1I3T1z (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Sep 2011 15:27:55 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Don Fry <donald.h.fry@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 1/1] iwlagn: rename iwlagn module iwlwifi and alias to iwlagn.
Date: Fri, 30 Sep 2011 11:40:20 -0700
Message-Id: <1317408020-16627-2-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110930_212800_003958_26528182)
In-Reply-To: <1317408020-16627-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1317408020-16627-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Don Fry <donald.h.fry@intel.com>

Rename the iwlagn module as iwlwifi in preparation for future
changes.  Add an alias to iwlagn for backward compatibility.

Signed-off-by: Don Fry <donald.h.fry@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 Documentation/feature-removal-schedule.txt |    5 +++
 drivers/net/wireless/Makefile              |    2 +-
 drivers/net/wireless/iwlwifi/Kconfig       |   22 +++++++-------
 drivers/net/wireless/iwlwifi/Makefile      |   40 ++++++++++++++--------------
 drivers/net/wireless/iwlwifi/iwl-agn.c     |    1 +
 drivers/net/wireless/iwlwifi/iwl-shared.h  |    2 +-
 6 files changed, 39 insertions(+), 33 deletions(-)

diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index dfd6a9f..1cf3dbd 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -555,3 +555,8 @@ Why:	This driver has been superseded by g_mass_storage.
 Who:	Alan Stern <stern@rowland.harvard.edu>
 
 ----------------------------
+What:	iwlagn alias support
+When:	3.5
+Why:	The iwlagn module has been renamed iwlwifi.  The alias will be around
+	for backward compatibility for several cycles and then dropped.
+Who:	Don Fry <donald.h.fry@intel.com>
\ No newline at end of file
diff --git a/drivers/net/wireless/Makefile b/drivers/net/wireless/Makefile
index 7bba6a8..4cf0ad3 100644
--- a/drivers/net/wireless/Makefile
+++ b/drivers/net/wireless/Makefile
@@ -41,7 +41,7 @@ obj-$(CONFIG_ADM8211)	+= adm8211.o
 
 obj-$(CONFIG_MWL8K)	+= mwl8k.o
 
-obj-$(CONFIG_IWLAGN)	+= iwlwifi/
+obj-$(CONFIG_IWLWIFI)	+= iwlwifi/
 obj-$(CONFIG_IWLWIFI_LEGACY)	+= iwlegacy/
 obj-$(CONFIG_RT2X00)	+= rt2x00/
 
diff --git a/drivers/net/wireless/iwlwifi/Kconfig b/drivers/net/wireless/iwlwifi/Kconfig
index 1d7572f..e044103 100644
--- a/drivers/net/wireless/iwlwifi/Kconfig
+++ b/drivers/net/wireless/iwlwifi/Kconfig
@@ -1,5 +1,5 @@
-config IWLAGN
-	tristate "Intel Wireless WiFi Next Gen AGN - Wireless-N/Advanced-N/Ultimate-N (iwlagn) "
+config IWLWIFI
+	tristate "Intel Wireless WiFi Next Gen AGN - Wireless-N/Advanced-N/Ultimate-N (iwlwifi) "
 	depends on PCI && MAC80211
 	select FW_LOADER
 	select NEW_LEDS
@@ -39,14 +39,14 @@ config IWLAGN
 	  If you want to compile the driver as a module ( = code which can be
 	  inserted in and removed from the running kernel whenever you want),
 	  say M here and read <file:Documentation/kbuild/modules.txt>.  The
-	  module will be called iwlagn.
+	  module will be called iwlwifi.
 
 menu "Debugging Options"
-	depends on IWLAGN
+	depends on IWLWIFI
 
 config IWLWIFI_DEBUG
-	bool "Enable full debugging output in the iwlagn driver"
-	depends on IWLAGN
+	bool "Enable full debugging output in the iwlwifi driver"
+	depends on IWLWIFI
 	---help---
 	  This option will enable debug tracing output for the iwlwifi drivers
 
@@ -70,8 +70,8 @@ config IWLWIFI_DEBUG
 	  any problems you may encounter.
 
 config IWLWIFI_DEBUGFS
-        bool "iwlagn debugfs support"
-        depends on IWLAGN && MAC80211_DEBUGFS
+        bool "iwlwifi debugfs support"
+        depends on IWLWIFI && MAC80211_DEBUGFS
         ---help---
 	  Enable creation of debugfs files for the iwlwifi drivers. This
 	  is a low-impact option that allows getting insight into the
@@ -79,13 +79,13 @@ config IWLWIFI_DEBUGFS
 
 config IWLWIFI_DEBUG_EXPERIMENTAL_UCODE
         bool "Experimental uCode support"
-        depends on IWLAGN && IWLWIFI_DEBUG
+        depends on IWLWIFI && IWLWIFI_DEBUG
         ---help---
 	  Enable use of experimental ucode for testing and debugging.
 
 config IWLWIFI_DEVICE_TRACING
 	bool "iwlwifi device access tracing"
-	depends on IWLAGN
+	depends on IWLWIFI
 	depends on EVENT_TRACING
 	help
 	  Say Y here to trace all commands, including TX frames and IO
@@ -104,7 +104,7 @@ endmenu
 
 config IWLWIFI_DEVICE_SVTOOL
 	bool "iwlwifi device svtool support"
-	depends on IWLAGN
+	depends on IWLWIFI
 	select NL80211_TESTMODE
 	help
 	  This option enables the svtool support for iwlwifi device through
diff --git a/drivers/net/wireless/iwlwifi/Makefile b/drivers/net/wireless/iwlwifi/Makefile
index 8fa59cd..bacafa4 100644
--- a/drivers/net/wireless/iwlwifi/Makefile
+++ b/drivers/net/wireless/iwlwifi/Makefile
@@ -1,25 +1,25 @@
-# AGN
-obj-$(CONFIG_IWLAGN)	+= iwlagn.o
-iwlagn-objs		:= iwl-agn.o iwl-agn-rs.o
-iwlagn-objs		+= iwl-agn-ucode.o iwl-agn-tx.o
-iwlagn-objs		+= iwl-agn-lib.o iwl-agn-calib.o iwl-io.o
-iwlagn-objs		+= iwl-agn-tt.o iwl-agn-sta.o
+# WIFI
+obj-$(CONFIG_IWLWIFI)	+= iwlwifi.o
+iwlwifi-objs		:= iwl-agn.o iwl-agn-rs.o
+iwlwifi-objs		+= iwl-agn-ucode.o iwl-agn-tx.o
+iwlwifi-objs		+= iwl-agn-lib.o iwl-agn-calib.o iwl-io.o
+iwlwifi-objs		+= iwl-agn-tt.o iwl-agn-sta.o
 
-iwlagn-objs		+= iwl-core.o iwl-eeprom.o iwl-power.o
-iwlagn-objs		+= iwl-rx.o iwl-sta.o
-iwlagn-objs		+= iwl-scan.o iwl-led.o
-iwlagn-objs		+= iwl-agn-rxon.o
-iwlagn-objs		+= iwl-5000.o
-iwlagn-objs		+= iwl-6000.o
-iwlagn-objs		+= iwl-1000.o
-iwlagn-objs		+= iwl-2000.o
-iwlagn-objs		+= iwl-pci.o
-iwlagn-objs		+= iwl-trans.o
-iwlagn-objs		+= iwl-trans-pcie.o iwl-trans-pcie-rx.o iwl-trans-pcie-tx.o
+iwlwifi-objs		+= iwl-core.o iwl-eeprom.o iwl-power.o
+iwlwifi-objs		+= iwl-rx.o iwl-sta.o
+iwlwifi-objs		+= iwl-scan.o iwl-led.o
+iwlwifi-objs		+= iwl-agn-rxon.o
+iwlwifi-objs		+= iwl-5000.o
+iwlwifi-objs		+= iwl-6000.o
+iwlwifi-objs		+= iwl-1000.o
+iwlwifi-objs		+= iwl-2000.o
+iwlwifi-objs		+= iwl-pci.o
+iwlwifi-objs		+= iwl-trans.o
+iwlwifi-objs		+= iwl-trans-pcie.o iwl-trans-pcie-rx.o iwl-trans-pcie-tx.o
 
-iwlagn-$(CONFIG_IWLWIFI_DEBUGFS) += iwl-debugfs.o
-iwlagn-$(CONFIG_IWLWIFI_DEVICE_TRACING) += iwl-devtrace.o
-iwlagn-$(CONFIG_IWLWIFI_DEVICE_SVTOOL) += iwl-sv-open.o
+iwlwifi-$(CONFIG_IWLWIFI_DEBUGFS) += iwl-debugfs.o
+iwlwifi-$(CONFIG_IWLWIFI_DEVICE_TRACING) += iwl-devtrace.o
+iwlwifi-$(CONFIG_IWLWIFI_DEVICE_SVTOOL) += iwl-sv-open.o
 
 CFLAGS_iwl-devtrace.o := -I$(src)
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index baaf486..d0fd6f0 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -79,6 +79,7 @@ MODULE_DESCRIPTION(DRV_DESCRIPTION);
 MODULE_VERSION(DRV_VERSION);
 MODULE_AUTHOR(DRV_COPYRIGHT " " DRV_AUTHOR);
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("iwlagn");
 
 void iwl_update_chain_flags(struct iwl_priv *priv)
 {
diff --git a/drivers/net/wireless/iwlwifi/iwl-shared.h b/drivers/net/wireless/iwlwifi/iwl-shared.h
index 8747bbd..3a24b47 100644
--- a/drivers/net/wireless/iwlwifi/iwl-shared.h
+++ b/drivers/net/wireless/iwlwifi/iwl-shared.h
@@ -100,7 +100,7 @@ struct iwl_priv;
 struct iwl_sensitivity_ranges;
 struct iwl_trans_ops;
 
-#define DRV_NAME        "iwlagn"
+#define DRV_NAME        "iwlwifi"
 #define IWLWIFI_VERSION "in-tree:"
 #define DRV_COPYRIGHT	"Copyright(c) 2003-2011 Intel Corporation"
 #define DRV_AUTHOR     "<ilw@linux.intel.com>"
-- 
1.7.0.4

