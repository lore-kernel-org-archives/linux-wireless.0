Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f51.google.com ([74.125.82.51]:55543 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932078AbaHGJNK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Aug 2014 05:13:10 -0400
Received: by mail-wg0-f51.google.com with SMTP id b13so3817140wgh.10
        for <linux-wireless@vger.kernel.org>; Thu, 07 Aug 2014 02:13:08 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 3/6] ath10k: remove pci features var
Date: Thu,  7 Aug 2014 11:03:29 +0200
Message-Id: <1407402212-29809-4-git-send-email-michal.kazior@tieto.com> (sfid-20140807_111329_954091_2EB7D8EE)
In-Reply-To: <1407402212-29809-1-git-send-email-michal.kazior@tieto.com>
References: <1407402212-29809-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The ATH10K_PCI_FEATURE_MSI_X was originally
introduced to support both chips QCA988Xv1 and
QCA988Xv2. Since v1 isn't supported anymore it
doesn't make sense to keep the feature flag
around. Since this is the last one remove the
whole thing.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/pci.c | 33 +--------------------------------
 drivers/net/wireless/ath/ath10k/pci.h |  9 ---------
 2 files changed, 1 insertion(+), 41 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index 5fa45db..c31edb6 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -2318,8 +2318,6 @@ static void ath10k_pci_init_irq_tasklets(struct ath10k *ar)
 static int ath10k_pci_init_irq(struct ath10k *ar)
 {
 	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
-	bool msix_supported = test_bit(ATH10K_PCI_FEATURE_MSI_X,
-				       ar_pci->features);
 	int ret;
 
 	ath10k_pci_init_irq_tasklets(ar);
@@ -2329,7 +2327,7 @@ static int ath10k_pci_init_irq(struct ath10k *ar)
 		ath10k_info("limiting irq mode to: %d\n", ath10k_pci_irq_mode);
 
 	/* Try MSI-X */
-	if (ath10k_pci_irq_mode == ATH10K_PCI_IRQ_AUTO && msix_supported) {
+	if (ath10k_pci_irq_mode == ATH10K_PCI_IRQ_AUTO) {
 		ar_pci->num_msi_intrs = MSI_NUM_REQUEST;
 		ret = pci_enable_msi_range(ar_pci->pdev, ar_pci->num_msi_intrs,
 							 ar_pci->num_msi_intrs);
@@ -2485,22 +2483,6 @@ static int ath10k_pci_cold_reset(struct ath10k *ar)
 	return 0;
 }
 
-static void ath10k_pci_dump_features(struct ath10k_pci *ar_pci)
-{
-	int i;
-
-	for (i = 0; i < ATH10K_PCI_FEATURE_COUNT; i++) {
-		if (!test_bit(i, ar_pci->features))
-			continue;
-
-		switch (i) {
-		case ATH10K_PCI_FEATURE_MSI_X:
-			ath10k_dbg(ATH10K_DBG_BOOT, "device supports MSI-X\n");
-			break;
-		}
-	}
-}
-
 static int ath10k_pci_probe(struct pci_dev *pdev,
 			    const struct pci_device_id *pci_dev)
 {
@@ -2522,19 +2504,6 @@ static int ath10k_pci_probe(struct pci_dev *pdev,
 	ar_pci = ath10k_pci_priv(ar);
 	ar_pci->pdev = pdev;
 	ar_pci->dev = &pdev->dev;
-
-	switch (pci_dev->device) {
-	case QCA988X_2_0_DEVICE_ID:
-		set_bit(ATH10K_PCI_FEATURE_MSI_X, ar_pci->features);
-		break;
-	default:
-		ret = -ENODEV;
-		ath10k_err("Unknown device ID: %d\n", pci_dev->device);
-		goto err_core_destroy;
-	}
-
-	ath10k_pci_dump_features(ar_pci);
-
 	ar_pci->ar = ar;
 
 	pci_set_drvdata(pdev, ar);
diff --git a/drivers/net/wireless/ath/ath10k/pci.h b/drivers/net/wireless/ath/ath10k/pci.h
index 65b1b90..662bca3 100644
--- a/drivers/net/wireless/ath/ath10k/pci.h
+++ b/drivers/net/wireless/ath/ath10k/pci.h
@@ -135,13 +135,6 @@ struct service_to_pipe {
 	u32 pipenum;
 };
 
-enum ath10k_pci_features {
-	ATH10K_PCI_FEATURE_MSI_X		= 0,
-
-	/* keep last */
-	ATH10K_PCI_FEATURE_COUNT
-};
-
 /* Per-pipe state. */
 struct ath10k_pci_pipe {
 	/* Handle of underlying Copy Engine */
@@ -168,8 +161,6 @@ struct ath10k_pci {
 	struct ath10k *ar;
 	void __iomem *mem;
 
-	DECLARE_BITMAP(features, ATH10K_PCI_FEATURE_COUNT);
-
 	/*
 	 * Number of MSI interrupts granted, 0 --> using legacy PCI line
 	 * interrupts.
-- 
1.8.5.3

