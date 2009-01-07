Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from phoenix.szarvasnet.hu ([87.101.127.3]:44000 "EHLO
	phoenix.szarvas.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751755AbZAGKLF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Jan 2009 05:11:05 -0500
From: Gabor Juhos <juhosg@openwrt.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Jouni Malinen <jmalinen@atheros.com>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Felix Fietkau <nbd@openwrt.org>,
	Christoph Hellwig <hch@infradead.org>,
	Sujith Manoharan <Sujith.Manoharan@atheros.com>,
	Gabor Juhos <juhosg@openwrt.org>,
	Imre Kaloz <kaloz@openwrt.org>
Subject: [PATCH 04/11] ath9k: introduce bus specific cleanup routine
Date: Wed,  7 Jan 2009 11:09:25 +0100
Message-Id: <1231322972-24094-5-git-send-email-juhosg@openwrt.org> (sfid-20090107_111132_955895_E4ACE8AD)
In-Reply-To: <1231322972-24094-1-git-send-email-juhosg@openwrt.org>
References: <1231322972-24094-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We have left only some PCI specific cleanup code. We have to convert
them as well.

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
Signed-off-by: Imre Kaloz <kaloz@openwrt.org>
---
 drivers/net/wireless/ath9k/core.h |    6 ++++++
 drivers/net/wireless/ath9k/main.c |   30 ++++++++++++++++--------------
 2 files changed, 22 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/ath9k/core.h b/drivers/net/wireless/ath9k/core.h
index 8e93d11..175f026 100644
--- a/drivers/net/wireless/ath9k/core.h
+++ b/drivers/net/wireless/ath9k/core.h
@@ -695,6 +695,7 @@ enum PROT_MODE {
 
 struct ath_bus_ops {
 	void		(*read_cachesize)(struct ath_softc *sc, int *csz);
+	void		(*cleanup)(struct ath_softc *sc);
 };
 
 struct ath_softc {
@@ -760,4 +761,9 @@ static inline void ath_read_cachesize(struct ath_softc *sc, int *csz)
 	sc->bus_ops->read_cachesize(sc, csz);
 }
 
+static inline void ath_bus_cleanup(struct ath_softc *sc)
+{
+	sc->bus_ops->cleanup(sc);
+}
+
 #endif /* CORE_H */
diff --git a/drivers/net/wireless/ath9k/main.c b/drivers/net/wireless/ath9k/main.c
index 15824c1..7917441 100644
--- a/drivers/net/wireless/ath9k/main.c
+++ b/drivers/net/wireless/ath9k/main.c
@@ -1267,13 +1267,7 @@ static int ath_start_rfkill_poll(struct ath_softc *sc)
 			rfkill_free(sc->rf_kill.rfkill);
 
 			/* Deinitialize the device */
-			ath_detach(sc);
-			if (to_pci_dev(sc->dev)->irq)
-				free_irq(to_pci_dev(sc->dev)->irq, sc);
-			pci_iounmap(to_pci_dev(sc->dev), sc->mem);
-			pci_release_region(to_pci_dev(sc->dev), 0);
-			pci_disable_device(to_pci_dev(sc->dev));
-			ieee80211_free_hw(sc->hw);
+			ath_bus_cleanup(sc);
 			return -EIO;
 		} else {
 			sc->sc_flags |= SC_OP_RFKILL_REGISTERED;
@@ -2529,8 +2523,22 @@ ath_rf_name(u16 rf_version)
 	return "????";
 }
 
+static void ath_pci_cleanup(struct ath_softc *sc)
+{
+	struct pci_dev *pdev = to_pci_dev(sc->dev);
+
+	ath_detach(sc);
+	if (pdev->irq)
+		free_irq(pdev->irq, sc);
+	pci_iounmap(pdev, sc->mem);
+	pci_release_region(pdev, 0);
+	pci_disable_device(pdev);
+	ieee80211_free_hw(sc->hw);
+}
+
 static struct ath_bus_ops ath_pci_bus_ops = {
 	.read_cachesize = ath_pci_read_cachesize,
+	.cleanup = ath_pci_cleanup,
 };
 
 static int ath_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
@@ -2667,13 +2675,7 @@ static void ath_pci_remove(struct pci_dev *pdev)
 	struct ieee80211_hw *hw = pci_get_drvdata(pdev);
 	struct ath_softc *sc = hw->priv;
 
-	ath_detach(sc);
-	if (pdev->irq)
-		free_irq(pdev->irq, sc);
-	pci_iounmap(pdev, sc->mem);
-	pci_release_region(pdev, 0);
-	pci_disable_device(pdev);
-	ieee80211_free_hw(hw);
+	ath_pci_cleanup(sc);
 }
 
 #ifdef CONFIG_PM
-- 
1.5.3.2

