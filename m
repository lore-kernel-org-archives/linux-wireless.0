Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:50660 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753029AbdDKMjF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 11 Apr 2017 08:39:05 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Tue, 11 Apr 2017 15:37:35 +0300
Message-Id: <20170411123742.12214-19-luca@coelho.fi> (sfid-20170411_144106_761606_D0DCC25F)
In-Reply-To: <20170411123742.12214-1-luca@coelho.fi>
References: <20170411123742.12214-1-luca@coelho.fi>
Subject: [PATCH 18/25] iwlwifi: pcie: use WFPM_GP for debugging D3 flows
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

This register is helpful for debugging D3 issues.
Driver turns all bits on, and then on exit reads the
updated value there.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-prph.h   |  1 +
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c | 13 +++++++++++++
 2 files changed, 14 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-prph.h b/drivers/net/wireless/intel/iwlwifi/iwl-prph.h
index 406ef301b8ab..3a8aeee3b55a 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-prph.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-prph.h
@@ -378,6 +378,7 @@
 #define RADIO_REG_SYS_MANUAL_DFT_0	0xAD4078
 #define RFIC_REG_RD			0xAD0470
 #define WFPM_CTRL_REG			0xA03030
+#define WFPM_GP2			0xA030B4
 enum {
 	ENABLE_WFPM = BIT(31),
 	WFPM_AUX_CTL_AUX_IF_MAC_OWNER_MSK	= 0x80000000,
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
index 69f1b032260c..15bf5100d096 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -1047,6 +1047,16 @@ static int iwl_pcie_load_given_ucode_8000(struct iwl_trans *trans,
 	if (ret)
 		return ret;
 
+	IWL_DEBUG_POWER(trans, "Original WFPM value = 0x%08X\n",
+			iwl_read_prph(trans, WFPM_GP2));
+
+	/*
+	 * Set default value. On resume reading the values that were
+	 * zeored can provide debug data on the resume flow.
+	 * This is for debugging only and has no functional impact.
+	 */
+	iwl_write_prph(trans, WFPM_GP2, 0x01010101);
+
 	/* configure the ucode to be ready to get the secured image */
 	/* release CPU reset */
 	iwl_write_prph(trans, RELEASE_CPU_RESET, RELEASE_CPU_RESET_BIT);
@@ -1527,6 +1537,9 @@ static int iwl_trans_pcie_d3_resume(struct iwl_trans *trans,
 		}
 	}
 
+	IWL_DEBUG_POWER(trans, "WFPM value upon resume = 0x%08X\n",
+			iwl_read_prph(trans, WFPM_GP2));
+
 	val = iwl_read32(trans, CSR_RESET);
 	if (val & CSR_RESET_REG_FLAG_NEVO_RESET)
 		*status = IWL_D3_STATUS_RESET;
-- 
2.11.0
