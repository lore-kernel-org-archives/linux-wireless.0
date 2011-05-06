Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:63984 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751871Ab1EFM5y (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 May 2011 08:57:54 -0400
Received: from mail.atheros.com ([10.234.20.104])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 06 May 2011 05:57:26 -0700
From: Rajkumar Manoharan <rmanoharan@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanoharan@atheros.com>,
	<stable@kernel.org>
Subject: [PATCH 1/2] ath9k: avoid enabling interrupts while processing rx
Date: Fri, 6 May 2011 18:27:46 +0530
Message-ID: <1304686667-2864-1-git-send-email-rmanoharan@atheros.com> (sfid-20110506_145758_527231_041BF0D9)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The assumsion is that while processing ath9k tasklet,
interrupts were already disabled and it will be enabled
at the completion of ath9k tasklet. But whenever TSFOOR is raised,
the driver configures the beacon timers after having received a
beacon frame from the AP which inturn enables the interrupts.

Cc: stable@kernel.org
Signed-off-by: Rajkumar Manoharan <rmanoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h  |    1 +
 drivers/net/wireless/ath/ath9k/beacon.c |   15 +++++++++++++--
 drivers/net/wireless/ath/ath9k/main.c   |    3 ++-
 drivers/net/wireless/ath/ath9k/recv.c   |    1 +
 4 files changed, 17 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 1bffd15..f2f672b 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -564,6 +564,7 @@ struct ath_ant_comb {
 #define PS_WAIT_FOR_PSPOLL_DATA   BIT(2)
 #define PS_WAIT_FOR_TX_ACK        BIT(3)
 #define PS_BEACON_SYNC            BIT(4)
+#define PS_TSFOOR_SYNC            BIT(5)
 
 struct ath_rate_table;
 
diff --git a/drivers/net/wireless/ath/ath9k/beacon.c b/drivers/net/wireless/ath/ath9k/beacon.c
index 22cd241..637dbc5 100644
--- a/drivers/net/wireless/ath/ath9k/beacon.c
+++ b/drivers/net/wireless/ath/ath9k/beacon.c
@@ -620,7 +620,13 @@ static void ath_beacon_config_sta(struct ath_softc *sc,
 	ath9k_hw_disable_interrupts(ah);
 	ath9k_hw_set_sta_beacon_timers(ah, &bs);
 	ah->imask |= ATH9K_INT_BMISS;
-	ath9k_hw_set_interrupts(ah, ah->imask);
+
+	/*
+	 * If the beacon config is called beacause of TSFOOR,
+	 * Interrupts will be enabled back at the end of ath9k_tasklet
+	 */
+	if (!(sc->ps_flags & PS_TSFOOR_SYNC))
+		ath9k_hw_set_interrupts(ah, ah->imask);
 }
 
 static void ath_beacon_config_adhoc(struct ath_softc *sc,
@@ -661,7 +667,12 @@ static void ath_beacon_config_adhoc(struct ath_softc *sc,
 	ath9k_hw_disable_interrupts(ah);
 	ath9k_beacon_init(sc, nexttbtt, intval);
 	sc->beacon.bmisscnt = 0;
-	ath9k_hw_set_interrupts(ah, ah->imask);
+	/*
+	 * If the beacon config is called beacause of TSFOOR,
+	 * Interrupts will be enabled back at the end of ath9k_tasklet
+	 */
+	if (!(sc->ps_flags & PS_TSFOOR_SYNC))
+		ath9k_hw_set_interrupts(ah, ah->imask);
 }
 
 static bool ath9k_allow_beacon_config(struct ath_softc *sc,
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 3de115d..c171d11 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -718,7 +718,8 @@ void ath9k_tasklet(unsigned long data)
 		 */
 		ath_dbg(common, ATH_DBG_PS,
 			"TSFOOR - Sync with next Beacon\n");
-		sc->ps_flags |= PS_WAIT_FOR_BEACON | PS_BEACON_SYNC;
+		sc->ps_flags |= PS_WAIT_FOR_BEACON | PS_BEACON_SYNC |
+				PS_TSFOOR_SYNC;
 	}
 
 	if (ah->btcoex_hw.scheme == ATH_BTCOEX_CFG_3WIRE)
diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index c5b7cbe..a485c04 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -572,6 +572,7 @@ static void ath_rx_ps_beacon(struct ath_softc *sc, struct sk_buff *skb)
 		ath_dbg(common, ATH_DBG_PS,
 			"Reconfigure Beacon timers based on timestamp from the AP\n");
 		ath_set_beacon(sc);
+		sc->ps_flags &= ~PS_TSFOOR_SYNC;
 	}
 
 	if (ath_beacon_dtim_pending_cab(skb)) {
-- 
1.7.5.1

