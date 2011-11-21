Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:59610 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754576Ab1KUAtZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Nov 2011 19:49:25 -0500
Received: by mail-gx0-f174.google.com with SMTP id r5so1781850ggn.19
        for <linux-wireless@vger.kernel.org>; Sun, 20 Nov 2011 16:49:25 -0800 (PST)
From: Nikolay Martynov <mar.kolya@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	rodrigue@qca.qualcomm.com, Nikolay Martynov <mar.kolya@gmail.com>
Subject: [PATCH 2/4] ath9k: change calibration debug to log all calibration types
Date: Sun, 20 Nov 2011 19:48:58 -0500
Message-Id: <1321836540-5325-3-git-send-email-mar.kolya@gmail.com> (sfid-20111121_014928_180779_2FA6DF4C)
In-Reply-To: <1321836540-5325-1-git-send-email-mar.kolya@gmail.com>
References: <1321836540-5325-1-git-send-email-mar.kolya@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

---
 drivers/net/wireless/ath/ath9k/main.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index e43c41c..9ce3dff 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -561,7 +561,6 @@ void ath_ani_calibrate(unsigned long data)
 	/* Long calibration runs independently of short calibration. */
 	if ((timestamp - common->ani.longcal_timer) >= long_cal_interval) {
 		longcal = true;
-		ath_dbg(common, ATH_DBG_ANI, "longcal @%lu\n", jiffies);
 		common->ani.longcal_timer = timestamp;
 	}
 
@@ -569,8 +568,6 @@ void ath_ani_calibrate(unsigned long data)
 	if (!common->ani.caldone) {
 		if ((timestamp - common->ani.shortcal_timer) >= short_cal_interval) {
 			shortcal = true;
-			ath_dbg(common, ATH_DBG_ANI,
-				"shortcal @%lu\n", jiffies);
 			common->ani.shortcal_timer = timestamp;
 			common->ani.resetcal_timer = timestamp;
 		}
@@ -605,6 +602,11 @@ void ath_ani_calibrate(unsigned long data)
 						ah->rxchainmask, longcal);
 	}
 
+        ath_dbg(common, ATH_DBG_ANI,
+                "Calibration @%lu finished: %s %s %s, caldone: %s\n", jiffies,
+                longcal ? "long" : "", shortcal ? "short" : "",
+                aniflag ? "ani" : "", common->ani.caldone ? "true" : "false");
+
 	ath9k_ps_restore(sc);
 
 set_timer:
-- 
1.7.4.1

