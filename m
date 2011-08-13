Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:60424 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752032Ab1HMSS4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Aug 2011 14:18:56 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 39/60] iwlagn: iwl-dev.h doesn't include iwl-fh.h any more
Date: Sat, 13 Aug 2011 10:38:15 -0700
Message-Id: <1313257116-2697-40-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110813_204257_483289_D12FF819)
In-Reply-To: <1313257116-2697-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1313257116-2697-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Since iwl-fh.h contains transport related data, it shouldn't be included by the
upper layer.
Only the transport layer and iwl-agn-ucode.c includes it.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-hw.h         |   13 -------------
 drivers/net/wireless/iwlwifi/iwl-agn-ucode.c      |    1 +
 drivers/net/wireless/iwlwifi/iwl-agn.c            |    4 ++++
 drivers/net/wireless/iwlwifi/iwl-commands.h       |    1 +
 drivers/net/wireless/iwlwifi/iwl-dev.h            |    1 -
 drivers/net/wireless/iwlwifi/iwl-fh.h             |   18 ++++++++++++------
 drivers/net/wireless/iwlwifi/iwl-sv-open.c        |    1 -
 drivers/net/wireless/iwlwifi/iwl-trans-int-pcie.h |    2 ++
 8 files changed, 20 insertions(+), 21 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-hw.h b/drivers/net/wireless/iwlwifi/iwl-agn-hw.h
index 47c4304..33951a1 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-hw.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-hw.h
@@ -95,17 +95,4 @@
 #define IWLAGN_NUM_AMPDU_QUEUES		9
 #define IWLAGN_FIRST_AMPDU_QUEUE	11
 
-/* Fixed (non-configurable) rx data from phy */
-
-/**
- * struct iwlagn_schedq_bc_tbl scheduler byte count table
- *	base physical address provided by SCD_DRAM_BASE_ADDR
- * @tfd_offset  0-12 - tx command byte count
- *	       12-16 - station index
- */
-struct iwlagn_scd_bc_tbl {
-	__le16 tfd_offset[TFD_QUEUE_BC_SIZE];
-} __packed;
-
-
 #endif /* __iwl_agn_hw_h__ */
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c b/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c
index a094b66..033f595 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c
@@ -40,6 +40,7 @@
 #include "iwl-agn.h"
 #include "iwl-agn-calib.h"
 #include "iwl-trans.h"
+#include "iwl-fh.h"
 
 static struct iwl_wimax_coex_event_entry cu_priorities[COEX_NUM_OF_EVENTS] = {
 	{COEX_CU_UNASSOC_IDLE_RP, COEX_CU_UNASSOC_IDLE_WP,
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 0dec6a3..2a8ea45 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -3253,6 +3253,10 @@ static u32 iwl_hw_detect(struct iwl_priv *priv)
 	return iwl_read32(priv, CSR_HW_REV);
 }
 
+/* Size of one Rx buffer in host DRAM */
+#define IWL_RX_BUF_SIZE_4K (4 * 1024)
+#define IWL_RX_BUF_SIZE_8K (8 * 1024)
+
 static int iwl_set_hw_params(struct iwl_priv *priv)
 {
 	if (iwlagn_mod_params.amsdu_size_8K)
diff --git a/drivers/net/wireless/iwlwifi/iwl-commands.h b/drivers/net/wireless/iwlwifi/iwl-commands.h
index 2e8b386..20b4b39 100644
--- a/drivers/net/wireless/iwlwifi/iwl-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-commands.h
@@ -3911,6 +3911,7 @@ struct iwlagn_wowlan_kek_kck_material_cmd {
  * Union of all expected notifications/responses:
  *
  *****************************************************************************/
+#define FH_RSCSR_FRAME_SIZE_MSK	(0x00003FFF)	/* bits 0-13 */
 
 struct iwl_rx_packet {
 	/*
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index ad564b8..92fc7c6 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -40,7 +40,6 @@
 #include "iwl-eeprom.h"
 #include "iwl-csr.h"
 #include "iwl-prph.h"
-#include "iwl-fh.h"
 #include "iwl-debug.h"
 #include "iwl-agn-hw.h"
 #include "iwl-led.h"
diff --git a/drivers/net/wireless/iwlwifi/iwl-fh.h b/drivers/net/wireless/iwlwifi/iwl-fh.h
index 0ad60b3..c1b8837 100644
--- a/drivers/net/wireless/iwlwifi/iwl-fh.h
+++ b/drivers/net/wireless/iwlwifi/iwl-fh.h
@@ -266,8 +266,6 @@
 #define FH_RCSR_CHNL0_RX_CONFIG_IRQ_DEST_NO_INT_VAL    (0x00000000)
 #define FH_RCSR_CHNL0_RX_CONFIG_IRQ_DEST_INT_HOST_VAL  (0x00001000)
 
-#define FH_RSCSR_FRAME_SIZE_MSK	(0x00003FFF)	/* bits 0-13 */
-
 /**
  * Rx Shared Status Registers (RSSR)
  *
@@ -422,10 +420,6 @@
 #define RX_FREE_BUFFERS 64
 #define RX_LOW_WATERMARK 8
 
-/* Size of one Rx buffer in host DRAM */
-#define IWL_RX_BUF_SIZE_4K (4 * 1024)
-#define IWL_RX_BUF_SIZE_8K (8 * 1024)
-
 /**
  * struct iwl_rb_status - reseve buffer status
  * 	host memory mapped FH registers
@@ -508,4 +502,16 @@ struct iwl_tfd {
 /* Keep Warm Size */
 #define IWL_KW_SIZE 0x1000	/* 4k */
 
+/* Fixed (non-configurable) rx data from phy */
+
+/**
+ * struct iwlagn_schedq_bc_tbl scheduler byte count table
+ *	base physical address provided by SCD_DRAM_BASE_ADDR
+ * @tfd_offset  0-12 - tx command byte count
+ *	       12-16 - station index
+ */
+struct iwlagn_scd_bc_tbl {
+	__le16 tfd_offset[TFD_QUEUE_BC_SIZE];
+} __packed;
+
 #endif /* !__iwl_fh_h__ */
diff --git a/drivers/net/wireless/iwlwifi/iwl-sv-open.c b/drivers/net/wireless/iwlwifi/iwl-sv-open.c
index 4d4358a..15c9be8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sv-open.c
+++ b/drivers/net/wireless/iwlwifi/iwl-sv-open.c
@@ -72,7 +72,6 @@
 #include "iwl-dev.h"
 #include "iwl-core.h"
 #include "iwl-debug.h"
-#include "iwl-fh.h"
 #include "iwl-io.h"
 #include "iwl-agn.h"
 #include "iwl-testmode.h"
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-int-pcie.h b/drivers/net/wireless/iwlwifi/iwl-trans-int-pcie.h
index 59c6b3c..af2d478 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-int-pcie.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-int-pcie.h
@@ -29,6 +29,8 @@
 #ifndef __iwl_trans_int_pcie_h__
 #define __iwl_trans_int_pcie_h__
 
+#include "iwl-fh.h"
+
 /*This file includes the declaration that are internal to the
  * trans_pcie layer */
 
-- 
1.7.0.4

