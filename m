Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f45.google.com ([74.125.83.45]:53100 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754738Ab3KVNIp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Nov 2013 08:08:45 -0500
Received: by mail-ee0-f45.google.com with SMTP id d49so622359eek.32
        for <linux-wireless@vger.kernel.org>; Fri, 22 Nov 2013 05:08:44 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 5/8] ath10k: defer irq registration until hif start()
Date: Fri, 22 Nov 2013 14:05:15 +0100
Message-Id: <1385125518-13461-6-git-send-email-michal.kazior@tieto.com> (sfid-20131122_140858_581371_FFAB2F28)
In-Reply-To: <1385125518-13461-1-git-send-email-michal.kazior@tieto.com>
References: <1385125518-13461-1-git-send-email-michal.kazior@tieto.com>
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
 drivers/net/wireless/ath/ath10k/pci.c | 62 +++++++++++++++--------------------
 1 file changed, 26 insertions(+), 36 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index 1b12db8..fa1162e 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -886,13 +886,6 @@ static void ath10k_pci_stop_ce(struct ath10k *ar)
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
@@ -1203,17 +1196,30 @@ static int ath10k_pci_hif_start(struct ath10k *ar)
 		return ret;
 	}
 
+	ret = ath10k_pci_request_irq(ar);
+	if (ret) {
+		ath10k_warn("failed to post RX buffers for all pipes: %d\n",
+			    ret);
+		goto err_stop_ce;
+	}
+
 	/* Post buffers once to start things off. */
 	ret = ath10k_pci_post_rx(ar);
 	if (ret) {
 		ath10k_warn("failed to post RX buffers for all pipes: %d\n",
 			    ret);
-		ath10k_pci_stop_ce(ar);
-		return ret;
+		goto err_free_irq;
 	}
 
 	ar_pci->started = 1;
 	return 0;
+
+err_free_irq:
+	ath10k_pci_free_irq(ar);
+	ath10k_pci_kill_tasklet(ar);
+err_stop_ce:
+	ath10k_pci_stop_ce(ar);
+	return ret;
 }
 
 static void ath10k_pci_rx_pipe_cleanup(struct ath10k_pci_pipe *pipe_info)
@@ -1331,25 +1337,19 @@ static void ath10k_pci_ce_deinit(struct ath10k *ar)
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
@@ -1900,34 +1900,28 @@ static int ath10k_pci_hif_power_up(struct ath10k *ar)
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
+		goto err_deinit_irq;
 	}
 
 	ret = ath10k_ce_enable_err_irq(ar);
 	if (ret) {
 		ath10k_err("failed to enable CE error irq: %d\n", ret);
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
@@ -1942,14 +1936,11 @@ static int ath10k_pci_hif_power_up(struct ath10k *ar)
 
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
@@ -1961,7 +1952,6 @@ static void ath10k_pci_hif_power_down(struct ath10k *ar)
 {
 	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
 
-	ath10k_pci_free_irq(ar);
 	ath10k_pci_deinit_irq(ar);
 	ath10k_pci_device_reset(ar);
 
-- 
1.8.4.rc3

