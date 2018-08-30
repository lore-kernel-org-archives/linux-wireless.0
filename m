Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:37726 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727270AbeH3G3r (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 30 Aug 2018 02:29:47 -0400
From: Carl Huang <cjhuang@codeaurora.org>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 3/3] ath10k: download firmware via diag Copy Engine for QCA6174 and QCA9377.
Date: Thu, 30 Aug 2018 10:29:42 +0800
Message-Id: <1535596182-18038-4-git-send-email-cjhuang@codeaurora.org> (sfid-20180830_043002_419575_AFAE5304)
In-Reply-To: <1535596182-18038-1-git-send-email-cjhuang@codeaurora.org>
References: <1535596182-18038-1-git-send-email-cjhuang@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Downloading firmware via BMI protocol takes too long time. For example,
a ~700K bytes firmware takes about 500ms to download via BMI protocol.
This is too long especially in suspend and resume scenario where firmware
is re-downloaded unless WoWLAN is enabled. Downloading firmware via diag CE
can reduce the time to ~40ms for a ~700K bytes firmware binary.

Ath10k driver parses the firmware to segments and downloads the segments
to the specified address directly. If the firmware is compressed or has
unsupported segments, ath10k driver will try BMI download again.

It's tested with QCA6174 hw3.2 and
firmware-6.bin_WLAN.RM.4.4.1-00111-QCARMSWP-1. QCA9377 is also affected.

Signed-off-by: Carl Huang <cjhuang@codeaurora.org>
---
 drivers/net/wireless/ath/ath10k/bmi.c  |  23 ++++
 drivers/net/wireless/ath/ath10k/bmi.h  |  31 ++++++
 drivers/net/wireless/ath/ath10k/core.c |  36 +++++--
 drivers/net/wireless/ath/ath10k/hw.c   | 185 +++++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/hw.h   |  19 ++++
 5 files changed, 288 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/bmi.c b/drivers/net/wireless/ath/ath10k/bmi.c
index af4978d..1750b18 100644
--- a/drivers/net/wireless/ath/ath10k/bmi.c
+++ b/drivers/net/wireless/ath/ath10k/bmi.c
@@ -459,3 +459,26 @@ int ath10k_bmi_fast_download(struct ath10k *ar,
 
 	return ret;
 }
+
+int ath10k_bmi_set_start(struct ath10k *ar, u32 address)
+{
+	struct bmi_cmd cmd;
+	u32 cmdlen = sizeof(cmd.id) + sizeof(cmd.set_app_start);
+	int ret;
+
+	if (ar->bmi.done_sent) {
+		ath10k_warn(ar, "bmi set start command disallowed\n");
+		return -EBUSY;
+	}
+
+	cmd.id = __cpu_to_le32(BMI_SET_APP_START);
+	cmd.set_app_start.addr = __cpu_to_le32(address);
+
+	ret = ath10k_hif_exchange_bmi_msg(ar, &cmd, cmdlen, NULL, NULL);
+	if (ret) {
+		ath10k_warn(ar, "unable to set start to the device:%d\n", ret);
+		return ret;
+	}
+
+	return 0;
+}
diff --git a/drivers/net/wireless/ath/ath10k/bmi.h b/drivers/net/wireless/ath/ath10k/bmi.h
index 9a39681..770a19d 100644
--- a/drivers/net/wireless/ath/ath10k/bmi.h
+++ b/drivers/net/wireless/ath/ath10k/bmi.h
@@ -190,6 +190,35 @@ struct bmi_target_info {
 	u32 type;
 };
 
+struct bmi_segmented_file_header {
+	__le32 magic_num;
+	__le32 file_flags;
+	u8 data[];
+};
+
+struct bmi_segmented_metadata {
+	__le32 addr;
+	__le32 length;
+	u8 data[];
+};
+
+#define BMI_SGMTFILE_MAGIC_NUM          0x544d4753 /* "SGMT" */
+#define BMI_SGMTFILE_FLAG_COMPRESS      1
+
+/* Special values for bmi_segmented_metadata.length (all have high bit set) */
+
+/* end of segmented data */
+#define BMI_SGMTFILE_DONE               0xffffffff
+
+/* Board Data segment */
+#define BMI_SGMTFILE_BDDATA             0xfffffffe
+
+/* set beginning address */
+#define BMI_SGMTFILE_BEGINADDR          0xfffffffd
+
+/* immediate function execution */
+#define BMI_SGMTFILE_EXEC               0xfffffffc
+
 /* in jiffies */
 #define BMI_COMMUNICATION_TIMEOUT_HZ (3 * HZ)
 
@@ -239,4 +268,6 @@ int ath10k_bmi_fast_download(struct ath10k *ar, u32 address,
 			     const void *buffer, u32 length);
 int ath10k_bmi_read_soc_reg(struct ath10k *ar, u32 address, u32 *reg_val);
 int ath10k_bmi_write_soc_reg(struct ath10k *ar, u32 address, u32 reg_val);
+int ath10k_bmi_set_start(struct ath10k *ar, u32 address);
+
 #endif /* _BMI_H_ */
diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index c40cd12..78a0515 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -91,6 +91,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 		.rx_ring_fill_level = HTT_RX_RING_FILL_LEVEL,
 		.shadow_reg_support = false,
 		.rri_on_ddr = false,
+		.fw_diag_ce_download = false,
 	},
 	{
 		.id = QCA988X_HW_2_0_VERSION,
@@ -124,6 +125,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 		.per_ce_irq = false,
 		.shadow_reg_support = false,
 		.rri_on_ddr = false,
+		.fw_diag_ce_download = false,
 	},
 	{
 		.id = QCA9887_HW_1_0_VERSION,
@@ -157,6 +159,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 		.per_ce_irq = false,
 		.shadow_reg_support = false,
 		.rri_on_ddr = false,
+		.fw_diag_ce_download = false,
 	},
 	{
 		.id = QCA6174_HW_2_1_VERSION,
@@ -189,6 +192,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 		.per_ce_irq = false,
 		.shadow_reg_support = false,
 		.rri_on_ddr = false,
+		.fw_diag_ce_download = false,
 	},
 	{
 		.id = QCA6174_HW_2_1_VERSION,
@@ -221,6 +225,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 		.per_ce_irq = false,
 		.shadow_reg_support = false,
 		.rri_on_ddr = false,
+		.fw_diag_ce_download = false,
 	},
 	{
 		.id = QCA6174_HW_3_0_VERSION,
@@ -253,6 +258,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 		.per_ce_irq = false,
 		.shadow_reg_support = false,
 		.rri_on_ddr = false,
+		.fw_diag_ce_download = false,
 	},
 	{
 		.id = QCA6174_HW_3_2_VERSION,
@@ -288,6 +294,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 		.per_ce_irq = false,
 		.shadow_reg_support = false,
 		.rri_on_ddr = false,
+		.fw_diag_ce_download = true,
 	},
 	{
 		.id = QCA99X0_HW_2_0_DEV_VERSION,
@@ -326,6 +333,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 		.per_ce_irq = false,
 		.shadow_reg_support = false,
 		.rri_on_ddr = false,
+		.fw_diag_ce_download = false,
 	},
 	{
 		.id = QCA9984_HW_1_0_DEV_VERSION,
@@ -369,6 +377,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 		.per_ce_irq = false,
 		.shadow_reg_support = false,
 		.rri_on_ddr = false,
+		.fw_diag_ce_download = false,
 	},
 	{
 		.id = QCA9888_HW_2_0_DEV_VERSION,
@@ -411,6 +420,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 		.per_ce_irq = false,
 		.shadow_reg_support = false,
 		.rri_on_ddr = false,
+		.fw_diag_ce_download = false,
 	},
 	{
 		.id = QCA9377_HW_1_0_DEV_VERSION,
@@ -443,6 +453,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 		.per_ce_irq = false,
 		.shadow_reg_support = false,
 		.rri_on_ddr = false,
+		.fw_diag_ce_download = false,
 	},
 	{
 		.id = QCA9377_HW_1_1_DEV_VERSION,
@@ -477,6 +488,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 		.per_ce_irq = false,
 		.shadow_reg_support = false,
 		.rri_on_ddr = false,
+		.fw_diag_ce_download = true,
 	},
 	{
 		.id = QCA4019_HW_1_0_DEV_VERSION,
@@ -516,6 +528,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 		.per_ce_irq = false,
 		.shadow_reg_support = false,
 		.rri_on_ddr = false,
+		.fw_diag_ce_download = false,
 	},
 	{
 		.id = WCN3990_HW_1_0_DEV_VERSION,
@@ -539,6 +552,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 		.per_ce_irq = true,
 		.shadow_reg_support = true,
 		.rri_on_ddr = true,
+		.fw_diag_ce_download = false,
 	},
 };
 
@@ -1135,14 +1149,24 @@ static int ath10k_download_fw(struct ath10k *ar)
 		   "boot uploading firmware image %pK len %d\n",
 		   data, data_len);
 
-	ret = ath10k_bmi_fast_download(ar, address, data, data_len);
-	if (ret) {
-		ath10k_err(ar, "failed to download firmware: %d\n",
-			   ret);
-		return ret;
+	/* Check if device supports to download firmware via
+	 * diag copy engine. Downloading firmware via diag CE
+	 * greatly reduces the time to download firmware.
+	 */
+	if (ar->hw_params.fw_diag_ce_download) {
+		ret = ath10k_hw_diag_fast_download(ar, address,
+						   data, data_len);
+		if (ret == 0)
+			/* firmware upload via diag ce was successful */
+			return 0;
+
+		ath10k_warn(ar,
+			    "failed to upload firmware via diag ce, trying BMI: %d",
+			    ret);
 	}
 
-	return ret;
+	return ath10k_bmi_fast_download(ar, address,
+					data, data_len);
 }
 
 static void ath10k_core_free_board_files(struct ath10k *ar)
diff --git a/drivers/net/wireless/ath/ath10k/hw.c b/drivers/net/wireless/ath/ath10k/hw.c
index 677535b..25ee1c6 100644
--- a/drivers/net/wireless/ath/ath10k/hw.c
+++ b/drivers/net/wireless/ath/ath10k/hw.c
@@ -16,6 +16,7 @@
 
 #include <linux/types.h>
 #include <linux/bitops.h>
+#include <linux/bitfield.h>
 #include "core.h"
 #include "hw.h"
 #include "hif.h"
@@ -918,6 +919,190 @@ static int ath10k_hw_qca6174_enable_pll_clock(struct ath10k *ar)
 	return 0;
 }
 
+/* Program CPU_ADDR_MSB to allow different memory
+ * region access.
+ */
+static void ath10k_hw_map_target_mem(struct ath10k *ar, u32 msb)
+{
+	u32 address = SOC_CORE_BASE_ADDRESS + FW_RAM_CONFIG_ADDRESS;
+
+	ath10k_hif_write32(ar, address, msb);
+}
+
+/* 1. Write to memory region of target, such as IRAM adn DRAM.
+ * 2. Target address( 0 ~ 00100000 & 0x00400000~0x00500000)
+ *    can be written directly. See ath10k_pci_targ_cpu_to_ce_addr() too.
+ * 3. In order to access the region other than the above,
+ *    we need to set the value of register CPU_ADDR_MSB.
+ * 4. Target memory access space is limited to 1M size. If the size is larger
+ *    than 1M, need to split it and program CPU_ADDR_MSB accordingly.
+ */
+static int ath10k_hw_diag_segment_msb_download(struct ath10k *ar,
+					       const void *buffer,
+					       u32 address,
+					       u32 length)
+{
+	u32 addr = address & REGION_ACCESS_SIZE_MASK;
+	int ret, remain_size, size;
+	const u8 *buf;
+
+	ath10k_hw_map_target_mem(ar, CPU_ADDR_MSB_REGION_VAL(address));
+
+	if (addr + length > REGION_ACCESS_SIZE_LIMIT) {
+		size = REGION_ACCESS_SIZE_LIMIT - addr;
+		remain_size = length - size;
+
+		ret = ath10k_hif_diag_write(ar, address, buffer, size);
+		if (ret) {
+			ath10k_warn(ar,
+				    "failed to download the first %d bytes segment to address:0x%x: %d\n",
+				    size, address, ret);
+			goto done;
+		}
+
+		/* Change msb to the next memory region*/
+		ath10k_hw_map_target_mem(ar,
+					 CPU_ADDR_MSB_REGION_VAL(address) + 1);
+		buf = buffer +  size;
+		ret = ath10k_hif_diag_write(ar,
+					    address & ~REGION_ACCESS_SIZE_MASK,
+					    buf, remain_size);
+		if (ret) {
+			ath10k_warn(ar,
+				    "failed to download the second %d bytes segment to address:0x%x: %d\n",
+				    remain_size,
+				    address & ~REGION_ACCESS_SIZE_MASK,
+				    ret);
+			goto done;
+		}
+	} else {
+		ret = ath10k_hif_diag_write(ar, address, buffer, length);
+		if (ret) {
+			ath10k_warn(ar,
+				    "failed to download the only %d bytes segment to address:0x%x: %d\n",
+				    length, address, ret);
+			goto done;
+		}
+	}
+
+done:
+	/* Change msb to DRAM */
+	ath10k_hw_map_target_mem(ar,
+				 CPU_ADDR_MSB_REGION_VAL(DRAM_BASE_ADDRESS));
+	return ret;
+}
+
+static int ath10k_hw_diag_segment_download(struct ath10k *ar,
+					   const void *buffer,
+					   u32 address,
+					   u32 length)
+{
+	if (address >= DRAM_BASE_ADDRESS + REGION_ACCESS_SIZE_LIMIT)
+		/* Needs to change MSB for memory write */
+		return ath10k_hw_diag_segment_msb_download(ar, buffer,
+							   address, length);
+	else
+		return ath10k_hif_diag_write(ar, address, buffer, length);
+}
+
+int ath10k_hw_diag_fast_download(struct ath10k *ar,
+				 u32 address,
+				 const void *buffer,
+				 u32 length)
+{
+	const u8 *buf = buffer;
+	bool sgmt_end = false;
+	u32 base_addr = 0;
+	u32 base_len = 0;
+	u32 left = 0;
+	struct bmi_segmented_file_header *hdr;
+	struct bmi_segmented_metadata *metadata;
+	int ret = 0;
+
+	if (length < sizeof(*hdr))
+		return -EINVAL;
+
+	/* check firmware header. If it has no correct magic number
+	 * or it's compressed, returns error.
+	 */
+	hdr = (struct bmi_segmented_file_header *)buf;
+	if (hdr->magic_num != BMI_SGMTFILE_MAGIC_NUM) {
+		ath10k_dbg(ar, ATH10K_DBG_BOOT,
+			   "Not a supported firmware, magic_num:0x%x\n",
+			   hdr->magic_num);
+		return -EINVAL;
+	}
+
+	if (hdr->file_flags != 0) {
+		ath10k_dbg(ar, ATH10K_DBG_BOOT,
+			   "Not a supported firmware, file_flags:0x%x\n",
+			   hdr->file_flags);
+		return -EINVAL;
+	}
+
+	metadata = (struct bmi_segmented_metadata *)hdr->data;
+	left = length - sizeof(*hdr);
+
+	while (left > 0) {
+		base_addr = metadata->addr;
+		base_len = metadata->length;
+		buf = metadata->data;
+		left -= sizeof(*metadata);
+
+		switch (base_len) {
+		case BMI_SGMTFILE_BEGINADDR:
+			/* base_addr is the start address to run */
+			ret = ath10k_bmi_set_start(ar, base_addr);
+			base_len = 0;
+			break;
+		case BMI_SGMTFILE_DONE:
+			/* no more segment */
+			base_len = 0;
+			sgmt_end = true;
+			ret = 0;
+			break;
+		case BMI_SGMTFILE_BDDATA:
+		case BMI_SGMTFILE_EXEC:
+			ath10k_warn(ar,
+				    "firmware has unsupported segment:%d\n",
+				    base_len);
+			ret = -EINVAL;
+			break;
+		default:
+			if (base_len > left) {
+				/* sanity check */
+				ath10k_warn(ar,
+					    "firmware has invalid segment length, %d > %d\n",
+					    base_len, left);
+				ret = -EINVAL;
+				break;
+			}
+
+			ret = ath10k_hw_diag_segment_download(ar,
+							      buf,
+							      base_addr,
+							      base_len);
+
+			if (ret)
+				ath10k_warn(ar,
+					    "failed to download firmware via diag interface:%d\n",
+					    ret);
+			break;
+		}
+
+		if (ret || sgmt_end)
+			break;
+
+		metadata = (struct bmi_segmented_metadata *)(buf + base_len);
+		left -= base_len;
+	}
+
+	if (ret == 0)
+		ath10k_dbg(ar, ATH10K_DBG_BOOT,
+			   "boot firmware fast diag download successfully.\n");
+	return ret;
+}
+
 const struct ath10k_hw_ops qca988x_ops = {
 	.set_coverage_class = ath10k_hw_qca988x_set_coverage_class,
 };
diff --git a/drivers/net/wireless/ath/ath10k/hw.h b/drivers/net/wireless/ath/ath10k/hw.h
index 977f79e..1598315 100644
--- a/drivers/net/wireless/ath/ath10k/hw.h
+++ b/drivers/net/wireless/ath/ath10k/hw.h
@@ -389,6 +389,11 @@ extern const struct ath10k_hw_ce_regs qcax_ce_regs;
 void ath10k_hw_fill_survey_time(struct ath10k *ar, struct survey_info *survey,
 				u32 cc, u32 rcc, u32 cc_prev, u32 rcc_prev);
 
+int ath10k_hw_diag_fast_download(struct ath10k *ar,
+				 u32 address,
+				 const void *buffer,
+				 u32 length);
+
 #define QCA_REV_988X(ar) ((ar)->hw_rev == ATH10K_HW_QCA988X)
 #define QCA_REV_9887(ar) ((ar)->hw_rev == ATH10K_HW_QCA9887)
 #define QCA_REV_6174(ar) ((ar)->hw_rev == ATH10K_HW_QCA6174)
@@ -589,6 +594,9 @@ struct ath10k_hw_params {
 
 	/* Number of bytes to be the offset for each FFT sample */
 	int spectral_bin_offset;
+
+	/* target supporting fw download via diag ce */
+	bool fw_diag_ce_download;
 };
 
 struct htt_rx_desc;
@@ -1124,4 +1132,15 @@ ath10k_rx_desc_get_l3_pad_bytes(struct ath10k_hw_params *hw,
 #define RTC_SYNC_STATUS_PLL_CHANGING_MASK	0x00000020
 /* qca6174 PLL offset/mask end */
 
+/* CPU_ADDR_MSB is a register, bit[3:0] is to specify which memory
+ * region is accessed. The memory region size is 1M.
+ * If host wants to access 0xX12345 at target, then CPU_ADDR_MSB[3:0]
+ * is 0xX.
+ * The following MACROs are defined to get the 0xX and the size limit.
+ */
+#define CPU_ADDR_MSB_REGION_MASK	GENMASK(23, 20)
+#define CPU_ADDR_MSB_REGION_VAL(X)	FIELD_GET(CPU_ADDR_MSB_REGION_MASK, X)
+#define REGION_ACCESS_SIZE_LIMIT	0x100000
+#define REGION_ACCESS_SIZE_MASK		(REGION_ACCESS_SIZE_LIMIT - 1)
+
 #endif /* _HW_H_ */
-- 
2.7.4
