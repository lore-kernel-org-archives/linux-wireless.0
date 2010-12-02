Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:59217 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757372Ab0LBLNj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Dec 2010 06:13:39 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 02 Dec 2010 03:13:24 -0800
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH V2 17/27] ath9k_hw: Configure attenuation control  only for supported chains
Date: Thu, 2 Dec 2010 03:07:01 -0800
Message-ID: <1291288031-3409-18-git-send-email-vasanth@atheros.com>
In-Reply-To: <1291288031-3409-1-git-send-email-vasanth@atheros.com>
References: <1291288031-3409-1-git-send-email-vasanth@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
index 9ce6846..133e142 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
@@ -3641,7 +3641,7 @@ static void ar9003_hw_atten_apply(struct ath_hw *ah, struct ath9k_channel *chan)
 					 };
 
 	/* Test value. if 0 then attenuation is unused. Don't load anything. */
-	for (i = 0; i < 3; i++) {
+	for (i = 0; i < ah->caps.max_rxchains; i++) {
 		value = ar9003_hw_atten_chain_get(ah, i, chan);
 		REG_RMW_FIELD(ah, ext_atten_reg[i],
 			      AR_PHY_EXT_ATTEN_CTL_XATTEN1_DB, value);
-- 
1.7.0.4

