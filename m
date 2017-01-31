Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:57105 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751449AbdAaSl5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 31 Jan 2017 13:41:57 -0500
From: Ashok Raj Nagarajan <arnagara@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>, <arnagara@codeaurora.org>,
        "Ashok Raj Nagarajan" <arnagara@qti.qualcomm.com>
Subject: [PATCH] ath10k: fix reading sram contents for QCA4019
Date: Wed, 1 Feb 2017 00:06:51 +0530
Message-ID: <1485887811-23313-1-git-send-email-arnagara@qti.qualcomm.com> (sfid-20170131_194200_843472_A2A72910)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

With QCA4019 platform, SRAM address can be accessed directly from host but
currently, we are assuming sram addresses cannot be accessed directly and
hence we convert the addresses.

While there, clean up growing hw checks during conversion of target CPU
address to CE address. Now we have function pointer pertaining to different
chips.

Signed-off-by: Ashok Raj Nagarajan <arnagara@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/ahb.c | 23 ++++++++++++++++
 drivers/net/wireless/ath/ath10k/pci.c | 51 ++++++++++++++++++++++-------------
 drivers/net/wireless/ath/ath10k/pci.h |  5 ++++
 3 files changed, 60 insertions(+), 19 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/ahb.c b/drivers/net/wireless/ath/ath10k/ahb.c
index 766c63b..45226db 100644
--- a/drivers/net/wireless/ath/ath10k/ahb.c
+++ b/drivers/net/wireless/ath/ath10k/ahb.c
@@ -33,6 +33,9 @@
 
 MODULE_DEVICE_TABLE(of, ath10k_ahb_of_match);
 
+#define QCA4019_SRAM_ADDR      0x000C0000
+#define QCA4019_SRAM_LEN       0x00040000 /* 256 kb */
+
 static inline struct ath10k_ahb *ath10k_ahb_priv(struct ath10k *ar)
 {
 	return &((struct ath10k_pci *)ar->drv_priv)->ahb[0];
@@ -699,6 +702,25 @@ static int ath10k_ahb_hif_power_up(struct ath10k *ar)
 	return ret;
 }
 
+static u32 ath10k_ahb_qca4019_targ_cpu_to_ce_addr(struct ath10k *ar, u32 addr)
+{
+	u32 val = 0, region = addr & 0xfffff;
+
+	val = ath10k_pci_read32(ar, PCIE_BAR_REG_ADDRESS);
+
+	if (region >= QCA4019_SRAM_ADDR && region <=
+	    (QCA4019_SRAM_ADDR + QCA4019_SRAM_LEN)) {
+		/* SRAM contents for QCA4019 can be directly accessed and
+		 * no conversions are required
+		 */
+		val |= region;
+	} else {
+		val |= 0x100000 | region;
+	}
+
+	return val;
+}
+
 static const struct ath10k_hif_ops ath10k_ahb_hif_ops = {
 	.tx_sg                  = ath10k_pci_hif_tx_sg,
 	.diag_read              = ath10k_pci_hif_diag_read,
@@ -766,6 +788,7 @@ static int ath10k_ahb_probe(struct platform_device *pdev)
 	ar_pci->mem_len = ar_ahb->mem_len;
 	ar_pci->ar = ar;
 	ar_pci->bus_ops = &ath10k_ahb_bus_ops;
+	ar_pci->targ_cpu_to_ce_addr = ath10k_ahb_qca4019_targ_cpu_to_ce_addr;
 
 	ret = ath10k_pci_setup_resource(ar);
 	if (ret) {
diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index d2aa9e5..6e0d062 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -840,31 +840,35 @@ void ath10k_pci_rx_replenish_retry(unsigned long ptr)
 	ath10k_pci_rx_post(ar);
 }
 
-static u32 ath10k_pci_targ_cpu_to_ce_addr(struct ath10k *ar, u32 addr)
+static u32 ath10k_pci_qca988x_targ_cpu_to_ce_addr(struct ath10k *ar, u32 addr)
 {
-	u32 val = 0;
+	u32 val = 0, region = addr & 0xfffff;
 
-	switch (ar->hw_rev) {
-	case ATH10K_HW_QCA988X:
-	case ATH10K_HW_QCA9887:
-	case ATH10K_HW_QCA6174:
-	case ATH10K_HW_QCA9377:
-		val = (ath10k_pci_read32(ar, SOC_CORE_BASE_ADDRESS +
-					  CORE_CTRL_ADDRESS) &
-		       0x7ff) << 21;
-		break;
-	case ATH10K_HW_QCA9888:
-	case ATH10K_HW_QCA99X0:
-	case ATH10K_HW_QCA9984:
-	case ATH10K_HW_QCA4019:
-		val = ath10k_pci_read32(ar, PCIE_BAR_REG_ADDRESS);
-		break;
-	}
+	val = (ath10k_pci_read32(ar, SOC_CORE_BASE_ADDRESS + CORE_CTRL_ADDRESS)
+				 & 0x7ff) << 21;
+	val |= 0x100000 | region;
+	return val;
+}
+
+static u32 ath10k_pci_qca99x0_targ_cpu_to_ce_addr(struct ath10k *ar, u32 addr)
+{
+	u32 val = 0, region = addr & 0xfffff;
 
-	val |= 0x100000 | (addr & 0xfffff);
+	val = ath10k_pci_read32(ar, PCIE_BAR_REG_ADDRESS);
+	val |= 0x100000 | region;
 	return val;
 }
 
+static u32 ath10k_pci_targ_cpu_to_ce_addr(struct ath10k *ar, u32 addr)
+{
+	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
+
+	if (WARN_ON_ONCE(!ar_pci->targ_cpu_to_ce_addr))
+		return -ENOTSUPP;
+
+	return ar_pci->targ_cpu_to_ce_addr(ar, addr);
+}
+
 /*
  * Diagnostic read/write access is provided for startup/config/debug usage.
  * Caller must guarantee proper alignment, when applicable, and single user
@@ -3170,6 +3174,7 @@ static int ath10k_pci_probe(struct pci_dev *pdev,
 	bool pci_ps;
 	int (*pci_soft_reset)(struct ath10k *ar);
 	int (*pci_hard_reset)(struct ath10k *ar);
+	u32 (*targ_cpu_to_ce_addr)(struct ath10k *ar, u32 addr);
 
 	switch (pci_dev->device) {
 	case QCA988X_2_0_DEVICE_ID:
@@ -3177,12 +3182,14 @@ static int ath10k_pci_probe(struct pci_dev *pdev,
 		pci_ps = false;
 		pci_soft_reset = ath10k_pci_warm_reset;
 		pci_hard_reset = ath10k_pci_qca988x_chip_reset;
+		targ_cpu_to_ce_addr = ath10k_pci_qca988x_targ_cpu_to_ce_addr;
 		break;
 	case QCA9887_1_0_DEVICE_ID:
 		hw_rev = ATH10K_HW_QCA9887;
 		pci_ps = false;
 		pci_soft_reset = ath10k_pci_warm_reset;
 		pci_hard_reset = ath10k_pci_qca988x_chip_reset;
+		targ_cpu_to_ce_addr = ath10k_pci_qca988x_targ_cpu_to_ce_addr;
 		break;
 	case QCA6164_2_1_DEVICE_ID:
 	case QCA6174_2_1_DEVICE_ID:
@@ -3190,30 +3197,35 @@ static int ath10k_pci_probe(struct pci_dev *pdev,
 		pci_ps = true;
 		pci_soft_reset = ath10k_pci_warm_reset;
 		pci_hard_reset = ath10k_pci_qca6174_chip_reset;
+		targ_cpu_to_ce_addr = ath10k_pci_qca988x_targ_cpu_to_ce_addr;
 		break;
 	case QCA99X0_2_0_DEVICE_ID:
 		hw_rev = ATH10K_HW_QCA99X0;
 		pci_ps = false;
 		pci_soft_reset = ath10k_pci_qca99x0_soft_chip_reset;
 		pci_hard_reset = ath10k_pci_qca99x0_chip_reset;
+		targ_cpu_to_ce_addr = ath10k_pci_qca99x0_targ_cpu_to_ce_addr;
 		break;
 	case QCA9984_1_0_DEVICE_ID:
 		hw_rev = ATH10K_HW_QCA9984;
 		pci_ps = false;
 		pci_soft_reset = ath10k_pci_qca99x0_soft_chip_reset;
 		pci_hard_reset = ath10k_pci_qca99x0_chip_reset;
+		targ_cpu_to_ce_addr = ath10k_pci_qca99x0_targ_cpu_to_ce_addr;
 		break;
 	case QCA9888_2_0_DEVICE_ID:
 		hw_rev = ATH10K_HW_QCA9888;
 		pci_ps = false;
 		pci_soft_reset = ath10k_pci_qca99x0_soft_chip_reset;
 		pci_hard_reset = ath10k_pci_qca99x0_chip_reset;
+		targ_cpu_to_ce_addr = ath10k_pci_qca99x0_targ_cpu_to_ce_addr;
 		break;
 	case QCA9377_1_0_DEVICE_ID:
 		hw_rev = ATH10K_HW_QCA9377;
 		pci_ps = true;
 		pci_soft_reset = NULL;
 		pci_hard_reset = ath10k_pci_qca6174_chip_reset;
+		targ_cpu_to_ce_addr = ath10k_pci_qca988x_targ_cpu_to_ce_addr;
 		break;
 	default:
 		WARN_ON(1);
@@ -3240,6 +3252,7 @@ static int ath10k_pci_probe(struct pci_dev *pdev,
 	ar_pci->bus_ops = &ath10k_pci_bus_ops;
 	ar_pci->pci_soft_reset = pci_soft_reset;
 	ar_pci->pci_hard_reset = pci_hard_reset;
+	ar_pci->targ_cpu_to_ce_addr = targ_cpu_to_ce_addr;
 
 	ar->id.vendor = pdev->vendor;
 	ar->id.device = pdev->device;
diff --git a/drivers/net/wireless/ath/ath10k/pci.h b/drivers/net/wireless/ath/ath10k/pci.h
index c76789d..c1e08ad6 100644
--- a/drivers/net/wireless/ath/ath10k/pci.h
+++ b/drivers/net/wireless/ath/ath10k/pci.h
@@ -233,6 +233,11 @@ struct ath10k_pci {
 	/* Chip specific pci full reset function */
 	int (*pci_hard_reset)(struct ath10k *ar);
 
+	/* chip specific methods for converting target CPU virtual address
+	 * space to CE address space
+	 */
+	u32 (*targ_cpu_to_ce_addr)(struct ath10k *ar, u32 addr);
+
 	/* Keep this entry in the last, memory for struct ath10k_ahb is
 	 * allocated (ahb support enabled case) in the continuation of
 	 * this struct.
-- 
1.9.1
