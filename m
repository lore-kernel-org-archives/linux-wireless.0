Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:22727 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752987Ab0CYUo4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Mar 2010 16:44:56 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 09/22] iwlwifi: move agn common code to iwlagn library file
Date: Thu, 25 Mar 2010 13:44:37 -0700
Message-Id: <1269549890-19195-10-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1269549890-19195-1-git-send-email-reinette.chatre@intel.com>
References: <1269549890-19195-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

Multiple iwlagn based devices share the same common functions.
Move those functions from iwl-5000.c to iwl-agn-lib.c file.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/Makefile      |    1 +
 drivers/net/wireless/iwlwifi/iwl-1000.c    |   28 +-
 drivers/net/wireless/iwlwifi/iwl-5000.c    |  394 ++--------------------------
 drivers/net/wireless/iwlwifi/iwl-6000.c    |   56 ++--
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c |  377 ++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-agn.h     |   10 +
 drivers/net/wireless/iwlwifi/iwl-eeprom.h  |   14 +-
 7 files changed, 464 insertions(+), 416 deletions(-)
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-agn-lib.c

diff --git a/drivers/net/wireless/iwlwifi/Makefile b/drivers/net/wireless/iwlwifi/Makefile
index fec44cf..a684a72 100644
--- a/drivers/net/wireless/iwlwifi/Makefile
+++ b/drivers/net/wireless/iwlwifi/Makefile
@@ -11,6 +11,7 @@ CFLAGS_iwl-devtrace.o := -I$(src)
 obj-$(CONFIG_IWLAGN)	+= iwlagn.o
 iwlagn-objs		:= iwl-agn.o iwl-agn-rs.o iwl-agn-led.o iwl-agn-ict.o
 iwlagn-objs		+= iwl-agn-ucode.o iwl-agn-hcmd.o iwl-agn-tx.o
+iwlagn-objs		+= iwl-agn-lib.o
 
 iwlagn-$(CONFIG_IWL4965) += iwl-4965.o
 iwlagn-$(CONFIG_IWL5000) += iwl-5000.o
diff --git a/drivers/net/wireless/iwlwifi/iwl-1000.c b/drivers/net/wireless/iwlwifi/iwl-1000.c
index 9d21160..a99945b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-1000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-1000.c
@@ -170,9 +170,9 @@ static struct iwl_lib_ops iwl1000_lib = {
 	.txq_attach_buf_to_tfd = iwl_hw_txq_attach_buf_to_tfd,
 	.txq_free_tfd = iwl_hw_txq_free_tfd,
 	.txq_init = iwl_hw_tx_queue_init,
-	.rx_handler_setup = iwl5000_rx_handler_setup,
-	.setup_deferred_work = iwl5000_setup_deferred_work,
-	.is_valid_rtc_data_addr = iwl5000_hw_valid_rtc_data_addr,
+	.rx_handler_setup = iwlagn_rx_handler_setup,
+	.setup_deferred_work = iwlagn_setup_deferred_work,
+	.is_valid_rtc_data_addr = iwlagn_hw_valid_rtc_data_addr,
 	.load_ucode = iwlagn_load_ucode,
 	.dump_nic_event_log = iwl_dump_nic_event_log,
 	.dump_nic_error_log = iwl_dump_nic_error_log,
@@ -180,7 +180,7 @@ static struct iwl_lib_ops iwl1000_lib = {
 	.dump_fh = iwl_dump_fh,
 	.init_alive_start = iwlagn_init_alive_start,
 	.alive_notify = iwlagn_alive_notify,
-	.send_tx_power = iwl5000_send_tx_power,
+	.send_tx_power = iwlagn_send_tx_power,
 	.update_chain_flags = iwl_update_chain_flags,
 	.apm_ops = {
 		.init = iwl_apm_init,
@@ -190,25 +190,25 @@ static struct iwl_lib_ops iwl1000_lib = {
 	},
 	.eeprom_ops = {
 		.regulatory_bands = {
-			EEPROM_5000_REG_BAND_1_CHANNELS,
-			EEPROM_5000_REG_BAND_2_CHANNELS,
-			EEPROM_5000_REG_BAND_3_CHANNELS,
-			EEPROM_5000_REG_BAND_4_CHANNELS,
-			EEPROM_5000_REG_BAND_5_CHANNELS,
-			EEPROM_5000_REG_BAND_24_HT40_CHANNELS,
-			EEPROM_5000_REG_BAND_52_HT40_CHANNELS
+			EEPROM_REG_BAND_1_CHANNELS,
+			EEPROM_REG_BAND_2_CHANNELS,
+			EEPROM_REG_BAND_3_CHANNELS,
+			EEPROM_REG_BAND_4_CHANNELS,
+			EEPROM_REG_BAND_5_CHANNELS,
+			EEPROM_REG_BAND_24_HT40_CHANNELS,
+			EEPROM_REG_BAND_52_HT40_CHANNELS
 		},
 		.verify_signature  = iwlcore_eeprom_verify_signature,
 		.acquire_semaphore = iwlcore_eeprom_acquire_semaphore,
 		.release_semaphore = iwlcore_eeprom_release_semaphore,
-		.calib_version	= iwl5000_eeprom_calib_version,
-		.query_addr = iwl5000_eeprom_query_addr,
+		.calib_version	= iwlagn_eeprom_calib_version,
+		.query_addr = iwlagn_eeprom_query_addr,
 	},
 	.post_associate = iwl_post_associate,
 	.isr = iwl_isr_ict,
 	.config_ap = iwl_config_ap,
 	.temp_ops = {
-		.temperature = iwl5000_temperature,
+		.temperature = iwlagn_temperature,
 		.set_ct_kill = iwl1000_set_ct_threshold,
 	 },
 	.add_bcast_station = iwl_add_bcast_station,
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index 9128ccd..4d3dda1 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -47,7 +47,6 @@
 #include "iwl-agn-led.h"
 #include "iwl-agn-hw.h"
 #include "iwl-5000-hw.h"
-#include "iwl-6000-hw.h"
 
 /* Highest firmware API version supported */
 #define IWL5000_UCODE_API_MAX 2
@@ -99,60 +98,6 @@ void iwl5000_nic_config(struct iwl_priv *priv)
 	spin_unlock_irqrestore(&priv->lock, flags);
 }
 
-
-/*
- * EEPROM
- */
-static u32 eeprom_indirect_address(const struct iwl_priv *priv, u32 address)
-{
-	u16 offset = 0;
-
-	if ((address & INDIRECT_ADDRESS) == 0)
-		return address;
-
-	switch (address & INDIRECT_TYPE_MSK) {
-	case INDIRECT_HOST:
-		offset = iwl_eeprom_query16(priv, EEPROM_5000_LINK_HOST);
-		break;
-	case INDIRECT_GENERAL:
-		offset = iwl_eeprom_query16(priv, EEPROM_5000_LINK_GENERAL);
-		break;
-	case INDIRECT_REGULATORY:
-		offset = iwl_eeprom_query16(priv, EEPROM_5000_LINK_REGULATORY);
-		break;
-	case INDIRECT_CALIBRATION:
-		offset = iwl_eeprom_query16(priv, EEPROM_5000_LINK_CALIBRATION);
-		break;
-	case INDIRECT_PROCESS_ADJST:
-		offset = iwl_eeprom_query16(priv, EEPROM_5000_LINK_PROCESS_ADJST);
-		break;
-	case INDIRECT_OTHERS:
-		offset = iwl_eeprom_query16(priv, EEPROM_5000_LINK_OTHERS);
-		break;
-	default:
-		IWL_ERR(priv, "illegal indirect type: 0x%X\n",
-		address & INDIRECT_TYPE_MSK);
-		break;
-	}
-
-	/* translate the offset from words to byte */
-	return (address & ADDRESS_MSK) + (offset << 1);
-}
-
-u16 iwl5000_eeprom_calib_version(struct iwl_priv *priv)
-{
-	struct iwl_eeprom_calib_hdr {
-		u8 version;
-		u8 pa_type;
-		u16 voltage;
-	} *hdr;
-
-	hdr = (struct iwl_eeprom_calib_hdr *)iwl_eeprom_query_addr(priv,
-							EEPROM_5000_CALIB_ALL);
-	return hdr->version;
-
-}
-
 static struct iwl_sensitivity_ranges iwl5000_sensitivity = {
 	.min_nrg_cck = 95,
 	.max_nrg_cck = 0, /* not used, set to 0 */
@@ -204,14 +149,6 @@ static struct iwl_sensitivity_ranges iwl5150_sensitivity = {
 	.nrg_th_cca = 62,
 };
 
-const u8 *iwl5000_eeprom_query_addr(const struct iwl_priv *priv,
-					   size_t offset)
-{
-	u32 address = eeprom_indirect_address(priv, offset);
-	BUG_ON(address >= priv->cfg->eeprom_size);
-	return &priv->eeprom[address];
-}
-
 static void iwl5150_set_ct_threshold(struct iwl_priv *priv)
 {
 	const s32 volt2temp_coef = IWL_5150_VOLTAGE_TO_TEMPERATURE_COEFF;
@@ -285,283 +222,6 @@ int iwl5000_hw_set_hw_params(struct iwl_priv *priv)
 	return 0;
 }
 
-static inline u32 iwl5000_get_scd_ssn(struct iwl5000_tx_resp *tx_resp)
-{
-	return le32_to_cpup((__le32 *)&tx_resp->status +
-			    tx_resp->frame_count) & MAX_SN;
-}
-
-static int iwl5000_tx_status_reply_tx(struct iwl_priv *priv,
-				      struct iwl_ht_agg *agg,
-				      struct iwl5000_tx_resp *tx_resp,
-				      int txq_id, u16 start_idx)
-{
-	u16 status;
-	struct agg_tx_status *frame_status = &tx_resp->status;
-	struct ieee80211_tx_info *info = NULL;
-	struct ieee80211_hdr *hdr = NULL;
-	u32 rate_n_flags = le32_to_cpu(tx_resp->rate_n_flags);
-	int i, sh, idx;
-	u16 seq;
-
-	if (agg->wait_for_ba)
-		IWL_DEBUG_TX_REPLY(priv, "got tx response w/o block-ack\n");
-
-	agg->frame_count = tx_resp->frame_count;
-	agg->start_idx = start_idx;
-	agg->rate_n_flags = rate_n_flags;
-	agg->bitmap = 0;
-
-	/* # frames attempted by Tx command */
-	if (agg->frame_count == 1) {
-		/* Only one frame was attempted; no block-ack will arrive */
-		status = le16_to_cpu(frame_status[0].status);
-		idx = start_idx;
-
-		/* FIXME: code repetition */
-		IWL_DEBUG_TX_REPLY(priv, "FrameCnt = %d, StartIdx=%d idx=%d\n",
-				   agg->frame_count, agg->start_idx, idx);
-
-		info = IEEE80211_SKB_CB(priv->txq[txq_id].txb[idx].skb[0]);
-		info->status.rates[0].count = tx_resp->failure_frame + 1;
-		info->flags &= ~IEEE80211_TX_CTL_AMPDU;
-		info->flags |= iwl_tx_status_to_mac80211(status);
-		iwl_hwrate_to_tx_control(priv, rate_n_flags, info);
-
-		/* FIXME: code repetition end */
-
-		IWL_DEBUG_TX_REPLY(priv, "1 Frame 0x%x failure :%d\n",
-				    status & 0xff, tx_resp->failure_frame);
-		IWL_DEBUG_TX_REPLY(priv, "Rate Info rate_n_flags=%x\n", rate_n_flags);
-
-		agg->wait_for_ba = 0;
-	} else {
-		/* Two or more frames were attempted; expect block-ack */
-		u64 bitmap = 0;
-		int start = agg->start_idx;
-
-		/* Construct bit-map of pending frames within Tx window */
-		for (i = 0; i < agg->frame_count; i++) {
-			u16 sc;
-			status = le16_to_cpu(frame_status[i].status);
-			seq  = le16_to_cpu(frame_status[i].sequence);
-			idx = SEQ_TO_INDEX(seq);
-			txq_id = SEQ_TO_QUEUE(seq);
-
-			if (status & (AGG_TX_STATE_FEW_BYTES_MSK |
-				      AGG_TX_STATE_ABORT_MSK))
-				continue;
-
-			IWL_DEBUG_TX_REPLY(priv, "FrameCnt = %d, txq_id=%d idx=%d\n",
-					   agg->frame_count, txq_id, idx);
-
-			hdr = iwl_tx_queue_get_hdr(priv, txq_id, idx);
-			if (!hdr) {
-				IWL_ERR(priv,
-					"BUG_ON idx doesn't point to valid skb"
-					" idx=%d, txq_id=%d\n", idx, txq_id);
-				return -1;
-			}
-
-			sc = le16_to_cpu(hdr->seq_ctrl);
-			if (idx != (SEQ_TO_SN(sc) & 0xff)) {
-				IWL_ERR(priv,
-					"BUG_ON idx doesn't match seq control"
-					" idx=%d, seq_idx=%d, seq=%d\n",
-					  idx, SEQ_TO_SN(sc),
-					  hdr->seq_ctrl);
-				return -1;
-			}
-
-			IWL_DEBUG_TX_REPLY(priv, "AGG Frame i=%d idx %d seq=%d\n",
-					   i, idx, SEQ_TO_SN(sc));
-
-			sh = idx - start;
-			if (sh > 64) {
-				sh = (start - idx) + 0xff;
-				bitmap = bitmap << sh;
-				sh = 0;
-				start = idx;
-			} else if (sh < -64)
-				sh  = 0xff - (start - idx);
-			else if (sh < 0) {
-				sh = start - idx;
-				start = idx;
-				bitmap = bitmap << sh;
-				sh = 0;
-			}
-			bitmap |= 1ULL << sh;
-			IWL_DEBUG_TX_REPLY(priv, "start=%d bitmap=0x%llx\n",
-					   start, (unsigned long long)bitmap);
-		}
-
-		agg->bitmap = bitmap;
-		agg->start_idx = start;
-		IWL_DEBUG_TX_REPLY(priv, "Frames %d start_idx=%d bitmap=0x%llx\n",
-				   agg->frame_count, agg->start_idx,
-				   (unsigned long long)agg->bitmap);
-
-		if (bitmap)
-			agg->wait_for_ba = 1;
-	}
-	return 0;
-}
-
-static void iwl5000_rx_reply_tx(struct iwl_priv *priv,
-				struct iwl_rx_mem_buffer *rxb)
-{
-	struct iwl_rx_packet *pkt = rxb_addr(rxb);
-	u16 sequence = le16_to_cpu(pkt->hdr.sequence);
-	int txq_id = SEQ_TO_QUEUE(sequence);
-	int index = SEQ_TO_INDEX(sequence);
-	struct iwl_tx_queue *txq = &priv->txq[txq_id];
-	struct ieee80211_tx_info *info;
-	struct iwl5000_tx_resp *tx_resp = (void *)&pkt->u.raw[0];
-	u32  status = le16_to_cpu(tx_resp->status.status);
-	int tid;
-	int sta_id;
-	int freed;
-
-	if ((index >= txq->q.n_bd) || (iwl_queue_used(&txq->q, index) == 0)) {
-		IWL_ERR(priv, "Read index for DMA queue txq_id (%d) index %d "
-			  "is out of range [0-%d] %d %d\n", txq_id,
-			  index, txq->q.n_bd, txq->q.write_ptr,
-			  txq->q.read_ptr);
-		return;
-	}
-
-	info = IEEE80211_SKB_CB(txq->txb[txq->q.read_ptr].skb[0]);
-	memset(&info->status, 0, sizeof(info->status));
-
-	tid = (tx_resp->ra_tid & IWL50_TX_RES_TID_MSK) >> IWL50_TX_RES_TID_POS;
-	sta_id = (tx_resp->ra_tid & IWL50_TX_RES_RA_MSK) >> IWL50_TX_RES_RA_POS;
-
-	if (txq->sched_retry) {
-		const u32 scd_ssn = iwl5000_get_scd_ssn(tx_resp);
-		struct iwl_ht_agg *agg = NULL;
-
-		agg = &priv->stations[sta_id].tid[tid].agg;
-
-		iwl5000_tx_status_reply_tx(priv, agg, tx_resp, txq_id, index);
-
-		/* check if BAR is needed */
-		if ((tx_resp->frame_count == 1) && !iwl_is_tx_success(status))
-			info->flags |= IEEE80211_TX_STAT_AMPDU_NO_BACK;
-
-		if (txq->q.read_ptr != (scd_ssn & 0xff)) {
-			index = iwl_queue_dec_wrap(scd_ssn & 0xff, txq->q.n_bd);
-			IWL_DEBUG_TX_REPLY(priv, "Retry scheduler reclaim "
-					"scd_ssn=%d idx=%d txq=%d swq=%d\n",
-					scd_ssn , index, txq_id, txq->swq_id);
-
-			freed = iwl_tx_queue_reclaim(priv, txq_id, index);
-			iwl_free_tfds_in_queue(priv, sta_id, tid, freed);
-
-			if (priv->mac80211_registered &&
-			    (iwl_queue_space(&txq->q) > txq->q.low_mark) &&
-			    (agg->state != IWL_EMPTYING_HW_QUEUE_DELBA)) {
-				if (agg->state == IWL_AGG_OFF)
-					iwl_wake_queue(priv, txq_id);
-				else
-					iwl_wake_queue(priv, txq->swq_id);
-			}
-		}
-	} else {
-		BUG_ON(txq_id != txq->swq_id);
-
-		info->status.rates[0].count = tx_resp->failure_frame + 1;
-		info->flags |= iwl_tx_status_to_mac80211(status);
-		iwl_hwrate_to_tx_control(priv,
-					le32_to_cpu(tx_resp->rate_n_flags),
-					info);
-
-		IWL_DEBUG_TX_REPLY(priv, "TXQ %d status %s (0x%08x) rate_n_flags "
-				   "0x%x retries %d\n",
-				   txq_id,
-				   iwl_get_tx_fail_reason(status), status,
-				   le32_to_cpu(tx_resp->rate_n_flags),
-				   tx_resp->failure_frame);
-
-		freed = iwl_tx_queue_reclaim(priv, txq_id, index);
-		iwl_free_tfds_in_queue(priv, sta_id, tid, freed);
-
-		if (priv->mac80211_registered &&
-		    (iwl_queue_space(&txq->q) > txq->q.low_mark))
-			iwl_wake_queue(priv, txq_id);
-	}
-
-	iwl_txq_check_empty(priv, sta_id, tid, txq_id);
-
-	if (iwl_check_bits(status, TX_ABORT_REQUIRED_MSK))
-		IWL_ERR(priv, "TODO:  Implement Tx ABORT REQUIRED!!!\n");
-}
-
-void iwl5000_setup_deferred_work(struct iwl_priv *priv)
-{
-	/* in 5000 the tx power calibration is done in uCode */
-	priv->disable_tx_power_cal = 1;
-}
-
-void iwl5000_rx_handler_setup(struct iwl_priv *priv)
-{
-	/* init calibration handlers */
-	priv->rx_handlers[CALIBRATION_RES_NOTIFICATION] =
-					iwlagn_rx_calib_result;
-	priv->rx_handlers[CALIBRATION_COMPLETE_NOTIFICATION] =
-					iwlagn_rx_calib_complete;
-	priv->rx_handlers[REPLY_TX] = iwl5000_rx_reply_tx;
-}
-
-
-int iwl5000_hw_valid_rtc_data_addr(u32 addr)
-{
-	return (addr >= IWLAGN_RTC_DATA_LOWER_BOUND) &&
-		(addr < IWLAGN_RTC_DATA_UPPER_BOUND);
-}
-
-int  iwl5000_send_tx_power(struct iwl_priv *priv)
-{
-	struct iwl5000_tx_power_dbm_cmd tx_power_cmd;
-	u8 tx_ant_cfg_cmd;
-
-	/* half dBm need to multiply */
-	tx_power_cmd.global_lmt = (s8)(2 * priv->tx_power_user_lmt);
-
-	if (priv->tx_power_lmt_in_half_dbm &&
-	    priv->tx_power_lmt_in_half_dbm < tx_power_cmd.global_lmt) {
-		/*
-		 * For the newer devices which using enhanced/extend tx power
-		 * table in EEPROM, the format is in half dBm. driver need to
-		 * convert to dBm format before report to mac80211.
-		 * By doing so, there is a possibility of 1/2 dBm resolution
-		 * lost. driver will perform "round-up" operation before
-		 * reporting, but it will cause 1/2 dBm tx power over the
-		 * regulatory limit. Perform the checking here, if the
-		 * "tx_power_user_lmt" is higher than EEPROM value (in
-		 * half-dBm format), lower the tx power based on EEPROM
-		 */
-		tx_power_cmd.global_lmt = priv->tx_power_lmt_in_half_dbm;
-	}
-	tx_power_cmd.flags = IWL50_TX_POWER_NO_CLOSED;
-	tx_power_cmd.srv_chan_lmt = IWL50_TX_POWER_AUTO;
-
-	if (IWL_UCODE_API(priv->ucode_ver) == 1)
-		tx_ant_cfg_cmd = REPLY_TX_POWER_DBM_CMD_V1;
-	else
-		tx_ant_cfg_cmd = REPLY_TX_POWER_DBM_CMD;
-
-	return  iwl_send_cmd_pdu_async(priv, tx_ant_cfg_cmd,
-				       sizeof(tx_power_cmd), &tx_power_cmd,
-				       NULL);
-}
-
-void iwl5000_temperature(struct iwl_priv *priv)
-{
-	/* store temperature from statistics (in Celsius) */
-	priv->temperature = le32_to_cpu(priv->statistics.general.temperature);
-	iwl_tt_handler(priv);
-}
-
 static void iwl5150_temperature(struct iwl_priv *priv)
 {
 	u32 vt = 0;
@@ -616,9 +276,9 @@ struct iwl_lib_ops iwl5000_lib = {
 	.txq_attach_buf_to_tfd = iwl_hw_txq_attach_buf_to_tfd,
 	.txq_free_tfd = iwl_hw_txq_free_tfd,
 	.txq_init = iwl_hw_tx_queue_init,
-	.rx_handler_setup = iwl5000_rx_handler_setup,
-	.setup_deferred_work = iwl5000_setup_deferred_work,
-	.is_valid_rtc_data_addr = iwl5000_hw_valid_rtc_data_addr,
+	.rx_handler_setup = iwlagn_rx_handler_setup,
+	.setup_deferred_work = iwlagn_setup_deferred_work,
+	.is_valid_rtc_data_addr = iwlagn_hw_valid_rtc_data_addr,
 	.dump_nic_event_log = iwl_dump_nic_event_log,
 	.dump_nic_error_log = iwl_dump_nic_error_log,
 	.dump_csr = iwl_dump_csr,
@@ -626,7 +286,7 @@ struct iwl_lib_ops iwl5000_lib = {
 	.load_ucode = iwlagn_load_ucode,
 	.init_alive_start = iwlagn_init_alive_start,
 	.alive_notify = iwlagn_alive_notify,
-	.send_tx_power = iwl5000_send_tx_power,
+	.send_tx_power = iwlagn_send_tx_power,
 	.update_chain_flags = iwl_update_chain_flags,
 	.set_channel_switch = iwl5000_hw_channel_switch,
 	.apm_ops = {
@@ -637,25 +297,25 @@ struct iwl_lib_ops iwl5000_lib = {
 	},
 	.eeprom_ops = {
 		.regulatory_bands = {
-			EEPROM_5000_REG_BAND_1_CHANNELS,
-			EEPROM_5000_REG_BAND_2_CHANNELS,
-			EEPROM_5000_REG_BAND_3_CHANNELS,
-			EEPROM_5000_REG_BAND_4_CHANNELS,
-			EEPROM_5000_REG_BAND_5_CHANNELS,
-			EEPROM_5000_REG_BAND_24_HT40_CHANNELS,
-			EEPROM_5000_REG_BAND_52_HT40_CHANNELS
+			EEPROM_REG_BAND_1_CHANNELS,
+			EEPROM_REG_BAND_2_CHANNELS,
+			EEPROM_REG_BAND_3_CHANNELS,
+			EEPROM_REG_BAND_4_CHANNELS,
+			EEPROM_REG_BAND_5_CHANNELS,
+			EEPROM_REG_BAND_24_HT40_CHANNELS,
+			EEPROM_REG_BAND_52_HT40_CHANNELS
 		},
 		.verify_signature  = iwlcore_eeprom_verify_signature,
 		.acquire_semaphore = iwlcore_eeprom_acquire_semaphore,
 		.release_semaphore = iwlcore_eeprom_release_semaphore,
-		.calib_version	= iwl5000_eeprom_calib_version,
-		.query_addr = iwl5000_eeprom_query_addr,
+		.calib_version	= iwlagn_eeprom_calib_version,
+		.query_addr = iwlagn_eeprom_query_addr,
 	},
 	.post_associate = iwl_post_associate,
 	.isr = iwl_isr_ict,
 	.config_ap = iwl_config_ap,
 	.temp_ops = {
-		.temperature = iwl5000_temperature,
+		.temperature = iwlagn_temperature,
 		.set_ct_kill = iwl5000_set_ct_threshold,
 	 },
 	.add_bcast_station = iwl_add_bcast_station,
@@ -674,16 +334,16 @@ static struct iwl_lib_ops iwl5150_lib = {
 	.txq_attach_buf_to_tfd = iwl_hw_txq_attach_buf_to_tfd,
 	.txq_free_tfd = iwl_hw_txq_free_tfd,
 	.txq_init = iwl_hw_tx_queue_init,
-	.rx_handler_setup = iwl5000_rx_handler_setup,
-	.setup_deferred_work = iwl5000_setup_deferred_work,
-	.is_valid_rtc_data_addr = iwl5000_hw_valid_rtc_data_addr,
+	.rx_handler_setup = iwlagn_rx_handler_setup,
+	.setup_deferred_work = iwlagn_setup_deferred_work,
+	.is_valid_rtc_data_addr = iwlagn_hw_valid_rtc_data_addr,
 	.dump_nic_event_log = iwl_dump_nic_event_log,
 	.dump_nic_error_log = iwl_dump_nic_error_log,
 	.dump_csr = iwl_dump_csr,
 	.load_ucode = iwlagn_load_ucode,
 	.init_alive_start = iwlagn_init_alive_start,
 	.alive_notify = iwlagn_alive_notify,
-	.send_tx_power = iwl5000_send_tx_power,
+	.send_tx_power = iwlagn_send_tx_power,
 	.update_chain_flags = iwl_update_chain_flags,
 	.set_channel_switch = iwl5000_hw_channel_switch,
 	.apm_ops = {
@@ -694,19 +354,19 @@ static struct iwl_lib_ops iwl5150_lib = {
 	},
 	.eeprom_ops = {
 		.regulatory_bands = {
-			EEPROM_5000_REG_BAND_1_CHANNELS,
-			EEPROM_5000_REG_BAND_2_CHANNELS,
-			EEPROM_5000_REG_BAND_3_CHANNELS,
-			EEPROM_5000_REG_BAND_4_CHANNELS,
-			EEPROM_5000_REG_BAND_5_CHANNELS,
-			EEPROM_5000_REG_BAND_24_HT40_CHANNELS,
-			EEPROM_5000_REG_BAND_52_HT40_CHANNELS
+			EEPROM_REG_BAND_1_CHANNELS,
+			EEPROM_REG_BAND_2_CHANNELS,
+			EEPROM_REG_BAND_3_CHANNELS,
+			EEPROM_REG_BAND_4_CHANNELS,
+			EEPROM_REG_BAND_5_CHANNELS,
+			EEPROM_REG_BAND_24_HT40_CHANNELS,
+			EEPROM_REG_BAND_52_HT40_CHANNELS
 		},
 		.verify_signature  = iwlcore_eeprom_verify_signature,
 		.acquire_semaphore = iwlcore_eeprom_acquire_semaphore,
 		.release_semaphore = iwlcore_eeprom_release_semaphore,
-		.calib_version	= iwl5000_eeprom_calib_version,
-		.query_addr = iwl5000_eeprom_query_addr,
+		.calib_version	= iwlagn_eeprom_calib_version,
+		.query_addr = iwlagn_eeprom_query_addr,
 	},
 	.post_associate = iwl_post_associate,
 	.isr = iwl_isr_ict,
diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index 96f4fa6..92b407f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -234,9 +234,9 @@ static struct iwl_lib_ops iwl6000_lib = {
 	.txq_attach_buf_to_tfd = iwl_hw_txq_attach_buf_to_tfd,
 	.txq_free_tfd = iwl_hw_txq_free_tfd,
 	.txq_init = iwl_hw_tx_queue_init,
-	.rx_handler_setup = iwl5000_rx_handler_setup,
-	.setup_deferred_work = iwl5000_setup_deferred_work,
-	.is_valid_rtc_data_addr = iwl5000_hw_valid_rtc_data_addr,
+	.rx_handler_setup = iwlagn_rx_handler_setup,
+	.setup_deferred_work = iwlagn_setup_deferred_work,
+	.is_valid_rtc_data_addr = iwlagn_hw_valid_rtc_data_addr,
 	.load_ucode = iwlagn_load_ucode,
 	.dump_nic_event_log = iwl_dump_nic_event_log,
 	.dump_nic_error_log = iwl_dump_nic_error_log,
@@ -244,7 +244,7 @@ static struct iwl_lib_ops iwl6000_lib = {
 	.dump_fh = iwl_dump_fh,
 	.init_alive_start = iwlagn_init_alive_start,
 	.alive_notify = iwlagn_alive_notify,
-	.send_tx_power = iwl5000_send_tx_power,
+	.send_tx_power = iwlagn_send_tx_power,
 	.update_chain_flags = iwl_update_chain_flags,
 	.set_channel_switch = iwl6000_hw_channel_switch,
 	.apm_ops = {
@@ -255,26 +255,26 @@ static struct iwl_lib_ops iwl6000_lib = {
 	},
 	.eeprom_ops = {
 		.regulatory_bands = {
-			EEPROM_5000_REG_BAND_1_CHANNELS,
-			EEPROM_5000_REG_BAND_2_CHANNELS,
-			EEPROM_5000_REG_BAND_3_CHANNELS,
-			EEPROM_5000_REG_BAND_4_CHANNELS,
-			EEPROM_5000_REG_BAND_5_CHANNELS,
-			EEPROM_5000_REG_BAND_24_HT40_CHANNELS,
-			EEPROM_5000_REG_BAND_52_HT40_CHANNELS
+			EEPROM_REG_BAND_1_CHANNELS,
+			EEPROM_REG_BAND_2_CHANNELS,
+			EEPROM_REG_BAND_3_CHANNELS,
+			EEPROM_REG_BAND_4_CHANNELS,
+			EEPROM_REG_BAND_5_CHANNELS,
+			EEPROM_REG_BAND_24_HT40_CHANNELS,
+			EEPROM_REG_BAND_52_HT40_CHANNELS
 		},
 		.verify_signature  = iwlcore_eeprom_verify_signature,
 		.acquire_semaphore = iwlcore_eeprom_acquire_semaphore,
 		.release_semaphore = iwlcore_eeprom_release_semaphore,
-		.calib_version	= iwl5000_eeprom_calib_version,
-		.query_addr = iwl5000_eeprom_query_addr,
+		.calib_version	= iwlagn_eeprom_calib_version,
+		.query_addr = iwlagn_eeprom_query_addr,
 		.update_enhanced_txpower = iwlcore_eeprom_enhanced_txpower,
 	},
 	.post_associate = iwl_post_associate,
 	.isr = iwl_isr_ict,
 	.config_ap = iwl_config_ap,
 	.temp_ops = {
-		.temperature = iwl5000_temperature,
+		.temperature = iwlagn_temperature,
 		.set_ct_kill = iwl6000_set_ct_threshold,
 	 },
 	.add_bcast_station = iwl_add_bcast_station,
@@ -301,9 +301,9 @@ static struct iwl_lib_ops iwl6050_lib = {
 	.txq_attach_buf_to_tfd = iwl_hw_txq_attach_buf_to_tfd,
 	.txq_free_tfd = iwl_hw_txq_free_tfd,
 	.txq_init = iwl_hw_tx_queue_init,
-	.rx_handler_setup = iwl5000_rx_handler_setup,
-	.setup_deferred_work = iwl5000_setup_deferred_work,
-	.is_valid_rtc_data_addr = iwl5000_hw_valid_rtc_data_addr,
+	.rx_handler_setup = iwlagn_rx_handler_setup,
+	.setup_deferred_work = iwlagn_setup_deferred_work,
+	.is_valid_rtc_data_addr = iwlagn_hw_valid_rtc_data_addr,
 	.load_ucode = iwlagn_load_ucode,
 	.dump_nic_event_log = iwl_dump_nic_event_log,
 	.dump_nic_error_log = iwl_dump_nic_error_log,
@@ -311,7 +311,7 @@ static struct iwl_lib_ops iwl6050_lib = {
 	.dump_fh = iwl_dump_fh,
 	.init_alive_start = iwlagn_init_alive_start,
 	.alive_notify = iwlagn_alive_notify,
-	.send_tx_power = iwl5000_send_tx_power,
+	.send_tx_power = iwlagn_send_tx_power,
 	.update_chain_flags = iwl_update_chain_flags,
 	.set_channel_switch = iwl6000_hw_channel_switch,
 	.apm_ops = {
@@ -322,26 +322,26 @@ static struct iwl_lib_ops iwl6050_lib = {
 	},
 	.eeprom_ops = {
 		.regulatory_bands = {
-			EEPROM_5000_REG_BAND_1_CHANNELS,
-			EEPROM_5000_REG_BAND_2_CHANNELS,
-			EEPROM_5000_REG_BAND_3_CHANNELS,
-			EEPROM_5000_REG_BAND_4_CHANNELS,
-			EEPROM_5000_REG_BAND_5_CHANNELS,
-			EEPROM_5000_REG_BAND_24_HT40_CHANNELS,
-			EEPROM_5000_REG_BAND_52_HT40_CHANNELS
+			EEPROM_REG_BAND_1_CHANNELS,
+			EEPROM_REG_BAND_2_CHANNELS,
+			EEPROM_REG_BAND_3_CHANNELS,
+			EEPROM_REG_BAND_4_CHANNELS,
+			EEPROM_REG_BAND_5_CHANNELS,
+			EEPROM_REG_BAND_24_HT40_CHANNELS,
+			EEPROM_REG_BAND_52_HT40_CHANNELS
 		},
 		.verify_signature  = iwlcore_eeprom_verify_signature,
 		.acquire_semaphore = iwlcore_eeprom_acquire_semaphore,
 		.release_semaphore = iwlcore_eeprom_release_semaphore,
-		.calib_version	= iwl5000_eeprom_calib_version,
-		.query_addr = iwl5000_eeprom_query_addr,
+		.calib_version	= iwlagn_eeprom_calib_version,
+		.query_addr = iwlagn_eeprom_query_addr,
 		.update_enhanced_txpower = iwlcore_eeprom_enhanced_txpower,
 	},
 	.post_associate = iwl_post_associate,
 	.isr = iwl_isr_ict,
 	.config_ap = iwl_config_ap,
 	.temp_ops = {
-		.temperature = iwl5000_temperature,
+		.temperature = iwlagn_temperature,
 		.set_ct_kill = iwl6000_set_ct_threshold,
 		.set_calib_version = iwl6050_set_calib_version,
 	 },
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
new file mode 100644
index 0000000..e4c0726
--- /dev/null
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -0,0 +1,377 @@
+/******************************************************************************
+ *
+ * GPL LICENSE SUMMARY
+ *
+ * Copyright(c) 2008 - 2010 Intel Corporation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110,
+ * USA
+ *
+ * The full GNU General Public License is included in this distribution
+ * in the file called LICENSE.GPL.
+ *
+ * Contact Information:
+ *  Intel Linux Wireless <ilw@linux.intel.com>
+ * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
+ *
+ *****************************************************************************/
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/sched.h>
+
+#include "iwl-dev.h"
+#include "iwl-core.h"
+#include "iwl-io.h"
+#include "iwl-helpers.h"
+#include "iwl-agn-hw.h"
+#include "iwl-agn.h"
+
+static inline u32 iwlagn_get_scd_ssn(struct iwl5000_tx_resp *tx_resp)
+{
+	return le32_to_cpup((__le32 *)&tx_resp->status +
+			    tx_resp->frame_count) & MAX_SN;
+}
+
+static int iwlagn_tx_status_reply_tx(struct iwl_priv *priv,
+				      struct iwl_ht_agg *agg,
+				      struct iwl5000_tx_resp *tx_resp,
+				      int txq_id, u16 start_idx)
+{
+	u16 status;
+	struct agg_tx_status *frame_status = &tx_resp->status;
+	struct ieee80211_tx_info *info = NULL;
+	struct ieee80211_hdr *hdr = NULL;
+	u32 rate_n_flags = le32_to_cpu(tx_resp->rate_n_flags);
+	int i, sh, idx;
+	u16 seq;
+
+	if (agg->wait_for_ba)
+		IWL_DEBUG_TX_REPLY(priv, "got tx response w/o block-ack\n");
+
+	agg->frame_count = tx_resp->frame_count;
+	agg->start_idx = start_idx;
+	agg->rate_n_flags = rate_n_flags;
+	agg->bitmap = 0;
+
+	/* # frames attempted by Tx command */
+	if (agg->frame_count == 1) {
+		/* Only one frame was attempted; no block-ack will arrive */
+		status = le16_to_cpu(frame_status[0].status);
+		idx = start_idx;
+
+		/* FIXME: code repetition */
+		IWL_DEBUG_TX_REPLY(priv, "FrameCnt = %d, StartIdx=%d idx=%d\n",
+				   agg->frame_count, agg->start_idx, idx);
+
+		info = IEEE80211_SKB_CB(priv->txq[txq_id].txb[idx].skb[0]);
+		info->status.rates[0].count = tx_resp->failure_frame + 1;
+		info->flags &= ~IEEE80211_TX_CTL_AMPDU;
+		info->flags |= iwl_tx_status_to_mac80211(status);
+		iwl_hwrate_to_tx_control(priv, rate_n_flags, info);
+
+		/* FIXME: code repetition end */
+
+		IWL_DEBUG_TX_REPLY(priv, "1 Frame 0x%x failure :%d\n",
+				    status & 0xff, tx_resp->failure_frame);
+		IWL_DEBUG_TX_REPLY(priv, "Rate Info rate_n_flags=%x\n", rate_n_flags);
+
+		agg->wait_for_ba = 0;
+	} else {
+		/* Two or more frames were attempted; expect block-ack */
+		u64 bitmap = 0;
+		int start = agg->start_idx;
+
+		/* Construct bit-map of pending frames within Tx window */
+		for (i = 0; i < agg->frame_count; i++) {
+			u16 sc;
+			status = le16_to_cpu(frame_status[i].status);
+			seq  = le16_to_cpu(frame_status[i].sequence);
+			idx = SEQ_TO_INDEX(seq);
+			txq_id = SEQ_TO_QUEUE(seq);
+
+			if (status & (AGG_TX_STATE_FEW_BYTES_MSK |
+				      AGG_TX_STATE_ABORT_MSK))
+				continue;
+
+			IWL_DEBUG_TX_REPLY(priv, "FrameCnt = %d, txq_id=%d idx=%d\n",
+					   agg->frame_count, txq_id, idx);
+
+			hdr = iwl_tx_queue_get_hdr(priv, txq_id, idx);
+			if (!hdr) {
+				IWL_ERR(priv,
+					"BUG_ON idx doesn't point to valid skb"
+					" idx=%d, txq_id=%d\n", idx, txq_id);
+				return -1;
+			}
+
+			sc = le16_to_cpu(hdr->seq_ctrl);
+			if (idx != (SEQ_TO_SN(sc) & 0xff)) {
+				IWL_ERR(priv,
+					"BUG_ON idx doesn't match seq control"
+					" idx=%d, seq_idx=%d, seq=%d\n",
+					  idx, SEQ_TO_SN(sc),
+					  hdr->seq_ctrl);
+				return -1;
+			}
+
+			IWL_DEBUG_TX_REPLY(priv, "AGG Frame i=%d idx %d seq=%d\n",
+					   i, idx, SEQ_TO_SN(sc));
+
+			sh = idx - start;
+			if (sh > 64) {
+				sh = (start - idx) + 0xff;
+				bitmap = bitmap << sh;
+				sh = 0;
+				start = idx;
+			} else if (sh < -64)
+				sh  = 0xff - (start - idx);
+			else if (sh < 0) {
+				sh = start - idx;
+				start = idx;
+				bitmap = bitmap << sh;
+				sh = 0;
+			}
+			bitmap |= 1ULL << sh;
+			IWL_DEBUG_TX_REPLY(priv, "start=%d bitmap=0x%llx\n",
+					   start, (unsigned long long)bitmap);
+		}
+
+		agg->bitmap = bitmap;
+		agg->start_idx = start;
+		IWL_DEBUG_TX_REPLY(priv, "Frames %d start_idx=%d bitmap=0x%llx\n",
+				   agg->frame_count, agg->start_idx,
+				   (unsigned long long)agg->bitmap);
+
+		if (bitmap)
+			agg->wait_for_ba = 1;
+	}
+	return 0;
+}
+
+static void iwlagn_rx_reply_tx(struct iwl_priv *priv,
+				struct iwl_rx_mem_buffer *rxb)
+{
+	struct iwl_rx_packet *pkt = rxb_addr(rxb);
+	u16 sequence = le16_to_cpu(pkt->hdr.sequence);
+	int txq_id = SEQ_TO_QUEUE(sequence);
+	int index = SEQ_TO_INDEX(sequence);
+	struct iwl_tx_queue *txq = &priv->txq[txq_id];
+	struct ieee80211_tx_info *info;
+	struct iwl5000_tx_resp *tx_resp = (void *)&pkt->u.raw[0];
+	u32  status = le16_to_cpu(tx_resp->status.status);
+	int tid;
+	int sta_id;
+	int freed;
+
+	if ((index >= txq->q.n_bd) || (iwl_queue_used(&txq->q, index) == 0)) {
+		IWL_ERR(priv, "Read index for DMA queue txq_id (%d) index %d "
+			  "is out of range [0-%d] %d %d\n", txq_id,
+			  index, txq->q.n_bd, txq->q.write_ptr,
+			  txq->q.read_ptr);
+		return;
+	}
+
+	info = IEEE80211_SKB_CB(txq->txb[txq->q.read_ptr].skb[0]);
+	memset(&info->status, 0, sizeof(info->status));
+
+	tid = (tx_resp->ra_tid & IWL50_TX_RES_TID_MSK) >> IWL50_TX_RES_TID_POS;
+	sta_id = (tx_resp->ra_tid & IWL50_TX_RES_RA_MSK) >> IWL50_TX_RES_RA_POS;
+
+	if (txq->sched_retry) {
+		const u32 scd_ssn = iwlagn_get_scd_ssn(tx_resp);
+		struct iwl_ht_agg *agg = NULL;
+
+		agg = &priv->stations[sta_id].tid[tid].agg;
+
+		iwlagn_tx_status_reply_tx(priv, agg, tx_resp, txq_id, index);
+
+		/* check if BAR is needed */
+		if ((tx_resp->frame_count == 1) && !iwl_is_tx_success(status))
+			info->flags |= IEEE80211_TX_STAT_AMPDU_NO_BACK;
+
+		if (txq->q.read_ptr != (scd_ssn & 0xff)) {
+			index = iwl_queue_dec_wrap(scd_ssn & 0xff, txq->q.n_bd);
+			IWL_DEBUG_TX_REPLY(priv, "Retry scheduler reclaim "
+					"scd_ssn=%d idx=%d txq=%d swq=%d\n",
+					scd_ssn , index, txq_id, txq->swq_id);
+
+			freed = iwl_tx_queue_reclaim(priv, txq_id, index);
+			iwl_free_tfds_in_queue(priv, sta_id, tid, freed);
+
+			if (priv->mac80211_registered &&
+			    (iwl_queue_space(&txq->q) > txq->q.low_mark) &&
+			    (agg->state != IWL_EMPTYING_HW_QUEUE_DELBA)) {
+				if (agg->state == IWL_AGG_OFF)
+					iwl_wake_queue(priv, txq_id);
+				else
+					iwl_wake_queue(priv, txq->swq_id);
+			}
+		}
+	} else {
+		BUG_ON(txq_id != txq->swq_id);
+
+		info->status.rates[0].count = tx_resp->failure_frame + 1;
+		info->flags |= iwl_tx_status_to_mac80211(status);
+		iwl_hwrate_to_tx_control(priv,
+					le32_to_cpu(tx_resp->rate_n_flags),
+					info);
+
+		IWL_DEBUG_TX_REPLY(priv, "TXQ %d status %s (0x%08x) rate_n_flags "
+				   "0x%x retries %d\n",
+				   txq_id,
+				   iwl_get_tx_fail_reason(status), status,
+				   le32_to_cpu(tx_resp->rate_n_flags),
+				   tx_resp->failure_frame);
+
+		freed = iwl_tx_queue_reclaim(priv, txq_id, index);
+		iwl_free_tfds_in_queue(priv, sta_id, tid, freed);
+
+		if (priv->mac80211_registered &&
+		    (iwl_queue_space(&txq->q) > txq->q.low_mark))
+			iwl_wake_queue(priv, txq_id);
+	}
+
+	iwl_txq_check_empty(priv, sta_id, tid, txq_id);
+
+	if (iwl_check_bits(status, TX_ABORT_REQUIRED_MSK))
+		IWL_ERR(priv, "TODO:  Implement Tx ABORT REQUIRED!!!\n");
+}
+
+void iwlagn_rx_handler_setup(struct iwl_priv *priv)
+{
+	/* init calibration handlers */
+	priv->rx_handlers[CALIBRATION_RES_NOTIFICATION] =
+					iwlagn_rx_calib_result;
+	priv->rx_handlers[CALIBRATION_COMPLETE_NOTIFICATION] =
+					iwlagn_rx_calib_complete;
+	priv->rx_handlers[REPLY_TX] = iwlagn_rx_reply_tx;
+}
+
+void iwlagn_setup_deferred_work(struct iwl_priv *priv)
+{
+	/* in agn, the tx power calibration is done in uCode */
+	priv->disable_tx_power_cal = 1;
+}
+
+int iwlagn_hw_valid_rtc_data_addr(u32 addr)
+{
+	return (addr >= IWLAGN_RTC_DATA_LOWER_BOUND) &&
+		(addr < IWLAGN_RTC_DATA_UPPER_BOUND);
+}
+
+int iwlagn_send_tx_power(struct iwl_priv *priv)
+{
+	struct iwl5000_tx_power_dbm_cmd tx_power_cmd;
+	u8 tx_ant_cfg_cmd;
+
+	/* half dBm need to multiply */
+	tx_power_cmd.global_lmt = (s8)(2 * priv->tx_power_user_lmt);
+
+	if (priv->tx_power_lmt_in_half_dbm &&
+	    priv->tx_power_lmt_in_half_dbm < tx_power_cmd.global_lmt) {
+		/*
+		 * For the newer devices which using enhanced/extend tx power
+		 * table in EEPROM, the format is in half dBm. driver need to
+		 * convert to dBm format before report to mac80211.
+		 * By doing so, there is a possibility of 1/2 dBm resolution
+		 * lost. driver will perform "round-up" operation before
+		 * reporting, but it will cause 1/2 dBm tx power over the
+		 * regulatory limit. Perform the checking here, if the
+		 * "tx_power_user_lmt" is higher than EEPROM value (in
+		 * half-dBm format), lower the tx power based on EEPROM
+		 */
+		tx_power_cmd.global_lmt = priv->tx_power_lmt_in_half_dbm;
+	}
+	tx_power_cmd.flags = IWL50_TX_POWER_NO_CLOSED;
+	tx_power_cmd.srv_chan_lmt = IWL50_TX_POWER_AUTO;
+
+	if (IWL_UCODE_API(priv->ucode_ver) == 1)
+		tx_ant_cfg_cmd = REPLY_TX_POWER_DBM_CMD_V1;
+	else
+		tx_ant_cfg_cmd = REPLY_TX_POWER_DBM_CMD;
+
+	return  iwl_send_cmd_pdu_async(priv, tx_ant_cfg_cmd,
+				       sizeof(tx_power_cmd), &tx_power_cmd,
+				       NULL);
+}
+
+void iwlagn_temperature(struct iwl_priv *priv)
+{
+	/* store temperature from statistics (in Celsius) */
+	priv->temperature = le32_to_cpu(priv->statistics.general.temperature);
+	iwl_tt_handler(priv);
+}
+
+u16 iwlagn_eeprom_calib_version(struct iwl_priv *priv)
+{
+	struct iwl_eeprom_calib_hdr {
+		u8 version;
+		u8 pa_type;
+		u16 voltage;
+	} *hdr;
+
+	hdr = (struct iwl_eeprom_calib_hdr *)iwl_eeprom_query_addr(priv,
+							EEPROM_5000_CALIB_ALL);
+	return hdr->version;
+
+}
+
+/*
+ * EEPROM
+ */
+static u32 eeprom_indirect_address(const struct iwl_priv *priv, u32 address)
+{
+	u16 offset = 0;
+
+	if ((address & INDIRECT_ADDRESS) == 0)
+		return address;
+
+	switch (address & INDIRECT_TYPE_MSK) {
+	case INDIRECT_HOST:
+		offset = iwl_eeprom_query16(priv, EEPROM_5000_LINK_HOST);
+		break;
+	case INDIRECT_GENERAL:
+		offset = iwl_eeprom_query16(priv, EEPROM_5000_LINK_GENERAL);
+		break;
+	case INDIRECT_REGULATORY:
+		offset = iwl_eeprom_query16(priv, EEPROM_5000_LINK_REGULATORY);
+		break;
+	case INDIRECT_CALIBRATION:
+		offset = iwl_eeprom_query16(priv, EEPROM_5000_LINK_CALIBRATION);
+		break;
+	case INDIRECT_PROCESS_ADJST:
+		offset = iwl_eeprom_query16(priv, EEPROM_5000_LINK_PROCESS_ADJST);
+		break;
+	case INDIRECT_OTHERS:
+		offset = iwl_eeprom_query16(priv, EEPROM_5000_LINK_OTHERS);
+		break;
+	default:
+		IWL_ERR(priv, "illegal indirect type: 0x%X\n",
+		address & INDIRECT_TYPE_MSK);
+		break;
+	}
+
+	/* translate the offset from words to byte */
+	return (address & ADDRESS_MSK) + (offset << 1);
+}
+
+const u8 *iwlagn_eeprom_query_addr(const struct iwl_priv *priv,
+					   size_t offset)
+{
+	u32 address = eeprom_indirect_address(priv, offset);
+	BUG_ON(address >= priv->cfg->eeprom_size);
+	return &priv->eeprom[address];
+}
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.h b/drivers/net/wireless/iwlwifi/iwl-agn.h
index 9b66765..aa49e66 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.h
@@ -103,4 +103,14 @@ void iwlagn_rx_calib_complete(struct iwl_priv *priv,
 void iwlagn_init_alive_start(struct iwl_priv *priv);
 int iwlagn_alive_notify(struct iwl_priv *priv);
 
+/* lib */
+void iwlagn_rx_handler_setup(struct iwl_priv *priv);
+void iwlagn_setup_deferred_work(struct iwl_priv *priv);
+int iwlagn_hw_valid_rtc_data_addr(u32 addr);
+int iwlagn_send_tx_power(struct iwl_priv *priv);
+void iwlagn_temperature(struct iwl_priv *priv);
+u16 iwlagn_eeprom_calib_version(struct iwl_priv *priv);
+const u8 *iwlagn_eeprom_query_addr(const struct iwl_priv *priv,
+				   size_t offset);
+
 #endif /* __iwl_agn_h__ */
diff --git a/drivers/net/wireless/iwlwifi/iwl-eeprom.h b/drivers/net/wireless/iwlwifi/iwl-eeprom.h
index 4e1ba82..907a30a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-eeprom.h
+++ b/drivers/net/wireless/iwlwifi/iwl-eeprom.h
@@ -188,19 +188,19 @@ struct iwl_eeprom_enhanced_txpwr {
 /* 5000 regulatory - indirect access */
 #define EEPROM_5000_REG_SKU_ID ((0x02)\
 		| INDIRECT_ADDRESS | INDIRECT_REGULATORY)   /* 4  bytes */
-#define EEPROM_5000_REG_BAND_1_CHANNELS       ((0x08)\
+#define EEPROM_REG_BAND_1_CHANNELS       ((0x08)\
 		| INDIRECT_ADDRESS | INDIRECT_REGULATORY)   /* 28 bytes */
-#define EEPROM_5000_REG_BAND_2_CHANNELS       ((0x26)\
+#define EEPROM_REG_BAND_2_CHANNELS       ((0x26)\
 		| INDIRECT_ADDRESS | INDIRECT_REGULATORY)   /* 26 bytes */
-#define EEPROM_5000_REG_BAND_3_CHANNELS       ((0x42)\
+#define EEPROM_REG_BAND_3_CHANNELS       ((0x42)\
 		| INDIRECT_ADDRESS | INDIRECT_REGULATORY)   /* 24 bytes */
-#define EEPROM_5000_REG_BAND_4_CHANNELS       ((0x5C)\
+#define EEPROM_REG_BAND_4_CHANNELS       ((0x5C)\
 		| INDIRECT_ADDRESS | INDIRECT_REGULATORY)   /* 22 bytes */
-#define EEPROM_5000_REG_BAND_5_CHANNELS       ((0x74)\
+#define EEPROM_REG_BAND_5_CHANNELS       ((0x74)\
 		| INDIRECT_ADDRESS | INDIRECT_REGULATORY)   /* 12 bytes */
-#define EEPROM_5000_REG_BAND_24_HT40_CHANNELS  ((0x82)\
+#define EEPROM_REG_BAND_24_HT40_CHANNELS  ((0x82)\
 		| INDIRECT_ADDRESS | INDIRECT_REGULATORY)   /* 14  bytes */
-#define EEPROM_5000_REG_BAND_52_HT40_CHANNELS  ((0x92)\
+#define EEPROM_REG_BAND_52_HT40_CHANNELS  ((0x92)\
 		| INDIRECT_ADDRESS | INDIRECT_REGULATORY)   /* 22  bytes */
 
 /* 6000 and up regulatory tx power - indirect access */
-- 
1.6.3.3

