Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:33680 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753934Ab2FFNXG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jun 2012 09:23:06 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 12/29] iwlwifi: move DVM code into subdirectory
Date: Wed,  6 Jun 2012 15:21:53 +0200
Message-Id: <1338988930-11561-12-git-send-email-johannes@sipsolutions.net> (sfid-20120606_152323_087247_F87BD194)
In-Reply-To: <1338988930-11561-1-git-send-email-johannes@sipsolutions.net>
References: <1338988930-11561-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Since we're working on another mode/driver
inside iwlwifi, move the current one into a
subdirectory to more cleanly separate the
code. While at it, rename all the files.

Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/Makefile               |   15 ++-------------
 drivers/net/wireless/iwlwifi/dvm/Makefile           |   13 +++++++++++++
 .../net/wireless/iwlwifi/{iwl-agn.h => dvm/agn.h}   |    3 ++-
 .../iwlwifi/{iwl-agn-calib.c => dvm/calib.c}        |    7 ++++---
 .../iwlwifi/{iwl-agn-calib.h => dvm/calib.h}        |    4 ++--
 .../iwlwifi/{iwl-commands.h => dvm/commands.h}      |    4 ++--
 .../iwlwifi/{iwl-debugfs.c => dvm/debugfs.c}        |    8 ++------
 .../net/wireless/iwlwifi/{iwl-dev.h => dvm/dev.h}   |   19 ++++++++++---------
 .../iwlwifi/{iwl-agn-devices.c => dvm/devices.c}    |    7 ++++---
 .../wireless/iwlwifi/{iwl-eeprom.c => dvm/eeprom.c} |   10 ++++------
 .../wireless/iwlwifi/{iwl-eeprom.h => dvm/eeprom.h} |    0
 .../net/wireless/iwlwifi/{iwl-led.c => dvm/led.c}   |    5 ++---
 .../net/wireless/iwlwifi/{iwl-led.h => dvm/led.h}   |    0
 .../wireless/iwlwifi/{iwl-agn-lib.c => dvm/lib.c}   |    5 +++--
 .../iwlwifi/{iwl-mac80211.c => dvm/mac80211.c}      |    9 +++++----
 .../net/wireless/iwlwifi/{iwl-agn.c => dvm/main.c}  |    9 +++++----
 .../wireless/iwlwifi/{iwl-power.c => dvm/power.c}   |   12 +++++-------
 .../wireless/iwlwifi/{iwl-power.h => dvm/power.h}   |    2 +-
 .../net/wireless/iwlwifi/{iwl-agn-rs.c => dvm/rs.c} |    6 ++----
 .../net/wireless/iwlwifi/{iwl-agn-rs.h => dvm/rs.h} |    3 ++-
 .../net/wireless/iwlwifi/{iwl-agn-rx.c => dvm/rx.c} |    9 ++++-----
 .../wireless/iwlwifi/{iwl-agn-rxon.c => dvm/rxon.c} |    6 +++---
 .../net/wireless/iwlwifi/{iwl-scan.c => dvm/scan.c} |    8 +++-----
 .../wireless/iwlwifi/{iwl-agn-sta.c => dvm/sta.c}   |    5 ++---
 .../iwlwifi/{iwl-testmode.c => dvm/testmode.c}      |   11 +++++------
 .../iwlwifi/{iwl-testmode.h => dvm/testmode.h}      |    0
 .../net/wireless/iwlwifi/{iwl-agn-tt.c => dvm/tt.c} |   14 ++++++--------
 .../net/wireless/iwlwifi/{iwl-agn-tt.h => dvm/tt.h} |    2 +-
 .../net/wireless/iwlwifi/{iwl-agn-tx.c => dvm/tx.c} |    7 +++----
 .../wireless/iwlwifi/{iwl-ucode.c => dvm/ucode.c}   |    7 ++++---
 drivers/net/wireless/iwlwifi/iwl-devtrace.h         |    1 +
 drivers/net/wireless/iwlwifi/pcie/2000.c            |    2 +-
 drivers/net/wireless/iwlwifi/pcie/6000.c            |    2 +-
 drivers/net/wireless/iwlwifi/pcie/trans.c           |    3 +--
 drivers/net/wireless/iwlwifi/pcie/tx.c              |    3 +--
 35 files changed, 106 insertions(+), 115 deletions(-)
 create mode 100644 drivers/net/wireless/iwlwifi/dvm/Makefile
 rename drivers/net/wireless/iwlwifi/{iwl-agn.h => dvm/agn.h} (99%)
 rename drivers/net/wireless/iwlwifi/{iwl-agn-calib.c => dvm/calib.c} (99%)
 rename drivers/net/wireless/iwlwifi/{iwl-agn-calib.h => dvm/calib.h} (98%)
 rename drivers/net/wireless/iwlwifi/{iwl-commands.h => dvm/commands.h} (99%)
 rename drivers/net/wireless/iwlwifi/{iwl-debugfs.c => dvm/debugfs.c} (99%)
 rename drivers/net/wireless/iwlwifi/{iwl-dev.h => dvm/dev.h} (98%)
 rename drivers/net/wireless/iwlwifi/{iwl-agn-devices.c => dvm/devices.c} (99%)
 rename drivers/net/wireless/iwlwifi/{iwl-eeprom.c => dvm/eeprom.c} (99%)
 rename drivers/net/wireless/iwlwifi/{iwl-eeprom.h => dvm/eeprom.h} (100%)
 rename drivers/net/wireless/iwlwifi/{iwl-led.c => dvm/led.c} (99%)
 rename drivers/net/wireless/iwlwifi/{iwl-led.h => dvm/led.h} (100%)
 rename drivers/net/wireless/iwlwifi/{iwl-agn-lib.c => dvm/lib.c} (99%)
 rename drivers/net/wireless/iwlwifi/{iwl-mac80211.c => dvm/mac80211.c} (99%)
 rename drivers/net/wireless/iwlwifi/{iwl-agn.c => dvm/main.c} (99%)
 rename drivers/net/wireless/iwlwifi/{iwl-power.c => dvm/power.c} (99%)
 rename drivers/net/wireless/iwlwifi/{iwl-power.h => dvm/power.h} (98%)
 rename drivers/net/wireless/iwlwifi/{iwl-agn-rs.c => dvm/rs.c} (99%)
 rename drivers/net/wireless/iwlwifi/{iwl-agn-rs.h => dvm/rs.h} (99%)
 rename drivers/net/wireless/iwlwifi/{iwl-agn-rx.c => dvm/rx.c} (99%)
 rename drivers/net/wireless/iwlwifi/{iwl-agn-rxon.c => dvm/rxon.c} (99%)
 rename drivers/net/wireless/iwlwifi/{iwl-scan.c => dvm/scan.c} (99%)
 rename drivers/net/wireless/iwlwifi/{iwl-agn-sta.c => dvm/sta.c} (99%)
 rename drivers/net/wireless/iwlwifi/{iwl-testmode.c => dvm/testmode.c} (99%)
 rename drivers/net/wireless/iwlwifi/{iwl-testmode.h => dvm/testmode.h} (100%)
 rename drivers/net/wireless/iwlwifi/{iwl-agn-tt.c => dvm/tt.c} (99%)
 rename drivers/net/wireless/iwlwifi/{iwl-agn-tt.h => dvm/tt.h} (99%)
 rename drivers/net/wireless/iwlwifi/{iwl-agn-tx.c => dvm/tx.c} (99%)
 rename drivers/net/wireless/iwlwifi/{iwl-ucode.c => dvm/ucode.c} (99%)

diff --git a/drivers/net/wireless/iwlwifi/Makefile b/drivers/net/wireless/iwlwifi/Makefile
index f155126..7ba6b8d 100644
--- a/drivers/net/wireless/iwlwifi/Makefile
+++ b/drivers/net/wireless/iwlwifi/Makefile
@@ -1,19 +1,8 @@
-# DVM
-obj-$(CONFIG_IWLDVM)   += iwldvm.o
-iwldvm-objs		:= iwl-agn.o iwl-agn-rs.o iwl-mac80211.o
-iwldvm-objs		+= iwl-ucode.o iwl-agn-tx.o
-iwldvm-objs		+= iwl-agn-lib.o iwl-agn-calib.o
-iwldvm-objs		+= iwl-agn-tt.o iwl-agn-sta.o iwl-agn-rx.o
-iwldvm-objs		+= iwl-eeprom.o iwl-power.o
-iwldvm-objs		+= iwl-scan.o iwl-led.o
-iwldvm-objs		+= iwl-agn-rxon.o iwl-agn-devices.o
-
-iwldvm-$(CONFIG_IWLWIFI_DEBUGFS) += iwl-debugfs.o
-iwldvm-$(CONFIG_IWLWIFI_DEVICE_TESTMODE) += iwl-testmode.o
+obj-$(CONFIG_IWLDVM)	+= dvm/
 
 CFLAGS_iwl-devtrace.o := -I$(src)
 
-# WIFI
+# common
 obj-$(CONFIG_IWLWIFI)	+= iwlwifi.o
 iwlwifi-objs		+= iwl-io.o
 iwlwifi-objs		+= iwl-drv.o
diff --git a/drivers/net/wireless/iwlwifi/dvm/Makefile b/drivers/net/wireless/iwlwifi/dvm/Makefile
new file mode 100644
index 0000000..13f8282
--- /dev/null
+++ b/drivers/net/wireless/iwlwifi/dvm/Makefile
@@ -0,0 +1,13 @@
+# DVM
+obj-$(CONFIG_IWLDVM)	+= iwldvm.o
+iwldvm-objs		+= main.o rs.o mac80211.o ucode.o tx.o
+iwldvm-objs		+= lib.o calib.o tt.o sta.o rx.o
+
+iwldvm-objs		+= eeprom.o power.o
+iwldvm-objs		+= scan.o led.o
+iwldvm-objs		+= rxon.o devices.o
+
+iwldvm-$(CONFIG_IWLWIFI_DEBUGFS) += debugfs.o
+iwldvm-$(CONFIG_IWLWIFI_DEVICE_TESTMODE) += testmode.o
+
+ccflags-y += -D__CHECK_ENDIAN__ -I$(src)/../
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.h b/drivers/net/wireless/iwlwifi/dvm/agn.h
similarity index 99%
rename from drivers/net/wireless/iwlwifi/iwl-agn.h
rename to drivers/net/wireless/iwlwifi/dvm/agn.h
index 3f3607f..9a8dd1a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.h
+++ b/drivers/net/wireless/iwlwifi/dvm/agn.h
@@ -63,9 +63,10 @@
 #ifndef __iwl_agn_h__
 #define __iwl_agn_h__
 
-#include "iwl-dev.h"
 #include "iwl-config.h"
 
+#include "dev.h"
+
 /* The first 11 queues (0-10) are used otherwise */
 #define IWLAGN_FIRST_AMPDU_QUEUE	11
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-calib.c b/drivers/net/wireless/iwlwifi/dvm/calib.c
similarity index 99%
rename from drivers/net/wireless/iwlwifi/iwl-agn-calib.c
rename to drivers/net/wireless/iwlwifi/dvm/calib.c
index 95f27f1..7eb3fa3 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-calib.c
+++ b/drivers/net/wireless/iwlwifi/dvm/calib.c
@@ -63,10 +63,11 @@
 #include <linux/slab.h>
 #include <net/mac80211.h>
 
-#include "iwl-dev.h"
-#include "iwl-agn-calib.h"
 #include "iwl-trans.h"
-#include "iwl-agn.h"
+
+#include "dev.h"
+#include "calib.h"
+#include "agn.h"
 
 /*****************************************************************************
  * INIT calibrations framework
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-calib.h b/drivers/net/wireless/iwlwifi/dvm/calib.h
similarity index 98%
rename from drivers/net/wireless/iwlwifi/iwl-agn-calib.h
rename to drivers/net/wireless/iwlwifi/dvm/calib.h
index dbe1378..2349f39 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-calib.h
+++ b/drivers/net/wireless/iwlwifi/dvm/calib.h
@@ -62,8 +62,8 @@
 #ifndef __iwl_calib_h__
 #define __iwl_calib_h__
 
-#include "iwl-dev.h"
-#include "iwl-commands.h"
+#include "dev.h"
+#include "commands.h"
 
 void iwl_chain_noise_calibration(struct iwl_priv *priv);
 void iwl_sensitivity_calibration(struct iwl_priv *priv);
diff --git a/drivers/net/wireless/iwlwifi/iwl-commands.h b/drivers/net/wireless/iwlwifi/dvm/commands.h
similarity index 99%
rename from drivers/net/wireless/iwlwifi/iwl-commands.h
rename to drivers/net/wireless/iwlwifi/dvm/commands.h
index b9f7361..64811cd 100644
--- a/drivers/net/wireless/iwlwifi/iwl-commands.h
+++ b/drivers/net/wireless/iwlwifi/dvm/commands.h
@@ -61,9 +61,9 @@
  *
  *****************************************************************************/
 /*
- * Please use this file (iwl-commands.h) only for uCode API definitions.
+ * Please use this file (commands.h) only for uCode API definitions.
  * Please use iwl-xxxx-hw.h for hardware-related definitions.
- * Please use iwl-dev.h for driver implementation definitions.
+ * Please use dev.h for driver implementation definitions.
  */
 
 #ifndef __iwl_commands_h__
diff --git a/drivers/net/wireless/iwlwifi/iwl-debugfs.c b/drivers/net/wireless/iwlwifi/dvm/debugfs.c
similarity index 99%
rename from drivers/net/wireless/iwlwifi/iwl-debugfs.c
rename to drivers/net/wireless/iwlwifi/dvm/debugfs.c
index e7c157e..2268add 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debugfs.c
+++ b/drivers/net/wireless/iwlwifi/dvm/debugfs.c
@@ -30,16 +30,12 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/debugfs.h>
-
 #include <linux/ieee80211.h>
 #include <net/mac80211.h>
-
-
-#include "iwl-dev.h"
 #include "iwl-debug.h"
 #include "iwl-io.h"
-#include "iwl-agn.h"
-#include "iwl-modparams.h"
+#include "dev.h"
+#include "agn.h"
 
 /* create and remove of files */
 #define DEBUGFS_ADD_FILE(name, parent, mode) do {			\
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/dvm/dev.h
similarity index 98%
rename from drivers/net/wireless/iwlwifi/iwl-dev.h
rename to drivers/net/wireless/iwlwifi/dvm/dev.h
index a4936a1..2880a0a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/dvm/dev.h
@@ -24,8 +24,8 @@
  *
  *****************************************************************************/
 /*
- * Please use this file (iwl-dev.h) for driver implementation definitions.
- * Please use iwl-commands.h for uCode API definitions.
+ * Please use this file (dev.h) for driver implementation definitions.
+ * Please use commands.h for uCode API definitions.
  */
 
 #ifndef __iwl_dev_h__
@@ -39,17 +39,18 @@
 #include <linux/mutex.h>
 
 #include "iwl-fw.h"
-#include "iwl-eeprom.h"
 #include "iwl-csr.h"
 #include "iwl-debug.h"
 #include "iwl-agn-hw.h"
-#include "iwl-led.h"
-#include "iwl-power.h"
-#include "iwl-agn-rs.h"
-#include "iwl-agn-tt.h"
-#include "iwl-trans.h"
 #include "iwl-op-mode.h"
 #include "iwl-notif-wait.h"
+#include "iwl-trans.h"
+
+#include "eeprom.h"
+#include "led.h"
+#include "power.h"
+#include "rs.h"
+#include "tt.h"
 
 /* CT-KILL constants */
 #define CT_KILL_THRESHOLD_LEGACY   110 /* in Celsius */
@@ -664,7 +665,7 @@ struct iwl_lib_ops {
 	/* device specific configuration */
 	void (*nic_config)(struct iwl_priv *priv);
 
-	/* eeprom operations (as defined in iwl-eeprom.h) */
+	/* eeprom operations (as defined in eeprom.h) */
 	struct iwl_eeprom_ops eeprom_ops;
 
 	/* temperature */
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-devices.c b/drivers/net/wireless/iwlwifi/dvm/devices.c
similarity index 99%
rename from drivers/net/wireless/iwlwifi/iwl-agn-devices.c
rename to drivers/net/wireless/iwlwifi/dvm/devices.c
index 529cdac..ac5675d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-devices.c
+++ b/drivers/net/wireless/iwlwifi/dvm/devices.c
@@ -27,12 +27,13 @@
 /*
  * DVM device-specific data & functions
  */
-#include "iwl-agn.h"
-#include "iwl-dev.h"
-#include "iwl-commands.h"
 #include "iwl-io.h"
 #include "iwl-prph.h"
 
+#include "agn.h"
+#include "dev.h"
+#include "commands.h"
+
 /*
  * 1000 series
  * ===========
diff --git a/drivers/net/wireless/iwlwifi/iwl-eeprom.c b/drivers/net/wireless/iwlwifi/dvm/eeprom.c
similarity index 99%
rename from drivers/net/wireless/iwlwifi/iwl-eeprom.c
rename to drivers/net/wireless/iwlwifi/dvm/eeprom.c
index 50c5891..69d280f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-eeprom.c
+++ b/drivers/net/wireless/iwlwifi/dvm/eeprom.c
@@ -65,15 +65,13 @@
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/init.h>
-
 #include <net/mac80211.h>
-
-#include "iwl-dev.h"
-#include "iwl-debug.h"
-#include "iwl-agn.h"
-#include "iwl-eeprom.h"
 #include "iwl-io.h"
 #include "iwl-prph.h"
+#include "iwl-debug.h"
+#include "dev.h"
+#include "agn.h"
+#include "eeprom.h"
 
 /************************** EEPROM BANDS ****************************
  *
diff --git a/drivers/net/wireless/iwlwifi/iwl-eeprom.h b/drivers/net/wireless/iwlwifi/dvm/eeprom.h
similarity index 100%
rename from drivers/net/wireless/iwlwifi/iwl-eeprom.h
rename to drivers/net/wireless/iwlwifi/dvm/eeprom.h
diff --git a/drivers/net/wireless/iwlwifi/iwl-led.c b/drivers/net/wireless/iwlwifi/dvm/led.c
similarity index 99%
rename from drivers/net/wireless/iwlwifi/iwl-led.c
rename to drivers/net/wireless/iwlwifi/dvm/led.c
index 4700041..bf479f7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-led.c
+++ b/drivers/net/wireless/iwlwifi/dvm/led.c
@@ -34,12 +34,11 @@
 #include <net/mac80211.h>
 #include <linux/etherdevice.h>
 #include <asm/unaligned.h>
-
-#include "iwl-dev.h"
-#include "iwl-agn.h"
 #include "iwl-io.h"
 #include "iwl-trans.h"
 #include "iwl-modparams.h"
+#include "dev.h"
+#include "agn.h"
 
 /* Throughput		OFF time(ms)	ON time (ms)
  *	>300			25		25
diff --git a/drivers/net/wireless/iwlwifi/iwl-led.h b/drivers/net/wireless/iwlwifi/dvm/led.h
similarity index 100%
rename from drivers/net/wireless/iwlwifi/iwl-led.h
rename to drivers/net/wireless/iwlwifi/dvm/led.h
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/dvm/lib.c
similarity index 99%
rename from drivers/net/wireless/iwlwifi/iwl-agn-lib.c
rename to drivers/net/wireless/iwlwifi/dvm/lib.c
index c31072d..4ac9af7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/dvm/lib.c
@@ -33,13 +33,14 @@
 #include <linux/sched.h>
 #include <net/mac80211.h>
 
-#include "iwl-dev.h"
 #include "iwl-io.h"
 #include "iwl-agn-hw.h"
-#include "iwl-agn.h"
 #include "iwl-trans.h"
 #include "iwl-modparams.h"
 
+#include "dev.h"
+#include "agn.h"
+
 int iwlagn_hw_valid_rtc_data_addr(u32 addr)
 {
 	return (addr >= IWLAGN_RTC_DATA_LOWER_BOUND) &&
diff --git a/drivers/net/wireless/iwlwifi/iwl-mac80211.c b/drivers/net/wireless/iwlwifi/dvm/mac80211.c
similarity index 99%
rename from drivers/net/wireless/iwlwifi/iwl-mac80211.c
rename to drivers/net/wireless/iwlwifi/dvm/mac80211.c
index 26a87c2..33603c5 100644
--- a/drivers/net/wireless/iwlwifi/iwl-mac80211.c
+++ b/drivers/net/wireless/iwlwifi/dvm/mac80211.c
@@ -43,15 +43,16 @@
 
 #include <asm/div64.h>
 
-#include "iwl-eeprom.h"
-#include "iwl-dev.h"
 #include "iwl-io.h"
-#include "iwl-agn-calib.h"
-#include "iwl-agn.h"
 #include "iwl-trans.h"
 #include "iwl-op-mode.h"
 #include "iwl-modparams.h"
 
+#include "eeprom.h"
+#include "dev.h"
+#include "calib.h"
+#include "agn.h"
+
 /*****************************************************************************
  *
  * mac80211 entry point functions
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/dvm/main.c
similarity index 99%
rename from drivers/net/wireless/iwlwifi/iwl-agn.c
rename to drivers/net/wireless/iwlwifi/dvm/main.c
index fa00717..d67ae99 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/dvm/main.c
@@ -44,16 +44,17 @@
 
 #include <asm/div64.h>
 
-#include "iwl-eeprom.h"
-#include "iwl-dev.h"
 #include "iwl-io.h"
-#include "iwl-agn-calib.h"
-#include "iwl-agn.h"
 #include "iwl-trans.h"
 #include "iwl-op-mode.h"
 #include "iwl-drv.h"
 #include "iwl-modparams.h"
 
+#include "eeprom.h"
+#include "dev.h"
+#include "calib.h"
+#include "agn.h"
+
 /******************************************************************************
  *
  * module boiler plate
diff --git a/drivers/net/wireless/iwlwifi/iwl-power.c b/drivers/net/wireless/iwlwifi/dvm/power.c
similarity index 99%
rename from drivers/net/wireless/iwlwifi/iwl-power.c
rename to drivers/net/wireless/iwlwifi/dvm/power.c
index 544ddf1..72c9407 100644
--- a/drivers/net/wireless/iwlwifi/iwl-power.c
+++ b/drivers/net/wireless/iwlwifi/dvm/power.c
@@ -31,18 +31,16 @@
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/init.h>
-
 #include <net/mac80211.h>
-
-#include "iwl-eeprom.h"
-#include "iwl-dev.h"
-#include "iwl-agn.h"
 #include "iwl-io.h"
-#include "iwl-commands.h"
 #include "iwl-debug.h"
-#include "iwl-power.h"
 #include "iwl-trans.h"
 #include "iwl-modparams.h"
+#include "eeprom.h"
+#include "dev.h"
+#include "agn.h"
+#include "commands.h"
+#include "power.h"
 
 /*
  * Setting power level allows the card to go to sleep when not busy.
diff --git a/drivers/net/wireless/iwlwifi/iwl-power.h b/drivers/net/wireless/iwlwifi/dvm/power.h
similarity index 98%
rename from drivers/net/wireless/iwlwifi/iwl-power.h
rename to drivers/net/wireless/iwlwifi/dvm/power.h
index 21afc92..a2cee7f0 100644
--- a/drivers/net/wireless/iwlwifi/iwl-power.h
+++ b/drivers/net/wireless/iwlwifi/dvm/power.h
@@ -28,7 +28,7 @@
 #ifndef __iwl_power_setting_h__
 #define __iwl_power_setting_h__
 
-#include "iwl-commands.h"
+#include "commands.h"
 
 struct iwl_power_mgr {
 	struct iwl_powertable_cmd sleep_cmd;
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c b/drivers/net/wireless/iwlwifi/dvm/rs.c
similarity index 99%
rename from drivers/net/wireless/iwlwifi/iwl-agn-rs.c
rename to drivers/net/wireless/iwlwifi/dvm/rs.c
index 8cebd7c..af10291 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
+++ b/drivers/net/wireless/iwlwifi/dvm/rs.c
@@ -35,10 +35,8 @@
 
 #include <linux/workqueue.h>
 
-#include "iwl-dev.h"
-#include "iwl-agn.h"
-#include "iwl-op-mode.h"
-#include "iwl-modparams.h"
+#include "dev.h"
+#include "agn.h"
 
 #define RS_NAME "iwl-agn-rs"
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rs.h b/drivers/net/wireless/iwlwifi/dvm/rs.h
similarity index 99%
rename from drivers/net/wireless/iwlwifi/iwl-agn-rs.h
rename to drivers/net/wireless/iwlwifi/dvm/rs.h
index 82d02e1..ad3aea8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rs.h
+++ b/drivers/net/wireless/iwlwifi/dvm/rs.h
@@ -29,9 +29,10 @@
 
 #include <net/mac80211.h>
 
-#include "iwl-commands.h"
 #include "iwl-config.h"
 
+#include "commands.h"
+
 struct iwl_rate_info {
 	u8 plcp;	/* uCode API:  IWL_RATE_6M_PLCP, etc. */
 	u8 plcp_siso;	/* uCode API:  IWL_RATE_SISO_6M_PLCP, etc. */
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rx.c b/drivers/net/wireless/iwlwifi/dvm/rx.c
similarity index 99%
rename from drivers/net/wireless/iwlwifi/iwl-agn-rx.c
rename to drivers/net/wireless/iwlwifi/dvm/rx.c
index 5035d2d..d619802 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rx.c
+++ b/drivers/net/wireless/iwlwifi/dvm/rx.c
@@ -32,12 +32,11 @@
 #include <linux/sched.h>
 #include <net/mac80211.h>
 #include <asm/unaligned.h>
-#include "iwl-eeprom.h"
-#include "iwl-dev.h"
 #include "iwl-io.h"
-#include "iwl-agn-calib.h"
-#include "iwl-agn.h"
-#include "iwl-modparams.h"
+#include "eeprom.h"
+#include "dev.h"
+#include "calib.h"
+#include "agn.h"
 
 #define IWL_CMD_ENTRY(x) [x] = #x
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c b/drivers/net/wireless/iwlwifi/dvm/rxon.c
similarity index 99%
rename from drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
rename to drivers/net/wireless/iwlwifi/dvm/rxon.c
index 36b4965..4f55689 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
+++ b/drivers/net/wireless/iwlwifi/dvm/rxon.c
@@ -25,11 +25,11 @@
  *****************************************************************************/
 
 #include <linux/etherdevice.h>
-#include "iwl-dev.h"
-#include "iwl-agn.h"
-#include "iwl-agn-calib.h"
 #include "iwl-trans.h"
 #include "iwl-modparams.h"
+#include "dev.h"
+#include "agn.h"
+#include "calib.h"
 
 /*
  * initialize rxon structure with default values from eeprom
diff --git a/drivers/net/wireless/iwlwifi/iwl-scan.c b/drivers/net/wireless/iwlwifi/dvm/scan.c
similarity index 99%
rename from drivers/net/wireless/iwlwifi/iwl-scan.c
rename to drivers/net/wireless/iwlwifi/dvm/scan.c
index a32b35e..7ee7f32 100644
--- a/drivers/net/wireless/iwlwifi/iwl-scan.c
+++ b/drivers/net/wireless/iwlwifi/dvm/scan.c
@@ -30,11 +30,9 @@
 #include <linux/etherdevice.h>
 #include <net/mac80211.h>
 
-#include "iwl-eeprom.h"
-#include "iwl-dev.h"
-#include "iwl-io.h"
-#include "iwl-agn.h"
-#include "iwl-trans.h"
+#include "eeprom.h"
+#include "dev.h"
+#include "agn.h"
 
 /* For active scan, listen ACTIVE_DWELL_TIME (msec) on each channel after
  * sending probe req.  This should be set long enough to hear probe responses
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-sta.c b/drivers/net/wireless/iwlwifi/dvm/sta.c
similarity index 99%
rename from drivers/net/wireless/iwlwifi/iwl-agn-sta.c
rename to drivers/net/wireless/iwlwifi/dvm/sta.c
index 01fbf06..c6b343f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-sta.c
+++ b/drivers/net/wireless/iwlwifi/dvm/sta.c
@@ -28,10 +28,9 @@
  *****************************************************************************/
 #include <linux/etherdevice.h>
 #include <net/mac80211.h>
-
-#include "iwl-dev.h"
-#include "iwl-agn.h"
 #include "iwl-trans.h"
+#include "dev.h"
+#include "agn.h"
 
 const u8 iwl_bcast_addr[ETH_ALEN] = { 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF };
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-testmode.c b/drivers/net/wireless/iwlwifi/dvm/testmode.c
similarity index 99%
rename from drivers/net/wireless/iwlwifi/iwl-testmode.c
rename to drivers/net/wireless/iwlwifi/dvm/testmode.c
index 060aac3..59cfe9a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-testmode.c
+++ b/drivers/net/wireless/iwlwifi/dvm/testmode.c
@@ -69,15 +69,14 @@
 #include <net/cfg80211.h>
 #include <net/mac80211.h>
 #include <net/netlink.h>
-
-#include "iwl-dev.h"
 #include "iwl-debug.h"
 #include "iwl-io.h"
-#include "iwl-agn.h"
-#include "iwl-testmode.h"
 #include "iwl-trans.h"
 #include "iwl-fh.h"
 #include "iwl-prph.h"
+#include "dev.h"
+#include "agn.h"
+#include "testmode.h"
 
 
 /* Periphery registers absolute lower bound. This is used in order to
@@ -89,7 +88,7 @@
 /* The TLVs used in the gnl message policy between the kernel module and
  * user space application. iwl_testmode_gnl_msg_policy is to be carried
  * through the NL80211_CMD_TESTMODE channel regulated by nl80211.
- * See iwl-testmode.h
+ * See testmode.h
  */
 static
 struct nla_policy iwl_testmode_gnl_msg_policy[IWL_TM_ATTR_MAX] = {
@@ -129,7 +128,7 @@ struct nla_policy iwl_testmode_gnl_msg_policy[IWL_TM_ATTR_MAX] = {
 };
 
 /*
- * See the struct iwl_rx_packet in iwl-commands.h for the format of the
+ * See the struct iwl_rx_packet in commands.h for the format of the
  * received events from the device
  */
 static inline int get_event_length(struct iwl_rx_cmd_buffer *rxb)
diff --git a/drivers/net/wireless/iwlwifi/iwl-testmode.h b/drivers/net/wireless/iwlwifi/dvm/testmode.h
similarity index 100%
rename from drivers/net/wireless/iwlwifi/iwl-testmode.h
rename to drivers/net/wireless/iwlwifi/dvm/testmode.h
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-tt.c b/drivers/net/wireless/iwlwifi/dvm/tt.c
similarity index 99%
rename from drivers/net/wireless/iwlwifi/iwl-agn-tt.c
rename to drivers/net/wireless/iwlwifi/dvm/tt.c
index a5cfe0a..5541889 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-tt.c
+++ b/drivers/net/wireless/iwlwifi/dvm/tt.c
@@ -31,17 +31,15 @@
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/init.h>
-
 #include <net/mac80211.h>
-
-#include "iwl-agn.h"
-#include "iwl-eeprom.h"
-#include "iwl-dev.h"
 #include "iwl-io.h"
-#include "iwl-commands.h"
-#include "iwl-debug.h"
-#include "iwl-agn-tt.h"
 #include "iwl-modparams.h"
+#include "iwl-debug.h"
+#include "agn.h"
+#include "eeprom.h"
+#include "dev.h"
+#include "commands.h"
+#include "tt.h"
 
 /* default Thermal Throttling transaction table
  * Current state   |         Throttling Down               |  Throttling Up
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-tt.h b/drivers/net/wireless/iwlwifi/dvm/tt.h
similarity index 99%
rename from drivers/net/wireless/iwlwifi/iwl-agn-tt.h
rename to drivers/net/wireless/iwlwifi/dvm/tt.h
index 86bbf47..44c7c8f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-tt.h
+++ b/drivers/net/wireless/iwlwifi/dvm/tt.h
@@ -28,7 +28,7 @@
 #ifndef __iwl_tt_setting_h__
 #define __iwl_tt_setting_h__
 
-#include "iwl-commands.h"
+#include "commands.h"
 
 #define IWL_ABSOLUTE_ZERO		0
 #define IWL_ABSOLUTE_MAX		0xFFFFFFFF
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c b/drivers/net/wireless/iwlwifi/dvm/tx.c
similarity index 99%
rename from drivers/net/wireless/iwlwifi/iwl-agn-tx.c
rename to drivers/net/wireless/iwlwifi/dvm/tx.c
index ad1d36f..52f2cae 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
+++ b/drivers/net/wireless/iwlwifi/dvm/tx.c
@@ -32,12 +32,11 @@
 #include <linux/init.h>
 #include <linux/sched.h>
 #include <linux/ieee80211.h>
-
-#include "iwl-dev.h"
 #include "iwl-io.h"
-#include "iwl-agn-hw.h"
-#include "iwl-agn.h"
 #include "iwl-trans.h"
+#include "iwl-agn-hw.h"
+#include "dev.h"
+#include "agn.h"
 
 static const u8 tid_to_ac[] = {
 	IEEE80211_AC_BE,
diff --git a/drivers/net/wireless/iwlwifi/iwl-ucode.c b/drivers/net/wireless/iwlwifi/dvm/ucode.c
similarity index 99%
rename from drivers/net/wireless/iwlwifi/iwl-ucode.c
rename to drivers/net/wireless/iwlwifi/dvm/ucode.c
index d14e633..5a2e186 100644
--- a/drivers/net/wireless/iwlwifi/iwl-ucode.c
+++ b/drivers/net/wireless/iwlwifi/dvm/ucode.c
@@ -30,15 +30,16 @@
 #include <linux/kernel.h>
 #include <linux/init.h>
 
-#include "iwl-dev.h"
 #include "iwl-io.h"
 #include "iwl-agn-hw.h"
-#include "iwl-agn.h"
-#include "iwl-agn-calib.h"
 #include "iwl-trans.h"
 #include "iwl-fh.h"
 #include "iwl-op-mode.h"
 
+#include "dev.h"
+#include "agn.h"
+#include "calib.h"
+
 /******************************************************************************
  *
  * uCode download functions
diff --git a/drivers/net/wireless/iwlwifi/iwl-devtrace.h b/drivers/net/wireless/iwlwifi/iwl-devtrace.h
index 06203d6..6536479 100644
--- a/drivers/net/wireless/iwlwifi/iwl-devtrace.h
+++ b/drivers/net/wireless/iwlwifi/iwl-devtrace.h
@@ -28,6 +28,7 @@
 #define __IWLWIFI_DEVICE_TRACE
 
 #include <linux/tracepoint.h>
+#include <linux/device.h>
 
 
 #if !defined(CONFIG_IWLWIFI_DEVICE_TRACING) || defined(__CHECKER__)
diff --git a/drivers/net/wireless/iwlwifi/pcie/2000.c b/drivers/net/wireless/iwlwifi/pcie/2000.c
index f6efa12..062c07b 100644
--- a/drivers/net/wireless/iwlwifi/pcie/2000.c
+++ b/drivers/net/wireless/iwlwifi/pcie/2000.c
@@ -29,7 +29,7 @@
 #include "iwl-config.h"
 #include "iwl-agn-hw.h"
 #include "cfg.h"
-#include "iwl-commands.h" /* needed for BT for now */
+#include "dvm/commands.h" /* needed for BT for now */
 
 /* Highest firmware API version supported */
 #define IWL2030_UCODE_API_MAX 6
diff --git a/drivers/net/wireless/iwlwifi/pcie/6000.c b/drivers/net/wireless/iwlwifi/pcie/6000.c
index 7360cd9..f9e3961 100644
--- a/drivers/net/wireless/iwlwifi/pcie/6000.c
+++ b/drivers/net/wireless/iwlwifi/pcie/6000.c
@@ -29,7 +29,7 @@
 #include "iwl-config.h"
 #include "iwl-agn-hw.h"
 #include "cfg.h"
-#include "iwl-commands.h" /* needed for BT for now */
+#include "dvm/commands.h" /* needed for BT for now */
 
 /* Highest firmware API version supported */
 #define IWL6000_UCODE_API_MAX 6
diff --git a/drivers/net/wireless/iwlwifi/pcie/trans.c b/drivers/net/wireless/iwlwifi/pcie/trans.c
index e8a04a1..a19ce40 100644
--- a/drivers/net/wireless/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/iwlwifi/pcie/trans.c
@@ -72,11 +72,10 @@
 #include "iwl-trans.h"
 #include "iwl-csr.h"
 #include "iwl-prph.h"
-#include "iwl-eeprom.h"
 #include "iwl-agn-hw.h"
 #include "internal.h"
 /* FIXME: need to abstract out TX command (once we know what it looks like) */
-#include "iwl-commands.h"
+#include "dvm/commands.h"
 
 #define SCD_QUEUECHAIN_SEL_ALL(trans, trans_pcie)	\
 	(((1<<trans->cfg->base_params->num_of_queues) - 1) &\
diff --git a/drivers/net/wireless/iwlwifi/pcie/tx.c b/drivers/net/wireless/iwlwifi/pcie/tx.c
index 0b8bbb0..583451c 100644
--- a/drivers/net/wireless/iwlwifi/pcie/tx.c
+++ b/drivers/net/wireless/iwlwifi/pcie/tx.c
@@ -34,11 +34,10 @@
 #include "iwl-csr.h"
 #include "iwl-prph.h"
 #include "iwl-io.h"
-#include "iwl-agn-hw.h"
 #include "iwl-op-mode.h"
 #include "internal.h"
 /* FIXME: need to abstract out TX command (once we know what it looks like) */
-#include "iwl-commands.h"
+#include "dvm/commands.h"
 
 #define IWL_TX_CRC_SIZE 4
 #define IWL_TX_DELIMITER_SIZE 4
-- 
1.7.10

