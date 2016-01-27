Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:21913 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754144AbcA0J4e (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Jan 2016 04:56:34 -0500
From: Raja Mani <rmani@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Raja Mani <rmani@qti.qualcomm.com>
Subject: [PATCH 01/12] ath10k: make some of ath10k_pci_* func reusable
Date: Wed, 27 Jan 2016 15:24:22 +0530
Message-ID: <1453888473-2879-2-git-send-email-rmani@qti.qualcomm.com> (sfid-20160127_105808_509621_74F360CD)
In-Reply-To: <1453888473-2879-1-git-send-email-rmani@qti.qualcomm.com>
References: <1453888473-2879-1-git-send-email-rmani@qti.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some of static functions present in pci.c file are reusable
in ahb (qca4019) case. Remove static word for those reusable
functions and have those function prototype declaration in
pci.h file. So that, pci.h header file can be included in
ahb module and reused. There is no functionality changes done
in this patch.

Signed-off-by: Raja Mani <rmani@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/pci.c | 63 +++++++++++++++++------------------
 drivers/net/wireless/ath/ath10k/pci.h | 32 ++++++++++++++++++
 2 files changed, 63 insertions(+), 32 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index ee925c6..956e548 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -94,7 +94,6 @@ static const struct ath10k_pci_supp_chip ath10k_pci_supp_chips[] = {
 static void ath10k_pci_buffer_cleanup(struct ath10k *ar);
 static int ath10k_pci_cold_reset(struct ath10k *ar);
 static int ath10k_pci_safe_chip_reset(struct ath10k *ar);
-static int ath10k_pci_wait_for_target_init(struct ath10k *ar);
 static int ath10k_pci_init_irq(struct ath10k *ar);
 static int ath10k_pci_deinit_irq(struct ath10k *ar);
 static int ath10k_pci_request_irq(struct ath10k *ar);
@@ -687,7 +686,7 @@ void ath10k_pci_reg_write32(struct ath10k *ar, u32 addr, u32 val)
 	ath10k_pci_write32(ar, PCIE_LOCAL_BASE_ADDRESS + addr, val);
 }
 
-static bool ath10k_pci_irq_pending(struct ath10k *ar)
+bool ath10k_pci_irq_pending(struct ath10k *ar)
 {
 	u32 cause;
 
@@ -700,7 +699,7 @@ static bool ath10k_pci_irq_pending(struct ath10k *ar)
 	return false;
 }
 
-static void ath10k_pci_disable_and_clear_legacy_irq(struct ath10k *ar)
+void ath10k_pci_disable_and_clear_legacy_irq(struct ath10k *ar)
 {
 	/* IMPORTANT: INTR_CLR register has to be set after
 	 * INTR_ENABLE is set to 0, otherwise interrupt can not be
@@ -716,7 +715,7 @@ static void ath10k_pci_disable_and_clear_legacy_irq(struct ath10k *ar)
 				PCIE_INTR_ENABLE_ADDRESS);
 }
 
-static void ath10k_pci_enable_legacy_irq(struct ath10k *ar)
+void ath10k_pci_enable_legacy_irq(struct ath10k *ar)
 {
 	ath10k_pci_write32(ar, SOC_CORE_BASE_ADDRESS +
 			   PCIE_INTR_ENABLE_ADDRESS,
@@ -809,7 +808,7 @@ static void ath10k_pci_rx_post_pipe(struct ath10k_pci_pipe *pipe)
 	}
 }
 
-static void ath10k_pci_rx_post(struct ath10k *ar)
+void ath10k_pci_rx_post(struct ath10k *ar)
 {
 	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
 	int i;
@@ -818,7 +817,7 @@ static void ath10k_pci_rx_post(struct ath10k *ar)
 		ath10k_pci_rx_post_pipe(&ar_pci->pipe_info[i]);
 }
 
-static void ath10k_pci_rx_replenish_retry(unsigned long ptr)
+void ath10k_pci_rx_replenish_retry(unsigned long ptr)
 {
 	struct ath10k *ar = (void *)ptr;
 
@@ -1007,8 +1006,8 @@ static int __ath10k_pci_diag_read_hi(struct ath10k *ar, void *dest,
 #define ath10k_pci_diag_read_hi(ar, dest, src, len)		\
 	__ath10k_pci_diag_read_hi(ar, dest, HI_ITEM(src), len)
 
-static int ath10k_pci_diag_write_mem(struct ath10k *ar, u32 address,
-				     const void *data, int nbytes)
+int ath10k_pci_diag_write_mem(struct ath10k *ar, u32 address,
+			      const void *data, int nbytes)
 {
 	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
 	int ret = 0;
@@ -1263,8 +1262,8 @@ static void ath10k_pci_htt_rx_cb(struct ath10k_ce_pipe *ce_state)
 	ath10k_pci_process_rx_cb(ce_state, ath10k_pci_htt_rx_deliver);
 }
 
-static int ath10k_pci_hif_tx_sg(struct ath10k *ar, u8 pipe_id,
-				struct ath10k_hif_sg_item *items, int n_items)
+int ath10k_pci_hif_tx_sg(struct ath10k *ar, u8 pipe_id,
+			 struct ath10k_hif_sg_item *items, int n_items)
 {
 	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
 	struct ath10k_pci_pipe *pci_pipe = &ar_pci->pipe_info[pipe_id];
@@ -1332,13 +1331,13 @@ err:
 	return err;
 }
 
-static int ath10k_pci_hif_diag_read(struct ath10k *ar, u32 address, void *buf,
-				    size_t buf_len)
+int ath10k_pci_hif_diag_read(struct ath10k *ar, u32 address, void *buf,
+			     size_t buf_len)
 {
 	return ath10k_pci_diag_read_mem(ar, address, buf, buf_len);
 }
 
-static u16 ath10k_pci_hif_get_free_queue_number(struct ath10k *ar, u8 pipe)
+u16 ath10k_pci_hif_get_free_queue_number(struct ath10k *ar, u8 pipe)
 {
 	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
 
@@ -1406,8 +1405,8 @@ static void ath10k_pci_fw_crashed_dump(struct ath10k *ar)
 	queue_work(ar->workqueue, &ar->restart_work);
 }
 
-static void ath10k_pci_hif_send_complete_check(struct ath10k *ar, u8 pipe,
-					       int force)
+void ath10k_pci_hif_send_complete_check(struct ath10k *ar, u8 pipe,
+					int force)
 {
 	ath10k_dbg(ar, ATH10K_DBG_PCI, "pci hif send complete check\n");
 
@@ -1432,7 +1431,7 @@ static void ath10k_pci_hif_send_complete_check(struct ath10k *ar, u8 pipe,
 	ath10k_ce_per_engine_service(ar, pipe);
 }
 
-static void ath10k_pci_kill_tasklet(struct ath10k *ar)
+void ath10k_pci_kill_tasklet(struct ath10k *ar)
 {
 	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
 	int i;
@@ -1446,8 +1445,8 @@ static void ath10k_pci_kill_tasklet(struct ath10k *ar)
 	del_timer_sync(&ar_pci->rx_post_retry);
 }
 
-static int ath10k_pci_hif_map_service_to_pipe(struct ath10k *ar, u16 service_id,
-					      u8 *ul_pipe, u8 *dl_pipe)
+int ath10k_pci_hif_map_service_to_pipe(struct ath10k *ar, u16 service_id,
+				       u8 *ul_pipe, u8 *dl_pipe)
 {
 	const struct service_to_pipe *entry;
 	bool ul_set = false, dl_set = false;
@@ -1491,8 +1490,8 @@ static int ath10k_pci_hif_map_service_to_pipe(struct ath10k *ar, u16 service_id,
 	return 0;
 }
 
-static void ath10k_pci_hif_get_default_pipe(struct ath10k *ar,
-					    u8 *ul_pipe, u8 *dl_pipe)
+void ath10k_pci_hif_get_default_pipe(struct ath10k *ar,
+				     u8 *ul_pipe, u8 *dl_pipe)
 {
 	ath10k_dbg(ar, ATH10K_DBG_PCI, "pci hif get default pipe\n");
 
@@ -1668,7 +1667,7 @@ static void ath10k_pci_buffer_cleanup(struct ath10k *ar)
 	}
 }
 
-static void ath10k_pci_ce_deinit(struct ath10k *ar)
+void ath10k_pci_ce_deinit(struct ath10k *ar)
 {
 	int i;
 
@@ -1676,7 +1675,7 @@ static void ath10k_pci_ce_deinit(struct ath10k *ar)
 		ath10k_ce_deinit_pipe(ar, i);
 }
 
-static void ath10k_pci_flush(struct ath10k *ar)
+void ath10k_pci_flush(struct ath10k *ar)
 {
 	ath10k_pci_kill_tasklet(ar);
 	ath10k_pci_buffer_cleanup(ar);
@@ -1711,9 +1710,9 @@ static void ath10k_pci_hif_stop(struct ath10k *ar)
 	spin_unlock_irqrestore(&ar_pci->ps_lock, flags);
 }
 
-static int ath10k_pci_hif_exchange_bmi_msg(struct ath10k *ar,
-					   void *req, u32 req_len,
-					   void *resp, u32 *resp_len)
+int ath10k_pci_hif_exchange_bmi_msg(struct ath10k *ar,
+				    void *req, u32 req_len,
+				    void *resp, u32 *resp_len)
 {
 	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
 	struct ath10k_pci_pipe *pci_tx = &ar_pci->pipe_info[BMI_CE_NUM_TO_TARG];
@@ -1907,7 +1906,7 @@ static int ath10k_pci_get_num_banks(struct ath10k *ar)
 	return 1;
 }
 
-static int ath10k_pci_init_config(struct ath10k *ar)
+int ath10k_pci_init_config(struct ath10k *ar)
 {
 	u32 interconnect_targ_addr;
 	u32 pcie_state_targ_addr = 0;
@@ -2071,7 +2070,7 @@ static void ath10k_pci_override_ce_config(struct ath10k *ar)
 	target_service_to_ce_map_wlan[15].pipenum = __cpu_to_le32(1);
 }
 
-static int ath10k_pci_alloc_pipes(struct ath10k *ar)
+int ath10k_pci_alloc_pipes(struct ath10k *ar)
 {
 	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
 	struct ath10k_pci_pipe *pipe;
@@ -2102,7 +2101,7 @@ static int ath10k_pci_alloc_pipes(struct ath10k *ar)
 	return 0;
 }
 
-static void ath10k_pci_free_pipes(struct ath10k *ar)
+void ath10k_pci_free_pipes(struct ath10k *ar)
 {
 	int i;
 
@@ -2110,7 +2109,7 @@ static void ath10k_pci_free_pipes(struct ath10k *ar)
 		ath10k_ce_free_pipe(ar, i);
 }
 
-static int ath10k_pci_init_pipes(struct ath10k *ar)
+int ath10k_pci_init_pipes(struct ath10k *ar)
 {
 	int i, ret;
 
@@ -2453,7 +2452,7 @@ err_sleep:
 	return ret;
 }
 
-static void ath10k_pci_hif_power_down(struct ath10k *ar)
+void ath10k_pci_hif_power_down(struct ath10k *ar)
 {
 	ath10k_dbg(ar, ATH10K_DBG_BOOT, "boot hif power down\n");
 
@@ -2722,7 +2721,7 @@ static void ath10k_pci_free_irq(struct ath10k *ar)
 		free_irq(ar_pci->pdev->irq + i, ar);
 }
 
-static void ath10k_pci_init_irq_tasklets(struct ath10k *ar)
+void ath10k_pci_init_irq_tasklets(struct ath10k *ar)
 {
 	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
 	int i;
@@ -2808,7 +2807,7 @@ static int ath10k_pci_deinit_irq(struct ath10k *ar)
 	return 0;
 }
 
-static int ath10k_pci_wait_for_target_init(struct ath10k *ar)
+int ath10k_pci_wait_for_target_init(struct ath10k *ar)
 {
 	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
 	unsigned long timeout;
diff --git a/drivers/net/wireless/ath/ath10k/pci.h b/drivers/net/wireless/ath/ath10k/pci.h
index f91bf33..ae76131 100644
--- a/drivers/net/wireless/ath/ath10k/pci.h
+++ b/drivers/net/wireless/ath/ath10k/pci.h
@@ -253,6 +253,38 @@ u32 ath10k_pci_read32(struct ath10k *ar, u32 offset);
 u32 ath10k_pci_soc_read32(struct ath10k *ar, u32 addr);
 u32 ath10k_pci_reg_read32(struct ath10k *ar, u32 addr);
 
+int ath10k_pci_hif_tx_sg(struct ath10k *ar, u8 pipe_id,
+			 struct ath10k_hif_sg_item *items, int n_items);
+int ath10k_pci_hif_diag_read(struct ath10k *ar, u32 address, void *buf,
+			     size_t buf_len);
+int ath10k_pci_diag_write_mem(struct ath10k *ar, u32 address,
+			      const void *data, int nbytes);
+int ath10k_pci_hif_exchange_bmi_msg(struct ath10k *ar, void *req, u32 req_len,
+				    void *resp, u32 *resp_len);
+int ath10k_pci_hif_map_service_to_pipe(struct ath10k *ar, u16 service_id,
+				       u8 *ul_pipe, u8 *dl_pipe);
+void ath10k_pci_hif_get_default_pipe(struct ath10k *ar, u8 *ul_pipe,
+				     u8 *dl_pipe);
+void ath10k_pci_hif_send_complete_check(struct ath10k *ar, u8 pipe,
+					int force);
+u16 ath10k_pci_hif_get_free_queue_number(struct ath10k *ar, u8 pipe);
+void ath10k_pci_hif_power_down(struct ath10k *ar);
+int ath10k_pci_alloc_pipes(struct ath10k *ar);
+void ath10k_pci_free_pipes(struct ath10k *ar);
+void ath10k_pci_free_pipes(struct ath10k *ar);
+void ath10k_pci_rx_replenish_retry(unsigned long ptr);
+void ath10k_pci_ce_deinit(struct ath10k *ar);
+void ath10k_pci_init_irq_tasklets(struct ath10k *ar);
+void ath10k_pci_kill_tasklet(struct ath10k *ar);
+int ath10k_pci_init_pipes(struct ath10k *ar);
+int ath10k_pci_init_config(struct ath10k *ar);
+void ath10k_pci_rx_post(struct ath10k *ar);
+void ath10k_pci_flush(struct ath10k *ar);
+void ath10k_pci_enable_legacy_irq(struct ath10k *ar);
+bool ath10k_pci_irq_pending(struct ath10k *ar);
+void ath10k_pci_disable_and_clear_legacy_irq(struct ath10k *ar);
+int ath10k_pci_wait_for_target_init(struct ath10k *ar);
+
 /* QCA6174 is known to have Tx/Rx issues when SOC_WAKE register is poked too
  * frequently. To avoid this put SoC to sleep after a very conservative grace
  * period. Adjust with great care.
-- 
1.8.1.2

