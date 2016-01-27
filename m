Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:10901 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754024AbcA0J7U (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Jan 2016 04:59:20 -0500
From: Raja Mani <rmani@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Raja Mani <rmani@qti.qualcomm.com>
Subject: [PATCH 12/12] ath10k: expose hif ops for ahb
Date: Wed, 27 Jan 2016 15:24:33 +0530
Message-ID: <1453888473-2879-13-git-send-email-rmani@qti.qualcomm.com> (sfid-20160127_105924_160885_883B27E3)
In-Reply-To: <1453888473-2879-1-git-send-email-rmani@qti.qualcomm.com>
References: <1453888473-2879-1-git-send-email-rmani@qti.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Like how pci.c exposes hif ops for the bus specific operation,
expose similar hif ops table for ahb with all required functions
linked to it. Many ath10k_pci_* functions are reused here in hif ops
table. If something is not sharable, new functions are added for ahb
and linked to hif ops table.

Finally, make ath10k_ahb_probe/remove() to perform what is expected
out of it.

Signed-off-by: Raja Mani <rmani@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/ahb.c | 271 ++++++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/ahb.h |   5 +
 drivers/net/wireless/ath/ath10k/hw.h  |   1 +
 3 files changed, 277 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/ahb.c b/drivers/net/wireless/ath/ath10k/ahb.c
index d83a864..bd62bc1 100644
--- a/drivers/net/wireless/ath/ath10k/ahb.c
+++ b/drivers/net/wireless/ath/ath10k/ahb.c
@@ -624,13 +624,284 @@ static void ath10k_ahb_resource_deinit(struct ath10k *ar)
 	ath10k_ahb_rst_ctrl_deinit(ar);
 }
 
+static int ath10k_ahb_prepare_device(struct ath10k *ar)
+{
+	u32 val;
+	int ret;
+
+	ret = ath10k_ahb_clock_enable(ar);
+	if (ret) {
+		ath10k_err(ar, "failed to enable clocks\n");
+		return ret;
+	}
+
+	/* Clock for the target is supplied from outside of target (ie,
+	 * external clock module controlled by the host). Target needs
+	 * to know what frequency target cpu is configured which is needed
+	 * for target internal use. Read target cpu frequency info from
+	 * gcc register and write into target's scratch register where
+	 * target expects this information.
+	 */
+	val = ath10k_ahb_gcc_read32(ar, ATH10K_AHB_GCC_FEPLL_PLL_DIV);
+	ath10k_ahb_write32(ar, ATH10K_AHB_WIFI_SCRATCH_5_REG, val);
+
+	ret = ath10k_ahb_release_reset(ar);
+	if (ret)
+		goto err_clk_disable;
+
+	ath10k_ahb_irq_disable(ar);
+
+	ath10k_ahb_write32(ar, FW_INDICATOR_ADDRESS, FW_IND_HOST_READY);
+
+	ret = ath10k_pci_wait_for_target_init(ar);
+	if (ret)
+		goto err_halt_chip;
+
+	return 0;
+
+err_halt_chip:
+	ath10k_ahb_halt_chip(ar);
+
+err_clk_disable:
+	ath10k_ahb_clock_disable(ar);
+
+	return ret;
+}
+
+static int ath10k_ahb_chip_reset(struct ath10k *ar)
+{
+	int ret;
+
+	ath10k_ahb_halt_chip(ar);
+	ath10k_ahb_clock_disable(ar);
+
+	ret = ath10k_ahb_prepare_device(ar);
+	if (ret)
+		return ret;
+
+	return 0;
+}
+
+static int ath10k_ahb_wake_target_cpu(struct ath10k *ar)
+{
+	u32 addr, val;
+
+	addr = SOC_CORE_BASE_ADDRESS | CORE_CTRL_ADDRESS;
+	val = ath10k_ahb_read32(ar, addr);
+	val |= ATH10K_AHB_CORE_CTRL_CPU_INTR_MASK;
+	ath10k_ahb_write32(ar, addr, val);
+
+	return 0;
+}
+
+static int ath10k_ahb_hif_start(struct ath10k *ar)
+{
+	ath10k_dbg(ar, ATH10K_DBG_BOOT, "boot ahb hif start\n");
+
+	ath10k_ce_enable_interrupts(ar);
+	ath10k_pci_enable_legacy_irq(ar);
+
+	ath10k_pci_rx_post(ar);
+
+	return 0;
+}
+
+static void ath10k_ahb_hif_stop(struct ath10k *ar)
+{
+	struct ath10k_ahb *ar_ahb = ath10k_ahb_priv(ar);
+
+	ath10k_dbg(ar, ATH10K_DBG_BOOT, "boot ahb hif stop\n");
+
+	ath10k_ahb_irq_disable(ar);
+	synchronize_irq(ar_ahb->irq);
+
+	ath10k_pci_flush(ar);
+}
+
+static int ath10k_ahb_hif_power_up(struct ath10k *ar)
+{
+	int ret;
+
+	ath10k_dbg(ar, ATH10K_DBG_BOOT, "boot ahb hif power up\n");
+
+	ret = ath10k_ahb_chip_reset(ar);
+	if (ret) {
+		ath10k_err(ar, "failed to reset chip: %d\n", ret);
+		goto out;
+	}
+
+	ret = ath10k_pci_init_pipes(ar);
+	if (ret) {
+		ath10k_err(ar, "failed to initialize CE: %d\n", ret);
+		goto out;
+	}
+
+	ret = ath10k_pci_init_config(ar);
+	if (ret) {
+		ath10k_err(ar, "failed to setup init config: %d\n", ret);
+		goto err_ce_deinit;
+	}
+
+	ret = ath10k_ahb_wake_target_cpu(ar);
+	if (ret) {
+		ath10k_err(ar, "could not wake up target CPU: %d\n", ret);
+		goto err_ce_deinit;
+	}
+
+	return 0;
+
+err_ce_deinit:
+	ath10k_pci_ce_deinit(ar);
+out:
+	return ret;
+}
+
+static const struct ath10k_hif_ops ath10k_ahb_hif_ops = {
+	.tx_sg                  = ath10k_pci_hif_tx_sg,
+	.diag_read              = ath10k_pci_hif_diag_read,
+	.diag_write             = ath10k_pci_diag_write_mem,
+	.exchange_bmi_msg       = ath10k_pci_hif_exchange_bmi_msg,
+	.start                  = ath10k_ahb_hif_start,
+	.stop                   = ath10k_ahb_hif_stop,
+	.map_service_to_pipe    = ath10k_pci_hif_map_service_to_pipe,
+	.get_default_pipe       = ath10k_pci_hif_get_default_pipe,
+	.send_complete_check    = ath10k_pci_hif_send_complete_check,
+	.get_free_queue_number  = ath10k_pci_hif_get_free_queue_number,
+	.power_up               = ath10k_ahb_hif_power_up,
+	.power_down             = ath10k_pci_hif_power_down,
+	.read32                 = ath10k_ahb_read32,
+	.write32                = ath10k_ahb_write32,
+};
+
+static const struct ath10k_bus_ops ath10k_ahb_bus_ops = {
+	.read32		= ath10k_ahb_read32,
+	.write32	= ath10k_ahb_write32,
+	.get_num_banks	= ath10k_ahb_get_num_banks,
+};
+
 static int ath10k_ahb_probe(struct platform_device *pdev)
 {
+	struct ath10k *ar;
+	struct ath10k_ahb *ar_ahb;
+	struct ath10k_pci *ar_pci;
+	const struct of_device_id *of_id;
+	enum ath10k_hw_rev hw_rev;
+	size_t size;
+	int ret;
+	u32 chip_id;
+
+	of_id = of_match_device(ath10k_ahb_of_match, &pdev->dev);
+	if (!of_id) {
+		dev_err(&pdev->dev, "failed to find matching device tree id\n");
+		return -EINVAL;
+	}
+
+	hw_rev = (enum ath10k_hw_rev)of_id->data;
+
+	size = sizeof(*ar_pci) + sizeof(*ar_ahb);
+	ar = ath10k_core_create(size, &pdev->dev, ATH10K_BUS_AHB,
+				hw_rev, &ath10k_ahb_hif_ops);
+	if (!ar) {
+		dev_err(&pdev->dev, "failed to allocate core\n");
+		return -ENOMEM;
+	}
+
+	ath10k_dbg(ar, ATH10K_DBG_BOOT, "ahb probe\n");
+
+	ar_pci = ath10k_pci_priv(ar);
+	ar_ahb = ath10k_ahb_priv(ar);
+
+	ar_ahb->pdev = pdev;
+	platform_set_drvdata(pdev, ar);
+
+	ret = ath10k_ahb_resource_init(ar);
+	if (ret)
+		goto err_core_destroy;
+
+	ar->dev_id = 0;
+	ar_pci->mem = ar_ahb->mem;
+	ar_pci->mem_len = ar_ahb->mem_len;
+	ar_pci->ar = ar;
+	ar_pci->bus_ops = &ath10k_ahb_bus_ops;
+
+	ret = ath10k_pci_setup_resource(ar);
+	if (ret) {
+		ath10k_err(ar, "failed to setup resource: %d\n", ret);
+		goto err_resource_deinit;
+	}
+
+	ath10k_pci_init_irq_tasklets(ar);
+
+	ret = ath10k_ahb_request_irq_legacy(ar);
+	if (ret)
+		goto err_free_pipes;
+
+	ret = ath10k_ahb_prepare_device(ar);
+	if (ret)
+		goto err_free_irq;
+
+	ath10k_pci_ce_deinit(ar);
+
+	chip_id = ath10k_ahb_soc_read32(ar, SOC_CHIP_ID_ADDRESS);
+	if (chip_id == 0xffffffff) {
+		ath10k_err(ar, "failed to get chip id\n");
+		goto err_halt_device;
+	}
+
+	ret = ath10k_core_register(ar, chip_id);
+	if (ret) {
+		ath10k_err(ar, "failed to register driver core: %d\n", ret);
+		goto err_halt_device;
+	}
+
 	return 0;
+
+err_halt_device:
+	ath10k_ahb_halt_chip(ar);
+	ath10k_ahb_clock_disable(ar);
+
+err_free_irq:
+	ath10k_ahb_release_irq_legacy(ar);
+
+err_free_pipes:
+	ath10k_pci_free_pipes(ar);
+
+err_resource_deinit:
+	ath10k_ahb_resource_deinit(ar);
+
+err_core_destroy:
+	ath10k_core_destroy(ar);
+	platform_set_drvdata(pdev, NULL);
+
+	return ret;
 }
 
 static int ath10k_ahb_remove(struct platform_device *pdev)
 {
+	struct ath10k *ar = platform_get_drvdata(pdev);
+	struct ath10k_ahb *ar_ahb;
+
+	if (!ar)
+		return -EINVAL;
+
+	ar_ahb = ath10k_ahb_priv(ar);
+
+	if (!ar_ahb)
+		return -EINVAL;
+
+	ath10k_dbg(ar, ATH10K_DBG_AHB, "ahb remove\n");
+
+	ath10k_core_unregister(ar);
+	ath10k_ahb_irq_disable(ar);
+	ath10k_ahb_release_irq_legacy(ar);
+	ath10k_pci_release_resource(ar);
+	ath10k_ahb_halt_chip(ar);
+	ath10k_ahb_clock_disable(ar);
+	ath10k_ahb_resource_deinit(ar);
+	ath10k_core_destroy(ar);
+
+	platform_set_drvdata(pdev, NULL);
+
 	return 0;
 }
 
diff --git a/drivers/net/wireless/ath/ath10k/ahb.h b/drivers/net/wireless/ath/ath10k/ahb.h
index 5bd01b4..d43e375 100644
--- a/drivers/net/wireless/ath/ath10k/ahb.h
+++ b/drivers/net/wireless/ath/ath10k/ahb.h
@@ -48,6 +48,9 @@ struct ath10k_ahb {
 #define ATH10K_TCSR_REG_BASE                 0x1900000
 #define ATH10K_TCSR_REG_SIZE                 0x80000
 
+#define ATH10K_AHB_GCC_FEPLL_PLL_DIV         0x2f020
+#define ATH10K_AHB_WIFI_SCRATCH_5_REG        0x4f014
+
 #define ATH10K_AHB_WLAN_CORE_ID_REG          0x82030
 
 #define ATH10K_AHB_TCSR_WIFI0_GLB_CFG        0x49000
@@ -63,6 +66,8 @@ struct ath10k_ahb {
 #define AHB_AXI_BUS_HALT_REQ                 1
 #define AHB_AXI_BUS_HALT_ACK                 1
 
+#define ATH10K_AHB_CORE_CTRL_CPU_INTR_MASK   1
+
 int ath10k_ahb_init(void);
 void ath10k_ahb_exit(void);
 
diff --git a/drivers/net/wireless/ath/ath10k/hw.h b/drivers/net/wireless/ath/ath10k/hw.h
index f57a37b..4217bdb 100644
--- a/drivers/net/wireless/ath/ath10k/hw.h
+++ b/drivers/net/wireless/ath/ath10k/hw.h
@@ -605,6 +605,7 @@ enum ath10k_hw_4addr_pad {
 #define FW_INDICATOR_ADDRESS			ar->regs->fw_indicator_address
 #define FW_IND_EVENT_PENDING			1
 #define FW_IND_INITIALIZED			2
+#define FW_IND_HOST_READY			0x80000000
 
 /* HOST_REG interrupt from firmware */
 #define PCIE_INTR_FIRMWARE_MASK			ar->regs->pcie_intr_fw_mask
-- 
1.8.1.2

