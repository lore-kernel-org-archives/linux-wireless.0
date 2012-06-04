Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:29111 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752054Ab2FDK7G (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Jun 2012 06:59:06 -0400
From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20428.38070.104450.5245@gargle.gargle.HOWL> (sfid-20120604_125909_747914_84F03A33)
Date: Mon, 4 Jun 2012 16:27:58 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH v3 10/20] ath9k: Use separate operational flags for BTCOEX
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Also, use atomic operations to check the flags.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h |   12 ++++++++----
 drivers/net/wireless/ath/ath9k/gpio.c  |   23 ++++++++++++-----------
 2 files changed, 20 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index e204648..ee946b8 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -441,12 +441,18 @@ void ath_start_ani(struct ath_common *common);
 /* BTCOEX */
 /**********/
 
+enum bt_op_flags {
+	BT_OP_PRIORITY_DETECTED,
+	BT_OP_SCAN,
+};
+
 struct ath_btcoex {
 	bool hw_timer_enabled;
 	spinlock_t btcoex_lock;
 	struct timer_list period_timer; /* Timer for BT period */
 	u32 bt_priority_cnt;
 	unsigned long bt_priority_time;
+	unsigned long op_flags;
 	int bt_stomp_type; /* Types of BT stomping */
 	u32 btcoex_no_stomp; /* in usec */
 	u32 btcoex_period; /* in usec */
@@ -588,10 +594,8 @@ struct ath_ant_comb {
 #define SC_OP_BEACONS                BIT(1)
 #define SC_OP_RXFLUSH                BIT(2)
 #define SC_OP_TSF_RESET              BIT(3)
-#define SC_OP_BT_PRIORITY_DETECTED   BIT(4)
-#define SC_OP_BT_SCAN                BIT(5)
-#define SC_OP_ANI_RUN                BIT(6)
-#define SC_OP_PRIM_STA_VIF           BIT(7)
+#define SC_OP_ANI_RUN                BIT(4)
+#define SC_OP_PRIM_STA_VIF           BIT(5)
 
 /* Powersave flags */
 #define PS_WAIT_FOR_BEACON        BIT(0)
diff --git a/drivers/net/wireless/ath/ath9k/gpio.c b/drivers/net/wireless/ath/ath9k/gpio.c
index 281a9af..9397a6d 100644
--- a/drivers/net/wireless/ath/ath9k/gpio.c
+++ b/drivers/net/wireless/ath/ath9k/gpio.c
@@ -132,17 +132,18 @@ static void ath_detect_bt_priority(struct ath_softc *sc)
 
 	if (time_after(jiffies, btcoex->bt_priority_time +
 			msecs_to_jiffies(ATH_BT_PRIORITY_TIME_THRESHOLD))) {
-		sc->sc_flags &= ~(SC_OP_BT_PRIORITY_DETECTED | SC_OP_BT_SCAN);
+		clear_bit(BT_OP_PRIORITY_DETECTED, &btcoex->op_flags);
+		clear_bit(BT_OP_SCAN, &btcoex->op_flags);
 		/* Detect if colocated bt started scanning */
 		if (btcoex->bt_priority_cnt >= ATH_BT_CNT_SCAN_THRESHOLD) {
 			ath_dbg(ath9k_hw_common(sc->sc_ah), BTCOEX,
 				"BT scan detected\n");
-			sc->sc_flags |= (SC_OP_BT_SCAN |
-					 SC_OP_BT_PRIORITY_DETECTED);
+			set_bit(BT_OP_PRIORITY_DETECTED, &btcoex->op_flags);
+			set_bit(BT_OP_SCAN, &btcoex->op_flags);
 		} else if (btcoex->bt_priority_cnt >= ATH_BT_CNT_THRESHOLD) {
 			ath_dbg(ath9k_hw_common(sc->sc_ah), BTCOEX,
 				"BT priority traffic detected\n");
-			sc->sc_flags |= SC_OP_BT_PRIORITY_DETECTED;
+			set_bit(BT_OP_PRIORITY_DETECTED, &btcoex->op_flags);
 		}
 
 		btcoex->bt_priority_cnt = 0;
@@ -196,7 +197,7 @@ static void ath_btcoex_period_timer(unsigned long data)
 	ath9k_ps_wakeup(sc);
 	if (!(ah->caps.hw_caps & ATH9K_HW_CAP_MCI))
 		ath_detect_bt_priority(sc);
-	is_btscan = sc->sc_flags & SC_OP_BT_SCAN;
+	is_btscan = test_bit(BT_OP_SCAN, &btcoex->op_flags);
 
 	spin_lock_bh(&btcoex->btcoex_lock);
 
@@ -219,8 +220,7 @@ static void ath_btcoex_period_timer(unsigned long data)
 
 	ath9k_ps_restore(sc);
 	timer_period = btcoex->btcoex_period / 1000;
-	mod_timer(&btcoex->period_timer, jiffies +
-				  msecs_to_jiffies(timer_period));
+	mod_timer(&btcoex->period_timer, jiffies + msecs_to_jiffies(timer_period));
 }
 
 /*
@@ -233,14 +233,14 @@ static void ath_btcoex_no_stomp_timer(void *arg)
 	struct ath_hw *ah = sc->sc_ah;
 	struct ath_btcoex *btcoex = &sc->btcoex;
 	struct ath_common *common = ath9k_hw_common(ah);
-	bool is_btscan = sc->sc_flags & SC_OP_BT_SCAN;
 
 	ath_dbg(common, BTCOEX, "no stomp timer running\n");
 
 	ath9k_ps_wakeup(sc);
 	spin_lock_bh(&btcoex->btcoex_lock);
 
-	if (btcoex->bt_stomp_type == ATH_BTCOEX_STOMP_LOW || is_btscan)
+	if (btcoex->bt_stomp_type == ATH_BTCOEX_STOMP_LOW ||
+	    test_bit(BT_OP_SCAN, &btcoex->op_flags))
 		ath9k_hw_btcoex_bt_stomp(ah, ATH_BTCOEX_STOMP_NONE);
 	 else if (btcoex->bt_stomp_type == ATH_BTCOEX_STOMP_ALL)
 		ath9k_hw_btcoex_bt_stomp(ah, ATH_BTCOEX_STOMP_LOW);
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
+	else if (test_bit(BT_OP_PRIORITY_DETECTED, &btcoex->op_flags))
 		aggr_limit = min((max_4ms_framelen * 3) / 8,
 				 (u32)ATH_AMPDU_LIMIT_MAX);
 
-- 
1.7.10.3

