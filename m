Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:19309 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752422Ab1JGLsX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Oct 2011 07:48:23 -0400
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: [PATCH 09/14] ath9k_hw: Fix ASPM L1 issue for AR9480
Date: Fri, 7 Oct 2011 17:17:14 +0530
Message-ID: <1317988039-28632-9-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20111007_134825_651334_A8E8FB0B)
In-Reply-To: <1317988039-28632-1-git-send-email-rmanohar@qca.qualcomm.com>
References: <1317988039-28632-1-git-send-email-rmanohar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Because of not clearing Bit 14 of AR_WA, the ASPM L1 is not
enabled when entering into sleep mode. AR9480 does not need
bit 14 to be set.

Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/hw.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 9c60132..1da6c9d 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -542,6 +542,9 @@ static int __ath9k_hw_init(struct ath_hw *ah)
 		return -EIO;
 	}
 
+	if (AR_SREV_9480(ah))
+		ah->WARegVal &= ~AR_WA_D3_L1_DISABLE;
+
 	ath9k_hw_init_defaults(ah);
 	ath9k_hw_init_config(ah);
 
@@ -1819,8 +1822,7 @@ static void ath9k_set_power_sleep(struct ath_hw *ah, int setChip)
 	}
 
 	/* Clear Bit 14 of AR_WA after putting chip into Full Sleep mode. */
-	if (!AR_SREV_9480(ah))
-		REG_WRITE(ah, AR_WA, ah->WARegVal & ~AR_WA_D3_L1_DISABLE);
+	REG_WRITE(ah, AR_WA, ah->WARegVal & ~AR_WA_D3_L1_DISABLE);
 }
 
 /*
-- 
1.7.7

