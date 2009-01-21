Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:25627 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751499AbZAUN4u (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Jan 2009 08:56:50 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 21 Jan 2009 05:56:50 -0800
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Luis.Rodriguez@atheros.com>,
	<Jouni.Malinen@atheros.com>, <ath9k-devel@lists.ath9k.org>
Subject: [PATCH] ath9k: Remove unnecessary gpio configuration in ath9k_hw_reset()
Date: Wed, 21 Jan 2009 19:24:13 +0530
Message-ID: <1232546053-15453-1-git-send-email-vasanth@atheros.com> (sfid-20090121_145707_503612_C89D34AF)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
 drivers/net/wireless/ath9k/hw.c |   14 ++------------
 1 files changed, 2 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/ath9k/hw.c b/drivers/net/wireless/ath9k/hw.c
index baa7a7e..65e0d80 100644
--- a/drivers/net/wireless/ath9k/hw.c
+++ b/drivers/net/wireless/ath9k/hw.c
@@ -2255,18 +2255,8 @@ int ath9k_hw_reset(struct ath_hal *ah, struct ath9k_channel *chan,
 		return -EINVAL;
 	}
 
-	if (AR_SREV_9280_10_OR_LATER(ah)) {
-		REG_SET_BIT(ah, AR_GPIO_INPUT_EN_VAL,
-			    AR_GPIO_JTAG_DISABLE);
-
-		if (test_bit(ATH9K_MODE_11A, ah->ah_caps.wireless_modes)) {
-			if (IS_CHAN_5GHZ(chan))
-				ath9k_hw_set_gpio(ah, 9, 0);
-			else
-				ath9k_hw_set_gpio(ah, 9, 1);
-		}
-		ath9k_hw_cfg_output(ah, 9, AR_GPIO_OUTPUT_MUX_AS_OUTPUT);
-	}
+	if (AR_SREV_9280_10_OR_LATER(ah))
+		REG_SET_BIT(ah, AR_GPIO_INPUT_EN_VAL, AR_GPIO_JTAG_DISABLE);
 
 	r = ath9k_hw_process_ini(ah, chan, sc->tx_chan_width);
 	if (r)
-- 
1.5.5.1

