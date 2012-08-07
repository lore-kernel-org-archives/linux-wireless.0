Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:48877 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758270Ab2HHN47 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Aug 2012 09:56:59 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, mcgrof@qca.qualcomm.com
Subject: [PATCH 3.6 2/4] ath9k_hw: clear the AM2PM predistortion mask on AR933x
Date: Tue,  7 Aug 2012 15:06:10 +0200
Message-Id: <1344344772-49459-2-git-send-email-nbd@openwrt.org> (sfid-20120808_155706_495161_34C13214)
In-Reply-To: <1344344772-49459-1-git-send-email-nbd@openwrt.org>
References: <1344344772-49459-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

That predistortion type is not supported

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ar9003_paprd.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_paprd.c b/drivers/net/wireless/ath/ath9k/ar9003_paprd.c
index 2c9f7d7..2173bd7 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_paprd.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_paprd.c
@@ -142,6 +142,7 @@ static int ar9003_paprd_setup_single_table(struct ath_hw *ah)
 	};
 	int training_power;
 	int i, val;
+	u32 am2pm_mask = ah->paprd_ratemask;
 
 	if (IS_CHAN_2GHZ(ah->curchan))
 		training_power = ar9003_get_training_power_2g(ah);
@@ -158,10 +159,13 @@ static int ar9003_paprd_setup_single_table(struct ath_hw *ah)
 	}
 	ah->paprd_training_power = training_power;
 
+	if (AR_SREV_9330(ah))
+		am2pm_mask = 0;
+
 	REG_RMW_FIELD(ah, AR_PHY_PAPRD_AM2AM, AR_PHY_PAPRD_AM2AM_MASK,
 		      ah->paprd_ratemask);
 	REG_RMW_FIELD(ah, AR_PHY_PAPRD_AM2PM, AR_PHY_PAPRD_AM2PM_MASK,
-		      ah->paprd_ratemask);
+		      am2pm_mask);
 	REG_RMW_FIELD(ah, AR_PHY_PAPRD_HT40, AR_PHY_PAPRD_HT40_MASK,
 		      ah->paprd_ratemask_ht40);
 
-- 
1.7.9.6 (Apple Git-31.1)

