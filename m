Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:28708 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751022AbbFPFNW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Jun 2015 01:13:22 -0400
From: Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
Subject: [PATCH 02/10] ath10k: Add new reg_address/mask to hw register table
Date: Tue, 16 Jun 2015 10:42:14 +0530
Message-ID: <1434431542-14724-3-git-send-email-vthiagar@qti.qualcomm.com> (sfid-20150616_071326_847163_631CF1A2)
In-Reply-To: <1434431542-14724-1-git-send-email-vthiagar@qti.qualcomm.com>
References: <1434431542-14724-1-git-send-email-vthiagar@qti.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add more register address and mask which can be different
for newer chip to hw_reg table.

Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/ce.h |  6 ++++--
 drivers/net/wireless/ath/ath10k/hw.c | 22 ++++++++++++++++++----
 drivers/net/wireless/ath/ath10k/hw.h | 17 ++++++++++++-----
 3 files changed, 34 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/ce.h b/drivers/net/wireless/ath/ath10k/ce.h
index 0eddb20..93939de 100644
--- a/drivers/net/wireless/ath/ath10k/ce.h
+++ b/drivers/net/wireless/ath/ath10k/ce.h
@@ -423,8 +423,10 @@ static inline u32 ath10k_ce_base_address(struct ath10k *ar, unsigned int ce_id)
 
 #define CE_RING_IDX_INCR(nentries_mask, idx) (((idx) + 1) & (nentries_mask))
 
-#define CE_WRAPPER_INTERRUPT_SUMMARY_HOST_MSI_LSB		8
-#define CE_WRAPPER_INTERRUPT_SUMMARY_HOST_MSI_MASK		0x0000ff00
+#define CE_WRAPPER_INTERRUPT_SUMMARY_HOST_MSI_LSB \
+				ar->regs->ce_wrap_intr_sum_host_msi_lsb
+#define CE_WRAPPER_INTERRUPT_SUMMARY_HOST_MSI_MASK \
+				ar->regs->ce_wrap_intr_sum_host_msi_mask
 #define CE_WRAPPER_INTERRUPT_SUMMARY_HOST_MSI_GET(x) \
 	(((x) & CE_WRAPPER_INTERRUPT_SUMMARY_HOST_MSI_MASK) >> \
 		CE_WRAPPER_INTERRUPT_SUMMARY_HOST_MSI_LSB)
diff --git a/drivers/net/wireless/ath/ath10k/hw.c b/drivers/net/wireless/ath/ath10k/hw.c
index 48bcd2c..cb09867 100644
--- a/drivers/net/wireless/ath/ath10k/hw.c
+++ b/drivers/net/wireless/ath/ath10k/hw.c
@@ -34,8 +34,15 @@ const struct ath10k_hw_regs qca988x_regs = {
 	.ce7_base_address		= 0x00059000,
 	.soc_reset_control_si0_rst_mask	= 0x00000001,
 	.soc_reset_control_ce_rst_mask	= 0x00040000,
-	.soc_chip_id_address		= 0x00ec,
-	.scratch_3_address		= 0x0030,
+	.soc_chip_id_address		= 0x000000ec,
+	.scratch_3_address		= 0x00000030,
+	.fw_indicator_address		= 0x00009030,
+	.pcie_local_base_address	= 0x00080000,
+	.ce_wrap_intr_sum_host_msi_lsb	= 0x00000008,
+	.ce_wrap_intr_sum_host_msi_mask	= 0x0000ff00,
+	.pcie_intr_fw_mask		= 0x00000400,
+	.pcie_intr_ce_mask_all		= 0x0007f800,
+	.pcie_intr_clr_address		= 0x00000014,
 };
 
 const struct ath10k_hw_regs qca6174_regs = {
@@ -54,8 +61,15 @@ const struct ath10k_hw_regs qca6174_regs = {
 	.ce7_base_address			= 0x00036000,
 	.soc_reset_control_si0_rst_mask		= 0x00000000,
 	.soc_reset_control_ce_rst_mask		= 0x00000001,
-	.soc_chip_id_address			= 0x000f0,
-	.scratch_3_address			= 0x0028,
+	.soc_chip_id_address			= 0x000000f0,
+	.scratch_3_address			= 0x00000028,
+	.fw_indicator_address			= 0x00009028,
+	.pcie_local_base_address		= 0x00080000,
+	.ce_wrap_intr_sum_host_msi_lsb		= 0x00000008,
+	.ce_wrap_intr_sum_host_msi_mask		= 0x0000ff00,
+	.pcie_intr_fw_mask			= 0x00000400,
+	.pcie_intr_ce_mask_all			= 0x0007f800,
+	.pcie_intr_clr_address			= 0x00000014,
 };
 
 const struct ath10k_hw_values qca988x_values = {
diff --git a/drivers/net/wireless/ath/ath10k/hw.h b/drivers/net/wireless/ath/ath10k/hw.h
index b218388..5d04317 100644
--- a/drivers/net/wireless/ath/ath10k/hw.h
+++ b/drivers/net/wireless/ath/ath10k/hw.h
@@ -164,6 +164,13 @@ struct ath10k_hw_regs {
 	u32 soc_reset_control_ce_rst_mask;
 	u32 soc_chip_id_address;
 	u32 scratch_3_address;
+	u32 fw_indicator_address;
+	u32 pcie_local_base_address;
+	u32 ce_wrap_intr_sum_host_msi_lsb;
+	u32 ce_wrap_intr_sum_host_msi_mask;
+	u32 pcie_intr_fw_mask;
+	u32 pcie_intr_ce_mask_all;
+	u32 pcie_intr_clr_address;
 };
 
 extern const struct ath10k_hw_regs qca988x_regs;
@@ -386,7 +393,7 @@ enum ath10k_hw_rate_cck {
 #define CE7_BASE_ADDRESS			ar->regs->ce7_base_address
 #define DBI_BASE_ADDRESS			0x00060000
 #define WLAN_ANALOG_INTF_PCIE_BASE_ADDRESS	0x0006c000
-#define PCIE_LOCAL_BASE_ADDRESS			0x00080000
+#define PCIE_LOCAL_BASE_ADDRESS		ar->regs->pcie_local_base_address
 
 #define SOC_RESET_CONTROL_ADDRESS		0x00000000
 #define SOC_RESET_CONTROL_OFFSET		0x00000000
@@ -460,7 +467,7 @@ enum ath10k_hw_rate_cck {
 #define CORE_CTRL_ADDRESS			0x0000
 #define PCIE_INTR_ENABLE_ADDRESS		0x0008
 #define PCIE_INTR_CAUSE_ADDRESS			0x000c
-#define PCIE_INTR_CLR_ADDRESS			0x0014
+#define PCIE_INTR_CLR_ADDRESS			ar->regs->pcie_intr_clr_address
 #define SCRATCH_3_ADDRESS			ar->regs->scratch_3_address
 #define CPU_INTR_ADDRESS			0x0010
 
@@ -468,13 +475,13 @@ enum ath10k_hw_rate_cck {
 #define CCNT_TO_MSEC(x) ((x) / 88000)
 
 /* Firmware indications to the Host via SCRATCH_3 register. */
-#define FW_INDICATOR_ADDRESS	(SOC_CORE_BASE_ADDRESS + SCRATCH_3_ADDRESS)
+#define FW_INDICATOR_ADDRESS			ar->regs->fw_indicator_address
 #define FW_IND_EVENT_PENDING			1
 #define FW_IND_INITIALIZED			2
 
 /* HOST_REG interrupt from firmware */
-#define PCIE_INTR_FIRMWARE_MASK			0x00000400
-#define PCIE_INTR_CE_MASK_ALL			0x0007f800
+#define PCIE_INTR_FIRMWARE_MASK			ar->regs->pcie_intr_fw_mask
+#define PCIE_INTR_CE_MASK_ALL			ar->regs->pcie_intr_ce_mask_all
 
 #define DRAM_BASE_ADDRESS			0x00400000
 
-- 
1.9.1

