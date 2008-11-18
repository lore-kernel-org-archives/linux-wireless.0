Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:28420 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751868AbYKRDms (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Nov 2008 22:42:48 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 17 Nov 2008 19:42:48 -0800
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18722.14602.497310.375755@gargle.gargle.HOWL> (sfid-20081118_044250_929460_7C58B35E)
Date: Tue, 18 Nov 2008 09:09:54 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Jouni.Malinen@Atheros.com>,
	<Luis.Rodriguez@Atheros.com>
Subject: [PATCH 16/18] ath9k: Fix bug in deciphering channel flags
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

CHANNEL_CCK flag is set for all 2 Ghz channels, so IS_CHAN_CCK() would
turn out to be true for all channles in that band.
Use IS_CHAN_B() now, which checks the channel mode and not the channel
flags.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath9k/ath9k.h |    3 +--
 drivers/net/wireless/ath9k/hw.c    |   11 ++++++-----
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath9k/ath9k.h b/drivers/net/wireless/ath9k/ath9k.h
index 6b0e3dd..5b9bc54 100644
--- a/drivers/net/wireless/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath9k/ath9k.h
@@ -476,12 +476,10 @@ struct ath9k_channel {
        (((_c)->channelFlags & CHANNEL_A_HT20) == CHANNEL_A_HT20) || \
        (((_c)->channelFlags & CHANNEL_A_HT40PLUS) == CHANNEL_A_HT40PLUS) || \
        (((_c)->channelFlags & CHANNEL_A_HT40MINUS) == CHANNEL_A_HT40MINUS))
-#define IS_CHAN_B(_c) (((_c)->channelFlags & CHANNEL_B) == CHANNEL_B)
 #define IS_CHAN_G(_c) ((((_c)->channelFlags & (CHANNEL_G)) == CHANNEL_G) || \
        (((_c)->channelFlags & CHANNEL_G_HT20) == CHANNEL_G_HT20) || \
        (((_c)->channelFlags & CHANNEL_G_HT40PLUS) == CHANNEL_G_HT40PLUS) || \
        (((_c)->channelFlags & CHANNEL_G_HT40MINUS) == CHANNEL_G_HT40MINUS))
-#define IS_CHAN_CCK(_c) (((_c)->channelFlags & CHANNEL_CCK) != 0)
 #define IS_CHAN_OFDM(_c) (((_c)->channelFlags & CHANNEL_OFDM) != 0)
 #define IS_CHAN_5GHZ(_c) (((_c)->channelFlags & CHANNEL_5GHZ) != 0)
 #define IS_CHAN_2GHZ(_c) (((_c)->channelFlags & CHANNEL_2GHZ) != 0)
@@ -490,6 +488,7 @@ struct ath9k_channel {
 #define IS_CHAN_QUARTER_RATE(_c) (((_c)->channelFlags & CHANNEL_QUARTER) != 0)
 
 /* These macros check chanmode and not channelFlags */
+#define IS_CHAN_B(_c) ((_c)->chanmode == CHANNEL_B)
 #define IS_CHAN_HT20(_c) (((_c)->chanmode == CHANNEL_A_HT20) ||	\
 			  ((_c)->chanmode == CHANNEL_G_HT20))
 #define IS_CHAN_HT40(_c) (((_c)->chanmode == CHANNEL_A_HT40PLUS) ||	\
diff --git a/drivers/net/wireless/ath9k/hw.c b/drivers/net/wireless/ath9k/hw.c
index 1885d24..6593a13 100644
--- a/drivers/net/wireless/ath9k/hw.c
+++ b/drivers/net/wireless/ath9k/hw.c
@@ -86,10 +86,11 @@ static u32 ath9k_hw_mac_to_clks(struct ath_hal *ah, u32 usecs)
 enum wireless_mode ath9k_hw_chan2wmode(struct ath_hal *ah,
 			       const struct ath9k_channel *chan)
 {
-	if (IS_CHAN_CCK(chan))
-		return ATH9K_MODE_11A;
+	if (IS_CHAN_B(chan))
+		return ATH9K_MODE_11B;
 	if (IS_CHAN_G(chan))
 		return ATH9K_MODE_11G;
+
 	return ATH9K_MODE_11A;
 }
 
@@ -910,7 +911,7 @@ static void ath9k_hw_init_bb(struct ath_hal *ah,
 	u32 synthDelay;
 
 	synthDelay = REG_READ(ah, AR_PHY_RX_DELAY) & AR_PHY_RX_DELAY_DELAY;
-	if (IS_CHAN_CCK(chan))
+	if (IS_CHAN_B(chan))
 		synthDelay = (4 * synthDelay) / 22;
 	else
 		synthDelay /= 10;
@@ -1648,7 +1649,7 @@ static struct ath9k_channel *ath9k_hw_check_chan(struct ath_hal *ah,
 	}
 
 	if (!IS_CHAN_OFDM(chan) &&
-	    !IS_CHAN_CCK(chan) &&
+	    !IS_CHAN_B(chan) &&
 	    !IS_CHAN_HT20(chan) &&
 	    !IS_CHAN_HT40(chan)) {
 		DPRINTF(ah->ah_sc, ATH_DBG_CHANNEL,
@@ -1712,7 +1713,7 @@ static bool ath9k_hw_channel_change(struct ath_hal *ah,
 	}
 
 	synthDelay = REG_READ(ah, AR_PHY_RX_DELAY) & AR_PHY_RX_DELAY_DELAY;
-	if (IS_CHAN_CCK(chan))
+	if (IS_CHAN_B(chan))
 		synthDelay = (4 * synthDelay) / 22;
 	else
 		synthDelay /= 10;
-- 
1.6.0.3

