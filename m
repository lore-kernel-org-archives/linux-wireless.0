Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f42.google.com ([209.85.215.42]:40697 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752714AbbCBMX1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Mar 2015 07:23:27 -0500
Received: by labgd6 with SMTP id gd6so29886594lab.7
        for <linux-wireless@vger.kernel.org>; Mon, 02 Mar 2015 04:23:26 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v2 1/2] ath10k: fix some pci wake/sleep issues
Date: Mon,  2 Mar 2015 13:22:13 +0100
Message-Id: <1425298934-12370-1-git-send-email-michal.kazior@tieto.com> (sfid-20150302_132332_564826_7935CD0D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In some cases the device ends up sleeping while
ath10k didn't expect it to leading to reading
garbage from registers, e.g. when shared irqs are
used and the driver is in powered down state.

This effectively makes the device remain awake all
the time even when all interfaces are down.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/pci.c | 37 ++++++++++++++++++++++++++++++-----
 1 file changed, 32 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index e6972b0..cbf82ff 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -819,6 +819,21 @@ static int ath10k_pci_wake_wait(struct ath10k *ar)
 	return -ETIMEDOUT;
 }
 
+/* The rule is host is forbidden from accessing device registers while it's
+ * asleep. Currently ath10k_pci_wake() and ath10k_pci_sleep() calls aren't
+ * balanced and the device is kept awake all the time. This is intended for a
+ * simpler solution for the following problems:
+ *
+ *   * device can enter sleep during s2ram without the host knowing,
+ *
+ *   * irq handlers access registers which is a problem if other device asserts
+ *     a shared irq line when ath10k is between hif_power_down() and
+ *     hif_power_up().
+ *
+ * FIXME: If power consumption is a concern (and there are *real* gains) then a
+ * refcounted wake/sleep needs to be implemented.
+ */
+
 static int ath10k_pci_wake(struct ath10k *ar)
 {
 	ath10k_pci_reg_write32(ar, PCIE_SOC_WAKE_ADDRESS,
@@ -2034,8 +2049,6 @@ static void ath10k_pci_hif_power_down(struct ath10k *ar)
 	/* Currently hif_power_up performs effectively a reset and hif_stop
 	 * resets the chip as well so there's no point in resetting here.
 	 */
-
-	ath10k_pci_sleep(ar);
 }
 
 #ifdef CONFIG_PM
@@ -2048,6 +2061,8 @@ static int ath10k_pci_hif_suspend(struct ath10k *ar)
 	struct pci_dev *pdev = ar_pci->pdev;
 	u32 val;
 
+	ath10k_pci_sleep(ar);
+
 	pci_read_config_dword(pdev, ATH10K_PCI_PM_CONTROL, &val);
 
 	if ((val & 0x000000ff) != 0x3) {
@@ -2065,6 +2080,13 @@ static int ath10k_pci_hif_resume(struct ath10k *ar)
 	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
 	struct pci_dev *pdev = ar_pci->pdev;
 	u32 val;
+	int ret;
+
+	ret = ath10k_pci_wake(ar);
+	if (ret) {
+		ath10k_err(ar, "failed to wake device up on resume: %d\n", ret);
+		return ret;
+	}
 
 	pci_read_config_dword(pdev, ATH10K_PCI_PM_CONTROL, &val);
 
@@ -2083,7 +2105,7 @@ static int ath10k_pci_hif_resume(struct ath10k *ar)
 			pci_write_config_dword(pdev, 0x40, val & 0xffff00ff);
 	}
 
-	return 0;
+	return ret;
 }
 #endif
 
@@ -2177,6 +2199,13 @@ static irqreturn_t ath10k_pci_interrupt_handler(int irq, void *arg)
 {
 	struct ath10k *ar = arg;
 	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
+	int ret;
+
+	ret = ath10k_pci_wake(ar);
+	if (ret) {
+		ath10k_warn(ar, "failed to wake device up on irq: %d\n", ret);
+		return IRQ_NONE;
+	}
 
 	if (ar_pci->num_msi_intrs == 0) {
 		if (!ath10k_pci_irq_pending(ar))
@@ -2681,8 +2710,6 @@ static int ath10k_pci_probe(struct pci_dev *pdev,
 		goto err_sleep;
 	}
 
-	ath10k_pci_sleep(ar);
-
 	ret = ath10k_core_register(ar, chip_id);
 	if (ret) {
 		ath10k_err(ar, "failed to register driver core: %d\n", ret);
-- 
1.8.5.3

