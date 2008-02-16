Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:39369
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1757627AbYBPAIZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Feb 2008 19:08:25 -0500
Received: from localhost (localhost [127.0.0.1])
	by sunset.davemloft.net (Postfix) with ESMTP id 53E1EC8C1F1
	for <linux-wireless@vger.kernel.org>; Fri, 15 Feb 2008 16:08:59 -0800 (PST)
Date: Fri, 15 Feb 2008 16:08:59 -0800 (PST)
Message-Id: <20080215.160859.33950358.davem@davemloft.net> (sfid-20080216_000833_442805_948159DF)
To: linux-wireless@vger.kernel.org
Subject: [PATCH]: Fix ath5k build warnings on 64-bit.
From: David Miller <davem@davemloft.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


[ATH5K]: Fix build warnings on some 64-bit platforms.

'u64' is not necessarily 'unsigned long long'

drivers/net/wireless/ath5k/base.c: In function 'ath5k_beacon_update_timers':
drivers/net/wireless/ath5k/base.c:2130: warning: format '%llx' expects type 'long long unsigned int', but argument 4 has type 'u64'
drivers/net/wireless/ath5k/base.c:2130: warning: format '%llx' expects type 'long long unsigned int', but argument 5 has type 'u64'
drivers/net/wireless/ath5k/base.c: In function 'ath5k_intr':
drivers/net/wireless/ath5k/base.c:2391: warning: format '%llx' expects type 'long long unsigned int', but argument 6 has type 'u64'

Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/drivers/net/wireless/ath5k/base.c b/drivers/net/wireless/ath5k/base.c
index dfdaec0..1e860f5 100644
--- a/drivers/net/wireless/ath5k/base.c
+++ b/drivers/net/wireless/ath5k/base.c
@@ -2126,8 +2126,9 @@ ath5k_beacon_update_timers(struct ath5k_softc *sc, u64 bc_tsf)
 			"updated timers based on beacon TSF\n");
 
 	ATH5K_DBG_UNLIMIT(sc, ATH5K_DEBUG_BEACON,
-		"bc_tsf %llx hw_tsf %llx bc_tu %u hw_tu %u nexttbtt %u\n",
-		bc_tsf, hw_tsf, bc_tu, hw_tu, nexttbtt);
+			  "bc_tsf %llx hw_tsf %llx bc_tu %u hw_tu %u nexttbtt %u\n",
+			  (unsigned long long) bc_tsf,
+			  (unsigned long long) hw_tsf, bc_tu, hw_tu, nexttbtt);
 	ATH5K_DBG_UNLIMIT(sc, ATH5K_DEBUG_BEACON, "intval %u %s %s\n",
 		intval & AR5K_BEACON_PERIOD,
 		intval & AR5K_BEACON_ENA ? "AR5K_BEACON_ENA" : "",
@@ -2385,10 +2386,11 @@ ath5k_intr(int irq, void *dev_id)
 					u64 tsf = ath5k_hw_get_tsf64(ah);
 					sc->nexttbtt += sc->bintval;
 					ATH5K_DBG(sc, ATH5K_DEBUG_BEACON,
-						"SWBA nexttbtt: %x hw_tu: %x "
-						"TSF: %llx\n",
-						sc->nexttbtt,
-						TSF_TO_TU(tsf), tsf);
+						  "SWBA nexttbtt: %x hw_tu: %x "
+						  "TSF: %llx\n",
+						  sc->nexttbtt,
+						  TSF_TO_TU(tsf),
+						  (unsigned long long) tsf);
 				} else {
 					ath5k_beacon_send(sc);
 				}
