Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f53.google.com ([209.85.216.53]:63297 "EHLO
	mail-qw0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755864Ab1LCDjm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Dec 2011 22:39:42 -0500
Received: by mail-qw0-f53.google.com with SMTP id b15so1643606qad.19
        for <linux-wireless@vger.kernel.org>; Fri, 02 Dec 2011 19:39:42 -0800 (PST)
From: Nikolay Martynov <mar.kolya@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Nikolay Martynov <mar.kolya@gmail.com>
Subject: [PATCH v4 2/4] ath9k: change calibration debug log to output all calibration types
Date: Fri,  2 Dec 2011 22:39:15 -0500
Message-Id: <1322883557-14120-3-git-send-email-mar.kolya@gmail.com> (sfid-20111203_043953_859680_72CEF88D)
In-Reply-To: <1322883557-14120-1-git-send-email-mar.kolya@gmail.com>
References: <1322883557-14120-1-git-send-email-mar.kolya@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

  To help debugging write a log entry when long calibration, short
calibration or ANI is performed.

Signed-off-by: Nikolay Martynov <mar.kolya@gmail.com>
---
 drivers/net/wireless/ath/ath9k/main.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index fd59c1f..461afb9 100644
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
 
+	ath_dbg(common, ATH_DBG_ANI,
+		"Calibration @%lu finished: %s %s %s, caldone: %s\n", jiffies,
+		longcal ? "long" : "", shortcal ? "short" : "",
+		aniflag ? "ani" : "", common->ani.caldone ? "true" : "false");
+
 	ath9k_ps_restore(sc);
 
 set_timer:
-- 
1.7.4.1

