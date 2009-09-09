Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:54042 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754704AbZIIXo7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Sep 2009 19:44:59 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	devel@linuxdriverproject.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 03/15] ath9k: move hw specific btcoex info to ath_hw
Date: Wed,  9 Sep 2009 19:44:49 -0400
Message-Id: <1252539901-20679-4-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1252539901-20679-1-git-send-email-lrodriguez@atheros.com>
References: <1252539901-20679-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since we now access it via the ath_hw declare the ath_hw pointer
at the header of some routines and se it. ath9k.h no longer needs to
access btcoex.h and to adjust for this move ath_btcoex_set_weight()
into btcoex.h and instead give main.c a helper for setting initial
values upon drv_start()

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h  |    2 -
 drivers/net/wireless/ath/ath9k/btcoex.c |   57 +++++++++++++++++--------
 drivers/net/wireless/ath/ath9k/btcoex.h |   14 +-----
 drivers/net/wireless/ath/ath9k/hw.c     |    3 +-
 drivers/net/wireless/ath/ath9k/hw.h     |    7 +++
 drivers/net/wireless/ath/ath9k/main.c   |   70 +++++++++++++++++--------------
 6 files changed, 88 insertions(+), 65 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 831874c..e8a630c 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -26,7 +26,6 @@
 #include "rc.h"
 #include "debug.h"
 #include "../ath.h"
-#include "btcoex.h"
 
 struct ath_node;
 
@@ -622,7 +621,6 @@ struct ath_softc {
 	struct ath_bus_ops *bus_ops;
 	struct ath_beacon_config cur_beacon_conf;
 	struct delayed_work tx_complete_work;
-	struct ath_btcoex_info btcoex_info;
 	struct ath_btcoex btcoex;
 };
 
diff --git a/drivers/net/wireless/ath/ath9k/btcoex.c b/drivers/net/wireless/ath/ath9k/btcoex.c
index e88a0a3..dfbcbd0 100644
--- a/drivers/net/wireless/ath/ath9k/btcoex.c
+++ b/drivers/net/wireless/ath/ath9k/btcoex.c
@@ -43,14 +43,29 @@ bool ath_btcoex_supported(u16 subsysid)
 	return false;
 }
 
+static void ath_btcoex_set_weight(struct ath_btcoex_info *btcoex_info,
+				  u32 bt_weight,
+				  u32 wlan_weight)
+{
+	btcoex_info->bt_coex_weights = SM(bt_weight, AR_BTCOEX_BT_WGHT) |
+				       SM(wlan_weight, AR_BTCOEX_WL_WGHT);
+}
+
+void ath9k_hw_btcoex_init_weight(struct ath_hw *ah)
+{
+	ath_btcoex_set_weight(&ah->btcoex_info, AR_BT_COEX_WGHT,
+			      AR_STOMP_LOW_WLAN_WGHT);
+}
+
 /*
  * Detects if there is any priority bt traffic
  */
 static void ath_detect_bt_priority(struct ath_softc *sc)
 {
 	struct ath_btcoex *btcoex = &sc->btcoex;
+	struct ath_hw *ah = sc->sc_ah;
 
-	if (ath9k_hw_gpio_get(sc->sc_ah, sc->btcoex_info.btpriority_gpio))
+	if (ath9k_hw_gpio_get(sc->sc_ah, ah->btcoex_info.btpriority_gpio))
 		btcoex->bt_priority_cnt++;
 
 	if (time_after(jiffies, btcoex->bt_priority_time +
@@ -106,8 +121,9 @@ static void ath_btcoex_bt_stomp(struct ath_softc *sc,
 static void ath_btcoex_period_timer(unsigned long data)
 {
 	struct ath_softc *sc = (struct ath_softc *) data;
+	struct ath_hw *ah = sc->sc_ah;
 	struct ath_btcoex *btcoex = &sc->btcoex;
-	struct ath_btcoex_info *btinfo = &sc->btcoex_info;
+	struct ath_btcoex_info *btinfo = &ah->btcoex_info;
 
 	ath_detect_bt_priority(sc);
 
@@ -119,9 +135,9 @@ static void ath_btcoex_period_timer(unsigned long data)
 
 	if (btcoex->btcoex_period != btcoex->btcoex_no_stomp) {
 		if (btcoex->hw_timer_enabled)
-			ath_gen_timer_stop(sc->sc_ah, btinfo->no_stomp_timer);
+			ath_gen_timer_stop(ah, btinfo->no_stomp_timer);
 
-		ath_gen_timer_start(sc->sc_ah,
+		ath_gen_timer_start(ah,
 			btinfo->no_stomp_timer,
 			(ath9k_hw_gettsf32(sc->sc_ah) +
 				btcoex->btcoex_no_stomp),
@@ -141,10 +157,11 @@ static void ath_btcoex_period_timer(unsigned long data)
 static void ath_btcoex_no_stomp_timer(void *arg)
 {
 	struct ath_softc *sc = (struct ath_softc *)arg;
+	struct ath_hw *ah = sc->sc_ah;
 	struct ath_btcoex *btcoex = &sc->btcoex;
-	struct ath_btcoex_info *btinfo = &sc->btcoex_info;
+	struct ath_btcoex_info *btinfo = &ah->btcoex_info;
 
-	DPRINTF(sc->sc_ah, ATH_DBG_BTCOEX, "no stomp timer running \n");
+	DPRINTF(ah, ATH_DBG_BTCOEX, "no stomp timer running \n");
 
 	spin_lock_bh(&btcoex->btcoex_lock);
 
@@ -156,14 +173,14 @@ static void ath_btcoex_no_stomp_timer(void *arg)
 	spin_unlock_bh(&btcoex->btcoex_lock);
 }
 
-static int ath_init_btcoex_info(struct ath_hw *hw,
+static int ath_init_btcoex_info(struct ath_hw *ah,
 				struct ath_btcoex_info *btcoex_info)
 {
-	struct ath_btcoex *btcoex = &hw->ah_sc->btcoex;
+	struct ath_btcoex *btcoex = &ah->ah_sc->btcoex;
 	u32 i;
 	int qnum;
 
-	qnum = ath_tx_get_qnum(hw->ah_sc, ATH9K_TX_QUEUE_DATA, ATH9K_WME_AC_BE);
+	qnum = ath_tx_get_qnum(ah->ah_sc, ATH9K_TX_QUEUE_DATA, ATH9K_WME_AC_BE);
 
 	btcoex_info->bt_coex_mode =
 		(btcoex_info->bt_coex_mode & AR_BT_QCU_THRESH) |
@@ -190,15 +207,15 @@ static int ath_init_btcoex_info(struct ath_hw *hw,
 		btcoex->btcoex_period / 100;
 
 	for (i = 0; i < 32; i++)
-		hw->hw_gen_timers.gen_timer_index[(debruijn32 << i) >> 27] = i;
+		ah->hw_gen_timers.gen_timer_index[(debruijn32 << i) >> 27] = i;
 
 	setup_timer(&btcoex->period_timer, ath_btcoex_period_timer,
-			(unsigned long) hw->ah_sc);
+			(unsigned long) ah->ah_sc);
 
-	btcoex_info->no_stomp_timer = ath_gen_timer_alloc(hw,
+	btcoex_info->no_stomp_timer = ath_gen_timer_alloc(ah,
 			ath_btcoex_no_stomp_timer,
 			ath_btcoex_no_stomp_timer,
-			(void *)hw->ah_sc, AR_FIRST_NDP_TIMER);
+			(void *)ah->ah_sc, AR_FIRST_NDP_TIMER);
 
 	if (btcoex_info->no_stomp_timer == NULL)
 		return -ENOMEM;
@@ -210,7 +227,7 @@ static int ath_init_btcoex_info(struct ath_hw *hw,
 
 int ath9k_hw_btcoex_init(struct ath_hw *ah)
 {
-	struct ath_btcoex_info *btcoex_info = &ah->ah_sc->btcoex_info;
+	struct ath_btcoex_info *btcoex_info = &ah->btcoex_info;
 	int ret = 0;
 
 	if (btcoex_info->btcoex_scheme == ATH_BTCOEX_CFG_2WIRE) {
@@ -258,7 +275,7 @@ int ath9k_hw_btcoex_init(struct ath_hw *ah)
 
 void ath9k_hw_btcoex_enable(struct ath_hw *ah)
 {
-	struct ath_btcoex_info *btcoex_info = &ah->ah_sc->btcoex_info;
+	struct ath_btcoex_info *btcoex_info = &ah->btcoex_info;
 
 	if (btcoex_info->btcoex_scheme == ATH_BTCOEX_CFG_2WIRE) {
 		/* Configure the desired GPIO port for TX_FRAME output */
@@ -291,7 +308,7 @@ void ath9k_hw_btcoex_enable(struct ath_hw *ah)
 
 void ath9k_hw_btcoex_disable(struct ath_hw *ah)
 {
-	struct ath_btcoex_info *btcoex_info = &ah->ah_sc->btcoex_info;
+	struct ath_btcoex_info *btcoex_info = &ah->btcoex_info;
 
 	ath9k_hw_set_gpio(ah, btcoex_info->wlanactive_gpio, 0);
 
@@ -313,11 +330,12 @@ void ath9k_hw_btcoex_disable(struct ath_hw *ah)
 void ath_btcoex_timer_pause(struct ath_softc *sc)
 {
 	struct ath_btcoex *btcoex = &sc->btcoex;
+	struct ath_hw *ah = sc->sc_ah;
 
 	del_timer_sync(&btcoex->period_timer);
 
 	if (btcoex->hw_timer_enabled)
-		ath_gen_timer_stop(sc->sc_ah, sc->btcoex_info.no_stomp_timer);
+		ath_gen_timer_stop(ah, ah->btcoex_info.no_stomp_timer);
 
 	btcoex->hw_timer_enabled = false;
 }
@@ -328,12 +346,13 @@ void ath_btcoex_timer_pause(struct ath_softc *sc)
 void ath_btcoex_timer_resume(struct ath_softc *sc)
 {
 	struct ath_btcoex *btcoex = &sc->btcoex;
+	struct ath_hw *ah = sc->sc_ah;
 
-	DPRINTF(sc->sc_ah, ATH_DBG_BTCOEX, "Starting btcoex timers");
+	DPRINTF(ah, ATH_DBG_BTCOEX, "Starting btcoex timers");
 
 	/* make sure duty cycle timer is also stopped when resuming */
 	if (btcoex->hw_timer_enabled)
-		ath_gen_timer_stop(sc->sc_ah, sc->btcoex_info.no_stomp_timer);
+		ath_gen_timer_stop(sc->sc_ah, ah->btcoex_info.no_stomp_timer);
 
 	btcoex->bt_priority_cnt = 0;
 	btcoex->bt_priority_time = jiffies;
diff --git a/drivers/net/wireless/ath/ath9k/btcoex.h b/drivers/net/wireless/ath/ath9k/btcoex.h
index 6cbbc14..12e86b7 100644
--- a/drivers/net/wireless/ath/ath9k/btcoex.h
+++ b/drivers/net/wireless/ath/ath9k/btcoex.h
@@ -17,6 +17,8 @@
 #ifndef BTCOEX_H
 #define BTCOEX_H
 
+#include "hw.h"
+
 #define ATH_WLANACTIVE_GPIO	5
 #define ATH_BTACTIVE_GPIO	6
 #define ATH_BTPRIORITY_GPIO	7
@@ -74,19 +76,9 @@ struct ath_btcoex_info {
 };
 
 bool ath_btcoex_supported(u16 subsysid);
+void ath9k_hw_btcoex_init_weight(struct ath_hw *ah);
 int ath9k_hw_btcoex_init(struct ath_hw *ah);
 void ath9k_hw_btcoex_enable(struct ath_hw *ah);
 void ath9k_hw_btcoex_disable(struct ath_hw *ah);
 
-void ath_btcoex_timer_resume(struct ath_softc *sc);
-void ath_btcoex_timer_pause(struct ath_softc *sc);
-
-static inline void ath_btcoex_set_weight(struct ath_btcoex_info *btcoex_info,
-					 u32 bt_weight,
-					 u32 wlan_weight)
-{
-		btcoex_info->bt_coex_weights = SM(bt_weight, AR_BTCOEX_BT_WGHT) |
-				       SM(wlan_weight, AR_BTCOEX_WL_WGHT);
-}
-
 #endif
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 39431c3..9be5587 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -18,6 +18,7 @@
 #include <asm/unaligned.h>
 #include <linux/pci.h>
 
+#include "hw.h"
 #include "ath9k.h"
 #include "initvals.h"
 
@@ -3510,7 +3511,7 @@ void ath9k_hw_fill_cap_info(struct ath_hw *ah)
 {
 	struct ath9k_hw_capabilities *pCap = &ah->caps;
 	struct ath_regulatory *regulatory = ath9k_hw_regulatory(ah);
-	struct ath_btcoex_info *btcoex_info = &ah->ah_sc->btcoex_info;
+	struct ath_btcoex_info *btcoex_info = &ah->btcoex_info;
 
 	u16 capField = 0, eeval;
 
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 9106a0b..774dc08 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -27,6 +27,7 @@
 #include "calib.h"
 #include "reg.h"
 #include "phy.h"
+#include "btcoex.h"
 
 #include "../regd.h"
 
@@ -553,6 +554,9 @@ struct ath_hw {
 	int firpwr[5];
 	enum ath9k_ani_cmd ani_function;
 
+	/* Bluetooth coexistance */
+	struct ath_btcoex_info btcoex_info;
+
 	u32 intr_txqs;
 	enum ath9k_ht_extprotspacing extprotspacing;
 	u8 txchainmask;
@@ -675,4 +679,7 @@ u32 ath9k_hw_gettsf32(struct ath_hw *ah);
 #define ATH_PCIE_CAP_LINK_L1	2
 
 void ath_pcie_aspm_disable(struct ath_softc *sc);
+
+void ath_btcoex_timer_resume(struct ath_softc *sc);
+void ath_btcoex_timer_pause(struct ath_softc *sc);
 #endif
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 7805323..defbe9f 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -16,6 +16,7 @@
 
 #include <linux/nl80211.h>
 #include "ath9k.h"
+#include "btcoex.h"
 
 static char *dev_info = "ath9k";
 
@@ -439,8 +440,10 @@ static void ath_start_ani(struct ath_softc *sc)
  */
 void ath_update_chainmask(struct ath_softc *sc, int is_ht)
 {
+	struct ath_hw *ah = sc->sc_ah;
+
 	if ((sc->sc_flags & SC_OP_SCANNING) || is_ht ||
-	    (sc->btcoex_info.btcoex_scheme != ATH_BTCOEX_CFG_NONE)) {
+	    (ah->btcoex_info.btcoex_scheme != ATH_BTCOEX_CFG_NONE)) {
 		sc->tx_chainmask = sc->sc_ah->caps.tx_chainmask;
 		sc->rx_chainmask = sc->sc_ah->caps.rx_chainmask;
 	} else {
@@ -448,7 +451,7 @@ void ath_update_chainmask(struct ath_softc *sc, int is_ht)
 		sc->rx_chainmask = 1;
 	}
 
-	DPRINTF(sc->sc_ah, ATH_DBG_CONFIG, "tx chmask: %d, rx chmask: %d\n",
+	DPRINTF(ah, ATH_DBG_CONFIG, "tx chmask: %d, rx chmask: %d\n",
 		sc->tx_chainmask, sc->rx_chainmask);
 }
 
@@ -478,6 +481,8 @@ static void ath_node_detach(struct ath_softc *sc, struct ieee80211_sta *sta)
 static void ath9k_tasklet(unsigned long data)
 {
 	struct ath_softc *sc = (struct ath_softc *)data;
+	struct ath_hw *ah = sc->sc_ah;
+
 	u32 status = sc->intrstatus;
 
 	ath9k_ps_wakeup(sc);
@@ -502,16 +507,16 @@ static void ath9k_tasklet(unsigned long data)
 		 * TSF sync does not look correct; remain awake to sync with
 		 * the next Beacon.
 		 */
-		DPRINTF(sc->sc_ah, ATH_DBG_PS, "TSFOOR - Sync with next Beacon\n");
+		DPRINTF(ah, ATH_DBG_PS, "TSFOOR - Sync with next Beacon\n");
 		sc->sc_flags |= SC_OP_WAIT_FOR_BEACON | SC_OP_BEACON_SYNC;
 	}
 
-	if (sc->btcoex_info.btcoex_scheme == ATH_BTCOEX_CFG_3WIRE)
+	if (ah->btcoex_info.btcoex_scheme == ATH_BTCOEX_CFG_3WIRE)
 		if (status & ATH9K_INT_GENTIMER)
 			ath_gen_timer_isr(sc->sc_ah);
 
 	/* re-enable hardware interrupt */
-	ath9k_hw_set_interrupts(sc->sc_ah, sc->imask);
+	ath9k_hw_set_interrupts(ah, sc->imask);
 	ath9k_ps_restore(sc);
 }
 
@@ -1285,12 +1290,12 @@ void ath_detach(struct ath_softc *sc)
 		if (ATH_TXQ_SETUP(sc, i))
 			ath_tx_cleanupq(sc, &sc->tx.txq[i]);
 
-	if ((sc->btcoex_info.no_stomp_timer) &&
-	    sc->btcoex_info.btcoex_scheme == ATH_BTCOEX_CFG_3WIRE)
-		ath_gen_timer_free(ah, sc->btcoex_info.no_stomp_timer);
+	if ((ah->btcoex_info.no_stomp_timer) &&
+	    ah->btcoex_info.btcoex_scheme == ATH_BTCOEX_CFG_3WIRE)
+		ath_gen_timer_free(ah, ah->btcoex_info.no_stomp_timer);
 
 	ath9k_hw_detach(ah);
-	ath9k_exit_debug(sc->sc_ah);
+	ath9k_exit_debug(ah);
 	sc->sc_ah = NULL;
 }
 
@@ -1520,7 +1525,7 @@ static int ath_init_softc(u16 devid, struct ath_softc *sc, u16 subsysid)
 			ARRAY_SIZE(ath9k_5ghz_chantable);
 	}
 
-	if (sc->btcoex_info.btcoex_scheme != ATH_BTCOEX_CFG_NONE) {
+	if (ah->btcoex_info.btcoex_scheme != ATH_BTCOEX_CFG_NONE) {
 		r = ath9k_hw_btcoex_init(ah);
 		if (r)
 			goto bad2;
@@ -1909,11 +1914,12 @@ static int ath9k_start(struct ieee80211_hw *hw)
 {
 	struct ath_wiphy *aphy = hw->priv;
 	struct ath_softc *sc = aphy->sc;
+	struct ath_hw *ah = sc->sc_ah;
 	struct ieee80211_channel *curchan = hw->conf.channel;
 	struct ath9k_channel *init_channel;
 	int r;
 
-	DPRINTF(sc->sc_ah, ATH_DBG_CONFIG, "Starting driver with "
+	DPRINTF(ah, ATH_DBG_CONFIG, "Starting driver with "
 		"initial channel: %d MHz\n", curchan->center_freq);
 
 	mutex_lock(&sc->mutex);
@@ -1946,7 +1952,7 @@ static int ath9k_start(struct ieee80211_hw *hw)
 	init_channel = ath_get_curchannel(sc, hw);
 
 	/* Reset SERDES registers */
-	ath9k_hw_configpcipowersave(sc->sc_ah, 0);
+	ath9k_hw_configpcipowersave(ah, 0);
 
 	/*
 	 * The basic interface to setting the hardware in a good
@@ -1956,9 +1962,9 @@ static int ath9k_start(struct ieee80211_hw *hw)
 	 * and then setup of the interrupt mask.
 	 */
 	spin_lock_bh(&sc->sc_resetlock);
-	r = ath9k_hw_reset(sc->sc_ah, init_channel, false);
+	r = ath9k_hw_reset(ah, init_channel, false);
 	if (r) {
-		DPRINTF(sc->sc_ah, ATH_DBG_FATAL,
+		DPRINTF(ah, ATH_DBG_FATAL,
 			"Unable to reset hardware; reset status %d "
 			"(freq %u MHz)\n", r,
 			curchan->center_freq);
@@ -1981,7 +1987,7 @@ static int ath9k_start(struct ieee80211_hw *hw)
 	 * here except setup the interrupt mask.
 	 */
 	if (ath_startrecv(sc) != 0) {
-		DPRINTF(sc->sc_ah, ATH_DBG_FATAL, "Unable to start recv logic\n");
+		DPRINTF(ah, ATH_DBG_FATAL, "Unable to start recv logic\n");
 		r = -EIO;
 		goto mutex_unlock;
 	}
@@ -1991,10 +1997,10 @@ static int ath9k_start(struct ieee80211_hw *hw)
 		| ATH9K_INT_RXEOL | ATH9K_INT_RXORN
 		| ATH9K_INT_FATAL | ATH9K_INT_GLOBAL;
 
-	if (sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_GTT)
+	if (ah->caps.hw_caps & ATH9K_HW_CAP_GTT)
 		sc->imask |= ATH9K_INT_GTT;
 
-	if (sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_HT)
+	if (ah->caps.hw_caps & ATH9K_HW_CAP_HT)
 		sc->imask |= ATH9K_INT_CST;
 
 	ath_cache_conf_rate(sc, &hw->conf);
@@ -2003,20 +2009,19 @@ static int ath9k_start(struct ieee80211_hw *hw)
 
 	/* Disable BMISS interrupt when we're not associated */
 	sc->imask &= ~(ATH9K_INT_SWBA | ATH9K_INT_BMISS);
-	ath9k_hw_set_interrupts(sc->sc_ah, sc->imask);
+	ath9k_hw_set_interrupts(ah, sc->imask);
 
 	ieee80211_wake_queues(hw);
 
 	ieee80211_queue_delayed_work(sc->hw, &sc->tx_complete_work, 0);
 
-	if ((sc->btcoex_info.btcoex_scheme != ATH_BTCOEX_CFG_NONE) &&
+	if ((ah->btcoex_info.btcoex_scheme != ATH_BTCOEX_CFG_NONE) &&
 	    !(sc->sc_flags & SC_OP_BTCOEX_ENABLED)) {
-		ath_btcoex_set_weight(&sc->btcoex_info, AR_BT_COEX_WGHT,
-				      AR_STOMP_LOW_WLAN_WGHT);
-		ath9k_hw_btcoex_enable(sc->sc_ah);
+		ath9k_hw_btcoex_init_weight(ah);
+		ath9k_hw_btcoex_enable(ah);
 
 		ath_pcie_aspm_disable(sc);
-		if (sc->btcoex_info.btcoex_scheme == ATH_BTCOEX_CFG_3WIRE)
+		if (ah->btcoex_info.btcoex_scheme == ATH_BTCOEX_CFG_3WIRE)
 			ath_btcoex_timer_resume(sc);
 	}
 
@@ -2129,6 +2134,7 @@ static void ath9k_stop(struct ieee80211_hw *hw)
 {
 	struct ath_wiphy *aphy = hw->priv;
 	struct ath_softc *sc = aphy->sc;
+	struct ath_hw *ah = sc->sc_ah;
 
 	mutex_lock(&sc->mutex);
 
@@ -2143,7 +2149,7 @@ static void ath9k_stop(struct ieee80211_hw *hw)
 	}
 
 	if (sc->sc_flags & SC_OP_INVALID) {
-		DPRINTF(sc->sc_ah, ATH_DBG_ANY, "Device not present\n");
+		DPRINTF(ah, ATH_DBG_ANY, "Device not present\n");
 		mutex_unlock(&sc->mutex);
 		return;
 	}
@@ -2154,34 +2160,34 @@ static void ath9k_stop(struct ieee80211_hw *hw)
 	}
 
 	if (sc->sc_flags & SC_OP_BTCOEX_ENABLED) {
-		ath9k_hw_btcoex_disable(sc->sc_ah);
-		if (sc->btcoex_info.btcoex_scheme == ATH_BTCOEX_CFG_3WIRE)
+		ath9k_hw_btcoex_disable(ah);
+		if (ah->btcoex_info.btcoex_scheme == ATH_BTCOEX_CFG_3WIRE)
 			ath_btcoex_timer_pause(sc);
 	}
 
 	/* make sure h/w will not generate any interrupt
 	 * before setting the invalid flag. */
-	ath9k_hw_set_interrupts(sc->sc_ah, 0);
+	ath9k_hw_set_interrupts(ah, 0);
 
 	if (!(sc->sc_flags & SC_OP_INVALID)) {
 		ath_drain_all_txq(sc, false);
 		ath_stoprecv(sc);
-		ath9k_hw_phy_disable(sc->sc_ah);
+		ath9k_hw_phy_disable(ah);
 	} else
 		sc->rx.rxlink = NULL;
 
 	wiphy_rfkill_stop_polling(sc->hw->wiphy);
 
 	/* disable HAL and put h/w to sleep */
-	ath9k_hw_disable(sc->sc_ah);
-	ath9k_hw_configpcipowersave(sc->sc_ah, 1);
-	ath9k_hw_setpower(sc->sc_ah, ATH9K_PM_FULL_SLEEP);
+	ath9k_hw_disable(ah);
+	ath9k_hw_configpcipowersave(ah, 1);
+	ath9k_hw_setpower(ah, ATH9K_PM_FULL_SLEEP);
 
 	sc->sc_flags |= SC_OP_INVALID;
 
 	mutex_unlock(&sc->mutex);
 
-	DPRINTF(sc->sc_ah, ATH_DBG_CONFIG, "Driver halt\n");
+	DPRINTF(ah, ATH_DBG_CONFIG, "Driver halt\n");
 }
 
 static int ath9k_add_interface(struct ieee80211_hw *hw,
-- 
1.6.3.3

