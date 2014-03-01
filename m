Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:63579 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753344AbaCAURk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Mar 2014 15:17:40 -0500
From: Oleksij Rempel <linux@rempel-privat.de>
To: linux-wireless@vger.kernel.org, sujith@msujith.org,
	linville@tuxdriver.com
Cc: Oleksij Rempel <linux@rempel-privat.de>
Subject: [PATCH 21/23] ath9k: remove unused ath9k_get_next_tbtt
Date: Sat,  1 Mar 2014 21:16:04 +0100
Message-Id: <1393704966-13985-22-git-send-email-linux@rempel-privat.de> (sfid-20140301_214710_197854_C7757E08)
In-Reply-To: <1393704966-13985-1-git-send-email-linux@rempel-privat.de>
References: <1393704966-13985-1-git-send-email-linux@rempel-privat.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Oleksij Rempel <linux@rempel-privat.de>
---
 drivers/net/wireless/ath/ath9k/beacon.c | 27 ---------------------------
 1 file changed, 27 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/beacon.c b/drivers/net/wireless/ath/ath9k/beacon.c
index e188743..471e0f6 100644
--- a/drivers/net/wireless/ath/ath9k/beacon.c
+++ b/drivers/net/wireless/ath/ath9k/beacon.c
@@ -447,33 +447,6 @@ static void ath9k_beacon_init(struct ath_softc *sc, u32 nexttbtt,
 	ath9k_hw_enable_interrupts(ah);
 }
 
-/* Calculate the modulo of a 64 bit TSF snapshot with a TU divisor */
-static u32 ath9k_mod_tsf64_tu(u64 tsf, u32 div_tu)
-{
-	u32 tsf_mod, tsf_hi, tsf_lo, mod_hi, mod_lo;
-
-	tsf_mod = tsf & (BIT(10) - 1);
-	tsf_hi = tsf >> 32;
-	tsf_lo = ((u32) tsf) >> 10;
-
-	mod_hi = tsf_hi % div_tu;
-	mod_lo = ((mod_hi << 22) + tsf_lo) % div_tu;
-
-	return (mod_lo << 10) | tsf_mod;
-}
-
-static u32 ath9k_get_next_tbtt(struct ath_softc *sc, u64 tsf,
-			       unsigned int interval)
-{
-	struct ath_hw *ah = sc->sc_ah;
-	unsigned int offset;
-
-	tsf += TU_TO_USEC(FUDGE + ah->config.sw_beacon_response_time);
-	offset = ath9k_mod_tsf64_tu(tsf, interval);
-
-	return (u32) tsf + TU_TO_USEC(interval) - offset;
-}
-
 /*
  * For multi-bss ap support beacons are either staggered evenly over N slots or
  * burst together.  For the former arrange for the SWBA to be delivered for each
-- 
1.9.0

