Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:12774 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751607Ab1KRIVH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Nov 2011 03:21:07 -0500
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pAI8L6SC026033
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-wireless@vger.kernel.org>; Fri, 18 Nov 2011 03:21:06 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 08/77] iwlegacy: remove il argument from IWL_ERR/INFO/WARN/CRIT
Date: Fri, 18 Nov 2011 09:21:30 +0100
Message-Id: <1321604559-10707-8-git-send-email-sgruszka@redhat.com> (sfid-20111118_092115_911922_90C40404)
In-Reply-To: <1321604559-10707-1-git-send-email-sgruszka@redhat.com>
References: <1321604559-10707-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlegacy/iwl-3945-debugfs.c |    6 +-
 drivers/net/wireless/iwlegacy/iwl-3945.c         |   48 ++++----
 drivers/net/wireless/iwlegacy/iwl-4965-debugfs.c |    6 +-
 drivers/net/wireless/iwlegacy/iwl-4965-eeprom.c  |    4 +-
 drivers/net/wireless/iwlegacy/iwl-4965-lib.c     |   16 ++--
 drivers/net/wireless/iwlegacy/iwl-4965-rs.c      |   22 ++--
 drivers/net/wireless/iwlegacy/iwl-4965-sta.c     |   22 ++--
 drivers/net/wireless/iwlegacy/iwl-4965-tx.c      |   32 +++---
 drivers/net/wireless/iwlegacy/iwl-4965-ucode.c   |    4 +-
 drivers/net/wireless/iwlegacy/iwl-4965.c         |   50 ++++----
 drivers/net/wireless/iwlegacy/iwl-core.c         |   64 +++++-----
 drivers/net/wireless/iwlegacy/iwl-debug.h        |    8 +-
 drivers/net/wireless/iwlegacy/iwl-debugfs.c      |   24 ++--
 drivers/net/wireless/iwlegacy/iwl-eeprom.c       |   10 +-
 drivers/net/wireless/iwlegacy/iwl-hcmd.c         |   14 +-
 drivers/net/wireless/iwlegacy/iwl-io.h           |    2 +-
 drivers/net/wireless/iwlegacy/iwl-led.c          |    2 +-
 drivers/net/wireless/iwlegacy/iwl-power.c        |    2 +-
 drivers/net/wireless/iwlegacy/iwl-scan.c         |    2 +-
 drivers/net/wireless/iwlegacy/iwl-sta.c          |   26 ++--
 drivers/net/wireless/iwlegacy/iwl-tx.c           |   12 +-
 drivers/net/wireless/iwlegacy/iwl3945-base.c     |  130 +++++++++++-----------
 drivers/net/wireless/iwlegacy/iwl4965-base.c     |  132 +++++++++++-----------
 23 files changed, 319 insertions(+), 319 deletions(-)

diff --git a/drivers/net/wireless/iwlegacy/iwl-3945-debugfs.c b/drivers/net/wireless/iwlegacy/iwl-3945-debugfs.c
index b767979..40e3a70 100644
--- a/drivers/net/wireless/iwlegacy/iwl-3945-debugfs.c
+++ b/drivers/net/wireless/iwlegacy/iwl-3945-debugfs.c
@@ -71,7 +71,7 @@ ssize_t il3945_ucode_rx_stats_read(struct file *file,
 
 	buf = kzalloc(bufsz, GFP_KERNEL);
 	if (!buf) {
-		IL_ERR(il, "Can not allocate Buffer\n");
+		IL_ERR("Can not allocate Buffer\n");
 		return -ENOMEM;
 	}
 
@@ -341,7 +341,7 @@ ssize_t il3945_ucode_tx_stats_read(struct file *file,
 
 	buf = kzalloc(bufsz, GFP_KERNEL);
 	if (!buf) {
-		IL_ERR(il, "Can not allocate Buffer\n");
+		IL_ERR("Can not allocate Buffer\n");
 		return -ENOMEM;
 	}
 
@@ -440,7 +440,7 @@ ssize_t il3945_ucode_general_stats_read(struct file *file,
 
 	buf = kzalloc(bufsz, GFP_KERNEL);
 	if (!buf) {
-		IL_ERR(il, "Can not allocate Buffer\n");
+		IL_ERR("Can not allocate Buffer\n");
 		return -ENOMEM;
 	}
 
diff --git a/drivers/net/wireless/iwlegacy/iwl-3945.c b/drivers/net/wireless/iwlegacy/iwl-3945.c
index a1e2a42..cf47fdb 100644
--- a/drivers/net/wireless/iwlegacy/iwl-3945.c
+++ b/drivers/net/wireless/iwlegacy/iwl-3945.c
@@ -166,7 +166,7 @@ void il3945_disable_events(struct il_priv *il)
 
 	base = le32_to_cpu(il->card_alive.log_event_table_ptr);
 	if (!il3945_hw_valid_rtc_data_addr(base)) {
-		IL_ERR(il, "Invalid event log pointer 0x%08X\n", base);
+		IL_ERR("Invalid event log pointer 0x%08X\n", base);
 		return;
 	}
 
@@ -317,7 +317,7 @@ static void il3945_rx_reply_tx(struct il_priv *il,
 	int fail;
 
 	if ((index >= txq->q.n_bd) || (il_queue_used(&txq->q, index) == 0)) {
-		IL_ERR(il, "Read index for DMA queue txq_id (%d) index %d "
+		IL_ERR("Read index for DMA queue txq_id (%d) index %d "
 			  "is out of range [0-%d] %d %d\n", txq_id,
 			  index, txq->q.n_bd, txq->q.write_ptr,
 			  txq->q.read_ptr);
@@ -350,7 +350,7 @@ static void il3945_rx_reply_tx(struct il_priv *il,
 	il3945_tx_queue_reclaim(il, txq_id, index);
 
 	if (status & TX_ABORT_REQUIRED_MSK)
-		IL_ERR(il, "TODO:  Implement Tx ABORT REQUIRED!!!\n");
+		IL_ERR("TODO:  Implement Tx ABORT REQUIRED!!!\n");
 }
 
 
@@ -484,7 +484,7 @@ static void il3945_pass_packet_to_mac80211(struct il_priv *il,
 
 	skb = dev_alloc_skb(128);
 	if (!skb) {
-		IL_ERR(il, "dev_alloc_skb failed\n");
+		IL_ERR("dev_alloc_skb failed\n");
 		return;
 	}
 
@@ -600,7 +600,7 @@ int il3945_hw_txq_attach_buf_to_tfd(struct il_priv *il,
 	count = TFD_CTL_COUNT_GET(le32_to_cpu(tfd->control_flags));
 
 	if ((count >= NUM_TFD_CHUNKS) || (count < 0)) {
-		IL_ERR(il, "Error can not send more than %d chunks\n",
+		IL_ERR("Error can not send more than %d chunks\n",
 			  NUM_TFD_CHUNKS);
 		return -EINVAL;
 	}
@@ -633,7 +633,7 @@ void il3945_hw_txq_free_tfd(struct il_priv *il, struct il_tx_queue *txq)
 	/* sanity check */
 	counter = TFD_CTL_COUNT_GET(le32_to_cpu(tfd->control_flags));
 	if (counter > NUM_TFD_CHUNKS) {
-		IL_ERR(il, "Too many chunks: %i\n", counter);
+		IL_ERR("Too many chunks: %i\n", counter);
 		/* @todo issue fatal error, it is quite serious situation */
 		return;
 	}
@@ -855,7 +855,7 @@ static int il3945_txq_ctx_reset(struct il_priv *il)
 		rc = il_tx_queue_init(il, &il->txq[txq_id],
 						slots_num, txq_id);
 		if (rc) {
-			IL_ERR(il, "Tx %d queue init failed\n", txq_id);
+			IL_ERR("Tx %d queue init failed\n", txq_id);
 			goto error;
 		}
 	}
@@ -971,7 +971,7 @@ int il3945_hw_nic_init(struct il_priv *il)
 	if (!rxq->bd) {
 		rc = il_rx_queue_alloc(il);
 		if (rc) {
-			IL_ERR(il, "Unable to initialize Rx queue\n");
+			IL_ERR("Unable to initialize Rx queue\n");
 			return -ENOMEM;
 		}
 	} else
@@ -1078,7 +1078,7 @@ static int il3945_hw_reg_txpower_get_temperature(struct il_priv *il)
 
 	/* handle insane temp reading */
 	if (il3945_hw_reg_temp_out_of_range(temperature)) {
-		IL_ERR(il, "Error bad temperature value  %d\n", temperature);
+		IL_ERR("Error bad temperature value  %d\n", temperature);
 
 		/* if really really hot(?),
 		 *   substitute the 3rd band/group's temp measured at factory */
@@ -1388,7 +1388,7 @@ static int il3945_send_tx_power(struct il_priv *il)
 	txpower.band = (il->band == IEEE80211_BAND_5GHZ) ? 0 : 1;
 	ch_info = il_get_channel_info(il, il->band, chan);
 	if (!ch_info) {
-		IL_ERR(il,
+		IL_ERR(
 			"Failed to get channel info for channel %d [%d]\n",
 			chan, il->band);
 		return -EINVAL;
@@ -1686,7 +1686,7 @@ static int il3945_send_rxon_assoc(struct il_priv *il,
 
 	pkt = (struct il_rx_packet *)cmd.reply_page;
 	if (pkt->hdr.flags & IL_CMD_FAILED_MSK) {
-		IL_ERR(il, "Bad return from REPLY_RXON_ASSOC command\n");
+		IL_ERR("Bad return from REPLY_RXON_ASSOC command\n");
 		rc = -EIO;
 	}
 
@@ -1727,7 +1727,7 @@ int il3945_commit_rxon(struct il_priv *il, struct il_rxon_context *ctx)
 
 	rc = il_check_rxon_cmd(il, ctx);
 	if (rc) {
-		IL_ERR(il, "Invalid RXON configuration.  Not committing.\n");
+		IL_ERR("Invalid RXON configuration.  Not committing.\n");
 		return -EINVAL;
 	}
 
@@ -1739,7 +1739,7 @@ int il3945_commit_rxon(struct il_priv *il, struct il_rxon_context *ctx)
 		rc = il_send_rxon_assoc(il,
 					 &il->contexts[IL_RXON_CTX_BSS]);
 		if (rc) {
-			IL_ERR(il, "Error setting RXON_ASSOC "
+			IL_ERR("Error setting RXON_ASSOC "
 				  "configuration (%d).\n", rc);
 			return rc;
 		}
@@ -1775,7 +1775,7 @@ int il3945_commit_rxon(struct il_priv *il, struct il_rxon_context *ctx)
 		 * active_rxon back to what it was previously */
 		if (rc) {
 			active_rxon->filter_flags |= RXON_FILTER_ASSOC_MSK;
-			IL_ERR(il, "Error clearing ASSOC_MSK on current "
+			IL_ERR("Error clearing ASSOC_MSK on current "
 				  "configuration (%d).\n", rc);
 			return rc;
 		}
@@ -1807,7 +1807,7 @@ int il3945_commit_rxon(struct il_priv *il, struct il_rxon_context *ctx)
 			      sizeof(struct il3945_rxon_cmd),
 			      staging_rxon);
 	if (rc) {
-		IL_ERR(il, "Error setting new configuration (%d).\n", rc);
+		IL_ERR("Error setting new configuration (%d).\n", rc);
 		return rc;
 	}
 
@@ -1824,14 +1824,14 @@ int il3945_commit_rxon(struct il_priv *il, struct il_rxon_context *ctx)
 	 * send a new TXPOWER command or we won't be able to Tx any frames */
 	rc = il_set_tx_power(il, il->tx_power_next, true);
 	if (rc) {
-		IL_ERR(il, "Error setting Tx power (%d).\n", rc);
+		IL_ERR("Error setting Tx power (%d).\n", rc);
 		return rc;
 	}
 
 	/* Init the hardware's rate fallback order based on the band */
 	rc = il3945_init_hw_rate_table(il);
 	if (rc) {
-		IL_ERR(il, "Error setting HW rate table: %02X\n", rc);
+		IL_ERR("Error setting HW rate table: %02X\n", rc);
 		return -EIO;
 	}
 
@@ -1989,7 +1989,7 @@ static void il3945_hw_reg_init_channel_groups(struct il_priv *il)
 
 		/* sanity check on factory saturation power value */
 		if (group->saturation_power < 40) {
-			IL_WARN(il, "Error: saturation power is %d, "
+			IL_WARN("Error: saturation power is %d, "
 				    "less than minimum expected 40\n",
 				    group->saturation_power);
 			return;
@@ -2119,7 +2119,7 @@ int il3945_txpower_set_from_eeprom(struct il_priv *il)
 							 ch_info->group_index,
 							 &power_idx);
 			if (rc) {
-				IL_ERR(il, "Invalid power index\n");
+				IL_ERR("Invalid power index\n");
 				return rc;
 			}
 			pwr_info->base_power_index = (u8) power_idx;
@@ -2187,7 +2187,7 @@ int il3945_hw_rxq_stop(struct il_priv *il)
 	rc = il_poll_direct_bit(il, FH39_RSSR_STATUS,
 			FH39_RSSR_CHNL0_RX_STATUS_CHNL_IDLE, 1000);
 	if (rc < 0)
-		IL_ERR(il, "Can't stop Rx DMA.\n");
+		IL_ERR("Can't stop Rx DMA.\n");
 
 	return 0;
 }
@@ -2263,7 +2263,7 @@ static int il3945_add_bssid_station(struct il_priv *il,
 
 	ret = il_add_station_common(il, ctx, addr, 0, NULL, &sta_id);
 	if (ret) {
-		IL_ERR(il, "Unable to add station %pM\n", addr);
+		IL_ERR("Unable to add station %pM\n", addr);
 		return ret;
 	}
 
@@ -2390,7 +2390,7 @@ int il3945_hw_set_hw_params(struct il_priv *il)
 				   sizeof(struct il3945_shared),
 				   &il->_3945.shared_phys, GFP_KERNEL);
 	if (!il->_3945.shared_virt) {
-		IL_ERR(il, "failed to allocate pci memory\n");
+		IL_ERR("failed to allocate pci memory\n");
 		return -ENOMEM;
 	}
 
@@ -2481,7 +2481,7 @@ static int il3945_verify_bsm(struct il_priv *il)
 	     reg += sizeof(u32), image++) {
 		val = il_read_prph(il, reg);
 		if (val != le32_to_cpu(*image)) {
-			IL_ERR(il, "BSM uCode verification failed at "
+			IL_ERR("BSM uCode verification failed at "
 				  "addr 0x%08X+%u (of %u), is 0x%x, s/b 0x%x\n",
 				  BSM_SRAM_LOWER_BOUND,
 				  reg - BSM_SRAM_LOWER_BOUND, len,
@@ -2620,7 +2620,7 @@ static int il3945_load_bsm(struct il_priv *il)
 	if (i < 100)
 		D_INFO("BSM write complete, poll %d iterations\n", i);
 	else {
-		IL_ERR(il, "BSM write did not complete!\n");
+		IL_ERR("BSM write did not complete!\n");
 		return -EIO;
 	}
 
diff --git a/drivers/net/wireless/iwlegacy/iwl-4965-debugfs.c b/drivers/net/wireless/iwlegacy/iwl-4965-debugfs.c
index 8ea0ac2..ebb71a6 100644
--- a/drivers/net/wireless/iwlegacy/iwl-4965-debugfs.c
+++ b/drivers/net/wireless/iwlegacy/iwl-4965-debugfs.c
@@ -75,7 +75,7 @@ ssize_t il4965_ucode_rx_stats_read(struct file *file, char __user *user_buf,
 
 	buf = kzalloc(bufsz, GFP_KERNEL);
 	if (!buf) {
-		IL_ERR(il, "Can not allocate Buffer\n");
+		IL_ERR("Can not allocate Buffer\n");
 		return -ENOMEM;
 	}
 
@@ -501,7 +501,7 @@ ssize_t il4965_ucode_tx_stats_read(struct file *file,
 
 	buf = kzalloc(bufsz, GFP_KERNEL);
 	if (!buf) {
-		IL_ERR(il, "Can not allocate Buffer\n");
+		IL_ERR("Can not allocate Buffer\n");
 		return -ENOMEM;
 	}
 
@@ -679,7 +679,7 @@ il4965_ucode_general_stats_read(struct file *file, char __user *user_buf,
 
 	buf = kzalloc(bufsz, GFP_KERNEL);
 	if (!buf) {
-		IL_ERR(il, "Can not allocate Buffer\n");
+		IL_ERR("Can not allocate Buffer\n");
 		return -ENOMEM;
 	}
 
diff --git a/drivers/net/wireless/iwlegacy/iwl-4965-eeprom.c b/drivers/net/wireless/iwlegacy/iwl-4965-eeprom.c
index ef8b0d5..016472d 100644
--- a/drivers/net/wireless/iwlegacy/iwl-4965-eeprom.c
+++ b/drivers/net/wireless/iwlegacy/iwl-4965-eeprom.c
@@ -129,12 +129,12 @@ int il4965_eeprom_check_version(struct il_priv *il)
 	    calib_ver < il->cfg->eeprom_calib_ver)
 		goto err;
 
-	IL_INFO(il, "device EEPROM VER=0x%x, CALIB=0x%x\n",
+	IL_INFO("device EEPROM VER=0x%x, CALIB=0x%x\n",
 		 eeprom_ver, calib_ver);
 
 	return 0;
 err:
-	IL_ERR(il, "Unsupported (too old) EEPROM VER=0x%x < 0x%x "
+	IL_ERR("Unsupported (too old) EEPROM VER=0x%x < 0x%x "
 		  "CALIB=0x%x < 0x%x\n",
 		  eeprom_ver, il->cfg->eeprom_ver,
 		  calib_ver,  il->cfg->eeprom_calib_ver);
diff --git a/drivers/net/wireless/iwlegacy/iwl-4965-lib.c b/drivers/net/wireless/iwlegacy/iwl-4965-lib.c
index b51ae3d..f4df28d 100644
--- a/drivers/net/wireless/iwlegacy/iwl-4965-lib.c
+++ b/drivers/net/wireless/iwlegacy/iwl-4965-lib.c
@@ -44,7 +44,7 @@ void il4965_check_abort_status(struct il_priv *il,
 			    u8 frame_count, u32 status)
 {
 	if (frame_count == 1 && status == TX_STATUS_FAIL_RFKILL_FLUSH) {
-		IL_ERR(il, "Tx flush command to flush out all frames\n");
+		IL_ERR("Tx flush command to flush out all frames\n");
 		if (!test_bit(STATUS_EXIT_PENDING, &il->status))
 			queue_work(il->workqueue, &il->tx_flush);
 	}
@@ -176,7 +176,7 @@ int il4965_hw_nic_init(struct il_priv *il)
 	if (!rxq->bd) {
 		ret = il_rx_queue_alloc(il);
 		if (ret) {
-			IL_ERR(il, "Unable to initialize Rx queue\n");
+			IL_ERR("Unable to initialize Rx queue\n");
 			return -ENOMEM;
 		}
 	} else
@@ -309,7 +309,7 @@ static void il4965_rx_allocate(struct il_priv *il, gfp_t priority)
 
 			if ((rxq->free_count <= RX_LOW_WATERMARK) &&
 			    net_ratelimit())
-				IL_CRIT(il,
+				IL_CRIT(
 					"Failed to alloc_pages with %s. "
 					"Only %u free buffers remaining.\n",
 					 priority == GFP_ATOMIC ?
@@ -549,7 +549,7 @@ static void il4965_pass_packet_to_mac80211(struct il_priv *il,
 
 	skb = dev_alloc_skb(128);
 	if (!skb) {
-		IL_ERR(il, "dev_alloc_skb failed\n");
+		IL_ERR("dev_alloc_skb failed\n");
 		return;
 	}
 
@@ -598,7 +598,7 @@ void il4965_rx_reply_rx(struct il_priv *il,
 		ampdu_status = le32_to_cpu(rx_pkt_status);
 	} else {
 		if (!il->_4965.last_phy_res_valid) {
-			IL_ERR(il, "MPDU frame without cached PHY data\n");
+			IL_ERR("MPDU frame without cached PHY data\n");
 			return;
 		}
 		phy_res = &il->_4965.last_phy_res;
@@ -880,7 +880,7 @@ int il4965_request_scan(struct il_priv *il, struct ieee80211_vif *vif)
 		rate = IL_RATE_6M_PLCP;
 		break;
 	default:
-		IL_WARN(il, "Invalid scan band\n");
+		IL_WARN("Invalid scan band\n");
 		return -EIO;
 	}
 
@@ -1184,9 +1184,9 @@ int il4965_dump_fh(struct il_priv *il, char **buf, bool display)
 		return pos;
 	}
 #endif
-	IL_ERR(il, "FH register values:\n");
+	IL_ERR("FH register values:\n");
 	for (i = 0; i <  ARRAY_SIZE(fh_tbl); i++) {
-		IL_ERR(il, "  %34s: 0X%08x\n",
+		IL_ERR("  %34s: 0X%08x\n",
 			il4965_get_fh_string(fh_tbl[i]),
 			il_read_direct32(il, fh_tbl[i]));
 	}
diff --git a/drivers/net/wireless/iwlegacy/iwl-4965-rs.c b/drivers/net/wireless/iwlegacy/iwl-4965-rs.c
index b53cf1b..93bb31d 100644
--- a/drivers/net/wireless/iwlegacy/iwl-4965-rs.c
+++ b/drivers/net/wireless/iwlegacy/iwl-4965-rs.c
@@ -367,12 +367,12 @@ static int il4965_rs_tl_turn_on_agg_for_tid(struct il_priv *il,
 			 * this might be cause by reloading firmware
 			 * stop the tx ba session here
 			 */
-			IL_ERR(il, "Fail start Tx agg on tid: %d\n",
+			IL_ERR("Fail start Tx agg on tid: %d\n",
 				tid);
 			ieee80211_stop_tx_ba_session(sta, tid);
 		}
 	} else {
-		IL_ERR(il, "Aggregation not enabled for tid %d "
+		IL_ERR("Aggregation not enabled for tid %d "
 			"because load = %u\n", tid, load);
 	}
 	return ret;
@@ -385,7 +385,7 @@ static void il4965_rs_tl_turn_on_agg(struct il_priv *il, u8 tid,
 	if (tid < TID_MAX_LOAD_COUNT)
 		il4965_rs_tl_turn_on_agg_for_tid(il, lq_data, tid, sta);
 	else
-		IL_ERR(il, "tid exceeds max load count: %d/%d\n",
+		IL_ERR("tid exceeds max load count: %d/%d\n",
 			tid, TID_MAX_LOAD_COUNT);
 }
 
@@ -505,7 +505,7 @@ static u32 il4965_rate_n_flags_from_tbl(struct il_priv *il,
 
 	} else if (is_Ht(tbl->lq_type)) {
 		if (index > IL_LAST_OFDM_RATE) {
-			IL_ERR(il, "Invalid HT rate index %d\n", index);
+			IL_ERR("Invalid HT rate index %d\n", index);
 			index = IL_LAST_OFDM_RATE;
 		}
 		rate_n_flags = RATE_MCS_HT_MSK;
@@ -515,7 +515,7 @@ static u32 il4965_rate_n_flags_from_tbl(struct il_priv *il,
 		else
 			rate_n_flags |=	il_rates[index].plcp_mimo2;
 	} else {
-		IL_ERR(il, "Invalid tbl->lq_type %d\n", tbl->lq_type);
+		IL_ERR("Invalid tbl->lq_type %d\n", tbl->lq_type);
 	}
 
 	rate_n_flags |= ((tbl->ant_type << RATE_MCS_ANT_POS) &
@@ -535,7 +535,7 @@ static u32 il4965_rate_n_flags_from_tbl(struct il_priv *il,
 			rate_n_flags |= RATE_MCS_GF_MSK;
 			if (is_siso(tbl->lq_type) && tbl->is_SGI) {
 				rate_n_flags &= ~RATE_MCS_SGI_MSK;
-				IL_ERR(il, "GF was set with SGI:SISO\n");
+				IL_ERR("GF was set with SGI:SISO\n");
 			}
 		}
 	}
@@ -1480,7 +1480,7 @@ static int il4965_rs_move_siso_to_other(struct il_priv *il,
 				if (!tbl->is_SGI)
 					break;
 				else
-					IL_ERR(il,
+					IL_ERR(
 						"SGI was set in GF+SISO\n");
 			}
 			search_tbl->is_SGI = !tbl->is_SGI;
@@ -1851,7 +1851,7 @@ static void il4965_rs_rate_scale_perform(struct il_priv *il,
 		rate_scale_index_msk = rate_mask;
 
 	if (!((1 << index) & rate_scale_index_msk)) {
-		IL_ERR(il, "Current Rate is not valid\n");
+		IL_ERR("Current Rate is not valid\n");
 		if (lq_sta->search_better_tbl) {
 			/* revert to active table if search table is not valid*/
 			tbl->lq_type = LQ_NONE;
@@ -1867,7 +1867,7 @@ static void il4965_rs_rate_scale_perform(struct il_priv *il,
 
 	/* Get expected throughput table and history window for current rate */
 	if (!tbl->expected_tpt) {
-		IL_ERR(il, "tbl->expected_tpt is NULL\n");
+		IL_ERR("tbl->expected_tpt is NULL\n");
 		return;
 	}
 
@@ -1909,7 +1909,7 @@ static void il4965_rs_rate_scale_perform(struct il_priv *il,
 	 * actual average throughput */
 	if (window->average_tpt != ((window->success_ratio *
 			tbl->expected_tpt[index] + 64) / 128)) {
-		IL_ERR(il,
+		IL_ERR(
 			 "expected_tpt should have been calculated by now\n");
 		window->average_tpt = ((window->success_ratio *
 					tbl->expected_tpt[index] + 64) / 128);
@@ -2590,7 +2590,7 @@ static void il4965_rs_dbgfs_set_mcs(struct il_lq_sta *lq_sta,
 			D_RATE("Fixed rate ON\n");
 		} else {
 			lq_sta->dbg_fixed_rate = 0;
-			IL_ERR(il,
+			IL_ERR(
 			    "Invalid antenna selection 0x%X, Valid is 0x%X\n",
 			    ant_sel_tx, valid_tx_ant);
 			D_RATE("Fixed rate OFF\n");
diff --git a/drivers/net/wireless/iwlegacy/iwl-4965-sta.c b/drivers/net/wireless/iwlegacy/iwl-4965-sta.c
index 3019baf..a82d444 100644
--- a/drivers/net/wireless/iwlegacy/iwl-4965-sta.c
+++ b/drivers/net/wireless/iwlegacy/iwl-4965-sta.c
@@ -44,7 +44,7 @@ il4965_sta_alloc_lq(struct il_priv *il, u8 sta_id)
 
 	link_cmd = kzalloc(sizeof(struct il_link_quality_cmd), GFP_KERNEL);
 	if (!link_cmd) {
-		IL_ERR(il, "Unable to allocate memory for LQ cmd.\n");
+		IL_ERR("Unable to allocate memory for LQ cmd.\n");
 		return NULL;
 	}
 	/* Set up the rate scaling to start at selected rate, fall back
@@ -105,7 +105,7 @@ il4965_add_bssid_station(struct il_priv *il, struct il_rxon_context *ctx,
 
 	ret = il_add_station_common(il, ctx, addr, 0, NULL, &sta_id);
 	if (ret) {
-		IL_ERR(il, "Unable to add station %pM\n", addr);
+		IL_ERR("Unable to add station %pM\n", addr);
 		return ret;
 	}
 
@@ -119,7 +119,7 @@ il4965_add_bssid_station(struct il_priv *il, struct il_rxon_context *ctx,
 	/* Set up default rate scaling table in device's station table */
 	link_cmd = il4965_sta_alloc_lq(il, sta_id);
 	if (!link_cmd) {
-		IL_ERR(il,
+		IL_ERR(
 			"Unable to initialize rate scaling for station %pM.\n",
 			addr);
 		return -ENOMEM;
@@ -127,7 +127,7 @@ il4965_add_bssid_station(struct il_priv *il, struct il_rxon_context *ctx,
 
 	ret = il_send_lq_cmd(il, ctx, link_cmd, CMD_SYNC, true);
 	if (ret)
-		IL_ERR(il, "Link quality command failed (%d)\n", ret);
+		IL_ERR("Link quality command failed (%d)\n", ret);
 
 	spin_lock_irqsave(&il->sta_lock, flags);
 	il->stations[sta_id].lq = link_cmd;
@@ -467,7 +467,7 @@ int il4965_remove_dynamic_key(struct il_priv *il,
 	}
 
 	if (il->stations[sta_id].sta.key.key_offset == WEP_INVALID_OFFSET) {
-		IL_WARN(il, "Removing wrong key %d 0x%x\n",
+		IL_WARN("Removing wrong key %d 0x%x\n",
 			    keyconf->keyidx, key_flags);
 		spin_unlock_irqrestore(&il->sta_lock, flags);
 		return 0;
@@ -475,7 +475,7 @@ int il4965_remove_dynamic_key(struct il_priv *il,
 
 	if (!test_and_clear_bit(il->stations[sta_id].sta.key.key_offset,
 		&il->ucode_key_table))
-		IL_ERR(il, "index %d not used in uCode key table.\n",
+		IL_ERR("index %d not used in uCode key table.\n",
 			il->stations[sta_id].sta.key.key_offset);
 	memset(&il->stations[sta_id].keyinfo, 0,
 					sizeof(struct il_hw_key));
@@ -525,7 +525,7 @@ int il4965_set_dynamic_key(struct il_priv *il, struct il_rxon_context *ctx,
 							keyconf, sta_id);
 		break;
 	default:
-		IL_ERR(il,
+		IL_ERR(
 			"Unknown alg: %s cipher = %x\n", __func__,
 			keyconf->cipher);
 		ret = -EINVAL;
@@ -557,7 +557,7 @@ int il4965_alloc_bcast_station(struct il_priv *il,
 	sta_id = il_prep_station(il, ctx, il_bcast_addr,
 								false, NULL);
 	if (sta_id == IL_INVALID_STATION) {
-		IL_ERR(il, "Unable to prepare broadcast station\n");
+		IL_ERR("Unable to prepare broadcast station\n");
 		spin_unlock_irqrestore(&il->sta_lock, flags);
 
 		return -EINVAL;
@@ -569,7 +569,7 @@ int il4965_alloc_bcast_station(struct il_priv *il,
 
 	link_cmd = il4965_sta_alloc_lq(il, sta_id);
 	if (!link_cmd) {
-		IL_ERR(il,
+		IL_ERR(
 			"Unable to initialize rate scaling for bcast station.\n");
 		return -ENOMEM;
 	}
@@ -596,7 +596,7 @@ static int il4965_update_bcast_station(struct il_priv *il,
 
 	link_cmd = il4965_sta_alloc_lq(il, sta_id);
 	if (!link_cmd) {
-		IL_ERR(il,
+		IL_ERR(
 		"Unable to initialize rate scaling for bcast station.\n");
 		return -ENOMEM;
 	}
@@ -686,7 +686,7 @@ int il4965_sta_rx_agg_stop(struct il_priv *il, struct ieee80211_sta *sta,
 
 	sta_id = il_sta_id(sta);
 	if (sta_id == IL_INVALID_STATION) {
-		IL_ERR(il, "Invalid station for AGG tid %d\n", tid);
+		IL_ERR("Invalid station for AGG tid %d\n", tid);
 		return -ENXIO;
 	}
 
diff --git a/drivers/net/wireless/iwlegacy/iwl-4965-tx.c b/drivers/net/wireless/iwlegacy/iwl-4965-tx.c
index efc21be..66dd172 100644
--- a/drivers/net/wireless/iwlegacy/iwl-4965-tx.c
+++ b/drivers/net/wireless/iwlegacy/iwl-4965-tx.c
@@ -258,7 +258,7 @@ static void il4965_tx_cmd_build_hwcrypto(struct il_priv *il,
 		break;
 
 	default:
-		IL_ERR(il, "Unknown encode cipher %x\n", keyconf->cipher);
+		IL_ERR("Unknown encode cipher %x\n", keyconf->cipher);
 		break;
 	}
 }
@@ -619,13 +619,13 @@ int il4965_txq_ctx_alloc(struct il_priv *il)
 	ret = il4965_alloc_dma_ptr(il, &il->scd_bc_tbls,
 				il->hw_params.scd_bc_tbls_size);
 	if (ret) {
-		IL_ERR(il, "Scheduler BC Table allocation failed\n");
+		IL_ERR("Scheduler BC Table allocation failed\n");
 		goto error_bc_tbls;
 	}
 	/* Alloc keep-warm buffer */
 	ret = il4965_alloc_dma_ptr(il, &il->kw, IL_KW_SIZE);
 	if (ret) {
-		IL_ERR(il, "Keep Warm allocation failed\n");
+		IL_ERR("Keep Warm allocation failed\n");
 		goto error_kw;
 	}
 
@@ -652,7 +652,7 @@ int il4965_txq_ctx_alloc(struct il_priv *il)
 					&il->txq[txq_id], slots_num,
 				       txq_id);
 		if (ret) {
-			IL_ERR(il, "Tx %d queue init failed\n", txq_id);
+			IL_ERR("Tx %d queue init failed\n", txq_id);
 			goto error;
 		}
 	}
@@ -712,7 +712,7 @@ void il4965_txq_ctx_stop(struct il_priv *il)
 		if (il_poll_direct_bit(il, FH_TSSR_TX_STATUS_REG,
 				    FH_TSSR_TX_STATUS_REG_MSK_CHNL_IDLE(ch),
 				    1000))
-			IL_ERR(il, "Failing on timeout while stopping"
+			IL_ERR("Failing on timeout while stopping"
 			    " DMA channel %d [0x%08x]", ch,
 			    il_read_direct32(il,
 					FH_TSSR_TX_STATUS_REG));
@@ -803,7 +803,7 @@ static int il4965_txq_agg_enable(struct il_priv *il, int txq_id,
 	if ((IWL49_FIRST_AMPDU_QUEUE > txq_id) ||
 	    (IWL49_FIRST_AMPDU_QUEUE +
 		il->cfg->base_params->num_of_ampdu_queues <= txq_id)) {
-		IL_WARN(il,
+		IL_WARN(
 			"queue number out of range: %d, must be %d to %d\n",
 			txq_id, IWL49_FIRST_AMPDU_QUEUE,
 			IWL49_FIRST_AMPDU_QUEUE +
@@ -871,25 +871,25 @@ int il4965_tx_agg_start(struct il_priv *il, struct ieee80211_vif *vif,
 	if (unlikely(tx_fifo < 0))
 		return tx_fifo;
 
-	IL_WARN(il, "%s on ra = %pM tid = %d\n",
+	IL_WARN("%s on ra = %pM tid = %d\n",
 			__func__, sta->addr, tid);
 
 	sta_id = il_sta_id(sta);
 	if (sta_id == IL_INVALID_STATION) {
-		IL_ERR(il, "Start AGG on invalid station\n");
+		IL_ERR("Start AGG on invalid station\n");
 		return -ENXIO;
 	}
 	if (unlikely(tid >= MAX_TID_COUNT))
 		return -EINVAL;
 
 	if (il->stations[sta_id].tid[tid].agg.state != IL_AGG_OFF) {
-		IL_ERR(il, "Start AGG when state is not IL_AGG_OFF !\n");
+		IL_ERR("Start AGG when state is not IL_AGG_OFF !\n");
 		return -ENXIO;
 	}
 
 	txq_id = il4965_txq_ctx_activate_free(il);
 	if (txq_id == -1) {
-		IL_ERR(il, "No free aggregation queue available\n");
+		IL_ERR("No free aggregation queue available\n");
 		return -ENXIO;
 	}
 
@@ -932,7 +932,7 @@ static int il4965_txq_agg_disable(struct il_priv *il, u16 txq_id,
 	if ((IWL49_FIRST_AMPDU_QUEUE > txq_id) ||
 	    (IWL49_FIRST_AMPDU_QUEUE +
 		il->cfg->base_params->num_of_ampdu_queues <= txq_id)) {
-		IL_WARN(il,
+		IL_WARN(
 			"queue number out of range: %d, must be %d to %d\n",
 			txq_id, IWL49_FIRST_AMPDU_QUEUE,
 			IWL49_FIRST_AMPDU_QUEUE +
@@ -973,7 +973,7 @@ int il4965_tx_agg_stop(struct il_priv *il, struct ieee80211_vif *vif,
 	sta_id = il_sta_id(sta);
 
 	if (sta_id == IL_INVALID_STATION) {
-		IL_ERR(il, "Invalid station for AGG tid %d\n", tid);
+		IL_ERR("Invalid station for AGG tid %d\n", tid);
 		return -ENXIO;
 	}
 
@@ -996,7 +996,7 @@ int il4965_tx_agg_stop(struct il_priv *il, struct ieee80211_vif *vif,
 	case IL_AGG_ON:
 		break;
 	default:
-		IL_WARN(il, "Stopping AGG while state not ON or starting\n");
+		IL_WARN("Stopping AGG while state not ON or starting\n");
 	}
 
 	write_ptr = il->txq[txq_id].q.write_ptr;
@@ -1115,7 +1115,7 @@ int il4965_tx_queue_reclaim(struct il_priv *il, int txq_id, int index)
 	struct ieee80211_hdr *hdr;
 
 	if ((index >= q->n_bd) || (il_queue_used(q, index) == 0)) {
-		IL_ERR(il, "Read index for DMA queue txq id (%d), index %d, "
+		IL_ERR("Read index for DMA queue txq id (%d), index %d, "
 			  "is out of range [0-%d] %d %d.\n", txq_id,
 			  index, q->n_bd, q->write_ptr, q->read_ptr);
 		return 0;
@@ -1163,7 +1163,7 @@ static int il4965_tx_status_reply_compressed_ba(struct il_priv *il,
 
 	if (unlikely(!agg->wait_for_ba))  {
 		if (unlikely(ba_resp->bitmap))
-			IL_ERR(il, "Received BA when not expected\n");
+			IL_ERR("Received BA when not expected\n");
 		return -EINVAL;
 	}
 
@@ -1266,7 +1266,7 @@ void il4965_rx_reply_compressed_ba(struct il_priv *il,
 	u16 ba_resp_scd_ssn = le16_to_cpu(ba_resp->scd_ssn);
 
 	if (scd_flow >= il->hw_params.max_txq_num) {
-		IL_ERR(il,
+		IL_ERR(
 			"BUG_ON scd_flow is bigger than number of queues\n");
 		return;
 	}
diff --git a/drivers/net/wireless/iwlegacy/iwl-4965-ucode.c b/drivers/net/wireless/iwlegacy/iwl-4965-ucode.c
index d1e1775..3fa939e 100644
--- a/drivers/net/wireless/iwlegacy/iwl-4965-ucode.c
+++ b/drivers/net/wireless/iwlegacy/iwl-4965-ucode.c
@@ -99,7 +99,7 @@ static int il4965_verify_inst_full(struct il_priv *il, __le32 *image,
 		 * if IL_DL_IO is set */
 		val = _il_read_direct32(il, HBUS_TARG_MEM_RDAT);
 		if (val != le32_to_cpu(*image)) {
-			IL_ERR(il, "uCode INST section is invalid at "
+			IL_ERR("uCode INST section is invalid at "
 				  "offset 0x%x, is 0x%x, s/b 0x%x\n",
 				  save_len - len, val, le32_to_cpu(*image));
 			ret = -EIO;
@@ -153,7 +153,7 @@ int il4965_verify_ucode(struct il_priv *il)
 		return 0;
 	}
 
-	IL_ERR(il, "NO VALID UCODE IMAGE IN INSTRUCTION SRAM!!\n");
+	IL_ERR("NO VALID UCODE IMAGE IN INSTRUCTION SRAM!!\n");
 
 	/* Since nothing seems to match, show first several data entries in
 	 * instruction SRAM, so maybe visual inspection will give a clue.
diff --git a/drivers/net/wireless/iwlegacy/iwl-4965.c b/drivers/net/wireless/iwlegacy/iwl-4965.c
index cc28e0e..7b422f2 100644
--- a/drivers/net/wireless/iwlegacy/iwl-4965.c
+++ b/drivers/net/wireless/iwlegacy/iwl-4965.c
@@ -78,7 +78,7 @@ static int il4965_verify_bsm(struct il_priv *il)
 	     reg += sizeof(u32), image++) {
 		val = il_read_prph(il, reg);
 		if (val != le32_to_cpu(*image)) {
-			IL_ERR(il, "BSM uCode verification failed at "
+			IL_ERR("BSM uCode verification failed at "
 				  "addr 0x%08X+%u (of %u), is 0x%x, s/b 0x%x\n",
 				  BSM_SRAM_LOWER_BOUND,
 				  reg - BSM_SRAM_LOWER_BOUND, len,
@@ -191,7 +191,7 @@ static int il4965_load_bsm(struct il_priv *il)
 	if (i < 100)
 		D_INFO("BSM write complete, poll %d iterations\n", i);
 	else {
-		IL_ERR(il, "BSM write did not complete!\n");
+		IL_ERR("BSM write did not complete!\n");
 		return -EIO;
 	}
 
@@ -343,7 +343,7 @@ static void il4965_chain_noise_reset(struct il_priv *il)
 		cmd.diff_gain_c = 0;
 		if (il_send_cmd_pdu(il, REPLY_PHY_CALIBRATION_CMD,
 				 sizeof(cmd), &cmd))
-			IL_ERR(il,
+			IL_ERR(
 				"Could not send REPLY_PHY_CALIBRATION_CMD\n");
 		data->state = IL_CHAIN_NOISE_ACCUMULATE;
 		D_CALIB("Run chain_noise_calibrate\n");
@@ -548,7 +548,7 @@ static int il4965_interpolate_chan(struct il_priv *il, u32 channel,
 
 	s = il4965_get_sub_band(il, channel);
 	if (s >= EEPROM_TX_POWER_BANDS) {
-		IL_ERR(il, "Tx Power can not find channel %d\n", channel);
+		IL_ERR("Tx Power can not find channel %d\n", channel);
 		return -1;
 	}
 
@@ -912,7 +912,7 @@ static int il4965_fill_txpower_tbl(struct il_priv *il, u8 band, u16 channel,
 	 *   and 2) mimo txpower balance between Tx chains. */
 	txatten_grp = il4965_get_tx_atten_grp(channel);
 	if (txatten_grp < 0) {
-		IL_ERR(il, "Can't find txatten group for channel %d.\n",
+		IL_ERR("Can't find txatten group for channel %d.\n",
 			  channel);
 		return txatten_grp;
 	}
@@ -1078,12 +1078,12 @@ static int il4965_fill_txpower_tbl(struct il_priv *il, u8 band, u16 channel,
 
 			/* stay within the table! */
 			if (power_index > 107) {
-				IL_WARN(il, "txpower index %d > 107\n",
+				IL_WARN("txpower index %d > 107\n",
 					    power_index);
 				power_index = 107;
 			}
 			if (power_index < 0) {
-				IL_WARN(il, "txpower index %d < 0\n",
+				IL_WARN("txpower index %d < 0\n",
 					    power_index);
 				power_index = 0;
 			}
@@ -1207,7 +1207,7 @@ static int il4965_commit_rxon(struct il_priv *il, struct il_rxon_context *ctx)
 
 	ret = il_check_rxon_cmd(il, ctx);
 	if (ret) {
-		IL_ERR(il, "Invalid RXON configuration.  Not committing.\n");
+		IL_ERR("Invalid RXON configuration.  Not committing.\n");
 		return -EINVAL;
 	}
 
@@ -1228,7 +1228,7 @@ static int il4965_commit_rxon(struct il_priv *il, struct il_rxon_context *ctx)
 	if (!il_full_rxon_required(il, ctx)) {
 		ret = il_send_rxon_assoc(il, ctx);
 		if (ret) {
-			IL_ERR(il, "Error setting RXON_ASSOC (%d)\n", ret);
+			IL_ERR("Error setting RXON_ASSOC (%d)\n", ret);
 			return ret;
 		}
 
@@ -1258,14 +1258,14 @@ static int il4965_commit_rxon(struct il_priv *il, struct il_rxon_context *ctx)
 		 * active_rxon back to what it was previously */
 		if (ret) {
 			active_rxon->filter_flags |= RXON_FILTER_ASSOC_MSK;
-			IL_ERR(il, "Error clearing ASSOC_MSK (%d)\n", ret);
+			IL_ERR("Error clearing ASSOC_MSK (%d)\n", ret);
 			return ret;
 		}
 		il_clear_ucode_stations(il, ctx);
 		il_restore_stations(il, ctx);
 		ret = il4965_restore_default_wep_keys(il, ctx);
 		if (ret) {
-			IL_ERR(il, "Failed to restore WEP keys (%d)\n", ret);
+			IL_ERR("Failed to restore WEP keys (%d)\n", ret);
 			return ret;
 		}
 	}
@@ -1289,7 +1289,7 @@ static int il4965_commit_rxon(struct il_priv *il, struct il_rxon_context *ctx)
 		ret = il_send_cmd_pdu(il, ctx->rxon_cmd,
 			      sizeof(struct il_rxon_cmd), &ctx->staging);
 		if (ret) {
-			IL_ERR(il, "Error setting new RXON (%d)\n", ret);
+			IL_ERR("Error setting new RXON (%d)\n", ret);
 			return ret;
 		}
 		D_INFO("Return from !new_assoc RXON.\n");
@@ -1298,7 +1298,7 @@ static int il4965_commit_rxon(struct il_priv *il, struct il_rxon_context *ctx)
 		il_restore_stations(il, ctx);
 		ret = il4965_restore_default_wep_keys(il, ctx);
 		if (ret) {
-			IL_ERR(il, "Failed to restore WEP keys (%d)\n", ret);
+			IL_ERR("Failed to restore WEP keys (%d)\n", ret);
 			return ret;
 		}
 	}
@@ -1310,7 +1310,7 @@ static int il4965_commit_rxon(struct il_priv *il, struct il_rxon_context *ctx)
 		ret = il_send_cmd_pdu(il, ctx->rxon_cmd,
 			      sizeof(struct il_rxon_cmd), &ctx->staging);
 		if (ret) {
-			IL_ERR(il, "Error setting new RXON (%d)\n", ret);
+			IL_ERR("Error setting new RXON (%d)\n", ret);
 			return ret;
 		}
 		memcpy(active_rxon, &ctx->staging, sizeof(*active_rxon));
@@ -1323,7 +1323,7 @@ static int il4965_commit_rxon(struct il_priv *il, struct il_rxon_context *ctx)
 	 * send a new TXPOWER command or we won't be able to Tx any frames */
 	ret = il_set_tx_power(il, il->tx_power_next, true);
 	if (ret) {
-		IL_ERR(il, "Error sending TX power (%d)\n", ret);
+		IL_ERR("Error sending TX power (%d)\n", ret);
 		return ret;
 	}
 
@@ -1393,7 +1393,7 @@ static int il4965_hw_channel_switch(struct il_priv *il,
 	if (ch_info)
 		cmd.expect_beacon = il_is_channel_radar(ch_info);
 	else {
-		IL_ERR(il, "invalid channel switch from %u to %u\n",
+		IL_ERR("invalid channel switch from %u to %u\n",
 			ctx->active.channel, ch);
 		return -EFAULT;
 	}
@@ -1479,7 +1479,7 @@ static int il4965_hw_get_temperature(struct il_priv *il)
 	D_TEMP("Calib values R[1-3]: %d %d %d R4: %d\n", R1, R2, R3, vt);
 
 	if (R3 == R1) {
-		IL_ERR(il, "Calibration conflict R1 == R3\n");
+		IL_ERR("Calibration conflict R1 == R3\n");
 		return -1;
 	}
 
@@ -1666,7 +1666,7 @@ static int il4965_tx_status_reply_tx(struct il_priv *il,
 
 			hdr = il_tx_queue_get_hdr(il, txq_id, idx);
 			if (!hdr) {
-				IL_ERR(il,
+				IL_ERR(
 					"BUG_ON idx doesn't point to valid skb"
 					" idx=%d, txq_id=%d\n", idx, txq_id);
 				return -1;
@@ -1674,7 +1674,7 @@ static int il4965_tx_status_reply_tx(struct il_priv *il,
 
 			sc = le16_to_cpu(hdr->seq_ctrl);
 			if (idx != (SEQ_TO_SN(sc) & 0xff)) {
-				IL_ERR(il,
+				IL_ERR(
 					"BUG_ON idx doesn't match seq control"
 					" idx=%d, seq_idx=%d, seq=%d\n",
 					idx, SEQ_TO_SN(sc), hdr->seq_ctrl);
@@ -1750,7 +1750,7 @@ static u8 il4965_find_station(struct il_priv *il, const u8 *addr)
 	    (!(il->stations[ret].used & IL_STA_UCODE_ACTIVE) ||
 	     ((il->stations[ret].used & IL_STA_UCODE_ACTIVE) &&
 	      (il->stations[ret].used & IL_STA_UCODE_INPROGRESS)))) {
-		IL_ERR(il, "Requested station info for sta %d before ready.\n",
+		IL_ERR("Requested station info for sta %d before ready.\n",
 			ret);
 		ret = IL_INVALID_STATION;
 	}
@@ -1790,7 +1790,7 @@ static void il4965_rx_reply_tx(struct il_priv *il,
 	unsigned long flags;
 
 	if ((index >= txq->q.n_bd) || (il_queue_used(&txq->q, index) == 0)) {
-		IL_ERR(il, "Read index for DMA queue txq_id (%d) index %d "
+		IL_ERR("Read index for DMA queue txq_id (%d) index %d "
 			  "is out of range [0-%d] %d %d\n", txq_id,
 			  index, txq->q.n_bd, txq->q.write_ptr,
 			  txq->q.read_ptr);
@@ -1809,7 +1809,7 @@ static void il4965_rx_reply_tx(struct il_priv *il,
 
 	sta_id = il4965_get_ra_sta_id(il, hdr);
 	if (txq->sched_retry && unlikely(sta_id == IL_INVALID_STATION)) {
-		IL_ERR(il, "Station not known\n");
+		IL_ERR("Station not known\n");
 		return;
 	}
 
@@ -1943,7 +1943,7 @@ static void il4965_post_associate(struct il_priv *il)
 
 	ret = il_send_rxon_timing(il, ctx);
 	if (ret)
-		IL_WARN(il, "RXON timing - "
+		IL_WARN("RXON timing - "
 			    "Attempting to continue.\n");
 
 	ctx->staging.filter_flags |= RXON_FILTER_ASSOC_MSK;
@@ -1982,7 +1982,7 @@ static void il4965_post_associate(struct il_priv *il)
 		il4965_send_beacon_cmd(il);
 		break;
 	default:
-		IL_ERR(il, "%s Should not be called in %d mode\n",
+		IL_ERR("%s Should not be called in %d mode\n",
 			  __func__, vif->type);
 		break;
 	}
@@ -2019,7 +2019,7 @@ static void il4965_config_ap(struct il_priv *il)
 		/* RXON Timing */
 		ret = il_send_rxon_timing(il, ctx);
 		if (ret)
-			IL_WARN(il, "RXON timing failed - "
+			IL_WARN("RXON timing failed - "
 					"Attempting to continue.\n");
 
 		/* AP has all antennas */
diff --git a/drivers/net/wireless/iwlegacy/iwl-core.c b/drivers/net/wireless/iwlegacy/iwl-core.c
index e6c7e9d..42be833 100644
--- a/drivers/net/wireless/iwlegacy/iwl-core.c
+++ b/drivers/net/wireless/iwlegacy/iwl-core.c
@@ -253,14 +253,14 @@ int il_init_geos(struct il_priv *il)
 
 	if ((il->bands[IEEE80211_BAND_5GHZ].n_channels == 0) &&
 	     il->cfg->sku & IL_SKU_A) {
-		IL_INFO(il, "Incorrectly detected BG card as ABG. "
+		IL_INFO("Incorrectly detected BG card as ABG. "
 			"Please send your PCI ID 0x%04X:0x%04X to maintainer.\n",
 			   il->pci_dev->device,
 			   il->pci_dev->subsystem_device);
 		il->cfg->sku &= ~IL_SKU_A;
 	}
 
-	IL_INFO(il, "Tunable channels: %d 802.11bg, %d 802.11a channels\n",
+	IL_INFO("Tunable channels: %d 802.11bg, %d 802.11a channels\n",
 		   il->bands[IEEE80211_BAND_2GHZ].n_channels,
 		   il->bands[IEEE80211_BAND_5GHZ].n_channels);
 
@@ -431,65 +431,65 @@ il_check_rxon_cmd(struct il_priv *il, struct il_rxon_context *ctx)
 
 	if (rxon->flags & RXON_FLG_BAND_24G_MSK) {
 		if (rxon->flags & RXON_FLG_TGJ_NARROW_BAND_MSK) {
-			IL_WARN(il, "check 2.4G: wrong narrow\n");
+			IL_WARN("check 2.4G: wrong narrow\n");
 			error = true;
 		}
 		if (rxon->flags & RXON_FLG_RADAR_DETECT_MSK) {
-			IL_WARN(il, "check 2.4G: wrong radar\n");
+			IL_WARN("check 2.4G: wrong radar\n");
 			error = true;
 		}
 	} else {
 		if (!(rxon->flags & RXON_FLG_SHORT_SLOT_MSK)) {
-			IL_WARN(il, "check 5.2G: not short slot!\n");
+			IL_WARN("check 5.2G: not short slot!\n");
 			error = true;
 		}
 		if (rxon->flags & RXON_FLG_CCK_MSK) {
-			IL_WARN(il, "check 5.2G: CCK!\n");
+			IL_WARN("check 5.2G: CCK!\n");
 			error = true;
 		}
 	}
 	if ((rxon->node_addr[0] | rxon->bssid_addr[0]) & 0x1) {
-		IL_WARN(il, "mac/bssid mcast!\n");
+		IL_WARN("mac/bssid mcast!\n");
 		error = true;
 	}
 
 	/* make sure basic rates 6Mbps and 1Mbps are supported */
 	if ((rxon->ofdm_basic_rates & IL_RATE_6M_MASK) == 0 &&
 	    (rxon->cck_basic_rates & IL_RATE_1M_MASK) == 0) {
-		IL_WARN(il, "neither 1 nor 6 are basic\n");
+		IL_WARN("neither 1 nor 6 are basic\n");
 		error = true;
 	}
 
 	if (le16_to_cpu(rxon->assoc_id) > 2007) {
-		IL_WARN(il, "aid > 2007\n");
+		IL_WARN("aid > 2007\n");
 		error = true;
 	}
 
 	if ((rxon->flags & (RXON_FLG_CCK_MSK | RXON_FLG_SHORT_SLOT_MSK))
 			== (RXON_FLG_CCK_MSK | RXON_FLG_SHORT_SLOT_MSK)) {
-		IL_WARN(il, "CCK and short slot\n");
+		IL_WARN("CCK and short slot\n");
 		error = true;
 	}
 
 	if ((rxon->flags & (RXON_FLG_CCK_MSK | RXON_FLG_AUTO_DETECT_MSK))
 			== (RXON_FLG_CCK_MSK | RXON_FLG_AUTO_DETECT_MSK)) {
-		IL_WARN(il, "CCK and auto detect");
+		IL_WARN("CCK and auto detect");
 		error = true;
 	}
 
 	if ((rxon->flags & (RXON_FLG_AUTO_DETECT_MSK |
 			    RXON_FLG_TGG_PROTECT_MSK)) ==
 			    RXON_FLG_TGG_PROTECT_MSK) {
-		IL_WARN(il, "TGg but no auto-detect\n");
+		IL_WARN("TGg but no auto-detect\n");
 		error = true;
 	}
 
 	if (error)
-		IL_WARN(il, "Tuning to channel %d\n",
+		IL_WARN("Tuning to channel %d\n",
 			    le16_to_cpu(rxon->channel));
 
 	if (error) {
-		IL_ERR(il, "Invalid RXON\n");
+		IL_ERR("Invalid RXON\n");
 		return -EINVAL;
 	}
 	return 0;
@@ -626,7 +626,7 @@ static void _il_set_rxon_ht(struct il_priv *il,
 			case IEEE80211_HT_PARAM_CHA_SEC_NONE:
 			default:
 				/* channel location only valid if in Mixed mode */
-				IL_ERR(il,
+				IL_ERR(
 					"invalid extension channel offset\n");
 				break;
 			}
@@ -778,7 +778,7 @@ void il_connection_init_rx_config(struct il_priv *il,
 		break;
 
 	default:
-		IL_ERR(il, "Unsupported interface type %d\n",
+		IL_ERR("Unsupported interface type %d\n",
 			ctx->vif->type);
 		break;
 	}
@@ -828,7 +828,7 @@ void il_set_rate(struct il_priv *il)
 
 	hw = il_get_hw_mode(il, il->band);
 	if (!hw) {
-		IL_ERR(il, "Failed to set rate: unable to get hw mode\n");
+		IL_ERR("Failed to set rate: unable to get hw mode\n");
 		return;
 	}
 
@@ -882,7 +882,7 @@ void il_rx_csa(struct il_priv *il, struct il_rx_mem_buffer *rxb)
 			      le16_to_cpu(csa->channel));
 		il_chswitch_done(il, true);
 	} else {
-		IL_ERR(il, "CSA notif (fail) : channel %d\n",
+		IL_ERR("CSA notif (fail) : channel %d\n",
 			le16_to_cpu(csa->channel));
 		il_chswitch_done(il, false);
 	}
@@ -925,7 +925,7 @@ void il_irq_handle_error(struct il_priv *il)
 	/* Cancel currently queued command. */
 	clear_bit(STATUS_HCMD_ACTIVE, &il->status);
 
-	IL_ERR(il, "Loaded firmware version: %s\n",
+	IL_ERR("Loaded firmware version: %s\n",
 		il->hw->wiphy->fw_version);
 
 	il->cfg->ops->lib->dump_nic_error_log(il);
@@ -963,7 +963,7 @@ static int il_apm_stop_master(struct il_priv *il)
 	ret = il_poll_bit(il, CSR_RESET, CSR_RESET_REG_FLAG_MASTER_DISABLED,
 			CSR_RESET_REG_FLAG_MASTER_DISABLED, 100);
 	if (ret)
-		IL_WARN(il, "Master Disable Timed Out, 100 usec\n");
+		IL_WARN("Master Disable Timed Out, 100 usec\n");
 
 	D_INFO("stop master\n");
 
@@ -1123,14 +1123,14 @@ int il_set_tx_power(struct il_priv *il, s8 tx_power, bool force)
 
 	/* 0 dBm mean 1 milliwatt */
 	if (tx_power < 0) {
-		IL_WARN(il,
+		IL_WARN(
 			 "Requested user TXPOWER %d below 1 mW.\n",
 			 tx_power);
 		return -EINVAL;
 	}
 
 	if (tx_power > il->tx_power_device_lmt) {
-		IL_WARN(il,
+		IL_WARN(
 			"Requested user TXPOWER %d above upper limit %d.\n",
 			 tx_power, il->tx_power_device_lmt);
 		return -EINVAL;
@@ -1184,7 +1184,7 @@ void il_send_bt_config(struct il_priv *il)
 
 	if (il_send_cmd_pdu(il, REPLY_BT_CONFIG,
 			     sizeof(struct il_bt_cmd), &bt_cmd))
-		IL_ERR(il, "failed to send BT Coex Config\n");
+		IL_ERR("failed to send BT Coex Config\n");
 }
 EXPORT_SYMBOL(il_send_bt_config);
 
@@ -1235,7 +1235,7 @@ void il_rx_reply_error(struct il_priv *il,
 {
 	struct il_rx_packet *pkt = rxb_addr(rxb);
 
-	IL_ERR(il, "Error Reply type 0x%08X cmd %s (0x%02X) "
+	IL_ERR("Error Reply type 0x%08X cmd %s (0x%02X) "
 		"seq 0x%04X ser 0x%08X\n",
 		le32_to_cpu(pkt->u.err_resp.error_type),
 		il_get_cmd_string(pkt->u.err_resp.cmd_id),
@@ -1354,7 +1354,7 @@ il_mac_add_interface(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 	mutex_lock(&il->mutex);
 
 	if (!il_is_ready_rf(il)) {
-		IL_WARN(il, "Try to add interface when device not ready\n");
+		IL_WARN("Try to add interface when device not ready\n");
 		err = -EINVAL;
 		goto out;
 	}
@@ -1454,7 +1454,7 @@ int il_alloc_txq_mem(struct il_priv *il)
 				il->cfg->base_params->num_of_queues,
 			GFP_KERNEL);
 	if (!il->txq) {
-		IL_ERR(il, "Not enough memory for txq\n");
+		IL_ERR("Not enough memory for txq\n");
 		return -ENOMEM;
 	}
 	return 0;
@@ -1743,7 +1743,7 @@ int il_force_reset(struct il_priv *il, bool external)
 		return 0;
 	}
 
-	IL_ERR(il, "On demand firmware reload\n");
+	IL_ERR("On demand firmware reload\n");
 
 	/* Set the FW error flag -- cleared on il_down */
 	set_bit(STATUS_FW_ERROR, &il->status);
@@ -1847,7 +1847,7 @@ static int il_check_stuck_queue(struct il_priv *il, int cnt)
 		  msecs_to_jiffies(il->cfg->base_params->wd_timeout);
 
 	if (time_after(jiffies, timeout)) {
-		IL_ERR(il, "Queue %d stuck for %u ms.\n",
+		IL_ERR("Queue %d stuck for %u ms.\n",
 				q->id, il->cfg->base_params->wd_timeout);
 		ret = il_force_reset(il, false);
 		return (ret == -EAGAIN) ? 0 : 1;
@@ -2363,7 +2363,7 @@ static void il_beacon_update(struct ieee80211_hw *hw,
 	lockdep_assert_held(&il->mutex);
 
 	if (!il->beacon_ctx) {
-		IL_ERR(il, "update beacon but no beacon context!\n");
+		IL_ERR("update beacon but no beacon context!\n");
 		dev_kfree_skb(skb);
 		return;
 	}
@@ -2440,7 +2440,7 @@ void il_mac_bss_info_changed(struct ieee80211_hw *hw,
 		 * below/in post_associate will fail.
 		 */
 		if (il_scan_cancel_timeout(il, 100)) {
-			IL_WARN(il,
+			IL_WARN(
 				"Aborted scan still in progress after 100ms\n");
 			D_MAC80211(
 				"leaving - scan abort failed.\n");
@@ -2554,7 +2554,7 @@ void il_mac_bss_info_changed(struct ieee80211_hw *hw,
 		ret = il->cfg->ops->legacy->manage_ibss_station(il, vif,
 							bss_conf->ibss_joined);
 		if (ret)
-			IL_ERR(il, "failed to %s IBSS station %pM\n",
+			IL_ERR("failed to %s IBSS station %pM\n",
 				bss_conf->ibss_joined ? "add" : "remove",
 				bss_conf->bssid);
 	}
@@ -2599,7 +2599,7 @@ irqreturn_t il_isr(int irq, void *data)
 	if ((inta == 0xFFFFFFFF) || ((inta & 0xFFFFFFF0) == 0xa5a5a5a0)) {
 		/* Hardware disappeared. It might have already raised
 		 * an interrupt */
-		IL_WARN(il, "HARDWARE GONE?? INTA == 0x%08x\n", inta);
+		IL_WARN("HARDWARE GONE?? INTA == 0x%08x\n", inta);
 		goto unplugged;
 	}
 
diff --git a/drivers/net/wireless/iwlegacy/iwl-debug.h b/drivers/net/wireless/iwlegacy/iwl-debug.h
index 2c5c42f..373188d 100644
--- a/drivers/net/wireless/iwlegacy/iwl-debug.h
+++ b/drivers/net/wireless/iwlegacy/iwl-debug.h
@@ -32,10 +32,10 @@
 struct il_priv;
 extern u32 il_debug_level;
 
-#define IL_ERR(p, f, a...) dev_err(&((p)->pci_dev->dev), f, ## a)
-#define IL_WARN(p, f, a...) dev_warn(&((p)->pci_dev->dev), f, ## a)
-#define IL_INFO(p, f, a...) dev_info(&((p)->pci_dev->dev), f, ## a)
-#define IL_CRIT(p, f, a...) dev_crit(&((p)->pci_dev->dev), f, ## a)
+#define IL_ERR(f, a...) dev_err(&il->pci_dev->dev, f, ## a)
+#define IL_WARN(f, a...) dev_warn(&il->pci_dev->dev, f, ## a)
+#define IL_INFO(f, a...) dev_info(&il->pci_dev->dev, f, ## a)
+#define IL_CRIT(f, a...) dev_crit(&il->pci_dev->dev, f, ## a)
 
 #define il_print_hex_error(il, p, len)					\
 do {									\
diff --git a/drivers/net/wireless/iwlegacy/iwl-debugfs.c b/drivers/net/wireless/iwlegacy/iwl-debugfs.c
index a811c17..45b71a8 100644
--- a/drivers/net/wireless/iwlegacy/iwl-debugfs.c
+++ b/drivers/net/wireless/iwlegacy/iwl-debugfs.c
@@ -358,20 +358,20 @@ static ssize_t il_dbgfs_nvm_read(struct file *file,
 	buf_size = 4 * eeprom_len + 256;
 
 	if (eeprom_len % 16) {
-		IL_ERR(il, "NVM size is not multiple of 16.\n");
+		IL_ERR("NVM size is not multiple of 16.\n");
 		return -ENODATA;
 	}
 
 	ptr = il->eeprom;
 	if (!ptr) {
-		IL_ERR(il, "Invalid EEPROM memory\n");
+		IL_ERR("Invalid EEPROM memory\n");
 		return -ENOMEM;
 	}
 
 	/* 4 characters for byte 0xYY */
 	buf = kzalloc(buf_size, GFP_KERNEL);
 	if (!buf) {
-		IL_ERR(il, "Can not allocate Buffer\n");
+		IL_ERR("Can not allocate Buffer\n");
 		return -ENOMEM;
 	}
 	eeprom_ver = il_eeprom_query16(il, EEPROM_VERSION);
@@ -407,7 +407,7 @@ il_dbgfs_channels_read(struct file *file, char __user *user_buf,
 
 	buf = kzalloc(bufsz, GFP_KERNEL);
 	if (!buf) {
-		IL_ERR(il, "Can not allocate Buffer\n");
+		IL_ERR("Can not allocate Buffer\n");
 		return -ENOMEM;
 	}
 
@@ -519,7 +519,7 @@ static ssize_t il_dbgfs_interrupt_read(struct file *file,
 
 	buf = kzalloc(bufsz, GFP_KERNEL);
 	if (!buf) {
-		IL_ERR(il, "Can not allocate Buffer\n");
+		IL_ERR("Can not allocate Buffer\n");
 		return -ENOMEM;
 	}
 
@@ -640,7 +640,7 @@ static ssize_t il_dbgfs_disable_ht40_write(struct file *file,
 	if (!il_is_any_associated(il))
 		il->disable_ht40 = ht40 ? true : false;
 	else {
-		IL_ERR(il, "Sta associated with AP - "
+		IL_ERR("Sta associated with AP - "
 			"Change to 40MHz channel support is not allowed\n");
 		return -EINVAL;
 	}
@@ -689,12 +689,12 @@ static ssize_t il_dbgfs_traffic_log_read(struct file *file,
 	ssize_t ret;
 
 	if (!il->txq) {
-		IL_ERR(il, "txq not ready\n");
+		IL_ERR("txq not ready\n");
 		return -EAGAIN;
 	}
 	buf = kzalloc(bufsz, GFP_KERNEL);
 	if (!buf) {
-		IL_ERR(il, "Can not allocate buffer\n");
+		IL_ERR("Can not allocate buffer\n");
 		return -ENOMEM;
 	}
 	pos += scnprintf(buf + pos, bufsz - pos, "Tx Queue\n");
@@ -787,7 +787,7 @@ static ssize_t il_dbgfs_tx_queue_read(struct file *file,
 				il->cfg->base_params->num_of_queues;
 
 	if (!il->txq) {
-		IL_ERR(il, "txq not ready\n");
+		IL_ERR("txq not ready\n");
 		return -EAGAIN;
 	}
 	buf = kzalloc(bufsz, GFP_KERNEL);
@@ -884,7 +884,7 @@ static ssize_t il_dbgfs_sensitivity_read(struct file *file,
 	data = &il->sensitivity_data;
 	buf = kzalloc(bufsz, GFP_KERNEL);
 	if (!buf) {
-		IL_ERR(il, "Can not allocate Buffer\n");
+		IL_ERR("Can not allocate Buffer\n");
 		return -ENOMEM;
 	}
 
@@ -965,7 +965,7 @@ static ssize_t il_dbgfs_chain_noise_read(struct file *file,
 	data = &il->chain_noise_data;
 	buf = kzalloc(bufsz, GFP_KERNEL);
 	if (!buf) {
-		IL_ERR(il, "Can not allocate Buffer\n");
+		IL_ERR("Can not allocate Buffer\n");
 		return -ENOMEM;
 	}
 
@@ -1292,7 +1292,7 @@ int il_dbgfs_register(struct il_priv *il, const char *name)
 	return 0;
 
 err:
-	IL_ERR(il, "Can't create the debugfs directory\n");
+	IL_ERR("Can't create the debugfs directory\n");
 	il_dbgfs_unregister(il);
 	return -ENOMEM;
 }
diff --git a/drivers/net/wireless/iwlegacy/iwl-eeprom.c b/drivers/net/wireless/iwlegacy/iwl-eeprom.c
index 33fe598..5f0fd2a 100644
--- a/drivers/net/wireless/iwlegacy/iwl-eeprom.c
+++ b/drivers/net/wireless/iwlegacy/iwl-eeprom.c
@@ -153,7 +153,7 @@ static int il_eeprom_verify_signature(struct il_priv *il)
 	case CSR_EEPROM_GP_GOOD_SIG_EEP_MORE_THAN_4K:
 		break;
 	default:
-		IL_ERR(il, "bad EEPROM signature,"
+		IL_ERR("bad EEPROM signature,"
 			"EEPROM_GP=0x%08x\n", gp);
 		ret = -ENOENT;
 		break;
@@ -206,7 +206,7 @@ int il_eeprom_init(struct il_priv *il)
 
 	ret = il_eeprom_verify_signature(il);
 	if (ret < 0) {
-		IL_ERR(il, "EEPROM not found, EEPROM_GP=0x%08x\n", gp);
+		IL_ERR("EEPROM not found, EEPROM_GP=0x%08x\n", gp);
 		ret = -ENOENT;
 		goto err;
 	}
@@ -214,7 +214,7 @@ int il_eeprom_init(struct il_priv *il)
 	/* Make sure driver (instead of uCode) is allowed to read EEPROM */
 	ret = il->cfg->ops->lib->eeprom_ops.acquire_semaphore(il);
 	if (ret < 0) {
-		IL_ERR(il, "Failed to acquire EEPROM semaphore.\n");
+		IL_ERR("Failed to acquire EEPROM semaphore.\n");
 		ret = -ENOENT;
 		goto err;
 	}
@@ -231,7 +231,7 @@ int il_eeprom_init(struct il_priv *il)
 					  CSR_EEPROM_REG_READ_VALID_MSK,
 					  IL_EEPROM_ACCESS_TIMEOUT);
 		if (ret < 0) {
-			IL_ERR(il, "Time out reading EEPROM[%d]\n",
+			IL_ERR("Time out reading EEPROM[%d]\n",
 							addr);
 			goto done;
 		}
@@ -399,7 +399,7 @@ int il_init_channel_map(struct il_priv *il)
 	il->channel_info = kzalloc(sizeof(struct il_channel_info) *
 				     il->channel_count, GFP_KERNEL);
 	if (!il->channel_info) {
-		IL_ERR(il, "Could not allocate channel_info\n");
+		IL_ERR("Could not allocate channel_info\n");
 		il->channel_count = 0;
 		return -ENOMEM;
 	}
diff --git a/drivers/net/wireless/iwlegacy/iwl-hcmd.c b/drivers/net/wireless/iwlegacy/iwl-hcmd.c
index 61cf0d8..8f87bd8 100644
--- a/drivers/net/wireless/iwlegacy/iwl-hcmd.c
+++ b/drivers/net/wireless/iwlegacy/iwl-hcmd.c
@@ -95,7 +95,7 @@ static void il_generic_cmd_callback(struct il_priv *il,
 				     struct il_rx_packet *pkt)
 {
 	if (pkt->hdr.flags & IL_CMD_FAILED_MSK) {
-		IL_ERR(il, "Bad return from %s (0x%08X)\n",
+		IL_ERR("Bad return from %s (0x%08X)\n",
 		il_get_cmd_string(cmd->hdr.cmd), pkt->hdr.flags);
 		return;
 	}
@@ -133,7 +133,7 @@ il_send_cmd_async(struct il_priv *il, struct il_host_cmd *cmd)
 
 	ret = il_enqueue_hcmd(il, cmd);
 	if (ret < 0) {
-		IL_ERR(il, "Error sending %s: enqueue_hcmd failed: %d\n",
+		IL_ERR("Error sending %s: enqueue_hcmd failed: %d\n",
 			  il_get_cmd_string(cmd->id), ret);
 		return ret;
 	}
@@ -162,7 +162,7 @@ int il_send_cmd_sync(struct il_priv *il, struct il_host_cmd *cmd)
 	cmd_idx = il_enqueue_hcmd(il, cmd);
 	if (cmd_idx < 0) {
 		ret = cmd_idx;
-		IL_ERR(il, "Error sending %s: enqueue_hcmd failed: %d\n",
+		IL_ERR("Error sending %s: enqueue_hcmd failed: %d\n",
 			  il_get_cmd_string(cmd->id), ret);
 		goto out;
 	}
@@ -172,7 +172,7 @@ int il_send_cmd_sync(struct il_priv *il, struct il_host_cmd *cmd)
 			HOST_COMPLETE_TIMEOUT);
 	if (!ret) {
 		if (test_bit(STATUS_HCMD_ACTIVE, &il->status)) {
-			IL_ERR(il,
+			IL_ERR(
 				"Error sending %s: time out after %dms.\n",
 				il_get_cmd_string(cmd->id),
 				jiffies_to_msecs(HOST_COMPLETE_TIMEOUT));
@@ -187,19 +187,19 @@ int il_send_cmd_sync(struct il_priv *il, struct il_host_cmd *cmd)
 	}
 
 	if (test_bit(STATUS_RF_KILL_HW, &il->status)) {
-		IL_ERR(il, "Command %s aborted: RF KILL Switch\n",
+		IL_ERR("Command %s aborted: RF KILL Switch\n",
 			       il_get_cmd_string(cmd->id));
 		ret = -ECANCELED;
 		goto fail;
 	}
 	if (test_bit(STATUS_FW_ERROR, &il->status)) {
-		IL_ERR(il, "Command %s failed: FW Error\n",
+		IL_ERR("Command %s failed: FW Error\n",
 			       il_get_cmd_string(cmd->id));
 		ret = -EIO;
 		goto fail;
 	}
 	if ((cmd->flags & CMD_WANT_SKB) && !cmd->reply_page) {
-		IL_ERR(il, "Error: Response NULL in '%s'\n",
+		IL_ERR("Error: Response NULL in '%s'\n",
 			  il_get_cmd_string(cmd->id));
 		ret = -EIO;
 		goto cancel;
diff --git a/drivers/net/wireless/iwlegacy/iwl-io.h b/drivers/net/wireless/iwlegacy/iwl-io.h
index d6aae8d..1afd5c0 100644
--- a/drivers/net/wireless/iwlegacy/iwl-io.h
+++ b/drivers/net/wireless/iwlegacy/iwl-io.h
@@ -132,7 +132,7 @@ static inline int _il_grab_nic_access(struct il_priv *il)
 			    CSR_GP_CNTRL_REG_FLAG_GOING_TO_SLEEP), 15000);
 	if (ret < 0) {
 		val = _il_read32(il, CSR_GP_CNTRL);
-		IL_ERR(il,
+		IL_ERR(
 			"MAC is in deep sleep!.  CSR_GP_CNTRL = 0x%08X\n", val);
 		_il_write32(il, CSR_RESET,
 				CSR_RESET_REG_FLAG_FORCE_NMI);
diff --git a/drivers/net/wireless/iwlegacy/iwl-led.c b/drivers/net/wireless/iwlegacy/iwl-led.c
index b4d71cf..a283804 100644
--- a/drivers/net/wireless/iwlegacy/iwl-led.c
+++ b/drivers/net/wireless/iwlegacy/iwl-led.c
@@ -88,7 +88,7 @@ static inline u8 il_blink_compensation(struct il_priv *il,
 				    u8 time, u16 compensation)
 {
 	if (!compensation) {
-		IL_ERR(il, "undefined blink compensation: "
+		IL_ERR("undefined blink compensation: "
 			"use pre-defined blinking time\n");
 		return time;
 	}
diff --git a/drivers/net/wireless/iwlegacy/iwl-power.c b/drivers/net/wireless/iwlegacy/iwl-power.c
index 33aec39..6c6e5e7 100644
--- a/drivers/net/wireless/iwlegacy/iwl-power.c
+++ b/drivers/net/wireless/iwlegacy/iwl-power.c
@@ -136,7 +136,7 @@ il_power_set_mode(struct il_priv *il, struct il_powertable_cmd *cmd,
 
 		memcpy(&il->power_data.sleep_cmd, cmd, sizeof(*cmd));
 	} else
-		IL_ERR(il, "set power fail, ret = %d", ret);
+		IL_ERR("set power fail, ret = %d", ret);
 
 	return ret;
 }
diff --git a/drivers/net/wireless/iwlegacy/iwl-scan.c b/drivers/net/wireless/iwlegacy/iwl-scan.c
index c534dce..3687104 100644
--- a/drivers/net/wireless/iwlegacy/iwl-scan.c
+++ b/drivers/net/wireless/iwlegacy/iwl-scan.c
@@ -341,7 +341,7 @@ static int il_scan_initiate(struct il_priv *il,
 	cancel_delayed_work(&il->scan_check);
 
 	if (!il_is_ready_rf(il)) {
-		IL_WARN(il, "Request scan called when driver not ready.\n");
+		IL_WARN("Request scan called when driver not ready.\n");
 		return -EIO;
 	}
 
diff --git a/drivers/net/wireless/iwlegacy/iwl-sta.c b/drivers/net/wireless/iwlegacy/iwl-sta.c
index a48af85..42033d2 100644
--- a/drivers/net/wireless/iwlegacy/iwl-sta.c
+++ b/drivers/net/wireless/iwlegacy/iwl-sta.c
@@ -41,7 +41,7 @@ static void il_sta_ucode_activate(struct il_priv *il, u8 sta_id)
 {
 
 	if (!(il->stations[sta_id].used & IL_STA_DRIVER_ACTIVE))
-		IL_ERR(il,
+		IL_ERR(
 			"ACTIVATE a non DRIVER active station id %u addr %pM\n",
 			sta_id, il->stations[sta_id].sta.sta.addr);
 
@@ -67,7 +67,7 @@ static int il_process_add_sta_resp(struct il_priv *il,
 	int ret = -EIO;
 
 	if (pkt->hdr.flags & IL_CMD_FAILED_MSK) {
-		IL_ERR(il, "Bad return from REPLY_ADD_STA (0x%08X)\n",
+		IL_ERR("Bad return from REPLY_ADD_STA (0x%08X)\n",
 			pkt->hdr.flags);
 		return ret;
 	}
@@ -84,16 +84,16 @@ static int il_process_add_sta_resp(struct il_priv *il,
 		ret = 0;
 		break;
 	case ADD_STA_NO_ROOM_IN_TABLE:
-		IL_ERR(il, "Adding station %d failed, no room in table.\n",
+		IL_ERR("Adding station %d failed, no room in table.\n",
 			sta_id);
 		break;
 	case ADD_STA_NO_BLOCK_ACK_RESOURCE:
-		IL_ERR(il,
+		IL_ERR(
 			"Adding station %d failed, no block ack resource.\n",
 			sta_id);
 		break;
 	case ADD_STA_MODIFY_NON_EXIST_STA:
-		IL_ERR(il, "Attempting to modify non-existing station %d\n",
+		IL_ERR("Attempting to modify non-existing station %d\n",
 			sta_id);
 		break;
 	default:
@@ -206,7 +206,7 @@ static void il_set_ht_add_station(struct il_priv *il, u8 index,
 	case WLAN_HT_CAP_SM_PS_DISABLED:
 		break;
 	default:
-		IL_WARN(il, "Invalid MIMO PS mode %d\n", mimo_ps_mode);
+		IL_WARN("Invalid MIMO PS mode %d\n", mimo_ps_mode);
 		break;
 	}
 
@@ -343,7 +343,7 @@ il_add_station_common(struct il_priv *il,
 	spin_lock_irqsave(&il->sta_lock, flags_spin);
 	sta_id = il_prep_station(il, ctx, addr, is_ap, sta);
 	if (sta_id == IL_INVALID_STATION) {
-		IL_ERR(il, "Unable to prepare station %pM for addition\n",
+		IL_ERR("Unable to prepare station %pM for addition\n",
 			addr);
 		spin_unlock_irqrestore(&il->sta_lock, flags_spin);
 		return -EINVAL;
@@ -380,7 +380,7 @@ il_add_station_common(struct il_priv *il,
 	ret = il_send_add_sta(il, &sta_cmd, CMD_SYNC);
 	if (ret) {
 		spin_lock_irqsave(&il->sta_lock, flags_spin);
-		IL_ERR(il, "Adding station %pM failed.\n",
+		IL_ERR("Adding station %pM failed.\n",
 			il->stations[sta_id].sta.sta.addr);
 		il->stations[sta_id].used &= ~IL_STA_DRIVER_ACTIVE;
 		il->stations[sta_id].used &= ~IL_STA_UCODE_INPROGRESS;
@@ -402,7 +402,7 @@ static void il_sta_ucode_deactivate(struct il_priv *il, u8 sta_id)
 	if ((il->stations[sta_id].used &
 	     (IL_STA_UCODE_ACTIVE | IL_STA_DRIVER_ACTIVE)) !=
 						IL_STA_UCODE_ACTIVE)
-		IL_ERR(il, "removed non active STA %u\n", sta_id);
+		IL_ERR("removed non active STA %u\n", sta_id);
 
 	il->stations[sta_id].used &= ~IL_STA_UCODE_ACTIVE;
 
@@ -440,7 +440,7 @@ static int il_send_remove_station(struct il_priv *il,
 
 	pkt = (struct il_rx_packet *)cmd.reply_page;
 	if (pkt->hdr.flags & IL_CMD_FAILED_MSK) {
-		IL_ERR(il, "Bad return from REPLY_REMOVE_STA (0x%08X)\n",
+		IL_ERR("Bad return from REPLY_REMOVE_STA (0x%08X)\n",
 			  pkt->hdr.flags);
 		ret = -EIO;
 	}
@@ -458,7 +458,7 @@ static int il_send_remove_station(struct il_priv *il,
 			break;
 		default:
 			ret = -EIO;
-			IL_ERR(il, "REPLY_REMOVE_STA failed\n");
+			IL_ERR("REPLY_REMOVE_STA failed\n");
 			break;
 		}
 	}
@@ -618,7 +618,7 @@ il_restore_stations(struct il_priv *il, struct il_rxon_context *ctx)
 			ret = il_send_add_sta(il, &sta_cmd, CMD_SYNC);
 			if (ret) {
 				spin_lock_irqsave(&il->sta_lock, flags_spin);
-				IL_ERR(il, "Adding station %pM failed.\n",
+				IL_ERR("Adding station %pM failed.\n",
 					il->stations[i].sta.sta.addr);
 				il->stations[i].used &=
 						~IL_STA_DRIVER_ACTIVE;
@@ -808,7 +808,7 @@ int il_mac_sta_remove(struct ieee80211_hw *hw,
 			sta->addr);
 	ret = il_remove_station(il, sta_common->sta_id, sta->addr);
 	if (ret)
-		IL_ERR(il, "Error removing station %pM\n",
+		IL_ERR("Error removing station %pM\n",
 			sta->addr);
 	mutex_unlock(&il->mutex);
 	return ret;
diff --git a/drivers/net/wireless/iwlegacy/iwl-tx.c b/drivers/net/wireless/iwlegacy/iwl-tx.c
index 22617c4..cfc015a 100644
--- a/drivers/net/wireless/iwlegacy/iwl-tx.c
+++ b/drivers/net/wireless/iwlegacy/iwl-tx.c
@@ -299,7 +299,7 @@ static int il_tx_queue_alloc(struct il_priv *il,
 		txq->txb = kzalloc(sizeof(txq->txb[0]) *
 				   TFD_QUEUE_SIZE_MAX, GFP_KERNEL);
 		if (!txq->txb) {
-			IL_ERR(il, "kmalloc for auxiliary BD "
+			IL_ERR("kmalloc for auxiliary BD "
 				  "structures failed\n");
 			goto error;
 		}
@@ -312,7 +312,7 @@ static int il_tx_queue_alloc(struct il_priv *il,
 	txq->tfds = dma_alloc_coherent(dev, tfd_sz, &txq->q.dma_addr,
 				       GFP_KERNEL);
 	if (!txq->tfds) {
-		IL_ERR(il, "pci_alloc_consistent(%zd) failed\n", tfd_sz);
+		IL_ERR("pci_alloc_consistent(%zd) failed\n", tfd_sz);
 		goto error;
 	}
 	txq->q.id = id;
@@ -461,7 +461,7 @@ int il_enqueue_hcmd(struct il_priv *il, struct il_host_cmd *cmd)
 	BUG_ON(fix_size > IL_MAX_CMD_SIZE);
 
 	if (il_is_rfkill(il) || il_is_ctkill(il)) {
-		IL_WARN(il, "Not sending command - %s KILL\n",
+		IL_WARN("Not sending command - %s KILL\n",
 			 il_is_rfkill(il) ? "RF" : "CT");
 		return -EIO;
 	}
@@ -471,7 +471,7 @@ int il_enqueue_hcmd(struct il_priv *il, struct il_host_cmd *cmd)
 	if (il_queue_space(q) < ((cmd->flags & CMD_ASYNC) ? 2 : 1)) {
 		spin_unlock_irqrestore(&il->hcmd_lock, flags);
 
-		IL_ERR(il, "Restarting adapter due to command queue full\n");
+		IL_ERR("Restarting adapter due to command queue full\n");
 		queue_work(il->workqueue, &il->restart);
 		return -ENOSPC;
 	}
@@ -566,7 +566,7 @@ static void il_hcmd_queue_reclaim(struct il_priv *il, int txq_id,
 	int nfreed = 0;
 
 	if ((idx >= q->n_bd) || (il_queue_used(q, idx) == 0)) {
-		IL_ERR(il, "Read index for DMA queue txq id (%d), index %d, "
+		IL_ERR("Read index for DMA queue txq id (%d), index %d, "
 			  "is out of range [0-%d] %d %d.\n", txq_id,
 			  idx, q->n_bd, q->write_ptr, q->read_ptr);
 		return;
@@ -576,7 +576,7 @@ static void il_hcmd_queue_reclaim(struct il_priv *il, int txq_id,
 	     q->read_ptr = il_queue_inc_wrap(q->read_ptr, q->n_bd)) {
 
 		if (nfreed++ > 0) {
-			IL_ERR(il, "HCMD skipped: index (%d) %d %d\n", idx,
+			IL_ERR("HCMD skipped: index (%d) %d %d\n", idx,
 					q->write_ptr, q->read_ptr);
 			queue_work(il->workqueue, &il->restart);
 		}
diff --git a/drivers/net/wireless/iwlegacy/iwl3945-base.c b/drivers/net/wireless/iwlegacy/iwl3945-base.c
index 8aa22a0..8a6b193 100644
--- a/drivers/net/wireless/iwlegacy/iwl3945-base.c
+++ b/drivers/net/wireless/iwlegacy/iwl3945-base.c
@@ -127,7 +127,7 @@ __le32 il3945_get_antenna_flags(const struct il_priv *il)
 	}
 
 	/* bad antenna selector value */
-	IL_ERR(il, "Bad antenna selector value (0x%x)\n",
+	IL_ERR("Bad antenna selector value (0x%x)\n",
 		il3945_mod_params.antenna);
 
 	return 0;		/* "diversity" is default if error */
@@ -236,7 +236,7 @@ static int il3945_set_dynamic_key(struct il_priv *il,
 		ret = il3945_set_wep_dynamic_key_info(il, keyconf, sta_id);
 		break;
 	default:
-		IL_ERR(il, "Unknown alg: %s alg=%x\n", __func__,
+		IL_ERR("Unknown alg: %s alg=%x\n", __func__,
 			keyconf->cipher);
 		ret = -EINVAL;
 	}
@@ -262,7 +262,7 @@ static int il3945_set_static_key(struct il_priv *il,
 	    key->cipher == WLAN_CIPHER_SUITE_WEP104)
 		return -EOPNOTSUPP;
 
-	IL_ERR(il, "Static key invalid: cipher %x\n", key->cipher);
+	IL_ERR("Static key invalid: cipher %x\n", key->cipher);
 	return -EINVAL;
 }
 
@@ -281,7 +281,7 @@ static void il3945_clear_free_frames(struct il_priv *il)
 	}
 
 	if (il->frames_count) {
-		IL_WARN(il, "%d frames still in use.  Did we lose one?\n",
+		IL_WARN("%d frames still in use.  Did we lose one?\n",
 			    il->frames_count);
 		il->frames_count = 0;
 	}
@@ -294,7 +294,7 @@ static struct il3945_frame *il3945_get_free_frame(struct il_priv *il)
 	if (list_empty(&il->free_frames)) {
 		frame = kzalloc(sizeof(*frame), GFP_KERNEL);
 		if (!frame) {
-			IL_ERR(il, "Could not allocate frame!\n");
+			IL_ERR("Could not allocate frame!\n");
 			return NULL;
 		}
 
@@ -339,7 +339,7 @@ static int il3945_send_beacon_cmd(struct il_priv *il)
 	frame = il3945_get_free_frame(il);
 
 	if (!frame) {
-		IL_ERR(il, "Could not obtain free frame buffer for beacon "
+		IL_ERR("Could not obtain free frame buffer for beacon "
 			  "command.\n");
 		return -ENOMEM;
 	}
@@ -401,7 +401,7 @@ static void il3945_build_tx_cmd_hwcrypto(struct il_priv *il,
 		break;
 
 	default:
-		IL_ERR(il, "Unknown encode cipher %x\n", keyinfo->cipher);
+		IL_ERR("Unknown encode cipher %x\n", keyinfo->cipher);
 		break;
 	}
 }
@@ -491,7 +491,7 @@ static int il3945_tx_skb(struct il_priv *il, struct sk_buff *skb)
 	}
 
 	if ((ieee80211_get_tx_rate(il->hw, info)->hw_value & 0xFF) == IL_INVALID_RATE) {
-		IL_ERR(il, "ERROR: No TX rate available.\n");
+		IL_ERR("ERROR: No TX rate available.\n");
 		goto drop_unlock;
 	}
 
@@ -718,7 +718,7 @@ static int il3945_get_measurement(struct il_priv *il,
 
 	pkt = (struct il_rx_packet *)cmd.reply_page;
 	if (pkt->hdr.flags & IL_CMD_FAILED_MSK) {
-		IL_ERR(il, "Bad return from REPLY_RX_ON_ASSOC command\n");
+		IL_ERR("Bad return from REPLY_RX_ON_ASSOC command\n");
 		rc = -EIO;
 	}
 
@@ -777,7 +777,7 @@ static void il3945_rx_reply_alive(struct il_priv *il,
 		queue_delayed_work(il->workqueue, pwork,
 				   msecs_to_jiffies(5));
 	else
-		IL_WARN(il, "uCode did not respond OK.\n");
+		IL_WARN("uCode did not respond OK.\n");
 }
 
 static void il3945_rx_reply_add_sta(struct il_priv *il,
@@ -820,7 +820,7 @@ static void il3945_rx_card_state_notif(struct il_priv *il,
 	u32 flags = le32_to_cpu(pkt->u.card_state_notif.flags);
 	unsigned long status = il->status;
 
-	IL_WARN(il, "Card state received: HW:%s SW:%s\n",
+	IL_WARN("Card state received: HW:%s SW:%s\n",
 			  (flags & HW_CARD_DISABLED) ? "Kill" : "On",
 			  (flags & SW_CARD_DISABLED) ? "Kill" : "On");
 
@@ -1043,7 +1043,7 @@ static void il3945_rx_allocate(struct il_priv *il, gfp_t priority)
 				D_INFO("Failed to allocate SKB buffer.\n");
 			if ((rxq->free_count <= RX_LOW_WATERMARK) &&
 			    net_ratelimit())
-				IL_CRIT(il, "Failed to allocate SKB buffer with %s. Only %u free buffers remaining.\n",
+				IL_CRIT("Failed to allocate SKB buffer with %s. Only %u free buffers remaining.\n",
 					 priority == GFP_ATOMIC ?  "GFP_ATOMIC" : "GFP_KERNEL",
 					 rxq->free_count);
 			/* We don't reschedule replenish work here -- we will
@@ -1287,7 +1287,7 @@ static void il3945_rx_handle(struct il_priv *il)
 			if (rxb->page)
 				il_tx_cmd_complete(il, rxb);
 			else
-				IL_WARN(il, "Claim null rxb?\n");
+				IL_WARN("Claim null rxb?\n");
 		}
 
 		/* Reuse the page if possible. For notification packets and
@@ -1366,7 +1366,7 @@ void il3945_dump_nic_error_log(struct il_priv *il)
 	base = le32_to_cpu(il->card_alive.error_event_table_ptr);
 
 	if (!il3945_hw_valid_rtc_data_addr(base)) {
-		IL_ERR(il, "Not valid error log pointer 0x%08X\n", base);
+		IL_ERR("Not valid error log pointer 0x%08X\n", base);
 		return;
 	}
 
@@ -1374,12 +1374,12 @@ void il3945_dump_nic_error_log(struct il_priv *il)
 	count = il_read_targ_mem(il, base);
 
 	if (ERROR_START_OFFSET <= count * ERROR_ELEM_SIZE) {
-		IL_ERR(il, "Start IWL Error Log Dump:\n");
-		IL_ERR(il, "Status: 0x%08lX, count: %d\n",
+		IL_ERR("Start IWL Error Log Dump:\n");
+		IL_ERR("Status: 0x%08lX, count: %d\n",
 			il->status, count);
 	}
 
-	IL_ERR(il, "Desc       Time       asrtPC  blink2 "
+	IL_ERR("Desc       Time       asrtPC  blink2 "
 		  "ilink1  nmiPC   Line\n");
 	for (i = ERROR_START_OFFSET;
 	     i < (count * ERROR_ELEM_SIZE) + ERROR_START_OFFSET;
@@ -1398,7 +1398,7 @@ void il3945_dump_nic_error_log(struct il_priv *il)
 		data1 =
 		    il_read_targ_mem(il, base + i + 6 * sizeof(u32));
 
-		IL_ERR(il,
+		IL_ERR(
 			"%-13s (0x%X) %010u 0x%05X 0x%05X 0x%05X 0x%05X %u\n\n",
 			il3945_desc_lookup(desc), desc, time, blink1, blink2,
 			ilink1, ilink2, data1);
@@ -1450,7 +1450,7 @@ static void il3945_irq_tasklet(struct il_priv *il)
 
 	/* Now service all interrupt bits discovered above. */
 	if (inta & CSR_INT_BIT_HW_ERR) {
-		IL_ERR(il, "Hardware error detected.  Restarting.\n");
+		IL_ERR("Hardware error detected.  Restarting.\n");
 
 		/* Tell the device to stop sending interrupts */
 		il_disable_interrupts(il);
@@ -1484,7 +1484,7 @@ static void il3945_irq_tasklet(struct il_priv *il)
 
 	/* Error detected by uCode */
 	if (inta & CSR_INT_BIT_SW_ERR) {
-		IL_ERR(il, "Microcode SW error detected. "
+		IL_ERR("Microcode SW error detected. "
 			"Restarting 0x%X.\n", inta);
 		il->isr_stats.sw++;
 		il_irq_handle_error(il);
@@ -1526,14 +1526,14 @@ static void il3945_irq_tasklet(struct il_priv *il)
 	}
 
 	if (inta & ~handled) {
-		IL_ERR(il, "Unhandled INTA bits 0x%08x\n", inta & ~handled);
+		IL_ERR("Unhandled INTA bits 0x%08x\n", inta & ~handled);
 		il->isr_stats.unhandled++;
 	}
 
 	if (inta & ~il->inta_mask) {
-		IL_WARN(il, "Disabled INTA bits 0x%08x were pending\n",
+		IL_WARN("Disabled INTA bits 0x%08x were pending\n",
 			 inta & ~il->inta_mask);
-		IL_WARN(il, "   with FH_INT = 0x%08x\n", inta_fh);
+		IL_WARN("   with FH_INT = 0x%08x\n", inta_fh);
 	}
 
 	/* Re-enable all interrupts */
@@ -1708,7 +1708,7 @@ static int il3945_verify_inst_full(struct il_priv *il, __le32 *image, u32 len)
 		 * if IL_DL_IO is set */
 		val = _il_read_direct32(il, HBUS_TARG_MEM_RDAT);
 		if (val != le32_to_cpu(*image)) {
-			IL_ERR(il, "uCode INST section is invalid at "
+			IL_ERR("uCode INST section is invalid at "
 				  "offset 0x%x, is 0x%x, s/b 0x%x\n",
 				  save_len - len, val, le32_to_cpu(*image));
 			rc = -EIO;
@@ -1750,7 +1750,7 @@ static int il3945_verify_inst_sparse(struct il_priv *il, __le32 *image, u32 len)
 		val = _il_read_direct32(il, HBUS_TARG_MEM_RDAT);
 		if (val != le32_to_cpu(*image)) {
 #if 0 /* Enable this if you want to see details */
-			IL_ERR(il, "uCode INST section is invalid at "
+			IL_ERR("uCode INST section is invalid at "
 				  "offset 0x%x, is 0x%x, s/b 0x%x\n",
 				  i, val, *image);
 #endif
@@ -1802,7 +1802,7 @@ static int il3945_verify_ucode(struct il_priv *il)
 		return 0;
 	}
 
-	IL_ERR(il, "NO VALID UCODE IMAGE IN INSTRUCTION SRAM!!\n");
+	IL_ERR("NO VALID UCODE IMAGE IN INSTRUCTION SRAM!!\n");
 
 	/* Since nothing seems to match, show first several data entries in
 	 * instruction SRAM, so maybe visual inspection will give a clue.
@@ -1867,7 +1867,7 @@ static int il3945_read_ucode(struct il_priv *il)
 		sprintf(buf, "%s%u%s", name_pre, index, ".ucode");
 		ret = request_firmware(&ucode_raw, buf, &il->pci_dev->dev);
 		if (ret < 0) {
-			IL_ERR(il, "%s firmware file req failed: %d\n",
+			IL_ERR("%s firmware file req failed: %d\n",
 				  buf, ret);
 			if (ret == -ENOENT)
 				continue;
@@ -1875,7 +1875,7 @@ static int il3945_read_ucode(struct il_priv *il)
 				goto error;
 		} else {
 			if (index < api_max)
-				IL_ERR(il, "Loaded firmware %s, "
+				IL_ERR("Loaded firmware %s, "
 					"which is deprecated. "
 					" Please use API v%u instead.\n",
 					  buf, api_max);
@@ -1891,7 +1891,7 @@ static int il3945_read_ucode(struct il_priv *il)
 
 	/* Make sure that we got at least our header! */
 	if (ucode_raw->size <  il3945_ucode_get_header_size(1)) {
-		IL_ERR(il, "File size way too small!\n");
+		IL_ERR("File size way too small!\n");
 		ret = -EINVAL;
 		goto err_release;
 	}
@@ -1913,7 +1913,7 @@ static int il3945_read_ucode(struct il_priv *il)
 	 * on the API version read from firmware header from here on forward */
 
 	if (api_ver < api_min || api_ver > api_max) {
-		IL_ERR(il, "Driver unable to support your firmware API. "
+		IL_ERR("Driver unable to support your firmware API. "
 			  "Driver supports v%u, firmware is v%u.\n",
 			  api_max, api_ver);
 		il->ucode_ver = 0;
@@ -1921,12 +1921,12 @@ static int il3945_read_ucode(struct il_priv *il)
 		goto err_release;
 	}
 	if (api_ver != api_max)
-		IL_ERR(il, "Firmware has old API version. Expected %u, "
+		IL_ERR("Firmware has old API version. Expected %u, "
 			  "got %u. New firmware can be obtained "
 			  "from http://www.intellinuxwireless.org.\n",
 			  api_max, api_ver);
 
-	IL_INFO(il, "loaded firmware version %u.%u.%u.%u\n",
+	IL_INFO("loaded firmware version %u.%u.%u.%u\n",
 		IL_UCODE_MAJOR(il->ucode_ver),
 		IL_UCODE_MINOR(il->ucode_ver),
 		IL_UCODE_API(il->ucode_ver),
@@ -2091,7 +2091,7 @@ static int il3945_read_ucode(struct il_priv *il)
 	return 0;
 
  err_pci_alloc:
-	IL_ERR(il, "failed to allocate pci memory\n");
+	IL_ERR("failed to allocate pci memory\n");
 	ret = -ENOMEM;
 	il3945_dealloc_ucode_pci(il);
 
@@ -2380,7 +2380,7 @@ static int il3945_alloc_bcast_station(struct il_priv *il)
 	sta_id = il_prep_station(il, ctx,
 					il_bcast_addr, false, NULL);
 	if (sta_id == IL_INVALID_STATION) {
-		IL_ERR(il, "Unable to prepare broadcast station\n");
+		IL_ERR("Unable to prepare broadcast station\n");
 		spin_unlock_irqrestore(&il->sta_lock, flags);
 
 		return -EINVAL;
@@ -2402,12 +2402,12 @@ static int __il3945_up(struct il_priv *il)
 		return rc;
 
 	if (test_bit(STATUS_EXIT_PENDING, &il->status)) {
-		IL_WARN(il, "Exit pending; will not bring the NIC up\n");
+		IL_WARN("Exit pending; will not bring the NIC up\n");
 		return -EIO;
 	}
 
 	if (!il->ucode_data_backup.v_addr || !il->ucode_data.v_addr) {
-		IL_ERR(il, "ucode not available for device bring up\n");
+		IL_ERR("ucode not available for device bring up\n");
 		return -EIO;
 	}
 
@@ -2417,7 +2417,7 @@ static int __il3945_up(struct il_priv *il)
 		clear_bit(STATUS_RF_KILL_HW, &il->status);
 	else {
 		set_bit(STATUS_RF_KILL_HW, &il->status);
-		IL_WARN(il, "Radio disabled by HW RF Kill switch\n");
+		IL_WARN("Radio disabled by HW RF Kill switch\n");
 		return -ENODEV;
 	}
 
@@ -2425,7 +2425,7 @@ static int __il3945_up(struct il_priv *il)
 
 	rc = il3945_hw_nic_init(il);
 	if (rc) {
-		IL_ERR(il, "Unable to int nic\n");
+		IL_ERR("Unable to int nic\n");
 		return rc;
 	}
 
@@ -2460,7 +2460,7 @@ static int __il3945_up(struct il_priv *il)
 		rc = il->cfg->ops->lib->load_ucode(il);
 
 		if (rc) {
-			IL_ERR(il,
+			IL_ERR(
 				"Unable to set up bootstrap uCode: %d\n", rc);
 			continue;
 		}
@@ -2479,7 +2479,7 @@ static int __il3945_up(struct il_priv *il)
 
 	/* tried to restart and config the device for as long as our
 	 * patience could withstand */
-	IL_ERR(il, "Unable to initialize device after %d attempts.\n", i);
+	IL_ERR("Unable to initialize device after %d attempts.\n", i);
 	return -EIO;
 }
 
@@ -2650,7 +2650,7 @@ int il3945_request_scan(struct il_priv *il, struct ieee80211_vif *vif)
 		band = IEEE80211_BAND_5GHZ;
 		break;
 	default:
-		IL_WARN(il, "Invalid scan band\n");
+		IL_WARN("Invalid scan band\n");
 		return -EIO;
 	}
 
@@ -2770,7 +2770,7 @@ void il3945_post_associate(struct il_priv *il)
 
 	rc = il_send_rxon_timing(il, ctx);
 	if (rc)
-		IL_WARN(il, "REPLY_RXON_TIMING failed - "
+		IL_WARN("REPLY_RXON_TIMING failed - "
 			    "Attempting to continue.\n");
 
 	ctx->staging.filter_flags |= RXON_FILTER_ASSOC_MSK;
@@ -2802,7 +2802,7 @@ void il3945_post_associate(struct il_priv *il)
 		il3945_send_beacon_cmd(il);
 		break;
 	default:
-		IL_ERR(il, "%s Should not be called in %d mode\n",
+		IL_ERR("%s Should not be called in %d mode\n",
 			__func__, ctx->vif->type);
 		break;
 	}
@@ -2832,7 +2832,7 @@ static int il3945_mac_start(struct ieee80211_hw *hw)
 	if (!il->ucode_code.len) {
 		ret = il3945_read_ucode(il);
 		if (ret) {
-			IL_ERR(il, "Could not read microcode: %d\n", ret);
+			IL_ERR("Could not read microcode: %d\n", ret);
 			mutex_unlock(&il->mutex);
 			goto out_release_irq;
 		}
@@ -2854,7 +2854,7 @@ static int il3945_mac_start(struct ieee80211_hw *hw)
 			UCODE_READY_TIMEOUT);
 	if (!ret) {
 		if (!test_bit(STATUS_READY, &il->status)) {
-			IL_ERR(il,
+			IL_ERR(
 				"Wait for START_ALIVE timeout after %dms.\n",
 				jiffies_to_msecs(UCODE_READY_TIMEOUT));
 			ret = -ETIMEDOUT;
@@ -2934,7 +2934,7 @@ void il3945_config_ap(struct il_priv *il)
 		/* RXON Timing */
 		rc = il_send_rxon_timing(il, ctx);
 		if (rc)
-			IL_WARN(il, "REPLY_RXON_TIMING failed - "
+			IL_WARN("REPLY_RXON_TIMING failed - "
 					"Attempting to continue.\n");
 
 		ctx->staging.assoc_id = 0;
@@ -3045,7 +3045,7 @@ static int il3945_mac_sta_add(struct ieee80211_hw *hw,
 				&il->contexts[IL_RXON_CTX_BSS],
 				     sta->addr, is_ap, sta, &sta_id);
 	if (ret) {
-		IL_ERR(il, "Unable to add station %pM (%d)\n",
+		IL_ERR("Unable to add station %pM (%d)\n",
 			sta->addr, ret);
 		/* Should we return success if return code is EEXIST ? */
 		mutex_unlock(&il->mutex);
@@ -3147,11 +3147,11 @@ static ssize_t il3945_store_debug_level(struct device *d,
 
 	ret = strict_strtoul(buf, 0, &val);
 	if (ret)
-		IL_INFO(il, "%s is not in hex or decimal form.\n", buf);
+		IL_INFO("%s is not in hex or decimal form.\n", buf);
 	else {
 		il->debug_level = val;
 		if (il_alloc_traffic_mem(il))
-			IL_ERR(il,
+			IL_ERR(
 				"Not enough memory to generate traffic log\n");
 	}
 	return strnlen(buf, count);
@@ -3192,7 +3192,7 @@ static ssize_t il3945_store_tx_power(struct device *d,
 
 	val = simple_strtoul(p, &p, 10);
 	if (p == buf)
-		IL_INFO(il, ": %s is not in decimal form.\n", buf);
+		IL_INFO(": %s is not in decimal form.\n", buf);
 	else
 		il3945_hw_reg_set_txpower(il, val);
 
@@ -3222,7 +3222,7 @@ static ssize_t il3945_store_flags(struct device *d,
 	if (le32_to_cpu(ctx->staging.flags) != flags) {
 		/* Cancel any currently running scans... */
 		if (il_scan_cancel_timeout(il, 100))
-			IL_WARN(il, "Could not cancel scan.\n");
+			IL_WARN("Could not cancel scan.\n");
 		else {
 			D_INFO("Committing rxon.flags = 0x%04X\n",
 				       flags);
@@ -3259,7 +3259,7 @@ static ssize_t il3945_store_filter_flags(struct device *d,
 	if (le32_to_cpu(ctx->staging.filter_flags) != filter_flags) {
 		/* Cancel any currently running scans... */
 		if (il_scan_cancel_timeout(il, 100))
-			IL_WARN(il, "Could not cancel scan.\n");
+			IL_WARN("Could not cancel scan.\n");
 		else {
 			D_INFO("Committing rxon.filter_flags = "
 				       "0x%04X\n", filter_flags);
@@ -3551,14 +3551,14 @@ static int il3945_init_drv(struct il_priv *il)
 	il->force_reset.reset_duration = IL_DELAY_NEXT_FORCE_FW_RELOAD;
 
 	if (eeprom->version < EEPROM_3945_EEPROM_VERSION) {
-		IL_WARN(il, "Unsupported EEPROM version: 0x%04X\n",
+		IL_WARN("Unsupported EEPROM version: 0x%04X\n",
 			 eeprom->version);
 		ret = -EINVAL;
 		goto err;
 	}
 	ret = il_init_channel_map(il);
 	if (ret) {
-		IL_ERR(il, "initializing regulatory failed: %d\n", ret);
+		IL_ERR("initializing regulatory failed: %d\n", ret);
 		goto err;
 	}
 
@@ -3570,7 +3570,7 @@ static int il3945_init_drv(struct il_priv *il)
 
 	ret = il_init_geos(il);
 	if (ret) {
-		IL_ERR(il, "initializing geos failed: %d\n", ret);
+		IL_ERR("initializing geos failed: %d\n", ret);
 		goto err_free_channel_map;
 	}
 	il3945_init_hw_rates(il, il->ieee_rates);
@@ -3624,7 +3624,7 @@ static int il3945_setup_mac(struct il_priv *il)
 
 	ret = ieee80211_register_hw(il->hw);
 	if (ret) {
-		IL_ERR(il, "Failed to register hw (error %d)\n", ret);
+		IL_ERR("Failed to register hw (error %d)\n", ret);
 		return ret;
 	}
 	il->mac80211_registered = 1;
@@ -3692,7 +3692,7 @@ static int il3945_pci_probe(struct pci_dev *pdev, const struct pci_device_id *en
 	il->inta_mask = CSR_INI_SET_MASK;
 
 	if (il_alloc_traffic_mem(il))
-		IL_ERR(il, "Not enough memory to generate traffic log\n");
+		IL_ERR("Not enough memory to generate traffic log\n");
 
 	/***************************
 	 * 2. Initializing PCI bus
@@ -3711,7 +3711,7 @@ static int il3945_pci_probe(struct pci_dev *pdev, const struct pci_device_id *en
 	if (!err)
 		err = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(32));
 	if (err) {
-		IL_WARN(il, "No suitable DMA available.\n");
+		IL_WARN("No suitable DMA available.\n");
 		goto out_pci_disable_device;
 	}
 
@@ -3757,7 +3757,7 @@ static int il3945_pci_probe(struct pci_dev *pdev, const struct pci_device_id *en
 	/* Read the EEPROM */
 	err = il_eeprom_init(il);
 	if (err) {
-		IL_ERR(il, "Unable to init EEPROM\n");
+		IL_ERR("Unable to init EEPROM\n");
 		goto out_iounmap;
 	}
 	/* MAC Address location in EEPROM same for 3945/4965 */
@@ -3770,7 +3770,7 @@ static int il3945_pci_probe(struct pci_dev *pdev, const struct pci_device_id *en
 	 * ********************/
 	/* Device-specific setup */
 	if (il3945_hw_set_hw_params(il)) {
-		IL_ERR(il, "failed to set hw settings\n");
+		IL_ERR("failed to set hw settings\n");
 		goto out_eeprom_free;
 	}
 
@@ -3780,11 +3780,11 @@ static int il3945_pci_probe(struct pci_dev *pdev, const struct pci_device_id *en
 
 	err = il3945_init_drv(il);
 	if (err) {
-		IL_ERR(il, "initializing driver failed\n");
+		IL_ERR("initializing driver failed\n");
 		goto out_unset_hw_params;
 	}
 
-	IL_INFO(il, "Detected Intel Wireless WiFi Link %s\n",
+	IL_INFO("Detected Intel Wireless WiFi Link %s\n",
 		il->cfg->name);
 
 	/***********************
@@ -3800,13 +3800,13 @@ static int il3945_pci_probe(struct pci_dev *pdev, const struct pci_device_id *en
 	err = request_irq(il->pci_dev->irq, il_isr,
 			  IRQF_SHARED, DRV_NAME, il);
 	if (err) {
-		IL_ERR(il, "Error allocating IRQ %d\n", il->pci_dev->irq);
+		IL_ERR("Error allocating IRQ %d\n", il->pci_dev->irq);
 		goto out_disable_msi;
 	}
 
 	err = sysfs_create_group(&pdev->dev.kobj, &il3945_attribute_group);
 	if (err) {
-		IL_ERR(il, "failed to create sysfs device attributes\n");
+		IL_ERR("failed to create sysfs device attributes\n");
 		goto out_release_irq;
 	}
 
@@ -3829,7 +3829,7 @@ static int il3945_pci_probe(struct pci_dev *pdev, const struct pci_device_id *en
 
 	err = il_dbgfs_register(il, DRV_NAME);
 	if (err)
-		IL_ERR(il, "failed to create debugfs files. Ignoring error: %d\n", err);
+		IL_ERR("failed to create debugfs files. Ignoring error: %d\n", err);
 
 	/* Start monitoring the killswitch */
 	queue_delayed_work(il->workqueue, &il->_3945.rfkill_poll,
diff --git a/drivers/net/wireless/iwlegacy/iwl4965-base.c b/drivers/net/wireless/iwlegacy/iwl4965-base.c
index 88dc8db..df7e0a4 100644
--- a/drivers/net/wireless/iwlegacy/iwl4965-base.c
+++ b/drivers/net/wireless/iwlegacy/iwl4965-base.c
@@ -115,7 +115,7 @@ static void il4965_clear_free_frames(struct il_priv *il)
 	}
 
 	if (il->frames_count) {
-		IL_WARN(il, "%d frames still in use.  Did we lose one?\n",
+		IL_WARN("%d frames still in use.  Did we lose one?\n",
 			    il->frames_count);
 		il->frames_count = 0;
 	}
@@ -128,7 +128,7 @@ static struct il_frame *il4965_get_free_frame(struct il_priv *il)
 	if (list_empty(&il->free_frames)) {
 		frame = kzalloc(sizeof(*frame), GFP_KERNEL);
 		if (!frame) {
-			IL_ERR(il, "Could not allocate frame!\n");
+			IL_ERR("Could not allocate frame!\n");
 			return NULL;
 		}
 
@@ -188,7 +188,7 @@ static void il4965_set_beacon_tim(struct il_priv *il,
 		tx_beacon_cmd->tim_idx = cpu_to_le16(tim_idx);
 		tx_beacon_cmd->tim_size = beacon[tim_idx+1];
 	} else
-		IL_WARN(il, "Unable to find TIM Element in beacon\n");
+		IL_WARN("Unable to find TIM Element in beacon\n");
 }
 
 static unsigned int il4965_hw_get_beacon_cmd(struct il_priv *il,
@@ -206,7 +206,7 @@ static unsigned int il4965_hw_get_beacon_cmd(struct il_priv *il,
 	lockdep_assert_held(&il->mutex);
 
 	if (!il->beacon_ctx) {
-		IL_ERR(il, "trying to build beacon w/o beacon context!\n");
+		IL_ERR("trying to build beacon w/o beacon context!\n");
 		return 0;
 	}
 
@@ -254,14 +254,14 @@ int il4965_send_beacon_cmd(struct il_priv *il)
 
 	frame = il4965_get_free_frame(il);
 	if (!frame) {
-		IL_ERR(il, "Could not obtain free frame buffer for beacon "
+		IL_ERR("Could not obtain free frame buffer for beacon "
 			  "command.\n");
 		return -ENOMEM;
 	}
 
 	frame_size = il4965_hw_get_beacon_cmd(il, frame);
 	if (!frame_size) {
-		IL_ERR(il, "Error configuring the beacon command\n");
+		IL_ERR("Error configuring the beacon command\n");
 		il4965_free_frame(il, frame);
 		return -EINVAL;
 	}
@@ -336,7 +336,7 @@ void il4965_hw_txq_free_tfd(struct il_priv *il, struct il_tx_queue *txq)
 	num_tbs = il4965_tfd_get_num_tbs(tfd);
 
 	if (num_tbs >= IL_NUM_OF_TBS) {
-		IL_ERR(il, "Too many chunks: %i\n", num_tbs);
+		IL_ERR("Too many chunks: %i\n", num_tbs);
 		/* @todo issue fatal error, it is quite serious situation */
 		return;
 	}
@@ -388,14 +388,14 @@ int il4965_hw_txq_attach_buf_to_tfd(struct il_priv *il,
 
 	/* Each TFD can point to a maximum 20 Tx buffers */
 	if (num_tbs >= IL_NUM_OF_TBS) {
-		IL_ERR(il, "Error can not send more than %d chunks\n",
+		IL_ERR("Error can not send more than %d chunks\n",
 			  IL_NUM_OF_TBS);
 		return -EINVAL;
 	}
 
 	BUG_ON(addr & ~DMA_BIT_MASK(36));
 	if (unlikely(addr & ~IL_TX_DMA_MASK))
-		IL_ERR(il, "Unaligned address = %llx\n",
+		IL_ERR("Unaligned address = %llx\n",
 			  (unsigned long long)addr);
 
 	il4965_tfd_set_tb(tfd, num_tbs, addr, len);
@@ -460,7 +460,7 @@ static void il4965_rx_reply_alive(struct il_priv *il,
 		queue_delayed_work(il->workqueue, pwork,
 				   msecs_to_jiffies(5));
 	else
-		IL_WARN(il, "uCode did not respond OK.\n");
+		IL_WARN("uCode did not respond OK.\n");
 }
 
 /**
@@ -725,7 +725,7 @@ void il4965_rx_handle(struct il_priv *il)
 			if (rxb->page)
 				il_tx_cmd_complete(il, rxb);
 			else
-				IL_WARN(il, "Claim null rxb?\n");
+				IL_WARN("Claim null rxb?\n");
 		}
 
 		/* Reuse the page if possible. For notification packets and
@@ -818,7 +818,7 @@ static void il4965_irq_tasklet(struct il_priv *il)
 
 	/* Now service all interrupt bits discovered above. */
 	if (inta & CSR_INT_BIT_HW_ERR) {
-		IL_ERR(il, "Hardware error detected.  Restarting.\n");
+		IL_ERR("Hardware error detected.  Restarting.\n");
 
 		/* Tell the device to stop sending interrupts */
 		il_disable_interrupts(il);
@@ -857,7 +857,7 @@ static void il4965_irq_tasklet(struct il_priv *il)
 				CSR_GP_CNTRL_REG_FLAG_HW_RF_KILL_SW))
 			hw_rf_kill = 1;
 
-		IL_WARN(il, "RF_KILL bit toggled to %s.\n",
+		IL_WARN("RF_KILL bit toggled to %s.\n",
 				hw_rf_kill ? "disable radio" : "enable radio");
 
 		il->isr_stats.rfkill++;
@@ -880,14 +880,14 @@ static void il4965_irq_tasklet(struct il_priv *il)
 
 	/* Chip got too hot and stopped itself */
 	if (inta & CSR_INT_BIT_CT_KILL) {
-		IL_ERR(il, "Microcode CT kill error detected.\n");
+		IL_ERR("Microcode CT kill error detected.\n");
 		il->isr_stats.ctkill++;
 		handled |= CSR_INT_BIT_CT_KILL;
 	}
 
 	/* Error detected by uCode */
 	if (inta & CSR_INT_BIT_SW_ERR) {
-		IL_ERR(il, "Microcode SW error detected. "
+		IL_ERR("Microcode SW error detected. "
 			" Restarting 0x%X.\n", inta);
 		il->isr_stats.sw++;
 		il_irq_handle_error(il);
@@ -928,14 +928,14 @@ static void il4965_irq_tasklet(struct il_priv *il)
 	}
 
 	if (inta & ~handled) {
-		IL_ERR(il, "Unhandled INTA bits 0x%08x\n", inta & ~handled);
+		IL_ERR("Unhandled INTA bits 0x%08x\n", inta & ~handled);
 		il->isr_stats.unhandled++;
 	}
 
 	if (inta & ~(il->inta_mask)) {
-		IL_WARN(il, "Disabled INTA bits 0x%08x were pending\n",
+		IL_WARN("Disabled INTA bits 0x%08x were pending\n",
 			 inta & ~il->inta_mask);
-		IL_WARN(il, "   with FH_INT = 0x%08x\n", inta_fh);
+		IL_WARN("   with FH_INT = 0x%08x\n", inta_fh);
 	}
 
 	/* Re-enable all interrupts */
@@ -993,11 +993,11 @@ static ssize_t il4965_store_debug_level(struct device *d,
 
 	ret = strict_strtoul(buf, 0, &val);
 	if (ret)
-		IL_ERR(il, "%s is not in hex or decimal form.\n", buf);
+		IL_ERR("%s is not in hex or decimal form.\n", buf);
 	else {
 		il->debug_level = val;
 		if (il_alloc_traffic_mem(il))
-			IL_ERR(il,
+			IL_ERR(
 				"Not enough memory to generate traffic log\n");
 	}
 	return strnlen(buf, count);
@@ -1044,11 +1044,11 @@ static ssize_t il4965_store_tx_power(struct device *d,
 
 	ret = strict_strtoul(buf, 10, &val);
 	if (ret)
-		IL_INFO(il, "%s is not in decimal form.\n", buf);
+		IL_INFO("%s is not in decimal form.\n", buf);
 	else {
 		ret = il_set_tx_power(il, val, false);
 		if (ret)
-			IL_ERR(il, "failed setting tx power (0x%d).\n",
+			IL_ERR("failed setting tx power (0x%d).\n",
 				ret);
 		else
 			ret = count;
@@ -1114,7 +1114,7 @@ static int __must_check il4965_request_firmware(struct il_priv *il, bool first)
 	}
 
 	if (il->fw_index < il->cfg->ucode_api_min) {
-		IL_ERR(il, "no suitable firmware found!\n");
+		IL_ERR("no suitable firmware found!\n");
 		return -ENOENT;
 	}
 
@@ -1151,7 +1151,7 @@ static int il4965_load_firmware(struct il_priv *il,
 	case 2:
 		hdr_size = 24;
 		if (ucode_raw->size < hdr_size) {
-			IL_ERR(il, "File size too small!\n");
+			IL_ERR("File size too small!\n");
 			return -EINVAL;
 		}
 		pieces->inst_size = le32_to_cpu(ucode->v1.inst_size);
@@ -1169,7 +1169,7 @@ static int il4965_load_firmware(struct il_priv *il,
 				pieces->data_size + pieces->init_size +
 				pieces->init_data_size + pieces->boot_size) {
 
-		IL_ERR(il,
+		IL_ERR(
 			"uCode file size %d does not match expected size\n",
 			(int)ucode_raw->size);
 		return -EINVAL;
@@ -1214,7 +1214,7 @@ il4965_ucode_callback(const struct firmware *ucode_raw, void *context)
 
 	if (!ucode_raw) {
 		if (il->fw_index <= il->cfg->ucode_api_max)
-			IL_ERR(il,
+			IL_ERR(
 				"request for firmware file '%s' failed.\n",
 				il->firmware_name);
 		goto try_again;
@@ -1225,7 +1225,7 @@ il4965_ucode_callback(const struct firmware *ucode_raw, void *context)
 
 	/* Make sure that we got at least the API version number */
 	if (ucode_raw->size < 4) {
-		IL_ERR(il, "File size way too small!\n");
+		IL_ERR("File size way too small!\n");
 		goto try_again;
 	}
 
@@ -1245,7 +1245,7 @@ il4965_ucode_callback(const struct firmware *ucode_raw, void *context)
 	 * on the API version read from firmware header from here on forward
 	 */
 	if (api_ver < api_min || api_ver > api_max) {
-		IL_ERR(il,
+		IL_ERR(
 			"Driver unable to support your firmware API. "
 			"Driver supports v%u, firmware is v%u.\n",
 			api_max, api_ver);
@@ -1253,13 +1253,13 @@ il4965_ucode_callback(const struct firmware *ucode_raw, void *context)
 	}
 
 	if (api_ver != api_max)
-		IL_ERR(il,
+		IL_ERR(
 			"Firmware has old API version. Expected v%u, "
 			"got v%u. New firmware can be obtained "
 			"from http://www.intellinuxwireless.org.\n",
 			api_max, api_ver);
 
-	IL_INFO(il, "loaded firmware version %u.%u.%u.%u\n",
+	IL_INFO("loaded firmware version %u.%u.%u.%u\n",
 		 IL_UCODE_MAJOR(il->ucode_ver),
 		 IL_UCODE_MINOR(il->ucode_ver),
 		 IL_UCODE_API(il->ucode_ver),
@@ -1294,31 +1294,31 @@ il4965_ucode_callback(const struct firmware *ucode_raw, void *context)
 
 	/* Verify that uCode images will fit in card's SRAM */
 	if (pieces.inst_size > il->hw_params.max_inst_size) {
-		IL_ERR(il, "uCode instr len %Zd too large to fit in\n",
+		IL_ERR("uCode instr len %Zd too large to fit in\n",
 			pieces.inst_size);
 		goto try_again;
 	}
 
 	if (pieces.data_size > il->hw_params.max_data_size) {
-		IL_ERR(il, "uCode data len %Zd too large to fit in\n",
+		IL_ERR("uCode data len %Zd too large to fit in\n",
 			pieces.data_size);
 		goto try_again;
 	}
 
 	if (pieces.init_size > il->hw_params.max_inst_size) {
-		IL_ERR(il, "uCode init instr len %Zd too large to fit in\n",
+		IL_ERR("uCode init instr len %Zd too large to fit in\n",
 			pieces.init_size);
 		goto try_again;
 	}
 
 	if (pieces.init_data_size > il->hw_params.max_data_size) {
-		IL_ERR(il, "uCode init data len %Zd too large to fit in\n",
+		IL_ERR("uCode init data len %Zd too large to fit in\n",
 			pieces.init_data_size);
 		goto try_again;
 	}
 
 	if (pieces.boot_size > il->hw_params.max_bsm_size) {
-		IL_ERR(il, "uCode boot instr len %Zd too large to fit in\n",
+		IL_ERR("uCode boot instr len %Zd too large to fit in\n",
 			pieces.boot_size);
 		goto try_again;
 	}
@@ -1427,13 +1427,13 @@ il4965_ucode_callback(const struct firmware *ucode_raw, void *context)
 
 	err = il_dbgfs_register(il, DRV_NAME);
 	if (err)
-		IL_ERR(il,
+		IL_ERR(
 		"failed to create debugfs files. Ignoring error: %d\n", err);
 
 	err = sysfs_create_group(&il->pci_dev->dev.kobj,
 					&il_attribute_group);
 	if (err) {
-		IL_ERR(il, "failed to create sysfs device attributes\n");
+		IL_ERR("failed to create sysfs device attributes\n");
 		goto out_unbind;
 	}
 
@@ -1450,7 +1450,7 @@ il4965_ucode_callback(const struct firmware *ucode_raw, void *context)
 	return;
 
  err_pci_alloc:
-	IL_ERR(il, "failed to allocate pci memory\n");
+	IL_ERR("failed to allocate pci memory\n");
 	il4965_dealloc_ucode_pci(il);
  out_unbind:
 	complete(&il->_4965.firmware_loading_complete);
@@ -1541,7 +1541,7 @@ void il4965_dump_nic_error_log(struct il_priv *il)
 	}
 
 	if (!il->cfg->ops->lib->is_valid_rtc_data_addr(base)) {
-		IL_ERR(il,
+		IL_ERR(
 			"Not valid error log pointer 0x%08X for %s uCode\n",
 			base, (il->ucode_type == UCODE_INIT) ? "Init" : "RT");
 		return;
@@ -1550,8 +1550,8 @@ void il4965_dump_nic_error_log(struct il_priv *il)
 	count = il_read_targ_mem(il, base);
 
 	if (ERROR_START_OFFSET <= count * ERROR_ELEM_SIZE) {
-		IL_ERR(il, "Start IWL Error Log Dump:\n");
-		IL_ERR(il, "Status: 0x%08lX, count: %d\n",
+		IL_ERR("Start IWL Error Log Dump:\n");
+		IL_ERR("Status: 0x%08lX, count: %d\n",
 			il->status, count);
 	}
 
@@ -1568,12 +1568,12 @@ void il4965_dump_nic_error_log(struct il_priv *il)
 	time = il_read_targ_mem(il, base + 11 * sizeof(u32));
 	hcmd = il_read_targ_mem(il, base + 22 * sizeof(u32));
 
-	IL_ERR(il, "Desc                                  Time       "
+	IL_ERR("Desc                                  Time       "
 		"data1      data2      line\n");
-	IL_ERR(il, "%-28s (0x%04X) %010u 0x%08X 0x%08X %u\n",
+	IL_ERR("%-28s (0x%04X) %010u 0x%08X 0x%08X %u\n",
 		il4965_desc_lookup(desc), desc, time, data1, data2, line);
-	IL_ERR(il, "pc      blink1  blink2  ilink1  ilink2  hcmd\n");
-	IL_ERR(il, "0x%05X 0x%05X 0x%05X 0x%05X 0x%05X 0x%05X\n",
+	IL_ERR("pc      blink1  blink2  ilink1  ilink2  hcmd\n");
+	IL_ERR("0x%05X 0x%05X 0x%05X 0x%05X 0x%05X 0x%05X\n",
 		pc, blink1, blink2, ilink1, ilink2, hcmd);
 }
 
@@ -1594,7 +1594,7 @@ static void il4965_rf_kill_ct_config(struct il_priv *il)
 	ret = il_send_cmd_pdu(il, REPLY_CT_KILL_CONFIG_CMD,
 			       sizeof(cmd), &cmd);
 	if (ret)
-		IL_ERR(il, "REPLY_CT_KILL_CONFIG_CMD failed\n");
+		IL_ERR("REPLY_CT_KILL_CONFIG_CMD failed\n");
 	else
 		D_INFO("REPLY_CT_KILL_CONFIG_CMD "
 				"succeeded, "
@@ -1740,7 +1740,7 @@ static void il4965_alive_start(struct il_priv *il)
 
 	ret = il4965_alive_notify(il);
 	if (ret) {
-		IL_WARN(il,
+		IL_WARN(
 			"Could not complete ALIVE transition [ntf]: %d\n", ret);
 		goto restart;
 	}
@@ -1955,12 +1955,12 @@ static int __il4965_up(struct il_priv *il)
 	int ret;
 
 	if (test_bit(STATUS_EXIT_PENDING, &il->status)) {
-		IL_WARN(il, "Exit pending; will not bring the NIC up\n");
+		IL_WARN("Exit pending; will not bring the NIC up\n");
 		return -EIO;
 	}
 
 	if (!il->ucode_data_backup.v_addr || !il->ucode_data.v_addr) {
-		IL_ERR(il, "ucode not available for device bringup\n");
+		IL_ERR("ucode not available for device bringup\n");
 		return -EIO;
 	}
 
@@ -1975,7 +1975,7 @@ static int __il4965_up(struct il_priv *il)
 	il4965_prepare_card_hw(il);
 
 	if (!il->hw_ready) {
-		IL_WARN(il, "Exit HW not ready\n");
+		IL_WARN("Exit HW not ready\n");
 		return -EIO;
 	}
 
@@ -1990,7 +1990,7 @@ static int __il4965_up(struct il_priv *il)
 		wiphy_rfkill_set_hw_state(il->hw->wiphy, true);
 
 		il_enable_interrupts(il);
-		IL_WARN(il, "Radio disabled by HW RF Kill switch\n");
+		IL_WARN("Radio disabled by HW RF Kill switch\n");
 		return 0;
 	}
 
@@ -2001,7 +2001,7 @@ static int __il4965_up(struct il_priv *il)
 
 	ret = il4965_hw_nic_init(il);
 	if (ret) {
-		IL_ERR(il, "Unable to init nic\n");
+		IL_ERR("Unable to init nic\n");
 		return ret;
 	}
 
@@ -2032,7 +2032,7 @@ static int __il4965_up(struct il_priv *il)
 		ret = il->cfg->ops->lib->load_ucode(il);
 
 		if (ret) {
-			IL_ERR(il, "Unable to set up bootstrap uCode: %d\n",
+			IL_ERR("Unable to set up bootstrap uCode: %d\n",
 				ret);
 			continue;
 		}
@@ -2051,7 +2051,7 @@ static int __il4965_up(struct il_priv *il)
 
 	/* tried to restart and config the device for as long as our
 	 * patience could withstand */
-	IL_ERR(il, "Unable to initialize device after %d attempts.\n", i);
+	IL_ERR("Unable to initialize device after %d attempts.\n", i);
 	return -EIO;
 }
 
@@ -2229,7 +2229,7 @@ static int il4965_mac_setup_register(struct il_priv *il,
 
 	ret = ieee80211_register_hw(il->hw);
 	if (ret) {
-		IL_ERR(il, "Failed to register hw (error %d)\n", ret);
+		IL_ERR("Failed to register hw (error %d)\n", ret);
 		return ret;
 	}
 	il->mac80211_registered = 1;
@@ -2265,7 +2265,7 @@ int il4965_mac_start(struct ieee80211_hw *hw)
 			UCODE_READY_TIMEOUT);
 	if (!ret) {
 		if (!test_bit(STATUS_READY, &il->status)) {
-			IL_ERR(il, "START_ALIVE timeout after %dms.\n",
+			IL_ERR("START_ALIVE timeout after %dms.\n",
 				jiffies_to_msecs(UCODE_READY_TIMEOUT));
 			return -ETIMEDOUT;
 		}
@@ -2475,7 +2475,7 @@ int il4965_mac_sta_add(struct ieee80211_hw *hw,
 	ret = il_add_station_common(il, vif_priv->ctx, sta->addr,
 				     is_ap, sta, &sta_id);
 	if (ret) {
-		IL_ERR(il, "Unable to add station %pM (%d)\n",
+		IL_ERR("Unable to add station %pM (%d)\n",
 			sta->addr, ret);
 		/* Should we return success if return code is EEXIST ? */
 		mutex_unlock(&il->mutex);
@@ -2792,13 +2792,13 @@ static int il4965_init_drv(struct il_priv *il)
 
 	ret = il_init_channel_map(il);
 	if (ret) {
-		IL_ERR(il, "initializing regulatory failed: %d\n", ret);
+		IL_ERR("initializing regulatory failed: %d\n", ret);
 		goto err;
 	}
 
 	ret = il_init_geos(il);
 	if (ret) {
-		IL_ERR(il, "initializing geos failed: %d\n", ret);
+		IL_ERR("initializing geos failed: %d\n", ret);
 		goto err_free_channel_map;
 	}
 	il4965_init_hw_rates(il, il->ieee_rates);
@@ -2917,7 +2917,7 @@ il4965_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	il->inta_mask = CSR_INI_SET_MASK;
 
 	if (il_alloc_traffic_mem(il))
-		IL_ERR(il, "Not enough memory to generate traffic log\n");
+		IL_ERR("Not enough memory to generate traffic log\n");
 
 	/**************************
 	 * 2. Initializing PCI bus
@@ -2942,7 +2942,7 @@ il4965_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 							DMA_BIT_MASK(32));
 		/* both attempts failed: */
 		if (err) {
-			IL_WARN(il, "No suitable DMA available.\n");
+			IL_WARN("No suitable DMA available.\n");
 			goto out_pci_disable_device;
 		}
 	}
@@ -2981,7 +2981,7 @@ il4965_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	il_write32(il, CSR_RESET, CSR_RESET_REG_FLAG_NEVO_RESET);
 
 	il4965_hw_detect(il);
-	IL_INFO(il, "Detected %s, REV=0x%X\n",
+	IL_INFO("Detected %s, REV=0x%X\n",
 		il->cfg->name, il->hw_rev);
 
 	/* We disable the RETRY_TIMEOUT register (0x41) to keep
@@ -2990,7 +2990,7 @@ il4965_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	il4965_prepare_card_hw(il);
 	if (!il->hw_ready) {
-		IL_WARN(il, "Failed, HW not ready\n");
+		IL_WARN("Failed, HW not ready\n");
 		goto out_iounmap;
 	}
 
@@ -3000,7 +3000,7 @@ il4965_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	/* Read the EEPROM */
 	err = il_eeprom_init(il);
 	if (err) {
-		IL_ERR(il, "Unable to init EEPROM\n");
+		IL_ERR("Unable to init EEPROM\n");
 		goto out_iounmap;
 	}
 	err = il4965_eeprom_check_version(il);
@@ -3020,7 +3020,7 @@ il4965_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	 * 5. Setup HW constants
 	 ************************/
 	if (il4965_set_hw_params(il)) {
-		IL_ERR(il, "failed to set hw parameters\n");
+		IL_ERR("failed to set hw parameters\n");
 		goto out_free_eeprom;
 	}
 
@@ -3045,7 +3045,7 @@ il4965_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	err = request_irq(il->pci_dev->irq, il_isr,
 			  IRQF_SHARED, DRV_NAME, il);
 	if (err) {
-		IL_ERR(il, "Error allocating IRQ %d\n", il->pci_dev->irq);
+		IL_ERR("Error allocating IRQ %d\n", il->pci_dev->irq);
 		goto out_disable_msi;
 	}
 
-- 
1.7.1

