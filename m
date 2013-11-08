Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f50.google.com ([74.125.83.50]:59726 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753166Ab3KHHEy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Nov 2013 02:04:54 -0500
Received: by mail-ee0-f50.google.com with SMTP id b45so770947eek.23
        for <linux-wireless@vger.kernel.org>; Thu, 07 Nov 2013 23:04:52 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCHv2 11/13] ath10k: re-arrange PCI init code
Date: Fri,  8 Nov 2013 08:01:33 +0100
Message-Id: <1383894095-27998-12-git-send-email-michal.kazior@tieto.com> (sfid-20131108_080807_257194_A16EB88B)
In-Reply-To: <1383894095-27998-1-git-send-email-michal.kazior@tieto.com>
References: <1383133346-8135-1-git-send-email-michal.kazior@tieto.com>
 <1383894095-27998-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch moves irq registering after necessary
structures have been allocated and initialized.
This should prevent interrupts from causing
tasklet access invalid memory pointers.

Reported-By: Ben Greear <greearb@candelatech.com>
Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/ce.c  | 19 ++++++--
 drivers/net/wireless/ath/ath10k/ce.h  |  1 +
 drivers/net/wireless/ath/ath10k/pci.c | 87 ++++++++++++++++++++++-------------
 3 files changed, 71 insertions(+), 36 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/ce.c b/drivers/net/wireless/ath/ath10k/ce.c
index ab22d14..476928f 100644
--- a/drivers/net/wireless/ath/ath10k/ce.c
+++ b/drivers/net/wireless/ath/ath10k/ce.c
@@ -792,6 +792,21 @@ static void ath10k_ce_per_engine_handler_adjust(struct ath10k_ce_pipe *ce_state,
 	ath10k_pci_sleep(ar);
 }
 
+int ath10k_ce_enable_err_irq(struct ath10k *ar)
+{
+	int i, ret;
+
+	ret = ath10k_pci_wake(ar);
+	if (ret)
+		return ret;
+
+	for (i = 0; i < CE_COUNT; i++)
+		ath10k_ce_error_intr_enable(ar, ath10k_ce_base_address(i));
+
+	ath10k_pci_sleep(ar);
+	return 0;
+}
+
 int ath10k_ce_disable_interrupts(struct ath10k *ar)
 {
 	int ce_id, ret;
@@ -1059,7 +1074,6 @@ struct ath10k_ce_pipe *ath10k_ce_init(struct ath10k *ar,
 				const struct ce_attr *attr)
 {
 	struct ath10k_ce_pipe *ce_state;
-	u32 ctrl_addr = ath10k_ce_base_address(ce_id);
 	int ret;
 
 	/*
@@ -1105,9 +1119,6 @@ struct ath10k_ce_pipe *ath10k_ce_init(struct ath10k *ar,
 		}
 	}
 
-	/* Enable CE error interrupts */
-	ath10k_ce_error_intr_enable(ar, ctrl_addr);
-
 out:
 	ath10k_pci_sleep(ar);
 	return ce_state;
diff --git a/drivers/net/wireless/ath/ath10k/ce.h b/drivers/net/wireless/ath/ath10k/ce.h
index 67dbde6..8a58bac 100644
--- a/drivers/net/wireless/ath/ath10k/ce.h
+++ b/drivers/net/wireless/ath/ath10k/ce.h
@@ -235,6 +235,7 @@ void ath10k_ce_deinit(struct ath10k_ce_pipe *ce_state);
 void ath10k_ce_per_engine_service_any(struct ath10k *ar);
 void ath10k_ce_per_engine_service(struct ath10k *ar, unsigned int ce_id);
 int ath10k_ce_disable_interrupts(struct ath10k *ar);
+int ath10k_ce_enable_err_irq(struct ath10k *ar);
 
 /* ce_attr.flags values */
 /* Use NonSnooping PCIe accesses? */
diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index 0b89726..e552770 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -1786,18 +1786,6 @@ static int ath10k_pci_ce_init(struct ath10k *ar)
 		pipe_info->buf_sz = (size_t) (attr->src_sz_max);
 	}
 
-	/*
-	 * Initially, establish CE completion handlers for use with BMI.
-	 * These are overwritten with generic handlers after we exit BMI phase.
-	 */
-	pipe_info = &ar_pci->pipe_info[BMI_CE_NUM_TO_TARG];
-	ath10k_ce_send_cb_register(pipe_info->ce_hdl,
-				   ath10k_pci_bmi_send_done, 0);
-
-	pipe_info = &ar_pci->pipe_info[BMI_CE_NUM_TO_HOST];
-	ath10k_ce_recv_cb_register(pipe_info->ce_hdl,
-				   ath10k_pci_bmi_recv_data);
-
 	return 0;
 }
 
@@ -1830,17 +1818,27 @@ static void ath10k_pci_fw_interrupt_handler(struct ath10k *ar)
 	ath10k_pci_sleep(ar);
 }
 
+static void ath10k_pci_start_bmi(struct ath10k *ar)
+{
+	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
+	struct ath10k_pci_pipe *pipe;
+
+	/*
+	 * Initially, establish CE completion handlers for use with BMI.
+	 * These are overwritten with generic handlers after we exit BMI phase.
+	 */
+	pipe = &ar_pci->pipe_info[BMI_CE_NUM_TO_TARG];
+	ath10k_ce_send_cb_register(pipe->ce_hdl, ath10k_pci_bmi_send_done, 0);
+
+	pipe = &ar_pci->pipe_info[BMI_CE_NUM_TO_HOST];
+	ath10k_ce_recv_cb_register(pipe->ce_hdl, ath10k_pci_bmi_recv_data);
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
@@ -1854,13 +1852,9 @@ static int ath10k_pci_hif_power_up(struct ath10k *ar)
 	ret = ath10k_pci_device_reset(ar);
 	if (ret) {
 		ath10k_err("failed to reset target: %d\n", ret);
-		goto err_irq;
+		goto err;
 	}
 
-	ret = ath10k_pci_wait_for_target_init(ar);
-	if (ret)
-		goto err_irq;
-
 	if (!test_bit(ATH10K_PCI_FEATURE_SOC_POWER_SAVE, ar_pci->features))
 		/* Force AWAKE forever */
 		ath10k_do_pci_wake(ar);
@@ -1869,25 +1863,54 @@ static int ath10k_pci_hif_power_up(struct ath10k *ar)
 	if (ret)
 		goto err_ps;
 
-	ret = ath10k_pci_init_config(ar);
-	if (ret)
+	ret = ath10k_ce_disable_interrupts(ar);
+	if (ret) {
+		ath10k_err("failed to disable CE interrupts: %d\n", ret);
+		goto err_ce;
+	}
+
+	ret = ath10k_pci_start_intr(ar);
+	if (ret) {
+		ath10k_err("failed to start interrupt handling: %d\n", ret);
 		goto err_ce;
+	}
+
+	ret = ath10k_pci_wait_for_target_init(ar);
+	if (ret) {
+		ath10k_err("failed to wait for target to init: %d\n", ret);
+		goto err_irq;
+	}
+
+	ret = ath10k_ce_enable_err_irq(ar);
+	if (ret) {
+		ath10k_err("failed to enable CE error irq: %d\n", ret);
+		goto err_irq;
+	}
+
+	ret = ath10k_pci_init_config(ar);
+	if (ret) {
+		ath10k_err("failed to setup init config: %d\n", ret);
+		goto err_irq;
+	}
 
 	ret = ath10k_pci_wake_target_cpu(ar);
 	if (ret) {
 		ath10k_err("could not wake up target CPU (%d)\n", ret);
-		goto err_ce;
+		goto err_irq;
 	}
 
+	ath10k_pci_start_bmi(ar);
 	return 0;
 
+err_irq:
+	ath10k_ce_disable_interrupts(ar);
+	ath10k_pci_stop_intr(ar);
+	ath10k_pci_kill_tasklet(ar);
 err_ce:
 	ath10k_pci_ce_deinit(ar);
 err_ps:
 	if (!test_bit(ATH10K_PCI_FEATURE_SOC_POWER_SAVE, ar_pci->features))
 		ath10k_do_pci_sleep(ar);
-err_irq:
-	ath10k_pci_stop_intr(ar);
 err:
 	return ret;
 }
@@ -2156,7 +2179,7 @@ static int ath10k_pci_start_intr_legacy(struct ath10k *ar)
 	if (ret < 0)
 		return ret;
 
-	ret = ath10k_do_pci_wake(ar);
+	ret = ath10k_pci_wake(ar);
 	if (ret) {
 		free_irq(ar_pci->pdev->irq, ar);
 		ath10k_err("failed to wake up target: %d\n", ret);
@@ -2176,7 +2199,7 @@ static int ath10k_pci_start_intr_legacy(struct ath10k *ar)
 		  ar_pci->mem + (SOC_CORE_BASE_ADDRESS |
 				 PCIE_INTR_ENABLE_ADDRESS));
 
-	ath10k_do_pci_sleep(ar);
+	ath10k_pci_sleep(ar);
 	ath10k_info("legacy interrupt handling\n");
 	return 0;
 }
@@ -2252,7 +2275,7 @@ static int ath10k_pci_wait_for_target_init(struct ath10k *ar)
 	int wait_limit = 300; /* 3 sec */
 	int ret;
 
-	ret = ath10k_do_pci_wake(ar);
+	ret = ath10k_pci_wake(ar);
 	if (ret) {
 		ath10k_err("failed to wake up target: %d\n", ret);
 		return ret;
@@ -2277,7 +2300,7 @@ static int ath10k_pci_wait_for_target_init(struct ath10k *ar)
 	}
 
 out:
-	ath10k_do_pci_sleep(ar);
+	ath10k_pci_sleep(ar);
 	return ret;
 }
 
-- 
1.8.4.rc3

