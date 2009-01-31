Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50458 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755042AbZAaOwV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 31 Jan 2009 09:52:21 -0500
Received: from Relay1.suse.de (relay-ext.suse.de [195.135.221.8])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mx2.suse.de (Postfix) with ESMTP id B7A5A466AA
	for <linux-wireless@vger.kernel.org>; Sat, 31 Jan 2009 15:52:19 +0100 (CET)
From: Danny Kukawka <dkukawka@suse.de>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 1/4] ath9k: fix led naming
Date: Sat, 31 Jan 2009 15:52:09 +0100
Cc: Helmut Schaa <hschaa@suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200901311552.10448.dkukawka@suse.de> (sfid-20090131_155241_773449_DB374EFE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Danny Kukawka <dkukawka@suse.de>
Subject: ath9k: fix led naming

Fixed led device naming for the ath9k driver. Due to the
documentation of the led subsystem/class the naming should be
"devicename:colour:function" while not applying sections
should be left blank.
    
This should lead to e.g. "ath9k-%s::rx" instead of "ath9k-%s:rx".

Signed-off-by: Danny Kukawka <dkukawka@suse.de>
--
 main.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath9k/main.c b/drivers/net/wireless/ath9k/main.c
index 727f067..e76018d 100644
--- a/drivers/net/wireless/ath9k/main.c
+++ b/drivers/net/wireless/ath9k/main.c
@@ -1022,7 +1022,7 @@ static void ath_init_leds(struct ath_softc *sc)
 
 	trigger = ieee80211_get_radio_led_name(sc->hw);
 	snprintf(sc->radio_led.name, sizeof(sc->radio_led.name),
-		"ath9k-%s:radio", wiphy_name(sc->hw->wiphy));
+		"ath9k-%s::radio", wiphy_name(sc->hw->wiphy));
 	ret = ath_register_led(sc, &sc->radio_led, trigger);
 	sc->radio_led.led_type = ATH_LED_RADIO;
 	if (ret)
@@ -1030,7 +1030,7 @@ static void ath_init_leds(struct ath_softc *sc)
 
 	trigger = ieee80211_get_assoc_led_name(sc->hw);
 	snprintf(sc->assoc_led.name, sizeof(sc->assoc_led.name),
-		"ath9k-%s:assoc", wiphy_name(sc->hw->wiphy));
+		"ath9k-%s::assoc", wiphy_name(sc->hw->wiphy));
 	ret = ath_register_led(sc, &sc->assoc_led, trigger);
 	sc->assoc_led.led_type = ATH_LED_ASSOC;
 	if (ret)
@@ -1038,7 +1038,7 @@ static void ath_init_leds(struct ath_softc *sc)
 
 	trigger = ieee80211_get_tx_led_name(sc->hw);
 	snprintf(sc->tx_led.name, sizeof(sc->tx_led.name),
-		"ath9k-%s:tx", wiphy_name(sc->hw->wiphy));
+		"ath9k-%s::tx", wiphy_name(sc->hw->wiphy));
 	ret = ath_register_led(sc, &sc->tx_led, trigger);
 	sc->tx_led.led_type = ATH_LED_TX;
 	if (ret)
@@ -1046,7 +1046,7 @@ static void ath_init_leds(struct ath_softc *sc)
 
 	trigger = ieee80211_get_rx_led_name(sc->hw);
 	snprintf(sc->rx_led.name, sizeof(sc->rx_led.name),
-		"ath9k-%s:rx", wiphy_name(sc->hw->wiphy));
+		"ath9k-%s::rx", wiphy_name(sc->hw->wiphy));
 	ret = ath_register_led(sc, &sc->rx_led, trigger);
 	sc->rx_led.led_type = ATH_LED_RX;
 	if (ret)
@@ -1238,7 +1238,7 @@ static int ath_init_sw_rfkill(struct ath_softc *sc)
 	}
 
 	snprintf(sc->rf_kill.rfkill_name, sizeof(sc->rf_kill.rfkill_name),
-		"ath9k-%s:rfkill", wiphy_name(sc->hw->wiphy));
+		"ath9k-%s::rfkill", wiphy_name(sc->hw->wiphy));
 	sc->rf_kill.rfkill->name = sc->rf_kill.rfkill_name;
 	sc->rf_kill.rfkill->data = sc;
 	sc->rf_kill.rfkill->toggle_radio = ath_sw_toggle_radio;

-- 
Danny Kukawka
dkukawka@suse.de
R&D Team Mobile Devices
SUSE LINUX a Novell Business
Maxfeldstr. 5, D-90409 Nuernberg, Germany
SUSE LINUX Products GmbH, Nuernberg; GF: Markus Rex, HRB 16746 (AG Nuernberg)
