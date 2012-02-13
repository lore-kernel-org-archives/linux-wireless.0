Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:20837 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756548Ab2BMKYT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Feb 2012 05:24:19 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 12/24] iwlegacy: merge all ops structures into one
Date: Mon, 13 Feb 2012 11:23:19 +0100
Message-Id: <1329128611-6815-13-git-send-email-sgruszka@redhat.com> (sfid-20120213_112433_470960_790296AF)
In-Reply-To: <1329128611-6815-1-git-send-email-sgruszka@redhat.com>
References: <1329128611-6815-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlegacy/3945.c     |   39 +++++++---------------
 drivers/net/wireless/iwlegacy/4965-mac.c |   17 ++++-----
 drivers/net/wireless/iwlegacy/4965.c     |   51 +++++++++++------------------
 drivers/net/wireless/iwlegacy/common.c   |   50 +++++++++++------------------
 drivers/net/wireless/iwlegacy/common.h   |   52 +++++++++++-------------------
 5 files changed, 78 insertions(+), 131 deletions(-)

diff --git a/drivers/net/wireless/iwlegacy/3945.c b/drivers/net/wireless/iwlegacy/3945.c
index f5833d0..fde6979 100644
--- a/drivers/net/wireless/iwlegacy/3945.c
+++ b/drivers/net/wireless/iwlegacy/3945.c
@@ -57,10 +57,6 @@ il3945_send_led_cmd(struct il_priv *il, struct il_led_cmd *led_cmd)
 	return il_send_cmd(il, &cmd);
 }
 
-const struct il_led_ops il3945_led_ops = {
-	.cmd = il3945_send_led_cmd,
-};
-
 #define IL_DECLARE_RATE_INFO(r, ip, in, rp, rn, pp, np)    \
 	[RATE_##r##M_IDX] = { RATE_##r##M_PLCP,   \
 				    RATE_##r##M_IEEE,   \
@@ -2629,24 +2625,6 @@ il3945_load_bsm(struct il_priv *il)
 	return 0;
 }
 
-static struct il_hcmd_ops il3945_hcmd = {
-	.rxon_assoc = il3945_send_rxon_assoc,
-	.commit_rxon = il3945_commit_rxon,
-};
-
-static const struct il_legacy_ops il3945_legacy_ops = {
-	.post_associate = il3945_post_associate,
-	.config_ap = il3945_config_ap,
-	.manage_ibss_station = il3945_manage_ibss_station,
-};
-
-static struct il_hcmd_utils_ops il3945_hcmd_utils = {
-	.get_hcmd_size = il3945_get_hcmd_size,
-	.build_addsta_hcmd = il3945_build_addsta_hcmd,
-	.request_scan = il3945_request_scan,
-	.post_scan = il3945_post_scan,
-};
-
 const struct il_ops il3945_ops = {
 	.txq_attach_buf_to_tfd = il3945_hw_txq_attach_buf_to_tfd,
 	.txq_free_tfd = il3945_hw_txq_free_tfd,
@@ -2659,10 +2637,19 @@ const struct il_ops il3945_ops = {
 	.eeprom_acquire_semaphore = il3945_eeprom_acquire_semaphore,
 	.eeprom_release_semaphore = il3945_eeprom_release_semaphore,
 
-	.hcmd = &il3945_hcmd,
-	.utils = &il3945_hcmd_utils,
-	.led = &il3945_led_ops,
-	.legacy = &il3945_legacy_ops,
+	.rxon_assoc = il3945_send_rxon_assoc,
+	.commit_rxon = il3945_commit_rxon,
+
+	.get_hcmd_size = il3945_get_hcmd_size,
+	.build_addsta_hcmd = il3945_build_addsta_hcmd,
+	.request_scan = il3945_request_scan,
+	.post_scan = il3945_post_scan,
+
+	.post_associate = il3945_post_associate,
+	.config_ap = il3945_config_ap,
+	.manage_ibss_station = il3945_manage_ibss_station,
+
+	.send_led_cmd = il3945_send_led_cmd,
 };
 
 static struct il_cfg il3945_bg_cfg = {
diff --git a/drivers/net/wireless/iwlegacy/4965-mac.c b/drivers/net/wireless/iwlegacy/4965-mac.c
index cc2963b..89275bf 100644
--- a/drivers/net/wireless/iwlegacy/4965-mac.c
+++ b/drivers/net/wireless/iwlegacy/4965-mac.c
@@ -3649,8 +3649,8 @@ il4965_sta_modify_sleep_tx_count(struct il_priv *il, int sta_id, int cnt)
 void
 il4965_update_chain_flags(struct il_priv *il)
 {
-	if (il->ops->hcmd->set_rxon_chain) {
-		il->ops->hcmd->set_rxon_chain(il);
+	if (il->ops->set_rxon_chain) {
+		il->ops->set_rxon_chain(il);
 		if (il->active.rx_chain != il->staging.rx_chain)
 			il_commit_rxon(il);
 	}
@@ -4399,9 +4399,8 @@ il4965_irq_tasklet(struct il_priv *il)
 	/* HW RF KILL switch toggled */
 	if (inta & CSR_INT_BIT_RF_KILL) {
 		int hw_rf_kill = 0;
-		if (!
-		    (_il_rd(il, CSR_GP_CNTRL) &
-		     CSR_GP_CNTRL_REG_FLAG_HW_RF_KILL_SW))
+
+		if (!(_il_rd(il, CSR_GP_CNTRL) & CSR_GP_CNTRL_REG_FLAG_HW_RF_KILL_SW))
 			hw_rf_kill = 1;
 
 		IL_WARN("RF_KILL bit toggled to %s.\n",
@@ -5300,8 +5299,8 @@ il4965_alive_start(struct il_priv *il)
 		/* Initialize our rx_config data */
 		il_connection_init_rx_config(il);
 
-		if (il->ops->hcmd->set_rxon_chain)
-			il->ops->hcmd->set_rxon_chain(il);
+		if (il->ops->set_rxon_chain)
+			il->ops->set_rxon_chain(il);
 	}
 
 	/* Configure bluetooth coexistence if enabled */
@@ -6333,8 +6332,8 @@ il4965_init_drv(struct il_priv *il)
 	il->force_reset.reset_duration = IL_DELAY_NEXT_FORCE_FW_RELOAD;
 
 	/* Choose which receivers/antennas to use */
-	if (il->ops->hcmd->set_rxon_chain)
-		il->ops->hcmd->set_rxon_chain(il);
+	if (il->ops->set_rxon_chain)
+		il->ops->set_rxon_chain(il);
 
 	il_init_scan_params(il);
 
diff --git a/drivers/net/wireless/iwlegacy/4965.c b/drivers/net/wireless/iwlegacy/4965.c
index 805a4ea..5db1171 100644
--- a/drivers/net/wireless/iwlegacy/4965.c
+++ b/drivers/net/wireless/iwlegacy/4965.c
@@ -264,10 +264,6 @@ il4965_led_enable(struct il_priv *il)
 	_il_wr(il, CSR_LED_REG, CSR_LED_REG_TRUN_ON);
 }
 
-const struct il_led_ops il4965_led_ops = {
-	.cmd = il4965_send_led_cmd,
-};
-
 static int il4965_send_tx_power(struct il_priv *il);
 static int il4965_hw_get_temperature(struct il_priv *il);
 
@@ -1737,12 +1733,6 @@ il4965_build_addsta_hcmd(const struct il_addsta_cmd *cmd, u8 * data)
 	return (u16) sizeof(struct il4965_addsta_cmd);
 }
 
-static struct il_hcmd_ops il4965_hcmd = {
-	.rxon_assoc = il4965_send_rxon_assoc,
-	.commit_rxon = il4965_commit_rxon,
-	.set_rxon_chain = il4965_set_rxon_chain,
-};
-
 static void
 il4965_post_scan(struct il_priv *il)
 {
@@ -1782,8 +1772,8 @@ il4965_post_associate(struct il_priv *il)
 
 	il_set_rxon_ht(il, &il->current_ht_config);
 
-	if (il->ops->hcmd->set_rxon_chain)
-		il->ops->hcmd->set_rxon_chain(il);
+	if (il->ops->set_rxon_chain)
+		il->ops->set_rxon_chain(il);
 
 	il->staging.assoc_id = cpu_to_le16(vif->bss_conf.aid);
 
@@ -1857,8 +1847,8 @@ il4965_config_ap(struct il_priv *il)
 		/* AP has all antennas */
 		il->chain_noise_data.active_chains = il->hw_params.valid_rx_ant;
 		il_set_rxon_ht(il, &il->current_ht_config);
-		if (il->ops->hcmd->set_rxon_chain)
-			il->ops->hcmd->set_rxon_chain(il);
+		if (il->ops->set_rxon_chain)
+			il->ops->set_rxon_chain(il);
 
 		il->staging.assoc_id = 0;
 
@@ -1882,20 +1872,6 @@ il4965_config_ap(struct il_priv *il)
 	il4965_send_beacon_cmd(il);
 }
 
-static struct il_hcmd_utils_ops il4965_hcmd_utils = {
-	.get_hcmd_size = il4965_get_hcmd_size,
-	.build_addsta_hcmd = il4965_build_addsta_hcmd,
-	.request_scan = il4965_request_scan,
-	.post_scan = il4965_post_scan,
-};
-
-static const struct il_legacy_ops il4965_legacy_ops = {
-	.post_associate = il4965_post_associate,
-	.config_ap = il4965_config_ap,
-	.manage_ibss_station = il4965_manage_ibss_station,
-	.update_bcast_stations = il4965_update_bcast_stations,
-};
-
 const struct il_ops il4965_ops = {
 	.txq_update_byte_cnt_tbl = il4965_txq_update_byte_cnt_tbl,
 	.txq_attach_buf_to_tfd = il4965_hw_txq_attach_buf_to_tfd,
@@ -1913,10 +1889,21 @@ const struct il_ops il4965_ops = {
 	.eeprom_acquire_semaphore = il4965_eeprom_acquire_semaphore,
 	.eeprom_release_semaphore = il4965_eeprom_release_semaphore,
 
-	.hcmd = &il4965_hcmd,
-	.utils = &il4965_hcmd_utils,
-	.led = &il4965_led_ops,
-	.legacy = &il4965_legacy_ops,
+	.rxon_assoc = il4965_send_rxon_assoc,
+	.commit_rxon = il4965_commit_rxon,
+	.set_rxon_chain = il4965_set_rxon_chain,
+
+	.get_hcmd_size = il4965_get_hcmd_size,
+	.build_addsta_hcmd = il4965_build_addsta_hcmd,
+	.request_scan = il4965_request_scan,
+	.post_scan = il4965_post_scan,
+
+	.post_associate = il4965_post_associate,
+	.config_ap = il4965_config_ap,
+	.manage_ibss_station = il4965_manage_ibss_station,
+	.update_bcast_stations = il4965_update_bcast_stations,
+
+	.send_led_cmd = il4965_send_led_cmd,
 };
 
 struct il_cfg il4965_cfg = {
diff --git a/drivers/net/wireless/iwlegacy/common.c b/drivers/net/wireless/iwlegacy/common.c
index d522a43..1bf8616 100644
--- a/drivers/net/wireless/iwlegacy/common.c
+++ b/drivers/net/wireless/iwlegacy/common.c
@@ -519,7 +519,7 @@ il_led_cmd(struct il_priv *il, unsigned long on, unsigned long off)
 	    il_blink_compensation(il, off,
 				  il->cfg->led_compensation);
 
-	ret = il->ops->led->cmd(il, &led_cmd);
+	ret = il->ops->send_led_cmd(il, &led_cmd);
 	if (!ret) {
 		il->blink_on = on;
 		il->blink_off = off;
@@ -1482,9 +1482,6 @@ il_scan_initiate(struct il_priv *il, struct ieee80211_vif *vif)
 
 	lockdep_assert_held(&il->mutex);
 
-	if (WARN_ON(!il->ops->utils->request_scan))
-		return -EOPNOTSUPP;
-
 	cancel_delayed_work(&il->scan_check);
 
 	if (!il_is_ready_rf(il)) {
@@ -1507,7 +1504,7 @@ il_scan_initiate(struct il_priv *il, struct ieee80211_vif *vif)
 	set_bit(S_SCANNING, &il->status);
 	il->scan_start = jiffies;
 
-	ret = il->ops->utils->request_scan(il, vif);
+	ret = il->ops->request_scan(il, vif);
 	if (ret) {
 		clear_bit(S_SCANNING, &il->status);
 		return ret;
@@ -1669,7 +1666,7 @@ out_settings:
 	il_power_set_mode(il, &il->power_data.sleep_cmd_next, false);
 	il_set_tx_power(il, il->tx_power_next, false);
 
-	il->ops->utils->post_scan(il);
+	il->ops->post_scan(il);
 
 out:
 	mutex_unlock(&il->mutex);
@@ -1811,7 +1808,7 @@ il_send_add_sta(struct il_priv *il, struct il_addsta_cmd *sta, u8 flags)
 		might_sleep();
 	}
 
-	cmd.len = il->ops->utils->build_addsta_hcmd(sta, data);
+	cmd.len = il->ops->build_addsta_hcmd(sta, data);
 	ret = il_send_cmd(il, &cmd);
 
 	if (ret || (flags & CMD_ASYNC))
@@ -3078,7 +3075,7 @@ il_enqueue_hcmd(struct il_priv *il, struct il_host_cmd *cmd)
 	u32 idx;
 	u16 fix_size;
 
-	cmd->len = il->ops->utils->get_hcmd_size(cmd->id, cmd->len);
+	cmd->len = il->ops->get_hcmd_size(cmd->id, cmd->len);
 	fix_size = (u16) (cmd->len + sizeof(out_cmd->hdr));
 
 	/* If any of the command structures end up being larger than
@@ -3842,8 +3839,8 @@ _il_set_rxon_ht(struct il_priv *il, struct il_ht_config *ht_conf)
 		rxon->flags |= RXON_FLG_CHANNEL_MODE_LEGACY;
 	}
 
-	if (il->ops->hcmd->set_rxon_chain)
-		il->ops->hcmd->set_rxon_chain(il);
+	if (il->ops->set_rxon_chain)
+		il->ops->set_rxon_chain(il);
 
 	D_ASSOC("rxon flags 0x%X operation mode :0x%X "
 		"extension channel offset 0x%x\n", le32_to_cpu(rxon->flags),
@@ -4472,8 +4469,8 @@ il_set_mode(struct il_priv *il)
 {
 	il_connection_init_rx_config(il);
 
-	if (il->ops->hcmd->set_rxon_chain)
-		il->ops->hcmd->set_rxon_chain(il);
+	if (il->ops->set_rxon_chain)
+		il->ops->set_rxon_chain(il);
 
 	return il_commit_rxon(il);
 }
@@ -5171,9 +5168,6 @@ il_mac_config(struct ieee80211_hw *hw, u32 changed)
 	int scan_active = 0;
 	bool ht_changed = false;
 
-	if (WARN_ON(!il->ops->legacy))
-		return -EOPNOTSUPP;
-
 	mutex_lock(&il->mutex);
 
 	D_MAC80211("enter to channel %d changed 0x%X\n", channel->hw_value,
@@ -5196,8 +5190,8 @@ il_mac_config(struct ieee80211_hw *hw, u32 changed)
 		 * set up the SM PS mode to OFF if an HT channel is
 		 * configured.
 		 */
-		if (il->ops->hcmd->set_rxon_chain)
-			il->ops->hcmd->set_rxon_chain(il);
+		if (il->ops->set_rxon_chain)
+			il->ops->set_rxon_chain(il);
 	}
 
 	/* during scanning mac80211 will delay channel setting until
@@ -5266,8 +5260,8 @@ il_mac_config(struct ieee80211_hw *hw, u32 changed)
 
 		spin_unlock_irqrestore(&il->lock, flags);
 
-		if (il->ops->legacy->update_bcast_stations)
-			ret = il->ops->legacy->update_bcast_stations(il);
+		if (il->ops->update_bcast_stations)
+			ret = il->ops->update_bcast_stations(il);
 
 set_ch_out:
 		/* The list of supported rates and rate mask can be different
@@ -5317,9 +5311,6 @@ il_mac_reset_tsf(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 	struct il_priv *il = hw->priv;
 	unsigned long flags;
 
-	if (WARN_ON(!il->ops->legacy))
-		return;
-
 	mutex_lock(&il->mutex);
 	D_MAC80211("enter\n");
 
@@ -5472,7 +5463,7 @@ il_beacon_update(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 		return;
 	}
 
-	il->ops->legacy->post_associate(il);
+	il->ops->post_associate(il);
 }
 
 void
@@ -5482,9 +5473,6 @@ il_mac_bss_info_changed(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 	struct il_priv *il = hw->priv;
 	int ret;
 
-	if (WARN_ON(!il->ops->legacy))
-		return;
-
 	D_MAC80211("changes = 0x%X\n", changes);
 
 	mutex_lock(&il->mutex);
@@ -5587,8 +5575,8 @@ il_mac_bss_info_changed(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 	if (changes & BSS_CHANGED_HT) {
 		il_ht_conf(il, vif);
 
-		if (il->ops->hcmd->set_rxon_chain)
-			il->ops->hcmd->set_rxon_chain(il);
+		if (il->ops->set_rxon_chain)
+			il->ops->set_rxon_chain(il);
 	}
 
 	if (changes & BSS_CHANGED_ASSOC) {
@@ -5597,7 +5585,7 @@ il_mac_bss_info_changed(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 			il->timestamp = bss_conf->timestamp;
 
 			if (!il_is_rfkill(il))
-				il->ops->legacy->post_associate(il);
+				il->ops->post_associate(il);
 		} else
 			il_set_no_assoc(il, vif);
 	}
@@ -5617,14 +5605,14 @@ il_mac_bss_info_changed(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 			memcpy(il->staging.bssid_addr, bss_conf->bssid,
 			       ETH_ALEN);
 			memcpy(il->bssid, bss_conf->bssid, ETH_ALEN);
-			il->ops->legacy->config_ap(il);
+			il->ops->config_ap(il);
 		} else
 			il_set_no_assoc(il, vif);
 	}
 
 	if (changes & BSS_CHANGED_IBSS) {
 		ret =
-		    il->ops->legacy->manage_ibss_station(il, vif,
+		    il->ops->manage_ibss_station(il, vif,
 							 bss_conf->ibss_joined);
 		if (ret)
 			IL_ERR("failed to %s IBSS station %pM\n",
diff --git a/drivers/net/wireless/iwlegacy/common.h b/drivers/net/wireless/iwlegacy/common.h
index 91624ee..873182e 100644
--- a/drivers/net/wireless/iwlegacy/common.h
+++ b/drivers/net/wireless/iwlegacy/common.h
@@ -1553,19 +1553,6 @@ il_free_pages(struct il_priv *il, unsigned long page)
 #define IL_RX_BUF_SIZE_4K (4 * 1024)
 #define IL_RX_BUF_SIZE_8K (8 * 1024)
 
-struct il_hcmd_ops {
-	int (*rxon_assoc) (struct il_priv *il);
-	int (*commit_rxon) (struct il_priv *il);
-	void (*set_rxon_chain) (struct il_priv *il);
-};
-
-struct il_hcmd_utils_ops {
-	u16(*get_hcmd_size) (u8 cmd_id, u16 len);
-	u16(*build_addsta_hcmd) (const struct il_addsta_cmd *cmd, u8 *data);
-	int (*request_scan) (struct il_priv *il, struct ieee80211_vif *vif);
-	void (*post_scan) (struct il_priv *il);
-};
-
 #ifdef CONFIG_IWLEGACY_DEBUGFS
 struct il_debugfs_ops {
 	ssize_t(*rx_stats_read) (struct file *file, char __user *user_buf,
@@ -1578,19 +1565,6 @@ struct il_debugfs_ops {
 };
 #endif
 
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
 struct il_ops {
 	/* Handling TX */
 	void (*txq_update_byte_cnt_tbl) (struct il_priv *il,
@@ -1623,11 +1597,23 @@ struct il_ops {
 	int (*eeprom_acquire_semaphore) (struct il_priv *il);
 	void (*eeprom_release_semaphore) (struct il_priv *il);
 
-	const struct il_hcmd_ops *hcmd;
-	const struct il_hcmd_utils_ops *utils;
-	const struct il_led_ops *led;
-	const struct il_nic_ops *nic;
-	const struct il_legacy_ops *legacy;
+	int (*rxon_assoc) (struct il_priv *il);
+	int (*commit_rxon) (struct il_priv *il);
+	void (*set_rxon_chain) (struct il_priv *il);
+
+	u16(*get_hcmd_size) (u8 cmd_id, u16 len);
+	u16(*build_addsta_hcmd) (const struct il_addsta_cmd *cmd, u8 *data);
+
+	int (*request_scan) (struct il_priv *il, struct ieee80211_vif *vif);
+	void (*post_scan) (struct il_priv *il);
+	void (*post_associate) (struct il_priv *il);
+	void (*config_ap) (struct il_priv *il);
+	/* station management */
+	int (*update_bcast_stations) (struct il_priv *il);
+	int (*manage_ibss_station) (struct il_priv *il,
+				    struct ieee80211_vif *vif, bool add);
+
+	int (*send_led_cmd) (struct il_priv *il, struct il_led_cmd *led_cmd);
 };
 
 struct il_mod_params {
@@ -2053,13 +2039,13 @@ int il_send_rxon_timing(struct il_priv *il);
 static inline int
 il_send_rxon_assoc(struct il_priv *il)
 {
-	return il->ops->hcmd->rxon_assoc(il);
+	return il->ops->rxon_assoc(il);
 }
 
 static inline int
 il_commit_rxon(struct il_priv *il)
 {
-	return il->ops->hcmd->commit_rxon(il);
+	return il->ops->commit_rxon(il);
 }
 
 static inline const struct ieee80211_supported_band *
-- 
1.7.1

