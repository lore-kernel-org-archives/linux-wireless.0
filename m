Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from phoenix.szarvasnet.hu ([87.101.127.3]:48838 "EHLO
	phoenix.szarvas.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758678AbZACNo4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 3 Jan 2009 08:44:56 -0500
From: Gabor Juhos <juhosg@openwrt.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Jouni Malinen <jmalinen@atheros.com>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Felix Fietkau <nbd@openwrt.org>,
	Gabor Juhos <juhosg@openwrt.org>,
	Imre Kaloz <kaloz@openwrt.org>
Subject: [RFC 04/12] ath9k: introduce bus specific cleanup routine
Date: Sat,  3 Jan 2009 14:44:14 +0100
Message-Id: <1230990262-22923-5-git-send-email-juhosg@openwrt.org> (sfid-20090103_150901_724398_4C435AE2)
In-Reply-To: <1230990262-22923-1-git-send-email-juhosg@openwrt.org>
References: <1230990262-22923-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We have left only some PCI specific cleanup code. We have to convert
them as well.

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
Signed-off-by: Imre Kaloz <kaloz@openwrt.org>
---
 drivers/net/wireless/ath9k/core.h |    7 +++++++
 drivers/net/wireless/ath9k/main.c |   29 +++++++++++++++--------------
 2 files changed, 22 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/ath9k/core.h b/drivers/net/wireless/ath9k/core.h
index 0c8064e..4833598 100644
--- a/drivers/net/wireless/ath9k/core.h
+++ b/drivers/net/wireless/ath9k/core.h
@@ -723,6 +723,8 @@ struct ath_bus_ops {
 	void		(*reg_write)(struct ath_hal *ah, unsigned reg, u32 val);
 
 	void		(*read_cachesize)(struct ath_softc *sc, int *csz);
+
+	void		(*cleanup)(struct ath_softc *sc);
 };
 
 struct ath_softc {
@@ -850,4 +852,9 @@ static inline void ath_read_cachesize(struct ath_softc *sc, int *csz)
 	sc->bus_ops->read_cachesize(sc, csz);
 }
 
+static inline void ath_bus_cleanup(struct ath_softc *sc)
+{
+	sc->bus_ops->cleanup(sc);
+}
+
 #endif /* CORE_H */
diff --git a/drivers/net/wireless/ath9k/main.c b/drivers/net/wireless/ath9k/main.c
index f1da1ac..e126b65 100644
--- a/drivers/net/wireless/ath9k/main.c
+++ b/drivers/net/wireless/ath9k/main.c
@@ -1276,13 +1276,7 @@ static int ath_start_rfkill_poll(struct ath_softc *sc)
 			rfkill_free(sc->rf_kill.rfkill);
 
 			/* Deinitialize the device */
-			ath_detach(sc);
-			if (sc->pdev->irq)
-				free_irq(sc->pdev->irq, sc);
-			pci_iounmap(sc->pdev, sc->mem);
-			pci_release_region(sc->pdev, 0);
-			pci_disable_device(sc->pdev);
-			ieee80211_free_hw(sc->hw);
+			ath_bus_cleanup(sc);
 			return -EIO;
 		} else {
 			sc->sc_flags |= SC_OP_RFKILL_REGISTERED;
@@ -2605,6 +2599,17 @@ static void ath_pci_reg_write(struct ath_hal *ah, unsigned reg, u32 val)
 	iowrite32(val, ah->ah_sh + reg);
 }
 
+static void ath_pci_cleanup(struct ath_softc *sc)
+{
+	ath_detach(sc);
+	if (sc->pdev->irq)
+		free_irq(sc->pdev->irq, sc);
+	pci_iounmap(sc->pdev, sc->mem);
+	pci_release_region(sc->pdev, 0);
+	pci_disable_device(sc->pdev);
+	ieee80211_free_hw(sc->hw);
+}
+
 static struct ath_bus_ops ath_pci_bus_ops  = {
 	.dma_map_single_to_device = ath_pci_map_single_to_device,
 	.dma_unmap_single_to_device = ath_pci_unmap_single_to_device,
@@ -2620,6 +2625,8 @@ static struct ath_bus_ops ath_pci_bus_ops  = {
 	.reg_write = ath_pci_reg_write,
 
 	.read_cachesize = ath_pci_read_cachesize,
+
+	.cleanup = ath_pci_cleanup,
 };
 
 static int ath_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
@@ -2756,13 +2763,7 @@ static void ath_pci_remove(struct pci_dev *pdev)
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

