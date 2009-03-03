Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:40017 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757946AbZCCEux (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Mar 2009 23:50:53 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 02 Mar 2009 20:50:52 -0800
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18860.46656.319012.606808@gargle.gargle.HOWL> (sfid-20090303_055113_370887_C49A83EC)
Date: Tue, 3 Mar 2009 10:16:56 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Jouni.Malinen@Atheros.com>,
	<Luis.Rodriguez@Atheros.com>
Subject: [PATCH 5/7] ath9k: Handle TSF properly for AP mode
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The TSF has to be reset only once, upon bringing
the interface up in AP mode. For any beacon reconfigure calls
after that, resetting the TSF results in incorrect beacon generation.
The only exception is a change in the beacon interval,
which is indicated to the driver by mac80211 through
IEEE80211_CONF_CHANGE_BEACON_INTERVAL, handle this properly.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath9k/ath9k.h  |   33 +++++++++++++++++----------------
 drivers/net/wireless/ath9k/beacon.c |   10 ++++++++++
 drivers/net/wireless/ath9k/main.c   |   14 +++++++++++++-
 3 files changed, 40 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/ath9k/ath9k.h b/drivers/net/wireless/ath9k/ath9k.h
index 733108c..a4f195b 100644
--- a/drivers/net/wireless/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath9k/ath9k.h
@@ -542,22 +542,23 @@ struct ath_rfkill {
 #define ATH_RSSI_DUMMY_MARKER   0x127
 #define ATH_RATE_DUMMY_MARKER   0
 
-#define SC_OP_INVALID		BIT(0)
-#define SC_OP_BEACONS		BIT(1)
-#define SC_OP_RXAGGR		BIT(2)
-#define SC_OP_TXAGGR		BIT(3)
-#define SC_OP_CHAINMASK_UPDATE	BIT(4)
-#define SC_OP_FULL_RESET	BIT(5)
-#define SC_OP_PREAMBLE_SHORT	BIT(6)
-#define SC_OP_PROTECT_ENABLE	BIT(7)
-#define SC_OP_RXFLUSH		BIT(8)
-#define SC_OP_LED_ASSOCIATED	BIT(9)
-#define SC_OP_RFKILL_REGISTERED	BIT(10)
-#define SC_OP_RFKILL_SW_BLOCKED	BIT(11)
-#define SC_OP_RFKILL_HW_BLOCKED	BIT(12)
-#define SC_OP_WAIT_FOR_BEACON	BIT(13)
-#define SC_OP_LED_ON		BIT(14)
-#define SC_OP_SCANNING		BIT(15)
+#define SC_OP_INVALID           BIT(0)
+#define SC_OP_BEACONS           BIT(1)
+#define SC_OP_RXAGGR            BIT(2)
+#define SC_OP_TXAGGR            BIT(3)
+#define SC_OP_CHAINMASK_UPDATE  BIT(4)
+#define SC_OP_FULL_RESET        BIT(5)
+#define SC_OP_PREAMBLE_SHORT    BIT(6)
+#define SC_OP_PROTECT_ENABLE    BIT(7)
+#define SC_OP_RXFLUSH           BIT(8)
+#define SC_OP_LED_ASSOCIATED    BIT(9)
+#define SC_OP_RFKILL_REGISTERED BIT(10)
+#define SC_OP_RFKILL_SW_BLOCKED BIT(11)
+#define SC_OP_RFKILL_HW_BLOCKED BIT(12)
+#define SC_OP_WAIT_FOR_BEACON   BIT(13)
+#define SC_OP_LED_ON            BIT(14)
+#define SC_OP_SCANNING          BIT(15)
+#define SC_OP_TSF_RESET         BIT(16)
 
 struct ath_bus_ops {
 	void		(*read_cachesize)(struct ath_softc *sc, int *csz);
diff --git a/drivers/net/wireless/ath9k/beacon.c b/drivers/net/wireless/ath9k/beacon.c
index 7491643..d136572 100644
--- a/drivers/net/wireless/ath9k/beacon.c
+++ b/drivers/net/wireless/ath9k/beacon.c
@@ -510,6 +510,11 @@ static void ath_beacon_config_ap(struct ath_softc *sc,
 {
 	u32 nexttbtt, intval;
 
+	/* Configure the timers only when the TSF has to be reset */
+
+	if (!(sc->sc_flags & SC_OP_TSF_RESET))
+		return;
+
 	/* NB: the beacon interval is kept internally in TU's */
 	intval = conf->beacon_interval & ATH9K_BEACON_PERIOD;
 	intval /= ATH_BCBUF;    /* for staggered beacons */
@@ -530,6 +535,11 @@ static void ath_beacon_config_ap(struct ath_softc *sc,
 	ath9k_hw_beaconinit(sc->sc_ah, nexttbtt, intval);
 	sc->beacon.bmisscnt = 0;
 	ath9k_hw_set_interrupts(sc->sc_ah, sc->imask);
+
+	/* Clear the reset TSF flag, so that subsequent beacon updation
+	   will not reset the HW TSF. */
+
+	sc->sc_flags &= ~SC_OP_TSF_RESET;
 }
 
 /*
diff --git a/drivers/net/wireless/ath9k/main.c b/drivers/net/wireless/ath9k/main.c
index 2ed6848..ee72a0c 100644
--- a/drivers/net/wireless/ath9k/main.c
+++ b/drivers/net/wireless/ath9k/main.c
@@ -2166,8 +2166,10 @@ static int ath9k_add_interface(struct ieee80211_hw *hw,
 	avp->av_opmode = ic_opmode;
 	avp->av_bslot = -1;
 
-	if (ic_opmode == NL80211_IFTYPE_AP)
+	if (ic_opmode == NL80211_IFTYPE_AP) {
 		ath9k_hw_set_tsfadjust(sc->sc_ah, 1);
+		sc->sc_flags |= SC_OP_TSF_RESET;
+	}
 
 	sc->vifs[0] = conf->vif;
 	sc->nvifs++;
@@ -2289,6 +2291,16 @@ static int ath9k_config(struct ieee80211_hw *hw, u32 changed)
 	if (changed & IEEE80211_CONF_CHANGE_POWER)
 		sc->config.txpowlimit = 2 * conf->power_level;
 
+	/*
+	 * The HW TSF has to be reset when the beacon interval changes.
+	 * We set the flag here, and ath_beacon_config_ap() would take this
+	 * into account when it gets called through the subsequent
+	 * config_interface() call - with IFCC_BEACON in the changed field.
+	 */
+
+	if (changed & IEEE80211_CONF_CHANGE_BEACON_INTERVAL)
+		sc->sc_flags |= SC_OP_TSF_RESET;
+
 	mutex_unlock(&sc->mutex);
 
 	return 0;
-- 
1.6.1

