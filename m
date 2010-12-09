Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:32374 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752057Ab0LIQTB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Dec 2010 11:19:01 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 09 Dec 2010 08:18:46 -0800
From: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <lrodriguez@atheros.com>,
	Mohammed Shafi Shajakhan <mshajakhan@atheros.com>,
	doug dahlby <ddahlby@atheros.com>
Subject: [PATCH] ath9k: clean up hardware code for beacon handling
Date: Thu, 9 Dec 2010 21:48:54 +0530
Message-ID: <1291911534-8537-1-git-send-email-mshajakhan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>

The registers TBTT_TIMER ,DMA_BEACON_ALERT ,NEXT_SWBA are need to be
configured only for AP and IBSS mode.

SWBA register is used for generating software interrupts so that beacon
frames will be created by the software.DMA beacon alert register is
to indicate the hardware to DMA the contents of beacon buffer to PCU buffer
and TBTT to start transmitting the packet buffer to the base band.
Clearly these things are not needed for station/monitor mode so
remove configuring them.

Cc: doug dahlby <ddahlby@atheros.com>
Signed-off-by: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/hw.c |   14 --------------
 1 files changed, 0 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 516227f..1beb896 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -1632,12 +1632,6 @@ void ath9k_hw_beaconinit(struct ath_hw *ah, u32 next_beacon, u32 beacon_period)
 	ENABLE_REGWRITE_BUFFER(ah);
 
 	switch (ah->opmode) {
-	case NL80211_IFTYPE_STATION:
-		REG_WRITE(ah, AR_NEXT_TBTT_TIMER, TU_TO_USEC(next_beacon));
-		REG_WRITE(ah, AR_NEXT_DMA_BEACON_ALERT, 0xffff);
-		REG_WRITE(ah, AR_NEXT_SWBA, 0x7ffff);
-		flags |= AR_TBTT_TIMER_EN;
-		break;
 	case NL80211_IFTYPE_ADHOC:
 	case NL80211_IFTYPE_MESH_POINT:
 		REG_SET_BIT(ah, AR_TXCFG,
@@ -1661,14 +1655,6 @@ void ath9k_hw_beaconinit(struct ath_hw *ah, u32 next_beacon, u32 beacon_period)
 			AR_TBTT_TIMER_EN | AR_DBA_TIMER_EN | AR_SWBA_TIMER_EN;
 		break;
 	default:
-		if (ah->is_monitoring) {
-			REG_WRITE(ah, AR_NEXT_TBTT_TIMER,
-					TU_TO_USEC(next_beacon));
-			REG_WRITE(ah, AR_NEXT_DMA_BEACON_ALERT, 0xffff);
-			REG_WRITE(ah, AR_NEXT_SWBA, 0x7ffff);
-			flags |= AR_TBTT_TIMER_EN;
-			break;
-		}
 		ath_dbg(ath9k_hw_common(ah), ATH_DBG_BEACON,
 			"%s: unsupported opmode: %d\n",
 			__func__, ah->opmode);
-- 
1.7.0.4

