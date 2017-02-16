Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:34732 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753461AbdBPAef (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 15 Feb 2017 19:34:35 -0500
From: <ryanhsu@qca.qualcomm.com>
To: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
CC: <lenb@kernel.org>, <ryanhsu@qca.qualcomm.com>
Subject: [PATCH v2 1/2] ath10k: improve the firmware download time for QCA6174
Date: Wed, 15 Feb 2017 16:33:29 -0800
Message-ID: <1487205210-17112-1-git-send-email-ryanhsu@qca.qualcomm.com> (sfid-20170216_013457_325236_5DC3746C)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ryan Hsu <ryanhsu@qca.qualcomm.com>

Len Brown reported the system resume time is taking more than 2 seconds in
bug - https://bugzilla.kernel.org/show_bug.cgi?id=185621.

The reason of the 2 seconds is due to the firmware download time.

The chip is booted up in the default reference clock speed to handle the
firmware download to chip memory and advanced to the support higher speed
clock to run the firmware after all. The default reference clock in the
hardware is slow so that the firmware download time is taking up to 2
seconds for a 600KB firmware file.

	[76796.349701] ath10k_pci : boot uploading firmware image len 688691
	[76798.334612] ath10k_pci : htt tx max num pending tx 1056

The resolution here is to enable the higher speed clock if the hardware
supported before the firmware download at BMI stage, so that the hardware
can handle the firmare download in a more efficient way. This can help to
improve the firmware download time from 2 seconds to around 500ms for the
same 600KB firmware file.

	[322858.577919] ath10k_pci boot uploading firmware image len 688691
	[322859.093094] ath10k_pci htt tx max num pending tx 1056

The steps to advance to the higher speed clock is very hardware specific,
so adding the hardware ops for the hardware that can support this.

Reported-by: Len Brown <lenb@kernel.org>
Signed-off-by: Ryan Hsu <ryanhsu@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/bmi.c  |  72 +++++++++
 drivers/net/wireless/ath/ath10k/bmi.h  |   2 +
 drivers/net/wireless/ath/ath10k/core.c |   4 +-
 drivers/net/wireless/ath/ath10k/hw.c   | 265 +++++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/hw.h   |  69 +++++++++
 5 files changed, 411 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/bmi.c b/drivers/net/wireless/ath/ath10k/bmi.c
index 2872d34..abeee20 100644
--- a/drivers/net/wireless/ath/ath10k/bmi.c
+++ b/drivers/net/wireless/ath/ath10k/bmi.c
@@ -19,12 +19,21 @@
 #include "hif.h"
 #include "debug.h"
 #include "htc.h"
+#include "hw.h"
 
 void ath10k_bmi_start(struct ath10k *ar)
 {
+	int ret;
+
 	ath10k_dbg(ar, ATH10K_DBG_BMI, "bmi start\n");
 
 	ar->bmi.done_sent = false;
+
+	/* Enable hardware clock to speed up firmware download */
+	if (ar->hw_params.hw_ops->enable_pll_clk) {
+		ret = ar->hw_params.hw_ops->enable_pll_clk(ar);
+		ath10k_dbg(ar, ATH10K_DBG_BMI, "bmi enable pll ret %d\n", ret);
+	}
 }
 
 int ath10k_bmi_done(struct ath10k *ar)
@@ -129,6 +138,69 @@ int ath10k_bmi_read_memory(struct ath10k *ar,
 	return 0;
 }
 
+int ath10k_bmi_write_soc_reg(struct ath10k *ar, u32 address, u32 reg_val)
+{
+	struct bmi_cmd cmd;
+	u32 cmdlen = sizeof(cmd.id) + sizeof(cmd.write_soc_reg);
+	int ret;
+
+	ath10k_dbg(ar, ATH10K_DBG_BMI,
+		   "bmi write soc register 0x%08x val 0x%08x\n",
+		   address, reg_val);
+
+	if (ar->bmi.done_sent) {
+		ath10k_warn(ar, "bmi write soc register command in progress\n");
+		return -EBUSY;
+	}
+
+	cmd.id = __cpu_to_le32(BMI_WRITE_SOC_REGISTER);
+	cmd.write_soc_reg.addr = __cpu_to_le32(address);
+	cmd.write_soc_reg.value = __cpu_to_le32(reg_val);
+
+	ret = ath10k_hif_exchange_bmi_msg(ar, &cmd, cmdlen, NULL, NULL);
+	if (ret) {
+		ath10k_warn(ar, "Unable to write soc register to device: %d\n",
+			    ret);
+		return ret;
+	}
+
+	return 0;
+}
+
+int ath10k_bmi_read_soc_reg(struct ath10k *ar, u32 address, u32 *reg_val)
+{
+	struct bmi_cmd cmd;
+	union bmi_resp resp;
+	u32 cmdlen = sizeof(cmd.id) + sizeof(cmd.read_soc_reg);
+	u32 resplen = sizeof(resp.read_soc_reg);
+	int ret;
+
+	ath10k_dbg(ar, ATH10K_DBG_BMI, "bmi read soc register 0x%08x\n",
+		   address);
+
+	if (ar->bmi.done_sent) {
+		ath10k_warn(ar, "bmi read soc register command in progress\n");
+		return -EBUSY;
+	}
+
+	cmd.id = __cpu_to_le32(BMI_READ_SOC_REGISTER);
+	cmd.read_soc_reg.addr = __cpu_to_le32(address);
+
+	ret = ath10k_hif_exchange_bmi_msg(ar, &cmd, cmdlen, &resp, &resplen);
+	if (ret) {
+		ath10k_warn(ar, "Unable to read soc register from device: %d\n",
+			    ret);
+		return ret;
+	}
+
+	*reg_val = __le32_to_cpu(resp.read_soc_reg.value);
+
+	ath10k_dbg(ar, ATH10K_DBG_BMI, "bmi read soc register value 0x%08x\n",
+		   *reg_val);
+
+	return 0;
+}
+
 int ath10k_bmi_write_memory(struct ath10k *ar,
 			    u32 address, const void *buffer, u32 length)
 {
diff --git a/drivers/net/wireless/ath/ath10k/bmi.h b/drivers/net/wireless/ath/ath10k/bmi.h
index 7d3231a..a65f262 100644
--- a/drivers/net/wireless/ath/ath10k/bmi.h
+++ b/drivers/net/wireless/ath/ath10k/bmi.h
@@ -232,4 +232,6 @@ int ath10k_bmi_write_memory(struct ath10k *ar, u32 address,
 int ath10k_bmi_lz_data(struct ath10k *ar, const void *buffer, u32 length);
 int ath10k_bmi_fast_download(struct ath10k *ar, u32 address,
 			     const void *buffer, u32 length);
+int ath10k_bmi_read_soc_reg(struct ath10k *ar, u32 address, u32 *reg_val);
+int ath10k_bmi_write_soc_reg(struct ath10k *ar, u32 address, u32 reg_val);
 #endif /* _BMI_H_ */
diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index 014a87e..c6de267 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -166,7 +166,9 @@
 			.board_size = QCA6174_BOARD_DATA_SZ,
 			.board_ext_size = QCA6174_BOARD_EXT_DATA_SZ,
 		},
-		.hw_ops = &qca988x_ops,
+		.hw_ops = &qca6174_ops,
+		.hw_clk = qca6174_clk,
+		.target_cpu_freq = 176000000,
 		.decap_align_bytes = 4,
 	},
 	{
diff --git a/drivers/net/wireless/ath/ath10k/hw.c b/drivers/net/wireless/ath/ath10k/hw.c
index 33fb268..85582bd 100644
--- a/drivers/net/wireless/ath/ath10k/hw.c
+++ b/drivers/net/wireless/ath/ath10k/hw.c
@@ -19,6 +19,7 @@
 #include "hw.h"
 #include "hif.h"
 #include "wmi-ops.h"
+#include "bmi.h"
 
 const struct ath10k_hw_regs qca988x_regs = {
 	.rtc_soc_base_address		= 0x00004000,
@@ -72,6 +73,9 @@
 	.pcie_intr_fw_mask			= 0x00000400,
 	.pcie_intr_ce_mask_all			= 0x0007f800,
 	.pcie_intr_clr_address			= 0x00000014,
+	.cpu_pll_init_address			= 0x00404020,
+	.cpu_speed_address			= 0x00404024,
+	.core_clk_div_address			= 0x00404028,
 };
 
 const struct ath10k_hw_regs qca99x0_regs = {
@@ -187,6 +191,73 @@
 	.ce_desc_meta_data_lsb          = 4,
 };
 
+const struct ath10k_hw_clk_params qca6174_clk[ATH10K_HW_REFCLK_COUNT] = {
+	{
+		.refclk = 48000000,
+		.div = 0xe,
+		.rnfrac = 0x2aaa8,
+		.settle_time = 2400,
+		.refdiv = 0,
+		.outdiv = 1,
+	},
+	{
+		.refclk = 19200000,
+		.div = 0x24,
+		.rnfrac = 0x2aaa8,
+		.settle_time = 960,
+		.refdiv = 0,
+		.outdiv = 1,
+	},
+	{
+		.refclk = 24000000,
+		.div = 0x1d,
+		.rnfrac = 0x15551,
+		.settle_time = 1200,
+		.refdiv = 0,
+		.outdiv = 1,
+	},
+	{
+		.refclk = 26000000,
+		.div = 0x1b,
+		.rnfrac = 0x4ec4,
+		.settle_time = 1300,
+		.refdiv = 0,
+		.outdiv = 1,
+	},
+	{
+		.refclk = 37400000,
+		.div = 0x12,
+		.rnfrac = 0x34b49,
+		.settle_time = 1870,
+		.refdiv = 0,
+		.outdiv = 1,
+	},
+	{
+		.refclk = 38400000,
+		.div = 0x12,
+		.rnfrac = 0x15551,
+		.settle_time = 1920,
+		.refdiv = 0,
+		.outdiv = 1,
+	},
+	{
+		.refclk = 40000000,
+		.div = 0x12,
+		.rnfrac = 0x26665,
+		.settle_time = 2000,
+		.refdiv = 0,
+		.outdiv = 1,
+	},
+	{
+		.refclk = 52000000,
+		.div = 0x1b,
+		.rnfrac = 0x4ec4,
+		.settle_time = 2600,
+		.refdiv = 0,
+		.outdiv = 1,
+	},
+};
+
 void ath10k_hw_fill_survey_time(struct ath10k *ar, struct survey_info *survey,
 				u32 cc, u32 rcc, u32 cc_prev, u32 rcc_prev)
 {
@@ -361,6 +432,195 @@ static void ath10k_hw_qca988x_set_coverage_class(struct ath10k *ar,
 	mutex_unlock(&ar->conf_mutex);
 }
 
+/**
+ * ath10k_hw_qca6174_enable_pll_clock() - enable the qca6174 hw pll clock
+ * @ar: the ath10k blob
+ *
+ * This function is very hardware specific, the clock initialization
+ * steps is very sensitive and could lead to unknown crash, so they
+ * should be done in sequence.
+ *
+ * *** Be aware if you planned to refactor them. ***
+ *
+ * Return: 0 if successfully enable the pll, otherwise EINVAL
+ */
+static int ath10k_hw_qca6174_enable_pll_clock(struct ath10k *ar)
+{
+	int ret, wait_limit;
+	u32 clk_div_addr, pll_init_addr, speed_addr;
+	u32 addr, reg_val, mem_val;
+	struct ath10k_hw_params *hw;
+	const struct ath10k_hw_clk_params *hw_clk;
+
+	hw = &ar->hw_params;
+
+	if (ar->regs->core_clk_div_address == 0 ||
+	    ar->regs->cpu_pll_init_address == 0 ||
+	    ar->regs->cpu_speed_address == 0)
+		return -EINVAL;
+
+	clk_div_addr = ar->regs->core_clk_div_address;
+	pll_init_addr = ar->regs->cpu_pll_init_address;
+	speed_addr = ar->regs->cpu_speed_address;
+
+	/* Read efuse register to find out the right hw clock configuration */
+	addr = (RTC_SOC_BASE_ADDRESS | EFUSE_OFFSET);
+	ret = ath10k_bmi_read_soc_reg(ar, addr, &reg_val);
+	if (ret)
+		return -EINVAL;
+
+	/* sanitize if the hw refclk index is out of the boundary */
+	if (MS(reg_val, EFUSE_XTAL_SEL) > ATH10K_HW_REFCLK_COUNT)
+		return -EINVAL;
+
+	hw_clk = &hw->hw_clk[MS(reg_val, EFUSE_XTAL_SEL)];
+
+	/* Set the rnfrac and outdiv params to bb_pll register */
+	addr = (RTC_SOC_BASE_ADDRESS | BB_PLL_CONFIG_OFFSET);
+	ret = ath10k_bmi_read_soc_reg(ar, addr, &reg_val);
+	if (ret)
+		return -EINVAL;
+
+	reg_val &= ~(BB_PLL_CONFIG_FRAC_MASK | BB_PLL_CONFIG_OUTDIV_MASK);
+	reg_val |= (SM(hw_clk->rnfrac, BB_PLL_CONFIG_FRAC) |
+		    SM(hw_clk->outdiv, BB_PLL_CONFIG_OUTDIV));
+	ret = ath10k_bmi_write_soc_reg(ar, addr, reg_val);
+	if (ret)
+		return -EINVAL;
+
+	/* Set the correct settle time value to pll_settle register */
+	addr = (RTC_WMAC_BASE_ADDRESS | WLAN_PLL_SETTLE_OFFSET);
+	ret = ath10k_bmi_read_soc_reg(ar, addr, &reg_val);
+	if (ret)
+		return -EINVAL;
+
+	reg_val &= ~WLAN_PLL_SETTLE_TIME_MASK;
+	reg_val |= SM(hw_clk->settle_time, WLAN_PLL_SETTLE_TIME);
+	ret = ath10k_bmi_write_soc_reg(ar, addr, reg_val);
+	if (ret)
+		return -EINVAL;
+
+	/* Set the clock_ctrl div to core_clk_ctrl register */
+	addr = (RTC_SOC_BASE_ADDRESS | SOC_CORE_CLK_CTRL_OFFSET);
+	ret = ath10k_bmi_read_soc_reg(ar, addr, &reg_val);
+	if (ret)
+		return -EINVAL;
+
+	reg_val &= ~SOC_CORE_CLK_CTRL_DIV_MASK;
+	reg_val |= SM(1, SOC_CORE_CLK_CTRL_DIV);
+	ret = ath10k_bmi_write_soc_reg(ar, addr, reg_val);
+	if (ret)
+		return -EINVAL;
+
+	/* Set the clock_div register */
+	mem_val = 1;
+	ret = ath10k_bmi_write_memory(ar, clk_div_addr, &mem_val,
+				      sizeof(mem_val));
+	if (ret)
+		return -EINVAL;
+
+	/* Configure the pll_control register */
+	addr = (RTC_WMAC_BASE_ADDRESS | WLAN_PLL_CONTROL_OFFSET);
+	ret = ath10k_bmi_read_soc_reg(ar, addr, &reg_val);
+	if (ret)
+		return -EINVAL;
+
+	reg_val |= (SM(hw_clk->refdiv, WLAN_PLL_CONTROL_REFDIV) |
+		    SM(hw_clk->div, WLAN_PLL_CONTROL_DIV) |
+		    SM(1, WLAN_PLL_CONTROL_NOPWD));
+	ret = ath10k_bmi_write_soc_reg(ar, addr, reg_val);
+	if (ret)
+		return -EINVAL;
+
+	/* busy wait (max 1s) the rtc_sync status register indicate ready */
+	wait_limit = 100000;
+	addr = (RTC_WMAC_BASE_ADDRESS | RTC_SYNC_STATUS_OFFSET);
+	do {
+		ret = ath10k_bmi_read_soc_reg(ar, addr, &reg_val);
+		if (ret)
+			return -EINVAL;
+
+		if (!MS(reg_val, RTC_SYNC_STATUS_PLL_CHANGING))
+			break;
+
+		wait_limit--;
+		udelay(10);
+
+	} while (wait_limit > 0);
+
+	if (MS(reg_val, RTC_SYNC_STATUS_PLL_CHANGING))
+		return -EINVAL;
+
+	/* Unset the pll_bypass in pll_control register */
+	addr = (RTC_WMAC_BASE_ADDRESS | WLAN_PLL_CONTROL_OFFSET);
+	ret = ath10k_bmi_read_soc_reg(ar, addr, &reg_val);
+	if (ret)
+		return -EINVAL;
+
+	reg_val &= ~WLAN_PLL_CONTROL_BYPASS_MASK;
+	reg_val |= SM(0, WLAN_PLL_CONTROL_BYPASS);
+	ret = ath10k_bmi_write_soc_reg(ar, addr, reg_val);
+	if (ret)
+		return -EINVAL;
+
+	/* busy wait (max 1s) the rtc_sync status register indicate ready */
+	wait_limit = 100000;
+	addr = (RTC_WMAC_BASE_ADDRESS | RTC_SYNC_STATUS_OFFSET);
+	do {
+		ret = ath10k_bmi_read_soc_reg(ar, addr, &reg_val);
+		if (ret)
+			return -EINVAL;
+
+		if (!MS(reg_val, RTC_SYNC_STATUS_PLL_CHANGING))
+			break;
+
+		wait_limit--;
+		udelay(10);
+
+	} while (wait_limit > 0);
+
+	if (MS(reg_val, RTC_SYNC_STATUS_PLL_CHANGING))
+		return -EINVAL;
+
+	/* Enable the hardware cpu clock register */
+	addr = (RTC_SOC_BASE_ADDRESS | SOC_CPU_CLOCK_OFFSET);
+	ret = ath10k_bmi_read_soc_reg(ar, addr, &reg_val);
+	if (ret)
+		return -EINVAL;
+
+	reg_val &= ~SOC_CPU_CLOCK_STANDARD_MASK;
+	reg_val |= SM(1, SOC_CPU_CLOCK_STANDARD);
+	ret = ath10k_bmi_write_soc_reg(ar, addr, reg_val);
+	if (ret)
+		return -EINVAL;
+
+	/* unset the nopwd from pll_control register */
+	addr = (RTC_WMAC_BASE_ADDRESS | WLAN_PLL_CONTROL_OFFSET);
+	ret = ath10k_bmi_read_soc_reg(ar, addr, &reg_val);
+	if (ret)
+		return -EINVAL;
+
+	reg_val &= ~WLAN_PLL_CONTROL_NOPWD_MASK;
+	ret = ath10k_bmi_write_soc_reg(ar, addr, reg_val);
+	if (ret)
+		return -EINVAL;
+
+	/* enable the pll_init register */
+	mem_val = 1;
+	ret = ath10k_bmi_write_memory(ar, pll_init_addr, &mem_val,
+				      sizeof(mem_val));
+	if (ret)
+		return -EINVAL;
+
+	/* set the target clock frequency to speed register */
+	ret = ath10k_bmi_write_memory(ar, speed_addr, &hw->target_cpu_freq,
+				      sizeof(hw->target_cpu_freq));
+	if (ret)
+		return -EINVAL;
+
+	return 0;
+}
+
 const struct ath10k_hw_ops qca988x_ops = {
 	.set_coverage_class = ath10k_hw_qca988x_set_coverage_class,
 };
@@ -374,3 +634,8 @@ static int ath10k_qca99x0_rx_desc_get_l3_pad_bytes(struct htt_rx_desc *rxd)
 const struct ath10k_hw_ops qca99x0_ops = {
 	.rx_desc_get_l3_pad_bytes = ath10k_qca99x0_rx_desc_get_l3_pad_bytes,
 };
+
+const struct ath10k_hw_ops qca6174_ops = {
+	.set_coverage_class = ath10k_hw_qca988x_set_coverage_class,
+	.enable_pll_clk = ath10k_hw_qca6174_enable_pll_clock,
+};
diff --git a/drivers/net/wireless/ath/ath10k/hw.h b/drivers/net/wireless/ath/ath10k/hw.h
index 38aa7c9..1ca1278 100644
--- a/drivers/net/wireless/ath/ath10k/hw.h
+++ b/drivers/net/wireless/ath/ath10k/hw.h
@@ -251,6 +251,9 @@ struct ath10k_hw_regs {
 	u32 pcie_intr_fw_mask;
 	u32 pcie_intr_ce_mask_all;
 	u32 pcie_intr_clr_address;
+	u32 cpu_pll_init_address;
+	u32 cpu_speed_address;
+	u32 core_clk_div_address;
 };
 
 extern const struct ath10k_hw_regs qca988x_regs;
@@ -359,6 +362,30 @@ enum ath10k_hw_cc_wraparound_type {
 	ATH10K_HW_CC_WRAP_SHIFTED_EACH = 2,
 };
 
+enum ath10k_hw_refclk_speed {
+	ATH10K_HW_REFCLK_UNKNOWN = -1,
+	ATH10K_HW_REFCLK_48_MHZ = 0,
+	ATH10K_HW_REFCLK_19_2_MHZ = 1,
+	ATH10K_HW_REFCLK_24_MHZ = 2,
+	ATH10K_HW_REFCLK_26_MHZ = 3,
+	ATH10K_HW_REFCLK_37_4_MHZ = 4,
+	ATH10K_HW_REFCLK_38_4_MHZ = 5,
+	ATH10K_HW_REFCLK_40_MHZ = 6,
+	ATH10K_HW_REFCLK_52_MHZ = 7,
+
+	/* must be the last one */
+	ATH10K_HW_REFCLK_COUNT,
+};
+
+struct ath10k_hw_clk_params {
+	u32 refclk;
+	u32 div;
+	u32 rnfrac;
+	u32 settle_time;
+	u32 refdiv;
+	u32 outdiv;
+};
+
 struct ath10k_hw_params {
 	u32 id;
 	u16 dev_id;
@@ -412,6 +439,10 @@ struct ath10k_hw_params {
 
 	/* Number of bytes used for alignment in rx_hdr_status of rx desc. */
 	int decap_align_bytes;
+
+	/* hw specific clock control parameters */
+	const struct ath10k_hw_clk_params *hw_clk;
+	int target_cpu_freq;
 };
 
 struct htt_rx_desc;
@@ -420,10 +451,14 @@ struct ath10k_hw_params {
 struct ath10k_hw_ops {
 	int (*rx_desc_get_l3_pad_bytes)(struct htt_rx_desc *rxd);
 	void (*set_coverage_class)(struct ath10k *ar, s16 value);
+	int (*enable_pll_clk)(struct ath10k *ar);
 };
 
 extern const struct ath10k_hw_ops qca988x_ops;
 extern const struct ath10k_hw_ops qca99x0_ops;
+extern const struct ath10k_hw_ops qca6174_ops;
+
+extern const struct ath10k_hw_clk_params qca6174_clk[];
 
 static inline int
 ath10k_rx_desc_get_l3_pad_bytes(struct ath10k_hw_params *hw,
@@ -843,4 +878,38 @@ struct ath10k_hw_ops {
 #define WAVE1_PHYCLK_USEC_MASK			0x0000007F
 #define WAVE1_PHYCLK_USEC_LSB			0
 
+/* qca6174 PLL offset/mask */
+#define SOC_CORE_CLK_CTRL_OFFSET		0x00000114
+#define SOC_CORE_CLK_CTRL_DIV_LSB		0
+#define SOC_CORE_CLK_CTRL_DIV_MASK		0x00000007
+
+#define EFUSE_OFFSET				0x0000032c
+#define EFUSE_XTAL_SEL_LSB			8
+#define EFUSE_XTAL_SEL_MASK			0x00000700
+
+#define BB_PLL_CONFIG_OFFSET			0x000002f4
+#define BB_PLL_CONFIG_FRAC_LSB			0
+#define BB_PLL_CONFIG_FRAC_MASK			0x0003ffff
+#define BB_PLL_CONFIG_OUTDIV_LSB		18
+#define BB_PLL_CONFIG_OUTDIV_MASK		0x001c0000
+
+#define WLAN_PLL_SETTLE_OFFSET			0x0018
+#define WLAN_PLL_SETTLE_TIME_LSB		0
+#define WLAN_PLL_SETTLE_TIME_MASK		0x000007ff
+
+#define WLAN_PLL_CONTROL_OFFSET			0x0014
+#define WLAN_PLL_CONTROL_DIV_LSB		0
+#define WLAN_PLL_CONTROL_DIV_MASK		0x000003ff
+#define WLAN_PLL_CONTROL_REFDIV_LSB		10
+#define WLAN_PLL_CONTROL_REFDIV_MASK		0x00003c00
+#define WLAN_PLL_CONTROL_BYPASS_LSB		16
+#define WLAN_PLL_CONTROL_BYPASS_MASK		0x00010000
+#define WLAN_PLL_CONTROL_NOPWD_LSB		18
+#define WLAN_PLL_CONTROL_NOPWD_MASK		0x00040000
+
+#define RTC_SYNC_STATUS_OFFSET			0x0244
+#define RTC_SYNC_STATUS_PLL_CHANGING_LSB	5
+#define RTC_SYNC_STATUS_PLL_CHANGING_MASK	0x00000020
+/* qca6174 PLL offset/mask end */
+
 #endif /* _HW_H_ */
-- 
1.9.1
