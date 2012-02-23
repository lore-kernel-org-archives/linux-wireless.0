Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53011 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754079Ab2BWKQX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Feb 2012 05:16:23 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Cc: Intel Linux Wireless <ilw@linux.intel.com>,
	linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 6/6] iwlwifi: reintroduce iwl_enable_rfkill_int
Date: Thu, 23 Feb 2012 11:16:08 +0100
Message-Id: <1329992168-19990-6-git-send-email-sgruszka@redhat.com> (sfid-20120223_111627_825523_2D229977)
In-Reply-To: <1329992168-19990-1-git-send-email-sgruszka@redhat.com>
References: <1329992168-19990-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If device is disabled by rfkill switch, do not enable all interrupts,
but only CSR_INT_BIT_RF_KILL to receive rfkill state change. Unblocking
other interrupts might cause problems, since driver can not be prepared
for receive them.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h |    6 ++++++
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c  |    6 ++----
 drivers/net/wireless/iwlwifi/iwl-trans-pcie.c     |   14 +++++++-------
 3 files changed, 15 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h
index 561865f..d5f3d2f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h
@@ -338,6 +338,12 @@ static inline void iwl_enable_interrupts(struct iwl_trans *trans)
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
index a38a5b3..4175cb8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c
@@ -1150,10 +1150,8 @@ void iwl_irq_tasklet(struct iwl_trans *trans)
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
index a0e716f..33f119a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
@@ -1045,7 +1045,7 @@ static int iwl_trans_pcie_start_fw(struct iwl_trans *trans, struct fw_img *fw)
 
 	if (iwl_is_rfkill(trans->shrd)) {
 		iwl_set_hw_rfkill_state(priv(trans), true);
-		iwl_enable_interrupts(trans);
+		iwl_enable_rfkill_int(trans);
 		return -ERFKILL;
 	}
 
@@ -1538,8 +1538,7 @@ static void iwl_trans_pcie_stop_hw(struct iwl_trans *trans)
 	iwl_write32(trans, CSR_INT, 0xFFFFFFFF);
 
 	/* Even if we stop the HW, we still want the RF kill interrupt */
-	IWL_DEBUG_ISR(trans, "Enabling rfkill interrupt\n");
-	iwl_write32(trans, CSR_INT_MASK, CSR_INT_BIT_RF_KILL);
+	iwl_enable_rfkill_int(trans);
 }
 
 static int iwl_trans_pcie_reclaim(struct iwl_trans *trans, int sta_id, int tid,
@@ -1650,16 +1649,17 @@ static int iwl_trans_pcie_resume(struct iwl_trans *trans)
 {
 	bool hw_rfkill = false;
 
-	iwl_enable_interrupts(trans);
-
 	if (!(iwl_read32(trans, CSR_GP_CNTRL) &
 				CSR_GP_CNTRL_REG_FLAG_HW_RF_KILL_SW))
 		hw_rfkill = true;
 
-	if (hw_rfkill)
+	if (hw_rfkill) {
 		set_bit(STATUS_RF_KILL_HW, &trans->shrd->status);
-	else
+		iwl_enable_rfkill_int(trans);
+	} else {
 		clear_bit(STATUS_RF_KILL_HW, &trans->shrd->status);
+		iwl_enable_interrupts(trans);
+	}
 
 	iwl_set_hw_rfkill_state(priv(trans), hw_rfkill);
 
-- 
1.7.1

