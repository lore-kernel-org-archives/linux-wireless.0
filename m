Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:54047 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754685AbZIIXo7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Sep 2009 19:44:59 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	devel@linuxdriverproject.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 05/15] ath9k: move driver core helpers to main.c
Date: Wed,  9 Sep 2009 19:44:51 -0400
Message-Id: <1252539901-20679-6-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1252539901-20679-1-git-send-email-lrodriguez@atheros.com>
References: <1252539901-20679-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Keep on btcoex.c only hardware access helpers, move the
driver core specific code to main.c. To accomplish
this we had to split ath_init_btcoex_info() into two parts,
the driver core part -- ath_init_btcoex_timer() and the hw
specific part -- ath9k_hw_init_btcoex_hw_info(). This
highlights how ath_gen_timer is part of the driver core, not
hw related, so stuff that into ath_btcoex struct.

The ath9k_hw_btcoex_init() code is now put inline on
ath_init_softc() through a switch to it easier to follow,
since we did that we can now call ath_tx_get_qnum() from
the main.c instead of btcoex.c

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h  |    1 +
 drivers/net/wireless/ath/ath9k/btcoex.c |  214 +------------------------------
 drivers/net/wireless/ath/ath9k/btcoex.h |    7 +-
 drivers/net/wireless/ath/ath9k/hw.h     |    3 -
 drivers/net/wireless/ath/ath9k/main.c   |  215 ++++++++++++++++++++++++++++++-
 5 files changed, 218 insertions(+), 222 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index e8a630c..f001cc2 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -458,6 +458,7 @@ struct ath_btcoex {
 	unsigned long bt_priority_time;
 	u32 btcoex_no_stomp; /* in usec */
 	u32 btcoex_period; /* in usec */
+	struct ath_gen_timer *no_stomp_timer; /* Timer for no BT stomping */
 };
 
 /********************/
diff --git a/drivers/net/wireless/ath/ath9k/btcoex.c b/drivers/net/wireless/ath/ath9k/btcoex.c
index be69924..6209a56 100644
--- a/drivers/net/wireless/ath/ath9k/btcoex.c
+++ b/drivers/net/wireless/ath/ath9k/btcoex.c
@@ -43,144 +43,10 @@ bool ath_btcoex_supported(u16 subsysid)
 	return false;
 }
 
-static void ath_btcoex_set_weight(struct ath_btcoex_info *btcoex_info,
-				  u32 bt_weight,
-				  u32 wlan_weight)
+void ath9k_hw_init_btcoex_hw_info(struct ath_hw *ah, int qnum)
 {
-	btcoex_info->bt_coex_weights = SM(bt_weight, AR_BTCOEX_BT_WGHT) |
-				       SM(wlan_weight, AR_BTCOEX_WL_WGHT);
-}
-
-void ath9k_hw_btcoex_init_weight(struct ath_hw *ah)
-{
-	ath_btcoex_set_weight(&ah->btcoex_info, AR_BT_COEX_WGHT,
-			      AR_STOMP_LOW_WLAN_WGHT);
-}
-
-/*
- * Detects if there is any priority bt traffic
- */
-static void ath_detect_bt_priority(struct ath_softc *sc)
-{
-	struct ath_btcoex *btcoex = &sc->btcoex;
-	struct ath_hw *ah = sc->sc_ah;
-
-	if (ath9k_hw_gpio_get(sc->sc_ah, ah->btcoex_info.btpriority_gpio))
-		btcoex->bt_priority_cnt++;
-
-	if (time_after(jiffies, btcoex->bt_priority_time +
-			msecs_to_jiffies(ATH_BT_PRIORITY_TIME_THRESHOLD))) {
-		if (btcoex->bt_priority_cnt >= ATH_BT_CNT_THRESHOLD) {
-			DPRINTF(sc->sc_ah, ATH_DBG_BTCOEX,
-				"BT priority traffic detected");
-			sc->sc_flags |= SC_OP_BT_PRIORITY_DETECTED;
-		} else {
-			sc->sc_flags &= ~SC_OP_BT_PRIORITY_DETECTED;
-		}
-
-		btcoex->bt_priority_cnt = 0;
-		btcoex->bt_priority_time = jiffies;
-	}
-}
-
-/*
- * Configures appropriate weight based on stomp type.
- */
-static void ath_btcoex_bt_stomp(struct ath_softc *sc,
-				struct ath_btcoex_info *btinfo,
-				int stomp_type)
-{
-
-	switch (stomp_type) {
-	case ATH_BTCOEX_STOMP_ALL:
-		ath_btcoex_set_weight(btinfo, AR_BT_COEX_WGHT,
-				      AR_STOMP_ALL_WLAN_WGHT);
-		break;
-	case ATH_BTCOEX_STOMP_LOW:
-		ath_btcoex_set_weight(btinfo, AR_BT_COEX_WGHT,
-				      AR_STOMP_LOW_WLAN_WGHT);
-		break;
-	case ATH_BTCOEX_STOMP_NONE:
-		ath_btcoex_set_weight(btinfo, AR_BT_COEX_WGHT,
-				      AR_STOMP_NONE_WLAN_WGHT);
-		break;
-	default:
-		DPRINTF(sc->sc_ah, ATH_DBG_BTCOEX, "Invalid Stomptype\n");
-		break;
-	}
-
-	ath9k_hw_btcoex_enable(sc->sc_ah);
-}
-
-/*
- * This is the master bt coex timer which runs for every
- * 45ms, bt traffic will be given priority during 55% of this
- * period while wlan gets remaining 45%
- */
-
-static void ath_btcoex_period_timer(unsigned long data)
-{
-	struct ath_softc *sc = (struct ath_softc *) data;
-	struct ath_hw *ah = sc->sc_ah;
-	struct ath_btcoex *btcoex = &sc->btcoex;
-	struct ath_btcoex_info *btinfo = &ah->btcoex_info;
-
-	ath_detect_bt_priority(sc);
-
-	spin_lock_bh(&btcoex->btcoex_lock);
-
-	ath_btcoex_bt_stomp(sc, btinfo, btinfo->bt_stomp_type);
-
-	spin_unlock_bh(&btcoex->btcoex_lock);
-
-	if (btcoex->btcoex_period != btcoex->btcoex_no_stomp) {
-		if (btcoex->hw_timer_enabled)
-			ath_gen_timer_stop(ah, btinfo->no_stomp_timer);
-
-		ath_gen_timer_start(ah,
-			btinfo->no_stomp_timer,
-			(ath9k_hw_gettsf32(sc->sc_ah) +
-				btcoex->btcoex_no_stomp),
-				btcoex->btcoex_no_stomp * 10);
-		btcoex->hw_timer_enabled = true;
-	}
-
-	mod_timer(&btcoex->period_timer, jiffies +
-				  msecs_to_jiffies(ATH_BTCOEX_DEF_BT_PERIOD));
-}
-
-/*
- * Generic tsf based hw timer which configures weight
- * registers to time slice between wlan and bt traffic
- */
-
-static void ath_btcoex_no_stomp_timer(void *arg)
-{
-	struct ath_softc *sc = (struct ath_softc *)arg;
-	struct ath_hw *ah = sc->sc_ah;
-	struct ath_btcoex *btcoex = &sc->btcoex;
-	struct ath_btcoex_info *btinfo = &ah->btcoex_info;
-
-	DPRINTF(ah, ATH_DBG_BTCOEX, "no stomp timer running \n");
-
-	spin_lock_bh(&btcoex->btcoex_lock);
-
-	if (btinfo->bt_stomp_type == ATH_BTCOEX_STOMP_LOW)
-		ath_btcoex_bt_stomp(sc, btinfo, ATH_BTCOEX_STOMP_NONE);
-	 else if (btinfo->bt_stomp_type == ATH_BTCOEX_STOMP_ALL)
-		ath_btcoex_bt_stomp(sc, btinfo, ATH_BTCOEX_STOMP_LOW);
-
-	spin_unlock_bh(&btcoex->btcoex_lock);
-}
-
-static int ath_init_btcoex_info(struct ath_hw *ah,
-				struct ath_btcoex_info *btcoex_info)
-{
-	struct ath_btcoex *btcoex = &ah->ah_sc->btcoex;
+	struct ath_btcoex_info *btcoex_info = &ah->btcoex_info;
 	u32 i;
-	int qnum;
-
-	qnum = ath_tx_get_qnum(ah->ah_sc, ATH9K_TX_QUEUE_DATA, ATH9K_WME_AC_BE);
 
 	btcoex_info->bt_coex_mode =
 		(btcoex_info->bt_coex_mode & AR_BT_QCU_THRESH) |
@@ -201,31 +67,11 @@ static int ath_init_btcoex_info(struct ath_hw *ah,
 
 	btcoex_info->bt_stomp_type = ATH_BTCOEX_STOMP_LOW;
 
-	btcoex->btcoex_period = ATH_BTCOEX_DEF_BT_PERIOD * 1000;
-
-	btcoex->btcoex_no_stomp = (100 - ATH_BTCOEX_DEF_DUTY_CYCLE) *
-		btcoex->btcoex_period / 100;
-
 	for (i = 0; i < 32; i++)
 		ah->hw_gen_timers.gen_timer_index[(debruijn32 << i) >> 27] = i;
-
-	setup_timer(&btcoex->period_timer, ath_btcoex_period_timer,
-			(unsigned long) ah->ah_sc);
-
-	btcoex_info->no_stomp_timer = ath_gen_timer_alloc(ah,
-			ath_btcoex_no_stomp_timer,
-			ath_btcoex_no_stomp_timer,
-			(void *)ah->ah_sc, AR_FIRST_NDP_TIMER);
-
-	if (btcoex_info->no_stomp_timer == NULL)
-		return -ENOMEM;
-
-	spin_lock_init(&btcoex->btcoex_lock);
-
-	return 0;
 }
 
-static void ath9k_hw_btcoex_init_2wire(struct ath_hw *ah)
+void ath9k_hw_btcoex_init_2wire(struct ath_hw *ah)
 {
 	struct ath_btcoex_info *btcoex_info = &ah->btcoex_info;
 
@@ -246,7 +92,7 @@ static void ath9k_hw_btcoex_init_2wire(struct ath_hw *ah)
 	ath9k_hw_cfg_gpio_input(ah, btcoex_info->btactive_gpio);
 }
 
-static void ath9k_hw_btcoex_init_3wire(struct ath_hw *ah)
+void ath9k_hw_btcoex_init_3wire(struct ath_hw *ah)
 {
 	struct ath_btcoex_info *btcoex_info = &ah->btcoex_info;
 
@@ -271,21 +117,6 @@ static void ath9k_hw_btcoex_init_3wire(struct ath_hw *ah)
 	ath9k_hw_cfg_gpio_input(ah, btcoex_info->btpriority_gpio);
 }
 
-int ath9k_hw_btcoex_init(struct ath_hw *ah)
-{
-	struct ath_btcoex_info *btcoex_info = &ah->btcoex_info;
-	int ret = 0;
-
-	if (btcoex_info->btcoex_scheme == ATH_BTCOEX_CFG_2WIRE)
-		ath9k_hw_btcoex_init_2wire(ah);
-	else {
-		ath9k_hw_btcoex_init_3wire(ah);
-		ret = ath_init_btcoex_info(ah, btcoex_info);
-	}
-
-	return ret;
-}
-
 void ath9k_hw_btcoex_enable(struct ath_hw *ah)
 {
 	struct ath_btcoex_info *btcoex_info = &ah->btcoex_info;
@@ -336,40 +167,3 @@ void ath9k_hw_btcoex_disable(struct ath_hw *ah)
 
 	ah->ah_sc->sc_flags &= ~SC_OP_BTCOEX_ENABLED;
 }
-
-/*
- * Pause btcoex timer and bt duty cycle timer
- */
-void ath_btcoex_timer_pause(struct ath_softc *sc)
-{
-	struct ath_btcoex *btcoex = &sc->btcoex;
-	struct ath_hw *ah = sc->sc_ah;
-
-	del_timer_sync(&btcoex->period_timer);
-
-	if (btcoex->hw_timer_enabled)
-		ath_gen_timer_stop(ah, ah->btcoex_info.no_stomp_timer);
-
-	btcoex->hw_timer_enabled = false;
-}
-
-/*
- * (Re)start btcoex timers
- */
-void ath_btcoex_timer_resume(struct ath_softc *sc)
-{
-	struct ath_btcoex *btcoex = &sc->btcoex;
-	struct ath_hw *ah = sc->sc_ah;
-
-	DPRINTF(ah, ATH_DBG_BTCOEX, "Starting btcoex timers");
-
-	/* make sure duty cycle timer is also stopped when resuming */
-	if (btcoex->hw_timer_enabled)
-		ath_gen_timer_stop(sc->sc_ah, ah->btcoex_info.no_stomp_timer);
-
-	btcoex->bt_priority_cnt = 0;
-	btcoex->bt_priority_time = jiffies;
-	sc->sc_flags &= ~SC_OP_BT_PRIORITY_DETECTED;
-
-	mod_timer(&btcoex->period_timer, jiffies);
-}
diff --git a/drivers/net/wireless/ath/ath9k/btcoex.h b/drivers/net/wireless/ath/ath9k/btcoex.h
index 12e86b7..ed8d01d 100644
--- a/drivers/net/wireless/ath/ath9k/btcoex.h
+++ b/drivers/net/wireless/ath/ath9k/btcoex.h
@@ -72,13 +72,14 @@ struct ath_btcoex_info {
 	u32 bt_coex_mode; 	/* Register setting for AR_BT_COEX_MODE */
 	u32 bt_coex_weights; 	/* Register setting for AR_BT_COEX_WEIGHT */
 	u32 bt_coex_mode2; 	/* Register setting for AR_BT_COEX_MODE2 */
-	struct ath_gen_timer *no_stomp_timer; /*Timer for no BT stomping*/
 };
 
 bool ath_btcoex_supported(u16 subsysid);
-void ath9k_hw_btcoex_init_weight(struct ath_hw *ah);
-int ath9k_hw_btcoex_init(struct ath_hw *ah);
+void ath9k_hw_btcoex_init_2wire(struct ath_hw *ah);
+void ath9k_hw_btcoex_init_3wire(struct ath_hw *ah);
+void ath9k_hw_init_btcoex_hw_info(struct ath_hw *ah, int qnum);
 void ath9k_hw_btcoex_enable(struct ath_hw *ah);
 void ath9k_hw_btcoex_disable(struct ath_hw *ah);
 
+
 #endif
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 774dc08..6658d95 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -679,7 +679,4 @@ u32 ath9k_hw_gettsf32(struct ath_hw *ah);
 #define ATH_PCIE_CAP_LINK_L1	2
 
 void ath_pcie_aspm_disable(struct ath_softc *sc);
-
-void ath_btcoex_timer_resume(struct ath_softc *sc);
-void ath_btcoex_timer_pause(struct ath_softc *sc);
 #endif
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index defbe9f..e6a42d2 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1290,9 +1290,9 @@ void ath_detach(struct ath_softc *sc)
 		if (ATH_TXQ_SETUP(sc, i))
 			ath_tx_cleanupq(sc, &sc->tx.txq[i]);
 
-	if ((ah->btcoex_info.no_stomp_timer) &&
+	if ((sc->btcoex.no_stomp_timer) &&
 	    ah->btcoex_info.btcoex_scheme == ATH_BTCOEX_CFG_3WIRE)
-		ath_gen_timer_free(ah, ah->btcoex_info.no_stomp_timer);
+		ath_gen_timer_free(ah, sc->btcoex.no_stomp_timer);
 
 	ath9k_hw_detach(ah);
 	ath9k_exit_debug(ah);
@@ -1311,6 +1311,158 @@ static int ath9k_reg_notifier(struct wiphy *wiphy,
 }
 
 /*
+ * Detects if there is any priority bt traffic
+ */
+static void ath_detect_bt_priority(struct ath_softc *sc)
+{
+	struct ath_btcoex *btcoex = &sc->btcoex;
+	struct ath_hw *ah = sc->sc_ah;
+
+	if (ath9k_hw_gpio_get(sc->sc_ah, ah->btcoex_info.btpriority_gpio))
+		btcoex->bt_priority_cnt++;
+
+	if (time_after(jiffies, btcoex->bt_priority_time +
+			msecs_to_jiffies(ATH_BT_PRIORITY_TIME_THRESHOLD))) {
+		if (btcoex->bt_priority_cnt >= ATH_BT_CNT_THRESHOLD) {
+			DPRINTF(sc->sc_ah, ATH_DBG_BTCOEX,
+				"BT priority traffic detected");
+			sc->sc_flags |= SC_OP_BT_PRIORITY_DETECTED;
+		} else {
+			sc->sc_flags &= ~SC_OP_BT_PRIORITY_DETECTED;
+		}
+
+		btcoex->bt_priority_cnt = 0;
+		btcoex->bt_priority_time = jiffies;
+	}
+}
+
+static void ath_btcoex_set_weight(struct ath_btcoex_info *btcoex_info,
+				  u32 bt_weight,
+				  u32 wlan_weight)
+{
+	btcoex_info->bt_coex_weights = SM(bt_weight, AR_BTCOEX_BT_WGHT) |
+				       SM(wlan_weight, AR_BTCOEX_WL_WGHT);
+}
+
+static void ath9k_hw_btcoex_init_weight(struct ath_hw *ah)
+{
+	ath_btcoex_set_weight(&ah->btcoex_info, AR_BT_COEX_WGHT,
+			      AR_STOMP_LOW_WLAN_WGHT);
+}
+
+/*
+ * Configures appropriate weight based on stomp type.
+ */
+static void ath_btcoex_bt_stomp(struct ath_softc *sc,
+				struct ath_btcoex_info *btinfo,
+				int stomp_type)
+{
+
+	switch (stomp_type) {
+	case ATH_BTCOEX_STOMP_ALL:
+		ath_btcoex_set_weight(btinfo, AR_BT_COEX_WGHT,
+				      AR_STOMP_ALL_WLAN_WGHT);
+		break;
+	case ATH_BTCOEX_STOMP_LOW:
+		ath_btcoex_set_weight(btinfo, AR_BT_COEX_WGHT,
+				      AR_STOMP_LOW_WLAN_WGHT);
+		break;
+	case ATH_BTCOEX_STOMP_NONE:
+		ath_btcoex_set_weight(btinfo, AR_BT_COEX_WGHT,
+				      AR_STOMP_NONE_WLAN_WGHT);
+		break;
+	default:
+		DPRINTF(sc->sc_ah, ATH_DBG_BTCOEX, "Invalid Stomptype\n");
+		break;
+	}
+
+	ath9k_hw_btcoex_enable(sc->sc_ah);
+}
+
+/*
+ * This is the master bt coex timer which runs for every
+ * 45ms, bt traffic will be given priority during 55% of this
+ * period while wlan gets remaining 45%
+ */
+static void ath_btcoex_period_timer(unsigned long data)
+{
+	struct ath_softc *sc = (struct ath_softc *) data;
+	struct ath_hw *ah = sc->sc_ah;
+	struct ath_btcoex *btcoex = &sc->btcoex;
+	struct ath_btcoex_info *btinfo = &ah->btcoex_info;
+
+	ath_detect_bt_priority(sc);
+
+	spin_lock_bh(&btcoex->btcoex_lock);
+
+	ath_btcoex_bt_stomp(sc, btinfo, btinfo->bt_stomp_type);
+
+	spin_unlock_bh(&btcoex->btcoex_lock);
+
+	if (btcoex->btcoex_period != btcoex->btcoex_no_stomp) {
+		if (btcoex->hw_timer_enabled)
+			ath_gen_timer_stop(ah, btcoex->no_stomp_timer);
+
+		ath_gen_timer_start(ah,
+			btcoex->no_stomp_timer,
+			(ath9k_hw_gettsf32(ah) +
+				btcoex->btcoex_no_stomp),
+				btcoex->btcoex_no_stomp * 10);
+		btcoex->hw_timer_enabled = true;
+	}
+
+	mod_timer(&btcoex->period_timer, jiffies +
+				  msecs_to_jiffies(ATH_BTCOEX_DEF_BT_PERIOD));
+}
+
+/*
+ * Generic tsf based hw timer which configures weight
+ * registers to time slice between wlan and bt traffic
+ */
+static void ath_btcoex_no_stomp_timer(void *arg)
+{
+	struct ath_softc *sc = (struct ath_softc *)arg;
+	struct ath_hw *ah = sc->sc_ah;
+	struct ath_btcoex *btcoex = &sc->btcoex;
+	struct ath_btcoex_info *btinfo = &ah->btcoex_info;
+
+	DPRINTF(ah, ATH_DBG_BTCOEX, "no stomp timer running \n");
+
+	spin_lock_bh(&btcoex->btcoex_lock);
+
+	if (btinfo->bt_stomp_type == ATH_BTCOEX_STOMP_LOW)
+		ath_btcoex_bt_stomp(sc, btinfo, ATH_BTCOEX_STOMP_NONE);
+	 else if (btinfo->bt_stomp_type == ATH_BTCOEX_STOMP_ALL)
+		ath_btcoex_bt_stomp(sc, btinfo, ATH_BTCOEX_STOMP_LOW);
+
+	spin_unlock_bh(&btcoex->btcoex_lock);
+}
+
+static int ath_init_btcoex_timer(struct ath_softc *sc)
+{
+	struct ath_btcoex *btcoex = &sc->btcoex;
+
+	btcoex->btcoex_period = ATH_BTCOEX_DEF_BT_PERIOD * 1000;
+	btcoex->btcoex_no_stomp = (100 - ATH_BTCOEX_DEF_DUTY_CYCLE) *
+		btcoex->btcoex_period / 100;
+
+	setup_timer(&btcoex->period_timer, ath_btcoex_period_timer,
+			(unsigned long) sc);
+
+	spin_lock_init(&btcoex->btcoex_lock);
+
+	btcoex->no_stomp_timer = ath_gen_timer_alloc(sc->sc_ah,
+			ath_btcoex_no_stomp_timer,
+			ath_btcoex_no_stomp_timer,
+			(void *) sc, AR_FIRST_NDP_TIMER);
+
+	if (!btcoex->no_stomp_timer)
+		return -ENOMEM;
+
+	return 0;
+}
+
+/*
  * Initialize and fill ath_softc, ath_sofct is the
  * "Software Carrier" struct. Historically it has existed
  * to allow the separation between hardware specific
@@ -1321,6 +1473,7 @@ static int ath_init_softc(u16 devid, struct ath_softc *sc, u16 subsysid)
 	struct ath_hw *ah = NULL;
 	int r = 0, i;
 	int csz = 0;
+	int qnum;
 
 	/* XXX: hardware will not be ready until ath_open() being called */
 	sc->sc_flags |= SC_OP_INVALID;
@@ -1525,10 +1678,23 @@ static int ath_init_softc(u16 devid, struct ath_softc *sc, u16 subsysid)
 			ARRAY_SIZE(ath9k_5ghz_chantable);
 	}
 
-	if (ah->btcoex_info.btcoex_scheme != ATH_BTCOEX_CFG_NONE) {
-		r = ath9k_hw_btcoex_init(ah);
+	switch (ah->btcoex_info.btcoex_scheme) {
+	case ATH_BTCOEX_CFG_NONE:
+		break;
+	case ATH_BTCOEX_CFG_2WIRE:
+		ath9k_hw_btcoex_init_2wire(ah);
+		break;
+	case ATH_BTCOEX_CFG_3WIRE:
+		ath9k_hw_btcoex_init_3wire(ah);
+		r = ath_init_btcoex_timer(sc);
 		if (r)
 			goto bad2;
+		qnum = ath_tx_get_qnum(sc, ATH9K_TX_QUEUE_DATA, ATH9K_WME_AC_BE);
+		ath9k_hw_init_btcoex_hw_info(ah, qnum);
+		break;
+	default:
+		WARN_ON(1);
+		break;
 	}
 
 	return 0;
@@ -1910,6 +2076,27 @@ void ath9k_update_ichannel(struct ath_softc *sc, struct ieee80211_hw *hw,
 /* mac80211 callbacks */
 /**********************/
 
+/*
+ * (Re)start btcoex timers
+ */
+static void ath9k_btcoex_timer_resume(struct ath_softc *sc)
+{
+	struct ath_btcoex *btcoex = &sc->btcoex;
+	struct ath_hw *ah = sc->sc_ah;
+
+	DPRINTF(ah, ATH_DBG_BTCOEX, "Starting btcoex timers");
+
+	/* make sure duty cycle timer is also stopped when resuming */
+	if (btcoex->hw_timer_enabled)
+		ath_gen_timer_stop(sc->sc_ah, btcoex->no_stomp_timer);
+
+	btcoex->bt_priority_cnt = 0;
+	btcoex->bt_priority_time = jiffies;
+	sc->sc_flags &= ~SC_OP_BT_PRIORITY_DETECTED;
+
+	mod_timer(&btcoex->period_timer, jiffies);
+}
+
 static int ath9k_start(struct ieee80211_hw *hw)
 {
 	struct ath_wiphy *aphy = hw->priv;
@@ -2022,7 +2209,7 @@ static int ath9k_start(struct ieee80211_hw *hw)
 
 		ath_pcie_aspm_disable(sc);
 		if (ah->btcoex_info.btcoex_scheme == ATH_BTCOEX_CFG_3WIRE)
-			ath_btcoex_timer_resume(sc);
+			ath9k_btcoex_timer_resume(sc);
 	}
 
 mutex_unlock:
@@ -2130,6 +2317,22 @@ exit:
 	return 0;
 }
 
+/*
+ * Pause btcoex timer and bt duty cycle timer
+ */
+static void ath9k_btcoex_timer_pause(struct ath_softc *sc)
+{
+	struct ath_btcoex *btcoex = &sc->btcoex;
+	struct ath_hw *ah = sc->sc_ah;
+
+	del_timer_sync(&btcoex->period_timer);
+
+	if (btcoex->hw_timer_enabled)
+		ath_gen_timer_stop(ah, btcoex->no_stomp_timer);
+
+	btcoex->hw_timer_enabled = false;
+}
+
 static void ath9k_stop(struct ieee80211_hw *hw)
 {
 	struct ath_wiphy *aphy = hw->priv;
@@ -2162,7 +2365,7 @@ static void ath9k_stop(struct ieee80211_hw *hw)
 	if (sc->sc_flags & SC_OP_BTCOEX_ENABLED) {
 		ath9k_hw_btcoex_disable(ah);
 		if (ah->btcoex_info.btcoex_scheme == ATH_BTCOEX_CFG_3WIRE)
-			ath_btcoex_timer_pause(sc);
+			ath9k_btcoex_timer_pause(sc);
 	}
 
 	/* make sure h/w will not generate any interrupt
-- 
1.6.3.3

