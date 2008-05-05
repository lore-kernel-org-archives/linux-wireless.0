Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:57565 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754449AbYEECYU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 May 2008 22:24:20 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Ester Kummer <ester.kummer@intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 13/25] iwlwifi: move per driverdebug_level to per device
Date: Mon,  5 May 2008 10:22:40 +0800
Message-Id: <1209954172-3092-14-git-send-email-yi.zhu@intel.com> (sfid-20080505_044417_034979_566E63C1)
In-Reply-To: <1209954172-3092-13-git-send-email-yi.zhu@intel.com>
References: <1209954172-3092-1-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-2-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-3-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-4-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-5-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-6-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-7-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-8-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-9-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-10-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-11-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-12-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-13-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ester Kummer <ester.kummer@intel.com>

This patch ports the debug_level to iwl_priv and changes
the format of the debug prints.

Signed-off-by: Ester Kummer <ester.kummer@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965-rs.c  |   32 +++++++++++++++++------
 drivers/net/wireless/iwlwifi/iwl-4965.c     |   13 +++++----
 drivers/net/wireless/iwlwifi/iwl-debug.h    |   20 +++------------
 drivers/net/wireless/iwlwifi/iwl-dev.h      |   18 +++++++++++++
 drivers/net/wireless/iwlwifi/iwl4965-base.c |   36 +++++++++++++++++---------
 5 files changed, 75 insertions(+), 44 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965-rs.c b/drivers/net/wireless/iwlwifi/iwl-4965-rs.c
index 67356d9..ab73932 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965-rs.c
@@ -662,7 +662,8 @@ static u16 rs_get_supported_rates(struct iwl4965_lq_sta *lq_sta,
 	}
 }
 
-static u16 rs_get_adjacent_rate(u8 index, u16 rate_mask, int rate_type)
+static u16 rs_get_adjacent_rate(struct iwl_priv *priv, u8 index, u16 rate_mask,
+				int rate_type)
 {
 	u8 high = IWL_RATE_INVALID;
 	u8 low = IWL_RATE_INVALID;
@@ -763,7 +764,8 @@ static u32 rs_get_lower_rate(struct iwl4965_lq_sta *lq_sta,
 		goto out;
 	}
 
-	high_low = rs_get_adjacent_rate(scale_index, rate_mask, tbl->lq_type);
+	high_low = rs_get_adjacent_rate(lq_sta->drv, scale_index, rate_mask,
+					tbl->lq_type);
 	low = high_low & 0xff;
 
 	if (low == IWL_RATE_INVALID)
@@ -990,7 +992,7 @@ out:
  * These control how long we stay using same modulation mode before
  * searching for a new mode.
  */
-static void rs_set_stay_in_table(u8 is_legacy,
+static void rs_set_stay_in_table(struct iwl_priv *priv, u8 is_legacy,
 				 struct iwl4965_lq_sta *lq_sta)
 {
 	IWL_DEBUG_RATE("we are staying in the same table\n");
@@ -1079,7 +1081,8 @@ static s32 rs_get_best_rate(struct iwl_priv *priv,
 	new_rate = high = low = start_hi = IWL_RATE_INVALID;
 
 	for (; ;) {
-		high_low = rs_get_adjacent_rate(rate, rate_mask, tbl->lq_type);
+		high_low = rs_get_adjacent_rate(priv, rate, rate_mask,
+						tbl->lq_type);
 
 		low = high_low & 0xff;
 		high = (high_low >> 8) & 0xff;
@@ -1565,7 +1568,9 @@ static void rs_stay_in_table(struct iwl4965_lq_sta *lq_sta)
 	int i;
 	int active_tbl;
 	int flush_interval_passed = 0;
+	struct iwl_priv *priv;
 
+	priv = lq_sta->drv;
 	active_tbl = lq_sta->active_tbl;
 
 	tbl = &(lq_sta->lq_info[active_tbl]);
@@ -1838,7 +1843,7 @@ static void rs_rate_scale_perform(struct iwl_priv *priv,
 
 	/* (Else) not in search of better modulation mode, try for better
 	 * starting rate, while staying in this mode. */
-	high_low = rs_get_adjacent_rate(index, rate_scale_index_msk,
+	high_low = rs_get_adjacent_rate(priv, index, rate_scale_index_msk,
 					tbl->lq_type);
 	low = high_low & 0xff;
 	high = (high_low >> 8) & 0xff;
@@ -1998,7 +2003,7 @@ static void rs_rate_scale_perform(struct iwl_priv *priv,
 		    (lq_sta->action_counter >= 1)) {
 			lq_sta->action_counter = 0;
 			IWL_DEBUG_RATE("LQ: STAY in legacy table\n");
-			rs_set_stay_in_table(1, lq_sta);
+			rs_set_stay_in_table(priv, 1, lq_sta);
 		}
 
 		/* If we're in an HT mode, and all 3 mode switch actions
@@ -2015,7 +2020,7 @@ static void rs_rate_scale_perform(struct iwl_priv *priv,
 			}
 #endif /*CONFIG_IWL4965_HT */
 			lq_sta->action_counter = 0;
-			rs_set_stay_in_table(0, lq_sta);
+			rs_set_stay_in_table(priv, 0, lq_sta);
 		}
 
 	/*
@@ -2169,11 +2174,13 @@ out:
 	rcu_read_unlock();
 }
 
-static void *rs_alloc_sta(void *priv, gfp_t gfp)
+static void *rs_alloc_sta(void *priv_rate, gfp_t gfp)
 {
 	struct iwl4965_lq_sta *lq_sta;
+	struct iwl_priv *priv;
 	int i, j;
 
+	priv = (struct iwl_priv *)priv_rate;
 	IWL_DEBUG_RATE("create station rate scale window\n");
 
 	lq_sta = kzalloc(sizeof(struct iwl4965_lq_sta), gfp);
@@ -2443,10 +2450,12 @@ static void rs_clear(void *priv_rate)
 	IWL_DEBUG_RATE("leave\n");
 }
 
-static void rs_free_sta(void *priv, void *priv_sta)
+static void rs_free_sta(void *priv_rate, void *priv_sta)
 {
 	struct iwl4965_lq_sta *lq_sta = priv_sta;
+	struct iwl_priv *priv;
 
+	priv = (struct iwl_priv *)priv_rate;
 	IWL_DEBUG_RATE("enter\n");
 	kfree(lq_sta);
 	IWL_DEBUG_RATE("leave\n");
@@ -2462,6 +2471,9 @@ static int open_file_generic(struct inode *inode, struct file *file)
 static void rs_dbgfs_set_mcs(struct iwl4965_lq_sta *lq_sta,
 				u32 *rate_n_flags, int index)
 {
+	struct iwl_priv *priv;
+
+	priv = lq_sta->drv;
 	if (lq_sta->dbg_fixed_rate) {
 		if (index < 12) {
 			*rate_n_flags = lq_sta->dbg_fixed_rate;
@@ -2481,10 +2493,12 @@ static ssize_t rs_sta_dbgfs_scale_table_write(struct file *file,
 			const char __user *user_buf, size_t count, loff_t *ppos)
 {
 	struct iwl4965_lq_sta *lq_sta = file->private_data;
+	struct iwl_priv *priv;
 	char buf[64];
 	int buf_size;
 	u32 parsed_rate;
 
+	priv = lq_sta->drv;
 	memset(buf, 0, sizeof(buf));
 	buf_size = min(count, sizeof(buf) -  1);
 	if (copy_from_user(buf, user_buf, buf_size))
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 47b6d64..ff2ee82 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -2743,7 +2743,7 @@ static int iwl4965_set_decrypted_flag(struct iwl_priv *priv,
 	return 0;
 }
 
-static u32 iwl4965_translate_rx_status(u32 decrypt_in)
+static u32 iwl4965_translate_rx_status(struct iwl_priv *priv, u32 decrypt_in)
 {
 	u32 decrypt_out = 0;
 
@@ -2855,7 +2855,7 @@ static void iwl4965_handle_data_packet(struct iwl_priv *priv, int is_data,
 	if (!include_phy) {
 		/* New status scheme, need to translate */
 		ampdu_status_legacy = ampdu_status;
-		ampdu_status = iwl4965_translate_rx_status(ampdu_status);
+		ampdu_status = iwl4965_translate_rx_status(priv, ampdu_status);
 	}
 
 	/* start from MAC */
@@ -2887,7 +2887,8 @@ static void iwl4965_handle_data_packet(struct iwl_priv *priv, int is_data,
 }
 
 /* Calc max signal level (dBm) among 3 possible receivers */
-static int iwl4965_calc_rssi(struct iwl4965_rx_phy_res *rx_resp)
+static int iwl4965_calc_rssi(struct iwl_priv *priv,
+			     struct iwl4965_rx_phy_res *rx_resp)
 {
 	/* data from PHY/DSP regarding signal strength, etc.,
 	 *   contents are always there, not configurable by host.  */
@@ -2991,7 +2992,7 @@ static void iwl4965_dbg_report_frame(struct iwl_priv *priv,
 	struct iwl4965_rx_frame_end *rx_end = IWL_RX_END(pkt);
 	u8 *data = IWL_RX_DATA(pkt);
 
-	if (likely(!(iwl_debug_level & IWL_DL_RX)))
+	if (likely(!(priv->debug_level & IWL_DL_RX)))
 		return;
 
 	/* MAC header */
@@ -3094,7 +3095,7 @@ static void iwl4965_dbg_report_frame(struct iwl_priv *priv,
 		}
 	}
 	if (print_dump)
-		iwl_print_hex_dump(IWL_DL_RX, data, length);
+		iwl_print_hex_dump(priv, IWL_DL_RX, data, length);
 }
 #else
 static inline void iwl4965_dbg_report_frame(struct iwl_priv *priv,
@@ -3187,7 +3188,7 @@ static void iwl4965_rx_reply_rx(struct iwl_priv *priv,
 	priv->ucode_beacon_time = le32_to_cpu(rx_start->beacon_time_stamp);
 
 	/* Find max signal strength (dBm) among 3 antenna/receiver chains */
-	rx_status.ssi = iwl4965_calc_rssi(rx_start);
+	rx_status.ssi = iwl4965_calc_rssi(priv, rx_start);
 
 	/* Meaningful noise values are available only from beacon statistics,
 	 *   which are gathered only when associated, and indicate noise
diff --git a/drivers/net/wireless/iwlwifi/iwl-debug.h b/drivers/net/wireless/iwlwifi/iwl-debug.h
index 7e68d24..14d95dd 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debug.h
+++ b/drivers/net/wireless/iwlwifi/iwl-debug.h
@@ -32,24 +32,15 @@
 #ifdef CONFIG_IWLWIFI_DEBUG
 extern u32 iwl_debug_level;
 #define IWL_DEBUG(level, fmt, args...) \
-do { if (iwl_debug_level & (level)) \
-  printk(KERN_ERR DRV_NAME": %c %s " fmt, \
+do { if (priv->debug_level & (level)) \
+  dev_printk(KERN_ERR, &(priv->hw->wiphy->dev), "%c %s " fmt, \
 	 in_interrupt() ? 'I' : 'U', __FUNCTION__ , ## args); } while (0)
 
 #define IWL_DEBUG_LIMIT(level, fmt, args...) \
-do { if ((iwl_debug_level & (level)) && net_ratelimit()) \
-  printk(KERN_ERR DRV_NAME": %c %s " fmt, \
+do { if ((priv->debug_level & (level)) && net_ratelimit()) \
+  dev_printk(KERN_ERR, &(priv->hw->wiphy->dev), "%c %s " fmt, \
 	 in_interrupt() ? 'I' : 'U', __FUNCTION__ , ## args); } while (0)
 
-static inline void iwl_print_hex_dump(int level, void *p, u32 len)
-{
-	if (!(iwl_debug_level & level))
-		return;
-
-	print_hex_dump(KERN_DEBUG, "iwl data: ", DUMP_PREFIX_OFFSET, 16, 1,
-			p, len, 1);
-}
-
 #ifdef CONFIG_IWLWIFI_DEBUGFS
 struct iwl_debugfs {
 	const char *name;
@@ -77,9 +68,6 @@ static inline void IWL_DEBUG(int level, const char *fmt, ...)
 static inline void IWL_DEBUG_LIMIT(int level, const char *fmt, ...)
 {
 }
-static inline void iwl_print_hex_dump(int level, void *p, u32 len)
-{
-}
 #endif				/* CONFIG_IWLWIFI_DEBUG */
 
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 4786194..0a37ff4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -1194,6 +1194,7 @@ struct iwl_priv {
 
 #ifdef CONFIG_IWLWIFI_DEBUG
 	/* debugging info */
+	u32 debug_level;
 	u32 framecnt_to_us;
 	atomic_t restrict_refcnt;
 #ifdef CONFIG_IWLWIFI_DEBUGFS
@@ -1246,6 +1247,23 @@ static inline int is_channel_ibss(const struct iwl_channel_info *ch)
 	return ((ch->flags & EEPROM_CHANNEL_IBSS)) ? 1 : 0;
 }
 
+#ifdef CONFIG_IWLWIFI_DEBUG
+static inline void iwl_print_hex_dump(struct iwl_priv *priv, int level,
+				      void *p, u32 len)
+{
+	if (!(priv->debug_level & level))
+		return;
+
+	print_hex_dump(KERN_DEBUG, "iwl data: ", DUMP_PREFIX_OFFSET, 16, 1,
+			p, len, 1);
+}
+#else
+static inline void iwl_print_hex_dump(struct iwl_priv *priv, int level,
+				      void *p, u32 len)
+{
+}
+#endif
+
 extern const struct iwl_channel_info *iwl_get_channel_info(
 	const struct iwl_priv *priv, enum ieee80211_band band, u16 channel);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index 820b90a..8100384 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -145,6 +145,7 @@ static const char *iwl4965_escape_essid(const char *essid, u8 essid_len)
 	return escaped;
 }
 
+
 /*************** DMA-QUEUE-GENERAL-FUNCTIONS  *****
  * DMA services
  *
@@ -1914,7 +1915,7 @@ static int iwl4965_get_sta_id(struct iwl_priv *priv,
 		IWL_DEBUG_DROP("Station %s not in station map. "
 			       "Defaulting to broadcast...\n",
 			       print_mac(mac, hdr->addr1));
-		iwl_print_hex_dump(IWL_DL_DROP, (u8 *) hdr, sizeof(*hdr));
+		iwl_print_hex_dump(priv, IWL_DL_DROP, (u8 *) hdr, sizeof(*hdr));
 		return priv->hw_params.bcast_sta_id;
 
 	default:
@@ -2130,10 +2131,10 @@ static int iwl4965_tx_skb(struct iwl_priv *priv,
 		txq->need_update = 0;
 	}
 
-	iwl_print_hex_dump(IWL_DL_TX, out_cmd->cmd.payload,
+	iwl_print_hex_dump(priv, IWL_DL_TX, out_cmd->cmd.payload,
 			   sizeof(out_cmd->cmd.tx));
 
-	iwl_print_hex_dump(IWL_DL_TX, (u8 *)out_cmd->cmd.tx.hdr,
+	iwl_print_hex_dump(priv, IWL_DL_TX, (u8 *)out_cmd->cmd.tx.hdr,
 			   ieee80211_get_hdrlen(fc));
 
 	/* Set up entry for this TFD in Tx byte-count array */
@@ -2912,7 +2913,7 @@ static void iwl4965_rx_pm_debug_statistics_notif(struct iwl_priv *priv,
 	IWL_DEBUG_RADIO("Dumping %d bytes of unhandled "
 			"notification for %s:\n",
 			le32_to_cpu(pkt->len), get_cmd_string(pkt->hdr.cmd));
-	iwl_print_hex_dump(IWL_DL_RADIO, pkt->u.raw, le32_to_cpu(pkt->len));
+	iwl_print_hex_dump(priv, IWL_DL_RADIO, pkt->u.raw, le32_to_cpu(pkt->len));
 }
 
 static void iwl4965_bg_beacon_update(struct work_struct *work)
@@ -3485,12 +3486,13 @@ static int iwl4965_tx_queue_update_write_ptr(struct iwl_priv *priv,
 }
 
 #ifdef CONFIG_IWLWIFI_DEBUG
-static void iwl4965_print_rx_config_cmd(struct iwl4965_rxon_cmd *rxon)
+static void iwl4965_print_rx_config_cmd(struct iwl_priv *priv)
 {
+	struct iwl4965_rxon_cmd *rxon = &priv->staging_rxon;
 	DECLARE_MAC_BUF(mac);
 
 	IWL_DEBUG_RADIO("RX CONFIG:\n");
-	iwl_print_hex_dump(IWL_DL_RADIO, (u8 *) rxon, sizeof(*rxon));
+	iwl_print_hex_dump(priv, IWL_DL_RADIO, (u8 *) rxon, sizeof(*rxon));
 	IWL_DEBUG_RADIO("u16 channel: 0x%x\n", le16_to_cpu(rxon->channel));
 	IWL_DEBUG_RADIO("u32 flags: 0x%08X\n", le32_to_cpu(rxon->flags));
 	IWL_DEBUG_RADIO("u32 filter_flags: 0x%08x\n",
@@ -3716,10 +3718,10 @@ static void iwl4965_irq_handle_error(struct iwl_priv *priv)
 	clear_bit(STATUS_HCMD_ACTIVE, &priv->status);
 
 #ifdef CONFIG_IWLWIFI_DEBUG
-	if (iwl_debug_level & IWL_DL_FW_ERRORS) {
+	if (priv->debug_level & IWL_DL_FW_ERRORS) {
 		iwl4965_dump_nic_error_log(priv);
 		iwl4965_dump_nic_event_log(priv);
-		iwl4965_print_rx_config_cmd(&priv->staging_rxon);
+		iwl4965_print_rx_config_cmd(priv);
 	}
 #endif
 
@@ -3783,7 +3785,7 @@ static void iwl4965_irq_tasklet(struct iwl_priv *priv)
 	iwl_write32(priv, CSR_FH_INT_STATUS, inta_fh);
 
 #ifdef CONFIG_IWLWIFI_DEBUG
-	if (iwl_debug_level & IWL_DL_ISR) {
+	if (priv->debug_level & IWL_DL_ISR) {
 		/* just for debug */
 		inta_mask = iwl_read32(priv, CSR_INT_MASK);
 		IWL_DEBUG_ISR("inta 0x%08x, enabled 0x%08x, fh 0x%08x\n",
@@ -3817,7 +3819,7 @@ static void iwl4965_irq_tasklet(struct iwl_priv *priv)
 	}
 
 #ifdef CONFIG_IWLWIFI_DEBUG
-	if (iwl_debug_level & (IWL_DL_ISR)) {
+	if (priv->debug_level & (IWL_DL_ISR)) {
 		/* NIC fires this, but we don't use it, redundant with WAKEUP */
 		if (inta & CSR_INT_BIT_SCD)
 			IWL_DEBUG_ISR("Scheduler finished to transmit "
@@ -3910,7 +3912,7 @@ static void iwl4965_irq_tasklet(struct iwl_priv *priv)
 		iwl4965_enable_interrupts(priv);
 
 #ifdef CONFIG_IWLWIFI_DEBUG
-	if (iwl_debug_level & (IWL_DL_ISR)) {
+	if (priv->debug_level & (IWL_DL_ISR)) {
 		inta = iwl_read32(priv, CSR_INT);
 		inta_mask = iwl_read32(priv, CSR_INT_MASK);
 		inta_fh = iwl_read32(priv, CSR_FH_INT_STATUS);
@@ -6050,6 +6052,9 @@ static int iwl4965_mac_get_tx_stats(struct ieee80211_hw *hw,
 static int iwl4965_mac_get_stats(struct ieee80211_hw *hw,
 			     struct ieee80211_low_level_stats *stats)
 {
+	struct iwl_priv *priv = hw->priv;
+
+	priv = hw->priv;
 	IWL_DEBUG_MAC80211("enter\n");
 	IWL_DEBUG_MAC80211("leave\n");
 
@@ -6058,6 +6063,9 @@ static int iwl4965_mac_get_stats(struct ieee80211_hw *hw,
 
 static u64 iwl4965_mac_get_tsf(struct ieee80211_hw *hw)
 {
+	struct iwl_priv *priv;
+
+	priv = hw->priv;
 	IWL_DEBUG_MAC80211("enter\n");
 	IWL_DEBUG_MAC80211("leave\n");
 
@@ -6707,7 +6715,9 @@ static int iwl4965_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 	/* Disabling hardware scan means that mac80211 will perform scans
 	 * "the hard way", rather than using device's scan. */
 	if (cfg->mod_params->disable_hw_scan) {
-		IWL_DEBUG_INFO("Disabling hw_scan\n");
+		if (cfg->mod_params->debug & IWL_DL_INFO)
+			dev_printk(KERN_DEBUG, &(pdev->dev),
+				   "Disabling hw_scan\n");
 		iwl4965_hw_ops.hw_scan = NULL;
 	}
 
@@ -6726,7 +6736,7 @@ static int iwl4965_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 	priv->pci_dev = pdev;
 
 #ifdef CONFIG_IWLWIFI_DEBUG
-	iwl_debug_level = priv->cfg->mod_params->debug;
+	priv->debug_level = priv->cfg->mod_params->debug;
 	atomic_set(&priv->restrict_refcnt, 0);
 #endif
 
-- 
1.5.3.6

