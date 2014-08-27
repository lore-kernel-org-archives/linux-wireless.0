Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f169.google.com ([209.85.217.169]:35188 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933490AbaH0NTo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Aug 2014 09:19:44 -0400
Received: by mail-lb0-f169.google.com with SMTP id n15so324238lbi.14
        for <linux-wireless@vger.kernel.org>; Wed, 27 Aug 2014 06:19:43 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH] ath10k: re-enable interrupts properly in hw recovery
Date: Wed, 27 Aug 2014 15:09:49 +0200
Message-Id: <1409144989-17934-1-git-send-email-michal.kazior@tieto.com> (sfid-20140827_151947_702640_2862ACBC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Recent changes done to start/restart sequences
broke hw recovery in some hw configurations. The
pci transport was stopped twice however due to a
workaround in the pci disabling code the
disable/enable for first msi interrupt was not
balanced. This ended up with irqs not being
properly re-enabled and the following print out
during recovery:

 ath10k: failed to receive control response completion, polling..
 ath10k: Service connect timeout: -110
 ath10k: Could not init core: -110

Legacy interrupt mode was unaffected while msi
ranged mode would be partially crippled (it would
miss fw indication interrupts but otherwise it
worked fine).

This fixes completely broken fw recovery for a
single msi interrupt mode and fixes subsequent fw
crash reports for msi range interrupt mode.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/pci.c | 35 ++++++++++++++---------------------
 1 file changed, 14 insertions(+), 21 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index 144eb8a3..4b1a7ef 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -1083,16 +1083,8 @@ static void ath10k_pci_irq_disable(struct ath10k *ar)
 	int i;
 
 	ath10k_ce_disable_interrupts(ar);
-
-	/* Regardless how many interrupts were assigned for MSI the first one
-	 * is always used for firmware indications (crashes). There's no way to
-	 * mask the irq in the device so call disable_irq(). Legacy (shared)
-	 * interrupts can be masked on the device though.
-	 */
-	if (ar_pci->num_msi_intrs > 0)
-		disable_irq(ar_pci->pdev->irq);
-	else
-		ath10k_pci_disable_and_clear_legacy_irq(ar);
+	ath10k_pci_disable_and_clear_legacy_irq(ar);
+	/* FIXME: How to mask all MSI interrupts? */
 
 	for (i = 0; i < max(1, ar_pci->num_msi_intrs); i++)
 		synchronize_irq(ar_pci->pdev->irq + i);
@@ -1100,15 +1092,9 @@ static void ath10k_pci_irq_disable(struct ath10k *ar)
 
 static void ath10k_pci_irq_enable(struct ath10k *ar)
 {
-	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
-
 	ath10k_ce_enable_interrupts(ar);
-
-	/* See comment in ath10k_pci_irq_disable() */
-	if (ar_pci->num_msi_intrs > 0)
-		enable_irq(ar_pci->pdev->irq);
-	else
-		ath10k_pci_enable_legacy_irq(ar);
+	ath10k_pci_enable_legacy_irq(ar);
+	/* FIXME: How to unmask all MSI interrupts? */
 }
 
 static int ath10k_pci_hif_start(struct ath10k *ar)
@@ -1222,14 +1208,21 @@ static void ath10k_pci_hif_stop(struct ath10k *ar)
 {
 	ath10k_dbg(ar, ATH10K_DBG_BOOT, "boot hif stop\n");
 
-	ath10k_pci_irq_disable(ar);
-	ath10k_pci_flush(ar);
-
 	/* Most likely the device has HTT Rx ring configured. The only way to
 	 * prevent the device from accessing (and possible corrupting) host
 	 * memory is to reset the chip now.
+	 *
+	 * There's also no known way of masking MSI interrupts on the device.
+	 * For ranged MSI the CE-related interrupts can be masked. However
+	 * regardless how many MSI interrupts are assigned the first one
+	 * is always used for firmware indications (crashes) and cannot be
+	 * masked. To prevent the device from asserting the interrupt reset it
+	 * before proceeding with cleanup.
 	 */
 	ath10k_pci_warm_reset(ar);
+
+	ath10k_pci_irq_disable(ar);
+	ath10k_pci_flush(ar);
 }
 
 static int ath10k_pci_hif_exchange_bmi_msg(struct ath10k *ar,
-- 
1.8.5.3

