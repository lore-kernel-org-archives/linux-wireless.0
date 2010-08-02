Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:48357 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753252Ab0HBNxW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Aug 2010 09:53:22 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, lrodriguez@atheros.com
Subject: [PATCH 4/4] ath9k: shorten the calibration interval during strong interference
Date: Mon,  2 Aug 2010 15:53:15 +0200
Message-Id: <1280757195-9532-4-git-send-email-nbd@openwrt.org>
In-Reply-To: <1280757195-9532-3-git-send-email-nbd@openwrt.org>
References: <1280757195-9532-1-git-send-email-nbd@openwrt.org>
 <1280757195-9532-2-git-send-email-nbd@openwrt.org>
 <1280757195-9532-3-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When the noise floor limits are being bypassed because of strong
interference, sensitivity is also reduced.
In order to recover from this as quickly as possible, trigger a
long periodic calibration every second instead of every 30 seconds,
until the NF median is within limits again. This is especially important
if the interference lasts for a while, since it takes multiple clean
NF calibrations to bring the median back to normal.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ath9k.h |    1 +
 drivers/net/wireless/ath/ath9k/main.c  |    9 +++++++--
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 07f26ee..def0cd3 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -423,6 +423,7 @@ int ath_beaconq_config(struct ath_softc *sc);
 #define ATH_AP_SHORT_CALINTERVAL  100     /* 100 ms */
 #define ATH_ANI_POLLINTERVAL_OLD  100     /* 100 ms */
 #define ATH_ANI_POLLINTERVAL_NEW  1000    /* 1000 ms */
+#define ATH_LONG_CALINTERVAL_INT  1000    /* 1000 ms */
 #define ATH_LONG_CALINTERVAL      30000   /* 30 seconds */
 #define ATH_RESTART_CALINTERVAL   1200000 /* 20 minutes */
 
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 3caa323..ca80dbb 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -395,7 +395,12 @@ void ath_ani_calibrate(unsigned long data)
 	bool shortcal = false;
 	bool aniflag = false;
 	unsigned int timestamp = jiffies_to_msecs(jiffies);
-	u32 cal_interval, short_cal_interval;
+	u32 cal_interval, short_cal_interval, long_cal_interval;
+
+	if (ah->caldata && ah->caldata->nfcal_interference)
+		long_cal_interval = ATH_LONG_CALINTERVAL_INT;
+	else
+		long_cal_interval = ATH_LONG_CALINTERVAL;
 
 	short_cal_interval = (ah->opmode == NL80211_IFTYPE_AP) ?
 		ATH_AP_SHORT_CALINTERVAL : ATH_STA_SHORT_CALINTERVAL;
@@ -407,7 +412,7 @@ void ath_ani_calibrate(unsigned long data)
 	ath9k_ps_wakeup(sc);
 
 	/* Long calibration runs independently of short calibration. */
-	if ((timestamp - common->ani.longcal_timer) >= ATH_LONG_CALINTERVAL) {
+	if ((timestamp - common->ani.longcal_timer) >= long_cal_interval) {
 		longcal = true;
 		ath_print(common, ATH_DBG_ANI, "longcal @%lu\n", jiffies);
 		common->ani.longcal_timer = timestamp;
-- 
1.6.4.2

