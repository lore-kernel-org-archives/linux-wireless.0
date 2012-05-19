Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:41423 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932657Ab2ESIoq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 May 2012 04:44:46 -0400
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: [PATCH v2 09/10] ath9k: always perform ani calibration at poll interval
Date: Sat, 19 May 2012 14:13:55 +0530
Message-ID: <1337417036-1431-9-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20120519_104453_785835_D3BAA9E0)
In-Reply-To: <1337417036-1431-1-git-send-email-rmanohar@qca.qualcomm.com>
References: <1337417036-1431-1-git-send-email-rmanohar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Skiping the ani based on power state is delaying the ani cycles
further on an idle state. And also as the power state is updated
in different contexts, let us not skip the ani calibration.

Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/main.c |    5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 66ea3df..8be8243 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -549,10 +549,6 @@ void ath_ani_calibrate(unsigned long data)
 	short_cal_interval = (ah->opmode == NL80211_IFTYPE_AP) ?
 		ATH_AP_SHORT_CALINTERVAL : ATH_STA_SHORT_CALINTERVAL;
 
-	/* Only calibrate if awake */
-	if (sc->sc_ah->power_mode != ATH9K_PM_AWAKE)
-		goto set_timer;
-
 	ath9k_ps_wakeup(sc);
 
 	/* Long calibration runs independently of short calibration. */
@@ -608,7 +604,6 @@ void ath_ani_calibrate(unsigned long data)
 
 	ath9k_ps_restore(sc);
 
-set_timer:
 	/*
 	* Set timer interval based on previous results.
 	* The interval must be the shortest necessary to satisfy ANI,
-- 
1.7.10.2

