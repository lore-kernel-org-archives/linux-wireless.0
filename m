Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:41256 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1758553AbcH3LkX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 30 Aug 2016 07:40:23 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Tue, 30 Aug 2016 14:39:02 +0300
Message-Id: <1472557142-14782-16-git-send-email-luca@coelho.fi> (sfid-20160830_134025_583300_AB7302AB)
In-Reply-To: <1472557142-14782-1-git-send-email-luca@coelho.fi>
References: <1472556999.27868.86.camel@coelho.fi>
 <1472557142-14782-1-git-send-email-luca@coelho.fi>
Subject: [PATCH 16/16] iwlwifi: pcie: remove dead code
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

If device family is 8000 then iwl_pcie_load_cpu_sections()
won't be called at all (iwl_pcie_load_cpu_sections_8000() is
called in that case) so this piece of code never gets called.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-prph.h   | 13 -------------
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c |  8 --------
 2 files changed, 21 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-prph.h b/drivers/net/wireless/intel/iwlwifi/iwl-prph.h
index 849ee79..406ef30 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-prph.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-prph.h
@@ -302,7 +302,6 @@
 #define OSC_CLK_FORCE_CONTROL		(0x8)
 
 #define FH_UCODE_LOAD_STATUS		(0x1AF0)
-#define CSR_UCODE_LOAD_STATUS_ADDR	(0x1E70)
 
 /*
  * Replacing FH_UCODE_LOAD_STATUS
@@ -311,21 +310,9 @@
  */
 #define UREG_UCODE_LOAD_STATUS		(0xa05c40)
 
-enum secure_load_status_reg {
-	LMPM_CPU_UCODE_LOADING_STARTED			= 0x00000001,
-	LMPM_CPU_HDRS_LOADING_COMPLETED			= 0x00000003,
-	LMPM_CPU_UCODE_LOADING_COMPLETED		= 0x00000007,
-	LMPM_CPU_STATUS_NUM_OF_LAST_COMPLETED		= 0x000000F8,
-	LMPM_CPU_STATUS_NUM_OF_LAST_LOADED_BLOCK	= 0x0000FF00,
-};
-
-#define LMPM_SECURE_INSPECTOR_CODE_ADDR	(0x1E38)
-#define LMPM_SECURE_INSPECTOR_DATA_ADDR	(0x1E3C)
 #define LMPM_SECURE_UCODE_LOAD_CPU1_HDR_ADDR	(0x1E78)
 #define LMPM_SECURE_UCODE_LOAD_CPU2_HDR_ADDR	(0x1E7C)
 
-#define LMPM_SECURE_INSPECTOR_CODE_MEM_SPACE	(0x400000)
-#define LMPM_SECURE_INSPECTOR_DATA_MEM_SPACE	(0x402000)
 #define LMPM_SECURE_CPU1_HDR_MEM_SPACE		(0x420000)
 #define LMPM_SECURE_CPU2_HDR_MEM_SPACE		(0x420400)
 
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
index 039eeca..2f46eed 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -903,14 +903,6 @@ static int iwl_pcie_load_cpu_sections(struct iwl_trans *trans,
 			return ret;
 	}
 
-	if (trans->cfg->device_family == IWL_DEVICE_FAMILY_8000)
-		iwl_set_bits_prph(trans,
-				  CSR_UCODE_LOAD_STATUS_ADDR,
-				  (LMPM_CPU_UCODE_LOADING_COMPLETED |
-				   LMPM_CPU_HDRS_LOADING_COMPLETED |
-				   LMPM_CPU_UCODE_LOADING_STARTED) <<
-					shift_param);
-
 	*first_ucode_section = last_read_idx;
 
 	return 0;
-- 
2.8.1
