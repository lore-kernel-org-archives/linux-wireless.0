Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:26180 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751899Ab1JMFUY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Oct 2011 01:20:24 -0400
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>,
	<stable@kernel.org>
Subject: [PATCH v2] ath9k_hw: Fix ASPM L1 issue for AR9480
Date: Thu, 13 Oct 2011 10:49:13 +0530
Message-ID: <1318483153-14268-1-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20111013_072037_083109_E8A50FAC)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Because of not clearing Bit 14 of AR_WA, the ASPM L1 is not
enabled when entering into sleep mode. AR9480 does not need
bit 14 to be set.

Cc: stable@kernel.org
Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/hw.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index fd7c207..58794a4 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -541,6 +541,9 @@ static int __ath9k_hw_init(struct ath_hw *ah)
 		return -EIO;
 	}
 
+	if (AR_SREV_9480(ah))
+		ah->WARegVal &= ~AR_WA_D3_L1_DISABLE;
+
 	ath9k_hw_init_defaults(ah);
 	ath9k_hw_init_config(ah);
 
@@ -1776,8 +1779,7 @@ static void ath9k_set_power_sleep(struct ath_hw *ah, int setChip)
 	}
 
 	/* Clear Bit 14 of AR_WA after putting chip into Full Sleep mode. */
-	if (!AR_SREV_9480(ah))
-		REG_WRITE(ah, AR_WA, ah->WARegVal & ~AR_WA_D3_L1_DISABLE);
+	REG_WRITE(ah, AR_WA, ah->WARegVal & ~AR_WA_D3_L1_DISABLE);
 }
 
 /*
-- 
1.7.7

