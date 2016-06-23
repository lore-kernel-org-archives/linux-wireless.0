Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:36072 "EHLO
	mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750950AbcFWO5l (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Jun 2016 10:57:41 -0400
Received: by mail-wm0-f66.google.com with SMTP id c82so11661088wme.3
        for <linux-wireless@vger.kernel.org>; Thu, 23 Jun 2016 07:57:40 -0700 (PDT)
From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To: ath9k-devel@qca.qualcomm.com, linux-wireless@vger.kernel.org,
	ath9k-devel@lists.ath9k.org
Cc: nbd@nbd.name,
	Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH 2/6] ath9k: remove variable which is set but never read
Date: Thu, 23 Jun 2016 16:57:10 +0200
Message-Id: <20160623145714.20576-3-martin.blumenstingl@googlemail.com> (sfid-20160623_165750_300425_F502EC10)
In-Reply-To: <20160623145714.20576-1-martin.blumenstingl@googlemail.com>
References: <20160623145714.20576-1-martin.blumenstingl@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

No functional changes - this only removes a variable which is set but
never read.

Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
---
 drivers/net/wireless/ath/ath9k/hw.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 8b2895f..4f98ca0 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -474,15 +474,12 @@ static void ath9k_hw_init_defaults(struct ath_hw *ah)
 static int ath9k_hw_init_macaddr(struct ath_hw *ah)
 {
 	struct ath_common *common = ath9k_hw_common(ah);
-	u32 sum;
 	int i;
 	u16 eeval;
 	static const u32 EEP_MAC[] = { EEP_MAC_LSW, EEP_MAC_MID, EEP_MAC_MSW };
 
-	sum = 0;
 	for (i = 0; i < 3; i++) {
 		eeval = ah->eep_ops->get_eeprom(ah, EEP_MAC[i]);
-		sum += eeval;
 		common->macaddr[2 * i] = eeval >> 8;
 		common->macaddr[2 * i + 1] = eeval & 0xff;
 	}
-- 
2.9.0

