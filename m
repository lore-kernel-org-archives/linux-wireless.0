Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f45.google.com ([209.85.215.45]:39314 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756131AbaHVMdd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Aug 2014 08:33:33 -0400
Received: by mail-la0-f45.google.com with SMTP id ty20so9958656lab.32
        for <linux-wireless@vger.kernel.org>; Fri, 22 Aug 2014 05:33:31 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v2 6/6] ath10k: remove early irq handling
Date: Fri, 22 Aug 2014 14:23:34 +0200
Message-Id: <1408710214-24894-7-git-send-email-michal.kazior@tieto.com> (sfid-20140822_143337_828348_8B59B3FC)
In-Reply-To: <1408710214-24894-1-git-send-email-michal.kazior@tieto.com>
References: <1408710214-24894-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It's not really necessary to have a dedicated irq
handler just for the sake of catching early fw
crashes anymore. It is now safe to use one handler
even during early stages of device boot up.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---

Notes:
    v2:
     * remove early_tasket_struct [Kalle]
     * s/ath10k_pci_fw_crashed/ath10k_pci_has_fw_crashed [Kalle]
     * perform warm reset before initializing irq

 drivers/net/wireless/ath/ath10k/pci.c | 172 ++++++++++------------------------
 drivers/net/wireless/ath/ath10k/pci.h |   1 -
 2 files changed, 48 insertions(+), 125 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index 6224952..ffb980c 100644
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
@@ -948,7 +908,6 @@ static void ath10k_pci_kill_tasklet(struct ath10k *ar)
 
 	tasklet_kill(&ar_pci->intr_tq);
 	tasklet_kill(&ar_pci->msi_fw_err);
-	tasklet_kill(&ar_pci->early_irq_tasklet);
 
 	for (i = 0; i < CE_COUNT; i++)
 		tasklet_kill(&ar_pci->pipe_info[i].intr);
@@ -1158,20 +1117,10 @@ static void ath10k_pci_irq_enable(struct ath10k *ar)
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
 	ath10k_pci_irq_enable(ar);
 
 	/* Post buffers once to start things off. */
@@ -1187,15 +1136,7 @@ static int ath10k_pci_hif_start(struct ath10k *ar)
 
 err_stop:
 	ath10k_pci_irq_disable(ar);
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
@@ -1302,7 +1243,6 @@ static void ath10k_pci_ce_deinit(struct ath10k *ar)
 static void ath10k_pci_hif_stop(struct ath10k *ar)
 {
 	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
-	int ret;
 
 	ath10k_dbg(ATH10K_DBG_BOOT, "boot hif stop\n");
 
@@ -1310,17 +1250,7 @@ static void ath10k_pci_hif_stop(struct ath10k *ar)
 		return;
 
 	ath10k_pci_irq_disable(ar);
-	ath10k_pci_free_irq(ar);
 	ath10k_pci_kill_tasklet(ar);
-
-	ret = ath10k_pci_request_early_irq(ar);
-	if (ret)
-		ath10k_warn("failed to re-enable early irq: %d\n", ret);
-
-	/* At this point, asynchronous threads are stopped, the target should
-	 * not DMA nor interrupt. We process the leftovers and then free
-	 * everything else up. */
-
 	ath10k_pci_buffer_cleanup(ar);
 
 	/* Make the sure the device won't access any structures on the host by
@@ -1806,28 +1736,19 @@ static int ath10k_pci_ce_init(struct ath10k *ar)
 	return 0;
 }
 
-static void ath10k_pci_fw_interrupt_handler(struct ath10k *ar)
+static bool ath10k_pci_has_fw_crashed(struct ath10k *ar)
 {
-	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
-	u32 fw_indicator;
-
-	fw_indicator = ath10k_pci_read32(ar, FW_INDICATOR_ADDRESS);
+	return ath10k_pci_read32(ar, FW_INDICATOR_ADDRESS) &
+	       FW_IND_EVENT_PENDING;
+}
 
-	if (fw_indicator & FW_IND_EVENT_PENDING) {
-		/* ACK: clear Target-side pending event */
-		ath10k_pci_write32(ar, FW_INDICATOR_ADDRESS,
-				   fw_indicator & ~FW_IND_EVENT_PENDING);
+static void ath10k_pci_fw_crashed_clear(struct ath10k *ar)
+{
+	u32 val;
 
-		if (ar_pci->started) {
-			ath10k_pci_fw_crashed_dump(ar);
-		} else {
-			/*
-			 * Probable Target failure before we're prepared
-			 * to handle it.  Generally unexpected.
-			 */
-			ath10k_warn("early firmware event indicated\n");
-		}
-	}
+	val = ath10k_pci_read32(ar, FW_INDICATOR_ADDRESS);
+	val &= ~FW_IND_EVENT_PENDING;
+	ath10k_pci_write32(ar, FW_INDICATOR_ADDRESS, val);
 }
 
 /* this function effectively clears target memory controller assert line */
@@ -1960,34 +1881,26 @@ static int __ath10k_pci_hif_power_up(struct ath10k *ar, bool cold_reset)
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
@@ -2056,8 +1969,6 @@ static void ath10k_pci_hif_power_down(struct ath10k *ar)
 {
 	ath10k_dbg(ATH10K_DBG_BOOT, "boot hif power down\n");
 
-	ath10k_pci_free_early_irq(ar);
-	ath10k_pci_kill_tasklet(ar);
 	ath10k_pci_warm_reset(ar);
 }
 
@@ -2140,7 +2051,13 @@ static void ath10k_msi_err_tasklet(unsigned long data)
 {
 	struct ath10k *ar = (struct ath10k *)data;
 
-	ath10k_pci_fw_interrupt_handler(ar);
+	if (!ath10k_pci_has_fw_crashed(ar)) {
+		ath10k_warn("received unsolicited fw crash interrupt\n");
+		return;
+	}
+
+	ath10k_pci_fw_crashed_clear(ar);
+	ath10k_pci_fw_crashed_dump(ar);
 }
 
 /*
@@ -2201,27 +2118,17 @@ static irqreturn_t ath10k_pci_interrupt_handler(int irq, void *arg)
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
+	if (ath10k_pci_has_fw_crashed(ar)) {
+		ath10k_pci_fw_crashed_clear(ar);
 		ath10k_pci_fw_crashed_dump(ar);
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
@@ -2332,8 +2239,6 @@ static void ath10k_pci_init_irq_tasklets(struct ath10k *ar)
 	tasklet_init(&ar_pci->intr_tq, ath10k_pci_tasklet, (unsigned long)ar);
 	tasklet_init(&ar_pci->msi_fw_err, ath10k_msi_err_tasklet,
 		     (unsigned long)ar);
-	tasklet_init(&ar_pci->early_irq_tasklet, ath10k_pci_early_irq_tasklet,
-		     (unsigned long)ar);
 
 	for (i = 0; i < CE_COUNT; i++) {
 		ar_pci->pipe_info[i].ar_pci = ar_pci;
@@ -2459,8 +2364,7 @@ static int ath10k_pci_wait_for_target_init(struct ath10k *ar)
 
 	if (val & FW_IND_EVENT_PENDING) {
 		ath10k_warn("device has crashed during init\n");
-		ath10k_pci_write32(ar, FW_INDICATOR_ADDRESS,
-				   val & ~FW_IND_EVENT_PENDING);
+		ath10k_pci_fw_crashed_clear(ar);
 		ath10k_pci_fw_crashed_dump(ar);
 		return -ECOMM;
 	}
@@ -2643,6 +2547,13 @@ static int ath10k_pci_probe(struct pci_dev *pdev,
 		goto err_free_ce;
 	}
 
+	/* Workaround: There's no known way to mask all possible interrupts via
+	 * device CSR. The only way to make sure device doesn't assert
+	 * interrupts is to reset it. Interrupts are then disabled on host
+	 * after handlers are registered.
+	 */
+	ath10k_pci_warm_reset(ar);
+
 	ret = ath10k_pci_init_irq(ar);
 	if (ret) {
 		ath10k_err("failed to init irqs: %d\n", ret);
@@ -2653,14 +2564,26 @@ static int ath10k_pci_probe(struct pci_dev *pdev,
 		    ath10k_pci_get_irq_method(ar), ar_pci->num_msi_intrs,
 		    ath10k_pci_irq_mode, ath10k_pci_reset_mode);
 
+	ret = ath10k_pci_request_irq(ar);
+	if (ret) {
+		ath10k_warn("failed to request irqs: %d\n", ret);
+		goto err_deinit_irq;
+	}
+
+	/* This shouldn't race as the device has been reset above. */
+	ath10k_pci_irq_disable(ar);
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
 
@@ -2695,6 +2618,7 @@ static void ath10k_pci_remove(struct pci_dev *pdev)
 		return;
 
 	ath10k_core_unregister(ar);
+	ath10k_pci_free_irq(ar);
 	ath10k_pci_deinit_irq(ar);
 	ath10k_pci_ce_deinit(ar);
 	ath10k_pci_free_ce(ar);
diff --git a/drivers/net/wireless/ath/ath10k/pci.h b/drivers/net/wireless/ath/ath10k/pci.h
index 294a72e..caed918 100644
--- a/drivers/net/wireless/ath/ath10k/pci.h
+++ b/drivers/net/wireless/ath/ath10k/pci.h
@@ -166,7 +166,6 @@ struct ath10k_pci {
 
 	struct tasklet_struct intr_tq;
 	struct tasklet_struct msi_fw_err;
-	struct tasklet_struct early_irq_tasklet;
 
 	int started;
 
-- 
1.8.5.3

