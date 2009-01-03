Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from phoenix.szarvasnet.hu ([87.101.127.3]:48803 "EHLO
	phoenix.szarvas.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758194AbZACNoy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 3 Jan 2009 08:44:54 -0500
From: Gabor Juhos <juhosg@openwrt.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Jouni Malinen <jmalinen@atheros.com>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Felix Fietkau <nbd@openwrt.org>,
	Gabor Juhos <juhosg@openwrt.org>,
	Imre Kaloz <kaloz@openwrt.org>
Subject: [RFC 06/12] ath9k: convert to struct device
Date: Sat,  3 Jan 2009 14:44:16 +0100
Message-Id: <1230990262-22923-7-git-send-email-juhosg@openwrt.org> (sfid-20090103_144458_982151_24407CFF)
In-Reply-To: <1230990262-22923-1-git-send-email-juhosg@openwrt.org>
References: <1230990262-22923-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Now that we have converted all bus specific routines to replaceable, we
can move the PCI specific codes into a separate file.

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
Signed-off-by: Imre Kaloz <kaloz@openwrt.org>
---
 drivers/net/wireless/ath9k/core.h |    5 +++--
 drivers/net/wireless/ath9k/pci.c  |   35 ++++++++++++++++++++---------------
 2 files changed, 23 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/ath9k/core.h b/drivers/net/wireless/ath9k/core.h
index 73a409b..6889df7 100644
--- a/drivers/net/wireless/ath9k/core.h
+++ b/drivers/net/wireless/ath9k/core.h
@@ -18,7 +18,8 @@
 #define CORE_H
 
 #include <linux/etherdevice.h>
-#include <linux/pci.h>
+#include <linux/device.h>
+#include <linux/types.h>
 #include <net/mac80211.h>
 #include <linux/leds.h>
 #include <linux/rfkill.h>
@@ -729,7 +730,7 @@ struct ath_bus_ops {
 
 struct ath_softc {
 	struct ieee80211_hw *hw;
-	struct pci_dev *pdev;
+	struct device *dev;
 	struct tasklet_struct intr_tq;
 	struct tasklet_struct bcon_tasklet;
 	struct ath_hal *sc_ah;
diff --git a/drivers/net/wireless/ath9k/pci.c b/drivers/net/wireless/ath9k/pci.c
index 1bb4787..314bf9d 100644
--- a/drivers/net/wireless/ath9k/pci.c
+++ b/drivers/net/wireless/ath9k/pci.c
@@ -15,6 +15,8 @@
  */
 
 #include <linux/nl80211.h>
+#include <linux/pci.h>
+
 #include "core.h"
 #include "reg.h"
 #include "hw.h"
@@ -34,7 +36,8 @@ static void ath_pci_read_cachesize(struct ath_softc *sc, int *csz)
 {
 	u8 u8tmp;
 
-	pci_read_config_byte(sc->pdev, PCI_CACHE_LINE_SIZE, (u8 *)&u8tmp);
+	pci_read_config_byte(to_pci_dev(sc->dev), PCI_CACHE_LINE_SIZE,
+			     (u8 *)&u8tmp);
 	*csz = (int)u8tmp;
 
 	/*
@@ -50,49 +53,49 @@ static void ath_pci_read_cachesize(struct ath_softc *sc, int *csz)
 static dma_addr_t ath_pci_map_single_to_device(struct ath_softc *sc,
 					       void *p, size_t size)
 {
-	return pci_map_single(sc->pdev, p, size, PCI_DMA_TODEVICE);
+	return pci_map_single(to_pci_dev(sc->dev), p, size, PCI_DMA_TODEVICE);
 }
 
 static void ath_pci_unmap_single_to_device(struct ath_softc *sc,
 					   dma_addr_t da, size_t size)
 {
-	pci_unmap_single(sc->pdev, da, size, PCI_DMA_TODEVICE);
+	pci_unmap_single(to_pci_dev(sc->dev), da, size, PCI_DMA_TODEVICE);
 }
 
 static dma_addr_t ath_pci_map_single_from_device(struct ath_softc *sc,
 						 void *p, size_t size)
 {
-	return pci_map_single(sc->pdev, p, size, PCI_DMA_FROMDEVICE);
+	return pci_map_single(to_pci_dev(sc->dev), p, size, PCI_DMA_FROMDEVICE);
 }
 
 static void ath_pci_unmap_single_from_device(struct ath_softc *sc,
 					     dma_addr_t da, size_t size)
 {
-	pci_unmap_single(sc->pdev, da, size, PCI_DMA_FROMDEVICE);
+	pci_unmap_single(to_pci_dev(sc->dev), da, size, PCI_DMA_FROMDEVICE);
 }
 
 static int ath_pci_dma_mapping_error(struct ath_softc *sc, dma_addr_t da)
 {
-	return pci_dma_mapping_error(sc->pdev, da);
+	return pci_dma_mapping_error(to_pci_dev(sc->dev), da);
 }
 
 static void ath_pci_sync_single_for_cpu(struct ath_softc *sc, dma_addr_t da,
 				       size_t size)
 {
-	pci_dma_sync_single_for_cpu(sc->pdev, da, size,
+	pci_dma_sync_single_for_cpu(to_pci_dev(sc->dev), da, size,
 				    PCI_DMA_FROMDEVICE);
 }
 
 static void *ath_pci_dma_alloc(struct ath_softc *sc, size_t size,
 				       dma_addr_t *pda)
 {
-	return pci_alloc_consistent(sc->pdev, size, pda);
+	return pci_alloc_consistent(to_pci_dev(sc->dev), size, pda);
 }
 
 static void ath_pci_dma_free(struct ath_softc *sc, size_t size,
 				    void *p, dma_addr_t da)
 {
-	pci_free_consistent(sc->pdev, size, p, da);
+	pci_free_consistent(to_pci_dev(sc->dev), size, p, da);
 }
 
 static u32 ath_pci_reg_read(struct ath_hal *ah, unsigned reg)
@@ -107,12 +110,14 @@ static void ath_pci_reg_write(struct ath_hal *ah, unsigned reg, u32 val)
 
 static void ath_pci_cleanup(struct ath_softc *sc)
 {
+	struct pci_dev *pdev = to_pci_dev(sc->dev);
+
 	ath_detach(sc);
-	if (sc->pdev->irq)
-		free_irq(sc->pdev->irq, sc);
-	pci_iounmap(sc->pdev, sc->mem);
-	pci_release_region(sc->pdev, 0);
-	pci_disable_device(sc->pdev);
+	if (pdev->irq)
+		free_irq(pdev->irq, sc);
+	pci_iounmap(pdev, sc->mem);
+	pci_release_region(pdev, 0);
+	pci_disable_device(pdev);
 	ieee80211_free_hw(sc->hw);
 }
 
@@ -221,7 +226,7 @@ static int ath_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	sc = hw->priv;
 	sc->hw = hw;
-	sc->pdev = pdev;
+	sc->dev = &pdev->dev;
 	sc->mem = mem;
 	sc->bus_ops = &ath_pci_bus_ops;
 
-- 
1.5.3.2

