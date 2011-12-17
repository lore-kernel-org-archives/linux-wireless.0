Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:33267 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751502Ab1LQPsM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 Dec 2011 10:48:12 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, mcgrof@qca.qualcomm.com
Subject: [PATCH v2] ath9k_hw: make bluetooth coexistence support optional at compile time
Date: Sat, 17 Dec 2011 16:47:56 +0100
Message-Id: <1324136876-28071-1-git-send-email-nbd@openwrt.org> (sfid-20111217_164831_927211_3533A54A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Many systems (e.g. embedded systems) do not have wifi modules connected to
bluetooth modules, so bluetooth coexistence is irrelevant there. With the
addition of MCI support, ath9k picked up quite a bit of extra code that
can be compiled out this way.

This patch redefines ATH9K_HW_CAP_MCI and adds an inline wrapper for
querying the bluetooth coexistence scheme, allowing the compiler to
eliminate code that uses it, with only very little use of #ifdef.

On MIPS this reduces the total size for the modules by about 20k.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/Kconfig        |    8 ++++
 drivers/net/wireless/ath/ath9k/ar9003_mci.c   |   54 +++++++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/btcoex.c       |   25 ++++++++++-
 drivers/net/wireless/ath/ath9k/gpio.c         |    9 ++++
 drivers/net/wireless/ath/ath9k/htc_drv_gpio.c |    9 ++++
 drivers/net/wireless/ath/ath9k/htc_drv_init.c |    5 +-
 drivers/net/wireless/ath/ath9k/htc_drv_main.c |    5 +-
 drivers/net/wireless/ath/ath9k/hw.c           |    3 +-
 drivers/net/wireless/ath/ath9k/hw.h           |   14 ++++++
 drivers/net/wireless/ath/ath9k/init.c         |    6 +-
 drivers/net/wireless/ath/ath9k/main.c         |   13 +++---
 drivers/net/wireless/ath/ath9k/mci.c          |    9 ++++
 drivers/net/wireless/ath/ath9k/pci.c          |    2 +-
 13 files changed, 145 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/Kconfig b/drivers/net/wireless/ath/ath9k/Kconfig
index 1b4786a..dc6be4a 100644
--- a/drivers/net/wireless/ath/ath9k/Kconfig
+++ b/drivers/net/wireless/ath/ath9k/Kconfig
@@ -81,6 +81,14 @@ config ATH9K_RATE_CONTROL
 	  Say Y, if you want to use the ath9k specific rate control
 	  module instead of minstrel_ht.
 
+config ATH9K_BTCOEX_SUPPORT
+	bool "Atheros ath9k bluetooth coexistence support"
+	depends on ATH9K
+	default y
+	---help---
+	  Say Y, if you want to use the ath9k radios together with
+	  Bluetooth modules in the same system.
+
 config ATH9K_HTC
        tristate "Atheros HTC based wireless cards support"
        depends on USB && MAC80211
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_mci.c b/drivers/net/wireless/ath/ath9k/ar9003_mci.c
index 8599822..4905af9 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_mci.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_mci.c
@@ -85,6 +85,9 @@ void ar9003_mci_remote_reset(struct ath_hw *ah, bool wait_done)
 {
 	u32 payload[4] = { 0xffffffff, 0xffffffff, 0xffffffff, 0xffffff00};
 
+	if (!ATH9K_HW_CAP_MCI)
+		return;
+
 	ar9003_mci_send_message(ah, MCI_REMOTE_RESET, 0, payload, 16,
 				wait_done, false);
 	udelay(5);
@@ -94,6 +97,9 @@ void ar9003_mci_send_lna_transfer(struct ath_hw *ah, bool wait_done)
 {
 	u32 payload = 0x00000000;
 
+	if (!ATH9K_HW_CAP_MCI)
+		return;
+
 	ar9003_mci_send_message(ah, MCI_LNA_TRANS, 0, &payload, 1,
 				wait_done, false);
 }
@@ -107,6 +113,9 @@ static void ar9003_mci_send_req_wake(struct ath_hw *ah, bool wait_done)
 
 void ar9003_mci_send_sys_waking(struct ath_hw *ah, bool wait_done)
 {
+	if (!ATH9K_HW_CAP_MCI)
+		return;
+
 	ar9003_mci_send_message(ah, MCI_SYS_WAKING, MCI_FLAG_DISABLE_TIMESTAMP,
 				NULL, 0, wait_done, false);
 }
@@ -221,6 +230,9 @@ void ar9003_mci_send_coex_halt_bt_gpm(struct ath_hw *ah, bool halt,
 	struct ath9k_hw_mci *mci = &ah->btcoex_hw.mci;
 	u32 payload[4] = {0, 0, 0, 0};
 
+	if (!ATH9K_HW_CAP_MCI)
+		return;
+
 	ath_dbg(common, ATH_DBG_MCI, "MCI Send Coex %s BT GPM.\n",
 		(halt) ? "halt" : "unhalt");
 
@@ -381,12 +393,17 @@ static void ar9003_mci_prep_interface(struct ath_hw *ah)
 
 void ar9003_mci_disable_interrupt(struct ath_hw *ah)
 {
+	if (!ATH9K_HW_CAP_MCI)
+		return;
+
 	REG_WRITE(ah, AR_MCI_INTERRUPT_EN, 0);
 	REG_WRITE(ah, AR_MCI_INTERRUPT_RX_MSG_EN, 0);
 }
 
 void ar9003_mci_enable_interrupt(struct ath_hw *ah)
 {
+	if (!ATH9K_HW_CAP_MCI)
+		return;
 
 	REG_WRITE(ah, AR_MCI_INTERRUPT_EN, AR_MCI_INTERRUPT_DEFAULT);
 	REG_WRITE(ah, AR_MCI_INTERRUPT_RX_MSG_EN,
@@ -397,6 +414,9 @@ bool ar9003_mci_check_int(struct ath_hw *ah, u32 ints)
 {
 	u32 intr;
 
+	if (!ATH9K_HW_CAP_MCI)
+		return false;
+
 	intr = REG_READ(ah, AR_MCI_INTERRUPT_RX_MSG_RAW);
 	return ((intr & ints) == ints);
 }
@@ -405,6 +425,10 @@ void ar9003_mci_get_interrupt(struct ath_hw *ah, u32 *raw_intr,
 			      u32 *rx_msg_intr)
 {
 	struct ath9k_hw_mci *mci = &ah->btcoex_hw.mci;
+
+	if (!ATH9K_HW_CAP_MCI)
+		return;
+
 	*raw_intr = mci->raw_intr;
 	*rx_msg_intr = mci->rx_msg_intr;
 
@@ -418,6 +442,9 @@ void ar9003_mci_2g5g_changed(struct ath_hw *ah, bool is_2g)
 {
 	struct ath9k_hw_mci *mci = &ah->btcoex_hw.mci;
 
+	if (!ATH9K_HW_CAP_MCI)
+		return;
+
 	if (!mci->update_2g5g &&
 	    (mci->is_2g != is_2g))
 		mci->update_2g5g = true;
@@ -531,6 +558,9 @@ void ar9003_mci_reset(struct ath_hw *ah, bool en_int, bool is_2g,
 	struct ath9k_hw_mci *mci = &ah->btcoex_hw.mci;
 	u32 regval, thresh;
 
+	if (!ATH9K_HW_CAP_MCI)
+		return;
+
 	ath_dbg(common, ATH_DBG_MCI, "MCI full_sleep = %d, is_2g = %d\n",
 		is_full_sleep, is_2g);
 
@@ -661,6 +691,9 @@ void ar9003_mci_mute_bt(struct ath_hw *ah)
 {
 	struct ath_common *common = ath9k_hw_common(ah);
 
+	if (!ATH9K_HW_CAP_MCI)
+		return;
+
 	/* disable all MCI messages */
 	REG_WRITE(ah, AR_MCI_MSG_ATTRIBUTES_TABLE, 0xffff0000);
 	REG_WRITE(ah, AR_BTCOEX_WL_WEIGHTS0, 0xffffffff);
@@ -693,6 +726,9 @@ void ar9003_mci_sync_bt_state(struct ath_hw *ah)
 	struct ath9k_hw_mci *mci = &ah->btcoex_hw.mci;
 	u32 cur_bt_state;
 
+	if (!ATH9K_HW_CAP_MCI)
+		return;
+
 	cur_bt_state = ar9003_mci_state(ah, MCI_STATE_REMOTE_SLEEP, NULL);
 
 	if (mci->bt_state != cur_bt_state) {
@@ -857,6 +893,9 @@ void ar9003_mci_2g5g_switch(struct ath_hw *ah, bool wait_done)
 	struct ath_common *common = ath9k_hw_common(ah);
 	struct ath9k_hw_mci *mci = &ah->btcoex_hw.mci;
 
+	if (!ATH9K_HW_CAP_MCI)
+		return;
+
 	if (mci->update_2g5g) {
 		if (mci->is_2g) {
 
@@ -908,6 +947,9 @@ bool ar9003_mci_send_message(struct ath_hw *ah, u8 header, u32 flag,
 	u32 saved_mci_int_en;
 	int i;
 
+	if (!ATH9K_HW_CAP_MCI)
+		return false;
+
 	saved_mci_int_en = REG_READ(ah, AR_MCI_INTERRUPT_EN);
 	regval = REG_READ(ah, AR_BTCOEX_CTRL);
 
@@ -973,6 +1015,9 @@ void ar9003_mci_setup(struct ath_hw *ah, u32 gpm_addr, void *gpm_buf,
 	struct ath9k_hw_mci *mci = &ah->btcoex_hw.mci;
 	void *sched_buf = (void *)((char *) gpm_buf + (sched_addr - gpm_addr));
 
+	if (!ATH9K_HW_CAP_MCI)
+		return;
+
 	mci->gpm_addr = gpm_addr;
 	mci->gpm_buf = gpm_buf;
 	mci->gpm_len = len;
@@ -987,6 +1032,9 @@ void ar9003_mci_cleanup(struct ath_hw *ah)
 {
 	struct ath_common *common = ath9k_hw_common(ah);
 
+	if (!ATH9K_HW_CAP_MCI)
+		return;
+
 	/* Turn off MCI and Jupiter mode. */
 	REG_WRITE(ah, AR_BTCOEX_CTRL, 0x00);
 	ath_dbg(common, ATH_DBG_MCI, "MCI ar9003_mci_cleanup\n");
@@ -1056,6 +1104,9 @@ u32 ar9003_mci_wait_for_gpm(struct ath_hw *ah, u8 gpm_type,
 	u8 recv_type = 0, recv_opcode = 0;
 	bool b_is_bt_cal_done = (gpm_type == MCI_GPM_BT_CAL_DONE);
 
+	if (!ATH9K_HW_CAP_MCI)
+		return 0;
+
 	more_data = time_out ? MCI_GPM_NOMORE : MCI_GPM_MORE;
 
 	while (time_out > 0) {
@@ -1188,6 +1239,9 @@ u32 ar9003_mci_state(struct ath_hw *ah, u32 state_type, u32 *p_data)
 	u32 value = 0, more_gpm = 0, gpm_ptr;
 	u8 query_type;
 
+	if (!ATH9K_HW_CAP_MCI)
+		return 0;
+
 	switch (state_type) {
 	case MCI_STATE_ENABLE:
 		if (mci->ready) {
diff --git a/drivers/net/wireless/ath/ath9k/btcoex.c b/drivers/net/wireless/ath/ath9k/btcoex.c
index bbb2081..fe73388 100644
--- a/drivers/net/wireless/ath/ath9k/btcoex.c
+++ b/drivers/net/wireless/ath/ath9k/btcoex.c
@@ -68,6 +68,9 @@ void ath9k_hw_init_btcoex_hw(struct ath_hw *ah, int qnum)
 	u32 i, idx;
 	bool rxclear_polarity = ath_bt_config.bt_rxclear_polarity;
 
+	if (ath9k_hw_get_btcoex_scheme(ah) == ATH_BTCOEX_CFG_NONE)
+		return;
+
 	if (AR_SREV_9300_20_OR_LATER(ah))
 		rxclear_polarity = !ath_bt_config.bt_rxclear_polarity;
 
@@ -99,6 +102,9 @@ void ath9k_hw_btcoex_init_2wire(struct ath_hw *ah)
 {
 	struct ath_btcoex_hw *btcoex_hw = &ah->btcoex_hw;
 
+	if (ath9k_hw_get_btcoex_scheme(ah) == ATH_BTCOEX_CFG_NONE)
+		return;
+
 	/* connect bt_active to baseband */
 	REG_CLR_BIT(ah, AR_GPIO_INPUT_EN_VAL,
 		    (AR_GPIO_INPUT_EN_VAL_BT_PRIORITY_DEF |
@@ -121,6 +127,9 @@ void ath9k_hw_btcoex_init_3wire(struct ath_hw *ah)
 {
 	struct ath_btcoex_hw *btcoex_hw = &ah->btcoex_hw;
 
+	if (ath9k_hw_get_btcoex_scheme(ah) == ATH_BTCOEX_CFG_NONE)
+		return;
+
 	/* btcoex 3-wire */
 	REG_SET_BIT(ah, AR_GPIO_INPUT_EN_VAL,
 			(AR_GPIO_INPUT_EN_VAL_BT_PRIORITY_BB |
@@ -147,6 +156,9 @@ static void ath9k_hw_btcoex_enable_2wire(struct ath_hw *ah)
 {
 	struct ath_btcoex_hw *btcoex_hw = &ah->btcoex_hw;
 
+	if (ath9k_hw_get_btcoex_scheme(ah) == ATH_BTCOEX_CFG_NONE)
+		return;
+
 	/* Configure the desired GPIO port for TX_FRAME output */
 	ath9k_hw_cfg_output(ah, btcoex_hw->wlanactive_gpio,
 			    AR_GPIO_OUTPUT_MUX_AS_TX_FRAME);
@@ -158,6 +170,9 @@ void ath9k_hw_btcoex_set_weight(struct ath_hw *ah,
 {
 	struct ath_btcoex_hw *btcoex_hw = &ah->btcoex_hw;
 
+	if (ath9k_hw_get_btcoex_scheme(ah) == ATH_BTCOEX_CFG_NONE)
+		return;
+
 	btcoex_hw->bt_coex_weights = SM(bt_weight, AR_BTCOEX_BT_WGHT) |
 				     SM(wlan_weight, AR_BTCOEX_WL_WGHT);
 }
@@ -219,9 +234,9 @@ void ath9k_hw_btcoex_enable(struct ath_hw *ah)
 {
 	struct ath_btcoex_hw *btcoex_hw = &ah->btcoex_hw;
 
-	switch (btcoex_hw->scheme) {
+	switch (ath9k_hw_get_btcoex_scheme(ah)) {
 	case ATH_BTCOEX_CFG_NONE:
-		break;
+		return;
 	case ATH_BTCOEX_CFG_2WIRE:
 		ath9k_hw_btcoex_enable_2wire(ah);
 		break;
@@ -246,6 +261,9 @@ void ath9k_hw_btcoex_disable(struct ath_hw *ah)
 	struct ath_btcoex_hw *btcoex_hw = &ah->btcoex_hw;
 	int i;
 
+	if (ath9k_hw_get_btcoex_scheme(ah) == ATH_BTCOEX_CFG_NONE)
+		return;
+
 	btcoex_hw->enabled = false;
 	if (btcoex_hw->scheme == ATH_BTCOEX_CFG_MCI) {
 		ath9k_hw_btcoex_bt_stomp(ah, ATH_BTCOEX_STOMP_NONE);
@@ -294,6 +312,9 @@ static void ar9003_btcoex_bt_stomp(struct ath_hw *ah,
 void ath9k_hw_btcoex_bt_stomp(struct ath_hw *ah,
 			      enum ath_stomp_type stomp_type)
 {
+	if (ath9k_hw_get_btcoex_scheme(ah) == ATH_BTCOEX_CFG_NONE)
+		return;
+
 	if (AR_SREV_9300_20_OR_LATER(ah)) {
 		ar9003_btcoex_bt_stomp(ah, stomp_type);
 		return;
diff --git a/drivers/net/wireless/ath/ath9k/gpio.c b/drivers/net/wireless/ath/ath9k/gpio.c
index e4ae08e..9b2cd8d 100644
--- a/drivers/net/wireless/ath/ath9k/gpio.c
+++ b/drivers/net/wireless/ath/ath9k/gpio.c
@@ -250,6 +250,9 @@ int ath_init_btcoex_timer(struct ath_softc *sc)
 {
 	struct ath_btcoex *btcoex = &sc->btcoex;
 
+	if (ath9k_hw_get_btcoex_scheme(sc->sc_ah) == ATH_BTCOEX_CFG_NONE)
+		return 0;
+
 	btcoex->btcoex_period = ATH_BTCOEX_DEF_BT_PERIOD * 1000;
 	btcoex->btcoex_no_stomp = (100 - ATH_BTCOEX_DEF_DUTY_CYCLE) *
 		btcoex->btcoex_period / 100;
@@ -283,6 +286,9 @@ void ath9k_btcoex_timer_resume(struct ath_softc *sc)
 	ath_dbg(ath9k_hw_common(ah), ATH_DBG_BTCOEX,
 		"Starting btcoex timers\n");
 
+	if (ath9k_hw_get_btcoex_scheme(ah) == ATH_BTCOEX_CFG_NONE)
+		return;
+
 	/* make sure duty cycle timer is also stopped when resuming */
 	if (btcoex->hw_timer_enabled)
 		ath9k_gen_timer_stop(sc->sc_ah, btcoex->no_stomp_timer);
@@ -303,6 +309,9 @@ void ath9k_btcoex_timer_pause(struct ath_softc *sc)
 	struct ath_btcoex *btcoex = &sc->btcoex;
 	struct ath_hw *ah = sc->sc_ah;
 
+	if (ath9k_hw_get_btcoex_scheme(ah) == ATH_BTCOEX_CFG_NONE)
+		return;
+
 	del_timer_sync(&btcoex->period_timer);
 
 	if (btcoex->hw_timer_enabled)
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_gpio.c b/drivers/net/wireless/ath/ath9k/htc_drv_gpio.c
index ce606b6..e576068 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_gpio.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_gpio.c
@@ -116,6 +116,9 @@ void ath_htc_init_btcoex_work(struct ath9k_htc_priv *priv)
 {
 	struct ath_btcoex *btcoex = &priv->btcoex;
 
+	if (ath9k_hw_get_btcoex_scheme(priv->ah) == ATH_BTCOEX_CFG_NONE)
+		return;
+
 	btcoex->btcoex_period = ATH_BTCOEX_DEF_BT_PERIOD;
 	btcoex->btcoex_no_stomp = (100 - ATH_BTCOEX_DEF_DUTY_CYCLE) *
 		btcoex->btcoex_period / 100;
@@ -134,6 +137,9 @@ void ath_htc_resume_btcoex_work(struct ath9k_htc_priv *priv)
 	struct ath_btcoex *btcoex = &priv->btcoex;
 	struct ath_hw *ah = priv->ah;
 
+	if (ath9k_hw_get_btcoex_scheme(ah) == ATH_BTCOEX_CFG_NONE)
+		return;
+
 	ath_dbg(ath9k_hw_common(ah), ATH_DBG_BTCOEX, "Starting btcoex work\n");
 
 	btcoex->bt_priority_cnt = 0;
@@ -148,6 +154,9 @@ void ath_htc_resume_btcoex_work(struct ath9k_htc_priv *priv)
  */
 void ath_htc_cancel_btcoex_work(struct ath9k_htc_priv *priv)
 {
+	if (ath9k_hw_get_btcoex_scheme(priv->ah) == ATH_BTCOEX_CFG_NONE)
+		return;
+
 	cancel_delayed_work_sync(&priv->coex_period_work);
 	cancel_delayed_work_sync(&priv->duty_cycle_work);
 }
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_init.c b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
index 966661c..002c04e 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_init.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
@@ -610,7 +610,7 @@ static void ath9k_init_btcoex(struct ath9k_htc_priv *priv)
 {
 	int qnum;
 
-	switch (priv->ah->btcoex_hw.scheme) {
+	switch (ath9k_hw_get_btcoex_scheme(priv->ah)) {
 	case ATH_BTCOEX_CFG_NONE:
 		break;
 	case ATH_BTCOEX_CFG_3WIRE:
@@ -704,7 +704,8 @@ static int ath9k_init_priv(struct ath9k_htc_priv *priv,
 
 	if (product && strncmp(product, ATH_HTC_BTCOEX_PRODUCT_ID, 5) == 0) {
 		ah->btcoex_hw.scheme = ATH_BTCOEX_CFG_3WIRE;
-		ath9k_init_btcoex(priv);
+		if (ath9k_hw_get_btcoex_scheme(ah) != ATH_BTCOEX_CFG_NONE)
+			ath9k_init_btcoex(priv);
 	}
 
 	return 0;
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
index f8ce4ea..703cd82 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
@@ -958,7 +958,7 @@ static int ath9k_htc_start(struct ieee80211_hw *hw)
 	mod_timer(&priv->tx.cleanup_timer,
 		  jiffies + msecs_to_jiffies(ATH9K_HTC_TX_CLEANUP_INTERVAL));
 
-	if (ah->btcoex_hw.scheme == ATH_BTCOEX_CFG_3WIRE) {
+	if (ath9k_hw_get_btcoex_scheme(ah) == ATH_BTCOEX_CFG_3WIRE) {
 		ath9k_hw_btcoex_set_weight(ah, AR_BT_COEX_WGHT,
 					   AR_STOMP_LOW_WLAN_WGHT);
 		ath9k_hw_btcoex_enable(ah);
@@ -1010,7 +1010,8 @@ static void ath9k_htc_stop(struct ieee80211_hw *hw)
 
 	mutex_lock(&priv->mutex);
 
-	if (ah->btcoex_hw.enabled) {
+	if (ah->btcoex_hw.enabled &&
+	    ath9k_hw_get_btcoex_scheme(ah) != ATH_BTCOEX_CFG_NONE) {
 		ath9k_hw_btcoex_disable(ah);
 		if (ah->btcoex_hw.scheme == ATH_BTCOEX_CFG_3WIRE)
 			ath_htc_cancel_btcoex_work(priv);
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 8cda9a1..67984ba 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -1896,7 +1896,8 @@ int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_channel *chan,
 #endif
 	}
 
-	if (ah->btcoex_hw.enabled)
+	if (ah->btcoex_hw.enabled &&
+	    ath9k_hw_get_btcoex_scheme(ah) != ATH_BTCOEX_CFG_NONE)
 		ath9k_hw_btcoex_enable(ah);
 
 	if (mci && mci_hw->ready) {
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 615cc83..48205c2 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -209,7 +209,11 @@ enum ath9k_hw_caps {
 	ATH9K_HW_CAP_5GHZ			= BIT(12),
 	ATH9K_HW_CAP_APM			= BIT(13),
 	ATH9K_HW_CAP_RTT			= BIT(14),
+#ifdef CONFIG_ATH9K_BTCOEX_SUPPORT
 	ATH9K_HW_CAP_MCI			= BIT(15),
+#else
+	ATH9K_HW_CAP_MCI			= 0,
+#endif
 	ATH9K_HW_CAP_DFS			= BIT(16),
 };
 
@@ -1228,6 +1232,16 @@ void ar9003_mci_sync_bt_state(struct ath_hw *ah);
 void ar9003_mci_get_interrupt(struct ath_hw *ah, u32 *raw_intr,
 			      u32 *rx_msg_intr);
 
+#ifdef CONFIG_ATH9K_BTCOEX_SUPPORT
+static inline enum ath_btcoex_scheme
+ath9k_hw_get_btcoex_scheme(struct ath_hw *ah)
+{
+	return ah->btcoex_hw.scheme;
+}
+#else
+#define ath9k_hw_get_btcoex_scheme(...) ATH_BTCOEX_CFG_NONE
+#endif
+
 #define ATH9K_CLOCK_RATE_CCK		22
 #define ATH9K_CLOCK_RATE_5GHZ_OFDM	40
 #define ATH9K_CLOCK_RATE_2GHZ_OFDM	44
diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index c5df981..4c56863 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -426,7 +426,7 @@ static int ath9k_init_btcoex(struct ath_softc *sc)
 	struct ath_hw *ah = sc->sc_ah;
 	int r;
 
-	switch (sc->sc_ah->btcoex_hw.scheme) {
+	switch (ath9k_hw_get_btcoex_scheme(sc->sc_ah)) {
 	case ATH_BTCOEX_CFG_NONE:
 		break;
 	case ATH_BTCOEX_CFG_2WIRE:
@@ -881,10 +881,10 @@ static void ath9k_deinit_softc(struct ath_softc *sc)
 		kfree(sc->sbands[IEEE80211_BAND_5GHZ].channels);
 
         if ((sc->btcoex.no_stomp_timer) &&
-	    sc->sc_ah->btcoex_hw.scheme == ATH_BTCOEX_CFG_3WIRE)
+	    ath9k_hw_get_btcoex_scheme(sc->sc_ah) == ATH_BTCOEX_CFG_3WIRE)
 		ath_gen_timer_free(sc->sc_ah, sc->btcoex.no_stomp_timer);
 
-	if (sc->sc_ah->btcoex_hw.scheme == ATH_BTCOEX_CFG_MCI)
+	if (ath9k_hw_get_btcoex_scheme(sc->sc_ah) == ATH_BTCOEX_CFG_MCI)
 		ath_mci_cleanup(sc);
 
 	for (i = 0; i < ATH9K_NUM_TX_QUEUES; i++)
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 7fbc4bd..0a60164 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -742,11 +742,11 @@ void ath9k_tasklet(unsigned long data)
 			ath_tx_tasklet(sc);
 	}
 
-	if (ah->btcoex_hw.scheme == ATH_BTCOEX_CFG_3WIRE)
+	if (ath9k_hw_get_btcoex_scheme(ah) == ATH_BTCOEX_CFG_3WIRE)
 		if (status & ATH9K_INT_GENTIMER)
 			ath_gen_timer_isr(sc->sc_ah);
 
-	if (status & ATH9K_INT_MCI)
+	if ((status & ATH9K_INT_MCI) && ATH9K_HW_CAP_MCI)
 		ath_mci_intr(sc);
 
 out:
@@ -1083,14 +1083,14 @@ static int ath9k_start(struct ieee80211_hw *hw)
 
 	spin_unlock_bh(&sc->sc_pcu_lock);
 
-	if ((ah->btcoex_hw.scheme != ATH_BTCOEX_CFG_NONE) &&
+	if ((ath9k_hw_get_btcoex_scheme(ah) != ATH_BTCOEX_CFG_NONE) &&
 	    !ah->btcoex_hw.enabled) {
 		if (!(sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_MCI))
 			ath9k_hw_btcoex_set_weight(ah, AR_BT_COEX_WGHT,
 						   AR_STOMP_LOW_WLAN_WGHT);
 		ath9k_hw_btcoex_enable(ah);
 
-		if (ah->btcoex_hw.scheme == ATH_BTCOEX_CFG_3WIRE)
+		if (ath9k_hw_get_btcoex_scheme(ah) == ATH_BTCOEX_CFG_3WIRE)
 			ath9k_btcoex_timer_resume(sc);
 	}
 
@@ -1194,9 +1194,10 @@ static void ath9k_stop(struct ieee80211_hw *hw)
 	/* Ensure HW is awake when we try to shut it down. */
 	ath9k_ps_wakeup(sc);
 
-	if (ah->btcoex_hw.enabled) {
+	if (ah->btcoex_hw.enabled &&
+	    ath9k_hw_get_btcoex_scheme(ah) != ATH_BTCOEX_CFG_NONE) {
 		ath9k_hw_btcoex_disable(ah);
-		if (ah->btcoex_hw.scheme == ATH_BTCOEX_CFG_3WIRE)
+		if (ath9k_hw_get_btcoex_scheme(ah) == ATH_BTCOEX_CFG_3WIRE)
 			ath9k_btcoex_timer_pause(sc);
 		ath_mci_flush_profile(&sc->btcoex.mci);
 	}
diff --git a/drivers/net/wireless/ath/ath9k/mci.c b/drivers/net/wireless/ath/ath9k/mci.c
index 691bf47..3118f30 100644
--- a/drivers/net/wireless/ath/ath9k/mci.c
+++ b/drivers/net/wireless/ath/ath9k/mci.c
@@ -425,6 +425,9 @@ int ath_mci_setup(struct ath_softc *sc)
 	struct ath_mci_coex *mci = &sc->mci_coex;
 	int error = 0;
 
+	if (!ATH9K_HW_CAP_MCI)
+		return 0;
+
 	mci->sched_buf.bf_len = ATH_MCI_SCHED_BUF_SIZE + ATH_MCI_GPM_BUF_SIZE;
 
 	if (ath_mci_buf_alloc(sc, &mci->sched_buf)) {
@@ -458,6 +461,9 @@ void ath_mci_cleanup(struct ath_softc *sc)
 	struct ath_hw *ah = sc->sc_ah;
 	struct ath_mci_coex *mci = &sc->mci_coex;
 
+	if (!ATH9K_HW_CAP_MCI)
+		return;
+
 	/*
 	 * both schedule and gpm buffers will be released
 	 */
@@ -476,6 +482,9 @@ void ath_mci_intr(struct ath_softc *sc)
 	u32 more_data = MCI_GPM_MORE;
 	bool skip_gpm = false;
 
+	if (!ATH9K_HW_CAP_MCI)
+		return;
+
 	ar9003_mci_get_interrupt(sc->sc_ah, &mci_int, &mci_int_rxmsg);
 
 	if (ar9003_mci_state(ah, MCI_STATE_ENABLE, NULL) == 0) {
diff --git a/drivers/net/wireless/ath/ath9k/pci.c b/drivers/net/wireless/ath/ath9k/pci.c
index a439edc..77dc327 100644
--- a/drivers/net/wireless/ath/ath9k/pci.c
+++ b/drivers/net/wireless/ath/ath9k/pci.c
@@ -121,7 +121,7 @@ static void ath_pci_aspm_init(struct ath_common *common)
 	if (!parent)
 		return;
 
-	if (ah->btcoex_hw.scheme != ATH_BTCOEX_CFG_NONE) {
+	if (ath9k_hw_get_btcoex_scheme(ah) != ATH_BTCOEX_CFG_NONE) {
 		/* Bluetooth coexistance requires disabling ASPM. */
 		pci_read_config_byte(pdev, pos + PCI_EXP_LNKCTL, &aspm);
 		aspm &= ~(PCIE_LINK_STATE_L0S | PCIE_LINK_STATE_L1);
-- 
1.7.3.2

