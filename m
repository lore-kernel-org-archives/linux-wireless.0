Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from phoenix.szarvasnet.hu ([87.101.127.3]:39986 "EHLO
	phoenix.szarvas.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753007AbZAIMZv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Jan 2009 07:25:51 -0500
From: Gabor Juhos <juhosg@openwrt.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Jouni Malinen <jmalinen@atheros.com>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Felix Fietkau <nbd@openwrt.org>,
	Christoph Hellwig <hch@infradead.org>,
	Sujith Manoharan <Sujith.Manoharan@atheros.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Gabor Juhos <juhosg@openwrt.org>,
	Imre Kaloz <kaloz@openwrt.org>
Subject: [PATCH v2 08/11] ath9k: remove (u16) casts from rtc register access
Date: Fri,  9 Jan 2009 13:24:25 +0100
Message-Id: <1231503868-29226-9-git-send-email-juhosg@openwrt.org> (sfid-20090109_132557_008436_C2A353D9)
In-Reply-To: <1231503868-29226-1-git-send-email-juhosg@openwrt.org>
References: <1231503868-29226-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The RTC register offsets don't fit into 'u16' on the AR913x, so we have
to remove the existing casts.

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
Signed-off-by: Imre Kaloz <kaloz@openwrt.org>
---
 drivers/net/wireless/ath9k/hw.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath9k/hw.c b/drivers/net/wireless/ath9k/hw.c
index 088d968..742ecc1 100644
--- a/drivers/net/wireless/ath9k/hw.c
+++ b/drivers/net/wireless/ath9k/hw.c
@@ -1008,7 +1008,7 @@ static void ath9k_hw_init_pll(struct ath_hal *ah,
 				pll |= SM(0xb, AR_RTC_PLL_DIV);
 		}
 	}
-	REG_WRITE(ah, (u16) (AR_RTC_PLL_CONTROL), pll);
+	REG_WRITE(ah, (AR_RTC_PLL_CONTROL), pll);
 
 	udelay(RTC_PLL_SETTLE_DELAY);
 
@@ -1547,11 +1547,11 @@ static bool ath9k_hw_set_reset(struct ath_hal *ah, int type)
 			rst_flags |= AR_RTC_RC_MAC_COLD;
 	}
 
-	REG_WRITE(ah, (u16) (AR_RTC_RC), rst_flags);
+	REG_WRITE(ah, (AR_RTC_RC), rst_flags);
 	udelay(50);
 
-	REG_WRITE(ah, (u16) (AR_RTC_RC), 0);
-	if (!ath9k_hw_wait(ah, (u16) (AR_RTC_RC), AR_RTC_RC_M, 0)) {
+	REG_WRITE(ah, (AR_RTC_RC), 0);
+	if (!ath9k_hw_wait(ah, (AR_RTC_RC), AR_RTC_RC_M, 0)) {
 		DPRINTF(ah->ah_sc, ATH_DBG_RESET,
 			"RTC stuck in MAC reset\n");
 		return false;
@@ -1573,8 +1573,8 @@ static bool ath9k_hw_set_reset_power_on(struct ath_hal *ah)
 	REG_WRITE(ah, AR_RTC_FORCE_WAKE, AR_RTC_FORCE_WAKE_EN |
 		  AR_RTC_FORCE_WAKE_ON_INT);
 
-	REG_WRITE(ah, (u16) (AR_RTC_RESET), 0);
-	REG_WRITE(ah, (u16) (AR_RTC_RESET), 1);
+	REG_WRITE(ah, (AR_RTC_RESET), 0);
+	REG_WRITE(ah, (AR_RTC_RESET), 1);
 
 	if (!ath9k_hw_wait(ah,
 			   AR_RTC_STATUS,
@@ -2599,7 +2599,7 @@ static void ath9k_set_power_sleep(struct ath_hal *ah, int setChip)
 		if (!AR_SREV_9100(ah))
 			REG_WRITE(ah, AR_RC, AR_RC_AHB | AR_RC_HOSTIF);
 
-		REG_CLR_BIT(ah, (u16) (AR_RTC_RESET),
+		REG_CLR_BIT(ah, (AR_RTC_RESET),
 			    AR_RTC_RESET_EN);
 	}
 }
-- 
1.5.3.2

