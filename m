Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:26186 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753443AbYGTXkX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Jul 2008 19:40:23 -0400
From: Tomas Winkler <tomas.winkler@intel.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net, yi.zhu@intel.com
Cc: linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 2/3] iwlwifi: fix checkpatch.pl errors
Date: Mon, 21 Jul 2008 02:40:14 +0300
Message-Id: <1216597215-19708-3-git-send-email-tomas.winkler@intel.com> (sfid-20080721_014027_745271_FE3BA75C)
In-Reply-To: <1216597215-19708-2-git-send-email-tomas.winkler@intel.com>
References: <1216597215-19708-1-git-send-email-tomas.winkler@intel.com>
 <1216597215-19708-2-git-send-email-tomas.winkler@intel.com>
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes errors reported by checkpatch in iwlwifi drivers

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945.c     |    7 ++--
 drivers/net/wireless/iwlwifi/iwl-4965.c     |    4 +-
 drivers/net/wireless/iwlwifi/iwl-5000.c     |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c   |   16 ++++----
 drivers/net/wireless/iwlwifi/iwl-agn.c      |   10 +++---
 drivers/net/wireless/iwlwifi/iwl-core.c     |    4 +-
 drivers/net/wireless/iwlwifi/iwl-debug.h    |    4 +-
 drivers/net/wireless/iwlwifi/iwl-debugfs.c  |   11 ++++--
 drivers/net/wireless/iwlwifi/iwl-eeprom.c   |    3 +-
 drivers/net/wireless/iwlwifi/iwl-sta.c      |    2 +-
 drivers/net/wireless/iwlwifi/iwl3945-base.c |   52 ++++++++++++---------------
 11 files changed, 55 insertions(+), 60 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index c2a7678..cab1f4b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -791,8 +791,7 @@ static void iwl3945_rx_reply_rx(struct iwl3945_priv *priv,
 					struct ieee80211_mgmt *mgmt =
 					    (struct ieee80211_mgmt *)header;
 					__le32 *pos;
-					pos =
-					    (__le32 *) & mgmt->u.beacon.
+					pos = (__le32 *)&mgmt->u.beacon.
 					    timestamp;
 					priv->timestamp0 = le32_to_cpu(pos[0]);
 					priv->timestamp1 = le32_to_cpu(pos[1]);
@@ -1505,7 +1504,7 @@ static int iwl3945_hw_reg_adjust_power_by_temp(int new_reading, int old_reading)
  */
 static inline int iwl3945_hw_reg_temp_out_of_range(int temperature)
 {
-	return (((temperature < -260) || (temperature > 25)) ? 1 : 0);
+	return ((temperature < -260) || (temperature > 25)) ? 1 : 0;
 }
 
 int iwl3945_hw_get_temperature(struct iwl3945_priv *priv)
@@ -2626,7 +2625,7 @@ unsigned int iwl3945_hw_get_beacon_cmd(struct iwl3945_priv *priv,
 	tx_beacon_cmd->tx.supp_rates[1] =
 		(IWL_CCK_BASIC_RATES_MASK & 0xF);
 
-	return (sizeof(struct iwl3945_tx_beacon_cmd) + frame_size);
+	return sizeof(struct iwl3945_tx_beacon_cmd) + frame_size;
 }
 
 void iwl3945_hw_rx_handler_setup(struct iwl3945_priv *priv)
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index ee31c24..e261bc9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -1515,11 +1515,11 @@ static int iwl4965_fill_txpower_tbl(struct iwl_priv *priv, u8 band, u16 channel,
 					  c, atten_value, power_index,
 					tx_power.s.radio_tx_gain[c],
 					tx_power.s.dsp_predis_atten[c]);
-		}/* for each chain */
+		} /* for each chain */
 
 		tx_power_tbl->power_tbl[i].dw = cpu_to_le32(tx_power.dw);
 
-	}/* for each rate */
+	} /* for each rate */
 
 	return 0;
 }
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index 076d356..f7bbd12 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -1131,7 +1131,7 @@ static void iwl5000_txq_set_sched(struct iwl_priv *priv, u32 mask)
 
 static inline u32 iwl5000_get_scd_ssn(struct iwl5000_tx_resp *tx_resp)
 {
-	return le32_to_cpup((__le32*)&tx_resp->status +
+	return le32_to_cpup((__le32 *)&tx_resp->status +
 			    tx_resp->frame_count) & MAX_SN;
 }
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
index 0e8100e..a8bf5a9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
@@ -245,7 +245,7 @@ static void rs_rate_scale_clear_window(struct iwl_rate_scale_data *window)
 
 static inline u8 rs_is_valid_ant(u8 valid_antenna, u8 ant_type)
 {
-	return ((ant_type & valid_antenna) == ant_type);
+	return (ant_type & valid_antenna) == ant_type;
 }
 
 /*
@@ -384,9 +384,9 @@ static void rs_tl_turn_on_agg(struct iwl_priv *priv, u8 tid,
 
 static inline int get_num_of_ant_from_rate(u32 rate_n_flags)
 {
-	return (!!(rate_n_flags & RATE_MCS_ANT_A_MSK) +
-		!!(rate_n_flags & RATE_MCS_ANT_B_MSK) +
-		!!(rate_n_flags & RATE_MCS_ANT_C_MSK));
+	return !!(rate_n_flags & RATE_MCS_ANT_A_MSK) +
+	       !!(rate_n_flags & RATE_MCS_ANT_B_MSK) +
+	       !!(rate_n_flags & RATE_MCS_ANT_C_MSK);
 }
 
 /**
@@ -620,9 +620,9 @@ static int rs_toggle_antenna(u32 valid_ant, u32 *rate_n_flags,
 #if 0
 static inline u8 rs_use_green(struct iwl_priv *priv, struct ieee80211_conf *conf)
 {
-	return ((conf->flags & IEEE80211_CONF_SUPPORT_HT_MODE) &&
+	return (conf->flags & IEEE80211_CONF_SUPPORT_HT_MODE) &&
 		priv->current_ht_config.is_green_field &&
-		!priv->current_ht_config.non_GF_STA_present);
+		!priv->current_ht_config.non_GF_STA_present;
 }
 #endif
 static inline u8 rs_use_green(struct iwl_priv *priv, struct ieee80211_conf *conf)
@@ -2157,7 +2157,7 @@ static void *rs_alloc_sta(void *priv_rate, gfp_t gfp)
 
 	for (j = 0; j < LQ_SIZE; j++)
 		for (i = 0; i < IWL_RATE_COUNT; i++)
-			rs_rate_scale_clear_window(&(lq_sta->lq_info[j].win[i]));
+			rs_rate_scale_clear_window(&lq_sta->lq_info[j].win[i]);
 
 	return lq_sta;
 }
@@ -2179,7 +2179,7 @@ static void rs_rate_init(void *priv_rate, void *priv_sta,
 	sta->txrate_idx = 3;
 	for (j = 0; j < LQ_SIZE; j++)
 		for (i = 0; i < IWL_RATE_COUNT; i++)
-			rs_rate_scale_clear_window(&(lq_sta->lq_info[j].win[i]));
+			rs_rate_scale_clear_window(&lq_sta->lq_info[j].win[i]);
 
 	IWL_DEBUG_RATE("LQ: *** rate scale global init ***\n");
 	/* TODO: what is a good starting rate for STA? About middle? Maybe not
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 3ebe90a..3639607 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -2477,7 +2477,7 @@ static void iwl4965_post_associate(struct iwl_priv *priv)
 	unsigned long flags;
 
 	if (priv->iw_mode == IEEE80211_IF_TYPE_AP) {
-		IWL_ERROR("%s Should not be called in AP mode\n", __FUNCTION__);
+		IWL_ERROR("%s Should not be called in AP mode\n", __func__);
 		return;
 	}
 
@@ -2553,7 +2553,7 @@ static void iwl4965_post_associate(struct iwl_priv *priv)
 
 	default:
 		IWL_ERROR("%s Should not be called in %d mode\n",
-				__FUNCTION__, priv->iw_mode);
+			  __func__, priv->iw_mode);
 		break;
 	}
 
@@ -3781,7 +3781,7 @@ static ssize_t show_measurement(struct device *d,
 	struct iwl_priv *priv = dev_get_drvdata(d);
 	struct iwl4965_spectrum_notification measure_report;
 	u32 size = sizeof(measure_report), len = 0, ofs = 0;
-	u8 *data = (u8 *) & measure_report;
+	u8 *data = (u8 *)&measure_report;
 	unsigned long flags;
 
 	spin_lock_irqsave(&priv->lock, flags);
@@ -3921,7 +3921,7 @@ static ssize_t show_power_level(struct device *d,
 	p += sprintf(p, "\tMODE:%s", (mode < IWL_POWER_AUTO)?"fixed":"auto");
 	p += sprintf(p, "\tINDEX:%d", level);
 	p += sprintf(p, "\n");
-	return (p - buf + 1);
+	return p - buf + 1;
 }
 
 static DEVICE_ATTR(power_level, S_IWUSR | S_IRUSR, show_power_level,
@@ -3996,7 +3996,7 @@ static ssize_t show_statistics(struct device *d,
 	struct iwl_priv *priv = dev_get_drvdata(d);
 	u32 size = sizeof(struct iwl_notif_statistics);
 	u32 len = 0, ofs = 0;
-	u8 *data = (u8 *) & priv->statistics;
+	u8 *data = (u8 *)&priv->statistics;
 	int rc = 0;
 
 	if (!iwl_is_alive(priv))
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 5cd990b..f55d7eb 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -383,8 +383,8 @@ void iwl_reset_qos(struct iwl_priv *priv)
 }
 EXPORT_SYMBOL(iwl_reset_qos);
 
-#define MAX_BIT_RATE_40_MHZ 0x96; /* 150 Mbps */
-#define MAX_BIT_RATE_20_MHZ 0x48; /* 72 Mbps */
+#define MAX_BIT_RATE_40_MHZ 0x96 /* 150 Mbps */
+#define MAX_BIT_RATE_20_MHZ 0x48 /* 72 Mbps */
 static void iwlcore_init_ht_hw_capab(const struct iwl_priv *priv,
 			      struct ieee80211_ht_info *ht_info,
 			      enum ieee80211_band band)
diff --git a/drivers/net/wireless/iwlwifi/iwl-debug.h b/drivers/net/wireless/iwlwifi/iwl-debug.h
index 5838480..097a72f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debug.h
+++ b/drivers/net/wireless/iwlwifi/iwl-debug.h
@@ -33,12 +33,12 @@
 #define IWL_DEBUG(level, fmt, args...) \
 do { if (priv->debug_level & (level)) \
   dev_printk(KERN_ERR, &(priv->hw->wiphy->dev), "%c %s " fmt, \
-	 in_interrupt() ? 'I' : 'U', __FUNCTION__ , ## args); } while (0)
+	 in_interrupt() ? 'I' : 'U', __func__ , ## args); } while (0)
 
 #define IWL_DEBUG_LIMIT(level, fmt, args...) \
 do { if ((priv->debug_level & (level)) && net_ratelimit()) \
   dev_printk(KERN_ERR, &(priv->hw->wiphy->dev), "%c %s " fmt, \
-	 in_interrupt() ? 'I' : 'U', __FUNCTION__ , ## args); } while (0)
+	 in_interrupt() ? 'I' : 'U', __func__ , ## args); } while (0)
 
 #ifdef CONFIG_IWLWIFI_DEBUGFS
 struct iwl_debugfs {
diff --git a/drivers/net/wireless/iwlwifi/iwl-debugfs.c b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
index ed948dc..20db0eb 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debugfs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
@@ -231,7 +231,7 @@ static ssize_t iwl_dbgfs_stations_read(struct file *file, char __user *user_buf,
 	DECLARE_MAC_BUF(mac);
 
 	buf = kmalloc(bufsz, GFP_KERNEL);
-	if(!buf)
+	if (!buf)
 		return -ENOMEM;
 
 	pos += scnprintf(buf + pos, bufsz - pos, "num of stations: %d\n\n",
@@ -364,16 +364,19 @@ int iwl_dbgfs_register(struct iwl_priv *priv, const char *name)
 {
 	struct iwl_debugfs *dbgfs;
 	struct dentry *phyd = priv->hw->wiphy->debugfsdir;
+	int ret = 0;
 
 	dbgfs = kzalloc(sizeof(struct iwl_debugfs), GFP_KERNEL);
 	if (!dbgfs) {
+		ret = -ENOMEM;
 		goto err;
 	}
 
 	priv->dbgfs = dbgfs;
 	dbgfs->name = name;
 	dbgfs->dir_drv = debugfs_create_dir(name, phyd);
-	if (!dbgfs->dir_drv || IS_ERR(dbgfs->dir_drv)){
+	if (!dbgfs->dir_drv || IS_ERR(dbgfs->dir_drv)) {
+		ret = -ENOENT;
 		goto err;
 	}
 
@@ -394,7 +397,7 @@ int iwl_dbgfs_register(struct iwl_priv *priv, const char *name)
 err:
 	IWL_ERROR("Can't open the debugfs directory\n");
 	iwl_dbgfs_unregister(priv);
-	return -ENOENT;
+	return ret;
 }
 EXPORT_SYMBOL(iwl_dbgfs_register);
 
@@ -404,7 +407,7 @@ EXPORT_SYMBOL(iwl_dbgfs_register);
  */
 void iwl_dbgfs_unregister(struct iwl_priv *priv)
 {
-	if (!(priv->dbgfs))
+	if (!priv->dbgfs)
 		return;
 
 	DEBUGFS_REMOVE(priv->dbgfs->dbgfs_data_files.file_eeprom);
diff --git a/drivers/net/wireless/iwlwifi/iwl-eeprom.c b/drivers/net/wireless/iwlwifi/iwl-eeprom.c
index 4a08a1b..bce5383 100644
--- a/drivers/net/wireless/iwlwifi/iwl-eeprom.c
+++ b/drivers/net/wireless/iwlwifi/iwl-eeprom.c
@@ -273,8 +273,7 @@ EXPORT_SYMBOL(iwl_eeprom_init);
 
 void iwl_eeprom_free(struct iwl_priv *priv)
 {
-	if(priv->eeprom)
-		kfree(priv->eeprom);
+	kfree(priv->eeprom);
 	priv->eeprom = NULL;
 }
 EXPORT_SYMBOL(iwl_eeprom_free);
diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.c b/drivers/net/wireless/iwlwifi/iwl-sta.c
index 10af821..60a6e01 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-sta.c
@@ -823,7 +823,7 @@ int iwl_send_lq_cmd(struct iwl_priv *priv,
 	if (lq->sta_id == 0xFF)
 		lq->sta_id = IWL_AP_ID;
 
-	iwl_dump_lq_cmd(priv,lq);
+	iwl_dump_lq_cmd(priv, lq);
 
 	if (iwl_is_associated(priv) && priv->assoc_station_added)
 		return  iwl_send_cmd(priv, &cmd);
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index ae81072..27e6cb1 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -275,10 +275,8 @@ static int iwl3945_tx_queue_alloc(struct iwl3945_priv *priv,
 	return 0;
 
  error:
-	if (txq->txb) {
-		kfree(txq->txb);
-		txq->txb = NULL;
-	}
+	kfree(txq->txb);
+	txq->txb = NULL;
 
 	return -ENOMEM;
 }
@@ -365,10 +363,8 @@ void iwl3945_tx_queue_free(struct iwl3945_priv *priv, struct iwl3945_tx_queue *t
 				    txq->q.n_bd, txq->bd, txq->q.dma_addr);
 
 	/* De-alloc array of per-TFD driver data */
-	if (txq->txb) {
-		kfree(txq->txb);
-		txq->txb = NULL;
-	}
+	kfree(txq->txb);
+	txq->txb = NULL;
 
 	/* 0-fill queue descriptor structure */
 	memset(txq, 0, sizeof(*txq));
@@ -2703,9 +2699,8 @@ static int iwl3945_tx_skb(struct iwl3945_priv *priv, struct sk_buff *skb)
 
 	if (!ieee80211_has_morefrags(hdr->frame_control)) {
 		txq->need_update = 1;
-		if (qc) {
+		if (qc)
 			priv->stations[sta_id].tid[tid].seq_number = seq_number;
-		}
 	} else {
 		wait_write_ptr = 1;
 		txq->need_update = 0;
@@ -3813,7 +3808,7 @@ int iwl3945_calc_db_from_ratio(int sig_ratio)
 	/* 100:1 or higher, divide by 10 and use table,
 	 *   add 20 dB to make up for divide by 10 */
 	if (sig_ratio >= 100)
-		return (20 + (int)ratio2dB[sig_ratio/10]);
+		return 20 + (int)ratio2dB[sig_ratio/10];
 
 	/* We shouldn't see this */
 	if (sig_ratio < 1)
@@ -5088,7 +5083,7 @@ static void iwl3945_dealloc_ucode_pci(struct iwl3945_priv *priv)
  * iwl3945_verify_inst_full - verify runtime uCode image in card vs. host,
  *     looking at all data.
  */
-static int iwl3945_verify_inst_full(struct iwl3945_priv *priv, __le32 * image, u32 len)
+static int iwl3945_verify_inst_full(struct iwl3945_priv *priv, __le32 *image, u32 len)
 {
 	u32 val;
 	u32 save_len = len;
@@ -5237,7 +5232,7 @@ static int iwl3945_verify_bsm(struct iwl3945_priv *priv)
 	val = iwl3945_read_prph(priv, BSM_WR_DWCOUNT_REG);
 	for (reg = BSM_SRAM_LOWER_BOUND;
 	     reg < BSM_SRAM_LOWER_BOUND + len;
-	     reg += sizeof(u32), image ++) {
+	     reg += sizeof(u32), image++) {
 		val = iwl3945_read_prph(priv, reg);
 		if (val != le32_to_cpu(*image)) {
 			IWL_ERROR("BSM uCode verification failed at "
@@ -6336,7 +6331,7 @@ static void iwl3945_bg_post_associate(struct work_struct *data)
 	DECLARE_MAC_BUF(mac);
 
 	if (priv->iw_mode == IEEE80211_IF_TYPE_AP) {
-		IWL_ERROR("%s Should not be called in AP mode\n", __FUNCTION__);
+		IWL_ERROR("%s Should not be called in AP mode\n", __func__);
 		return;
 	}
 
@@ -6417,7 +6412,7 @@ static void iwl3945_bg_post_associate(struct work_struct *data)
 
 	default:
 		 IWL_ERROR("%s Should not be called in %d mode\n",
-			   __FUNCTION__, priv->iw_mode);
+			   __func__, priv->iw_mode);
 		break;
 	}
 
@@ -7436,7 +7431,7 @@ static ssize_t show_measurement(struct device *d,
 	struct iwl3945_priv *priv = dev_get_drvdata(d);
 	struct iwl3945_spectrum_notification measure_report;
 	u32 size = sizeof(measure_report), len = 0, ofs = 0;
-	u8 *data = (u8 *) & measure_report;
+	u8 *data = (u8 *)&measure_report;
 	unsigned long flags;
 
 	spin_lock_irqsave(&priv->lock, flags);
@@ -7607,7 +7602,7 @@ static ssize_t show_power_level(struct device *d,
 	else
 		p += sprintf(p, " \n");
 
-	return (p - buf + 1);
+	return p - buf + 1;
 
 }
 
@@ -7629,7 +7624,7 @@ static ssize_t show_statistics(struct device *d,
 	struct iwl3945_priv *priv = dev_get_drvdata(d);
 	u32 size = sizeof(struct iwl3945_notif_statistics);
 	u32 len = 0, ofs = 0;
-	u8 *data = (u8 *) & priv->statistics;
+	u8 *data = (u8 *)&priv->statistics;
 	int rc = 0;
 
 	if (!iwl3945_is_alive(priv))
@@ -7985,16 +7980,16 @@ static int iwl3945_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 
 	/* nic init */
 	iwl3945_set_bit(priv, CSR_GIO_CHICKEN_BITS,
-                    CSR_GIO_CHICKEN_BITS_REG_BIT_DIS_L0S_EXIT_TIMER);
-
-        iwl3945_set_bit(priv, CSR_GP_CNTRL, CSR_GP_CNTRL_REG_FLAG_INIT_DONE);
-        err = iwl3945_poll_bit(priv, CSR_GP_CNTRL,
-                          CSR_GP_CNTRL_REG_FLAG_MAC_CLOCK_READY,
-                          CSR_GP_CNTRL_REG_FLAG_MAC_CLOCK_READY, 25000);
-        if (err < 0) {
-                IWL_DEBUG_INFO("Failed to init the card\n");
+			CSR_GIO_CHICKEN_BITS_REG_BIT_DIS_L0S_EXIT_TIMER);
+
+	iwl3945_set_bit(priv, CSR_GP_CNTRL, CSR_GP_CNTRL_REG_FLAG_INIT_DONE);
+	err = iwl3945_poll_bit(priv, CSR_GP_CNTRL,
+			       CSR_GP_CNTRL_REG_FLAG_MAC_CLOCK_READY,
+			       CSR_GP_CNTRL_REG_FLAG_MAC_CLOCK_READY, 25000);
+	if (err < 0) {
+		IWL_DEBUG_INFO("Failed to init the card\n");
 		goto out_remove_sysfs;
-        }
+	}
 	/* Read the EEPROM */
 	err = iwl3945_eeprom_init(priv);
 	if (err) {
@@ -8096,9 +8091,8 @@ static void __devexit iwl3945_pci_remove(struct pci_dev *pdev)
 	iwl3945_unset_hw_setting(priv);
 	iwl3945_clear_stations_table(priv);
 
-	if (priv->mac80211_registered) {
+	if (priv->mac80211_registered)
 		ieee80211_unregister_hw(priv->hw);
-	}
 
 	/*netif_stop_queue(dev); */
 	flush_workqueue(priv->workqueue);
-- 
1.5.4.1

---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

