Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([70.167.247.36]:44513 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752947AbYGORHi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Jul 2008 13:07:38 -0400
Date: Tue, 15 Jul 2008 13:07:16 -0400
From: Bob Copeland <me@bobcopeland.com>
To: linville@tuxdriver.com
Cc: deller@gmx.de, mickflemm@gmail.com, jirislaby@gmail.com,
	mcgrof@gmail.com, linux-wireless@vger.kernel.org
Subject: [PATCH] ath5k: use positive logic for HP laptop LEDs
Message-ID: <20080715170716.GA5785@hash.localnet> (sfid-20080715_190742_414592_16D161C0)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Helge Deller reports that HP laptops (NC4010 and NC6000) use active-
high signals to turn on the LEDs.  Previous code used active-low for
all devices.

Signed-off-by: Bob Copeland <me@bobcopeland.com>
---
Other ath5k devs, any issues with this patch?  Thread here for
reference:

http://marc.info/?l=linux-wireless&m=121555862316630&w=2

 drivers/net/wireless/ath5k/base.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath5k/base.c b/drivers/net/wireless/ath5k/base.c
index 217d506..3394b35 100644
--- a/drivers/net/wireless/ath5k/base.c
+++ b/drivers/net/wireless/ath5k/base.c
@@ -2550,8 +2550,6 @@ ath5k_init_leds(struct ath5k_softc *sc)
 	struct pci_dev *pdev = sc->pdev;
 	char name[ATH5K_LED_MAX_NAME_LEN + 1];
 
-	sc->led_on = 0;  /* active low */
-
 	/*
 	 * Auto-enable soft led processing for IBM cards and for
 	 * 5211 minipci cards.
@@ -2560,11 +2558,13 @@ ath5k_init_leds(struct ath5k_softc *sc)
 	    pdev->device == PCI_DEVICE_ID_ATHEROS_AR5211) {
 		__set_bit(ATH_STAT_LEDSOFT, sc->status);
 		sc->led_pin = 0;
+		sc->led_on = 0;  /* active low */
 	}
 	/* Enable softled on PIN1 on HP Compaq nc6xx, nc4000 & nx5000 laptops */
 	if (pdev->subsystem_vendor == PCI_VENDOR_ID_COMPAQ) {
 		__set_bit(ATH_STAT_LEDSOFT, sc->status);
 		sc->led_pin = 1;
+		sc->led_on = 1;  /* active high */
 	}
 	if (!test_bit(ATH_STAT_LEDSOFT, sc->status))
 		goto out;
-- 
1.5.4.2.182.gb3092

-- 
Bob Copeland %% www.bobcopeland.com

