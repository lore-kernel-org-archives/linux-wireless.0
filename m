Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:34806 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754679AbZHCTZQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Aug 2009 15:25:16 -0400
Received: from mail.atheros.com ([10.10.20.104])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 03 Aug 2009 12:25:17 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 15/24] ath9k: distinguish between device initialization and ath_softc init
Date: Mon, 3 Aug 2009 12:24:47 -0700
Message-ID: <1249327496-24629-16-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1249327496-24629-1-git-send-email-lrodriguez@atheros.com>
References: <1249327496-24629-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We re-label the device driver initialization routines from the
ath_softc, the "Software Carrier" fillers. This should make it
clearer what each of these do.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ahb.c   |    2 +-
 drivers/net/wireless/ath/ath9k/ath9k.h |    2 +-
 drivers/net/wireless/ath/ath9k/main.c  |   13 ++++++++++---
 drivers/net/wireless/ath/ath9k/pci.c   |    2 +-
 4 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ahb.c b/drivers/net/wireless/ath/ath9k/ahb.c
index 0e65c51..5618fc2 100644
--- a/drivers/net/wireless/ath/ath9k/ahb.c
+++ b/drivers/net/wireless/ath/ath9k/ahb.c
@@ -119,7 +119,7 @@ static int ath_ahb_probe(struct platform_device *pdev)
 	sc->bus_ops = &ath_ahb_bus_ops;
 	sc->irq = irq;
 
-	ret = ath_attach(AR5416_AR9100_DEVID, sc);
+	ret = ath_init_device(AR5416_AR9100_DEVID, sc);
 	if (ret != 0) {
 		dev_err(&pdev->dev, "failed to attach device, err=%d\n", ret);
 		ret = -ENODEV;
diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index bda0f30..7a5a157 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -642,7 +642,7 @@ extern struct ieee80211_ops ath9k_ops;
 
 irqreturn_t ath_isr(int irq, void *dev);
 void ath_cleanup(struct ath_softc *sc);
-int ath_attach(u16 devid, struct ath_softc *sc);
+int ath_init_device(u16 devid, struct ath_softc *sc);
 void ath_detach(struct ath_softc *sc);
 const char *ath_mac_bb_name(u32 mac_bb_version);
 const char *ath_rf_name(u16 rf_version);
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 751d803..91bffc9 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1292,7 +1292,13 @@ static int ath9k_reg_notifier(struct wiphy *wiphy,
 	return ath_reg_notifier_apply(wiphy, request, reg);
 }
 
-static int ath_init(u16 devid, struct ath_softc *sc)
+/*
+ * Initialize and fill ath_softc, ath_sofct is the
+ * "Software Carrier" struct. Historically it has existed
+ * to allow the separation between hardware specific
+ * variables (now in ath_hw) and driver specific variables.
+ */
+static int ath_init_softc(u16 devid, struct ath_softc *sc)
 {
 	struct ath_hw *ah = NULL;
 	int r = 0, i;
@@ -1558,7 +1564,8 @@ void ath_set_hw_capab(struct ath_softc *sc, struct ieee80211_hw *hw)
 			&sc->sbands[IEEE80211_BAND_5GHZ];
 }
 
-int ath_attach(u16 devid, struct ath_softc *sc)
+/* Device driver core initialization */
+int ath_init_device(u16 devid, struct ath_softc *sc)
 {
 	struct ieee80211_hw *hw = sc->hw;
 	int error = 0, i;
@@ -1566,7 +1573,7 @@ int ath_attach(u16 devid, struct ath_softc *sc)
 
 	DPRINTF(sc, ATH_DBG_CONFIG, "Attach ATH hw\n");
 
-	error = ath_init(devid, sc);
+	error = ath_init_softc(devid, sc);
 	if (error != 0)
 		return error;
 
diff --git a/drivers/net/wireless/ath/ath9k/pci.c b/drivers/net/wireless/ath/ath9k/pci.c
index cd4841b..3546504 100644
--- a/drivers/net/wireless/ath/ath9k/pci.c
+++ b/drivers/net/wireless/ath/ath9k/pci.c
@@ -178,7 +178,7 @@ static int ath_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	sc->mem = mem;
 	sc->bus_ops = &ath_pci_bus_ops;
 
-	if (ath_attach(id->device, sc) != 0) {
+	if (ath_init_device(id->device, sc) != 0) {
 		ret = -ENODEV;
 		goto bad3;
 	}
-- 
1.6.3.3

