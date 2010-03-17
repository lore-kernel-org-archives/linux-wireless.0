Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:26848 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753132Ab0CQV1T (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Mar 2010 17:27:19 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 17 Mar 2010 14:27:19 -0700
From: Senthil Balasubramanian <senthilkumar@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Sujith <Sujith.Manoharan@atheros.com>,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 08/12] ath9k_hw: use the skip count for PA calibration on AR9271
Date: Wed, 17 Mar 2010 14:25:21 +0530
Message-ID: <1268816125-16173-9-git-send-email-senthilkumar@atheros.com>
In-Reply-To: <1268816125-16173-8-git-send-email-senthilkumar@atheros.com>
References: <1268816125-16173-1-git-send-email-senthilkumar@atheros.com>
 <1268816125-16173-2-git-send-email-senthilkumar@atheros.com>
 <1268816125-16173-3-git-send-email-senthilkumar@atheros.com>
 <1268816125-16173-4-git-send-email-senthilkumar@atheros.com>
 <1268816125-16173-5-git-send-email-senthilkumar@atheros.com>
 <1268816125-16173-6-git-send-email-senthilkumar@atheros.com>
 <1268816125-16173-7-git-send-email-senthilkumar@atheros.com>
 <1268816125-16173-8-git-send-email-senthilkumar@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith <Sujith.Manoharan@atheros.com>

Periodic power amplifier offset calibration is skipped on ath9k
algorithmically, this is required on AR9271.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/calib.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/calib.c b/drivers/net/wireless/ath/ath9k/calib.c
index e76dd74..d5026e4 100644
--- a/drivers/net/wireless/ath/ath9k/calib.c
+++ b/drivers/net/wireless/ath/ath9k/calib.c
@@ -1059,9 +1059,12 @@ bool ath9k_hw_calibrate(struct ath_hw *ah, struct ath9k_channel *chan,
 	/* Do NF cal only at longer intervals */
 	if (longcal) {
 		/* Do periodic PAOffset Cal */
-		if (AR_SREV_9271(ah))
-			ath9k_hw_9271_pa_cal(ah, false);
-		else if (AR_SREV_9285_11_OR_LATER(ah)) {
+		if (AR_SREV_9271(ah)) {
+			if (!ah->pacal_info.skipcount)
+				ath9k_hw_9271_pa_cal(ah, false);
+			else
+				ah->pacal_info.skipcount--;
+		} else if (AR_SREV_9285_11_OR_LATER(ah)) {
 			if (!ah->pacal_info.skipcount)
 				ath9k_hw_9285_pa_cal(ah, false);
 			else
-- 
1.6.4.2

