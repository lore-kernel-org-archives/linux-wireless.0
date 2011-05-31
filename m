Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from phoenix3.szarvasnet.hu ([87.101.127.16]:53503 "EHLO
	phoenix3.szarvasnet.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758244Ab1EaTrv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 May 2011 15:47:51 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [RFC 16/32] ath9k: skip internal regulator configuration for AR9330
Date: Tue, 31 May 2011 21:37:07 +0200
Message-Id: <1306870643-7935-17-git-send-email-juhosg@openwrt.org> (sfid-20110531_214807_798398_4669A0AF)
In-Reply-To: <1306870643-7935-1-git-send-email-juhosg@openwrt.org>
References: <1306870643-7935-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
index 729534c..6021186 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
@@ -3795,7 +3795,7 @@ static void ath9k_hw_ar9300_set_board_values(struct ath_hw *ah,
 	ar9003_hw_ant_ctrl_apply(ah, IS_CHAN_2GHZ(chan));
 	ar9003_hw_drive_strength_apply(ah);
 	ar9003_hw_atten_apply(ah, chan);
-	if (!AR_SREV_9340(ah))
+	if (!AR_SREV_9330(ah) && !AR_SREV_9340(ah))
 		ar9003_hw_internal_regulator_apply(ah);
 	if (AR_SREV_9485(ah) || AR_SREV_9340(ah))
 		ar9003_hw_apply_tuning_caps(ah);
-- 
1.7.2.1

