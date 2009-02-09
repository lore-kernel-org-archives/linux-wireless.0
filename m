Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from venema.h4ckr.net ([217.24.1.135]:51460 "EHLO venema.h4ckr.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753836AbZBIEPu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Feb 2009 23:15:50 -0500
Date: Mon, 9 Feb 2009 06:15:42 +0200
From: Nick Kossifidis <mick@madwifi-project.org>
To: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, jirislaby@gmail.com, mcgrof@gmail.com,
	me@bobcopeland.com, nbd@openwrt.org
Subject: [PATCH 6/7] ath5k: Disable BMISS interrupts
Message-ID: <20090209041542.GF3168@makis> (sfid-20090209_051553_377120_BC33AC9D)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

 * Don't enable BMISS interrupts as we don't handle them yet

 Signed-off-by: Nick Kossifidis <mickflemm@gmail.com>

diff --git a/drivers/net/wireless/ath5k/base.c b/drivers/net/wireless/ath5k/base.c
index 697450d..685c19c 100644
--- a/drivers/net/wireless/ath5k/base.c
+++ b/drivers/net/wireless/ath5k/base.c
@@ -2196,10 +2196,6 @@ ath5k_beacon_update_timers(struct ath5k_softc *sc, u64 bc_tsf)
  *
  * @sc: struct ath5k_softc pointer we are operating on
  *
- * When operating in station mode we want to receive a BMISS interrupt when we
- * stop seeing beacons from the AP we've associated with so we can look for
- * another AP to associate with.
- *
  * In IBSS mode we use a self-linked tx descriptor if possible. We enable SWBA
  * interrupts to detect TSF updates only.
  */
@@ -2212,9 +2208,7 @@ ath5k_beacon_config(struct ath5k_softc *sc)
 	sc->bmisscount = 0;
 	sc->imask &= ~(AR5K_INT_BMISS | AR5K_INT_SWBA);
 
-	if (sc->opmode == NL80211_IFTYPE_STATION) {
-		sc->imask |= AR5K_INT_BMISS;
-	} else if (sc->opmode == NL80211_IFTYPE_ADHOC ||
+	if (sc->opmode == NL80211_IFTYPE_ADHOC ||
 			sc->opmode == NL80211_IFTYPE_MESH_POINT ||
 			sc->opmode == NL80211_IFTYPE_AP) {
 		/*
@@ -2466,6 +2460,7 @@ ath5k_intr(int irq, void *dev_id)
 					| AR5K_INT_TXERR | AR5K_INT_TXEOL))
 				tasklet_schedule(&sc->txtq);
 			if (status & AR5K_INT_BMISS) {
+				/* TODO */
 			}
 			if (status & AR5K_INT_MIB) {
 				/*
