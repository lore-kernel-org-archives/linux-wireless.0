Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:59980 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752064AbZESOC2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 May 2009 10:02:28 -0400
Message-Id: <20090519140221.003991008@atheros.com>
References: <20090519140137.708996030@atheros.com>
Date: Tue, 19 May 2009 17:01:39 +0300
From: Jouni Malinen <jouni.malinen@atheros.com>
To: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Jouni Malinen <jouni.malinen@atheros.com>
Subject: [PATCH 2/7] ath9k: Do not try to calibrate radio when in sleep mode
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When the chip is in sleep mode, there is no point trying to calibrate
the radio since it will just results in incorrect values being read
from registers and other potential issues. In addition, if we actually
start processing calibrate, do not allow the chip to be put into sleep
until we have completed the calibration step.

Signed-off-by: Jouni Malinen <jouni.malinen@atheros.com>

---
 drivers/net/wireless/ath/ath9k/main.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- wireless-testing.orig/drivers/net/wireless/ath/ath9k/main.c	2009-05-19 16:32:29.000000000 +0300
+++ wireless-testing/drivers/net/wireless/ath/ath9k/main.c	2009-05-19 16:32:31.000000000 +0300
@@ -329,6 +329,12 @@ static void ath_ani_calibrate(unsigned l
 	if (sc->sc_flags & SC_OP_SCANNING)
 		goto set_timer;
 
+	/* Only calibrate if awake */
+	if (sc->sc_ah->power_mode != ATH9K_PM_AWAKE)
+		goto set_timer;
+
+	ath9k_ps_wakeup(sc);
+
 	/* Long calibration runs independently of short calibration. */
 	if ((timestamp - sc->ani.longcal_timer) >= ATH_LONG_CALINTERVAL) {
 		longcal = true;
@@ -380,6 +386,8 @@ static void ath_ani_calibrate(unsigned l
 		}
 	}
 
+	ath9k_ps_restore(sc);
+
 set_timer:
 	/*
 	* Set timer interval based on previous results.

-- 

-- 
Jouni Malinen                                            PGP id EFC895FA
