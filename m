Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:37396 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754965Ab3JJMPW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Oct 2013 08:15:22 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com
Subject: [PATCH 04/10] ath9k_hw: remove IS_CHAN_OFDM()
Date: Thu, 10 Oct 2013 14:15:06 +0200
Message-Id: <1381407312-72719-4-git-send-email-nbd@openwrt.org> (sfid-20131010_141537_978259_F9530696)
In-Reply-To: <1381407312-72719-1-git-send-email-nbd@openwrt.org>
References: <1381407312-72719-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The hardware is always configured with OFDM support enabled

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/hw.c | 8 ++------
 drivers/net/wireless/ath/ath9k/hw.h | 1 -
 2 files changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 34c8e2e..40a1132 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -1544,9 +1544,7 @@ static bool ath9k_hw_channel_change(struct ath_hw *ah,
 	ath9k_hw_set_clockrate(ah);
 	ath9k_hw_apply_txpower(ah, chan, false);
 
-	if (IS_CHAN_OFDM(chan) || IS_CHAN_HT(chan))
-		ath9k_hw_set_delta_slope(ah, chan);
-
+	ath9k_hw_set_delta_slope(ah, chan);
 	ath9k_hw_spur_mitigate_freq(ah, chan);
 
 	if (band_switch || ini_reloaded)
@@ -1981,9 +1979,7 @@ int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_channel *chan,
 
 	ath9k_hw_init_mfp(ah);
 
-	if (IS_CHAN_OFDM(chan) || IS_CHAN_HT(chan))
-		ath9k_hw_set_delta_slope(ah, chan);
-
+	ath9k_hw_set_delta_slope(ah, chan);
 	ath9k_hw_spur_mitigate_freq(ah, chan);
 	ah->eep_ops->set_board_values(ah, chan);
 
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index eaaf98b..0e44693 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -445,7 +445,6 @@ struct ath9k_channel {
        (((_c)->channelFlags & CHANNEL_G_HT20) == CHANNEL_G_HT20) || \
        (((_c)->channelFlags & CHANNEL_G_HT40PLUS) == CHANNEL_G_HT40PLUS) || \
        (((_c)->channelFlags & CHANNEL_G_HT40MINUS) == CHANNEL_G_HT40MINUS))
-#define IS_CHAN_OFDM(_c) (((_c)->channelFlags & CHANNEL_OFDM) != 0)
 #define IS_CHAN_5GHZ(_c) (((_c)->channelFlags & CHANNEL_5GHZ) != 0)
 #define IS_CHAN_2GHZ(_c) (((_c)->channelFlags & CHANNEL_2GHZ) != 0)
 #define IS_CHAN_HALF_RATE(_c) (((_c)->channelFlags & CHANNEL_HALF) != 0)
-- 
1.8.0.2

