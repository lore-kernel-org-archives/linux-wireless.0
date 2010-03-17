Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:26830 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755781Ab0CQV1J (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Mar 2010 17:27:09 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 17 Mar 2010 14:27:09 -0700
From: Senthil Balasubramanian <senthilkumar@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Sujith <Sujith.Manoharan@atheros.com>,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 03/12] ath9k_hw: skip chip tests for AR9271
Date: Wed, 17 Mar 2010 14:25:16 +0530
Message-ID: <1268816125-16173-4-git-send-email-senthilkumar@atheros.com>
In-Reply-To: <1268816125-16173-3-git-send-email-senthilkumar@atheros.com>
References: <1268816125-16173-1-git-send-email-senthilkumar@atheros.com>
 <1268816125-16173-2-git-send-email-senthilkumar@atheros.com>
 <1268816125-16173-3-git-send-email-senthilkumar@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith <Sujith.Manoharan@atheros.com>

The chip test is not required for AR9271 on the host driver
code as the firmware will do the test internally on its own.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/hw.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 7b1ba6f..b1a4a83 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -499,8 +499,10 @@ static int ath9k_hw_post_init(struct ath_hw *ah)
 {
 	int ecode;
 
-	if (!ath9k_hw_chip_test(ah))
-		return -ENODEV;
+	if (!AR_SREV_9271(ah)) {
+		if (!ath9k_hw_chip_test(ah))
+			return -ENODEV;
+	}
 
 	ecode = ath9k_hw_rf_claim(ah);
 	if (ecode != 0)
-- 
1.6.4.2

