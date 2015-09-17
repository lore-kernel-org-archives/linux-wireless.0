Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:33065 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753476AbbIQGSB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Sep 2015 02:18:01 -0400
Received: by lbbvu2 with SMTP id vu2so3984122lbb.0
        for <linux-wireless@vger.kernel.org>; Wed, 16 Sep 2015 23:17:59 -0700 (PDT)
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>
Subject: [PATCH] ath10k: fix MSI-X registering for qca99x0
Date: Thu, 17 Sep 2015 08:17:33 +0200
Message-Id: <1442470653-25162-1-git-send-email-janusz.dziedzic@tieto.com> (sfid-20150917_081805_998540_B1AF3C71)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In case of qca99x0 and MSI-X supported/enabled we
failed during interrupts registering with message:

ath10k_pci 0000:04:00.0: failed to request MSI-X ce irq 50: -22

Issue/fix was reproduced/tested using Dell Latitude E6430 laptop.

Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
---
 drivers/net/wireless/ath/ath10k/hw.h  | 10 ----------
 drivers/net/wireless/ath/ath10k/pci.c | 18 +++++-------------
 2 files changed, 5 insertions(+), 23 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/hw.h b/drivers/net/wireless/ath/ath10k/hw.h
index 23afcda..bc421a5 100644
--- a/drivers/net/wireless/ath/ath10k/hw.h
+++ b/drivers/net/wireless/ath/ath10k/hw.h
@@ -414,16 +414,6 @@ enum ath10k_hw_rate_cck {
 #define CE_COUNT ar->hw_values->ce_count
 
 /*
- * Total number of PCIe MSI interrupts requested for all interrupt sources.
- * PCIe standard forces this to be a power of 2.
- * Some Host OS's limit MSI requests that can be granted to 8
- * so for now we abide by this limit and avoid requesting more
- * than that.
- */
-#define MSI_NUM_REQUEST_LOG2	3
-#define MSI_NUM_REQUEST		(1<<MSI_NUM_REQUEST_LOG2)
-
-/*
  * Granted MSIs are assigned as follows:
  * Firmware uses the first
  * Remaining MSIs, if any, are used by Copy Engines
diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index 1046ab6..110fcad6 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -2609,12 +2609,9 @@ static int ath10k_pci_request_irq(struct ath10k *ar)
 		return ath10k_pci_request_irq_legacy(ar);
 	case 1:
 		return ath10k_pci_request_irq_msi(ar);
-	case MSI_NUM_REQUEST:
+	default:
 		return ath10k_pci_request_irq_msix(ar);
 	}
-
-	ath10k_warn(ar, "unknown irq configuration upon request\n");
-	return -EINVAL;
 }
 
 static void ath10k_pci_free_irq(struct ath10k *ar)
@@ -2657,7 +2654,7 @@ static int ath10k_pci_init_irq(struct ath10k *ar)
 
 	/* Try MSI-X */
 	if (ath10k_pci_irq_mode == ATH10K_PCI_IRQ_AUTO) {
-		ar_pci->num_msi_intrs = MSI_NUM_REQUEST;
+		ar_pci->num_msi_intrs = MSI_ASSIGN_CE_MAX + 1;
 		ret = pci_enable_msi_range(ar_pci->pdev, ar_pci->num_msi_intrs,
 					   ar_pci->num_msi_intrs);
 		if (ret > 0)
@@ -2705,18 +2702,13 @@ static int ath10k_pci_deinit_irq(struct ath10k *ar)
 	switch (ar_pci->num_msi_intrs) {
 	case 0:
 		ath10k_pci_deinit_irq_legacy(ar);
-		return 0;
-	case 1:
-		/* fall-through */
-	case MSI_NUM_REQUEST:
-		pci_disable_msi(ar_pci->pdev);
-		return 0;
+		break;
 	default:
 		pci_disable_msi(ar_pci->pdev);
+		break;
 	}
 
-	ath10k_warn(ar, "unknown irq configuration upon deinit\n");
-	return -EINVAL;
+	return 0;
 }
 
 static int ath10k_pci_wait_for_target_init(struct ath10k *ar)
-- 
1.9.1

