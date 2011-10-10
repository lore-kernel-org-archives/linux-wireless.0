Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:50123 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751403Ab1JJPQb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Oct 2011 11:16:31 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 32/34] iwlagn: move iwl_enable_rfkill_int and kill iwl-helpers.h
Date: Mon, 10 Oct 2011 07:27:17 -0700
Message-Id: <1318256839-31837-33-git-send-email-wey-yi.w.guy@intel.com> (sfid-20111010_171635_725376_697321D4)
In-Reply-To: <1318256839-31837-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1318256839-31837-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Move iwl_enable_rfkill_int to iwl-core.h, and remove the empty
iwl-helpers.h

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-1000.c          |    1 -
 drivers/net/wireless/iwlwifi/iwl-2000.c          |    1 -
 drivers/net/wireless/iwlwifi/iwl-5000.c          |    1 -
 drivers/net/wireless/iwlwifi/iwl-6000.c          |    1 -
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c       |    1 -
 drivers/net/wireless/iwlwifi/iwl-agn-rx.c        |    3 +-
 drivers/net/wireless/iwlwifi/iwl-agn-rxon.c      |    1 -
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c        |    1 -
 drivers/net/wireless/iwlwifi/iwl-agn-ucode.c     |    1 -
 drivers/net/wireless/iwlwifi/iwl-agn.c           |    1 -
 drivers/net/wireless/iwlwifi/iwl-core.c          |    1 -
 drivers/net/wireless/iwlwifi/iwl-core.h          |    7 +++
 drivers/net/wireless/iwlwifi/iwl-helpers.h       |   44 ----------------------
 drivers/net/wireless/iwlwifi/iwl-scan.c          |    1 -
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c |    1 -
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c |    1 -
 16 files changed, 8 insertions(+), 59 deletions(-)
 delete mode 100644 drivers/net/wireless/iwlwifi/iwl-helpers.h

diff --git a/drivers/net/wireless/iwlwifi/iwl-1000.c b/drivers/net/wireless/iwlwifi/iwl-1000.c
index 0bf6afd..e12b48c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-1000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-1000.c
@@ -40,7 +40,6 @@
 #include "iwl-core.h"
 #include "iwl-io.h"
 #include "iwl-agn.h"
-#include "iwl-helpers.h"
 #include "iwl-agn-hw.h"
 #include "iwl-shared.h"
 #include "iwl-cfg.h"
diff --git a/drivers/net/wireless/iwlwifi/iwl-2000.c b/drivers/net/wireless/iwlwifi/iwl-2000.c
index f14eb0b..7943197 100644
--- a/drivers/net/wireless/iwlwifi/iwl-2000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-2000.c
@@ -40,7 +40,6 @@
 #include "iwl-core.h"
 #include "iwl-io.h"
 #include "iwl-agn.h"
-#include "iwl-helpers.h"
 #include "iwl-agn-hw.h"
 #include "iwl-shared.h"
 #include "iwl-cfg.h"
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index fdbf031..c511c98 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -40,7 +40,6 @@
 #include "iwl-dev.h"
 #include "iwl-core.h"
 #include "iwl-io.h"
-#include "iwl-helpers.h"
 #include "iwl-agn.h"
 #include "iwl-agn-hw.h"
 #include "iwl-trans.h"
diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index f05f2b8..c840c78 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -40,7 +40,6 @@
 #include "iwl-core.h"
 #include "iwl-io.h"
 #include "iwl-agn.h"
-#include "iwl-helpers.h"
 #include "iwl-agn-hw.h"
 #include "iwl-trans.h"
 #include "iwl-shared.h"
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index b1746f9..1a52ed2 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -35,7 +35,6 @@
 #include "iwl-dev.h"
 #include "iwl-core.h"
 #include "iwl-io.h"
-#include "iwl-helpers.h"
 #include "iwl-agn-hw.h"
 #include "iwl-agn.h"
 #include "iwl-trans.h"
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rx.c b/drivers/net/wireless/iwlwifi/iwl-agn-rx.c
index daa3c60..5af9e62 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rx.c
@@ -3,7 +3,7 @@
  * Copyright(c) 2003 - 2011 Intel Corporation. All rights reserved.
  *
  * Portions of this file are derived from the ipw3945 project, as well
- * as portions of the ieee80211 subsystem header files.
+ * as portionhelp of the ieee80211 subsystem header files.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of version 2 of the GNU General Public License as
@@ -36,7 +36,6 @@
 #include "iwl-dev.h"
 #include "iwl-core.h"
 #include "iwl-io.h"
-#include "iwl-helpers.h"
 #include "iwl-agn-calib.h"
 #include "iwl-agn.h"
 #include "iwl-shared.h"
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
index 68bdc19..a580efe 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
@@ -28,7 +28,6 @@
 #include "iwl-agn.h"
 #include "iwl-core.h"
 #include "iwl-agn-calib.h"
-#include "iwl-helpers.h"
 #include "iwl-trans.h"
 #include "iwl-shared.h"
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
index d7e48f2..35a6b71 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
@@ -36,7 +36,6 @@
 #include "iwl-dev.h"
 #include "iwl-core.h"
 #include "iwl-io.h"
-#include "iwl-helpers.h"
 #include "iwl-agn-hw.h"
 #include "iwl-agn.h"
 #include "iwl-trans.h"
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c b/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c
index b4e1e7c..8ba0dd5 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c
@@ -35,7 +35,6 @@
 #include "iwl-dev.h"
 #include "iwl-core.h"
 #include "iwl-io.h"
-#include "iwl-helpers.h"
 #include "iwl-agn-hw.h"
 #include "iwl-agn.h"
 #include "iwl-agn-calib.h"
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 5a78480..ccba69b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -47,7 +47,6 @@
 #include "iwl-dev.h"
 #include "iwl-core.h"
 #include "iwl-io.h"
-#include "iwl-helpers.h"
 #include "iwl-agn-calib.h"
 #include "iwl-agn.h"
 #include "iwl-shared.h"
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 6ecdf82..abd0de4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -40,7 +40,6 @@
 #include "iwl-io.h"
 #include "iwl-power.h"
 #include "iwl-agn.h"
-#include "iwl-helpers.h"
 #include "iwl-shared.h"
 #include "iwl-agn.h"
 #include "iwl-trans.h"
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 151cc43..137da33 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -64,6 +64,7 @@
 #define __iwl_core_h__
 
 #include "iwl-dev.h"
+#include "iwl-io.h"
 
 /************************
  * forward declarations *
@@ -382,6 +383,12 @@ static inline bool iwl_advanced_bt_coexist(struct iwl_priv *priv)
 	       priv->cfg->bt_params->advanced_bt_coexist;
 }
 
+static inline void iwl_enable_rfkill_int(struct iwl_priv *priv)
+{
+	IWL_DEBUG_ISR(priv, "Enabling rfkill interrupt\n");
+	iwl_write32(bus(priv), CSR_INT_MASK, CSR_INT_BIT_RF_KILL);
+}
+
 extern bool bt_siso_mode;
 
 #endif /* __iwl_core_h__ */
diff --git a/drivers/net/wireless/iwlwifi/iwl-helpers.h b/drivers/net/wireless/iwlwifi/iwl-helpers.h
deleted file mode 100644
index b7cf992..0000000
--- a/drivers/net/wireless/iwlwifi/iwl-helpers.h
+++ /dev/null
@@ -1,44 +0,0 @@
-/******************************************************************************
- *
- * Copyright(c) 2003 - 2011 Intel Corporation. All rights reserved.
- *
- * Portions of this file are derived from the ipw3945 project, as well
- * as portions of the ieee80211 subsystem header files.
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of version 2 of the GNU General Public License as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful, but WITHOUT
- * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
- * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
- * more details.
- *
- * You should have received a copy of the GNU General Public License along with
- * this program; if not, write to the Free Software Foundation, Inc.,
- * 51 Franklin Street, Fifth Floor, Boston, MA 02110, USA
- *
- * The full GNU General Public License is included in this distribution in the
- * file called LICENSE.
- *
- * Contact Information:
- *  Intel Linux Wireless <ilw@linux.intel.com>
- * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
- *
- *****************************************************************************/
-
-#ifndef __iwl_helpers_h__
-#define __iwl_helpers_h__
-
-#include <linux/ctype.h>
-#include <net/mac80211.h>
-
-#include "iwl-io.h"
-
-static inline void iwl_enable_rfkill_int(struct iwl_priv *priv)
-{
-	IWL_DEBUG_ISR(priv, "Enabling rfkill interrupt\n");
-	iwl_write32(bus(priv), CSR_INT_MASK, CSR_INT_BIT_RF_KILL);
-}
-
-#endif				/* __iwl_helpers_h__ */
diff --git a/drivers/net/wireless/iwlwifi/iwl-scan.c b/drivers/net/wireless/iwlwifi/iwl-scan.c
index bb03bf8..e5d727f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-scan.c
+++ b/drivers/net/wireless/iwlwifi/iwl-scan.c
@@ -34,7 +34,6 @@
 #include "iwl-dev.h"
 #include "iwl-core.h"
 #include "iwl-io.h"
-#include "iwl-helpers.h"
 #include "iwl-agn.h"
 #include "iwl-trans.h"
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c
index b4eff55..374c68c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c
@@ -33,7 +33,6 @@
 /*TODO: Remove include to iwl-core.h*/
 #include "iwl-core.h"
 #include "iwl-io.h"
-#include "iwl-helpers.h"
 #include "iwl-trans-pcie-int.h"
 
 /******************************************************************************
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c
index 2e48979..0d7803b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c
@@ -37,7 +37,6 @@
 #include "iwl-prph.h"
 #include "iwl-io.h"
 #include "iwl-agn-hw.h"
-#include "iwl-helpers.h"
 #include "iwl-trans-pcie-int.h"
 
 #define IWL_TX_CRC_SIZE 4
-- 
1.7.0.4

