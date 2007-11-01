Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.251]:4755 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753495AbXKATW7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Nov 2007 15:22:59 -0400
Received: by an-out-0708.google.com with SMTP id b36so88488ana
        for <linux-wireless@vger.kernel.org>; Thu, 01 Nov 2007 12:22:58 -0700 (PDT)
Date: Thu, 1 Nov 2007 15:22:51 -0400
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Jeff Garzik <jeff@garzik.org>,
	Jiri Slaby <jirislaby@gmail.com>,
	Nick Kossifidis <mickflemm@gmail.com>
Subject: [PATCH] RFC: move ath5k to use pci_request_selected_regions()
Message-ID: <20071101192251.GB3201@pogo> (sfid-20071101_192302_489363_FB17052F)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Documentation/pci.txt states:

"If your PCI device driver doesn't need I/O port resources assigned to
I/O Port BARs, you should use pci_enable_device_bars() instead of
pci_enable_device() in order not to enable I/O port regions for the
corresponding devices. In addition, you should use
pci_request_selected_regions() and pci_release_selected_regions()
instead of pci_request_regions()/pci_release_regions() in order not to
request/release I/O port regions for the corresponding devices."

So shall we? This also re-arranges the pci_release_selected_regions()
as per the documenation.

Changes to base.c
Changes-licensed-under: 3-clause-BSD

Signed-off-by: Luis R. Rodriguez <mcgrof@gmail.com>
---

diff --git a/drivers/net/wireless/ath5k/base.c b/drivers/net/wireless/ath5k/base.c
index 15ae868..a87a47f 100644
--- a/drivers/net/wireless/ath5k/base.c
+++ b/drivers/net/wireless/ath5k/base.c
@@ -445,11 +445,14 @@ ath5k_pci_probe(struct pci_dev *pdev,
 		const struct pci_device_id *id)
 {
 	void __iomem *mem;
-	struct ath5k_softc *sc;
+	struct ath5k_softc *sc = NULL;
 	struct ieee80211_hw *hw;
 	int ret;
+	int bars;
 	u8 csz;
 
+	bars = pci_select_bars(pdev, IORESOURCE_MEM);
+
 	ret = pci_enable_device(pdev);
 	if (ret) {
 		dev_err(&pdev->dev, "can't enable device\n");
@@ -495,7 +498,7 @@ ath5k_pci_probe(struct pci_dev *pdev,
 	 */
 	pci_write_config_byte(pdev, 0x41, 0);
 
-	ret = pci_request_region(pdev, 0, "ath5k");
+	ret = pci_request_selected_regions(pdev, bars, "ath5k");
 	if (ret) {
 		dev_err(&pdev->dev, "cannot reserve PCI memory region\n");
 		goto err_dis;
@@ -528,6 +531,7 @@ ath5k_pci_probe(struct pci_dev *pdev,
 	sc = hw->priv;
 	sc->hw = hw;
 	sc->pdev = pdev;
+	sc->bars = bars;
 
 	/*
 	 * Mark the device as detached to avoid processing
@@ -602,10 +606,10 @@ err_free:
 	ieee80211_free_hw(hw);
 err_map:
 	pci_iounmap(pdev, mem);
-err_reg:
-	pci_release_region(pdev, 0);
 err_dis:
 	pci_disable_device(pdev);
+err_reg:
+	pci_release_selected_regions(pdev, sc->bars);
 err:
 	return ret;
 }
@@ -621,8 +625,8 @@ ath5k_pci_remove(struct pci_dev *pdev)
 	free_irq(pdev->irq, sc);
 	pci_disable_msi(pdev);
 	pci_iounmap(pdev, sc->iobase);
-	pci_release_region(pdev, 0);
 	pci_disable_device(pdev);
+	pci_release_selected_regions(pdev, sc->bars);
 	ieee80211_free_hw(hw);
 }
 
diff --git a/drivers/net/wireless/ath5k/base.h b/drivers/net/wireless/ath5k/base.h
index c13e54b..913d0ab 100644
--- a/drivers/net/wireless/ath5k/base.h
+++ b/drivers/net/wireless/ath5k/base.h
@@ -89,6 +89,7 @@ struct ath5k_txq {
  * associated with an instance of a device */
 struct ath5k_softc {
 	struct pci_dev		*pdev;		/* for dma mapping */
+	int			bars;
 	void __iomem		*iobase;	/* address of the device */
 	struct mutex		lock;		/* dev-level lock */
 	struct ieee80211_tx_queue_stats tx_stats;
