Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:33677 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754601Ab2FFNWX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jun 2012 09:22:23 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 10/29] iwlwifi: move PCIe into subdirectory
Date: Wed,  6 Jun 2012 15:21:51 +0200
Message-Id: <1338988930-11561-10-git-send-email-johannes@sipsolutions.net> (sfid-20120606_152243_190520_28EEA21E)
In-Reply-To: <1338988930-11561-1-git-send-email-johannes@sipsolutions.net>
References: <1338988930-11561-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Structure the code a bit more and move all PCIe code
including the hardware configuration files into a
PCIe specific subdirectory.

Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/Makefile                        |   10 +++-------
 drivers/net/wireless/iwlwifi/{iwl-1000.c => pcie/1000.c}     |    2 +-
 drivers/net/wireless/iwlwifi/{iwl-2000.c => pcie/2000.c}     |    2 +-
 drivers/net/wireless/iwlwifi/{iwl-5000.c => pcie/5000.c}     |    2 +-
 drivers/net/wireless/iwlwifi/{iwl-6000.c => pcie/6000.c}     |    2 +-
 drivers/net/wireless/iwlwifi/{iwl-cfg.h => pcie/cfg.h}       |    0
 drivers/net/wireless/iwlwifi/{iwl-pci.c => pcie/drv.c}       |    5 +++--
 .../iwlwifi/{iwl-trans-pcie-int.h => pcie/internal.h}        |    0
 .../net/wireless/iwlwifi/{iwl-trans-pcie-rx.c => pcie/rx.c}  |    2 +-
 .../net/wireless/iwlwifi/{iwl-trans-pcie.c => pcie/trans.c}  |    2 +-
 .../net/wireless/iwlwifi/{iwl-trans-pcie-tx.c => pcie/tx.c}  |    2 +-
 11 files changed, 13 insertions(+), 16 deletions(-)
 rename drivers/net/wireless/iwlwifi/{iwl-1000.c => pcie/1000.c} (99%)
 rename drivers/net/wireless/iwlwifi/{iwl-2000.c => pcie/2000.c} (99%)
 rename drivers/net/wireless/iwlwifi/{iwl-5000.c => pcie/5000.c} (99%)
 rename drivers/net/wireless/iwlwifi/{iwl-6000.c => pcie/6000.c} (99%)
 rename drivers/net/wireless/iwlwifi/{iwl-cfg.h => pcie/cfg.h} (100%)
 rename drivers/net/wireless/iwlwifi/{iwl-pci.c => pcie/drv.c} (99%)
 rename drivers/net/wireless/iwlwifi/{iwl-trans-pcie-int.h => pcie/internal.h} (100%)
 rename drivers/net/wireless/iwlwifi/{iwl-trans-pcie-rx.c => pcie/rx.c} (99%)
 rename drivers/net/wireless/iwlwifi/{iwl-trans-pcie.c => pcie/trans.c} (99%)
 rename drivers/net/wireless/iwlwifi/{iwl-trans-pcie-tx.c => pcie/tx.c} (99%)

diff --git a/drivers/net/wireless/iwlwifi/Makefile b/drivers/net/wireless/iwlwifi/Makefile
index 9310027..f155126 100644
--- a/drivers/net/wireless/iwlwifi/Makefile
+++ b/drivers/net/wireless/iwlwifi/Makefile
@@ -15,17 +15,13 @@ CFLAGS_iwl-devtrace.o := -I$(src)
 
 # WIFI
 obj-$(CONFIG_IWLWIFI)	+= iwlwifi.o
-iwlwifi-objs		+= iwl-5000.o
-iwlwifi-objs		+= iwl-6000.o
-iwlwifi-objs		+= iwl-1000.o
-iwlwifi-objs		+= iwl-2000.o
 iwlwifi-objs		+= iwl-io.o
-iwlwifi-objs		+= iwl-pci.o
 iwlwifi-objs		+= iwl-drv.o
 iwlwifi-objs		+= iwl-debug.o
 iwlwifi-objs		+= iwl-notif-wait.o
-iwlwifi-objs		+= iwl-trans-pcie.o iwl-trans-pcie-rx.o iwl-trans-pcie-tx.o
+iwlwifi-objs		+= pcie/drv.o pcie/rx.o pcie/tx.o pcie/trans.o
+iwlwifi-objs		+= pcie/1000.o pcie/2000.o pcie/5000.o pcie/6000.o
 
 iwlwifi-$(CONFIG_IWLWIFI_DEVICE_TRACING) += iwl-devtrace.o
 
-ccflags-y += -D__CHECK_ENDIAN__
+ccflags-y += -D__CHECK_ENDIAN__ -I$(src)
diff --git a/drivers/net/wireless/iwlwifi/iwl-1000.c b/drivers/net/wireless/iwlwifi/pcie/1000.c
similarity index 99%
rename from drivers/net/wireless/iwlwifi/iwl-1000.c
rename to drivers/net/wireless/iwlwifi/pcie/1000.c
index 2629a66..0cfbf9f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-1000.c
+++ b/drivers/net/wireless/iwlwifi/pcie/1000.c
@@ -27,9 +27,9 @@
 #include <linux/module.h>
 #include <linux/stringify.h>
 #include "iwl-config.h"
-#include "iwl-cfg.h"
 #include "iwl-csr.h"
 #include "iwl-agn-hw.h"
+#include "cfg.h"
 
 /* Highest firmware API version supported */
 #define IWL1000_UCODE_API_MAX 5
diff --git a/drivers/net/wireless/iwlwifi/iwl-2000.c b/drivers/net/wireless/iwlwifi/pcie/2000.c
similarity index 99%
rename from drivers/net/wireless/iwlwifi/iwl-2000.c
rename to drivers/net/wireless/iwlwifi/pcie/2000.c
index 8133105..f6efa12 100644
--- a/drivers/net/wireless/iwlwifi/iwl-2000.c
+++ b/drivers/net/wireless/iwlwifi/pcie/2000.c
@@ -27,8 +27,8 @@
 #include <linux/module.h>
 #include <linux/stringify.h>
 #include "iwl-config.h"
-#include "iwl-cfg.h"
 #include "iwl-agn-hw.h"
+#include "cfg.h"
 #include "iwl-commands.h" /* needed for BT for now */
 
 /* Highest firmware API version supported */
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/pcie/5000.c
similarity index 99%
rename from drivers/net/wireless/iwlwifi/iwl-5000.c
rename to drivers/net/wireless/iwlwifi/pcie/5000.c
index 8e26bc8..92e502e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/pcie/5000.c
@@ -27,9 +27,9 @@
 #include <linux/module.h>
 #include <linux/stringify.h>
 #include "iwl-config.h"
-#include "iwl-cfg.h"
 #include "iwl-agn-hw.h"
 #include "iwl-csr.h"
+#include "cfg.h"
 
 /* Highest firmware API version supported */
 #define IWL5000_UCODE_API_MAX 5
diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/pcie/6000.c
similarity index 99%
rename from drivers/net/wireless/iwlwifi/iwl-6000.c
rename to drivers/net/wireless/iwlwifi/pcie/6000.c
index 19f7ee8..7360cd9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/pcie/6000.c
@@ -27,8 +27,8 @@
 #include <linux/module.h>
 #include <linux/stringify.h>
 #include "iwl-config.h"
-#include "iwl-cfg.h"
 #include "iwl-agn-hw.h"
+#include "cfg.h"
 #include "iwl-commands.h" /* needed for BT for now */
 
 /* Highest firmware API version supported */
diff --git a/drivers/net/wireless/iwlwifi/iwl-cfg.h b/drivers/net/wireless/iwlwifi/pcie/cfg.h
similarity index 100%
rename from drivers/net/wireless/iwlwifi/iwl-cfg.h
rename to drivers/net/wireless/iwlwifi/pcie/cfg.h
diff --git a/drivers/net/wireless/iwlwifi/iwl-pci.c b/drivers/net/wireless/iwlwifi/pcie/drv.c
similarity index 99%
rename from drivers/net/wireless/iwlwifi/iwl-pci.c
rename to drivers/net/wireless/iwlwifi/pcie/drv.c
index 0c8a1c2..f4c3500 100644
--- a/drivers/net/wireless/iwlwifi/iwl-pci.c
+++ b/drivers/net/wireless/iwlwifi/pcie/drv.c
@@ -68,10 +68,11 @@
 #include <linux/pci-aspm.h>
 
 #include "iwl-trans.h"
-#include "iwl-cfg.h"
 #include "iwl-drv.h"
 #include "iwl-trans.h"
-#include "iwl-trans-pcie-int.h"
+
+#include "cfg.h"
+#include "internal.h"
 
 #define IWL_PCI_DEVICE(dev, subdev, cfg) \
 	.vendor = PCI_VENDOR_ID_INTEL,  .device = (dev), \
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h b/drivers/net/wireless/iwlwifi/pcie/internal.h
similarity index 100%
rename from drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h
rename to drivers/net/wireless/iwlwifi/pcie/internal.h
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c b/drivers/net/wireless/iwlwifi/pcie/rx.c
similarity index 99%
rename from drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c
rename to drivers/net/wireless/iwlwifi/pcie/rx.c
index 98605fc..d6860c0 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c
+++ b/drivers/net/wireless/iwlwifi/pcie/rx.c
@@ -32,7 +32,7 @@
 
 #include "iwl-prph.h"
 #include "iwl-io.h"
-#include "iwl-trans-pcie-int.h"
+#include "internal.h"
 #include "iwl-op-mode.h"
 
 #ifdef CONFIG_IWLWIFI_IDI
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c b/drivers/net/wireless/iwlwifi/pcie/trans.c
similarity index 99%
rename from drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
rename to drivers/net/wireless/iwlwifi/pcie/trans.c
index 1e50401..e8a04a1 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
+++ b/drivers/net/wireless/iwlwifi/pcie/trans.c
@@ -70,11 +70,11 @@
 
 #include "iwl-drv.h"
 #include "iwl-trans.h"
-#include "iwl-trans-pcie-int.h"
 #include "iwl-csr.h"
 #include "iwl-prph.h"
 #include "iwl-eeprom.h"
 #include "iwl-agn-hw.h"
+#include "internal.h"
 /* FIXME: need to abstract out TX command (once we know what it looks like) */
 #include "iwl-commands.h"
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c b/drivers/net/wireless/iwlwifi/pcie/tx.c
similarity index 99%
rename from drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c
rename to drivers/net/wireless/iwlwifi/pcie/tx.c
index 6f601cd..0b8bbb0 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c
+++ b/drivers/net/wireless/iwlwifi/pcie/tx.c
@@ -36,7 +36,7 @@
 #include "iwl-io.h"
 #include "iwl-agn-hw.h"
 #include "iwl-op-mode.h"
-#include "iwl-trans-pcie-int.h"
+#include "internal.h"
 /* FIXME: need to abstract out TX command (once we know what it looks like) */
 #include "iwl-commands.h"
 
-- 
1.7.10

