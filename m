Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:44376 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751331Ab1EIE7J (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 May 2011 00:59:09 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Sun, 08 May 2011 21:58:40 -0700
From: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <lrodriguez@atheros.com>,
	Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
Subject: [PATCH] ath9k_hw: remove get_channel_noise function
Date: Mon, 9 May 2011 10:29:01 +0530
Message-ID: <1304917141-5379-1-git-send-email-mshajakhan@atheros.com> (sfid-20110509_065925_733543_EB233ABA)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>

currently ath9k_hw_getchan_noise is not used anywhere

Signed-off-by: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/calib.c |    8 --------
 drivers/net/wireless/ath/ath9k/calib.h |    1 -
 2 files changed, 0 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/calib.c b/drivers/net/wireless/ath/ath9k/calib.c
index fe3c10e..558b228 100644
--- a/drivers/net/wireless/ath/ath9k/calib.c
+++ b/drivers/net/wireless/ath/ath9k/calib.c
@@ -409,14 +409,6 @@ void ath9k_init_nfcal_hist_buffer(struct ath_hw *ah,
 	}
 }
 
-s16 ath9k_hw_getchan_noise(struct ath_hw *ah, struct ath9k_channel *chan)
-{
-	if (!ah->curchan || !ah->curchan->noisefloor)
-		return ath9k_hw_get_default_nf(ah, chan);
-
-	return ah->curchan->noisefloor;
-}
-EXPORT_SYMBOL(ath9k_hw_getchan_noise);
 
 void ath9k_hw_bstuck_nfcal(struct ath_hw *ah)
 {
diff --git a/drivers/net/wireless/ath/ath9k/calib.h b/drivers/net/wireless/ath/ath9k/calib.h
index b8973eb..4420780 100644
--- a/drivers/net/wireless/ath/ath9k/calib.h
+++ b/drivers/net/wireless/ath/ath9k/calib.h
@@ -106,7 +106,6 @@ bool ath9k_hw_getnf(struct ath_hw *ah, struct ath9k_channel *chan);
 void ath9k_init_nfcal_hist_buffer(struct ath_hw *ah,
 				  struct ath9k_channel *chan);
 void ath9k_hw_bstuck_nfcal(struct ath_hw *ah);
-s16 ath9k_hw_getchan_noise(struct ath_hw *ah, struct ath9k_channel *chan);
 void ath9k_hw_reset_calibration(struct ath_hw *ah,
 				struct ath9k_cal_list *currCal);
 
-- 
1.7.0.4

