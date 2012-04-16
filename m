Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:28026 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755613Ab2DPWB3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Apr 2012 18:01:29 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Don Fry <donald.h.fry@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 07/16] iwlwifi: move status definitions from iwl-shared
Date: Mon, 16 Apr 2012 14:57:01 -0700
Message-Id: <1334613430-30720-8-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120417_000232_518679_5BFD1312)
In-Reply-To: <1334613430-30720-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1334613430-30720-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Don Fry <donald.h.fry@intel.com>

The code has been changed, move the definitions to the proper file
being used by the code.

Signed-off-by: Don Fry <donald.h.fry@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.h            |   18 +++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-shared.h         |   24 ---------------------
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h |    8 +++++++
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c  |    2 +-
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c  |    2 +-
 drivers/net/wireless/iwlwifi/iwl-trans-pcie.c     |    6 ++--
 6 files changed, 31 insertions(+), 29 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.h b/drivers/net/wireless/iwlwifi/iwl-agn.h
index caef7a9..4485a0c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.h
@@ -82,6 +82,24 @@ extern struct iwl_lib_ops iwl6030_lib;
 
 
 
+/*****************************************************
+* DRIVER STATUS FUNCTIONS
+******************************************************/
+#define STATUS_RF_KILL_HW	0
+#define STATUS_CT_KILL		1
+#define STATUS_ALIVE		2
+#define STATUS_READY		3
+#define STATUS_GEO_CONFIGURED	4
+#define STATUS_EXIT_PENDING	5
+#define STATUS_STATISTICS	6
+#define STATUS_SCANNING		7
+#define STATUS_SCAN_ABORTING	8
+#define STATUS_SCAN_HW		9
+#define STATUS_FW_ERROR		10
+#define STATUS_CHANNEL_SWITCH_PENDING 11
+#define STATUS_SCAN_COMPLETE	12
+#define STATUS_POWER_PMI	13
+
 struct iwl_ucode_capabilities;
 
 extern struct ieee80211_ops iwlagn_hw_ops;
diff --git a/drivers/net/wireless/iwlwifi/iwl-shared.h b/drivers/net/wireless/iwlwifi/iwl-shared.h
index 2fe3145..82b52da 100644
--- a/drivers/net/wireless/iwlwifi/iwl-shared.h
+++ b/drivers/net/wireless/iwlwifi/iwl-shared.h
@@ -185,28 +185,4 @@ const char *get_cmd_string(u8 cmd);
 
 #define IWL_CMD(x) case x: return #x
 
-/*****************************************************
-* DRIVER STATUS FUNCTIONS
-******************************************************/
-#define STATUS_HCMD_ACTIVE	0	/* host command in progress */
-/* 1 is unused (used to be STATUS_HCMD_SYNC_ACTIVE) */
-#define STATUS_INT_ENABLED	2
-#define STATUS_RF_KILL_HW	3
-#define STATUS_CT_KILL		4
-#define STATUS_INIT		5
-#define STATUS_ALIVE		6
-#define STATUS_READY		7
-#define STATUS_TEMPERATURE	8
-#define STATUS_GEO_CONFIGURED	9
-#define STATUS_EXIT_PENDING	10
-#define STATUS_STATISTICS	12
-#define STATUS_SCANNING		13
-#define STATUS_SCAN_ABORTING	14
-#define STATUS_SCAN_HW		15
-#define STATUS_POWER_PMI	16
-#define STATUS_FW_ERROR		17
-#define STATUS_DEVICE_ENABLED	18
-#define STATUS_CHANNEL_SWITCH_PENDING 19
-#define STATUS_SCAN_COMPLETE	20
-
 #endif /* #__iwl_shared_h__ */
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h
index 731d275..6704dab 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h
@@ -278,6 +278,14 @@ struct iwl_trans_pcie {
 	unsigned long wd_timeout;
 };
 
+/*****************************************************
+* DRIVER STATUS FUNCTIONS
+******************************************************/
+#define STATUS_HCMD_ACTIVE	0
+#define STATUS_DEVICE_ENABLED	1
+#define STATUS_TPOWER_PMI	2
+#define STATUS_INT_ENABLED	3
+
 #define IWL_TRANS_GET_PCIE_TRANS(_iwl_trans) \
 	((struct iwl_trans_pcie *) ((_iwl_trans)->trans_specific))
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c
index 96ca5ad..bf83806 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c
@@ -150,7 +150,7 @@ void iwl_rx_queue_update_write_ptr(struct iwl_trans *trans,
 			IWL_TRANS_GET_PCIE_TRANS(trans);
 
 		/* If power-saving is in use, make sure device is awake */
-		if (test_bit(STATUS_POWER_PMI, &trans_pcie->status)) {
+		if (test_bit(STATUS_TPOWER_PMI, &trans_pcie->status)) {
 			reg = iwl_read32(trans, CSR_UCODE_DRV_GP1);
 
 			if (reg & CSR_UCODE_DRV_GP1_BIT_MAC_SLEEP) {
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c
index 2bc2670..21b7ca2 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c
@@ -107,7 +107,7 @@ void iwl_txq_update_write_ptr(struct iwl_trans *trans, struct iwl_tx_queue *txq)
 		struct iwl_trans_pcie *trans_pcie =
 			IWL_TRANS_GET_PCIE_TRANS(trans);
 		/* if we're trying to save power */
-		if (test_bit(STATUS_POWER_PMI, &trans_pcie->status)) {
+		if (test_bit(STATUS_TPOWER_PMI, &trans_pcie->status)) {
 			/* wake up nic if it's powered down ...
 			 * uCode will wake up, and interrupt us again, so next
 			 * time we'll skip this part. */
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
index 1b7c846..333a278 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
@@ -1253,7 +1253,7 @@ static void iwl_trans_pcie_stop_device(struct iwl_trans *trans)
 	clear_bit(STATUS_HCMD_ACTIVE, &trans_pcie->status);
 	clear_bit(STATUS_INT_ENABLED, &trans_pcie->status);
 	clear_bit(STATUS_DEVICE_ENABLED, &trans_pcie->status);
-	clear_bit(STATUS_POWER_PMI, &trans_pcie->status);
+	clear_bit(STATUS_TPOWER_PMI, &trans_pcie->status);
 }
 
 static void iwl_trans_pcie_wowlan_suspend(struct iwl_trans *trans)
@@ -1574,9 +1574,9 @@ static void iwl_trans_pcie_set_pmi(struct iwl_trans *trans, bool state)
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 
 	if (state)
-		set_bit(STATUS_POWER_PMI, &trans_pcie->status);
+		set_bit(STATUS_TPOWER_PMI, &trans_pcie->status);
 	else
-		clear_bit(STATUS_POWER_PMI, &trans_pcie->status);
+		clear_bit(STATUS_TPOWER_PMI, &trans_pcie->status);
 }
 
 #ifdef CONFIG_PM_SLEEP
-- 
1.7.0.4

