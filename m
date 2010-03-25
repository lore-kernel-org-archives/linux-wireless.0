Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30g.wh2.ocn.ne.jp ([220.111.41.239]:10123 "HELO
	mail30g.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752506Ab0CYFtK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Mar 2010 01:49:10 -0400
Received: from vs3010.wh2.ocn.ne.jp (125.206.180.173)
	by mail30g.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 2-0812996148
	for <linux-wireless@vger.kernel.org>; Thu, 25 Mar 2010 14:49:09 +0900 (JST)
Subject: [PATCH 01/10] ath5k: remove static calibration interval variable
To: linville@tuxdriver.com
From: Bruno Randolf <br1@einfach.org>
Cc: linux-wireless@vger.kernel.org, bob@bobcopeland.com,
	ath5k-devel@lists.ath5k.org, lrodriguez@atheros.com,
	mickflemm@gmail.com
Date: Thu, 25 Mar 2010 14:49:03 +0900
Message-ID: <20100325054903.10697.14362.stgit@tt-desk>
In-Reply-To: <20100325054603.10697.48915.stgit@tt-desk>
References: <20100325054603.10697.48915.stgit@tt-desk>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove static variable ath5k_calinterval which was used as a constant. Use a
#define instead. Also we don't need ah_cal_intval.

Signed-off-by: Bruno Randolf <br1@einfach.org>
---
 drivers/net/wireless/ath/ath5k/ath5k.h |    4 +---
 drivers/net/wireless/ath/ath5k/base.c  |    4 ----
 drivers/net/wireless/ath/ath5k/phy.c   |    2 +-
 3 files changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/ath5k.h b/drivers/net/wireless/ath/ath5k/ath5k.h
index 1d7491c..a3019ee 100644
--- a/drivers/net/wireless/ath/ath5k/ath5k.h
+++ b/drivers/net/wireless/ath/ath5k/ath5k.h
@@ -202,6 +202,7 @@
 #define AR5K_TUNE_MAX_TXPOWER			63
 #define AR5K_TUNE_DEFAULT_TXPOWER		25
 #define AR5K_TUNE_TPC_TXPOWER			false
+#define ATH5K_TUNE_CALIBRATION_INTERVAL_FULL    10000   /* 10 sec */
 
 #define AR5K_INIT_CARR_SENSE_EN			1
 
@@ -1101,9 +1102,6 @@ struct ath5k_hw {
 	/* Calibration timestamp */
 	unsigned long		ah_cal_tstamp;
 
-	/* Calibration interval (secs) */
-	u8			ah_cal_intval;
-
 	/* Software interrupt mask */
 	u8			ah_swi_mask;
 
diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index b142a78..39d5800 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -59,7 +59,6 @@
 #include "reg.h"
 #include "debug.h"
 
-static u8 ath5k_calinterval = 10; /* Calibrate PHY every 10 secs (TODO: Fixme) */
 static int modparam_nohwcrypt;
 module_param_named(nohwcrypt, modparam_nohwcrypt, bool, S_IRUGO);
 MODULE_PARM_DESC(nohwcrypt, "Disable hardware encryption.");
@@ -2497,9 +2496,6 @@ ath5k_init(struct ath5k_softc *sc)
 	 */
 	ath5k_stop_locked(sc);
 
-	/* Set PHY calibration interval */
-	ah->ah_cal_intval = ath5k_calinterval;
-
 	/*
 	 * The basic interface to setting the hardware in a good
 	 * state is ``reset''.  On return the hardware is known to
diff --git a/drivers/net/wireless/ath/ath5k/phy.c b/drivers/net/wireless/ath/ath5k/phy.c
index 47f3679..07f59b1 100644
--- a/drivers/net/wireless/ath/ath5k/phy.c
+++ b/drivers/net/wireless/ath/ath5k/phy.c
@@ -1108,7 +1108,7 @@ ath5k_hw_calibration_poll(struct ath5k_hw *ah)
 	/* Calibration interval in jiffies */
 	unsigned long cal_intval;
 
-	cal_intval = msecs_to_jiffies(ah->ah_cal_intval * 1000);
+	cal_intval = msecs_to_jiffies(ATH5K_TUNE_CALIBRATION_INTERVAL_FULL);
 
 	/* Initialize timestamp if needed */
 	if (!ah->ah_cal_tstamp)

