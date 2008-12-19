Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:32389 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752762AbYLSCpf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Dec 2008 21:45:35 -0500
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	"Winkler, Tomas" <tomas.winkler@intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 33/43] iwlwifi: replace IWL_ERROR with IWL_ERR
Date: Fri, 19 Dec 2008 10:37:33 +0800
Message-Id: <1229654263-21454-34-git-send-email-yi.zhu@intel.com> (sfid-20081219_040902_150671_B1706C5E)
In-Reply-To: <1229654263-21454-33-git-send-email-yi.zhu@intel.com>
References: <1229654263-21454-1-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-2-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-3-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-4-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-5-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-6-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-7-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-8-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-9-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-10-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-11-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-12-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-13-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-14-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-15-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-16-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-17-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-18-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-19-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-20-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-21-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-22-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-23-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-24-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-25-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-26-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-27-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-28-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-29-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-30-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-31-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-32-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-33-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Winkler, Tomas <tomas.winkler@intel.com>

IWL_ERR doesn't use hidden priv pointer.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945-led.c       |    2 +-
 drivers/net/wireless/iwlwifi/iwl-3945.c           |   30 ++--
 drivers/net/wireless/iwlwifi/iwl-4965.c           |   32 ++--
 drivers/net/wireless/iwlwifi/iwl-5000.c           |   29 ++--
 drivers/net/wireless/iwlwifi/iwl-agn-hcmd-check.c |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c         |    7 +-
 drivers/net/wireless/iwlwifi/iwl-agn.c            |   88 +++++-----
 drivers/net/wireless/iwlwifi/iwl-calib.c          |    4 +-
 drivers/net/wireless/iwlwifi/iwl-core.c           |   41 +++--
 drivers/net/wireless/iwlwifi/iwl-debug.h          |    1 -
 drivers/net/wireless/iwlwifi/iwl-debugfs.c        |    8 +-
 drivers/net/wireless/iwlwifi/iwl-eeprom.c         |   12 +-
 drivers/net/wireless/iwlwifi/iwl-hcmd.c           |   22 ++-
 drivers/net/wireless/iwlwifi/iwl-io.h             |   18 +-
 drivers/net/wireless/iwlwifi/iwl-led.c            |    2 +-
 drivers/net/wireless/iwlwifi/iwl-rfkill.c         |    4 +-
 drivers/net/wireless/iwlwifi/iwl-rx.c             |    4 +-
 drivers/net/wireless/iwlwifi/iwl-spectrum.c       |    2 +-
 drivers/net/wireless/iwlwifi/iwl-sta.c            |   36 ++--
 drivers/net/wireless/iwlwifi/iwl-tx.c             |   35 ++--
 drivers/net/wireless/iwlwifi/iwl3945-base.c       |  192 +++++++++++----------
 21 files changed, 299 insertions(+), 272 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945-led.c b/drivers/net/wireless/iwlwifi/iwl-3945-led.c
index 165da9e..958e705 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945-led.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945-led.c
@@ -216,7 +216,7 @@ static int iwl3945_led_register_led(struct iwl_priv *priv,
 
 	ret = led_classdev_register(device, &led->led_dev);
 	if (ret) {
-		IWL_ERROR("Error: failed to register led handler.\n");
+		IWL_ERR(priv, "Error: failed to register led handler.\n");
 		return ret;
 	}
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index de9bf2b..5a44a87 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -152,7 +152,7 @@ void iwl3945_disable_events(struct iwl_priv *priv)
 
 	base = le32_to_cpu(priv->card_alive.log_event_table_ptr);
 	if (!iwl3945_hw_valid_rtc_data_addr(base)) {
-		IWL_ERROR("Invalid event log pointer 0x%08X\n", base);
+		IWL_ERR(priv, "Invalid event log pointer 0x%08X\n", base);
 		return;
 	}
 
@@ -224,7 +224,7 @@ __le32 iwl3945_get_antenna_flags(const struct iwl_priv *priv)
 	}
 
 	/* bad antenna selector value */
-	IWL_ERROR("Bad antenna selector value (0x%x)\n", priv->antenna);
+	IWL_ERR(priv, "Bad antenna selector value (0x%x)\n", priv->antenna);
 	return 0;		/* "diversity" is default if error */
 }
 
@@ -344,7 +344,7 @@ static void iwl3945_rx_reply_tx(struct iwl_priv *priv,
 	int fail;
 
 	if ((index >= txq->q.n_bd) || (iwl3945_x2_queue_used(&txq->q, index) == 0)) {
-		IWL_ERROR("Read index for DMA queue txq_id (%d) index %d "
+		IWL_ERR(priv, "Read index for DMA queue txq_id (%d) index %d "
 			  "is out of range [0-%d] %d %d\n", txq_id,
 			  index, txq->q.n_bd, txq->q.write_ptr,
 			  txq->q.read_ptr);
@@ -376,7 +376,7 @@ static void iwl3945_rx_reply_tx(struct iwl_priv *priv,
 	iwl3945_tx_queue_reclaim(priv, txq_id, index);
 
 	if (iwl_check_bits(status, TX_ABORT_REQUIRED_MSK))
-		IWL_ERROR("TODO:  Implement Tx ABORT REQUIRED!!!\n");
+		IWL_ERR(priv, "TODO:  Implement Tx ABORT REQUIRED!!!\n");
 }
 
 
@@ -734,7 +734,7 @@ int iwl3945_hw_txq_attach_buf_to_tfd(struct iwl_priv *priv, void *ptr,
 	pad = TFD_CTL_PAD_GET(le32_to_cpu(tfd->control_flags));
 
 	if ((count >= NUM_TFD_CHUNKS) || (count < 0)) {
-		IWL_ERROR("Error can not send more than %d chunks\n",
+		IWL_ERR(priv, "Error can not send more than %d chunks\n",
 			  NUM_TFD_CHUNKS);
 		return -EINVAL;
 	}
@@ -771,7 +771,7 @@ int iwl3945_hw_txq_free_tfd(struct iwl_priv *priv, struct iwl3945_tx_queue *txq)
 	/* sanity check */
 	counter = TFD_CTL_COUNT_GET(le32_to_cpu(bd->control_flags));
 	if (counter > NUM_TFD_CHUNKS) {
-		IWL_ERROR("Too many chunks: %i\n", counter);
+		IWL_ERR(priv, "Too many chunks: %i\n", counter);
 		/* @todo issue fatal error, it is quite serious situation */
 		return 0;
 	}
@@ -1066,7 +1066,7 @@ static int iwl3945_txq_ctx_reset(struct iwl_priv *priv)
 		rc = iwl3945_tx_queue_init(priv, &priv->txq39[txq_id], slots_num,
 				txq_id);
 		if (rc) {
-			IWL_ERROR("Tx %d queue init failed\n", txq_id);
+			IWL_ERR(priv, "Tx %d queue init failed\n", txq_id);
 			goto error;
 		}
 	}
@@ -1178,7 +1178,7 @@ int iwl3945_hw_nic_init(struct iwl_priv *priv)
 	if (!rxq->bd) {
 		rc = iwl3945_rx_queue_alloc(priv);
 		if (rc) {
-			IWL_ERROR("Unable to initialize Rx queue\n");
+			IWL_ERR(priv, "Unable to initialize Rx queue\n");
 			return -ENOMEM;
 		}
 	} else
@@ -1378,7 +1378,7 @@ static int iwl3945_hw_reg_txpower_get_temperature(struct iwl_priv *priv)
 
 	/* handle insane temp reading */
 	if (iwl3945_hw_reg_temp_out_of_range(temperature)) {
-		IWL_ERROR("Error bad temperature value  %d\n", temperature);
+		IWL_ERR(priv, "Error bad temperature value  %d\n", temperature);
 
 		/* if really really hot(?),
 		 *   substitute the 3rd band/group's temp measured at factory */
@@ -1686,9 +1686,9 @@ int iwl3945_hw_reg_send_txpower(struct iwl_priv *priv)
 				       priv->band,
 				       le16_to_cpu(priv->active39_rxon.channel));
 	if (!ch_info) {
-		IWL_ERROR
-		    ("Failed to get channel info for channel %d [%d]\n",
-		     le16_to_cpu(priv->active39_rxon.channel), priv->band);
+		IWL_ERR(priv,
+			"Failed to get channel info for channel %d [%d]\n",
+			le16_to_cpu(priv->active39_rxon.channel), priv->band);
 		return -EINVAL;
 	}
 
@@ -2225,7 +2225,7 @@ int iwl3945_txpower_set_from_eeprom(struct iwl_priv *priv)
 							 ch_info->group_index,
 							 &power_idx);
 			if (rc) {
-				IWL_ERROR("Invalid power index\n");
+				IWL_ERR(priv, "Invalid power index\n");
 				return rc;
 			}
 			pwr_info->base_power_index = (u8) power_idx;
@@ -2301,7 +2301,7 @@ int iwl3945_hw_rxq_stop(struct iwl_priv *priv)
 	rc = iwl_poll_direct_bit(priv, FH39_RSSR_STATUS,
 			FH39_RSSR_CHNL0_RX_STATUS_CHNL_IDLE, 1000);
 	if (rc < 0)
-		IWL_ERROR("Can't stop Rx DMA.\n");
+		IWL_ERR(priv, "Can't stop Rx DMA.\n");
 
 	iwl_release_nic_access(priv);
 	spin_unlock_irqrestore(&priv->lock, flags);
@@ -2441,7 +2441,7 @@ int iwl3945_hw_set_hw_params(struct iwl_priv *priv)
 				 &priv->shared_phys);
 
 	if (!priv->shared_virt) {
-		IWL_ERROR("failed to allocate pci memory\n");
+		IWL_ERR(priv, "failed to allocate pci memory\n");
 		mutex_unlock(&priv->mutex);
 		return -ENOMEM;
 	}
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 3de8d64..e68d587 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -85,7 +85,7 @@ static int iwl4965_verify_bsm(struct iwl_priv *priv)
 	     reg += sizeof(u32), image++) {
 		val = iwl_read_prph(priv, reg);
 		if (val != le32_to_cpu(*image)) {
-			IWL_ERROR("BSM uCode verification failed at "
+			IWL_ERR(priv, "BSM uCode verification failed at "
 				  "addr 0x%08X+%u (of %u), is 0x%x, s/b 0x%x\n",
 				  BSM_SRAM_LOWER_BOUND,
 				  reg - BSM_SRAM_LOWER_BOUND, len,
@@ -203,7 +203,7 @@ static int iwl4965_load_bsm(struct iwl_priv *priv)
 	if (i < 100)
 		IWL_DEBUG_INFO("BSM write complete, poll %d iterations\n", i);
 	else {
-		IWL_ERROR("BSM write did not complete!\n");
+		IWL_ERR(priv, "BSM write did not complete!\n");
 		return -EIO;
 	}
 
@@ -523,7 +523,8 @@ static void iwl4965_chain_noise_reset(struct iwl_priv *priv)
 		cmd.diff_gain_c = 0;
 		if (iwl_send_cmd_pdu(priv, REPLY_PHY_CALIBRATION_CMD,
 				 sizeof(cmd), &cmd))
-			IWL_ERROR("Could not send REPLY_PHY_CALIBRATION_CMD\n");
+			IWL_ERR(priv,
+				"Could not send REPLY_PHY_CALIBRATION_CMD\n");
 		data->state = IWL_CHAIN_NOISE_ACCUMULATE;
 		IWL_DEBUG_CALIB("Run chain_noise_calibrate\n");
 	}
@@ -804,8 +805,9 @@ static int iwl4965_hw_set_hw_params(struct iwl_priv *priv)
 
 	if ((priv->cfg->mod_params->num_of_queues > IWL49_NUM_QUEUES) ||
 	    (priv->cfg->mod_params->num_of_queues < IWL_MIN_NUM_QUEUES)) {
-		IWL_ERROR("invalid queues_num, should be between %d and %d\n",
-			  IWL_MIN_NUM_QUEUES, IWL49_NUM_QUEUES);
+		IWL_ERR(priv,
+			"invalid queues_num, should be between %d and %d\n",
+			IWL_MIN_NUM_QUEUES, IWL49_NUM_QUEUES);
 		return -EINVAL;
 	}
 
@@ -955,7 +957,7 @@ static int iwl4965_interpolate_chan(struct iwl_priv *priv, u32 channel,
 
 	s = iwl4965_get_sub_band(priv, channel);
 	if (s >= EEPROM_TX_POWER_BANDS) {
-		IWL_ERROR("Tx Power can not find channel %d\n", channel);
+		IWL_ERR(priv, "Tx Power can not find channel %d\n", channel);
 		return -1;
 	}
 
@@ -1319,7 +1321,7 @@ static int iwl4965_fill_txpower_tbl(struct iwl_priv *priv, u8 band, u16 channel,
 	 *   and 2) mimo txpower balance between Tx chains. */
 	txatten_grp = iwl4965_get_tx_atten_grp(channel);
 	if (txatten_grp < 0) {
-		IWL_ERROR("Can't find txatten group for channel %d.\n",
+		IWL_ERR(priv, "Can't find txatten group for channel %d.\n",
 			  channel);
 		return -EINVAL;
 	}
@@ -1727,7 +1729,7 @@ static int iwl4965_hw_get_temperature(const struct iwl_priv *priv)
 	IWL_DEBUG_TEMP("Calib values R[1-3]: %d %d %d R4: %d\n", R1, R2, R3, vt);
 
 	if (R3 == R1) {
-		IWL_ERROR("Calibration conflict R1 == R3\n");
+		IWL_ERR(priv, "Calibration conflict R1 == R3\n");
 		return -1;
 	}
 
@@ -2071,10 +2073,10 @@ static int iwl4965_tx_status_reply_tx(struct iwl_priv *priv,
 
 			sc = le16_to_cpu(hdr->seq_ctrl);
 			if (idx != (SEQ_TO_SN(sc) & 0xff)) {
-				IWL_ERROR("BUG_ON idx doesn't match seq control"
-					  " idx=%d, seq_idx=%d, seq=%d\n",
-					  idx, SEQ_TO_SN(sc),
-					  hdr->seq_ctrl);
+				IWL_ERR(priv,
+					"BUG_ON idx doesn't match seq control"
+					" idx=%d, seq_idx=%d, seq=%d\n",
+					idx, SEQ_TO_SN(sc), hdr->seq_ctrl);
 				return -1;
 			}
 
@@ -2133,7 +2135,7 @@ static void iwl4965_rx_reply_tx(struct iwl_priv *priv,
 	u8 *qc = NULL;
 
 	if ((index >= txq->q.n_bd) || (iwl_queue_used(&txq->q, index) == 0)) {
-		IWL_ERROR("Read index for DMA queue txq_id (%d) index %d "
+		IWL_ERR(priv, "Read index for DMA queue txq_id (%d) index %d "
 			  "is out of range [0-%d] %d %d\n", txq_id,
 			  index, txq->q.n_bd, txq->q.write_ptr,
 			  txq->q.read_ptr);
@@ -2151,7 +2153,7 @@ static void iwl4965_rx_reply_tx(struct iwl_priv *priv,
 
 	sta_id = iwl_get_ra_sta_id(priv, hdr);
 	if (txq->sched_retry && unlikely(sta_id == IWL_INVALID_STATION)) {
-		IWL_ERROR("Station not known\n");
+		IWL_ERR(priv, "Station not known\n");
 		return;
 	}
 
@@ -2214,7 +2216,7 @@ static void iwl4965_rx_reply_tx(struct iwl_priv *priv,
 		iwl_txq_check_empty(priv, sta_id, tid, txq_id);
 
 	if (iwl_check_bits(status, TX_ABORT_REQUIRED_MSK))
-		IWL_ERROR("TODO:  Implement Tx ABORT REQUIRED!!!\n");
+		IWL_ERR(priv, "TODO:  Implement Tx ABORT REQUIRED!!!\n");
 }
 
 static int iwl4965_calc_rssi(struct iwl_priv *priv,
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index 448bdb6..76d86fe 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -289,7 +289,7 @@ static u32 eeprom_indirect_address(const struct iwl_priv *priv, u32 address)
 		offset = iwl_eeprom_query16(priv, EEPROM_5000_LINK_OTHERS);
 		break;
 	default:
-		IWL_ERROR("illegal indirect type: 0x%X\n",
+		IWL_ERR(priv, "illegal indirect type: 0x%X\n",
 		address & INDIRECT_TYPE_MSK);
 		break;
 	}
@@ -384,7 +384,8 @@ static void iwl5000_chain_noise_reset(struct iwl_priv *priv)
 		ret = iwl_send_cmd_pdu(priv, REPLY_PHY_CALIBRATION_CMD,
 					sizeof(cmd), &cmd);
 		if (ret)
-			IWL_ERROR("Could not send REPLY_PHY_CALIBRATION_CMD\n");
+			IWL_ERR(priv,
+				"Could not send REPLY_PHY_CALIBRATION_CMD\n");
 		data->state = IWL_CHAIN_NOISE_ACCUMULATE;
 		IWL_DEBUG_CALIB("Run chain_noise_calibrate\n");
 	}
@@ -507,7 +508,7 @@ static void iwl5000_rx_calib_result(struct iwl_priv *priv,
 		index = IWL_CALIB_BASE_BAND;
 		break;
 	default:
-		IWL_ERROR("Unknown calibration notification %d\n",
+		IWL_ERR(priv, "Unknown calibration notification %d\n",
 			  hdr->op_code);
 		return;
 	}
@@ -589,12 +590,12 @@ static int iwl5000_load_given_ucode(struct iwl_priv *priv,
 	ret = wait_event_interruptible_timeout(priv->wait_command_queue,
 					priv->ucode_write_complete, 5 * HZ);
 	if (ret == -ERESTARTSYS) {
-		IWL_ERROR("Could not load the INST uCode section due "
+		IWL_ERR(priv, "Could not load the INST uCode section due "
 			"to interrupt\n");
 		return ret;
 	}
 	if (!ret) {
-		IWL_ERROR("Could not load the INST uCode section\n");
+		IWL_ERR(priv, "Could not load the INST uCode section\n");
 		return -ETIMEDOUT;
 	}
 
@@ -610,11 +611,11 @@ static int iwl5000_load_given_ucode(struct iwl_priv *priv,
 	ret = wait_event_interruptible_timeout(priv->wait_command_queue,
 				priv->ucode_write_complete, 5 * HZ);
 	if (ret == -ERESTARTSYS) {
-		IWL_ERROR("Could not load the INST uCode section due "
+		IWL_ERR(priv, "Could not load the INST uCode section due "
 			"to interrupt\n");
 		return ret;
 	} else if (!ret) {
-		IWL_ERROR("Could not load the DATA uCode section\n");
+		IWL_ERR(priv, "Could not load the DATA uCode section\n");
 		return -ETIMEDOUT;
 	} else
 		ret = 0;
@@ -826,8 +827,9 @@ static int iwl5000_hw_set_hw_params(struct iwl_priv *priv)
 {
 	if ((priv->cfg->mod_params->num_of_queues > IWL50_NUM_QUEUES) ||
 	    (priv->cfg->mod_params->num_of_queues < IWL_MIN_NUM_QUEUES)) {
-		IWL_ERROR("invalid queues_num, should be between %d and %d\n",
-			  IWL_MIN_NUM_QUEUES, IWL50_NUM_QUEUES);
+		IWL_ERR(priv,
+			"invalid queues_num, should be between %d and %d\n",
+			IWL_MIN_NUM_QUEUES, IWL50_NUM_QUEUES);
 		return -EINVAL;
 	}
 
@@ -1201,8 +1203,9 @@ static int iwl5000_tx_status_reply_tx(struct iwl_priv *priv,
 
 			sc = le16_to_cpu(hdr->seq_ctrl);
 			if (idx != (SEQ_TO_SN(sc) & 0xff)) {
-				IWL_ERROR("BUG_ON idx doesn't match seq control"
-					  " idx=%d, seq_idx=%d, seq=%d\n",
+				IWL_ERR(priv,
+					"BUG_ON idx doesn't match seq control"
+					" idx=%d, seq_idx=%d, seq=%d\n",
 					  idx, SEQ_TO_SN(sc),
 					  hdr->seq_ctrl);
 				return -1;
@@ -1258,7 +1261,7 @@ static void iwl5000_rx_reply_tx(struct iwl_priv *priv,
 	int freed;
 
 	if ((index >= txq->q.n_bd) || (iwl_queue_used(&txq->q, index) == 0)) {
-		IWL_ERROR("Read index for DMA queue txq_id (%d) index %d "
+		IWL_ERR(priv, "Read index for DMA queue txq_id (%d) index %d "
 			  "is out of range [0-%d] %d %d\n", txq_id,
 			  index, txq->q.n_bd, txq->q.write_ptr,
 			  txq->q.read_ptr);
@@ -1332,7 +1335,7 @@ static void iwl5000_rx_reply_tx(struct iwl_priv *priv,
 		iwl_txq_check_empty(priv, sta_id, tid, txq_id);
 
 	if (iwl_check_bits(status, TX_ABORT_REQUIRED_MSK))
-		IWL_ERROR("TODO:  Implement Tx ABORT REQUIRED!!!\n");
+		IWL_ERR(priv, "TODO:  Implement Tx ABORT REQUIRED!!!\n");
 }
 
 /* Currently 5000 is the superset of everything */
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-hcmd-check.c b/drivers/net/wireless/iwlwifi/iwl-agn-hcmd-check.c
index 16e656a..2c8e676 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-hcmd-check.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-hcmd-check.c
@@ -101,7 +101,7 @@ int iwl_agn_check_rxon_cmd(struct iwl_priv *priv)
 			    le16_to_cpu(rxon->channel));
 
 	if (error) {
-		IWL_ERROR("Not a valid iwl4965_rxon_assoc_cmd field values\n");
+		IWL_ERR(priv, "Not a valid iwl_rxon_assoc_cmd field values\n");
 		return -1;
 	}
 	return 0;
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
index f382b6f..f032167 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
@@ -1432,7 +1432,8 @@ static int rs_move_siso_to_other(struct iwl_priv *priv,
 				if (!tbl->is_SGI)
 					break;
 				else
-					IWL_ERROR("SGI was set in GF+SISO\n");
+					IWL_ERR(priv,
+						"SGI was set in GF+SISO\n");
 			}
 			search_tbl->is_SGI = !tbl->is_SGI;
 			rs_set_expected_tpt_table(lq_sta, search_tbl);
@@ -1749,13 +1750,13 @@ static void rs_rate_scale_perform(struct iwl_priv *priv,
 		rate_scale_index_msk = rate_mask;
 
 	if (!((1 << index) & rate_scale_index_msk)) {
-		IWL_ERROR("Current Rate is not valid\n");
+		IWL_ERR(priv, "Current Rate is not valid\n");
 		return;
 	}
 
 	/* Get expected throughput table and history window for current rate */
 	if (!tbl->expected_tpt) {
-		IWL_ERROR("tbl->expected_tpt is NULL\n");
+		IWL_ERR(priv, "tbl->expected_tpt is NULL\n");
 		return;
 	}
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 78c9950..05cd04c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -182,7 +182,7 @@ static int iwl_commit_rxon(struct iwl_priv *priv)
 
 	ret = iwl_agn_check_rxon_cmd(priv);
 	if (ret) {
-		IWL_ERROR("Invalid RXON configuration.  Not committing.\n");
+		IWL_ERR(priv, "Invalid RXON configuration.  Not committing.\n");
 		return -EINVAL;
 	}
 
@@ -192,7 +192,7 @@ static int iwl_commit_rxon(struct iwl_priv *priv)
 	if (!iwl_full_rxon_required(priv)) {
 		ret = iwl_send_rxon_assoc(priv);
 		if (ret) {
-			IWL_ERROR("Error setting RXON_ASSOC (%d)\n", ret);
+			IWL_ERR(priv, "Error setting RXON_ASSOC (%d)\n", ret);
 			return ret;
 		}
 
@@ -219,7 +219,7 @@ static int iwl_commit_rxon(struct iwl_priv *priv)
 		 * active_rxon back to what it was previously */
 		if (ret) {
 			active_rxon->filter_flags |= RXON_FILTER_ASSOC_MSK;
-			IWL_ERROR("Error clearing ASSOC_MSK (%d)\n", ret);
+			IWL_ERR(priv, "Error clearing ASSOC_MSK (%d)\n", ret);
 			return ret;
 		}
 	}
@@ -243,7 +243,7 @@ static int iwl_commit_rxon(struct iwl_priv *priv)
 		ret = iwl_send_cmd_pdu(priv, REPLY_RXON,
 			      sizeof(struct iwl_rxon_cmd), &priv->staging_rxon);
 		if (ret) {
-			IWL_ERROR("Error setting new RXON (%d)\n", ret);
+			IWL_ERR(priv, "Error setting new RXON (%d)\n", ret);
 			return ret;
 		}
 		memcpy(active_rxon, &priv->staging_rxon, sizeof(*active_rxon));
@@ -257,7 +257,7 @@ static int iwl_commit_rxon(struct iwl_priv *priv)
 	/* Add the broadcast address so we can send broadcast frames */
 	if (iwl_rxon_add_station(priv, iwl_bcast_addr, 0) ==
 						IWL_INVALID_STATION) {
-		IWL_ERROR("Error adding BROADCAST address for transmit.\n");
+		IWL_ERR(priv, "Error adding BROADCAST address for transmit.\n");
 		return -EIO;
 	}
 
@@ -268,13 +268,15 @@ static int iwl_commit_rxon(struct iwl_priv *priv)
 			ret = iwl_rxon_add_station(priv,
 					   priv->active_rxon.bssid_addr, 1);
 			if (ret == IWL_INVALID_STATION) {
-				IWL_ERROR("Error adding AP address for TX.\n");
+				IWL_ERR(priv,
+					"Error adding AP address for TX.\n");
 				return -EIO;
 			}
 			priv->assoc_station_added = 1;
 			if (priv->default_wep_key &&
 			    iwl_send_static_wepkey_cmd(priv, 0))
-				IWL_ERROR("Could not send WEP static key.\n");
+				IWL_ERR(priv,
+					"Could not send WEP static key.\n");
 		}
 
 		/* Apply the new configuration
@@ -283,7 +285,7 @@ static int iwl_commit_rxon(struct iwl_priv *priv)
 		ret = iwl_send_cmd_pdu(priv, REPLY_RXON,
 			      sizeof(struct iwl_rxon_cmd), &priv->staging_rxon);
 		if (ret) {
-			IWL_ERROR("Error setting new RXON (%d)\n", ret);
+			IWL_ERR(priv, "Error setting new RXON (%d)\n", ret);
 			return ret;
 		}
 		memcpy(active_rxon, &priv->staging_rxon, sizeof(*active_rxon));
@@ -295,7 +297,7 @@ static int iwl_commit_rxon(struct iwl_priv *priv)
 	 * send a new TXPOWER command or we won't be able to Tx any frames */
 	ret = iwl_set_tx_power(priv, priv->tx_power_user_lmt, true);
 	if (ret) {
-		IWL_ERROR("Error sending TX power (%d)\n", ret);
+		IWL_ERR(priv, "Error sending TX power (%d)\n", ret);
 		return ret;
 	}
 
@@ -351,7 +353,7 @@ static struct iwl_frame *iwl_get_free_frame(struct iwl_priv *priv)
 	if (list_empty(&priv->free_frames)) {
 		frame = kzalloc(sizeof(*frame), GFP_KERNEL);
 		if (!frame) {
-			IWL_ERROR("Could not allocate frame!\n");
+			IWL_ERR(priv, "Could not allocate frame!\n");
 			return NULL;
 		}
 
@@ -453,7 +455,7 @@ static int iwl_send_beacon_cmd(struct iwl_priv *priv)
 	frame = iwl_get_free_frame(priv);
 
 	if (!frame) {
-		IWL_ERROR("Could not obtain free frame buffer for beacon "
+		IWL_ERR(priv, "Could not obtain free frame buffer for beacon "
 			  "command.\n");
 		return -ENOMEM;
 	}
@@ -687,7 +689,7 @@ static void iwl_connection_init_rx_config(struct iwl_priv *priv, int mode)
 		    RXON_FILTER_CTL2HOST_MSK | RXON_FILTER_ACCEPT_GRP_MSK;
 		break;
 	default:
-		IWL_ERROR("Unsupported interface type %d\n", mode);
+		IWL_ERR(priv, "Unsupported interface type %d\n", mode);
 		break;
 	}
 
@@ -764,7 +766,7 @@ static void iwl_set_rate(struct iwl_priv *priv)
 
 	hw = iwl_get_hw_mode(priv, priv->band);
 	if (!hw) {
-		IWL_ERROR("Failed to set rate: unable to get hw mode\n");
+		IWL_ERR(priv, "Failed to set rate: unable to get hw mode\n");
 		return;
 	}
 
@@ -850,7 +852,7 @@ static void iwl_rx_reply_error(struct iwl_priv *priv,
 {
 	struct iwl_rx_packet *pkt = (struct iwl_rx_packet *)rxb->skb->data;
 
-	IWL_ERROR("Error Reply type 0x%08X cmd %s (0x%02X) "
+	IWL_ERR(priv, "Error Reply type 0x%08X cmd %s (0x%02X) "
 		"seq 0x%04X ser 0x%08X\n",
 		le32_to_cpu(pkt->u.err_resp.error_type),
 		get_cmd_string(pkt->u.err_resp.cmd_id),
@@ -903,7 +905,7 @@ static void iwl_bg_beacon_update(struct work_struct *work)
 	beacon = ieee80211_beacon_get(priv->hw, priv->vif);
 
 	if (!beacon) {
-		IWL_ERROR("update beacon failed\n");
+		IWL_ERR(priv, "update beacon failed\n");
 		return;
 	}
 
@@ -1361,7 +1363,7 @@ static void iwl_irq_tasklet(struct iwl_priv *priv)
 
 	/* Now service all interrupt bits discovered above. */
 	if (inta & CSR_INT_BIT_HW_ERR) {
-		IWL_ERROR("Microcode HW error detected.  Restarting.\n");
+		IWL_ERR(priv, "Microcode HW error detected.  Restarting.\n");
 
 		/* Tell the device to stop sending interrupts */
 		iwl_disable_interrupts(priv);
@@ -1415,14 +1417,14 @@ static void iwl_irq_tasklet(struct iwl_priv *priv)
 
 	/* Chip got too hot and stopped itself */
 	if (inta & CSR_INT_BIT_CT_KILL) {
-		IWL_ERROR("Microcode CT kill error detected.\n");
+		IWL_ERR(priv, "Microcode CT kill error detected.\n");
 		handled |= CSR_INT_BIT_CT_KILL;
 	}
 
 	/* Error detected by uCode */
 	if (inta & CSR_INT_BIT_SW_ERR) {
-		IWL_ERROR("Microcode SW error detected.  Restarting 0x%X.\n",
-			  inta);
+		IWL_ERR(priv, "Microcode SW error detected. "
+			" Restarting 0x%X.\n", inta);
 		iwl_irq_handle_error(priv);
 		handled |= CSR_INT_BIT_SW_ERR;
 	}
@@ -1458,7 +1460,7 @@ static void iwl_irq_tasklet(struct iwl_priv *priv)
 	}
 
 	if (inta & ~handled)
-		IWL_ERROR("Unhandled INTA bits 0x%08x\n", inta & ~handled);
+		IWL_ERR(priv, "Unhandled INTA bits 0x%08x\n", inta & ~handled);
 
 	if (inta & ~CSR_INI_SET_MASK) {
 		IWL_WARN(priv, "Disabled INTA bits 0x%08x were pending\n",
@@ -1588,7 +1590,7 @@ static int iwl_read_ucode(struct iwl_priv *priv)
 		sprintf(buf, "%s%d%s", name_pre, index, ".ucode");
 		ret = request_firmware(&ucode_raw, buf, &priv->pci_dev->dev);
 		if (ret < 0) {
-			IWL_ERROR("%s firmware file req failed: Reason %d\n",
+			IWL_ERR(priv, "%s firmware file req failed: %d\n",
 				  buf, ret);
 			if (ret == -ENOENT)
 				continue;
@@ -1596,8 +1598,11 @@ static int iwl_read_ucode(struct iwl_priv *priv)
 				goto error;
 		} else {
 			if (index < api_max)
-				IWL_ERROR("Loaded firmware %s, which is deprecated. Please use API v%u instead.\n",
+				IWL_ERR(priv, "Loaded firmware %s, "
+					"which is deprecated. "
+					"Please use API v%u instead.\n",
 					  buf, api_max);
+
 			IWL_DEBUG_INFO("Got firmware '%s' file (%zd bytes) from disk\n",
 				       buf, ucode_raw->size);
 			break;
@@ -1609,7 +1614,7 @@ static int iwl_read_ucode(struct iwl_priv *priv)
 
 	/* Make sure that we got at least our header! */
 	if (ucode_raw->size < sizeof(*ucode)) {
-		IWL_ERROR("File size way too small!\n");
+		IWL_ERR(priv, "File size way too small!\n");
 		ret = -EINVAL;
 		goto err_release;
 	}
@@ -1630,7 +1635,7 @@ static int iwl_read_ucode(struct iwl_priv *priv)
 	 * on the API version read from firware header from here on forward */
 
 	if (api_ver < api_min || api_ver > api_max) {
-		IWL_ERROR("Driver unable to support your firmware API. "
+		IWL_ERR(priv, "Driver unable to support your firmware API. "
 			  "Driver supports v%u, firmware is v%u.\n",
 			  api_max, api_ver);
 		priv->ucode_ver = 0;
@@ -1791,7 +1796,7 @@ static int iwl_read_ucode(struct iwl_priv *priv)
 	return 0;
 
  err_pci_alloc:
-	IWL_ERROR("failed to allocate pci memory\n");
+	IWL_ERR(priv, "failed to allocate pci memory\n");
 	ret = -ENOMEM;
 	iwl_dealloc_ucode_pci(priv);
 
@@ -2029,7 +2034,7 @@ static int __iwl_up(struct iwl_priv *priv)
 	}
 
 	if (!priv->ucode_data_backup.v_addr || !priv->ucode_data.v_addr) {
-		IWL_ERROR("ucode not available for device bringup\n");
+		IWL_ERR(priv, "ucode not available for device bringup\n");
 		return -EIO;
 	}
 
@@ -2050,7 +2055,7 @@ static int __iwl_up(struct iwl_priv *priv)
 
 	ret = iwl_hw_nic_init(priv);
 	if (ret) {
-		IWL_ERROR("Unable to init nic\n");
+		IWL_ERR(priv, "Unable to init nic\n");
 		return ret;
 	}
 
@@ -2083,7 +2088,8 @@ static int __iwl_up(struct iwl_priv *priv)
 		ret = priv->cfg->ops->lib->load_ucode(priv);
 
 		if (ret) {
-			IWL_ERROR("Unable to set up bootstrap uCode: %d\n", ret);
+			IWL_ERR(priv, "Unable to set up bootstrap uCode: %d\n",
+				ret);
 			continue;
 		}
 
@@ -2104,7 +2110,7 @@ static int __iwl_up(struct iwl_priv *priv)
 
 	/* tried to restart and config the device for as long as our
 	 * patience could withstand */
-	IWL_ERROR("Unable to initialize device after %d attempts.\n", i);
+	IWL_ERR(priv, "Unable to initialize device after %d attempts.\n", i);
 	return -EIO;
 }
 
@@ -2245,7 +2251,7 @@ static void iwl_post_associate(struct iwl_priv *priv)
 	unsigned long flags;
 
 	if (priv->iw_mode == NL80211_IFTYPE_AP) {
-		IWL_ERROR("%s Should not be called in AP mode\n", __func__);
+		IWL_ERR(priv, "%s Should not be called in AP mode\n", __func__);
 		return;
 	}
 
@@ -2319,7 +2325,7 @@ static void iwl_post_associate(struct iwl_priv *priv)
 		break;
 
 	default:
-		IWL_ERROR("%s Should not be called in %d mode\n",
+		IWL_ERR(priv, "%s Should not be called in %d mode\n",
 			  __func__, priv->iw_mode);
 		break;
 	}
@@ -2360,7 +2366,7 @@ static int iwl_mac_start(struct ieee80211_hw *hw)
 	IWL_DEBUG_MAC80211("enter\n");
 
 	if (pci_enable_device(priv->pci_dev)) {
-		IWL_ERROR("Fail to pci_enable_device\n");
+		IWL_ERR(priv, "Fail to pci_enable_device\n");
 		return -ENODEV;
 	}
 	pci_restore_state(priv->pci_dev);
@@ -2376,7 +2382,7 @@ static int iwl_mac_start(struct ieee80211_hw *hw)
 	ret = request_irq(priv->pci_dev->irq, iwl_isr, IRQF_SHARED,
 			  DRV_NAME, priv);
 	if (ret) {
-		IWL_ERROR("Error allocating IRQ %d\n", priv->pci_dev->irq);
+		IWL_ERR(priv, "Error allocating IRQ %d\n", priv->pci_dev->irq);
 		goto out_disable_msi;
 	}
 
@@ -2390,7 +2396,7 @@ static int iwl_mac_start(struct ieee80211_hw *hw)
 	if (!priv->ucode_code.len) {
 		ret = iwl_read_ucode(priv);
 		if (ret) {
-			IWL_ERROR("Could not read microcode: %d\n", ret);
+			IWL_ERR(priv, "Could not read microcode: %d\n", ret);
 			mutex_unlock(&priv->mutex);
 			goto out_release_irq;
 		}
@@ -2420,7 +2426,7 @@ static int iwl_mac_start(struct ieee80211_hw *hw)
 			UCODE_READY_TIMEOUT);
 	if (!ret) {
 		if (!test_bit(STATUS_READY, &priv->status)) {
-			IWL_ERROR("START_ALIVE timeout after %dms.\n",
+			IWL_ERR(priv, "START_ALIVE timeout after %dms.\n",
 				jiffies_to_msecs(UCODE_READY_TIMEOUT));
 			ret = -ETIMEDOUT;
 			goto out_release_irq;
@@ -2580,7 +2586,7 @@ static int iwl_mac_config(struct ieee80211_hw *hw, u32 changed)
 
 	if (priv->iw_mode == NL80211_IFTYPE_ADHOC &&
 	    !is_channel_ibss(ch_info)) {
-		IWL_ERROR("channel %d in band %d not IBSS channel\n",
+		IWL_ERR(priv, "channel %d in band %d not IBSS channel\n",
 			conf->channel->hw_value, conf->channel->band);
 		ret = -EINVAL;
 		goto out;
@@ -3867,7 +3873,7 @@ static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	/* Read the EEPROM */
 	err = iwl_eeprom_init(priv);
 	if (err) {
-		IWL_ERROR("Unable to init EEPROM\n");
+		IWL_ERR(priv, "Unable to init EEPROM\n");
 		goto out_iounmap;
 	}
 	err = iwl_eeprom_check_version(priv);
@@ -3883,7 +3889,7 @@ static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	 * 5. Setup HW constants
 	 ************************/
 	if (iwl_set_hw_params(priv)) {
-		IWL_ERROR("failed to set hw parameters\n");
+		IWL_ERR(priv, "failed to set hw parameters\n");
 		goto out_free_eeprom;
 	}
 
@@ -3915,7 +3921,7 @@ static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	err = sysfs_create_group(&pdev->dev.kobj, &iwl_attribute_group);
 	if (err) {
-		IWL_ERROR("failed to create sysfs device attributes\n");
+		IWL_ERR(priv, "failed to create sysfs device attributes\n");
 		goto out_uninit_drv;
 	}
 
@@ -3939,11 +3945,11 @@ static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	err = iwl_dbgfs_register(priv, DRV_NAME);
 	if (err)
-		IWL_ERROR("failed to create debugfs files\n");
+		IWL_ERR(priv, "failed to create debugfs files\n");
 
 	err = iwl_rfkill_init(priv);
 	if (err)
-		IWL_ERROR("Unable to initialize RFKILL system. "
+		IWL_ERR(priv, "Unable to initialize RFKILL system. "
 				  "Ignoring error: %d\n", err);
 	iwl_power_initialize(priv);
 	return 0;
diff --git a/drivers/net/wireless/iwlwifi/iwl-calib.c b/drivers/net/wireless/iwlwifi/iwl-calib.c
index f836ecc..d2aabbc 100644
--- a/drivers/net/wireless/iwlwifi/iwl-calib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-calib.c
@@ -102,7 +102,7 @@ int iwl_send_calib_results(struct iwl_priv *priv)
 
 	return 0;
 err:
-	IWL_ERROR("Error %d iteration %d\n", ret, i);
+	IWL_ERR(priv, "Error %d iteration %d\n", ret, i);
 	return ret;
 }
 EXPORT_SYMBOL(iwl_send_calib_results);
@@ -483,7 +483,7 @@ static int iwl_sensitivity_write(struct iwl_priv *priv)
 
 	ret = iwl_send_cmd(priv, &cmd_out);
 	if (ret)
-		IWL_ERROR("SENSITIVITY_CMD failed\n");
+		IWL_ERR(priv, "SENSITIVITY_CMD failed\n");
 
 	return ret;
 }
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index fcfb4ba..d3bcbba 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -211,7 +211,7 @@ int iwl_hw_nic_init(struct iwl_priv *priv)
 	if (!rxq->bd) {
 		ret = iwl_rx_queue_alloc(priv);
 		if (ret) {
-			IWL_ERROR("Unable to initialize Rx queue\n");
+			IWL_ERR(priv, "Unable to initialize Rx queue\n");
 			return -ENOMEM;
 		}
 	} else
@@ -679,7 +679,7 @@ static int iwl_get_idle_rx_chain_count(struct iwl_priv *priv, int active_cnt)
 		break;
 	case WLAN_HT_CAP_SM_PS_INVALID:
 	default:
-		IWL_ERROR("invalid mimo ps mode %d\n",
+		IWL_ERR(priv, "invalid mimo ps mode %d\n",
 			   priv->current_ht_config.sm_ps);
 		WARN_ON(1);
 		idle_cnt = -1;
@@ -831,7 +831,7 @@ int iwl_setup_mac(struct iwl_priv *priv)
 
 	ret = ieee80211_register_hw(priv->hw);
 	if (ret) {
-		IWL_ERROR("Failed to register hw (error %d)\n", ret);
+		IWL_ERR(priv, "Failed to register hw (error %d)\n", ret);
 		return ret;
 	}
 	priv->mac80211_registered = 1;
@@ -903,13 +903,13 @@ int iwl_init_drv(struct iwl_priv *priv)
 
 	ret = iwl_init_channel_map(priv);
 	if (ret) {
-		IWL_ERROR("initializing regulatory failed: %d\n", ret);
+		IWL_ERR(priv, "initializing regulatory failed: %d\n", ret);
 		goto err;
 	}
 
 	ret = iwlcore_init_geos(priv);
 	if (ret) {
-		IWL_ERROR("initializing geos failed: %d\n", ret);
+		IWL_ERR(priv, "initializing geos failed: %d\n", ret);
 		goto err_free_channel_map;
 	}
 
@@ -1061,7 +1061,7 @@ static int iwl_verify_inst_full(struct iwl_priv *priv, __le32 *image,
 		 * if IWL_DL_IO is set */
 		val = _iwl_read_direct32(priv, HBUS_TARG_MEM_RDAT);
 		if (val != le32_to_cpu(*image)) {
-			IWL_ERROR("uCode INST section is invalid at "
+			IWL_ERR(priv, "uCode INST section is invalid at "
 				  "offset 0x%x, is 0x%x, s/b 0x%x\n",
 				  save_len - len, val, le32_to_cpu(*image));
 			ret = -EIO;
@@ -1117,7 +1117,7 @@ int iwl_verify_ucode(struct iwl_priv *priv)
 		return 0;
 	}
 
-	IWL_ERROR("NO VALID UCODE IMAGE IN INSTRUCTION SRAM!!\n");
+	IWL_ERR(priv, "NO VALID UCODE IMAGE IN INSTRUCTION SRAM!!\n");
 
 	/* Since nothing seems to match, show first several data entries in
 	 * instruction SRAM, so maybe visual inspection will give a clue.
@@ -1189,7 +1189,7 @@ void iwl_dump_nic_error_log(struct iwl_priv *priv)
 		base = le32_to_cpu(priv->card_alive.error_event_table_ptr);
 
 	if (!priv->cfg->ops->lib->is_valid_rtc_data_addr(base)) {
-		IWL_ERROR("Not valid error log pointer 0x%08X\n", base);
+		IWL_ERR(priv, "Not valid error log pointer 0x%08X\n", base);
 		return;
 	}
 
@@ -1202,8 +1202,9 @@ void iwl_dump_nic_error_log(struct iwl_priv *priv)
 	count = iwl_read_targ_mem(priv, base);
 
 	if (ERROR_START_OFFSET <= count * ERROR_ELEM_SIZE) {
-		IWL_ERROR("Start IWL Error Log Dump:\n");
-		IWL_ERROR("Status: 0x%08lX, count: %d\n", priv->status, count);
+		IWL_ERR(priv, "Start IWL Error Log Dump:\n");
+		IWL_ERR(priv, "Status: 0x%08lX, count: %d\n",
+			priv->status, count);
 	}
 
 	desc = iwl_read_targ_mem(priv, base + 1 * sizeof(u32));
@@ -1216,12 +1217,12 @@ void iwl_dump_nic_error_log(struct iwl_priv *priv)
 	line = iwl_read_targ_mem(priv, base + 9 * sizeof(u32));
 	time = iwl_read_targ_mem(priv, base + 11 * sizeof(u32));
 
-	IWL_ERROR("Desc                               Time       "
+	IWL_ERR(priv, "Desc                               Time       "
 		"data1      data2      line\n");
-	IWL_ERROR("%-28s (#%02d) %010u 0x%08X 0x%08X %u\n",
+	IWL_ERR(priv, "%-28s (#%02d) %010u 0x%08X 0x%08X %u\n",
 		desc_lookup(desc), desc, time, data1, data2, line);
-	IWL_ERROR("blink1  blink2  ilink1  ilink2\n");
-	IWL_ERROR("0x%05X 0x%05X 0x%05X 0x%05X\n", blink1, blink2,
+	IWL_ERR(priv, "blink1  blink2  ilink1  ilink2\n");
+	IWL_ERR(priv, "0x%05X 0x%05X 0x%05X 0x%05X\n", blink1, blink2,
 		ilink1, ilink2);
 
 	iwl_release_nic_access(priv);
@@ -1267,11 +1268,11 @@ static void iwl_print_event_log(struct iwl_priv *priv, u32 start_idx,
 		ptr += sizeof(u32);
 		if (mode == 0) {
 			/* data, ev */
-			IWL_ERROR("EVT_LOG:0x%08x:%04u\n", time, ev);
+			IWL_ERR(priv, "EVT_LOG:0x%08x:%04u\n", time, ev);
 		} else {
 			data = iwl_read_targ_mem(priv, ptr);
 			ptr += sizeof(u32);
-			IWL_ERROR("EVT_LOGT:%010u:0x%08x:%04u\n",
+			IWL_ERR(priv, "EVT_LOGT:%010u:0x%08x:%04u\n",
 					time, data, ev);
 		}
 	}
@@ -1293,7 +1294,7 @@ void iwl_dump_nic_event_log(struct iwl_priv *priv)
 		base = le32_to_cpu(priv->card_alive.log_event_table_ptr);
 
 	if (!priv->cfg->ops->lib->is_valid_rtc_data_addr(base)) {
-		IWL_ERROR("Invalid event log pointer 0x%08X\n", base);
+		IWL_ERR(priv, "Invalid event log pointer 0x%08X\n", base);
 		return;
 	}
 
@@ -1313,12 +1314,12 @@ void iwl_dump_nic_event_log(struct iwl_priv *priv)
 
 	/* bail out if nothing in log */
 	if (size == 0) {
-		IWL_ERROR("Start IWL Event Log Dump: nothing in log\n");
+		IWL_ERR(priv, "Start IWL Event Log Dump: nothing in log\n");
 		iwl_release_nic_access(priv);
 		return;
 	}
 
-	IWL_ERROR("Start IWL Event Log Dump: display count %d, wraps %d\n",
+	IWL_ERR(priv, "Start IWL Event Log Dump: display count %d, wraps %d\n",
 			size, num_wraps);
 
 	/* if uCode has wrapped back to top of log, start at the oldest entry,
@@ -1350,7 +1351,7 @@ void iwl_rf_kill_ct_config(struct iwl_priv *priv)
 	ret = iwl_send_cmd_pdu(priv, REPLY_CT_KILL_CONFIG_CMD,
 			       sizeof(cmd), &cmd);
 	if (ret)
-		IWL_ERROR("REPLY_CT_KILL_CONFIG_CMD failed\n");
+		IWL_ERR(priv, "REPLY_CT_KILL_CONFIG_CMD failed\n");
 	else
 		IWL_DEBUG_INFO("REPLY_CT_KILL_CONFIG_CMD succeeded, "
 			"critical temperature is %d\n",
diff --git a/drivers/net/wireless/iwlwifi/iwl-debug.h b/drivers/net/wireless/iwlwifi/iwl-debug.h
index 4774c98..798f946 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debug.h
+++ b/drivers/net/wireless/iwlwifi/iwl-debug.h
@@ -31,7 +31,6 @@
 
 struct iwl_priv;
 
-#define IWL_ERROR(f, a...) dev_err(&(priv->pci_dev->dev), f, ## a)
 #define IWL_ERR(p, f, a...) dev_err(&((p)->pci_dev->dev), f, ## a)
 #define IWL_WARN(p, f, a...) dev_warn(&((p)->pci_dev->dev), f, ## a)
 #define IWL_INFO(p, f, a...) dev_info(&((p)->pci_dev->dev), f, ## a)
diff --git a/drivers/net/wireless/iwlwifi/iwl-debugfs.c b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
index df5906f..ecb3900 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debugfs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
@@ -300,14 +300,14 @@ static ssize_t iwl_dbgfs_eeprom_read(struct file *file,
 	buf_size = 4 * eeprom_len + 256;
 
 	if (eeprom_len % 16) {
-		IWL_ERROR("EEPROM size is not multiple of 16.\n");
+		IWL_ERR(priv, "EEPROM size is not multiple of 16.\n");
 		return -ENODATA;
 	}
 
 	/* 4 characters for byte 0xYY */
 	buf = kzalloc(buf_size, GFP_KERNEL);
 	if (!buf) {
-		IWL_ERROR("Can not allocate Buffer\n");
+		IWL_ERR(priv, "Can not allocate Buffer\n");
 		return -ENOMEM;
 	}
 
@@ -364,7 +364,7 @@ static ssize_t iwl_dbgfs_channels_read(struct file *file, char __user *user_buf,
 
 	buf = kzalloc(bufsz, GFP_KERNEL);
 	if (!buf) {
-		IWL_ERROR("Can not allocate Buffer\n");
+		IWL_ERR(priv, "Can not allocate Buffer\n");
 		return -ENOMEM;
 	}
 
@@ -468,7 +468,7 @@ int iwl_dbgfs_register(struct iwl_priv *priv, const char *name)
 	return 0;
 
 err:
-	IWL_ERROR("Can't open the debugfs directory\n");
+	IWL_ERR(priv, "Can't open the debugfs directory\n");
 	iwl_dbgfs_unregister(priv);
 	return ret;
 }
diff --git a/drivers/net/wireless/iwlwifi/iwl-eeprom.c b/drivers/net/wireless/iwlwifi/iwl-eeprom.c
index ce2f473..59abac0 100644
--- a/drivers/net/wireless/iwlwifi/iwl-eeprom.c
+++ b/drivers/net/wireless/iwlwifi/iwl-eeprom.c
@@ -145,7 +145,7 @@ int iwlcore_eeprom_verify_signature(struct iwl_priv *priv)
 {
 	u32 gp = iwl_read32(priv, CSR_EEPROM_GP);
 	if ((gp & CSR_EEPROM_GP_VALID_MSK) == CSR_EEPROM_GP_BAD_SIGNATURE) {
-		IWL_ERROR("EEPROM not found, EEPROM_GP=0x%08x\n", gp);
+		IWL_ERR(priv, "EEPROM not found, EEPROM_GP=0x%08x\n", gp);
 		return -ENOENT;
 	}
 	return 0;
@@ -223,7 +223,7 @@ int iwl_eeprom_init(struct iwl_priv *priv)
 
 	ret = priv->cfg->ops->lib->eeprom_ops.verify_signature(priv);
 	if (ret < 0) {
-		IWL_ERROR("EEPROM not found, EEPROM_GP=0x%08x\n", gp);
+		IWL_ERR(priv, "EEPROM not found, EEPROM_GP=0x%08x\n", gp);
 		ret = -ENOENT;
 		goto err;
 	}
@@ -231,7 +231,7 @@ int iwl_eeprom_init(struct iwl_priv *priv)
 	/* Make sure driver (instead of uCode) is allowed to read EEPROM */
 	ret = priv->cfg->ops->lib->eeprom_ops.acquire_semaphore(priv);
 	if (ret < 0) {
-		IWL_ERROR("Failed to acquire EEPROM semaphore.\n");
+		IWL_ERR(priv, "Failed to acquire EEPROM semaphore.\n");
 		ret = -ENOENT;
 		goto err;
 	}
@@ -247,7 +247,7 @@ int iwl_eeprom_init(struct iwl_priv *priv)
 					  CSR_EEPROM_REG_READ_VALID_MSK,
 					  IWL_EEPROM_ACCESS_TIMEOUT);
 		if (ret < 0) {
-			IWL_ERROR("Time out reading EEPROM[%d]\n", addr);
+			IWL_ERR(priv, "Time out reading EEPROM[%d]\n", addr);
 			goto done;
 		}
 		r = _iwl_read_direct32(priv, CSR_EEPROM_REG);
@@ -285,7 +285,7 @@ int iwl_eeprom_check_version(struct iwl_priv *priv)
 
 	return 0;
 err:
-	IWL_ERROR("Unsupported EEPROM VER=0x%x < 0x%x CALIB=0x%x < 0x%x\n",
+	IWL_ERR(priv, "Unsupported EEPROM VER=0x%x < 0x%x CALIB=0x%x < 0x%x\n",
 		  eeprom_ver, priv->cfg->eeprom_ver,
 		  calib_ver,  priv->cfg->eeprom_calib_ver);
 	return -EINVAL;
@@ -450,7 +450,7 @@ int iwl_init_channel_map(struct iwl_priv *priv)
 	priv->channel_info = kzalloc(sizeof(struct iwl_channel_info) *
 				     priv->channel_count, GFP_KERNEL);
 	if (!priv->channel_info) {
-		IWL_ERROR("Could not allocate channel_info\n");
+		IWL_ERR(priv, "Could not allocate channel_info\n");
 		priv->channel_count = 0;
 		return -ENOMEM;
 	}
diff --git a/drivers/net/wireless/iwlwifi/iwl-hcmd.c b/drivers/net/wireless/iwlwifi/iwl-hcmd.c
index 01a2169..0accf88 100644
--- a/drivers/net/wireless/iwlwifi/iwl-hcmd.c
+++ b/drivers/net/wireless/iwlwifi/iwl-hcmd.c
@@ -108,14 +108,14 @@ static int iwl_generic_cmd_callback(struct iwl_priv *priv,
 	struct iwl_rx_packet *pkt = NULL;
 
 	if (!skb) {
-		IWL_ERROR("Error: Response NULL in %s.\n",
+		IWL_ERR(priv, "Error: Response NULL in %s.\n",
 				get_cmd_string(cmd->hdr.cmd));
 		return 1;
 	}
 
 	pkt = (struct iwl_rx_packet *)skb->data;
 	if (pkt->hdr.flags & IWL_CMD_FAILED_MSK) {
-		IWL_ERROR("Bad return from %s (0x%08X)\n",
+		IWL_ERR(priv, "Bad return from %s (0x%08X)\n",
 			get_cmd_string(cmd->hdr.cmd), pkt->hdr.flags);
 		return 1;
 	}
@@ -155,7 +155,7 @@ static int iwl_send_cmd_async(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
 
 	ret = iwl_enqueue_hcmd(priv, cmd);
 	if (ret < 0) {
-		IWL_ERROR("Error sending %s: enqueue_hcmd failed: %d\n",
+		IWL_ERR(priv, "Error sending %s: enqueue_hcmd failed: %d\n",
 			  get_cmd_string(cmd->id), ret);
 		return ret;
 	}
@@ -173,8 +173,9 @@ int iwl_send_cmd_sync(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
 	BUG_ON(cmd->meta.u.callback != NULL);
 
 	if (test_and_set_bit(STATUS_HCMD_SYNC_ACTIVE, &priv->status)) {
-		IWL_ERROR("Error sending %s: Already sending a host command\n",
-			  get_cmd_string(cmd->id));
+		IWL_ERR(priv,
+			"Error sending %s: Already sending a host command\n",
+			get_cmd_string(cmd->id));
 		ret = -EBUSY;
 		goto out;
 	}
@@ -187,7 +188,7 @@ int iwl_send_cmd_sync(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
 	cmd_idx = iwl_enqueue_hcmd(priv, cmd);
 	if (cmd_idx < 0) {
 		ret = cmd_idx;
-		IWL_ERROR("Error sending %s: enqueue_hcmd failed: %d\n",
+		IWL_ERR(priv, "Error sending %s: enqueue_hcmd failed: %d\n",
 			  get_cmd_string(cmd->id), ret);
 		goto out;
 	}
@@ -197,9 +198,10 @@ int iwl_send_cmd_sync(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
 			HOST_COMPLETE_TIMEOUT);
 	if (!ret) {
 		if (test_bit(STATUS_HCMD_ACTIVE, &priv->status)) {
-			IWL_ERROR("Error sending %s: time out after %dms.\n",
-				  get_cmd_string(cmd->id),
-				  jiffies_to_msecs(HOST_COMPLETE_TIMEOUT));
+			IWL_ERR(priv,
+				"Error sending %s: time out after %dms.\n",
+				get_cmd_string(cmd->id),
+				jiffies_to_msecs(HOST_COMPLETE_TIMEOUT));
 
 			clear_bit(STATUS_HCMD_ACTIVE, &priv->status);
 			ret = -ETIMEDOUT;
@@ -220,7 +222,7 @@ int iwl_send_cmd_sync(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
 		goto fail;
 	}
 	if ((cmd->meta.flags & CMD_WANT_SKB) && !cmd->meta.u.skb) {
-		IWL_ERROR("Error: Response NULL in '%s'\n",
+		IWL_ERR(priv, "Error: Response NULL in '%s'\n",
 			  get_cmd_string(cmd->id));
 		ret = -EIO;
 		goto out;
diff --git a/drivers/net/wireless/iwlwifi/iwl-io.h b/drivers/net/wireless/iwlwifi/iwl-io.h
index 0a92e74..801d5ff 100644
--- a/drivers/net/wireless/iwlwifi/iwl-io.h
+++ b/drivers/net/wireless/iwlwifi/iwl-io.h
@@ -167,7 +167,7 @@ static inline int _iwl_grab_nic_access(struct iwl_priv *priv)
 			   (CSR_GP_CNTRL_REG_FLAG_MAC_CLOCK_READY |
 			    CSR_GP_CNTRL_REG_FLAG_GOING_TO_SLEEP), 50);
 	if (ret < 0) {
-		IWL_ERROR("MAC is in deep sleep!\n");
+		IWL_ERR(priv, "MAC is in deep sleep!\n");
 		return -EIO;
 	}
 
@@ -182,7 +182,7 @@ static inline int __iwl_grab_nic_access(const char *f, u32 l,
 					       struct iwl_priv *priv)
 {
 	if (atomic_read(&priv->restrict_refcnt))
-		IWL_ERROR("Grabbing access while already held %s %d.\n", f, l);
+		IWL_ERR(priv, "Grabbing access while already held %s %d.\n", f, l);
 
 	IWL_DEBUG_IO("grabbing nic access - %s %d\n", f, l);
 	return _iwl_grab_nic_access(priv);
@@ -207,7 +207,7 @@ static inline void __iwl_release_nic_access(const char *f, u32 l,
 					    struct iwl_priv *priv)
 {
 	if (atomic_read(&priv->restrict_refcnt) <= 0)
-		IWL_ERROR("Release unheld nic access at line %s %d.\n", f, l);
+		IWL_ERR(priv, "Release unheld nic access at line %s %d.\n", f, l);
 
 	IWL_DEBUG_IO("releasing nic access - %s %d\n", f, l);
 	_iwl_release_nic_access(priv);
@@ -229,7 +229,7 @@ static inline u32 __iwl_read_direct32(const char *f, u32 l,
 {
 	u32 value = _iwl_read_direct32(priv, reg);
 	if (!atomic_read(&priv->restrict_refcnt))
-		IWL_ERROR("Nic access not held from %s %d\n", f, l);
+		IWL_ERR(priv, "Nic access not held from %s %d\n", f, l);
 	IWL_DEBUG_IO("read_direct32(0x%4X) = 0x%08x - %s %d \n", reg, value,
 		     f, l);
 	return value;
@@ -250,7 +250,7 @@ static void __iwl_write_direct32(const char *f , u32 line,
 				   struct iwl_priv *priv, u32 reg, u32 value)
 {
 	if (!atomic_read(&priv->restrict_refcnt))
-		IWL_ERROR("Nic access not held from %s line %d\n", f, line);
+		IWL_ERR(priv, "Nic access not held from %s line %d\n", f, line);
 	_iwl_write_direct32(priv, reg, value);
 }
 #define iwl_write_direct32(priv, reg, value) \
@@ -308,7 +308,7 @@ static inline u32 __iwl_read_prph(const char *f, u32 line,
 				  struct iwl_priv *priv, u32 reg)
 {
 	if (!atomic_read(&priv->restrict_refcnt))
-		IWL_ERROR("Nic access not held from %s line %d\n", f, line);
+		IWL_ERR(priv, "Nic access not held from %s line %d\n", f, line);
 	return _iwl_read_prph(priv, reg);
 }
 
@@ -331,7 +331,7 @@ static inline void __iwl_write_prph(const char *f, u32 line,
 				    struct iwl_priv *priv, u32 addr, u32 val)
 {
 	if (!atomic_read(&priv->restrict_refcnt))
-		IWL_ERROR("Nic access not held from %s line %d\n", f, line);
+		IWL_ERR(priv, "Nic access not held from %s line %d\n", f, line);
 	_iwl_write_prph(priv, addr, val);
 }
 
@@ -349,7 +349,7 @@ static inline void __iwl_set_bits_prph(const char *f, u32 line,
 				       u32 reg, u32 mask)
 {
 	if (!atomic_read(&priv->restrict_refcnt))
-		IWL_ERROR("Nic access not held from %s line %d\n", f, line);
+		IWL_ERR(priv, "Nic access not held from %s line %d\n", f, line);
 
 	_iwl_set_bits_prph(priv, reg, mask);
 }
@@ -367,7 +367,7 @@ static inline void __iwl_set_bits_mask_prph(const char *f, u32 line,
 		struct iwl_priv *priv, u32 reg, u32 bits, u32 mask)
 {
 	if (!atomic_read(&priv->restrict_refcnt))
-		IWL_ERROR("Nic access not held from %s line %d\n", f, line);
+		IWL_ERR(priv, "Nic access not held from %s line %d\n", f, line);
 	_iwl_set_bits_mask_prph(priv, reg, bits, mask);
 }
 #define iwl_set_bits_mask_prph(priv, reg, bits, mask) \
diff --git a/drivers/net/wireless/iwlwifi/iwl-led.c b/drivers/net/wireless/iwlwifi/iwl-led.c
index 11eccd7..98be90f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-led.c
+++ b/drivers/net/wireless/iwlwifi/iwl-led.c
@@ -254,7 +254,7 @@ static int iwl_leds_register_led(struct iwl_priv *priv, struct iwl_led *led,
 
 	ret = led_classdev_register(device, &led->led_dev);
 	if (ret) {
-		IWL_ERROR("Error: failed to register led handler.\n");
+		IWL_ERR(priv, "Error: failed to register led handler.\n");
 		return ret;
 	}
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-rfkill.c b/drivers/net/wireless/iwlwifi/iwl-rfkill.c
index cece1c5..98df755 100644
--- a/drivers/net/wireless/iwlwifi/iwl-rfkill.c
+++ b/drivers/net/wireless/iwlwifi/iwl-rfkill.c
@@ -82,7 +82,7 @@ int iwl_rfkill_init(struct iwl_priv *priv)
 	IWL_DEBUG_RF_KILL("Initializing RFKILL.\n");
 	priv->rfkill = rfkill_allocate(device, RFKILL_TYPE_WLAN);
 	if (!priv->rfkill) {
-		IWL_ERROR("Unable to allocate RFKILL device.\n");
+		IWL_ERR(priv, "Unable to allocate RFKILL device.\n");
 		ret = -ENOMEM;
 		goto error;
 	}
@@ -98,7 +98,7 @@ int iwl_rfkill_init(struct iwl_priv *priv)
 
 	ret = rfkill_register(priv->rfkill);
 	if (ret) {
-		IWL_ERROR("Unable to register RFKILL: %d\n", ret);
+		IWL_ERR(priv, "Unable to register RFKILL: %d\n", ret);
 		goto free_rfkill;
 	}
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-rx.c b/drivers/net/wireless/iwlwifi/iwl-rx.c
index 18c630d..bc3febe 100644
--- a/drivers/net/wireless/iwlwifi/iwl-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-rx.c
@@ -894,7 +894,7 @@ static void iwl_pass_packet_to_mac80211(struct iwl_priv *priv,
 		rx_start = (struct iwl_rx_phy_res *)&priv->last_phy_res[1];
 
 	if (!rx_start) {
-		IWL_ERROR("MPDU frame without a PHY data\n");
+		IWL_ERR(priv, "MPDU frame without a PHY data\n");
 		return;
 	}
 	if (include_phy) {
@@ -1020,7 +1020,7 @@ void iwl_rx_reply_rx(struct iwl_priv *priv,
 	}
 
 	if (!rx_start) {
-		IWL_ERROR("MPDU frame without a PHY data\n");
+		IWL_ERR(priv, "MPDU frame without a PHY data\n");
 		return;
 	}
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-spectrum.c b/drivers/net/wireless/iwlwifi/iwl-spectrum.c
index 836c3c8..f4ed497 100644
--- a/drivers/net/wireless/iwlwifi/iwl-spectrum.c
+++ b/drivers/net/wireless/iwlwifi/iwl-spectrum.c
@@ -146,7 +146,7 @@ static int iwl_get_measurement(struct iwl_priv *priv,
 
 	res = (struct iwl_rx_packet *)cmd.meta.u.skb->data;
 	if (res->hdr.flags & IWL_CMD_FAILED_MSK) {
-		IWL_ERROR("Bad return from REPLY_RX_ON_ASSOC command\n");
+		IWL_ERR(priv, "Bad return from REPLY_RX_ON_ASSOC command\n");
 		rc = -EIO;
 	}
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.c b/drivers/net/wireless/iwlwifi/iwl-sta.c
index d7d0387..ab96c72 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-sta.c
@@ -89,7 +89,8 @@ static void iwl_sta_ucode_activate(struct iwl_priv *priv, u8 sta_id)
 	spin_lock_irqsave(&priv->sta_lock, flags);
 
 	if (!(priv->stations[sta_id].used & IWL_STA_DRIVER_ACTIVE))
-		IWL_ERROR("ACTIVATE a non DRIVER active station %d\n", sta_id);
+		IWL_ERR(priv, "ACTIVATE a non DRIVER active station %d\n",
+			sta_id);
 
 	priv->stations[sta_id].used |= IWL_STA_UCODE_ACTIVE;
 	IWL_DEBUG_ASSOC("Added STA to Ucode: %s\n",
@@ -107,13 +108,13 @@ static int iwl_add_sta_callback(struct iwl_priv *priv,
 	u8 sta_id = addsta->sta.sta_id;
 
 	if (!skb) {
-		IWL_ERROR("Error: Response NULL in REPLY_ADD_STA.\n");
+		IWL_ERR(priv, "Error: Response NULL in REPLY_ADD_STA.\n");
 		return 1;
 	}
 
 	res = (struct iwl_rx_packet *)skb->data;
 	if (res->hdr.flags & IWL_CMD_FAILED_MSK) {
-		IWL_ERROR("Bad return from REPLY_ADD_STA (0x%08X)\n",
+		IWL_ERR(priv, "Bad return from REPLY_ADD_STA (0x%08X)\n",
 			  res->hdr.flags);
 		return 1;
 	}
@@ -157,7 +158,7 @@ static int iwl_send_add_sta(struct iwl_priv *priv,
 
 	res = (struct iwl_rx_packet *)cmd.meta.u.skb->data;
 	if (res->hdr.flags & IWL_CMD_FAILED_MSK) {
-		IWL_ERROR("Bad return from REPLY_ADD_STA (0x%08X)\n",
+		IWL_ERR(priv, "Bad return from REPLY_ADD_STA (0x%08X)\n",
 			  res->hdr.flags);
 		ret = -EIO;
 	}
@@ -313,7 +314,7 @@ static void iwl_sta_ucode_deactivate(struct iwl_priv *priv, const char *addr)
 
 	/* Ucode must be active and driver must be non active */
 	if (priv->stations[sta_id].used != IWL_STA_UCODE_ACTIVE)
-		IWL_ERROR("removed non active STA %d\n", sta_id);
+		IWL_ERR(priv, "removed non active STA %d\n", sta_id);
 
 	priv->stations[sta_id].used &= ~IWL_STA_UCODE_ACTIVE;
 
@@ -330,13 +331,13 @@ static int iwl_remove_sta_callback(struct iwl_priv *priv,
 	const char *addr = rm_sta->addr;
 
 	if (!skb) {
-		IWL_ERROR("Error: Response NULL in REPLY_REMOVE_STA.\n");
+		IWL_ERR(priv, "Error: Response NULL in REPLY_REMOVE_STA.\n");
 		return 1;
 	}
 
 	res = (struct iwl_rx_packet *)skb->data;
 	if (res->hdr.flags & IWL_CMD_FAILED_MSK) {
-		IWL_ERROR("Bad return from REPLY_REMOVE_STA (0x%08X)\n",
+		IWL_ERR(priv, "Bad return from REPLY_REMOVE_STA (0x%08X)\n",
 		res->hdr.flags);
 		return 1;
 	}
@@ -346,7 +347,7 @@ static int iwl_remove_sta_callback(struct iwl_priv *priv,
 		iwl_sta_ucode_deactivate(priv, addr);
 		break;
 	default:
-		IWL_ERROR("REPLY_REMOVE_STA failed\n");
+		IWL_ERR(priv, "REPLY_REMOVE_STA failed\n");
 		break;
 	}
 
@@ -384,7 +385,7 @@ static int iwl_send_remove_station(struct iwl_priv *priv, const u8 *addr,
 
 	res = (struct iwl_rx_packet *)cmd.meta.u.skb->data;
 	if (res->hdr.flags & IWL_CMD_FAILED_MSK) {
-		IWL_ERROR("Bad return from REPLY_REMOVE_STA (0x%08X)\n",
+		IWL_ERR(priv, "Bad return from REPLY_REMOVE_STA (0x%08X)\n",
 			  res->hdr.flags);
 		ret = -EIO;
 	}
@@ -397,7 +398,7 @@ static int iwl_send_remove_station(struct iwl_priv *priv, const u8 *addr,
 			break;
 		default:
 			ret = -EIO;
-			IWL_ERROR("REPLY_REMOVE_STA failed\n");
+			IWL_ERR(priv, "REPLY_REMOVE_STA failed\n");
 			break;
 		}
 	}
@@ -440,13 +441,13 @@ int iwl_remove_station(struct iwl_priv *priv, const u8 *addr, int is_ap)
 		sta_id, print_mac(mac, addr));
 
 	if (!(priv->stations[sta_id].used & IWL_STA_DRIVER_ACTIVE)) {
-		IWL_ERROR("Removing %s but non DRIVER active\n",
+		IWL_ERR(priv, "Removing %s but non DRIVER active\n",
 				print_mac(mac, addr));
 		goto out;
 	}
 
 	if (!(priv->stations[sta_id].used & IWL_STA_UCODE_ACTIVE)) {
-		IWL_ERROR("Removing %s but non UCODE active\n",
+		IWL_ERR(priv, "Removing %s but non UCODE active\n",
 				print_mac(mac, addr));
 		goto out;
 	}
@@ -482,7 +483,7 @@ void iwl_clear_stations_table(struct iwl_priv *priv)
 	if (iwl_is_alive(priv) &&
 	   !test_bit(STATUS_EXIT_PENDING, &priv->status) &&
 	   iwl_send_cmd_pdu_async(priv, REPLY_REMOVE_ALL_STA, 0, NULL, NULL))
-		IWL_ERROR("Couldn't clear the station table\n");
+		IWL_ERR(priv, "Couldn't clear the station table\n");
 
 	priv->num_stations = 0;
 	memset(priv->stations, 0, sizeof(priv->stations));
@@ -558,7 +559,7 @@ int iwl_remove_default_wep_key(struct iwl_priv *priv,
 	spin_lock_irqsave(&priv->sta_lock, flags);
 
 	if (!test_and_clear_bit(keyconf->keyidx, &priv->ucode_key_table))
-		IWL_ERROR("index %d not used in uCode key table.\n",
+		IWL_ERR(priv, "index %d not used in uCode key table.\n",
 			  keyconf->keyidx);
 
 	priv->default_wep_key--;
@@ -592,7 +593,7 @@ int iwl_set_default_wep_key(struct iwl_priv *priv,
 	priv->default_wep_key++;
 
 	if (test_and_set_bit(keyconf->keyidx, &priv->ucode_key_table))
-		IWL_ERROR("index %d already used in uCode key table.\n",
+		IWL_ERR(priv, "index %d already used in uCode key table.\n",
 			keyconf->keyidx);
 
 	priv->wep_keys[keyconf->keyidx].key_size = keyconf->keylen;
@@ -830,7 +831,7 @@ int iwl_remove_dynamic_key(struct iwl_priv *priv,
 
 	if (!test_and_clear_bit(priv->stations[sta_id].sta.key.key_offset,
 		&priv->ucode_key_table))
-		IWL_ERROR("index %d not used in uCode key table.\n",
+		IWL_ERR(priv, "index %d not used in uCode key table.\n",
 			priv->stations[sta_id].sta.key.key_offset);
 	memset(&priv->stations[sta_id].keyinfo, 0,
 					sizeof(struct iwl_hw_key));
@@ -867,7 +868,8 @@ int iwl_set_dynamic_key(struct iwl_priv *priv,
 		ret = iwl_set_wep_dynamic_key_info(priv, keyconf, sta_id);
 		break;
 	default:
-		IWL_ERROR("Unknown alg: %s alg = %d\n", __func__, keyconf->alg);
+		IWL_ERR(priv,
+			"Unknown alg: %s alg = %d\n", __func__, keyconf->alg);
 		ret = -EINVAL;
 	}
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-tx.c b/drivers/net/wireless/iwlwifi/iwl-tx.c
index 2671a7e..eddc127 100644
--- a/drivers/net/wireless/iwlwifi/iwl-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-tx.c
@@ -138,7 +138,7 @@ static void iwl_hw_txq_free_tfd(struct iwl_priv *priv, struct iwl_tx_queue *txq)
 	num_tbs = iwl_tfd_get_num_tbs(tfd);
 
 	if (num_tbs >= IWL_NUM_OF_TBS) {
-		IWL_ERROR("Too many chunks: %i\n", num_tbs);
+		IWL_ERR(priv, "Too many chunks: %i\n", num_tbs);
 		/* @todo issue fatal error, it is quite serious situation */
 		return;
 	}
@@ -171,14 +171,14 @@ static int iwl_hw_txq_attach_buf_to_tfd(struct iwl_priv *priv,
 
 	/* Each TFD can point to a maximum 20 Tx buffers */
 	if (num_tbs >= IWL_NUM_OF_TBS) {
-		IWL_ERROR("Error can not send more than %d chunks\n",
+		IWL_ERR(priv, "Error can not send more than %d chunks\n",
 			  IWL_NUM_OF_TBS);
 		return -EINVAL;
 	}
 
 	BUG_ON(addr & ~DMA_BIT_MASK(36));
 	if (unlikely(addr & ~IWL_TX_DMA_MASK))
-		IWL_ERROR("Unaligned address = %llx\n",
+		IWL_ERR(priv, "Unaligned address = %llx\n",
 			  (unsigned long long)addr);
 
 	iwl_tfd_set_tb(tfd, num_tbs, addr, len);
@@ -395,7 +395,7 @@ static int iwl_tx_queue_alloc(struct iwl_priv *priv,
 		txq->txb = kmalloc(sizeof(txq->txb[0]) *
 				   TFD_QUEUE_SIZE_MAX, GFP_KERNEL);
 		if (!txq->txb) {
-			IWL_ERROR("kmalloc for auxiliary BD "
+			IWL_ERR(priv, "kmalloc for auxiliary BD "
 				  "structures failed\n");
 			goto error;
 		}
@@ -409,7 +409,7 @@ static int iwl_tx_queue_alloc(struct iwl_priv *priv,
 			&txq->q.dma_addr);
 
 	if (!txq->tfds) {
-		IWL_ERROR("pci_alloc_consistent(%zd) failed\n",
+		IWL_ERR(priv, "pci_alloc_consistent(%zd) failed\n",
 			  sizeof(txq->tfds[0]) * TFD_QUEUE_SIZE_MAX);
 		goto error;
 	}
@@ -557,13 +557,13 @@ int iwl_txq_ctx_reset(struct iwl_priv *priv)
 	ret = iwl_alloc_dma_ptr(priv, &priv->scd_bc_tbls,
 				priv->hw_params.scd_bc_tbls_size);
 	if (ret) {
-		IWL_ERROR("Scheduler BC Table allocation failed\n");
+		IWL_ERR(priv, "Scheduler BC Table allocation failed\n");
 		goto error_bc_tbls;
 	}
 	/* Alloc keep-warm buffer */
 	ret = iwl_alloc_dma_ptr(priv, &priv->kw, IWL_KW_SIZE);
 	if (ret) {
-		IWL_ERROR("Keep Warm allocation failed\n");
+		IWL_ERR(priv, "Keep Warm allocation failed\n");
 		goto error_kw;
 	}
 	spin_lock_irqsave(&priv->lock, flags);
@@ -589,7 +589,7 @@ int iwl_txq_ctx_reset(struct iwl_priv *priv)
 		ret = iwl_tx_queue_init(priv, &priv->txq[txq_id], slots_num,
 				       txq_id);
 		if (ret) {
-			IWL_ERROR("Tx %d queue init failed\n", txq_id);
+			IWL_ERR(priv, "Tx %d queue init failed\n", txq_id);
 			goto error;
 		}
 	}
@@ -850,7 +850,7 @@ int iwl_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 
 	if ((ieee80211_get_tx_rate(priv->hw, info)->hw_value & 0xFF) ==
 	     IWL_INVALID_RATE) {
-		IWL_ERROR("ERROR: No TX rate available.\n");
+		IWL_ERR(priv, "ERROR: No TX rate available.\n");
 		goto drop_unlock;
 	}
 
@@ -1090,7 +1090,7 @@ int iwl_enqueue_hcmd(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
 	}
 
 	if (iwl_queue_space(q) < ((cmd->meta.flags & CMD_ASYNC) ? 2 : 1)) {
-		IWL_ERROR("No space for Tx\n");
+		IWL_ERR(priv, "No space for Tx\n");
 		return -ENOSPC;
 	}
 
@@ -1167,7 +1167,7 @@ int iwl_tx_queue_reclaim(struct iwl_priv *priv, int txq_id, int index)
 	int nfreed = 0;
 
 	if ((index >= q->n_bd) || (iwl_queue_used(q, index) == 0)) {
-		IWL_ERROR("Read index for DMA queue txq id (%d), index %d, "
+		IWL_ERR(priv, "Read index for DMA queue txq id (%d), index %d, "
 			  "is out of range [0-%d] %d %d.\n", txq_id,
 			  index, q->n_bd, q->write_ptr, q->read_ptr);
 		return 0;
@@ -1207,7 +1207,7 @@ static void iwl_hcmd_queue_reclaim(struct iwl_priv *priv, int txq_id,
 	int nfreed = 0;
 
 	if ((idx >= q->n_bd) || (iwl_queue_used(q, idx) == 0)) {
-		IWL_ERROR("Read index for DMA queue txq id (%d), index %d, "
+		IWL_ERR(priv, "Read index for DMA queue txq id (%d), index %d, "
 			  "is out of range [0-%d] %d %d.\n", txq_id,
 			  idx, q->n_bd, q->write_ptr, q->read_ptr);
 		return;
@@ -1222,7 +1222,7 @@ static void iwl_hcmd_queue_reclaim(struct iwl_priv *priv, int txq_id,
 	     q->read_ptr = iwl_queue_inc_wrap(q->read_ptr, q->n_bd)) {
 
 		if (nfreed++ > 0) {
-			IWL_ERROR("HCMD skipped: index (%d) %d %d\n", idx,
+			IWL_ERR(priv, "HCMD skipped: index (%d) %d %d\n", idx,
 					q->write_ptr, q->read_ptr);
 			queue_work(priv->workqueue, &priv->restart);
 		}
@@ -1319,7 +1319,7 @@ int iwl_tx_agg_start(struct iwl_priv *priv, const u8 *ra, u16 tid, u16 *ssn)
 		return -ENXIO;
 
 	if (priv->stations[sta_id].tid[tid].agg.state != IWL_AGG_OFF) {
-		IWL_ERROR("Start AGG when state is not IWL_AGG_OFF !\n");
+		IWL_ERR(priv, "Start AGG when state is not IWL_AGG_OFF !\n");
 		return -ENXIO;
 	}
 
@@ -1360,7 +1360,7 @@ int iwl_tx_agg_stop(struct iwl_priv *priv , const u8 *ra, u16 tid)
 	DECLARE_MAC_BUF(mac);
 
 	if (!ra) {
-		IWL_ERROR("ra = NULL\n");
+		IWL_ERR(priv, "ra = NULL\n");
 		return -EINVAL;
 	}
 
@@ -1461,7 +1461,7 @@ static int iwl_tx_status_reply_compressed_ba(struct iwl_priv *priv,
 	struct ieee80211_tx_info *info;
 
 	if (unlikely(!agg->wait_for_ba))  {
-		IWL_ERROR("Received BA when not expected\n");
+		IWL_ERR(priv, "Received BA when not expected\n");
 		return -EINVAL;
 	}
 
@@ -1535,7 +1535,8 @@ void iwl_rx_reply_compressed_ba(struct iwl_priv *priv,
 	u16 ba_resp_scd_ssn = le16_to_cpu(ba_resp->scd_ssn);
 
 	if (scd_flow >= priv->hw_params.max_txq_num) {
-		IWL_ERROR("BUG_ON scd_flow is bigger than number of queues\n");
+		IWL_ERR(priv,
+			"BUG_ON scd_flow is bigger than number of queues\n");
 		return;
 	}
 
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index c255c04..d84c4ce 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -185,7 +185,7 @@ static int iwl3945_tx_queue_alloc(struct iwl_priv *priv,
 		txq->txb = kmalloc(sizeof(txq->txb[0]) *
 				   TFD_QUEUE_SIZE_MAX, GFP_KERNEL);
 		if (!txq->txb) {
-			IWL_ERROR("kmalloc for auxiliary BD "
+			IWL_ERR(priv, "kmalloc for auxiliary BD "
 				  "structures failed\n");
 			goto error;
 		}
@@ -199,7 +199,7 @@ static int iwl3945_tx_queue_alloc(struct iwl_priv *priv,
 			&txq->q.dma_addr);
 
 	if (!txq->bd) {
-		IWL_ERROR("pci_alloc_consistent(%zd) failed\n",
+		IWL_ERR(priv, "pci_alloc_consistent(%zd) failed\n",
 			  sizeof(txq->bd[0]) * TFD_QUEUE_SIZE_MAX);
 		goto error;
 	}
@@ -529,7 +529,7 @@ static int iwl3945_enqueue_hcmd(struct iwl_priv *priv, struct iwl3945_host_cmd *
 	}
 
 	if (iwl_queue_space(q) < ((cmd->meta.flags & CMD_ASYNC) ? 2 : 1)) {
-		IWL_ERROR("No space for Tx\n");
+		IWL_ERR(priv, "No space for Tx\n");
 		return -ENOSPC;
 	}
 
@@ -597,8 +597,9 @@ static int iwl3945_send_cmd_async(struct iwl_priv *priv, struct iwl3945_host_cmd
 
 	ret = iwl3945_enqueue_hcmd(priv, cmd);
 	if (ret < 0) {
-		IWL_ERROR("Error sending %s: iwl3945_enqueue_hcmd failed: %d\n",
-			  get_cmd_string(cmd->id), ret);
+		IWL_ERR(priv,
+			"Error sending %s: iwl3945_enqueue_hcmd failed: %d\n",
+			get_cmd_string(cmd->id), ret);
 		return ret;
 	}
 	return 0;
@@ -615,8 +616,9 @@ static int iwl3945_send_cmd_sync(struct iwl_priv *priv, struct iwl3945_host_cmd
 	BUG_ON(cmd->meta.u.callback != NULL);
 
 	if (test_and_set_bit(STATUS_HCMD_SYNC_ACTIVE, &priv->status)) {
-		IWL_ERROR("Error sending %s: Already sending a host command\n",
-			  get_cmd_string(cmd->id));
+		IWL_ERR(priv,
+			"Error sending %s: Already sending a host command\n",
+			get_cmd_string(cmd->id));
 		ret = -EBUSY;
 		goto out;
 	}
@@ -629,8 +631,9 @@ static int iwl3945_send_cmd_sync(struct iwl_priv *priv, struct iwl3945_host_cmd
 	cmd_idx = iwl3945_enqueue_hcmd(priv, cmd);
 	if (cmd_idx < 0) {
 		ret = cmd_idx;
-		IWL_ERROR("Error sending %s: iwl3945_enqueue_hcmd failed: %d\n",
-			  get_cmd_string(cmd->id), ret);
+		IWL_ERR(priv,
+			"Error sending %s: iwl3945_enqueue_hcmd failed: %d\n",
+			get_cmd_string(cmd->id), ret);
 		goto out;
 	}
 
@@ -639,7 +642,7 @@ static int iwl3945_send_cmd_sync(struct iwl_priv *priv, struct iwl3945_host_cmd
 			HOST_COMPLETE_TIMEOUT);
 	if (!ret) {
 		if (test_bit(STATUS_HCMD_ACTIVE, &priv->status)) {
-			IWL_ERROR("Error sending %s: time out after %dms.\n",
+			IWL_ERR(priv, "Error sending %s: time out after %dms\n",
 				  get_cmd_string(cmd->id),
 				  jiffies_to_msecs(HOST_COMPLETE_TIMEOUT));
 
@@ -662,7 +665,7 @@ static int iwl3945_send_cmd_sync(struct iwl_priv *priv, struct iwl3945_host_cmd
 		goto fail;
 	}
 	if ((cmd->meta.flags & CMD_WANT_SKB) && !cmd->meta.u.skb) {
-		IWL_ERROR("Error: Response NULL in '%s'\n",
+		IWL_ERR(priv, "Error: Response NULL in '%s'\n",
 			  get_cmd_string(cmd->id));
 		ret = -EIO;
 		goto out;
@@ -838,7 +841,7 @@ static int iwl3945_check_rxon_cmd(struct iwl_priv *priv)
 			    le16_to_cpu(rxon->channel));
 
 	if (error) {
-		IWL_ERROR("Not a valid iwl3945_rxon_assoc_cmd field values\n");
+		IWL_ERR(priv, "Not a valid rxon_assoc_cmd field values\n");
 		return -1;
 	}
 	return 0;
@@ -921,7 +924,7 @@ static int iwl3945_send_rxon_assoc(struct iwl_priv *priv)
 
 	res = (struct iwl_rx_packet *)cmd.meta.u.skb->data;
 	if (res->hdr.flags & IWL_CMD_FAILED_MSK) {
-		IWL_ERROR("Bad return from REPLY_RXON_ASSOC command\n");
+		IWL_ERR(priv, "Bad return from REPLY_RXON_ASSOC command\n");
 		rc = -EIO;
 	}
 
@@ -959,7 +962,7 @@ static int iwl3945_commit_rxon(struct iwl_priv *priv)
 
 	rc = iwl3945_check_rxon_cmd(priv);
 	if (rc) {
-		IWL_ERROR("Invalid RXON configuration.  Not committing.\n");
+		IWL_ERR(priv, "Invalid RXON configuration.  Not committing.\n");
 		return -EINVAL;
 	}
 
@@ -969,7 +972,7 @@ static int iwl3945_commit_rxon(struct iwl_priv *priv)
 	if (!iwl3945_full_rxon_required(priv)) {
 		rc = iwl3945_send_rxon_assoc(priv);
 		if (rc) {
-			IWL_ERROR("Error setting RXON_ASSOC "
+			IWL_ERR(priv, "Error setting RXON_ASSOC "
 				  "configuration (%d).\n", rc);
 			return rc;
 		}
@@ -996,7 +999,7 @@ static int iwl3945_commit_rxon(struct iwl_priv *priv)
 		 * active_rxon back to what it was previously */
 		if (rc) {
 			active_rxon->filter_flags |= RXON_FILTER_ASSOC_MSK;
-			IWL_ERROR("Error clearing ASSOC_MSK on current "
+			IWL_ERR(priv, "Error clearing ASSOC_MSK on current "
 				  "configuration (%d).\n", rc);
 			return rc;
 		}
@@ -1015,7 +1018,7 @@ static int iwl3945_commit_rxon(struct iwl_priv *priv)
 	rc = iwl3945_send_cmd_pdu(priv, REPLY_RXON,
 			      sizeof(struct iwl3945_rxon_cmd), &priv->staging39_rxon);
 	if (rc) {
-		IWL_ERROR("Error setting new configuration (%d).\n", rc);
+		IWL_ERR(priv, "Error setting new configuration (%d).\n", rc);
 		return rc;
 	}
 
@@ -1027,14 +1030,14 @@ static int iwl3945_commit_rxon(struct iwl_priv *priv)
 	 * send a new TXPOWER command or we won't be able to Tx any frames */
 	rc = iwl3945_hw_reg_send_txpower(priv);
 	if (rc) {
-		IWL_ERROR("Error setting Tx power (%d).\n", rc);
+		IWL_ERR(priv, "Error setting Tx power (%d).\n", rc);
 		return rc;
 	}
 
 	/* Add the broadcast address so we can send broadcast frames */
 	if (iwl3945_add_station(priv, iwl_bcast_addr, 0, 0) ==
 	    IWL_INVALID_STATION) {
-		IWL_ERROR("Error adding BROADCAST address for transmit.\n");
+		IWL_ERR(priv, "Error adding BROADCAST address for transmit.\n");
 		return -EIO;
 	}
 
@@ -1044,14 +1047,14 @@ static int iwl3945_commit_rxon(struct iwl_priv *priv)
 	    (priv->iw_mode == NL80211_IFTYPE_STATION))
 		if (iwl3945_add_station(priv, priv->active39_rxon.bssid_addr, 1, 0)
 		    == IWL_INVALID_STATION) {
-			IWL_ERROR("Error adding AP address for transmit.\n");
+			IWL_ERR(priv, "Error adding AP address for transmit\n");
 			return -EIO;
 		}
 
 	/* Init the hardware's rate fallback order based on the band */
 	rc = iwl3945_init_hw_rate_table(priv);
 	if (rc) {
-		IWL_ERROR("Error setting HW rate table: %02X\n", rc);
+		IWL_ERR(priv, "Error setting HW rate table: %02X\n", rc);
 		return -EIO;
 	}
 
@@ -1151,13 +1154,13 @@ static int iwl3945_add_sta_sync_callback(struct iwl_priv *priv,
 	struct iwl_rx_packet *res = NULL;
 
 	if (!skb) {
-		IWL_ERROR("Error: Response NULL in REPLY_ADD_STA.\n");
+		IWL_ERR(priv, "Error: Response NULL in REPLY_ADD_STA.\n");
 		return 1;
 	}
 
 	res = (struct iwl_rx_packet *)skb->data;
 	if (res->hdr.flags & IWL_CMD_FAILED_MSK) {
-		IWL_ERROR("Bad return from REPLY_ADD_STA (0x%08X)\n",
+		IWL_ERR(priv, "Bad return from REPLY_ADD_STA (0x%08X)\n",
 			  res->hdr.flags);
 		return 1;
 	}
@@ -1197,7 +1200,7 @@ int iwl3945_send_add_station(struct iwl_priv *priv,
 
 	res = (struct iwl_rx_packet *)cmd.meta.u.skb->data;
 	if (res->hdr.flags & IWL_CMD_FAILED_MSK) {
-		IWL_ERROR("Bad return from REPLY_ADD_STA (0x%08X)\n",
+		IWL_ERR(priv, "Bad return from REPLY_ADD_STA (0x%08X)\n",
 			  res->hdr.flags);
 		rc = -EIO;
 	}
@@ -1304,7 +1307,7 @@ static struct iwl3945_frame *iwl3945_get_free_frame(struct iwl_priv *priv)
 	if (list_empty(&priv->free_frames)) {
 		frame = kzalloc(sizeof(*frame), GFP_KERNEL);
 		if (!frame) {
-			IWL_ERROR("Could not allocate frame!\n");
+			IWL_ERR(priv, "Could not allocate frame!\n");
 			return NULL;
 		}
 
@@ -1375,7 +1378,7 @@ static int iwl3945_send_beacon_cmd(struct iwl_priv *priv)
 	frame = iwl3945_get_free_frame(priv);
 
 	if (!frame) {
-		IWL_ERROR("Could not obtain free frame buffer for beacon "
+		IWL_ERR(priv, "Could not obtain free frame buffer for beacon "
 			  "command.\n");
 		return -ENOMEM;
 	}
@@ -1439,14 +1442,14 @@ int iwl3945_eeprom_init(struct iwl_priv *priv)
 	BUILD_BUG_ON(sizeof(priv->eeprom39) != IWL_EEPROM_IMAGE_SIZE);
 
 	if ((gp & CSR_EEPROM_GP_VALID_MSK) == CSR_EEPROM_GP_BAD_SIGNATURE) {
-		IWL_ERROR("EEPROM not found, EEPROM_GP=0x%08x\n", gp);
+		IWL_ERR(priv, "EEPROM not found, EEPROM_GP=0x%08x\n", gp);
 		return -ENOENT;
 	}
 
 	/* Make sure driver (instead of uCode) is allowed to read EEPROM */
 	ret = iwl3945_eeprom_acquire_semaphore(priv);
 	if (ret < 0) {
-		IWL_ERROR("Failed to acquire EEPROM semaphore.\n");
+		IWL_ERR(priv, "Failed to acquire EEPROM semaphore.\n");
 		return -ENOENT;
 	}
 
@@ -1461,7 +1464,7 @@ int iwl3945_eeprom_init(struct iwl_priv *priv)
 					      CSR_EEPROM_REG_READ_VALID_MSK,
 					      IWL_EEPROM_ACCESS_TIMEOUT);
 		if (ret < 0) {
-			IWL_ERROR("Time out reading EEPROM[%d]\n", addr);
+			IWL_ERR(priv, "Time out reading EEPROM[%d]\n", addr);
 			return ret;
 		}
 
@@ -2122,7 +2125,7 @@ static void iwl3945_connection_init_rx_config(struct iwl_priv *priv,
 		    RXON_FILTER_CTL2HOST_MSK | RXON_FILTER_ACCEPT_GRP_MSK;
 		break;
 	default:
-		IWL_ERROR("Unsupported interface type %d\n", mode);
+		IWL_ERR(priv, "Unsupported interface type %d\n", mode);
 		break;
 	}
 
@@ -2172,7 +2175,7 @@ static int iwl3945_set_mode(struct iwl_priv *priv, int mode)
 			le16_to_cpu(priv->staging39_rxon.channel));
 
 		if (!ch_info || !is_channel_ibss(ch_info)) {
-			IWL_ERROR("channel %d not IBSS channel\n",
+			IWL_ERR(priv, "channel %d not IBSS channel\n",
 				  le16_to_cpu(priv->staging39_rxon.channel));
 			return -EINVAL;
 		}
@@ -2407,7 +2410,7 @@ static int iwl3945_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 	}
 
 	if ((ieee80211_get_tx_rate(priv->hw, info)->hw_value & 0xFF) == IWL_INVALID_RATE) {
-		IWL_ERROR("ERROR: No TX rate available.\n");
+		IWL_ERR(priv, "ERROR: No TX rate available.\n");
 		goto drop_unlock;
 	}
 
@@ -2609,7 +2612,7 @@ static void iwl3945_set_rate(struct iwl_priv *priv)
 
 	sband = iwl3945_get_band(priv, priv->band);
 	if (!sband) {
-		IWL_ERROR("Failed to set rate: unable to get hw mode\n");
+		IWL_ERR(priv, "Failed to set rate: unable to get hw mode\n");
 		return;
 	}
 
@@ -2842,7 +2845,7 @@ static int iwl3945_get_measurement(struct iwl_priv *priv,
 
 	res = (struct iwl_rx_packet *)cmd.meta.u.skb->data;
 	if (res->hdr.flags & IWL_CMD_FAILED_MSK) {
-		IWL_ERROR("Bad return from REPLY_RX_ON_ASSOC command\n");
+		IWL_ERR(priv, "Bad return from REPLY_RX_ON_ASSOC command\n");
 		rc = -EIO;
 	}
 
@@ -2919,7 +2922,7 @@ static void iwl3945_rx_reply_error(struct iwl_priv *priv,
 {
 	struct iwl_rx_packet *pkt = (void *)rxb->skb->data;
 
-	IWL_ERROR("Error Reply type 0x%08X cmd %s (0x%02X) "
+	IWL_ERR(priv, "Error Reply type 0x%08X cmd %s (0x%02X) "
 		"seq 0x%04X ser 0x%08X\n",
 		le32_to_cpu(pkt->u.err_resp.error_type),
 		get_cmd_string(pkt->u.err_resp.cmd_id),
@@ -2991,7 +2994,7 @@ static void iwl3945_bg_beacon_update(struct work_struct *work)
 	beacon = ieee80211_beacon_get(priv->hw, priv->vif);
 
 	if (!beacon) {
-		IWL_ERROR("update beacon failed\n");
+		IWL_ERR(priv, "update beacon failed\n");
 		return;
 	}
 
@@ -3238,7 +3241,7 @@ static void iwl3945_cmd_queue_reclaim(struct iwl_priv *priv,
 	int nfreed = 0;
 
 	if ((index >= q->n_bd) || (iwl3945_x2_queue_used(q, index) == 0)) {
-		IWL_ERROR("Read index for DMA queue txq id (%d), index %d, "
+		IWL_ERR(priv, "Read index for DMA queue txq id (%d), index %d, "
 			  "is out of range [0-%d] %d %d.\n", txq_id,
 			  index, q->n_bd, q->write_ptr, q->read_ptr);
 		return;
@@ -3247,7 +3250,7 @@ static void iwl3945_cmd_queue_reclaim(struct iwl_priv *priv,
 	for (index = iwl_queue_inc_wrap(index, q->n_bd); q->read_ptr != index;
 		q->read_ptr = iwl_queue_inc_wrap(q->read_ptr, q->n_bd)) {
 		if (nfreed > 1) {
-			IWL_ERROR("HCMD skipped: index (%d) %d %d\n", index,
+			IWL_ERR(priv, "HCMD skipped: index (%d) %d %d\n", index,
 					q->write_ptr, q->read_ptr);
 			queue_work(priv->workqueue, &priv->restart);
 			break;
@@ -3965,7 +3968,7 @@ static void iwl3945_dump_nic_error_log(struct iwl_priv *priv)
 	base = le32_to_cpu(priv->card_alive.error_event_table_ptr);
 
 	if (!iwl3945_hw_valid_rtc_data_addr(base)) {
-		IWL_ERROR("Not valid error log pointer 0x%08X\n", base);
+		IWL_ERR(priv, "Not valid error log pointer 0x%08X\n", base);
 		return;
 	}
 
@@ -3978,11 +3981,12 @@ static void iwl3945_dump_nic_error_log(struct iwl_priv *priv)
 	count = iwl_read_targ_mem(priv, base);
 
 	if (ERROR_START_OFFSET <= count * ERROR_ELEM_SIZE) {
-		IWL_ERROR("Start IWL Error Log Dump:\n");
-		IWL_ERROR("Status: 0x%08lX, count: %d\n", priv->status, count);
+		IWL_ERR(priv, "Start IWL Error Log Dump:\n");
+		IWL_ERR(priv, "Status: 0x%08lX, count: %d\n",
+			priv->status, count);
 	}
 
-	IWL_ERROR("Desc       Time       asrtPC  blink2 "
+	IWL_ERR(priv, "Desc       Time       asrtPC  blink2 "
 		  "ilink1  nmiPC   Line\n");
 	for (i = ERROR_START_OFFSET;
 	     i < (count * ERROR_ELEM_SIZE) + ERROR_START_OFFSET;
@@ -4001,10 +4005,10 @@ static void iwl3945_dump_nic_error_log(struct iwl_priv *priv)
 		data1 =
 		    iwl_read_targ_mem(priv, base + i + 6 * sizeof(u32));
 
-		IWL_ERROR
-		    ("%-13s (#%d) %010u 0x%05X 0x%05X 0x%05X 0x%05X %u\n\n",
-		     desc_lookup(desc), desc, time, blink1, blink2,
-		     ilink1, ilink2, data1);
+		IWL_ERR(priv,
+			"%-13s (#%d) %010u 0x%05X 0x%05X 0x%05X 0x%05X %u\n\n",
+			desc_lookup(desc), desc, time, blink1, blink2,
+			ilink1, ilink2, data1);
 	}
 
 	iwl_release_nic_access(priv);
@@ -4046,12 +4050,13 @@ static void iwl3945_print_event_log(struct iwl_priv *priv, u32 start_idx,
 		ptr += sizeof(u32);
 		time = iwl_read_targ_mem(priv, ptr);
 		ptr += sizeof(u32);
-		if (mode == 0)
-			IWL_ERROR("0x%08x\t%04u\n", time, ev); /* data, ev */
-		else {
+		if (mode == 0) {
+			/* data, ev */
+			IWL_ERR(priv, "0x%08x\t%04u\n", time, ev);
+		} else {
 			data = iwl_read_targ_mem(priv, ptr);
 			ptr += sizeof(u32);
-			IWL_ERROR("%010u\t0x%08x\t%04u\n", time, data, ev);
+			IWL_ERR(priv, "%010u\t0x%08x\t%04u\n", time, data, ev);
 		}
 	}
 }
@@ -4068,7 +4073,7 @@ static void iwl3945_dump_nic_event_log(struct iwl_priv *priv)
 
 	base = le32_to_cpu(priv->card_alive.log_event_table_ptr);
 	if (!iwl3945_hw_valid_rtc_data_addr(base)) {
-		IWL_ERROR("Invalid event log pointer 0x%08X\n", base);
+		IWL_ERR(priv, "Invalid event log pointer 0x%08X\n", base);
 		return;
 	}
 
@@ -4088,12 +4093,12 @@ static void iwl3945_dump_nic_event_log(struct iwl_priv *priv)
 
 	/* bail out if nothing in log */
 	if (size == 0) {
-		IWL_ERROR("Start IWL Event Log Dump: nothing in log\n");
+		IWL_ERR(priv, "Start IWL Event Log Dump: nothing in log\n");
 		iwl_release_nic_access(priv);
 		return;
 	}
 
-	IWL_ERROR("Start IWL Event Log Dump: display count %d, wraps %d\n",
+	IWL_ERR(priv, "Start IWL Event Log Dump: display count %d, wraps %d\n",
 		  size, num_wraps);
 
 	/* if uCode has wrapped back to top of log, start at the oldest entry,
@@ -4206,7 +4211,7 @@ static void iwl3945_irq_tasklet(struct iwl_priv *priv)
 
 	/* Now service all interrupt bits discovered above. */
 	if (inta & CSR_INT_BIT_HW_ERR) {
-		IWL_ERROR("Microcode HW error detected.  Restarting.\n");
+		IWL_ERR(priv, "Microcode HW error detected.  Restarting.\n");
 
 		/* Tell the device to stop sending interrupts */
 		iwl3945_disable_interrupts(priv);
@@ -4237,8 +4242,8 @@ static void iwl3945_irq_tasklet(struct iwl_priv *priv)
 
 	/* Error detected by uCode */
 	if (inta & CSR_INT_BIT_SW_ERR) {
-		IWL_ERROR("Microcode SW error detected.  Restarting 0x%X.\n",
-			  inta);
+		IWL_ERR(priv, "Microcode SW error detected. "
+			"Restarting 0x%X.\n", inta);
 		iwl3945_irq_handle_error(priv);
 		handled |= CSR_INT_BIT_SW_ERR;
 	}
@@ -4278,7 +4283,7 @@ static void iwl3945_irq_tasklet(struct iwl_priv *priv)
 	}
 
 	if (inta & ~handled)
-		IWL_ERROR("Unhandled INTA bits 0x%08x\n", inta & ~handled);
+		IWL_ERR(priv, "Unhandled INTA bits 0x%08x\n", inta & ~handled);
 
 	if (inta & ~CSR_INI_SET_MASK) {
 		IWL_WARN(priv, "Disabled INTA bits 0x%08x were pending\n",
@@ -4520,7 +4525,7 @@ static int iwl3945_init_channel_map(struct iwl_priv *priv)
 	priv->channel_info = kzalloc(sizeof(struct iwl_channel_info) *
 				     priv->channel_count, GFP_KERNEL);
 	if (!priv->channel_info) {
-		IWL_ERROR("Could not allocate channel_info\n");
+		IWL_ERR(priv, "Could not allocate channel_info\n");
 		priv->channel_count = 0;
 		return -ENOMEM;
 	}
@@ -4959,7 +4964,7 @@ static int iwl3945_verify_inst_full(struct iwl_priv *priv, __le32 *image, u32 le
 		 * if IWL_DL_IO is set */
 		val = _iwl_read_direct32(priv, HBUS_TARG_MEM_RDAT);
 		if (val != le32_to_cpu(*image)) {
-			IWL_ERROR("uCode INST section is invalid at "
+			IWL_ERR(priv, "uCode INST section is invalid at "
 				  "offset 0x%x, is 0x%x, s/b 0x%x\n",
 				  save_len - len, val, le32_to_cpu(*image));
 			rc = -EIO;
@@ -5005,7 +5010,7 @@ static int iwl3945_verify_inst_sparse(struct iwl_priv *priv, __le32 *image, u32
 		val = _iwl_read_direct32(priv, HBUS_TARG_MEM_RDAT);
 		if (val != le32_to_cpu(*image)) {
 #if 0 /* Enable this if you want to see details */
-			IWL_ERROR("uCode INST section is invalid at "
+			IWL_ERR(priv, "uCode INST section is invalid at "
 				  "offset 0x%x, is 0x%x, s/b 0x%x\n",
 				  i, val, *image);
 #endif
@@ -5059,7 +5064,7 @@ static int iwl3945_verify_ucode(struct iwl_priv *priv)
 		return 0;
 	}
 
-	IWL_ERROR("NO VALID UCODE IMAGE IN INSTRUCTION SRAM!!\n");
+	IWL_ERR(priv, "NO VALID UCODE IMAGE IN INSTRUCTION SRAM!!\n");
 
 	/* Since nothing seems to match, show first several data entries in
 	 * instruction SRAM, so maybe visual inspection will give a clue.
@@ -5089,7 +5094,7 @@ static int iwl3945_verify_bsm(struct iwl_priv *priv)
 	     reg += sizeof(u32), image++) {
 		val = iwl_read_prph(priv, reg);
 		if (val != le32_to_cpu(*image)) {
-			IWL_ERROR("BSM uCode verification failed at "
+			IWL_ERR(priv, "BSM uCode verification failed at "
 				  "addr 0x%08X+%u (of %u), is 0x%x, s/b 0x%x\n",
 				  BSM_SRAM_LOWER_BOUND,
 				  reg - BSM_SRAM_LOWER_BOUND, len,
@@ -5207,7 +5212,7 @@ static int iwl3945_load_bsm(struct iwl_priv *priv)
 	if (i < 100)
 		IWL_DEBUG_INFO("BSM write complete, poll %d iterations\n", i);
 	else {
-		IWL_ERROR("BSM write did not complete!\n");
+		IWL_ERR(priv, "BSM write did not complete!\n");
 		return -EIO;
 	}
 
@@ -5252,7 +5257,7 @@ static int iwl3945_read_ucode(struct iwl_priv *priv)
 		sprintf(buf, "%s%u%s", name_pre, index, ".ucode");
 		ret = request_firmware(&ucode_raw, buf, &priv->pci_dev->dev);
 		if (ret < 0) {
-			IWL_ERROR("%s firmware file req failed: Reason %d\n",
+			IWL_ERR(priv, "%s firmware file req failed: %d\n",
 				  buf, ret);
 			if (ret == -ENOENT)
 				continue;
@@ -5260,7 +5265,9 @@ static int iwl3945_read_ucode(struct iwl_priv *priv)
 				goto error;
 		} else {
 			if (index < api_max)
-				IWL_ERROR("Loaded firmware %s, which is deprecated. Please use API v%u instead.\n",
+				IWL_ERR(priv, "Loaded firmware %s, "
+					"which is deprecated. "
+					" Please use API v%u instead.\n",
 					  buf, api_max);
 			IWL_DEBUG_INFO("Got firmware '%s' file (%zd bytes) from disk\n",
 				       buf, ucode_raw->size);
@@ -5273,7 +5280,7 @@ static int iwl3945_read_ucode(struct iwl_priv *priv)
 
 	/* Make sure that we got at least our header! */
 	if (ucode_raw->size < sizeof(*ucode)) {
-		IWL_ERROR("File size way too small!\n");
+		IWL_ERR(priv, "File size way too small!\n");
 		ret = -EINVAL;
 		goto err_release;
 	}
@@ -5294,7 +5301,7 @@ static int iwl3945_read_ucode(struct iwl_priv *priv)
 	 * on the API version read from firware header from here on forward */
 
 	if (api_ver < api_min || api_ver > api_max) {
-		IWL_ERROR("Driver unable to support your firmware API. "
+		IWL_ERR(priv, "Driver unable to support your firmware API. "
 			  "Driver supports v%u, firmware is v%u.\n",
 			  api_max, api_ver);
 		priv->ucode_ver = 0;
@@ -5302,7 +5309,7 @@ static int iwl3945_read_ucode(struct iwl_priv *priv)
 		goto err_release;
 	}
 	if (api_ver != api_max)
-		IWL_ERROR("Firmware has old API version. Expected %u, "
+		IWL_ERR(priv, "Firmware has old API version. Expected %u, "
 			  "got %u. New firmware can be obtained "
 			  "from http://www.intellinuxwireless.org.\n",
 			  api_max, api_ver);
@@ -5453,7 +5460,7 @@ static int iwl3945_read_ucode(struct iwl_priv *priv)
 	return 0;
 
  err_pci_alloc:
-	IWL_ERROR("failed to allocate pci memory\n");
+	IWL_ERR(priv, "failed to allocate pci memory\n");
 	ret = -ENOMEM;
 	iwl3945_dealloc_ucode_pci(priv);
 
@@ -5805,7 +5812,7 @@ static int __iwl3945_up(struct iwl_priv *priv)
 	}
 
 	if (!priv->ucode_data_backup.v_addr || !priv->ucode_data.v_addr) {
-		IWL_ERROR("ucode not available for device bring up\n");
+		IWL_ERR(priv, "ucode not available for device bring up\n");
 		return -EIO;
 	}
 
@@ -5825,7 +5832,7 @@ static int __iwl3945_up(struct iwl_priv *priv)
 
 	rc = iwl3945_hw_nic_init(priv);
 	if (rc) {
-		IWL_ERROR("Unable to int nic\n");
+		IWL_ERR(priv, "Unable to int nic\n");
 		return rc;
 	}
 
@@ -5862,7 +5869,8 @@ static int __iwl3945_up(struct iwl_priv *priv)
 		rc = iwl3945_load_bsm(priv);
 
 		if (rc) {
-			IWL_ERROR("Unable to set up bootstrap uCode: %d\n", rc);
+			IWL_ERR(priv,
+				"Unable to set up bootstrap uCode: %d\n", rc);
 			continue;
 		}
 
@@ -5880,7 +5888,7 @@ static int __iwl3945_up(struct iwl_priv *priv)
 
 	/* tried to restart and config the device for as long as our
 	 * patience could withstand */
-	IWL_ERROR("Unable to initialize device after %d attempts.\n", i);
+	IWL_ERR(priv, "Unable to initialize device after %d attempts.\n", i);
 	return -EIO;
 }
 
@@ -6214,7 +6222,7 @@ static void iwl3945_post_associate(struct iwl_priv *priv)
 	DECLARE_MAC_BUF(mac);
 
 	if (priv->iw_mode == NL80211_IFTYPE_AP) {
-		IWL_ERROR("%s Should not be called in AP mode\n", __func__);
+		IWL_ERR(priv, "%s Should not be called in AP mode\n", __func__);
 		return;
 	}
 
@@ -6288,7 +6296,7 @@ static void iwl3945_post_associate(struct iwl_priv *priv)
 		break;
 
 	default:
-		 IWL_ERROR("%s Should not be called in %d mode\n",
+		 IWL_ERR(priv, "%s Should not be called in %d mode\n",
 			   __func__, priv->iw_mode);
 		break;
 	}
@@ -6354,7 +6362,7 @@ static int iwl3945_mac_start(struct ieee80211_hw *hw)
 	IWL_DEBUG_MAC80211("enter\n");
 
 	if (pci_enable_device(priv->pci_dev)) {
-		IWL_ERROR("Fail to pci_enable_device\n");
+		IWL_ERR(priv, "Fail to pci_enable_device\n");
 		return -ENODEV;
 	}
 	pci_restore_state(priv->pci_dev);
@@ -6363,7 +6371,7 @@ static int iwl3945_mac_start(struct ieee80211_hw *hw)
 	ret = request_irq(priv->pci_dev->irq, iwl3945_isr, IRQF_SHARED,
 			  DRV_NAME, priv);
 	if (ret) {
-		IWL_ERROR("Error allocating IRQ %d\n", priv->pci_dev->irq);
+		IWL_ERR(priv, "Error allocating IRQ %d\n", priv->pci_dev->irq);
 		goto out_disable_msi;
 	}
 
@@ -6377,7 +6385,7 @@ static int iwl3945_mac_start(struct ieee80211_hw *hw)
 	if (!priv->ucode_code.len) {
 		ret = iwl3945_read_ucode(priv);
 		if (ret) {
-			IWL_ERROR("Could not read microcode: %d\n", ret);
+			IWL_ERR(priv, "Could not read microcode: %d\n", ret);
 			mutex_unlock(&priv->mutex);
 			goto out_release_irq;
 		}
@@ -6404,8 +6412,9 @@ static int iwl3945_mac_start(struct ieee80211_hw *hw)
 			UCODE_READY_TIMEOUT);
 	if (!ret) {
 		if (!test_bit(STATUS_READY, &priv->status)) {
-			IWL_ERROR("Wait for START_ALIVE timeout after %dms.\n",
-				  jiffies_to_msecs(UCODE_READY_TIMEOUT));
+			IWL_ERR(priv,
+				"Wait for START_ALIVE timeout after %dms.\n",
+				jiffies_to_msecs(UCODE_READY_TIMEOUT));
 			ret = -ETIMEDOUT;
 			goto out_release_irq;
 		}
@@ -7756,8 +7765,9 @@ static int iwl3945_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 
 	if ((iwl3945_param_queues_num > IWL39_MAX_NUM_QUEUES) ||
 	    (iwl3945_param_queues_num < IWL_MIN_NUM_QUEUES)) {
-		IWL_ERROR("invalid queues_num, should be between %d and %d\n",
-			  IWL_MIN_NUM_QUEUES, IWL39_MAX_NUM_QUEUES);
+		IWL_ERR(priv,
+			"invalid queues_num, should be between %d and %d\n",
+			IWL_MIN_NUM_QUEUES, IWL39_MAX_NUM_QUEUES);
 		err = -EINVAL;
 		goto out;
 	}
@@ -7851,7 +7861,7 @@ static int iwl3945_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 	/* Read the EEPROM */
 	err = iwl3945_eeprom_init(priv);
 	if (err) {
-		IWL_ERROR("Unable to init EEPROM\n");
+		IWL_ERR(priv, "Unable to init EEPROM\n");
 		goto out_remove_sysfs;
 	}
 	/* MAC Address location in EEPROM same for 3945/4965 */
@@ -7864,7 +7874,7 @@ static int iwl3945_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 	 * ********************/
 	/* Device-specific setup */
 	if (iwl3945_hw_set_hw_params(priv)) {
-		IWL_ERROR("failed to set hw settings\n");
+		IWL_ERR(priv, "failed to set hw settings\n");
 		goto out_iounmap;
 	}
 
@@ -7905,13 +7915,13 @@ static int iwl3945_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 
 	err = iwl3945_init_channel_map(priv);
 	if (err) {
-		IWL_ERROR("initializing regulatory failed: %d\n", err);
+		IWL_ERR(priv, "initializing regulatory failed: %d\n", err);
 		goto out_release_irq;
 	}
 
 	err = iwl3945_init_geos(priv);
 	if (err) {
-		IWL_ERROR("initializing geos failed: %d\n", err);
+		IWL_ERR(priv, "initializing geos failed: %d\n", err);
 		goto out_free_channel_map;
 	}
 
@@ -7940,7 +7950,7 @@ static int iwl3945_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 
 	err = sysfs_create_group(&pdev->dev.kobj, &iwl3945_attribute_group);
 	if (err) {
-		IWL_ERROR("failed to create sysfs device attributes\n");
+		IWL_ERR(priv, "failed to create sysfs device attributes\n");
 		goto out_free_geos;
 	}
 
@@ -7960,7 +7970,7 @@ static int iwl3945_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 
 	err = ieee80211_register_hw(priv->hw);
 	if (err) {
-		IWL_ERROR("Failed to register network device (error %d)\n", err);
+		IWL_ERR(priv, "Failed to register network device: %d\n", err);
 		goto  out_remove_sysfs;
 	}
 
@@ -7970,7 +7980,7 @@ static int iwl3945_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 
 	err = iwl3945_rfkill_init(priv);
 	if (err)
-		IWL_ERROR("Unable to initialize RFKILL system. "
+		IWL_ERR(priv, "Unable to initialize RFKILL system. "
 				  "Ignoring error: %d\n", err);
 
 	return 0;
@@ -8142,7 +8152,7 @@ int iwl3945_rfkill_init(struct iwl_priv *priv)
 	IWL_DEBUG_RF_KILL("Initializing RFKILL.\n");
 	priv->rfkill = rfkill_allocate(device, RFKILL_TYPE_WLAN);
 	if (!priv->rfkill) {
-		IWL_ERROR("Unable to allocate rfkill device.\n");
+		IWL_ERR(priv, "Unable to allocate rfkill device.\n");
 		ret = -ENOMEM;
 		goto error;
 	}
@@ -8158,7 +8168,7 @@ int iwl3945_rfkill_init(struct iwl_priv *priv)
 
 	ret = rfkill_register(priv->rfkill);
 	if (ret) {
-		IWL_ERROR("Unable to register rfkill: %d\n", ret);
+		IWL_ERR(priv, "Unable to register rfkill: %d\n", ret);
 		goto freed_rfkill;
 	}
 
-- 
1.5.3.6

