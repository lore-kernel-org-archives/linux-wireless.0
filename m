Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:46672 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754116Ab2FSJTM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Jun 2012 05:19:12 -0400
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: [PATCH] ath9k: do not sampling on ani timer when chip is in sleep
Date: Tue, 19 Jun 2012 14:50:28 +0530
Message-ID: <1340097628-3199-1-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20120619_111920_913774_A7228517)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The baseband and cycle counters are being sampled during ani
processing for debugging purpose. Whenever the ani is postponded
due to sleep state, taking samples on that time is of no use and
also unneccesarily waking up the chip might increase the power
consumption on idle associated state. Hence moving debug function
within powersave block.

Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/link.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/link.c b/drivers/net/wireless/ath/ath9k/link.c
index a105c94..91650fe 100644
--- a/drivers/net/wireless/ath/ath9k/link.c
+++ b/drivers/net/wireless/ath/ath9k/link.c
@@ -407,6 +407,7 @@ void ath_ani_calibrate(unsigned long data)
 		longcal ? "long" : "", shortcal ? "short" : "",
 		aniflag ? "ani" : "", common->ani.caldone ? "true" : "false");
 
+	ath9k_debug_samp_bb_mac(sc);
 	ath9k_ps_restore(sc);
 
 set_timer:
@@ -415,7 +416,6 @@ set_timer:
 	* The interval must be the shortest necessary to satisfy ANI,
 	* short calibration and long calibration.
 	*/
-	ath9k_debug_samp_bb_mac(sc);
 	cal_interval = ATH_LONG_CALINTERVAL;
 	if (sc->sc_ah->config.enable_ani)
 		cal_interval = min(cal_interval,
-- 
1.7.11

