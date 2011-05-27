Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:34435 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751389Ab1E0PIk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 May 2011 11:08:40 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 27 May 2011 08:08:09 -0700
From: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <lrodriguez@atheros.com>,
	Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
Subject: [RFC] ath9k: make use of get_paprd_scale_factor helper
Date: Fri, 27 May 2011 20:38:15 +0530
Message-ID: <1306508895-22960-1-git-send-email-mshajakhan@atheros.com> (sfid-20110527_170843_864822_EB81FCC0)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>

Signed-off-by: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_paprd.c |   18 +++---------------
 1 files changed, 3 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_paprd.c b/drivers/net/wireless/ath/ath9k/ar9003_paprd.c
index e4d6a87..4985a81 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_paprd.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_paprd.c
@@ -46,11 +46,10 @@ EXPORT_SYMBOL(ar9003_paprd_enable);
 
 static int ar9003_get_training_power_2g(struct ath_hw *ah)
 {
-	struct ar9300_eeprom *eep = &ah->eeprom.ar9300_eep;
-	struct ar9300_modal_eep_header *hdr = &eep->modalHeader2G;
+	struct ath9k_channel *chan = ah->curchan;
 	unsigned int power, scale, delta;
 
-	scale = MS(le32_to_cpu(hdr->papdRateMaskHt20), AR9300_PAPRD_SCALE_1);
+	scale = ar9003_get_paprd_scale_factor(ah, chan);
 	power = REG_READ_FIELD(ah, AR_PHY_POWERTX_RATE5,
 			       AR_PHY_POWERTX_RATE5_POWERTXHT20_0);
 
@@ -67,21 +66,10 @@ static int ar9003_get_training_power_2g(struct ath_hw *ah)
 static int ar9003_get_training_power_5g(struct ath_hw *ah)
 {
 	struct ath_common *common = ath9k_hw_common(ah);
-	struct ar9300_eeprom *eep = &ah->eeprom.ar9300_eep;
-	struct ar9300_modal_eep_header *hdr = &eep->modalHeader5G;
 	struct ath9k_channel *chan = ah->curchan;
 	unsigned int power, scale, delta;
 
-	if (chan->channel >= 5700)
-		scale = MS(le32_to_cpu(hdr->papdRateMaskHt20),
-			   AR9300_PAPRD_SCALE_1);
-	else if (chan->channel >= 5400)
-		scale = MS(le32_to_cpu(hdr->papdRateMaskHt40),
-			   AR9300_PAPRD_SCALE_2);
-	else
-		scale = MS(le32_to_cpu(hdr->papdRateMaskHt40),
-			   AR9300_PAPRD_SCALE_1);
-
+	scale = ar9003_get_paprd_scale_factor(ah, chan);
 	if (IS_CHAN_HT40(chan))
 		power = REG_READ_FIELD(ah, AR_PHY_POWERTX_RATE8,
 			AR_PHY_POWERTX_RATE8_POWERTXHT40_5);
-- 
1.7.0.4

