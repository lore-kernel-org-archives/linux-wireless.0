Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb05.tieto.com ([131.207.168.36]:42644 "EHLO ebb05.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752430Ab3GPHjH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Jul 2013 03:39:07 -0400
From: Michal Kazior <michal.kazior@tieto.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v4 01/10] ath10k: decouple pci start/stop logic
Date: Tue, 16 Jul 2013 09:38:50 +0200
Message-ID: <1373960339-8525-2-git-send-email-michal.kazior@tieto.com> (sfid-20130716_093926_288285_A75A9E40)
In-Reply-To: <1373960339-8525-1-git-send-email-michal.kazior@tieto.com>
References: <1371041642-20273-1-git-send-email-michal.kazior@tieto.com>
 <1373960339-8525-1-git-send-email-michal.kazior@tieto.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Split logic that prepares the device for BMI
phase/cleans up related resources.

This is necessary for ath10k to be able to restart
hw on the fly without reloading the module.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/hif.h |   20 ++++++
 drivers/net/wireless/ath/ath10k/pci.c |  110 +++++++++++++++++++++------------
 2 files changed, 91 insertions(+), 39 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/hif.h b/drivers/net/wireless/ath/ath10k/hif.h
index 010e265..00d2940 100644
--- a/drivers/net/wireless/ath/ath10k/hif.h
+++ b/drivers/net/wireless/ath/ath10k/hif.h
@@ -46,8 +46,11 @@ struct ath10k_hif_ops {
 				void *request, u32 request_len,
 				void *response, u32 *response_len);
 
+	/* Post BMI phase, after FW is loaded. Starts regular operation */
 	int (*start)(struct ath10k *ar);
 
+	/* Clean up what start() did. This does not revert to BMI phase. If
+	 * desired so, call power_down() and power_up() */
 	void (*stop)(struct ath10k *ar);
 
 	int (*map_service_to_pipe)(struct ath10k *ar, u16 service_id,
@@ -70,6 +73,13 @@ struct ath10k_hif_ops {
 			      struct ath10k_hif_cb *callbacks);
 
 	u16 (*get_free_queue_number)(struct ath10k *ar, u8 pipe_id);
+
+	/* Power up the device and enter BMI transfer mode for FW download */
+	int (*power_up)(struct ath10k *ar);
+
+	/* Power down the device and free up resources. stop() must be called
+	 * before this if start() was called earlier */
+	void (*power_down)(struct ath10k *ar);
 };
 
 
@@ -134,4 +144,14 @@ static inline u16 ath10k_hif_get_free_queue_number(struct ath10k *ar,
 	return ar->hif.ops->get_free_queue_number(ar, pipe_id);
 }
 
+static inline int ath10k_hif_power_up(struct ath10k *ar)
+{
+	return ar->hif.ops->power_up(ar);
+}
+
+static inline void ath10k_hif_power_down(struct ath10k *ar)
+{
+	ar->hif.ops->power_down(ar);
+}
+
 #endif /* _HIF_H_ */
diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index 7da0983..c15b0c5 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -54,6 +54,8 @@ static int ath10k_pci_post_rx_pipe(struct hif_ce_pipe_info *pipe_info,
 					     int num);
 static void ath10k_pci_rx_pipe_cleanup(struct hif_ce_pipe_info *pipe_info);
 static void ath10k_pci_stop_ce(struct ath10k *ar);
+static void ath10k_pci_device_reset(struct ath10k *ar);
+static int ath10k_pci_reset_target(struct ath10k *ar);
 
 static const struct ce_attr host_ce_config_wlan[] = {
 	/* host->target HTC control and raw streams */
@@ -1734,6 +1736,66 @@ static void ath10k_pci_fw_interrupt_handler(struct ath10k *ar)
 	ath10k_pci_sleep(ar);
 }
 
+static int ath10k_pci_hif_power_up(struct ath10k *ar)
+{
+	int ret;
+
+	/*
+	 * Bring the target up cleanly.
+	 *
+	 * The target may be in an undefined state with an AUX-powered Target
+	 * and a Host in WoW mode. If the Host crashes, loses power, or is
+	 * restarted (without unloading the driver) then the Target is left
+	 * (aux) powered and running. On a subsequent driver load, the Target
+	 * is in an unexpected state. We try to catch that here in order to
+	 * reset the Target and retry the probe.
+	 */
+	ath10k_pci_device_reset(ar);
+
+	ret = ath10k_pci_reset_target(ar);
+	if (ret)
+		goto err;
+
+	if (ath10k_target_ps) {
+		ath10k_dbg(ATH10K_DBG_PCI, "on-chip power save enabled\n");
+	} else {
+		/* Force AWAKE forever */
+		ath10k_dbg(ATH10K_DBG_PCI, "on-chip power save disabled\n");
+		ath10k_do_pci_wake(ar);
+	}
+
+	ret = ath10k_pci_ce_init(ar);
+	if (ret)
+		goto err_ps;
+
+	ret = ath10k_pci_init_config(ar);
+	if (ret)
+		goto err_ce;
+
+	ret = ath10k_pci_wake_target_cpu(ar);
+	if (ret) {
+		ath10k_err("could not wake up target CPU (%d)\n", ret);
+		goto err_ce;
+	}
+
+	return 0;
+
+err_ce:
+	ath10k_pci_ce_deinit(ar);
+err_ps:
+	if (!ath10k_target_ps)
+		ath10k_do_pci_sleep(ar);
+err:
+	return ret;
+}
+
+static void ath10k_pci_hif_power_down(struct ath10k *ar)
+{
+	ath10k_pci_ce_deinit(ar);
+	if (!ath10k_target_ps)
+		ath10k_do_pci_sleep(ar);
+}
+
 static const struct ath10k_hif_ops ath10k_pci_hif_ops = {
 	.send_head		= ath10k_pci_hif_send_head,
 	.exchange_bmi_msg	= ath10k_pci_hif_exchange_bmi_msg,
@@ -1744,6 +1806,8 @@ static const struct ath10k_hif_ops ath10k_pci_hif_ops = {
 	.send_complete_check	= ath10k_pci_hif_send_complete_check,
 	.set_callbacks		= ath10k_pci_hif_set_callbacks,
 	.get_free_queue_number	= ath10k_pci_hif_get_free_queue_number,
+	.power_up		= ath10k_pci_hif_power_up,
+	.power_down		= ath10k_pci_hif_power_down,
 };
 
 static void ath10k_pci_ce_tasklet(unsigned long ptr)
@@ -2245,54 +2309,22 @@ static int ath10k_pci_probe(struct pci_dev *pdev,
 		goto err_iomap;
 	}
 
-	/*
-	 * Bring the target up cleanly.
-	 *
-	 * The target may be in an undefined state with an AUX-powered Target
-	 * and a Host in WoW mode. If the Host crashes, loses power, or is
-	 * restarted (without unloading the driver) then the Target is left
-	 * (aux) powered and running. On a subsequent driver load, the Target
-	 * is in an unexpected state. We try to catch that here in order to
-	 * reset the Target and retry the probe.
-	 */
-	ath10k_pci_device_reset(ar);
-
-	ret = ath10k_pci_reset_target(ar);
-	if (ret)
-		goto err_intr;
-
-	if (ath10k_target_ps) {
-		ath10k_dbg(ATH10K_DBG_PCI, "on-chip power save enabled\n");
-	} else {
-		/* Force AWAKE forever */
-		ath10k_dbg(ATH10K_DBG_PCI, "on-chip power save disabled\n");
-		ath10k_do_pci_wake(ar);
-	}
-
-	ret = ath10k_pci_ce_init(ar);
-	if (ret)
-		goto err_intr;
-
-	ret = ath10k_pci_init_config(ar);
-	if (ret)
-		goto err_ce;
-
-	ret = ath10k_pci_wake_target_cpu(ar);
+	ret = ath10k_pci_hif_power_up(ar);
 	if (ret) {
-		ath10k_err("could not wake up target CPU (%d)\n", ret);
-		goto err_ce;
+		ath10k_err("could not start pci hif (%d)\n", ret);
+		goto err_intr;
 	}
 
 	ret = ath10k_core_register(ar);
 	if (ret) {
 		ath10k_err("could not register driver core (%d)\n", ret);
-		goto err_ce;
+		goto err_hif;
 	}
 
 	return 0;
 
-err_ce:
-	ath10k_pci_ce_deinit(ar);
+err_hif:
+	ath10k_pci_hif_power_down(ar);
 err_intr:
 	ath10k_pci_stop_intr(ar);
 err_iomap:
@@ -2331,7 +2363,7 @@ static void ath10k_pci_remove(struct pci_dev *pdev)
 	tasklet_kill(&ar_pci->msi_fw_err);
 
 	ath10k_core_unregister(ar);
-	ath10k_pci_ce_deinit(ar);
+	ath10k_pci_hif_power_down(ar);
 	ath10k_pci_stop_intr(ar);
 
 	pci_set_drvdata(pdev, NULL);
-- 
1.7.9.5

