Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:58224 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751935AbZIKBex (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Sep 2009 21:34:53 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	devel@linuxdriverproject.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 2/4] ath5k: allocate ath5k_hw prior to initializing hw
Date: Thu, 10 Sep 2009 21:34:53 -0400
Message-Id: <1252632895-11914-3-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1252632895-11914-1-git-send-email-lrodriguez@atheros.com>
References: <1252632895-11914-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We can propagate better errors upon failed hw initialization,
and set up the ath_common structure for attach purposes. This
will become important once we start using the ath_common
for read/write ops.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath5k/ath5k.h  |    2 +-
 drivers/net/wireless/ath/ath5k/attach.c |   23 ++++-------------------
 drivers/net/wireless/ath/ath5k/base.c   |   20 ++++++++++++++++----
 3 files changed, 21 insertions(+), 24 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/ath5k.h b/drivers/net/wireless/ath/ath5k/ath5k.h
index fee16fd..29ce868 100644
--- a/drivers/net/wireless/ath/ath5k/ath5k.h
+++ b/drivers/net/wireless/ath/ath5k/ath5k.h
@@ -1147,7 +1147,7 @@ struct ath5k_hw {
  */
 
 /* Attach/Detach Functions */
-extern struct ath5k_hw *ath5k_hw_attach(struct ath5k_softc *sc);
+extern int ath5k_hw_attach(struct ath5k_softc *sc);
 extern void ath5k_hw_detach(struct ath5k_hw *ah);
 
 /* LED functions */
diff --git a/drivers/net/wireless/ath/ath5k/attach.c b/drivers/net/wireless/ath/ath5k/attach.c
index 123612a..c0840ab 100644
--- a/drivers/net/wireless/ath/ath5k/attach.c
+++ b/drivers/net/wireless/ath/ath5k/attach.c
@@ -101,28 +101,15 @@ static int ath5k_hw_post(struct ath5k_hw *ah)
  * -ENODEV if the device is not supported or prints an error msg if something
  * else went wrong.
  */
-struct ath5k_hw *ath5k_hw_attach(struct ath5k_softc *sc)
+int ath5k_hw_attach(struct ath5k_softc *sc)
 {
-	struct ath5k_hw *ah;
+	struct ath5k_hw *ah = sc->ah;
 	struct ath_common *common;
 	struct pci_dev *pdev = sc->pdev;
 	struct ath5k_eeprom_info *ee;
 	int ret;
 	u32 srev;
 
-	/*If we passed the test malloc a ath5k_hw struct*/
-	ah = kzalloc(sizeof(struct ath5k_hw), GFP_KERNEL);
-	if (ah == NULL) {
-		ret = -ENOMEM;
-		ATH5K_ERR(sc, "out of memory\n");
-		goto err;
-	}
-
-	ah->ah_sc = sc;
-	ah->ah_sc->ah = ah;
-	ah->ah_iobase = sc->iobase;
-	common = ath5k_hw_common(ah);
-
 	/*
 	 * HW information
 	 */
@@ -347,11 +334,10 @@ struct ath5k_hw *ath5k_hw_attach(struct ath5k_softc *sc)
 	/* turn on HW LEDs */
 	ath5k_hw_set_ledstate(ah, AR5K_LED_INIT);
 
-	return ah;
+	return 0;
 err_free:
 	kfree(ah);
-err:
-	return ERR_PTR(ret);
+	return ret;
 }
 
 /**
@@ -371,5 +357,4 @@ void ath5k_hw_detach(struct ath5k_hw *ah)
 	ath5k_eeprom_detach(ah);
 
 	/* assume interrupts are down */
-	kfree(ah);
 }
diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index 06fc893..3cb0752 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -565,16 +565,25 @@ ath5k_pci_probe(struct pci_dev *pdev,
 		goto err_free;
 	}
 
-	/* Initialize device */
-	sc->ah = ath5k_hw_attach(sc);
-	if (IS_ERR(sc->ah)) {
-		ret = PTR_ERR(sc->ah);
+	/*If we passed the test malloc a ath5k_hw struct*/
+	sc->ah = kzalloc(sizeof(struct ath5k_hw), GFP_KERNEL);
+	if (!sc->ah) {
+		ret = -ENOMEM;
+		ATH5K_ERR(sc, "out of memory\n");
 		goto err_irq;
 	}
 
+	sc->ah->ah_sc = sc;
+	sc->ah->ah_iobase = sc->iobase;
 	common = ath5k_hw_common(sc->ah);
 	common->cachelsz = csz << 2; /* convert to bytes */
 
+	/* Initialize device */
+	ret = ath5k_hw_attach(sc);
+	if (ret) {
+		goto err_free_ah;
+	}
+
 	/* set up multi-rate retry capabilities */
 	if (sc->ah->ah_version == AR5K_AR5212) {
 		hw->max_rates = 4;
@@ -643,6 +652,8 @@ err_ah:
 	ath5k_hw_detach(sc->ah);
 err_irq:
 	free_irq(pdev->irq, sc);
+err_free_ah:
+	kfree(sc->ah);
 err_free:
 	ieee80211_free_hw(hw);
 err_map:
@@ -664,6 +675,7 @@ ath5k_pci_remove(struct pci_dev *pdev)
 	ath5k_debug_finish_device(sc);
 	ath5k_detach(pdev, hw);
 	ath5k_hw_detach(sc->ah);
+	kfree(sc->ah);
 	free_irq(pdev->irq, sc);
 	pci_iounmap(pdev, sc->iobase);
 	pci_release_region(pdev, 0);
-- 
1.6.3.3

