Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:15660 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751400Ab0AaChg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 Jan 2010 21:37:36 -0500
Subject: [PATCH] ath9k: fix access to freed data on unload
From: Pavel Roskin <proski@gnu.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain
Date: Sat, 30 Jan 2010 21:37:24 -0500
Message-Id: <1264905444.10146.9.camel@mj>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Calling ath_bus_cleanup() after ieee80211_free_hw() resulted in access
to common->bus_ops, which is already freed as part of the device data.

Remove the cleanup field in struct ath_bus_ops, as it was never used
properly.  Remove ath_bus_cleanup().  Merge cleanup functions in place
of the ath_bus_cleanup() calls.  Take care not to use any device data
after ieee80211_free_hw().

Signed-off-by: Pavel Roskin <proski@gnu.org>
---

The bug was causing a hang on a kernel with most debugging options
enabled.  I think the fix is important and simple enough for stable
kernels.  I wish I could make the patch smaller, but I didn't want to
leave unused and dangerous fields and functions.

ath9k was tested on the PCI bus.  ath9k on AHB was compile tested.
ath5k and ar9170 use struct ath_bus_ops, but don't use the cleanup
field, so they are not affected.

 drivers/net/wireless/ath/ath.h         |    1 -
 drivers/net/wireless/ath/ath9k/ahb.c   |   12 ++----------
 drivers/net/wireless/ath/ath9k/ath9k.h |    5 -----
 drivers/net/wireless/ath/ath9k/pci.c   |   18 +++++-------------
 4 files changed, 7 insertions(+), 29 deletions(-)

diff --git a/drivers/net/wireless/ath/ath.h b/drivers/net/wireless/ath/ath.h
index 9e05648..71fc960 100644
--- a/drivers/net/wireless/ath/ath.h
+++ b/drivers/net/wireless/ath/ath.h
@@ -74,7 +74,6 @@ struct ath_common;
 
 struct ath_bus_ops {
 	void		(*read_cachesize)(struct ath_common *common, int *csz);
-	void		(*cleanup)(struct ath_common *common);
 	bool		(*eeprom_read)(struct ath_common *common, u32 off, u16 *data);
 	void		(*bt_coex_prep)(struct ath_common *common);
 };
diff --git a/drivers/net/wireless/ath/ath9k/ahb.c b/drivers/net/wireless/ath/ath9k/ahb.c
index 9e62a56..ca4994f 100644
--- a/drivers/net/wireless/ath/ath9k/ahb.c
+++ b/drivers/net/wireless/ath/ath9k/ahb.c
@@ -27,12 +27,6 @@ static void ath_ahb_read_cachesize(struct ath_common *common, int *csz)
 	*csz = L1_CACHE_BYTES >> 2;
 }
 
-static void ath_ahb_cleanup(struct ath_common *common)
-{
-	struct ath_softc *sc = (struct ath_softc *)common->priv;
-	iounmap(sc->mem);
-}
-
 static bool ath_ahb_eeprom_read(struct ath_common *common, u32 off, u16 *data)
 {
 	struct ath_softc *sc = (struct ath_softc *)common->priv;
@@ -54,8 +48,6 @@ static bool ath_ahb_eeprom_read(struct ath_common *common, u32 off, u16 *data)
 
 static struct ath_bus_ops ath_ahb_bus_ops  = {
 	.read_cachesize = ath_ahb_read_cachesize,
-	.cleanup = ath_ahb_cleanup,
-
 	.eeprom_read = ath_ahb_eeprom_read,
 };
 
@@ -164,12 +156,12 @@ static int ath_ahb_remove(struct platform_device *pdev)
 	if (hw) {
 		struct ath_wiphy *aphy = hw->priv;
 		struct ath_softc *sc = aphy->sc;
-		struct ath_common *common = ath9k_hw_common(sc->sc_ah);
+		void __iomem *mem = sc->mem;
 
 		ath9k_deinit_device(sc);
 		free_irq(sc->irq, sc);
 		ieee80211_free_hw(sc->hw);
-		ath_bus_cleanup(common);
+		iounmap(mem);
 		platform_set_drvdata(pdev, NULL);
 	}
 
diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 3f8a7e7..0ea340f 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -538,11 +538,6 @@ static inline void ath_read_cachesize(struct ath_common *common, int *csz)
 	common->bus_ops->read_cachesize(common, csz);
 }
 
-static inline void ath_bus_cleanup(struct ath_common *common)
-{
-	common->bus_ops->cleanup(common);
-}
-
 extern struct ieee80211_ops ath9k_ops;
 extern int modparam_nohwcrypt;
 
diff --git a/drivers/net/wireless/ath/ath9k/pci.c b/drivers/net/wireless/ath/ath9k/pci.c
index 4ae7b5f..f2afcbe 100644
--- a/drivers/net/wireless/ath/ath9k/pci.c
+++ b/drivers/net/wireless/ath/ath9k/pci.c
@@ -49,16 +49,6 @@ static void ath_pci_read_cachesize(struct ath_common *common, int *csz)
 		*csz = DEFAULT_CACHELINE >> 2;   /* Use the default size */
 }
 
-static void ath_pci_cleanup(struct ath_common *common)
-{
-	struct ath_softc *sc = (struct ath_softc *) common->priv;
-	struct pci_dev *pdev = to_pci_dev(sc->dev);
-
-	pci_iounmap(pdev, sc->mem);
-	pci_disable_device(pdev);
-	pci_release_region(pdev, 0);
-}
-
 static bool ath_pci_eeprom_read(struct ath_common *common, u32 off, u16 *data)
 {
 	struct ath_hw *ah = (struct ath_hw *) common->ah;
@@ -98,7 +88,6 @@ static void ath_pci_bt_coex_prep(struct ath_common *common)
 
 static const struct ath_bus_ops ath_pci_bus_ops = {
 	.read_cachesize = ath_pci_read_cachesize,
-	.cleanup = ath_pci_cleanup,
 	.eeprom_read = ath_pci_eeprom_read,
 	.bt_coex_prep = ath_pci_bt_coex_prep,
 };
@@ -245,12 +234,15 @@ static void ath_pci_remove(struct pci_dev *pdev)
 	struct ieee80211_hw *hw = pci_get_drvdata(pdev);
 	struct ath_wiphy *aphy = hw->priv;
 	struct ath_softc *sc = aphy->sc;
-	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
+	void __iomem *mem = sc->mem;
 
 	ath9k_deinit_device(sc);
 	free_irq(sc->irq, sc);
 	ieee80211_free_hw(sc->hw);
-	ath_bus_cleanup(common);
+
+	pci_iounmap(pdev, mem);
+	pci_disable_device(pdev);
+	pci_release_region(pdev, 0);
 }
 
 #ifdef CONFIG_PM

-- 
Regards,
Pavel Roskin
