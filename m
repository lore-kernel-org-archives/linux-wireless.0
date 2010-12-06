Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:36120 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751695Ab0LFMbr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Dec 2010 07:31:47 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 06 Dec 2010 04:31:32 -0800
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH V3 17/27] ath9k_hw: Configure attenuation control  only for supported chains
Date: Mon, 6 Dec 2010 04:27:50 -0800
Message-ID: <1291638480-8950-18-git-send-email-vasanth@atheros.com>
In-Reply-To: <1291638480-8950-1-git-send-email-vasanth@atheros.com>
References: <1291638480-8950-1-git-send-email-vasanth@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
index 17d22a2..96478a9 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
@@ -3644,7 +3644,7 @@ static void ar9003_hw_atten_apply(struct ath_hw *ah, struct ath9k_channel *chan)
 					 };
 
 	/* Test value. if 0 then attenuation is unused. Don't load anything. */
-	for (i = 0; i < 3; i++) {
+	for (i = 0; i < ah->caps.max_rxchains; i++) {
 		value = ar9003_hw_atten_chain_get(ah, i, chan);
 		REG_RMW_FIELD(ah, ext_atten_reg[i],
 			      AR_PHY_EXT_ATTEN_CTL_XATTEN1_DB, value);
-- 
1.7.0.4

