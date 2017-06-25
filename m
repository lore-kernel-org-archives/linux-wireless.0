Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:34998 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751339AbdFYLNB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 25 Jun 2017 07:13:01 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Luca Coelho <luciano.coelho@intel.com>
Date: Sun, 25 Jun 2017 14:11:45 +0300
Message-Id: <20170625111158.1792-14-luca@coelho.fi> (sfid-20170625_131307_808085_54856BBA)
In-Reply-To: <20170625111158.1792-1-luca@coelho.fi>
References: <20170625111158.1792-1-luca@coelho.fi>
Subject: [PATCH 13/26] iwlwifi: mvm: reset the HW before dumping if HW error is detected
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luca Coelho <luciano.coelho@intel.com>

If the hardware is stuck, we can't read any of the memory we need to
dump it, so we end up printing only 0xa5a5a5a5, which is useless.

To solve this, poke the hardware by triggering a reset and re-enabling
the clocks if we detect a HW error.

Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/utils.c | 32 ++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/utils.c b/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
index dc8104d846f9..e7cc8e05615a 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
@@ -69,6 +69,7 @@
 #include "iwl-debug.h"
 #include "iwl-io.h"
 #include "iwl-prph.h"
+#include "iwl-csr.h"
 #include "fw-dbg.h"
 #include "mvm.h"
 #include "fw-api-rs.h"
@@ -497,6 +498,7 @@ static void iwl_mvm_dump_lmac_error_log(struct iwl_mvm *mvm, u32 base)
 {
 	struct iwl_trans *trans = mvm->trans;
 	struct iwl_error_event_table table;
+	u32 val;
 
 	if (mvm->cur_ucode == IWL_UCODE_INIT) {
 		if (!base)
@@ -515,6 +517,36 @@ static void iwl_mvm_dump_lmac_error_log(struct iwl_mvm *mvm, u32 base)
 		return;
 	}
 
+	/* check if there is a HW error */
+	val = iwl_trans_read_mem32(trans, base);
+	if (((val & ~0xf) == 0xa5a5a5a0) || ((val & ~0xf) == 0x5a5a5a50)) {
+		int err;
+
+		IWL_ERR(trans, "HW error, resetting before reading\n");
+
+		/* reset the device */
+		iwl_set_bit(trans, CSR_RESET, CSR_RESET_REG_FLAG_SW_RESET);
+		usleep_range(1000, 2000);
+
+		/* set INIT_DONE flag */
+		iwl_set_bit(trans, CSR_GP_CNTRL,
+			    CSR_GP_CNTRL_REG_FLAG_INIT_DONE);
+
+		/* and wait for clock stabilization */
+		if (trans->cfg->device_family == IWL_DEVICE_FAMILY_8000)
+			udelay(2);
+
+		err = iwl_poll_bit(trans, CSR_GP_CNTRL,
+				   CSR_GP_CNTRL_REG_FLAG_MAC_CLOCK_READY,
+				   CSR_GP_CNTRL_REG_FLAG_MAC_CLOCK_READY,
+				   25000);
+		if (err < 0) {
+			IWL_DEBUG_INFO(trans,
+				       "Failed to reset the card for the dump\n");
+			return;
+		}
+	}
+
 	iwl_trans_read_mem_bytes(trans, base, &table, sizeof(table));
 
 	if (ERROR_START_OFFSET <= table.valid * ERROR_ELEM_SIZE) {
-- 
2.11.0
