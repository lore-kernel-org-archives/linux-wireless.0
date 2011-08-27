Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:39076 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750871Ab1H0Fwa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 27 Aug 2011 01:52:30 -0400
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: [PATCH] ath9k_hw: Set default slottime as 9us
Date: Sat, 27 Aug 2011 11:22:59 +0530
Message-ID: <1314424379-1206-1-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20110827_075240_155609_571B0A16)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Initialize 9us slot time as that is what is used mostly
(for non-ERP cases) and also to be in sync with initvals.

Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/hw.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 0d7a5ee..05472c5 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -440,7 +440,7 @@ static void ath9k_hw_init_defaults(struct ath_hw *ah)
 	if (AR_SREV_9100(ah))
 		ah->sta_id1_defaults |= AR_STA_ID1_AR9100_BA_FIX;
 	ah->enable_32kHz_clock = DONT_USE_32KHZ;
-	ah->slottime = 20;
+	ah->slottime = ATH9K_SLOT_TIME_9;
 	ah->globaltxtimeout = (u32) -1;
 	ah->power_mode = ATH9K_PM_UNDEFINED;
 }
-- 
1.7.6.1

