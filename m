Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:39352 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1754793AbdBHPxM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 8 Feb 2017 10:53:12 -0500
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Golan Ben Ami <golan.ben.ami@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Wed,  8 Feb 2017 17:51:45 +0200
Message-Id: <20170208155149.1704-5-luca@coelho.fi> (sfid-20170208_165320_050614_DA4C610F)
In-Reply-To: <20170208155149.1704-1-luca@coelho.fi>
References: <20170208112322.29413-1-luca@coelho.fi>
 <20170208155149.1704-1-luca@coelho.fi>
Subject: [PATCH 13/17] iwlwifi: pcie: set STATUS_RFKILL immediately after interrupt
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Golan Ben Ami <golan.ben.ami@intel.com>

Currently, when getting a RFKILL interrupt, the transport enters a flow
in which it stops the device, disables other interrupts, etc. After
stopping the device, the transport resets the hw, and sleeps. During
the sleep, a context switch occurs and host commands are sent by upper
layers (e.g. mvm) to the fw. This is possible since the op_mode layer
and the transport layer hold different mutexes.

Since the STATUS_RFKILL bit isn't set, the transport layer doesn't
recognize that RFKILL was toggled on, and no commands can actually be
sent, so it enqueues the command to the tx queue and sets a timer on
the queue.

After switching context back to stopping the device, STATUS_RFKILL is
set, and then the transport can't send the command to the fw.
This eventually results in a queue hang.

Fix this by setting STATUS_RFKILL immediately when
the interrupt is fired.

Signed-off-by: Golan Ben-Ami <golan.ben.ami@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/pcie/rx.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
index e1bf6da20909..de94dfdf2ec9 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
@@ -1609,6 +1609,9 @@ irqreturn_t iwl_pcie_irq_handler(int irq, void *dev_id)
 
 		mutex_lock(&trans_pcie->mutex);
 		hw_rfkill = iwl_is_rfkill_set(trans);
+		if (hw_rfkill)
+			set_bit(STATUS_RFKILL, &trans->status);
+
 		IWL_WARN(trans, "RF_KILL bit toggled to %s.\n",
 			 hw_rfkill ? "disable radio" : "enable radio");
 
@@ -1617,7 +1620,6 @@ irqreturn_t iwl_pcie_irq_handler(int irq, void *dev_id)
 		iwl_trans_pcie_rf_kill(trans, hw_rfkill);
 		mutex_unlock(&trans_pcie->mutex);
 		if (hw_rfkill) {
-			set_bit(STATUS_RFKILL, &trans->status);
 			if (test_and_clear_bit(STATUS_SYNC_HCMD_ACTIVE,
 					       &trans->status))
 				IWL_DEBUG_RF_KILL(trans,
@@ -1954,6 +1956,9 @@ irqreturn_t iwl_pcie_irq_msix_handler(int irq, void *dev_id)
 
 		mutex_lock(&trans_pcie->mutex);
 		hw_rfkill = iwl_is_rfkill_set(trans);
+		if (hw_rfkill)
+			set_bit(STATUS_RFKILL, &trans->status);
+
 		IWL_WARN(trans, "RF_KILL bit toggled to %s.\n",
 			 hw_rfkill ? "disable radio" : "enable radio");
 
@@ -1962,7 +1967,6 @@ irqreturn_t iwl_pcie_irq_msix_handler(int irq, void *dev_id)
 		iwl_trans_pcie_rf_kill(trans, hw_rfkill);
 		mutex_unlock(&trans_pcie->mutex);
 		if (hw_rfkill) {
-			set_bit(STATUS_RFKILL, &trans->status);
 			if (test_and_clear_bit(STATUS_SYNC_HCMD_ACTIVE,
 					       &trans->status))
 				IWL_DEBUG_RF_KILL(trans,
-- 
2.11.0
