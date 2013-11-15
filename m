Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh02.mail.saunalahti.fi ([62.142.5.108]:50649 "EHLO
	emh02.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751253Ab3KORZa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Nov 2013 12:25:30 -0500
Subject: [PATCH 1/3] ath10k: don't show MSI registration warnings
To: ath10k@lists.infradead.org
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 15 Nov 2013 19:25:26 +0200
Message-ID: <20131115172526.10646.35233.stgit@localhost6.localdomain6> (sfid-20131115_182533_830080_DC20CBDB)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Convert the MSI failure warnings to a debug message to make them less spammy.
Also convert the irq mode printout to a single print to make it easier to
show it only once.

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/pci.c |   26 ++++++++++++++++++++------
 1 file changed, 20 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index 46c94ce..a3cdd72 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -1851,6 +1851,7 @@ static void ath10k_pci_start_bmi(struct ath10k *ar)
 static int ath10k_pci_hif_power_up(struct ath10k *ar)
 {
 	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
+	const char *irq_mode;
 	int ret;
 
 	/*
@@ -1916,6 +1917,16 @@ static int ath10k_pci_hif_power_up(struct ath10k *ar)
 	}
 
 	ath10k_pci_start_bmi(ar);
+
+	if (ar_pci->num_msi_intrs > 1)
+		irq_mode = "MSI-X";
+	else if (ar_pci->num_msi_intrs == 1)
+		irq_mode = "MSI";
+	else
+		irq_mode = "legacy";
+
+	ath10k_info("pci irq %s\n", irq_mode);
+
 	return 0;
 
 err_irq:
@@ -2161,7 +2172,8 @@ static int ath10k_pci_start_intr_msix(struct ath10k *ar, int num)
 		}
 	}
 
-	ath10k_info("MSI-X interrupt handling (%d intrs)\n", num);
+	ath10k_dbg(ATH10K_DBG_BOOT,
+		   "MSI-X interrupt handling (%d intrs)\n", num);
 	return 0;
 }
 
@@ -2182,7 +2194,7 @@ static int ath10k_pci_start_intr_msi(struct ath10k *ar)
 		return ret;
 	}
 
-	ath10k_info("MSI interrupt handling\n");
+	ath10k_dbg(ATH10K_DBG_BOOT, "MSI interrupt handling\n");
 	return 0;
 }
 
@@ -2218,7 +2230,7 @@ static int ath10k_pci_start_intr_legacy(struct ath10k *ar)
 				 PCIE_INTR_ENABLE_ADDRESS));
 
 	ath10k_pci_sleep(ar);
-	ath10k_info("legacy interrupt handling\n");
+	ath10k_dbg(ATH10K_DBG_BOOT, "legacy interrupt handling\n");
 	return 0;
 }
 
@@ -2248,7 +2260,8 @@ static int ath10k_pci_start_intr(struct ath10k *ar)
 		if (ret == 0)
 			goto exit;
 
-		ath10k_warn("MSI-X didn't succeed (%d), trying MSI\n", ret);
+		ath10k_dbg(ATH10K_DBG_BOOT,
+			   "MSI-X didn't succeed (%d), trying MSI\n", ret);
 		num = 1;
 	}
 
@@ -2257,8 +2270,9 @@ static int ath10k_pci_start_intr(struct ath10k *ar)
 		if (ret == 0)
 			goto exit;
 
-		ath10k_warn("MSI didn't succeed (%d), trying legacy INTR\n",
-			    ret);
+		ath10k_dbg(ATH10K_DBG_BOOT,
+			   "MSI didn't succeed (%d), trying legacy INTR\n",
+			   ret);
 		num = 0;
 	}
 

