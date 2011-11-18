Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33939 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756975Ab1KRIXK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Nov 2011 03:23:10 -0500
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pAI8NALk032548
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-wireless@vger.kernel.org>; Fri, 18 Nov 2011 03:23:10 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 67/77] iwlegacy: checkpatch.pl fixes
Date: Fri, 18 Nov 2011 09:22:29 +0100
Message-Id: <1321604559-10707-67-git-send-email-sgruszka@redhat.com> (sfid-20111118_092318_966824_192A7D97)
In-Reply-To: <1321604559-10707-1-git-send-email-sgruszka@redhat.com>
References: <1321604559-10707-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix most checkpatch.pl ERRORs and some WARNINGs.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlegacy/3945-debug.c |   12 +-
 drivers/net/wireless/iwlegacy/3945-mac.c   |   10 +-
 drivers/net/wireless/iwlegacy/3945-rs.c    |    4 +-
 drivers/net/wireless/iwlegacy/3945.c       |   43 ++++----
 drivers/net/wireless/iwlegacy/3945.h       |   29 ++---
 drivers/net/wireless/iwlegacy/4965-calib.c |    7 +-
 drivers/net/wireless/iwlegacy/4965-debug.c |   12 +-
 drivers/net/wireless/iwlegacy/4965-mac.c   |   60 +++++------
 drivers/net/wireless/iwlegacy/4965-rs.c    |   36 +++---
 drivers/net/wireless/iwlegacy/4965.c       |    4 +-
 drivers/net/wireless/iwlegacy/4965.h       |   30 +++---
 drivers/net/wireless/iwlegacy/common.c     |  157 +++++--------------------
 drivers/net/wireless/iwlegacy/common.h     |  132 +++++++++++-----------
 drivers/net/wireless/iwlegacy/debug.c      |  172 ++++++++++++++--------------
 14 files changed, 297 insertions(+), 411 deletions(-)

diff --git a/drivers/net/wireless/iwlegacy/3945-debug.c b/drivers/net/wireless/iwlegacy/3945-debug.c
index 382af2e..5e1a19f 100644
--- a/drivers/net/wireless/iwlegacy/3945-debug.c
+++ b/drivers/net/wireless/iwlegacy/3945-debug.c
@@ -49,8 +49,8 @@ il3945_stats_flag(struct il_priv *il, char *buf, int bufsz)
 }
 
 ssize_t
-il3945_ucode_rx_stats_read(struct file * file, char __user * user_buf,
-			   size_t count, loff_t * ppos)
+il3945_ucode_rx_stats_read(struct file *file, char __user *user_buf,
+			   size_t count, loff_t *ppos)
 {
 	struct il_priv *il = file->private_data;
 	int pos = 0;
@@ -314,8 +314,8 @@ il3945_ucode_rx_stats_read(struct file * file, char __user * user_buf,
 }
 
 ssize_t
-il3945_ucode_tx_stats_read(struct file * file, char __user * user_buf,
-			   size_t count, loff_t * ppos)
+il3945_ucode_tx_stats_read(struct file *file, char __user *user_buf,
+			   size_t count, loff_t *ppos)
 {
 	struct il_priv *il = file->private_data;
 	int pos = 0;
@@ -404,8 +404,8 @@ il3945_ucode_tx_stats_read(struct file * file, char __user * user_buf,
 }
 
 ssize_t
-il3945_ucode_general_stats_read(struct file * file, char __user * user_buf,
-				size_t count, loff_t * ppos)
+il3945_ucode_general_stats_read(struct file *file, char __user *user_buf,
+				size_t count, loff_t *ppos)
 {
 	struct il_priv *il = file->private_data;
 	int pos = 0;
diff --git a/drivers/net/wireless/iwlegacy/3945-mac.c b/drivers/net/wireless/iwlegacy/3945-mac.c
index 2249fe4..daef6b5 100644
--- a/drivers/net/wireless/iwlegacy/3945-mac.c
+++ b/drivers/net/wireless/iwlegacy/3945-mac.c
@@ -1033,11 +1033,9 @@ il3945_rx_allocate(struct il_priv *il, gfp_t priority)
 				D_INFO("Failed to allocate SKB buffer.\n");
 			if (rxq->free_count <= RX_LOW_WATERMARK &&
 			    net_ratelimit())
-				IL_ERR
-				    ("Failed to allocate SKB buffer with %s. Only %u free buffers remaining.\n",
-				     priority ==
-				     GFP_ATOMIC ? "GFP_ATOMIC" : "GFP_KERNEL",
-				     rxq->free_count);
+				IL_ERR("Failed to allocate SKB buffer with %0x."
+				       "Only %u free buffers remaining.\n",
+				       priority, rxq->free_count);
 			/* We don't reschedule replenish work here -- we will
 			 * call the restock method and if it still needs
 			 * more buffers it will schedule replenish */
@@ -3250,7 +3248,7 @@ il3945_show_measurement(struct device *d, struct device_attribute *attr,
 	struct il_priv *il = dev_get_drvdata(d);
 	struct il_spectrum_notification measure_report;
 	u32 size = sizeof(measure_report), len = 0, ofs = 0;
-	u8 *data = (u8 *) & measure_report;
+	u8 *data = (u8 *) &measure_report;
 	unsigned long flags;
 
 	spin_lock_irqsave(&il->lock, flags);
diff --git a/drivers/net/wireless/iwlegacy/3945-rs.c b/drivers/net/wireless/iwlegacy/3945-rs.c
index 3420b1c..30ad404 100644
--- a/drivers/net/wireless/iwlegacy/3945-rs.c
+++ b/drivers/net/wireless/iwlegacy/3945-rs.c
@@ -837,8 +837,8 @@ il3945_open_file_generic(struct inode *inode, struct file *file)
 }
 
 static ssize_t
-il3945_sta_dbgfs_stats_table_read(struct file *file, char __user * user_buf,
-				  size_t count, loff_t * ppos)
+il3945_sta_dbgfs_stats_table_read(struct file *file, char __user *user_buf,
+				  size_t count, loff_t *ppos)
 {
 	char *buff;
 	int desc = 0;
diff --git a/drivers/net/wireless/iwlegacy/3945.c b/drivers/net/wireless/iwlegacy/3945.c
index 7f0b9f5..7367dbb 100644
--- a/drivers/net/wireless/iwlegacy/3945.c
+++ b/drivers/net/wireless/iwlegacy/3945.c
@@ -381,10 +381,10 @@ il3945_accumulative_stats(struct il_priv *il, __le32 * stats)
 	u32 *accum_stats;
 	u32 *delta, *max_delta;
 
-	prev_stats = (__le32 *) & il->_3945.stats;
-	accum_stats = (u32 *) & il->_3945.accum_stats;
-	delta = (u32 *) & il->_3945.delta_stats;
-	max_delta = (u32 *) & il->_3945.max_delta;
+	prev_stats = (__le32 *) &il->_3945.stats;
+	accum_stats = (u32 *) &il->_3945.accum_stats;
+	delta = (u32 *) &il->_3945.delta_stats;
+	max_delta = (u32 *) &il->_3945.max_delta;
 
 	for (i = sizeof(__le32); i < sizeof(struct il3945_notif_stats);
 	     i +=
@@ -416,7 +416,7 @@ il3945_hdl_stats(struct il_priv *il, struct il_rx_buf *rxb)
 	     (int)sizeof(struct il3945_notif_stats),
 	     le32_to_cpu(pkt->len_n_flags) & IL_RX_FRAME_SIZE_MSK);
 #ifdef CONFIG_IWLEGACY_DEBUGFS
-	il3945_accumulative_stats(il, (__le32 *) & pkt->u.raw);
+	il3945_accumulative_stats(il, (__le32 *) &pkt->u.raw);
 #endif
 
 	memcpy(&il->_3945.stats, pkt->u.raw, sizeof(il->_3945.stats));
@@ -426,7 +426,7 @@ void
 il3945_hdl_c_stats(struct il_priv *il, struct il_rx_buf *rxb)
 {
 	struct il_rx_pkt *pkt = rxb_addr(rxb);
-	__le32 *flag = (__le32 *) & pkt->u.raw;
+	__le32 *flag = (__le32 *) &pkt->u.raw;
 
 	if (le32_to_cpu(*flag) & UCODE_STATS_CLEAR_MSK) {
 #ifdef CONFIG_IWLEGACY_DEBUGFS
@@ -775,7 +775,8 @@ il3945_set_pwr_vmain(struct il_priv *il)
 			      APMG_PS_CTRL_VAL_PWR_SRC_VMAIN,
 			      ~APMG_PS_CTRL_MSK_PWR_SRC);
 
-	_il_poll_bit(il, CSR_GPIO_IN, CSR_GPIO_IN_VAL_VMAIN_PWR_SRC, CSR_GPIO_IN_BIT_AUX_POWER, 5000);	/* uS */
+	_il_poll_bit(il, CSR_GPIO_IN, CSR_GPIO_IN_VAL_VMAIN_PWR_SRC,
+		     CSR_GPIO_IN_BIT_AUX_POWER, 5000);
 }
 
 static int
@@ -1228,7 +1229,8 @@ static struct il3945_tx_power power_gain_table[2][IL_MAX_GAIN_ENTRIES] = {
 	 {3, 113},
 	 {3, 106},
 	 {3, 102},
-	 {3, 95}},		/* 2.4 GHz, lowest power */
+	 {3, 95}		/* 2.4 GHz, lowest power */
+	},
 	{
 	 {251, 127},		/* 5.x GHz, highest power */
 	 {251, 120},
@@ -1307,7 +1309,8 @@ static struct il3945_tx_power power_gain_table[2][IL_MAX_GAIN_ENTRIES] = {
 	 {35, 113},
 	 {35, 107},
 	 {35, 99},
-	 {3, 120}}		/* 5.x GHz, lowest power */
+	 {3, 120}		/* 5.x GHz, lowest power */
+	}
 };
 
 static inline u8
@@ -1331,7 +1334,7 @@ il3945_hw_reg_fix_power_idx(int idx)
  */
 static void
 il3945_hw_reg_set_scan_power(struct il_priv *il, u32 scan_tbl_idx, s32 rate_idx,
-			     const s8 * clip_pwrs,
+			     const s8 *clip_pwrs,
 			     struct il_channel_info *ch_info, int band_idx)
 {
 	struct il3945_scan_power_info *scan_power_info;
@@ -1883,8 +1886,7 @@ il3945_bg_reg_txpower_periodic(struct work_struct *work)
 }
 
 /**
- * il3945_hw_reg_get_ch_grp_idx - find the channel-group idx (0-4)
- * 				   for the channel.
+ * il3945_hw_reg_get_ch_grp_idx - find the channel-group idx (0-4) for channel.
  *
  * This function is used when initializing channel-info structs.
  *
@@ -1930,7 +1932,7 @@ il3945_hw_reg_get_ch_grp_idx(struct il_priv *il,
  */
 static int
 il3945_hw_reg_get_matched_power_idx(struct il_priv *il, s8 requested_power,
-				    s32 setting_idx, s32 * new_idx)
+				    s32 setting_idx, s32 *new_idx)
 {
 	const struct il3945_eeprom_txpower_group *chnl_grp = NULL;
 	struct il3945_eeprom *eeprom = (struct il3945_eeprom *)il->eeprom;
@@ -2735,14 +2737,13 @@ static struct il_cfg il3945_abg_cfg = {
 };
 
 DEFINE_PCI_DEVICE_TABLE(il3945_hw_card_ids) = {
-	{
-	IL_PCI_DEVICE(0x4222, 0x1005, il3945_bg_cfg)}, {
-	IL_PCI_DEVICE(0x4222, 0x1034, il3945_bg_cfg)}, {
-	IL_PCI_DEVICE(0x4222, 0x1044, il3945_bg_cfg)}, {
-	IL_PCI_DEVICE(0x4227, 0x1014, il3945_bg_cfg)}, {
-	IL_PCI_DEVICE(0x4222, PCI_ANY_ID, il3945_abg_cfg)}, {
-	IL_PCI_DEVICE(0x4227, PCI_ANY_ID, il3945_abg_cfg)}, {
-	0}
+	{IL_PCI_DEVICE(0x4222, 0x1005, il3945_bg_cfg)},
+	{IL_PCI_DEVICE(0x4222, 0x1034, il3945_bg_cfg)},
+	{IL_PCI_DEVICE(0x4222, 0x1044, il3945_bg_cfg)},
+	{IL_PCI_DEVICE(0x4227, 0x1014, il3945_bg_cfg)},
+	{IL_PCI_DEVICE(0x4222, PCI_ANY_ID, il3945_abg_cfg)},
+	{IL_PCI_DEVICE(0x4227, PCI_ANY_ID, il3945_abg_cfg)},
+	{0}
 };
 
 MODULE_DEVICE_TABLE(pci, il3945_hw_card_ids);
diff --git a/drivers/net/wireless/iwlegacy/3945.h b/drivers/net/wireless/iwlegacy/3945.h
index 8e53751..00d3336 100644
--- a/drivers/net/wireless/iwlegacy/3945.h
+++ b/drivers/net/wireless/iwlegacy/3945.h
@@ -269,11 +269,6 @@ extern int il3945_init_hw_rate_table(struct il_priv *il);
 extern void il3945_reg_txpower_periodic(struct il_priv *il);
 extern int il3945_txpower_set_from_eeprom(struct il_priv *il);
 
-extern const struct il_channel_info *il3945_get_channel_info(const struct
-							     il_priv *il,
-							     enum ieee80211_band
-							     band, u16 channel);
-
 extern int il3945_rs_next_rate(struct il_priv *il, int rate);
 
 /* scanning */
@@ -619,31 +614,31 @@ struct il3945_tfd {
 } __packed;
 
 #ifdef CONFIG_IWLEGACY_DEBUGFS
-ssize_t il3945_ucode_rx_stats_read(struct file *file, char __user * user_buf,
-				   size_t count, loff_t * ppos);
-ssize_t il3945_ucode_tx_stats_read(struct file *file, char __user * user_buf,
-				   size_t count, loff_t * ppos);
+ssize_t il3945_ucode_rx_stats_read(struct file *file, char __user *user_buf,
+				   size_t count, loff_t *ppos);
+ssize_t il3945_ucode_tx_stats_read(struct file *file, char __user *user_buf,
+				   size_t count, loff_t *ppos);
 ssize_t il3945_ucode_general_stats_read(struct file *file,
-					char __user * user_buf, size_t count,
-					loff_t * ppos);
+					char __user *user_buf, size_t count,
+					loff_t *ppos);
 #else
 static ssize_t
-il3945_ucode_rx_stats_read(struct file *file, char __user * user_buf,
-			   size_t count, loff_t * ppos)
+il3945_ucode_rx_stats_read(struct file *file, char __user *user_buf,
+			   size_t count, loff_t *ppos)
 {
 	return 0;
 }
 
 static ssize_t
-il3945_ucode_tx_stats_read(struct file *file, char __user * user_buf,
-			   size_t count, loff_t * ppos)
+il3945_ucode_tx_stats_read(struct file *file, char __user *user_buf,
+			   size_t count, loff_t *ppos)
 {
 	return 0;
 }
 
 static ssize_t
-il3945_ucode_general_stats_read(struct file *file, char __user * user_buf,
-				size_t count, loff_t * ppos)
+il3945_ucode_general_stats_read(struct file *file, char __user *user_buf,
+				size_t count, loff_t *ppos)
 {
 	return 0;
 }
diff --git a/drivers/net/wireless/iwlegacy/4965-calib.c b/drivers/net/wireless/iwlegacy/4965-calib.c
index efb3233..d3248e3 100644
--- a/drivers/net/wireless/iwlegacy/4965-calib.c
+++ b/drivers/net/wireless/iwlegacy/4965-calib.c
@@ -366,7 +366,7 @@ il4965_sens_auto_corr_ofdm(struct il_priv *il, u32 norm_fa, u32 rx_enable_time)
 static void
 il4965_prepare_legacy_sensitivity_tbl(struct il_priv *il,
 				      struct il_sensitivity_data *data,
-				      __le16 * tbl)
+				      __le16 *tbl)
 {
 	tbl[HD_AUTO_CORR32_X4_TH_ADD_MIN_IDX] =
 	    cpu_to_le16((u16) data->auto_corr_ofdm);
@@ -707,9 +707,8 @@ il4965_find_disconn_antenna(struct il_priv *il, u32 * average_sig,
 			    il4965_find_first_chain(il->cfg->valid_tx_ant);
 			data->disconn_array[first_chain] = 0;
 			active_chains |= BIT(first_chain);
-			D_CALIB
-			    ("All Tx chains are disconnected W/A - declare %d as connected\n",
-			     first_chain);
+			D_CALIB("All Tx chains are disconnected"
+				"- declare %d as connected\n", first_chain);
 			break;
 		}
 	}
diff --git a/drivers/net/wireless/iwlegacy/4965-debug.c b/drivers/net/wireless/iwlegacy/4965-debug.c
index 5299399..98ec39f 100644
--- a/drivers/net/wireless/iwlegacy/4965-debug.c
+++ b/drivers/net/wireless/iwlegacy/4965-debug.c
@@ -56,8 +56,8 @@ il4965_stats_flag(struct il_priv *il, char *buf, int bufsz)
 }
 
 ssize_t
-il4965_ucode_rx_stats_read(struct file * file, char __user * user_buf,
-			   size_t count, loff_t * ppos)
+il4965_ucode_rx_stats_read(struct file *file, char __user *user_buf,
+			   size_t count, loff_t *ppos)
 {
 	struct il_priv *il = file->private_data;
 	int pos = 0;
@@ -468,8 +468,8 @@ il4965_ucode_rx_stats_read(struct file * file, char __user * user_buf,
 }
 
 ssize_t
-il4965_ucode_tx_stats_read(struct file * file, char __user * user_buf,
-			   size_t count, loff_t * ppos)
+il4965_ucode_tx_stats_read(struct file *file, char __user *user_buf,
+			   size_t count, loff_t *ppos)
 {
 	struct il_priv *il = file->private_data;
 	int pos = 0;
@@ -634,8 +634,8 @@ il4965_ucode_tx_stats_read(struct file * file, char __user * user_buf,
 }
 
 ssize_t
-il4965_ucode_general_stats_read(struct file * file, char __user * user_buf,
-				size_t count, loff_t * ppos)
+il4965_ucode_general_stats_read(struct file *file, char __user *user_buf,
+				size_t count, loff_t *ppos)
 {
 	struct il_priv *il = file->private_data;
 	int pos = 0;
diff --git a/drivers/net/wireless/iwlegacy/4965-mac.c b/drivers/net/wireless/iwlegacy/4965-mac.c
index ca819d8..21a1381 100644
--- a/drivers/net/wireless/iwlegacy/4965-mac.c
+++ b/drivers/net/wireless/iwlegacy/4965-mac.c
@@ -163,10 +163,10 @@ il4965_rx_init(struct il_priv *il, struct il_rx_queue *rxq)
 	il_wr(il, FH49_MEM_RCSR_CHNL0_CONFIG_REG,
 	      FH49_RCSR_RX_CONFIG_CHNL_EN_ENABLE_VAL |
 	      FH49_RCSR_CHNL0_RX_CONFIG_IRQ_DEST_INT_HOST_VAL |
-	      FH49_RCSR_CHNL0_RX_CONFIG_SINGLE_FRAME_MSK | rb_size | (rb_timeout
-								      <<
-								      FH49_RCSR_RX_CONFIG_REG_IRQ_RBTH_POS)
-	      | (rfdnlog << FH49_RCSR_RX_CONFIG_RBDCB_SIZE_POS));
+	      FH49_RCSR_CHNL0_RX_CONFIG_SINGLE_FRAME_MSK |
+	      rb_size |
+	      (rb_timeout << FH49_RCSR_RX_CONFIG_REG_IRQ_RBTH_POS) |
+	      (rfdnlog << FH49_RCSR_RX_CONFIG_RBDCB_SIZE_POS));
 
 	/* Set interrupt coalescing timer to default (2048 usecs) */
 	il_write8(il, CSR_INT_COALESCING, IL_HOST_INT_TIMEOUT_DEF);
@@ -1235,9 +1235,8 @@ il4965_dump_fh(struct il_priv *il, char **buf, bool display)
 			pos +=
 			    scnprintf(*buf + pos, bufsz - pos,
 				      "  %34s: 0X%08x\n",
-				      il4965_get_fh_string(fh_tbl[i]), il_rd(il,
-									     fh_tbl
-									     [i]));
+				      il4965_get_fh_string(fh_tbl[i]),
+				      il_rd(il, fh_tbl[i]));
 		}
 		return pos;
 	}
@@ -1328,15 +1327,15 @@ il4965_accumulative_stats(struct il_priv *il, __le32 * stats)
 	struct stats_general_common *general, *accum_general;
 	struct stats_tx *tx, *accum_tx;
 
-	prev_stats = (__le32 *) & il->_4965.stats;
-	accum_stats = (u32 *) & il->_4965.accum_stats;
+	prev_stats = (__le32 *) &il->_4965.stats;
+	accum_stats = (u32 *) &il->_4965.accum_stats;
 	size = sizeof(struct il_notif_stats);
 	general = &il->_4965.stats.general.common;
 	accum_general = &il->_4965.accum_stats.general.common;
 	tx = &il->_4965.stats.tx;
 	accum_tx = &il->_4965.accum_stats.tx;
-	delta = (u32 *) & il->_4965.delta_stats;
-	max_delta = (u32 *) & il->_4965.max_delta;
+	delta = (u32 *) &il->_4965.delta_stats;
+	max_delta = (u32 *) &il->_4965.max_delta;
 
 	for (i = sizeof(__le32); i < size;
 	     i +=
@@ -1375,7 +1374,7 @@ il4965_hdl_stats(struct il_priv *il, struct il_rx_buf *rxb)
 	     ((il->_4965.stats.flag & STATS_REPLY_FLG_HT40_MODE_MSK) !=
 	      (pkt->u.stats.flag & STATS_REPLY_FLG_HT40_MODE_MSK)));
 #ifdef CONFIG_IWLEGACY_DEBUGFS
-	il4965_accumulative_stats(il, (__le32 *) & pkt->u.stats);
+	il4965_accumulative_stats(il, (__le32 *) &pkt->u.stats);
 #endif
 
 	/* TODO: reading some of stats is unneeded */
@@ -2093,8 +2092,8 @@ il4965_txq_ctx_stop(struct il_priv *il)
 		    (il, FH49_TSSR_TX_STATUS_REG,
 		     FH49_TSSR_TX_STATUS_REG_MSK_CHNL_IDLE(ch), 1000))
 			IL_ERR("Failing on timeout while stopping"
-			       " DMA channel %d [0x%08x]", ch, il_rd(il,
-								     FH49_TSSR_TX_STATUS_REG));
+			       " DMA channel %d [0x%08x]", ch,
+			       il_rd(il, FH49_TSSR_TX_STATUS_REG));
 	}
 	spin_unlock_irqrestore(&il->lock, flags);
 
@@ -2135,8 +2134,8 @@ il4965_tx_queue_stop_scheduler(struct il_priv *il, u16 txq_id)
 	/* Simply stop the queue, but don't change any configuration;
 	 * the SCD_ACT_EN bit is the write-enable mask for the ACTIVE bit. */
 	il_wr_prph(il, IL49_SCD_QUEUE_STATUS_BITS(txq_id),
-		   (0 << IL49_SCD_QUEUE_STTS_REG_POS_ACTIVE) | (1 <<
-								IL49_SCD_QUEUE_STTS_REG_POS_SCD_ACT_EN));
+		   (0 << IL49_SCD_QUEUE_STTS_REG_POS_ACTIVE) |
+		   (1 << IL49_SCD_QUEUE_STTS_REG_POS_SCD_ACT_EN));
 }
 
 /**
@@ -2451,7 +2450,7 @@ il4965_txq_check_empty(struct il_priv *il, int sta_id, u8 tid, int txq_id)
 
 static void
 il4965_non_agg_tx_status(struct il_priv *il, struct il_rxon_context *ctx,
-			 const u8 * addr1)
+			 const u8 *addr1)
 {
 	struct ieee80211_sta *sta;
 	struct il_station_priv *sta_priv;
@@ -2661,7 +2660,7 @@ il4965_hdl_compressed_ba(struct il_priv *il, struct il_rx_buf *rxb)
 	spin_lock_irqsave(&il->sta_lock, flags);
 
 	D_TX_REPLY("N_COMPRESSED_BA [%d] Received from %pM, " "sta_id = %d\n",
-		   agg->wait_for_ba, (u8 *) & ba_resp->sta_addr_lo32,
+		   agg->wait_for_ba, (u8 *) &ba_resp->sta_addr_lo32,
 		   ba_resp->sta_id);
 	D_TX_REPLY("TID = %d, SeqCtl = %d, bitmap = 0x%llx," "scd_flow = "
 		   "%d, scd_ssn = %d\n", ba_resp->tid, ba_resp->seq_ctl,
@@ -2791,7 +2790,7 @@ il4965_sta_alloc_lq(struct il_priv *il, u8 sta_id)
  */
 int
 il4965_add_bssid_station(struct il_priv *il, struct il_rxon_context *ctx,
-			 const u8 * addr, u8 * sta_id_r)
+			 const u8 *addr, u8 *sta_id_r)
 {
 	int ret;
 	u8 sta_id;
@@ -3277,8 +3276,7 @@ il4965_update_bcast_station(struct il_priv *il, struct il_rxon_context *ctx)
 
 	link_cmd = il4965_sta_alloc_lq(il, sta_id);
 	if (!link_cmd) {
-		IL_ERR
-		    ("Unable to initialize rate scaling for bcast station.\n");
+		IL_ERR("Unable to initialize rate scaling for bcast sta.\n");
 		return -ENOMEM;
 	}
 
@@ -3286,8 +3284,7 @@ il4965_update_bcast_station(struct il_priv *il, struct il_rxon_context *ctx)
 	if (il->stations[sta_id].lq)
 		kfree(il->stations[sta_id].lq);
 	else
-		D_INFO
-		    ("Bcast station rate scaling has not been initialized yet.\n");
+		D_INFO("Bcast sta rate scaling has not been initialized.\n");
 	il->stations[sta_id].lq = link_cmd;
 	spin_unlock_irqrestore(&il->sta_lock, flags);
 
@@ -4819,11 +4816,10 @@ il4965_dump_nic_error_log(struct il_priv *il)
 	u32 blink1, blink2, ilink1, ilink2;
 	u32 pc, hcmd;
 
-	if (il->ucode_type == UCODE_INIT) {
+	if (il->ucode_type == UCODE_INIT)
 		base = le32_to_cpu(il->card_alive_init.error_event_table_ptr);
-	} else {
+	else
 		base = le32_to_cpu(il->card_alive.error_event_table_ptr);
-	}
 
 	if (!il->cfg->ops->lib->is_valid_rtc_data_addr(base)) {
 		IL_ERR("Not valid error log pointer 0x%08X for %s uCode\n",
@@ -6026,13 +6022,11 @@ il4965_tx_queue_set_status(struct il_priv *il, struct il_tx_queue *txq,
 
 	/* Set up and activate */
 	il_wr_prph(il, IL49_SCD_QUEUE_STATUS_BITS(txq_id),
-		   (active << IL49_SCD_QUEUE_STTS_REG_POS_ACTIVE) | (tx_fifo_id
-								     <<
-								     IL49_SCD_QUEUE_STTS_REG_POS_TXF)
-		   | (scd_retry << IL49_SCD_QUEUE_STTS_REG_POS_WSL) | (scd_retry
-								       <<
-								       IL49_SCD_QUEUE_STTS_REG_POS_SCD_ACK)
-		   | IL49_SCD_QUEUE_STTS_REG_MSK);
+		   (active << IL49_SCD_QUEUE_STTS_REG_POS_ACTIVE) |
+		   (tx_fifo_id << IL49_SCD_QUEUE_STTS_REG_POS_TXF) |
+		   (scd_retry << IL49_SCD_QUEUE_STTS_REG_POS_WSL) |
+		   (scd_retry << IL49_SCD_QUEUE_STTS_REG_POS_SCD_ACK) |
+		   IL49_SCD_QUEUE_STTS_REG_MSK);
 
 	txq->sched_retry = scd_retry;
 
diff --git a/drivers/net/wireless/iwlegacy/4965-rs.c b/drivers/net/wireless/iwlegacy/4965-rs.c
index 3ea2361..4bc5a18 100644
--- a/drivers/net/wireless/iwlegacy/4965-rs.c
+++ b/drivers/net/wireless/iwlegacy/4965-rs.c
@@ -96,18 +96,18 @@ static const u8 ant_toggle_lookup[] = {
  */
 const struct il_rate_info il_rates[RATE_COUNT] = {
 	IL_DECLARE_RATE_INFO(1, INV, INV, 2, INV, 2, INV, 2),	/*  1mbps */
-	IL_DECLARE_RATE_INFO(2, INV, 1, 5, 1, 5, 1, 5),	/*  2mbps */
+	IL_DECLARE_RATE_INFO(2, INV, 1, 5, 1, 5, 1, 5),		/*  2mbps */
 	IL_DECLARE_RATE_INFO(5, INV, 2, 6, 2, 11, 2, 11),	/*5.5mbps */
 	IL_DECLARE_RATE_INFO(11, INV, 9, 12, 9, 12, 5, 18),	/* 11mbps */
-	IL_DECLARE_RATE_INFO(6, 6, 5, 9, 5, 11, 5, 11),	/*  6mbps */
+	IL_DECLARE_RATE_INFO(6, 6, 5, 9, 5, 11, 5, 11),		/*  6mbps */
 	IL_DECLARE_RATE_INFO(9, 6, 6, 11, 6, 11, 5, 11),	/*  9mbps */
 	IL_DECLARE_RATE_INFO(12, 12, 11, 18, 11, 18, 11, 18),	/* 12mbps */
 	IL_DECLARE_RATE_INFO(18, 18, 12, 24, 12, 24, 11, 24),	/* 18mbps */
 	IL_DECLARE_RATE_INFO(24, 24, 18, 36, 18, 36, 18, 36),	/* 24mbps */
 	IL_DECLARE_RATE_INFO(36, 36, 24, 48, 24, 48, 24, 48),	/* 36mbps */
 	IL_DECLARE_RATE_INFO(48, 48, 36, 54, 36, 54, 36, 54),	/* 48mbps */
-	IL_DECLARE_RATE_INFO(54, 54, 48, INV, 48, INV, 48, INV),	/* 54mbps */
-	IL_DECLARE_RATE_INFO(60, 60, 48, INV, 48, INV, 48, INV),	/* 60mbps */
+	IL_DECLARE_RATE_INFO(54, 54, 48, INV, 48, INV, 48, INV),/* 54mbps */
+	IL_DECLARE_RATE_INFO(60, 60, 48, INV, 48, INV, 48, INV),/* 60mbps */
 };
 
 static int
@@ -150,7 +150,7 @@ static void il4965_rs_stay_in_table(struct il_lq_sta *lq_sta,
 
 #ifdef CONFIG_MAC80211_DEBUGFS
 static void il4965_rs_dbgfs_set_mcs(struct il_lq_sta *lq_sta,
-				    u32 * rate_n_flags, int idx);
+				    u32 *rate_n_flags, int idx);
 #else
 static void
 il4965_rs_dbgfs_set_mcs(struct il_lq_sta *lq_sta, u32 * rate_n_flags, int idx)
@@ -610,7 +610,7 @@ il4965_rs_get_tbl_info_from_mcs(const u32 rate_n_flags,
 /* switch to another antenna/antennas and return 1 */
 /* if no other valid antenna found, return 0 */
 static int
-il4965_rs_toggle_antenna(u32 valid_ant, u32 * rate_n_flags,
+il4965_rs_toggle_antenna(u32 valid_ant, u32 *rate_n_flags,
 			 struct il_scale_tbl_info *tbl)
 {
 	u8 new_ant_type;
@@ -1082,7 +1082,8 @@ il4965_rs_set_expected_tpt_table(struct il_lq_sta *lq_sta,
  * bit rate will typically need to increase, but not if performance was bad.
  */
 static s32
-il4965_rs_get_best_rate(struct il_priv *il, struct il_lq_sta *lq_sta, struct il_scale_tbl_info *tbl,	/* "search" */
+il4965_rs_get_best_rate(struct il_priv *il, struct il_lq_sta *lq_sta,
+			struct il_scale_tbl_info *tbl,	/* "search" */
 			u16 rate_mask, s8 idx)
 {
 	/* "active" values */
@@ -2012,11 +2013,10 @@ il4965_rs_rate_scale_perform(struct il_priv *il, struct sk_buff *skb,
 		/* Higher adjacent rate's throughput is measured */
 		if (high_tpt != IL_INVALID_VALUE) {
 			/* Higher rate has better throughput */
-			if (high_tpt > current_tpt && sr >= RATE_INCREASE_TH) {
+			if (high_tpt > current_tpt && sr >= RATE_INCREASE_TH)
 				scale_action = 1;
-			} else {
+			else
 				scale_action = 0;
-			}
 
 			/* Lower adjacent rate's throughput is measured */
 		} else if (low_tpt != IL_INVALID_VALUE) {
@@ -2583,8 +2583,8 @@ il4965_rs_dbgfs_set_mcs(struct il_lq_sta *lq_sta, u32 * rate_n_flags, int idx)
 
 static ssize_t
 il4965_rs_sta_dbgfs_scale_table_write(struct file *file,
-				      const char __user * user_buf,
-				      size_t count, loff_t * ppos)
+				      const char __user *user_buf,
+				      size_t count, loff_t *ppos)
 {
 	struct il_lq_sta *lq_sta = file->private_data;
 	struct il_priv *il;
@@ -2622,8 +2622,8 @@ il4965_rs_sta_dbgfs_scale_table_write(struct file *file,
 }
 
 static ssize_t
-il4965_rs_sta_dbgfs_scale_table_read(struct file *file, char __user * user_buf,
-				     size_t count, loff_t * ppos)
+il4965_rs_sta_dbgfs_scale_table_read(struct file *file, char __user *user_buf,
+				     size_t count, loff_t *ppos)
 {
 	char *buff;
 	int desc = 0;
@@ -2730,8 +2730,8 @@ static const struct file_operations rs_sta_dbgfs_scale_table_ops = {
 };
 
 static ssize_t
-il4965_rs_sta_dbgfs_stats_table_read(struct file *file, char __user * user_buf,
-				     size_t count, loff_t * ppos)
+il4965_rs_sta_dbgfs_stats_table_read(struct file *file, char __user *user_buf,
+				     size_t count, loff_t *ppos)
 {
 	char *buff;
 	int desc = 0;
@@ -2776,8 +2776,8 @@ static const struct file_operations rs_sta_dbgfs_stats_table_ops = {
 
 static ssize_t
 il4965_rs_sta_dbgfs_rate_scale_data_read(struct file *file,
-					 char __user * user_buf, size_t count,
-					 loff_t * ppos)
+					 char __user *user_buf, size_t count,
+					 loff_t *ppos)
 {
 	char buff[120];
 	int desc = 0;
diff --git a/drivers/net/wireless/iwlegacy/4965.c b/drivers/net/wireless/iwlegacy/4965.c
index be054f1..6f5e6a1 100644
--- a/drivers/net/wireless/iwlegacy/4965.c
+++ b/drivers/net/wireless/iwlegacy/4965.c
@@ -533,8 +533,8 @@ il4965_nic_config(struct il_priv *il)
 		   CSR_HW_IF_CONFIG_REG_BIT_MAC_SI);
 
 	il->calib_info =
-	    (struct il_eeprom_calib_info *)il_eeprom_query_addr(il,
-								EEPROM_4965_CALIB_TXPOWER_OFFSET);
+	    (struct il_eeprom_calib_info *)
+	    il_eeprom_query_addr(il, EEPROM_4965_CALIB_TXPOWER_OFFSET);
 
 	spin_unlock_irqrestore(&il->lock, flags);
 }
diff --git a/drivers/net/wireless/iwlegacy/4965.h b/drivers/net/wireless/iwlegacy/4965.h
index 78eae22..ded8b92 100644
--- a/drivers/net/wireless/iwlegacy/4965.h
+++ b/drivers/net/wireless/iwlegacy/4965.h
@@ -138,7 +138,7 @@ il4965_get_tx_fail_reason(u32 status)
 /* station management */
 int il4965_alloc_bcast_station(struct il_priv *il, struct il_rxon_context *ctx);
 int il4965_add_bssid_station(struct il_priv *il, struct il_rxon_context *ctx,
-			     const u8 * addr, u8 * sta_id_r);
+			     const u8 *addr, u8 *sta_id_r);
 int il4965_remove_default_wep_key(struct il_priv *il,
 				  struct il_rxon_context *ctx,
 				  struct ieee80211_key_conf *key);
@@ -153,7 +153,7 @@ int il4965_remove_dynamic_key(struct il_priv *il, struct il_rxon_context *ctx,
 void il4965_update_tkip_key(struct il_priv *il, struct il_rxon_context *ctx,
 			    struct ieee80211_key_conf *keyconf,
 			    struct ieee80211_sta *sta, u32 iv32,
-			    u16 * phase1key);
+			    u16 *phase1key);
 int il4965_sta_tx_modify_enable_tid(struct il_priv *il, int sta_id, int tid);
 int il4965_sta_rx_agg_start(struct il_priv *il, struct ieee80211_sta *sta,
 			    int tid, u16 ssn);
@@ -195,7 +195,7 @@ void il4965_mac_update_tkip_key(struct ieee80211_hw *hw,
 				struct ieee80211_vif *vif,
 				struct ieee80211_key_conf *keyconf,
 				struct ieee80211_sta *sta, u32 iv32,
-				u16 * phase1key);
+				u16 *phase1key);
 int il4965_mac_ampdu_action(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 			    enum ieee80211_ampdu_mlme_action action,
 			    struct ieee80211_sta *sta, u16 tid, u16 * ssn,
@@ -949,31 +949,31 @@ void il4965_calib_free_results(struct il_priv *il);
 
 /* Debug */
 #ifdef CONFIG_IWLEGACY_DEBUGFS
-ssize_t il4965_ucode_rx_stats_read(struct file *file, char __user * user_buf,
-				   size_t count, loff_t * ppos);
-ssize_t il4965_ucode_tx_stats_read(struct file *file, char __user * user_buf,
-				   size_t count, loff_t * ppos);
+ssize_t il4965_ucode_rx_stats_read(struct file *file, char __user *user_buf,
+				   size_t count, loff_t *ppos);
+ssize_t il4965_ucode_tx_stats_read(struct file *file, char __user *user_buf,
+				   size_t count, loff_t *ppos);
 ssize_t il4965_ucode_general_stats_read(struct file *file,
-					char __user * user_buf, size_t count,
-					loff_t * ppos);
+					char __user *user_buf, size_t count,
+					loff_t *ppos);
 #else
 static ssize_t
-il4965_ucode_rx_stats_read(struct file *file, char __user * user_buf,
-			   size_t count, loff_t * ppos)
+il4965_ucode_rx_stats_read(struct file *file, char __user *user_buf,
+			   size_t count, loff_t *ppos)
 {
 	return 0;
 }
 
 static ssize_t
-il4965_ucode_tx_stats_read(struct file *file, char __user * user_buf,
-			   size_t count, loff_t * ppos)
+il4965_ucode_tx_stats_read(struct file *file, char __user *user_buf,
+			   size_t count, loff_t *ppos)
 {
 	return 0;
 }
 
 static ssize_t
-il4965_ucode_general_stats_read(struct file *file, char __user * user_buf,
-				size_t count, loff_t * ppos)
+il4965_ucode_general_stats_read(struct file *file, char __user *user_buf,
+				size_t count, loff_t *ppos)
 {
 	return 0;
 }
diff --git a/drivers/net/wireless/iwlegacy/common.c b/drivers/net/wireless/iwlegacy/common.c
index 2e1bbb2..7e2924f 100644
--- a/drivers/net/wireless/iwlegacy/common.c
+++ b/drivers/net/wireless/iwlegacy/common.c
@@ -92,7 +92,6 @@ il_get_cmd_string(u8 cmd)
 
 	}
 }
-
 EXPORT_SYMBOL(il_get_cmd_string);
 
 #define HOST_COMPLETE_TIMEOUT (HZ / 2)
@@ -231,7 +230,6 @@ fail:
 out:
 	return ret;
 }
-
 EXPORT_SYMBOL(il_send_cmd_sync);
 
 int
@@ -242,7 +240,6 @@ il_send_cmd(struct il_priv *il, struct il_host_cmd *cmd)
 
 	return il_send_cmd_sync(il, cmd);
 }
-
 EXPORT_SYMBOL(il_send_cmd);
 
 int
@@ -256,14 +253,13 @@ il_send_cmd_pdu(struct il_priv *il, u8 id, u16 len, const void *data)
 
 	return il_send_cmd_sync(il, &cmd);
 }
-
 EXPORT_SYMBOL(il_send_cmd_pdu);
 
 int
 il_send_cmd_pdu_async(struct il_priv *il, u8 id, u16 len, const void *data,
-		      void (*callback) (struct il_priv * il,
-					struct il_device_cmd * cmd,
-					struct il_rx_pkt * pkt))
+		      void (*callback) (struct il_priv *il,
+					struct il_device_cmd *cmd,
+					struct il_rx_pkt *pkt))
 {
 	struct il_host_cmd cmd = {
 		.id = id,
@@ -276,7 +272,6 @@ il_send_cmd_pdu_async(struct il_priv *il, u8 id, u16 len, const void *data,
 
 	return il_send_cmd_async(il, &cmd);
 }
-
 EXPORT_SYMBOL(il_send_cmd_pdu_async);
 
 /* default: IL_LED_BLINK(0) using blinking idx table */
@@ -299,16 +294,16 @@ MODULE_PARM_DESC(led_mode,
  *	<=0					SOLID ON
  */
 static const struct ieee80211_tpt_blink il_blink[] = {
-	{.throughput = 0,.blink_time = 334},
-	{.throughput = 1 * 1024 - 1,.blink_time = 260},
-	{.throughput = 5 * 1024 - 1,.blink_time = 220},
-	{.throughput = 10 * 1024 - 1,.blink_time = 190},
-	{.throughput = 20 * 1024 - 1,.blink_time = 170},
-	{.throughput = 50 * 1024 - 1,.blink_time = 150},
-	{.throughput = 70 * 1024 - 1,.blink_time = 130},
-	{.throughput = 100 * 1024 - 1,.blink_time = 110},
-	{.throughput = 200 * 1024 - 1,.blink_time = 80},
-	{.throughput = 300 * 1024 - 1,.blink_time = 50},
+	{.throughput = 0,		.blink_time = 334},
+	{.throughput = 1 * 1024 - 1,	.blink_time = 260},
+	{.throughput = 5 * 1024 - 1,	.blink_time = 220},
+	{.throughput = 10 * 1024 - 1,	.blink_time = 190},
+	{.throughput = 20 * 1024 - 1,	.blink_time = 170},
+	{.throughput = 50 * 1024 - 1,	.blink_time = 150},
+	{.throughput = 70 * 1024 - 1,	.blink_time = 130},
+	{.throughput = 100 * 1024 - 1,	.blink_time = 110},
+	{.throughput = 200 * 1024 - 1,	.blink_time = 80},
+	{.throughput = 300 * 1024 - 1,	.blink_time = 50},
 };
 
 /*
@@ -433,7 +428,6 @@ il_leds_init(struct il_priv *il)
 
 	il->led_registered = true;
 }
-
 EXPORT_SYMBOL(il_leds_init);
 
 void
@@ -445,7 +439,6 @@ il_leds_exit(struct il_priv *il)
 	led_classdev_unregister(&il->led);
 	kfree(il->led.name);
 }
-
 EXPORT_SYMBOL(il_leds_exit);
 
 /************************** EEPROM BANDS ****************************
@@ -540,17 +533,15 @@ il_eeprom_query_addr(const struct il_priv *il, size_t offset)
 	BUG_ON(offset >= il->cfg->base_params->eeprom_size);
 	return &il->eeprom[offset];
 }
-
 EXPORT_SYMBOL(il_eeprom_query_addr);
 
 u16
-il_eeprom_query16(const struct il_priv * il, size_t offset)
+il_eeprom_query16(const struct il_priv *il, size_t offset)
 {
 	if (!il->eeprom)
 		return 0;
 	return (u16) il->eeprom[offset] | ((u16) il->eeprom[offset + 1] << 8);
 }
-
 EXPORT_SYMBOL(il_eeprom_query16);
 
 /**
@@ -631,7 +622,6 @@ err:
 alloc_err:
 	return ret;
 }
-
 EXPORT_SYMBOL(il_eeprom_init);
 
 void
@@ -640,14 +630,13 @@ il_eeprom_free(struct il_priv *il)
 	kfree(il->eeprom);
 	il->eeprom = NULL;
 }
-
 EXPORT_SYMBOL(il_eeprom_free);
 
 static void
 il_init_band_reference(const struct il_priv *il, int eep_band,
 		       int *eeprom_ch_count,
 		       const struct il_eeprom_channel **eeprom_ch_info,
-		       const u8 ** eeprom_ch_idx)
+		       const u8 **eeprom_ch_idx)
 {
 	u32 offset =
 	    il->cfg->ops->lib->eeprom_ops.regulatory_bands[eep_band - 1];
@@ -885,7 +874,6 @@ il_init_channel_map(struct il_priv *il)
 
 	return 0;
 }
-
 EXPORT_SYMBOL(il_init_channel_map);
 
 /*
@@ -897,7 +885,6 @@ il_free_channel_map(struct il_priv *il)
 	kfree(il->channel_info);
 	il->channel_count = 0;
 }
-
 EXPORT_SYMBOL(il_free_channel_map);
 
 /**
@@ -928,7 +915,6 @@ il_get_channel_info(const struct il_priv *il, enum ieee80211_band band,
 
 	return NULL;
 }
-
 EXPORT_SYMBOL(il_get_channel_info);
 
 /*
@@ -1033,7 +1019,6 @@ il_power_update_mode(struct il_priv *il, bool force)
 	il_power_sleep_cam_cmd(il, &cmd);
 	return il_power_set_mode(il, &cmd, force);
 }
-
 EXPORT_SYMBOL(il_power_update_mode);
 
 /* initialize to default */
@@ -1172,7 +1157,6 @@ il_scan_cancel(struct il_priv *il)
 	queue_work(il->workqueue, &il->abort_scan);
 	return 0;
 }
-
 EXPORT_SYMBOL(il_scan_cancel);
 
 /**
@@ -1199,7 +1183,6 @@ il_scan_cancel_timeout(struct il_priv *il, unsigned long ms)
 
 	return test_bit(S_SCAN_HW, &il->status);
 }
-
 EXPORT_SYMBOL(il_scan_cancel_timeout);
 
 /* Service response to C_SCAN (0x80) */
@@ -1279,7 +1262,6 @@ il_setup_rx_scan_handlers(struct il_priv *il)
 	il->handlers[N_SCAN_RESULTS] = il_hdl_scan_results;
 	il->handlers[N_SCAN_COMPLETE] = il_hdl_scan_complete;
 }
-
 EXPORT_SYMBOL(il_setup_rx_scan_handlers);
 
 inline u16
@@ -1293,12 +1275,11 @@ il_get_active_dwell_time(struct il_priv *il, enum ieee80211_band band,
 		return IL_ACTIVE_DWELL_TIME_24 +
 		    IL_ACTIVE_DWELL_FACTOR_24GHZ * (n_probes + 1);
 }
-
 EXPORT_SYMBOL(il_get_active_dwell_time);
 
 u16
-il_get_passive_dwell_time(struct il_priv * il, enum ieee80211_band band,
-			  struct ieee80211_vif * vif)
+il_get_passive_dwell_time(struct il_priv *il, enum ieee80211_band band,
+			  struct ieee80211_vif *vif)
 {
 	struct il_rxon_context *ctx = &il->ctx;
 	u16 value;
@@ -1324,7 +1305,6 @@ il_get_passive_dwell_time(struct il_priv * il, enum ieee80211_band band,
 
 	return passive;
 }
-
 EXPORT_SYMBOL(il_get_passive_dwell_time);
 
 void
@@ -1336,7 +1316,6 @@ il_init_scan_params(struct il_priv *il)
 	if (!il->scan_tx_ant[IEEE80211_BAND_2GHZ])
 		il->scan_tx_ant[IEEE80211_BAND_2GHZ] = ant_idx;
 }
-
 EXPORT_SYMBOL(il_init_scan_params);
 
 static int
@@ -1417,7 +1396,6 @@ out_unlock:
 
 	return ret;
 }
-
 EXPORT_SYMBOL(il_mac_hw_scan);
 
 static void
@@ -1442,7 +1420,7 @@ il_bg_scan_check(struct work_struct *data)
 
 u16
 il_fill_probe_req(struct il_priv *il, struct ieee80211_mgmt *frame,
-		  const u8 * ta, const u8 * ies, int ie_len, int left)
+		  const u8 *ta, const u8 *ies, int ie_len, int left)
 {
 	int len = 0;
 	u8 *pos = NULL;
@@ -1483,7 +1461,6 @@ il_fill_probe_req(struct il_priv *il, struct ieee80211_mgmt *frame,
 
 	return (u16) len;
 }
-
 EXPORT_SYMBOL(il_fill_probe_req);
 
 static void
@@ -1548,7 +1525,6 @@ il_setup_scan_deferred_work(struct il_priv *il)
 	INIT_WORK(&il->abort_scan, il_bg_abort_scan);
 	INIT_DELAYED_WORK(&il->scan_check, il_bg_scan_check);
 }
-
 EXPORT_SYMBOL(il_setup_scan_deferred_work);
 
 void
@@ -1563,7 +1539,6 @@ il_cancel_scan_deferred_work(struct il_priv *il)
 		mutex_unlock(&il->mutex);
 	}
 }
-
 EXPORT_SYMBOL(il_cancel_scan_deferred_work);
 
 /* il->sta_lock must be held */
@@ -1693,7 +1668,6 @@ il_send_add_sta(struct il_priv *il, struct il_addsta_cmd *sta, u8 flags)
 
 	return ret;
 }
-
 EXPORT_SYMBOL(il_send_add_sta);
 
 static void
@@ -1709,10 +1683,9 @@ il_set_ht_add_station(struct il_priv *il, u8 idx, struct ieee80211_sta *sta,
 
 	mimo_ps_mode = (sta_ht_inf->cap & IEEE80211_HT_CAP_SM_PS) >> 2;
 	D_ASSOC("spatial multiplexing power save mode: %s\n",
-		(mimo_ps_mode ==
-		 WLAN_HT_CAP_SM_PS_STATIC) ? "static" : (mimo_ps_mode ==
-							 WLAN_HT_CAP_SM_PS_DYNAMIC)
-		? "dynamic" : "disabled");
+		(mimo_ps_mode == WLAN_HT_CAP_SM_PS_STATIC) ? "static" :
+		(mimo_ps_mode == WLAN_HT_CAP_SM_PS_DYNAMIC) ? "dynamic" :
+		"disabled");
 
 	sta_flags = il->stations[idx].sta.station_flags;
 
@@ -1756,8 +1729,8 @@ done:
  * should be called with sta_lock held
  */
 u8
-il_prep_station(struct il_priv * il, struct il_rxon_context * ctx,
-		const u8 * addr, bool is_ap, struct ieee80211_sta * sta)
+il_prep_station(struct il_priv *il, struct il_rxon_context *ctx,
+		const u8 *addr, bool is_ap, struct ieee80211_sta *sta)
 {
 	struct il_station_entry *station;
 	int i;
@@ -1841,7 +1814,6 @@ il_prep_station(struct il_priv * il, struct il_rxon_context * ctx,
 	return sta_id;
 
 }
-
 EXPORT_SYMBOL_GPL(il_prep_station);
 
 #define STA_WAIT_TIMEOUT (HZ/2)
@@ -1851,8 +1823,8 @@ EXPORT_SYMBOL_GPL(il_prep_station);
  */
 int
 il_add_station_common(struct il_priv *il, struct il_rxon_context *ctx,
-		      const u8 * addr, bool is_ap, struct ieee80211_sta *sta,
-		      u8 * sta_id_r)
+		      const u8 *addr, bool is_ap, struct ieee80211_sta *sta,
+		      u8 *sta_id_r)
 {
 	unsigned long flags_spin;
 	int ret = 0;
@@ -1905,7 +1877,6 @@ il_add_station_common(struct il_priv *il, struct il_rxon_context *ctx,
 	*sta_id_r = sta_id;
 	return ret;
 }
-
 EXPORT_SYMBOL(il_add_station_common);
 
 /**
@@ -2038,7 +2009,6 @@ out_err:
 	spin_unlock_irqrestore(&il->sta_lock, flags);
 	return -EINVAL;
 }
-
 EXPORT_SYMBOL_GPL(il_remove_station);
 
 /**
@@ -2074,7 +2044,6 @@ il_clear_ucode_stations(struct il_priv *il, struct il_rxon_context *ctx)
 	if (!cleared)
 		D_INFO("No active stations found to be cleared\n");
 }
-
 EXPORT_SYMBOL(il_clear_ucode_stations);
 
 /**
@@ -2156,7 +2125,6 @@ il_restore_stations(struct il_priv *il, struct il_rxon_context *ctx)
 	else
 		D_INFO("Restoring all known stations" " .... complete.\n");
 }
-
 EXPORT_SYMBOL(il_restore_stations);
 
 int
@@ -2170,7 +2138,6 @@ il_get_free_ucode_key_idx(struct il_priv *il)
 
 	return WEP_INVALID_OFFSET;
 }
-
 EXPORT_SYMBOL(il_get_free_ucode_key_idx);
 
 void
@@ -2192,7 +2159,6 @@ il_dealloc_bcast_stations(struct il_priv *il)
 	}
 	spin_unlock_irqrestore(&il->sta_lock, flags);
 }
-
 EXPORT_SYMBOL_GPL(il_dealloc_bcast_stations);
 
 #ifdef CONFIG_IWLEGACY_DEBUG
@@ -2299,7 +2265,6 @@ il_send_lq_cmd(struct il_priv *il, struct il_rxon_context *ctx,
 	}
 	return ret;
 }
-
 EXPORT_SYMBOL(il_send_lq_cmd);
 
 int
@@ -2319,7 +2284,6 @@ il_mac_sta_remove(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 	mutex_unlock(&il->mutex);
 	return ret;
 }
-
 EXPORT_SYMBOL(il_mac_sta_remove);
 
 /************************** RX-FUNCTIONS ****************************/
@@ -2404,7 +2368,6 @@ il_rx_queue_space(const struct il_rx_queue *q)
 		s = 0;
 	return s;
 }
-
 EXPORT_SYMBOL(il_rx_queue_space);
 
 /**
@@ -2449,7 +2412,6 @@ il_rx_queue_update_write_ptr(struct il_priv *il, struct il_rx_queue *q)
 exit_unlock:
 	spin_unlock_irqrestore(&q->lock, flags);
 }
-
 EXPORT_SYMBOL(il_rx_queue_update_write_ptr);
 
 int
@@ -2494,7 +2456,6 @@ err_rb:
 err_bd:
 	return -ENOMEM;
 }
-
 EXPORT_SYMBOL(il_rx_queue_alloc);
 
 void
@@ -2511,7 +2472,6 @@ il_hdl_spectrum_measurement(struct il_priv *il, struct il_rx_buf *rxb)
 	memcpy(&il->measure_report, report, sizeof(*report));
 	il->measurement_status |= MEASUREMENT_READY;
 }
-
 EXPORT_SYMBOL(il_hdl_spectrum_measurement);
 
 /*
@@ -2563,7 +2523,6 @@ il_set_decrypted_flag(struct il_priv *il, struct ieee80211_hdr *hdr,
 	}
 	return 0;
 }
-
 EXPORT_SYMBOL(il_set_decrypted_flag);
 
 /**
@@ -2604,7 +2563,6 @@ il_txq_update_write_ptr(struct il_priv *il, struct il_tx_queue *txq)
 		_il_wr(il, HBUS_TARG_WRPTR, txq->q.write_ptr | (txq_id << 8));
 	txq->need_update = 0;
 }
-
 EXPORT_SYMBOL(il_txq_update_write_ptr);
 
 /**
@@ -2624,7 +2582,6 @@ il_tx_queue_unmap(struct il_priv *il, int txq_id)
 		q->read_ptr = il_queue_inc_wrap(q->read_ptr, q->n_bd);
 	}
 }
-
 EXPORT_SYMBOL(il_tx_queue_unmap);
 
 /**
@@ -2666,7 +2623,6 @@ il_tx_queue_free(struct il_priv *il, int txq_id)
 	/* 0-fill queue descriptor structure */
 	memset(txq, 0, sizeof(*txq));
 }
-
 EXPORT_SYMBOL(il_tx_queue_free);
 
 /**
@@ -2705,7 +2661,6 @@ il_cmd_queue_unmap(struct il_priv *il)
 		txq->meta[i].flags = 0;
 	}
 }
-
 EXPORT_SYMBOL(il_cmd_queue_unmap);
 
 /**
@@ -2743,7 +2698,6 @@ il_cmd_queue_free(struct il_priv *il)
 	/* 0-fill queue descriptor structure */
 	memset(txq, 0, sizeof(*txq));
 }
-
 EXPORT_SYMBOL(il_cmd_queue_free);
 
 /*************** DMA-QUEUE-GENERAL-FUNCTIONS  *****
@@ -2785,7 +2739,6 @@ il_queue_space(const struct il_queue *q)
 		s = 0;
 	return s;
 }
-
 EXPORT_SYMBOL(il_queue_space);
 
 
@@ -2940,7 +2893,6 @@ out_free_arrays:
 
 	return -ENOMEM;
 }
-
 EXPORT_SYMBOL(il_tx_queue_init);
 
 void
@@ -2962,7 +2914,6 @@ il_tx_queue_reset(struct il_priv *il, struct il_tx_queue *txq, int slots_num,
 	/* Tell device where to find queue */
 	il->cfg->ops->lib->txq_init(il, txq);
 }
-
 EXPORT_SYMBOL(il_tx_queue_reset);
 
 /*************** HOST COMMAND QUEUE FUNCTIONS   *****/
@@ -3219,7 +3170,6 @@ u32 il_debug_level;
 EXPORT_SYMBOL(il_debug_level);
 
 const u8 il_bcast_addr[ETH_ALEN] = { 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF };
-
 EXPORT_SYMBOL(il_bcast_addr);
 
 /* This function both allocates and initializes hw and il. */
@@ -3244,7 +3194,6 @@ il_alloc_all(struct il_cfg *cfg)
 out:
 	return hw;
 }
-
 EXPORT_SYMBOL(il_alloc_all);
 
 #define MAX_BIT_RATE_40_MHZ 150	/* Mbps */
@@ -3418,7 +3367,6 @@ il_init_geos(struct il_priv *il)
 
 	return 0;
 }
-
 EXPORT_SYMBOL(il_init_geos);
 
 /*
@@ -3431,7 +3379,6 @@ il_free_geos(struct il_priv *il)
 	kfree(il->ieee_rates);
 	clear_bit(S_GEO_CONFIGURED, &il->status);
 }
-
 EXPORT_SYMBOL(il_free_geos);
 
 static bool
@@ -3455,8 +3402,8 @@ il_is_channel_extension(struct il_priv *il, enum ieee80211_band band,
 }
 
 bool
-il_is_ht40_tx_allowed(struct il_priv * il, struct il_rxon_context * ctx,
-		      struct ieee80211_sta_ht_cap * ht_cap)
+il_is_ht40_tx_allowed(struct il_priv *il, struct il_rxon_context *ctx,
+		      struct ieee80211_sta_ht_cap *ht_cap)
 {
 	if (!ctx->ht.enabled || !ctx->ht.is_40mhz)
 		return false;
@@ -3477,7 +3424,6 @@ il_is_ht40_tx_allowed(struct il_priv * il, struct il_rxon_context * ctx,
 				       le16_to_cpu(ctx->staging.channel),
 				       ctx->ht.extension_chan_offset);
 }
-
 EXPORT_SYMBOL(il_is_ht40_tx_allowed);
 
 static u16
@@ -3561,7 +3507,6 @@ il_send_rxon_timing(struct il_priv *il, struct il_rxon_context *ctx)
 	return il_send_cmd_pdu(il, ctx->rxon_timing_cmd, sizeof(ctx->timing),
 			       &ctx->timing);
 }
-
 EXPORT_SYMBOL(il_send_rxon_timing);
 
 void
@@ -3576,7 +3521,6 @@ il_set_rxon_hwcrypto(struct il_priv *il, struct il_rxon_context *ctx,
 		rxon->filter_flags |= RXON_FILTER_DIS_DECRYPT_MSK;
 
 }
-
 EXPORT_SYMBOL(il_set_rxon_hwcrypto);
 
 /* validate RXON structure is valid */
@@ -3650,7 +3594,6 @@ il_check_rxon_cmd(struct il_priv *il, struct il_rxon_context *ctx)
 	}
 	return 0;
 }
-
 EXPORT_SYMBOL(il_check_rxon_cmd);
 
 /**
@@ -3713,11 +3656,10 @@ il_full_rxon_required(struct il_priv *il, struct il_rxon_context *ctx)
 
 	return 0;
 }
-
 EXPORT_SYMBOL(il_full_rxon_required);
 
 u8
-il_get_lowest_plcp(struct il_priv * il, struct il_rxon_context * ctx)
+il_get_lowest_plcp(struct il_priv *il, struct il_rxon_context *ctx)
 {
 	/*
 	 * Assign the lowest rate -- should really get this from
@@ -3728,7 +3670,6 @@ il_get_lowest_plcp(struct il_priv * il, struct il_rxon_context * ctx)
 	else
 		return RATE_6M_PLCP;
 }
-
 EXPORT_SYMBOL(il_get_lowest_plcp);
 
 static void
@@ -3803,7 +3744,6 @@ il_set_rxon_ht(struct il_priv *il, struct il_ht_config *ht_conf)
 {
 	_il_set_rxon_ht(il, ht_conf, &il->ctx);
 }
-
 EXPORT_SYMBOL(il_set_rxon_ht);
 
 /* Return valid, unused, channel for a passive scan to reset the RF */
@@ -3835,7 +3775,6 @@ il_get_single_channel_number(struct il_priv *il, enum ieee80211_band band)
 
 	return channel;
 }
-
 EXPORT_SYMBOL(il_get_single_channel_number);
 
 /**
@@ -3867,7 +3806,6 @@ il_set_rxon_channel(struct il_priv *il, struct ieee80211_channel *ch,
 
 	return 0;
 }
-
 EXPORT_SYMBOL(il_set_rxon_channel);
 
 void
@@ -3891,7 +3829,6 @@ il_set_flags_for_band(struct il_priv *il, struct il_rxon_context *ctx,
 		ctx->staging.flags &= ~RXON_FLG_CCK_MSK;
 	}
 }
-
 EXPORT_SYMBOL(il_set_flags_for_band);
 
 /*
@@ -3962,7 +3899,6 @@ il_connection_init_rx_config(struct il_priv *il, struct il_rxon_context *ctx)
 	ctx->staging.ofdm_ht_single_stream_basic_rates = 0xff;
 	ctx->staging.ofdm_ht_dual_stream_basic_rates = 0xff;
 }
-
 EXPORT_SYMBOL(il_connection_init_rx_config);
 
 void
@@ -3994,7 +3930,6 @@ il_set_rate(struct il_priv *il)
 	il->ctx.staging.ofdm_basic_rates =
 	    (IL_OFDM_BASIC_RATES_MASK >> IL_FIRST_OFDM_RATE) & 0xFF;
 }
-
 EXPORT_SYMBOL(il_set_rate);
 
 void
@@ -4008,7 +3943,6 @@ il_chswitch_done(struct il_priv *il, bool is_success)
 	if (test_and_clear_bit(S_CHANNEL_SWITCH_PENDING, &il->status))
 		ieee80211_chswitch_done(ctx->vif, is_success);
 }
-
 EXPORT_SYMBOL(il_chswitch_done);
 
 void
@@ -4034,7 +3968,6 @@ il_hdl_csa(struct il_priv *il, struct il_rx_buf *rxb)
 		il_chswitch_done(il, false);
 	}
 }
-
 EXPORT_SYMBOL(il_hdl_csa);
 
 #ifdef CONFIG_IWLEGACY_DEBUG
@@ -4055,7 +3988,6 @@ il_print_rx_config_cmd(struct il_priv *il, struct il_rxon_context *ctx)
 	D_RADIO("u8[6] bssid_addr: %pM\n", rxon->bssid_addr);
 	D_RADIO("u16 assoc_id: 0x%x\n", le16_to_cpu(rxon->assoc_id));
 }
-
 EXPORT_SYMBOL(il_print_rx_config_cmd);
 #endif
 /**
@@ -4094,7 +4026,6 @@ il_irq_handle_error(struct il_priv *il)
 			queue_work(il->workqueue, &il->restart);
 	}
 }
-
 EXPORT_SYMBOL(il_irq_handle_error);
 
 static int
@@ -4135,7 +4066,6 @@ il_apm_stop(struct il_priv *il)
 	 */
 	il_clear_bit(il, CSR_GP_CNTRL, CSR_GP_CNTRL_REG_FLAG_INIT_DONE);
 }
-
 EXPORT_SYMBOL(il_apm_stop);
 
 /*
@@ -4249,7 +4179,6 @@ il_apm_init(struct il_priv *il)
 out:
 	return ret;
 }
-
 EXPORT_SYMBOL(il_apm_init);
 
 int
@@ -4307,7 +4236,6 @@ il_set_tx_power(struct il_priv *il, s8 tx_power, bool force)
 	}
 	return ret;
 }
-
 EXPORT_SYMBOL(il_set_tx_power);
 
 void
@@ -4356,7 +4284,7 @@ il_hdl_pm_sleep(struct il_priv *il, struct il_rx_buf *rxb)
 	struct il_rx_pkt *pkt = rxb_addr(rxb);
 	struct il_sleep_notification *sleep = &(pkt->u.sleep_notif);
 	D_RX("sleep mode: %d, src: %d\n",
-		     sleep->pm_sleep_mode, sleep->pm_wakeup_src);
+	     sleep->pm_sleep_mode, sleep->pm_wakeup_src);
 #endif
 }
 EXPORT_SYMBOL(il_hdl_pm_sleep);
@@ -4432,7 +4360,6 @@ il_mac_conf_tx(struct ieee80211_hw *hw, struct ieee80211_vif *vif, u16 queue,
 	D_MAC80211("leave\n");
 	return 0;
 }
-
 EXPORT_SYMBOL(il_mac_conf_tx);
 
 int
@@ -4442,7 +4369,6 @@ il_mac_tx_last_beacon(struct ieee80211_hw *hw)
 
 	return il->ibss_manager == IL_IBSS_MANAGER;
 }
-
 EXPORT_SYMBOL_GPL(il_mac_tx_last_beacon);
 
 static int
@@ -4529,7 +4455,6 @@ out:
 	D_MAC80211("leave\n");
 	return err;
 }
-
 EXPORT_SYMBOL(il_mac_add_interface);
 
 static void
@@ -4573,7 +4498,6 @@ il_mac_remove_interface(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 	D_MAC80211("leave\n");
 
 }
-
 EXPORT_SYMBOL(il_mac_remove_interface);
 
 int
@@ -4589,7 +4513,6 @@ il_alloc_txq_mem(struct il_priv *il)
 	}
 	return 0;
 }
-
 EXPORT_SYMBOL(il_alloc_txq_mem);
 
 void
@@ -4598,7 +4521,6 @@ il_txq_mem(struct il_priv *il)
 	kfree(il->txq);
 	il->txq = NULL;
 }
-
 EXPORT_SYMBOL(il_txq_mem);
 
 #ifdef CONFIG_IWLEGACY_DEBUGFS
@@ -4638,7 +4560,6 @@ il_alloc_traffic_mem(struct il_priv *il)
 	il_reset_traffic_log(il);
 	return 0;
 }
-
 EXPORT_SYMBOL(il_alloc_traffic_mem);
 
 void
@@ -4650,7 +4571,6 @@ il_free_traffic_mem(struct il_priv *il)
 	kfree(il->rx_traffic);
 	il->rx_traffic = NULL;
 }
-
 EXPORT_SYMBOL(il_free_traffic_mem);
 
 void
@@ -4678,7 +4598,6 @@ il_dbg_log_tx_data_frame(struct il_priv *il, u16 length,
 		    (il->tx_traffic_idx + 1) % IL_TRAFFIC_ENTRIES;
 	}
 }
-
 EXPORT_SYMBOL(il_dbg_log_tx_data_frame);
 
 void
@@ -4706,7 +4625,6 @@ il_dbg_log_rx_data_frame(struct il_priv *il, u16 length,
 		    (il->rx_traffic_idx + 1) % IL_TRAFFIC_ENTRIES;
 	}
 }
-
 EXPORT_SYMBOL(il_dbg_log_rx_data_frame);
 
 const char *
@@ -4849,7 +4767,6 @@ il_update_stats(struct il_priv *il, bool is_tx, __le16 fc, u16 len)
 		stats->data_bytes += len;
 	}
 }
-
 EXPORT_SYMBOL(il_update_stats);
 #endif
 
@@ -4958,7 +4875,6 @@ out:
 	mutex_unlock(&il->mutex);
 	return err;
 }
-
 EXPORT_SYMBOL(il_mac_change_interface);
 
 /*
@@ -5034,7 +4950,6 @@ il_bg_watchdog(unsigned long data)
 	mod_timer(&il->watchdog,
 		  jiffies + msecs_to_jiffies(IL_WD_TICK(timeout)));
 }
-
 EXPORT_SYMBOL(il_bg_watchdog);
 
 void
@@ -5048,7 +4963,6 @@ il_setup_watchdog(struct il_priv *il)
 	else
 		del_timer(&il->watchdog);
 }
-
 EXPORT_SYMBOL(il_setup_watchdog);
 
 /*
@@ -5080,14 +4994,13 @@ il_usecs_to_beacons(struct il_priv *il, u32 usec, u32 beacon_interval)
 
 	return (quot << il->hw_params.beacon_time_tsf_bits) + rem;
 }
-
 EXPORT_SYMBOL(il_usecs_to_beacons);
 
 /* base is usually what we get from ucode with each received frame,
  * the same as HW timer counter counting down
  */
 __le32
-il_add_beacon_time(struct il_priv * il, u32 base, u32 addon,
+il_add_beacon_time(struct il_priv *il, u32 base, u32 addon,
 		   u32 beacon_interval)
 {
 	u32 base_low = base & il_beacon_time_mask_low(il,
@@ -5114,7 +5027,6 @@ il_add_beacon_time(struct il_priv * il, u32 base, u32 addon,
 
 	return cpu_to_le32(res);
 }
-
 EXPORT_SYMBOL(il_add_beacon_time);
 
 #ifdef CONFIG_PM
@@ -5136,7 +5048,6 @@ il_pci_suspend(struct device *device)
 
 	return 0;
 }
-
 EXPORT_SYMBOL(il_pci_suspend);
 
 int
@@ -5166,7 +5077,6 @@ il_pci_resume(struct device *device)
 
 	return 0;
 }
-
 EXPORT_SYMBOL(il_pci_resume);
 
 const struct dev_pm_ops il_pm_ops = {
@@ -5177,7 +5087,6 @@ const struct dev_pm_ops il_pm_ops = {
 	.poweroff = il_pci_suspend,
 	.restore = il_pci_resume,
 };
-
 EXPORT_SYMBOL(il_pm_ops);
 
 #endif /* CONFIG_PM */
@@ -5413,7 +5322,6 @@ il_mac_reset_tsf(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 
 	D_MAC80211("leave\n");
 }
-
 EXPORT_SYMBOL(il_mac_reset_tsf);
 
 static void
@@ -5701,7 +5609,6 @@ il_mac_bss_info_changed(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 
 	D_MAC80211("leave\n");
 }
-
 EXPORT_SYMBOL(il_mac_bss_info_changed);
 
 irqreturn_t
@@ -5763,7 +5670,6 @@ none:
 	spin_unlock_irqrestore(&il->lock, flags);
 	return IRQ_NONE;
 }
-
 EXPORT_SYMBOL(il_isr);
 
 /*
@@ -5772,7 +5678,7 @@ EXPORT_SYMBOL(il_isr);
  */
 void
 il_tx_cmd_protection(struct il_priv *il, struct ieee80211_tx_info *info,
-		     __le16 fc, __le32 * tx_flags)
+		     __le16 fc, __le32 *tx_flags)
 {
 	if (info->control.rates[0].flags & IEEE80211_TX_RC_USE_RTS_CTS) {
 		*tx_flags |= TX_CMD_FLG_RTS_MSK;
@@ -5798,5 +5704,4 @@ il_tx_cmd_protection(struct il_priv *il, struct ieee80211_tx_info *info,
 		*tx_flags |= TX_CMD_FLG_FULL_TXOP_PROT_MSK;
 	}
 }
-
 EXPORT_SYMBOL(il_tx_cmd_protection);
diff --git a/drivers/net/wireless/iwlegacy/common.h b/drivers/net/wireless/iwlegacy/common.h
index 38ff3d6..d0975ab 100644
--- a/drivers/net/wireless/iwlegacy/common.h
+++ b/drivers/net/wireless/iwlegacy/common.h
@@ -112,8 +112,8 @@ struct il_cmd_meta {
 	 * invoked for SYNC commands, if it were and its result passed
 	 * through it would be simpler...)
 	 */
-	void (*callback) (struct il_priv * il, struct il_device_cmd * cmd,
-			  struct il_rx_pkt * pkt);
+	void (*callback) (struct il_priv *il, struct il_device_cmd *cmd,
+			  struct il_rx_pkt *pkt);
 
 	/* The CMD_SIZE_HUGE flag bit indicates that the command
 	 * structure is stored at the end of the shared queue memory. */
@@ -432,8 +432,8 @@ struct il_eeprom_calib_info {
 
 struct il_eeprom_ops {
 	const u32 regulatory_bands[7];
-	int (*acquire_semaphore) (struct il_priv * il);
-	void (*release_semaphore) (struct il_priv * il);
+	int (*acquire_semaphore) (struct il_priv *il);
+	void (*release_semaphore) (struct il_priv *il);
 };
 
 int il_eeprom_init(struct il_priv *il);
@@ -592,8 +592,8 @@ struct il_device_cmd {
 struct il_host_cmd {
 	const void *data;
 	unsigned long reply_page;
-	void (*callback) (struct il_priv * il, struct il_device_cmd * cmd,
-			  struct il_rx_pkt * pkt);
+	void (*callback) (struct il_priv *il, struct il_device_cmd *cmd,
+			  struct il_rx_pkt *pkt);
 	u32 flags;
 	u16 len;
 	u8 id;
@@ -1224,8 +1224,8 @@ struct il_priv {
 	enum ieee80211_band band;
 	int alloc_rxb_page;
 
-	void (*handlers[IL_CN_MAX]) (struct il_priv * il,
-				     struct il_rx_buf * rxb);
+	void (*handlers[IL_CN_MAX]) (struct il_priv *il,
+				     struct il_rx_buf *rxb);
 
 	struct ieee80211_supported_band bands[IEEE80211_NUM_BANDS];
 
@@ -1613,69 +1613,69 @@ il_free_pages(struct il_priv *il, unsigned long page)
 #define IL_RX_BUF_SIZE_8K (8 * 1024)
 
 struct il_hcmd_ops {
-	int (*rxon_assoc) (struct il_priv * il, struct il_rxon_context * ctx);
-	int (*commit_rxon) (struct il_priv * il, struct il_rxon_context * ctx);
-	void (*set_rxon_chain) (struct il_priv * il,
-				struct il_rxon_context * ctx);
+	int (*rxon_assoc) (struct il_priv *il, struct il_rxon_context *ctx);
+	int (*commit_rxon) (struct il_priv *il, struct il_rxon_context *ctx);
+	void (*set_rxon_chain) (struct il_priv *il,
+				struct il_rxon_context *ctx);
 };
 
 struct il_hcmd_utils_ops {
 	u16(*get_hcmd_size) (u8 cmd_id, u16 len);
-	u16(*build_addsta_hcmd) (const struct il_addsta_cmd * cmd, u8 * data);
-	int (*request_scan) (struct il_priv * il, struct ieee80211_vif * vif);
-	void (*post_scan) (struct il_priv * il);
+	u16(*build_addsta_hcmd) (const struct il_addsta_cmd *cmd, u8 *data);
+	int (*request_scan) (struct il_priv *il, struct ieee80211_vif *vif);
+	void (*post_scan) (struct il_priv *il);
 };
 
 struct il_apm_ops {
-	int (*init) (struct il_priv * il);
-	void (*config) (struct il_priv * il);
+	int (*init) (struct il_priv *il);
+	void (*config) (struct il_priv *il);
 };
 
 struct il_debugfs_ops {
-	ssize_t(*rx_stats_read) (struct file * file, char __user * user_buf,
-				 size_t count, loff_t * ppos);
-	ssize_t(*tx_stats_read) (struct file * file, char __user * user_buf,
-				 size_t count, loff_t * ppos);
-	ssize_t(*general_stats_read) (struct file * file,
-				      char __user * user_buf, size_t count,
-				      loff_t * ppos);
+	ssize_t(*rx_stats_read) (struct file *file, char __user *user_buf,
+				 size_t count, loff_t *ppos);
+	ssize_t(*tx_stats_read) (struct file *file, char __user *user_buf,
+				 size_t count, loff_t *ppos);
+	ssize_t(*general_stats_read) (struct file *file,
+				      char __user *user_buf, size_t count,
+				      loff_t *ppos);
 };
 
 struct il_temp_ops {
-	void (*temperature) (struct il_priv * il);
+	void (*temperature) (struct il_priv *il);
 };
 
 struct il_lib_ops {
 	/* set hw dependent parameters */
-	int (*set_hw_params) (struct il_priv * il);
+	int (*set_hw_params) (struct il_priv *il);
 	/* Handling TX */
-	void (*txq_update_byte_cnt_tbl) (struct il_priv * il,
-					 struct il_tx_queue * txq,
+	void (*txq_update_byte_cnt_tbl) (struct il_priv *il,
+					 struct il_tx_queue *txq,
 					 u16 byte_cnt);
-	int (*txq_attach_buf_to_tfd) (struct il_priv * il,
-				      struct il_tx_queue * txq, dma_addr_t addr,
+	int (*txq_attach_buf_to_tfd) (struct il_priv *il,
+				      struct il_tx_queue *txq, dma_addr_t addr,
 				      u16 len, u8 reset, u8 pad);
-	void (*txq_free_tfd) (struct il_priv * il, struct il_tx_queue * txq);
-	int (*txq_init) (struct il_priv * il, struct il_tx_queue * txq);
+	void (*txq_free_tfd) (struct il_priv *il, struct il_tx_queue *txq);
+	int (*txq_init) (struct il_priv *il, struct il_tx_queue *txq);
 	/* setup Rx handler */
-	void (*handler_setup) (struct il_priv * il);
+	void (*handler_setup) (struct il_priv *il);
 	/* alive notification after init uCode load */
-	void (*init_alive_start) (struct il_priv * il);
+	void (*init_alive_start) (struct il_priv *il);
 	/* check validity of rtc data address */
 	int (*is_valid_rtc_data_addr) (u32 addr);
 	/* 1st ucode load */
-	int (*load_ucode) (struct il_priv * il);
+	int (*load_ucode) (struct il_priv *il);
 
-	void (*dump_nic_error_log) (struct il_priv * il);
-	int (*dump_fh) (struct il_priv * il, char **buf, bool display);
-	int (*set_channel_switch) (struct il_priv * il,
-				   struct ieee80211_channel_switch * ch_switch);
+	void (*dump_nic_error_log) (struct il_priv *il);
+	int (*dump_fh) (struct il_priv *il, char **buf, bool display);
+	int (*set_channel_switch) (struct il_priv *il,
+				   struct ieee80211_channel_switch *ch_switch);
 	/* power management */
 	struct il_apm_ops apm_ops;
 
 	/* power */
-	int (*send_tx_power) (struct il_priv * il);
-	void (*update_chain_flags) (struct il_priv * il);
+	int (*send_tx_power) (struct il_priv *il);
+	void (*update_chain_flags) (struct il_priv *il);
 
 	/* eeprom operations */
 	struct il_eeprom_ops eeprom_ops;
@@ -1688,16 +1688,16 @@ struct il_lib_ops {
 };
 
 struct il_led_ops {
-	int (*cmd) (struct il_priv * il, struct il_led_cmd * led_cmd);
+	int (*cmd) (struct il_priv *il, struct il_led_cmd *led_cmd);
 };
 
 struct il_legacy_ops {
-	void (*post_associate) (struct il_priv * il);
-	void (*config_ap) (struct il_priv * il);
+	void (*post_associate) (struct il_priv *il);
+	void (*config_ap) (struct il_priv *il);
 	/* station management */
-	int (*update_bcast_stations) (struct il_priv * il);
-	int (*manage_ibss_station) (struct il_priv * il,
-				    struct ieee80211_vif * vif, bool add);
+	int (*update_bcast_stations) (struct il_priv *il);
+	int (*manage_ibss_station) (struct il_priv *il,
+				    struct ieee80211_vif *vif, bool add);
 };
 
 struct il_ops {
@@ -1965,7 +1965,7 @@ int il_mac_hw_scan(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 void il_internal_short_hw_scan(struct il_priv *il);
 int il_force_reset(struct il_priv *il, bool external);
 u16 il_fill_probe_req(struct il_priv *il, struct ieee80211_mgmt *frame,
-		      const u8 * ta, const u8 * ie, int ie_len, int left);
+		      const u8 *ta, const u8 *ie, int ie_len, int left);
 void il_setup_rx_scan_handlers(struct il_priv *il);
 u16 il_get_active_dwell_time(struct il_priv *il, enum ieee80211_band band,
 			     u8 n_probes);
@@ -1995,9 +1995,9 @@ int il_send_cmd(struct il_priv *il, struct il_host_cmd *cmd);
 int __must_check il_send_cmd_pdu(struct il_priv *il, u8 id, u16 len,
 				 const void *data);
 int il_send_cmd_pdu_async(struct il_priv *il, u8 id, u16 len, const void *data,
-			  void (*callback) (struct il_priv * il,
-					    struct il_device_cmd * cmd,
-					    struct il_rx_pkt * pkt));
+			  void (*callback) (struct il_priv *il,
+					    struct il_device_cmd *cmd,
+					    struct il_rx_pkt *pkt));
 
 int il_enqueue_hcmd(struct il_priv *il, struct il_host_cmd *cmd);
 
@@ -2155,7 +2155,7 @@ void il_mac_reset_tsf(struct ieee80211_hw *hw, struct ieee80211_vif *vif);
 void il_mac_bss_info_changed(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 			     struct ieee80211_bss_conf *bss_conf, u32 changes);
 void il_tx_cmd_protection(struct il_priv *il, struct ieee80211_tx_info *info,
-			  __le16 fc, __le32 * tx_flags);
+			  __le16 fc, __le32 *tx_flags);
 
 irqreturn_t il_isr(int irq, void *data);
 
@@ -2191,8 +2191,7 @@ _il_poll_bit(struct il_priv *il, u32 addr, u32 bits, u32 mask, int timeout)
 			return t;
 		udelay(IL_POLL_INTERVAL);
 		t += IL_POLL_INTERVAL;
-	}
-	while (t < timeout);
+	} while (t < timeout);
 
 	return -ETIMEDOUT;
 }
@@ -2324,8 +2323,7 @@ il_poll_bit(struct il_priv *il, u32 addr, u32 mask, int timeout)
 			return t;
 		udelay(IL_POLL_INTERVAL);
 		t += IL_POLL_INTERVAL;
-	}
-	while (t < timeout);
+	} while (t < timeout);
 
 	return -ETIMEDOUT;
 }
@@ -2485,14 +2483,14 @@ void il_dealloc_bcast_stations(struct il_priv *il);
 int il_get_free_ucode_key_idx(struct il_priv *il);
 int il_send_add_sta(struct il_priv *il, struct il_addsta_cmd *sta, u8 flags);
 int il_add_station_common(struct il_priv *il, struct il_rxon_context *ctx,
-			  const u8 * addr, bool is_ap,
-			  struct ieee80211_sta *sta, u8 * sta_id_r);
+			  const u8 *addr, bool is_ap,
+			  struct ieee80211_sta *sta, u8 *sta_id_r);
 int il_remove_station(struct il_priv *il, const u8 sta_id, const u8 * addr);
 int il_mac_sta_remove(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 		      struct ieee80211_sta *sta);
 
 u8 il_prep_station(struct il_priv *il, struct il_rxon_context *ctx,
-		   const u8 * addr, bool is_ap, struct ieee80211_sta *sta);
+		   const u8 *addr, bool is_ap, struct ieee80211_sta *sta);
 
 int il_send_lq_cmd(struct il_priv *il, struct il_rxon_context *ctx,
 		   struct il_link_quality_cmd *lq, u8 flags, bool init);
@@ -2758,10 +2756,10 @@ il_get_dma_hi_addr(dma_addr_t addr)
  *
  * This structure contains dma address and length of transmission address
  *
- * @lo: low [31:0] portion of the dma address of TX buffer
- * 	every even is unaligned on 16 bit boundary
- * @hi_n_len 0-3 [35:32] portion of dma
- *	     4-15 length of the tx buffer
+ * @lo: low [31:0] portion of the dma address of TX buffer every even is
+ *	unaligned on 16 bit boundary
+ * @hi_n_len: 0-3 [35:32] portion of dma
+ *	      4-15 length of the tx buffer
  */
 struct il_tfd_tb {
 	__le32 lo;
@@ -2778,7 +2776,7 @@ struct il_tfd_tb {
  *	     5   reserved
  * 	     6-7 padding (not used)
  * @ tbs[20]	transmit frame buffer descriptors
- * @ __pad 	padding
+ * @ __pad	padding
  *
  * Each Tx queue uses a circular buffer of 256 TFDs stored in host DRAM.
  * Both driver and device share these circular buffers, each of which must be
@@ -3295,7 +3293,7 @@ do {									\
 			__func__ , ## args);				\
 } while (0)
 
-#define il_print_hex_dump(il, level, p, len) 			\
+#define il_print_hex_dump(il, level, p, len)				\
 do {									\
 	if (il_get_debug_level(il) & level)				\
 		print_hex_dump(KERN_DEBUG, "iwl data: ",		\
@@ -3342,9 +3340,9 @@ il_dbgfs_unregister(struct il_priv *il)
  *
  * The active debug levels can be accessed via files
  *
- * 	/sys/module/iwl4965/parameters/debug
+ *	/sys/module/iwl4965/parameters/debug
  *	/sys/module/iwl3945/parameters/debug
- * 	/sys/class/net/wlan0/device/debug_level
+ *	/sys/class/net/wlan0/device/debug_level
  *
  * when CONFIG_IWLEGACY_DEBUG=y.
  */
diff --git a/drivers/net/wireless/iwlegacy/debug.c b/drivers/net/wireless/iwlegacy/debug.c
index e79794a..928bdbb 100644
--- a/drivers/net/wireless/iwlegacy/debug.c
+++ b/drivers/net/wireless/iwlegacy/debug.c
@@ -71,35 +71,35 @@ il_dbgfs_open_file_generic(struct inode *inode, struct file *file)
 	return 0;
 }
 
-#define DEBUGFS_READ_FILE_OPS(name) 				\
-	DEBUGFS_READ_FUNC(name);                                        \
+#define DEBUGFS_READ_FILE_OPS(name)				\
+	DEBUGFS_READ_FUNC(name);				\
 static const struct file_operations il_dbgfs_##name##_ops = {	\
 	.read = il_dbgfs_##name##_read,				\
-	.open = il_dbgfs_open_file_generic,                    	\
-	.llseek = generic_file_llseek,					\
+	.open = il_dbgfs_open_file_generic,			\
+	.llseek = generic_file_llseek,				\
 };
 
-#define DEBUGFS_WRITE_FILE_OPS(name) 				\
-	DEBUGFS_WRITE_FUNC(name);                                       \
+#define DEBUGFS_WRITE_FILE_OPS(name)				\
+	DEBUGFS_WRITE_FUNC(name);				\
 static const struct file_operations il_dbgfs_##name##_ops = {	\
 	.write = il_dbgfs_##name##_write,			\
-	.open = il_dbgfs_open_file_generic,                    	\
-	.llseek = generic_file_llseek,					\
+	.open = il_dbgfs_open_file_generic,			\
+	.llseek = generic_file_llseek,				\
 };
 
-#define DEBUGFS_READ_WRITE_FILE_OPS(name)                           \
-	DEBUGFS_READ_FUNC(name);                                        \
-	DEBUGFS_WRITE_FUNC(name);                                       \
+#define DEBUGFS_READ_WRITE_FILE_OPS(name)			\
+	DEBUGFS_READ_FUNC(name);				\
+	DEBUGFS_WRITE_FUNC(name);				\
 static const struct file_operations il_dbgfs_##name##_ops = {	\
 	.write = il_dbgfs_##name##_write,			\
 	.read = il_dbgfs_##name##_read,				\
 	.open = il_dbgfs_open_file_generic,			\
-	.llseek = generic_file_llseek,					\
+	.llseek = generic_file_llseek,				\
 };
 
 static ssize_t
-il_dbgfs_tx_stats_read(struct file *file, char __user * user_buf, size_t count,
-		       loff_t * ppos)
+il_dbgfs_tx_stats_read(struct file *file, char __user *user_buf, size_t count,
+		       loff_t *ppos)
 {
 
 	struct il_priv *il = file->private_data;
@@ -139,8 +139,8 @@ il_dbgfs_tx_stats_read(struct file *file, char __user * user_buf, size_t count,
 
 static ssize_t
 il_dbgfs_clear_traffic_stats_write(struct file *file,
-				   const char __user * user_buf, size_t count,
-				   loff_t * ppos)
+				   const char __user *user_buf, size_t count,
+				   loff_t *ppos)
 {
 	struct il_priv *il = file->private_data;
 	u32 clear_flag;
@@ -159,8 +159,8 @@ il_dbgfs_clear_traffic_stats_write(struct file *file,
 }
 
 static ssize_t
-il_dbgfs_rx_stats_read(struct file *file, char __user * user_buf, size_t count,
-		       loff_t * ppos)
+il_dbgfs_rx_stats_read(struct file *file, char __user *user_buf, size_t count,
+		       loff_t *ppos)
 {
 
 	struct il_priv *il = file->private_data;
@@ -203,8 +203,8 @@ il_dbgfs_rx_stats_read(struct file *file, char __user * user_buf, size_t count,
 #define BYTE2_MASK 0x0000ffff;
 #define BYTE3_MASK 0x00ffffff;
 static ssize_t
-il_dbgfs_sram_read(struct file *file, char __user * user_buf, size_t count,
-		   loff_t * ppos)
+il_dbgfs_sram_read(struct file *file, char __user *user_buf, size_t count,
+		   loff_t *ppos)
 {
 	u32 val;
 	char *buf;
@@ -262,8 +262,8 @@ il_dbgfs_sram_read(struct file *file, char __user * user_buf, size_t count,
 }
 
 static ssize_t
-il_dbgfs_sram_write(struct file *file, const char __user * user_buf,
-		    size_t count, loff_t * ppos)
+il_dbgfs_sram_write(struct file *file, const char __user *user_buf,
+		    size_t count, loff_t *ppos)
 {
 	struct il_priv *il = file->private_data;
 	char buf[64];
@@ -287,8 +287,8 @@ il_dbgfs_sram_write(struct file *file, const char __user * user_buf,
 }
 
 static ssize_t
-il_dbgfs_stations_read(struct file *file, char __user * user_buf, size_t count,
-		       loff_t * ppos)
+il_dbgfs_stations_read(struct file *file, char __user *user_buf, size_t count,
+		       loff_t *ppos)
 {
 	struct il_priv *il = file->private_data;
 	struct il_station_entry *station;
@@ -351,8 +351,8 @@ il_dbgfs_stations_read(struct file *file, char __user * user_buf, size_t count,
 }
 
 static ssize_t
-il_dbgfs_nvm_read(struct file *file, char __user * user_buf, size_t count,
-		  loff_t * ppos)
+il_dbgfs_nvm_read(struct file *file, char __user *user_buf, size_t count,
+		  loff_t *ppos)
 {
 	ssize_t ret;
 	struct il_priv *il = file->private_data;
@@ -399,8 +399,8 @@ il_dbgfs_nvm_read(struct file *file, char __user * user_buf, size_t count,
 }
 
 static ssize_t
-il_dbgfs_channels_read(struct file *file, char __user * user_buf, size_t count,
-		       loff_t * ppos)
+il_dbgfs_channels_read(struct file *file, char __user *user_buf, size_t count,
+		       loff_t *ppos)
 {
 	struct il_priv *il = file->private_data;
 	struct ieee80211_channel *channels = NULL;
@@ -478,8 +478,8 @@ il_dbgfs_channels_read(struct file *file, char __user * user_buf, size_t count,
 }
 
 static ssize_t
-il_dbgfs_status_read(struct file *file, char __user * user_buf, size_t count,
-		     loff_t * ppos)
+il_dbgfs_status_read(struct file *file, char __user *user_buf, size_t count,
+		     loff_t *ppos)
 {
 
 	struct il_priv *il = file->private_data;
@@ -539,8 +539,8 @@ il_dbgfs_status_read(struct file *file, char __user * user_buf, size_t count,
 }
 
 static ssize_t
-il_dbgfs_interrupt_read(struct file *file, char __user * user_buf, size_t count,
-			loff_t * ppos)
+il_dbgfs_interrupt_read(struct file *file, char __user *user_buf, size_t count,
+			loff_t *ppos)
 {
 
 	struct il_priv *il = file->private_data;
@@ -618,8 +618,8 @@ il_dbgfs_interrupt_read(struct file *file, char __user * user_buf, size_t count,
 }
 
 static ssize_t
-il_dbgfs_interrupt_write(struct file *file, const char __user * user_buf,
-			 size_t count, loff_t * ppos)
+il_dbgfs_interrupt_write(struct file *file, const char __user *user_buf,
+			 size_t count, loff_t *ppos)
 {
 	struct il_priv *il = file->private_data;
 	char buf[8];
@@ -639,8 +639,8 @@ il_dbgfs_interrupt_write(struct file *file, const char __user * user_buf,
 }
 
 static ssize_t
-il_dbgfs_qos_read(struct file *file, char __user * user_buf, size_t count,
-		  loff_t * ppos)
+il_dbgfs_qos_read(struct file *file, char __user *user_buf, size_t count,
+		  loff_t *ppos)
 {
 	struct il_priv *il = file->private_data;
 	struct il_rxon_context *ctx = &il->ctx;
@@ -666,8 +666,8 @@ il_dbgfs_qos_read(struct file *file, char __user * user_buf, size_t count,
 }
 
 static ssize_t
-il_dbgfs_disable_ht40_write(struct file *file, const char __user * user_buf,
-			    size_t count, loff_t * ppos)
+il_dbgfs_disable_ht40_write(struct file *file, const char __user *user_buf,
+			    size_t count, loff_t *ppos)
 {
 	struct il_priv *il = file->private_data;
 	char buf[8];
@@ -692,8 +692,8 @@ il_dbgfs_disable_ht40_write(struct file *file, const char __user * user_buf,
 }
 
 static ssize_t
-il_dbgfs_disable_ht40_read(struct file *file, char __user * user_buf,
-			   size_t count, loff_t * ppos)
+il_dbgfs_disable_ht40_read(struct file *file, char __user *user_buf,
+			   size_t count, loff_t *ppos)
 {
 	struct il_priv *il = file->private_data;
 	char buf[100];
@@ -716,8 +716,8 @@ DEBUGFS_READ_FILE_OPS(qos);
 DEBUGFS_READ_WRITE_FILE_OPS(disable_ht40);
 
 static ssize_t
-il_dbgfs_traffic_log_read(struct file *file, char __user * user_buf,
-			  size_t count, loff_t * ppos)
+il_dbgfs_traffic_log_read(struct file *file, char __user *user_buf,
+			  size_t count, loff_t *ppos)
 {
 	struct il_priv *il = file->private_data;
 	int pos = 0, ofs = 0;
@@ -801,8 +801,8 @@ il_dbgfs_traffic_log_read(struct file *file, char __user * user_buf,
 }
 
 static ssize_t
-il_dbgfs_traffic_log_write(struct file *file, const char __user * user_buf,
-			   size_t count, loff_t * ppos)
+il_dbgfs_traffic_log_write(struct file *file, const char __user *user_buf,
+			   size_t count, loff_t *ppos)
 {
 	struct il_priv *il = file->private_data;
 	char buf[8];
@@ -822,8 +822,8 @@ il_dbgfs_traffic_log_write(struct file *file, const char __user * user_buf,
 }
 
 static ssize_t
-il_dbgfs_tx_queue_read(struct file *file, char __user * user_buf, size_t count,
-		       loff_t * ppos)
+il_dbgfs_tx_queue_read(struct file *file, char __user *user_buf, size_t count,
+		       loff_t *ppos)
 {
 
 	struct il_priv *il = file->private_data;
@@ -851,9 +851,8 @@ il_dbgfs_tx_queue_read(struct file *file, char __user * user_buf, size_t count,
 		    scnprintf(buf + pos, bufsz - pos,
 			      "hwq %.2d: read=%u write=%u stop=%d"
 			      " swq_id=%#.2x (ac %d/hwq %d)\n", cnt,
-			      q->read_ptr, q->write_ptr, !!test_bit(cnt,
-								    il->
-								    queue_stopped),
+			      q->read_ptr, q->write_ptr,
+			      !!test_bit(cnt, il->queue_stopped),
 			      txq->swq_id, txq->swq_id & 3,
 			      (txq->swq_id >> 2) & 0x1f);
 		if (cnt >= 4)
@@ -870,8 +869,8 @@ il_dbgfs_tx_queue_read(struct file *file, char __user * user_buf, size_t count,
 }
 
 static ssize_t
-il_dbgfs_rx_queue_read(struct file *file, char __user * user_buf, size_t count,
-		       loff_t * ppos)
+il_dbgfs_rx_queue_read(struct file *file, char __user *user_buf, size_t count,
+		       loff_t *ppos)
 {
 
 	struct il_priv *il = file->private_data;
@@ -899,8 +898,8 @@ il_dbgfs_rx_queue_read(struct file *file, char __user * user_buf, size_t count,
 }
 
 static ssize_t
-il_dbgfs_ucode_rx_stats_read(struct file *file, char __user * user_buf,
-			     size_t count, loff_t * ppos)
+il_dbgfs_ucode_rx_stats_read(struct file *file, char __user *user_buf,
+			     size_t count, loff_t *ppos)
 {
 	struct il_priv *il = file->private_data;
 	return il->cfg->ops->lib->debugfs_ops.rx_stats_read(file, user_buf,
@@ -908,8 +907,8 @@ il_dbgfs_ucode_rx_stats_read(struct file *file, char __user * user_buf,
 }
 
 static ssize_t
-il_dbgfs_ucode_tx_stats_read(struct file *file, char __user * user_buf,
-			     size_t count, loff_t * ppos)
+il_dbgfs_ucode_tx_stats_read(struct file *file, char __user *user_buf,
+			     size_t count, loff_t *ppos)
 {
 	struct il_priv *il = file->private_data;
 	return il->cfg->ops->lib->debugfs_ops.tx_stats_read(file, user_buf,
@@ -917,8 +916,8 @@ il_dbgfs_ucode_tx_stats_read(struct file *file, char __user * user_buf,
 }
 
 static ssize_t
-il_dbgfs_ucode_general_stats_read(struct file *file, char __user * user_buf,
-				  size_t count, loff_t * ppos)
+il_dbgfs_ucode_general_stats_read(struct file *file, char __user *user_buf,
+				  size_t count, loff_t *ppos)
 {
 	struct il_priv *il = file->private_data;
 	return il->cfg->ops->lib->debugfs_ops.general_stats_read(file, user_buf,
@@ -926,8 +925,8 @@ il_dbgfs_ucode_general_stats_read(struct file *file, char __user * user_buf,
 }
 
 static ssize_t
-il_dbgfs_sensitivity_read(struct file *file, char __user * user_buf,
-			  size_t count, loff_t * ppos)
+il_dbgfs_sensitivity_read(struct file *file, char __user *user_buf,
+			  size_t count, loff_t *ppos)
 {
 
 	struct il_priv *il = file->private_data;
@@ -1025,8 +1024,8 @@ il_dbgfs_sensitivity_read(struct file *file, char __user * user_buf,
 }
 
 static ssize_t
-il_dbgfs_chain_noise_read(struct file *file, char __user * user_buf,
-			  size_t count, loff_t * ppos)
+il_dbgfs_chain_noise_read(struct file *file, char __user *user_buf,
+			  size_t count, loff_t *ppos)
 {
 
 	struct il_priv *il = file->private_data;
@@ -1096,8 +1095,8 @@ il_dbgfs_chain_noise_read(struct file *file, char __user * user_buf,
 }
 
 static ssize_t
-il_dbgfs_power_save_status_read(struct file *file, char __user * user_buf,
-				size_t count, loff_t * ppos)
+il_dbgfs_power_save_status_read(struct file *file, char __user *user_buf,
+				size_t count, loff_t *ppos)
 {
 	struct il_priv *il = file->private_data;
 	char buf[60];
@@ -1111,19 +1110,18 @@ il_dbgfs_power_save_status_read(struct file *file, char __user * user_buf,
 	pos += scnprintf(buf + pos, bufsz - pos, "Power Save Status: ");
 	pos +=
 	    scnprintf(buf + pos, bufsz - pos, "%s\n",
-		      (pwrsave_status ==
-		       CSR_GP_REG_NO_POWER_SAVE) ? "none" : (pwrsave_status ==
-							     CSR_GP_REG_MAC_POWER_SAVE)
-		      ? "MAC" : (pwrsave_status ==
-				 CSR_GP_REG_PHY_POWER_SAVE) ? "PHY" : "error");
+		      (pwrsave_status == CSR_GP_REG_NO_POWER_SAVE) ? "none" :
+		      (pwrsave_status == CSR_GP_REG_MAC_POWER_SAVE) ? "MAC" :
+		      (pwrsave_status == CSR_GP_REG_PHY_POWER_SAVE) ? "PHY" :
+		      "error");
 
 	return simple_read_from_buffer(user_buf, count, ppos, buf, pos);
 }
 
 static ssize_t
 il_dbgfs_clear_ucode_stats_write(struct file *file,
-				 const char __user * user_buf, size_t count,
-				 loff_t * ppos)
+				 const char __user *user_buf, size_t count,
+				 loff_t *ppos)
 {
 	struct il_priv *il = file->private_data;
 	char buf[8];
@@ -1146,8 +1144,8 @@ il_dbgfs_clear_ucode_stats_write(struct file *file,
 }
 
 static ssize_t
-il_dbgfs_rxon_flags_read(struct file *file, char __user * user_buf,
-			 size_t count, loff_t * ppos)
+il_dbgfs_rxon_flags_read(struct file *file, char __user *user_buf,
+			 size_t count, loff_t *ppos)
 {
 
 	struct il_priv *il = file->private_data;
@@ -1159,8 +1157,8 @@ il_dbgfs_rxon_flags_read(struct file *file, char __user * user_buf,
 }
 
 static ssize_t
-il_dbgfs_rxon_filter_flags_read(struct file *file, char __user * user_buf,
-				size_t count, loff_t * ppos)
+il_dbgfs_rxon_filter_flags_read(struct file *file, char __user *user_buf,
+				size_t count, loff_t *ppos)
 {
 
 	struct il_priv *il = file->private_data;
@@ -1173,8 +1171,8 @@ il_dbgfs_rxon_filter_flags_read(struct file *file, char __user * user_buf,
 }
 
 static ssize_t
-il_dbgfs_fh_reg_read(struct file *file, char __user * user_buf, size_t count,
-		     loff_t * ppos)
+il_dbgfs_fh_reg_read(struct file *file, char __user *user_buf, size_t count,
+		     loff_t *ppos)
 {
 	struct il_priv *il = file->private_data;
 	char *buf;
@@ -1195,8 +1193,8 @@ il_dbgfs_fh_reg_read(struct file *file, char __user * user_buf, size_t count,
 }
 
 static ssize_t
-il_dbgfs_missed_beacon_read(struct file *file, char __user * user_buf,
-			    size_t count, loff_t * ppos)
+il_dbgfs_missed_beacon_read(struct file *file, char __user *user_buf,
+			    size_t count, loff_t *ppos)
 {
 
 	struct il_priv *il = file->private_data;
@@ -1212,8 +1210,8 @@ il_dbgfs_missed_beacon_read(struct file *file, char __user * user_buf,
 }
 
 static ssize_t
-il_dbgfs_missed_beacon_write(struct file *file, const char __user * user_buf,
-			     size_t count, loff_t * ppos)
+il_dbgfs_missed_beacon_write(struct file *file, const char __user *user_buf,
+			     size_t count, loff_t *ppos)
 {
 	struct il_priv *il = file->private_data;
 	char buf[8];
@@ -1237,8 +1235,8 @@ il_dbgfs_missed_beacon_write(struct file *file, const char __user * user_buf,
 }
 
 static ssize_t
-il_dbgfs_force_reset_read(struct file *file, char __user * user_buf,
-			  size_t count, loff_t * ppos)
+il_dbgfs_force_reset_read(struct file *file, char __user *user_buf,
+			  size_t count, loff_t *ppos)
 {
 
 	struct il_priv *il = file->private_data;
@@ -1268,8 +1266,8 @@ il_dbgfs_force_reset_read(struct file *file, char __user * user_buf,
 }
 
 static ssize_t
-il_dbgfs_force_reset_write(struct file *file, const char __user * user_buf,
-			   size_t count, loff_t * ppos)
+il_dbgfs_force_reset_write(struct file *file, const char __user *user_buf,
+			   size_t count, loff_t *ppos)
 {
 
 	int ret;
@@ -1281,8 +1279,8 @@ il_dbgfs_force_reset_write(struct file *file, const char __user * user_buf,
 }
 
 static ssize_t
-il_dbgfs_wd_timeout_write(struct file *file, const char __user * user_buf,
-			  size_t count, loff_t * ppos)
+il_dbgfs_wd_timeout_write(struct file *file, const char __user *user_buf,
+			  size_t count, loff_t *ppos)
 {
 
 	struct il_priv *il = file->private_data;
@@ -1394,7 +1392,6 @@ err:
 	il_dbgfs_unregister(il);
 	return -ENOMEM;
 }
-
 EXPORT_SYMBOL(il_dbgfs_register);
 
 /**
@@ -1410,5 +1407,4 @@ il_dbgfs_unregister(struct il_priv *il)
 	debugfs_remove_recursive(il->debugfs_dir);
 	il->debugfs_dir = NULL;
 }
-
 EXPORT_SYMBOL(il_dbgfs_unregister);
-- 
1.7.1

