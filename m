Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:4336 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753795Ab2BUJYS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Feb 2012 04:24:18 -0500
From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20291.25269.870927.604493@gargle.gargle.HOWL> (sfid-20120221_102423_706267_5C23FF5F)
Date: Tue, 21 Feb 2012 14:54:05 +0530
To: <linux-wireless@vger.kernel.org>
CC: <ath9k-devel@lists.ath9k.org>
Subject: [RFC/WIP 21/22] ath9k: Remove ATH9K_HW_CAP_MCI checks
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

With the ability to remove BTCOEX support at compile time,
these checks are no longer needed.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_mci.c |   54 ---------------------------
 drivers/net/wireless/ath/ath9k/gpio.c       |    2 +-
 drivers/net/wireless/ath/ath9k/hw.h         |    4 --
 drivers/net/wireless/ath/ath9k/mci.c        |    9 ----
 4 files changed, 1 insertions(+), 68 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_mci.c b/drivers/net/wireless/ath/ath9k/ar9003_mci.c
index e76ffcf..d3d82b4 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_mci.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_mci.c
@@ -86,9 +86,6 @@ static void ar9003_mci_remote_reset(struct ath_hw *ah, bool wait_done)
 {
 	u32 payload[4] = { 0xffffffff, 0xffffffff, 0xffffffff, 0xffffff00};
 
-	if (!ATH9K_HW_CAP_MCI)
-		return;
-
 	ar9003_mci_send_message(ah, MCI_REMOTE_RESET, 0, payload, 16,
 				wait_done, false);
 	udelay(5);
@@ -98,9 +95,6 @@ static void ar9003_mci_send_lna_transfer(struct ath_hw *ah, bool wait_done)
 {
 	u32 payload = 0x00000000;
 
-	if (!ATH9K_HW_CAP_MCI)
-		return;
-
 	ar9003_mci_send_message(ah, MCI_LNA_TRANS, 0, &payload, 1,
 				wait_done, false);
 }
@@ -114,9 +108,6 @@ static void ar9003_mci_send_req_wake(struct ath_hw *ah, bool wait_done)
 
 static void ar9003_mci_send_sys_waking(struct ath_hw *ah, bool wait_done)
 {
-	if (!ATH9K_HW_CAP_MCI)
-		return;
-
 	ar9003_mci_send_message(ah, MCI_SYS_WAKING, MCI_FLAG_DISABLE_TIMESTAMP,
 				NULL, 0, wait_done, false);
 }
@@ -230,9 +221,6 @@ static void ar9003_mci_send_coex_halt_bt_gpm(struct ath_hw *ah, bool halt,
 	struct ath9k_hw_mci *mci = &ah->btcoex_hw.mci;
 	u32 payload[4] = {0, 0, 0, 0};
 
-	if (!ATH9K_HW_CAP_MCI)
-		return;
-
 	ath_dbg(common, MCI, "MCI Send Coex %s BT GPM\n",
 		(halt) ? "halt" : "unhalt");
 
@@ -385,18 +373,12 @@ void ar9003_mci_set_full_sleep(struct ath_hw *ah)
 
 static void ar9003_mci_disable_interrupt(struct ath_hw *ah)
 {
-	if (!ATH9K_HW_CAP_MCI)
-		return;
-
 	REG_WRITE(ah, AR_MCI_INTERRUPT_EN, 0);
 	REG_WRITE(ah, AR_MCI_INTERRUPT_RX_MSG_EN, 0);
 }
 
 static void ar9003_mci_enable_interrupt(struct ath_hw *ah)
 {
-	if (!ATH9K_HW_CAP_MCI)
-		return;
-
 	REG_WRITE(ah, AR_MCI_INTERRUPT_EN, AR_MCI_INTERRUPT_DEFAULT);
 	REG_WRITE(ah, AR_MCI_INTERRUPT_RX_MSG_EN,
 		  AR_MCI_INTERRUPT_RX_MSG_DEFAULT);
@@ -406,9 +388,6 @@ static bool ar9003_mci_check_int(struct ath_hw *ah, u32 ints)
 {
 	u32 intr;
 
-	if (!ATH9K_HW_CAP_MCI)
-		return false;
-
 	intr = REG_READ(ah, AR_MCI_INTERRUPT_RX_MSG_RAW);
 	return ((intr & ints) == ints);
 }
@@ -418,9 +397,6 @@ void ar9003_mci_get_interrupt(struct ath_hw *ah, u32 *raw_intr,
 {
 	struct ath9k_hw_mci *mci = &ah->btcoex_hw.mci;
 
-	if (!ATH9K_HW_CAP_MCI)
-		return;
-
 	*raw_intr = mci->raw_intr;
 	*rx_msg_intr = mci->rx_msg_intr;
 
@@ -459,9 +435,6 @@ static void ar9003_mci_2g5g_changed(struct ath_hw *ah, bool is_2g)
 {
 	struct ath9k_hw_mci *mci = &ah->btcoex_hw.mci;
 
-	if (!ATH9K_HW_CAP_MCI)
-		return;
-
 	if (!mci->update_2g5g &&
 	    (mci->is_2g != is_2g))
 		mci->update_2g5g = true;
@@ -574,9 +547,6 @@ static void ar9003_mci_sync_bt_state(struct ath_hw *ah)
 	struct ath9k_hw_mci *mci = &ah->btcoex_hw.mci;
 	u32 cur_bt_state;
 
-	if (!ATH9K_HW_CAP_MCI)
-		return;
-
 	cur_bt_state = ar9003_mci_state(ah, MCI_STATE_REMOTE_SLEEP, NULL);
 
 	if (mci->bt_state != cur_bt_state) {
@@ -675,9 +645,6 @@ static u32 ar9003_mci_wait_for_gpm(struct ath_hw *ah, u8 gpm_type,
 	u8 recv_type = 0, recv_opcode = 0;
 	bool b_is_bt_cal_done = (gpm_type == MCI_GPM_BT_CAL_DONE);
 
-	if (!ATH9K_HW_CAP_MCI)
-		return 0;
-
 	more_data = time_out ? MCI_GPM_NOMORE : MCI_GPM_MORE;
 
 	while (time_out > 0) {
@@ -909,9 +876,6 @@ static void ar9003_mci_mute_bt(struct ath_hw *ah)
 {
 	struct ath_common *common = ath9k_hw_common(ah);
 
-	if (!ATH9K_HW_CAP_MCI)
-		return;
-
 	/* disable all MCI messages */
 	REG_WRITE(ah, AR_MCI_MSG_ATTRIBUTES_TABLE, 0xffff0000);
 	REG_WRITE(ah, AR_BTCOEX_WL_WEIGHTS0, 0xffffffff);
@@ -945,9 +909,6 @@ void ar9003_mci_reset(struct ath_hw *ah, bool en_int, bool is_2g,
 	struct ath9k_hw_mci *mci = &ah->btcoex_hw.mci;
 	u32 regval, thresh;
 
-	if (!ATH9K_HW_CAP_MCI)
-		return;
-
 	ath_dbg(common, MCI, "MCI full_sleep = %d, is_2g = %d\n",
 		is_full_sleep, is_2g);
 
@@ -1221,9 +1182,6 @@ void ar9003_mci_2g5g_switch(struct ath_hw *ah, bool wait_done)
 	struct ath_common *common = ath9k_hw_common(ah);
 	struct ath9k_hw_mci *mci = &ah->btcoex_hw.mci;
 
-	if (!ATH9K_HW_CAP_MCI)
-		return;
-
 	if (mci->update_2g5g) {
 		if (mci->is_2g) {
 
@@ -1275,9 +1233,6 @@ bool ar9003_mci_send_message(struct ath_hw *ah, u8 header, u32 flag,
 	u32 saved_mci_int_en;
 	int i;
 
-	if (!ATH9K_HW_CAP_MCI)
-		return false;
-
 	saved_mci_int_en = REG_READ(ah, AR_MCI_INTERRUPT_EN);
 	regval = REG_READ(ah, AR_BTCOEX_CTRL);
 
@@ -1391,9 +1346,6 @@ void ar9003_mci_setup(struct ath_hw *ah, u32 gpm_addr, void *gpm_buf,
 {
 	struct ath9k_hw_mci *mci = &ah->btcoex_hw.mci;
 
-	if (!ATH9K_HW_CAP_MCI)
-		return;
-
 	mci->gpm_addr = gpm_addr;
 	mci->gpm_buf = gpm_buf;
 	mci->gpm_len = len;
@@ -1405,9 +1357,6 @@ EXPORT_SYMBOL(ar9003_mci_setup);
 
 void ar9003_mci_cleanup(struct ath_hw *ah)
 {
-	if (!ATH9K_HW_CAP_MCI)
-		return;
-
 	/* Turn off MCI and Jupiter mode. */
 	REG_WRITE(ah, AR_BTCOEX_CTRL, 0x00);
 	ar9003_mci_disable_interrupt(ah);
@@ -1421,9 +1370,6 @@ u32 ar9003_mci_state(struct ath_hw *ah, u32 state_type, u32 *p_data)
 	u32 value = 0, more_gpm = 0, gpm_ptr;
 	u8 query_type;
 
-	if (!ATH9K_HW_CAP_MCI)
-		return 0;
-
 	switch (state_type) {
 	case MCI_STATE_ENABLE:
 		if (mci->ready) {
diff --git a/drivers/net/wireless/ath/ath9k/gpio.c b/drivers/net/wireless/ath/ath9k/gpio.c
index af6e181..f2c68e9 100644
--- a/drivers/net/wireless/ath/ath9k/gpio.c
+++ b/drivers/net/wireless/ath/ath9k/gpio.c
@@ -333,7 +333,7 @@ void ath9k_btcoex_handle_interrupt(struct ath_softc *sc, u32 status)
 		if (status & ATH9K_INT_GENTIMER)
 			ath_gen_timer_isr(sc->sc_ah);
 
-	if ((status & ATH9K_INT_MCI) && ATH9K_HW_CAP_MCI)
+	if (status & ATH9K_INT_MCI)
 		ath_mci_intr(sc);
 }
 
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index b24fe8f..5a96dba 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -209,11 +209,7 @@ enum ath9k_hw_caps {
 	ATH9K_HW_CAP_5GHZ			= BIT(12),
 	ATH9K_HW_CAP_APM			= BIT(13),
 	ATH9K_HW_CAP_RTT			= BIT(14),
-#ifdef CONFIG_ATH9K_BTCOEX_SUPPORT
 	ATH9K_HW_CAP_MCI			= BIT(15),
-#else
-	ATH9K_HW_CAP_MCI			= 0,
-#endif
 	ATH9K_HW_CAP_DFS			= BIT(16),
 };
 
diff --git a/drivers/net/wireless/ath/ath9k/mci.c b/drivers/net/wireless/ath/ath9k/mci.c
index 85a957a..f818faa 100644
--- a/drivers/net/wireless/ath/ath9k/mci.c
+++ b/drivers/net/wireless/ath/ath9k/mci.c
@@ -389,9 +389,6 @@ int ath_mci_setup(struct ath_softc *sc)
 	struct ath_mci_coex *mci = &sc->mci_coex;
 	struct ath_mci_buf *buf = &mci->sched_buf;
 
-	if (!ATH9K_HW_CAP_MCI)
-		return 0;
-
 	buf->bf_addr = dma_alloc_coherent(sc->dev,
 				  ATH_MCI_SCHED_BUF_SIZE + ATH_MCI_GPM_BUF_SIZE,
 				  &buf->bf_paddr, GFP_KERNEL);
@@ -426,9 +423,6 @@ void ath_mci_cleanup(struct ath_softc *sc)
 	struct ath_mci_coex *mci = &sc->mci_coex;
 	struct ath_mci_buf *buf = &mci->sched_buf;
 
-	if (!ATH9K_HW_CAP_MCI)
-		return;
-
 	if (buf->bf_addr)
 		dma_free_coherent(sc->dev,
 				  ATH_MCI_SCHED_BUF_SIZE + ATH_MCI_GPM_BUF_SIZE,
@@ -450,9 +444,6 @@ void ath_mci_intr(struct ath_softc *sc)
 	u32 more_data = MCI_GPM_MORE;
 	bool skip_gpm = false;
 
-	if (!ATH9K_HW_CAP_MCI)
-		return;
-
 	ar9003_mci_get_interrupt(sc->sc_ah, &mci_int, &mci_int_rxmsg);
 
 	if (ar9003_mci_state(ah, MCI_STATE_ENABLE, NULL) == 0) {
-- 
1.7.9.1

