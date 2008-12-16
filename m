Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:37455 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751169AbYLPHJf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Dec 2008 02:09:35 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 15 Dec 2008 23:09:35 -0800
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Luis.Rodriguez@atheros.com>,
	<Jouni.Malinen@atheros.com>, <ath9k-devel@lists.ath9k.org>
Subject: [PATCH] ath9k: Move rate control alg register/unregister to appropriate place
Date: Tue, 16 Dec 2008 12:37:38 +0530
Message-ID: <1229411258-4152-1-git-send-email-vasanth@atheros.com> (sfid-20081216_080940_158485_D21F62AC)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch makes sure the rate control alg is registered/unregistered
only once for this module.

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
 drivers/net/wireless/ath9k/main.c |   30 ++++++++++++++----------------
 1 files changed, 14 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/ath9k/main.c b/drivers/net/wireless/ath9k/main.c
index 05416db..2ad36a4 100644
--- a/drivers/net/wireless/ath9k/main.c
+++ b/drivers/net/wireless/ath9k/main.c
@@ -1231,9 +1231,6 @@ static void ath_detach(struct ath_softc *sc)
 	ath_deinit_leds(sc);
 
 	ieee80211_unregister_hw(hw);
-
-	ath_rate_control_unregister();
-
 	ath_rx_cleanup(sc);
 	ath_tx_cleanup(sc);
 
@@ -1518,15 +1515,7 @@ static int ath_attach(u16 devid, struct ath_softc *sc)
 	hw->sta_data_size = sizeof(struct ath_node);
 	hw->vif_data_size = sizeof(struct ath_vap);
 
-	/* Register rate control */
 	hw->rate_control_algorithm = "ath9k_rate_control";
-	error = ath_rate_control_register();
-	if (error != 0) {
-		DPRINTF(sc, ATH_DBG_FATAL,
-			"Unable to register rate control algorithm: %d\n", error);
-		ath_rate_control_unregister();
-		goto bad;
-	}
 
 	if (sc->sc_ah->ah_caps.hw_caps & ATH9K_HW_CAP_HT) {
 		setup_ht_cap(&sc->sbands[IEEE80211_BAND_2GHZ].ht_cap);
@@ -1559,10 +1548,6 @@ static int ath_attach(u16 devid, struct ath_softc *sc)
 #endif
 
 	error = ieee80211_register_hw(hw);
-	if (error != 0) {
-		ath_rate_control_unregister();
-		goto bad;
-	}
 
 	/* Initialize LED control */
 	ath_init_leds(sc);
@@ -1575,7 +1560,6 @@ static int ath_attach(u16 devid, struct ath_softc *sc)
 	return 0;
 detach:
 	ath_detach(sc);
-bad:
 	return error;
 }
 
@@ -2727,11 +2711,24 @@ static struct pci_driver ath_pci_driver = {
 
 static int __init init_ath_pci(void)
 {
+	int error;
+
 	printk(KERN_INFO "%s: %s\n", dev_info, ATH_PCI_VERSION);
 
+	/* Register rate control algorithm */
+	error = ath_rate_control_register();
+	if (error != 0) {
+		printk(KERN_ERR
+			"Unable to register rate control algorithm: %d\n",
+			error);
+		ath_rate_control_unregister();
+		return error;
+	}
+
 	if (pci_register_driver(&ath_pci_driver) < 0) {
 		printk(KERN_ERR
 			"ath_pci: No devices found, driver not installed.\n");
+		ath_rate_control_unregister();
 		pci_unregister_driver(&ath_pci_driver);
 		return -ENODEV;
 	}
@@ -2742,6 +2739,7 @@ module_init(init_ath_pci);
 
 static void __exit exit_ath_pci(void)
 {
+	ath_rate_control_unregister();
 	pci_unregister_driver(&ath_pci_driver);
 	printk(KERN_INFO "%s: Driver unloaded\n", dev_info);
 }
-- 
1.5.5.1

