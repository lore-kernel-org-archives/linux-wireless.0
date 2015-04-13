Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f179.google.com ([209.85.217.179]:34806 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752138AbbDMHq0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Apr 2015 03:46:26 -0400
Received: by lbcga7 with SMTP id ga7so52296994lbc.1
        for <linux-wireless@vger.kernel.org>; Mon, 13 Apr 2015 00:46:24 -0700 (PDT)
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>
Subject: [RFC 1/2] ath10k: refactor ASPM workaround
Date: Mon, 13 Apr 2015 09:45:40 +0200
Message-Id: <1428911141-6534-1-git-send-email-janusz.dziedzic@tieto.com> (sfid-20150413_094630_477061_70F1E05B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Disable ASPM only when loading firmware.
After that back to BIOS/system ASMP
settings. When ASPM is enable by system,
this decrease power consumtion.

Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
---
 drivers/net/wireless/ath/ath10k/pci.c | 17 ++++++++++++-----
 drivers/net/wireless/ath/ath10k/pci.h |  3 +++
 2 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index 51e3921..9923c09 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -1227,11 +1227,16 @@ static void ath10k_pci_irq_enable(struct ath10k *ar)
 
 static int ath10k_pci_hif_start(struct ath10k *ar)
 {
+	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
 	ath10k_dbg(ar, ATH10K_DBG_BOOT, "boot hif start\n");
 
 	ath10k_pci_irq_enable(ar);
 	ath10k_pci_rx_post(ar);
 
+	/* Workaround: Back to BIOS/system settings */
+	pcie_capability_write_word(ar_pci->pdev, PCI_EXP_LNKCTL,
+				   ar_pci->link_ctl);
+
 	return 0;
 }
 
@@ -1982,6 +1987,7 @@ static int ath10k_pci_chip_reset(struct ath10k *ar)
 
 static int ath10k_pci_hif_power_up(struct ath10k *ar)
 {
+	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
 	int ret;
 
 	ath10k_dbg(ar, ATH10K_DBG_BOOT, "boot hif power up\n");
@@ -1992,6 +1998,12 @@ static int ath10k_pci_hif_power_up(struct ath10k *ar)
 		return ret;
 	}
 
+	/* Workaround: Disable ASPM */
+	pcie_capability_read_word(ar_pci->pdev, PCI_EXP_LNKCTL,
+				  &ar_pci->link_ctl);
+	pcie_capability_write_word(ar_pci->pdev, PCI_EXP_LNKCTL,
+				   ar_pci->link_ctl & ~PCI_EXP_LNKCTL_ASPMC);
+
 	/*
 	 * Bring the target up cleanly.
 	 *
@@ -2515,7 +2527,6 @@ static int ath10k_pci_claim(struct ath10k *ar)
 {
 	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
 	struct pci_dev *pdev = ar_pci->pdev;
-	u32 lcr_val;
 	int ret;
 
 	pci_set_drvdata(pdev, ar);
@@ -2549,10 +2560,6 @@ static int ath10k_pci_claim(struct ath10k *ar)
 
 	pci_set_master(pdev);
 
-	/* Workaround: Disable ASPM */
-	pci_read_config_dword(pdev, 0x80, &lcr_val);
-	pci_write_config_dword(pdev, 0x80, (lcr_val & 0xffffff00));
-
 	/* Arrange for access to Target SoC registers. */
 	ar_pci->mem = pci_iomap(pdev, BAR_NUM, 0);
 	if (!ar_pci->mem) {
diff --git a/drivers/net/wireless/ath/ath10k/pci.h b/drivers/net/wireless/ath/ath10k/pci.h
index 56795ed..a6eafec 100644
--- a/drivers/net/wireless/ath/ath10k/pci.h
+++ b/drivers/net/wireless/ath/ath10k/pci.h
@@ -185,6 +185,9 @@ struct ath10k_pci {
 	/* Map CE id to ce_state */
 	struct ath10k_ce_pipe ce_states[CE_COUNT_MAX];
 	struct timer_list rx_post_retry;
+
+	/* Link Control */
+	u16 link_ctl;
 };
 
 static inline struct ath10k_pci *ath10k_pci_priv(struct ath10k *ar)
-- 
1.9.1

