Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:58806 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755823Ab2DWVw4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Apr 2012 17:52:56 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 11/29] iwlwifi: clean up iwl-shared.h includes
Date: Mon, 23 Apr 2012 14:47:22 -0700
Message-Id: <1335217660-21950-12-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120423_235347_256328_58CCFCD5)
In-Reply-To: <1335217660-21950-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1335217660-21950-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

That file is now holding just a few defines and
the module parameters, so it shouldn't include
anything. Make sure the right users include the
right files instead.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.h           |    1 +
 drivers/net/wireless/iwlwifi/iwl-debug.c         |    1 +
 drivers/net/wireless/iwlwifi/iwl-debug.h         |    1 -
 drivers/net/wireless/iwlwifi/iwl-dev.h           |    1 +
 drivers/net/wireless/iwlwifi/iwl-drv.c           |    2 ++
 drivers/net/wireless/iwlwifi/iwl-eeprom.c        |    1 -
 drivers/net/wireless/iwlwifi/iwl-pci.c           |    1 +
 drivers/net/wireless/iwlwifi/iwl-shared.h        |    4 ----
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c |    2 ++
 drivers/net/wireless/iwlwifi/iwl-trans-pcie.c    |    3 +++
 drivers/net/wireless/iwlwifi/iwl-trans.h         |    9 ++-------
 11 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.h b/drivers/net/wireless/iwlwifi/iwl-agn.h
index 1db6bde..29d21c8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.h
@@ -64,6 +64,7 @@
 #define __iwl_agn_h__
 
 #include "iwl-dev.h"
+#include "iwl-config.h"
 
 /* The first 11 queues (0-10) are used otherwise */
 #define IWLAGN_FIRST_AMPDU_QUEUE	11
diff --git a/drivers/net/wireless/iwlwifi/iwl-debug.c b/drivers/net/wireless/iwlwifi/iwl-debug.c
index 059efab..2d1b428 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debug.c
+++ b/drivers/net/wireless/iwlwifi/iwl-debug.c
@@ -63,6 +63,7 @@
 
 #include <linux/interrupt.h>
 #include "iwl-debug.h"
+#include "iwl-devtrace.h"
 
 #define __iwl_fn(fn)						\
 void __iwl_ ##fn(struct device *dev, const char *fmt, ...)	\
diff --git a/drivers/net/wireless/iwlwifi/iwl-debug.h b/drivers/net/wireless/iwlwifi/iwl-debug.h
index a7f3f33..2dcbeba 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debug.h
+++ b/drivers/net/wireless/iwlwifi/iwl-debug.h
@@ -30,7 +30,6 @@
 #define __iwl_debug_h__
 
 #include "iwl-shared.h"
-#include "iwl-devtrace.h"
 
 
 static inline bool iwl_have_debug_level(u32 level)
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 9d58b23..a76be80 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -38,6 +38,7 @@
 #include <linux/slab.h>
 #include <linux/mutex.h>
 
+#include "iwl-fw.h"
 #include "iwl-eeprom.h"
 #include "iwl-csr.h"
 #include "iwl-debug.h"
diff --git a/drivers/net/wireless/iwlwifi/iwl-drv.c b/drivers/net/wireless/iwlwifi/iwl-drv.c
index e4cc5f5..28d81a7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-drv.c
+++ b/drivers/net/wireless/iwlwifi/iwl-drv.c
@@ -69,6 +69,8 @@
 #include "iwl-trans.h"
 #include "iwl-op-mode.h"
 #include "iwl-agn-hw.h"
+#include "iwl-fw.h"
+#include "iwl-config.h"
 
 /* private includes */
 #include "iwl-fw-file.h"
diff --git a/drivers/net/wireless/iwlwifi/iwl-eeprom.c b/drivers/net/wireless/iwlwifi/iwl-eeprom.c
index 84e2384..098d565 100644
--- a/drivers/net/wireless/iwlwifi/iwl-eeprom.c
+++ b/drivers/net/wireless/iwlwifi/iwl-eeprom.c
@@ -68,7 +68,6 @@
 
 #include <net/mac80211.h>
 
-#include "iwl-commands.h"
 #include "iwl-dev.h"
 #include "iwl-core.h"
 #include "iwl-debug.h"
diff --git a/drivers/net/wireless/iwlwifi/iwl-pci.c b/drivers/net/wireless/iwlwifi/iwl-pci.c
index 3b41b84..49d2b18 100644
--- a/drivers/net/wireless/iwlwifi/iwl-pci.c
+++ b/drivers/net/wireless/iwlwifi/iwl-pci.c
@@ -72,6 +72,7 @@
 #include "iwl-drv.h"
 #include "iwl-trans.h"
 #include "iwl-trans-pcie-int.h"
+#include "iwl-shared.h"
 
 #define IWL_PCI_DEVICE(dev, subdev, cfg) \
 	.vendor = PCI_VENDOR_ID_INTEL,  .device = (dev), \
diff --git a/drivers/net/wireless/iwlwifi/iwl-shared.h b/drivers/net/wireless/iwlwifi/iwl-shared.h
index e37dee4..079964b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-shared.h
+++ b/drivers/net/wireless/iwlwifi/iwl-shared.h
@@ -68,10 +68,6 @@
 #include <linux/gfp.h>
 #include <net/mac80211.h>
 
-#include "iwl-commands.h"
-#include "iwl-fw.h"
-#include "iwl-config.h"
-
 #define DRV_NAME        "iwlwifi"
 #define IWLWIFI_VERSION "in-tree:"
 #define DRV_COPYRIGHT	"Copyright(c) 2003-2012 Intel Corporation"
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c
index 1b2aed6..21a8a67 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c
@@ -37,6 +37,8 @@
 #include "iwl-agn-hw.h"
 #include "iwl-op-mode.h"
 #include "iwl-trans-pcie-int.h"
+/* FIXME: need to abstract out TX command (once we know what it looks like) */
+#include "iwl-commands.h"
 
 #define IWL_TX_CRC_SIZE 4
 #define IWL_TX_DELIMITER_SIZE 4
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
index e0c93cc..36616e3 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
@@ -69,11 +69,14 @@
 #include <linux/gfp.h>
 
 #include "iwl-trans.h"
+#include "iwl-shared.h"
 #include "iwl-trans-pcie-int.h"
 #include "iwl-csr.h"
 #include "iwl-prph.h"
 #include "iwl-eeprom.h"
 #include "iwl-agn-hw.h"
+/* FIXME: need to abstract out TX command (once we know what it looks like) */
+#include "iwl-commands.h"
 
 #define IWL_MASK(lo, hi) ((1 << (hi)) | ((1 << (hi)) - (1 << (lo))))
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.h b/drivers/net/wireless/iwlwifi/iwl-trans.h
index d7c3032..ba3c09d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.h
@@ -67,6 +67,8 @@
 #include <linux/mm.h> /* for page_address */
 
 #include "iwl-debug.h"
+#include "iwl-config.h"
+#include "iwl-fw.h"
 
 /**
  * DOC: Transport layer - what is it ?
@@ -103,13 +105,6 @@
  *	6) Eventually, the free function will be called.
  */
 
-struct iwl_priv;
-struct iwl_shared;
-struct iwl_op_mode;
-struct fw_img;
-struct sk_buff;
-struct dentry;
-
 /**
  * DOC: Host command section
  *
-- 
1.7.0.4

