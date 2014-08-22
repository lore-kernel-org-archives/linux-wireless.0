Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f177.google.com ([209.85.217.177]:44794 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756102AbaHVMd3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Aug 2014 08:33:29 -0400
Received: by mail-lb0-f177.google.com with SMTP id s7so9536270lbd.36
        for <linux-wireless@vger.kernel.org>; Fri, 22 Aug 2014 05:33:27 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v2 3/6] ath10k: setup irq method in probe
Date: Fri, 22 Aug 2014 14:23:31 +0200
Message-Id: <1408710214-24894-4-git-send-email-michal.kazior@tieto.com> (sfid-20140822_143334_015487_821E0BE2)
In-Reply-To: <1408710214-24894-1-git-send-email-michal.kazior@tieto.com>
References: <1408710214-24894-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It doesn't make sense to re-init irqs completely
whenever transport is started/stopped. Do it just
once upon probing/removing.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---

Notes:
    v2:
     * tweak print style [Kalle]
     * use ce_deinit instead of ce_init

 drivers/net/wireless/ath/ath10k/core.h |  1 -
 drivers/net/wireless/ath/ath10k/pci.c  | 73 ++++++++++++++++++----------------
 2 files changed, 39 insertions(+), 35 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 8da77c7..4ef4760 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -357,7 +357,6 @@ enum ath10k_fw_features {
 enum ath10k_dev_flags {
 	/* Indicates that ath10k device is during CAC phase of DFS */
 	ATH10K_CAC_RUNNING,
-	ATH10K_FLAG_FIRST_BOOT_DONE,
 	ATH10K_FLAG_CORE_REGISTERED,
 };
 
diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index 4a7a5fe..c3b3f62 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -306,6 +306,18 @@ static void ath10k_pci_free_early_irq(struct ath10k *ar)
 	free_irq(ath10k_pci_priv(ar)->pdev->irq, ar);
 }
 
+static inline const char *ath10k_pci_get_irq_method(struct ath10k *ar)
+{
+	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
+
+	if (ar_pci->num_msi_intrs > 1)
+		return "msi-x";
+	else if (ar_pci->num_msi_intrs == 1)
+		return "msi";
+	else
+		return "legacy";
+}
+
 /*
  * Diagnostic read/write access is provided for startup/config/debug usage.
  * Caller must guarantee proper alignment, when applicable, and single user
@@ -1922,8 +1934,6 @@ static int ath10k_pci_warm_reset(struct ath10k *ar)
 
 static int __ath10k_pci_hif_power_up(struct ath10k *ar, bool cold_reset)
 {
-	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
-	const char *irq_mode;
 	int ret;
 
 	/*
@@ -1952,22 +1962,10 @@ static int __ath10k_pci_hif_power_up(struct ath10k *ar, bool cold_reset)
 		goto err;
 	}
 
-	ret = ath10k_ce_disable_interrupts(ar);
-	if (ret) {
-		ath10k_err("failed to disable CE interrupts: %d\n", ret);
-		goto err_ce;
-	}
-
-	ret = ath10k_pci_init_irq(ar);
-	if (ret) {
-		ath10k_err("failed to init irqs: %d\n", ret);
-		goto err_ce;
-	}
-
 	ret = ath10k_pci_request_early_irq(ar);
 	if (ret) {
 		ath10k_err("failed to request early irq: %d\n", ret);
-		goto err_deinit_irq;
+		goto err_ce;
 	}
 
 	ret = ath10k_pci_wait_for_target_init(ar);
@@ -1988,24 +1986,10 @@ static int __ath10k_pci_hif_power_up(struct ath10k *ar, bool cold_reset)
 		goto err_free_early_irq;
 	}
 
-	if (ar_pci->num_msi_intrs > 1)
-		irq_mode = "MSI-X";
-	else if (ar_pci->num_msi_intrs == 1)
-		irq_mode = "MSI";
-	else
-		irq_mode = "legacy";
-
-	if (!test_bit(ATH10K_FLAG_FIRST_BOOT_DONE, &ar->dev_flags))
-		ath10k_info("pci irq %s irq_mode %d reset_mode %d\n",
-			    irq_mode, ath10k_pci_irq_mode,
-			    ath10k_pci_reset_mode);
-
 	return 0;
 
 err_free_early_irq:
 	ath10k_pci_free_early_irq(ar);
-err_deinit_irq:
-	ath10k_pci_deinit_irq(ar);
 err_ce:
 	ath10k_pci_ce_deinit(ar);
 	ath10k_pci_warm_reset(ar);
@@ -2076,8 +2060,6 @@ static void ath10k_pci_hif_power_down(struct ath10k *ar)
 
 	ath10k_pci_free_early_irq(ar);
 	ath10k_pci_kill_tasklet(ar);
-	ath10k_pci_deinit_irq(ar);
-	ath10k_pci_ce_deinit(ar);
 	ath10k_pci_warm_reset(ar);
 }
 
@@ -2369,8 +2351,7 @@ static int ath10k_pci_init_irq(struct ath10k *ar)
 
 	ath10k_pci_init_irq_tasklets(ar);
 
-	if (ath10k_pci_irq_mode != ATH10K_PCI_IRQ_AUTO &&
-	    !test_bit(ATH10K_FLAG_FIRST_BOOT_DONE, &ar->dev_flags))
+	if (ath10k_pci_irq_mode != ATH10K_PCI_IRQ_AUTO)
 		ath10k_info("limiting irq mode to: %d\n", ath10k_pci_irq_mode);
 
 	/* Try MSI-X */
@@ -2655,14 +2636,36 @@ static int ath10k_pci_probe(struct pci_dev *pdev,
 		goto err_sleep;
 	}
 
+	ath10k_pci_ce_deinit(ar);
+
+	ret = ath10k_ce_disable_interrupts(ar);
+	if (ret) {
+		ath10k_err("failed to disable copy engine interrupts: %d\n",
+			   ret);
+		goto err_free_ce;
+	}
+
+	ret = ath10k_pci_init_irq(ar);
+	if (ret) {
+		ath10k_err("failed to init irqs: %d\n", ret);
+		goto err_free_ce;
+	}
+
+	ath10k_info("pci irq %s interrupts %d irq_mode %d reset_mode %d\n",
+		    ath10k_pci_get_irq_method(ar), ar_pci->num_msi_intrs,
+		    ath10k_pci_irq_mode, ath10k_pci_reset_mode);
+
 	ret = ath10k_core_register(ar, chip_id);
 	if (ret) {
 		ath10k_err("failed to register driver core: %d\n", ret);
-		goto err_free_ce;
+		goto err_deinit_irq;
 	}
 
 	return 0;
 
+err_deinit_irq:
+	ath10k_pci_deinit_irq(ar);
+
 err_free_ce:
 	ath10k_pci_free_ce(ar);
 
@@ -2694,6 +2697,8 @@ static void ath10k_pci_remove(struct pci_dev *pdev)
 		return;
 
 	ath10k_core_unregister(ar);
+	ath10k_pci_deinit_irq(ar);
+	ath10k_pci_ce_deinit(ar);
 	ath10k_pci_free_ce(ar);
 	ath10k_pci_sleep(ar);
 	ath10k_pci_release(ar);
-- 
1.8.5.3

