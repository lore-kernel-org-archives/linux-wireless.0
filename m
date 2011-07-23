Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:49997 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751052Ab1GWHzm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Jul 2011 03:55:42 -0400
Subject: [PATCH] ath9k: remove all references to subsysid, it's never used
To: ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
From: Pavel Roskin <proski@gnu.org>
Date: Sat, 23 Jul 2011 03:55:39 -0400
Message-ID: <20110723075539.29166.82607.stgit@mj.roinet.com> (sfid-20110723_095544_837226_B2805DC8)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Pavel Roskin <proski@gnu.org>
---
 drivers/net/wireless/ath/ath9k/ahb.c          |    2 +-
 drivers/net/wireless/ath/ath9k/ath9k.h        |    2 +-
 drivers/net/wireless/ath/ath9k/htc_drv_init.c |    1 -
 drivers/net/wireless/ath/ath9k/hw.h           |    1 -
 drivers/net/wireless/ath/ath9k/init.c         |    7 +++----
 drivers/net/wireless/ath/ath9k/pci.c          |    4 +---
 6 files changed, 6 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ahb.c b/drivers/net/wireless/ath/ath9k/ahb.c
index 0b36fcf..85a54cd 100644
--- a/drivers/net/wireless/ath/ath9k/ahb.c
+++ b/drivers/net/wireless/ath/ath9k/ahb.c
@@ -133,7 +133,7 @@ static int ath_ahb_probe(struct platform_device *pdev)
 		goto err_free_hw;
 	}
 
-	ret = ath9k_init_device(id->driver_data, sc, 0x0, &ath_ahb_bus_ops);
+	ret = ath9k_init_device(id->driver_data, sc, &ath_ahb_bus_ops);
 	if (ret) {
 		dev_err(&pdev->dev, "failed to initialize device\n");
 		goto err_irq;
diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 964fb97..89dad92 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -668,7 +668,7 @@ extern bool is_ath9k_unloaded;
 
 irqreturn_t ath_isr(int irq, void *dev);
 void ath9k_init_crypto(struct ath_softc *sc);
-int ath9k_init_device(u16 devid, struct ath_softc *sc, u16 subsysid,
+int ath9k_init_device(u16 devid, struct ath_softc *sc,
 		    const struct ath_bus_ops *bus_ops);
 void ath9k_deinit_device(struct ath_softc *sc);
 void ath9k_set_hw_capab(struct ath_softc *sc, struct ieee80211_hw *hw);
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_init.c b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
index 3bea7ea..19aa5b7 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_init.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
@@ -666,7 +666,6 @@ static int ath9k_init_priv(struct ath9k_htc_priv *priv,
 		return -ENOMEM;
 
 	ah->hw_version.devid = devid;
-	ah->hw_version.subsysid = 0; /* FIXME */
 	ah->hw_version.usbdev = drv_info;
 	ah->ah_flags |= AH_USE_EEPROM;
 	ah->reg_ops.read = ath9k_regread;
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 6acd0f97..1967ceb 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -439,7 +439,6 @@ struct ath9k_hw_version {
 	u16 phyRev;
 	u16 analog5GhzRev;
 	u16 analog2GhzRev;
-	u16 subsysid;
 	enum ath_usb_dev usbdev;
 };
 
diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index dceaa4a..86af958 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -547,7 +547,7 @@ static void ath9k_init_misc(struct ath_softc *sc)
 		sc->ant_comb.count = ATH_ANT_DIV_COMB_INIT_COUNT;
 }
 
-static int ath9k_init_softc(u16 devid, struct ath_softc *sc, u16 subsysid,
+static int ath9k_init_softc(u16 devid, struct ath_softc *sc,
 			    const struct ath_bus_ops *bus_ops)
 {
 	struct ath9k_platform_data *pdata = sc->dev->platform_data;
@@ -562,7 +562,6 @@ static int ath9k_init_softc(u16 devid, struct ath_softc *sc, u16 subsysid,
 
 	ah->hw = sc->hw;
 	ah->hw_version.devid = devid;
-	ah->hw_version.subsysid = subsysid;
 	ah->reg_ops.read = ath9k_ioread32;
 	ah->reg_ops.write = ath9k_iowrite32;
 	ah->reg_ops.rmw = ath9k_reg_rmw;
@@ -740,7 +739,7 @@ void ath9k_set_hw_capab(struct ath_softc *sc, struct ieee80211_hw *hw)
 	SET_IEEE80211_PERM_ADDR(hw, common->macaddr);
 }
 
-int ath9k_init_device(u16 devid, struct ath_softc *sc, u16 subsysid,
+int ath9k_init_device(u16 devid, struct ath_softc *sc,
 		    const struct ath_bus_ops *bus_ops)
 {
 	struct ieee80211_hw *hw = sc->hw;
@@ -750,7 +749,7 @@ int ath9k_init_device(u16 devid, struct ath_softc *sc, u16 subsysid,
 	struct ath_regulatory *reg;
 
 	/* Bring up device */
-	error = ath9k_init_softc(devid, sc, subsysid, bus_ops);
+	error = ath9k_init_softc(devid, sc, bus_ops);
 	if (error != 0)
 		goto error_init;
 
diff --git a/drivers/net/wireless/ath/ath9k/pci.c b/drivers/net/wireless/ath/ath9k/pci.c
index 3bad0b2..4d803b0 100644
--- a/drivers/net/wireless/ath/ath9k/pci.c
+++ b/drivers/net/wireless/ath/ath9k/pci.c
@@ -129,7 +129,6 @@ static int ath_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	struct ath_softc *sc;
 	struct ieee80211_hw *hw;
 	u8 csz;
-	u16 subsysid;
 	u32 val;
 	int ret = 0;
 	char hw_name[64];
@@ -223,8 +222,7 @@ static int ath_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	sc->irq = pdev->irq;
 
-	pci_read_config_word(pdev, PCI_SUBSYSTEM_ID, &subsysid);
-	ret = ath9k_init_device(id->device, sc, subsysid, &ath_pci_bus_ops);
+	ret = ath9k_init_device(id->device, sc, &ath_pci_bus_ops);
 	if (ret) {
 		dev_err(&pdev->dev, "Failed to initialize device\n");
 		goto err_init;
