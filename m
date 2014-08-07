Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f177.google.com ([74.125.82.177]:54049 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757334AbaHGJNw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Aug 2014 05:13:52 -0400
Received: by mail-we0-f177.google.com with SMTP id w62so3767443wes.8
        for <linux-wireless@vger.kernel.org>; Thu, 07 Aug 2014 02:13:51 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 3/5] ath10k: remove early irq handling
Date: Thu,  7 Aug 2014 11:04:18 +0200
Message-Id: <1407402260-29854-4-git-send-email-michal.kazior@tieto.com> (sfid-20140807_111356_798072_B874980B)
In-Reply-To: <1407402260-29854-1-git-send-email-michal.kazior@tieto.com>
References: <1407402260-29854-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It's not really necessary to have a dedicated irq
handler just for the sake of catching early fw
crashes. It is now safe to use one handler even
during early stages of device boot up.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/pci.c | 160 ++++++++--------------------------
 1 file changed, 36 insertions(+), 124 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index 2272f76..a61dfcf 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -266,46 +266,6 @@ static void ath10k_pci_enable_legacy_irq(struct ath10k *ar)
 				 PCIE_INTR_ENABLE_ADDRESS);
 }
 
-static irqreturn_t ath10k_pci_early_irq_handler(int irq, void *arg)
-{
-	struct ath10k *ar = arg;
-	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
-
-	if (ar_pci->num_msi_intrs == 0) {
-		if (!ath10k_pci_irq_pending(ar))
-			return IRQ_NONE;
-
-		ath10k_pci_disable_and_clear_legacy_irq(ar);
-	}
-
-	tasklet_schedule(&ar_pci->early_irq_tasklet);
-
-	return IRQ_HANDLED;
-}
-
-static int ath10k_pci_request_early_irq(struct ath10k *ar)
-{
-	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
-	int ret;
-
-	/* Regardless whether MSI-X/MSI/legacy irqs have been set up the first
-	 * interrupt from irq vector is triggered in all cases for FW
-	 * indication/errors */
-	ret = request_irq(ar_pci->pdev->irq, ath10k_pci_early_irq_handler,
-			  IRQF_SHARED, "ath10k_pci (early)", ar);
-	if (ret) {
-		ath10k_warn("failed to request early irq: %d\n", ret);
-		return ret;
-	}
-
-	return 0;
-}
-
-static void ath10k_pci_free_early_irq(struct ath10k *ar)
-{
-	free_irq(ath10k_pci_priv(ar)->pdev->irq, ar);
-}
-
 static inline const char *ath10k_pci_get_irq_method(struct ath10k *ar)
 {
 	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
@@ -931,7 +891,6 @@ static void ath10k_pci_kill_tasklet(struct ath10k *ar)
 
 	tasklet_kill(&ar_pci->intr_tq);
 	tasklet_kill(&ar_pci->msi_fw_err);
-	tasklet_kill(&ar_pci->early_irq_tasklet);
 
 	for (i = 0; i < CE_COUNT; i++)
 		tasklet_kill(&ar_pci->pipe_info[i].intr);
@@ -1107,20 +1066,10 @@ static int ath10k_pci_post_rx(struct ath10k *ar)
 static int ath10k_pci_hif_start(struct ath10k *ar)
 {
 	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
-	int ret, ret_early;
+	int ret;
 
 	ath10k_dbg(ATH10K_DBG_BOOT, "boot hif start\n");
 
-	ath10k_pci_free_early_irq(ar);
-	ath10k_pci_kill_tasklet(ar);
-
-	ret = ath10k_pci_request_irq(ar);
-	if (ret) {
-		ath10k_warn("failed to post RX buffers for all pipes: %d\n",
-			    ret);
-		goto err_early_irq;
-	}
-
 	ret = ath10k_pci_setup_ce_irq(ar);
 	if (ret) {
 		ath10k_warn("failed to setup CE interrupts: %d\n", ret);
@@ -1140,15 +1089,7 @@ static int ath10k_pci_hif_start(struct ath10k *ar)
 
 err_stop:
 	ath10k_ce_disable_interrupts(ar);
-	ath10k_pci_free_irq(ar);
 	ath10k_pci_kill_tasklet(ar);
-err_early_irq:
-	/* Though there should be no interrupts (device was reset)
-	 * power_down() expects the early IRQ to be installed as per the
-	 * driver lifecycle. */
-	ret_early = ath10k_pci_request_early_irq(ar);
-	if (ret_early)
-		ath10k_warn("failed to re-enable early irq: %d\n", ret_early);
 
 	return ret;
 }
@@ -1266,13 +1207,8 @@ static void ath10k_pci_hif_stop(struct ath10k *ar)
 	if (ret)
 		ath10k_warn("failed to disable CE interrupts: %d\n", ret);
 
-	ath10k_pci_free_irq(ar);
 	ath10k_pci_kill_tasklet(ar);
 
-	ret = ath10k_pci_request_early_irq(ar);
-	if (ret)
-		ath10k_warn("failed to re-enable early irq: %d\n", ret);
-
 	/* At this point, asynchronous threads are stopped, the target should
 	 * not DMA nor interrupt. We process the leftovers and then free
 	 * everything else up. */
@@ -1760,28 +1696,17 @@ static int ath10k_pci_ce_init(struct ath10k *ar)
 	return 0;
 }
 
-static void ath10k_pci_fw_interrupt_handler(struct ath10k *ar)
+static bool ath10k_pci_fw_crashed(struct ath10k *ar)
 {
-	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
-	u32 fw_indicator;
-
-	fw_indicator = ath10k_pci_read32(ar, FW_INDICATOR_ADDRESS);
-
-	if (fw_indicator & FW_IND_EVENT_PENDING) {
-		/* ACK: clear Target-side pending event */
-		ath10k_pci_write32(ar, FW_INDICATOR_ADDRESS,
-				   fw_indicator & ~FW_IND_EVENT_PENDING);
+	return ath10k_pci_read32(ar, FW_INDICATOR_ADDRESS) &
+	       FW_IND_EVENT_PENDING;
+}
 
-		if (ar_pci->started) {
-			ath10k_pci_hif_dump_area(ar);
-		} else {
-			/*
-			 * Probable Target failure before we're prepared
-			 * to handle it.  Generally unexpected.
-			 */
-			ath10k_warn("early firmware event indicated\n");
-		}
-	}
+static void ath10k_pci_fw_crashed_clear(struct ath10k *ar)
+{
+	ath10k_pci_write32(ar, FW_INDICATOR_ADDRESS,
+			   (ath10k_pci_read32(ar, FW_INDICATOR_ADDRESS) &
+			    ~FW_IND_EVENT_PENDING));
 }
 
 /* this function effectively clears target memory controller assert line */
@@ -1915,34 +1840,26 @@ static int __ath10k_pci_hif_power_up(struct ath10k *ar, bool cold_reset)
 		goto err;
 	}
 
-	ret = ath10k_pci_request_early_irq(ar);
-	if (ret) {
-		ath10k_err("failed to request early irq: %d\n", ret);
-		goto err_ce;
-	}
-
 	ret = ath10k_pci_wait_for_target_init(ar);
 	if (ret) {
 		ath10k_err("failed to wait for target to init: %d\n", ret);
-		goto err_free_early_irq;
+		goto err_ce;
 	}
 
 	ret = ath10k_pci_init_config(ar);
 	if (ret) {
 		ath10k_err("failed to setup init config: %d\n", ret);
-		goto err_free_early_irq;
+		goto err_ce;
 	}
 
 	ret = ath10k_pci_wake_target_cpu(ar);
 	if (ret) {
 		ath10k_err("could not wake up target CPU: %d\n", ret);
-		goto err_free_early_irq;
+		goto err_ce;
 	}
 
 	return 0;
 
-err_free_early_irq:
-	ath10k_pci_free_early_irq(ar);
 err_ce:
 	ath10k_pci_ce_deinit(ar);
 	ath10k_pci_warm_reset(ar);
@@ -2011,7 +1928,6 @@ static void ath10k_pci_hif_power_down(struct ath10k *ar)
 {
 	ath10k_dbg(ATH10K_DBG_BOOT, "boot hif power down\n");
 
-	ath10k_pci_free_early_irq(ar);
 	ath10k_pci_kill_tasklet(ar);
 	ath10k_pci_warm_reset(ar);
 }
@@ -2095,7 +2011,13 @@ static void ath10k_msi_err_tasklet(unsigned long data)
 {
 	struct ath10k *ar = (struct ath10k *)data;
 
-	ath10k_pci_fw_interrupt_handler(ar);
+	if (!ath10k_pci_fw_crashed(ar)) {
+		ath10k_warn("received unsolicited fw crash interrupt\n");
+		return;
+	}
+
+	ath10k_pci_fw_crashed_clear(ar);
+	ath10k_pci_hif_dump_area(ar);
 }
 
 /*
@@ -2156,27 +2078,17 @@ static irqreturn_t ath10k_pci_interrupt_handler(int irq, void *arg)
 	return IRQ_HANDLED;
 }
 
-static void ath10k_pci_early_irq_tasklet(unsigned long data)
+static void ath10k_pci_tasklet(unsigned long data)
 {
 	struct ath10k *ar = (struct ath10k *)data;
-	u32 fw_ind;
+	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
 
-	fw_ind = ath10k_pci_read32(ar, FW_INDICATOR_ADDRESS);
-	if (fw_ind & FW_IND_EVENT_PENDING) {
-		ath10k_pci_write32(ar, FW_INDICATOR_ADDRESS,
-				   fw_ind & ~FW_IND_EVENT_PENDING);
+	if (ath10k_pci_fw_crashed(ar)) {
+		ath10k_pci_fw_crashed_clear(ar);
 		ath10k_pci_hif_dump_area(ar);
+		return;
 	}
 
-	ath10k_pci_enable_legacy_irq(ar);
-}
-
-static void ath10k_pci_tasklet(unsigned long data)
-{
-	struct ath10k *ar = (struct ath10k *)data;
-	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
-
-	ath10k_pci_fw_interrupt_handler(ar); /* FIXME: Handle FW error */
 	ath10k_ce_per_engine_service_any(ar);
 
 	/* Re-enable legacy irq that was disabled in the irq handler */
@@ -2287,8 +2199,6 @@ static void ath10k_pci_init_irq_tasklets(struct ath10k *ar)
 	tasklet_init(&ar_pci->intr_tq, ath10k_pci_tasklet, (unsigned long)ar);
 	tasklet_init(&ar_pci->msi_fw_err, ath10k_msi_err_tasklet,
 		     (unsigned long)ar);
-	tasklet_init(&ar_pci->early_irq_tasklet, ath10k_pci_early_irq_tasklet,
-		     (unsigned long)ar);
 
 	for (i = 0; i < CE_COUNT; i++) {
 		ar_pci->pipe_info[i].ar_pci = ar_pci;
@@ -2412,14 +2322,6 @@ static int ath10k_pci_wait_for_target_init(struct ath10k *ar)
 		return -EIO;
 	}
 
-	if (val & FW_IND_EVENT_PENDING) {
-		ath10k_warn("device has crashed during init\n");
-		ath10k_pci_write32(ar, FW_INDICATOR_ADDRESS,
-				   val & ~FW_IND_EVENT_PENDING);
-		ath10k_pci_hif_dump_area(ar);
-		return -ECOMM;
-	}
-
 	if (!(val & FW_IND_INITIALIZED)) {
 		ath10k_err("failed to receive initialized event from target: %08x\n",
 			   val);
@@ -2612,14 +2514,23 @@ static int ath10k_pci_probe(struct pci_dev *pdev,
 		    ath10k_pci_get_irq_method(ar), ar_pci->num_msi_intrs,
 		    ath10k_pci_irq_mode, ath10k_pci_reset_mode);
 
+	ret = ath10k_pci_request_irq(ar);
+	if (ret) {
+		ath10k_warn("failed to request irqs: %d\n", ret);
+		goto err_deinit_irq;
+	}
+
 	ret = ath10k_core_register(ar, chip_id);
 	if (ret) {
 		ath10k_err("failed to register driver core: %d\n", ret);
-		goto err_deinit_irq;
+		goto err_free_irq;
 	}
 
 	return 0;
 
+err_free_irq:
+	ath10k_pci_free_irq(ar);
+
 err_deinit_irq:
 	ath10k_pci_deinit_irq(ar);
 
@@ -2654,6 +2565,7 @@ static void ath10k_pci_remove(struct pci_dev *pdev)
 		return;
 
 	ath10k_core_unregister(ar);
+	ath10k_pci_free_irq(ar);
 	ath10k_pci_deinit_irq(ar);
 	ath10k_pci_ce_deinit(ar);
 	ath10k_pci_free_ce(ar);
-- 
1.8.5.3

