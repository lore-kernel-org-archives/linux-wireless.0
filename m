Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f50.google.com ([74.125.83.50]:47054 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752939AbaBJQOu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Feb 2014 11:14:50 -0500
Received: by mail-ee0-f50.google.com with SMTP id d17so3022283eek.37
        for <linux-wireless@vger.kernel.org>; Mon, 10 Feb 2014 08:14:49 -0800 (PST)
From: Marek Puzyniak <marek.puzyniak@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>,
	Marek Puzyniak <marek.puzyniak@tieto.com>
Subject: [PATCH v2 1/3] ath10k: fix device initialization routine
Date: Mon, 10 Feb 2014 17:14:22 +0100
Message-Id: <1392048864-13352-2-git-send-email-marek.puzyniak@tieto.com> (sfid-20140210_171701_764546_A0F736C3)
In-Reply-To: <1392048864-13352-1-git-send-email-marek.puzyniak@tieto.com>
References: <1392048864-13352-1-git-send-email-marek.puzyniak@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Michal Kazior <michal.kazior@tieto.com>

Hardware CUS232 version 2 has some issues with cold
reset that lead to Data Bus Errors or system hangs
in some cases. It's safer to use warm reset when
possible as it shouldn't trigger the
aforementioned issues.

Prefer warm reset over cold reset. However since
warm reset doesn't work after FW crash make sure to
fallback to cold reset when booting up the HW.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
Signed-off-by: Marek Puzyniak <marek.puzyniak@tieto.com>
---
 drivers/net/wireless/ath/ath10k/hw.h  |   6 ++
 drivers/net/wireless/ath/ath10k/pci.c | 134 ++++++++++++++++++++++++++++++++--
 2 files changed, 133 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/hw.h b/drivers/net/wireless/ath/ath10k/hw.h
index f1505a2..35fc44e 100644
--- a/drivers/net/wireless/ath/ath10k/hw.h
+++ b/drivers/net/wireless/ath/ath10k/hw.h
@@ -205,8 +205,11 @@ enum ath10k_mcast2ucast_mode {
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
@@ -216,6 +219,8 @@ enum ath10k_mcast2ucast_mode {
 #define SOC_LPO_CAL_OFFSET			0x000000e0
 #define SOC_LPO_CAL_ENABLE_LSB			20
 #define SOC_LPO_CAL_ENABLE_MASK			0x00100000
+#define SOC_LF_TIMER_CONTROL0_ADDRESS		0x00000050
+#define SOC_LF_TIMER_CONTROL0_ENABLE_MASK	0x00000004
 
 #define SOC_CHIP_ID_ADDRESS			0x000000ec
 #define SOC_CHIP_ID_REV_LSB			8
@@ -273,6 +278,7 @@ enum ath10k_mcast2ucast_mode {
 #define PCIE_INTR_CAUSE_ADDRESS			0x000c
 #define PCIE_INTR_CLR_ADDRESS			0x0014
 #define SCRATCH_3_ADDRESS			0x0030
+#define CPU_INTR_ADDRESS			0x0010
 
 /* Firmware indications to the Host via SCRATCH_3 register. */
 #define FW_INDICATOR_ADDRESS	(SOC_CORE_BASE_ADDRESS + SCRATCH_3_ADDRESS)
diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index 9179c88..486412b9 100644
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
@@ -1500,7 +1501,7 @@ static void ath10k_pci_hif_stop(struct ath10k *ar)
 	 * configuration during init. If ringbuffers are freed and the device
 	 * were to access them this could lead to memory corruption on the
 	 * host. */
-	ath10k_pci_device_reset(ar);
+	ath10k_pci_warm_reset(ar);
 
 	ar_pci->started = 0;
 }
@@ -1991,7 +1992,94 @@ static void ath10k_pci_fw_interrupt_handler(struct ath10k *ar)
 	ath10k_pci_sleep(ar);
 }
 
-static int ath10k_pci_hif_power_up(struct ath10k *ar)
+static int ath10k_pci_warm_reset(struct ath10k *ar)
+{
+	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
+	int ret = 0;
+	u32 val;
+
+	ath10k_dbg(ATH10K_DBG_BOOT, "boot performing warm chip reset\n");
+
+	ret = ath10k_do_pci_wake(ar);
+	if (ret) {
+		ath10k_err("failed to wake up target: %d\n", ret);
+		return ret;
+	}
+
+	/* debug */
+	val = ath10k_pci_read32(ar, SOC_CORE_BASE_ADDRESS +
+				PCIE_INTR_CAUSE_ADDRESS);
+	ath10k_dbg(ATH10K_DBG_BOOT, "boot host cpu intr cause: 0x%08x\n", val);
+
+	val = ath10k_pci_read32(ar, SOC_CORE_BASE_ADDRESS +
+				CPU_INTR_ADDRESS);
+	ath10k_dbg(ATH10K_DBG_BOOT, "boot target cpu intr cause: 0x%08x\n",
+		   val);
+
+	/* disable pending irqs */
+	ath10k_pci_write32(ar, SOC_CORE_BASE_ADDRESS +
+			   PCIE_INTR_ENABLE_ADDRESS, 0);
+
+	ath10k_pci_write32(ar, SOC_CORE_BASE_ADDRESS +
+			   PCIE_INTR_CLR_ADDRESS, ~0);
+
+	msleep(100);
+
+	/* clear fw indicator */
+	ath10k_pci_write32(ar, ar_pci->fw_indicator_address, 0);
+
+	/* clear target LF timer interrupts */
+	val = ath10k_pci_read32(ar, RTC_SOC_BASE_ADDRESS +
+				SOC_LF_TIMER_CONTROL0_ADDRESS);
+	ath10k_pci_write32(ar, RTC_SOC_BASE_ADDRESS +
+			   SOC_LF_TIMER_CONTROL0_ADDRESS,
+			   val & ~SOC_LF_TIMER_CONTROL0_ENABLE_MASK);
+
+	/* reset CE */
+	val = ath10k_pci_read32(ar, RTC_SOC_BASE_ADDRESS +
+				SOC_RESET_CONTROL_ADDRESS);
+	ath10k_pci_write32(ar, RTC_SOC_BASE_ADDRESS + SOC_RESET_CONTROL_ADDRESS,
+			   val | SOC_RESET_CONTROL_CE_RST_MASK);
+	val = ath10k_pci_read32(ar, RTC_SOC_BASE_ADDRESS +
+				SOC_RESET_CONTROL_ADDRESS);
+	msleep(10);
+
+	/* unreset CE */
+	ath10k_pci_write32(ar, RTC_SOC_BASE_ADDRESS + SOC_RESET_CONTROL_ADDRESS,
+			   val & ~SOC_RESET_CONTROL_CE_RST_MASK);
+	val = ath10k_pci_read32(ar, RTC_SOC_BASE_ADDRESS +
+				SOC_RESET_CONTROL_ADDRESS);
+	msleep(10);
+
+	/* debug */
+	val = ath10k_pci_read32(ar, SOC_CORE_BASE_ADDRESS +
+				PCIE_INTR_CAUSE_ADDRESS);
+	ath10k_dbg(ATH10K_DBG_BOOT, "boot host cpu intr cause: 0x%08x\n", val);
+
+	val = ath10k_pci_read32(ar, SOC_CORE_BASE_ADDRESS +
+				CPU_INTR_ADDRESS);
+	ath10k_dbg(ATH10K_DBG_BOOT, "boot target cpu intr cause: 0x%08x\n",
+		   val);
+
+	/* CPU warm reset */
+	val = ath10k_pci_read32(ar, RTC_SOC_BASE_ADDRESS +
+				SOC_RESET_CONTROL_ADDRESS);
+	ath10k_pci_write32(ar, RTC_SOC_BASE_ADDRESS + SOC_RESET_CONTROL_ADDRESS,
+			   val | SOC_RESET_CONTROL_CPU_WARM_RST_MASK);
+
+	val = ath10k_pci_read32(ar, RTC_SOC_BASE_ADDRESS +
+				SOC_RESET_CONTROL_ADDRESS);
+	ath10k_dbg(ATH10K_DBG_BOOT, "boot target reset state: 0x%08x\n", val);
+
+	msleep(100);
+
+	ath10k_dbg(ATH10K_DBG_BOOT, "boot warm reset complete\n");
+
+	ath10k_do_pci_sleep(ar);
+	return ret;
+}
+
+static int __ath10k_pci_hif_power_up(struct ath10k *ar, bool cold_reset)
 {
 	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
 	const char *irq_mode;
@@ -2007,7 +2095,11 @@ static int ath10k_pci_hif_power_up(struct ath10k *ar)
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
@@ -2077,7 +2169,7 @@ err_deinit_irq:
 	ath10k_pci_deinit_irq(ar);
 err_ce:
 	ath10k_pci_ce_deinit(ar);
-	ath10k_pci_device_reset(ar);
+	ath10k_pci_warm_reset(ar);
 err_ps:
 	if (!test_bit(ATH10K_PCI_FEATURE_SOC_POWER_SAVE, ar_pci->features))
 		ath10k_do_pci_sleep(ar);
@@ -2085,6 +2177,34 @@ err:
 	return ret;
 }
 
+static int ath10k_pci_hif_power_up(struct ath10k *ar)
+{
+	int ret;
+
+	/*
+	 * Hardware CUS232 version 2 has some issues with cold reset and the
+	 * preferred (and safer) way to perform a device reset is through a
+	 * warm reset.
+	 *
+	 * Warm reset doesn't always work though (notably after a firmware
+	 * crash) so fall back to cold reset if necessary.
+	 */
+	ret = __ath10k_pci_hif_power_up(ar, false);
+	if (ret) {
+		ath10k_warn("failed to power up target using warm reset (%d), trying cold reset\n",
+			    ret);
+
+		ret = __ath10k_pci_hif_power_up(ar, true);
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
@@ -2092,7 +2212,7 @@ static void ath10k_pci_hif_power_down(struct ath10k *ar)
 	ath10k_pci_free_early_irq(ar);
 	ath10k_pci_kill_tasklet(ar);
 	ath10k_pci_deinit_irq(ar);
-	ath10k_pci_device_reset(ar);
+	ath10k_pci_warm_reset(ar);
 
 	ath10k_pci_ce_deinit(ar);
 	if (!test_bit(ATH10K_PCI_FEATURE_SOC_POWER_SAVE, ar_pci->features))
@@ -2521,7 +2641,7 @@ out:
 	return ret;
 }
 
-static int ath10k_pci_device_reset(struct ath10k *ar)
+static int ath10k_pci_cold_reset(struct ath10k *ar)
 {
 	int i, ret;
 	u32 val;
-- 
1.8.1.2

