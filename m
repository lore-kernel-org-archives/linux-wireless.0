Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:48359 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753235Ab0HBNxW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Aug 2010 09:53:22 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, lrodriguez@atheros.com
Subject: [PATCH 1/4] ath9k: add a separate debug level for stuck beacons
Date: Mon,  2 Aug 2010 15:53:12 +0200
Message-Id: <1280757195-9532-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Stuck beacons are a useful indicator for debugging various PHY
issues such as calibration. Putting them on the same debug level
as the other beacon stuff makes it hard to spot them in huge amounts
of spam.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/beacon.c |    6 +++---
 drivers/net/wireless/ath/debug.h        |    2 ++
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/beacon.c b/drivers/net/wireless/ath/ath9k/beacon.c
index 4d4b22d..102f123 100644
--- a/drivers/net/wireless/ath/ath9k/beacon.c
+++ b/drivers/net/wireless/ath/ath9k/beacon.c
@@ -359,11 +359,11 @@ void ath_beacon_tasklet(unsigned long data)
 		sc->beacon.bmisscnt++;
 
 		if (sc->beacon.bmisscnt < BSTUCK_THRESH) {
-			ath_print(common, ATH_DBG_BEACON,
+			ath_print(common, ATH_DBG_BSTUCK,
 				  "missed %u consecutive beacons\n",
 				  sc->beacon.bmisscnt);
 		} else if (sc->beacon.bmisscnt >= BSTUCK_THRESH) {
-			ath_print(common, ATH_DBG_BEACON,
+			ath_print(common, ATH_DBG_BSTUCK,
 				  "beacon is officially stuck\n");
 			sc->sc_flags |= SC_OP_TSF_RESET;
 			ath_reset(sc, false);
@@ -373,7 +373,7 @@ void ath_beacon_tasklet(unsigned long data)
 	}
 
 	if (sc->beacon.bmisscnt != 0) {
-		ath_print(common, ATH_DBG_BEACON,
+		ath_print(common, ATH_DBG_BSTUCK,
 			  "resume beacon xmit after %u misses\n",
 			  sc->beacon.bmisscnt);
 		sc->beacon.bmisscnt = 0;
diff --git a/drivers/net/wireless/ath/debug.h b/drivers/net/wireless/ath/debug.h
index 873bf52..fd3a020 100644
--- a/drivers/net/wireless/ath/debug.h
+++ b/drivers/net/wireless/ath/debug.h
@@ -36,6 +36,7 @@
  * @ATH_DBG_PS: power save processing
  * @ATH_DBG_HWTIMER: hardware timer handling
  * @ATH_DBG_BTCOEX: bluetooth coexistance
+ * @ATH_DBG_BSTUCK: stuck beacons
  * @ATH_DBG_ANY: enable all debugging
  *
  * The debug level is used to control the amount and type of debugging output
@@ -60,6 +61,7 @@ enum ATH_DEBUG {
 	ATH_DBG_HWTIMER		= 0x00001000,
 	ATH_DBG_BTCOEX		= 0x00002000,
 	ATH_DBG_WMI		= 0x00004000,
+	ATH_DBG_BSTUCK		= 0x00008000,
 	ATH_DBG_ANY		= 0xffffffff
 };
 
-- 
1.6.4.2

