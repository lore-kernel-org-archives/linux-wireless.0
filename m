Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:50872 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752776AbbLJJpN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Dec 2015 04:45:13 -0500
From: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
Subject: [PATCH 2/2] ath10k: reduce indentation by moving powersave check within function
Date: Thu, 10 Dec 2015 15:14:27 +0530
Message-ID: <1449740667-25901-2-git-send-email-rmanohar@qti.qualcomm.com> (sfid-20151210_104522_063902_CD406645)
In-Reply-To: <1449740667-25901-1-git-send-email-rmanohar@qti.qualcomm.com>
References: <1449740667-25901-1-git-send-email-rmanohar@qti.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

For devices that does not support PCI power save, force wake up
API is used. So move powersave check inside force wakeup to reduce
one level indentation.

Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/pci.c | 34 +++++++++++++++-------------------
 1 file changed, 15 insertions(+), 19 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index 473a141..c6aaad2 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -487,6 +487,9 @@ static int ath10k_pci_force_wake(struct ath10k *ar)
 	unsigned long flags;
 	int ret = 0;
 
+	if (ar_pci->pci_ps)
+		return ret;
+
 	spin_lock_irqsave(&ar_pci->ps_lock, flags);
 
 	if (!ar_pci->ps_awake) {
@@ -2480,12 +2483,10 @@ static int ath10k_pci_hif_resume(struct ath10k *ar)
 	u32 val;
 	int ret = 0;
 
-	if (ar_pci->pci_ps == 0) {
-		ret = ath10k_pci_force_wake(ar);
-		if (ret) {
-			ath10k_err(ar, "failed to wake up target: %d\n", ret);
-			return ret;
-		}
+	ret = ath10k_pci_force_wake(ar);
+	if (ret) {
+		ath10k_err(ar, "failed to wake up target: %d\n", ret);
+		return ret;
 	}
 
 	/* Suspend/Resume resets the PCI configuration space, so we have to
@@ -2592,13 +2593,10 @@ static irqreturn_t ath10k_pci_interrupt_handler(int irq, void *arg)
 	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
 	int ret;
 
-	if (ar_pci->pci_ps == 0) {
-		ret = ath10k_pci_force_wake(ar);
-		if (ret) {
-			ath10k_warn(ar, "failed to wake device up on irq: %d\n",
-				    ret);
-			return IRQ_NONE;
-		}
+	ret = ath10k_pci_force_wake(ar);
+	if (ret) {
+		ath10k_warn(ar, "failed to wake device up on irq: %d\n", ret);
+		return IRQ_NONE;
 	}
 
 	if (ar_pci->num_msi_intrs == 0) {
@@ -3071,12 +3069,10 @@ static int ath10k_pci_probe(struct pci_dev *pdev,
 		goto err_sleep;
 	}
 
-	if (ar_pci->pci_ps == 0) {
-		ret = ath10k_pci_force_wake(ar);
-		if (ret) {
-			ath10k_warn(ar, "failed to wake up device : %d\n", ret);
-			goto err_free_pipes;
-		}
+	ret = ath10k_pci_force_wake(ar);
+	if (ret) {
+		ath10k_warn(ar, "failed to wake up device : %d\n", ret);
+		goto err_free_pipes;
 	}
 
 	ath10k_pci_ce_deinit(ar);
-- 
2.6.3

