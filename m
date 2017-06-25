Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:35006 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751134AbdFYLNF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 25 Jun 2017 07:13:05 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Sun, 25 Jun 2017 14:11:57 +0300
Message-Id: <20170625111158.1792-26-luca@coelho.fi> (sfid-20170625_131317_474220_AC3906B6)
In-Reply-To: <20170625111158.1792-1-luca@coelho.fi>
References: <20170625111158.1792-1-luca@coelho.fi>
Subject: [PATCH 25/26] iwlwifi: pcie: work around suspend/resume issue
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

In some platforms, having the device enabled with certain radio
frontends causes the platform to not be able to resume properly
from suspend, regardless of the wakeup cause. This was traced to
a hardware issue with the integrated 9000-series A-step variant.
Set the right hardware bit to disable the problematic state.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-csr.h    |  4 ++++
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c | 11 +++++++++++
 2 files changed, 15 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-csr.h b/drivers/net/wireless/intel/iwlwifi/iwl-csr.h
index 36fb20168598..e239b1d92cf9 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-csr.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-csr.h
@@ -153,6 +153,10 @@
 /* GIO Chicken Bits (PCI Express bus link power management) */
 #define CSR_GIO_CHICKEN_BITS    (CSR_BASE+0x100)
 
+/* host chicken bits */
+#define CSR_HOST_CHICKEN	(CSR_BASE + 0x204)
+#define CSR_HOST_CHICKEN_PM_IDLE_SRC_DIS_SB_PME	BIT(19)
+
 /* Analog phase-lock-loop configuration  */
 #define CSR_ANA_PLL_CFG         (CSR_BASE+0x20c)
 
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
index 233b6734c237..5778ba2278d1 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -3134,6 +3134,17 @@ struct iwl_trans *iwl_trans_pcie_alloc(struct pci_dev *pdev,
 		}
 	}
 
+	/*
+	 * 9000-series integrated A-step has a problem with suspend/resume
+	 * and sometimes even causes the whole platform to get stuck. This
+	 * workaround makes the hardware not go into the problematic state.
+	 */
+	if (trans->cfg->integrated &&
+	    trans->cfg->device_family == IWL_DEVICE_FAMILY_9000 &&
+	    CSR_HW_REV_STEP(trans->hw_rev) == SILICON_A_STEP)
+		iwl_set_bit(trans, CSR_HOST_CHICKEN,
+			    CSR_HOST_CHICKEN_PM_IDLE_SRC_DIS_SB_PME);
+
 	trans->hw_rf_id = iwl_read32(trans, CSR_HW_RF_ID);
 
 	iwl_pcie_set_interrupt_capa(pdev, trans);
-- 
2.11.0
