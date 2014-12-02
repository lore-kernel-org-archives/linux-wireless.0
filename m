Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f53.google.com ([74.125.82.53]:52614 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932569AbaLBSLz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Dec 2014 13:11:55 -0500
Received: by mail-wg0-f53.google.com with SMTP id l18so17759814wgh.40
        for <linux-wireless@vger.kernel.org>; Tue, 02 Dec 2014 10:11:54 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Liad Kaufman <liad.kaufman@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 22/26] iwlwifi: define the .ucode file format for debug
Date: Tue,  2 Dec 2014 20:11:13 +0200
Message-Id: <1417543877-24193-22-git-send-email-egrumbach@gmail.com> (sfid-20141202_191210_652396_F77910BC)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB31B5A7D27@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB31B5A7D27@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Liad Kaufman <liad.kaufman@intel.com>

Debug information can be appended to the firmware file. This
information will be used by the driver to enable / disable
debugging features in the firmware.

Signed-off-by: Liad Kaufman <liad.kaufman@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-drv.c     | 121 ++++++++++++++++++++++++----
 drivers/net/wireless/iwlwifi/iwl-fw-file.h | 124 +++++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-fw.h      |  55 +++++++++++++
 3 files changed, 285 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-drv.c b/drivers/net/wireless/iwlwifi/iwl-drv.c
index 2c6e830..a53b534 100644
--- a/drivers/net/wireless/iwlwifi/iwl-drv.c
+++ b/drivers/net/wireless/iwlwifi/iwl-drv.c
@@ -184,6 +184,11 @@ static void iwl_free_fw_img(struct iwl_drv *drv, struct fw_img *img)
 static void iwl_dealloc_ucode(struct iwl_drv *drv)
 {
 	int i;
+
+	kfree(drv->fw.dbg_dest_tlv);
+	for (i = 0; i < ARRAY_SIZE(drv->fw.dbg_conf_tlv); i++)
+		kfree(drv->fw.dbg_conf_tlv[i]);
+
 	for (i = 0; i < IWL_UCODE_TYPE_MAX; i++)
 		iwl_free_fw_img(drv, drv->fw.img + i);
 }
@@ -308,6 +313,11 @@ struct iwl_firmware_pieces {
 
 	u32 init_evtlog_ptr, init_evtlog_size, init_errlog_ptr;
 	u32 inst_evtlog_ptr, inst_evtlog_size, inst_errlog_ptr;
+
+	/* FW debug data parsed for driver usage */
+	struct iwl_fw_dbg_dest_tlv *dbg_dest_tlv;
+	struct iwl_fw_dbg_conf_tlv *dbg_conf_tlv[FW_DBG_MAX];
+	size_t dbg_conf_tlv_len[FW_DBG_MAX];
 };
 
 /*
@@ -853,6 +863,58 @@ static int iwl_parse_tlv_firmware(struct iwl_drv *drv,
 			capa->n_scan_channels =
 				le32_to_cpup((__le32 *)tlv_data);
 			break;
+		case IWL_UCODE_TLV_FW_DBG_DEST: {
+			struct iwl_fw_dbg_dest_tlv *dest = (void *)tlv_data;
+
+			if (pieces->dbg_dest_tlv) {
+				IWL_ERR(drv,
+					"dbg destination ignored, already exists\n");
+				break;
+			}
+
+			pieces->dbg_dest_tlv = dest;
+			IWL_INFO(drv, "Found debug destination: %s\n",
+				 get_fw_dbg_mode_string(dest->monitor_mode));
+
+			drv->fw.dbg_dest_reg_num =
+				tlv_len - offsetof(struct iwl_fw_dbg_dest_tlv,
+						   reg_ops);
+			drv->fw.dbg_dest_reg_num /=
+				sizeof(drv->fw.dbg_dest_tlv->reg_ops[0]);
+
+			break;
+			}
+		case IWL_UCODE_TLV_FW_DBG_CONF: {
+			struct iwl_fw_dbg_conf_tlv *conf = (void *)tlv_data;
+
+			if (!pieces->dbg_dest_tlv) {
+				IWL_ERR(drv,
+					"Ignore dbg config %d - no destination configured\n",
+					conf->id);
+				break;
+			}
+
+			if (conf->id >= ARRAY_SIZE(drv->fw.dbg_conf_tlv)) {
+				IWL_ERR(drv,
+					"Skip unknown configuration: %d\n",
+					conf->id);
+				break;
+			}
+
+			if (pieces->dbg_conf_tlv[conf->id]) {
+				IWL_ERR(drv,
+					"Ignore duplicate dbg config %d\n",
+					conf->id);
+				break;
+			}
+
+			IWL_INFO(drv, "Found debug configuration: %d\n",
+				 conf->id);
+
+			pieces->dbg_conf_tlv[conf->id] = conf;
+			pieces->dbg_conf_tlv_len[conf->id] = tlv_len;
+			break;
+			}
 		default:
 			IWL_DEBUG_INFO(drv, "unknown TLV: %d\n", tlv_type);
 			break;
@@ -996,7 +1058,7 @@ static void iwl_req_fw_callback(const struct firmware *ucode_raw, void *context)
 	struct iwl_ucode_header *ucode;
 	struct iwlwifi_opmode_table *op;
 	int err;
-	struct iwl_firmware_pieces pieces;
+	struct iwl_firmware_pieces *pieces;
 	const unsigned int api_max = drv->cfg->ucode_api_max;
 	unsigned int api_ok = drv->cfg->ucode_api_ok;
 	const unsigned int api_min = drv->cfg->ucode_api_min;
@@ -1013,7 +1075,9 @@ static void iwl_req_fw_callback(const struct firmware *ucode_raw, void *context)
 	if (!api_ok)
 		api_ok = api_max;
 
-	memset(&pieces, 0, sizeof(pieces));
+	pieces = kzalloc(sizeof(*pieces), GFP_KERNEL);
+	if (!pieces)
+		return;
 
 	if (!ucode_raw) {
 		if (drv->fw_index <= api_ok)
@@ -1036,10 +1100,10 @@ static void iwl_req_fw_callback(const struct firmware *ucode_raw, void *context)
 	ucode = (struct iwl_ucode_header *)ucode_raw->data;
 
 	if (ucode->ver)
-		err = iwl_parse_v1_v2_firmware(drv, ucode_raw, &pieces);
+		err = iwl_parse_v1_v2_firmware(drv, ucode_raw, pieces);
 	else
-		err = iwl_parse_tlv_firmware(drv, ucode_raw, &pieces,
-					   &fw->ucode_capa);
+		err = iwl_parse_tlv_firmware(drv, ucode_raw, pieces,
+					     &fw->ucode_capa);
 
 	if (err)
 		goto try_again;
@@ -1079,7 +1143,7 @@ static void iwl_req_fw_callback(const struct firmware *ucode_raw, void *context)
 	 * In mvm uCode there is no difference between data and instructions
 	 * sections.
 	 */
-	if (!fw->mvm_fw && validate_sec_sizes(drv, &pieces, drv->cfg))
+	if (!fw->mvm_fw && validate_sec_sizes(drv, pieces, drv->cfg))
 		goto try_again;
 
 	/* Allocate ucode buffers for card's bus-master loading ... */
@@ -1088,9 +1152,33 @@ static void iwl_req_fw_callback(const struct firmware *ucode_raw, void *context)
 	 * 1) unmodified from disk
 	 * 2) backup cache for save/restore during power-downs */
 	for (i = 0; i < IWL_UCODE_TYPE_MAX; i++)
-		if (iwl_alloc_ucode(drv, &pieces, i))
+		if (iwl_alloc_ucode(drv, pieces, i))
 			goto out_free_fw;
 
+	if (pieces->dbg_dest_tlv) {
+		drv->fw.dbg_dest_tlv =
+			kmemdup(pieces->dbg_dest_tlv,
+				sizeof(*pieces->dbg_dest_tlv) +
+				sizeof(pieces->dbg_dest_tlv->reg_ops[0]) *
+				drv->fw.dbg_dest_reg_num, GFP_KERNEL);
+
+		if (!drv->fw.dbg_dest_tlv)
+			goto out_free_fw;
+	}
+
+	for (i = 0; i < ARRAY_SIZE(drv->fw.dbg_conf_tlv); i++) {
+		if (pieces->dbg_conf_tlv[i]) {
+			drv->fw.dbg_conf_tlv_len[i] =
+				pieces->dbg_conf_tlv_len[i];
+			drv->fw.dbg_conf_tlv[i] =
+				kmemdup(pieces->dbg_conf_tlv[i],
+					drv->fw.dbg_conf_tlv_len[i],
+					GFP_KERNEL);
+			if (!drv->fw.dbg_conf_tlv[i])
+				goto out_free_fw;
+		}
+	}
+
 	/* Now that we can no longer fail, copy information */
 
 	/*
@@ -1098,20 +1186,20 @@ static void iwl_req_fw_callback(const struct firmware *ucode_raw, void *context)
 	 * for each event, which is of mode 1 (including timestamp) for all
 	 * new microcodes that include this information.
 	 */
-	fw->init_evtlog_ptr = pieces.init_evtlog_ptr;
-	if (pieces.init_evtlog_size)
-		fw->init_evtlog_size = (pieces.init_evtlog_size - 16)/12;
+	fw->init_evtlog_ptr = pieces->init_evtlog_ptr;
+	if (pieces->init_evtlog_size)
+		fw->init_evtlog_size = (pieces->init_evtlog_size - 16)/12;
 	else
 		fw->init_evtlog_size =
 			drv->cfg->base_params->max_event_log_size;
-	fw->init_errlog_ptr = pieces.init_errlog_ptr;
-	fw->inst_evtlog_ptr = pieces.inst_evtlog_ptr;
-	if (pieces.inst_evtlog_size)
-		fw->inst_evtlog_size = (pieces.inst_evtlog_size - 16)/12;
+	fw->init_errlog_ptr = pieces->init_errlog_ptr;
+	fw->inst_evtlog_ptr = pieces->inst_evtlog_ptr;
+	if (pieces->inst_evtlog_size)
+		fw->inst_evtlog_size = (pieces->inst_evtlog_size - 16)/12;
 	else
 		fw->inst_evtlog_size =
 			drv->cfg->base_params->max_event_log_size;
-	fw->inst_errlog_ptr = pieces.inst_errlog_ptr;
+	fw->inst_errlog_ptr = pieces->inst_errlog_ptr;
 
 	/*
 	 * figure out the offset of chain noise reset and gain commands
@@ -1213,10 +1301,12 @@ static void iwl_req_fw_callback(const struct firmware *ucode_raw, void *context)
 		iwl_req_fw_callback(ucode_raw, context);
 	}
 
+	kfree(pieces);
 	return;
 
  try_again:
 	/* try next, if any */
+	kfree(pieces);
 	release_firmware(ucode_raw);
 	if (iwl_request_firmware(drv, false))
 		goto out_unbind;
@@ -1227,6 +1317,7 @@ static void iwl_req_fw_callback(const struct firmware *ucode_raw, void *context)
 	iwl_dealloc_ucode(drv);
 	release_firmware(ucode_raw);
  out_unbind:
+	kfree(pieces);
 	complete(&drv->request_firmware_complete);
 	device_release_driver(drv->trans->dev);
 }
diff --git a/drivers/net/wireless/iwlwifi/iwl-fw-file.h b/drivers/net/wireless/iwlwifi/iwl-fw-file.h
index df5613a..9faad69 100644
--- a/drivers/net/wireless/iwlwifi/iwl-fw-file.h
+++ b/drivers/net/wireless/iwlwifi/iwl-fw-file.h
@@ -131,6 +131,8 @@ enum iwl_ucode_tlv_type {
 	IWL_UCODE_TLV_API_CHANGES_SET	= 29,
 	IWL_UCODE_TLV_ENABLED_CAPABILITIES	= 30,
 	IWL_UCODE_TLV_N_SCAN_CHANNELS		= 31,
+	IWL_UCODE_TLV_FW_DBG_DEST	= 38,
+	IWL_UCODE_TLV_FW_DBG_CONF	= 39,
 };
 
 struct iwl_ucode_tlv {
@@ -362,4 +364,126 @@ struct iwl_fw_cipher_scheme {
 	u8 hw_cipher;
 } __packed;
 
+enum iwl_fw_dbg_reg_operator {
+	CSR_ASSIGN,
+	CSR_SETBIT,
+	CSR_CLEARBIT,
+
+	PRPH_ASSIGN,
+	PRPH_SETBIT,
+	PRPH_CLEARBIT,
+};
+
+/**
+ * struct iwl_fw_dbg_reg_op - an operation on a register
+ *
+ * @op: %enum iwl_fw_dbg_reg_operator
+ * @addr: offset of the register
+ * @val: value
+ */
+struct iwl_fw_dbg_reg_op {
+	u8 op;
+	u8 reserved[3];
+	__le32 addr;
+	__le32 val;
+} __packed;
+
+/**
+ * enum iwl_fw_dbg_monitor_mode - available monitor recording modes
+ *
+ * @SMEM_MODE: monitor stores the data in SMEM
+ * @EXTERNAL_MODE: monitor stores the data in allocated DRAM
+ * @MARBH_MODE: monitor stores the data in MARBH buffer
+ */
+enum iwl_fw_dbg_monitor_mode {
+	SMEM_MODE = 0,
+	EXTERNAL_MODE = 1,
+	MARBH_MODE = 2,
+};
+
+/**
+ * struct iwl_fw_dbg_dest_tlv - configures the destination of the debug data
+ *
+ * @version: version of the TLV - currently 0
+ * @monitor_mode: %enum iwl_fw_dbg_monitor_mode
+ * @base_reg: addr of the base addr register (PRPH)
+ * @end_reg:  addr of the end addr register (PRPH)
+ * @write_ptr_reg: the addr of the reg of the write pointer
+ * @wrap_count: the addr of the reg of the wrap_count
+ * @base_shift: shift right of the base addr reg
+ * @end_shift: shift right of the end addr reg
+ * @reg_ops: array of registers operations
+ *
+ * This parses IWL_UCODE_TLV_FW_DBG_DEST
+ */
+struct iwl_fw_dbg_dest_tlv {
+	u8 version;
+	u8 monitor_mode;
+	u8 reserved[2];
+	__le32 base_reg;
+	__le32 end_reg;
+	__le32 write_ptr_reg;
+	__le32 wrap_count;
+	u8 base_shift;
+	u8 end_shift;
+	struct iwl_fw_dbg_reg_op reg_ops[0];
+} __packed;
+
+struct iwl_fw_dbg_conf_hcmd {
+	u8 id;
+	u8 reserved;
+	__le16 len;
+	u8 data[0];
+} __packed;
+
+/**
+ * struct iwl_fw_dbg_trigger - a TLV that describes a debug configuration
+ *
+ * @enabled: is this trigger enabled
+ * @reserved:
+ * @len: length, in bytes, of the %trigger field
+ * @trigger: pointer to a trigger struct
+ */
+struct iwl_fw_dbg_trigger {
+	u8 enabled;
+	u8 reserved;
+	u8 len;
+	u8 trigger[0];
+} __packed;
+
+/**
+ * enum iwl_fw_dbg_conf - configurations available
+ *
+ * @FW_DBG_CUSTOM: take this configuration from alive
+ *	Note that the trigger is NO-OP for this configuration
+ */
+enum iwl_fw_dbg_conf {
+	FW_DBG_CUSTOM = 0,
+
+	/* must be last */
+	FW_DBG_MAX,
+	FW_DBG_INVALID = 0xff,
+};
+
+/**
+ * struct iwl_fw_dbg_conf_tlv - a TLV that describes a debug configuration
+ *
+ * @id: %enum iwl_fw_dbg_conf
+ * @usniffer: should the uSniffer image be used
+ * @num_of_hcmds: how many HCMDs to send are present here
+ * @hcmd: a variable length host command to be sent to apply the configuration.
+ *	If there is more than one HCMD to send, they will appear one after the
+ *	other and be sent in the order that they appear in.
+ * This parses IWL_UCODE_TLV_FW_DBG_CONF
+ */
+struct iwl_fw_dbg_conf_tlv {
+	u8 id;
+	u8 usniffer;
+	u8 reserved;
+	u8 num_of_hcmds;
+	struct iwl_fw_dbg_conf_hcmd hcmd;
+
+	/* struct iwl_fw_dbg_trigger sits after all variable length hcmds */
+} __packed;
+
 #endif  /* __iwl_fw_file_h__ */
diff --git a/drivers/net/wireless/iwlwifi/iwl-fw.h b/drivers/net/wireless/iwlwifi/iwl-fw.h
index eaf1ff0..20d44ea 100644
--- a/drivers/net/wireless/iwlwifi/iwl-fw.h
+++ b/drivers/net/wireless/iwlwifi/iwl-fw.h
@@ -150,6 +150,10 @@ struct iwl_fw_cscheme_list {
  * @mvm_fw: indicates this is MVM firmware
  * @cipher_scheme: optional external cipher scheme.
  * @human_readable: human readable version
+ * @dbg_dest_tlv: points to the destination TLV for debug
+ * @dbg_conf_tlv: array of pointers to configuration TLVs for debug
+ * @dbg_conf_tlv_len: lengths of the @dbg_conf_tlv entries
+ * @dbg_dest_reg_num: num of reg_ops in %dbg_dest_tlv
  */
 struct iwl_fw {
 	u32 ucode_ver;
@@ -174,6 +178,57 @@ struct iwl_fw {
 
 	struct ieee80211_cipher_scheme cs[IWL_UCODE_MAX_CS];
 	u8 human_readable[FW_VER_HUMAN_READABLE_SZ];
+
+	struct iwl_fw_dbg_dest_tlv *dbg_dest_tlv;
+	struct iwl_fw_dbg_conf_tlv *dbg_conf_tlv[FW_DBG_MAX];
+	size_t dbg_conf_tlv_len[FW_DBG_MAX];
+
+	u8 dbg_dest_reg_num;
 };
 
+static inline const char *get_fw_dbg_mode_string(int mode)
+{
+	switch (mode) {
+	case SMEM_MODE:
+		return "SMEM";
+	case EXTERNAL_MODE:
+		return "EXTERNAL_DRAM";
+	case MARBH_MODE:
+		return "MARBH";
+	default:
+		return "UNKNOWN";
+	}
+}
+
+static inline const struct iwl_fw_dbg_trigger *
+iwl_fw_dbg_conf_get_trigger(const struct iwl_fw *fw, u8 id)
+{
+	const struct iwl_fw_dbg_conf_tlv *conf_tlv = fw->dbg_conf_tlv[id];
+	u8 *ptr;
+	int i;
+
+	if (!conf_tlv)
+		return NULL;
+
+	ptr = (void *)&conf_tlv->hcmd;
+	for (i = 0; i < conf_tlv->num_of_hcmds; i++) {
+		ptr += sizeof(conf_tlv->hcmd);
+		ptr += le16_to_cpu(conf_tlv->hcmd.len);
+	}
+
+	return (const struct iwl_fw_dbg_trigger *)ptr;
+}
+
+static inline bool
+iwl_fw_dbg_conf_enabled(const struct iwl_fw *fw, u8 id)
+{
+	const struct iwl_fw_dbg_trigger *trigger =
+		iwl_fw_dbg_conf_get_trigger(fw, id);
+
+	if (!trigger)
+		return false;
+
+	return trigger->enabled;
+}
+
 #endif  /* __iwl_fw_h__ */
-- 
1.9.1

