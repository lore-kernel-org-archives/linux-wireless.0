Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:12169 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756099AbYGRQ5B (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Jul 2008 12:57:01 -0400
Subject: [PATCH v2] ath5k: don't enable MSI, we cannot handle it yet
From: Pavel Roskin <proski@gnu.org>
To: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, Nick Kossifidis <mickflemm@gmail.com>
In-Reply-To: <200807181849.25320.mb@bu3sch.de>
References: <20080718162855.22182.97573.stgit@dv.roinet.com>
	 <1216399487.18320.16.camel@dv>  <200807181849.25320.mb@bu3sch.de>
Content-Type: text/plain
Date: Fri, 18 Jul 2008 12:56:59 -0400
Message-Id: <1216400219.18320.26.camel@dv> (sfid-20080718_185705_905493_2716CC5F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

MSI is a nice thing, but we cannot enable it without changing the
interrupt handler.  If we do it, we break MSI capable hardware,
specifically AR5006 chipset.

Signed-off-by: Pavel Roskin <proski@gnu.org>
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


-- 
Regards,
Pavel Roskin
