Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:16861 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752107AbYKMMbM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Nov 2008 07:31:12 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 13 Nov 2008 04:31:12 -0800
Date: Thu, 13 Nov 2008 18:01:08 +0530
From: Senthil Balasubramanian <senthilkumar@atheros.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <jouni.malinen@atheros.com>,
	<lrodriguez@atheros.com>
Subject: [PATCH 05/05] ath9k: Race condition in accessing TX and RX buffers.
Message-ID: <20081113123108.GF7688@senthil-lnx.users.atheros.com> (sfid-20081113_133117_426184_C2217FA5)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Race condition causes RX buffers to be accessed even before it is
initialized. The RX and TX buffers are initialized immediately after
the hardware is registered with mac80211. The mac80211 start callback
is ready to be fired once the device is registered for a case when the
wpa_supplicant is also running at the same time.

The same race condition is also possible for RKFILL registration
as RFKILL init happens after the device registration with mac80211
and it is possible that rfkill_register would be called even before
it is initialized.

Signed-off-by: Senthil Balasubramanian <senthilkumar@atheros.com>
---
 drivers/net/wireless/ath9k/main.c |   29 ++++++++++++++---------------
 1 files changed, 14 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/ath9k/main.c b/drivers/net/wireless/ath9k/main.c
index ce5c0f7..ffd483f 100644
--- a/drivers/net/wireless/ath9k/main.c
+++ b/drivers/net/wireless/ath9k/main.c
@@ -913,14 +913,14 @@ static int ath_attach(u16 devid, struct ath_softc *sc)
 		hw->wiphy->bands[IEEE80211_BAND_5GHZ] =
 			&sc->sbands[IEEE80211_BAND_5GHZ];
 
-	error = ieee80211_register_hw(hw);
-	if (error != 0) {
-		ath_rate_control_unregister();
-		goto bad;
-	}
+	/* initialize tx/rx engine */
+	error = ath_tx_init(sc, ATH_TXBUF);
+	if (error != 0)
+		goto detach;
 
-	/* Initialize LED control */
-	ath_init_leds(sc);
+	error = ath_rx_init(sc, ATH_RXBUF);
+	if (error != 0)
+		goto detach;
 
 #if defined(CONFIG_RFKILL) || defined(CONFIG_RFKILL_MODULE)
 	/* Initialze h/w Rfkill */
@@ -932,15 +932,14 @@ static int ath_attach(u16 devid, struct ath_softc *sc)
 		goto detach;
 #endif
 
-	/* initialize tx/rx engine */
-
-	error = ath_tx_init(sc, ATH_TXBUF);
-	if (error != 0)
-		goto detach;
+	error = ieee80211_register_hw(hw);
+	if (error != 0) {
+		ath_rate_control_unregister();
+		goto bad;
+	}
 
-	error = ath_rx_init(sc, ATH_RXBUF);
-	if (error != 0)
-		goto detach;
+	/* Initialize LED control */
+	ath_init_leds(sc);
 
 	return 0;
 detach:
-- 
1.5.5

