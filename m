Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:31091 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754536AbbCLNF5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Mar 2015 09:05:57 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Eran Harary <eran.harary@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 25/49] iwlwifi: mvm: support family 8000 B2/C steps
Date: Thu, 12 Mar 2015 15:04:10 +0200
Message-Id: <1426165474-25586-25-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150312_143418_541134_2823C71D)
In-Reply-To: <1426164431.19690.4.camel@egrumbacBox>
References: <1426164431.19690.4.camel@egrumbacBox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eran Harary <eran.harary@intel.com>

In-order to recognize newer step of the device, the driver
must read the chip_version_id from the AUX bus MISC address
space. This will determine what firmware file will be
loaded.

Signed-off-by: Eran Harary <eran.harary@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-prph.h   |  9 ++++++++
 drivers/net/wireless/iwlwifi/pcie/trans.c | 37 ++++++++++++++++++++++++++++++-
 2 files changed, 45 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-prph.h b/drivers/net/wireless/iwlwifi/iwl-prph.h
index 383af27..aa6fb584 100644
--- a/drivers/net/wireless/iwlwifi/iwl-prph.h
+++ b/drivers/net/wireless/iwlwifi/iwl-prph.h
@@ -378,6 +378,15 @@ enum secure_load_status_reg {
 #define LMPM_PMG_EN			0xA01CEC
 #define RADIO_REG_SYS_MANUAL_DFT_0	0xAD4078
 #define RFIC_REG_RD			0xAD0470
+#define WFPM_CTRL_REG			0xA03030
+enum {
+	ENABLE_WFPM = BIT(31),
+};
+
+#define AUX_MISC_REG			0xA200B0
+enum {
+	HW_STEP_LOCATION_BITS = 24,
+};
 
 /* FW chicken bits */
 #define LMPM_CHICK			0xA01FF8
diff --git a/drivers/net/wireless/iwlwifi/pcie/trans.c b/drivers/net/wireless/iwlwifi/pcie/trans.c
index f31a941..4c16333 100644
--- a/drivers/net/wireless/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/iwlwifi/pcie/trans.c
@@ -2423,10 +2423,45 @@ struct iwl_trans *iwl_trans_pcie_alloc(struct pci_dev *pdev,
 	 * "dash" value). To keep hw_rev backwards compatible - we'll store it
 	 * in the old format.
 	 */
-	if (trans->cfg->device_family == IWL_DEVICE_FAMILY_8000)
+	if (trans->cfg->device_family == IWL_DEVICE_FAMILY_8000) {
+		unsigned long flags;
+		int ret;
+
 		trans->hw_rev = (trans->hw_rev & 0xfff0) |
 				(CSR_HW_REV_STEP(trans->hw_rev << 2) << 2);
 
+		/*
+		 * in-order to recognize C step driver should read chip version
+		 * id located at the AUX bus MISC address space.
+		 */
+		iwl_set_bit(trans, CSR_GP_CNTRL,
+			    CSR_GP_CNTRL_REG_FLAG_INIT_DONE);
+		udelay(2);
+
+		ret = iwl_poll_bit(trans, CSR_GP_CNTRL,
+				   CSR_GP_CNTRL_REG_FLAG_MAC_CLOCK_READY,
+				   CSR_GP_CNTRL_REG_FLAG_MAC_CLOCK_READY,
+				   25000);
+		if (ret < 0) {
+			IWL_DEBUG_INFO(trans, "Failed to wake up the nic\n");
+			goto out_pci_disable_msi;
+		}
+
+		if (iwl_trans_grab_nic_access(trans, false, &flags)) {
+			u32 hw_step;
+
+			hw_step = __iwl_read_prph(trans, WFPM_CTRL_REG);
+			hw_step |= ENABLE_WFPM;
+			__iwl_write_prph(trans, WFPM_CTRL_REG, hw_step);
+			hw_step = __iwl_read_prph(trans, AUX_MISC_REG);
+			hw_step = (hw_step >> HW_STEP_LOCATION_BITS) & 0xF;
+			if (hw_step == 0x3)
+				trans->hw_rev = (trans->hw_rev & 0xFFFFFFF3) |
+						(SILICON_C_STEP << 2);
+			iwl_trans_release_nic_access(trans, &flags);
+		}
+	}
+
 	trans->hw_id = (pdev->device << 16) + pdev->subsystem_device;
 	snprintf(trans->hw_id_str, sizeof(trans->hw_id_str),
 		 "PCI ID: 0x%04X:0x%04X", pdev->device, pdev->subsystem_device);
-- 
1.9.1

