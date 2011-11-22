Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:61904 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757910Ab1KVQZb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Nov 2011 11:25:31 -0500
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: Jouni Malinen <jouni@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>,
	Rodriguez Luis <rodrigue@qca.qualcomm.com>,
	Balasubramanian senthilkumar <senthilb@qca.qualcomm.com>,
	Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>,
	Vivek Natarajan <nataraja@qca.qualcomm.com>,
	<ath9k-devel@lists.ath9k.org>,
	Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>,
	Wilson Tsao <wtsao@qca.qualcomm.com>
Subject: [PATCH 17/18] ath9k: MCI state machine based on MCI interrupt
Date: Tue, 22 Nov 2011 21:52:44 +0530
Message-ID: <1321978965-21684-18-git-send-email-mohammed@qca.qualcomm.com> (sfid-20111122_172533_703016_C2B1E13D)
In-Reply-To: <1321978965-21684-1-git-send-email-mohammed@qca.qualcomm.com>
References: <1321978965-21684-1-git-send-email-mohammed@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>

Cc: Wilson Tsao <wtsao@qca.qualcomm.com>
Cc: Senthil Balasubramanian <senthilb@qca.qualcomm.com>
Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/hw.c   |    4 +-
 drivers/net/wireless/ath/ath9k/init.c |   11 +
 drivers/net/wireless/ath/ath9k/main.c |    3 +
 drivers/net/wireless/ath/ath9k/mci.c  |  341 +++++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/mci.h  |    1 +
 5 files changed, 359 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index e2860d7..5abe682 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -2397,7 +2397,9 @@ int ath9k_hw_fill_cap_info(struct ath_hw *ah)
 		pCap->hw_caps |= ATH9K_HW_CAP_4KB_SPLITTRANS;
 
 	if (common->btcoex_enabled) {
-		if (AR_SREV_9300_20_OR_LATER(ah)) {
+		if (AR_SREV_9462(ah))
+			btcoex_hw->scheme = ATH_BTCOEX_CFG_MCI;
+		else if (AR_SREV_9300_20_OR_LATER(ah)) {
 			btcoex_hw->scheme = ATH_BTCOEX_CFG_3WIRE;
 			btcoex_hw->btactive_gpio = ATH_BTACTIVE_GPIO_9300;
 			btcoex_hw->wlanactive_gpio = ATH_WLANACTIVE_GPIO_9300;
diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index 34b922b..e9711e2 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -425,8 +425,16 @@ static int ath9k_init_btcoex(struct ath_softc *sc)
 		txq = sc->tx.txq_map[WME_AC_BE];
 		ath9k_hw_init_btcoex_hw(sc->sc_ah, txq->axq_qnum);
 		sc->btcoex.bt_stomp_type = ATH_BTCOEX_STOMP_LOW;
+		break;
+	case ATH_BTCOEX_CFG_MCI:
+		sc->btcoex.bt_stomp_type = ATH_BTCOEX_STOMP_LOW;
 		sc->btcoex.duty_cycle = ATH_BTCOEX_DEF_DUTY_CYCLE;
 		INIT_LIST_HEAD(&sc->btcoex.mci.info);
+
+		r = ath_mci_setup(sc);
+		if (r)
+			return r;
+
 		if (sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_MCI) {
 			ah->btcoex_hw.mci.ready = false;
 			ah->btcoex_hw.mci.bt_state = 0;
@@ -861,6 +869,9 @@ static void ath9k_deinit_softc(struct ath_softc *sc)
 	    sc->sc_ah->btcoex_hw.scheme == ATH_BTCOEX_CFG_3WIRE)
 		ath_gen_timer_free(sc->sc_ah, sc->btcoex.no_stomp_timer);
 
+	if (sc->sc_ah->btcoex_hw.scheme == ATH_BTCOEX_CFG_MCI)
+		ath_mci_cleanup(sc);
+
 	for (i = 0; i < ATH9K_NUM_TX_QUEUES; i++)
 		if (ATH_TXQ_SETUP(sc, i))
 			ath_tx_cleanupq(sc, &sc->tx.txq[i]);
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index c9578ab..1149764 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -742,6 +742,9 @@ void ath9k_tasklet(unsigned long data)
 		if (status & ATH9K_INT_GENTIMER)
 			ath_gen_timer_isr(sc->sc_ah);
 
+	if (status & ATH9K_INT_MCI)
+		ath_mci_intr(sc);
+
 out:
 	/* re-enable hardware interrupt */
 	ath9k_hw_enable_interrupts(ah);
diff --git a/drivers/net/wireless/ath/ath9k/mci.c b/drivers/net/wireless/ath/ath9k/mci.c
index 5b24676..72ad656 100644
--- a/drivers/net/wireless/ath/ath9k/mci.c
+++ b/drivers/net/wireless/ath/ath9k/mci.c
@@ -184,6 +184,56 @@ static void ath_mci_update_scheme(struct ath_softc *sc)
 	ath9k_btcoex_timer_resume(sc);
 }
 
+
+static void ath_mci_cal_msg(struct ath_softc *sc, u8 opcode, u8 *rx_payload)
+{
+	struct ath_hw *ah = sc->sc_ah;
+	struct ath_common *common = ath9k_hw_common(ah);
+	u32 payload[4] = {0, 0, 0, 0};
+
+	switch (opcode) {
+	case MCI_GPM_BT_CAL_REQ:
+
+		ath_dbg(common, ATH_DBG_MCI, "MCI received BT_CAL_REQ\n");
+
+		if (ar9003_mci_state(ah, MCI_STATE_BT, NULL) == MCI_BT_AWAKE) {
+			ar9003_mci_state(ah, MCI_STATE_SET_BT_CAL_START, NULL);
+			ath_reset(sc, false);
+		} else
+			ath_dbg(common, ATH_DBG_MCI,
+				"MCI State mismatches: %d\n",
+				ar9003_mci_state(ah, MCI_STATE_BT, NULL));
+
+		break;
+
+	case MCI_GPM_BT_CAL_DONE:
+
+		ath_dbg(common, ATH_DBG_MCI, "MCI received BT_CAL_DONE\n");
+
+		if (ar9003_mci_state(ah, MCI_STATE_BT, NULL) == MCI_BT_CAL)
+			ath_dbg(common, ATH_DBG_MCI, "MCI error illegal!\n");
+		else
+			ath_dbg(common, ATH_DBG_MCI, "MCI BT not in CAL state\n");
+
+		break;
+
+	case MCI_GPM_BT_CAL_GRANT:
+
+		ath_dbg(common, ATH_DBG_MCI, "MCI received BT_CAL_GRANT\n");
+
+		/* Send WLAN_CAL_DONE for now */
+		ath_dbg(common, ATH_DBG_MCI, "MCI send WLAN_CAL_DONE\n");
+		MCI_GPM_SET_CAL_TYPE(payload, MCI_GPM_WLAN_CAL_DONE);
+		ar9003_mci_send_message(sc->sc_ah, MCI_GPM, 0, payload,
+					16, false, true);
+		break;
+
+	default:
+		ath_dbg(common, ATH_DBG_MCI, "MCI Unknown GPM CAL message\n");
+		break;
+	}
+}
+
 void ath_mci_process_profile(struct ath_softc *sc,
 			     struct ath_mci_profile_info *info)
 {
@@ -256,6 +306,90 @@ void ath_mci_process_status(struct ath_softc *sc,
 		ath_mci_update_scheme(sc);
 }
 
+static void ath_mci_msg(struct ath_softc *sc, u8 opcode, u8 *rx_payload)
+{
+	struct ath_hw *ah = sc->sc_ah;
+	struct ath_mci_profile_info profile_info;
+	struct ath_mci_profile_status profile_status;
+	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
+	u32 version;
+	u8 major;
+	u8 minor;
+	u32 seq_num;
+
+	switch (opcode) {
+
+	case MCI_GPM_COEX_VERSION_QUERY:
+		ath_dbg(common, ATH_DBG_MCI,
+			"MCI Recv GPM COEX Version Query.\n");
+		version = ar9003_mci_state(ah,
+				MCI_STATE_SEND_WLAN_COEX_VERSION, NULL);
+		break;
+
+	case MCI_GPM_COEX_VERSION_RESPONSE:
+		ath_dbg(common, ATH_DBG_MCI,
+			"MCI Recv GPM COEX Version Response.\n");
+		major = *(rx_payload + MCI_GPM_COEX_B_MAJOR_VERSION);
+		minor = *(rx_payload + MCI_GPM_COEX_B_MINOR_VERSION);
+		ath_dbg(common, ATH_DBG_MCI,
+			"MCI BT Coex version: %d.%d\n", major, minor);
+		version = (major << 8) + minor;
+		version = ar9003_mci_state(ah,
+			  MCI_STATE_SET_BT_COEX_VERSION, &version);
+		break;
+
+	case MCI_GPM_COEX_STATUS_QUERY:
+		ath_dbg(common, ATH_DBG_MCI,
+			"MCI Recv GPM COEX Status Query = 0x%02x.\n",
+			*(rx_payload + MCI_GPM_COEX_B_WLAN_BITMAP));
+		ar9003_mci_state(ah,
+		MCI_STATE_SEND_WLAN_CHANNELS, NULL);
+		break;
+
+	case MCI_GPM_COEX_BT_PROFILE_INFO:
+		ath_dbg(common, ATH_DBG_MCI,
+			"MCI Recv GPM Coex BT profile info\n");
+		memcpy(&profile_info,
+		       (rx_payload + MCI_GPM_COEX_B_PROFILE_TYPE), 10);
+
+		if ((profile_info.type == MCI_GPM_COEX_PROFILE_UNKNOWN)
+		    || (profile_info.type >=
+					    MCI_GPM_COEX_PROFILE_MAX)) {
+
+			ath_dbg(common, ATH_DBG_MCI,
+				"illegal profile type = %d,"
+				"state = %d\n", profile_info.type,
+				profile_info.start);
+			break;
+		}
+
+		ath_mci_process_profile(sc, &profile_info);
+		break;
+
+	case MCI_GPM_COEX_BT_STATUS_UPDATE:
+		profile_status.is_link = *(rx_payload +
+					   MCI_GPM_COEX_B_STATUS_TYPE);
+		profile_status.conn_handle = *(rx_payload +
+					       MCI_GPM_COEX_B_STATUS_LINKID);
+		profile_status.is_critical = *(rx_payload +
+					       MCI_GPM_COEX_B_STATUS_STATE);
+
+		seq_num = *((u32 *)(rx_payload + 12));
+		ath_dbg(common, ATH_DBG_MCI,
+			"MCI Recv GPM COEX BT_Status_Update: "
+			"is_link=%d, linkId=%d, state=%d, SEQ=%d\n",
+			profile_status.is_link, profile_status.conn_handle,
+			profile_status.is_critical, seq_num);
+
+		ath_mci_process_status(sc, &profile_status);
+		break;
+
+	default:
+		ath_dbg(common, ATH_DBG_MCI,
+		"MCI Unknown GPM COEX message = 0x%02x\n", opcode);
+		break;
+	}
+}
 
 static int ath_mci_buf_alloc(struct ath_softc *sc, struct ath_mci_buf *buf)
 {
@@ -330,3 +464,210 @@ void ath_mci_cleanup(struct ath_softc *sc)
 	ath_mci_buf_free(sc, &mci->sched_buf);
 	ar9003_mci_cleanup(ah);
 }
+
+void ath_mci_intr(struct ath_softc *sc)
+{
+	struct ath_mci_coex *mci = &sc->mci_coex;
+	struct ath_hw *ah = sc->sc_ah;
+	struct ath_common *common = ath9k_hw_common(ah);
+	u32 mci_int, mci_int_rxmsg;
+	u32 offset, subtype, opcode;
+	u32 *pgpm;
+	u32 more_data = MCI_GPM_MORE;
+	bool skip_gpm = false;
+
+	ar9003_mci_get_interrupt(sc->sc_ah, &mci_int, &mci_int_rxmsg);
+
+	if (ar9003_mci_state(ah, MCI_STATE_ENABLE, NULL) == 0) {
+
+		ar9003_mci_state(sc->sc_ah, MCI_STATE_INIT_GPM_OFFSET, NULL);
+		ath_dbg(common, ATH_DBG_MCI,
+			"MCI interrupt but MCI disabled\n");
+
+		ath_dbg(common, ATH_DBG_MCI,
+			"MCI interrupt: intr = 0x%x, intr_rxmsg = 0x%x\n",
+			mci_int, mci_int_rxmsg);
+		return;
+	}
+
+	if (mci_int_rxmsg & AR_MCI_INTERRUPT_RX_MSG_REQ_WAKE) {
+		u32 payload[4] = { 0xffffffff, 0xffffffff,
+				   0xffffffff, 0xffffff00};
+
+		/*
+		 * The following REMOTE_RESET and SYS_WAKING used to sent
+		 * only when BT wake up. Now they are always sent, as a
+		 * recovery method to reset BT MCI's RX alignment.
+		 */
+		ath_dbg(common, ATH_DBG_MCI, "MCI interrupt send REMOTE_RESET\n");
+
+		ar9003_mci_send_message(ah, MCI_REMOTE_RESET, 0,
+					payload, 16, true, false);
+		ath_dbg(common, ATH_DBG_MCI, "MCI interrupt send SYS_WAKING\n");
+		ar9003_mci_send_message(ah, MCI_SYS_WAKING, 0,
+					NULL, 0, true, false);
+
+		mci_int_rxmsg &= ~AR_MCI_INTERRUPT_RX_MSG_REQ_WAKE;
+		ar9003_mci_state(ah, MCI_STATE_RESET_REQ_WAKE, NULL);
+
+		/*
+		 * always do this for recovery and 2G/5G toggling and LNA_TRANS
+		 */
+		ath_dbg(common, ATH_DBG_MCI, "MCI Set BT state to AWAKE.\n");
+		ar9003_mci_state(ah, MCI_STATE_SET_BT_AWAKE, NULL);
+	}
+
+	/* Processing SYS_WAKING/SYS_SLEEPING */
+	if (mci_int_rxmsg & AR_MCI_INTERRUPT_RX_MSG_SYS_WAKING) {
+		mci_int_rxmsg &= ~AR_MCI_INTERRUPT_RX_MSG_SYS_WAKING;
+
+		if (ar9003_mci_state(ah, MCI_STATE_BT, NULL) == MCI_BT_SLEEP) {
+
+			if (ar9003_mci_state(ah, MCI_STATE_REMOTE_SLEEP, NULL)
+					== MCI_BT_SLEEP)
+				ath_dbg(common, ATH_DBG_MCI,
+					"MCI BT stays in sleep mode\n");
+			else {
+				ath_dbg(common, ATH_DBG_MCI,
+					"MCI Set BT state to AWAKE.\n");
+				ar9003_mci_state(ah,
+						 MCI_STATE_SET_BT_AWAKE, NULL);
+			}
+		} else
+			ath_dbg(common, ATH_DBG_MCI,
+				"MCI BT stays in AWAKE mode.\n");
+	}
+
+	if (mci_int_rxmsg & AR_MCI_INTERRUPT_RX_MSG_SYS_SLEEPING) {
+
+		mci_int_rxmsg &= ~AR_MCI_INTERRUPT_RX_MSG_SYS_SLEEPING;
+
+		if (ar9003_mci_state(ah, MCI_STATE_BT, NULL) == MCI_BT_AWAKE) {
+
+			if (ar9003_mci_state(ah, MCI_STATE_REMOTE_SLEEP, NULL)
+					== MCI_BT_AWAKE)
+				ath_dbg(common, ATH_DBG_MCI,
+					"MCI BT stays in AWAKE mode.\n");
+			else {
+				ath_dbg(common, ATH_DBG_MCI,
+					"MCI SetBT state to SLEEP\n");
+				ar9003_mci_state(ah, MCI_STATE_SET_BT_SLEEP,
+						 NULL);
+			}
+		} else
+			ath_dbg(common, ATH_DBG_MCI,
+				"MCI BT stays in SLEEP mode\n");
+	}
+
+	if ((mci_int & AR_MCI_INTERRUPT_RX_INVALID_HDR) ||
+	    (mci_int & AR_MCI_INTERRUPT_CONT_INFO_TIMEOUT)) {
+
+		ath_dbg(common, ATH_DBG_MCI, "MCI RX broken, skip GPM msgs\n");
+		ar9003_mci_state(ah, MCI_STATE_RECOVER_RX, NULL);
+		skip_gpm = true;
+	}
+
+	if (mci_int_rxmsg & AR_MCI_INTERRUPT_RX_MSG_SCHD_INFO) {
+
+		mci_int_rxmsg &= ~AR_MCI_INTERRUPT_RX_MSG_SCHD_INFO;
+		offset = ar9003_mci_state(ah, MCI_STATE_LAST_SCHD_MSG_OFFSET,
+					  NULL);
+	}
+
+	if (mci_int_rxmsg & AR_MCI_INTERRUPT_RX_MSG_GPM) {
+
+		mci_int_rxmsg &= ~AR_MCI_INTERRUPT_RX_MSG_GPM;
+
+		while (more_data == MCI_GPM_MORE) {
+
+			pgpm = mci->gpm_buf.bf_addr;
+			offset = ar9003_mci_state(ah,
+					MCI_STATE_NEXT_GPM_OFFSET, &more_data);
+
+			if (offset == MCI_GPM_INVALID)
+				break;
+
+			pgpm += (offset >> 2);
+
+			/*
+			 * The first dword is timer.
+			 * The real data starts from 2nd dword.
+			 */
+
+			subtype = MCI_GPM_TYPE(pgpm);
+			opcode = MCI_GPM_OPCODE(pgpm);
+
+			if (!skip_gpm) {
+
+				if (MCI_GPM_IS_CAL_TYPE(subtype))
+					ath_mci_cal_msg(sc, subtype,
+							(u8 *) pgpm);
+				else {
+					switch (subtype) {
+					case MCI_GPM_COEX_AGENT:
+						ath_mci_msg(sc, opcode,
+							    (u8 *) pgpm);
+						break;
+					default:
+						break;
+					}
+				}
+			}
+			MCI_GPM_RECYCLE(pgpm);
+		}
+	}
+
+	if (mci_int_rxmsg & AR_MCI_INTERRUPT_RX_HW_MSG_MASK) {
+
+		if (mci_int_rxmsg & AR_MCI_INTERRUPT_RX_MSG_LNA_CONTROL)
+			mci_int_rxmsg &= ~AR_MCI_INTERRUPT_RX_MSG_LNA_CONTROL;
+
+		if (mci_int_rxmsg & AR_MCI_INTERRUPT_RX_MSG_LNA_INFO) {
+			mci_int_rxmsg &= ~AR_MCI_INTERRUPT_RX_MSG_LNA_INFO;
+			ath_dbg(common, ATH_DBG_MCI, "MCI LNA_INFO\n");
+		}
+
+		if (mci_int_rxmsg & AR_MCI_INTERRUPT_RX_MSG_CONT_INFO) {
+
+			int value_dbm = ar9003_mci_state(ah,
+					MCI_STATE_CONT_RSSI_POWER, NULL);
+
+			mci_int_rxmsg &= ~AR_MCI_INTERRUPT_RX_MSG_CONT_INFO;
+
+			if (ar9003_mci_state(ah, MCI_STATE_CONT_TXRX, NULL))
+				ath_dbg(common, ATH_DBG_MCI,
+					"MCI CONT_INFO: "
+					"(tx) pri = %d, pwr = %d dBm\n",
+					ar9003_mci_state(ah,
+						MCI_STATE_CONT_PRIORITY, NULL),
+					value_dbm);
+			else
+				ath_dbg(common, ATH_DBG_MCI,
+					"MCI CONT_INFO:"
+					"(rx) pri = %d,pwr = %d dBm\n",
+					ar9003_mci_state(ah,
+						MCI_STATE_CONT_PRIORITY, NULL),
+					value_dbm);
+		}
+
+		if (mci_int_rxmsg & AR_MCI_INTERRUPT_RX_MSG_CONT_NACK) {
+			mci_int_rxmsg &= ~AR_MCI_INTERRUPT_RX_MSG_CONT_NACK;
+			ath_dbg(common, ATH_DBG_MCI, "MCI CONT_NACK\n");
+		}
+
+		if (mci_int_rxmsg & AR_MCI_INTERRUPT_RX_MSG_CONT_RST) {
+			mci_int_rxmsg &= ~AR_MCI_INTERRUPT_RX_MSG_CONT_RST;
+			ath_dbg(common, ATH_DBG_MCI, "MCI CONT_RST\n");
+		}
+	}
+
+	if ((mci_int & AR_MCI_INTERRUPT_RX_INVALID_HDR) ||
+	    (mci_int & AR_MCI_INTERRUPT_CONT_INFO_TIMEOUT))
+		mci_int &= ~(AR_MCI_INTERRUPT_RX_INVALID_HDR |
+			     AR_MCI_INTERRUPT_CONT_INFO_TIMEOUT);
+
+	if (mci_int_rxmsg & 0xfffffffe)
+		ath_dbg(common, ATH_DBG_MCI,
+			"MCI not processed mci_int_rxmsg = 0x%x\n",
+			mci_int_rxmsg);
+}
diff --git a/drivers/net/wireless/ath/ath9k/mci.h b/drivers/net/wireless/ath/ath9k/mci.h
index 4eeb0fe..b71bded 100644
--- a/drivers/net/wireless/ath/ath9k/mci.h
+++ b/drivers/net/wireless/ath/ath9k/mci.h
@@ -134,4 +134,5 @@ void ath_mci_process_status(struct ath_softc *sc,
 			    struct ath_mci_profile_status *status);
 int ath_mci_setup(struct ath_softc *sc);
 void ath_mci_cleanup(struct ath_softc *sc);
+void ath_mci_intr(struct ath_softc *sc);
 #endif
-- 
1.7.0.4

