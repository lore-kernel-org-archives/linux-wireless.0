Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f170.google.com ([209.85.215.170]:55811 "EHLO
	mail-ea0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751779Ab3LLO2c (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Dec 2013 09:28:32 -0500
Received: by mail-ea0-f170.google.com with SMTP id k10so274480eaj.15
        for <linux-wireless@vger.kernel.org>; Thu, 12 Dec 2013 06:28:31 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 1/3] ath10k: fix device initialization routine
Date: Thu, 12 Dec 2013 15:24:19 +0100
Message-Id: <1386858261-16037-2-git-send-email-michal.kazior@tieto.com> (sfid-20131212_152836_527875_C45F3D37)
In-Reply-To: <1386858261-16037-1-git-send-email-michal.kazior@tieto.com>
References: <1386858261-16037-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hardware revision 2 has some issues with cold
reset that lead to Data Bus Errors or system hangs
in some cases. It's safer to use warm reset when
possible as it shouldn't trigger the
aforementioned issues.

Prefer warm reset over cold reset. However since
warm reset doesn't always work (e.g. after FW
crash) make sure to fallback to cold reset.

This should generally reduce frequency of the
problem.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/hw.h  |   6 ++
 drivers/net/wireless/ath/ath10k/pci.c | 125 ++++++++++++++++++++++++++++++----
 2 files changed, 118 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/hw.h b/drivers/net/wireless/ath/ath10k/hw.h
index 9535eaa..2032737 100644
--- a/drivers/net/wireless/ath/ath10k/hw.h
+++ b/drivers/net/wireless/ath/ath10k/hw.h
@@ -204,8 +204,11 @@ enum ath10k_mcast2ucast_mode {
 #define WLAN_ANALOG_INTF_PCIE_BASE_ADDRESS	0x0006c000
 #define PCIE_LOCAL_BASE_ADDRESS			0x00080000
 
+#define SOC_RESET_CONTROL_ADDRESS		0x00000000
 #define SOC_RESET_CONTROL_OFFSET		0x00000000
 #define SOC_RESET_CONTROL_SI0_RST_MASK		0x00000001
+#define SOC_RESET_CONTROL_CE_RST_MASK		0x00040000
+#define SOC_RESET_CONTROL_CPU_WARM_RST_MASK	0x00000040
 #define SOC_CPU_CLOCK_OFFSET			0x00000020
 #define SOC_CPU_CLOCK_STANDARD_LSB		0
 #define SOC_CPU_CLOCK_STANDARD_MASK		0x00000003
@@ -215,6 +218,8 @@ enum ath10k_mcast2ucast_mode {
 #define SOC_LPO_CAL_OFFSET			0x000000e0
 #define SOC_LPO_CAL_ENABLE_LSB			20
 #define SOC_LPO_CAL_ENABLE_MASK			0x00100000
+#define SOC_LF_TIMER_CONTROL0_ADDRESS		0x00000050
+#define SOC_LF_TIMER_CONTROL0_ENABLE_MASK	0x00000004
 
 #define SOC_CHIP_ID_ADDRESS			0x000000ec
 #define SOC_CHIP_ID_REV_LSB			8
@@ -272,6 +277,7 @@ enum ath10k_mcast2ucast_mode {
 #define PCIE_INTR_CAUSE_ADDRESS			0x000c
 #define PCIE_INTR_CLR_ADDRESS			0x0014
 #define SCRATCH_3_ADDRESS			0x0030
+#define CPU_INTR_ADDRESS			0x0010
 
 /* Firmware indications to the Host via SCRATCH_3 register. */
 #define FW_INDICATOR_ADDRESS	(SOC_CORE_BASE_ADDRESS + SCRATCH_3_ADDRESS)
diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index 29fd197..475b4da 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -64,7 +64,8 @@ static int ath10k_pci_post_rx_pipe(struct ath10k_pci_pipe *pipe_info,
 					     int num);
 static void ath10k_pci_rx_pipe_cleanup(struct ath10k_pci_pipe *pipe_info);
 static void ath10k_pci_stop_ce(struct ath10k *ar);
-static int ath10k_pci_device_reset(struct ath10k *ar);
+static int ath10k_pci_cold_reset(struct ath10k *ar);
+static int ath10k_pci_warm_reset(struct ath10k *ar);
 static int ath10k_pci_wait_for_target_init(struct ath10k *ar);
 static int ath10k_pci_init_irq(struct ath10k *ar);
 static int ath10k_pci_deinit_irq(struct ath10k *ar);
@@ -1477,6 +1478,10 @@ static void ath10k_pci_hif_stop(struct ath10k *ar)
 
 	ath10k_dbg(ATH10K_DBG_PCI, "%s\n", __func__);
 
+	/* Make the sure the device won't access any structures on the host by
+	 * resetting it. This should prevent host memory corruption, hangs. */
+	ath10k_pci_warm_reset(ar);
+
 	ret = ath10k_ce_disable_interrupts(ar);
 	if (ret)
 		ath10k_warn("failed to disable CE interrupts: %d\n", ret);
@@ -1497,13 +1502,6 @@ static void ath10k_pci_hif_stop(struct ath10k *ar)
 	ath10k_pci_cleanup_ce(ar);
 	ath10k_pci_buffer_cleanup(ar);
 
-	/* Make the sure the device won't access any structures on the host by
-	 * resetting it. The device was fed with PCI CE ringbuffer
-	 * configuration during init. If ringbuffers are freed and the device
-	 * were to access them this could lead to memory corruption on the
-	 * host. */
-	ath10k_pci_device_reset(ar);
-
 	ar_pci->started = 0;
 }
 
@@ -1993,7 +1991,73 @@ static void ath10k_pci_fw_interrupt_handler(struct ath10k *ar)
 	ath10k_pci_sleep(ar);
 }
 
-static int ath10k_pci_hif_power_up(struct ath10k *ar)
+static int ath10k_pci_warm_reset(struct ath10k *ar)
+{
+	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
+	void __iomem *addr;
+	int ret = 0;
+	u32 val;
+
+	ath10k_dbg(ATH10K_DBG_BOOT, "performing warm chip reset\n");
+
+	ret = ath10k_do_pci_wake(ar);
+	if (ret)
+		return ret;
+
+	/* debug */
+	addr = ar_pci->mem + SOC_CORE_BASE_ADDRESS + PCIE_INTR_CAUSE_ADDRESS;
+	ath10k_dbg(ATH10K_DBG_BOOT, "host CPU intr cause: 0x%x\n", ioread32(addr));
+	addr = ar_pci->mem + SOC_CORE_BASE_ADDRESS + CPU_INTR_ADDRESS;
+	ath10k_dbg(ATH10K_DBG_BOOT, "target CPU intr cause: 0x%x\n", ioread32(addr));
+
+	/* disable pending irqs */
+	iowrite32(0, ar_pci->mem + SOC_CORE_BASE_ADDRESS + PCIE_INTR_ENABLE_ADDRESS);
+	iowrite32(~0, ar_pci->mem + SOC_CORE_BASE_ADDRESS + PCIE_INTR_CLR_ADDRESS);
+
+	msleep(100);
+
+	/* clear fw indicator */
+	iowrite32(0, ar_pci->mem + ar_pci->fw_indicator_address);
+
+	/* clear target LF timer interrupts */
+	addr = ar_pci->mem + RTC_SOC_BASE_ADDRESS + SOC_LF_TIMER_CONTROL0_ADDRESS;
+	iowrite32(ioread32(addr) & ~SOC_LF_TIMER_CONTROL0_ENABLE_MASK, addr);
+
+	/* reset CE */
+	addr = ar_pci->mem + RTC_SOC_BASE_ADDRESS + SOC_RESET_CONTROL_ADDRESS;
+	val = ioread32(addr);
+	val |= SOC_RESET_CONTROL_CE_RST_MASK;
+	iowrite32(val, addr);
+	val = ioread32(addr);
+	msleep(10);
+
+	/* unreset CE */
+	val &= ~SOC_RESET_CONTROL_CE_RST_MASK, addr;
+	iowrite32(val, addr);
+	val = ioread32(addr);
+	msleep(10);
+
+	/* debug */
+	addr = ar_pci->mem + SOC_CORE_BASE_ADDRESS + PCIE_INTR_CAUSE_ADDRESS;
+	ath10k_dbg(ATH10K_DBG_BOOT, "host CPU intr cause: 0x%x\n", ioread32(addr));
+	addr = ar_pci->mem + SOC_CORE_BASE_ADDRESS + CPU_INTR_ADDRESS;
+	ath10k_dbg(ATH10K_DBG_BOOT, "target CPU intr cause: 0x%x\n", ioread32(addr));
+
+	/* CPU warm reset */
+	addr = ar_pci->mem + RTC_SOC_BASE_ADDRESS + SOC_RESET_CONTROL_ADDRESS;
+	iowrite32(ioread32(addr) | SOC_RESET_CONTROL_CPU_WARM_RST_MASK, addr);
+
+	ath10k_dbg(ATH10K_DBG_BOOT, "target reset state: 0x%x\n", ioread32(addr));
+
+	msleep(100);
+
+	ath10k_dbg(ATH10K_DBG_BOOT, "warm reset complete\n");
+
+	ath10k_do_pci_sleep(ar);
+	return ret;
+}
+
+static int __ath10k_pci_hif_power_up(struct ath10k *ar, bool cold_reset)
 {
 	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
 	const char *irq_mode;
@@ -2009,7 +2073,11 @@ static int ath10k_pci_hif_power_up(struct ath10k *ar)
 	 * is in an unexpected state. We try to catch that here in order to
 	 * reset the Target and retry the probe.
 	 */
-	ret = ath10k_pci_device_reset(ar);
+	if (cold_reset)
+		ret = ath10k_pci_cold_reset(ar);
+	else
+		ret = ath10k_pci_warm_reset(ar);
+
 	if (ret) {
 		ath10k_err("failed to reset target: %d\n", ret);
 		goto err;
@@ -2078,8 +2146,8 @@ err_free_early_irq:
 err_deinit_irq:
 	ath10k_pci_deinit_irq(ar);
 err_ce:
+	ath10k_pci_warm_reset(ar);
 	ath10k_pci_ce_deinit(ar);
-	ath10k_pci_device_reset(ar);
 err_ps:
 	if (!test_bit(ATH10K_PCI_FEATURE_SOC_POWER_SAVE, ar_pci->features))
 		ath10k_do_pci_sleep(ar);
@@ -2087,14 +2155,45 @@ err:
 	return ret;
 }
 
+static int ath10k_pci_hif_power_up(struct ath10k *ar)
+{
+	int ret;
+
+	/*
+	 * Hardware revision 2 has some issues with cold reset and the
+	 * preferred (and safer) way to perform a device reset is through a
+	 * warm reset.
+	 *
+	 * Warm reset doesn't always work though (notably after a firmware
+	 * crash) so fall back to cold reset if necessary.
+	 */
+	ret = __ath10k_pci_hif_power_up(ar, 0);
+	if (ret) {
+		ath10k_warn("failed to power up target using warm reset (%d), trying cold reset\n",
+			    ret);
+
+		ret = __ath10k_pci_hif_power_up(ar, 1);
+		if (ret) {
+			ath10k_err("failed to power up target using cold reset too (%d)\n",
+				   ret);
+			return ret;
+		}
+	}
+
+	return 0;
+}
+
 static void ath10k_pci_hif_power_down(struct ath10k *ar)
 {
 	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
 
+	/* Make the sure the device won't access any structures on the host by
+	 * resetting it. This should prevent host memory corruption, hangs. */
+	ath10k_pci_warm_reset(ar);
+
 	ath10k_pci_free_early_irq(ar);
 	ath10k_pci_kill_tasklet(ar);
 	ath10k_pci_deinit_irq(ar);
-	ath10k_pci_device_reset(ar);
 
 	ath10k_pci_ce_deinit(ar);
 	if (!test_bit(ATH10K_PCI_FEATURE_SOC_POWER_SAVE, ar_pci->features))
@@ -2523,7 +2622,7 @@ out:
 	return ret;
 }
 
-static int ath10k_pci_device_reset(struct ath10k *ar)
+static int ath10k_pci_cold_reset(struct ath10k *ar)
 {
 	int i, ret;
 	u32 val;
-- 
1.8.4.rc3

