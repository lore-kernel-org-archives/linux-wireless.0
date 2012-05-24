Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:65405 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751072Ab2EXEEB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 May 2012 00:04:01 -0400
From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20413.45810.196851.526473@gargle.gargle.HOWL> (sfid-20120524_060408_432629_F6DB5001)
Date: Thu, 24 May 2012 09:32:58 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH v2 11/22] ath9k: Use separate operational flags for BTCOEX
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h |   12 +++++++-----
 drivers/net/wireless/ath/ath9k/gpio.c  |   17 +++++++++--------
 2 files changed, 16 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 9400579..9c54d4c 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -441,7 +441,11 @@ void ath_start_ani(struct ath_common *common);
 /* BTCOEX */
 /**********/
 
+#define BT_OP_PRIORITY_DETECTED   BIT(0)
+#define BT_OP_SCAN                BIT(1)
+
 struct ath_btcoex {
+	u8 op_flags; /* BT_OP_* */
 	bool hw_timer_enabled;
 	spinlock_t btcoex_lock;
 	struct timer_list period_timer; /* Timer for BT period */
@@ -588,11 +592,9 @@ struct ath_ant_comb {
 #define SC_OP_BEACONS                BIT(1)
 #define SC_OP_RXFLUSH                BIT(2)
 #define SC_OP_TSF_RESET              BIT(3)
-#define SC_OP_BT_PRIORITY_DETECTED   BIT(4)
-#define SC_OP_BT_SCAN                BIT(5)
-#define SC_OP_ANI_RUN                BIT(6)
-#define SC_OP_PRIM_STA_VIF           BIT(7)
-#define SC_OP_HW_RESET               BIT(8)
+#define SC_OP_ANI_RUN                BIT(4)
+#define SC_OP_PRIM_STA_VIF           BIT(5)
+#define SC_OP_HW_RESET               BIT(6)
 
 /* Powersave flags */
 #define PS_WAIT_FOR_BEACON        BIT(0)
diff --git a/drivers/net/wireless/ath/ath9k/gpio.c b/drivers/net/wireless/ath/ath9k/gpio.c
index 281a9af..ab805be 100644
--- a/drivers/net/wireless/ath/ath9k/gpio.c
+++ b/drivers/net/wireless/ath/ath9k/gpio.c
@@ -132,17 +132,17 @@ static void ath_detect_bt_priority(struct ath_softc *sc)
 
 	if (time_after(jiffies, btcoex->bt_priority_time +
 			msecs_to_jiffies(ATH_BT_PRIORITY_TIME_THRESHOLD))) {
-		sc->sc_flags &= ~(SC_OP_BT_PRIORITY_DETECTED | SC_OP_BT_SCAN);
+		btcoex->op_flags &= ~(BT_OP_PRIORITY_DETECTED | BT_OP_SCAN);
 		/* Detect if colocated bt started scanning */
 		if (btcoex->bt_priority_cnt >= ATH_BT_CNT_SCAN_THRESHOLD) {
 			ath_dbg(ath9k_hw_common(sc->sc_ah), BTCOEX,
 				"BT scan detected\n");
-			sc->sc_flags |= (SC_OP_BT_SCAN |
-					 SC_OP_BT_PRIORITY_DETECTED);
+			btcoex->op_flags |= (BT_OP_SCAN |
+					     BT_OP_PRIORITY_DETECTED);
 		} else if (btcoex->bt_priority_cnt >= ATH_BT_CNT_THRESHOLD) {
 			ath_dbg(ath9k_hw_common(sc->sc_ah), BTCOEX,
 				"BT priority traffic detected\n");
-			sc->sc_flags |= SC_OP_BT_PRIORITY_DETECTED;
+			btcoex->op_flags |= BT_OP_PRIORITY_DETECTED;
 		}
 
 		btcoex->bt_priority_cnt = 0;
@@ -196,7 +196,7 @@ static void ath_btcoex_period_timer(unsigned long data)
 	ath9k_ps_wakeup(sc);
 	if (!(ah->caps.hw_caps & ATH9K_HW_CAP_MCI))
 		ath_detect_bt_priority(sc);
-	is_btscan = sc->sc_flags & SC_OP_BT_SCAN;
+	is_btscan = !!(btcoex->op_flags & BT_OP_SCAN);
 
 	spin_lock_bh(&btcoex->btcoex_lock);
 
@@ -233,7 +233,7 @@ static void ath_btcoex_no_stomp_timer(void *arg)
 	struct ath_hw *ah = sc->sc_ah;
 	struct ath_btcoex *btcoex = &sc->btcoex;
 	struct ath_common *common = ath9k_hw_common(ah);
-	bool is_btscan = sc->sc_flags & SC_OP_BT_SCAN;
+	bool is_btscan = !!(btcoex->op_flags & BT_OP_SCAN);
 
 	ath_dbg(common, BTCOEX, "no stomp timer running\n");
 
@@ -292,7 +292,7 @@ void ath9k_btcoex_timer_resume(struct ath_softc *sc)
 
 	btcoex->bt_priority_cnt = 0;
 	btcoex->bt_priority_time = jiffies;
-	sc->sc_flags &= ~(SC_OP_BT_PRIORITY_DETECTED | SC_OP_BT_SCAN);
+	btcoex->op_flags &= ~(BT_OP_PRIORITY_DETECTED | BT_OP_SCAN);
 
 	mod_timer(&btcoex->period_timer, jiffies);
 }
@@ -316,12 +316,13 @@ void ath9k_btcoex_timer_pause(struct ath_softc *sc)
 
 u16 ath9k_btcoex_aggr_limit(struct ath_softc *sc, u32 max_4ms_framelen)
 {
+	struct ath_btcoex *btcoex = &sc->btcoex;
 	struct ath_mci_profile *mci = &sc->btcoex.mci;
 	u16 aggr_limit = 0;
 
 	if ((sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_MCI) && mci->aggr_limit)
 		aggr_limit = (max_4ms_framelen * mci->aggr_limit) >> 4;
-	else if (sc->sc_flags & SC_OP_BT_PRIORITY_DETECTED)
+	else if (btcoex->op_flags & BT_OP_PRIORITY_DETECTED)
 		aggr_limit = min((max_4ms_framelen * 3) / 8,
 				 (u32)ATH_AMPDU_LIMIT_MAX);
 
-- 
1.7.10.2

