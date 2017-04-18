Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:52720 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753681AbdDRWRr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 18 Apr 2017 18:17:47 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Liad Kaufman <liad.kaufman@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Wed, 19 Apr 2017 01:17:10 +0300
Message-Id: <20170418221729.28372-7-luca@coelho.fi> (sfid-20170419_001756_589137_C653AE05)
In-Reply-To: <20170418221729.28372-1-luca@coelho.fi>
References: <20170418221729.28372-1-luca@coelho.fi>
Subject: [PATCH 06/25] iwlwifi: mvm: remove unneeded reg write in iwl_mvm_up()
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Liad Kaufman <liad.kaufman@intel.com>

Not only that this write is not needed (as FW does this
itself), on newer HW this register is write protected
so trying to write there will cause problems.

Signed-off-by: Liad Kaufman <liad.kaufman@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-prph.h | 3 ---
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c   | 4 ----
 2 files changed, 7 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-prph.h b/drivers/net/wireless/intel/iwlwifi/iwl-prph.h
index e1aa1f7836fc..4bceaccee62f 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-prph.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-prph.h
@@ -294,9 +294,6 @@
 
 /*********************** END TX SCHEDULER *************************************/
 
-/* tcp checksum offload */
-#define RX_EN_CSUM		(0x00a00d88)
-
 /* Oscillator clock */
 #define OSC_CLK				(0xa04068)
 #define OSC_CLK_FORCE_CONTROL		(0x8)
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
index 2a4c952ef01a..bfccbadd1a6e 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
@@ -1475,10 +1475,6 @@ int iwl_mvm_up(struct iwl_mvm *mvm)
 			goto error;
 	}
 
-	if (iwl_mvm_is_csum_supported(mvm) &&
-	    mvm->cfg->features & NETIF_F_RXCSUM)
-		iwl_trans_write_prph(mvm->trans, RX_EN_CSUM, 0x3);
-
 	/* allow FW/transport low power modes if not during restart */
 	if (!test_bit(IWL_MVM_STATUS_IN_HW_RESTART, &mvm->status))
 		iwl_mvm_unref(mvm, IWL_MVM_REF_UCODE_DOWN);
-- 
2.11.0
