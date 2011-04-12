Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:38920 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750720Ab1DLNSW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Apr 2011 09:18:22 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 12 Apr 2011 06:17:56 -0700
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 10/22] ath9k_hw: Configure RF channel freqency for AR9340
Date: Tue, 12 Apr 2011 18:47:46 +0530
Message-ID: <1302614273-2063-6-git-send-email-vasanth@atheros.com>
In-Reply-To: <1302614273-2063-1-git-send-email-vasanth@atheros.com>
References: <1302614273-2063-1-git-send-email-vasanth@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_phy.c |   23 ++++++++++++++++++++---
 1 files changed, 20 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.c b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
index 65c52b4..1ec0d72 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
@@ -86,14 +86,31 @@ static int ar9003_hw_set_channel(struct ath_hw *ah, struct ath9k_channel *chan)
 			channelSel = (freq * 4) / 120;
 			chan_frac = (((freq * 4) % 120) * 0x20000) / 120;
 			channelSel = (channelSel << 17) | chan_frac;
+		} else if (AR_SREV_9340(ah)) {
+			if (ah->is_clk_25mhz) {
+				u32 chan_frac;
+
+				channelSel = (freq * 2) / 75;
+				chan_frac = (((freq * 2) % 75) * 0x20000) / 75;
+				channelSel = (channelSel << 17) | chan_frac;
+			} else
+				channelSel = CHANSEL_2G(freq) >> 1;
 		} else
 			channelSel = CHANSEL_2G(freq);
 		/* Set to 2G mode */
 		bMode = 1;
 	} else {
-		channelSel = CHANSEL_5G(freq);
-		/* Doubler is ON, so, divide channelSel by 2. */
-		channelSel >>= 1;
+		if (AR_SREV_9340(ah) && ah->is_clk_25mhz) {
+			u32 chan_frac;
+
+			channelSel = (freq * 2) / 75;
+			chan_frac = ((freq % 75) * 0x20000) / 75;
+			channelSel = (channelSel << 17) | chan_frac;
+		} else {
+			channelSel = CHANSEL_5G(freq);
+			/* Doubler is ON, so, divide channelSel by 2. */
+			channelSel >>= 1;
+		}
 		/* Set to 5G mode */
 		bMode = 0;
 	}
-- 
1.7.0.4

