Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f53.google.com ([209.85.215.53]:37864 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753489AbbCBMX2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Mar 2015 07:23:28 -0500
Received: by labhs14 with SMTP id hs14so29850137lab.4
        for <linux-wireless@vger.kernel.org>; Mon, 02 Mar 2015 04:23:27 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v2 2/2] ath10k: save/restore pci config space properly
Date: Mon,  2 Mar 2015 13:22:14 +0100
Message-Id: <1425298934-12370-2-git-send-email-michal.kazior@tieto.com> (sfid-20150302_132333_480061_7AA2F4FE)
In-Reply-To: <1425298934-12370-1-git-send-email-michal.kazior@tieto.com>
References: <1425298934-12370-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The check was't really necessary and couldn't even
work to begin with because pci_restore_state()
restores only first 64 bytes of PCI configuration
space.

Actually the PCI subsystem takes care of this so
there's no need for explicit calls to save PCI
state in ath10k.

This is necessary for future WoWLAN support.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---

Notes:
    v2:
     * don't call pci save/restore/enable/disable explicitly and
       leave it to the PCI subsystem [Johannes]
     * adjust commit message
     * the [PATCH 3/3] is effectivelly dropped since
       there's nothing to balance anymore

 drivers/net/wireless/ath/ath10k/pci.c | 39 +++++++----------------------------
 1 file changed, 8 insertions(+), 31 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index cbf82ff..a79b204 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -2053,25 +2053,10 @@ static void ath10k_pci_hif_power_down(struct ath10k *ar)
 
 #ifdef CONFIG_PM
 
-#define ATH10K_PCI_PM_CONTROL 0x44
-
 static int ath10k_pci_hif_suspend(struct ath10k *ar)
 {
-	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
-	struct pci_dev *pdev = ar_pci->pdev;
-	u32 val;
-
 	ath10k_pci_sleep(ar);
 
-	pci_read_config_dword(pdev, ATH10K_PCI_PM_CONTROL, &val);
-
-	if ((val & 0x000000ff) != 0x3) {
-		pci_save_state(pdev);
-		pci_disable_device(pdev);
-		pci_write_config_dword(pdev, ATH10K_PCI_PM_CONTROL,
-				       (val & 0xffffff00) | 0x03);
-	}
-
 	return 0;
 }
 
@@ -2088,22 +2073,14 @@ static int ath10k_pci_hif_resume(struct ath10k *ar)
 		return ret;
 	}
 
-	pci_read_config_dword(pdev, ATH10K_PCI_PM_CONTROL, &val);
-
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

