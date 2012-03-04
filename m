Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:17699 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755193Ab2CDUnM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Mar 2012 15:43:12 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 085/101] iwlwifi: reintroduce iwl_enable_rfkill_int
Date: Sun,  4 Mar 2012 11:29:39 -0800
Message-Id: <1330889395-533-86-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120304_214441_552571_F0C0FCD7)
In-Reply-To: <1330889395-533-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1330889395-533-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Stanislaw Gruszka <sgruszka@redhat.com>

If device is disabled by rfkill switch, do not enable all interrupts,
but only CSR_INT_BIT_RF_KILL to receive rfkill state change. Unblocking
other interrupts might cause problems, since driver can not be prepared
for receive them.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h |    6 ++++++
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c  |    6 ++----
 drivers/net/wireless/iwlwifi/iwl-trans-pcie.c     |   13 ++++++++-----
 3 files changed, 16 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h
index 4f73a6d..93d89a3 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h
@@ -376,6 +376,12 @@ static inline void iwl_enable_interrupts(struct iwl_trans *trans)
 	iwl_write32(trans, CSR_INT_MASK, trans_pcie->inta_mask);
 }
 
+static inline void iwl_enable_rfkill_int(struct iwl_trans *trans)
+{
+	IWL_DEBUG_ISR(trans, "Enabling rfkill interrupt\n");
+	iwl_write32(trans, CSR_INT_MASK, CSR_INT_BIT_RF_KILL);
+}
+
 /*
  * we have 8 bits used like this:
  *
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c
index 5b2e47a..3eb7bd1 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c
@@ -1134,10 +1134,8 @@ void iwl_irq_tasklet(struct iwl_trans *trans)
 	if (test_bit(STATUS_INT_ENABLED, &trans->shrd->status))
 		iwl_enable_interrupts(trans);
 	/* Re-enable RF_KILL if it occurred */
-	else if (handled & CSR_INT_BIT_RF_KILL) {
-		IWL_DEBUG_ISR(trans, "Enabling rfkill interrupt\n");
-		iwl_write32(trans, CSR_INT_MASK, CSR_INT_BIT_RF_KILL);
-	}
+	else if (handled & CSR_INT_BIT_RF_KILL)
+		iwl_enable_rfkill_int(trans);
 }
 
 /******************************************************************************
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
index 75bb95e..1d35d0e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
@@ -1051,7 +1051,7 @@ static int iwl_trans_pcie_start_fw(struct iwl_trans *trans,
 	iwl_op_mode_hw_rf_kill(trans->op_mode, hw_rfkill);
 
 	if (hw_rfkill) {
-		iwl_enable_interrupts(trans);
+		iwl_enable_rfkill_int(trans);
 		return -ERFKILL;
 	}
 
@@ -1562,8 +1562,7 @@ static void iwl_trans_pcie_stop_hw(struct iwl_trans *trans)
 	iwl_write32(trans, CSR_INT, 0xFFFFFFFF);
 
 	/* Even if we stop the HW, we still want the RF kill interrupt */
-	IWL_DEBUG_ISR(trans, "Enabling rfkill interrupt\n");
-	iwl_write32(trans, CSR_INT_MASK, CSR_INT_BIT_RF_KILL);
+	iwl_enable_rfkill_int(trans);
 }
 
 static int iwl_trans_pcie_reclaim(struct iwl_trans *trans, int sta_id, int tid,
@@ -1656,10 +1655,14 @@ static int iwl_trans_pcie_resume(struct iwl_trans *trans)
 {
 	bool hw_rfkill;
 
-	iwl_enable_interrupts(trans);
-
 	hw_rfkill = !(iwl_read32(trans, CSR_GP_CNTRL) &
 				CSR_GP_CNTRL_REG_FLAG_HW_RF_KILL_SW);
+
+	if (hw_rfkill)
+		iwl_enable_rfkill_int(trans);
+	else
+		iwl_enable_interrupts(trans);
+
 	iwl_op_mode_hw_rf_kill(trans->op_mode, hw_rfkill);
 
 	return 0;
-- 
1.7.0.4

