Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f44.google.com ([209.85.215.44]:56675 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756102AbaHVMdb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Aug 2014 08:33:31 -0400
Received: by mail-la0-f44.google.com with SMTP id el20so9986760lab.31
        for <linux-wireless@vger.kernel.org>; Fri, 22 Aug 2014 05:33:30 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v2 5/6] ath10k: make sure to really disable irqs
Date: Fri, 22 Aug 2014 14:23:33 +0200
Message-Id: <1408710214-24894-6-git-send-email-michal.kazior@tieto.com> (sfid-20140822_143338_993049_AA932423)
In-Reply-To: <1408710214-24894-1-git-send-email-michal.kazior@tieto.com>
References: <1408710214-24894-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This fixes two corner cases.

One is a race between disabling copy engine
interrupts and unhandled pending interrupts on the
host. This could end up with a runaway tasklet and
consequently memory leak of a few copy engine
rx buffers.

The other one is an unexpected (and non-maskable
via device CSR) MSI fw indication interrupt during
teardown. This could trigger the same problem as
the first corner case.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/pci.c | 43 ++++++++++++++++++++++++++++++-----
 1 file changed, 37 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index c764dd7..6224952 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -1121,6 +1121,40 @@ static int ath10k_pci_post_rx(struct ath10k *ar)
 	return 0;
 }
 
+static void ath10k_pci_irq_disable(struct ath10k *ar)
+{
+	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
+	int i;
+
+	ath10k_ce_disable_interrupts(ar);
+
+	/* Regardless how many interrupts were assigned for MSI the first one
+	 * is always used for firmware indications (crashes). There's no way to
+	 * mask the irq in the device so call disable_irq(). Legacy (shared)
+	 * interrupts can be masked on the device though.
+	 */
+	if (ar_pci->num_msi_intrs > 0)
+		disable_irq(ar_pci->pdev->irq);
+	else
+		ath10k_pci_disable_and_clear_legacy_irq(ar);
+
+	for (i = 0; i < max(1, ar_pci->num_msi_intrs); i++)
+		synchronize_irq(ar_pci->pdev->irq + i);
+}
+
+static void ath10k_pci_irq_enable(struct ath10k *ar)
+{
+	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
+
+	ath10k_ce_enable_interrupts(ar);
+
+	/* See comment in ath10k_pci_irq_disable() */
+	if (ar_pci->num_msi_intrs > 0)
+		enable_irq(ar_pci->pdev->irq);
+	else
+		ath10k_pci_enable_legacy_irq(ar);
+}
+
 static int ath10k_pci_hif_start(struct ath10k *ar)
 {
 	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
@@ -1138,7 +1172,7 @@ static int ath10k_pci_hif_start(struct ath10k *ar)
 		goto err_early_irq;
 	}
 
-	ath10k_ce_enable_interrupts(ar);
+	ath10k_pci_irq_enable(ar);
 
 	/* Post buffers once to start things off. */
 	ret = ath10k_pci_post_rx(ar);
@@ -1152,7 +1186,7 @@ static int ath10k_pci_hif_start(struct ath10k *ar)
 	return 0;
 
 err_stop:
-	ath10k_ce_disable_interrupts(ar);
+	ath10k_pci_irq_disable(ar);
 	ath10k_pci_free_irq(ar);
 	ath10k_pci_kill_tasklet(ar);
 err_early_irq:
@@ -1275,10 +1309,7 @@ static void ath10k_pci_hif_stop(struct ath10k *ar)
 	if (WARN_ON(!ar_pci->started))
 		return;
 
-	ret = ath10k_ce_disable_interrupts(ar);
-	if (ret)
-		ath10k_warn("failed to disable CE interrupts: %d\n", ret);
-
+	ath10k_pci_irq_disable(ar);
 	ath10k_pci_free_irq(ar);
 	ath10k_pci_kill_tasklet(ar);
 
-- 
1.8.5.3

