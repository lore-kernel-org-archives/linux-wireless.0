Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:34170 "EHLO
	mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751801AbcD1OqH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Apr 2016 10:46:07 -0400
Received: by mail-wm0-f67.google.com with SMTP id n129so14751051wmn.1
        for <linux-wireless@vger.kernel.org>; Thu, 28 Apr 2016 07:46:07 -0700 (PDT)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: linux-wireless@vger.kernel.org
Cc: ath9k-devel@lists.ath9k.org, kvalo@qca.qualcomm.com,
	ath9k-devel@qca.qualcomm.com,
	Helmut Schaa <helmut.schaa@googlemail.com>
Subject: [PATCH 3/3] ath9k: Simplify ar9003_hw_tx99_set_txpower
Date: Thu, 28 Apr 2016 16:45:06 +0200
Message-Id: <1461854706-10494-3-git-send-email-helmut.schaa@googlemail.com> (sfid-20160428_164612_629908_8873964C)
In-Reply-To: <1461854706-10494-1-git-send-email-helmut.schaa@googlemail.com>
References: <1461854706-10494-1-git-send-email-helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There's no need to keep the same for loop twice in the code.
Move the txpower cap before the loop to reduce code complexity.

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_phy.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.c b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
index 2f15cbc..81ab3ca 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
@@ -1844,13 +1844,9 @@ static void ar9003_hw_tx99_set_txpower(struct ath_hw *ah, u8 txpower)
 	static u8 p_pwr_array[ar9300RateSize] = { 0 };
 	unsigned int i;
 
-	if (txpower <= MAX_RATE_POWER) {
-		for (i = 0; i < ar9300RateSize; i++)
-			p_pwr_array[i] = txpower;
-	} else {
-		for (i = 0; i < ar9300RateSize; i++)
-			p_pwr_array[i] = MAX_RATE_POWER;
-	}
+	txpower = txpower <= MAX_RATE_POWER ? txpower : MAX_RATE_POWER;
+	for (i = 0; i < ar9300RateSize; i++)
+		p_pwr_array[i] = txpower;
 
 	ar9003_hw_tx_power_regwrite(ah, p_pwr_array);
 }
-- 
2.8.1

