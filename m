Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:56493 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932899Ab1BYWAh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Feb 2011 17:00:37 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] iwlegacy: change some symbols duplicated from iwlwifi directory
Date: Fri, 25 Feb 2011 16:12:50 -0500
Message-Id: <1298668370-325-1-git-send-email-linville@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

drivers/net/wireless/iwlegacy/built-in.o:(.rodata+0x29f0): multiple definition of `iwl_rates'
drivers/net/wireless/iwlwifi/built-in.o:(.rodata+0xa68): first defined here
powerpc64-linux-ld: Warning: size of symbol `iwl_rates' changed from 143 in drivers/net/wireless/iwlwifi/built-in.o to 130 in drivers/net/wireless/iwlegacy/built-in.o
drivers/net/wireless/iwlegacy/built-in.o:(.data+0x0): multiple definition of `bt_coex_active'
drivers/net/wireless/iwlwifi/built-in.o:(.data+0x668): first defined here
drivers/net/wireless/iwlegacy/built-in.o:(.rodata+0x750): multiple definition of `iwl_eeprom_band_1'
drivers/net/wireless/iwlwifi/built-in.o:(.rodata+0x27d0): first defined here
drivers/net/wireless/iwlegacy/built-in.o:(.rodata+0x3f0): multiple definition of `iwl_bcast_addr'
drivers/net/wireless/iwlwifi/built-in.o:(.rodata+0x24f8): first defined here
drivers/net/wireless/iwlegacy/built-in.o:(.bss+0x3d48): multiple definition of `iwl_debug_level'
drivers/net/wireless/iwlwifi/built-in.o:(.bss+0x21950): first defined here

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 drivers/net/wireless/iwlegacy/iwl-4965-lib.c  |    4 +-
 drivers/net/wireless/iwlegacy/iwl-4965-rs.c   |   20 +++++-----
 drivers/net/wireless/iwlegacy/iwl-4965-sta.c  |    5 +-
 drivers/net/wireless/iwlegacy/iwl-4965-tx.c   |    2 +-
 drivers/net/wireless/iwlegacy/iwl-core.c      |   21 +++++-----
 drivers/net/wireless/iwlegacy/iwl-core.h      |    2 -
 drivers/net/wireless/iwlegacy/iwl-debug.h     |    2 +-
 drivers/net/wireless/iwlegacy/iwl-debugfs.c   |    4 +-
 drivers/net/wireless/iwlegacy/iwl-dev.h       |    8 ++--
 drivers/net/wireless/iwlegacy/iwl-eeprom.c    |   54 ++++++++++++------------
 drivers/net/wireless/iwlegacy/iwl-eeprom.h    |    2 +-
 drivers/net/wireless/iwlegacy/iwl-legacy-rs.h |    4 +-
 drivers/net/wireless/iwlegacy/iwl-scan.c      |    4 +-
 drivers/net/wireless/iwlegacy/iwl3945-base.c  |    6 +-
 drivers/net/wireless/iwlegacy/iwl4965-base.c  |    6 +-
 15 files changed, 71 insertions(+), 73 deletions(-)

diff --git a/drivers/net/wireless/iwlegacy/iwl-4965-lib.c b/drivers/net/wireless/iwlegacy/iwl-4965-lib.c
index bd9618a..5a8a3cc 100644
--- a/drivers/net/wireless/iwlegacy/iwl-4965-lib.c
+++ b/drivers/net/wireless/iwlegacy/iwl-4965-lib.c
@@ -424,7 +424,7 @@ int iwl4965_hwrate_to_mac80211_idx(u32 rate_n_flags, enum ieee80211_band band)
 		if (band == IEEE80211_BAND_5GHZ)
 			band_offset = IWL_FIRST_OFDM_RATE;
 		for (idx = band_offset; idx < IWL_RATE_COUNT_LEGACY; idx++)
-			if (iwl_rates[idx].plcp == (rate_n_flags & 0xFF))
+			if (iwlegacy_rates[idx].plcp == (rate_n_flags & 0xFF))
 				return idx - band_offset;
 	}
 
@@ -995,7 +995,7 @@ int iwl4965_request_scan(struct iwl_priv *priv, struct ieee80211_vif *vif)
 		/* use bcast addr, will not be transmitted but must be valid */
 		cmd_len = iwl_legacy_fill_probe_req(priv,
 					(struct ieee80211_mgmt *)scan->data,
-					iwl_bcast_addr, NULL, 0,
+					iwlegacy_bcast_addr, NULL, 0,
 					IWL_MAX_SCAN_SIZE - sizeof(*scan));
 
 	}
diff --git a/drivers/net/wireless/iwlegacy/iwl-4965-rs.c b/drivers/net/wireless/iwlegacy/iwl-4965-rs.c
index 69abd28..31ac672 100644
--- a/drivers/net/wireless/iwlegacy/iwl-4965-rs.c
+++ b/drivers/net/wireless/iwlegacy/iwl-4965-rs.c
@@ -97,7 +97,7 @@ static const u8 ant_toggle_lookup[] = {
  * maps to IWL_RATE_INVALID
  *
  */
-const struct iwl_rate_info iwl_rates[IWL_RATE_COUNT] = {
+const struct iwl_rate_info iwlegacy_rates[IWL_RATE_COUNT] = {
 	IWL_DECLARE_RATE_INFO(1, INV, INV, 2, INV, 2, INV, 2),    /*  1mbps */
 	IWL_DECLARE_RATE_INFO(2, INV, 1, 5, 1, 5, 1, 5),          /*  2mbps */
 	IWL_DECLARE_RATE_INFO(5, INV, 2, 6, 2, 11, 2, 11),        /*5.5mbps */
@@ -133,8 +133,8 @@ static int iwl4965_hwrate_to_plcp_idx(u32 rate_n_flags)
 
 	/* legacy rate format, search for match in table */
 	} else {
-		for (idx = 0; idx < ARRAY_SIZE(iwl_rates); idx++)
-			if (iwl_rates[idx].plcp == (rate_n_flags & 0xFF))
+		for (idx = 0; idx < ARRAY_SIZE(iwlegacy_rates); idx++)
+			if (iwlegacy_rates[idx].plcp == (rate_n_flags & 0xFF))
 				return idx;
 	}
 
@@ -500,7 +500,7 @@ static u32 iwl4965_rate_n_flags_from_tbl(struct iwl_priv *priv,
 	u32 rate_n_flags = 0;
 
 	if (is_legacy(tbl->lq_type)) {
-		rate_n_flags = iwl_rates[index].plcp;
+		rate_n_flags = iwlegacy_rates[index].plcp;
 		if (index >= IWL_FIRST_CCK_RATE && index <= IWL_LAST_CCK_RATE)
 			rate_n_flags |= RATE_MCS_CCK_MSK;
 
@@ -512,9 +512,9 @@ static u32 iwl4965_rate_n_flags_from_tbl(struct iwl_priv *priv,
 		rate_n_flags = RATE_MCS_HT_MSK;
 
 		if (is_siso(tbl->lq_type))
-			rate_n_flags |=	iwl_rates[index].plcp_siso;
+			rate_n_flags |=	iwlegacy_rates[index].plcp_siso;
 		else
-			rate_n_flags |=	iwl_rates[index].plcp_mimo2;
+			rate_n_flags |=	iwlegacy_rates[index].plcp_mimo2;
 	} else {
 		IWL_ERR(priv, "Invalid tbl->lq_type %d\n", tbl->lq_type);
 	}
@@ -703,7 +703,7 @@ iwl4965_rs_get_adjacent_rate(struct iwl_priv *priv, u8 index, u16 rate_mask,
 
 	low = index;
 	while (low != IWL_RATE_INVALID) {
-		low = iwl_rates[low].prev_rs;
+		low = iwlegacy_rates[low].prev_rs;
 		if (low == IWL_RATE_INVALID)
 			break;
 		if (rate_mask & (1 << low))
@@ -713,7 +713,7 @@ iwl4965_rs_get_adjacent_rate(struct iwl_priv *priv, u8 index, u16 rate_mask,
 
 	high = index;
 	while (high != IWL_RATE_INVALID) {
-		high = iwl_rates[high].next_rs;
+		high = iwlegacy_rates[high].next_rs;
 		if (high == IWL_RATE_INVALID)
 			break;
 		if (rate_mask & (1 << high))
@@ -2221,7 +2221,7 @@ static void iwl4965_rs_initialize_lq(struct iwl_priv *priv,
 	if ((i < 0) || (i >= IWL_RATE_COUNT))
 		i = 0;
 
-	rate = iwl_rates[i].plcp;
+	rate = iwlegacy_rates[i].plcp;
 	tbl->ant_type = iwl4965_first_antenna(valid_tx_ant);
 	rate |= tbl->ant_type << RATE_MCS_ANT_POS;
 
@@ -2791,7 +2791,7 @@ static ssize_t iwl4965_rs_sta_dbgfs_rate_scale_data_read(struct file *file,
 	else
 		desc += sprintf(buff+desc,
 				"Bit Rate= %d Mb/s\n",
-				iwl_rates[lq_sta->last_txrate_idx].ieee >> 1);
+				iwlegacy_rates[lq_sta->last_txrate_idx].ieee >> 1);
 
 	ret = simple_read_from_buffer(user_buf, count, ppos, buff, desc);
 	return ret;
diff --git a/drivers/net/wireless/iwlegacy/iwl-4965-sta.c b/drivers/net/wireless/iwlegacy/iwl-4965-sta.c
index 057da2c..a262c23 100644
--- a/drivers/net/wireless/iwlegacy/iwl-4965-sta.c
+++ b/drivers/net/wireless/iwlegacy/iwl-4965-sta.c
@@ -59,7 +59,8 @@ iwl4965_sta_alloc_lq(struct iwl_priv *priv, u8 sta_id)
 
 	rate_flags |= iwl4965_first_antenna(priv->hw_params.valid_tx_ant) <<
 				RATE_MCS_ANT_POS;
-	rate_n_flags = iwl4965_hw_set_rate_n_flags(iwl_rates[r].plcp, rate_flags);
+	rate_n_flags = iwl4965_hw_set_rate_n_flags(iwlegacy_rates[r].plcp,
+						   rate_flags);
 	for (i = 0; i < LINK_QUAL_MAX_RETRY_NUM; i++)
 		link_cmd->rs_table[i].rate_n_flags = rate_n_flags;
 
@@ -553,7 +554,7 @@ int iwl4965_alloc_bcast_station(struct iwl_priv *priv,
 	u8 sta_id;
 
 	spin_lock_irqsave(&priv->sta_lock, flags);
-	sta_id = iwl_legacy_prep_station(priv, ctx, iwl_bcast_addr,
+	sta_id = iwl_legacy_prep_station(priv, ctx, iwlegacy_bcast_addr,
 								false, NULL);
 	if (sta_id == IWL_INVALID_STATION) {
 		IWL_ERR(priv, "Unable to prepare broadcast station\n");
diff --git a/drivers/net/wireless/iwlegacy/iwl-4965-tx.c b/drivers/net/wireless/iwlegacy/iwl-4965-tx.c
index 2e0f0db..829db91 100644
--- a/drivers/net/wireless/iwlegacy/iwl-4965-tx.c
+++ b/drivers/net/wireless/iwlegacy/iwl-4965-tx.c
@@ -203,7 +203,7 @@ static void iwl4965_tx_cmd_build_rate(struct iwl_priv *priv,
 	if (info->band == IEEE80211_BAND_5GHZ)
 		rate_idx += IWL_FIRST_OFDM_RATE;
 	/* Get PLCP rate for tx_cmd->rate_n_flags */
-	rate_plcp = iwl_rates[rate_idx].plcp;
+	rate_plcp = iwlegacy_rates[rate_idx].plcp;
 	/* Zero out flags for this packet */
 	rate_flags = 0;
 
diff --git a/drivers/net/wireless/iwlegacy/iwl-core.c b/drivers/net/wireless/iwlegacy/iwl-core.c
index 7cc560b..d418b64 100644
--- a/drivers/net/wireless/iwlegacy/iwl-core.c
+++ b/drivers/net/wireless/iwlegacy/iwl-core.c
@@ -64,16 +64,15 @@ MODULE_LICENSE("GPL");
  *
  * default: bt_coex_active = true (BT_COEX_ENABLE)
  */
-bool bt_coex_active = true;
-EXPORT_SYMBOL_GPL(bt_coex_active);
+static bool bt_coex_active = true;
 module_param(bt_coex_active, bool, S_IRUGO);
 MODULE_PARM_DESC(bt_coex_active, "enable wifi/bluetooth co-exist");
 
-u32 iwl_debug_level;
-EXPORT_SYMBOL(iwl_debug_level);
+u32 iwlegacy_debug_level;
+EXPORT_SYMBOL(iwlegacy_debug_level);
 
-const u8 iwl_bcast_addr[ETH_ALEN] = { 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF };
-EXPORT_SYMBOL(iwl_bcast_addr);
+const u8 iwlegacy_bcast_addr[ETH_ALEN] = { 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF };
+EXPORT_SYMBOL(iwlegacy_bcast_addr);
 
 
 /* This function both allocates and initializes hw and priv. */
@@ -183,7 +182,7 @@ int iwl_legacy_init_geos(struct iwl_priv *priv)
 
 	/* 5.2GHz channels start after the 2.4GHz channels */
 	sband = &priv->bands[IEEE80211_BAND_5GHZ];
-	sband->channels = &channels[ARRAY_SIZE(iwl_eeprom_band_1)];
+	sband->channels = &channels[ARRAY_SIZE(iwlegacy_eeprom_band_1)];
 	/* just OFDM */
 	sband->bitrates = &rates[IWL_FIRST_OFDM_RATE];
 	sband->n_bitrates = IWL_RATE_COUNT_LEGACY - IWL_FIRST_OFDM_RATE;
@@ -1489,7 +1488,7 @@ int iwl_legacy_alloc_traffic_mem(struct iwl_priv *priv)
 {
 	u32 traffic_size = IWL_TRAFFIC_DUMP_SIZE;
 
-	if (iwl_debug_level & IWL_DL_TX) {
+	if (iwlegacy_debug_level & IWL_DL_TX) {
 		if (!priv->tx_traffic) {
 			priv->tx_traffic =
 				kzalloc(traffic_size, GFP_KERNEL);
@@ -1497,7 +1496,7 @@ int iwl_legacy_alloc_traffic_mem(struct iwl_priv *priv)
 				return -ENOMEM;
 		}
 	}
-	if (iwl_debug_level & IWL_DL_RX) {
+	if (iwlegacy_debug_level & IWL_DL_RX) {
 		if (!priv->rx_traffic) {
 			priv->rx_traffic =
 				kzalloc(traffic_size, GFP_KERNEL);
@@ -1526,7 +1525,7 @@ void iwl_legacy_dbg_log_tx_data_frame(struct iwl_priv *priv,
 	__le16 fc;
 	u16 len;
 
-	if (likely(!(iwl_debug_level & IWL_DL_TX)))
+	if (likely(!(iwlegacy_debug_level & IWL_DL_TX)))
 		return;
 
 	if (!priv->tx_traffic)
@@ -1551,7 +1550,7 @@ void iwl_legacy_dbg_log_rx_data_frame(struct iwl_priv *priv,
 	__le16 fc;
 	u16 len;
 
-	if (likely(!(iwl_debug_level & IWL_DL_RX)))
+	if (likely(!(iwlegacy_debug_level & IWL_DL_RX)))
 		return;
 
 	if (!priv->rx_traffic)
diff --git a/drivers/net/wireless/iwlegacy/iwl-core.h b/drivers/net/wireless/iwlegacy/iwl-core.h
index 1159b0d..c6d12d7 100644
--- a/drivers/net/wireless/iwlegacy/iwl-core.h
+++ b/drivers/net/wireless/iwlegacy/iwl-core.h
@@ -628,8 +628,6 @@ static inline const struct ieee80211_supported_band *iwl_get_hw_mode(
 	return priv->hw->wiphy->bands[band];
 }
 
-extern bool bt_coex_active;
-
 /* mac80211 handlers */
 int iwl_legacy_mac_config(struct ieee80211_hw *hw, u32 changed);
 void iwl_legacy_mac_reset_tsf(struct ieee80211_hw *hw);
diff --git a/drivers/net/wireless/iwlegacy/iwl-debug.h b/drivers/net/wireless/iwlegacy/iwl-debug.h
index 665789f..ae13112 100644
--- a/drivers/net/wireless/iwlegacy/iwl-debug.h
+++ b/drivers/net/wireless/iwlegacy/iwl-debug.h
@@ -30,7 +30,7 @@
 #define __iwl_legacy_debug_h__
 
 struct iwl_priv;
-extern u32 iwl_debug_level;
+extern u32 iwlegacy_debug_level;
 
 #define IWL_ERR(p, f, a...) dev_err(&((p)->pci_dev->dev), f, ## a)
 #define IWL_WARN(p, f, a...) dev_warn(&((p)->pci_dev->dev), f, ## a)
diff --git a/drivers/net/wireless/iwlegacy/iwl-debugfs.c b/drivers/net/wireless/iwlegacy/iwl-debugfs.c
index 6ea9c4f..2d32438 100644
--- a/drivers/net/wireless/iwlegacy/iwl-debugfs.c
+++ b/drivers/net/wireless/iwlegacy/iwl-debugfs.c
@@ -748,7 +748,7 @@ static ssize_t iwl_legacy_dbgfs_traffic_log_read(struct file *file,
 				"q[%d]: read_ptr: %u, write_ptr: %u\n",
 				cnt, q->read_ptr, q->write_ptr);
 	}
-	if (priv->tx_traffic && (iwl_debug_level & IWL_DL_TX)) {
+	if (priv->tx_traffic && (iwlegacy_debug_level & IWL_DL_TX)) {
 		ptr = priv->tx_traffic;
 		pos += scnprintf(buf + pos, bufsz - pos,
 				"Tx Traffic idx: %u\n",	priv->tx_traffic_idx);
@@ -771,7 +771,7 @@ static ssize_t iwl_legacy_dbgfs_traffic_log_read(struct file *file,
 			"read: %u, write: %u\n",
 			 rxq->read, rxq->write);
 
-	if (priv->rx_traffic && (iwl_debug_level & IWL_DL_RX)) {
+	if (priv->rx_traffic && (iwlegacy_debug_level & IWL_DL_RX)) {
 		ptr = priv->rx_traffic;
 		pos += scnprintf(buf + pos, bufsz - pos,
 				"Rx Traffic idx: %u\n",	priv->rx_traffic_idx);
diff --git a/drivers/net/wireless/iwlegacy/iwl-dev.h b/drivers/net/wireless/iwlegacy/iwl-dev.h
index 25718cf..9ee849d 100644
--- a/drivers/net/wireless/iwlegacy/iwl-dev.h
+++ b/drivers/net/wireless/iwlegacy/iwl-dev.h
@@ -624,7 +624,7 @@ struct iwl_hw_params {
  *
  ****************************************************************************/
 extern void iwl4965_update_chain_flags(struct iwl_priv *priv);
-extern const u8 iwl_bcast_addr[ETH_ALEN];
+extern const u8 iwlegacy_bcast_addr[ETH_ALEN];
 extern int iwl_legacy_queue_space(const struct iwl_queue *q);
 static inline int iwl_legacy_queue_used(const struct iwl_queue *q, int i)
 {
@@ -1285,7 +1285,7 @@ struct iwl_priv {
 #ifdef CONFIG_IWLWIFI_LEGACY_DEBUG
 	/* debugging info */
 	u32 debug_level; /* per device debugging will override global
-			    iwl_debug_level if set */
+			    iwlegacy_debug_level if set */
 #endif /* CONFIG_IWLWIFI_LEGACY_DEBUG */
 #ifdef CONFIG_IWLWIFI_LEGACY_DEBUGFS
 	/* debugfs */
@@ -1338,12 +1338,12 @@ static inline u32 iwl_legacy_get_debug_level(struct iwl_priv *priv)
 	if (priv->debug_level)
 		return priv->debug_level;
 	else
-		return iwl_debug_level;
+		return iwlegacy_debug_level;
 }
 #else
 static inline u32 iwl_legacy_get_debug_level(struct iwl_priv *priv)
 {
-	return iwl_debug_level;
+	return iwlegacy_debug_level;
 }
 #endif
 
diff --git a/drivers/net/wireless/iwlegacy/iwl-eeprom.c b/drivers/net/wireless/iwlegacy/iwl-eeprom.c
index 39e5773..04c5648 100644
--- a/drivers/net/wireless/iwlegacy/iwl-eeprom.c
+++ b/drivers/net/wireless/iwlegacy/iwl-eeprom.c
@@ -77,7 +77,7 @@
 
 /************************** EEPROM BANDS ****************************
  *
- * The iwl_eeprom_band definitions below provide the mapping from the
+ * The iwlegacy_eeprom_band definitions below provide the mapping from the
  * EEPROM contents to the specific channel number supported for each
  * band.
  *
@@ -107,32 +107,32 @@
  *********************************************************************/
 
 /* 2.4 GHz */
-const u8 iwl_eeprom_band_1[14] = {
+const u8 iwlegacy_eeprom_band_1[14] = {
 	1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14
 };
 
 /* 5.2 GHz bands */
-static const u8 iwl_eeprom_band_2[] = {	/* 4915-5080MHz */
+static const u8 iwlegacy_eeprom_band_2[] = {	/* 4915-5080MHz */
 	183, 184, 185, 187, 188, 189, 192, 196, 7, 8, 11, 12, 16
 };
 
-static const u8 iwl_eeprom_band_3[] = {	/* 5170-5320MHz */
+static const u8 iwlegacy_eeprom_band_3[] = {	/* 5170-5320MHz */
 	34, 36, 38, 40, 42, 44, 46, 48, 52, 56, 60, 64
 };
 
-static const u8 iwl_eeprom_band_4[] = {	/* 5500-5700MHz */
+static const u8 iwlegacy_eeprom_band_4[] = {	/* 5500-5700MHz */
 	100, 104, 108, 112, 116, 120, 124, 128, 132, 136, 140
 };
 
-static const u8 iwl_eeprom_band_5[] = {	/* 5725-5825MHz */
+static const u8 iwlegacy_eeprom_band_5[] = {	/* 5725-5825MHz */
 	145, 149, 153, 157, 161, 165
 };
 
-static const u8 iwl_eeprom_band_6[] = {       /* 2.4 ht40 channel */
+static const u8 iwlegacy_eeprom_band_6[] = {       /* 2.4 ht40 channel */
 	1, 2, 3, 4, 5, 6, 7
 };
 
-static const u8 iwl_eeprom_band_7[] = {       /* 5.2 ht40 channel */
+static const u8 iwlegacy_eeprom_band_7[] = {       /* 5.2 ht40 channel */
 	36, 44, 52, 60, 100, 108, 116, 124, 132, 149, 157
 };
 
@@ -273,46 +273,46 @@ static void iwl_legacy_init_band_reference(const struct iwl_priv *priv,
 			eeprom_ops.regulatory_bands[eep_band - 1];
 	switch (eep_band) {
 	case 1:		/* 2.4GHz band */
-		*eeprom_ch_count = ARRAY_SIZE(iwl_eeprom_band_1);
+		*eeprom_ch_count = ARRAY_SIZE(iwlegacy_eeprom_band_1);
 		*eeprom_ch_info = (struct iwl_eeprom_channel *)
 				iwl_legacy_eeprom_query_addr(priv, offset);
-		*eeprom_ch_index = iwl_eeprom_band_1;
+		*eeprom_ch_index = iwlegacy_eeprom_band_1;
 		break;
 	case 2:		/* 4.9GHz band */
-		*eeprom_ch_count = ARRAY_SIZE(iwl_eeprom_band_2);
+		*eeprom_ch_count = ARRAY_SIZE(iwlegacy_eeprom_band_2);
 		*eeprom_ch_info = (struct iwl_eeprom_channel *)
 				iwl_legacy_eeprom_query_addr(priv, offset);
-		*eeprom_ch_index = iwl_eeprom_band_2;
+		*eeprom_ch_index = iwlegacy_eeprom_band_2;
 		break;
 	case 3:		/* 5.2GHz band */
-		*eeprom_ch_count = ARRAY_SIZE(iwl_eeprom_band_3);
+		*eeprom_ch_count = ARRAY_SIZE(iwlegacy_eeprom_band_3);
 		*eeprom_ch_info = (struct iwl_eeprom_channel *)
 				iwl_legacy_eeprom_query_addr(priv, offset);
-		*eeprom_ch_index = iwl_eeprom_band_3;
+		*eeprom_ch_index = iwlegacy_eeprom_band_3;
 		break;
 	case 4:		/* 5.5GHz band */
-		*eeprom_ch_count = ARRAY_SIZE(iwl_eeprom_band_4);
+		*eeprom_ch_count = ARRAY_SIZE(iwlegacy_eeprom_band_4);
 		*eeprom_ch_info = (struct iwl_eeprom_channel *)
 				iwl_legacy_eeprom_query_addr(priv, offset);
-		*eeprom_ch_index = iwl_eeprom_band_4;
+		*eeprom_ch_index = iwlegacy_eeprom_band_4;
 		break;
 	case 5:		/* 5.7GHz band */
-		*eeprom_ch_count = ARRAY_SIZE(iwl_eeprom_band_5);
+		*eeprom_ch_count = ARRAY_SIZE(iwlegacy_eeprom_band_5);
 		*eeprom_ch_info = (struct iwl_eeprom_channel *)
 				iwl_legacy_eeprom_query_addr(priv, offset);
-		*eeprom_ch_index = iwl_eeprom_band_5;
+		*eeprom_ch_index = iwlegacy_eeprom_band_5;
 		break;
 	case 6:		/* 2.4GHz ht40 channels */
-		*eeprom_ch_count = ARRAY_SIZE(iwl_eeprom_band_6);
+		*eeprom_ch_count = ARRAY_SIZE(iwlegacy_eeprom_band_6);
 		*eeprom_ch_info = (struct iwl_eeprom_channel *)
 				iwl_legacy_eeprom_query_addr(priv, offset);
-		*eeprom_ch_index = iwl_eeprom_band_6;
+		*eeprom_ch_index = iwlegacy_eeprom_band_6;
 		break;
 	case 7:		/* 5 GHz ht40 channels */
-		*eeprom_ch_count = ARRAY_SIZE(iwl_eeprom_band_7);
+		*eeprom_ch_count = ARRAY_SIZE(iwlegacy_eeprom_band_7);
 		*eeprom_ch_info = (struct iwl_eeprom_channel *)
 				iwl_legacy_eeprom_query_addr(priv, offset);
-		*eeprom_ch_index = iwl_eeprom_band_7;
+		*eeprom_ch_index = iwlegacy_eeprom_band_7;
 		break;
 	default:
 		BUG();
@@ -388,11 +388,11 @@ int iwl_legacy_init_channel_map(struct iwl_priv *priv)
 	IWL_DEBUG_EEPROM(priv, "Initializing regulatory info from EEPROM\n");
 
 	priv->channel_count =
-	    ARRAY_SIZE(iwl_eeprom_band_1) +
-	    ARRAY_SIZE(iwl_eeprom_band_2) +
-	    ARRAY_SIZE(iwl_eeprom_band_3) +
-	    ARRAY_SIZE(iwl_eeprom_band_4) +
-	    ARRAY_SIZE(iwl_eeprom_band_5);
+	    ARRAY_SIZE(iwlegacy_eeprom_band_1) +
+	    ARRAY_SIZE(iwlegacy_eeprom_band_2) +
+	    ARRAY_SIZE(iwlegacy_eeprom_band_3) +
+	    ARRAY_SIZE(iwlegacy_eeprom_band_4) +
+	    ARRAY_SIZE(iwlegacy_eeprom_band_5);
 
 	IWL_DEBUG_EEPROM(priv, "Parsing data for %d channels.\n",
 			priv->channel_count);
diff --git a/drivers/net/wireless/iwlegacy/iwl-eeprom.h b/drivers/net/wireless/iwlegacy/iwl-eeprom.h
index 0744f8d..c59c810 100644
--- a/drivers/net/wireless/iwlegacy/iwl-eeprom.h
+++ b/drivers/net/wireless/iwlegacy/iwl-eeprom.h
@@ -144,7 +144,7 @@ struct iwl_eeprom_channel {
 #define EEPROM_4965_BOARD_PBA                  (2*0x56+1) /* 9 bytes */
 
 /* 2.4 GHz */
-extern const u8 iwl_eeprom_band_1[14];
+extern const u8 iwlegacy_eeprom_band_1[14];
 
 /*
  * factory calibration data for one txpower level, on one channel,
diff --git a/drivers/net/wireless/iwlegacy/iwl-legacy-rs.h b/drivers/net/wireless/iwlegacy/iwl-legacy-rs.h
index f66a1b2..38647e4 100644
--- a/drivers/net/wireless/iwlegacy/iwl-legacy-rs.h
+++ b/drivers/net/wireless/iwlegacy/iwl-legacy-rs.h
@@ -56,7 +56,7 @@ struct iwl3945_rate_info {
 
 /*
  * These serve as indexes into
- * struct iwl_rate_info iwl_rates[IWL_RATE_COUNT];
+ * struct iwl_rate_info iwlegacy_rates[IWL_RATE_COUNT];
  */
 enum {
 	IWL_RATE_1M_INDEX = 0,
@@ -268,7 +268,7 @@ enum {
 #define TID_MAX_TIME_DIFF ((TID_QUEUE_MAX_SIZE - 1) * TID_QUEUE_CELL_SPACING)
 #define TIME_WRAP_AROUND(x, y) (((y) > (x)) ? (y) - (x) : (0-(x)) + (y))
 
-extern const struct iwl_rate_info iwl_rates[IWL_RATE_COUNT];
+extern const struct iwl_rate_info iwlegacy_rates[IWL_RATE_COUNT];
 
 enum iwl_table_type {
 	LQ_NONE,
diff --git a/drivers/net/wireless/iwlegacy/iwl-scan.c b/drivers/net/wireless/iwlegacy/iwl-scan.c
index 842f0b4..60f597f 100644
--- a/drivers/net/wireless/iwlegacy/iwl-scan.c
+++ b/drivers/net/wireless/iwlegacy/iwl-scan.c
@@ -492,9 +492,9 @@ iwl_legacy_fill_probe_req(struct iwl_priv *priv, struct ieee80211_mgmt *frame,
 		return 0;
 
 	frame->frame_control = cpu_to_le16(IEEE80211_STYPE_PROBE_REQ);
-	memcpy(frame->da, iwl_bcast_addr, ETH_ALEN);
+	memcpy(frame->da, iwlegacy_bcast_addr, ETH_ALEN);
 	memcpy(frame->sa, ta, ETH_ALEN);
-	memcpy(frame->bssid, iwl_bcast_addr, ETH_ALEN);
+	memcpy(frame->bssid, iwlegacy_bcast_addr, ETH_ALEN);
 	frame->seq_ctrl = 0;
 
 	len += 24;
diff --git a/drivers/net/wireless/iwlegacy/iwl3945-base.c b/drivers/net/wireless/iwlegacy/iwl3945-base.c
index a6af981..ab87e1b 100644
--- a/drivers/net/wireless/iwlegacy/iwl3945-base.c
+++ b/drivers/net/wireless/iwlegacy/iwl3945-base.c
@@ -2630,7 +2630,7 @@ static int iwl3945_alloc_bcast_station(struct iwl_priv *priv)
 
 	spin_lock_irqsave(&priv->sta_lock, flags);
 	sta_id = iwl_legacy_prep_station(priv, ctx,
-					iwl_bcast_addr, false, NULL);
+					iwlegacy_bcast_addr, false, NULL);
 	if (sta_id == IWL_INVALID_STATION) {
 		IWL_ERR(priv, "Unable to prepare broadcast station\n");
 		spin_unlock_irqrestore(&priv->sta_lock, flags);
@@ -2929,7 +2929,7 @@ int iwl3945_request_scan(struct iwl_priv *priv, struct ieee80211_vif *vif)
 		scan->tx_cmd.len = cpu_to_le16(
 			iwl_legacy_fill_probe_req(priv,
 				(struct ieee80211_mgmt *)scan->data,
-				iwl_bcast_addr, NULL, 0,
+				iwlegacy_bcast_addr, NULL, 0,
 				IWL_MAX_SCAN_SIZE - sizeof(*scan)));
 	}
 	/* select Rx antennas */
@@ -4283,7 +4283,7 @@ module_param_named(disable_hw_scan, iwl3945_mod_params.disable_hw_scan,
 MODULE_PARM_DESC(disable_hw_scan,
 		"disable hardware scanning (default 0) (deprecated)");
 #ifdef CONFIG_IWLWIFI_LEGACY_DEBUG
-module_param_named(debug, iwl_debug_level, uint, S_IRUGO | S_IWUSR);
+module_param_named(debug, iwlegacy_debug_level, uint, S_IRUGO | S_IWUSR);
 MODULE_PARM_DESC(debug, "debug output mask");
 #endif
 module_param_named(fw_restart, iwl3945_mod_params.restart_fw, int, S_IRUGO);
diff --git a/drivers/net/wireless/iwlegacy/iwl4965-base.c b/drivers/net/wireless/iwlegacy/iwl4965-base.c
index 4d53d0f..91b3d8b 100644
--- a/drivers/net/wireless/iwlegacy/iwl4965-base.c
+++ b/drivers/net/wireless/iwlegacy/iwl4965-base.c
@@ -3057,7 +3057,7 @@ static void iwl4965_init_hw_rates(struct iwl_priv *priv,
 	int i;
 
 	for (i = 0; i < IWL_RATE_COUNT_LEGACY; i++) {
-		rates[i].bitrate = iwl_rates[i].ieee * 5;
+		rates[i].bitrate = iwlegacy_rates[i].ieee * 5;
 		rates[i].hw_value = i; /* Rate scaling will work on indexes */
 		rates[i].hw_value_short = i;
 		rates[i].flags = 0;
@@ -3066,7 +3066,7 @@ static void iwl4965_init_hw_rates(struct iwl_priv *priv,
 			 * If CCK != 1M then set short preamble rate flag.
 			 */
 			rates[i].flags |=
-				(iwl_rates[i].plcp == IWL_RATE_1M_PLCP) ?
+				(iwlegacy_rates[i].plcp == IWL_RATE_1M_PLCP) ?
 					0 : IEEE80211_RATE_SHORT_PREAMBLE;
 		}
 	}
@@ -3615,7 +3615,7 @@ module_exit(iwl4965_exit);
 module_init(iwl4965_init);
 
 #ifdef CONFIG_IWLWIFI_LEGACY_DEBUG
-module_param_named(debug, iwl_debug_level, uint, S_IRUGO | S_IWUSR);
+module_param_named(debug, iwlegacy_debug_level, uint, S_IRUGO | S_IWUSR);
 MODULE_PARM_DESC(debug, "debug output mask");
 #endif
 
-- 
1.7.4

