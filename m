Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh06.mail.saunalahti.fi ([62.142.5.116]:56385 "EHLO
	emh06.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751099Ab3JQIgT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Oct 2013 04:36:19 -0400
Subject: [PATCH] ath10k: add error handling to ath10k_pci_wait()
To: ath10k@lists.infradead.org
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 17 Oct 2013 11:36:15 +0300
Message-ID: <20131017083615.31028.25088.stgit@localhost6.localdomain6> (sfid-20131017_103623_781430_CB9AC62E)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ath10k_pci_wait() didn't notify any errors to callers, it
just printed a warning so add proper error handling.

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/pci.c |   28 ++++++++++++++++++++++++----
 1 file changed, 24 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index 1e9cfcc9..92759cd 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -525,15 +525,19 @@ static bool ath10k_pci_target_is_awake(struct ath10k *ar)
 	return (RTC_STATE_V_GET(val) == RTC_STATE_V_ON);
 }
 
-static void ath10k_pci_wait(struct ath10k *ar)
+static int ath10k_pci_wait(struct ath10k *ar)
 {
 	int n = 100;
 
 	while (n-- && !ath10k_pci_target_is_awake(ar))
 		msleep(10);
 
-	if (n < 0)
+	if (n < 0) {
 		ath10k_warn("Unable to wakeup target\n");
+		return -ETIMEDOUT;
+	}
+
+	return 0;
 }
 
 int ath10k_do_pci_wake(struct ath10k *ar)
@@ -2227,7 +2231,13 @@ static int ath10k_pci_start_intr_legacy(struct ath10k *ar)
 		  ar_pci->mem + PCIE_LOCAL_BASE_ADDRESS +
 		  PCIE_SOC_WAKE_ADDRESS);
 
-	ath10k_pci_wait(ar);
+	ret = ath10k_pci_wait(ar);
+	if (ret) {
+		ath10k_warn("Failed to enable legacy interrupt, target did not wake up: %d\n",
+			    ret);
+		free_irq(ar_pci->pdev->irq, ar);
+		return ret;
+	}
 
 	/*
 	 * A potential race occurs here: The CORE_BASE write
@@ -2290,6 +2300,10 @@ static int ath10k_pci_start_intr(struct ath10k *ar)
 	}
 
 	ret = ath10k_pci_start_intr_legacy(ar);
+	if (ret) {
+		ath10k_warn("Failed to start legacy interrupts: %d\n", ret);
+		return ret;
+	}
 
 exit:
 	ar_pci->num_msi_intrs = num;
@@ -2315,13 +2329,19 @@ static int ath10k_pci_reset_target(struct ath10k *ar)
 {
 	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
 	int wait_limit = 300; /* 3 sec */
+	int ret;
 
 	/* Wait for Target to finish initialization before we proceed. */
 	iowrite32(PCIE_SOC_WAKE_V_MASK,
 		  ar_pci->mem + PCIE_LOCAL_BASE_ADDRESS +
 		  PCIE_SOC_WAKE_ADDRESS);
 
-	ath10k_pci_wait(ar);
+	ret = ath10k_pci_wait(ar);
+	if (ret) {
+		ath10k_warn("Failed to reset target, target did not wake up: %d\n",
+			    ret);
+		return ret;
+	}
 
 	while (wait_limit-- &&
 	       !(ioread32(ar_pci->mem + FW_INDICATOR_ADDRESS) &

