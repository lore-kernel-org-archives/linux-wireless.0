Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:62182 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752455AbbHNFRC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Aug 2015 01:17:02 -0400
From: Oleksij Rempel <linux@rempel-privat.de>
To: ath9k-devel@qca.qualcomm.com, kvalo@codeaurora.org,
	linux-wireless@vger.kernel.org
Cc: Oleksij Rempel <linux@rempel-privat.de>
Subject: [PATCH v2] ath9k_htc: do ani shortcalibratio if we got -ETIMEDOUT
Date: Fri, 14 Aug 2015 07:16:39 +0200
Message-Id: <1439529399-3094-1-git-send-email-linux@rempel-privat.de> (sfid-20150814_071706_660994_8CB2ED5C)
In-Reply-To: <55CD7828.8020904@rempel-privat.de>
References: <55CD7828.8020904@rempel-privat.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

current code will handle -ETIMEDOUT as success which is probalbly wrong.

According to this comment I assume it is safe to handle -ETIMEDOUT as false:
drivers/net/wireless/ath/ath9k/calib.c
290         /*
291          * We timed out waiting for the noisefloor to load, probably due to an
292          * in-progress rx. Simply return here and allow the load plenty of time
293          * to complete before the next calibration interval.  We need to avoid
294          * trying to load -50 (which happens below) while the previous load is
295          * still in progress as this can cause rx deafness. Instead by returning
296          * here, the baseband nf cal will just be capped by our present
297          * noisefloor until the next calibration timer.
298          */

Since no other error wariants are present, this patch is checking only
for (ret <= 0).

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Oleksij Rempel <linux@rempel-privat.de>
---
 drivers/net/wireless/ath/ath9k/htc_drv_main.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
index dab1323..172a9ff 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
@@ -794,8 +794,11 @@ void ath9k_htc_ani_work(struct work_struct *work)
 		common->ani.longcal_timer = timestamp;
 	}
 
-	/* Short calibration applies only while caldone is false */
-	if (!common->ani.caldone) {
+	/*
+	 * Short calibration applies only while caldone
+	 * is false or -ETIMEDOUT
+	 */
+	if (common->ani.caldone <= 0) {
 		if ((timestamp - common->ani.shortcal_timer) >=
 		    short_cal_interval) {
 			shortcal = true;
@@ -844,7 +847,11 @@ set_timer:
 	*/
 	cal_interval = ATH_LONG_CALINTERVAL;
 	cal_interval = min(cal_interval, (u32)ATH_ANI_POLLINTERVAL);
-	if (!common->ani.caldone)
+	/*
+	 * Short calibration applies only while caldone
+	 * is false or -ETIMEDOUT
+	 */
+	if (common->ani.caldone <= 0)
 		cal_interval = min(cal_interval, (u32)short_cal_interval);
 
 	ieee80211_queue_delayed_work(common->hw, &priv->ani_work,
-- 
2.1.4

