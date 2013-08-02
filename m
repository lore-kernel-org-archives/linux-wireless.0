Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb05.tieto.com ([131.207.168.36]:49704 "EHLO ebb05.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757358Ab3HBHQE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Aug 2013 03:16:04 -0400
From: Michal Kazior <michal.kazior@tieto.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v2] ath10k: fix device teardown
Date: Fri, 2 Aug 2013 09:15:47 +0200
Message-ID: <1375427747-9539-1-git-send-email-michal.kazior@tieto.com> (sfid-20130802_091612_748895_112AEA76)
In-Reply-To: <1374129572-6079-1-git-send-email-michal.kazior@tieto.com>
References: <1374129572-6079-1-git-send-email-michal.kazior@tieto.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This fixes interrupt-related issue when no
interfaces were running thus the device was
considered powered down.

The power_down() function isn't really powering
down the device. It simply assumed it won't
interrupt. This wasn't true in some cases and
could lead to paging failures upon FW indication
interrupt (i.e. FW crash) because some structures
aren't allocated in that device state.

One reason for that was that ar_pci->started
wasn't reset. The other is interrupts should've
been masked when teardown starts.

The patch reorganized interrupt setup and makes
sure ar_pci->started is reset accordingly.

Reported-by: Ben Greear <greearb@candelatech.com>
Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
v2:
 * updated commit message
 * added Reported-By: Ben
 * added disable_irq() in hif_stop()
 * added ar_pci->started resetting
 * removed ar_pci->intr_started

 drivers/net/wireless/ath/ath10k/pci.c |   41 ++++++++++++++++++++++++---------
 1 file changed, 30 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index c71b488..690a8b4 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -56,6 +56,8 @@ static void ath10k_pci_rx_pipe_cleanup(struct hif_ce_pipe_info *pipe_info);
 static void ath10k_pci_stop_ce(struct ath10k *ar);
 static void ath10k_pci_device_reset(struct ath10k *ar);
 static int ath10k_pci_reset_target(struct ath10k *ar);
+static int ath10k_pci_start_intr(struct ath10k *ar);
+static void ath10k_pci_stop_intr(struct ath10k *ar);
 
 static const struct ce_attr host_ce_config_wlan[] = {
 	/* host->target HTC control and raw streams */
@@ -1254,10 +1256,25 @@ static void ath10k_pci_ce_deinit(struct ath10k *ar)
 	}
 }
 
+static void ath10k_pci_disable_irqs(struct ath10k *ar)
+{
+	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
+	int i;
+
+	for (i = 0; i < max(1, ar_pci->num_msi_intrs); i++)
+		disable_irq(ar_pci->pdev->irq + i);
+}
+
 static void ath10k_pci_hif_stop(struct ath10k *ar)
 {
+	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
+
 	ath10k_dbg(ATH10K_DBG_PCI, "%s\n", __func__);
 
+	/* Irqs are never explicitly re-enabled. They are implicitly re-enabled
+	 * by ath10k_pci_start_intr(). */
+	ath10k_pci_disable_irqs(ar);
+
 	ath10k_pci_stop_ce(ar);
 
 	/* At this point, asynchronous threads are stopped, the target should
@@ -1267,6 +1284,8 @@ static void ath10k_pci_hif_stop(struct ath10k *ar)
 	ath10k_pci_process_ce(ar);
 	ath10k_pci_cleanup_ce(ar);
 	ath10k_pci_buffer_cleanup(ar);
+
+	ar_pci->started = 0;
 }
 
 static int ath10k_pci_hif_exchange_bmi_msg(struct ath10k *ar,
@@ -1742,6 +1761,12 @@ static int ath10k_pci_hif_power_up(struct ath10k *ar)
 {
 	int ret;
 
+	ret = ath10k_pci_start_intr(ar);
+	if (ret) {
+		ath10k_err("could not start interrupt handling (%d)\n", ret);
+		goto err;
+	}
+
 	/*
 	 * Bring the target up cleanly.
 	 *
@@ -1756,7 +1781,7 @@ static int ath10k_pci_hif_power_up(struct ath10k *ar)
 
 	ret = ath10k_pci_reset_target(ar);
 	if (ret)
-		goto err;
+		goto err_irq;
 
 	if (ath10k_target_ps) {
 		ath10k_dbg(ATH10K_DBG_PCI, "on-chip power save enabled\n");
@@ -1787,12 +1812,15 @@ err_ce:
 err_ps:
 	if (!ath10k_target_ps)
 		ath10k_do_pci_sleep(ar);
+err_irq:
+	ath10k_pci_stop_intr(ar);
 err:
 	return ret;
 }
 
 static void ath10k_pci_hif_power_down(struct ath10k *ar)
 {
+	ath10k_pci_stop_intr(ar);
 	ath10k_pci_ce_deinit(ar);
 	if (!ath10k_target_ps)
 		ath10k_do_pci_sleep(ar);
@@ -2358,22 +2386,14 @@ static int ath10k_pci_probe(struct pci_dev *pdev,
 
 	ar_pci->cacheline_sz = dma_get_cache_alignment();
 
-	ret = ath10k_pci_start_intr(ar);
-	if (ret) {
-		ath10k_err("could not start interrupt handling (%d)\n", ret);
-		goto err_iomap;
-	}
-
 	ret = ath10k_core_register(ar);
 	if (ret) {
 		ath10k_err("could not register driver core (%d)\n", ret);
-		goto err_intr;
+		goto err_iomap;
 	}
 
 	return 0;
 
-err_intr:
-	ath10k_pci_stop_intr(ar);
 err_iomap:
 	pci_iounmap(pdev, mem);
 err_master:
@@ -2410,7 +2430,6 @@ static void ath10k_pci_remove(struct pci_dev *pdev)
 	tasklet_kill(&ar_pci->msi_fw_err);
 
 	ath10k_core_unregister(ar);
-	ath10k_pci_stop_intr(ar);
 
 	pci_set_drvdata(pdev, NULL);
 	pci_iounmap(pdev, ar_pci->mem);
-- 
1.7.9.5

