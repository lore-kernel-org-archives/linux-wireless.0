Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:57270 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752608Ab1DSN7g (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Apr 2011 09:59:36 -0400
Received: from mail.atheros.com ([10.234.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 19 Apr 2011 06:59:10 -0700
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: linville@tuxdriver.com
CC: linux-wireless@vger.kernel.org
Subject: [PATCH V2 15/22] ath9k_hw: Configure tuning capacitance value for AR9340 as well
Date: Tue, 19 Apr 2011 19:29:13 +0530
Message-ID: <1303221560-25139-16-git-send-email-vasanth@atheros.com>
In-Reply-To: <1303221560-25139-1-git-send-email-vasanth@atheros.com>
References: <1303221560-25139-1-git-send-email-vasanth@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
index be673fd..a59f9c0 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
@@ -3755,7 +3755,7 @@ static void ath9k_hw_ar9300_set_board_values(struct ath_hw *ah,
 	ar9003_hw_atten_apply(ah, chan);
 	if (!AR_SREV_9340(ah))
 		ar9003_hw_internal_regulator_apply(ah);
-	if (AR_SREV_9485(ah))
+	if (AR_SREV_9485(ah) || AR_SREV_9340(ah))
 		ar9003_hw_apply_tuning_caps(ah);
 }
 
-- 
1.7.0.4

