Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:59892 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753790Ab2BVHMh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Feb 2012 02:12:37 -0500
From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20292.38235.426746.538493@gargle.gargle.HOWL> (sfid-20120222_081241_978867_0B44081A)
Date: Wed, 22 Feb 2012 12:42:27 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>
Subject: [PATCH 26/26] ath9k: Cleanup mci.c
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Cleanup whitespace, fix indentation and coding style.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/mci.c |  213 ++++++++++------------------------
 1 files changed, 59 insertions(+), 154 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/mci.c b/drivers/net/wireless/ath/ath9k/mci.c
index f818faa..29fe52d 100644
--- a/drivers/net/wireless/ath/ath9k/mci.c
+++ b/drivers/net/wireless/ath/ath9k/mci.c
@@ -42,24 +42,18 @@ static bool ath_mci_add_profile(struct ath_common *common,
 	struct ath_mci_profile_info *entry;
 
 	if ((mci->num_sco == ATH_MCI_MAX_SCO_PROFILE) &&
-	    (info->type == MCI_GPM_COEX_PROFILE_VOICE)) {
-		ath_dbg(common, MCI,
-			"Too many SCO profile, failed to add new profile\n");
+	    (info->type == MCI_GPM_COEX_PROFILE_VOICE))
 		return false;
-	}
 
 	if (((NUM_PROF(mci) - mci->num_sco) == ATH_MCI_MAX_ACL_PROFILE) &&
-	    (info->type != MCI_GPM_COEX_PROFILE_VOICE)) {
-		ath_dbg(common, MCI,
-			"Too many ACL profile, failed to add new profile\n");
+	    (info->type != MCI_GPM_COEX_PROFILE_VOICE))
 		return false;
-	}
 
 	entry = ath_mci_find_profile(mci, info);
 
-	if (entry)
+	if (entry) {
 		memcpy(entry, info, 10);
-	else {
+	} else {
 		entry = kzalloc(sizeof(*entry), GFP_KERNEL);
 		if (!entry)
 			return false;
@@ -68,6 +62,7 @@ static bool ath_mci_add_profile(struct ath_common *common,
 		INC_PROF(mci, info);
 		list_add_tail(&info->list, &mci->info);
 	}
+
 	return true;
 }
 
@@ -79,10 +74,9 @@ static void ath_mci_del_profile(struct ath_common *common,
 
 	entry = ath_mci_find_profile(mci, info);
 
-	if (!entry) {
-		ath_dbg(common, MCI, "Profile to be deleted not found\n");
+	if (!entry)
 		return;
-	}
+
 	DEC_PROF(mci, entry);
 	list_del(&entry->list);
 	kfree(entry);
@@ -177,13 +171,12 @@ static void ath_mci_update_scheme(struct ath_softc *sc)
 
 	btcoex->btcoex_period *= 1000;
 	btcoex->btcoex_no_stomp =  btcoex->btcoex_period *
-					(100 - btcoex->duty_cycle) / 100;
+		(100 - btcoex->duty_cycle) / 100;
 
 	ath9k_hw_btcoex_enable(sc->sc_ah);
 	ath9k_btcoex_timer_resume(sc);
 }
 
-
 static void ath_mci_cal_msg(struct ath_softc *sc, u8 opcode, u8 *rx_payload)
 {
 	struct ath_hw *ah = sc->sc_ah;
@@ -192,42 +185,24 @@ static void ath_mci_cal_msg(struct ath_softc *sc, u8 opcode, u8 *rx_payload)
 
 	switch (opcode) {
 	case MCI_GPM_BT_CAL_REQ:
-
-		ath_dbg(common, MCI, "MCI received BT_CAL_REQ\n");
-
 		if (ar9003_mci_state(ah, MCI_STATE_BT, NULL) == MCI_BT_AWAKE) {
 			ar9003_mci_state(ah, MCI_STATE_SET_BT_CAL_START, NULL);
 			ieee80211_queue_work(sc->hw, &sc->hw_reset_work);
-		} else
-			ath_dbg(common, MCI, "MCI State mismatches: %d\n",
+		} else {
+			ath_dbg(common, MCI, "MCI State mismatch: %d\n",
 				ar9003_mci_state(ah, MCI_STATE_BT, NULL));
-
+		}
 		break;
-
 	case MCI_GPM_BT_CAL_DONE:
-
-		ath_dbg(common, MCI, "MCI received BT_CAL_DONE\n");
-
-		if (ar9003_mci_state(ah, MCI_STATE_BT, NULL) == MCI_BT_CAL)
-			ath_dbg(common, MCI, "MCI error illegal!\n");
-		else
-			ath_dbg(common, MCI, "MCI BT not in CAL state\n");
-
+		ar9003_mci_state(ah, MCI_STATE_BT, NULL);
 		break;
-
 	case MCI_GPM_BT_CAL_GRANT:
-
-		ath_dbg(common, MCI, "MCI received BT_CAL_GRANT\n");
-
-		/* Send WLAN_CAL_DONE for now */
-		ath_dbg(common, MCI, "MCI send WLAN_CAL_DONE\n");
 		MCI_GPM_SET_CAL_TYPE(payload, MCI_GPM_WLAN_CAL_DONE);
 		ar9003_mci_send_message(sc->sc_ah, MCI_GPM, 0, payload,
 					16, false, true);
 		break;
-
 	default:
-		ath_dbg(common, MCI, "MCI Unknown GPM CAL message\n");
+		ath_dbg(common, MCI, "Unknown GPM CAL message\n");
 		break;
 	}
 }
@@ -247,6 +222,7 @@ static void ath_mci_process_profile(struct ath_softc *sc,
 
 	btcoex->btcoex_period = ATH_MCI_DEF_BT_PERIOD;
 	mci->aggr_limit = mci->num_sco ? 6 : 0;
+
 	if (NUM_PROF(mci)) {
 		btcoex->bt_stomp_type = ATH_BTCOEX_STOMP_LOW;
 		btcoex->duty_cycle = ath_mci_duty_cycle[NUM_PROF(mci)];
@@ -262,31 +238,24 @@ static void ath_mci_process_profile(struct ath_softc *sc,
 static void ath_mci_process_status(struct ath_softc *sc,
 				   struct ath_mci_profile_status *status)
 {
-	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
 	struct ath_btcoex *btcoex = &sc->btcoex;
 	struct ath_mci_profile *mci = &btcoex->mci;
 	struct ath_mci_profile_info info;
 	int i = 0, old_num_mgmt = mci->num_mgmt;
 
 	/* Link status type are not handled */
-	if (status->is_link) {
-		ath_dbg(common, MCI, "Skip link type status update\n");
+	if (status->is_link)
 		return;
-	}
 
 	memset(&info, 0, sizeof(struct ath_mci_profile_info));
 
 	info.conn_handle = status->conn_handle;
-	if (ath_mci_find_profile(mci, &info)) {
-		ath_dbg(common, MCI,
-			"Skip non link state update for existing profile %d\n",
-			status->conn_handle);
+	if (ath_mci_find_profile(mci, &info))
 		return;
-	}
-	if (status->conn_handle >= ATH_MCI_MAX_PROFILE) {
-		ath_dbg(common, MCI, "Ignore too many non-link update\n");
+
+	if (status->conn_handle >= ATH_MCI_MAX_PROFILE)
 		return;
-	}
+
 	if (status->is_critical)
 		__set_bit(status->conn_handle, mci->status);
 	else
@@ -314,43 +283,28 @@ static void ath_mci_msg(struct ath_softc *sc, u8 opcode, u8 *rx_payload)
 	u32 seq_num;
 
 	switch (opcode) {
-
 	case MCI_GPM_COEX_VERSION_QUERY:
-		ath_dbg(common, MCI, "MCI Recv GPM COEX Version Query\n");
-		version = ar9003_mci_state(ah,
-				MCI_STATE_SEND_WLAN_COEX_VERSION, NULL);
+		version = ar9003_mci_state(ah, MCI_STATE_SEND_WLAN_COEX_VERSION,
+					   NULL);
 		break;
-
 	case MCI_GPM_COEX_VERSION_RESPONSE:
-		ath_dbg(common, MCI, "MCI Recv GPM COEX Version Response\n");
 		major = *(rx_payload + MCI_GPM_COEX_B_MAJOR_VERSION);
 		minor = *(rx_payload + MCI_GPM_COEX_B_MINOR_VERSION);
-		ath_dbg(common, MCI, "MCI BT Coex version: %d.%d\n",
-			major, minor);
 		version = (major << 8) + minor;
-		version = ar9003_mci_state(ah,
-			  MCI_STATE_SET_BT_COEX_VERSION, &version);
+		version = ar9003_mci_state(ah, MCI_STATE_SET_BT_COEX_VERSION,
+					   &version);
 		break;
-
 	case MCI_GPM_COEX_STATUS_QUERY:
-		ath_dbg(common, MCI,
-			"MCI Recv GPM COEX Status Query = 0x%02x\n",
-			*(rx_payload + MCI_GPM_COEX_B_WLAN_BITMAP));
-		ar9003_mci_state(ah,
-		MCI_STATE_SEND_WLAN_CHANNELS, NULL);
+		ar9003_mci_state(ah, MCI_STATE_SEND_WLAN_CHANNELS, NULL);
 		break;
-
 	case MCI_GPM_COEX_BT_PROFILE_INFO:
-		ath_dbg(common, MCI, "MCI Recv GPM Coex BT profile info\n");
 		memcpy(&profile_info,
 		       (rx_payload + MCI_GPM_COEX_B_PROFILE_TYPE), 10);
 
-		if ((profile_info.type == MCI_GPM_COEX_PROFILE_UNKNOWN)
-		    || (profile_info.type >=
-					    MCI_GPM_COEX_PROFILE_MAX)) {
-
+		if ((profile_info.type == MCI_GPM_COEX_PROFILE_UNKNOWN) ||
+		    (profile_info.type >= MCI_GPM_COEX_PROFILE_MAX)) {
 			ath_dbg(common, MCI,
-				"illegal profile type = %d, state = %d\n",
+				"Illegal profile type = %d, state = %d\n",
 				profile_info.type,
 				profile_info.start);
 			break;
@@ -358,7 +312,6 @@ static void ath_mci_msg(struct ath_softc *sc, u8 opcode, u8 *rx_payload)
 
 		ath_mci_process_profile(sc, &profile_info);
 		break;
-
 	case MCI_GPM_COEX_BT_STATUS_UPDATE:
 		profile_status.is_link = *(rx_payload +
 					   MCI_GPM_COEX_B_STATUS_TYPE);
@@ -369,16 +322,14 @@ static void ath_mci_msg(struct ath_softc *sc, u8 opcode, u8 *rx_payload)
 
 		seq_num = *((u32 *)(rx_payload + 12));
 		ath_dbg(common, MCI,
-			"MCI Recv GPM COEX BT_Status_Update: is_link=%d, linkId=%d, state=%d, SEQ=%d\n",
+			"BT_Status_Update: is_link=%d, linkId=%d, state=%d, SEQ=%d\n",
 			profile_status.is_link, profile_status.conn_handle,
 			profile_status.is_critical, seq_num);
 
 		ath_mci_process_status(sc, &profile_status);
 		break;
-
 	default:
-		ath_dbg(common, MCI, "MCI Unknown GPM COEX message = 0x%02x\n",
-			opcode);
+		ath_dbg(common, MCI, "Unknown GPM COEX message = 0x%02x\n", opcode);
 		break;
 	}
 }
@@ -447,13 +398,7 @@ void ath_mci_intr(struct ath_softc *sc)
 	ar9003_mci_get_interrupt(sc->sc_ah, &mci_int, &mci_int_rxmsg);
 
 	if (ar9003_mci_state(ah, MCI_STATE_ENABLE, NULL) == 0) {
-
-		ar9003_mci_state(sc->sc_ah, MCI_STATE_INIT_GPM_OFFSET, NULL);
-		ath_dbg(common, MCI, "MCI interrupt but MCI disabled\n");
-
-		ath_dbg(common, MCI,
-			"MCI interrupt: intr = 0x%x, intr_rxmsg = 0x%x\n",
-			mci_int, mci_int_rxmsg);
+		ar9003_mci_state(ah, MCI_STATE_INIT_GPM_OFFSET, NULL);
 		return;
 	}
 
@@ -466,11 +411,8 @@ void ath_mci_intr(struct ath_softc *sc)
 		 * only when BT wake up. Now they are always sent, as a
 		 * recovery method to reset BT MCI's RX alignment.
 		 */
-		ath_dbg(common, MCI, "MCI interrupt send REMOTE_RESET\n");
-
 		ar9003_mci_send_message(ah, MCI_REMOTE_RESET, 0,
 					payload, 16, true, false);
-		ath_dbg(common, MCI, "MCI interrupt send SYS_WAKING\n");
 		ar9003_mci_send_message(ah, MCI_SYS_WAKING, 0,
 					NULL, 0, true, false);
 
@@ -480,74 +422,51 @@ void ath_mci_intr(struct ath_softc *sc)
 		/*
 		 * always do this for recovery and 2G/5G toggling and LNA_TRANS
 		 */
-		ath_dbg(common, MCI, "MCI Set BT state to AWAKE\n");
 		ar9003_mci_state(ah, MCI_STATE_SET_BT_AWAKE, NULL);
 	}
 
-	/* Processing SYS_WAKING/SYS_SLEEPING */
 	if (mci_int_rxmsg & AR_MCI_INTERRUPT_RX_MSG_SYS_WAKING) {
 		mci_int_rxmsg &= ~AR_MCI_INTERRUPT_RX_MSG_SYS_WAKING;
 
 		if (ar9003_mci_state(ah, MCI_STATE_BT, NULL) == MCI_BT_SLEEP) {
-
-			if (ar9003_mci_state(ah, MCI_STATE_REMOTE_SLEEP, NULL)
-					== MCI_BT_SLEEP)
-				ath_dbg(common, MCI,
-					"MCI BT stays in sleep mode\n");
-			else {
-				ath_dbg(common, MCI,
-					"MCI Set BT state to AWAKE\n");
-				ar9003_mci_state(ah,
-						 MCI_STATE_SET_BT_AWAKE, NULL);
-			}
-		} else
-			ath_dbg(common, MCI, "MCI BT stays in AWAKE mode\n");
+			if (ar9003_mci_state(ah, MCI_STATE_REMOTE_SLEEP, NULL) !=
+			    MCI_BT_SLEEP)
+				ar9003_mci_state(ah, MCI_STATE_SET_BT_AWAKE,
+						 NULL);
+		}
 	}
 
 	if (mci_int_rxmsg & AR_MCI_INTERRUPT_RX_MSG_SYS_SLEEPING) {
-
 		mci_int_rxmsg &= ~AR_MCI_INTERRUPT_RX_MSG_SYS_SLEEPING;
 
 		if (ar9003_mci_state(ah, MCI_STATE_BT, NULL) == MCI_BT_AWAKE) {
-
-			if (ar9003_mci_state(ah, MCI_STATE_REMOTE_SLEEP, NULL)
-					== MCI_BT_AWAKE)
-				ath_dbg(common, MCI,
-					"MCI BT stays in AWAKE mode\n");
-			else {
-				ath_dbg(common, MCI,
-					"MCI SetBT state to SLEEP\n");
+			if (ar9003_mci_state(ah, MCI_STATE_REMOTE_SLEEP, NULL) !=
+			    MCI_BT_AWAKE)
 				ar9003_mci_state(ah, MCI_STATE_SET_BT_SLEEP,
 						 NULL);
-			}
-		} else
-			ath_dbg(common, MCI, "MCI BT stays in SLEEP mode\n");
+		}
 	}
 
 	if ((mci_int & AR_MCI_INTERRUPT_RX_INVALID_HDR) ||
 	    (mci_int & AR_MCI_INTERRUPT_CONT_INFO_TIMEOUT)) {
-
-		ath_dbg(common, MCI, "MCI RX broken, skip GPM msgs\n");
 		ar9003_mci_state(ah, MCI_STATE_RECOVER_RX, NULL);
 		skip_gpm = true;
 	}
 
 	if (mci_int_rxmsg & AR_MCI_INTERRUPT_RX_MSG_SCHD_INFO) {
-
 		mci_int_rxmsg &= ~AR_MCI_INTERRUPT_RX_MSG_SCHD_INFO;
 		offset = ar9003_mci_state(ah, MCI_STATE_LAST_SCHD_MSG_OFFSET,
 					  NULL);
 	}
 
 	if (mci_int_rxmsg & AR_MCI_INTERRUPT_RX_MSG_GPM) {
-
 		mci_int_rxmsg &= ~AR_MCI_INTERRUPT_RX_MSG_GPM;
 
 		while (more_data == MCI_GPM_MORE) {
 
 			pgpm = mci->gpm_buf.bf_addr;
-			offset = ar9003_mci_state(ah,
-					MCI_STATE_NEXT_GPM_OFFSET, &more_data);
+			offset = ar9003_mci_state(ah, MCI_STATE_NEXT_GPM_OFFSET,
+						  &more_data);
 
 			if (offset == MCI_GPM_INVALID)
 				break;
@@ -558,44 +477,38 @@ void ath_mci_intr(struct ath_softc *sc)
 			 * The first dword is timer.
 			 * The real data starts from 2nd dword.
 			 */
-
 			subtype = MCI_GPM_TYPE(pgpm);
 			opcode = MCI_GPM_OPCODE(pgpm);
 
-			if (!skip_gpm) {
-
-				if (MCI_GPM_IS_CAL_TYPE(subtype))
-					ath_mci_cal_msg(sc, subtype,
-							(u8 *) pgpm);
-				else {
-					switch (subtype) {
-					case MCI_GPM_COEX_AGENT:
-						ath_mci_msg(sc, opcode,
-							    (u8 *) pgpm);
-						break;
-					default:
-						break;
-					}
+			if (skip_gpm)
+				goto recycle;
+
+			if (MCI_GPM_IS_CAL_TYPE(subtype)) {
+				ath_mci_cal_msg(sc, subtype, (u8 *)pgpm);
+			} else {
+				switch (subtype) {
+				case MCI_GPM_COEX_AGENT:
+					ath_mci_msg(sc, opcode, (u8 *)pgpm);
+					break;
+				default:
+					break;
 				}
 			}
+		recycle:
 			MCI_GPM_RECYCLE(pgpm);
 		}
 	}
 
 	if (mci_int_rxmsg & AR_MCI_INTERRUPT_RX_HW_MSG_MASK) {
-
 		if (mci_int_rxmsg & AR_MCI_INTERRUPT_RX_MSG_LNA_CONTROL)
 			mci_int_rxmsg &= ~AR_MCI_INTERRUPT_RX_MSG_LNA_CONTROL;
 
-		if (mci_int_rxmsg & AR_MCI_INTERRUPT_RX_MSG_LNA_INFO) {
+		if (mci_int_rxmsg & AR_MCI_INTERRUPT_RX_MSG_LNA_INFO)
 			mci_int_rxmsg &= ~AR_MCI_INTERRUPT_RX_MSG_LNA_INFO;
-			ath_dbg(common, MCI, "MCI LNA_INFO\n");
-		}
 
 		if (mci_int_rxmsg & AR_MCI_INTERRUPT_RX_MSG_CONT_INFO) {
-
 			int value_dbm = ar9003_mci_state(ah,
-					MCI_STATE_CONT_RSSI_POWER, NULL);
+						 MCI_STATE_CONT_RSSI_POWER, NULL);
 
 			mci_int_rxmsg &= ~AR_MCI_INTERRUPT_RX_MSG_CONT_INFO;
 
@@ -603,33 +516,25 @@ void ath_mci_intr(struct ath_softc *sc)
 				ath_dbg(common, MCI,
 					"MCI CONT_INFO: (tx) pri = %d, pwr = %d dBm\n",
 					ar9003_mci_state(ah,
-						MCI_STATE_CONT_PRIORITY, NULL),
+						 MCI_STATE_CONT_PRIORITY, NULL),
 					value_dbm);
 			else
 				ath_dbg(common, MCI,
 					"MCI CONT_INFO: (rx) pri = %d,pwr = %d dBm\n",
 					ar9003_mci_state(ah,
-						MCI_STATE_CONT_PRIORITY, NULL),
+						 MCI_STATE_CONT_PRIORITY, NULL),
 					value_dbm);
 		}
 
-		if (mci_int_rxmsg & AR_MCI_INTERRUPT_RX_MSG_CONT_NACK) {
+		if (mci_int_rxmsg & AR_MCI_INTERRUPT_RX_MSG_CONT_NACK)
 			mci_int_rxmsg &= ~AR_MCI_INTERRUPT_RX_MSG_CONT_NACK;
-			ath_dbg(common, MCI, "MCI CONT_NACK\n");
-		}
 
-		if (mci_int_rxmsg & AR_MCI_INTERRUPT_RX_MSG_CONT_RST) {
+		if (mci_int_rxmsg & AR_MCI_INTERRUPT_RX_MSG_CONT_RST)
 			mci_int_rxmsg &= ~AR_MCI_INTERRUPT_RX_MSG_CONT_RST;
-			ath_dbg(common, MCI, "MCI CONT_RST\n");
-		}
 	}
 
 	if ((mci_int & AR_MCI_INTERRUPT_RX_INVALID_HDR) ||
 	    (mci_int & AR_MCI_INTERRUPT_CONT_INFO_TIMEOUT))
 		mci_int &= ~(AR_MCI_INTERRUPT_RX_INVALID_HDR |
 			     AR_MCI_INTERRUPT_CONT_INFO_TIMEOUT);
-
-	if (mci_int_rxmsg & 0xfffffffe)
-		ath_dbg(common, MCI, "MCI not processed mci_int_rxmsg = 0x%x\n",
-			mci_int_rxmsg);
 }
-- 
1.7.9.1

