Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from phoenix.szarvasnet.hu ([87.101.127.3]:37614 "EHLO
	phoenix.szarvas.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754144AbZANTSm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Jan 2009 14:18:42 -0500
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
	Pavel Roskin <proski@gnu.org>,
	Gabor Juhos <juhosg@openwrt.org>,
	Imre Kaloz <kaloz@openwrt.org>
Subject: [PATCH v4 08/11] ath9k: remove (u16) casts from rtc register access
Date: Wed, 14 Jan 2009 20:17:09 +0100
Message-Id: <1231960632-4452-9-git-send-email-juhosg@openwrt.org> (sfid-20090114_201845_987958_EB901F26)
In-Reply-To: <1231960632-4452-1-git-send-email-juhosg@openwrt.org>
References: <1231960632-4452-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The RTC register offsets don't fit into 'u16' on the AR913x, so we have
to remove the existing casts.

Changes-licensed-under: ISC

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
Signed-off-by: Imre Kaloz <kaloz@openwrt.org>
---
 drivers/net/wireless/ath9k/hw.c  |   14 +++++++-------
 drivers/net/wireless/ath9k/reg.h |    4 ++--
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ath9k/hw.c b/drivers/net/wireless/ath9k/hw.c
index 55ed083..ed731b9 100644
--- a/drivers/net/wireless/ath9k/hw.c
+++ b/drivers/net/wireless/ath9k/hw.c
@@ -1011,7 +1011,7 @@ static void ath9k_hw_init_pll(struct ath_hal *ah,
 				pll |= SM(0xb, AR_RTC_PLL_DIV);
 		}
 	}
-	REG_WRITE(ah, (u16) (AR_RTC_PLL_CONTROL), pll);
+	REG_WRITE(ah, AR_RTC_PLL_CONTROL, pll);
 
 	udelay(RTC_PLL_SETTLE_DELAY);
 
@@ -1550,11 +1550,11 @@ static bool ath9k_hw_set_reset(struct ath_hal *ah, int type)
 			rst_flags |= AR_RTC_RC_MAC_COLD;
 	}
 
-	REG_WRITE(ah, (u16) (AR_RTC_RC), rst_flags);
+	REG_WRITE(ah, AR_RTC_RC, rst_flags);
 	udelay(50);
 
-	REG_WRITE(ah, (u16) (AR_RTC_RC), 0);
-	if (!ath9k_hw_wait(ah, (u16) (AR_RTC_RC), AR_RTC_RC_M, 0)) {
+	REG_WRITE(ah, AR_RTC_RC, 0);
+	if (!ath9k_hw_wait(ah, AR_RTC_RC, AR_RTC_RC_M, 0)) {
 		DPRINTF(ah->ah_sc, ATH_DBG_RESET,
 			"RTC stuck in MAC reset\n");
 		return false;
@@ -1576,8 +1576,8 @@ static bool ath9k_hw_set_reset_power_on(struct ath_hal *ah)
 	REG_WRITE(ah, AR_RTC_FORCE_WAKE, AR_RTC_FORCE_WAKE_EN |
 		  AR_RTC_FORCE_WAKE_ON_INT);
 
-	REG_WRITE(ah, (u16) (AR_RTC_RESET), 0);
-	REG_WRITE(ah, (u16) (AR_RTC_RESET), 1);
+	REG_WRITE(ah, AR_RTC_RESET, 0);
+	REG_WRITE(ah, AR_RTC_RESET, 1);
 
 	if (!ath9k_hw_wait(ah,
 			   AR_RTC_STATUS,
@@ -2619,7 +2619,7 @@ static void ath9k_set_power_sleep(struct ath_hal *ah, int setChip)
 		if (!AR_SREV_9100(ah))
 			REG_WRITE(ah, AR_RC, AR_RC_AHB | AR_RC_HOSTIF);
 
-		REG_CLR_BIT(ah, (u16) (AR_RTC_RESET),
+		REG_CLR_BIT(ah, (AR_RTC_RESET),
 			    AR_RTC_RESET_EN);
 	}
 }
diff --git a/drivers/net/wireless/ath9k/reg.h b/drivers/net/wireless/ath9k/reg.h
index 2dffe37..150eda5 100644
--- a/drivers/net/wireless/ath9k/reg.h
+++ b/drivers/net/wireless/ath9k/reg.h
@@ -953,7 +953,7 @@ enum {
 
 #define AR_RTC_BASE             0x00020000
 #define AR_RTC_RC \
-	(AR_SREV_9100(ah)) ? (AR_RTC_BASE + 0x0000) : 0x7000
+	((AR_SREV_9100(ah)) ? (AR_RTC_BASE + 0x0000) : 0x7000)
 #define AR_RTC_RC_M		0x00000003
 #define AR_RTC_RC_MAC_WARM      0x00000001
 #define AR_RTC_RC_MAC_COLD      0x00000002
@@ -961,7 +961,7 @@ enum {
 #define AR_RTC_RC_WARM_RESET    0x00000008
 
 #define AR_RTC_PLL_CONTROL \
-	(AR_SREV_9100(ah)) ? (AR_RTC_BASE + 0x0014) : 0x7014
+	((AR_SREV_9100(ah)) ? (AR_RTC_BASE + 0x0014) : 0x7014)
 
 #define AR_RTC_PLL_DIV          0x0000001f
 #define AR_RTC_PLL_DIV_S        0
-- 
1.5.3.2

