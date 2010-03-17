Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:26833 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755869Ab0CQV1N (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Mar 2010 17:27:13 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 17 Mar 2010 14:27:13 -0700
From: Senthil Balasubramanian <senthilkumar@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Sujith <Sujith.Manoharan@atheros.com>,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 05/12] ath9k_hw: Fix full sleep setup for AR9271
Date: Wed, 17 Mar 2010 14:25:18 +0530
Message-ID: <1268816125-16173-6-git-send-email-senthilkumar@atheros.com>
In-Reply-To: <1268816125-16173-5-git-send-email-senthilkumar@atheros.com>
References: <1268816125-16173-1-git-send-email-senthilkumar@atheros.com>
 <1268816125-16173-2-git-send-email-senthilkumar@atheros.com>
 <1268816125-16173-3-git-send-email-senthilkumar@atheros.com>
 <1268816125-16173-4-git-send-email-senthilkumar@atheros.com>
 <1268816125-16173-5-git-send-email-senthilkumar@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith <Sujith.Manoharan@atheros.com>

After telling the AR9271 to go into full sleep we do not need
to clear the RTC reset signal.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/hw.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index b1a4a83..023c38b 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -2453,7 +2453,7 @@ static void ath9k_set_power_sleep(struct ath_hw *ah, int setChip)
 		if (!AR_SREV_9100(ah))
 			REG_WRITE(ah, AR_RC, AR_RC_AHB | AR_RC_HOSTIF);
 
-		if(!AR_SREV_5416(ah))
+		if (!AR_SREV_5416(ah) && !AR_SREV_9271(ah))
 			REG_CLR_BIT(ah, (AR_RTC_RESET),
 				    AR_RTC_RESET_EN);
 	}
-- 
1.6.4.2

