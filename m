Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:36652 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755241Ab1CVUy0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Mar 2011 16:54:26 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, lrodriguez@atheros.com
Subject: [PATCH 3/3] ath9k: fix stuck beacon detection
Date: Tue, 22 Mar 2011 21:54:19 +0100
Message-Id: <1300827259-42910-3-git-send-email-nbd@openwrt.org>
In-Reply-To: <1300827259-42910-2-git-send-email-nbd@openwrt.org>
References: <1300827259-42910-1-git-send-email-nbd@openwrt.org>
 <1300827259-42910-2-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Stuck beacon detection is supposed to trigger when 9 consecutive beacons
could not be sent by the hardware. When the driver runs only one active
AP mode interface, it still configures the hardware beacon timer for
4 (ATH_BCBUF) beacon slots slots, which causes stuck beacon detection
to be reset if ath9k_hw_stoptxdma clears the stuck frames between
SWBA intervals.
Fix this by not resetting the missed beacon count for empty slots and
multiplying the threshold not by the maximum number of beacon slots
but by the configured number of beacon interfaces.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ath9k.h  |    2 +-
 drivers/net/wireless/ath/ath9k/beacon.c |   16 ++++++++--------
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 07dfb31..7c91ba4 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -362,7 +362,7 @@ struct ath_vif {
  * number of BSSIDs) if a given beacon does not go out even after waiting this
  * number of beacon intervals, the game's up.
  */
-#define BSTUCK_THRESH           	(9 * ATH_BCBUF)
+#define BSTUCK_THRESH           	9
 #define	ATH_BCBUF               	4
 #define ATH_DEFAULT_BINTVAL     	100 /* TU */
 #define ATH_DEFAULT_BMISS_LIMIT 	10
diff --git a/drivers/net/wireless/ath/ath9k/beacon.c b/drivers/net/wireless/ath/ath9k/beacon.c
index 6ebeafe..74f33bc 100644
--- a/drivers/net/wireless/ath/ath9k/beacon.c
+++ b/drivers/net/wireless/ath/ath9k/beacon.c
@@ -363,7 +363,7 @@ void ath_beacon_tasklet(unsigned long data)
 	if (ath9k_hw_numtxpending(ah, sc->beacon.beaconq) != 0) {
 		sc->beacon.bmisscnt++;
 
-		if (sc->beacon.bmisscnt < BSTUCK_THRESH) {
+		if (sc->beacon.bmisscnt < BSTUCK_THRESH * sc->nbcnvifs) {
 			ath_dbg(common, ATH_DBG_BSTUCK,
 				"missed %u consecutive beacons\n",
 				sc->beacon.bmisscnt);
@@ -380,13 +380,6 @@ void ath_beacon_tasklet(unsigned long data)
 		return;
 	}
 
-	if (sc->beacon.bmisscnt != 0) {
-		ath_dbg(common, ATH_DBG_BSTUCK,
-			"resume beacon xmit after %u misses\n",
-			sc->beacon.bmisscnt);
-		sc->beacon.bmisscnt = 0;
-	}
-
 	/*
 	 * Generate beacon frames. we are sending frames
 	 * staggered so calculate the slot for this frame based
@@ -420,6 +413,13 @@ void ath_beacon_tasklet(unsigned long data)
 			bfaddr = bf->bf_daddr;
 			bc = 1;
 		}
+
+		if (sc->beacon.bmisscnt != 0) {
+			ath_dbg(common, ATH_DBG_BSTUCK,
+				"resume beacon xmit after %u misses\n",
+				sc->beacon.bmisscnt);
+			sc->beacon.bmisscnt = 0;
+		}
 	}
 
 	/*
-- 
1.7.3.2

