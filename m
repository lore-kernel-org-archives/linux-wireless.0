Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh07.mail.saunalahti.fi ([62.142.5.117]:47207 "EHLO
	emh07.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934197Ab3JPNqU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Oct 2013 09:46:20 -0400
Subject: [PATCH v2 7/8] ath10k: fix device initialization routine
To: ath10k@lists.infradead.org
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 16 Oct 2013 16:46:18 +0300
Message-ID: <20131016134617.25095.10581.stgit@localhost6.localdomain6> (sfid-20131016_154622_792973_2048A8E8)
In-Reply-To: <20131016134503.25095.8044.stgit@localhost6.localdomain6>
References: <20131016134503.25095.8044.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Michal Kazior <michal.kazior@tieto.com>

Hardware revision 2 does not support cold reset
correctly. As such it would sometimes lead to host
machine freeze or data bus errors.

The patch introduces warm reset function which is
used instead of the cold reset one. It also moves
the reset before interrupts are being set up to
prevent any kind of spurious interrupts from being
handled.

kvalo: use ath10k_pci_write32() style wrappers, fix long
lines

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/hw.h  |    7 ++
 drivers/net/wireless/ath/ath10k/pci.c |  130 ++++++++++++++++++++-------------
 drivers/net/wireless/ath/ath10k/pci.h |   10 +++
 3 files changed, 97 insertions(+), 50 deletions(-)

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
index 5c78383..1e9cfcc9 100644
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
@@ -1825,16 +1824,78 @@ static void ath10k_pci_fw_interrupt_handler(struct ath10k *ar)
 	ath10k_pci_sleep(ar);
 }
 
-static int ath10k_pci_hif_power_up(struct ath10k *ar)
+static int ath10k_pci_warm_reset(struct ath10k *ar)
 {
 	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
 	int ret;
+	u32 val;
 
-	ret = ath10k_pci_start_intr(ar);
-	if (ret) {
-		ath10k_err("could not start interrupt handling (%d)\n", ret);
-		goto err;
-	}
+	ath10k_dbg(ATH10K_DBG_BOOT, "performing warm chip reset\n");
+
+	ret = ath10k_do_pci_wake(ar);
+	if (ret)
+		return ret;
+
+	ath10k_dbg(ATH10K_DBG_BOOT,
+		   "pci intr cause 0x%08x cpu intr 0x%08x (before)\n",
+		   ath10k_pci_core_read32(ar, PCIE_INTR_CAUSE_ADDRESS),
+		   ath10k_pci_core_read32(ar, CPU_INTR_ADDRESS));
+
+	/* disable pending irqs */
+	ath10k_pci_core_write32(ar, PCIE_INTR_ENABLE_ADDRESS, 0);
+	ath10k_pci_core_write32(ar, PCIE_INTR_CLR_ADDRESS, ~0);
+
+	msleep(100);
+
+	/* clear fw indicator */
+	ath10k_pci_write32(ar, ar_pci->fw_indicator_address, 0);
+
+	/* clear target LF timer interrupts */
+	val = ath10k_pci_soc_read32(ar, SOC_LF_TIMER_CONTROL0_ADDRESS);
+	ath10k_pci_soc_write32(ar, SOC_LF_TIMER_CONTROL0_ADDRESS,
+			       val & ~SOC_LF_TIMER_CONTROL0_ENABLE_MASK);
+
+	/* reset CE */
+	val = ath10k_pci_soc_read32(ar, SOC_RESET_CONTROL_ADDRESS);
+	val |= SOC_RESET_CONTROL_CE_RST_MASK;
+	ath10k_pci_soc_write32(ar, SOC_RESET_CONTROL_ADDRESS, val);
+	val = ath10k_pci_soc_read32(ar, SOC_RESET_CONTROL_ADDRESS);
+
+	msleep(10);
+
+	/* unreset CE */
+	val &= ~SOC_RESET_CONTROL_CE_RST_MASK;
+	ath10k_pci_soc_write32(ar, SOC_RESET_CONTROL_ADDRESS, val);
+	val = ath10k_pci_soc_read32(ar, SOC_RESET_CONTROL_ADDRESS);
+
+	msleep(10);
+
+	ath10k_dbg(ATH10K_DBG_BOOT,
+		   "pci intr cause 0x%08x cpu intr 0x%08x (after)\n",
+		   ath10k_pci_core_read32(ar, PCIE_INTR_CAUSE_ADDRESS),
+		   ath10k_pci_core_read32(ar, CPU_INTR_ADDRESS));
+
+	/* CPU warm reset */
+	val = ath10k_pci_soc_read32(ar, SOC_RESET_CONTROL_ADDRESS);
+	ath10k_pci_soc_write32(ar, SOC_RESET_CONTROL_ADDRESS,
+			       val | SOC_RESET_CONTROL_CPU_WARM_RST_MASK);
+
+	ath10k_dbg(ATH10K_DBG_BOOT, "soc reset control 0x%08x\n",
+		   ath10k_pci_soc_read32(ar, SOC_RESET_CONTROL_ADDRESS));
+
+	msleep(100);
+
+	ath10k_dbg(ATH10K_DBG_BOOT, "warm reset complete\n");
+
+	ath10k_do_pci_sleep(ar);
+
+	return ret;
+}
+
+static int ath10k_pci_hif_power_up(struct ath10k *ar)
+{
+	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
+	int ret;
 
 	/*
 	 * Bring the target up cleanly.
@@ -1845,8 +1906,19 @@ static int ath10k_pci_hif_power_up(struct ath10k *ar)
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
@@ -2278,48 +2350,6 @@ static int ath10k_pci_reset_target(struct ath10k *ar)
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
diff --git a/drivers/net/wireless/ath/ath10k/pci.h b/drivers/net/wireless/ath/ath10k/pci.h
index a304c33..28e8ca2 100644
--- a/drivers/net/wireless/ath/ath10k/pci.h
+++ b/drivers/net/wireless/ath/ath10k/pci.h
@@ -328,6 +328,16 @@ static inline void ath10k_pci_soc_write32(struct ath10k *ar, u32 addr, u32 val)
 	ath10k_pci_write32(ar, RTC_SOC_BASE_ADDRESS + addr, val);
 }
 
+static inline u32 ath10k_pci_core_read32(struct ath10k *ar, u32 addr)
+{
+	return ath10k_pci_read32(ar, SOC_CORE_BASE_ADDRESS + addr);
+}
+
+static inline void ath10k_pci_core_write32(struct ath10k *ar, u32 addr, u32 val)
+{
+	ath10k_pci_write32(ar, SOC_CORE_BASE_ADDRESS + addr, val);
+}
+
 int ath10k_do_pci_wake(struct ath10k *ar);
 void ath10k_do_pci_sleep(struct ath10k *ar);
 

