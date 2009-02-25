Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:39116 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750733AbZBYFBo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Feb 2009 00:01:44 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 24 Feb 2009 21:01:43 -0800
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Luis.Rodriguez@atheros.com>,
	<Jouni.Malinen@atheros.com>, <ath9k-devel@lists.ath9k.org>
Subject: [PATCH] ath9k: Configure Power control register appropriately for h/w with 4k eeprom
Date: Wed, 25 Feb 2009 10:28:22 +0530
Message-ID: <1235537903-5551-1-git-send-email-vasanth@atheros.com> (sfid-20090225_060148_804562_643136F0)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
 drivers/net/wireless/ath9k/eeprom.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath9k/eeprom.c b/drivers/net/wireless/ath9k/eeprom.c
index 17b3d04..b1cf590 100644
--- a/drivers/net/wireless/ath9k/eeprom.c
+++ b/drivers/net/wireless/ath9k/eeprom.c
@@ -752,8 +752,7 @@ static bool ath9k_hw_set_4k_power_cal_table(struct ath_hw *ah,
 		      xpdGainValues[0]);
 	REG_RMW_FIELD(ah, AR_PHY_TPCRG1, AR_PHY_TPCRG1_PD_GAIN_2,
 		      xpdGainValues[1]);
-	REG_RMW_FIELD(ah, AR_PHY_TPCRG1, AR_PHY_TPCRG1_PD_GAIN_3,
-		      xpdGainValues[2]);
+	REG_RMW_FIELD(ah, AR_PHY_TPCRG1, AR_PHY_TPCRG1_PD_GAIN_3, 0);
 
 	for (i = 0; i < AR5416_MAX_CHAINS; i++) {
 		if (AR_SREV_5416_V20_OR_LATER(ah) &&
-- 
1.5.5.1

