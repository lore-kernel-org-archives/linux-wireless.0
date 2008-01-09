Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30g.wh2.ocn.ne.jp ([220.111.41.239]:9165 "HELO
	mail30g.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752519AbYAIKLP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Jan 2008 05:11:15 -0500
From: Bruno Randolf <bruno@thinktube.com>
To: ath5k-devel@lists.ath5k.org
Cc: mcgrof@gmail.com, jirislaby@gmail.com, mickflemm@gmail.com,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	Bruno Randolf <bruno@thinktube.com>
Subject: [PATCH] ath5k: simplify beacon configuration
Date: Wed,  9 Jan 2008 19:11:14 +0900
Message-Id: <1199873474-11213-1-git-send-email-bruno@thinktube.com> (sfid-20080109_101120_560208_667DBEC1)
In-Reply-To: <200801091837.41102.bruno@thinktube.com>
References: <200801091837.41102.bruno@thinktube.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

make ath5k_beacon_config() clearer and move timer configuration into a seperate
function. it will be needed later when we can detect HW merges.

Changes-licensed-under: 3-clause-BSD
Signed-off-by: Bruno Randolf <bruno@thinktube.com>
---
 drivers/net/wireless/ath5k/base.c |  104 +++++++++++++++++-------------------
 1 files changed, 49 insertions(+), 55 deletions(-)

diff --git a/drivers/net/wireless/ath5k/base.c b/drivers/net/wireless/ath5k/base.c
index 92361df..f9744cd 100644
--- a/drivers/net/wireless/ath5k/base.c
+++ b/drivers/net/wireless/ath5k/base.c
@@ -1972,23 +1972,9 @@ ath5k_beacon_send(struct ath5k_softc *sc)
 	sc->bsent++;
 }
 
-/*
- * Configure the beacon and sleep timers.
- *
- * When operating as an AP this resets the TSF and sets
- * up the hardware to notify us when we need to issue beacons.
- *
- * When operating in station mode this sets up the beacon
- * timers according to the timestamp of the last received
- * beacon and the current TSF, configures PCF and DTIM
- * handling, programs the sleep registers so the hardware
- * will wakeup in time to receive beacons, and configures
- * the beacon miss handling so we'll receive a BMISS
- * interrupt when we stop seeing beacons from the AP
- * we've associated with.
- */
+
 static void
-ath5k_beacon_config(struct ath5k_softc *sc)
+ath5k_beacon_update_timers(struct ath5k_softc *sc)
 {
 	struct ath5k_hw *ah = sc->ah;
 	u32 uninitialized_var(nexttbtt), intval, tsftu;
@@ -2002,57 +1988,65 @@ ath5k_beacon_config(struct ath5k_softc *sc)
 	tsf = ath5k_hw_get_tsf64(ah);
 	tsftu = TSF_TO_TU(tsf);
 
-	ATH5K_DBG(sc, ATH5K_DEBUG_BEACON, "intval %u hw tsftu %u\n",
-		intval, tsftu);
+	/*
+	 * Pull nexttbtt forward to reflect the current
+	 * TSF. Add one intval otherwise the timespan
+	 * can be too short for ibss merges.
+	 */
+	nexttbtt = tsftu + 2 * intval;
 
-	if (sc->opmode == IEEE80211_IF_TYPE_STA ||
-			(sc->opmode == IEEE80211_IF_TYPE_IBSS &&
-				!sc->bbuf->skb)) {
-		ath5k_hw_set_intr(ah, 0);
-		sc->imask |= AR5K_INT_BMISS;
-		sc->bmisscount = 0;
-		ath5k_hw_set_intr(ah, sc->imask);
-	} else if (sc->opmode == IEEE80211_IF_TYPE_IBSS /* TODO || AP */) {
-		ath5k_hw_set_intr(ah, 0);
-		if (sc->opmode == IEEE80211_IF_TYPE_IBSS) {
-			/*
-			 * Pull nexttbtt forward to reflect the current
-			 * TSF. Add one intval otherwise the timespan
-			 * can be too short for ibss merges.
-			 */
-			nexttbtt = tsftu + 2 * intval;
+	ATH5K_DBG(sc, ATH5K_DEBUG_BEACON,
+		"hw tsftu %u nexttbtt %u intval %u\n", tsftu, nexttbtt, intval);
 
-			ATH5K_DBG(sc, ATH5K_DEBUG_BEACON, "nexttbtt %u "
-				"intval %u\n", nexttbtt, intval);
+	intval |= AR5K_BEACON_ENA;
 
-			/*
-			 * In IBSS mode enable the beacon timers but only
-			 * enable SWBA interrupts if we need to manually
-			 * prepare beacon frames.  Otherwise we use a
-			 * self-linked tx descriptor and let the hardware
-			 * deal with things.
-			 */
-			if (!ath5k_hw_hasveol(ah))
-				sc->imask |= AR5K_INT_SWBA;
-		} /* TODO else AP */
+	ath5k_hw_init_beacon(ah, nexttbtt, intval);
+}
 
-		intval |= AR5K_BEACON_ENA;
 
-		ath5k_beaconq_config(sc);
-		ath5k_hw_init_beacon(ah, nexttbtt, intval);
+/*
+ * Configure the beacon timers and interrupts based on the operating mode
+ *
+ * When operating in station mode we want to receive a BMISS interrupt when we
+ * stop seeing beacons from the AP we've associated with so we can look for
+ * another AP to associate with.
+ *
+ * In IBSS mode we need to configure the beacon timers and use a self-linked tx
+ * descriptor if possible. If the hardware cannot deal with that we enable SWBA
+ * interrupts to send the beacons from the interrupt handler.
+ */
+static void
+ath5k_beacon_config(struct ath5k_softc *sc)
+{
+	struct ath5k_hw *ah = sc->ah;
 
-		sc->bmisscount = 0;
-		ath5k_hw_set_intr(ah, sc->imask);
+	ath5k_hw_set_intr(ah, 0);
+	sc->bmisscount = 0;
+
+	if (sc->opmode == IEEE80211_IF_TYPE_STA) {
+		sc->imask |= AR5K_INT_BMISS;
+	} else if (sc->opmode == IEEE80211_IF_TYPE_IBSS) {
 		/*
-		 * When using a self-linked beacon descriptor in
-		 * ibss mode load it once here.
+		 * In IBSS mode enable the beacon timers but only enable SWBA
+		 * interrupts if we need to manually prepare beacon frames.
+		 * Otherwise we use a self-linked tx descriptor and let the
+		 * hardware deal with things. In that case we have to load it
+		 * only once here.
 		 */
-		if (sc->opmode == IEEE80211_IF_TYPE_IBSS &&
-				ath5k_hw_hasveol(ah))
+		ath5k_beaconq_config(sc);
+		ath5k_beacon_update_timers(sc);
+
+		if (!ath5k_hw_hasveol(ah))
+			sc->imask |= AR5K_INT_SWBA;
+		else
 			ath5k_beacon_send(sc);
 	}
+	/* TODO else AP */
+
+	ath5k_hw_set_intr(ah, sc->imask);
 }
 
+
 /********************\
 * Interrupt handling *
 \********************/
-- 
1.5.3.4

