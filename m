Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f43.google.com ([209.85.215.43]:33087 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751117AbbCBJKZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Mar 2015 04:10:25 -0500
Received: by lamq1 with SMTP id q1so5725141lam.0
        for <linux-wireless@vger.kernel.org>; Mon, 02 Mar 2015 01:10:23 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 2/3] ath10k: always save/restore pci config space
Date: Mon,  2 Mar 2015 10:09:03 +0100
Message-Id: <1425287344-30594-2-git-send-email-michal.kazior@tieto.com> (sfid-20150302_101036_254852_C8CA7C94)
In-Reply-To: <1425287344-30594-1-git-send-email-michal.kazior@tieto.com>
References: <1425287344-30594-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The check isn't really necessary and couldn't even
work because becase pci_restore_state() restores
only first 64 bytes of PCI configuration space.

This is necessary for future WoWLAN support.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/pci.c | 37 +++++++++++------------------------
 1 file changed, 11 insertions(+), 26 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index cbf82ff..d06b264 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -2053,24 +2053,15 @@ static void ath10k_pci_hif_power_down(struct ath10k *ar)
 
 #ifdef CONFIG_PM
 
-#define ATH10K_PCI_PM_CONTROL 0x44
-
 static int ath10k_pci_hif_suspend(struct ath10k *ar)
 {
 	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
 	struct pci_dev *pdev = ar_pci->pdev;
-	u32 val;
 
 	ath10k_pci_sleep(ar);
 
-	pci_read_config_dword(pdev, ATH10K_PCI_PM_CONTROL, &val);
-
-	if ((val & 0x000000ff) != 0x3) {
-		pci_save_state(pdev);
-		pci_disable_device(pdev);
-		pci_write_config_dword(pdev, ATH10K_PCI_PM_CONTROL,
-				       (val & 0xffffff00) | 0x03);
-	}
+	pci_save_state(pdev);
+	pci_disable_device(pdev);
 
 	return 0;
 }
@@ -2088,22 +2079,16 @@ static int ath10k_pci_hif_resume(struct ath10k *ar)
 		return ret;
 	}
 
-	pci_read_config_dword(pdev, ATH10K_PCI_PM_CONTROL, &val);
+	pci_restore_state(pdev);
 
-	if ((val & 0x000000ff) != 0) {
-		pci_restore_state(pdev);
-		pci_write_config_dword(pdev, ATH10K_PCI_PM_CONTROL,
-				       val & 0xffffff00);
-		/*
-		 * Suspend/Resume resets the PCI configuration space,
-		 * so we have to re-disable the RETRY_TIMEOUT register (0x41)
-		 * to keep PCI Tx retries from interfering with C3 CPU state
-		 */
-		pci_read_config_dword(pdev, 0x40, &val);
-
-		if ((val & 0x0000ff00) != 0)
-			pci_write_config_dword(pdev, 0x40, val & 0xffff00ff);
-	}
+	/* Suspend/Resume resets the PCI configuration space, so we have to
+	 * re-disable the RETRY_TIMEOUT register (0x41) to keep PCI Tx retries
+	 * from interfering with C3 CPU state. pci_restore_state won't help
+	 * here since it only restores the first 64 bytes pci config header.
+	 */
+	pci_read_config_dword(pdev, 0x40, &val);
+	if ((val & 0x0000ff00) != 0)
+		pci_write_config_dword(pdev, 0x40, val & 0xffff00ff);
 
 	return ret;
 }
-- 
1.8.5.3

