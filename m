Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:60714 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932554Ab0EMVuU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 May 2010 17:50:20 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 10/17] iwlagn: use firmware event/error log information
Date: Thu, 13 May 2010 14:49:52 -0700
Message-Id: <1273787399-9280-11-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1273787399-9280-1-git-send-email-reinette.chatre@intel.com>
References: <1273787399-9280-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

In order to debug problems before the ALIVE
notification is received, new firmware files
contain the event/error log information in
the file. Use that information.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c |  102 ++++++++++++++++++++++++++++----
 drivers/net/wireless/iwlwifi/iwl-dev.h |    9 +++
 2 files changed, 99 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index f62a345..845d0ee 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -1543,6 +1543,9 @@ struct iwlagn_firmware_pieces {
 	size_t inst_size, data_size, init_size, init_data_size, boot_size;
 
 	u32 build;
+
+	u32 init_evtlog_ptr, init_evtlog_size, init_errlog_ptr;
+	u32 inst_evtlog_ptr, inst_evtlog_size, inst_errlog_ptr;
 };
 
 static int iwlagn_load_legacy_firmware(struct iwl_priv *priv,
@@ -1720,6 +1723,42 @@ static int iwlagn_load_firmware(struct iwl_priv *priv,
 			capa->max_probe_length =
 				le32_to_cpup((__le32 *)tlv_data);
 			break;
+		case IWL_UCODE_TLV_INIT_EVTLOG_PTR:
+			if (tlv_len != 4)
+				return -EINVAL;
+			pieces->init_evtlog_ptr =
+				le32_to_cpup((__le32 *)tlv_data);
+			break;
+		case IWL_UCODE_TLV_INIT_EVTLOG_SIZE:
+			if (tlv_len != 4)
+				return -EINVAL;
+			pieces->init_evtlog_size =
+				le32_to_cpup((__le32 *)tlv_data);
+			break;
+		case IWL_UCODE_TLV_INIT_ERRLOG_PTR:
+			if (tlv_len != 4)
+				return -EINVAL;
+			pieces->init_errlog_ptr =
+				le32_to_cpup((__le32 *)tlv_data);
+			break;
+		case IWL_UCODE_TLV_RUNT_EVTLOG_PTR:
+			if (tlv_len != 4)
+				return -EINVAL;
+			pieces->inst_evtlog_ptr =
+				le32_to_cpup((__le32 *)tlv_data);
+			break;
+		case IWL_UCODE_TLV_RUNT_EVTLOG_SIZE:
+			if (tlv_len != 4)
+				return -EINVAL;
+			pieces->inst_evtlog_size =
+				le32_to_cpup((__le32 *)tlv_data);
+			break;
+		case IWL_UCODE_TLV_RUNT_ERRLOG_PTR:
+			if (tlv_len != 4)
+				return -EINVAL;
+			pieces->inst_errlog_ptr =
+				le32_to_cpup((__le32 *)tlv_data);
+			break;
 		default:
 			break;
 		}
@@ -1912,6 +1951,26 @@ static void iwl_ucode_callback(const struct firmware *ucode_raw, void *context)
 			goto err_pci_alloc;
 	}
 
+	/* Now that we can no longer fail, copy information */
+
+	/*
+	 * The (size - 16) / 12 formula is based on the information recorded
+	 * for each event, which is of mode 1 (including timestamp) for all
+	 * new microcodes that include this information.
+	 */
+	priv->_agn.init_evtlog_ptr = pieces.init_evtlog_ptr;
+	if (pieces.init_evtlog_size)
+		priv->_agn.init_evtlog_size = (pieces.init_evtlog_size - 16)/12;
+	else
+		priv->_agn.init_evtlog_size = priv->cfg->max_event_log_size;
+	priv->_agn.init_errlog_ptr = pieces.init_errlog_ptr;
+	priv->_agn.inst_evtlog_ptr = pieces.inst_evtlog_ptr;
+	if (pieces.inst_evtlog_size)
+		priv->_agn.inst_evtlog_size = (pieces.inst_evtlog_size - 16)/12;
+	else
+		priv->_agn.inst_evtlog_size = priv->cfg->max_event_log_size;
+	priv->_agn.inst_errlog_ptr = pieces.inst_errlog_ptr;
+
 	/* Copy images into buffers for card's bus-master reads ... */
 
 	/* Runtime instructions (first block of data in file) */
@@ -2037,10 +2096,15 @@ void iwl_dump_nic_error_log(struct iwl_priv *priv)
 	u32 blink1, blink2, ilink1, ilink2;
 	u32 pc, hcmd;
 
-	if (priv->ucode_type == UCODE_INIT)
+	if (priv->ucode_type == UCODE_INIT) {
 		base = le32_to_cpu(priv->card_alive_init.error_event_table_ptr);
-	else
+		if (!base)
+			base = priv->_agn.init_errlog_ptr;
+	} else {
 		base = le32_to_cpu(priv->card_alive.error_event_table_ptr);
+		if (!base)
+			base = priv->_agn.inst_errlog_ptr;
+	}
 
 	if (!priv->cfg->ops->lib->is_valid_rtc_data_addr(base)) {
 		IWL_ERR(priv,
@@ -2100,10 +2164,16 @@ static int iwl_print_event_log(struct iwl_priv *priv, u32 start_idx,
 
 	if (num_events == 0)
 		return pos;
-	if (priv->ucode_type == UCODE_INIT)
+
+	if (priv->ucode_type == UCODE_INIT) {
 		base = le32_to_cpu(priv->card_alive_init.log_event_table_ptr);
-	else
+		if (!base)
+			base = priv->_agn.init_evtlog_ptr;
+	} else {
 		base = le32_to_cpu(priv->card_alive.log_event_table_ptr);
+		if (!base)
+			base = priv->_agn.inst_evtlog_ptr;
+	}
 
 	if (mode == 0)
 		event_size = 2 * sizeof(u32);
@@ -2205,13 +2275,21 @@ int iwl_dump_nic_event_log(struct iwl_priv *priv, bool full_log,
 	u32 num_wraps;  /* # times uCode wrapped to top of log */
 	u32 next_entry; /* index of next entry to be written by uCode */
 	u32 size;       /* # entries that we'll print */
+	u32 logsize;
 	int pos = 0;
 	size_t bufsz = 0;
 
-	if (priv->ucode_type == UCODE_INIT)
+	if (priv->ucode_type == UCODE_INIT) {
 		base = le32_to_cpu(priv->card_alive_init.log_event_table_ptr);
-	else
+		logsize = priv->_agn.init_evtlog_size;
+		if (!base)
+			base = priv->_agn.init_evtlog_ptr;
+	} else {
 		base = le32_to_cpu(priv->card_alive.log_event_table_ptr);
+		logsize = priv->_agn.inst_evtlog_size;
+		if (!base)
+			base = priv->_agn.inst_evtlog_ptr;
+	}
 
 	if (!priv->cfg->ops->lib->is_valid_rtc_data_addr(base)) {
 		IWL_ERR(priv,
@@ -2226,16 +2304,16 @@ int iwl_dump_nic_event_log(struct iwl_priv *priv, bool full_log,
 	num_wraps = iwl_read_targ_mem(priv, base + (2 * sizeof(u32)));
 	next_entry = iwl_read_targ_mem(priv, base + (3 * sizeof(u32)));
 
-	if (capacity > priv->cfg->max_event_log_size) {
+	if (capacity > logsize) {
 		IWL_ERR(priv, "Log capacity %d is bogus, limit to %d entries\n",
-			capacity, priv->cfg->max_event_log_size);
-		capacity = priv->cfg->max_event_log_size;
+			capacity, logsize);
+		capacity = logsize;
 	}
 
-	if (next_entry > priv->cfg->max_event_log_size) {
+	if (next_entry > logsize) {
 		IWL_ERR(priv, "Log write index %d is bogus, limit to %d\n",
-			next_entry, priv->cfg->max_event_log_size);
-		next_entry = priv->cfg->max_event_log_size;
+			next_entry, logsize);
+		next_entry = logsize;
 	}
 
 	size = num_wraps ? capacity : next_entry;
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 5ac03f5..fdd0430 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -583,6 +583,12 @@ enum iwl_ucode_tlv_type {
 	IWL_UCODE_TLV_INIT_DATA		= 4,
 	IWL_UCODE_TLV_BOOT		= 5,
 	IWL_UCODE_TLV_PROBE_MAX_LEN	= 6, /* a u32 value */
+	IWL_UCODE_TLV_RUNT_EVTLOG_PTR	= 8,
+	IWL_UCODE_TLV_RUNT_EVTLOG_SIZE	= 9,
+	IWL_UCODE_TLV_RUNT_ERRLOG_PTR	= 10,
+	IWL_UCODE_TLV_INIT_EVTLOG_PTR	= 11,
+	IWL_UCODE_TLV_INIT_EVTLOG_SIZE	= 12,
+	IWL_UCODE_TLV_INIT_ERRLOG_PTR	= 13,
 };
 
 struct iwl_ucode_tlv {
@@ -1317,6 +1323,9 @@ struct iwl_priv {
 			struct iwl_notif_statistics delta_statistics;
 			struct iwl_notif_statistics max_delta;
 #endif
+
+			u32 init_evtlog_ptr, init_evtlog_size, init_errlog_ptr;
+			u32 inst_evtlog_ptr, inst_evtlog_size, inst_errlog_ptr;
 		} _agn;
 #endif
 	};
-- 
1.6.3.3

