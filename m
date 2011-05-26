Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:37188 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756835Ab1EZGLj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 May 2011 02:11:39 -0400
Received: from mail.atheros.com ([10.234.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 25 May 2011 23:11:07 -0700
From: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <lrodriguez@atheros.com>,
	Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
Subject: [PATCH] ath9k: better position PAPRD debug message
Date: Thu, 26 May 2011 11:41:13 +0530
Message-ID: <1306390273-7721-1-git-send-email-mshajakhan@atheros.com> (sfid-20110526_081142_255376_C278D9D9)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>

the training power calculation indirectly depends on target power under
some scenarios, unless we have a valid training power, the PAPRD frames
won't be sent out. so when we get an invalid training power, its better
to display them before returning back.

Signed-off-by: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_paprd.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_paprd.c b/drivers/net/wireless/ath/ath9k/ar9003_paprd.c
index e4d6a87..fee38ce 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_paprd.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_paprd.c
@@ -119,15 +119,16 @@ static int ar9003_paprd_setup_single_table(struct ath_hw *ah)
 	else
 		training_power = ar9003_get_training_power_5g(ah);
 
+	ath_dbg(common, ATH_DBG_CALIBRATE,
+		"Training power: %d, Target power: %d\n",
+		training_power, ah->paprd_target_power);
+
 	if (training_power < 0) {
 		ath_dbg(common, ATH_DBG_CALIBRATE,
 			"PAPRD target power delta out of range");
 		return -ERANGE;
 	}
 	ah->paprd_training_power = training_power;
-	ath_dbg(common, ATH_DBG_CALIBRATE,
-		"Training power: %d, Target power: %d\n",
-		ah->paprd_training_power, ah->paprd_target_power);
 
 	REG_RMW_FIELD(ah, AR_PHY_PAPRD_AM2AM, AR_PHY_PAPRD_AM2AM_MASK,
 		      ah->paprd_ratemask);
-- 
1.7.0.4

