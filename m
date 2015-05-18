Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f42.google.com ([74.125.82.42]:33021 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751207AbbERJid (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 May 2015 05:38:33 -0400
Received: by wgjc11 with SMTP id c11so19497479wgj.0
        for <linux-wireless@vger.kernel.org>; Mon, 18 May 2015 02:38:32 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v2 1/3] ath10k: enable ASPM
Date: Mon, 18 May 2015 09:38:16 +0000
Message-Id: <1431941898-13591-2-git-send-email-michal.kazior@tieto.com> (sfid-20150518_113839_331352_56DD07D2)
In-Reply-To: <1431941898-13591-1-git-send-email-michal.kazior@tieto.com>
References: <1431076388-24800-1-git-send-email-michal.kazior@tieto.com>
 <1431941898-13591-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Janusz Dziedzic <janusz.dziedzic@tieto.com>

It is actually safe to enable ASPM after the
device is booted up.

This reduces power drain of QCA61X4 when driver is
simply loaded (no interface is up) from 31mA to
14mA. QCA988X wasn't measured but doesn't seem to
regress in any other way.

Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/pci.c | 15 ++++++++++-----
 drivers/net/wireless/ath/ath10k/pci.h |  6 ++++++
 2 files changed, 16 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index 969a1231800e..8be07c653b2d 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -1227,11 +1227,15 @@ static void ath10k_pci_irq_enable(struct ath10k *ar)
 
 static int ath10k_pci_hif_start(struct ath10k *ar)
 {
+	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
 	ath10k_dbg(ar, ATH10K_DBG_BOOT, "boot hif start\n");
 
 	ath10k_pci_irq_enable(ar);
 	ath10k_pci_rx_post(ar);
 
+	pcie_capability_write_word(ar_pci->pdev, PCI_EXP_LNKCTL,
+				   ar_pci->link_ctl);
+
 	return 0;
 }
 
@@ -1981,6 +1985,7 @@ static int ath10k_pci_chip_reset(struct ath10k *ar)
 
 static int ath10k_pci_hif_power_up(struct ath10k *ar)
 {
+	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
 	int ret;
 
 	ath10k_dbg(ar, ATH10K_DBG_BOOT, "boot hif power up\n");
@@ -1991,6 +1996,11 @@ static int ath10k_pci_hif_power_up(struct ath10k *ar)
 		return ret;
 	}
 
+	pcie_capability_read_word(ar_pci->pdev, PCI_EXP_LNKCTL,
+				  &ar_pci->link_ctl);
+	pcie_capability_write_word(ar_pci->pdev, PCI_EXP_LNKCTL,
+				   ar_pci->link_ctl & ~PCI_EXP_LNKCTL_ASPMC);
+
 	/*
 	 * Bring the target up cleanly.
 	 *
@@ -2502,7 +2512,6 @@ static int ath10k_pci_claim(struct ath10k *ar)
 {
 	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
 	struct pci_dev *pdev = ar_pci->pdev;
-	u32 lcr_val;
 	int ret;
 
 	pci_set_drvdata(pdev, ar);
@@ -2536,10 +2545,6 @@ static int ath10k_pci_claim(struct ath10k *ar)
 
 	pci_set_master(pdev);
 
-	/* Workaround: Disable ASPM */
-	pci_read_config_dword(pdev, 0x80, &lcr_val);
-	pci_write_config_dword(pdev, 0x80, (lcr_val & 0xffffff00));
-
 	/* Arrange for access to Target SoC registers. */
 	ar_pci->mem = pci_iomap(pdev, BAR_NUM, 0);
 	if (!ar_pci->mem) {
diff --git a/drivers/net/wireless/ath/ath10k/pci.h b/drivers/net/wireless/ath/ath10k/pci.h
index bddf54320160..ee2173d61257 100644
--- a/drivers/net/wireless/ath/ath10k/pci.h
+++ b/drivers/net/wireless/ath/ath10k/pci.h
@@ -185,6 +185,12 @@ struct ath10k_pci {
 	/* Map CE id to ce_state */
 	struct ath10k_ce_pipe ce_states[CE_COUNT_MAX];
 	struct timer_list rx_post_retry;
+
+	/* Due to HW quirks it is recommended to disable ASPM during device
+	 * bootup. To do that the original PCI-E Link Control is stored before
+	 * device bootup is executed and re-programmed later.
+	 */
+	u16 link_ctl;
 };
 
 static inline struct ath10k_pci *ath10k_pci_priv(struct ath10k *ar)
-- 
2.1.4

