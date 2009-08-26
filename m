Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:45808 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751626AbZHZPrU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Aug 2009 11:47:20 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 26 Aug 2009 08:47:22 -0700
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Luis.Rodriguez@atheros.com>,
	<Jouni.Malinen@atheros.com>, <ath9k-devel@lists.ath9k.org>
Subject: [PATCH 8/8] ath9k: Add Bluetooth Coexistence 3-wire support
Date: Wed, 26 Aug 2009 21:08:50 +0530
Message-ID: <1251301130-10912-9-git-send-email-vasanth@atheros.com>
In-Reply-To: <1251301130-10912-8-git-send-email-vasanth@atheros.com>
References: <1251301130-10912-1-git-send-email-vasanth@atheros.com>
 <1251301130-10912-2-git-send-email-vasanth@atheros.com>
 <1251301130-10912-3-git-send-email-vasanth@atheros.com>
 <1251301130-10912-4-git-send-email-vasanth@atheros.com>
 <1251301130-10912-5-git-send-email-vasanth@atheros.com>
 <1251301130-10912-6-git-send-email-vasanth@atheros.com>
 <1251301130-10912-7-git-send-email-vasanth@atheros.com>
 <1251301130-10912-8-git-send-email-vasanth@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds 3-wire bluetooth coex support for AR9285.
This support can be enabled through btcoex_enable modparam.

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h  |    2 +
 drivers/net/wireless/ath/ath9k/btcoex.c |  290 +++++++++++++++++++++++++++++--
 drivers/net/wireless/ath/ath9k/btcoex.h |   61 +++++++-
 drivers/net/wireless/ath/ath9k/debug.h  |    1 +
 drivers/net/wireless/ath/ath9k/hw.c     |    2 +-
 drivers/net/wireless/ath/ath9k/hw.h     |    2 +
 drivers/net/wireless/ath/ath9k/main.c   |   34 +++-
 drivers/net/wireless/ath/ath9k/reg.h    |   49 +++++
 drivers/net/wireless/ath/ath9k/xmit.c   |    9 +-
 9 files changed, 423 insertions(+), 27 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 83f2c8f..1c68a9d 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -523,6 +523,7 @@ struct ath_led {
 #define SC_OP_WAIT_FOR_TX_ACK   BIT(18)
 #define SC_OP_BEACON_SYNC       BIT(19)
 #define SC_OP_BTCOEX_ENABLED    BIT(20)
+#define SC_OP_BT_PRIORITY_DETECTED BIT(21)
 
 struct ath_bus_ops {
 	void		(*read_cachesize)(struct ath_softc *sc, int *csz);
@@ -708,4 +709,5 @@ bool ath9k_all_wiphys_idle(struct ath_softc *sc);
 void ath9k_iowrite32(struct ath_hw *ah, u32 reg_offset, u32 val);
 unsigned int ath9k_ioread32(struct ath_hw *ah, u32 reg_offset);
 
+int ath_tx_get_qnum(struct ath_softc *sc, int qtype, int haltype);
 #endif /* ATH9K_H */
diff --git a/drivers/net/wireless/ath/ath9k/btcoex.c b/drivers/net/wireless/ath/ath9k/btcoex.c
index 9f19cd1..8fb3567 100644
--- a/drivers/net/wireless/ath/ath9k/btcoex.c
+++ b/drivers/net/wireless/ath/ath9k/btcoex.c
@@ -16,34 +16,251 @@
 
 #include "ath9k.h"
 
-void ath9k_hw_btcoex_init(struct ath_hw *ah)
+static const struct ath_btcoex_config ath_bt_config = { 0, true, true,
+			ATH_BT_COEX_MODE_SLOTTED, true, true, 2, 5, true };
+
+
+/*
+ * Detects if there is any priority bt traffic
+ */
+static void ath_detect_bt_priority(struct ath_softc *sc)
+{
+	struct ath_btcoex_info *btinfo = &sc->btcoex_info;
+
+	if (ath9k_hw_gpio_get(sc->sc_ah, btinfo->btpriority_gpio))
+		btinfo->bt_priority_cnt++;
+
+	if (time_after(jiffies, btinfo->bt_priority_time +
+			msecs_to_jiffies(ATH_BT_PRIORITY_TIME_THRESHOLD))) {
+		if (btinfo->bt_priority_cnt >= ATH_BT_CNT_THRESHOLD) {
+			DPRINTF(sc, ATH_DBG_BTCOEX,
+				"BT priority traffic detected");
+			sc->sc_flags |= SC_OP_BT_PRIORITY_DETECTED;
+		} else {
+			sc->sc_flags &= ~SC_OP_BT_PRIORITY_DETECTED;
+		}
+
+		btinfo->bt_priority_cnt = 0;
+		btinfo->bt_priority_time = jiffies;
+	}
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
+		DPRINTF(sc, ATH_DBG_BTCOEX, "Invalid Stomptype\n");
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
+
+static void ath_btcoex_period_timer(unsigned long data)
+{
+	struct ath_softc *sc = (struct ath_softc *) data;
+	struct ath_btcoex_info *btinfo = &sc->btcoex_info;
+	unsigned long flags;
+
+	ath_detect_bt_priority(sc);
+
+	spin_lock_irqsave(&btinfo->btcoex_lock, flags);
+
+	ath_btcoex_bt_stomp(sc, btinfo, btinfo->bt_stomp_type);
+
+	spin_unlock_irqrestore(&btinfo->btcoex_lock, flags);
+
+	if (btinfo->btcoex_period != btinfo->btcoex_no_stomp) {
+		if (btinfo->hw_timer_enabled)
+			ath_gen_timer_stop(sc->sc_ah, btinfo->no_stomp_timer);
+
+		ath_gen_timer_start(sc->sc_ah,
+			btinfo->no_stomp_timer,
+			(ath9k_hw_gettsf32(sc->sc_ah) +
+				btinfo->btcoex_no_stomp),
+				btinfo->btcoex_no_stomp * 10);
+		btinfo->hw_timer_enabled = true;
+	}
+
+	mod_timer(&btinfo->period_timer, jiffies +
+				  msecs_to_jiffies(ATH_BTCOEX_DEF_BT_PERIOD));
+}
+
+/*
+ * Generic tsf based hw timer which configures weight
+ * registers to time slice between wlan and bt traffic
+ */
+
+static void ath_btcoex_no_stomp_timer(void *arg)
+{
+	struct ath_softc *sc = (struct ath_softc *)arg;
+	struct ath_btcoex_info *btinfo = &sc->btcoex_info;
+	unsigned long flags;
+
+	DPRINTF(sc, ATH_DBG_BTCOEX, "no stomp timer running \n");
+
+	spin_lock_irqsave(&btinfo->btcoex_lock, flags);
+
+	if (btinfo->bt_stomp_type == ATH_BTCOEX_STOMP_LOW)
+		ath_btcoex_bt_stomp(sc, btinfo, ATH_BTCOEX_STOMP_NONE);
+	 else if (btinfo->bt_stomp_type == ATH_BTCOEX_STOMP_ALL)
+		ath_btcoex_bt_stomp(sc, btinfo, ATH_BTCOEX_STOMP_LOW);
+
+	spin_unlock_irqrestore(&btinfo->btcoex_lock, flags);
+}
+
+static int ath_init_btcoex_info(struct ath_hw *hw,
+				struct ath_btcoex_info *btcoex_info)
+{
+	u32 i;
+	int qnum;
+
+	qnum = ath_tx_get_qnum(hw->ah_sc, ATH9K_TX_QUEUE_DATA, ATH9K_WME_AC_BE);
+
+	btcoex_info->bt_coex_mode =
+		(btcoex_info->bt_coex_mode & AR_BT_QCU_THRESH) |
+		SM(ath_bt_config.bt_time_extend, AR_BT_TIME_EXTEND) |
+		SM(ath_bt_config.bt_txstate_extend, AR_BT_TXSTATE_EXTEND) |
+		SM(ath_bt_config.bt_txframe_extend, AR_BT_TX_FRAME_EXTEND) |
+		SM(ath_bt_config.bt_mode, AR_BT_MODE) |
+		SM(ath_bt_config.bt_quiet_collision, AR_BT_QUIET) |
+		SM(ath_bt_config.bt_rxclear_polarity, AR_BT_RX_CLEAR_POLARITY) |
+		SM(ath_bt_config.bt_priority_time, AR_BT_PRIORITY_TIME) |
+		SM(ath_bt_config.bt_first_slot_time, AR_BT_FIRST_SLOT_TIME) |
+		SM(qnum, AR_BT_QCU_THRESH);
+
+	btcoex_info->bt_coex_mode2 =
+		SM(ath_bt_config.bt_hold_rx_clear, AR_BT_HOLD_RX_CLEAR) |
+		SM(ATH_BTCOEX_BMISS_THRESH, AR_BT_BCN_MISS_THRESH) |
+		AR_BT_DISABLE_BT_ANT;
+
+	btcoex_info->bt_stomp_type = ATH_BTCOEX_STOMP_LOW;
+
+	btcoex_info->btcoex_period = ATH_BTCOEX_DEF_BT_PERIOD * 1000;
+
+	btcoex_info->btcoex_no_stomp = (100 - ATH_BTCOEX_DEF_DUTY_CYCLE) *
+		btcoex_info->btcoex_period / 100;
+
+	for (i = 0; i < 32; i++)
+		hw->hw_gen_timers.gen_timer_index[(debruijn32 << i) >> 27] = i;
+
+	setup_timer(&btcoex_info->period_timer, ath_btcoex_period_timer,
+			(unsigned long) hw->ah_sc);
+
+	btcoex_info->no_stomp_timer = ath_gen_timer_alloc(hw,
+			ath_btcoex_no_stomp_timer,
+			ath_btcoex_no_stomp_timer,
+			(void *)hw->ah_sc, AR_FIRST_NDP_TIMER);
+
+	if (btcoex_info->no_stomp_timer == NULL)
+		return -ENOMEM;
+
+	spin_lock_init(&btcoex_info->btcoex_lock);
+
+	return 0;
+}
+
+int ath9k_hw_btcoex_init(struct ath_hw *ah)
 {
 	struct ath_btcoex_info *btcoex_info = &ah->ah_sc->btcoex_info;
+	int ret = 0;
+
+	if (btcoex_info->btcoex_scheme == ATH_BTCOEX_CFG_2WIRE) {
+		/* connect bt_active to baseband */
+		REG_CLR_BIT(ah, AR_GPIO_INPUT_EN_VAL,
+				(AR_GPIO_INPUT_EN_VAL_BT_PRIORITY_DEF |
+				 AR_GPIO_INPUT_EN_VAL_BT_FREQUENCY_DEF));
+
+		REG_SET_BIT(ah, AR_GPIO_INPUT_EN_VAL,
+				AR_GPIO_INPUT_EN_VAL_BT_ACTIVE_BB);
+
+		/* Set input mux for bt_active to gpio pin */
+		REG_RMW_FIELD(ah, AR_GPIO_INPUT_MUX1,
+				AR_GPIO_INPUT_MUX1_BT_ACTIVE,
+				btcoex_info->btactive_gpio);
 
-	/* connect bt_active to baseband */
-	REG_CLR_BIT(ah, AR_GPIO_INPUT_EN_VAL,
-			(AR_GPIO_INPUT_EN_VAL_BT_PRIORITY_DEF |
-			 AR_GPIO_INPUT_EN_VAL_BT_FREQUENCY_DEF));
+		/* Configure the desired gpio port for input */
+		ath9k_hw_cfg_gpio_input(ah, btcoex_info->btactive_gpio);
+	} else {
+		/* btcoex 3-wire */
+		REG_SET_BIT(ah, AR_GPIO_INPUT_EN_VAL,
+				(AR_GPIO_INPUT_EN_VAL_BT_PRIORITY_BB |
+				 AR_GPIO_INPUT_EN_VAL_BT_ACTIVE_BB));
 
-	REG_SET_BIT(ah, AR_GPIO_INPUT_EN_VAL,
-			AR_GPIO_INPUT_EN_VAL_BT_ACTIVE_BB);
+		/* Set input mux for bt_prority_async and
+		 *                  bt_active_async to GPIO pins */
+		REG_RMW_FIELD(ah, AR_GPIO_INPUT_MUX1,
+				AR_GPIO_INPUT_MUX1_BT_ACTIVE,
+				btcoex_info->btactive_gpio);
 
-	/* Set input mux for bt_active to gpio pin */
-	REG_RMW_FIELD(ah, AR_GPIO_INPUT_MUX1,
-			AR_GPIO_INPUT_MUX1_BT_ACTIVE,
-			btcoex_info->btactive_gpio);
+		REG_RMW_FIELD(ah, AR_GPIO_INPUT_MUX1,
+				AR_GPIO_INPUT_MUX1_BT_PRIORITY,
+				btcoex_info->btpriority_gpio);
 
-	/* Configure the desired gpio port for input */
-	ath9k_hw_cfg_gpio_input(ah, btcoex_info->btactive_gpio);
+		/* Configure the desired GPIO ports for input */
+
+		ath9k_hw_cfg_gpio_input(ah, btcoex_info->btactive_gpio);
+		ath9k_hw_cfg_gpio_input(ah, btcoex_info->btpriority_gpio);
+
+		ret = ath_init_btcoex_info(ah, btcoex_info);
+	}
+
+	return ret;
 }
 
 void ath9k_hw_btcoex_enable(struct ath_hw *ah)
 {
 	struct ath_btcoex_info *btcoex_info = &ah->ah_sc->btcoex_info;
 
-	/* Configure the desired GPIO port for TX_FRAME output */
-	ath9k_hw_cfg_output(ah, btcoex_info->wlanactive_gpio,
-			    AR_GPIO_OUTPUT_MUX_AS_TX_FRAME);
+	if (btcoex_info->btcoex_scheme == ATH_BTCOEX_CFG_2WIRE) {
+		/* Configure the desired GPIO port for TX_FRAME output */
+		ath9k_hw_cfg_output(ah, btcoex_info->wlanactive_gpio,
+				AR_GPIO_OUTPUT_MUX_AS_TX_FRAME);
+	} else {
+		/*
+		 * Program coex mode and weight registers to
+		 * enable coex 3-wire
+		 */
+		REG_WRITE(ah, AR_BT_COEX_MODE, btcoex_info->bt_coex_mode);
+		REG_WRITE(ah, AR_BT_COEX_WEIGHT, btcoex_info->bt_coex_weights);
+		REG_WRITE(ah, AR_BT_COEX_MODE2, btcoex_info->bt_coex_mode2);
+
+		REG_RMW_FIELD(ah, AR_QUIET1,
+				AR_QUIET1_QUIET_ACK_CTS_ENABLE, 1);
+		REG_RMW_FIELD(ah, AR_PCU_MISC,
+				AR_PCU_BT_ANT_PREVENT_RX, 0);
+
+		ath9k_hw_cfg_output(ah, btcoex_info->wlanactive_gpio,
+				AR_GPIO_OUTPUT_MUX_AS_RX_CLEAR_EXTERNAL);
+	}
+
+	REG_RMW(ah, AR_GPIO_PDPU,
+		(0x2 << (btcoex_info->btactive_gpio * 2)),
+		(0x3 << (btcoex_info->btactive_gpio * 2)));
 
 	ah->ah_sc->sc_flags |= SC_OP_BTCOEX_ENABLED;
 }
@@ -57,5 +274,46 @@ void ath9k_hw_btcoex_disable(struct ath_hw *ah)
 	ath9k_hw_cfg_output(ah, btcoex_info->wlanactive_gpio,
 			AR_GPIO_OUTPUT_MUX_AS_OUTPUT);
 
+	if (btcoex_info->btcoex_scheme == ATH_BTCOEX_CFG_3WIRE) {
+		REG_WRITE(ah, AR_BT_COEX_MODE, AR_BT_QUIET | AR_BT_MODE);
+		REG_WRITE(ah, AR_BT_COEX_WEIGHT, 0);
+		REG_WRITE(ah, AR_BT_COEX_MODE2, 0);
+	}
+
 	ah->ah_sc->sc_flags &= ~SC_OP_BTCOEX_ENABLED;
 }
+
+/*
+ * Pause btcoex timer and bt duty cycle timer
+ */
+void ath_btcoex_timer_pause(struct ath_softc *sc,
+			    struct ath_btcoex_info *btinfo)
+{
+
+	del_timer_sync(&btinfo->period_timer);
+
+	if (btinfo->hw_timer_enabled)
+		ath_gen_timer_stop(sc->sc_ah, btinfo->no_stomp_timer);
+
+	btinfo->hw_timer_enabled = false;
+}
+
+/*
+ * (Re)start btcoex timers
+ */
+void ath_btcoex_timer_resume(struct ath_softc *sc,
+			     struct ath_btcoex_info *btinfo)
+{
+
+	DPRINTF(sc, ATH_DBG_BTCOEX, "Starting btcoex timers");
+
+	/* make sure duty cycle timer is also stopped when resuming */
+	if (btinfo->hw_timer_enabled)
+		ath_gen_timer_stop(sc->sc_ah, btinfo->no_stomp_timer);
+
+	btinfo->bt_priority_cnt = 0;
+	btinfo->bt_priority_time = jiffies;
+	sc->sc_flags &= ~SC_OP_BT_PRIORITY_DETECTED;
+
+	mod_timer(&btinfo->period_timer, jiffies);
+}
diff --git a/drivers/net/wireless/ath/ath9k/btcoex.h b/drivers/net/wireless/ath/ath9k/btcoex.h
index cdfa80d..4556819 100644
--- a/drivers/net/wireless/ath/ath9k/btcoex.h
+++ b/drivers/net/wireless/ath/ath9k/btcoex.h
@@ -20,20 +20,79 @@
 #define ATH_WLANACTIVE_GPIO	5
 #define ATH_BTACTIVE_GPIO	6
 
+#define ATH_BTCOEX_DEF_BT_PERIOD  45
+#define ATH_BTCOEX_DEF_DUTY_CYCLE 55
+#define ATH_BTCOEX_BMISS_THRESH   50
+
+#define ATH_BT_PRIORITY_TIME_THRESHOLD 1000 /* ms */
+#define ATH_BT_CNT_THRESHOLD	       3
+
 enum ath_btcoex_scheme {
 	ATH_BTCOEX_CFG_NONE,
 	ATH_BTCOEX_CFG_2WIRE,
 	ATH_BTCOEX_CFG_3WIRE,
 };
 
+enum ath_stomp_type {
+	ATH_BTCOEX_NO_STOMP,
+	ATH_BTCOEX_STOMP_ALL,
+	ATH_BTCOEX_STOMP_LOW,
+	ATH_BTCOEX_STOMP_NONE
+};
+
+enum ath_bt_mode {
+	ATH_BT_COEX_MODE_LEGACY,	/* legacy rx_clear mode */
+	ATH_BT_COEX_MODE_UNSLOTTED,	/* untimed/unslotted mode */
+	ATH_BT_COEX_MODE_SLOTTED,	/* slotted mode */
+	ATH_BT_COEX_MODE_DISALBED,	/* coexistence disabled */
+};
+
+struct ath_btcoex_config {
+	u8 bt_time_extend;
+	bool bt_txstate_extend;
+	bool bt_txframe_extend;
+	enum ath_bt_mode bt_mode; /* coexistence mode */
+	bool bt_quiet_collision;
+	bool bt_rxclear_polarity; /* invert rx_clear as WLAN_ACTIVE*/
+	u8 bt_priority_time;
+	u8 bt_first_slot_time;
+	bool bt_hold_rx_clear;
+};
+
 struct ath_btcoex_info {
 	enum ath_btcoex_scheme btcoex_scheme;
 	u8 wlanactive_gpio;
 	u8 btactive_gpio;
+	u8 btpriority_gpio;
+	u8 bt_duty_cycle; 	/* BT duty cycle in percentage */
+	int bt_stomp_type; 	/* Types of BT stomping */
+	u32 bt_coex_mode; 	/* Register setting for AR_BT_COEX_MODE */
+	u32 bt_coex_weights; 	/* Register setting for AR_BT_COEX_WEIGHT */
+	u32 bt_coex_mode2; 	/* Register setting for AR_BT_COEX_MODE2 */
+	u32 btcoex_no_stomp;   /* in usec */
+	u32 btcoex_period;     	/* in usec */
+	u32 bt_priority_cnt;
+	unsigned long bt_priority_time;
+	bool hw_timer_enabled;
+	spinlock_t btcoex_lock;
+	struct timer_list period_timer;      /* Timer for BT period */
+	struct ath_gen_timer *no_stomp_timer; /*Timer for no BT stomping*/
 };
 
-void ath9k_hw_btcoex_init(struct ath_hw *ah);
+int ath9k_hw_btcoex_init(struct ath_hw *ah);
 void ath9k_hw_btcoex_enable(struct ath_hw *ah);
 void ath9k_hw_btcoex_disable(struct ath_hw *ah);
+void ath_btcoex_timer_resume(struct ath_softc *sc,
+			     struct ath_btcoex_info *btinfo);
+void ath_btcoex_timer_pause(struct ath_softc *sc,
+			    struct ath_btcoex_info *btinfo);
+
+static inline void ath_btcoex_set_weight(struct ath_btcoex_info *btcoex_info,
+					 u32 bt_weight,
+					 u32 wlan_weight)
+{
+	btcoex_info->bt_coex_weights = SM(bt_weight, AR_BTCOEX_BT_WGHT) |
+				       SM(wlan_weight, AR_BTCOEX_WL_WGHT);
+}
 
 #endif
diff --git a/drivers/net/wireless/ath/ath9k/debug.h b/drivers/net/wireless/ath/ath9k/debug.h
index ea0dd1e..7241f47 100644
--- a/drivers/net/wireless/ath/ath9k/debug.h
+++ b/drivers/net/wireless/ath/ath9k/debug.h
@@ -31,6 +31,7 @@ enum ATH_DEBUG {
 	ATH_DBG_FATAL		= 0x00000400,
 	ATH_DBG_PS		= 0x00000800,
 	ATH_DBG_HWTIMER		= 0x00001000,
+	ATH_DBG_BTCOEX		= 0x00002000,
 	ATH_DBG_ANY		= 0xffffffff
 };
 
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 3afd7a9..e340dac 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -4141,7 +4141,7 @@ static u32 rightmost_index(struct ath_gen_timer_table *timer_table, u32 *mask)
 	return timer_table->gen_timer_index[b];
 }
 
-static u32 ath9k_hw_gettsf32(struct ath_hw *ah)
+u32 ath9k_hw_gettsf32(struct ath_hw *ah)
 {
 	return REG_READ(ah, AR_TSF_L32);
 }
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 052a9c4..5ca6ffa 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -79,6 +79,7 @@
 #define AR_GPIO_OUTPUT_MUX_AS_PCIE_ATTENTION_LED 1
 #define AR_GPIO_OUTPUT_MUX_AS_PCIE_POWER_LED     2
 #define AR_GPIO_OUTPUT_MUX_AS_TX_FRAME           3
+#define AR_GPIO_OUTPUT_MUX_AS_RX_CLEAR_EXTERNAL  4
 #define AR_GPIO_OUTPUT_MUX_AS_MAC_NETWORK_LED    5
 #define AR_GPIO_OUTPUT_MUX_AS_MAC_POWER_LED      6
 
@@ -662,5 +663,6 @@ void ath_gen_timer_start(struct ath_hw *ah, struct ath_gen_timer *timer,
 void ath_gen_timer_stop(struct ath_hw *ah, struct ath_gen_timer *timer);
 void ath_gen_timer_free(struct ath_hw *ah, struct ath_gen_timer *timer);
 void ath_gen_timer_isr(struct ath_hw *hw);
+u32 ath9k_hw_gettsf32(struct ath_hw *ah);
 
 #endif
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 215c672..4fae699 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -602,6 +602,10 @@ irqreturn_t ath_isr(int irq, void *dev)
 			sc->sc_flags |= SC_OP_WAIT_FOR_BEACON;
 		}
 
+	if (sc->btcoex_info.btcoex_scheme == ATH_BTCOEX_CFG_3WIRE)
+		if (status & ATH9K_INT_GENTIMER)
+			ath_gen_timer_isr(ah);
+
 chip_reset:
 
 	ath_debug_stat_interrupt(sc, status);
@@ -1279,6 +1283,10 @@ void ath_detach(struct ath_softc *sc)
 		if (ATH_TXQ_SETUP(sc, i))
 			ath_tx_cleanupq(sc, &sc->tx.txq[i]);
 
+	if ((sc->btcoex_info.no_stomp_timer) &&
+	    sc->btcoex_info.btcoex_scheme == ATH_BTCOEX_CFG_3WIRE)
+		ath_gen_timer_free(sc->sc_ah, sc->btcoex_info.no_stomp_timer);
+
 	ath9k_hw_detach(sc->sc_ah);
 	sc->sc_ah = NULL;
 	ath9k_exit_debug(sc);
@@ -1509,8 +1517,11 @@ static int ath_init_softc(u16 devid, struct ath_softc *sc)
 			ARRAY_SIZE(ath9k_5ghz_chantable);
 	}
 
-	if (sc->btcoex_info.btcoex_scheme == ATH_BTCOEX_CFG_2WIRE)
-		ath9k_hw_btcoex_init(ah);
+	if (sc->btcoex_info.btcoex_scheme != ATH_BTCOEX_CFG_NONE) {
+		r = ath9k_hw_btcoex_init(ah);
+		if (r)
+			goto bad2;
+	}
 
 	return 0;
 bad2:
@@ -1992,10 +2003,16 @@ static int ath9k_start(struct ieee80211_hw *hw)
 
 	ieee80211_queue_delayed_work(sc->hw, &sc->tx_complete_work, 0);
 
-	if ((sc->btcoex_info.btcoex_scheme == ATH_BTCOEX_CFG_2WIRE) &&
-	    !(sc->sc_flags & SC_OP_BTCOEX_ENABLED))
+	if ((sc->btcoex_info.btcoex_scheme != ATH_BTCOEX_CFG_NONE) &&
+	    !(sc->sc_flags & SC_OP_BTCOEX_ENABLED)) {
+		ath_btcoex_set_weight(&sc->btcoex_info, AR_BT_COEX_WGHT,
+				      AR_STOMP_LOW_WLAN_WGHT);
 		ath9k_hw_btcoex_enable(sc->sc_ah);
 
+		if (sc->btcoex_info.btcoex_scheme == ATH_BTCOEX_CFG_3WIRE)
+			ath_btcoex_timer_resume(sc, &sc->btcoex_info);
+	}
+
 mutex_unlock:
 	mutex_unlock(&sc->mutex);
 
@@ -2129,6 +2146,12 @@ static void ath9k_stop(struct ieee80211_hw *hw)
 		return; /* another wiphy still in use */
 	}
 
+	if (sc->sc_flags & SC_OP_BTCOEX_ENABLED) {
+		ath9k_hw_btcoex_disable(sc->sc_ah);
+		if (sc->btcoex_info.btcoex_scheme == ATH_BTCOEX_CFG_3WIRE)
+			ath_btcoex_timer_pause(sc, &sc->btcoex_info);
+	}
+
 	/* make sure h/w will not generate any interrupt
 	 * before setting the invalid flag. */
 	ath9k_hw_set_interrupts(sc->sc_ah, 0);
@@ -2142,9 +2165,6 @@ static void ath9k_stop(struct ieee80211_hw *hw)
 
 	wiphy_rfkill_stop_polling(sc->hw->wiphy);
 
-	if (sc->sc_flags & SC_OP_BTCOEX_ENABLED)
-		ath9k_hw_btcoex_disable(sc->sc_ah);
-
 	/* disable HAL and put h/w to sleep */
 	ath9k_hw_disable(sc->sc_ah);
 	ath9k_hw_configpcipowersave(sc->sc_ah, 1);
diff --git a/drivers/net/wireless/ath/ath9k/reg.h b/drivers/net/wireless/ath/ath9k/reg.h
index 1d8e0a8..3ddb243 100644
--- a/drivers/net/wireless/ath/ath9k/reg.h
+++ b/drivers/net/wireless/ath/ath9k/reg.h
@@ -970,6 +970,8 @@ enum {
 #define AR_GPIO_INPUT_EN_VAL_RFSILENT_DEF_S      7
 #define AR_GPIO_INPUT_EN_VAL_BT_ACTIVE_BB        0x00001000
 #define AR_GPIO_INPUT_EN_VAL_BT_ACTIVE_BB_S      12
+#define AR_GPIO_INPUT_EN_VAL_BT_PRIORITY_BB      0x00001000
+#define AR_GPIO_INPUT_EN_VAL_BT_PRIORITY_BB_S    1
 #define AR_GPIO_INPUT_EN_VAL_RFSILENT_BB         0x00008000
 #define AR_GPIO_INPUT_EN_VAL_RFSILENT_BB_S       15
 #define AR_GPIO_RTC_RESET_OVERRIDE_ENABLE        0x00010000
@@ -978,6 +980,8 @@ enum {
 #define AR_GPIO_INPUT_MUX1                       0x4058
 #define AR_GPIO_INPUT_MUX1_BT_ACTIVE             0x000f0000
 #define AR_GPIO_INPUT_MUX1_BT_ACTIVE_S           16
+#define AR_GPIO_INPUT_MUX1_BT_PRIORITY           0x00000f00
+#define AR_GPIO_INPUT_MUX1_BT_PRIORITY_S         8
 
 #define AR_GPIO_INPUT_MUX2                       0x405c
 #define AR_GPIO_INPUT_MUX2_CLK25                 0x0000000f
@@ -1003,6 +1007,8 @@ enum {
 
 #define AR_OBS                  0x4080
 
+#define AR_GPIO_PDPU                             0x4088
+
 #define AR_PCIE_MSI                              0x4094
 #define AR_PCIE_MSI_ENABLE                       0x00000001
 
@@ -1436,6 +1442,7 @@ enum {
 #define AR_QUIET1_NEXT_QUIET_M         0x0000ffff
 #define AR_QUIET1_QUIET_ENABLE         0x00010000
 #define AR_QUIET1_QUIET_ACK_CTS_ENABLE 0x00020000
+#define AR_QUIET1_QUIET_ACK_CTS_ENABLE_S 17
 #define AR_QUIET2          0x8100
 #define AR_QUIET2_QUIET_PERIOD_S       0
 #define AR_QUIET2_QUIET_PERIOD_M       0x0000ffff
@@ -1481,6 +1488,8 @@ enum {
 #define AR_PCU_CLEAR_VMF           0x01000000
 #define AR_PCU_CLEAR_BA_VALID      0x04000000
 
+#define AR_PCU_BT_ANT_PREVENT_RX   0x00100000
+#define AR_PCU_BT_ANT_PREVENT_RX_S 20
 
 #define AR_FILT_OFDM           0x8124
 #define AR_FILT_OFDM_COUNT     0x00FFFFFF
@@ -1508,6 +1517,46 @@ enum {
 #define AR_PHY_ERR_3_COUNT     0x00FFFFFF
 #define AR_PHY_ERR_MASK_3      0x816c
 
+#define AR_BT_COEX_MODE            0x8170
+#define AR_BT_TIME_EXTEND          0x000000ff
+#define AR_BT_TIME_EXTEND_S        0
+#define AR_BT_TXSTATE_EXTEND       0x00000100
+#define AR_BT_TXSTATE_EXTEND_S     8
+#define AR_BT_TX_FRAME_EXTEND      0x00000200
+#define AR_BT_TX_FRAME_EXTEND_S    9
+#define AR_BT_MODE                 0x00000c00
+#define AR_BT_MODE_S               10
+#define AR_BT_QUIET                0x00001000
+#define AR_BT_QUIET_S              12
+#define AR_BT_QCU_THRESH           0x0001e000
+#define AR_BT_QCU_THRESH_S         13
+#define AR_BT_RX_CLEAR_POLARITY    0x00020000
+#define AR_BT_RX_CLEAR_POLARITY_S  17
+#define AR_BT_PRIORITY_TIME        0x00fc0000
+#define AR_BT_PRIORITY_TIME_S      18
+#define AR_BT_FIRST_SLOT_TIME      0xff000000
+#define AR_BT_FIRST_SLOT_TIME_S    24
+
+#define AR_BT_COEX_WEIGHT          0x8174
+#define AR_BT_COEX_WGHT		   0xff55
+#define AR_STOMP_ALL_WLAN_WGHT	   0xffcc
+#define AR_STOMP_LOW_WLAN_WGHT	   0xaaa8
+#define AR_STOMP_NONE_WLAN_WGHT	   0xaa00
+#define AR_BTCOEX_BT_WGHT          0x0000ffff
+#define AR_BTCOEX_BT_WGHT_S        0
+#define AR_BTCOEX_WL_WGHT          0xffff0000
+#define AR_BTCOEX_WL_WGHT_S        16
+
+#define AR_BT_COEX_MODE2           0x817c
+#define AR_BT_BCN_MISS_THRESH      0x000000ff
+#define AR_BT_BCN_MISS_THRESH_S    0
+#define AR_BT_BCN_MISS_CNT         0x0000ff00
+#define AR_BT_BCN_MISS_CNT_S       8
+#define AR_BT_HOLD_RX_CLEAR        0x00010000
+#define AR_BT_HOLD_RX_CLEAR_S      16
+#define AR_BT_DISABLE_BT_ANT       0x00100000
+#define AR_BT_DISABLE_BT_ANT_S     20
+
 #define AR_TXSIFS              0x81d0
 #define AR_TXSIFS_TIME         0x000000FF
 #define AR_TXSIFS_TX_LATENCY   0x00000F00
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 87762da..42551a4 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -493,7 +493,12 @@ static u32 ath_lookup_rate(struct ath_softc *sc, struct ath_buf *bf,
 	if (tx_info->flags & IEEE80211_TX_CTL_RATE_CTRL_PROBE || legacy)
 		return 0;
 
-	aggr_limit = min(max_4ms_framelen, (u32)ATH_AMPDU_LIMIT_MAX);
+	if (sc->sc_flags & SC_OP_BT_PRIORITY_DETECTED)
+		aggr_limit = min((max_4ms_framelen * 3) / 8,
+				 (u32)ATH_AMPDU_LIMIT_MAX);
+	else
+		aggr_limit = min(max_4ms_framelen,
+				 (u32)ATH_AMPDU_LIMIT_MAX);
 
 	/*
 	 * h/w can accept aggregates upto 16 bit lengths (65535).
@@ -872,7 +877,7 @@ struct ath_txq *ath_txq_setup(struct ath_softc *sc, int qtype, int subtype)
 	return &sc->tx.txq[qnum];
 }
 
-static int ath_tx_get_qnum(struct ath_softc *sc, int qtype, int haltype)
+int ath_tx_get_qnum(struct ath_softc *sc, int qtype, int haltype)
 {
 	int qnum;
 
-- 
1.5.5.1

