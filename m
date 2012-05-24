Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:65331 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751137Ab2EXEFB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 May 2012 00:05:01 -0400
From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20413.45867.862989.977871@gargle.gargle.HOWL> (sfid-20120524_060506_506155_2F530EA6)
Date: Thu, 24 May 2012 09:33:55 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH v2 20/22] ath9k: always perform ani calibration at poll
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>

Skiping the ani based on power state is delaying the ani cycles
further on an idle state. And also as the power state is updated
in different contexts, let us not skip the ani calibration.

Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/main.c |    5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 3e8bef8..b9c9f4c 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -554,10 +554,6 @@ void ath_ani_calibrate(unsigned long data)
 	short_cal_interval = (ah->opmode == NL80211_IFTYPE_AP) ?
 		ATH_AP_SHORT_CALINTERVAL : ATH_STA_SHORT_CALINTERVAL;
 
-	/* Only calibrate if awake */
-	if (sc->sc_ah->power_mode != ATH9K_PM_AWAKE)
-		goto set_timer;
-
 	ath9k_ps_wakeup(sc);
 
 	/* Long calibration runs independently of short calibration. */
@@ -613,7 +609,6 @@ void ath_ani_calibrate(unsigned long data)
 
 	ath9k_ps_restore(sc);
 
-set_timer:
 	/*
 	* Set timer interval based on previous results.
 	* The interval must be the shortest necessary to satisfy ANI,
-- 
1.7.10.2

