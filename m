Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:31181 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754098AbZG0SxK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Jul 2009 14:53:10 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 27 Jul 2009 11:53:12 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 2/3] ath9k: move cancel_delayed_work_sync() out of ath_deinit_leds()
Date: Mon, 27 Jul 2009 11:53:03 -0700
Message-ID: <1248720784-15671-3-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1248720784-15671-1-git-send-email-lrodriguez@atheros.com>
References: <1248720784-15671-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We do this as we'll be moving the cancel elsewhere later.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/main.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index dfcd8d9..dbd5cfd 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1057,7 +1057,6 @@ static void ath_unregister_led(struct ath_led *led)
 
 static void ath_deinit_leds(struct ath_softc *sc)
 {
-	cancel_delayed_work_sync(&sc->ath_led_blink_work);
 	ath_unregister_led(&sc->assoc_led);
 	sc->sc_flags &= ~SC_OP_LED_ASSOCIATED;
 	ath_unregister_led(&sc->tx_led);
@@ -1114,6 +1113,7 @@ static void ath_init_leds(struct ath_softc *sc)
 	return;
 
 fail:
+	cancel_delayed_work_sync(&sc->ath_led_blink_work);
 	ath_deinit_leds(sc);
 }
 
@@ -1252,11 +1252,13 @@ void ath_detach(struct ath_softc *sc)
 
 	DPRINTF(sc, ATH_DBG_CONFIG, "Detach ATH hw\n");
 
-	ath_deinit_leds(sc);
+	cancel_delayed_work_sync(&sc->ath_led_blink_work);
 	cancel_delayed_work_sync(&sc->tx_complete_work);
 	cancel_delayed_work_sync(&sc->wiphy_work);
 	cancel_work_sync(&sc->chan_work);
 
+	ath_deinit_leds(sc);
+
 	for (i = 0; i < sc->num_sec_wiphy; i++) {
 		struct ath_wiphy *aphy = sc->sec_wiphy[i];
 		if (aphy == NULL)
-- 
1.6.0.4

