Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:13957 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932834Ab1ESJgL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 May 2011 05:36:11 -0400
Received: from mail.atheros.com ([10.234.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 19 May 2011 02:35:40 -0700
From: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <lrodriguez@atheros.com>,
	"Mohammed Shafi Shajakhan" <mshajakhan@atheros.com>
Subject: [PATCH] ath9k: remove redundant if check
Date: Thu, 19 May 2011 15:05:46 +0530
Message-ID: <1305797746-5357-1-git-send-email-mshajakhan@atheros.com> (sfid-20110519_113614_152270_9DBBE71C)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>

Signed-off-by: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/main.c |   29 ++++++++++++-----------------
 1 files changed, 12 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index a198ee3..dbd7c86 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -515,24 +515,19 @@ void ath_ani_calibrate(unsigned long data)
 		common->ani.checkani_timer = timestamp;
 	}
 
-	/* Skip all processing if there's nothing to do. */
-	if (longcal || shortcal || aniflag) {
-		/* Call ANI routine if necessary */
-		if (aniflag) {
-			spin_lock_irqsave(&common->cc_lock, flags);
-			ath9k_hw_ani_monitor(ah, ah->curchan);
-			ath_update_survey_stats(sc);
-			spin_unlock_irqrestore(&common->cc_lock, flags);
-		}
+	/* Call ANI routine if necessary */
+	if (aniflag) {
+		spin_lock_irqsave(&common->cc_lock, flags);
+		ath9k_hw_ani_monitor(ah, ah->curchan);
+		ath_update_survey_stats(sc);
+		spin_unlock_irqrestore(&common->cc_lock, flags);
+	}
 
-		/* Perform calibration if necessary */
-		if (longcal || shortcal) {
-			common->ani.caldone =
-				ath9k_hw_calibrate(ah,
-						   ah->curchan,
-						   common->rx_chainmask,
-						   longcal);
-		}
+	/* Perform calibration if necessary */
+	if (longcal || shortcal) {
+		common->ani.caldone =
+			ath9k_hw_calibrate(ah, ah->curchan,
+						common->rx_chainmask, longcal);
 	}
 
 	ath9k_ps_restore(sc);
-- 
1.7.0.4

