Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f179.google.com ([209.85.215.179]:35756 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755436Ab3KYNK2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Nov 2013 08:10:28 -0500
Received: by mail-ea0-f179.google.com with SMTP id r15so2356614ead.38
        for <linux-wireless@vger.kernel.org>; Mon, 25 Nov 2013 05:10:27 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v2 5/8] ath10k: defer irq registration until hif start()
Date: Mon, 25 Nov 2013 14:06:24 +0100
Message-Id: <1385384787-12470-6-git-send-email-michal.kazior@tieto.com> (sfid-20131125_141039_178242_AC6B8D77)
In-Reply-To: <1385384787-12470-1-git-send-email-michal.kazior@tieto.com>
References: <1385125518-13461-1-git-send-email-michal.kazior@tieto.com>
 <1385384787-12470-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It's impossible to rely on disable_irq() and/or CE
interrupt masking with legacy shared interrupts.
Other devices sharing the same irq line may assert
it while ath10k is doing something that requires
no interrupts.

Irq handlers are now registered after all
preparations are complete so spurious/foreign
interrupts won't do any harm. The handlers are
unregistered when no interrupts are required (i.e.
during driver teardown).

This also removes the ability to receive FW early
indication (since interrupts are not registered
until early boot is complete). This is not mission
critical (it's more of a hint that early boot
failed due to unexpected FW crash) and will be
re-added in a follow up patch.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
v2:
 * remove ce_enable_err_irq() - dont enable device
   interrupts before irq handlers are registered
 * with the earlier pci_start_ce() decoupling
   patch, irq handlers are now registered after CE
   completions are allocated but before CE
   interrupts are enabled via HW registers
   (fixes 'irq: nobody cared')

 drivers/net/wireless/ath/ath10k/ce.c  | 15 --------
 drivers/net/wireless/ath/ath10k/ce.h  |  1 -
 drivers/net/wireless/ath/ath10k/pci.c | 65 +++++++++++++----------------------
 3 files changed, 23 insertions(+), 58 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/ce.c b/drivers/net/wireless/ath/ath10k/ce.c
index 476928f..d44d618 100644
--- a/drivers/net/wireless/ath/ath10k/ce.c
+++ b/drivers/net/wireless/ath/ath10k/ce.c
@@ -792,21 +792,6 @@ static void ath10k_ce_per_engine_handler_adjust(struct ath10k_ce_pipe *ce_state,
 	ath10k_pci_sleep(ar);
 }
 
-int ath10k_ce_enable_err_irq(struct ath10k *ar)
-{
-	int i, ret;
-
-	ret = ath10k_pci_wake(ar);
-	if (ret)
-		return ret;
-
-	for (i = 0; i < CE_COUNT; i++)
-		ath10k_ce_error_intr_enable(ar, ath10k_ce_base_address(i));
-
-	ath10k_pci_sleep(ar);
-	return 0;
-}
-
 int ath10k_ce_disable_interrupts(struct ath10k *ar)
 {
 	int ce_id, ret;
diff --git a/drivers/net/wireless/ath/ath10k/ce.h b/drivers/net/wireless/ath/ath10k/ce.h
index 8a58bac..67dbde6 100644
--- a/drivers/net/wireless/ath/ath10k/ce.h
+++ b/drivers/net/wireless/ath/ath10k/ce.h
@@ -235,7 +235,6 @@ void ath10k_ce_deinit(struct ath10k_ce_pipe *ce_state);
 void ath10k_ce_per_engine_service_any(struct ath10k *ar);
 void ath10k_ce_per_engine_service(struct ath10k *ar, unsigned int ce_id);
 int ath10k_ce_disable_interrupts(struct ath10k *ar);
-int ath10k_ce_enable_err_irq(struct ath10k *ar);
 
 /* ce_attr.flags values */
 /* Use NonSnooping PCIe accesses? */
diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index 05e6f8b..bd67311 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -919,13 +919,6 @@ static void ath10k_pci_stop_ce(struct ath10k *ar)
 	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
 	struct ath10k_pci_compl *compl;
 	struct sk_buff *skb;
-	int ret;
-
-	ret = ath10k_ce_disable_interrupts(ar);
-	if (ret)
-		ath10k_warn("failed to disable CE interrupts: %d\n", ret);
-
-	ath10k_pci_kill_tasklet(ar);
 
 	/* Mark pending completions as aborted, so that upper layers free up
 	 * their associated resources */
@@ -1236,10 +1229,17 @@ static int ath10k_pci_hif_start(struct ath10k *ar)
 		return ret;
 	}
 
+	ret = ath10k_pci_request_irq(ar);
+	if (ret) {
+		ath10k_warn("failed to post RX buffers for all pipes: %d\n",
+			    ret);
+		goto err_free_compl;
+	}
+
 	ret = ath10k_pci_setup_ce_irq(ar);
 	if (ret) {
 		ath10k_warn("failed to setup CE interrupts: %d\n", ret);
-		goto err_free_compl;
+		goto err_stop;
 	}
 
 	/* Post buffers once to start things off. */
@@ -1247,13 +1247,16 @@ static int ath10k_pci_hif_start(struct ath10k *ar)
 	if (ret) {
 		ath10k_warn("failed to post RX buffers for all pipes: %d\n",
 			    ret);
-		goto err_stop_ce;
+		goto err_stop;
 	}
 
 	ar_pci->started = 1;
 	return 0;
 
-err_stop_ce:
+err_stop:
+	ath10k_ce_disable_interrupts(ar);
+	ath10k_pci_free_irq(ar);
+	ath10k_pci_kill_tasklet(ar);
 	ath10k_pci_stop_ce(ar);
 	ath10k_pci_process_ce(ar);
 err_free_compl:
@@ -1376,25 +1379,19 @@ static void ath10k_pci_ce_deinit(struct ath10k *ar)
 	}
 }
 
-static void ath10k_pci_disable_irqs(struct ath10k *ar)
-{
-	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
-	int i;
-
-	for (i = 0; i < max(1, ar_pci->num_msi_intrs); i++)
-		disable_irq(ar_pci->pdev->irq + i);
-}
-
 static void ath10k_pci_hif_stop(struct ath10k *ar)
 {
 	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
+	int ret;
 
 	ath10k_dbg(ATH10K_DBG_PCI, "%s\n", __func__);
 
-	/* Irqs are never explicitly re-enabled. They are implicitly re-enabled
-	 * by upon power_up. */
-	ath10k_pci_disable_irqs(ar);
+	ret = ath10k_ce_disable_interrupts(ar);
+	if (ret)
+		ath10k_warn("failed to disable CE interrupts: %d\n", ret);
 
+	ath10k_pci_free_irq(ar);
+	ath10k_pci_kill_tasklet(ar);
 	ath10k_pci_stop_ce(ar);
 
 	/* At this point, asynchronous threads are stopped, the target should
@@ -1945,34 +1942,22 @@ static int ath10k_pci_hif_power_up(struct ath10k *ar)
 		goto err_ce;
 	}
 
-	ret = ath10k_pci_request_irq(ar);
-	if (ret) {
-		ath10k_err("failed to request irqs: %d\n", ret);
-		goto err_deinit_irq;
-	}
-
 	ret = ath10k_pci_wait_for_target_init(ar);
 	if (ret) {
 		ath10k_err("failed to wait for target to init: %d\n", ret);
-		goto err_free_irq;
-	}
-
-	ret = ath10k_ce_enable_err_irq(ar);
-	if (ret) {
-		ath10k_err("failed to enable CE error irq: %d\n", ret);
-		goto err_free_irq;
+		goto err_deinit_irq;
 	}
 
 	ret = ath10k_pci_init_config(ar);
 	if (ret) {
 		ath10k_err("failed to setup init config: %d\n", ret);
-		goto err_free_irq;
+		goto err_deinit_irq;
 	}
 
 	ret = ath10k_pci_wake_target_cpu(ar);
 	if (ret) {
 		ath10k_err("could not wake up target CPU: %d\n", ret);
-		goto err_free_irq;
+		goto err_deinit_irq;
 	}
 
 	if (ar_pci->num_msi_intrs > 1)
@@ -1987,14 +1972,11 @@ static int ath10k_pci_hif_power_up(struct ath10k *ar)
 
 	return 0;
 
-err_free_irq:
-	ath10k_pci_free_irq(ar);
-	ath10k_pci_kill_tasklet(ar);
-	ath10k_pci_device_reset(ar);
 err_deinit_irq:
 	ath10k_pci_deinit_irq(ar);
 err_ce:
 	ath10k_pci_ce_deinit(ar);
+	ath10k_pci_device_reset(ar);
 err_ps:
 	if (!test_bit(ATH10K_PCI_FEATURE_SOC_POWER_SAVE, ar_pci->features))
 		ath10k_do_pci_sleep(ar);
@@ -2006,7 +1988,6 @@ static void ath10k_pci_hif_power_down(struct ath10k *ar)
 {
 	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
 
-	ath10k_pci_free_irq(ar);
 	ath10k_pci_deinit_irq(ar);
 	ath10k_pci_device_reset(ar);
 
-- 
1.8.4.rc3

