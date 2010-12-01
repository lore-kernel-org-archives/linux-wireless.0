Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:13852 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752967Ab0LAHem (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Dec 2010 02:34:42 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 30 Nov 2010 23:34:28 -0800
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 16/26] ath9k_hw: Configure attenuation control only for chain 0 on AR9485
Date: Tue, 30 Nov 2010 23:32:45 -0800
Message-ID: <1291188775-13707-17-git-send-email-vasanth@atheros.com>
In-Reply-To: <1291188775-13707-1-git-send-email-vasanth@atheros.com>
References: <1291188775-13707-1-git-send-email-vasanth@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
index 9ce6846..71316ec 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
@@ -3639,9 +3639,13 @@ static void ar9003_hw_atten_apply(struct ath_hw *ah, struct ath9k_channel *chan)
 					  AR_PHY_EXT_ATTEN_CTL_1,
 					  AR_PHY_EXT_ATTEN_CTL_2,
 					 };
+	u8 max_chains = AR9300_MAX_CHAINS;
+
+	if (AR_SREV_9485(ah))
+		max_chains = 1;
 
 	/* Test value. if 0 then attenuation is unused. Don't load anything. */
-	for (i = 0; i < 3; i++) {
+	for (i = 0; i < max_chains; i++) {
 		value = ar9003_hw_atten_chain_get(ah, i, chan);
 		REG_RMW_FIELD(ah, ext_atten_reg[i],
 			      AR_PHY_EXT_ATTEN_CTL_XATTEN1_DB, value);
-- 
1.7.0.4

