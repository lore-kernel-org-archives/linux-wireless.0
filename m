Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:27237 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751918AbYKRDiH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Nov 2008 22:38:07 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 17 Nov 2008 19:38:07 -0800
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18722.14321.337217.549326@gargle.gargle.HOWL> (sfid-20081118_043811_534519_0336A8B0)
Date: Tue, 18 Nov 2008 09:05:13 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Jouni.Malinen@Atheros.com>,
	<Luis.Rodriguez@Atheros.com>
Subject: [PATCH 05/18] ath9k: Remove half/quarter rate tables
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Half/Quarter rate tables are needed only for legacy chipsets.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath9k/core.c |    2 +-
 drivers/net/wireless/ath9k/rc.c   |  143 +++++--------------------------------
 drivers/net/wireless/ath9k/rc.h   |    2 +-
 3 files changed, 20 insertions(+), 127 deletions(-)

diff --git a/drivers/net/wireless/ath9k/core.c b/drivers/net/wireless/ath9k/core.c
index 3e94dab..bab9eaa 100644
--- a/drivers/net/wireless/ath9k/core.c
+++ b/drivers/net/wireless/ath9k/core.c
@@ -1075,7 +1075,7 @@ int ath_init(u16 devid, struct ath_softc *sc)
 	sc->sc_ani.sc_noise_floor = ATH_DEFAULT_NOISE_FLOOR;
 	setup_timer(&sc->sc_ani.timer, ath_ani_calibrate, (unsigned long)sc);
 
-	sc->sc_rc = ath_rate_attach(ah);
+	sc->sc_rc = ath_rate_attach(sc);
 	if (sc->sc_rc == NULL) {
 		error = -EIO;
 		goto bad2;
diff --git a/drivers/net/wireless/ath9k/rc.c b/drivers/net/wireless/ath9k/rc.c
index 1ec5861..aafd10d 100644
--- a/drivers/net/wireless/ath9k/rc.c
+++ b/drivers/net/wireless/ath9k/rc.c
@@ -348,72 +348,6 @@ static struct ath_rate_table ar5416_11a_ratetable = {
 	0,   /* Phy rates allowed initially */
 };
 
-static struct ath_rate_table ar5416_11a_ratetable_Half = {
-	8,
-	{
-		{ TRUE, TRUE, WLAN_PHY_OFDM, 3000, /* 6 Mb */
-			2700, 0x0b, 0x00, (0x80|6),
-			0, 2,  1, 0, 0},
-		{ TRUE, TRUE,  WLAN_PHY_OFDM, 4500, /* 9 Mb */
-			3900, 0x0f, 0x00, 9,
-			0, 3, 1, 1, 0 },
-		{ TRUE, TRUE, WLAN_PHY_OFDM, 6000, /* 12 Mb */
-			5000, 0x0a, 0x00, (0x80|12),
-			2, 4, 2, 2, 0 },
-		{ TRUE, TRUE, WLAN_PHY_OFDM, 9000, /* 18 Mb */
-			6950, 0x0e, 0x00, 18,
-			2, 6, 2, 3, 0 },
-		{ TRUE, TRUE, WLAN_PHY_OFDM, 12000, /* 24 Mb */
-			8650, 0x09, 0x00, (0x80|24),
-			4, 10, 3, 4, 0 },
-		{ TRUE, TRUE, WLAN_PHY_OFDM, 18000, /* 36 Mb */
-			11500, 0x0d, 0x00, 36,
-			4, 14, 3, 5, 0 },
-		{ TRUE, TRUE, WLAN_PHY_OFDM, 24000, /* 48 Mb */
-			13700, 0x08, 0x00, 48,
-			4, 19, 3, 6, 0 },
-		{ TRUE, TRUE, WLAN_PHY_OFDM, 27000, /* 54 Mb */
-			14650, 0x0c, 0x00, 54,
-			4, 23, 3, 7, 0 },
-	},
-	50,  /* probe interval */
-	50,  /* rssi reduce interval */
-	0,   /* Phy rates allowed initially */
-};
-
-static struct ath_rate_table ar5416_11a_ratetable_Quarter = {
-	8,
-	{
-		{ TRUE, TRUE, WLAN_PHY_OFDM, 1500, /* 6 Mb */
-			1350, 0x0b, 0x00, (0x80|3),
-			0, 2, 1, 0, 0 },
-		{ TRUE, TRUE, WLAN_PHY_OFDM, 2250, /* 9 Mb */
-			1950, 0x0f, 0x00, 4,
-			0, 3, 1, 1, 0 },
-		{ TRUE, TRUE, WLAN_PHY_OFDM, 3000, /* 12 Mb */
-			2500, 0x0a, 0x00, (0x80|6),
-			2, 4, 2, 2, 0 },
-		{ TRUE, TRUE, WLAN_PHY_OFDM, 4500, /* 18 Mb */
-			3475, 0x0e, 0x00, 9,
-			2, 6, 2, 3, 0 },
-		{ TRUE, TRUE, WLAN_PHY_OFDM, 6000, /* 25 Mb */
-			4325, 0x09, 0x00, (0x80|12),
-			4, 10, 3, 4, 0 },
-		{ TRUE, TRUE, WLAN_PHY_OFDM, 9000, /* 36 Mb */
-			5750, 0x0d, 0x00, 18,
-			4, 14, 3, 5, 0 },
-		{ TRUE, TRUE, WLAN_PHY_OFDM, 12000, /* 48 Mb */
-			6850, 0x08, 0x00, 24,
-			4, 19, 3, 6, 0 },
-		{ TRUE, TRUE, WLAN_PHY_OFDM, 13500, /* 54 Mb */
-			7325, 0x0c, 0x00, 27,
-			4, 23, 3, 7, 0 },
-	},
-	50,  /* probe interval */
-	50,  /* rssi reduce interval */
-	0,   /* Phy rates allowed initially */
-};
-
 static struct ath_rate_table ar5416_11g_ratetable = {
 	12,
 	{
@@ -480,45 +414,6 @@ static struct ath_rate_table ar5416_11b_ratetable = {
 	0,   /* Phy rates allowed initially */
 };
 
-static void ar5416_attach_ratetables(struct ath_rate_softc *sc)
-{
-	/*
-	 * Attach rate tables.
-	 */
-	sc->hw_rate_table[ATH9K_MODE_11B] = &ar5416_11b_ratetable;
-	sc->hw_rate_table[ATH9K_MODE_11A] = &ar5416_11a_ratetable;
-	sc->hw_rate_table[ATH9K_MODE_11G] = &ar5416_11g_ratetable;
-
-	sc->hw_rate_table[ATH9K_MODE_11NA_HT20] = &ar5416_11na_ratetable;
-	sc->hw_rate_table[ATH9K_MODE_11NG_HT20] = &ar5416_11ng_ratetable;
-	sc->hw_rate_table[ATH9K_MODE_11NA_HT40PLUS] =
-		&ar5416_11na_ratetable;
-	sc->hw_rate_table[ATH9K_MODE_11NA_HT40MINUS] =
-		&ar5416_11na_ratetable;
-	sc->hw_rate_table[ATH9K_MODE_11NG_HT40PLUS] =
-		&ar5416_11ng_ratetable;
-	sc->hw_rate_table[ATH9K_MODE_11NG_HT40MINUS] =
-		&ar5416_11ng_ratetable;
-}
-
-static void ar5416_setquarter_ratetable(struct ath_rate_softc *sc)
-{
-	sc->hw_rate_table[ATH9K_MODE_11A] = &ar5416_11a_ratetable_Quarter;
-	return;
-}
-
-static void ar5416_sethalf_ratetable(struct ath_rate_softc *sc)
-{
-	sc->hw_rate_table[ATH9K_MODE_11A] = &ar5416_11a_ratetable_Half;
-	return;
-}
-
-static void ar5416_setfull_ratetable(struct ath_rate_softc *sc)
-{
-	sc->hw_rate_table[ATH9K_MODE_11A] = &ar5416_11a_ratetable;
-	return;
-}
-
 /*
  * Return the median of three numbers
  */
@@ -758,25 +653,33 @@ ath_rc_sib_setvalid_htrates(struct ath_rate_node *ath_rc_priv,
 	return hi;
 }
 
-/*
- * Attach to a device instance.  Setup the public definition
- * of how much per-node space we need and setup the private
- * phy tables that have rate control parameters.
- */
-struct ath_rate_softc *ath_rate_attach(struct ath_hal *ah)
+struct ath_rate_softc *ath_rate_attach(struct ath_softc *sc)
 {
 	struct ath_rate_softc *asc;
 
-	/* we are only in user context so we can sleep for memory */
 	asc = kzalloc(sizeof(struct ath_rate_softc), GFP_KERNEL);
 	if (asc == NULL)
 		return NULL;
 
-	ar5416_attach_ratetables(asc);
+	asc->hw_rate_table[ATH9K_MODE_11B] = &ar5416_11b_ratetable;
+	asc->hw_rate_table[ATH9K_MODE_11A] = &ar5416_11a_ratetable;
+	asc->hw_rate_table[ATH9K_MODE_11G] = &ar5416_11g_ratetable;
+
+	asc->hw_rate_table[ATH9K_MODE_11NA_HT20] = &ar5416_11na_ratetable;
+	asc->hw_rate_table[ATH9K_MODE_11NG_HT20] = &ar5416_11ng_ratetable;
+
+	asc->hw_rate_table[ATH9K_MODE_11NA_HT40PLUS] =
+		&ar5416_11na_ratetable;
+	asc->hw_rate_table[ATH9K_MODE_11NA_HT40MINUS] =
+		&ar5416_11na_ratetable;
+	asc->hw_rate_table[ATH9K_MODE_11NG_HT40PLUS] =
+		&ar5416_11ng_ratetable;
+	asc->hw_rate_table[ATH9K_MODE_11NG_HT40MINUS] =
+		&ar5416_11ng_ratetable;
 
 	/* Save Maximum TX Trigger Level (used for 11n) */
-	tx_triglevel_max = ah->ah_caps.tx_triglevel_max;
-	/*  return alias for ath_rate_softc * */
+	tx_triglevel_max = sc->sc_ah->ah_caps.tx_triglevel_max;
+
 	return asc;
 }
 
@@ -816,16 +719,6 @@ void ath_rate_newstate(struct ath_softc *sc, struct ath_vap *avp)
 {
 	struct ath_rate_softc *asc = sc->sc_rc;
 
-	/* For half and quarter rate channles use different
-	 * rate tables
-	 */
-	if (sc->sc_ah->ah_curchan->channelFlags & CHANNEL_HALF)
-		ar5416_sethalf_ratetable(asc);
-	else if (sc->sc_ah->ah_curchan->channelFlags & CHANNEL_QUARTER)
-		ar5416_setquarter_ratetable(asc);
-	else /* full rate */
-		ar5416_setfull_ratetable(asc);
-
 	if (avp->av_config.av_fixed_rateset != IEEE80211_FIXED_RATE_NONE) {
 		asc->fixedrix =
 			sc->sc_rixmap[avp->av_config.av_fixed_rateset & 0xff];
diff --git a/drivers/net/wireless/ath9k/rc.h b/drivers/net/wireless/ath9k/rc.h
index 2166243..2d8df83 100644
--- a/drivers/net/wireless/ath9k/rc.h
+++ b/drivers/net/wireless/ath9k/rc.h
@@ -290,7 +290,7 @@ struct ath_tx_info_priv {
 /*
  * Attach/detach a rate control module.
  */
-struct ath_rate_softc *ath_rate_attach(struct ath_hal *ah);
+struct ath_rate_softc *ath_rate_attach(struct ath_softc *sch);
 void ath_rate_detach(struct ath_rate_softc *asc);
 
 /*
-- 
1.6.0.3

