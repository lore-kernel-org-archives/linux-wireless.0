Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54948 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756499Ab2BMKYP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Feb 2012 05:24:15 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 11/24] iwlegacy: merge il_lib_ops into il_ops
Date: Mon, 13 Feb 2012 11:23:18 +0100
Message-Id: <1329128611-6815-12-git-send-email-sgruszka@redhat.com> (sfid-20120213_112424_524369_A085AECA)
In-Reply-To: <1329128611-6815-1-git-send-email-sgruszka@redhat.com>
References: <1329128611-6815-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlegacy/3945-mac.c   |    8 +++---
 drivers/net/wireless/iwlegacy/3945.c       |   29 ++++++++++-------------
 drivers/net/wireless/iwlegacy/4965-calib.c |    4 +-
 drivers/net/wireless/iwlegacy/4965-mac.c   |   23 +++++++++----------
 drivers/net/wireless/iwlegacy/4965.c       |   19 ++++++---------
 drivers/net/wireless/iwlegacy/common.c     |   34 ++++++++++++++--------------
 drivers/net/wireless/iwlegacy/common.h     |   31 +++++++++++--------------
 drivers/net/wireless/iwlegacy/debug.c      |    4 +-
 8 files changed, 71 insertions(+), 81 deletions(-)

diff --git a/drivers/net/wireless/iwlegacy/3945-mac.c b/drivers/net/wireless/iwlegacy/3945-mac.c
index ba01d2d..19a4d56 100644
--- a/drivers/net/wireless/iwlegacy/3945-mac.c
+++ b/drivers/net/wireless/iwlegacy/3945-mac.c
@@ -616,7 +616,7 @@ il3945_tx_skb(struct il_priv *il, struct sk_buff *skb)
 
 	/* Add buffer containing Tx command and MAC(!) header to TFD's
 	 * first entry */
-	il->ops->lib->txq_attach_buf_to_tfd(il, txq, txcmd_phys, len, 1, 0);
+	il->ops->txq_attach_buf_to_tfd(il, txq, txcmd_phys, len, 1, 0);
 
 	/* Set up TFD's 2nd entry to point directly to remainder of skb,
 	 * if any (802.11 null frames have no payload). */
@@ -625,8 +625,8 @@ il3945_tx_skb(struct il_priv *il, struct sk_buff *skb)
 		phys_addr =
 		    pci_map_single(il->pci_dev, skb->data + hdr_len, len,
 				   PCI_DMA_TODEVICE);
-		il->ops->lib->txq_attach_buf_to_tfd(il, txq, phys_addr, len, 0,
-						    U32_PAD(len));
+		il->ops->txq_attach_buf_to_tfd(il, txq, phys_addr, len, 0,
+					       U32_PAD(len));
 	}
 
 	/* Tell device the write idx *just past* this latest filled TFD */
@@ -2413,7 +2413,7 @@ __il3945_up(struct il_priv *il)
 		/* load bootstrap state machine,
 		 * load bootstrap program into processor's memory,
 		 * prepare to load the "initialize" uCode */
-		rc = il->ops->lib->load_ucode(il);
+		rc = il->ops->load_ucode(il);
 
 		if (rc) {
 			IL_ERR("Unable to set up bootstrap uCode: %d\n", rc);
diff --git a/drivers/net/wireless/iwlegacy/3945.c b/drivers/net/wireless/iwlegacy/3945.c
index a21ec25..f5833d0 100644
--- a/drivers/net/wireless/iwlegacy/3945.c
+++ b/drivers/net/wireless/iwlegacy/3945.c
@@ -303,7 +303,7 @@ il3945_tx_queue_reclaim(struct il_priv *il, int txq_id, int idx)
 		skb = txq->skbs[txq->q.read_ptr];
 		ieee80211_tx_status_irqsafe(il->hw, skb);
 		txq->skbs[txq->q.read_ptr] = NULL;
-		il->ops->lib->txq_free_tfd(il, txq);
+		il->ops->txq_free_tfd(il, txq);
 	}
 
 	if (il_queue_space(q) > q->low_mark && txq_id >= 0 &&
@@ -1612,7 +1612,7 @@ il3945_hw_reg_comp_txpower_temp(struct il_priv *il)
 	}
 
 	/* send Txpower command for current channel to ucode */
-	return il->ops->lib->send_tx_power(il);
+	return il->ops->send_tx_power(il);
 }
 
 int
@@ -2634,19 +2634,6 @@ static struct il_hcmd_ops il3945_hcmd = {
 	.commit_rxon = il3945_commit_rxon,
 };
 
-static struct il_lib_ops il3945_lib = {
-	.txq_attach_buf_to_tfd = il3945_hw_txq_attach_buf_to_tfd,
-	.txq_free_tfd = il3945_hw_txq_free_tfd,
-	.txq_init = il3945_hw_tx_queue_init,
-	.load_ucode = il3945_load_bsm,
-	.dump_nic_error_log = il3945_dump_nic_error_log,
-	.apm_init = il3945_apm_init,
-	.send_tx_power = il3945_send_tx_power,
-	.is_valid_rtc_data_addr = il3945_hw_valid_rtc_data_addr,
-	.eeprom_acquire_semaphore = il3945_eeprom_acquire_semaphore,
-	.eeprom_release_semaphore = il3945_eeprom_release_semaphore,
-};
-
 static const struct il_legacy_ops il3945_legacy_ops = {
 	.post_associate = il3945_post_associate,
 	.config_ap = il3945_config_ap,
@@ -2661,7 +2648,17 @@ static struct il_hcmd_utils_ops il3945_hcmd_utils = {
 };
 
 const struct il_ops il3945_ops = {
-	.lib = &il3945_lib,
+	.txq_attach_buf_to_tfd = il3945_hw_txq_attach_buf_to_tfd,
+	.txq_free_tfd = il3945_hw_txq_free_tfd,
+	.txq_init = il3945_hw_tx_queue_init,
+	.load_ucode = il3945_load_bsm,
+	.dump_nic_error_log = il3945_dump_nic_error_log,
+	.apm_init = il3945_apm_init,
+	.send_tx_power = il3945_send_tx_power,
+	.is_valid_rtc_data_addr = il3945_hw_valid_rtc_data_addr,
+	.eeprom_acquire_semaphore = il3945_eeprom_acquire_semaphore,
+	.eeprom_release_semaphore = il3945_eeprom_release_semaphore,
+
 	.hcmd = &il3945_hcmd,
 	.utils = &il3945_hcmd_utils,
 	.led = &il3945_led_ops,
diff --git a/drivers/net/wireless/iwlegacy/4965-calib.c b/drivers/net/wireless/iwlegacy/4965-calib.c
index fe91715..47c20e3 100644
--- a/drivers/net/wireless/iwlegacy/4965-calib.c
+++ b/drivers/net/wireless/iwlegacy/4965-calib.c
@@ -923,8 +923,8 @@ il4965_chain_noise_calibration(struct il_priv *il, void *stat_resp)
 	/* Some power changes may have been made during the calibration.
 	 * Update and commit the RXON
 	 */
-	if (il->ops->lib->update_chain_flags)
-		il->ops->lib->update_chain_flags(il);
+	if (il->ops->update_chain_flags)
+		il->ops->update_chain_flags(il);
 
 	data->state = IL_CHAIN_NOISE_DONE;
 	il_power_update_mode(il, false);
diff --git a/drivers/net/wireless/iwlegacy/4965-mac.c b/drivers/net/wireless/iwlegacy/4965-mac.c
index ebfcfc8..cc2963b 100644
--- a/drivers/net/wireless/iwlegacy/4965-mac.c
+++ b/drivers/net/wireless/iwlegacy/4965-mac.c
@@ -1811,7 +1811,7 @@ il4965_tx_skb(struct il_priv *il, struct sk_buff *skb)
 	dma_unmap_len_set(out_meta, len, firstlen);
 	/* Add buffer containing Tx command and MAC(!) header to TFD's
 	 * first entry */
-	il->ops->lib->txq_attach_buf_to_tfd(il, txq, txcmd_phys, firstlen, 1, 0);
+	il->ops->txq_attach_buf_to_tfd(il, txq, txcmd_phys, firstlen, 1, 0);
 
 	if (!ieee80211_has_morefrags(hdr->frame_control)) {
 		txq->need_update = 1;
@@ -1827,8 +1827,8 @@ il4965_tx_skb(struct il_priv *il, struct sk_buff *skb)
 		phys_addr =
 		    pci_map_single(il->pci_dev, skb->data + hdr_len, secondlen,
 				   PCI_DMA_TODEVICE);
-		il->ops->lib->txq_attach_buf_to_tfd(il, txq, phys_addr,
-						    secondlen, 0, 0);
+		il->ops->txq_attach_buf_to_tfd(il, txq, phys_addr, secondlen,
+					       0, 0);
 	}
 
 	scratch_phys =
@@ -1848,8 +1848,7 @@ il4965_tx_skb(struct il_priv *il, struct sk_buff *skb)
 
 	/* Set up entry for this TFD in Tx byte-count array */
 	if (info->flags & IEEE80211_TX_CTL_AMPDU)
-		il->ops->lib->txq_update_byte_cnt_tbl(il, txq,
-						      le16_to_cpu(tx_cmd->len));
+		il->ops->txq_update_byte_cnt_tbl(il, txq, le16_to_cpu(tx_cmd->len));
 
 	pci_dma_sync_single_for_device(il->pci_dev, txcmd_phys, firstlen,
 				       PCI_DMA_BIDIRECTIONAL);
@@ -2470,7 +2469,7 @@ il4965_tx_queue_reclaim(struct il_priv *il, int txq_id, int idx)
 		il4965_tx_status(il, skb, txq_id >= IL4965_FIRST_AMPDU_QUEUE);
 
 		txq->skbs[txq->q.read_ptr] = NULL;
-		il->ops->lib->txq_free_tfd(il, txq);
+		il->ops->txq_free_tfd(il, txq);
 	}
 	return nfreed;
 }
@@ -5072,7 +5071,7 @@ il4965_dump_nic_error_log(struct il_priv *il)
 	else
 		base = le32_to_cpu(il->card_alive.error_event_table_ptr);
 
-	if (!il->ops->lib->is_valid_rtc_data_addr(base)) {
+	if (!il->ops->is_valid_rtc_data_addr(base)) {
 		IL_ERR("Not valid error log pointer 0x%08X for %s uCode\n",
 		       base, (il->ucode_type == UCODE_INIT) ? "Init" : "RT");
 		return;
@@ -5574,7 +5573,7 @@ __il4965_up(struct il_priv *il)
 		/* load bootstrap state machine,
 		 * load bootstrap program into processor's memory,
 		 * prepare to load the "initialize" uCode */
-		ret = il->ops->lib->load_ucode(il);
+		ret = il->ops->load_ucode(il);
 
 		if (ret) {
 			IL_ERR("Unable to set up bootstrap uCode: %d\n", ret);
@@ -5615,7 +5614,7 @@ il4965_bg_init_alive_start(struct work_struct *data)
 	if (test_bit(S_EXIT_PENDING, &il->status))
 		goto out;
 
-	il->ops->lib->init_alive_start(il);
+	il->ops->init_alive_start(il);
 out:
 	mutex_unlock(&il->mutex);
 }
@@ -6047,7 +6046,7 @@ il4965_mac_channel_switch(struct ieee80211_hw *hw,
 	if (!il_is_associated(il))
 		goto out;
 
-	if (!il->ops->lib->set_channel_switch)
+	if (!il->ops->set_channel_switch)
 		goto out;
 
 	ch = channel->hw_value;
@@ -6099,7 +6098,7 @@ il4965_mac_channel_switch(struct ieee80211_hw *hw,
 	 */
 	set_bit(S_CHANNEL_SWITCH_PENDING, &il->status);
 	il->switch_channel = cpu_to_le16(ch);
-	if (il->ops->lib->set_channel_switch(il, ch_switch)) {
+	if (il->ops->set_channel_switch(il, ch_switch)) {
 		clear_bit(S_CHANNEL_SWITCH_PENDING, &il->status);
 		il->switch_channel = 0;
 		ieee80211_chswitch_done(il->vif, false);
@@ -6182,7 +6181,7 @@ il4965_bg_txpower_work(struct work_struct *work)
 	/* Regardless of if we are associated, we must reconfigure the
 	 * TX power since frames can be sent on non-radar channels while
 	 * not associated */
-	il->ops->lib->send_tx_power(il);
+	il->ops->send_tx_power(il);
 
 	/* Update last_temperature to keep is_calib_needed from running
 	 * when it isn't needed... */
diff --git a/drivers/net/wireless/iwlegacy/4965.c b/drivers/net/wireless/iwlegacy/4965.c
index e5e5ab2..805a4ea 100644
--- a/drivers/net/wireless/iwlegacy/4965.c
+++ b/drivers/net/wireless/iwlegacy/4965.c
@@ -1889,7 +1889,14 @@ static struct il_hcmd_utils_ops il4965_hcmd_utils = {
 	.post_scan = il4965_post_scan,
 };
 
-static struct il_lib_ops il4965_lib = {
+static const struct il_legacy_ops il4965_legacy_ops = {
+	.post_associate = il4965_post_associate,
+	.config_ap = il4965_config_ap,
+	.manage_ibss_station = il4965_manage_ibss_station,
+	.update_bcast_stations = il4965_update_bcast_stations,
+};
+
+const struct il_ops il4965_ops = {
 	.txq_update_byte_cnt_tbl = il4965_txq_update_byte_cnt_tbl,
 	.txq_attach_buf_to_tfd = il4965_hw_txq_attach_buf_to_tfd,
 	.txq_free_tfd = il4965_hw_txq_free_tfd,
@@ -1905,17 +1912,7 @@ static struct il_lib_ops il4965_lib = {
 	.update_chain_flags = il4965_update_chain_flags,
 	.eeprom_acquire_semaphore = il4965_eeprom_acquire_semaphore,
 	.eeprom_release_semaphore = il4965_eeprom_release_semaphore,
-};
 
-static const struct il_legacy_ops il4965_legacy_ops = {
-	.post_associate = il4965_post_associate,
-	.config_ap = il4965_config_ap,
-	.manage_ibss_station = il4965_manage_ibss_station,
-	.update_bcast_stations = il4965_update_bcast_stations,
-};
-
-const struct il_ops il4965_ops = {
-	.lib = &il4965_lib,
 	.hcmd = &il4965_hcmd,
 	.utils = &il4965_hcmd_utils,
 	.led = &il4965_led_ops,
diff --git a/drivers/net/wireless/iwlegacy/common.c b/drivers/net/wireless/iwlegacy/common.c
index 6e63d9f..d522a43 100644
--- a/drivers/net/wireless/iwlegacy/common.c
+++ b/drivers/net/wireless/iwlegacy/common.c
@@ -730,7 +730,7 @@ il_eeprom_init(struct il_priv *il)
 	}
 	e = (__le16 *) il->eeprom;
 
-	il->ops->lib->apm_init(il);
+	il->ops->apm_init(il);
 
 	ret = il_eeprom_verify_signature(il);
 	if (ret < 0) {
@@ -740,7 +740,7 @@ il_eeprom_init(struct il_priv *il)
 	}
 
 	/* Make sure driver (instead of uCode) is allowed to read EEPROM */
-	ret = il->ops->lib->eeprom_acquire_semaphore(il);
+	ret = il->ops->eeprom_acquire_semaphore(il);
 	if (ret < 0) {
 		IL_ERR("Failed to acquire EEPROM semaphore.\n");
 		ret = -ENOENT;
@@ -772,7 +772,7 @@ il_eeprom_init(struct il_priv *il)
 
 	ret = 0;
 done:
-	il->ops->lib->eeprom_release_semaphore(il);
+	il->ops->eeprom_release_semaphore(il);
 
 err:
 	if (ret)
@@ -1155,9 +1155,9 @@ il_power_set_mode(struct il_priv *il, struct il_powertable_cmd *cmd, bool force)
 		if (!(cmd->flags & IL_POWER_DRIVER_ALLOW_SLEEP_MSK))
 			clear_bit(S_POWER_PMI, &il->status);
 
-		if (il->ops->lib->update_chain_flags && update_chains)
-			il->ops->lib->update_chain_flags(il);
-		else if (il->ops->lib->update_chain_flags)
+		if (il->ops->update_chain_flags && update_chains)
+			il->ops->update_chain_flags(il);
+		else if (il->ops->update_chain_flags)
 			D_POWER("Cannot update the power, chain noise "
 				"calibration running: %d\n",
 				il->chain_noise_data.state);
@@ -2719,7 +2719,7 @@ il_tx_queue_unmap(struct il_priv *il, int txq_id)
 		return;
 
 	while (q->write_ptr != q->read_ptr) {
-		il->ops->lib->txq_free_tfd(il, txq);
+		il->ops->txq_free_tfd(il, txq);
 		q->read_ptr = il_queue_inc_wrap(q->read_ptr, q->n_bd);
 	}
 }
@@ -3019,7 +3019,7 @@ il_tx_queue_init(struct il_priv *il, struct il_tx_queue *txq, int slots_num,
 	il_queue_init(il, &txq->q, TFD_QUEUE_SIZE_MAX, slots_num, txq_id);
 
 	/* Tell device where to find queue */
-	il->ops->lib->txq_init(il, txq);
+	il->ops->txq_init(il, txq);
 
 	return 0;
 err:
@@ -3050,7 +3050,7 @@ il_tx_queue_reset(struct il_priv *il, struct il_tx_queue *txq, int slots_num,
 	il_queue_init(il, &txq->q, TFD_QUEUE_SIZE_MAX, slots_num, txq_id);
 
 	/* Tell device where to find queue */
-	il->ops->lib->txq_init(il, txq);
+	il->ops->txq_init(il, txq);
 }
 EXPORT_SYMBOL(il_tx_queue_reset);
 
@@ -3157,9 +3157,9 @@ il_enqueue_hcmd(struct il_priv *il, struct il_host_cmd *cmd)
 #endif
 	txq->need_update = 1;
 
-	if (il->ops->lib->txq_update_byte_cnt_tbl)
+	if (il->ops->txq_update_byte_cnt_tbl)
 		/* Set up entry in queue's byte count circular buffer */
-		il->ops->lib->txq_update_byte_cnt_tbl(il, txq, 0);
+		il->ops->txq_update_byte_cnt_tbl(il, txq, 0);
 
 	phys_addr =
 	    pci_map_single(il->pci_dev, &out_cmd->hdr, fix_size,
@@ -3167,7 +3167,7 @@ il_enqueue_hcmd(struct il_priv *il, struct il_host_cmd *cmd)
 	dma_unmap_addr_set(out_meta, mapping, phys_addr);
 	dma_unmap_len_set(out_meta, len, fix_size);
 
-	il->ops->lib->txq_attach_buf_to_tfd(il, txq, phys_addr, fix_size, 1,
+	il->ops->txq_attach_buf_to_tfd(il, txq, phys_addr, fix_size, 1,
 					    U32_PAD(cmd->len));
 
 	/* Increment and update queue's write idx */
@@ -4101,9 +4101,9 @@ il_irq_handle_error(struct il_priv *il)
 
 	IL_ERR("Loaded firmware version: %s\n", il->hw->wiphy->fw_version);
 
-	il->ops->lib->dump_nic_error_log(il);
-	if (il->ops->lib->dump_fh)
-		il->ops->lib->dump_fh(il, NULL, false);
+	il->ops->dump_nic_error_log(il);
+	if (il->ops->dump_fh)
+		il->ops->dump_fh(il, NULL, false);
 #ifdef CONFIG_IWLEGACY_DEBUG
 	if (il_get_debug_level(il) & IL_DL_FW_ERRORS)
 		il_print_rx_config_cmd(il);
@@ -4290,7 +4290,7 @@ il_set_tx_power(struct il_priv *il, s8 tx_power, bool force)
 	if (il->tx_power_user_lmt == tx_power && !force)
 		return 0;
 
-	if (!il->ops->lib->send_tx_power)
+	if (!il->ops->send_tx_power)
 		return -EOPNOTSUPP;
 
 	/* 0 dBm mean 1 milliwatt */
@@ -4323,7 +4323,7 @@ il_set_tx_power(struct il_priv *il, s8 tx_power, bool force)
 	prev_tx_power = il->tx_power_user_lmt;
 	il->tx_power_user_lmt = tx_power;
 
-	ret = il->ops->lib->send_tx_power(il);
+	ret = il->ops->send_tx_power(il);
 
 	/* if fail to set tx_power, restore the orig. tx power */
 	if (ret) {
diff --git a/drivers/net/wireless/iwlegacy/common.h b/drivers/net/wireless/iwlegacy/common.h
index ca68b58..91624ee 100644
--- a/drivers/net/wireless/iwlegacy/common.h
+++ b/drivers/net/wireless/iwlegacy/common.h
@@ -1578,7 +1578,20 @@ struct il_debugfs_ops {
 };
 #endif
 
-struct il_lib_ops {
+struct il_led_ops {
+	int (*cmd) (struct il_priv *il, struct il_led_cmd *led_cmd);
+};
+
+struct il_legacy_ops {
+	void (*post_associate) (struct il_priv *il);
+	void (*config_ap) (struct il_priv *il);
+	/* station management */
+	int (*update_bcast_stations) (struct il_priv *il);
+	int (*manage_ibss_station) (struct il_priv *il,
+				    struct ieee80211_vif *vif, bool add);
+};
+
+struct il_ops {
 	/* Handling TX */
 	void (*txq_update_byte_cnt_tbl) (struct il_priv *il,
 					 struct il_tx_queue *txq,
@@ -1609,23 +1622,7 @@ struct il_lib_ops {
 	/* eeprom operations */
 	int (*eeprom_acquire_semaphore) (struct il_priv *il);
 	void (*eeprom_release_semaphore) (struct il_priv *il);
-};
 
-struct il_led_ops {
-	int (*cmd) (struct il_priv *il, struct il_led_cmd *led_cmd);
-};
-
-struct il_legacy_ops {
-	void (*post_associate) (struct il_priv *il);
-	void (*config_ap) (struct il_priv *il);
-	/* station management */
-	int (*update_bcast_stations) (struct il_priv *il);
-	int (*manage_ibss_station) (struct il_priv *il,
-				    struct ieee80211_vif *vif, bool add);
-};
-
-struct il_ops {
-	const struct il_lib_ops *lib;
 	const struct il_hcmd_ops *hcmd;
 	const struct il_hcmd_utils_ops *utils;
 	const struct il_led_ops *led;
diff --git a/drivers/net/wireless/iwlegacy/debug.c b/drivers/net/wireless/iwlegacy/debug.c
index 5091db8..be6005d 100644
--- a/drivers/net/wireless/iwlegacy/debug.c
+++ b/drivers/net/wireless/iwlegacy/debug.c
@@ -1178,8 +1178,8 @@ il_dbgfs_fh_reg_read(struct file *file, char __user *user_buf, size_t count,
 	int pos = 0;
 	ssize_t ret = -EFAULT;
 
-	if (il->ops->lib->dump_fh) {
-		ret = pos = il->ops->lib->dump_fh(il, &buf, true);
+	if (il->ops->dump_fh) {
+		ret = pos = il->ops->dump_fh(il, &buf, true);
 		if (buf) {
 			ret =
 			    simple_read_from_buffer(user_buf, count, ppos, buf,
-- 
1.7.1

