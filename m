Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:34858 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751186AbdFYLMJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 25 Jun 2017 07:12:09 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Liad Kaufman <liad.kaufman@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Sun, 25 Jun 2017 14:11:37 +0300
Message-Id: <20170625111158.1792-6-luca@coelho.fi> (sfid-20170625_131217_528740_B95FE978)
In-Reply-To: <20170625111158.1792-1-luca@coelho.fi>
References: <20170625111158.1792-1-luca@coelho.fi>
Subject: [PATCH 05/26] iwlwifi: mvm: fix fw monitor 7000 HW recollecting
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Liad Kaufman <liad.kaufman@intel.com>

To stop and start the FW monitor in the 7000 HW
family we need to use a different bit, otherwise
after stopping it for the first time - it won't
get restarted. Use the correct bitmask.

Note: This fix is only for DRAM collection mode.
      For other modes, an additional fix will be
      needed.

Signed-off-by: Liad Kaufman <liad.kaufman@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
index 3a8c95162811..4e66cc662120 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
@@ -1181,9 +1181,13 @@ static void iwl_mvm_fw_error_dump_wk(struct work_struct *work)
 
 		/* start recording again if the firmware is not crashed */
 		if (!test_bit(STATUS_FW_ERROR, &mvm->trans->status) &&
-		    mvm->fw->dbg_dest_tlv)
+		    mvm->fw->dbg_dest_tlv) {
 			iwl_clear_bits_prph(mvm->trans,
 					    MON_BUFF_SAMPLE_CTL, 0x100);
+			iwl_clear_bits_prph(mvm->trans,
+					    MON_BUFF_SAMPLE_CTL, 0x1);
+			iwl_set_bits_prph(mvm->trans, MON_BUFF_SAMPLE_CTL, 0x1);
+		}
 	} else {
 		u32 in_sample = iwl_read_prph(mvm->trans, DBGC_IN_SAMPLE);
 		u32 out_ctrl = iwl_read_prph(mvm->trans, DBGC_OUT_CTRL);
-- 
2.11.0
