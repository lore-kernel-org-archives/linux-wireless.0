Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:39331 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753715Ab0DZTEm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Apr 2010 15:04:42 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Felix Fietkau <nbd@openwrt.org>
Subject: [PATCH 07/13] ath9k_hw: fix fast clock handling for 5GHz channels
Date: Mon, 26 Apr 2010 15:04:35 -0400
Message-Id: <1272308681-32396-8-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1272308681-32396-1-git-send-email-lrodriguez@atheros.com>
References: <1272308681-32396-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Felix Fietkau <nbd@openwrt.org>

Combine multiple checks that were supposed to check for the same
conditions, but didn't. Always enable fast PLL clock on AR9280 2.0

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ar5008_phy.c |    5 ++---
 drivers/net/wireless/ath/ath9k/ar9002_phy.c |   16 ++++++----------
 drivers/net/wireless/ath/ath9k/ar9003_phy.c |    4 ++--
 drivers/net/wireless/ath/ath9k/hw.c         |    8 ++++++--
 drivers/net/wireless/ath/ath9k/hw.h         |    5 ++---
 5 files changed, 18 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar5008_phy.c b/drivers/net/wireless/ath/ath9k/ar5008_phy.c
index 3395ac4..c594814 100644
--- a/drivers/net/wireless/ath/ath9k/ar5008_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar5008_phy.c
@@ -852,7 +852,7 @@ static int ar5008_hw_process_ini(struct ath_hw *ah,
 
 	REG_WRITE_ARRAY(&ah->iniBB_RfGain, freqIndex, regWrites);
 
-	if (AR_SREV_9280_20(ah) && IS_CHAN_A_5MHZ_SPACED(chan)) {
+	if (IS_CHAN_A_FAST_CLOCK(ah, chan)) {
 		REG_WRITE_ARRAY(&ah->iniModesAdditional, modesIndex,
 				regWrites);
 	}
@@ -894,8 +894,7 @@ static void ar5008_hw_set_rfmode(struct ath_hw *ah, struct ath9k_channel *chan)
 		rfMode |= (IS_CHAN_5GHZ(chan)) ?
 			AR_PHY_MODE_RF5GHZ : AR_PHY_MODE_RF2GHZ;
 
-	if ((AR_SREV_9280_20(ah) || AR_SREV_9300_20_OR_LATER(ah))
-	    && IS_CHAN_A_5MHZ_SPACED(chan))
+	if (IS_CHAN_A_FAST_CLOCK(ah, chan))
 		rfMode |= (AR_PHY_MODE_DYNAMIC | AR_PHY_MODE_DYN_CCK_DISABLE);
 
 	REG_WRITE(ah, AR_PHY_MODE, rfMode);
diff --git a/drivers/net/wireless/ath/ath9k/ar9002_phy.c b/drivers/net/wireless/ath/ath9k/ar9002_phy.c
index 18cfe1a..ed314e8 100644
--- a/drivers/net/wireless/ath/ath9k/ar9002_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar9002_phy.c
@@ -455,16 +455,12 @@ static u32 ar9002_hw_compute_pll_control(struct ath_hw *ah,
 		pll |= SM(0x2, AR_RTC_9160_PLL_CLKSEL);
 
 	if (chan && IS_CHAN_5GHZ(chan)) {
-		pll |= SM(0x28, AR_RTC_9160_PLL_DIV);
-
-
-		if (AR_SREV_9280_20(ah)) {
-			if (((chan->channel % 20) == 0)
-			    || ((chan->channel % 10) == 0))
-				pll = 0x2850;
-			else
-				pll = 0x142c;
-		}
+		if (IS_CHAN_A_FAST_CLOCK(ah, chan))
+			pll = 0x142c;
+		else if (AR_SREV_9280_20(ah))
+			pll = 0x2850;
+		else
+			pll |= SM(0x28, AR_RTC_9160_PLL_DIV);
 	} else {
 		pll |= SM(0x2c, AR_RTC_9160_PLL_DIV);
 	}
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.c b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
index bf8ec68..806f4a5 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
@@ -583,7 +583,7 @@ static int ar9003_hw_process_ini(struct ath_hw *ah,
 	 * For 5GHz channels requiring Fast Clock, apply
 	 * different modal values.
 	 */
-	if (IS_CHAN_A_5MHZ_SPACED(chan))
+	if (IS_CHAN_A_FAST_CLOCK(ah, chan))
 		REG_WRITE_ARRAY(&ah->iniModesAdditional,
 				modesIndex, regWrites);
 
@@ -613,7 +613,7 @@ static void ar9003_hw_set_rfmode(struct ath_hw *ah,
 	rfMode |= (IS_CHAN_B(chan) || IS_CHAN_G(chan))
 		? AR_PHY_MODE_DYNAMIC : AR_PHY_MODE_OFDM;
 
-	if (IS_CHAN_A_5MHZ_SPACED(chan))
+	if (IS_CHAN_A_FAST_CLOCK(ah, chan))
 		rfMode |= (AR_PHY_MODE_DYNAMIC | AR_PHY_MODE_DYN_CCK_DISABLE);
 
 	REG_WRITE(ah, AR_PHY_MODE, rfMode);
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index ca676cd..2db3ecd 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -1232,8 +1232,7 @@ int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_channel *chan,
 	    (chan->channel != ah->curchan->channel) &&
 	    ((chan->channelFlags & CHANNEL_ALL) ==
 	     (ah->curchan->channelFlags & CHANNEL_ALL)) &&
-	     !(AR_SREV_9280(ah) || IS_CHAN_A_5MHZ_SPACED(chan) ||
-	     IS_CHAN_A_5MHZ_SPACED(ah->curchan))) {
+	    !AR_SREV_9280(ah)) {
 
 		if (ath9k_hw_channel_change(ah, chan)) {
 			ath9k_hw_loadnf(ah, ah->curchan);
@@ -2206,6 +2205,11 @@ int ath9k_hw_fill_cap_info(struct ath_hw *ah)
 		pCap->txs_len = sizeof(struct ar9003_txs);
 	} else {
 		pCap->tx_desc_len = sizeof(struct ath_desc);
+		if (AR_SREV_9280_20(ah) &&
+		    ((ah->eep_ops->get_eeprom(ah, EEP_MINOR_REV) <=
+		      AR5416_EEP_MINOR_VER_16) ||
+		     ah->eep_ops->get_eeprom(ah, EEP_FSTCLK_5G)))
+			pCap->hw_caps |= ATH9K_HW_CAP_FASTCLOCK;
 	}
 
 	if (AR_SREV_9300_20_OR_LATER(ah))
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 7a1347b..bc682da 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -369,10 +369,9 @@ struct ath9k_channel {
 #define IS_CHAN_2GHZ(_c) (((_c)->channelFlags & CHANNEL_2GHZ) != 0)
 #define IS_CHAN_HALF_RATE(_c) (((_c)->channelFlags & CHANNEL_HALF) != 0)
 #define IS_CHAN_QUARTER_RATE(_c) (((_c)->channelFlags & CHANNEL_QUARTER) != 0)
-#define IS_CHAN_A_5MHZ_SPACED(_c)			\
+#define IS_CHAN_A_FAST_CLOCK(_ah, _c)			\
 	((((_c)->channelFlags & CHANNEL_5GHZ) != 0) &&	\
-	 (((_c)->channel % 20) != 0) &&			\
-	 (((_c)->channel % 10) != 0))
+	 ((_ah)->caps.hw_caps & ATH9K_HW_CAP_FASTCLOCK))
 
 /* These macros check chanmode and not channelFlags */
 #define IS_CHAN_B(_c) ((_c)->chanmode == CHANNEL_B)
-- 
1.6.3.3

