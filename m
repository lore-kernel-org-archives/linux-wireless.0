Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb05.tieto.com ([131.207.168.36]:59878 "EHLO ebb05.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754052Ab3GRGji (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Jul 2013 02:39:38 -0400
From: Michal Kazior <michal.kazior@tieto.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH] ath10k: move irq setup
Date: Thu, 18 Jul 2013 08:39:32 +0200
Message-ID: <1374129572-6079-1-git-send-email-michal.kazior@tieto.com> (sfid-20130718_083942_057972_B9B2AD4A)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There was a slight race during PCI shutdown. Since
interrupts weren't really stopped (only Copy
Engine interrupts were disabled through device hw
registers) it was possible for a firmware
indication (crash) interrupt to come in after
tasklets were synced/killed. This would cause
memory corruption and a panic in most cases. It
was also possible for interrupt to come before CE
was initialized during device probing.

Interrupts are required for BMI phase so they are
enabled as soon as power_up() is called but are
freed upon both power_down() and stop() so there's
asymmetry here. As by design stop() cannot be
followed by start() it is okay. Both power_down()
and stop() should be merged later on to avoid
confusion.

Before this can be really properly fixed var/hw
init code split is necessary.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---

Please note: this is based on my (still under
review at the time of posting) previous patchests:
device setup refactor and recovery.

I'm posting this before those patchsets are merged
so anyone interested in testing this fix (I can't
reproduce the problem on my setup) can give it a
try.

 drivers/net/wireless/ath/ath10k/pci.c |   36 +++++++++++++++++++++++----------
 drivers/net/wireless/ath/ath10k/pci.h |    1 +
 2 files changed, 26 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index c71b488..e814151 100644
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
@@ -827,6 +829,7 @@ static void ath10k_pci_stop_ce(struct ath10k *ar)
 	int i;
 
 	ath10k_ce_disable_interrupts(ar);
+	ath10k_pci_stop_intr(ar);
 
 	/* Cancel the pending tasklet */
 	tasklet_kill(&ar_pci->intr_tq);
@@ -1742,6 +1745,12 @@ static int ath10k_pci_hif_power_up(struct ath10k *ar)
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
@@ -1756,7 +1765,7 @@ static int ath10k_pci_hif_power_up(struct ath10k *ar)
 
 	ret = ath10k_pci_reset_target(ar);
 	if (ret)
-		goto err;
+		goto err_intr;
 
 	if (ath10k_target_ps) {
 		ath10k_dbg(ATH10K_DBG_PCI, "on-chip power save enabled\n");
@@ -1783,16 +1792,24 @@ static int ath10k_pci_hif_power_up(struct ath10k *ar)
 	return 0;
 
 err_ce:
+	/* XXX: Until var/hw init is split it's impossible to fix the ordering
+	 * here so we must call stop_intr() here too to prevent interrupts after
+	 * CE is teared down. It's okay to double call the stop_intr() */
+	ath10k_pci_stop_intr(ar);
 	ath10k_pci_ce_deinit(ar);
 err_ps:
 	if (!ath10k_target_ps)
 		ath10k_do_pci_sleep(ar);
+err_intr:
+	ath10k_pci_stop_intr(ar);
 err:
 	return ret;
 }
 
 static void ath10k_pci_hif_power_down(struct ath10k *ar)
 {
+	ath10k_pci_stop_intr(ar);
+
 	ath10k_pci_ce_deinit(ar);
 	if (!ath10k_target_ps)
 		ath10k_do_pci_sleep(ar);
@@ -2119,6 +2136,7 @@ static int ath10k_pci_start_intr(struct ath10k *ar)
 	ret = ath10k_pci_start_intr_legacy(ar);
 
 exit:
+	ar_pci->intr_started = ret == 0;
 	ar_pci->num_msi_intrs = num;
 	ar_pci->ce_count = CE_COUNT;
 	return ret;
@@ -2129,6 +2147,9 @@ static void ath10k_pci_stop_intr(struct ath10k *ar)
 	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
 	int i;
 
+	if (ar_pci->intr_started == false)
+		return;
+
 	/* There's at least one interrupt irregardless whether its legacy INTR
 	 * or MSI or MSI-X */
 	for (i = 0; i < max(1, ar_pci->num_msi_intrs); i++)
@@ -2136,6 +2157,8 @@ static void ath10k_pci_stop_intr(struct ath10k *ar)
 
 	if (ar_pci->num_msi_intrs > 0)
 		pci_disable_msi(ar_pci->pdev);
+
+	ar_pci->intr_started = false;
 }
 
 static int ath10k_pci_reset_target(struct ath10k *ar)
@@ -2358,22 +2381,14 @@ static int ath10k_pci_probe(struct pci_dev *pdev,
 
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
@@ -2410,7 +2425,6 @@ static void ath10k_pci_remove(struct pci_dev *pdev)
 	tasklet_kill(&ar_pci->msi_fw_err);
 
 	ath10k_core_unregister(ar);
-	ath10k_pci_stop_intr(ar);
 
 	pci_set_drvdata(pdev, NULL);
 	pci_iounmap(pdev, ar_pci->mem);
diff --git a/drivers/net/wireless/ath/ath10k/pci.h b/drivers/net/wireless/ath/ath10k/pci.h
index d3a2e6c..5eb628f 100644
--- a/drivers/net/wireless/ath/ath10k/pci.h
+++ b/drivers/net/wireless/ath/ath10k/pci.h
@@ -198,6 +198,7 @@ struct ath10k_pci {
 	 * interrupts.
 	 */
 	int num_msi_intrs;
+	bool intr_started;
 
 	struct tasklet_struct intr_tq;
 	struct tasklet_struct msi_fw_err;
-- 
1.7.9.5

