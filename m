Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f170.google.com ([74.125.82.170]:51225 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755052AbaHGJNJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Aug 2014 05:13:09 -0400
Received: by mail-we0-f170.google.com with SMTP id w62so3824636wes.29
        for <linux-wireless@vger.kernel.org>; Thu, 07 Aug 2014 02:13:08 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 2/6] ath10k: remove target soc ps code
Date: Thu,  7 Aug 2014 11:03:28 +0200
Message-Id: <1407402212-29809-3-git-send-email-michal.kazior@tieto.com> (sfid-20140807_111319_351231_E52D0B75)
In-Reply-To: <1407402212-29809-1-git-send-email-michal.kazior@tieto.com>
References: <1407402212-29809-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The soc powersave was disabled by default. It
never was fully tested. Some hw apparently had
problems with it and the implementation itself had
a possible race.

Just remove the refcounting and simply wake up the
device when probing and put to sleep when
removing.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/ce.c  |  68 +------------
 drivers/net/wireless/ath/ath10k/pci.c | 182 +++++++---------------------------
 drivers/net/wireless/ath/ath10k/pci.h |  67 +++----------
 3 files changed, 54 insertions(+), 263 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/ce.c b/drivers/net/wireless/ath/ath10k/ce.c
index 4333107..5117705 100644
--- a/drivers/net/wireless/ath/ath10k/ce.c
+++ b/drivers/net/wireless/ath/ath10k/ce.c
@@ -287,10 +287,6 @@ int ath10k_ce_send_nolock(struct ath10k_ce_pipe *ce_state,
 		ath10k_warn("%s: send more we can (nbytes: %d, max: %d)\n",
 			    __func__, nbytes, ce_state->src_sz_max);
 
-	ret = ath10k_pci_wake(ar);
-	if (ret)
-		return ret;
-
 	if (unlikely(CE_RING_DELTA(nentries_mask,
 				   write_index, sw_index - 1) <= 0)) {
 		ret = -ENOSR;
@@ -325,7 +321,6 @@ int ath10k_ce_send_nolock(struct ath10k_ce_pipe *ce_state,
 
 	src_ring->write_index = write_index;
 exit:
-	ath10k_pci_sleep(ar);
 	return ret;
 }
 
@@ -407,10 +402,6 @@ int ath10k_ce_recv_buf_enqueue(struct ath10k_ce_pipe *ce_state,
 	write_index = dest_ring->write_index;
 	sw_index = dest_ring->sw_index;
 
-	ret = ath10k_pci_wake(ar);
-	if (ret)
-		goto out;
-
 	if (CE_RING_DELTA(nentries_mask, write_index, sw_index - 1) > 0) {
 		struct ce_desc *base = dest_ring->base_addr_owner_space;
 		struct ce_desc *desc = CE_DEST_RING_TO_DESC(base, write_index);
@@ -430,11 +421,8 @@ int ath10k_ce_recv_buf_enqueue(struct ath10k_ce_pipe *ce_state,
 	} else {
 		ret = -EIO;
 	}
-	ath10k_pci_sleep(ar);
 
-out:
 	spin_unlock_bh(&ar_pci->ce_lock);
-
 	return ret;
 }
 
@@ -588,7 +576,6 @@ static int ath10k_ce_completed_send_next_nolock(struct ath10k_ce_pipe *ce_state,
 	unsigned int sw_index = src_ring->sw_index;
 	struct ce_desc *sdesc, *sbase;
 	unsigned int read_index;
-	int ret;
 
 	if (src_ring->hw_index == sw_index) {
 		/*
@@ -599,18 +586,12 @@ static int ath10k_ce_completed_send_next_nolock(struct ath10k_ce_pipe *ce_state,
 		 * value of the HW index has become stale.
 		 */
 
-		ret = ath10k_pci_wake(ar);
-		if (ret)
-			return ret;
-
 		read_index = ath10k_ce_src_ring_read_index_get(ar, ctrl_addr);
 		if (read_index == 0xffffffff)
 			return -ENODEV;
 
 		read_index &= nentries_mask;
 		src_ring->hw_index = read_index;
-
-		ath10k_pci_sleep(ar);
 	}
 
 	read_index = src_ring->hw_index;
@@ -731,11 +712,6 @@ void ath10k_ce_per_engine_service(struct ath10k *ar, unsigned int ce_id)
 	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
 	struct ath10k_ce_pipe *ce_state = &ar_pci->ce_states[ce_id];
 	u32 ctrl_addr = ce_state->ctrl_addr;
-	int ret;
-
-	ret = ath10k_pci_wake(ar);
-	if (ret)
-		return;
 
 	spin_lock_bh(&ar_pci->ce_lock);
 
@@ -760,7 +736,6 @@ void ath10k_ce_per_engine_service(struct ath10k *ar, unsigned int ce_id)
 	ath10k_ce_engine_int_status_clear(ar, ctrl_addr, CE_WATERMARK_MASK);
 
 	spin_unlock_bh(&ar_pci->ce_lock);
-	ath10k_pci_sleep(ar);
 }
 
 /*
@@ -771,13 +746,9 @@ void ath10k_ce_per_engine_service(struct ath10k *ar, unsigned int ce_id)
 
 void ath10k_ce_per_engine_service_any(struct ath10k *ar)
 {
-	int ce_id, ret;
+	int ce_id;
 	u32 intr_summary;
 
-	ret = ath10k_pci_wake(ar);
-	if (ret)
-		return;
-
 	intr_summary = CE_INTERRUPT_SUMMARY(ar);
 
 	for (ce_id = 0; intr_summary && (ce_id < CE_COUNT); ce_id++) {
@@ -789,8 +760,6 @@ void ath10k_ce_per_engine_service_any(struct ath10k *ar)
 
 		ath10k_ce_per_engine_service(ar, ce_id);
 	}
-
-	ath10k_pci_sleep(ar);
 }
 
 /*
@@ -805,11 +774,6 @@ static void ath10k_ce_per_engine_handler_adjust(struct ath10k_ce_pipe *ce_state,
 {
 	u32 ctrl_addr = ce_state->ctrl_addr;
 	struct ath10k *ar = ce_state->ar;
-	int ret;
-
-	ret = ath10k_pci_wake(ar);
-	if (ret)
-		return;
 
 	if ((!disable_copy_compl_intr) &&
 	    (ce_state->send_cb || ce_state->recv_cb))
@@ -818,17 +782,11 @@ static void ath10k_ce_per_engine_handler_adjust(struct ath10k_ce_pipe *ce_state,
 		ath10k_ce_copy_complete_intr_disable(ar, ctrl_addr);
 
 	ath10k_ce_watermark_intr_disable(ar, ctrl_addr);
-
-	ath10k_pci_sleep(ar);
 }
 
 int ath10k_ce_disable_interrupts(struct ath10k *ar)
 {
-	int ce_id, ret;
-
-	ret = ath10k_pci_wake(ar);
-	if (ret)
-		return ret;
+	int ce_id;
 
 	for (ce_id = 0; ce_id < CE_COUNT; ce_id++) {
 		u32 ctrl_addr = ath10k_ce_base_address(ce_id);
@@ -838,8 +796,6 @@ int ath10k_ce_disable_interrupts(struct ath10k *ar)
 		ath10k_ce_watermark_intr_disable(ar, ctrl_addr);
 	}
 
-	ath10k_pci_sleep(ar);
-
 	return 0;
 }
 
@@ -1084,10 +1040,6 @@ int ath10k_ce_init_pipe(struct ath10k *ar, unsigned int ce_id,
 	BUILD_BUG_ON(2*TARGET_10X_NUM_MSDU_DESC >
 		     (CE_HTT_H2T_MSG_SRC_NENTRIES - 1));
 
-	ret = ath10k_pci_wake(ar);
-	if (ret)
-		return ret;
-
 	spin_lock_bh(&ar_pci->ce_lock);
 	ce_state->ar = ar;
 	ce_state->id = ce_id;
@@ -1101,7 +1053,7 @@ int ath10k_ce_init_pipe(struct ath10k *ar, unsigned int ce_id,
 		if (ret) {
 			ath10k_err("Failed to initialize CE src ring for ID: %d (%d)\n",
 				   ce_id, ret);
-			goto out;
+			return ret;
 		}
 	}
 
@@ -1110,13 +1062,11 @@ int ath10k_ce_init_pipe(struct ath10k *ar, unsigned int ce_id,
 		if (ret) {
 			ath10k_err("Failed to initialize CE dest ring for ID: %d (%d)\n",
 				   ce_id, ret);
-			goto out;
+			return ret;
 		}
 	}
 
-out:
-	ath10k_pci_sleep(ar);
-	return ret;
+	return 0;
 }
 
 static void ath10k_ce_deinit_src_ring(struct ath10k *ar, unsigned int ce_id)
@@ -1140,16 +1090,8 @@ static void ath10k_ce_deinit_dest_ring(struct ath10k *ar, unsigned int ce_id)
 
 void ath10k_ce_deinit_pipe(struct ath10k *ar, unsigned int ce_id)
 {
-	int ret;
-
-	ret = ath10k_pci_wake(ar);
-	if (ret)
-		return;
-
 	ath10k_ce_deinit_src_ring(ar, ce_id);
 	ath10k_ce_deinit_dest_ring(ar, ce_id);
-
-	ath10k_pci_sleep(ar);
 }
 
 int ath10k_ce_alloc_pipe(struct ath10k *ar, int ce_id,
diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index a2003b6..5fa45db 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -44,13 +44,9 @@ enum ath10k_pci_reset_mode {
 	ATH10K_PCI_RESET_WARM_ONLY = 1,
 };
 
-static unsigned int ath10k_pci_target_ps;
 static unsigned int ath10k_pci_irq_mode = ATH10K_PCI_IRQ_AUTO;
 static unsigned int ath10k_pci_reset_mode = ATH10K_PCI_RESET_AUTO;
 
-module_param_named(target_ps, ath10k_pci_target_ps, uint, 0644);
-MODULE_PARM_DESC(target_ps, "Enable ath10k Target (SoC) PS option");
-
 module_param_named(irq_mode, ath10k_pci_irq_mode, uint, 0644);
 MODULE_PARM_DESC(irq_mode, "0: auto, 1: legacy, 2: msi (default: 0)");
 
@@ -389,10 +385,8 @@ static int ath10k_pci_diag_read_mem(struct ath10k *ar, u32 address, void *data,
 		 * convert it from Target CPU virtual address space
 		 * to CE address space
 		 */
-		ath10k_pci_wake(ar);
 		address = TARG_CPU_SPACE_TO_CE_SPACE(ar, ar_pci->mem,
 						     address);
-		ath10k_pci_sleep(ar);
 
 		ret = ath10k_ce_send(ce_diag, NULL, (u32)address, nbytes, 0,
 				 0);
@@ -474,9 +468,7 @@ static int ath10k_pci_diag_read_access(struct ath10k *ar, u32 address,
 	if (address >= DRAM_BASE_ADDRESS)
 		return ath10k_pci_diag_read_mem(ar, address, data, sizeof(u32));
 
-	ath10k_pci_wake(ar);
 	*data = ath10k_pci_read32(ar, address);
-	ath10k_pci_sleep(ar);
 	return 0;
 }
 
@@ -528,9 +520,7 @@ static int ath10k_pci_diag_write_mem(struct ath10k *ar, u32 address,
 	 * to
 	 *    CE address space
 	 */
-	ath10k_pci_wake(ar);
 	address = TARG_CPU_SPACE_TO_CE_SPACE(ar, ar_pci->mem, address);
-	ath10k_pci_sleep(ar);
 
 	remaining_bytes = orig_nbytes;
 	ce_data = ce_data_base;
@@ -623,51 +613,25 @@ static int ath10k_pci_diag_write_access(struct ath10k *ar, u32 address,
 		return ath10k_pci_diag_write_mem(ar, address, &data,
 						 sizeof(u32));
 
-	ath10k_pci_wake(ar);
 	ath10k_pci_write32(ar, address, data);
-	ath10k_pci_sleep(ar);
 	return 0;
 }
 
-static bool ath10k_pci_target_is_awake(struct ath10k *ar)
+static bool ath10k_pci_is_awake(struct ath10k *ar)
 {
-	void __iomem *mem = ath10k_pci_priv(ar)->mem;
-	u32 val;
-	val = ioread32(mem + PCIE_LOCAL_BASE_ADDRESS +
-		       RTC_STATE_ADDRESS);
-	return (RTC_STATE_V_GET(val) == RTC_STATE_V_ON);
+	u32 val = ath10k_pci_reg_read32(ar, RTC_STATE_ADDRESS);
+
+	return RTC_STATE_V_GET(val) == RTC_STATE_V_ON;
 }
 
-int ath10k_do_pci_wake(struct ath10k *ar)
+static int ath10k_pci_wake_wait(struct ath10k *ar)
 {
-	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
-	void __iomem *pci_addr = ar_pci->mem;
 	int tot_delay = 0;
 	int curr_delay = 5;
 
-	if (atomic_read(&ar_pci->keep_awake_count) == 0) {
-		/* Force AWAKE */
-		iowrite32(PCIE_SOC_WAKE_V_MASK,
-			  pci_addr + PCIE_LOCAL_BASE_ADDRESS +
-			  PCIE_SOC_WAKE_ADDRESS);
-	}
-	atomic_inc(&ar_pci->keep_awake_count);
-
-	if (ar_pci->verified_awake)
-		return 0;
-
-	for (;;) {
-		if (ath10k_pci_target_is_awake(ar)) {
-			ar_pci->verified_awake = true;
+	while (tot_delay < PCIE_WAKE_TIMEOUT) {
+		if (ath10k_pci_is_awake(ar))
 			return 0;
-		}
-
-		if (tot_delay > PCIE_WAKE_TIMEOUT) {
-			ath10k_warn("target took longer %d us to wake up (awake count %d)\n",
-				    PCIE_WAKE_TIMEOUT,
-				    atomic_read(&ar_pci->keep_awake_count));
-			return -ETIMEDOUT;
-		}
 
 		udelay(curr_delay);
 		tot_delay += curr_delay;
@@ -675,20 +639,21 @@ int ath10k_do_pci_wake(struct ath10k *ar)
 		if (curr_delay < 50)
 			curr_delay += 5;
 	}
+
+	return -ETIMEDOUT;
 }
 
-void ath10k_do_pci_sleep(struct ath10k *ar)
+int ath10k_pci_wake(struct ath10k *ar)
 {
-	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
-	void __iomem *pci_addr = ar_pci->mem;
+	ath10k_pci_reg_write32(ar, PCIE_SOC_WAKE_ADDRESS,
+			       PCIE_SOC_WAKE_V_MASK);
+	return ath10k_pci_wake_wait(ar);
+}
 
-	if (atomic_dec_and_test(&ar_pci->keep_awake_count)) {
-		/* Allow sleep */
-		ar_pci->verified_awake = false;
-		iowrite32(PCIE_SOC_WAKE_RESET,
-			  pci_addr + PCIE_LOCAL_BASE_ADDRESS +
-			  PCIE_SOC_WAKE_ADDRESS);
-	}
+void ath10k_pci_sleep(struct ath10k *ar)
+{
+	ath10k_pci_reg_write32(ar, PCIE_SOC_WAKE_ADDRESS,
+			       PCIE_SOC_WAKE_RESET);
 }
 
 /* Called by lower (CE) layer when a send to Target completes. */
@@ -1788,8 +1753,6 @@ static void ath10k_pci_fw_interrupt_handler(struct ath10k *ar)
 	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
 	u32 fw_indicator;
 
-	ath10k_pci_wake(ar);
-
 	fw_indicator = ath10k_pci_read32(ar, FW_INDICATOR_ADDRESS);
 
 	if (fw_indicator & FW_IND_EVENT_PENDING) {
@@ -1807,8 +1770,6 @@ static void ath10k_pci_fw_interrupt_handler(struct ath10k *ar)
 			ath10k_warn("early firmware event indicated\n");
 		}
 	}
-
-	ath10k_pci_sleep(ar);
 }
 
 /* this function effectively clears target memory controller assert line */
@@ -1838,12 +1799,6 @@ static int ath10k_pci_warm_reset(struct ath10k *ar)
 
 	ath10k_dbg(ATH10K_DBG_BOOT, "boot warm reset\n");
 
-	ret = ath10k_do_pci_wake(ar);
-	if (ret) {
-		ath10k_err("failed to wake up target: %d\n", ret);
-		return ret;
-	}
-
 	/* debug */
 	val = ath10k_pci_read32(ar, SOC_CORE_BASE_ADDRESS +
 				PCIE_INTR_CAUSE_ADDRESS);
@@ -1915,7 +1870,6 @@ static int ath10k_pci_warm_reset(struct ath10k *ar)
 
 	ath10k_dbg(ATH10K_DBG_BOOT, "boot warm reset complete\n");
 
-	ath10k_do_pci_sleep(ar);
 	return ret;
 }
 
@@ -1945,14 +1899,10 @@ static int __ath10k_pci_hif_power_up(struct ath10k *ar, bool cold_reset)
 		goto err;
 	}
 
-	if (!test_bit(ATH10K_PCI_FEATURE_SOC_POWER_SAVE, ar_pci->features))
-		/* Force AWAKE forever */
-		ath10k_do_pci_wake(ar);
-
 	ret = ath10k_pci_ce_init(ar);
 	if (ret) {
 		ath10k_err("failed to initialize CE: %d\n", ret);
-		goto err_ps;
+		goto err;
 	}
 
 	ret = ath10k_ce_disable_interrupts(ar);
@@ -2012,9 +1962,6 @@ err_deinit_irq:
 err_ce:
 	ath10k_pci_ce_deinit(ar);
 	ath10k_pci_warm_reset(ar);
-err_ps:
-	if (!test_bit(ATH10K_PCI_FEATURE_SOC_POWER_SAVE, ar_pci->features))
-		ath10k_do_pci_sleep(ar);
 err:
 	return ret;
 }
@@ -2078,8 +2025,6 @@ static int ath10k_pci_hif_power_up(struct ath10k *ar)
 
 static void ath10k_pci_hif_power_down(struct ath10k *ar)
 {
-	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
-
 	ath10k_dbg(ATH10K_DBG_BOOT, "boot hif power down\n");
 
 	ath10k_pci_free_early_irq(ar);
@@ -2087,9 +2032,6 @@ static void ath10k_pci_hif_power_down(struct ath10k *ar)
 	ath10k_pci_deinit_irq(ar);
 	ath10k_pci_ce_deinit(ar);
 	ath10k_pci_warm_reset(ar);
-
-	if (!test_bit(ATH10K_PCI_FEATURE_SOC_POWER_SAVE, ar_pci->features))
-		ath10k_do_pci_sleep(ar);
 }
 
 #ifdef CONFIG_PM
@@ -2236,14 +2178,6 @@ static void ath10k_pci_early_irq_tasklet(unsigned long data)
 {
 	struct ath10k *ar = (struct ath10k *)data;
 	u32 fw_ind;
-	int ret;
-
-	ret = ath10k_pci_wake(ar);
-	if (ret) {
-		ath10k_warn("failed to wake target in early irq tasklet: %d\n",
-			    ret);
-		return;
-	}
 
 	fw_ind = ath10k_pci_read32(ar, FW_INDICATOR_ADDRESS);
 	if (fw_ind & FW_IND_EVENT_PENDING) {
@@ -2252,7 +2186,6 @@ static void ath10k_pci_early_irq_tasklet(unsigned long data)
 		ath10k_pci_hif_dump_area(ar);
 	}
 
-	ath10k_pci_sleep(ar);
 	ath10k_pci_enable_legacy_irq(ar);
 }
 
@@ -2426,34 +2359,16 @@ static int ath10k_pci_init_irq(struct ath10k *ar)
 	 * synchronization checking. */
 	ar_pci->num_msi_intrs = 0;
 
-	ret = ath10k_pci_wake(ar);
-	if (ret) {
-		ath10k_warn("failed to wake target: %d\n", ret);
-		return ret;
-	}
-
 	ath10k_pci_write32(ar, SOC_CORE_BASE_ADDRESS + PCIE_INTR_ENABLE_ADDRESS,
 			   PCIE_INTR_FIRMWARE_MASK | PCIE_INTR_CE_MASK_ALL);
-	ath10k_pci_sleep(ar);
 
 	return 0;
 }
 
-static int ath10k_pci_deinit_irq_legacy(struct ath10k *ar)
+static void ath10k_pci_deinit_irq_legacy(struct ath10k *ar)
 {
-	int ret;
-
-	ret = ath10k_pci_wake(ar);
-	if (ret) {
-		ath10k_warn("failed to wake target: %d\n", ret);
-		return ret;
-	}
-
 	ath10k_pci_write32(ar, SOC_CORE_BASE_ADDRESS + PCIE_INTR_ENABLE_ADDRESS,
 			   0);
-	ath10k_pci_sleep(ar);
-
-	return 0;
 }
 
 static int ath10k_pci_deinit_irq(struct ath10k *ar)
@@ -2462,7 +2377,8 @@ static int ath10k_pci_deinit_irq(struct ath10k *ar)
 
 	switch (ar_pci->num_msi_intrs) {
 	case 0:
-		return ath10k_pci_deinit_irq_legacy(ar);
+		ath10k_pci_deinit_irq_legacy(ar);
+		return 0;
 	case 1:
 		/* fall-through */
 	case MSI_NUM_REQUEST:
@@ -2480,17 +2396,10 @@ static int ath10k_pci_wait_for_target_init(struct ath10k *ar)
 {
 	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
 	unsigned long timeout;
-	int ret;
 	u32 val;
 
 	ath10k_dbg(ATH10K_DBG_BOOT, "boot waiting target to initialise\n");
 
-	ret = ath10k_pci_wake(ar);
-	if (ret) {
-		ath10k_err("failed to wake up target for init: %d\n", ret);
-		return ret;
-	}
-
 	timeout = jiffies + msecs_to_jiffies(ATH10K_PCI_TARGET_WAIT);
 
 	do {
@@ -2520,8 +2429,7 @@ static int ath10k_pci_wait_for_target_init(struct ath10k *ar)
 
 	if (val == 0xffffffff) {
 		ath10k_err("failed to read device register, device is gone\n");
-		ret = -EIO;
-		goto out;
+		return -EIO;
 	}
 
 	if (val & FW_IND_EVENT_PENDING) {
@@ -2529,38 +2437,26 @@ static int ath10k_pci_wait_for_target_init(struct ath10k *ar)
 		ath10k_pci_write32(ar, FW_INDICATOR_ADDRESS,
 				   val & ~FW_IND_EVENT_PENDING);
 		ath10k_pci_hif_dump_area(ar);
-		ret = -ECOMM;
-		goto out;
+		return -ECOMM;
 	}
 
 	if (!(val & FW_IND_INITIALIZED)) {
 		ath10k_err("failed to receive initialized event from target: %08x\n",
 			   val);
-		ret = -ETIMEDOUT;
-		goto out;
+		return -ETIMEDOUT;
 	}
 
 	ath10k_dbg(ATH10K_DBG_BOOT, "boot target initialised\n");
-
-out:
-	ath10k_pci_sleep(ar);
-	return ret;
+	return 0;
 }
 
 static int ath10k_pci_cold_reset(struct ath10k *ar)
 {
-	int i, ret;
+	int i;
 	u32 val;
 
 	ath10k_dbg(ATH10K_DBG_BOOT, "boot cold reset\n");
 
-	ret = ath10k_do_pci_wake(ar);
-	if (ret) {
-		ath10k_err("failed to wake up target: %d\n",
-			   ret);
-		return ret;
-	}
-
 	/* Put Target, including PCIe, into RESET. */
 	val = ath10k_pci_reg_read32(ar, SOC_GLOBAL_RESET_ADDRESS);
 	val |= 1;
@@ -2584,8 +2480,6 @@ static int ath10k_pci_cold_reset(struct ath10k *ar)
 		msleep(1);
 	}
 
-	ath10k_do_pci_sleep(ar);
-
 	ath10k_dbg(ATH10K_DBG_BOOT, "boot cold reset complete\n");
 
 	return 0;
@@ -2603,9 +2497,6 @@ static void ath10k_pci_dump_features(struct ath10k_pci *ar_pci)
 		case ATH10K_PCI_FEATURE_MSI_X:
 			ath10k_dbg(ATH10K_DBG_BOOT, "device supports MSI-X\n");
 			break;
-		case ATH10K_PCI_FEATURE_SOC_POWER_SAVE:
-			ath10k_dbg(ATH10K_DBG_BOOT, "QCA98XX SoC power save enabled\n");
-			break;
 		}
 	}
 }
@@ -2642,13 +2533,9 @@ static int ath10k_pci_probe(struct pci_dev *pdev,
 		goto err_core_destroy;
 	}
 
-	if (ath10k_pci_target_ps)
-		set_bit(ATH10K_PCI_FEATURE_SOC_POWER_SAVE, ar_pci->features);
-
 	ath10k_pci_dump_features(ar_pci);
 
 	ar_pci->ar = ar;
-	atomic_set(&ar_pci->keep_awake_count, 0);
 
 	pci_set_drvdata(pdev, ar);
 
@@ -2703,20 +2590,22 @@ static int ath10k_pci_probe(struct pci_dev *pdev,
 
 	spin_lock_init(&ar_pci->ce_lock);
 
-	ret = ath10k_do_pci_wake(ar);
+	ret = ath10k_pci_wake(ar);
 	if (ret) {
-		ath10k_err("Failed to get chip id: %d\n", ret);
+		ath10k_err("failed to wake up: %d\n", ret);
 		goto err_iomap;
 	}
 
 	chip_id = ath10k_pci_soc_read32(ar, SOC_CHIP_ID_ADDRESS);
-
-	ath10k_do_pci_sleep(ar);
+	if (chip_id == 0xffffffff) {
+		ath10k_err("failed to get chip id\n");
+		goto err_sleep;
+	}
 
 	ret = ath10k_pci_alloc_ce(ar);
 	if (ret) {
 		ath10k_err("failed to allocate copy engine pipes: %d\n", ret);
-		goto err_iomap;
+		goto err_sleep;
 	}
 
 	ath10k_dbg(ATH10K_DBG_BOOT, "boot pci_mem 0x%p\n", ar_pci->mem);
@@ -2731,6 +2620,8 @@ static int ath10k_pci_probe(struct pci_dev *pdev,
 
 err_free_ce:
 	ath10k_pci_free_ce(ar);
+err_sleep:
+	ath10k_pci_sleep(ar);
 err_iomap:
 	pci_iounmap(pdev, mem);
 err_master:
@@ -2762,6 +2653,7 @@ static void ath10k_pci_remove(struct pci_dev *pdev)
 
 	ath10k_core_unregister(ar);
 	ath10k_pci_free_ce(ar);
+	ath10k_pci_sleep(ar);
 
 	pci_iounmap(pdev, ar_pci->mem);
 	pci_release_region(pdev, BAR_NUM);
diff --git a/drivers/net/wireless/ath/ath10k/pci.h b/drivers/net/wireless/ath/ath10k/pci.h
index 531c98a..65b1b90 100644
--- a/drivers/net/wireless/ath/ath10k/pci.h
+++ b/drivers/net/wireless/ath/ath10k/pci.h
@@ -137,7 +137,6 @@ struct service_to_pipe {
 
 enum ath10k_pci_features {
 	ATH10K_PCI_FEATURE_MSI_X		= 0,
-	ATH10K_PCI_FEATURE_SOC_POWER_SAVE	= 1,
 
 	/* keep last */
 	ATH10K_PCI_FEATURE_COUNT
@@ -183,9 +182,6 @@ struct ath10k_pci {
 
 	int started;
 
-	atomic_t keep_awake_count;
-	bool verified_awake;
-
 	struct ath10k_pci_pipe pipe_info[CE_COUNT_MAX];
 
 	struct ath10k_hif_cb msg_callbacks_current;
@@ -205,20 +201,6 @@ static inline struct ath10k_pci *ath10k_pci_priv(struct ath10k *ar)
 	return (struct ath10k_pci *)ar->drv_priv;
 }
 
-static inline u32 ath10k_pci_reg_read32(struct ath10k *ar, u32 addr)
-{
-	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
-
-	return ioread32(ar_pci->mem + PCIE_LOCAL_BASE_ADDRESS + addr);
-}
-
-static inline void ath10k_pci_reg_write32(struct ath10k *ar, u32 addr, u32 val)
-{
-	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
-
-	iowrite32(val, ar_pci->mem + PCIE_LOCAL_BASE_ADDRESS + addr);
-}
-
 #define ATH_PCI_RESET_WAIT_MAX 10 /* ms */
 #define PCIE_WAKE_TIMEOUT 5000	/* 5ms */
 
@@ -242,35 +224,17 @@ static inline void ath10k_pci_reg_write32(struct ath10k *ar, u32 addr, u32 val)
 /* Wait up to this many Ms for a Diagnostic Access CE operation to complete */
 #define DIAG_ACCESS_CE_TIMEOUT_MS 10
 
-/*
- * This API allows the Host to access Target registers directly
- * and relatively efficiently over PCIe.
- * This allows the Host to avoid extra overhead associated with
- * sending a message to firmware and waiting for a response message
- * from firmware, as is done on other interconnects.
- *
- * Yet there is some complexity with direct accesses because the
- * Target's power state is not known a priori. The Host must issue
- * special PCIe reads/writes in order to explicitly wake the Target
- * and to verify that it is awake and will remain awake.
+/* Target exposes its registers for direct access. However before host can
+ * access them it needs to make sure the target is awake (ath10k_pci_wake,
+ * ath10k_pci_wake_wait, ath10k_pci_is_awake). Once target is awake it won't go
+ * to sleep unless host tells it to (ath10k_pci_sleep).
  *
- * Usage:
+ * If host tries to access target registers without waking it up it can
+ * scribble over host memory.
  *
- *   Use ath10k_pci_read32 and ath10k_pci_write32 to access Target space.
- *   These calls must be bracketed by ath10k_pci_wake and
- *   ath10k_pci_sleep.  A single BEGIN/END pair is adequate for
- *   multiple READ/WRITE operations.
- *
- *   Use ath10k_pci_wake to put the Target in a state in
- *   which it is legal for the Host to directly access it. This
- *   may involve waking the Target from a low power state, which
- *   may take up to 2Ms!
- *
- *   Use ath10k_pci_sleep to tell the Target that as far as
- *   this code path is concerned, it no longer needs to remain
- *   directly accessible.  BEGIN/END is under a reference counter;
- *   multiple code paths may issue BEGIN/END on a single targid.
+ * If target is asleep waking it up may take up to even 2ms.
  */
+
 static inline void ath10k_pci_write32(struct ath10k *ar, u32 offset,
 				      u32 value)
 {
@@ -296,25 +260,18 @@ static inline void ath10k_pci_soc_write32(struct ath10k *ar, u32 addr, u32 val)
 	ath10k_pci_write32(ar, RTC_SOC_BASE_ADDRESS + addr, val);
 }
 
-int ath10k_do_pci_wake(struct ath10k *ar);
-void ath10k_do_pci_sleep(struct ath10k *ar);
-
-static inline int ath10k_pci_wake(struct ath10k *ar)
+static inline u32 ath10k_pci_reg_read32(struct ath10k *ar, u32 addr)
 {
 	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
 
-	if (test_bit(ATH10K_PCI_FEATURE_SOC_POWER_SAVE, ar_pci->features))
-		return ath10k_do_pci_wake(ar);
-
-	return 0;
+	return ioread32(ar_pci->mem + PCIE_LOCAL_BASE_ADDRESS + addr);
 }
 
-static inline void ath10k_pci_sleep(struct ath10k *ar)
+static inline void ath10k_pci_reg_write32(struct ath10k *ar, u32 addr, u32 val)
 {
 	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
 
-	if (test_bit(ATH10K_PCI_FEATURE_SOC_POWER_SAVE, ar_pci->features))
-		ath10k_do_pci_sleep(ar);
+	iowrite32(val, ar_pci->mem + PCIE_LOCAL_BASE_ADDRESS + addr);
 }
 
 #endif /* _PCI_H_ */
-- 
1.8.5.3

