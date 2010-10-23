Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:36814 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757743Ab0JWPpl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Oct 2010 11:45:41 -0400
Message-ID: <4CC30322.2080902@openwrt.org>
Date: Sat, 23 Oct 2010 17:45:38 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: linux-wireless <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH] ath9k: resume aggregation immediately after a hardware reset
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since aggregation is usually triggered by tx completion, a hardware
reset (because of beacon stuck, tx hang or baseband hang) can
significantly delay the transmission of the next AMPDU (until the next
tx completion event).
Fix this by rescheduling aggregation after such a reset.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Cc: stable@kernel.org
---
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -587,7 +587,7 @@ void ath_hw_check(struct work_struct *wo
 
 		msleep(1);
 	}
-	ath_reset(sc, false);
+	ath_reset(sc, true);
 
 out:
 	ath9k_ps_restore(sc);
@@ -605,7 +605,7 @@ void ath9k_tasklet(unsigned long data)
 	ath9k_ps_wakeup(sc);
 
 	if (status & ATH9K_INT_FATAL) {
-		ath_reset(sc, false);
+		ath_reset(sc, true);
 		ath9k_ps_restore(sc);
 		return;
 	}
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -2163,7 +2163,7 @@ static void ath_tx_complete_poll_work(st
 		ath_print(ath9k_hw_common(sc->sc_ah), ATH_DBG_RESET,
 			  "tx hung, resetting the chip\n");
 		ath9k_ps_wakeup(sc);
-		ath_reset(sc, false);
+		ath_reset(sc, true);
 		ath9k_ps_restore(sc);
 	}
 
--- a/drivers/net/wireless/ath/ath9k/beacon.c
+++ b/drivers/net/wireless/ath/ath9k/beacon.c
@@ -370,7 +370,7 @@ void ath_beacon_tasklet(unsigned long da
 			ath_print(common, ATH_DBG_BSTUCK,
 				  "beacon is officially stuck\n");
 			sc->sc_flags |= SC_OP_TSF_RESET;
-			ath_reset(sc, false);
+			ath_reset(sc, true);
 		}
 
 		return;
