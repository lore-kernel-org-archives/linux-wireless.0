Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:16430 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753759AbZBTJrT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Feb 2009 04:47:19 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 20 Feb 2009 01:47:19 -0800
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18846.31552.431206.796054@gargle.gargle.HOWL> (sfid-20090220_104722_522780_6386708D)
Date: Fri, 20 Feb 2009 15:13:28 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Jouni.Malinen@Atheros.com>,
	<Luis.Rodriguez@Atheros.com>
Subject: [PATCH 5/5] ath9k: Add appropriate ANI values for AP mode
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The short calibration interval is different for AP
mode, fix this. Also, the timer should be rearmed in
the calibration routine during scanning.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath9k/ath9k.h |   12 +++++-------
 drivers/net/wireless/ath9k/main.c  |   27 ++++++++++++---------------
 2 files changed, 17 insertions(+), 22 deletions(-)

diff --git a/drivers/net/wireless/ath9k/ath9k.h b/drivers/net/wireless/ath9k/ath9k.h
index 0b0f82c..6481ea4 100644
--- a/drivers/net/wireless/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath9k/ath9k.h
@@ -464,13 +464,11 @@ void ath_beacon_sync(struct ath_softc *sc, int if_id);
 /* ANI */
 /*******/
 
-/* ANI values for STA only.
-   FIXME: Add appropriate values for AP later */
-
-#define ATH_ANI_POLLINTERVAL    100     /* 100 milliseconds between ANI poll */
-#define ATH_SHORT_CALINTERVAL   1000    /* 1 second between calibrations */
-#define ATH_LONG_CALINTERVAL    30000   /* 30 seconds between calibrations */
-#define ATH_RESTART_CALINTERVAL 1200000 /* 20 minutes between calibrations */
+#define ATH_STA_SHORT_CALINTERVAL 1000    /* 1 second */
+#define ATH_AP_SHORT_CALINTERVAL  100     /* 100 ms */
+#define ATH_ANI_POLLINTERVAL      100     /* 100 ms */
+#define ATH_LONG_CALINTERVAL      30000   /* 30 seconds */
+#define ATH_RESTART_CALINTERVAL   1200000 /* 20 minutes */
 
 struct ath_ani {
 	bool caldone;
diff --git a/drivers/net/wireless/ath9k/main.c b/drivers/net/wireless/ath9k/main.c
index 7264c4c..b47cbe9 100644
--- a/drivers/net/wireless/ath9k/main.c
+++ b/drivers/net/wireless/ath9k/main.c
@@ -308,23 +308,23 @@ static int ath_set_channel(struct ath_softc *sc, struct ath9k_channel *hchan)
  */
 static void ath_ani_calibrate(unsigned long data)
 {
-	struct ath_softc *sc;
-	struct ath_hw *ah;
+	struct ath_softc *sc = (struct ath_softc *)data;
+	struct ath_hw *ah = sc->sc_ah;
 	bool longcal = false;
 	bool shortcal = false;
 	bool aniflag = false;
 	unsigned int timestamp = jiffies_to_msecs(jiffies);
-	u32 cal_interval;
+	u32 cal_interval, short_cal_interval;
 
-	sc = (struct ath_softc *)data;
-	ah = sc->sc_ah;
+	short_cal_interval = (ah->opmode == NL80211_IFTYPE_AP) ?
+		ATH_AP_SHORT_CALINTERVAL : ATH_STA_SHORT_CALINTERVAL;
 
 	/*
 	* don't calibrate when we're scanning.
 	* we are most likely not on our home channel.
 	*/
 	if (sc->rx.rxfilter & FIF_BCN_PRBRESP_PROMISC)
-		return;
+		goto set_timer;
 
 	/* Long calibration runs independently of short calibration. */
 	if ((timestamp - sc->ani.longcal_timer) >= ATH_LONG_CALINTERVAL) {
@@ -335,8 +335,7 @@ static void ath_ani_calibrate(unsigned long data)
 
 	/* Short calibration applies only while caldone is false */
 	if (!sc->ani.caldone) {
-		if ((timestamp - sc->ani.shortcal_timer) >=
-		    ATH_SHORT_CALINTERVAL) {
+		if ((timestamp - sc->ani.shortcal_timer) >= short_cal_interval) {
 			shortcal = true;
 			DPRINTF(sc, ATH_DBG_ANI, "shortcal @%lu\n", jiffies);
 			sc->ani.shortcal_timer = timestamp;
@@ -352,8 +351,7 @@ static void ath_ani_calibrate(unsigned long data)
 	}
 
 	/* Verify whether we must check ANI */
-	if ((timestamp - sc->ani.checkani_timer) >=
-	   ATH_ANI_POLLINTERVAL) {
+	if ((timestamp - sc->ani.checkani_timer) >= ATH_ANI_POLLINTERVAL) {
 		aniflag = true;
 		sc->ani.checkani_timer = timestamp;
 	}
@@ -362,8 +360,7 @@ static void ath_ani_calibrate(unsigned long data)
 	if (longcal || shortcal || aniflag) {
 		/* Call ANI routine if necessary */
 		if (aniflag)
-			ath9k_hw_ani_monitor(ah, &sc->nodestats,
-					     ah->curchan);
+			ath9k_hw_ani_monitor(ah, &sc->nodestats, ah->curchan);
 
 		/* Perform calibration if necessary */
 		if (longcal || shortcal) {
@@ -392,6 +389,7 @@ static void ath_ani_calibrate(unsigned long data)
 		}
 	}
 
+set_timer:
 	/*
 	* Set timer interval based on previous results.
 	* The interval must be the shortest necessary to satisfy ANI,
@@ -401,7 +399,7 @@ static void ath_ani_calibrate(unsigned long data)
 	if (sc->sc_ah->config.enable_ani)
 		cal_interval = min(cal_interval, (u32)ATH_ANI_POLLINTERVAL);
 	if (!sc->ani.caldone)
-		cal_interval = min(cal_interval, (u32)ATH_SHORT_CALINTERVAL);
+		cal_interval = min(cal_interval, (u32)short_cal_interval);
 
 	mod_timer(&sc->ani.timer, jiffies + msecs_to_jiffies(cal_interval));
 }
@@ -924,8 +922,7 @@ static void ath9k_bss_assoc_info(struct ath_softc *sc,
 
 		/* Start ANI */
 		mod_timer(&sc->ani.timer,
-			jiffies + msecs_to_jiffies(ATH_ANI_POLLINTERVAL));
-
+			  jiffies + msecs_to_jiffies(ATH_ANI_POLLINTERVAL));
 	} else {
 		DPRINTF(sc, ATH_DBG_CONFIG, "Bss Info DISSOC\n");
 		sc->curaid = 0;
-- 
1.6.1

