Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:32822 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755345AbbBBMsX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Feb 2015 07:48:23 -0500
Received: from [117.216.55.194] (port=15247 helo=sujith-pixel.qualcomm.com)
	by server72.web-hosting.com with esmtpsa (UNKNOWN:AES128-SHA256:128)
	(Exim 4.82)
	(envelope-from <sujith@msujith.org>)
	id 1YIGQQ-002djK-Ir
	for linux-wireless@vger.kernel.org; Mon, 02 Feb 2015 07:48:22 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 6/6] ath9k: Choose correct rate for 2GHz channel
Date: Mon,  2 Feb 2015 18:21:13 +0530
Message-Id: <1422881473-24580-7-git-send-email-sujith@msujith.org> (sfid-20150202_135429_650860_4D6ED4A3)
In-Reply-To: <1422881473-24580-1-git-send-email-sujith@msujith.org>
References: <1422881473-24580-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Set the transmit rate for the keep-alive frames
as 1M/CCK when the current channel is in the
2GHz band.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_wow.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_wow.c b/drivers/net/wireless/ath/ath9k/ar9003_wow.c
index 2dc50a0..86bfc96 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_wow.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_wow.c
@@ -62,11 +62,15 @@ static void ath9k_wow_create_keep_alive_pattern(struct ath_hw *ah)
 	/* set the transmit buffer */
 	ctl[0] = (KAL_FRAME_LEN | (MAX_RATE_POWER << 16));
 	ctl[1] = 0;
-	ctl[3] = 0xb;	/* OFDM_6M hardware value for this rate */
 	ctl[4] = 0;
 	ctl[7] = (ah->txchainmask) << 2;
 	ctl[2] = 0xf << 16; /* tx_tries 0 */
 
+	if (IS_CHAN_2GHZ(ah->curchan))
+		ctl[3] = 0x1b;	/* CCK_1M */
+	else
+		ctl[3] = 0xb;	/* OFDM_6M */
+
 	for (i = 0; i < KAL_NUM_DESC_WORDS; i++)
 		REG_WRITE(ah, (AR_WOW_KA_DESC_WORD2 + i * 4), ctl[i]);
 
-- 
2.2.2

