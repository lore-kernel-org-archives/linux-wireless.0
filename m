Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f175.google.com ([209.85.215.175]:65340 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753179AbaBCU61 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Feb 2014 15:58:27 -0500
Received: by mail-ea0-f175.google.com with SMTP id z10so3948468ead.6
        for <linux-wireless@vger.kernel.org>; Mon, 03 Feb 2014 12:58:26 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Eran Harary <eran.harary@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 07/62] iwlwifi: pcie: fix secure section / dual cpu firmware loading
Date: Mon,  3 Feb 2014 22:57:13 +0200
Message-Id: <1391461088-8082-7-git-send-email-egrumbach@gmail.com> (sfid-20140203_215834_132561_40927716)
In-Reply-To: <CANUX_P2BFLVRL-DFsTWA56zLJsRcn_dZhVdCChaQs2ZLWiBv3g@mail.gmail.com>
References: <CANUX_P2BFLVRL-DFsTWA56zLJsRcn_dZhVdCChaQs2ZLWiBv3g@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eran Harary <eran.harary@intel.com>

Also handle the bypass mode in which the second CPU doesn't
interfere.

Signed-off-by: Eran Harary <eran.harary@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-csr.h    |   32 -----
 drivers/net/wireless/iwlwifi/iwl-io.c     |   15 +++
 drivers/net/wireless/iwlwifi/iwl-io.h     |    2 +
 drivers/net/wireless/iwlwifi/iwl-prph.h   |   39 ++++++
 drivers/net/wireless/iwlwifi/pcie/trans.c |  191 ++++++++++++++++-------------
 5 files changed, 159 insertions(+), 120 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-csr.h b/drivers/net/wireless/iwlwifi/iwl-csr.h
index 9d32551..f13dec9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-csr.h
+++ b/drivers/net/wireless/iwlwifi/iwl-csr.h
@@ -395,38 +395,6 @@
 #define CSR_DRAM_INT_TBL_ENABLE		(1 << 31)
 #define CSR_DRAM_INIT_TBL_WRAP_CHECK	(1 << 27)
 
-/* SECURE boot registers */
-#define CSR_SECURE_BOOT_CONFIG_ADDR	(0x100)
-enum secure_boot_config_reg {
-	CSR_SECURE_BOOT_CONFIG_INSPECTOR_BURNED_IN_OTP	= 0x00000001,
-	CSR_SECURE_BOOT_CONFIG_INSPECTOR_NOT_REQ	= 0x00000002,
-};
-
-#define CSR_SECURE_BOOT_CPU1_STATUS_ADDR	(0x100)
-#define CSR_SECURE_BOOT_CPU2_STATUS_ADDR	(0x100)
-enum secure_boot_status_reg {
-	CSR_SECURE_BOOT_CPU_STATUS_VERF_STATUS		= 0x00000003,
-	CSR_SECURE_BOOT_CPU_STATUS_VERF_COMPLETED	= 0x00000002,
-	CSR_SECURE_BOOT_CPU_STATUS_VERF_SUCCESS		= 0x00000004,
-	CSR_SECURE_BOOT_CPU_STATUS_VERF_FAIL		= 0x00000008,
-	CSR_SECURE_BOOT_CPU_STATUS_SIGN_VERF_FAIL	= 0x00000010,
-};
-
-#define CSR_UCODE_LOAD_STATUS_ADDR	(0x100)
-enum secure_load_status_reg {
-	CSR_CPU_STATUS_LOADING_STARTED			= 0x00000001,
-	CSR_CPU_STATUS_LOADING_COMPLETED		= 0x00000002,
-	CSR_CPU_STATUS_NUM_OF_LAST_COMPLETED		= 0x000000F8,
-	CSR_CPU_STATUS_NUM_OF_LAST_LOADED_BLOCK		= 0x0000FF00,
-};
-
-#define CSR_SECURE_INSPECTOR_CODE_ADDR	(0x100)
-#define CSR_SECURE_INSPECTOR_DATA_ADDR	(0x100)
-
-#define CSR_SECURE_TIME_OUT	(100)
-
-#define FH_TCSR_0_REG0 (0x1D00)
-
 /*
  * HBUS (Host-side Bus)
  *
diff --git a/drivers/net/wireless/iwlwifi/iwl-io.c b/drivers/net/wireless/iwlwifi/iwl-io.c
index f98175a..07372f2 100644
--- a/drivers/net/wireless/iwlwifi/iwl-io.c
+++ b/drivers/net/wireless/iwlwifi/iwl-io.c
@@ -130,6 +130,21 @@ void iwl_write_prph(struct iwl_trans *trans, u32 ofs, u32 val)
 }
 IWL_EXPORT_SYMBOL(iwl_write_prph);
 
+int iwl_poll_prph_bit(struct iwl_trans *trans, u32 addr,
+		      u32 bits, u32 mask, int timeout)
+{
+	int t = 0;
+
+	do {
+		if ((iwl_read_prph(trans, addr) & mask) == (bits & mask))
+			return t;
+		udelay(IWL_POLL_INTERVAL);
+		t += IWL_POLL_INTERVAL;
+	} while (t < timeout);
+
+	return -ETIMEDOUT;
+}
+
 void iwl_set_bits_prph(struct iwl_trans *trans, u32 ofs, u32 mask)
 {
 	unsigned long flags;
diff --git a/drivers/net/wireless/iwlwifi/iwl-io.h b/drivers/net/wireless/iwlwifi/iwl-io.h
index c339c1b..9e81b23 100644
--- a/drivers/net/wireless/iwlwifi/iwl-io.h
+++ b/drivers/net/wireless/iwlwifi/iwl-io.h
@@ -72,6 +72,8 @@ void iwl_write_direct32(struct iwl_trans *trans, u32 reg, u32 value);
 
 u32 iwl_read_prph(struct iwl_trans *trans, u32 ofs);
 void iwl_write_prph(struct iwl_trans *trans, u32 ofs, u32 val);
+int iwl_poll_prph_bit(struct iwl_trans *trans, u32 addr,
+		      u32 bits, u32 mask, int timeout);
 void iwl_set_bits_prph(struct iwl_trans *trans, u32 ofs, u32 mask);
 void iwl_set_bits_mask_prph(struct iwl_trans *trans, u32 ofs,
 			    u32 bits, u32 mask);
diff --git a/drivers/net/wireless/iwlwifi/iwl-prph.h b/drivers/net/wireless/iwlwifi/iwl-prph.h
index fc3b6be..9c90186 100644
--- a/drivers/net/wireless/iwlwifi/iwl-prph.h
+++ b/drivers/net/wireless/iwlwifi/iwl-prph.h
@@ -288,4 +288,43 @@ static inline unsigned int SCD_QUEUE_STATUS_BITS(unsigned int chnl)
 #define OSC_CLK				(0xa04068)
 #define OSC_CLK_FORCE_CONTROL		(0x8)
 
+/* SECURE boot registers */
+#define LMPM_SECURE_BOOT_CONFIG_ADDR	(0x100)
+enum secure_boot_config_reg {
+	LMPM_SECURE_BOOT_CONFIG_INSPECTOR_BURNED_IN_OTP	= 0x00000001,
+	LMPM_SECURE_BOOT_CONFIG_INSPECTOR_NOT_REQ	= 0x00000002,
+};
+
+#define LMPM_SECURE_BOOT_CPU1_STATUS_ADDR	(0x1E30)
+#define LMPM_SECURE_BOOT_CPU2_STATUS_ADDR	(0x1E34)
+enum secure_boot_status_reg {
+	LMPM_SECURE_BOOT_CPU_STATUS_VERF_STATUS		= 0x00000001,
+	LMPM_SECURE_BOOT_CPU_STATUS_VERF_COMPLETED	= 0x00000002,
+	LMPM_SECURE_BOOT_CPU_STATUS_VERF_SUCCESS	= 0x00000004,
+	LMPM_SECURE_BOOT_CPU_STATUS_VERF_FAIL		= 0x00000008,
+	LMPM_SECURE_BOOT_CPU_STATUS_SIGN_VERF_FAIL	= 0x00000010,
+	LMPM_SECURE_BOOT_STATUS_SUCCESS			= 0x00000003,
+};
+
+#define CSR_UCODE_LOAD_STATUS_ADDR	(0x1E70)
+enum secure_load_status_reg {
+	LMPM_CPU_UCODE_LOADING_STARTED			= 0x00000001,
+	LMPM_CPU_HDRS_LOADING_COMPLETED			= 0x00000003,
+	LMPM_CPU_UCODE_LOADING_COMPLETED		= 0x00000007,
+	LMPM_CPU_STATUS_NUM_OF_LAST_COMPLETED		= 0x000000F8,
+	LMPM_CPU_STATUS_NUM_OF_LAST_LOADED_BLOCK	= 0x0000FF00,
+};
+
+#define LMPM_SECURE_INSPECTOR_CODE_ADDR	(0x1E38)
+#define LMPM_SECURE_INSPECTOR_DATA_ADDR	(0x1E3C)
+#define LMPM_SECURE_UCODE_LOAD_CPU1_HDR_ADDR	(0x1E78)
+#define LMPM_SECURE_UCODE_LOAD_CPU2_HDR_ADDR	(0x1E7C)
+
+#define LMPM_SECURE_INSPECTOR_CODE_MEM_SPACE	(0x400000)
+#define LMPM_SECURE_INSPECTOR_DATA_MEM_SPACE	(0x402000)
+#define LMPM_SECURE_CPU1_HDR_MEM_SPACE		(0x420000)
+#define LMPM_SECURE_CPU2_HDR_MEM_SPACE		(0x420400)
+
+#define LMPM_SECURE_TIME_OUT	(100)
+
 #endif				/* __iwl_prph_h__ */
diff --git a/drivers/net/wireless/iwlwifi/pcie/trans.c b/drivers/net/wireless/iwlwifi/pcie/trans.c
index ff7d70d..7290f42 100644
--- a/drivers/net/wireless/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/iwlwifi/pcie/trans.c
@@ -441,78 +441,87 @@ static int iwl_pcie_load_section(struct iwl_trans *trans, u8 section_num,
 	return ret;
 }
 
-static int iwl_pcie_secure_set(struct iwl_trans *trans, int cpu)
+static int iwl_pcie_load_cpu_secured_sections(struct iwl_trans *trans,
+					      const struct fw_img *image,
+					      int cpu)
 {
 	int shift_param;
-	u32 address;
-	int ret = 0;
+	u32 first_idx, last_idx;
+	int i, ret = 0;
 
 	if (cpu == 1) {
 		shift_param = 0;
-		address = CSR_SECURE_BOOT_CPU1_STATUS_ADDR;
+		first_idx = 0;
+		last_idx = 2;
 	} else {
 		shift_param = 16;
-		address = CSR_SECURE_BOOT_CPU2_STATUS_ADDR;
+		first_idx = 3;
+		last_idx = 5;
 	}
 
-	/* set CPU to started */
-	iwl_trans_set_bits_mask(trans,
-				CSR_UCODE_LOAD_STATUS_ADDR,
-				CSR_CPU_STATUS_LOADING_STARTED << shift_param,
-				1);
-
-	/* set last complete descriptor number */
-	iwl_trans_set_bits_mask(trans,
-				CSR_UCODE_LOAD_STATUS_ADDR,
-				CSR_CPU_STATUS_NUM_OF_LAST_COMPLETED
-				<< shift_param,
-				1);
-
-	/* set last loaded block */
-	iwl_trans_set_bits_mask(trans,
-				CSR_UCODE_LOAD_STATUS_ADDR,
-				CSR_CPU_STATUS_NUM_OF_LAST_LOADED_BLOCK
-				<< shift_param,
-				1);
+	for (i = first_idx; i <= last_idx; i++) {
+		if (!image->sec[i].data)
+			break;
+		if (i == first_idx + 1)
+			/* set CPU to started */
+			iwl_set_bits_prph(trans,
+					  CSR_UCODE_LOAD_STATUS_ADDR,
+					  LMPM_CPU_HDRS_LOADING_COMPLETED
+					  << shift_param);
 
-	/* image loading complete */
-	iwl_trans_set_bits_mask(trans,
-				CSR_UCODE_LOAD_STATUS_ADDR,
-				CSR_CPU_STATUS_LOADING_COMPLETED
-				<< shift_param,
-				1);
-
-	/* set FH_TCSR_0_REG  */
-	iwl_trans_set_bits_mask(trans, FH_TCSR_0_REG0, 0x00400000, 1);
-
-	/* verify image verification started  */
-	ret = iwl_poll_bit(trans, address,
-			   CSR_SECURE_BOOT_CPU_STATUS_VERF_STATUS,
-			   CSR_SECURE_BOOT_CPU_STATUS_VERF_STATUS,
-			   CSR_SECURE_TIME_OUT);
-	if (ret < 0) {
-		IWL_ERR(trans, "secure boot process didn't start\n");
-		return ret;
+		ret = iwl_pcie_load_section(trans, i, &image->sec[i]);
+		if (ret)
+			return ret;
 	}
+	/* image loading complete */
+	iwl_set_bits_prph(trans,
+			  CSR_UCODE_LOAD_STATUS_ADDR,
+			  LMPM_CPU_UCODE_LOADING_COMPLETED << shift_param);
 
-	/* wait for image verification to complete  */
-	ret = iwl_poll_bit(trans, address,
-			   CSR_SECURE_BOOT_CPU_STATUS_VERF_COMPLETED,
-			   CSR_SECURE_BOOT_CPU_STATUS_VERF_COMPLETED,
-			   CSR_SECURE_TIME_OUT);
+	return 0;
+}
 
-	if (ret < 0) {
-		IWL_ERR(trans, "Time out on secure boot process\n");
-		return ret;
+static int iwl_pcie_load_cpu_sections(struct iwl_trans *trans,
+				      const struct fw_img *image,
+				      int cpu)
+{
+	int shift_param;
+	u32 first_idx, last_idx;
+	int i, ret = 0;
+
+	if (cpu == 1) {
+		shift_param = 0;
+		first_idx = 0;
+		last_idx = 1;
+	} else {
+		shift_param = 16;
+		first_idx = 2;
+		last_idx = 3;
 	}
 
+	for (i = first_idx; i <= last_idx; i++) {
+		if (!image->sec[i].data)
+			break;
+		ret = iwl_pcie_load_section(trans, i, &image->sec[i]);
+		if (ret)
+			return ret;
+	}
+
+	if (trans->cfg->device_family == IWL_DEVICE_FAMILY_8000)
+		iwl_set_bits_prph(trans,
+				  CSR_UCODE_LOAD_STATUS_ADDR,
+				  (LMPM_CPU_UCODE_LOADING_COMPLETED |
+				   LMPM_CPU_HDRS_LOADING_COMPLETED |
+				   LMPM_CPU_UCODE_LOADING_STARTED) <<
+					shift_param);
+
 	return 0;
 }
 
 static int iwl_pcie_load_given_ucode(struct iwl_trans *trans,
 				const struct fw_img *image)
 {
-	int i, ret = 0;
+	int ret = 0;
 
 	IWL_DEBUG_FW(trans,
 		     "working with %s image\n",
@@ -524,54 +533,46 @@ static int iwl_pcie_load_given_ucode(struct iwl_trans *trans,
 	/* configure the ucode to be ready to get the secured image */
 	if (image->is_secure) {
 		/* set secure boot inspector addresses */
-		iwl_write32(trans, CSR_SECURE_INSPECTOR_CODE_ADDR, 0);
-		iwl_write32(trans, CSR_SECURE_INSPECTOR_DATA_ADDR, 0);
+		iwl_write_prph(trans,
+			       LMPM_SECURE_INSPECTOR_CODE_ADDR,
+			       LMPM_SECURE_INSPECTOR_CODE_MEM_SPACE);
 
-		/* release CPU1 reset if secure inspector image burned in OTP */
-		iwl_write32(trans, CSR_RESET, 0);
-	}
+		iwl_write_prph(trans,
+			       LMPM_SECURE_INSPECTOR_DATA_ADDR,
+			       LMPM_SECURE_INSPECTOR_DATA_MEM_SPACE);
 
-	/* load to FW the binary sections of CPU1 */
-	IWL_DEBUG_INFO(trans, "Loading CPU1\n");
-	for (i = 0;
-	     i < IWL_UCODE_FIRST_SECTION_OF_SECOND_CPU;
-	     i++) {
-		if (!image->sec[i].data)
-			break;
-		ret = iwl_pcie_load_section(trans, i, &image->sec[i]);
+		/* set CPU1 header address */
+		iwl_write_prph(trans,
+			       LMPM_SECURE_UCODE_LOAD_CPU1_HDR_ADDR,
+			       LMPM_SECURE_CPU1_HDR_MEM_SPACE);
+
+		/* load to FW the binary Secured sections of CPU1 */
+		ret = iwl_pcie_load_cpu_secured_sections(trans, image, 1);
 		if (ret)
 			return ret;
-	}
 
-	/* configure the ucode to start secure process on CPU1 */
-	if (image->is_secure) {
-		/* config CPU1 to start secure protocol */
-		ret = iwl_pcie_secure_set(trans, 1);
+	} else {
+		/* load to FW the binary Non secured sections of CPU1 */
+		ret = iwl_pcie_load_cpu_sections(trans, image, 1);
 		if (ret)
 			return ret;
-	} else {
-		/* Remove all resets to allow NIC to operate */
-		iwl_write32(trans, CSR_RESET, 0);
 	}
 
 	if (image->is_dual_cpus) {
-		/* load to FW the binary sections of CPU2 */
-		IWL_DEBUG_INFO(trans, "working w/ DUAL CPUs - Loading CPU2\n");
-		for (i = IWL_UCODE_FIRST_SECTION_OF_SECOND_CPU;
-			i < IWL_UCODE_SECTION_MAX; i++) {
-			if (!image->sec[i].data)
-				break;
-			ret = iwl_pcie_load_section(trans, i, &image->sec[i]);
-			if (ret)
-				return ret;
-		}
+		/* set CPU2 header address */
+		iwl_write_prph(trans,
+			       LMPM_SECURE_UCODE_LOAD_CPU2_HDR_ADDR,
+			       LMPM_SECURE_CPU2_HDR_MEM_SPACE);
 
-		if (image->is_secure) {
-			/* set CPU2 for secure protocol */
-			ret = iwl_pcie_secure_set(trans, 2);
-			if (ret)
-				return ret;
-		}
+		/* load to FW the binary sections of CPU2 */
+		if (image->is_secure)
+			ret = iwl_pcie_load_cpu_secured_sections(trans,
+								 image,
+								 2);
+		else
+			ret = iwl_pcie_load_cpu_sections(trans, image, 2);
+		if (ret)
+			return ret;
 	}
 
 	/* release CPU reset */
@@ -580,6 +581,20 @@ static int iwl_pcie_load_given_ucode(struct iwl_trans *trans,
 	else
 		iwl_write32(trans, CSR_RESET, 0);
 
+	if (image->is_secure) {
+		/* wait for image verification to complete  */
+		ret = iwl_poll_prph_bit(trans,
+					LMPM_SECURE_BOOT_CPU1_STATUS_ADDR,
+					LMPM_SECURE_BOOT_STATUS_SUCCESS,
+					LMPM_SECURE_BOOT_STATUS_SUCCESS,
+					LMPM_SECURE_TIME_OUT);
+
+		if (ret < 0) {
+			IWL_ERR(trans, "Time out on secure boot process\n");
+			return ret;
+		}
+	}
+
 	return 0;
 }
 
-- 
1.7.9.5

