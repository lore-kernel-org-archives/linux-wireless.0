Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:65042 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932590Ab0LTRho (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Dec 2010 12:37:44 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 20 Dec 2010 09:37:28 -0800
From: Senthil Balasubramanian <senthilkumar@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Senthil Balasubramanian <senthilkumar@atheros.com>,
	Stable Kernel <stable@kernel.org>
Subject: [PATCH 1/2] ath9k_hw: Fix incorrect macversion and macrev checks
Date: Mon, 20 Dec 2010 23:07:35 +0530
Message-ID: <1292866656-2253-1-git-send-email-senthilkumar@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There are few places where we are checking for macversion and revsions
before RTC is powered ON. However we are reading the macversion and
revisions only after RTC is powered ON and so both macversion and
revisions are actully zero and this leads to incorrect srev checks.

fix this by reading the macversion and revisisons even before we start
using them. There is no reason why should we delay reading this info
until RTC is powered on as this is just a register information.

Cc: Stable Kernel <stable@kernel.org>
Signed-off-by: Senthil Balasubramanian <senthilkumar@atheros.com>
---
 drivers/net/wireless/ath/ath9k/hw.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index ddda76f..c9b7f1e 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -1078,13 +1078,13 @@ static bool ath9k_hw_set_reset_power_on(struct ath_hw *ah)
 		return false;
 	}
 
-	ath9k_hw_read_revisions(ah);
-
 	return ath9k_hw_set_reset(ah, ATH9K_RESET_WARM);
 }
 
 static bool ath9k_hw_set_reset_reg(struct ath_hw *ah, u32 type)
 {
+	ath9k_hw_read_revisions(ah);
+
 	if (AR_SREV_9300_20_OR_LATER(ah)) {
 		REG_WRITE(ah, AR_WA, ah->WARegVal);
 		udelay(10);
-- 
1.7.3.4

