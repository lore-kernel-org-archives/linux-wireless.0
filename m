Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from phoenix.szarvasnet.hu ([87.101.127.3]:39988 "EHLO
	phoenix.szarvas.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753276AbZAIMZv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Jan 2009 07:25:51 -0500
From: Gabor Juhos <juhosg@openwrt.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Jouni Malinen <jmalinen@atheros.com>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Felix Fietkau <nbd@openwrt.org>,
	Christoph Hellwig <hch@infradead.org>,
	Sujith Manoharan <Sujith.Manoharan@atheros.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Gabor Juhos <juhosg@openwrt.org>,
	Imre Kaloz <kaloz@openwrt.org>
Subject: [PATCH v2 04/11] ath9k: introduce bus specific cleanup routine
Date: Fri,  9 Jan 2009 13:24:21 +0100
Message-Id: <1231503868-29226-5-git-send-email-juhosg@openwrt.org> (sfid-20090109_132603_578544_822E1198)
In-Reply-To: <1231503868-29226-1-git-send-email-juhosg@openwrt.org>
References: <1231503868-29226-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We have left only some PCI specific cleanup code. We have to convert
them as well.

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
Signed-off-by: Imre Kaloz <kaloz@openwrt.org>
---
 drivers/net/wireless/ath9k/core.h |    7 +++++++
 drivers/net/wireless/ath9k/main.c |   37 +++++++++++++++++++++++--------------
 2 files changed, 30 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/ath9k/core.h b/drivers/net/wireless/ath9k/core.h
index 8e93d11..f9fa5c6 100644
--- a/drivers/net/wireless/ath9k/core.h
+++ b/drivers/net/wireless/ath9k/core.h
@@ -695,6 +695,7 @@ enum PROT_MODE {
 
 struct ath_bus_ops {
 	void		(*read_cachesize)(struct ath_softc *sc, int *csz);
+	void		(*cleanup)(struct ath_softc *sc);
 };
 
 struct ath_softc {
@@ -704,6 +705,7 @@ struct ath_softc {
 	struct tasklet_struct bcon_tasklet;
 	struct ath_hal *sc_ah;
 	void __iomem *mem;
+	int irq;
 	spinlock_t sc_resetlock;
 	struct mutex mutex;
 
@@ -760,4 +762,9 @@ static inline void ath_read_cachesize(struct ath_softc *sc, int *csz)
 	sc->bus_ops->read_cachesize(sc, csz);
 }
 
+static inline void ath_bus_cleanup(struct ath_softc *sc)
+{
+	sc->bus_ops->cleanup(sc);
+}
+
 #endif /* CORE_H */
diff --git a/drivers/net/wireless/ath9k/main.c b/drivers/net/wireless/ath9k/main.c
index 15824c1..7727825 100644
--- a/drivers/net/wireless/ath9k/main.c
+++ b/drivers/net/wireless/ath9k/main.c
@@ -39,6 +39,7 @@ static struct pci_device_id ath_pci_id_table[] __devinitdata = {
 };
 
 static void ath_detach(struct ath_softc *sc);
+static void ath_cleanup(struct ath_softc *sc);
 
 /* return bus cachesize in 4B word units */
 
@@ -1267,13 +1268,7 @@ static int ath_start_rfkill_poll(struct ath_softc *sc)
 			rfkill_free(sc->rf_kill.rfkill);
 
 			/* Deinitialize the device */
-			ath_detach(sc);
-			if (to_pci_dev(sc->dev)->irq)
-				free_irq(to_pci_dev(sc->dev)->irq, sc);
-			pci_iounmap(to_pci_dev(sc->dev), sc->mem);
-			pci_release_region(to_pci_dev(sc->dev), 0);
-			pci_disable_device(to_pci_dev(sc->dev));
-			ieee80211_free_hw(sc->hw);
+			ath_cleanup(sc);
 			return -EIO;
 		} else {
 			sc->sc_flags |= SC_OP_RFKILL_REGISTERED;
@@ -1284,6 +1279,14 @@ static int ath_start_rfkill_poll(struct ath_softc *sc)
 }
 #endif /* CONFIG_RFKILL */
 
+static void ath_cleanup(struct ath_softc *sc)
+{
+	ath_detach(sc);
+	free_irq(sc->irq, sc);
+	ath_bus_cleanup(sc);
+	ieee80211_free_hw(sc->hw);
+}
+
 static void ath_detach(struct ath_softc *sc)
 {
 	struct ieee80211_hw *hw = sc->hw;
@@ -2529,8 +2532,18 @@ ath_rf_name(u16 rf_version)
 	return "????";
 }
 
+static void ath_pci_cleanup(struct ath_softc *sc)
+{
+	struct pci_dev *pdev = to_pci_dev(sc->dev);
+
+	pci_iounmap(pdev, sc->mem);
+	pci_release_region(pdev, 0);
+	pci_disable_device(pdev);
+}
+
 static struct ath_bus_ops ath_pci_bus_ops = {
 	.read_cachesize = ath_pci_read_cachesize,
+	.cleanup = ath_pci_cleanup,
 };
 
 static int ath_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
@@ -2637,6 +2650,8 @@ static int ath_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		goto bad4;
 	}
 
+	sc->irq = pdev->irq;
+
 	ah = sc->sc_ah;
 	printk(KERN_INFO
 	       "%s: Atheros AR%s MAC/BB Rev:%x "
@@ -2667,13 +2682,7 @@ static void ath_pci_remove(struct pci_dev *pdev)
 	struct ieee80211_hw *hw = pci_get_drvdata(pdev);
 	struct ath_softc *sc = hw->priv;
 
-	ath_detach(sc);
-	if (pdev->irq)
-		free_irq(pdev->irq, sc);
-	pci_iounmap(pdev, sc->mem);
-	pci_release_region(pdev, 0);
-	pci_disable_device(pdev);
-	ieee80211_free_hw(hw);
+	ath_cleanup(sc);
 }
 
 #ifdef CONFIG_PM
-- 
1.5.3.2

