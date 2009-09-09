Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:12895 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751406AbZIIKES (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Sep 2009 06:04:18 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 09 Sep 2009 03:04:21 -0700
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Luis.Rodriguez@atheros.com>,
	<Jouni.Malinen@atheros.com>, <ath9k-devel@lists.ath9k.org>
Subject: [PATCH 1/4] ath9k: Store subsystem id in struct hw_version
Date: Wed, 9 Sep 2009 15:25:49 +0530
Message-ID: <1252490152-19284-1-git-send-email-vasanth@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This subsystem id will be used later to turn on the btcoex
support.

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ahb.c   |    2 +-
 drivers/net/wireless/ath/ath9k/ath9k.h |    2 +-
 drivers/net/wireless/ath/ath9k/hw.h    |    1 +
 drivers/net/wireless/ath/ath9k/main.c  |    7 ++++---
 drivers/net/wireless/ath/ath9k/pci.c   |    4 +++-
 5 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ahb.c b/drivers/net/wireless/ath/ath9k/ahb.c
index 7dc6301..2ad7d02 100644
--- a/drivers/net/wireless/ath/ath9k/ahb.c
+++ b/drivers/net/wireless/ath/ath9k/ahb.c
@@ -119,7 +119,7 @@ static int ath_ahb_probe(struct platform_device *pdev)
 	sc->bus_ops = &ath_ahb_bus_ops;
 	sc->irq = irq;
 
-	ret = ath_init_device(AR5416_AR9100_DEVID, sc);
+	ret = ath_init_device(AR5416_AR9100_DEVID, sc, 0x0);
 	if (ret) {
 		dev_err(&pdev->dev, "failed to initialize device\n");
 		goto err_free_hw;
diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 1c68a9d..1d59f10 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -658,7 +658,7 @@ extern struct ieee80211_ops ath9k_ops;
 
 irqreturn_t ath_isr(int irq, void *dev);
 void ath_cleanup(struct ath_softc *sc);
-int ath_init_device(u16 devid, struct ath_softc *sc);
+int ath_init_device(u16 devid, struct ath_softc *sc, u16 subsysid);
 void ath_detach(struct ath_softc *sc);
 const char *ath_mac_bb_name(u32 mac_bb_version);
 const char *ath_rf_name(u16 rf_version);
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index a592f1a..64ea547 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -390,6 +390,7 @@ struct ath9k_hw_version {
 	u16 phyRev;
 	u16 analog5GhzRev;
 	u16 analog2GhzRev;
+	u16 subsysid;
 };
 
 /* Generic TSF timer definitions */
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index ce011ab..3dc7b5a 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1310,7 +1310,7 @@ static int ath9k_reg_notifier(struct wiphy *wiphy,
  * to allow the separation between hardware specific
  * variables (now in ath_hw) and driver specific variables.
  */
-static int ath_init_softc(u16 devid, struct ath_softc *sc)
+static int ath_init_softc(u16 devid, struct ath_softc *sc, u16 subsysid)
 {
 	struct ath_hw *ah = NULL;
 	int r = 0, i;
@@ -1348,6 +1348,7 @@ static int ath_init_softc(u16 devid, struct ath_softc *sc)
 
 	ah->ah_sc = sc;
 	ah->hw_version.devid = devid;
+	ah->hw_version.subsysid = subsysid;
 	sc->sc_ah = ah;
 
 	r = ath9k_hw_init(ah);
@@ -1577,7 +1578,7 @@ void ath_set_hw_capab(struct ath_softc *sc, struct ieee80211_hw *hw)
 }
 
 /* Device driver core initialization */
-int ath_init_device(u16 devid, struct ath_softc *sc)
+int ath_init_device(u16 devid, struct ath_softc *sc, u16 subsysid)
 {
 	struct ieee80211_hw *hw = sc->hw;
 	int error = 0, i;
@@ -1585,7 +1586,7 @@ int ath_init_device(u16 devid, struct ath_softc *sc)
 
 	DPRINTF(sc, ATH_DBG_CONFIG, "Attach ATH hw\n");
 
-	error = ath_init_softc(devid, sc);
+	error = ath_init_softc(devid, sc, subsysid);
 	if (error != 0)
 		return error;
 
diff --git a/drivers/net/wireless/ath/ath9k/pci.c b/drivers/net/wireless/ath/ath9k/pci.c
index 8b28814..903dd8a 100644
--- a/drivers/net/wireless/ath/ath9k/pci.c
+++ b/drivers/net/wireless/ath/ath9k/pci.c
@@ -88,6 +88,7 @@ static int ath_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	struct ath_softc *sc;
 	struct ieee80211_hw *hw;
 	u8 csz;
+	u16 subsysid;
 	u32 val;
 	int ret = 0;
 	struct ath_hw *ah;
@@ -178,7 +179,8 @@ static int ath_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	sc->mem = mem;
 	sc->bus_ops = &ath_pci_bus_ops;
 
-	ret = ath_init_device(id->device, sc);
+	pci_read_config_word(pdev, PCI_SUBSYSTEM_ID, &subsysid);
+	ret = ath_init_device(id->device, sc, subsysid);
 	if (ret) {
 		dev_err(&pdev->dev, "failed to initialize device\n");
 		goto bad3;
-- 
1.5.5.1

