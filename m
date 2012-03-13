Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:35766 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758774Ab2CMVie (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Mar 2012 17:38:34 -0400
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>,
	Paul Stewart <pstew@google.com>
Subject: [PATCH RESEND 2/2] ath9k: recover ar9380 chips from rare stuck state
Date: Wed, 14 Mar 2012 03:08:53 +0530
Message-ID: <1331674733-10580-2-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20120313_223840_707385_4A808CED)
In-Reply-To: <1331674733-10580-1-git-send-email-rmanohar@qca.qualcomm.com>
References: <1331674733-10580-1-git-send-email-rmanohar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In the experiment with Azimuth ADEPT-n testbed where the APs transmit
power was reduced to 25% and the signal strength was futher attenuated
by 20dB and induced a path loss of ~7dB, the station was reporting
beacon losses and the following issue were observed.

* rx clear is stuck at low for more than 100ms
* dcu chain and complete state is stuck at one of the hang signature

This patch triggers the hang detection logic that recovers the chip
from any of the above conditions. As the issue was originally reported
in ChromeOs with AR9382 chips, this detection logic is enabled only for
AR9380/2 chips.

Cc: Paul Stewart <pstew@google.com>
Reported-by: Gary Morain <gmorain@google.com>
Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath.h         |    1 +
 drivers/net/wireless/ath/ath9k/ath9k.h |    3 ++
 drivers/net/wireless/ath/ath9k/hw.c    |   71 ++++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/hw.h    |    1 +
 drivers/net/wireless/ath/ath9k/init.c  |    1 +
 drivers/net/wireless/ath/ath9k/main.c  |   66 +++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/recv.c  |    3 ++
 drivers/net/wireless/ath/hw.c          |    5 +++
 8 files changed, 151 insertions(+)

diff --git a/drivers/net/wireless/ath/ath.h b/drivers/net/wireless/ath/ath.h
index c54b7d37..962b52f 100644
--- a/drivers/net/wireless/ath/ath.h
+++ b/drivers/net/wireless/ath/ath.h
@@ -150,6 +150,7 @@ struct ath_common {
 	spinlock_t cc_lock;
 	struct ath_cycle_counters cc_ani;
 	struct ath_cycle_counters cc_survey;
+	struct ath_cycle_counters cc_rxpoll;
 
 	struct ath_regulatory regulatory;
 	struct ath_regulatory reg_world_copy;
diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 3d8e51c..f039593 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -430,6 +430,8 @@ void ath9k_set_beaconing_status(struct ath_softc *sc, bool status);
 void ath_reset_work(struct work_struct *work);
 void ath_hw_check(struct work_struct *work);
 void ath_hw_pll_work(struct work_struct *work);
+void ath_rx_poll_work(unsigned long data);
+void ath_start_rx_poll(struct ath_softc *sc, u32 nmsec);
 void ath_paprd_calibrate(struct work_struct *work);
 void ath_ani_calibrate(unsigned long data);
 void ath_start_ani(struct ath_common *common);
@@ -679,6 +681,7 @@ struct ath_softc {
 	struct ath_beacon_config cur_beacon_conf;
 	struct delayed_work tx_complete_work;
 	struct delayed_work hw_pll_work;
+	struct timer_list rx_poll_timer;
 
 #ifdef CONFIG_ATH9K_BTCOEX_SUPPORT
 	struct ath_btcoex btcoex;
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 02cc1ce..51ebd7f 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -3045,3 +3045,74 @@ void ath9k_hw_name(struct ath_hw *ah, char *hw_name, size_t len)
 	hw_name[used] = '\0';
 }
 EXPORT_SYMBOL(ath9k_hw_name);
+
+static bool ath9k_hw_check_dcs(u32 dma_dbg, u32 num_dcu_states,
+			       int *hang_state, int *hang_pos)
+{
+	static u32 dcu_chain_state[] = {5, 6, 9}; /* DCU chain stuck states */
+	u32 chain_state, dcs_pos, i;
+
+	for (dcs_pos = 0; dcs_pos < num_dcu_states; dcs_pos++) {
+		chain_state = (dma_dbg >> (5 * dcs_pos)) & 0x1f;
+		for (i = 0; i < 3; i++) {
+			if (chain_state == dcu_chain_state[i]) {
+				*hang_state = chain_state;
+				*hang_pos = dcs_pos;
+				return true;
+			}
+		}
+	}
+	return false;
+}
+
+#define DCU_COMPLETE_STATE        1
+#define DCU_COMPLETE_STATE_MASK 0x3
+#define NUM_STATUS_READS         50
+bool ath9k_hw_detect_mac_hang(struct ath_hw *ah)
+{
+	u32 chain_state, comp_state, dcs_reg = AR_DMADBG_4;
+	u32 i, hang_pos, hang_state, num_state = 6;
+
+	comp_state = REG_READ(ah, AR_DMADBG_6);
+
+	if ((comp_state & DCU_COMPLETE_STATE_MASK) != DCU_COMPLETE_STATE) {
+		ath_dbg(ath9k_hw_common(ah), RESET,
+			"MAC Hang signature not found at DCU complete\n");
+		return false;
+	}
+
+	chain_state = REG_READ(ah, dcs_reg);
+	if (ath9k_hw_check_dcs(chain_state, num_state, &hang_state, &hang_pos))
+		goto hang_check_iter;
+
+	dcs_reg = AR_DMADBG_5;
+	num_state = 4;
+	chain_state = REG_READ(ah, dcs_reg);
+	if (ath9k_hw_check_dcs(chain_state, num_state, &hang_state, &hang_pos))
+		goto hang_check_iter;
+
+	ath_dbg(ath9k_hw_common(ah), RESET,
+		"MAC Hang signature 1 not found\n");
+	return false;
+
+hang_check_iter:
+	ath_dbg(ath9k_hw_common(ah), RESET,
+		"DCU registers: chain %08x complete %08x Hang: state %d pos %d\n",
+		chain_state, comp_state, hang_state, hang_pos);
+
+	for (i = 0; i < NUM_STATUS_READS; i++) {
+		chain_state = REG_READ(ah, dcs_reg);
+		chain_state = (chain_state >> (5 * hang_pos)) & 0x1f;
+		comp_state = REG_READ(ah, AR_DMADBG_6);
+
+		if (((comp_state & DCU_COMPLETE_STATE_MASK) !=
+					DCU_COMPLETE_STATE) ||
+		    (chain_state != hang_state))
+			return false;
+	}
+
+	ath_dbg(ath9k_hw_common(ah), RESET, "MAC Hang signature 1 found\n");
+
+	return true;
+}
+EXPORT_SYMBOL(ath9k_hw_detect_mac_hang);
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 1707137..c9031da 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -987,6 +987,7 @@ void ath_gen_timer_free(struct ath_hw *ah, struct ath_gen_timer *timer);
 void ath_gen_timer_isr(struct ath_hw *hw);
 
 void ath9k_hw_name(struct ath_hw *ah, char *hw_name, size_t len);
+bool ath9k_hw_detect_mac_hang(struct ath_hw *ah);
 
 /* HTC */
 void ath9k_hw_htc_resetinit(struct ath_hw *ah);
diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index 944e9b5..73de7e3 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -787,6 +787,7 @@ int ath9k_init_device(u16 devid, struct ath_softc *sc,
 			goto error_world;
 	}
 
+	setup_timer(&sc->rx_poll_timer, ath_rx_poll_work, (unsigned long)sc);
 	sc->last_rssi = ATH_RSSI_DUMMY_MARKER;
 
 	ath_init_leds(sc);
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 4a99010..d1c9998 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -243,6 +243,7 @@ static bool ath_prepare_reset(struct ath_softc *sc, bool retry_tx, bool flush)
 
 	sc->hw_busy_count = 0;
 	del_timer_sync(&common->ani.timer);
+	del_timer_sync(&sc->rx_poll_timer);
 
 	ath9k_debug_samp_bb_mac(sc);
 	ath9k_hw_disable_interrupts(ah);
@@ -284,6 +285,7 @@ static bool ath_complete_reset(struct ath_softc *sc, bool start)
 
 		ieee80211_queue_delayed_work(sc->hw, &sc->tx_complete_work, 0);
 		ieee80211_queue_delayed_work(sc->hw, &sc->hw_pll_work, HZ/2);
+		ath_start_rx_poll(sc, sc->cur_beacon_conf.beacon_interval);
 		if (!common->disable_ani)
 			ath_start_ani(common);
 	}
@@ -1163,6 +1165,7 @@ static void ath9k_stop(struct ieee80211_hw *hw)
 	mutex_lock(&sc->mutex);
 
 	ath_cancel_work(sc);
+	del_timer_sync(&sc->rx_poll_timer);
 
 	if (sc->sc_flags & SC_OP_INVALID) {
 		ath_dbg(common, ANY, "Device not present\n");
@@ -1396,6 +1399,65 @@ static void ath9k_do_vif_add_setup(struct ieee80211_hw *hw,
 	}
 }
 
+void ath_start_rx_poll(struct ath_softc *sc, u32 nmsec)
+{
+	if (!AR_SREV_9300(sc->sc_ah))
+		return;
+
+	if (!(sc->sc_flags & SC_OP_PRIM_STA_VIF))
+		return;
+
+	mod_timer(&sc->rx_poll_timer, jiffies + msecs_to_jiffies(nmsec));
+}
+
+void ath_rx_poll_work(unsigned long data)
+{
+	struct ath_softc *sc = (struct ath_softc *)data;
+	struct ath_hw *ah = sc->sc_ah;
+	struct ath_common *common = ath9k_hw_common(ah);
+	static u32 iteration, match_count;
+	static u64 last_run;
+	unsigned long flags;
+	u32 rx_clear, rx, tx, nmsec = 10;
+
+	if (jiffies_to_msecs(jiffies - last_run) > 120)
+		iteration = match_count = 0;
+	else
+		iteration += 1;
+
+	ath9k_ps_wakeup(sc);
+
+	spin_lock_irqsave(&common->cc_lock, flags);
+	ath_hw_cycle_counters_update(common);
+
+	rx_clear = common->cc_rxpoll.rx_busy * 100 / common->cc_rxpoll.cycles;
+	rx = common->cc_rxpoll.rx_frame * 100 / common->cc_rxpoll.cycles;
+	tx = common->cc_rxpoll.tx_frame * 100 / common->cc_rxpoll.cycles;
+	memset(&common->cc_rxpoll, 0, sizeof(common->cc_rxpoll));
+	spin_unlock_irqrestore(&common->cc_lock, flags);
+
+	last_run = jiffies;
+	if (rx_clear > 98) {
+		ath_dbg(common, RESET,
+			"rx clear %d match count %d iteration %d\n",
+		       rx_clear, match_count, iteration);
+		if (match_count++ > 9)
+			goto queue_reset_work;
+	} else if (ath9k_hw_detect_mac_hang(ah))
+		goto queue_reset_work;
+	else if (iteration >= 15) {
+		iteration = match_count = 0;
+		nmsec = 200;
+	}
+	ath9k_ps_restore(sc);
+	ath_start_rx_poll(sc, nmsec);
+	return;
+
+queue_reset_work:
+	ath9k_ps_restore(sc);
+	ieee80211_queue_work(sc->hw, &sc->hw_reset_work);
+	iteration = match_count = 0;
+}
 
 static int ath9k_add_interface(struct ieee80211_hw *hw,
 			       struct ieee80211_vif *vif)
@@ -1917,6 +1979,8 @@ static void ath9k_bss_iter(void *data, u8 *mac, struct ieee80211_vif *vif)
 		sc->last_rssi = ATH_RSSI_DUMMY_MARKER;
 		sc->sc_ah->stats.avgbrssi = ATH_RSSI_DUMMY_MARKER;
 
+		ath_start_rx_poll(sc, 3 * bss_conf->beacon_int);
+
 		if (!common->disable_ani) {
 			sc->sc_flags |= SC_OP_ANI_RUN;
 			ath_start_ani(common);
@@ -1956,6 +2020,7 @@ static void ath9k_config_bss(struct ath_softc *sc, struct ieee80211_vif *vif)
 		/* Stop ANI */
 		sc->sc_flags &= ~SC_OP_ANI_RUN;
 		del_timer_sync(&common->ani.timer);
+		del_timer_sync(&sc->rx_poll_timer);
 		memset(&sc->caldata, 0, sizeof(sc->caldata));
 	}
 }
@@ -1999,6 +2064,7 @@ static void ath9k_bss_info_changed(struct ieee80211_hw *hw,
 		} else {
 			sc->sc_flags &= ~SC_OP_ANI_RUN;
 			del_timer_sync(&common->ani.timer);
+			del_timer_sync(&sc->rx_poll_timer);
 		}
 	}
 
diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index f4ae3ba..1a139d4 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -1855,6 +1855,9 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush, bool hp)
 		if (retval)
 			goto requeue_drop_frag;
 
+		if (rs.is_mybeacon)
+			ath_start_rx_poll(sc, 3 * sc->cur_beacon_conf.
+					  beacon_interval);
 		/* Ensure we always have an skb to requeue once we are done
 		 * processing the current buffer's skb */
 		requeue_skb = ath_rxbuf_alloc(common, common->rx_bufsize, GFP_ATOMIC);
diff --git a/drivers/net/wireless/ath/hw.c b/drivers/net/wireless/ath/hw.c
index 19befb3..f1821ea 100644
--- a/drivers/net/wireless/ath/hw.c
+++ b/drivers/net/wireless/ath/hw.c
@@ -166,6 +166,11 @@ void ath_hw_cycle_counters_update(struct ath_common *common)
 	common->cc_survey.rx_busy += busy;
 	common->cc_survey.rx_frame += rx;
 	common->cc_survey.tx_frame += tx;
+
+	common->cc_rxpoll.cycles += cycles;
+	common->cc_rxpoll.rx_busy += busy;
+	common->cc_rxpoll.rx_frame += rx;
+	common->cc_rxpoll.tx_frame += tx;
 }
 EXPORT_SYMBOL(ath_hw_cycle_counters_update);
 
-- 
1.7.9.4

