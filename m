Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:54033 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754606AbZIIXo7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Sep 2009 19:44:59 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	devel@linuxdriverproject.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>
Subject: [PATCH 02/15] ath9k: move btcoex core driver info to its own struct
Date: Wed,  9 Sep 2009 19:44:48 -0400
Message-Id: <1252539901-20679-3-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1252539901-20679-1-git-send-email-lrodriguez@atheros.com>
References: <1252539901-20679-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There is some bluetooth coexistance data which is driver
specific, stuff that into its own structure.

Cc: Vasanthakumar Thiagarajan <vasanth@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h  |   11 +++++
 drivers/net/wireless/ath/ath9k/btcoex.c |   73 ++++++++++++++++---------------
 drivers/net/wireless/ath/ath9k/btcoex.h |   16 ++-----
 drivers/net/wireless/ath/ath9k/main.c   |    4 +-
 4 files changed, 55 insertions(+), 49 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 1d59f10..831874c 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -451,6 +451,16 @@ struct ath_ani {
 	struct timer_list timer;
 };
 
+struct ath_btcoex {
+	bool hw_timer_enabled;
+	spinlock_t btcoex_lock;
+	struct timer_list period_timer; /* Timer for BT period */
+	u32 bt_priority_cnt;
+	unsigned long bt_priority_time;
+	u32 btcoex_no_stomp; /* in usec */
+	u32 btcoex_period; /* in usec */
+};
+
 /********************/
 /*   LED Control    */
 /********************/
@@ -613,6 +623,7 @@ struct ath_softc {
 	struct ath_beacon_config cur_beacon_conf;
 	struct delayed_work tx_complete_work;
 	struct ath_btcoex_info btcoex_info;
+	struct ath_btcoex btcoex;
 };
 
 struct ath_wiphy {
diff --git a/drivers/net/wireless/ath/ath9k/btcoex.c b/drivers/net/wireless/ath/ath9k/btcoex.c
index e19a9c9..e88a0a3 100644
--- a/drivers/net/wireless/ath/ath9k/btcoex.c
+++ b/drivers/net/wireless/ath/ath9k/btcoex.c
@@ -48,14 +48,14 @@ bool ath_btcoex_supported(u16 subsysid)
  */
 static void ath_detect_bt_priority(struct ath_softc *sc)
 {
-	struct ath_btcoex_info *btinfo = &sc->btcoex_info;
+	struct ath_btcoex *btcoex = &sc->btcoex;
 
-	if (ath9k_hw_gpio_get(sc->sc_ah, btinfo->btpriority_gpio))
-		btinfo->bt_priority_cnt++;
+	if (ath9k_hw_gpio_get(sc->sc_ah, sc->btcoex_info.btpriority_gpio))
+		btcoex->bt_priority_cnt++;
 
-	if (time_after(jiffies, btinfo->bt_priority_time +
+	if (time_after(jiffies, btcoex->bt_priority_time +
 			msecs_to_jiffies(ATH_BT_PRIORITY_TIME_THRESHOLD))) {
-		if (btinfo->bt_priority_cnt >= ATH_BT_CNT_THRESHOLD) {
+		if (btcoex->bt_priority_cnt >= ATH_BT_CNT_THRESHOLD) {
 			DPRINTF(sc->sc_ah, ATH_DBG_BTCOEX,
 				"BT priority traffic detected");
 			sc->sc_flags |= SC_OP_BT_PRIORITY_DETECTED;
@@ -63,8 +63,8 @@ static void ath_detect_bt_priority(struct ath_softc *sc)
 			sc->sc_flags &= ~SC_OP_BT_PRIORITY_DETECTED;
 		}
 
-		btinfo->bt_priority_cnt = 0;
-		btinfo->bt_priority_time = jiffies;
+		btcoex->bt_priority_cnt = 0;
+		btcoex->bt_priority_time = jiffies;
 	}
 }
 
@@ -106,29 +106,30 @@ static void ath_btcoex_bt_stomp(struct ath_softc *sc,
 static void ath_btcoex_period_timer(unsigned long data)
 {
 	struct ath_softc *sc = (struct ath_softc *) data;
+	struct ath_btcoex *btcoex = &sc->btcoex;
 	struct ath_btcoex_info *btinfo = &sc->btcoex_info;
 
 	ath_detect_bt_priority(sc);
 
-	spin_lock_bh(&btinfo->btcoex_lock);
+	spin_lock_bh(&btcoex->btcoex_lock);
 
 	ath_btcoex_bt_stomp(sc, btinfo, btinfo->bt_stomp_type);
 
-	spin_unlock_bh(&btinfo->btcoex_lock);
+	spin_unlock_bh(&btcoex->btcoex_lock);
 
-	if (btinfo->btcoex_period != btinfo->btcoex_no_stomp) {
-		if (btinfo->hw_timer_enabled)
+	if (btcoex->btcoex_period != btcoex->btcoex_no_stomp) {
+		if (btcoex->hw_timer_enabled)
 			ath_gen_timer_stop(sc->sc_ah, btinfo->no_stomp_timer);
 
 		ath_gen_timer_start(sc->sc_ah,
 			btinfo->no_stomp_timer,
 			(ath9k_hw_gettsf32(sc->sc_ah) +
-				btinfo->btcoex_no_stomp),
-				btinfo->btcoex_no_stomp * 10);
-		btinfo->hw_timer_enabled = true;
+				btcoex->btcoex_no_stomp),
+				btcoex->btcoex_no_stomp * 10);
+		btcoex->hw_timer_enabled = true;
 	}
 
-	mod_timer(&btinfo->period_timer, jiffies +
+	mod_timer(&btcoex->period_timer, jiffies +
 				  msecs_to_jiffies(ATH_BTCOEX_DEF_BT_PERIOD));
 }
 
@@ -140,23 +141,25 @@ static void ath_btcoex_period_timer(unsigned long data)
 static void ath_btcoex_no_stomp_timer(void *arg)
 {
 	struct ath_softc *sc = (struct ath_softc *)arg;
+	struct ath_btcoex *btcoex = &sc->btcoex;
 	struct ath_btcoex_info *btinfo = &sc->btcoex_info;
 
 	DPRINTF(sc->sc_ah, ATH_DBG_BTCOEX, "no stomp timer running \n");
 
-	spin_lock_bh(&btinfo->btcoex_lock);
+	spin_lock_bh(&btcoex->btcoex_lock);
 
 	if (btinfo->bt_stomp_type == ATH_BTCOEX_STOMP_LOW)
 		ath_btcoex_bt_stomp(sc, btinfo, ATH_BTCOEX_STOMP_NONE);
 	 else if (btinfo->bt_stomp_type == ATH_BTCOEX_STOMP_ALL)
 		ath_btcoex_bt_stomp(sc, btinfo, ATH_BTCOEX_STOMP_LOW);
 
-	spin_unlock_bh(&btinfo->btcoex_lock);
+	spin_unlock_bh(&btcoex->btcoex_lock);
 }
 
 static int ath_init_btcoex_info(struct ath_hw *hw,
 				struct ath_btcoex_info *btcoex_info)
 {
+	struct ath_btcoex *btcoex = &hw->ah_sc->btcoex;
 	u32 i;
 	int qnum;
 
@@ -181,15 +184,15 @@ static int ath_init_btcoex_info(struct ath_hw *hw,
 
 	btcoex_info->bt_stomp_type = ATH_BTCOEX_STOMP_LOW;
 
-	btcoex_info->btcoex_period = ATH_BTCOEX_DEF_BT_PERIOD * 1000;
+	btcoex->btcoex_period = ATH_BTCOEX_DEF_BT_PERIOD * 1000;
 
-	btcoex_info->btcoex_no_stomp = (100 - ATH_BTCOEX_DEF_DUTY_CYCLE) *
-		btcoex_info->btcoex_period / 100;
+	btcoex->btcoex_no_stomp = (100 - ATH_BTCOEX_DEF_DUTY_CYCLE) *
+		btcoex->btcoex_period / 100;
 
 	for (i = 0; i < 32; i++)
 		hw->hw_gen_timers.gen_timer_index[(debruijn32 << i) >> 27] = i;
 
-	setup_timer(&btcoex_info->period_timer, ath_btcoex_period_timer,
+	setup_timer(&btcoex->period_timer, ath_btcoex_period_timer,
 			(unsigned long) hw->ah_sc);
 
 	btcoex_info->no_stomp_timer = ath_gen_timer_alloc(hw,
@@ -200,7 +203,7 @@ static int ath_init_btcoex_info(struct ath_hw *hw,
 	if (btcoex_info->no_stomp_timer == NULL)
 		return -ENOMEM;
 
-	spin_lock_init(&btcoex_info->btcoex_lock);
+	spin_lock_init(&btcoex->btcoex_lock);
 
 	return 0;
 }
@@ -307,34 +310,34 @@ void ath9k_hw_btcoex_disable(struct ath_hw *ah)
 /*
  * Pause btcoex timer and bt duty cycle timer
  */
-void ath_btcoex_timer_pause(struct ath_softc *sc,
-			    struct ath_btcoex_info *btinfo)
+void ath_btcoex_timer_pause(struct ath_softc *sc)
 {
+	struct ath_btcoex *btcoex = &sc->btcoex;
 
-	del_timer_sync(&btinfo->period_timer);
+	del_timer_sync(&btcoex->period_timer);
 
-	if (btinfo->hw_timer_enabled)
-		ath_gen_timer_stop(sc->sc_ah, btinfo->no_stomp_timer);
+	if (btcoex->hw_timer_enabled)
+		ath_gen_timer_stop(sc->sc_ah, sc->btcoex_info.no_stomp_timer);
 
-	btinfo->hw_timer_enabled = false;
+	btcoex->hw_timer_enabled = false;
 }
 
 /*
  * (Re)start btcoex timers
  */
-void ath_btcoex_timer_resume(struct ath_softc *sc,
-			     struct ath_btcoex_info *btinfo)
+void ath_btcoex_timer_resume(struct ath_softc *sc)
 {
+	struct ath_btcoex *btcoex = &sc->btcoex;
 
 	DPRINTF(sc->sc_ah, ATH_DBG_BTCOEX, "Starting btcoex timers");
 
 	/* make sure duty cycle timer is also stopped when resuming */
-	if (btinfo->hw_timer_enabled)
-		ath_gen_timer_stop(sc->sc_ah, btinfo->no_stomp_timer);
+	if (btcoex->hw_timer_enabled)
+		ath_gen_timer_stop(sc->sc_ah, sc->btcoex_info.no_stomp_timer);
 
-	btinfo->bt_priority_cnt = 0;
-	btinfo->bt_priority_time = jiffies;
+	btcoex->bt_priority_cnt = 0;
+	btcoex->bt_priority_time = jiffies;
 	sc->sc_flags &= ~SC_OP_BT_PRIORITY_DETECTED;
 
-	mod_timer(&btinfo->period_timer, jiffies);
+	mod_timer(&btcoex->period_timer, jiffies);
 }
diff --git a/drivers/net/wireless/ath/ath9k/btcoex.h b/drivers/net/wireless/ath/ath9k/btcoex.h
index 297b027..6cbbc14 100644
--- a/drivers/net/wireless/ath/ath9k/btcoex.h
+++ b/drivers/net/wireless/ath/ath9k/btcoex.h
@@ -70,13 +70,6 @@ struct ath_btcoex_info {
 	u32 bt_coex_mode; 	/* Register setting for AR_BT_COEX_MODE */
 	u32 bt_coex_weights; 	/* Register setting for AR_BT_COEX_WEIGHT */
 	u32 bt_coex_mode2; 	/* Register setting for AR_BT_COEX_MODE2 */
-	u32 btcoex_no_stomp;   /* in usec */
-	u32 btcoex_period;     	/* in usec */
-	u32 bt_priority_cnt;
-	unsigned long bt_priority_time;
-	bool hw_timer_enabled;
-	spinlock_t btcoex_lock;
-	struct timer_list period_timer;      /* Timer for BT period */
 	struct ath_gen_timer *no_stomp_timer; /*Timer for no BT stomping*/
 };
 
@@ -84,16 +77,15 @@ bool ath_btcoex_supported(u16 subsysid);
 int ath9k_hw_btcoex_init(struct ath_hw *ah);
 void ath9k_hw_btcoex_enable(struct ath_hw *ah);
 void ath9k_hw_btcoex_disable(struct ath_hw *ah);
-void ath_btcoex_timer_resume(struct ath_softc *sc,
-			     struct ath_btcoex_info *btinfo);
-void ath_btcoex_timer_pause(struct ath_softc *sc,
-			    struct ath_btcoex_info *btinfo);
+
+void ath_btcoex_timer_resume(struct ath_softc *sc);
+void ath_btcoex_timer_pause(struct ath_softc *sc);
 
 static inline void ath_btcoex_set_weight(struct ath_btcoex_info *btcoex_info,
 					 u32 bt_weight,
 					 u32 wlan_weight)
 {
-	btcoex_info->bt_coex_weights = SM(bt_weight, AR_BTCOEX_BT_WGHT) |
+		btcoex_info->bt_coex_weights = SM(bt_weight, AR_BTCOEX_BT_WGHT) |
 				       SM(wlan_weight, AR_BTCOEX_WL_WGHT);
 }
 
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 5e05e1d..7805323 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -2017,7 +2017,7 @@ static int ath9k_start(struct ieee80211_hw *hw)
 
 		ath_pcie_aspm_disable(sc);
 		if (sc->btcoex_info.btcoex_scheme == ATH_BTCOEX_CFG_3WIRE)
-			ath_btcoex_timer_resume(sc, &sc->btcoex_info);
+			ath_btcoex_timer_resume(sc);
 	}
 
 mutex_unlock:
@@ -2156,7 +2156,7 @@ static void ath9k_stop(struct ieee80211_hw *hw)
 	if (sc->sc_flags & SC_OP_BTCOEX_ENABLED) {
 		ath9k_hw_btcoex_disable(sc->sc_ah);
 		if (sc->btcoex_info.btcoex_scheme == ATH_BTCOEX_CFG_3WIRE)
-			ath_btcoex_timer_pause(sc, &sc->btcoex_info);
+			ath_btcoex_timer_pause(sc);
 	}
 
 	/* make sure h/w will not generate any interrupt
-- 
1.6.3.3

