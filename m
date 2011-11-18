Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:15823 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751607Ab1KRIU5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Nov 2011 03:20:57 -0500
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pAI8KvQF032158
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-wireless@vger.kernel.org>; Fri, 18 Nov 2011 03:20:57 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 04/77] iwlegacy: rename iwlegacy to il
Date: Fri, 18 Nov 2011 09:21:26 +0100
Message-Id: <1321604559-10707-4-git-send-email-sgruszka@redhat.com> (sfid-20111118_092103_011210_7A206251)
In-Reply-To: <1321604559-10707-1-git-send-email-sgruszka@redhat.com>
References: <1321604559-10707-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

More renaming to make code shorter.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlegacy/iwl-4965-lib.c  |    2 +-
 drivers/net/wireless/iwlegacy/iwl-4965-rs.c   |   20 +++++-----
 drivers/net/wireless/iwlegacy/iwl-4965-sta.c  |    4 +-
 drivers/net/wireless/iwlegacy/iwl-4965-tx.c   |    2 +-
 drivers/net/wireless/iwlegacy/iwl-core.c      |   18 ++++----
 drivers/net/wireless/iwlegacy/iwl-debug.h     |    2 +-
 drivers/net/wireless/iwlegacy/iwl-debugfs.c   |    4 +-
 drivers/net/wireless/iwlegacy/iwl-dev.h       |    8 ++--
 drivers/net/wireless/iwlegacy/iwl-eeprom.c    |   54 ++++++++++++------------
 drivers/net/wireless/iwlegacy/iwl-eeprom.h    |    2 +-
 drivers/net/wireless/iwlegacy/iwl-legacy-rs.h |    4 +-
 drivers/net/wireless/iwlegacy/iwl-scan.c      |    4 +-
 drivers/net/wireless/iwlegacy/iwl3945-base.c  |    4 +-
 drivers/net/wireless/iwlegacy/iwl4965-base.c  |    6 +-
 14 files changed, 67 insertions(+), 67 deletions(-)

diff --git a/drivers/net/wireless/iwlegacy/iwl-4965-lib.c b/drivers/net/wireless/iwlegacy/iwl-4965-lib.c
index 4d25590..647399e 100644
--- a/drivers/net/wireless/iwlegacy/iwl-4965-lib.c
+++ b/drivers/net/wireless/iwlegacy/iwl-4965-lib.c
@@ -424,7 +424,7 @@ int il4965_hwrate_to_mac80211_idx(u32 rate_n_flags, enum ieee80211_band band)
 		if (band == IEEE80211_BAND_5GHZ)
 			band_offset = IL_FIRST_OFDM_RATE;
 		for (idx = band_offset; idx < IL_RATE_COUNT_LEGACY; idx++)
-			if (iwlegacy_rates[idx].plcp == (rate_n_flags & 0xFF))
+			if (il_rates[idx].plcp == (rate_n_flags & 0xFF))
 				return idx - band_offset;
 	}
 
diff --git a/drivers/net/wireless/iwlegacy/iwl-4965-rs.c b/drivers/net/wireless/iwlegacy/iwl-4965-rs.c
index e53ed1a..60ff0cd 100644
--- a/drivers/net/wireless/iwlegacy/iwl-4965-rs.c
+++ b/drivers/net/wireless/iwlegacy/iwl-4965-rs.c
@@ -96,7 +96,7 @@ static const u8 ant_toggle_lookup[] = {
  * maps to IL_RATE_INVALID
  *
  */
-const struct il_rate_info iwlegacy_rates[IL_RATE_COUNT] = {
+const struct il_rate_info il_rates[IL_RATE_COUNT] = {
 	IL_DECLARE_RATE_INFO(1, INV, INV, 2, INV, 2, INV, 2),    /*  1mbps */
 	IL_DECLARE_RATE_INFO(2, INV, 1, 5, 1, 5, 1, 5),          /*  2mbps */
 	IL_DECLARE_RATE_INFO(5, INV, 2, 6, 2, 11, 2, 11),        /*5.5mbps */
@@ -132,8 +132,8 @@ static int il4965_hwrate_to_plcp_idx(u32 rate_n_flags)
 
 	/* legacy rate format, search for match in table */
 	} else {
-		for (idx = 0; idx < ARRAY_SIZE(iwlegacy_rates); idx++)
-			if (iwlegacy_rates[idx].plcp == (rate_n_flags & 0xFF))
+		for (idx = 0; idx < ARRAY_SIZE(il_rates); idx++)
+			if (il_rates[idx].plcp == (rate_n_flags & 0xFF))
 				return idx;
 	}
 
@@ -499,7 +499,7 @@ static u32 il4965_rate_n_flags_from_tbl(struct il_priv *il,
 	u32 rate_n_flags = 0;
 
 	if (is_legacy(tbl->lq_type)) {
-		rate_n_flags = iwlegacy_rates[index].plcp;
+		rate_n_flags = il_rates[index].plcp;
 		if (index >= IL_FIRST_CCK_RATE && index <= IL_LAST_CCK_RATE)
 			rate_n_flags |= RATE_MCS_CCK_MSK;
 
@@ -511,9 +511,9 @@ static u32 il4965_rate_n_flags_from_tbl(struct il_priv *il,
 		rate_n_flags = RATE_MCS_HT_MSK;
 
 		if (is_siso(tbl->lq_type))
-			rate_n_flags |=	iwlegacy_rates[index].plcp_siso;
+			rate_n_flags |=	il_rates[index].plcp_siso;
 		else
-			rate_n_flags |=	iwlegacy_rates[index].plcp_mimo2;
+			rate_n_flags |=	il_rates[index].plcp_mimo2;
 	} else {
 		IL_ERR(il, "Invalid tbl->lq_type %d\n", tbl->lq_type);
 	}
@@ -702,7 +702,7 @@ il4965_rs_get_adjacent_rate(struct il_priv *il, u8 index, u16 rate_mask,
 
 	low = index;
 	while (low != IL_RATE_INVALID) {
-		low = iwlegacy_rates[low].prev_rs;
+		low = il_rates[low].prev_rs;
 		if (low == IL_RATE_INVALID)
 			break;
 		if (rate_mask & (1 << low))
@@ -712,7 +712,7 @@ il4965_rs_get_adjacent_rate(struct il_priv *il, u8 index, u16 rate_mask,
 
 	high = index;
 	while (high != IL_RATE_INVALID) {
-		high = iwlegacy_rates[high].next_rs;
+		high = il_rates[high].next_rs;
 		if (high == IL_RATE_INVALID)
 			break;
 		if (rate_mask & (1 << high))
@@ -2220,7 +2220,7 @@ static void il4965_rs_initialize_lq(struct il_priv *il,
 	if ((i < 0) || (i >= IL_RATE_COUNT))
 		i = 0;
 
-	rate = iwlegacy_rates[i].plcp;
+	rate = il_rates[i].plcp;
 	tbl->ant_type = il4965_first_antenna(valid_tx_ant);
 	rate |= tbl->ant_type << RATE_MCS_ANT_POS;
 
@@ -2793,7 +2793,7 @@ static ssize_t il4965_rs_sta_dbgfs_rate_scale_data_read(struct file *file,
 	else
 		desc += sprintf(buff+desc,
 				"Bit Rate= %d Mb/s\n",
-				iwlegacy_rates[lq_sta->last_txrate_idx].ieee >> 1);
+				il_rates[lq_sta->last_txrate_idx].ieee >> 1);
 
 	ret = simple_read_from_buffer(user_buf, count, ppos, buff, desc);
 	return ret;
diff --git a/drivers/net/wireless/iwlegacy/iwl-4965-sta.c b/drivers/net/wireless/iwlegacy/iwl-4965-sta.c
index 20290d2..0fbc991 100644
--- a/drivers/net/wireless/iwlegacy/iwl-4965-sta.c
+++ b/drivers/net/wireless/iwlegacy/iwl-4965-sta.c
@@ -59,7 +59,7 @@ il4965_sta_alloc_lq(struct il_priv *il, u8 sta_id)
 
 	rate_flags |= il4965_first_antenna(il->hw_params.valid_tx_ant) <<
 				RATE_MCS_ANT_POS;
-	rate_n_flags = il4965_hw_set_rate_n_flags(iwlegacy_rates[r].plcp,
+	rate_n_flags = il4965_hw_set_rate_n_flags(il_rates[r].plcp,
 						   rate_flags);
 	for (i = 0; i < LINK_QUAL_MAX_RETRY_NUM; i++)
 		link_cmd->rs_table[i].rate_n_flags = rate_n_flags;
@@ -554,7 +554,7 @@ int il4965_alloc_bcast_station(struct il_priv *il,
 	u8 sta_id;
 
 	spin_lock_irqsave(&il->sta_lock, flags);
-	sta_id = il_prep_station(il, ctx, iwlegacy_bcast_addr,
+	sta_id = il_prep_station(il, ctx, il_bcast_addr,
 								false, NULL);
 	if (sta_id == IL_INVALID_STATION) {
 		IL_ERR(il, "Unable to prepare broadcast station\n");
diff --git a/drivers/net/wireless/iwlegacy/iwl-4965-tx.c b/drivers/net/wireless/iwlegacy/iwl-4965-tx.c
index 59d7374..fcc938e 100644
--- a/drivers/net/wireless/iwlegacy/iwl-4965-tx.c
+++ b/drivers/net/wireless/iwlegacy/iwl-4965-tx.c
@@ -203,7 +203,7 @@ static void il4965_tx_cmd_build_rate(struct il_priv *il,
 	if (info->band == IEEE80211_BAND_5GHZ)
 		rate_idx += IL_FIRST_OFDM_RATE;
 	/* Get PLCP rate for tx_cmd->rate_n_flags */
-	rate_plcp = iwlegacy_rates[rate_idx].plcp;
+	rate_plcp = il_rates[rate_idx].plcp;
 	/* Zero out flags for this packet */
 	rate_flags = 0;
 
diff --git a/drivers/net/wireless/iwlegacy/iwl-core.c b/drivers/net/wireless/iwlegacy/iwl-core.c
index 80ec543..a768e78 100644
--- a/drivers/net/wireless/iwlegacy/iwl-core.c
+++ b/drivers/net/wireless/iwlegacy/iwl-core.c
@@ -68,11 +68,11 @@ static bool bt_coex_active = true;
 module_param(bt_coex_active, bool, S_IRUGO);
 MODULE_PARM_DESC(bt_coex_active, "enable wifi/bluetooth co-exist");
 
-u32 iwlegacy_debug_level;
-EXPORT_SYMBOL(iwlegacy_debug_level);
+u32 il_debug_level;
+EXPORT_SYMBOL(il_debug_level);
 
-const u8 iwlegacy_bcast_addr[ETH_ALEN] = { 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF };
-EXPORT_SYMBOL(iwlegacy_bcast_addr);
+const u8 il_bcast_addr[ETH_ALEN] = { 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF };
+EXPORT_SYMBOL(il_bcast_addr);
 
 
 /* This function both allocates and initializes hw and il. */
@@ -183,7 +183,7 @@ int il_init_geos(struct il_priv *il)
 
 	/* 5.2GHz channels start after the 2.4GHz channels */
 	sband = &il->bands[IEEE80211_BAND_5GHZ];
-	sband->channels = &channels[ARRAY_SIZE(iwlegacy_eeprom_band_1)];
+	sband->channels = &channels[ARRAY_SIZE(il_eeprom_band_1)];
 	/* just OFDM */
 	sband->bitrates = &rates[IL_FIRST_OFDM_RATE];
 	sband->n_bitrates = IL_RATE_COUNT_LEGACY - IL_FIRST_OFDM_RATE;
@@ -1486,7 +1486,7 @@ int il_alloc_traffic_mem(struct il_priv *il)
 {
 	u32 traffic_size = IL_TRAFFIC_DUMP_SIZE;
 
-	if (iwlegacy_debug_level & IL_DL_TX) {
+	if (il_debug_level & IL_DL_TX) {
 		if (!il->tx_traffic) {
 			il->tx_traffic =
 				kzalloc(traffic_size, GFP_KERNEL);
@@ -1494,7 +1494,7 @@ int il_alloc_traffic_mem(struct il_priv *il)
 				return -ENOMEM;
 		}
 	}
-	if (iwlegacy_debug_level & IL_DL_RX) {
+	if (il_debug_level & IL_DL_RX) {
 		if (!il->rx_traffic) {
 			il->rx_traffic =
 				kzalloc(traffic_size, GFP_KERNEL);
@@ -1523,7 +1523,7 @@ void il_dbg_log_tx_data_frame(struct il_priv *il,
 	__le16 fc;
 	u16 len;
 
-	if (likely(!(iwlegacy_debug_level & IL_DL_TX)))
+	if (likely(!(il_debug_level & IL_DL_TX)))
 		return;
 
 	if (!il->tx_traffic)
@@ -1548,7 +1548,7 @@ void il_dbg_log_rx_data_frame(struct il_priv *il,
 	__le16 fc;
 	u16 len;
 
-	if (likely(!(iwlegacy_debug_level & IL_DL_RX)))
+	if (likely(!(il_debug_level & IL_DL_RX)))
 		return;
 
 	if (!il->rx_traffic)
diff --git a/drivers/net/wireless/iwlegacy/iwl-debug.h b/drivers/net/wireless/iwlegacy/iwl-debug.h
index 657da25..05a7933 100644
--- a/drivers/net/wireless/iwlegacy/iwl-debug.h
+++ b/drivers/net/wireless/iwlegacy/iwl-debug.h
@@ -30,7 +30,7 @@
 #define __il_debug_h__
 
 struct il_priv;
-extern u32 iwlegacy_debug_level;
+extern u32 il_debug_level;
 
 #define IL_ERR(p, f, a...) dev_err(&((p)->pci_dev->dev), f, ## a)
 #define IL_WARN(p, f, a...) dev_warn(&((p)->pci_dev->dev), f, ## a)
diff --git a/drivers/net/wireless/iwlegacy/iwl-debugfs.c b/drivers/net/wireless/iwlegacy/iwl-debugfs.c
index f2f2eba..a811c17 100644
--- a/drivers/net/wireless/iwlegacy/iwl-debugfs.c
+++ b/drivers/net/wireless/iwlegacy/iwl-debugfs.c
@@ -705,7 +705,7 @@ static ssize_t il_dbgfs_traffic_log_read(struct file *file,
 				"q[%d]: read_ptr: %u, write_ptr: %u\n",
 				cnt, q->read_ptr, q->write_ptr);
 	}
-	if (il->tx_traffic && (iwlegacy_debug_level & IL_DL_TX)) {
+	if (il->tx_traffic && (il_debug_level & IL_DL_TX)) {
 		ptr = il->tx_traffic;
 		pos += scnprintf(buf + pos, bufsz - pos,
 				"Tx Traffic idx: %u\n",	il->tx_traffic_idx);
@@ -728,7 +728,7 @@ static ssize_t il_dbgfs_traffic_log_read(struct file *file,
 			"read: %u, write: %u\n",
 			 rxq->read, rxq->write);
 
-	if (il->rx_traffic && (iwlegacy_debug_level & IL_DL_RX)) {
+	if (il->rx_traffic && (il_debug_level & IL_DL_RX)) {
 		ptr = il->rx_traffic;
 		pos += scnprintf(buf + pos, bufsz - pos,
 				"Rx Traffic idx: %u\n",	il->rx_traffic_idx);
diff --git a/drivers/net/wireless/iwlegacy/iwl-dev.h b/drivers/net/wireless/iwlegacy/iwl-dev.h
index 824d193..2e2e3f3 100644
--- a/drivers/net/wireless/iwlegacy/iwl-dev.h
+++ b/drivers/net/wireless/iwlegacy/iwl-dev.h
@@ -626,7 +626,7 @@ struct il_hw_params {
  *
  ****************************************************************************/
 extern void il4965_update_chain_flags(struct il_priv *il);
-extern const u8 iwlegacy_bcast_addr[ETH_ALEN];
+extern const u8 il_bcast_addr[ETH_ALEN];
 extern int il_queue_space(const struct il_queue *q);
 static inline int il_queue_used(const struct il_queue *q, int i)
 {
@@ -1220,7 +1220,7 @@ struct il_priv {
 #ifdef CONFIG_IWLWIFI_LEGACY_DEBUG
 	/* debugging info */
 	u32 debug_level; /* per device debugging will override global
-			    iwlegacy_debug_level if set */
+			    il_debug_level if set */
 #endif /* CONFIG_IWLWIFI_LEGACY_DEBUG */
 #ifdef CONFIG_IWLWIFI_LEGACY_DEBUGFS
 	/* debugfs */
@@ -1270,12 +1270,12 @@ static inline u32 il_get_debug_level(struct il_priv *il)
 	if (il->debug_level)
 		return il->debug_level;
 	else
-		return iwlegacy_debug_level;
+		return il_debug_level;
 }
 #else
 static inline u32 il_get_debug_level(struct il_priv *il)
 {
-	return iwlegacy_debug_level;
+	return il_debug_level;
 }
 #endif
 
diff --git a/drivers/net/wireless/iwlegacy/iwl-eeprom.c b/drivers/net/wireless/iwlegacy/iwl-eeprom.c
index 5edec73..f6b9d6d 100644
--- a/drivers/net/wireless/iwlegacy/iwl-eeprom.c
+++ b/drivers/net/wireless/iwlegacy/iwl-eeprom.c
@@ -77,7 +77,7 @@
 
 /************************** EEPROM BANDS ****************************
  *
- * The iwlegacy_eeprom_band definitions below provide the mapping from the
+ * The il_eeprom_band definitions below provide the mapping from the
  * EEPROM contents to the specific channel number supported for each
  * band.
  *
@@ -107,32 +107,32 @@
  *********************************************************************/
 
 /* 2.4 GHz */
-const u8 iwlegacy_eeprom_band_1[14] = {
+const u8 il_eeprom_band_1[14] = {
 	1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14
 };
 
 /* 5.2 GHz bands */
-static const u8 iwlegacy_eeprom_band_2[] = {	/* 4915-5080MHz */
+static const u8 il_eeprom_band_2[] = {	/* 4915-5080MHz */
 	183, 184, 185, 187, 188, 189, 192, 196, 7, 8, 11, 12, 16
 };
 
-static const u8 iwlegacy_eeprom_band_3[] = {	/* 5170-5320MHz */
+static const u8 il_eeprom_band_3[] = {	/* 5170-5320MHz */
 	34, 36, 38, 40, 42, 44, 46, 48, 52, 56, 60, 64
 };
 
-static const u8 iwlegacy_eeprom_band_4[] = {	/* 5500-5700MHz */
+static const u8 il_eeprom_band_4[] = {	/* 5500-5700MHz */
 	100, 104, 108, 112, 116, 120, 124, 128, 132, 136, 140
 };
 
-static const u8 iwlegacy_eeprom_band_5[] = {	/* 5725-5825MHz */
+static const u8 il_eeprom_band_5[] = {	/* 5725-5825MHz */
 	145, 149, 153, 157, 161, 165
 };
 
-static const u8 iwlegacy_eeprom_band_6[] = {       /* 2.4 ht40 channel */
+static const u8 il_eeprom_band_6[] = {       /* 2.4 ht40 channel */
 	1, 2, 3, 4, 5, 6, 7
 };
 
-static const u8 iwlegacy_eeprom_band_7[] = {       /* 5.2 ht40 channel */
+static const u8 il_eeprom_band_7[] = {       /* 5.2 ht40 channel */
 	36, 44, 52, 60, 100, 108, 116, 124, 132, 149, 157
 };
 
@@ -273,46 +273,46 @@ static void il_init_band_reference(const struct il_priv *il,
 			eeprom_ops.regulatory_bands[eep_band - 1];
 	switch (eep_band) {
 	case 1:		/* 2.4GHz band */
-		*eeprom_ch_count = ARRAY_SIZE(iwlegacy_eeprom_band_1);
+		*eeprom_ch_count = ARRAY_SIZE(il_eeprom_band_1);
 		*eeprom_ch_info = (struct il_eeprom_channel *)
 				il_eeprom_query_addr(il, offset);
-		*eeprom_ch_index = iwlegacy_eeprom_band_1;
+		*eeprom_ch_index = il_eeprom_band_1;
 		break;
 	case 2:		/* 4.9GHz band */
-		*eeprom_ch_count = ARRAY_SIZE(iwlegacy_eeprom_band_2);
+		*eeprom_ch_count = ARRAY_SIZE(il_eeprom_band_2);
 		*eeprom_ch_info = (struct il_eeprom_channel *)
 				il_eeprom_query_addr(il, offset);
-		*eeprom_ch_index = iwlegacy_eeprom_band_2;
+		*eeprom_ch_index = il_eeprom_band_2;
 		break;
 	case 3:		/* 5.2GHz band */
-		*eeprom_ch_count = ARRAY_SIZE(iwlegacy_eeprom_band_3);
+		*eeprom_ch_count = ARRAY_SIZE(il_eeprom_band_3);
 		*eeprom_ch_info = (struct il_eeprom_channel *)
 				il_eeprom_query_addr(il, offset);
-		*eeprom_ch_index = iwlegacy_eeprom_band_3;
+		*eeprom_ch_index = il_eeprom_band_3;
 		break;
 	case 4:		/* 5.5GHz band */
-		*eeprom_ch_count = ARRAY_SIZE(iwlegacy_eeprom_band_4);
+		*eeprom_ch_count = ARRAY_SIZE(il_eeprom_band_4);
 		*eeprom_ch_info = (struct il_eeprom_channel *)
 				il_eeprom_query_addr(il, offset);
-		*eeprom_ch_index = iwlegacy_eeprom_band_4;
+		*eeprom_ch_index = il_eeprom_band_4;
 		break;
 	case 5:		/* 5.7GHz band */
-		*eeprom_ch_count = ARRAY_SIZE(iwlegacy_eeprom_band_5);
+		*eeprom_ch_count = ARRAY_SIZE(il_eeprom_band_5);
 		*eeprom_ch_info = (struct il_eeprom_channel *)
 				il_eeprom_query_addr(il, offset);
-		*eeprom_ch_index = iwlegacy_eeprom_band_5;
+		*eeprom_ch_index = il_eeprom_band_5;
 		break;
 	case 6:		/* 2.4GHz ht40 channels */
-		*eeprom_ch_count = ARRAY_SIZE(iwlegacy_eeprom_band_6);
+		*eeprom_ch_count = ARRAY_SIZE(il_eeprom_band_6);
 		*eeprom_ch_info = (struct il_eeprom_channel *)
 				il_eeprom_query_addr(il, offset);
-		*eeprom_ch_index = iwlegacy_eeprom_band_6;
+		*eeprom_ch_index = il_eeprom_band_6;
 		break;
 	case 7:		/* 5 GHz ht40 channels */
-		*eeprom_ch_count = ARRAY_SIZE(iwlegacy_eeprom_band_7);
+		*eeprom_ch_count = ARRAY_SIZE(il_eeprom_band_7);
 		*eeprom_ch_info = (struct il_eeprom_channel *)
 				il_eeprom_query_addr(il, offset);
-		*eeprom_ch_index = iwlegacy_eeprom_band_7;
+		*eeprom_ch_index = il_eeprom_band_7;
 		break;
 	default:
 		BUG();
@@ -387,11 +387,11 @@ int il_init_channel_map(struct il_priv *il)
 	IL_DEBUG_EEPROM(il, "Initializing regulatory info from EEPROM\n");
 
 	il->channel_count =
-	    ARRAY_SIZE(iwlegacy_eeprom_band_1) +
-	    ARRAY_SIZE(iwlegacy_eeprom_band_2) +
-	    ARRAY_SIZE(iwlegacy_eeprom_band_3) +
-	    ARRAY_SIZE(iwlegacy_eeprom_band_4) +
-	    ARRAY_SIZE(iwlegacy_eeprom_band_5);
+	    ARRAY_SIZE(il_eeprom_band_1) +
+	    ARRAY_SIZE(il_eeprom_band_2) +
+	    ARRAY_SIZE(il_eeprom_band_3) +
+	    ARRAY_SIZE(il_eeprom_band_4) +
+	    ARRAY_SIZE(il_eeprom_band_5);
 
 	IL_DEBUG_EEPROM(il, "Parsing data for %d channels.\n",
 			il->channel_count);
diff --git a/drivers/net/wireless/iwlegacy/iwl-eeprom.h b/drivers/net/wireless/iwlegacy/iwl-eeprom.h
index acb5ec1..b97c837 100644
--- a/drivers/net/wireless/iwlegacy/iwl-eeprom.h
+++ b/drivers/net/wireless/iwlegacy/iwl-eeprom.h
@@ -144,7 +144,7 @@ struct il_eeprom_channel {
 #define EEPROM_4965_BOARD_PBA                  (2*0x56+1) /* 9 bytes */
 
 /* 2.4 GHz */
-extern const u8 iwlegacy_eeprom_band_1[14];
+extern const u8 il_eeprom_band_1[14];
 
 /*
  * factory calibration data for one txpower level, on one channel,
diff --git a/drivers/net/wireless/iwlegacy/iwl-legacy-rs.h b/drivers/net/wireless/iwlegacy/iwl-legacy-rs.h
index 4282ed5..744829a 100644
--- a/drivers/net/wireless/iwlegacy/iwl-legacy-rs.h
+++ b/drivers/net/wireless/iwlegacy/iwl-legacy-rs.h
@@ -56,7 +56,7 @@ struct il3945_rate_info {
 
 /*
  * These serve as indexes into
- * struct il_rate_info iwlegacy_rates[IL_RATE_COUNT];
+ * struct il_rate_info il_rates[IL_RATE_COUNT];
  */
 enum {
 	IL_RATE_1M_INDEX = 0,
@@ -268,7 +268,7 @@ enum {
 #define TID_MAX_TIME_DIFF ((TID_QUEUE_MAX_SIZE - 1) * TID_QUEUE_CELL_SPACING)
 #define TIME_WRAP_AROUND(x, y) (((y) > (x)) ? (y) - (x) : (0-(x)) + (y))
 
-extern const struct il_rate_info iwlegacy_rates[IL_RATE_COUNT];
+extern const struct il_rate_info il_rates[IL_RATE_COUNT];
 
 enum il_table_type {
 	LQ_NONE,
diff --git a/drivers/net/wireless/iwlegacy/iwl-scan.c b/drivers/net/wireless/iwlegacy/iwl-scan.c
index 0184d5b..5a967d2 100644
--- a/drivers/net/wireless/iwlegacy/iwl-scan.c
+++ b/drivers/net/wireless/iwlegacy/iwl-scan.c
@@ -442,9 +442,9 @@ il_fill_probe_req(struct il_priv *il, struct ieee80211_mgmt *frame,
 		return 0;
 
 	frame->frame_control = cpu_to_le16(IEEE80211_STYPE_PROBE_REQ);
-	memcpy(frame->da, iwlegacy_bcast_addr, ETH_ALEN);
+	memcpy(frame->da, il_bcast_addr, ETH_ALEN);
 	memcpy(frame->sa, ta, ETH_ALEN);
-	memcpy(frame->bssid, iwlegacy_bcast_addr, ETH_ALEN);
+	memcpy(frame->bssid, il_bcast_addr, ETH_ALEN);
 	frame->seq_ctrl = 0;
 
 	len += 24;
diff --git a/drivers/net/wireless/iwlegacy/iwl3945-base.c b/drivers/net/wireless/iwlegacy/iwl3945-base.c
index 2c336a7..af3f194 100644
--- a/drivers/net/wireless/iwlegacy/iwl3945-base.c
+++ b/drivers/net/wireless/iwlegacy/iwl3945-base.c
@@ -2378,7 +2378,7 @@ static int il3945_alloc_bcast_station(struct il_priv *il)
 
 	spin_lock_irqsave(&il->sta_lock, flags);
 	sta_id = il_prep_station(il, ctx,
-					iwlegacy_bcast_addr, false, NULL);
+					il_bcast_addr, false, NULL);
 	if (sta_id == IL_INVALID_STATION) {
 		IL_ERR(il, "Unable to prepare broadcast station\n");
 		spin_unlock_irqrestore(&il->sta_lock, flags);
@@ -4003,7 +4003,7 @@ module_param_named(disable_hw_scan, il3945_mod_params.disable_hw_scan,
 		int, S_IRUGO);
 MODULE_PARM_DESC(disable_hw_scan, "disable hardware scanning (default 1)");
 #ifdef CONFIG_IWLWIFI_LEGACY_DEBUG
-module_param_named(debug, iwlegacy_debug_level, uint, S_IRUGO | S_IWUSR);
+module_param_named(debug, il_debug_level, uint, S_IRUGO | S_IWUSR);
 MODULE_PARM_DESC(debug, "debug output mask");
 #endif
 module_param_named(fw_restart, il3945_mod_params.restart_fw, int, S_IRUGO);
diff --git a/drivers/net/wireless/iwlegacy/iwl4965-base.c b/drivers/net/wireless/iwlegacy/iwl4965-base.c
index ae8a937..d4eacc3 100644
--- a/drivers/net/wireless/iwlegacy/iwl4965-base.c
+++ b/drivers/net/wireless/iwlegacy/iwl4965-base.c
@@ -2712,7 +2712,7 @@ static void il4965_init_hw_rates(struct il_priv *il,
 	int i;
 
 	for (i = 0; i < IL_RATE_COUNT_LEGACY; i++) {
-		rates[i].bitrate = iwlegacy_rates[i].ieee * 5;
+		rates[i].bitrate = il_rates[i].ieee * 5;
 		rates[i].hw_value = i; /* Rate scaling will work on indexes */
 		rates[i].hw_value_short = i;
 		rates[i].flags = 0;
@@ -2721,7 +2721,7 @@ static void il4965_init_hw_rates(struct il_priv *il,
 			 * If CCK != 1M then set short preamble rate flag.
 			 */
 			rates[i].flags |=
-				(iwlegacy_rates[i].plcp == IL_RATE_1M_PLCP) ?
+				(il_rates[i].plcp == IL_RATE_1M_PLCP) ?
 					0 : IEEE80211_RATE_SHORT_PREAMBLE;
 		}
 	}
@@ -3259,7 +3259,7 @@ module_exit(il4965_exit);
 module_init(il4965_init);
 
 #ifdef CONFIG_IWLWIFI_LEGACY_DEBUG
-module_param_named(debug, iwlegacy_debug_level, uint, S_IRUGO | S_IWUSR);
+module_param_named(debug, il_debug_level, uint, S_IRUGO | S_IWUSR);
 MODULE_PARM_DESC(debug, "debug output mask");
 #endif
 
-- 
1.7.1

