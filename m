Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:38922 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753790Ab1DLNSd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Apr 2011 09:18:33 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 12 Apr 2011 06:18:08 -0700
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 14/22] ath9k_hw: Skip internal regulator configuration for AR9340
Date: Tue, 12 Apr 2011 18:47:48 +0530
Message-ID: <1302614273-2063-8-git-send-email-vasanth@atheros.com>
In-Reply-To: <1302614273-2063-1-git-send-email-vasanth@atheros.com>
References: <1302614273-2063-1-git-send-email-vasanth@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
index 685ce91..6e5baa7 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
@@ -3753,7 +3753,8 @@ static void ath9k_hw_ar9300_set_board_values(struct ath_hw *ah,
 	ar9003_hw_ant_ctrl_apply(ah, IS_CHAN_2GHZ(chan));
 	ar9003_hw_drive_strength_apply(ah);
 	ar9003_hw_atten_apply(ah, chan);
-	ar9003_hw_internal_regulator_apply(ah);
+	if (!AR_SREV_9340(ah))
+		ar9003_hw_internal_regulator_apply(ah);
 	if (AR_SREV_9485(ah))
 		ar9003_hw_apply_tuning_caps(ah);
 }
-- 
1.7.0.4

