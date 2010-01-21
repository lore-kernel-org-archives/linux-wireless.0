Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:62842 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751691Ab0AUFrc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jan 2010 00:47:32 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 20 Jan 2010 21:47:32 -0800
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH] ath9k: Fix wifi disconnection when collocated bt scan is active
Date: Thu, 21 Jan 2010 11:17:27 +0530
Message-ID: <1264052847-4735-1-git-send-email-vasanth@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

As all bt packets are priority traffic during bt scan, wifi
will get disconnected when bt scan lasts for few seconds. Fix
this by allocating 10% of bt period time (4.5ms) to wifi fully.

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h  |    2 ++
 drivers/net/wireless/ath/ath9k/btcoex.h |    2 ++
 drivers/net/wireless/ath/ath9k/gpio.c   |   30 ++++++++++++++++++++++--------
 drivers/net/wireless/ath/ath9k/reg.h    |    6 +++---
 4 files changed, 29 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index bf3d4c4..bdbcc70 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -364,6 +364,7 @@ struct ath_btcoex {
 	int bt_stomp_type; /* Types of BT stomping */
 	u32 btcoex_no_stomp; /* in usec */
 	u32 btcoex_period; /* in usec */
+	u32 btscan_no_stomp; /* in usec */
 	struct ath_gen_timer *no_stomp_timer; /* Timer for no BT stomping */
 };
 
@@ -429,6 +430,7 @@ void ath_deinit_leds(struct ath_softc *sc);
 #define SC_OP_SCANNING               BIT(10)
 #define SC_OP_TSF_RESET              BIT(11)
 #define SC_OP_BT_PRIORITY_DETECTED   BIT(12)
+#define SC_OP_BT_SCAN		     BIT(13)
 
 /* Powersave flags */
 #define PS_WAIT_FOR_BEACON        BIT(0)
diff --git a/drivers/net/wireless/ath/ath9k/btcoex.h b/drivers/net/wireless/ath/ath9k/btcoex.h
index 1ba31a7..1ee5a15 100644
--- a/drivers/net/wireless/ath/ath9k/btcoex.h
+++ b/drivers/net/wireless/ath/ath9k/btcoex.h
@@ -25,10 +25,12 @@
 
 #define ATH_BTCOEX_DEF_BT_PERIOD  45
 #define ATH_BTCOEX_DEF_DUTY_CYCLE 55
+#define ATH_BTCOEX_BTSCAN_DUTY_CYCLE 90
 #define ATH_BTCOEX_BMISS_THRESH   50
 
 #define ATH_BT_PRIORITY_TIME_THRESHOLD 1000 /* ms */
 #define ATH_BT_CNT_THRESHOLD	       3
+#define ATH_BT_CNT_SCAN_THRESHOLD      15
 
 enum ath_btcoex_scheme {
 	ATH_BTCOEX_CFG_NONE,
diff --git a/drivers/net/wireless/ath/ath9k/gpio.c b/drivers/net/wireless/ath/ath9k/gpio.c
index e204bd2..deab8be 100644
--- a/drivers/net/wireless/ath/ath9k/gpio.c
+++ b/drivers/net/wireless/ath/ath9k/gpio.c
@@ -230,12 +230,17 @@ static void ath_detect_bt_priority(struct ath_softc *sc)
 
 	if (time_after(jiffies, btcoex->bt_priority_time +
 			msecs_to_jiffies(ATH_BT_PRIORITY_TIME_THRESHOLD))) {
-		if (btcoex->bt_priority_cnt >= ATH_BT_CNT_THRESHOLD) {
+		sc->sc_flags &= ~(SC_OP_BT_PRIORITY_DETECTED | SC_OP_BT_SCAN);
+		/* Detect if colocated bt started scanning */
+		if (btcoex->bt_priority_cnt >= ATH_BT_CNT_SCAN_THRESHOLD) {
+			ath_print(ath9k_hw_common(sc->sc_ah), ATH_DBG_BTCOEX,
+				  "BT scan detected");
+			sc->sc_flags |= (SC_OP_BT_SCAN |
+					 SC_OP_BT_PRIORITY_DETECTED);
+		} else if (btcoex->bt_priority_cnt >= ATH_BT_CNT_THRESHOLD) {
 			ath_print(ath9k_hw_common(sc->sc_ah), ATH_DBG_BTCOEX,
 				  "BT priority traffic detected");
 			sc->sc_flags |= SC_OP_BT_PRIORITY_DETECTED;
-		} else {
-			sc->sc_flags &= ~SC_OP_BT_PRIORITY_DETECTED;
 		}
 
 		btcoex->bt_priority_cnt = 0;
@@ -316,12 +321,17 @@ static void ath_btcoex_period_timer(unsigned long data)
 	struct ath_softc *sc = (struct ath_softc *) data;
 	struct ath_hw *ah = sc->sc_ah;
 	struct ath_btcoex *btcoex = &sc->btcoex;
+	u32 timer_period;
+	bool is_btscan;
 
 	ath_detect_bt_priority(sc);
 
+	is_btscan = sc->sc_flags & SC_OP_BT_SCAN;
+
 	spin_lock_bh(&btcoex->btcoex_lock);
 
-	ath9k_btcoex_bt_stomp(sc, btcoex->bt_stomp_type);
+	ath9k_btcoex_bt_stomp(sc, is_btscan ? ATH_BTCOEX_STOMP_ALL :
+			      btcoex->bt_stomp_type);
 
 	spin_unlock_bh(&btcoex->btcoex_lock);
 
@@ -329,11 +339,12 @@ static void ath_btcoex_period_timer(unsigned long data)
 		if (btcoex->hw_timer_enabled)
 			ath9k_gen_timer_stop(ah, btcoex->no_stomp_timer);
 
+		timer_period = is_btscan ? btcoex->btscan_no_stomp :
+					   btcoex->btcoex_no_stomp;
 		ath9k_gen_timer_start(ah,
 				      btcoex->no_stomp_timer,
 				      (ath9k_hw_gettsf32(ah) +
-				       btcoex->btcoex_no_stomp),
-				       btcoex->btcoex_no_stomp * 10);
+				       timer_period), timer_period * 10);
 		btcoex->hw_timer_enabled = true;
 	}
 
@@ -350,13 +361,14 @@ static void ath_btcoex_no_stomp_timer(void *arg)
 	struct ath_softc *sc = (struct ath_softc *)arg;
 	struct ath_hw *ah = sc->sc_ah;
 	struct ath_btcoex *btcoex = &sc->btcoex;
+	bool is_btscan = sc->sc_flags & SC_OP_BT_SCAN;
 
 	ath_print(ath9k_hw_common(ah), ATH_DBG_BTCOEX,
 		  "no stomp timer running \n");
 
 	spin_lock_bh(&btcoex->btcoex_lock);
 
-	if (btcoex->bt_stomp_type == ATH_BTCOEX_STOMP_LOW)
+	if (btcoex->bt_stomp_type == ATH_BTCOEX_STOMP_LOW || is_btscan)
 		ath9k_btcoex_bt_stomp(sc, ATH_BTCOEX_STOMP_NONE);
 	 else if (btcoex->bt_stomp_type == ATH_BTCOEX_STOMP_ALL)
 		ath9k_btcoex_bt_stomp(sc, ATH_BTCOEX_STOMP_LOW);
@@ -371,6 +383,8 @@ int ath_init_btcoex_timer(struct ath_softc *sc)
 	btcoex->btcoex_period = ATH_BTCOEX_DEF_BT_PERIOD * 1000;
 	btcoex->btcoex_no_stomp = (100 - ATH_BTCOEX_DEF_DUTY_CYCLE) *
 		btcoex->btcoex_period / 100;
+	btcoex->btscan_no_stomp = (100 - ATH_BTCOEX_BTSCAN_DUTY_CYCLE) *
+				   btcoex->btcoex_period / 100;
 
 	setup_timer(&btcoex->period_timer, ath_btcoex_period_timer,
 			(unsigned long) sc);
@@ -405,7 +419,7 @@ void ath9k_btcoex_timer_resume(struct ath_softc *sc)
 
 	btcoex->bt_priority_cnt = 0;
 	btcoex->bt_priority_time = jiffies;
-	sc->sc_flags &= ~SC_OP_BT_PRIORITY_DETECTED;
+	sc->sc_flags &= ~(SC_OP_BT_PRIORITY_DETECTED | SC_OP_BT_SCAN);
 
 	mod_timer(&btcoex->period_timer, jiffies);
 }
diff --git a/drivers/net/wireless/ath/ath9k/reg.h b/drivers/net/wireless/ath/ath9k/reg.h
index 8e653fb..72cfa8e 100644
--- a/drivers/net/wireless/ath/ath9k/reg.h
+++ b/drivers/net/wireless/ath/ath9k/reg.h
@@ -1547,9 +1547,9 @@ enum {
 
 #define AR_BT_COEX_WEIGHT          0x8174
 #define AR_BT_COEX_WGHT		   0xff55
-#define AR_STOMP_ALL_WLAN_WGHT	   0xffcc
-#define AR_STOMP_LOW_WLAN_WGHT	   0xaaa8
-#define AR_STOMP_NONE_WLAN_WGHT	   0xaa00
+#define AR_STOMP_ALL_WLAN_WGHT	   0xfcfc
+#define AR_STOMP_LOW_WLAN_WGHT	   0xa8a8
+#define AR_STOMP_NONE_WLAN_WGHT	   0x0000
 #define AR_BTCOEX_BT_WGHT          0x0000ffff
 #define AR_BTCOEX_BT_WGHT_S        0
 #define AR_BTCOEX_WL_WGHT          0xffff0000
-- 
1.6.3.3

