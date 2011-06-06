Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:49690 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753027Ab1FFRcl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Jun 2011 13:32:41 -0400
Received: from mail.atheros.com ([10.234.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 06 Jun 2011 10:32:08 -0700
From: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <lrodriguez@atheros.com>,
	Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
Subject: [PATCH] ath9k: make use of a helper to get paprd scale factor
Date: Mon, 6 Jun 2011 23:02:33 +0530
Message-ID: <1307381553-8980-1-git-send-email-mshajakhan@atheros.com> (sfid-20110606_193244_785659_0F317263)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>

Signed-off-by: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_paprd.c |   17 +++--------------
 1 files changed, 3 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_paprd.c b/drivers/net/wireless/ath/ath9k/ar9003_paprd.c
index fee38ce..2e7f0f2 100644
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
 
@@ -67,20 +66,10 @@ static int ar9003_get_training_power_2g(struct ath_hw *ah)
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
+	scale = ar9003_get_paprd_scale_factor(ah, chan);
 
 	if (IS_CHAN_HT40(chan))
 		power = REG_READ_FIELD(ah, AR_PHY_POWERTX_RATE8,
-- 
1.7.0.4

