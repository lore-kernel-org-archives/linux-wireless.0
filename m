Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:57633 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751170AbYJ2Eus (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Oct 2008 00:50:48 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 28 Oct 2008 21:50:48 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18695.60154.759782.919661@gargle.gargle.HOWL> (sfid-20081029_060857_997300_7521D438)
Date: Wed, 29 Oct 2008 10:17:54 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Jouni.Malinen@Atheros.com>,
	<Luis.Rodriguez@Atheros.com>
Subject: [PATCH 12/16] ath9k: Enable interrupts at the proper place
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

config_interface() was the wrong place to enable interrupts
when bringing up an interface, move it to ath_open().

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath9k/core.c |    9 ++++-----
 drivers/net/wireless/ath9k/main.c |    6 ------
 2 files changed, 4 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/ath9k/core.c b/drivers/net/wireless/ath9k/core.c
index 1826818..d138446 100644
--- a/drivers/net/wireless/ath9k/core.c
+++ b/drivers/net/wireless/ath9k/core.c
@@ -675,13 +675,12 @@ int ath_open(struct ath_softc *sc, struct ath9k_channel *initial_chan)
 
 	ath_setcurmode(sc, ath_chan2mode(initial_chan));
 
-	/*
-	 *  Don't enable interrupts here as we've not yet built our
-	 *  vap and node data structures, which will be needed as soon
-	 *  as we start receiving.
-	 */
 	sc->sc_flags &= ~SC_OP_INVALID;
 
+	/* Disable BMISS interrupt when we're not associated */
+	sc->sc_imask &= ~(ATH9K_INT_SWBA | ATH9K_INT_BMISS);
+	ath9k_hw_set_interrupts(sc->sc_ah,sc->sc_imask);
+
 	ieee80211_wake_queues(sc->hw);
 done:
 	return error;
diff --git a/drivers/net/wireless/ath9k/main.c b/drivers/net/wireless/ath9k/main.c
index d2b53b5..494d4a0 100644
--- a/drivers/net/wireless/ath9k/main.c
+++ b/drivers/net/wireless/ath9k/main.c
@@ -1239,12 +1239,6 @@ static int ath9k_config_interface(struct ieee80211_hw *hw,
 			/* Set aggregation protection mode parameters */
 			sc->sc_config.ath_aggr_prot = 0;
 
-			/* Disable BMISS interrupt when we're not associated */
-			ath9k_hw_set_interrupts(sc->sc_ah,
-					sc->sc_imask &
-					~(ATH9K_INT_SWBA | ATH9K_INT_BMISS));
-			sc->sc_imask &= ~(ATH9K_INT_SWBA | ATH9K_INT_BMISS);
-
 			DPRINTF(sc, ATH_DBG_CONFIG,
 				"%s: RX filter 0x%x bssid %s aid 0x%x\n",
 				__func__, rfilt,
-- 
1.6.0.3

