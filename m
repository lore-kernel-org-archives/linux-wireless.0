Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30g.wh2.ocn.ne.jp ([220.111.41.239]:47635 "HELO
	mail30g.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756642Ab0ESBcj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 May 2010 21:32:39 -0400
Received: from vs3006.wh2.ocn.ne.jp (125.206.180.169)
	by mail30g.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 2-092112758
	for <linux-wireless@vger.kernel.org>; Wed, 19 May 2010 10:32:38 +0900 (JST)
Subject: [PATCH v2 09/20] ath5k: use ath5k_softc as driver data
To: linville@tuxdriver.com
From: Bruno Randolf <br1@einfach.org>
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Date: Wed, 19 May 2010 10:31:26 +0900
Message-ID: <20100519013126.22206.12588.stgit@tt-desk>
In-Reply-To: <20100519012528.22206.77550.stgit@tt-desk>
References: <20100519012528.22206.77550.stgit@tt-desk>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It's our "private driver data"... It's used more often and hw is the mac80211
part. This makes more sense with the next (sysfs) patch.

Signed-off-by: Bruno Randolf <br1@einfach.org>
---
 drivers/net/wireless/ath/ath5k/base.c |   15 ++++++---------
 1 files changed, 6 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index 496e2db..3b43b76 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -578,7 +578,7 @@ ath5k_pci_probe(struct pci_dev *pdev,
 	spin_lock_init(&sc->block);
 
 	/* Set private data */
-	pci_set_drvdata(pdev, hw);
+	pci_set_drvdata(pdev, sc);
 
 	/* Setup interrupt handler */
 	ret = request_irq(pdev->irq, ath5k_intr, IRQF_SHARED, "ath", sc);
@@ -694,25 +694,23 @@ err:
 static void __devexit
 ath5k_pci_remove(struct pci_dev *pdev)
 {
-	struct ieee80211_hw *hw = pci_get_drvdata(pdev);
-	struct ath5k_softc *sc = hw->priv;
+	struct ath5k_softc *sc = pci_get_drvdata(pdev);
 
 	ath5k_debug_finish_device(sc);
-	ath5k_detach(pdev, hw);
+	ath5k_detach(pdev, sc->hw);
 	ath5k_hw_detach(sc->ah);
 	kfree(sc->ah);
 	free_irq(pdev->irq, sc);
 	pci_iounmap(pdev, sc->iobase);
 	pci_release_region(pdev, 0);
 	pci_disable_device(pdev);
-	ieee80211_free_hw(hw);
+	ieee80211_free_hw(sc->hw);
 }
 
 #ifdef CONFIG_PM
 static int ath5k_pci_suspend(struct device *dev)
 {
-	struct ieee80211_hw *hw = pci_get_drvdata(to_pci_dev(dev));
-	struct ath5k_softc *sc = hw->priv;
+	struct ath5k_softc *sc = pci_get_drvdata(to_pci_dev(dev));
 
 	ath5k_led_off(sc);
 	return 0;
@@ -721,8 +719,7 @@ static int ath5k_pci_suspend(struct device *dev)
 static int ath5k_pci_resume(struct device *dev)
 {
 	struct pci_dev *pdev = to_pci_dev(dev);
-	struct ieee80211_hw *hw = pci_get_drvdata(pdev);
-	struct ath5k_softc *sc = hw->priv;
+	struct ath5k_softc *sc = pci_get_drvdata(pdev);
 
 	/*
 	 * Suspend/Resume resets the PCI configuration space, so we have to

