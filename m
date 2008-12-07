Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:46176 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754195AbYLGQQU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Dec 2008 11:16:20 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Sun, 07 Dec 2008 08:16:20 -0800
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18747.62998.68377.181538@gargle.gargle.HOWL> (sfid-20081207_171622_723272_164A2132)
Date: Sun, 7 Dec 2008 21:43:10 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Jouni.Malinen@Atheros.com>,
	<Luis.Rodriguez@Atheros.com>
Subject: [PATCH 4/6] ath9k: Remove remaining occurrences of CONFIG_SLOW_ANT_DIV
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Slow Antenna Diversity has been removed, these are remnants
of the old code.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath9k/core.h |    3 ---
 drivers/net/wireless/ath9k/hw.c   |   13 ++-----------
 drivers/net/wireless/ath9k/main.c |    8 --------
 3 files changed, 2 insertions(+), 22 deletions(-)

diff --git a/drivers/net/wireless/ath9k/core.h b/drivers/net/wireless/ath9k/core.h
index 9abdbd8..0e3c225 100644
--- a/drivers/net/wireless/ath9k/core.h
+++ b/drivers/net/wireless/ath9k/core.h
@@ -715,9 +715,6 @@ struct ath_softc {
 	enum ath9k_ht_extprotspacing sc_ht_extprotspacing;
 	enum ath9k_ht_macmode tx_chan_width;
 
-#ifdef CONFIG_SLOW_ANT_DIV
-	struct ath_antdiv sc_antdiv;
-#endif
 	enum {
 		OK,		/* no change needed */
 		UPDATE,		/* update pending */
diff --git a/drivers/net/wireless/ath9k/hw.c b/drivers/net/wireless/ath9k/hw.c
index 4d70430..60d18d6 100644
--- a/drivers/net/wireless/ath9k/hw.c
+++ b/drivers/net/wireless/ath9k/hw.c
@@ -641,10 +641,7 @@ static struct ath_hal *ath9k_hw_do_attach(u16 devid, struct ath_softc *sc,
 	struct ath_hal_5416 *ahp;
 	struct ath_hal *ah;
 	int ecode;
-#ifndef CONFIG_SLOW_ANT_DIV
-	u32 i;
-	u32 j;
-#endif
+	u32 i, j;
 
 	ahp = ath9k_hw_newstate(devid, sc, mem, status);
 	if (ahp == NULL)
@@ -854,7 +851,6 @@ static struct ath_hal *ath9k_hw_do_attach(u16 devid, struct ath_softc *sc,
 	if (AR_SREV_9280_20_OR_LATER(ah))
 		ath9k_hw_init_txgain_ini(ah);
 
-#ifndef CONFIG_SLOW_ANT_DIV
 	if (ah->ah_devid == AR9280_DEVID_PCI) {
 		for (i = 0; i < ahp->ah_iniModes.ia_rows; i++) {
 			u32 reg = INI_RA(&ahp->ah_iniModes, i, 0);
@@ -868,7 +864,7 @@ static struct ath_hal *ath9k_hw_do_attach(u16 devid, struct ath_softc *sc,
 			}
 		}
 	}
-#endif
+
 	if (!ath9k_hw_fill_cap_info(ah)) {
 		DPRINTF(ah->ah_sc, ATH_DBG_RESET,
 			"failed ath9k_hw_fill_cap_info\n");
@@ -1295,11 +1291,6 @@ static int ath9k_hw_process_ini(struct ath_hal *ah,
 		u32 reg = INI_RA(&ahp->ah_iniModes, i, 0);
 		u32 val = INI_RA(&ahp->ah_iniModes, i, modesIndex);
 
-#ifdef CONFIG_SLOW_ANT_DIV
-		if (ah->ah_devid == AR9280_DEVID_PCI)
-			val = ath9k_hw_ini_fixup(ah, &ahp->ah_eeprom, reg, val);
-#endif
-
 		REG_WRITE(ah, reg, val);
 
 		if (reg >= 0x7800 && reg < 0x78a0
diff --git a/drivers/net/wireless/ath9k/main.c b/drivers/net/wireless/ath9k/main.c
index 11cd52e..f1877da 100644
--- a/drivers/net/wireless/ath9k/main.c
+++ b/drivers/net/wireless/ath9k/main.c
@@ -1514,11 +1514,6 @@ static int ath_init(u16 devid, struct ath_softc *sc)
 	/* save MISC configurations */
 	sc->sc_config.swBeaconProcess = 1;
 
-#ifdef CONFIG_SLOW_ANT_DIV
-	/* range is 40 - 255, we use something in the middle */
-	ath_slow_ant_div_init(&sc->sc_antdiv, sc, 0x127);
-#endif
-
 	/* setup channels and rates */
 
 	sc->sbands[IEEE80211_BAND_2GHZ].channels =
@@ -2130,9 +2125,6 @@ static void ath9k_remove_interface(struct ieee80211_hw *hw,
 
 	DPRINTF(sc, ATH_DBG_CONFIG, "Detach Interface\n");
 
-#ifdef CONFIG_SLOW_ANT_DIV
-	ath_slow_ant_div_stop(&sc->sc_antdiv);
-#endif
 	/* Stop ANI */
 	del_timer_sync(&sc->sc_ani.timer);
 
-- 
1.6.0.3

