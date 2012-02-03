Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34865 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754530Ab2BCMIi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Feb 2012 07:08:38 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 22/25] iwlegacy: move ops out of config
Date: Fri,  3 Feb 2012 13:07:22 +0100
Message-Id: <1328270845-16891-23-git-send-email-sgruszka@redhat.com> (sfid-20120203_130852_001003_4635B329)
In-Reply-To: <1328270845-16891-1-git-send-email-sgruszka@redhat.com>
References: <1328270845-16891-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlegacy/3945-mac.c   |   22 +++---
 drivers/net/wireless/iwlegacy/3945.c       |   13 +--
 drivers/net/wireless/iwlegacy/3945.h       |    4 +-
 drivers/net/wireless/iwlegacy/4965-calib.c |    4 +-
 drivers/net/wireless/iwlegacy/4965-mac.c   |   78 ++++++++++++-------
 drivers/net/wireless/iwlegacy/4965.c       |   34 +-------
 drivers/net/wireless/iwlegacy/4965.h       |    3 +-
 drivers/net/wireless/iwlegacy/common.c     |  115 +++++++++++-----------------
 drivers/net/wireless/iwlegacy/common.h     |    8 +-
 drivers/net/wireless/iwlegacy/debug.c      |   13 +--
 10 files changed, 127 insertions(+), 167 deletions(-)

diff --git a/drivers/net/wireless/iwlegacy/3945-mac.c b/drivers/net/wireless/iwlegacy/3945-mac.c
index b2e04c5..40ce692 100644
--- a/drivers/net/wireless/iwlegacy/3945-mac.c
+++ b/drivers/net/wireless/iwlegacy/3945-mac.c
@@ -618,8 +618,7 @@ il3945_tx_skb(struct il_priv *il, struct sk_buff *skb)
 
 	/* Add buffer containing Tx command and MAC(!) header to TFD's
 	 * first entry */
-	il->cfg->ops->lib->txq_attach_buf_to_tfd(il, txq, txcmd_phys, len, 1,
-						 0);
+	il->ops->lib->txq_attach_buf_to_tfd(il, txq, txcmd_phys, len, 1, 0);
 
 	/* Set up TFD's 2nd entry to point directly to remainder of skb,
 	 * if any (802.11 null frames have no payload). */
@@ -628,8 +627,8 @@ il3945_tx_skb(struct il_priv *il, struct sk_buff *skb)
 		phys_addr =
 		    pci_map_single(il->pci_dev, skb->data + hdr_len, len,
 				   PCI_DMA_TODEVICE);
-		il->cfg->ops->lib->txq_attach_buf_to_tfd(il, txq, phys_addr,
-							 len, 0, U32_PAD(len));
+		il->ops->lib->txq_attach_buf_to_tfd(il, txq, phys_addr, len, 0,
+						    U32_PAD(len));
 	}
 
 	/* Tell device the write idx *just past* this latest filled TFD */
@@ -2416,7 +2415,7 @@ __il3945_up(struct il_priv *il)
 		/* load bootstrap state machine,
 		 * load bootstrap program into processor's memory,
 		 * prepare to load the "initialize" uCode */
-		rc = il->cfg->ops->lib->load_ucode(il);
+		rc = il->ops->lib->load_ucode(il);
 
 		if (rc) {
 			IL_ERR("Unable to set up bootstrap uCode: %d\n", rc);
@@ -3458,7 +3457,7 @@ static struct attribute_group il3945_attribute_group = {
 	.attrs = il3945_sysfs_entries,
 };
 
-struct ieee80211_ops il3945_hw_ops = {
+struct ieee80211_ops il3945_mac_ops = {
 	.tx = il3945_mac_tx,
 	.start = il3945_mac_start,
 	.stop = il3945_mac_stop,
@@ -3599,15 +3598,13 @@ il3945_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	 * 1. Allocating HW data
 	 * ********************/
 
-	/* mac80211 allocates memory for this device instance, including
-	 *   space for this driver's ilate structure */
-	hw = il_alloc_all(cfg);
-	if (hw == NULL) {
-		pr_err("Can not allocate network device\n");
+	hw = ieee80211_alloc_hw(sizeof(struct il_priv), &il3945_mac_ops);
+	if (!hw) {
 		err = -ENOMEM;
 		goto out;
 	}
 	il = hw->priv;
+	il->hw = hw;
 	SET_IEEE80211_DEV(hw, &pdev->dev);
 
 	il->cmd_queue = IL39_CMD_QUEUE_NUM;
@@ -3618,11 +3615,12 @@ il3945_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	 */
 	if (il3945_mod_params.disable_hw_scan) {
 		D_INFO("Disabling hw_scan\n");
-		il3945_hw_ops.hw_scan = NULL;
+		il3945_mac_ops.hw_scan = NULL;
 	}
 
 	D_INFO("*** LOAD DRIVER ***\n");
 	il->cfg = cfg;
+	il->ops = &il3945_ops;
 	il->pci_dev = pdev;
 	il->inta_mask = CSR_INI_SET_MASK;
 
diff --git a/drivers/net/wireless/iwlegacy/3945.c b/drivers/net/wireless/iwlegacy/3945.c
index 1e617c9..918cbef 100644
--- a/drivers/net/wireless/iwlegacy/3945.c
+++ b/drivers/net/wireless/iwlegacy/3945.c
@@ -303,7 +303,7 @@ il3945_tx_queue_reclaim(struct il_priv *il, int txq_id, int idx)
 		tx_info = &txq->txb[txq->q.read_ptr];
 		ieee80211_tx_status_irqsafe(il->hw, tx_info->skb);
 		tx_info->skb = NULL;
-		il->cfg->ops->lib->txq_free_tfd(il, txq);
+		il->ops->lib->txq_free_tfd(il, txq);
 	}
 
 	if (il_queue_space(q) > q->low_mark && txq_id >= 0 &&
@@ -960,12 +960,12 @@ il3945_hw_nic_init(struct il_priv *il)
 	struct il_rx_queue *rxq = &il->rxq;
 
 	spin_lock_irqsave(&il->lock, flags);
-	il->cfg->ops->lib->apm_ops.init(il);
+	il->ops->lib->apm_ops.init(il);
 	spin_unlock_irqrestore(&il->lock, flags);
 
 	il3945_set_pwr_vmain(il);
 
-	il->cfg->ops->lib->apm_ops.config(il);
+	il->ops->lib->apm_ops.config(il);
 
 	/* Allocate the RX queue, or reset if it is already allocated */
 	if (!rxq->bd) {
@@ -1615,7 +1615,7 @@ il3945_hw_reg_comp_txpower_temp(struct il_priv *il)
 	}
 
 	/* send Txpower command for current channel to ucode */
-	return il->cfg->ops->lib->send_tx_power(il);
+	return il->ops->lib->send_tx_power(il);
 }
 
 int
@@ -2685,13 +2685,12 @@ static struct il_hcmd_utils_ops il3945_hcmd_utils = {
 	.post_scan = il3945_post_scan,
 };
 
-static const struct il_ops il3945_ops = {
+const struct il_ops il3945_ops = {
 	.lib = &il3945_lib,
 	.hcmd = &il3945_hcmd,
 	.utils = &il3945_hcmd_utils,
 	.led = &il3945_led_ops,
 	.legacy = &il3945_legacy_ops,
-	.ieee80211_ops = &il3945_hw_ops,
 };
 
 static struct il_base_params il3945_base_params = {
@@ -2711,7 +2710,6 @@ static struct il_cfg il3945_bg_cfg = {
 	.ucode_api_min = IL3945_UCODE_API_MIN,
 	.sku = IL_SKU_G,
 	.eeprom_ver = EEPROM_3945_EEPROM_VERSION,
-	.ops = &il3945_ops,
 	.mod_params = &il3945_mod_params,
 	.base_params = &il3945_base_params,
 	.led_mode = IL_LED_BLINK,
@@ -2724,7 +2722,6 @@ static struct il_cfg il3945_abg_cfg = {
 	.ucode_api_min = IL3945_UCODE_API_MIN,
 	.sku = IL_SKU_A | IL_SKU_G,
 	.eeprom_ver = EEPROM_3945_EEPROM_VERSION,
-	.ops = &il3945_ops,
 	.mod_params = &il3945_mod_params,
 	.base_params = &il3945_base_params,
 	.led_mode = IL_LED_BLINK,
diff --git a/drivers/net/wireless/iwlegacy/3945.h b/drivers/net/wireless/iwlegacy/3945.h
index 8bee127..c00a8d3 100644
--- a/drivers/net/wireless/iwlegacy/3945.h
+++ b/drivers/net/wireless/iwlegacy/3945.h
@@ -36,6 +36,8 @@ extern const struct pci_device_id il3945_hw_card_ids[];
 
 #include "common.h"
 
+extern const struct il_ops il3945_ops;
+
 /* Highest firmware API version supported */
 #define IL3945_UCODE_API_MAX 2
 
@@ -261,8 +263,6 @@ extern int il3945_commit_rxon(struct il_priv *il);
  */
 extern u8 il3945_hw_find_station(struct il_priv *il, const u8 * bssid);
 
-extern struct ieee80211_ops il3945_hw_ops;
-
 extern __le32 il3945_get_antenna_flags(const struct il_priv *il);
 extern int il3945_init_hw_rate_table(struct il_priv *il);
 extern void il3945_reg_txpower_periodic(struct il_priv *il);
diff --git a/drivers/net/wireless/iwlegacy/4965-calib.c b/drivers/net/wireless/iwlegacy/4965-calib.c
index f302a6a..bfb361d 100644
--- a/drivers/net/wireless/iwlegacy/4965-calib.c
+++ b/drivers/net/wireless/iwlegacy/4965-calib.c
@@ -923,8 +923,8 @@ il4965_chain_noise_calibration(struct il_priv *il, void *stat_resp)
 	/* Some power changes may have been made during the calibration.
 	 * Update and commit the RXON
 	 */
-	if (il->cfg->ops->lib->update_chain_flags)
-		il->cfg->ops->lib->update_chain_flags(il);
+	if (il->ops->lib->update_chain_flags)
+		il->ops->lib->update_chain_flags(il);
 
 	data->state = IL_CHAIN_NOISE_DONE;
 	il_power_update_mode(il, false);
diff --git a/drivers/net/wireless/iwlegacy/4965-mac.c b/drivers/net/wireless/iwlegacy/4965-mac.c
index 4be53cc..2bf743f 100644
--- a/drivers/net/wireless/iwlegacy/4965-mac.c
+++ b/drivers/net/wireless/iwlegacy/4965-mac.c
@@ -201,7 +201,7 @@ il4965_hw_nic_init(struct il_priv *il)
 
 	/* nic_init */
 	spin_lock_irqsave(&il->lock, flags);
-	il->cfg->ops->lib->apm_ops.init(il);
+	il->ops->lib->apm_ops.init(il);
 
 	/* Set interrupt coalescing calibration timer to default (512 usecs) */
 	il_write8(il, CSR_INT_COALESCING, IL_HOST_INT_CALIB_TIMEOUT_DEF);
@@ -210,7 +210,7 @@ il4965_hw_nic_init(struct il_priv *il)
 
 	il4965_set_pwr_vmain(il);
 
-	il->cfg->ops->lib->apm_ops.config(il);
+	il->ops->lib->apm_ops.config(il);
 
 	/* Allocate the RX queue, or reset if it is already allocated */
 	if (!rxq->bd) {
@@ -1381,8 +1381,8 @@ il4965_hdl_stats(struct il_priv *il, struct il_rx_buf *rxb)
 		il4965_rx_calc_noise(il);
 		queue_work(il->workqueue, &il->run_time_calib_work);
 	}
-	if (il->cfg->ops->lib->temp_ops.temperature && change)
-		il->cfg->ops->lib->temp_ops.temperature(il);
+	if (il->ops->lib->temp_ops.temperature && change)
+		il->ops->lib->temp_ops.temperature(il);
 }
 
 void
@@ -1817,8 +1817,7 @@ il4965_tx_skb(struct il_priv *il, struct sk_buff *skb)
 	dma_unmap_len_set(out_meta, len, firstlen);
 	/* Add buffer containing Tx command and MAC(!) header to TFD's
 	 * first entry */
-	il->cfg->ops->lib->txq_attach_buf_to_tfd(il, txq, txcmd_phys, firstlen,
-						 1, 0);
+	il->ops->lib->txq_attach_buf_to_tfd(il, txq, txcmd_phys, firstlen, 1, 0);
 
 	if (!ieee80211_has_morefrags(hdr->frame_control)) {
 		txq->need_update = 1;
@@ -1834,8 +1833,8 @@ il4965_tx_skb(struct il_priv *il, struct sk_buff *skb)
 		phys_addr =
 		    pci_map_single(il->pci_dev, skb->data + hdr_len, secondlen,
 				   PCI_DMA_TODEVICE);
-		il->cfg->ops->lib->txq_attach_buf_to_tfd(il, txq, phys_addr,
-							 secondlen, 0, 0);
+		il->ops->lib->txq_attach_buf_to_tfd(il, txq, phys_addr,
+						    secondlen, 0, 0);
 	}
 
 	scratch_phys =
@@ -1855,9 +1854,8 @@ il4965_tx_skb(struct il_priv *il, struct sk_buff *skb)
 
 	/* Set up entry for this TFD in Tx byte-count array */
 	if (info->flags & IEEE80211_TX_CTL_AMPDU)
-		il->cfg->ops->lib->txq_update_byte_cnt_tbl(il, txq,
-							   le16_to_cpu(tx_cmd->
-								       len));
+		il->ops->lib->txq_update_byte_cnt_tbl(il, txq,
+						      le16_to_cpu(tx_cmd->len));
 
 	pci_dma_sync_single_for_device(il->pci_dev, txcmd_phys, firstlen,
 				       PCI_DMA_BIDIRECTIONAL);
@@ -2479,7 +2477,7 @@ il4965_tx_queue_reclaim(struct il_priv *il, int txq_id, int idx)
 				 txq_id >= IL4965_FIRST_AMPDU_QUEUE);
 		tx_info->skb = NULL;
 
-		il->cfg->ops->lib->txq_free_tfd(il, txq);
+		il->ops->lib->txq_free_tfd(il, txq);
 	}
 	return nfreed;
 }
@@ -3357,8 +3355,8 @@ il4965_sta_modify_sleep_tx_count(struct il_priv *il, int sta_id, int cnt)
 void
 il4965_update_chain_flags(struct il_priv *il)
 {
-	if (il->cfg->ops->hcmd->set_rxon_chain) {
-		il->cfg->ops->hcmd->set_rxon_chain(il);
+	if (il->ops->hcmd->set_rxon_chain) {
+		il->ops->hcmd->set_rxon_chain(il);
 		if (il->active.rx_chain != il->staging.rx_chain)
 			il_commit_rxon(il);
 	}
@@ -3878,7 +3876,7 @@ il4965_setup_handlers(struct il_priv *il)
 	/* block ack */
 	il->handlers[N_COMPRESSED_BA] = il4965_hdl_compressed_ba;
 	/* Set up hardware specific Rx handlers */
-	il->cfg->ops->lib->handler_setup(il);
+	il->ops->lib->handler_setup(il);
 }
 
 /**
@@ -4780,7 +4778,7 @@ il4965_dump_nic_error_log(struct il_priv *il)
 	else
 		base = le32_to_cpu(il->card_alive.error_event_table_ptr);
 
-	if (!il->cfg->ops->lib->is_valid_rtc_data_addr(base)) {
+	if (!il->ops->lib->is_valid_rtc_data_addr(base)) {
 		IL_ERR("Not valid error log pointer 0x%08X for %s uCode\n",
 		       base, (il->ucode_type == UCODE_INIT) ? "Init" : "RT");
 		return;
@@ -5009,8 +5007,8 @@ il4965_alive_start(struct il_priv *il)
 		/* Initialize our rx_config data */
 		il_connection_init_rx_config(il);
 
-		if (il->cfg->ops->hcmd->set_rxon_chain)
-			il->cfg->ops->hcmd->set_rxon_chain(il);
+		if (il->ops->hcmd->set_rxon_chain)
+			il->ops->hcmd->set_rxon_chain(il);
 	}
 
 	/* Configure bluetooth coexistence if enabled */
@@ -5282,7 +5280,7 @@ __il4965_up(struct il_priv *il)
 		/* load bootstrap state machine,
 		 * load bootstrap program into processor's memory,
 		 * prepare to load the "initialize" uCode */
-		ret = il->cfg->ops->lib->load_ucode(il);
+		ret = il->ops->lib->load_ucode(il);
 
 		if (ret) {
 			IL_ERR("Unable to set up bootstrap uCode: %d\n", ret);
@@ -5323,7 +5321,7 @@ il4965_bg_init_alive_start(struct work_struct *data)
 	if (test_bit(S_EXIT_PENDING, &il->status))
 		goto out;
 
-	il->cfg->ops->lib->init_alive_start(il);
+	il->ops->lib->init_alive_start(il);
 out:
 	mutex_unlock(&il->mutex);
 }
@@ -5755,7 +5753,7 @@ il4965_mac_channel_switch(struct ieee80211_hw *hw,
 	if (!il_is_associated(il))
 		goto out;
 
-	if (!il->cfg->ops->lib->set_channel_switch)
+	if (!il->ops->lib->set_channel_switch)
 		goto out;
 
 	ch = channel->hw_value;
@@ -5807,7 +5805,7 @@ il4965_mac_channel_switch(struct ieee80211_hw *hw,
 	 */
 	set_bit(S_CHANNEL_SWITCH_PENDING, &il->status);
 	il->switch_channel = cpu_to_le16(ch);
-	if (il->cfg->ops->lib->set_channel_switch(il, ch_switch)) {
+	if (il->ops->lib->set_channel_switch(il, ch_switch)) {
 		clear_bit(S_CHANNEL_SWITCH_PENDING, &il->status);
 		il->switch_channel = 0;
 		ieee80211_chswitch_done(il->vif, false);
@@ -5890,7 +5888,7 @@ il4965_bg_txpower_work(struct work_struct *work)
 	/* Regardless of if we are associated, we must reconfigure the
 	 * TX power since frames can be sent on non-radar channels while
 	 * not associated */
-	il->cfg->ops->lib->send_tx_power(il);
+	il->ops->lib->send_tx_power(il);
 
 	/* Update last_temperature to keep is_calib_needed from running
 	 * when it isn't needed... */
@@ -5996,6 +5994,28 @@ il4965_tx_queue_set_status(struct il_priv *il, struct il_tx_queue *txq,
 	       scd_retry ? "BA" : "AC", txq_id, tx_fifo_id);
 }
 
+const struct ieee80211_ops il4965_mac_ops = {
+	.tx = il4965_mac_tx,
+	.start = il4965_mac_start,
+	.stop = il4965_mac_stop,
+	.add_interface = il_mac_add_interface,
+	.remove_interface = il_mac_remove_interface,
+	.change_interface = il_mac_change_interface,
+	.config = il_mac_config,
+	.configure_filter = il4965_configure_filter,
+	.set_key = il4965_mac_set_key,
+	.update_tkip_key = il4965_mac_update_tkip_key,
+	.conf_tx = il_mac_conf_tx,
+	.reset_tsf = il_mac_reset_tsf,
+	.bss_info_changed = il_mac_bss_info_changed,
+	.ampdu_action = il4965_mac_ampdu_action,
+	.hw_scan = il_mac_hw_scan,
+	.sta_add = il4965_mac_sta_add,
+	.sta_remove = il_mac_sta_remove,
+	.channel_switch = il4965_mac_channel_switch,
+	.tx_last_beacon = il_mac_tx_last_beacon,
+};
+
 static int
 il4965_init_drv(struct il_priv *il)
 {
@@ -6020,8 +6040,8 @@ il4965_init_drv(struct il_priv *il)
 	il->force_reset.reset_duration = IL_DELAY_NEXT_FORCE_FW_RELOAD;
 
 	/* Choose which receivers/antennas to use */
-	if (il->cfg->ops->hcmd->set_rxon_chain)
-		il->cfg->ops->hcmd->set_rxon_chain(il);
+	if (il->ops->hcmd->set_rxon_chain)
+		il->ops->hcmd->set_rxon_chain(il);
 
 	il_init_scan_params(il);
 
@@ -6081,7 +6101,7 @@ il4965_set_hw_params(struct il_priv *il)
 		il->cfg->sku &= ~IL_SKU_N;
 
 	/* Device-specific setup */
-	return il->cfg->ops->lib->set_hw_params(il);
+	return il->ops->lib->set_hw_params(il);
 }
 
 static int
@@ -6098,18 +6118,18 @@ il4965_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	 * 1. Allocating HW data
 	 ************************/
 
-	hw = il_alloc_all(cfg);
+	hw = ieee80211_alloc_hw(sizeof(struct il_priv), &il4965_mac_ops);
 	if (!hw) {
 		err = -ENOMEM;
 		goto out;
 	}
 	il = hw->priv;
-	/* At this point both hw and il are allocated. */
-
+	il->hw = hw;
 	SET_IEEE80211_DEV(hw, &pdev->dev);
 
 	D_INFO("*** LOAD DRIVER ***\n");
 	il->cfg = cfg;
+	il->ops = &il4965_ops;
 	il->pci_dev = pdev;
 	il->inta_mask = CSR_INI_SET_MASK;
 
diff --git a/drivers/net/wireless/iwlegacy/4965.c b/drivers/net/wireless/iwlegacy/4965.c
index 9d9197f..27feb53 100644
--- a/drivers/net/wireless/iwlegacy/4965.c
+++ b/drivers/net/wireless/iwlegacy/4965.c
@@ -2166,8 +2166,8 @@ il4965_post_associate(struct il_priv *il)
 
 	il_set_rxon_ht(il, &il->current_ht_config);
 
-	if (il->cfg->ops->hcmd->set_rxon_chain)
-		il->cfg->ops->hcmd->set_rxon_chain(il);
+	if (il->ops->hcmd->set_rxon_chain)
+		il->ops->hcmd->set_rxon_chain(il);
 
 	il->staging.assoc_id = cpu_to_le16(vif->bss_conf.aid);
 
@@ -2241,8 +2241,8 @@ il4965_config_ap(struct il_priv *il)
 		/* AP has all antennas */
 		il->chain_noise_data.active_chains = il->hw_params.valid_rx_ant;
 		il_set_rxon_ht(il, &il->current_ht_config);
-		if (il->cfg->ops->hcmd->set_rxon_chain)
-			il->cfg->ops->hcmd->set_rxon_chain(il);
+		if (il->ops->hcmd->set_rxon_chain)
+			il->ops->hcmd->set_rxon_chain(il);
 
 		il->staging.assoc_id = 0;
 
@@ -2323,35 +2323,12 @@ static const struct il_legacy_ops il4965_legacy_ops = {
 	.update_bcast_stations = il4965_update_bcast_stations,
 };
 
-struct ieee80211_ops il4965_hw_ops = {
-	.tx = il4965_mac_tx,
-	.start = il4965_mac_start,
-	.stop = il4965_mac_stop,
-	.add_interface = il_mac_add_interface,
-	.remove_interface = il_mac_remove_interface,
-	.change_interface = il_mac_change_interface,
-	.config = il_mac_config,
-	.configure_filter = il4965_configure_filter,
-	.set_key = il4965_mac_set_key,
-	.update_tkip_key = il4965_mac_update_tkip_key,
-	.conf_tx = il_mac_conf_tx,
-	.reset_tsf = il_mac_reset_tsf,
-	.bss_info_changed = il_mac_bss_info_changed,
-	.ampdu_action = il4965_mac_ampdu_action,
-	.hw_scan = il_mac_hw_scan,
-	.sta_add = il4965_mac_sta_add,
-	.sta_remove = il_mac_sta_remove,
-	.channel_switch = il4965_mac_channel_switch,
-	.tx_last_beacon = il_mac_tx_last_beacon,
-};
-
-static const struct il_ops il4965_ops = {
+const struct il_ops il4965_ops = {
 	.lib = &il4965_lib,
 	.hcmd = &il4965_hcmd,
 	.utils = &il4965_hcmd_utils,
 	.led = &il4965_led_ops,
 	.legacy = &il4965_legacy_ops,
-	.ieee80211_ops = &il4965_hw_ops,
 };
 
 static struct il_base_params il4965_base_params = {
@@ -2380,7 +2357,6 @@ struct il_cfg il4965_cfg = {
 	.valid_rx_ant = ANT_ABC,
 	.eeprom_ver = EEPROM_4965_EEPROM_VERSION,
 	.eeprom_calib_ver = EEPROM_4965_TX_POWER_VERSION,
-	.ops = &il4965_ops,
 	.mod_params = &il4965_mod_params,
 	.base_params = &il4965_base_params,
 	.led_mode = IL_LED_BLINK,
diff --git a/drivers/net/wireless/iwlegacy/4965.h b/drivers/net/wireless/iwlegacy/4965.h
index 6789960..83ab604 100644
--- a/drivers/net/wireless/iwlegacy/4965.h
+++ b/drivers/net/wireless/iwlegacy/4965.h
@@ -38,11 +38,10 @@ struct il_rxon_context;
 
 /* configuration for the _4965 devices */
 extern struct il_cfg il4965_cfg;
+extern const struct il_ops il4965_ops;
 
 extern struct il_mod_params il4965_mod_params;
 
-extern struct ieee80211_ops il4965_hw_ops;
-
 /* tx queue */
 void il4965_free_tfds_in_queue(struct il_priv *il, int sta_id, int tid,
 			       int freed);
diff --git a/drivers/net/wireless/iwlegacy/common.c b/drivers/net/wireless/iwlegacy/common.c
index bee11a3..3bd1833 100644
--- a/drivers/net/wireless/iwlegacy/common.c
+++ b/drivers/net/wireless/iwlegacy/common.c
@@ -520,7 +520,7 @@ il_led_cmd(struct il_priv *il, unsigned long on, unsigned long off)
 	    il_blink_compensation(il, off,
 				  il->cfg->base_params->led_compensation);
 
-	ret = il->cfg->ops->led->cmd(il, &led_cmd);
+	ret = il->ops->led->cmd(il, &led_cmd);
 	if (!ret) {
 		il->blink_on = on;
 		il->blink_off = off;
@@ -731,7 +731,7 @@ il_eeprom_init(struct il_priv *il)
 	}
 	e = (__le16 *) il->eeprom;
 
-	il->cfg->ops->lib->apm_ops.init(il);
+	il->ops->lib->apm_ops.init(il);
 
 	ret = il_eeprom_verify_signature(il);
 	if (ret < 0) {
@@ -741,7 +741,7 @@ il_eeprom_init(struct il_priv *il)
 	}
 
 	/* Make sure driver (instead of uCode) is allowed to read EEPROM */
-	ret = il->cfg->ops->lib->eeprom_ops.acquire_semaphore(il);
+	ret = il->ops->lib->eeprom_ops.acquire_semaphore(il);
 	if (ret < 0) {
 		IL_ERR("Failed to acquire EEPROM semaphore.\n");
 		ret = -ENOENT;
@@ -773,7 +773,7 @@ il_eeprom_init(struct il_priv *il)
 
 	ret = 0;
 done:
-	il->cfg->ops->lib->eeprom_ops.release_semaphore(il);
+	il->ops->lib->eeprom_ops.release_semaphore(il);
 
 err:
 	if (ret)
@@ -800,7 +800,7 @@ il_init_band_reference(const struct il_priv *il, int eep_band,
 		       const u8 **eeprom_ch_idx)
 {
 	u32 offset =
-	    il->cfg->ops->lib->eeprom_ops.regulatory_bands[eep_band - 1];
+	    il->ops->lib->eeprom_ops.regulatory_bands[eep_band - 1];
 	switch (eep_band) {
 	case 1:		/* 2.4GHz band */
 		*eeprom_ch_count = ARRAY_SIZE(il_eeprom_band_1);
@@ -1001,9 +1001,9 @@ il_init_channel_map(struct il_priv *il)
 	}
 
 	/* Check if we do have HT40 channels */
-	if (il->cfg->ops->lib->eeprom_ops.regulatory_bands[5] ==
+	if (il->ops->lib->eeprom_ops.regulatory_bands[5] ==
 	    EEPROM_REGULATORY_BAND_NO_HT40 &&
-	    il->cfg->ops->lib->eeprom_ops.regulatory_bands[6] ==
+	    il->ops->lib->eeprom_ops.regulatory_bands[6] ==
 	    EEPROM_REGULATORY_BAND_NO_HT40)
 		return 0;
 
@@ -1158,9 +1158,9 @@ il_power_set_mode(struct il_priv *il, struct il_powertable_cmd *cmd, bool force)
 		if (!(cmd->flags & IL_POWER_DRIVER_ALLOW_SLEEP_MSK))
 			clear_bit(S_POWER_PMI, &il->status);
 
-		if (il->cfg->ops->lib->update_chain_flags && update_chains)
-			il->cfg->ops->lib->update_chain_flags(il);
-		else if (il->cfg->ops->lib->update_chain_flags)
+		if (il->ops->lib->update_chain_flags && update_chains)
+			il->ops->lib->update_chain_flags(il);
+		else if (il->ops->lib->update_chain_flags)
 			D_POWER("Cannot update the power, chain noise "
 				"calibration running: %d\n",
 				il->chain_noise_data.state);
@@ -1485,7 +1485,7 @@ il_scan_initiate(struct il_priv *il, struct ieee80211_vif *vif)
 
 	lockdep_assert_held(&il->mutex);
 
-	if (WARN_ON(!il->cfg->ops->utils->request_scan))
+	if (WARN_ON(!il->ops->utils->request_scan))
 		return -EOPNOTSUPP;
 
 	cancel_delayed_work(&il->scan_check);
@@ -1510,7 +1510,7 @@ il_scan_initiate(struct il_priv *il, struct ieee80211_vif *vif)
 	set_bit(S_SCANNING, &il->status);
 	il->scan_start = jiffies;
 
-	ret = il->cfg->ops->utils->request_scan(il, vif);
+	ret = il->ops->utils->request_scan(il, vif);
 	if (ret) {
 		clear_bit(S_SCANNING, &il->status);
 		return ret;
@@ -1672,7 +1672,7 @@ out_settings:
 	il_power_set_mode(il, &il->power_data.sleep_cmd_next, false);
 	il_set_tx_power(il, il->tx_power_next, false);
 
-	il->cfg->ops->utils->post_scan(il);
+	il->ops->utils->post_scan(il);
 
 out:
 	mutex_unlock(&il->mutex);
@@ -1814,7 +1814,7 @@ il_send_add_sta(struct il_priv *il, struct il_addsta_cmd *sta, u8 flags)
 		might_sleep();
 	}
 
-	cmd.len = il->cfg->ops->utils->build_addsta_hcmd(sta, data);
+	cmd.len = il->ops->utils->build_addsta_hcmd(sta, data);
 	ret = il_send_cmd(il, &cmd);
 
 	if (ret || (flags & CMD_ASYNC))
@@ -2722,7 +2722,7 @@ il_tx_queue_unmap(struct il_priv *il, int txq_id)
 		return;
 
 	while (q->write_ptr != q->read_ptr) {
-		il->cfg->ops->lib->txq_free_tfd(il, txq);
+		il->ops->lib->txq_free_tfd(il, txq);
 		q->read_ptr = il_queue_inc_wrap(q->read_ptr, q->n_bd);
 	}
 }
@@ -3024,7 +3024,7 @@ il_tx_queue_init(struct il_priv *il, struct il_tx_queue *txq, int slots_num,
 	il_queue_init(il, &txq->q, TFD_QUEUE_SIZE_MAX, slots_num, txq_id);
 
 	/* Tell device where to find queue */
-	il->cfg->ops->lib->txq_init(il, txq);
+	il->ops->lib->txq_init(il, txq);
 
 	return 0;
 err:
@@ -3055,7 +3055,7 @@ il_tx_queue_reset(struct il_priv *il, struct il_tx_queue *txq, int slots_num,
 	il_queue_init(il, &txq->q, TFD_QUEUE_SIZE_MAX, slots_num, txq_id);
 
 	/* Tell device where to find queue */
-	il->cfg->ops->lib->txq_init(il, txq);
+	il->ops->lib->txq_init(il, txq);
 }
 EXPORT_SYMBOL(il_tx_queue_reset);
 
@@ -3083,7 +3083,7 @@ il_enqueue_hcmd(struct il_priv *il, struct il_host_cmd *cmd)
 	u32 idx;
 	u16 fix_size;
 
-	cmd->len = il->cfg->ops->utils->get_hcmd_size(cmd->id, cmd->len);
+	cmd->len = il->ops->utils->get_hcmd_size(cmd->id, cmd->len);
 	fix_size = (u16) (cmd->len + sizeof(out_cmd->hdr));
 
 	/* If any of the command structures end up being larger than
@@ -3162,9 +3162,9 @@ il_enqueue_hcmd(struct il_priv *il, struct il_host_cmd *cmd)
 #endif
 	txq->need_update = 1;
 
-	if (il->cfg->ops->lib->txq_update_byte_cnt_tbl)
+	if (il->ops->lib->txq_update_byte_cnt_tbl)
 		/* Set up entry in queue's byte count circular buffer */
-		il->cfg->ops->lib->txq_update_byte_cnt_tbl(il, txq, 0);
+		il->ops->lib->txq_update_byte_cnt_tbl(il, txq, 0);
 
 	phys_addr =
 	    pci_map_single(il->pci_dev, &out_cmd->hdr, fix_size,
@@ -3172,8 +3172,8 @@ il_enqueue_hcmd(struct il_priv *il, struct il_host_cmd *cmd)
 	dma_unmap_addr_set(out_meta, mapping, phys_addr);
 	dma_unmap_len_set(out_meta, len, fix_size);
 
-	il->cfg->ops->lib->txq_attach_buf_to_tfd(il, txq, phys_addr, fix_size,
-						 1, U32_PAD(cmd->len));
+	il->ops->lib->txq_attach_buf_to_tfd(il, txq, phys_addr, fix_size, 1,
+					    U32_PAD(cmd->len));
 
 	/* Increment and update queue's write idx */
 	q->write_ptr = il_queue_inc_wrap(q->write_ptr, q->n_bd);
@@ -3315,30 +3315,6 @@ EXPORT_SYMBOL(il_debug_level);
 const u8 il_bcast_addr[ETH_ALEN] = { 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF };
 EXPORT_SYMBOL(il_bcast_addr);
 
-/* This function both allocates and initializes hw and il. */
-struct ieee80211_hw *
-il_alloc_all(struct il_cfg *cfg)
-{
-	struct il_priv *il;
-	/* mac80211 allocates memory for this device instance, including
-	 *   space for this driver's ilate structure */
-	struct ieee80211_hw *hw;
-
-	hw = ieee80211_alloc_hw(sizeof(struct il_priv),
-				cfg->ops->ieee80211_ops);
-	if (hw == NULL) {
-		pr_err("%s: Can not allocate network device\n", cfg->name);
-		goto out;
-	}
-
-	il = hw->priv;
-	il->hw = hw;
-
-out:
-	return hw;
-}
-EXPORT_SYMBOL(il_alloc_all);
-
 #define MAX_BIT_RATE_40_MHZ 150	/* Mbps */
 #define MAX_BIT_RATE_20_MHZ 72	/* Mbps */
 static void
@@ -3871,8 +3847,8 @@ _il_set_rxon_ht(struct il_priv *il, struct il_ht_config *ht_conf)
 		rxon->flags |= RXON_FLG_CHANNEL_MODE_LEGACY;
 	}
 
-	if (il->cfg->ops->hcmd->set_rxon_chain)
-		il->cfg->ops->hcmd->set_rxon_chain(il);
+	if (il->ops->hcmd->set_rxon_chain)
+		il->ops->hcmd->set_rxon_chain(il);
 
 	D_ASSOC("rxon flags 0x%X operation mode :0x%X "
 		"extension channel offset 0x%x\n", le32_to_cpu(rxon->flags),
@@ -4130,9 +4106,9 @@ il_irq_handle_error(struct il_priv *il)
 
 	IL_ERR("Loaded firmware version: %s\n", il->hw->wiphy->fw_version);
 
-	il->cfg->ops->lib->dump_nic_error_log(il);
-	if (il->cfg->ops->lib->dump_fh)
-		il->cfg->ops->lib->dump_fh(il, NULL, false);
+	il->ops->lib->dump_nic_error_log(il);
+	if (il->ops->lib->dump_fh)
+		il->ops->lib->dump_fh(il, NULL, false);
 #ifdef CONFIG_IWLEGACY_DEBUG
 	if (il_get_debug_level(il) & IL_DL_FW_ERRORS)
 		il_print_rx_config_cmd(il);
@@ -4319,7 +4295,7 @@ il_set_tx_power(struct il_priv *il, s8 tx_power, bool force)
 	if (il->tx_power_user_lmt == tx_power && !force)
 		return 0;
 
-	if (!il->cfg->ops->lib->send_tx_power)
+	if (!il->ops->lib->send_tx_power)
 		return -EOPNOTSUPP;
 
 	/* 0 dBm mean 1 milliwatt */
@@ -4352,7 +4328,7 @@ il_set_tx_power(struct il_priv *il, s8 tx_power, bool force)
 	prev_tx_power = il->tx_power_user_lmt;
 	il->tx_power_user_lmt = tx_power;
 
-	ret = il->cfg->ops->lib->send_tx_power(il);
+	ret = il->ops->lib->send_tx_power(il);
 
 	/* if fail to set tx_power, restore the orig. tx power */
 	if (ret) {
@@ -4501,8 +4477,8 @@ il_set_mode(struct il_priv *il)
 {
 	il_connection_init_rx_config(il);
 
-	if (il->cfg->ops->hcmd->set_rxon_chain)
-		il->cfg->ops->hcmd->set_rxon_chain(il);
+	if (il->ops->hcmd->set_rxon_chain)
+		il->ops->hcmd->set_rxon_chain(il);
 
 	return il_commit_rxon(il);
 }
@@ -5200,7 +5176,7 @@ il_mac_config(struct ieee80211_hw *hw, u32 changed)
 	int scan_active = 0;
 	bool ht_changed = false;
 
-	if (WARN_ON(!il->cfg->ops->legacy))
+	if (WARN_ON(!il->ops->legacy))
 		return -EOPNOTSUPP;
 
 	mutex_lock(&il->mutex);
@@ -5225,8 +5201,8 @@ il_mac_config(struct ieee80211_hw *hw, u32 changed)
 		 * set up the SM PS mode to OFF if an HT channel is
 		 * configured.
 		 */
-		if (il->cfg->ops->hcmd->set_rxon_chain)
-			il->cfg->ops->hcmd->set_rxon_chain(il);
+		if (il->ops->hcmd->set_rxon_chain)
+			il->ops->hcmd->set_rxon_chain(il);
 	}
 
 	/* during scanning mac80211 will delay channel setting until
@@ -5295,8 +5271,8 @@ il_mac_config(struct ieee80211_hw *hw, u32 changed)
 
 		spin_unlock_irqrestore(&il->lock, flags);
 
-		if (il->cfg->ops->legacy->update_bcast_stations)
-			ret = il->cfg->ops->legacy->update_bcast_stations(il);
+		if (il->ops->legacy->update_bcast_stations)
+			ret = il->ops->legacy->update_bcast_stations(il);
 
 set_ch_out:
 		/* The list of supported rates and rate mask can be different
@@ -5346,7 +5322,7 @@ il_mac_reset_tsf(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 	struct il_priv *il = hw->priv;
 	unsigned long flags;
 
-	if (WARN_ON(!il->cfg->ops->legacy))
+	if (WARN_ON(!il->ops->legacy))
 		return;
 
 	mutex_lock(&il->mutex);
@@ -5501,7 +5477,7 @@ il_beacon_update(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 		return;
 	}
 
-	il->cfg->ops->legacy->post_associate(il);
+	il->ops->legacy->post_associate(il);
 }
 
 void
@@ -5511,7 +5487,7 @@ il_mac_bss_info_changed(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 	struct il_priv *il = hw->priv;
 	int ret;
 
-	if (WARN_ON(!il->cfg->ops->legacy))
+	if (WARN_ON(!il->ops->legacy))
 		return;
 
 	D_MAC80211("changes = 0x%X\n", changes);
@@ -5616,8 +5592,8 @@ il_mac_bss_info_changed(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 	if (changes & BSS_CHANGED_HT) {
 		il_ht_conf(il, vif);
 
-		if (il->cfg->ops->hcmd->set_rxon_chain)
-			il->cfg->ops->hcmd->set_rxon_chain(il);
+		if (il->ops->hcmd->set_rxon_chain)
+			il->ops->hcmd->set_rxon_chain(il);
 	}
 
 	if (changes & BSS_CHANGED_ASSOC) {
@@ -5626,7 +5602,7 @@ il_mac_bss_info_changed(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 			il->timestamp = bss_conf->timestamp;
 
 			if (!il_is_rfkill(il))
-				il->cfg->ops->legacy->post_associate(il);
+				il->ops->legacy->post_associate(il);
 		} else
 			il_set_no_assoc(il, vif);
 	}
@@ -5646,16 +5622,15 @@ il_mac_bss_info_changed(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 			memcpy(il->staging.bssid_addr, bss_conf->bssid,
 			       ETH_ALEN);
 			memcpy(il->bssid, bss_conf->bssid, ETH_ALEN);
-			il->cfg->ops->legacy->config_ap(il);
+			il->ops->legacy->config_ap(il);
 		} else
 			il_set_no_assoc(il, vif);
 	}
 
 	if (changes & BSS_CHANGED_IBSS) {
 		ret =
-		    il->cfg->ops->legacy->manage_ibss_station(il, vif,
-							      bss_conf->
-							      ibss_joined);
+		    il->ops->legacy->manage_ibss_station(il, vif,
+							 bss_conf->ibss_joined);
 		if (ret)
 			IL_ERR("failed to %s IBSS station %pM\n",
 			       bss_conf->ibss_joined ? "add" : "remove",
diff --git a/drivers/net/wireless/iwlegacy/common.h b/drivers/net/wireless/iwlegacy/common.h
index 746eec0..2af8610 100644
--- a/drivers/net/wireless/iwlegacy/common.h
+++ b/drivers/net/wireless/iwlegacy/common.h
@@ -1167,6 +1167,7 @@ struct il_priv {
 	struct ieee80211_channel *ieee_channels;
 	struct ieee80211_rate *ieee_rates;
 	struct il_cfg *cfg;
+	const struct il_ops *ops;
 
 	/* temporary frame storage list */
 	struct list_head free_frames;
@@ -1668,7 +1669,6 @@ struct il_ops {
 	const struct il_led_ops *led;
 	const struct il_nic_ops *nic;
 	const struct il_legacy_ops *legacy;
-	const struct ieee80211_ops *ieee80211_ops;
 };
 
 struct il_mod_params {
@@ -1777,7 +1777,6 @@ struct il_cfg {
 	unsigned int sku;
 	u16 eeprom_ver;
 	u16 eeprom_calib_ver;
-	const struct il_ops *ops;
 	/* module based parameters which can be set from modprobe cmd */
 	const struct il_mod_params *mod_params;
 	/* params not likely to change within a device family */
@@ -1791,7 +1790,6 @@ struct il_cfg {
  *   L i b                 *
  ***************************/
 
-struct ieee80211_hw *il_alloc_all(struct il_cfg *cfg);
 int il_mac_conf_tx(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 		   u16 queue, const struct ieee80211_tx_queue_params *params);
 int il_mac_tx_last_beacon(struct ieee80211_hw *hw);
@@ -2093,13 +2091,13 @@ int il_send_rxon_timing(struct il_priv *il);
 static inline int
 il_send_rxon_assoc(struct il_priv *il)
 {
-	return il->cfg->ops->hcmd->rxon_assoc(il);
+	return il->ops->hcmd->rxon_assoc(il);
 }
 
 static inline int
 il_commit_rxon(struct il_priv *il)
 {
-	return il->cfg->ops->hcmd->commit_rxon(il);
+	return il->ops->hcmd->commit_rxon(il);
 }
 
 static inline const struct ieee80211_supported_band *
diff --git a/drivers/net/wireless/iwlegacy/debug.c b/drivers/net/wireless/iwlegacy/debug.c
index 61e3f43..dc149c1 100644
--- a/drivers/net/wireless/iwlegacy/debug.c
+++ b/drivers/net/wireless/iwlegacy/debug.c
@@ -903,8 +903,7 @@ il_dbgfs_ucode_rx_stats_read(struct file *file, char __user *user_buf,
 			     size_t count, loff_t *ppos)
 {
 	struct il_priv *il = file->private_data;
-	return il->cfg->ops->lib->debugfs_ops.rx_stats_read(file, user_buf,
-							    count, ppos);
+	return il->ops->lib->debugfs_ops.rx_stats_read(file, user_buf, count, ppos);
 }
 
 static ssize_t
@@ -912,8 +911,7 @@ il_dbgfs_ucode_tx_stats_read(struct file *file, char __user *user_buf,
 			     size_t count, loff_t *ppos)
 {
 	struct il_priv *il = file->private_data;
-	return il->cfg->ops->lib->debugfs_ops.tx_stats_read(file, user_buf,
-							    count, ppos);
+	return il->ops->lib->debugfs_ops.tx_stats_read(file, user_buf, count, ppos);
 }
 
 static ssize_t
@@ -921,8 +919,7 @@ il_dbgfs_ucode_general_stats_read(struct file *file, char __user *user_buf,
 				  size_t count, loff_t *ppos)
 {
 	struct il_priv *il = file->private_data;
-	return il->cfg->ops->lib->debugfs_ops.general_stats_read(file, user_buf,
-								 count, ppos);
+	return il->ops->lib->debugfs_ops.general_stats_read(file, user_buf, count, ppos);
 }
 
 static ssize_t
@@ -1180,8 +1177,8 @@ il_dbgfs_fh_reg_read(struct file *file, char __user *user_buf, size_t count,
 	int pos = 0;
 	ssize_t ret = -EFAULT;
 
-	if (il->cfg->ops->lib->dump_fh) {
-		ret = pos = il->cfg->ops->lib->dump_fh(il, &buf, true);
+	if (il->ops->lib->dump_fh) {
+		ret = pos = il->ops->lib->dump_fh(il, &buf, true);
 		if (buf) {
 			ret =
 			    simple_read_from_buffer(user_buf, count, ppos, buf,
-- 
1.7.1

