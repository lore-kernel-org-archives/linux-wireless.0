Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:64527 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752494AbbDBGlh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Apr 2015 02:41:37 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Eran Harary <eran.harary@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 07/31] iwlwifi: mvm: don't wait for firmware verification
Date: Thu,  2 Apr 2015 09:40:55 +0300
Message-Id: <1427956879-11725-7-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150402_084140_773101_672A5A00)
In-Reply-To: <1427956656.8122.2.camel@egrumbacBox>
References: <1427956656.8122.2.camel@egrumbacBox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eran Harary <eran.harary@intel.com>

The firmware has a race in the flow that indicates the
completion of the authentication. Checking the completion
of the authentication is not really needed anyway since
we can wait for the ALIVE notification instead.
Remove the unneeded and buggy code.

Signed-off-by: Eran Harary <eran.harary@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-prph.h   | 21 ---------------------
 drivers/net/wireless/iwlwifi/pcie/trans.c | 15 ---------------
 2 files changed, 36 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-prph.h b/drivers/net/wireless/iwlwifi/iwl-prph.h
index bc96288..467c4bc 100644
--- a/drivers/net/wireless/iwlwifi/iwl-prph.h
+++ b/drivers/net/wireless/iwlwifi/iwl-prph.h
@@ -295,25 +295,6 @@
 #define OSC_CLK				(0xa04068)
 #define OSC_CLK_FORCE_CONTROL		(0x8)
 
-/* SECURE boot registers */
-#define LMPM_SECURE_BOOT_CONFIG_ADDR	(0x100)
-enum secure_boot_config_reg {
-	LMPM_SECURE_BOOT_CONFIG_INSPECTOR_BURNED_IN_OTP	= 0x00000001,
-	LMPM_SECURE_BOOT_CONFIG_INSPECTOR_NOT_REQ	= 0x00000002,
-};
-
-#define LMPM_SECURE_BOOT_CPU1_STATUS_ADDR_B0	(0xA01E30)
-#define LMPM_SECURE_BOOT_CPU1_STATUS_ADDR	(0x1E30)
-#define LMPM_SECURE_BOOT_CPU2_STATUS_ADDR	(0x1E34)
-enum secure_boot_status_reg {
-	LMPM_SECURE_BOOT_CPU_STATUS_VERF_STATUS		= 0x00000001,
-	LMPM_SECURE_BOOT_CPU_STATUS_VERF_COMPLETED	= 0x00000002,
-	LMPM_SECURE_BOOT_CPU_STATUS_VERF_SUCCESS	= 0x00000004,
-	LMPM_SECURE_BOOT_CPU_STATUS_VERF_FAIL		= 0x00000008,
-	LMPM_SECURE_BOOT_CPU_STATUS_SIGN_VERF_FAIL	= 0x00000010,
-	LMPM_SECURE_BOOT_STATUS_SUCCESS			= 0x00000003,
-};
-
 #define FH_UCODE_LOAD_STATUS		(0x1AF0)
 #define CSR_UCODE_LOAD_STATUS_ADDR	(0x1E70)
 enum secure_load_status_reg {
@@ -334,8 +315,6 @@ enum secure_load_status_reg {
 #define LMPM_SECURE_CPU1_HDR_MEM_SPACE		(0x420000)
 #define LMPM_SECURE_CPU2_HDR_MEM_SPACE		(0x420400)
 
-#define LMPM_SECURE_TIME_OUT	(100) /* 10 micro */
-
 /* Rx FIFO */
 #define RXF_SIZE_ADDR			(0xa00c88)
 #define RXF_RD_D_SPACE			(0xa00c40)
diff --git a/drivers/net/wireless/iwlwifi/pcie/trans.c b/drivers/net/wireless/iwlwifi/pcie/trans.c
index dc24732..df0022e 100644
--- a/drivers/net/wireless/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/iwlwifi/pcie/trans.c
@@ -930,7 +930,6 @@ static int iwl_pcie_load_given_ucode_8000b(struct iwl_trans *trans,
 {
 	int ret = 0;
 	int first_ucode_section;
-	u32 reg;
 
 	IWL_DEBUG_FW(trans, "working with %s CPU\n",
 		     image->is_dual_cpus ? "Dual" : "Single");
@@ -959,20 +958,6 @@ static int iwl_pcie_load_given_ucode_8000b(struct iwl_trans *trans,
 	if (ret)
 		return ret;
 
-	/* wait for image verification to complete  */
-	ret = iwl_poll_prph_bit(trans, LMPM_SECURE_BOOT_CPU1_STATUS_ADDR_B0,
-				LMPM_SECURE_BOOT_STATUS_SUCCESS,
-				LMPM_SECURE_BOOT_STATUS_SUCCESS,
-				LMPM_SECURE_TIME_OUT);
-	if (ret < 0) {
-		reg = iwl_read_prph(trans,
-				    LMPM_SECURE_BOOT_CPU1_STATUS_ADDR_B0);
-
-		IWL_ERR(trans, "Timeout on secure boot process, reg = %x\n",
-			reg);
-		return ret;
-	}
-
 	return 0;
 }
 
-- 
1.9.1

