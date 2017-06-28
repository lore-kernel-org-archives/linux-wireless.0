Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:35912 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751618AbdF1UOe (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Jun 2017 16:14:34 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Wed, 28 Jun 2017 23:13:10 +0300
Message-Id: <20170628201330.9432-12-luca@coelho.fi> (sfid-20170628_221454_143446_1417739C)
In-Reply-To: <20170628201330.9432-1-luca@coelho.fi>
References: <20170628201330.9432-1-luca@coelho.fi>
Subject: [PATCH 11/31] iwlwifi: pcie: fix 9000-series RF-kill interrupt propagation
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

A hardware issue on 9000 series devices sometimes causes RF-kill
interrupts to not be propagated to the host properly if ASPM is
enabled. Work around this by setting the right hardware bit to
allow it to interrupt the host for this reason (rfkill).

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-csr.h       |  2 +-
 drivers/net/wireless/intel/iwlwifi/pcie/internal.h | 10 ++++++++++
 2 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-csr.h b/drivers/net/wireless/intel/iwlwifi/iwl-csr.h
index e239b1d92cf9..c6c1876c1ad4 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-csr.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-csr.h
@@ -312,7 +312,7 @@
 #define CSR_GP_CNTRL_REG_VAL_MAC_ACCESS_EN           (0x00000001)
 
 #define CSR_GP_CNTRL_REG_MSK_POWER_SAVE_TYPE         (0x07000000)
-#define CSR_GP_CNTRL_REG_FLAG_MAC_POWER_SAVE         (0x04000000)
+#define CSR_GP_CNTRL_REG_FLAG_RFKILL_WAKE_L1A_EN     (0x04000000)
 #define CSR_GP_CNTRL_REG_FLAG_HW_RF_KILL_SW          (0x08000000)
 
 
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/internal.h b/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
index 1f4bc933f0f2..7ec2d96ccceb 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
@@ -674,6 +674,16 @@ static inline void iwl_enable_rfkill_int(struct iwl_trans *trans)
 		iwl_enable_hw_int_msk_msix(trans,
 					   MSIX_HW_INT_CAUSES_REG_RF_KILL);
 	}
+
+	if (trans->cfg->device_family == IWL_DEVICE_FAMILY_9000) {
+		/*
+		 * On 9000-series devices this bit isn't enabled by default, so
+		 * when we power down the device we need set the bit to allow it
+		 * to wake up the PCI-E bus for RF-kill interrupts.
+		 */
+		iwl_set_bit(trans, CSR_GP_CNTRL,
+			    CSR_GP_CNTRL_REG_FLAG_RFKILL_WAKE_L1A_EN);
+	}
 }
 
 void iwl_pcie_handle_rfkill_irq(struct iwl_trans *trans);
-- 
2.11.0
