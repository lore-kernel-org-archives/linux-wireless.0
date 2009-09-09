Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:54076 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754715AbZIIXpE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Sep 2009 19:45:04 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	devel@linuxdriverproject.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 11/15] ath9k: rename ath_btcoex_info to ath_btcoex_hw
Date: Wed,  9 Sep 2009 19:44:57 -0400
Message-Id: <1252539901-20679-12-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1252539901-20679-1-git-send-email-lrodriguez@atheros.com>
References: <1252539901-20679-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/btcoex.c |   60 +++++++++++++++---------------
 drivers/net/wireless/ath/ath9k/btcoex.h |    4 +-
 drivers/net/wireless/ath/ath9k/hw.c     |   16 ++++----
 drivers/net/wireless/ath/ath9k/hw.h     |    2 +-
 drivers/net/wireless/ath/ath9k/main.c   |   46 ++++++++++++------------
 5 files changed, 64 insertions(+), 64 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/btcoex.c b/drivers/net/wireless/ath/ath9k/btcoex.c
index aa0ec2c..0b5a7d4 100644
--- a/drivers/net/wireless/ath/ath9k/btcoex.c
+++ b/drivers/net/wireless/ath/ath9k/btcoex.c
@@ -43,13 +43,13 @@ bool ath_btcoex_supported(u16 subsysid)
 	return false;
 }
 
-void ath9k_hw_init_btcoex_hw_info(struct ath_hw *ah, int qnum)
+void ath9k_hw_init_btcoex_hw(struct ath_hw *ah, int qnum)
 {
-	struct ath_btcoex_info *btcoex_info = &ah->btcoex_info;
+	struct ath_btcoex_hw *btcoex_hw = &ah->btcoex_hw;
 	u32 i;
 
-	btcoex_info->bt_coex_mode =
-		(btcoex_info->bt_coex_mode & AR_BT_QCU_THRESH) |
+	btcoex_hw->bt_coex_mode =
+		(btcoex_hw->bt_coex_mode & AR_BT_QCU_THRESH) |
 		SM(ath_bt_config.bt_time_extend, AR_BT_TIME_EXTEND) |
 		SM(ath_bt_config.bt_txstate_extend, AR_BT_TXSTATE_EXTEND) |
 		SM(ath_bt_config.bt_txframe_extend, AR_BT_TX_FRAME_EXTEND) |
@@ -60,7 +60,7 @@ void ath9k_hw_init_btcoex_hw_info(struct ath_hw *ah, int qnum)
 		SM(ath_bt_config.bt_first_slot_time, AR_BT_FIRST_SLOT_TIME) |
 		SM(qnum, AR_BT_QCU_THRESH);
 
-	btcoex_info->bt_coex_mode2 =
+	btcoex_hw->bt_coex_mode2 =
 		SM(ath_bt_config.bt_hold_rx_clear, AR_BT_HOLD_RX_CLEAR) |
 		SM(ATH_BTCOEX_BMISS_THRESH, AR_BT_BCN_MISS_THRESH) |
 		AR_BT_DISABLE_BT_ANT;
@@ -71,7 +71,7 @@ void ath9k_hw_init_btcoex_hw_info(struct ath_hw *ah, int qnum)
 
 void ath9k_hw_btcoex_init_2wire(struct ath_hw *ah)
 {
-	struct ath_btcoex_info *btcoex_info = &ah->btcoex_info;
+	struct ath_btcoex_hw *btcoex_hw = &ah->btcoex_hw;
 
 	/* connect bt_active to baseband */
 	REG_CLR_BIT(ah, AR_GPIO_INPUT_EN_VAL,
@@ -84,15 +84,15 @@ void ath9k_hw_btcoex_init_2wire(struct ath_hw *ah)
 	/* Set input mux for bt_active to gpio pin */
 	REG_RMW_FIELD(ah, AR_GPIO_INPUT_MUX1,
 		      AR_GPIO_INPUT_MUX1_BT_ACTIVE,
-		      btcoex_info->btactive_gpio);
+		      btcoex_hw->btactive_gpio);
 
 	/* Configure the desired gpio port for input */
-	ath9k_hw_cfg_gpio_input(ah, btcoex_info->btactive_gpio);
+	ath9k_hw_cfg_gpio_input(ah, btcoex_hw->btactive_gpio);
 }
 
 void ath9k_hw_btcoex_init_3wire(struct ath_hw *ah)
 {
-	struct ath_btcoex_info *btcoex_info = &ah->btcoex_info;
+	struct ath_btcoex_hw *btcoex_hw = &ah->btcoex_hw;
 
 	/* btcoex 3-wire */
 	REG_SET_BIT(ah, AR_GPIO_INPUT_EN_VAL,
@@ -103,51 +103,51 @@ void ath9k_hw_btcoex_init_3wire(struct ath_hw *ah)
 	 *                  bt_active_async to GPIO pins */
 	REG_RMW_FIELD(ah, AR_GPIO_INPUT_MUX1,
 			AR_GPIO_INPUT_MUX1_BT_ACTIVE,
-			btcoex_info->btactive_gpio);
+			btcoex_hw->btactive_gpio);
 
 	REG_RMW_FIELD(ah, AR_GPIO_INPUT_MUX1,
 			AR_GPIO_INPUT_MUX1_BT_PRIORITY,
-			btcoex_info->btpriority_gpio);
+			btcoex_hw->btpriority_gpio);
 
 	/* Configure the desired GPIO ports for input */
 
-	ath9k_hw_cfg_gpio_input(ah, btcoex_info->btactive_gpio);
-	ath9k_hw_cfg_gpio_input(ah, btcoex_info->btpriority_gpio);
+	ath9k_hw_cfg_gpio_input(ah, btcoex_hw->btactive_gpio);
+	ath9k_hw_cfg_gpio_input(ah, btcoex_hw->btpriority_gpio);
 }
 
 static void ath9k_hw_btcoex_enable_2wire(struct ath_hw *ah)
 {
-	struct ath_btcoex_info *btcoex_info = &ah->btcoex_info;
+	struct ath_btcoex_hw *btcoex_hw = &ah->btcoex_hw;
 
 	/* Configure the desired GPIO port for TX_FRAME output */
-	ath9k_hw_cfg_output(ah, btcoex_info->wlanactive_gpio,
+	ath9k_hw_cfg_output(ah, btcoex_hw->wlanactive_gpio,
 			    AR_GPIO_OUTPUT_MUX_AS_TX_FRAME);
 }
 
 static void ath9k_hw_btcoex_enable_3wire(struct ath_hw *ah)
 {
-	struct ath_btcoex_info *btcoex_info = &ah->btcoex_info;
+	struct ath_btcoex_hw *btcoex_hw = &ah->btcoex_hw;
 
 	/*
 	 * Program coex mode and weight registers to
 	 * enable coex 3-wire
 	 */
-	REG_WRITE(ah, AR_BT_COEX_MODE, btcoex_info->bt_coex_mode);
-	REG_WRITE(ah, AR_BT_COEX_WEIGHT, btcoex_info->bt_coex_weights);
-	REG_WRITE(ah, AR_BT_COEX_MODE2, btcoex_info->bt_coex_mode2);
+	REG_WRITE(ah, AR_BT_COEX_MODE, btcoex_hw->bt_coex_mode);
+	REG_WRITE(ah, AR_BT_COEX_WEIGHT, btcoex_hw->bt_coex_weights);
+	REG_WRITE(ah, AR_BT_COEX_MODE2, btcoex_hw->bt_coex_mode2);
 
 	REG_RMW_FIELD(ah, AR_QUIET1, AR_QUIET1_QUIET_ACK_CTS_ENABLE, 1);
 	REG_RMW_FIELD(ah, AR_PCU_MISC, AR_PCU_BT_ANT_PREVENT_RX, 0);
 
-	ath9k_hw_cfg_output(ah, btcoex_info->wlanactive_gpio,
+	ath9k_hw_cfg_output(ah, btcoex_hw->wlanactive_gpio,
 			    AR_GPIO_OUTPUT_MUX_AS_RX_CLEAR_EXTERNAL);
 }
 
 void ath9k_hw_btcoex_enable(struct ath_hw *ah)
 {
-	struct ath_btcoex_info *btcoex_info = &ah->btcoex_info;
+	struct ath_btcoex_hw *btcoex_hw = &ah->btcoex_hw;
 
-	switch (btcoex_info->scheme) {
+	switch (btcoex_hw->scheme) {
 	case ATH_BTCOEX_CFG_NONE:
 		break;
 	case ATH_BTCOEX_CFG_2WIRE:
@@ -159,26 +159,26 @@ void ath9k_hw_btcoex_enable(struct ath_hw *ah)
 	}
 
 	REG_RMW(ah, AR_GPIO_PDPU,
-		(0x2 << (btcoex_info->btactive_gpio * 2)),
-		(0x3 << (btcoex_info->btactive_gpio * 2)));
+		(0x2 << (btcoex_hw->btactive_gpio * 2)),
+		(0x3 << (btcoex_hw->btactive_gpio * 2)));
 
-	ah->btcoex_info.enabled = true;
+	ah->btcoex_hw.enabled = true;
 }
 
 void ath9k_hw_btcoex_disable(struct ath_hw *ah)
 {
-	struct ath_btcoex_info *btcoex_info = &ah->btcoex_info;
+	struct ath_btcoex_hw *btcoex_hw = &ah->btcoex_hw;
 
-	ath9k_hw_set_gpio(ah, btcoex_info->wlanactive_gpio, 0);
+	ath9k_hw_set_gpio(ah, btcoex_hw->wlanactive_gpio, 0);
 
-	ath9k_hw_cfg_output(ah, btcoex_info->wlanactive_gpio,
+	ath9k_hw_cfg_output(ah, btcoex_hw->wlanactive_gpio,
 			AR_GPIO_OUTPUT_MUX_AS_OUTPUT);
 
-	if (btcoex_info->scheme == ATH_BTCOEX_CFG_3WIRE) {
+	if (btcoex_hw->scheme == ATH_BTCOEX_CFG_3WIRE) {
 		REG_WRITE(ah, AR_BT_COEX_MODE, AR_BT_QUIET | AR_BT_MODE);
 		REG_WRITE(ah, AR_BT_COEX_WEIGHT, 0);
 		REG_WRITE(ah, AR_BT_COEX_MODE2, 0);
 	}
 
-	ah->btcoex_info.enabled = false;
+	ah->btcoex_hw.enabled = false;
 }
diff --git a/drivers/net/wireless/ath/ath9k/btcoex.h b/drivers/net/wireless/ath/ath9k/btcoex.h
index aea6d3f..296ddd8 100644
--- a/drivers/net/wireless/ath/ath9k/btcoex.h
+++ b/drivers/net/wireless/ath/ath9k/btcoex.h
@@ -55,7 +55,7 @@ struct ath_btcoex_config {
 	bool bt_hold_rx_clear;
 };
 
-struct ath_btcoex_info {
+struct ath_btcoex_hw {
 	enum ath_btcoex_scheme scheme;
 	bool enabled;
 	u8 wlanactive_gpio;
@@ -69,7 +69,7 @@ struct ath_btcoex_info {
 bool ath_btcoex_supported(u16 subsysid);
 void ath9k_hw_btcoex_init_2wire(struct ath_hw *ah);
 void ath9k_hw_btcoex_init_3wire(struct ath_hw *ah);
-void ath9k_hw_init_btcoex_hw_info(struct ath_hw *ah, int qnum);
+void ath9k_hw_init_btcoex_hw(struct ath_hw *ah, int qnum);
 void ath9k_hw_btcoex_enable(struct ath_hw *ah);
 void ath9k_hw_btcoex_disable(struct ath_hw *ah);
 
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 329d404..0fc4c6e 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -2560,7 +2560,7 @@ int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_channel *chan,
 #endif
 	}
 
-	if (ah->btcoex_info.enabled)
+	if (ah->btcoex_hw.enabled)
 		ath9k_hw_btcoex_enable(ah);
 
 	return 0;
@@ -3511,7 +3511,7 @@ void ath9k_hw_fill_cap_info(struct ath_hw *ah)
 {
 	struct ath9k_hw_capabilities *pCap = &ah->caps;
 	struct ath_regulatory *regulatory = ath9k_hw_regulatory(ah);
-	struct ath_btcoex_info *btcoex_info = &ah->btcoex_info;
+	struct ath_btcoex_hw *btcoex_hw = &ah->btcoex_hw;
 
 	u16 capField = 0, eeval;
 
@@ -3689,17 +3689,17 @@ void ath9k_hw_fill_cap_info(struct ath_hw *ah)
 
 	if (AR_SREV_9280_10_OR_LATER(ah) &&
 	    ath_btcoex_supported(ah->hw_version.subsysid)) {
-		btcoex_info->btactive_gpio = ATH_BTACTIVE_GPIO;
-		btcoex_info->wlanactive_gpio = ATH_WLANACTIVE_GPIO;
+		btcoex_hw->btactive_gpio = ATH_BTACTIVE_GPIO;
+		btcoex_hw->wlanactive_gpio = ATH_WLANACTIVE_GPIO;
 
 		if (AR_SREV_9285(ah)) {
-			btcoex_info->scheme = ATH_BTCOEX_CFG_3WIRE;
-			btcoex_info->btpriority_gpio = ATH_BTPRIORITY_GPIO;
+			btcoex_hw->scheme = ATH_BTCOEX_CFG_3WIRE;
+			btcoex_hw->btpriority_gpio = ATH_BTPRIORITY_GPIO;
 		} else {
-			btcoex_info->scheme = ATH_BTCOEX_CFG_2WIRE;
+			btcoex_hw->scheme = ATH_BTCOEX_CFG_2WIRE;
 		}
 	} else {
-		btcoex_info->scheme = ATH_BTCOEX_CFG_NONE;
+		btcoex_hw->scheme = ATH_BTCOEX_CFG_NONE;
 	}
 }
 
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 6658d95..2f3bf1a 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -555,7 +555,7 @@ struct ath_hw {
 	enum ath9k_ani_cmd ani_function;
 
 	/* Bluetooth coexistance */
-	struct ath_btcoex_info btcoex_info;
+	struct ath_btcoex_hw btcoex_hw;
 
 	u32 intr_txqs;
 	enum ath9k_ht_extprotspacing extprotspacing;
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 43f1f7e..1a89e47 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -443,7 +443,7 @@ void ath_update_chainmask(struct ath_softc *sc, int is_ht)
 	struct ath_hw *ah = sc->sc_ah;
 
 	if ((sc->sc_flags & SC_OP_SCANNING) || is_ht ||
-	    (ah->btcoex_info.scheme != ATH_BTCOEX_CFG_NONE)) {
+	    (ah->btcoex_hw.scheme != ATH_BTCOEX_CFG_NONE)) {
 		sc->tx_chainmask = sc->sc_ah->caps.tx_chainmask;
 		sc->rx_chainmask = sc->sc_ah->caps.rx_chainmask;
 	} else {
@@ -511,7 +511,7 @@ static void ath9k_tasklet(unsigned long data)
 		sc->sc_flags |= SC_OP_WAIT_FOR_BEACON | SC_OP_BEACON_SYNC;
 	}
 
-	if (ah->btcoex_info.scheme == ATH_BTCOEX_CFG_3WIRE)
+	if (ah->btcoex_hw.scheme == ATH_BTCOEX_CFG_3WIRE)
 		if (status & ATH9K_INT_GENTIMER)
 			ath_gen_timer_isr(sc->sc_ah);
 
@@ -1291,7 +1291,7 @@ void ath_detach(struct ath_softc *sc)
 			ath_tx_cleanupq(sc, &sc->tx.txq[i]);
 
 	if ((sc->btcoex.no_stomp_timer) &&
-	    ah->btcoex_info.scheme == ATH_BTCOEX_CFG_3WIRE)
+	    ah->btcoex_hw.scheme == ATH_BTCOEX_CFG_3WIRE)
 		ath_gen_timer_free(ah, sc->btcoex.no_stomp_timer);
 
 	ath9k_hw_detach(ah);
@@ -1318,7 +1318,7 @@ static void ath_detect_bt_priority(struct ath_softc *sc)
 	struct ath_btcoex *btcoex = &sc->btcoex;
 	struct ath_hw *ah = sc->sc_ah;
 
-	if (ath9k_hw_gpio_get(sc->sc_ah, ah->btcoex_info.btpriority_gpio))
+	if (ath9k_hw_gpio_get(sc->sc_ah, ah->btcoex_hw.btpriority_gpio))
 		btcoex->bt_priority_cnt++;
 
 	if (time_after(jiffies, btcoex->bt_priority_time +
@@ -1336,17 +1336,17 @@ static void ath_detect_bt_priority(struct ath_softc *sc)
 	}
 }
 
-static void ath_btcoex_set_weight(struct ath_btcoex_info *btcoex_info,
+static void ath_btcoex_set_weight(struct ath_btcoex_hw *btcoex_hw,
 				  u32 bt_weight,
 				  u32 wlan_weight)
 {
-	btcoex_info->bt_coex_weights = SM(bt_weight, AR_BTCOEX_BT_WGHT) |
+	btcoex_hw->bt_coex_weights = SM(bt_weight, AR_BTCOEX_BT_WGHT) |
 				       SM(wlan_weight, AR_BTCOEX_WL_WGHT);
 }
 
 static void ath9k_hw_btcoex_init_weight(struct ath_hw *ah)
 {
-	ath_btcoex_set_weight(&ah->btcoex_info, AR_BT_COEX_WGHT,
+	ath_btcoex_set_weight(&ah->btcoex_hw, AR_BT_COEX_WGHT,
 			      AR_STOMP_LOW_WLAN_WGHT);
 }
 
@@ -1354,21 +1354,21 @@ static void ath9k_hw_btcoex_init_weight(struct ath_hw *ah)
  * Configures appropriate weight based on stomp type.
  */
 static void ath_btcoex_bt_stomp(struct ath_softc *sc,
-				struct ath_btcoex_info *btinfo,
+				struct ath_btcoex_hw *btcoex_hw,
 				int stomp_type)
 {
 
 	switch (stomp_type) {
 	case ATH_BTCOEX_STOMP_ALL:
-		ath_btcoex_set_weight(btinfo, AR_BT_COEX_WGHT,
+		ath_btcoex_set_weight(btcoex_hw, AR_BT_COEX_WGHT,
 				      AR_STOMP_ALL_WLAN_WGHT);
 		break;
 	case ATH_BTCOEX_STOMP_LOW:
-		ath_btcoex_set_weight(btinfo, AR_BT_COEX_WGHT,
+		ath_btcoex_set_weight(btcoex_hw, AR_BT_COEX_WGHT,
 				      AR_STOMP_LOW_WLAN_WGHT);
 		break;
 	case ATH_BTCOEX_STOMP_NONE:
-		ath_btcoex_set_weight(btinfo, AR_BT_COEX_WGHT,
+		ath_btcoex_set_weight(btcoex_hw, AR_BT_COEX_WGHT,
 				      AR_STOMP_NONE_WLAN_WGHT);
 		break;
 	default:
@@ -1389,13 +1389,13 @@ static void ath_btcoex_period_timer(unsigned long data)
 	struct ath_softc *sc = (struct ath_softc *) data;
 	struct ath_hw *ah = sc->sc_ah;
 	struct ath_btcoex *btcoex = &sc->btcoex;
-	struct ath_btcoex_info *btinfo = &ah->btcoex_info;
+	struct ath_btcoex_hw *btcoex_hw= &ah->btcoex_hw;
 
 	ath_detect_bt_priority(sc);
 
 	spin_lock_bh(&btcoex->btcoex_lock);
 
-	ath_btcoex_bt_stomp(sc, btinfo, btcoex->bt_stomp_type);
+	ath_btcoex_bt_stomp(sc, btcoex_hw, btcoex->bt_stomp_type);
 
 	spin_unlock_bh(&btcoex->btcoex_lock);
 
@@ -1424,16 +1424,16 @@ static void ath_btcoex_no_stomp_timer(void *arg)
 	struct ath_softc *sc = (struct ath_softc *)arg;
 	struct ath_hw *ah = sc->sc_ah;
 	struct ath_btcoex *btcoex = &sc->btcoex;
-	struct ath_btcoex_info *btinfo = &ah->btcoex_info;
+	struct ath_btcoex_hw *btcoex_hw= &ah->btcoex_hw;
 
 	DPRINTF(ah, ATH_DBG_BTCOEX, "no stomp timer running \n");
 
 	spin_lock_bh(&btcoex->btcoex_lock);
 
 	if (btcoex->bt_stomp_type == ATH_BTCOEX_STOMP_LOW)
-		ath_btcoex_bt_stomp(sc, btinfo, ATH_BTCOEX_STOMP_NONE);
+		ath_btcoex_bt_stomp(sc, btcoex_hw, ATH_BTCOEX_STOMP_NONE);
 	 else if (btcoex->bt_stomp_type == ATH_BTCOEX_STOMP_ALL)
-		ath_btcoex_bt_stomp(sc, btinfo, ATH_BTCOEX_STOMP_LOW);
+		ath_btcoex_bt_stomp(sc, btcoex_hw, ATH_BTCOEX_STOMP_LOW);
 
 	spin_unlock_bh(&btcoex->btcoex_lock);
 }
@@ -1678,7 +1678,7 @@ static int ath_init_softc(u16 devid, struct ath_softc *sc, u16 subsysid)
 			ARRAY_SIZE(ath9k_5ghz_chantable);
 	}
 
-	switch (ah->btcoex_info.scheme) {
+	switch (ah->btcoex_hw.scheme) {
 	case ATH_BTCOEX_CFG_NONE:
 		break;
 	case ATH_BTCOEX_CFG_2WIRE:
@@ -1690,7 +1690,7 @@ static int ath_init_softc(u16 devid, struct ath_softc *sc, u16 subsysid)
 		if (r)
 			goto bad2;
 		qnum = ath_tx_get_qnum(sc, ATH9K_TX_QUEUE_DATA, ATH9K_WME_AC_BE);
-		ath9k_hw_init_btcoex_hw_info(ah, qnum);
+		ath9k_hw_init_btcoex_hw(ah, qnum);
 		sc->btcoex.bt_stomp_type = ATH_BTCOEX_STOMP_LOW;
 		break;
 	default:
@@ -2203,13 +2203,13 @@ static int ath9k_start(struct ieee80211_hw *hw)
 
 	ieee80211_queue_delayed_work(sc->hw, &sc->tx_complete_work, 0);
 
-	if ((ah->btcoex_info.scheme != ATH_BTCOEX_CFG_NONE) &&
-	    !ah->btcoex_info.enabled) {
+	if ((ah->btcoex_hw.scheme != ATH_BTCOEX_CFG_NONE) &&
+	    !ah->btcoex_hw.enabled) {
 		ath9k_hw_btcoex_init_weight(ah);
 		ath9k_hw_btcoex_enable(ah);
 
 		ath_pcie_aspm_disable(sc);
-		if (ah->btcoex_info.scheme == ATH_BTCOEX_CFG_3WIRE)
+		if (ah->btcoex_hw.scheme == ATH_BTCOEX_CFG_3WIRE)
 			ath9k_btcoex_timer_resume(sc);
 	}
 
@@ -2363,9 +2363,9 @@ static void ath9k_stop(struct ieee80211_hw *hw)
 		return; /* another wiphy still in use */
 	}
 
-	if (ah->btcoex_info.enabled) {
+	if (ah->btcoex_hw.enabled) {
 		ath9k_hw_btcoex_disable(ah);
-		if (ah->btcoex_info.scheme == ATH_BTCOEX_CFG_3WIRE)
+		if (ah->btcoex_hw.scheme == ATH_BTCOEX_CFG_3WIRE)
 			ath9k_btcoex_timer_pause(sc);
 	}
 
-- 
1.6.3.3

