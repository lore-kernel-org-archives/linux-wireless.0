Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:55339 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754276AbYGRQ25 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Jul 2008 12:28:57 -0400
From: Pavel Roskin <proski@gnu.org>
Subject: [PATCH] ath5k: don't enable MSI, we cannot handle it yet
To: stable@kernel.org
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, mickflemm@gmail.com
Date: Fri, 18 Jul 2008 12:28:55 -0400
Message-ID: <20080718162855.22182.97573.stgit@dv.roinet.com> (sfid-20080718_182900_763009_0756BDC4)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This fixes support for AR5006 chipset, which supports MSI
---

 drivers/net/wireless/ath5k/base.c |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath5k/base.c b/drivers/net/wireless/ath5k/base.c
index 635b9ac..e57905c 100644
--- a/drivers/net/wireless/ath5k/base.c
+++ b/drivers/net/wireless/ath5k/base.c
@@ -487,9 +487,6 @@ ath5k_pci_probe(struct pci_dev *pdev,
 	/* Set private data */
 	pci_set_drvdata(pdev, hw);
 
-	/* Enable msi for devices that support it */
-	pci_enable_msi(pdev);
-
 	/* Setup interrupt handler */
 	ret = request_irq(pdev->irq, ath5k_intr, IRQF_SHARED, "ath", sc);
 	if (ret) {
@@ -567,7 +564,6 @@ err_ah:
 err_irq:
 	free_irq(pdev->irq, sc);
 err_free:
-	pci_disable_msi(pdev);
 	ieee80211_free_hw(hw);
 err_map:
 	pci_iounmap(pdev, mem);
@@ -589,7 +585,6 @@ ath5k_pci_remove(struct pci_dev *pdev)
 	ath5k_detach(pdev, hw);
 	ath5k_hw_detach(sc->ah);
 	free_irq(pdev->irq, sc);
-	pci_disable_msi(pdev);
 	pci_iounmap(pdev, sc->iobase);
 	pci_release_region(pdev, 0);
 	pci_disable_device(pdev);
