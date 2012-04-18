Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:14459 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753550Ab2DROpv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Apr 2012 10:45:51 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 09/15] iwlwifi: remove unneeded includes
Date: Wed, 18 Apr 2012 07:41:11 -0700
Message-Id: <1334760077-5714-10-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120418_165903_964448_46D0F310)
In-Reply-To: <1334760077-5714-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1334760077-5714-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c        |    1 -
 drivers/net/wireless/iwlwifi/iwl-agn-rx.c         |    1 -
 drivers/net/wireless/iwlwifi/iwl-agn-rxon.c       |    1 -
 drivers/net/wireless/iwlwifi/iwl-agn.c            |    1 -
 drivers/net/wireless/iwlwifi/iwl-core.c           |    3 ---
 drivers/net/wireless/iwlwifi/iwl-drv.c            |    1 -
 drivers/net/wireless/iwlwifi/iwl-drv.h            |    3 +--
 drivers/net/wireless/iwlwifi/iwl-io.h             |    1 -
 drivers/net/wireless/iwlwifi/iwl-led.c            |    1 -
 drivers/net/wireless/iwlwifi/iwl-mac80211.c       |    1 -
 drivers/net/wireless/iwlwifi/iwl-pci.c            |    1 -
 drivers/net/wireless/iwlwifi/iwl-power.c          |    1 -
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h |    1 -
 drivers/net/wireless/iwlwifi/iwl-trans-pcie.c     |    1 -
 drivers/net/wireless/iwlwifi/iwl-trans.h          |    1 -
 15 files changed, 1 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index 86a6733..90b6ee8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -38,7 +38,6 @@
 #include "iwl-agn-hw.h"
 #include "iwl-agn.h"
 #include "iwl-trans.h"
-#include "iwl-shared.h"
 
 int iwlagn_hw_valid_rtc_data_addr(u32 addr)
 {
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rx.c b/drivers/net/wireless/iwlwifi/iwl-agn-rx.c
index 9f647bd..a6a6d8a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rx.c
@@ -38,7 +38,6 @@
 #include "iwl-io.h"
 #include "iwl-agn-calib.h"
 #include "iwl-agn.h"
-#include "iwl-shared.h"
 
 #define IWL_CMD_ENTRY(x) [x] = #x
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
index 00055a0..d950166 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
@@ -30,7 +30,6 @@
 #include "iwl-core.h"
 #include "iwl-agn-calib.h"
 #include "iwl-trans.h"
-#include "iwl-shared.h"
 
 /*
  * initialize rxon structure with default values from eeprom
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 948529f..07df432 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -50,7 +50,6 @@
 #include "iwl-io.h"
 #include "iwl-agn-calib.h"
 #include "iwl-agn.h"
-#include "iwl-shared.h"
 #include "iwl-trans.h"
 #include "iwl-op-mode.h"
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index d7a8cde..2a09678 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -37,12 +37,9 @@
 #include "iwl-core.h"
 #include "iwl-io.h"
 #include "iwl-power.h"
-#include "iwl-shared.h"
 #include "iwl-agn.h"
 #include "iwl-trans.h"
 
-
-
 #ifdef CONFIG_IWLWIFI_DEBUGFS
 
 #define IWL_TRAFFIC_DUMP_SIZE	(IWL_TRAFFIC_ENTRY_SIZE * IWL_TRAFFIC_ENTRIES)
diff --git a/drivers/net/wireless/iwlwifi/iwl-drv.c b/drivers/net/wireless/iwlwifi/iwl-drv.c
index 1219c0d..e4cc5f5 100644
--- a/drivers/net/wireless/iwlwifi/iwl-drv.c
+++ b/drivers/net/wireless/iwlwifi/iwl-drv.c
@@ -67,7 +67,6 @@
 
 #include "iwl-drv.h"
 #include "iwl-trans.h"
-#include "iwl-shared.h"
 #include "iwl-op-mode.h"
 #include "iwl-agn-hw.h"
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-drv.h b/drivers/net/wireless/iwlwifi/iwl-drv.h
index b673982..9ffcd1e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-drv.h
+++ b/drivers/net/wireless/iwlwifi/iwl-drv.h
@@ -63,8 +63,6 @@
 #ifndef __iwl_drv_h__
 #define __iwl_drv_h__
 
-#include "iwl-shared.h"
-
 /**
  * DOC: Driver system flows - drv component
  *
@@ -92,6 +90,7 @@
 
 struct iwl_drv;
 struct iwl_trans;
+struct iwl_cfg;
 /**
  * iwl_drv_start - start the drv
  *
diff --git a/drivers/net/wireless/iwlwifi/iwl-io.h b/drivers/net/wireless/iwlwifi/iwl-io.h
index 09b8567..abb3250 100644
--- a/drivers/net/wireless/iwlwifi/iwl-io.h
+++ b/drivers/net/wireless/iwlwifi/iwl-io.h
@@ -30,7 +30,6 @@
 #define __iwl_io_h__
 
 #include "iwl-devtrace.h"
-#include "iwl-shared.h"
 #include "iwl-trans.h"
 
 static inline void iwl_write8(struct iwl_trans *trans, u32 ofs, u8 val)
diff --git a/drivers/net/wireless/iwlwifi/iwl-led.c b/drivers/net/wireless/iwlwifi/iwl-led.c
index d57063e..7fbed47 100644
--- a/drivers/net/wireless/iwlwifi/iwl-led.c
+++ b/drivers/net/wireless/iwlwifi/iwl-led.c
@@ -40,7 +40,6 @@
 #include "iwl-agn.h"
 #include "iwl-io.h"
 #include "iwl-trans.h"
-#include "iwl-shared.h"
 
 /* Throughput		OFF time(ms)	ON time (ms)
  *	>300			25		25
diff --git a/drivers/net/wireless/iwlwifi/iwl-mac80211.c b/drivers/net/wireless/iwlwifi/iwl-mac80211.c
index 293110b..2d7453d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-mac80211.c
+++ b/drivers/net/wireless/iwlwifi/iwl-mac80211.c
@@ -48,7 +48,6 @@
 #include "iwl-io.h"
 #include "iwl-agn-calib.h"
 #include "iwl-agn.h"
-#include "iwl-shared.h"
 #include "iwl-trans.h"
 #include "iwl-op-mode.h"
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-pci.c b/drivers/net/wireless/iwlwifi/iwl-pci.c
index 47db96f..3b41b84 100644
--- a/drivers/net/wireless/iwlwifi/iwl-pci.c
+++ b/drivers/net/wireless/iwlwifi/iwl-pci.c
@@ -67,7 +67,6 @@
 #include <linux/pci.h>
 #include <linux/pci-aspm.h>
 
-#include "iwl-shared.h"
 #include "iwl-trans.h"
 #include "iwl-cfg.h"
 #include "iwl-drv.h"
diff --git a/drivers/net/wireless/iwlwifi/iwl-power.c b/drivers/net/wireless/iwlwifi/iwl-power.c
index 8456331..bc91cdd 100644
--- a/drivers/net/wireless/iwlwifi/iwl-power.c
+++ b/drivers/net/wireless/iwlwifi/iwl-power.c
@@ -43,7 +43,6 @@
 #include "iwl-debug.h"
 #include "iwl-power.h"
 #include "iwl-trans.h"
-#include "iwl-shared.h"
 
 /*
  * Setting power level allows the card to go to sleep when not busy.
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h
index 22e84f1..7caa875 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h
@@ -38,7 +38,6 @@
 
 #include "iwl-fh.h"
 #include "iwl-csr.h"
-#include "iwl-shared.h"
 #include "iwl-trans.h"
 #include "iwl-debug.h"
 #include "iwl-io.h"
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
index 72ee1e6..bc610f9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
@@ -72,7 +72,6 @@
 #include "iwl-trans-pcie-int.h"
 #include "iwl-csr.h"
 #include "iwl-prph.h"
-#include "iwl-shared.h"
 #include "iwl-eeprom.h"
 #include "iwl-agn-hw.h"
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.h b/drivers/net/wireless/iwlwifi/iwl-trans.h
index b28de2b..885c036 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.h
@@ -66,7 +66,6 @@
 #include <linux/ieee80211.h>
 #include <linux/mm.h> /* for page_address */
 
-#include "iwl-shared.h"
 #include "iwl-debug.h"
 
 /**
-- 
1.7.0.4

