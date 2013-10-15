Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f48.google.com ([209.85.220.48]:46730 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933498Ab3JORci (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Oct 2013 13:32:38 -0400
Received: by mail-pa0-f48.google.com with SMTP id bj1so9249279pad.7
        for <linux-wireless@vger.kernel.org>; Tue, 15 Oct 2013 10:32:37 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 6/7] ath10k: fix device initialization routine
Date: Tue, 15 Oct 2013 10:29:55 -0700
Message-Id: <1381858196-17000-7-git-send-email-michal.kazior@tieto.com> (sfid-20131015_193241_741745_E29417A7)
In-Reply-To: <1381858196-17000-1-git-send-email-michal.kazior@tieto.com>
References: <1381858196-17000-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hardware revision 2 does not support cold reset
correctly. As such it would sometimes lead to host
machine freeze or data bus errors.

The patch introduces warm reset function which is
used instead of the cold reset one. It also moves
the reset before interrupts are being set up to
prevent any kind of spurious interrupts from being
handled.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/hw.h  |   7 ++
 drivers/net/wireless/ath/ath10k/pci.c | 128 +++++++++++++++++++++-------------
 2 files changed, 85 insertions(+), 50 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/hw.h b/drivers/net/wireless/ath/ath10k/hw.h
index 8aeb46d..2032737 100644
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
@@ -269,8 +274,10 @@ enum ath10k_mcast2ucast_mode {
 #define CORE_CTRL_CPU_INTR_MASK			0x00002000
 #define CORE_CTRL_ADDRESS			0x0000
 #define PCIE_INTR_ENABLE_ADDRESS		0x0008
+#define PCIE_INTR_CAUSE_ADDRESS			0x000c
 #define PCIE_INTR_CLR_ADDRESS			0x0014
 #define SCRATCH_3_ADDRESS			0x0030
+#define CPU_INTR_ADDRESS			0x0010
 
 /* Firmware indications to the Host via SCRATCH_3 register. */
 #define FW_INDICATOR_ADDRESS	(SOC_CORE_BASE_ADDRESS + SCRATCH_3_ADDRESS)
diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index d09f8a2..14fcfe7 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -52,7 +52,6 @@ static int ath10k_pci_post_rx_pipe(struct ath10k_pci_pipe *pipe_info,
 					     int num);
 static void ath10k_pci_rx_pipe_cleanup(struct ath10k_pci_pipe *pipe_info);
 static void ath10k_pci_stop_ce(struct ath10k *ar);
-static void ath10k_pci_device_reset(struct ath10k *ar);
 static int ath10k_pci_reset_target(struct ath10k *ar);
 static int ath10k_pci_start_intr(struct ath10k *ar);
 static void ath10k_pci_stop_intr(struct ath10k *ar);
@@ -1825,17 +1824,77 @@ static void ath10k_pci_fw_interrupt_handler(struct ath10k *ar)
 	ath10k_pci_sleep(ar);
 }
 
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
 static int ath10k_pci_hif_power_up(struct ath10k *ar)
 {
 	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
 	int ret;
 
-	ret = ath10k_pci_start_intr(ar);
-	if (ret) {
-		ath10k_err("could not start interrupt handling (%d)\n", ret);
-		goto err;
-	}
-
 	/*
 	 * Bring the target up cleanly.
 	 *
@@ -1845,8 +1904,19 @@ static int ath10k_pci_hif_power_up(struct ath10k *ar)
 	 * (aux) powered and running. On a subsequent driver load, the Target
 	 * is in an unexpected state. We try to catch that here in order to
 	 * reset the Target and retry the probe.
+	 *
+	 * Only HW v2 supports warm reset. Since ath10k does not support v1
+	 * anymore just forget about cold reset which is broken on v2 for now.
 	 */
-	ath10k_pci_device_reset(ar);
+	ret = ath10k_pci_warm_reset(ar);
+	if (ret)
+		goto err;
+
+	ret = ath10k_pci_start_intr(ar);
+	if (ret) {
+		ath10k_err("could not start interrupt handling (%d)\n", ret);
+		goto err;
+	}
 
 	ret = ath10k_pci_reset_target(ar);
 	if (ret)
@@ -2278,48 +2348,6 @@ static int ath10k_pci_reset_target(struct ath10k *ar)
 	return 0;
 }
 
-static void ath10k_pci_device_reset(struct ath10k *ar)
-{
-	int i;
-	u32 val;
-
-	if (!SOC_GLOBAL_RESET_ADDRESS)
-		return;
-
-	ath10k_pci_reg_write32(ar, PCIE_SOC_WAKE_ADDRESS,
-			       PCIE_SOC_WAKE_V_MASK);
-	for (i = 0; i < ATH_PCI_RESET_WAIT_MAX; i++) {
-		if (ath10k_pci_target_is_awake(ar))
-			break;
-		msleep(1);
-	}
-
-	/* Put Target, including PCIe, into RESET. */
-	val = ath10k_pci_reg_read32(ar, SOC_GLOBAL_RESET_ADDRESS);
-	val |= 1;
-	ath10k_pci_reg_write32(ar, SOC_GLOBAL_RESET_ADDRESS, val);
-
-	for (i = 0; i < ATH_PCI_RESET_WAIT_MAX; i++) {
-		if (ath10k_pci_reg_read32(ar, RTC_STATE_ADDRESS) &
-					  RTC_STATE_COLD_RESET_MASK)
-			break;
-		msleep(1);
-	}
-
-	/* Pull Target, including PCIe, out of RESET. */
-	val &= ~1;
-	ath10k_pci_reg_write32(ar, SOC_GLOBAL_RESET_ADDRESS, val);
-
-	for (i = 0; i < ATH_PCI_RESET_WAIT_MAX; i++) {
-		if (!(ath10k_pci_reg_read32(ar, RTC_STATE_ADDRESS) &
-					    RTC_STATE_COLD_RESET_MASK))
-			break;
-		msleep(1);
-	}
-
-	ath10k_pci_reg_write32(ar, PCIE_SOC_WAKE_ADDRESS, PCIE_SOC_WAKE_RESET);
-}
-
 static void ath10k_pci_dump_features(struct ath10k_pci *ar_pci)
 {
 	int i;
-- 
1.8.4.rc3

