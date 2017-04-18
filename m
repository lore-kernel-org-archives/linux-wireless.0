Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:52808 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1754182AbdDRWVP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 18 Apr 2017 18:21:15 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Luca Coelho <luciano.coelho@intel.com>
Date: Wed, 19 Apr 2017 01:17:19 +0300
Message-Id: <20170418221729.28372-16-luca@coelho.fi> (sfid-20170419_002133_601828_B6C54E1D)
In-Reply-To: <20170418221729.28372-1-luca@coelho.fi>
References: <20170418221729.28372-1-luca@coelho.fi>
Subject: [PATCH 15/25] iwlwifi: pcie: remove RSA race workaround
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luca Coelho <luciano.coelho@intel.com>

This workaround is not needed anymore.  Remove it.

Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c | 46 -------------------------
 1 file changed, 46 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
index ed1034e58cb4..91f6030529b3 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -720,47 +720,6 @@ static int iwl_pcie_load_section(struct iwl_trans *trans, u8 section_num,
 	return ret;
 }
 
-/*
- * Driver Takes the ownership on secure machine before FW load
- * and prevent race with the BT load.
- * W/A for ROM bug. (should be remove in the next Si step)
- */
-static int iwl_pcie_rsa_race_bug_wa(struct iwl_trans *trans)
-{
-	u32 val, loop = 1000;
-
-	/*
-	 * Check the RSA semaphore is accessible.
-	 * If the HW isn't locked and the rsa semaphore isn't accessible,
-	 * we are in trouble.
-	 */
-	val = iwl_read_prph(trans, PREG_AUX_BUS_WPROT_0);
-	if (val & (BIT(1) | BIT(17))) {
-		IWL_DEBUG_INFO(trans,
-			       "can't access the RSA semaphore it is write protected\n");
-		return 0;
-	}
-
-	/* take ownership on the AUX IF */
-	iwl_write_prph(trans, WFPM_CTRL_REG, WFPM_AUX_CTL_AUX_IF_MAC_OWNER_MSK);
-	iwl_write_prph(trans, AUX_MISC_MASTER1_EN, AUX_MISC_MASTER1_EN_SBE_MSK);
-
-	do {
-		iwl_write_prph(trans, AUX_MISC_MASTER1_SMPHR_STATUS, 0x1);
-		val = iwl_read_prph(trans, AUX_MISC_MASTER1_SMPHR_STATUS);
-		if (val == 0x1) {
-			iwl_write_prph(trans, RSA_ENABLE, 0);
-			return 0;
-		}
-
-		udelay(10);
-		loop--;
-	} while (loop > 0);
-
-	IWL_ERR(trans, "Failed to take ownership on secure machine\n");
-	return -EIO;
-}
-
 static int iwl_pcie_load_cpu_sections_8000(struct iwl_trans *trans,
 					   const struct fw_img *image,
 					   int cpu,
@@ -1010,11 +969,6 @@ static int iwl_pcie_load_given_ucode_8000(struct iwl_trans *trans,
 	if (trans->dbg_dest_tlv)
 		iwl_pcie_apply_destination(trans);
 
-	/* TODO: remove in the next Si step */
-	ret = iwl_pcie_rsa_race_bug_wa(trans);
-	if (ret)
-		return ret;
-
 	IWL_DEBUG_POWER(trans, "Original WFPM value = 0x%08X\n",
 			iwl_read_prph(trans, WFPM_GP2));
 
-- 
2.11.0
