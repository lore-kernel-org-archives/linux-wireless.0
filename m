Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([70.167.247.36]:3581 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751144AbZCHFnG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Mar 2009 00:43:06 -0500
From: Bob Copeland <me@bobcopeland.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org,
	jirislaby@gmail.com, mickflemm@gmail.com, lrodriguez@atheros.com,
	Bob Copeland <me@bobcopeland.com>
Subject: [PATCH 2/3] ath5k: use a table for LED parameters
Date: Sun,  8 Mar 2009 00:10:21 -0500
Message-Id: <1236489022-16199-2-git-send-email-me@bobcopeland.com> (sfid-20090308_064311_240832_2C8220F1)
In-Reply-To: <1236489022-16199-1-git-send-email-me@bobcopeland.com>
References: <1236489022-16199-1-git-send-email-me@bobcopeland.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Put the device id-to-gpio mapping in a table to make it easier to add
new devices.  The list of supported devices is unchanged.

Signed-off-by: Bob Copeland <me@bobcopeland.com>
Acked-by: Jiri Slaby <jirislaby@gmail.com>
---
 drivers/net/wireless/ath5k/led.c |   53 ++++++++++++++++++++------------------
 1 files changed, 28 insertions(+), 25 deletions(-)

diff --git a/drivers/net/wireless/ath5k/led.c b/drivers/net/wireless/ath5k/led.c
index 7cef2bb..e365fbd 100644
--- a/drivers/net/wireless/ath5k/led.c
+++ b/drivers/net/wireless/ath5k/led.c
@@ -43,6 +43,29 @@
 #include "ath5k.h"
 #include "base.h"
 
+#define ATH_SDEVICE(subv,subd) \
+	.vendor = PCI_ANY_ID, .device = PCI_ANY_ID, \
+	.subvendor = (subv), .subdevice = (subd)
+
+#define ATH_LED(pin,polarity) .driver_data = (((pin) << 8) | (polarity))
+#define ATH_PIN(data) ((data) >> 8)
+#define ATH_POLARITY(data) ((data) & 0xff)
+
+/* Devices we match on for LED config info (typically laptops) */
+static const struct pci_device_id ath5k_led_devices[] = {
+	/* IBM-specific AR5212 */
+	{ PCI_VDEVICE(ATHEROS, PCI_DEVICE_ID_ATHEROS_AR5212_IBM), ATH_LED(0, 0) },
+	/* AR5211 */
+	{ PCI_VDEVICE(ATHEROS, PCI_DEVICE_ID_ATHEROS_AR5211), ATH_LED(0, 0) },
+	/* HP Compaq nc6xx, nc4000, nx6000 */
+	{ ATH_SDEVICE(PCI_VENDOR_ID_COMPAQ, PCI_ANY_ID), ATH_LED(1, 1) },
+	/* Acer Aspire One A150 (maximlevitsky@gmail.com) */
+	{ ATH_SDEVICE(PCI_VENDOR_ID_FOXCONN, PCI_ANY_ID), ATH_LED(3, 0) },
+	/* E-machines E510 (tuliom@gmail.com) */
+	{ ATH_SDEVICE(PCI_VENDOR_ID_AMBIT, PCI_ANY_ID), ATH_LED(3, 0) },
+	{ }
+};
+
 void ath5k_led_enable(struct ath5k_softc *sc)
 {
 	if (test_bit(ATH_STAT_LEDSOFT, sc->status)) {
@@ -114,39 +137,19 @@ void ath5k_unregister_leds(struct ath5k_softc *sc)
 	ath5k_unregister_led(&sc->tx_led);
 }
 
-
 int ath5k_init_leds(struct ath5k_softc *sc)
 {
 	int ret = 0;
 	struct ieee80211_hw *hw = sc->hw;
 	struct pci_dev *pdev = sc->pdev;
 	char name[ATH5K_LED_MAX_NAME_LEN + 1];
+	const struct pci_device_id *match;
 
-	/*
-	 * Auto-enable soft led processing for IBM cards and for
-	 * 5211 minipci cards.
-	 */
-	if (pdev->device == PCI_DEVICE_ID_ATHEROS_AR5212_IBM ||
-	    pdev->device == PCI_DEVICE_ID_ATHEROS_AR5211) {
-		__set_bit(ATH_STAT_LEDSOFT, sc->status);
-		sc->led_pin = 0;
-		sc->led_on = 0;  /* active low */
-	}
-	/* Enable softled on PIN1 on HP Compaq nc6xx, nc4000 & nx5000 laptops */
-	if (pdev->subsystem_vendor == PCI_VENDOR_ID_COMPAQ) {
-		__set_bit(ATH_STAT_LEDSOFT, sc->status);
-		sc->led_pin = 1;
-		sc->led_on = 1;  /* active high */
-	}
-	/*
-	 * Pin 3 on Foxconn chips used in Acer Aspire One (0x105b:e008) and
-	 * in emachines notebooks with AMBIT subsystem.
-	 */
-	if (pdev->subsystem_vendor == PCI_VENDOR_ID_FOXCONN ||
-	    pdev->subsystem_vendor == PCI_VENDOR_ID_AMBIT) {
+	match = pci_match_id(&ath5k_led_devices[0], pdev);
+	if (match) {
 		__set_bit(ATH_STAT_LEDSOFT, sc->status);
-		sc->led_pin = 3;
-		sc->led_on = 0;  /* active low */
+		sc->led_pin = ATH_PIN(match->driver_data);
+		sc->led_on = ATH_POLARITY(match->driver_data);
 	}
 
 	if (!test_bit(ATH_STAT_LEDSOFT, sc->status))
-- 
1.6.0.6


