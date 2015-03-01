Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:24100 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752829AbbCATc1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Mar 2015 14:32:27 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 18/31] iwlwifi: mvm: new Alive / error table API
Date: Sun,  1 Mar 2015 21:31:31 +0200
Message-Id: <1425238304-498-18-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150301_203417_969762_34784D73)
In-Reply-To: <1425238186.30202.5.camel@egrumbacBox>
References: <1425238186.30202.5.camel@egrumbacBox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The new API slightly changes the layout of the version of
the firmware - prepare for that.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/dvm/main.c     |   2 +-
 drivers/net/wireless/iwlwifi/iwl-devtrace.h |  18 ++--
 drivers/net/wireless/iwlwifi/iwl-drv.c      |  22 +++-
 drivers/net/wireless/iwlwifi/iwl-fw-file.h  |   6 +-
 drivers/net/wireless/iwlwifi/mvm/fw-api.h   |  26 ++++-
 drivers/net/wireless/iwlwifi/mvm/fw.c       |  49 +++++++--
 drivers/net/wireless/iwlwifi/mvm/utils.c    | 154 ++++++++++++++++++++++++++--
 7 files changed, 245 insertions(+), 32 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/dvm/main.c b/drivers/net/wireless/iwlwifi/dvm/main.c
index c4d6dd7..234e30f 100644
--- a/drivers/net/wireless/iwlwifi/dvm/main.c
+++ b/drivers/net/wireless/iwlwifi/dvm/main.c
@@ -1549,7 +1549,7 @@ static void iwl_dump_nic_error_log(struct iwl_priv *priv)
 				      table.blink1, table.blink2, table.ilink1,
 				      table.ilink2, table.bcon_time, table.gp1,
 				      table.gp2, table.gp3, table.ucode_ver,
-				      table.hw_ver, table.brd_ver);
+				      table.hw_ver, 0, table.brd_ver);
 	IWL_ERR(priv, "0x%08X | %-28s\n", table.error_id,
 		desc_lookup(table.error_id));
 	IWL_ERR(priv, "0x%08X | uPc\n", table.pc);
diff --git a/drivers/net/wireless/iwlwifi/iwl-devtrace.h b/drivers/net/wireless/iwlwifi/iwl-devtrace.h
index 78bd41b..53555a0 100644
--- a/drivers/net/wireless/iwlwifi/iwl-devtrace.h
+++ b/drivers/net/wireless/iwlwifi/iwl-devtrace.h
@@ -431,11 +431,11 @@ TRACE_EVENT(iwlwifi_dev_ucode_error,
 	TP_PROTO(const struct device *dev, u32 desc, u32 tsf_low,
 		 u32 data1, u32 data2, u32 line, u32 blink1,
 		 u32 blink2, u32 ilink1, u32 ilink2, u32 bcon_time,
-		 u32 gp1, u32 gp2, u32 gp3, u32 ucode_ver, u32 hw_ver,
+		 u32 gp1, u32 gp2, u32 gp3, u32 major, u32 minor, u32 hw_ver,
 		 u32 brd_ver),
 	TP_ARGS(dev, desc, tsf_low, data1, data2, line,
 		blink1, blink2, ilink1, ilink2, bcon_time, gp1, gp2,
-		gp3, ucode_ver, hw_ver, brd_ver),
+		gp3, major, minor, hw_ver, brd_ver),
 	TP_STRUCT__entry(
 		DEV_ENTRY
 		__field(u32, desc)
@@ -451,7 +451,8 @@ TRACE_EVENT(iwlwifi_dev_ucode_error,
 		__field(u32, gp1)
 		__field(u32, gp2)
 		__field(u32, gp3)
-		__field(u32, ucode_ver)
+		__field(u32, major)
+		__field(u32, minor)
 		__field(u32, hw_ver)
 		__field(u32, brd_ver)
 	),
@@ -470,21 +471,22 @@ TRACE_EVENT(iwlwifi_dev_ucode_error,
 		__entry->gp1 = gp1;
 		__entry->gp2 = gp2;
 		__entry->gp3 = gp3;
-		__entry->ucode_ver = ucode_ver;
+		__entry->major = major;
+		__entry->minor = minor;
 		__entry->hw_ver = hw_ver;
 		__entry->brd_ver = brd_ver;
 	),
 	TP_printk("[%s] #%02d %010u data 0x%08X 0x%08X line %u, "
 		  "blink 0x%05X 0x%05X ilink 0x%05X 0x%05X "
-		  "bcon_tm %010u gp 0x%08X 0x%08X 0x%08X uCode 0x%08X "
-		  "hw 0x%08X brd 0x%08X",
+		  "bcon_tm %010u gp 0x%08X 0x%08X 0x%08X major 0x%08X "
+		  "minor 0x%08X hw 0x%08X brd 0x%08X",
 		  __get_str(dev), __entry->desc, __entry->tsf_low,
 		  __entry->data1,
 		  __entry->data2, __entry->line, __entry->blink1,
 		  __entry->blink2, __entry->ilink1, __entry->ilink2,
 		  __entry->bcon_time, __entry->gp1, __entry->gp2,
-		  __entry->gp3, __entry->ucode_ver, __entry->hw_ver,
-		  __entry->brd_ver)
+		  __entry->gp3, __entry->major, __entry->minor,
+		  __entry->hw_ver, __entry->brd_ver)
 );
 
 TRACE_EVENT(iwlwifi_dev_ucode_event,
diff --git a/drivers/net/wireless/iwlwifi/iwl-drv.c b/drivers/net/wireless/iwlwifi/iwl-drv.c
index 996e7f1..b608114 100644
--- a/drivers/net/wireless/iwlwifi/iwl-drv.c
+++ b/drivers/net/wireless/iwlwifi/iwl-drv.c
@@ -842,6 +842,23 @@ static int iwl_parse_tlv_firmware(struct iwl_drv *drv,
 			capa->n_scan_channels =
 				le32_to_cpup((__le32 *)tlv_data);
 			break;
+		case IWL_UCODE_TLV_FW_VERSION: {
+			__le32 *ptr = (void *)tlv_data;
+			u32 major, minor;
+			u8 local_comp;
+
+			if (tlv_len != sizeof(u32) * 3)
+				goto invalid_tlv_len;
+
+			major = le32_to_cpup(ptr++);
+			minor = le32_to_cpup(ptr++);
+			local_comp = le32_to_cpup(ptr);
+
+			snprintf(drv->fw.fw_version,
+				 sizeof(drv->fw.fw_version), "%u.%u.%u",
+				 major, minor, local_comp);
+			break;
+			}
 		case IWL_UCODE_TLV_FW_DBG_DEST: {
 			struct iwl_fw_dbg_dest_tlv *dest = (void *)tlv_data;
 
@@ -1107,7 +1124,10 @@ static void iwl_req_fw_callback(const struct firmware *ucode_raw, void *context)
 	if (err)
 		goto try_again;
 
-	api_ver = IWL_UCODE_API(drv->fw.ucode_ver);
+	if (drv->fw.ucode_capa.api[0] & IWL_UCODE_TLV_API_NEW_VERSION)
+		api_ver = drv->fw.ucode_ver;
+	else
+		api_ver = IWL_UCODE_API(drv->fw.ucode_ver);
 
 	/*
 	 * api_ver should match the api version forming part of the
diff --git a/drivers/net/wireless/iwlwifi/iwl-fw-file.h b/drivers/net/wireless/iwlwifi/iwl-fw-file.h
index be4393e..3ec32e8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-fw-file.h
+++ b/drivers/net/wireless/iwlwifi/iwl-fw-file.h
@@ -133,6 +133,7 @@ enum iwl_ucode_tlv_type {
 	IWL_UCODE_TLV_N_SCAN_CHANNELS		= 31,
 	IWL_UCODE_TLV_SEC_RT_USNIFFER	= 34,
 	IWL_UCODE_TLV_SDIO_ADMA_ADDR	= 35,
+	IWL_UCODE_TLV_FW_VERSION	= 36,
 	IWL_UCODE_TLV_FW_DBG_DEST	= 38,
 	IWL_UCODE_TLV_FW_DBG_CONF	= 39,
 };
@@ -156,7 +157,8 @@ struct iwl_tlv_ucode_header {
 	__le32 zero;
 	__le32 magic;
 	u8 human_readable[FW_VER_HUMAN_READABLE_SZ];
-	__le32 ver;		/* major/minor/API/serial */
+	/* major/minor/API/serial or major in new format */
+	__le32 ver;
 	__le32 build;
 	__le64 ignore;
 	/*
@@ -250,6 +252,7 @@ enum iwl_ucode_tlv_flag {
  * @IWL_UCODE_TLV_API_ASYNC_DTM: Async temperature notifications are supported.
  * @IWL_UCODE_TLV_API_LQ_SS_PARAMS: Configure STBC/BFER via LQ CMD ss_params
  * @IWL_UCODE_TLV_API_STATS_V10: uCode supports/uses statistics API version 10
+ * @IWL_UCODE_TLV_API_NEW_VERSION: new versioning format
  */
 enum iwl_ucode_tlv_api {
 	IWL_UCODE_TLV_API_BT_COEX_SPLIT         = BIT(3),
@@ -263,6 +266,7 @@ enum iwl_ucode_tlv_api {
 	IWL_UCODE_TLV_API_ASYNC_DTM		= BIT(17),
 	IWL_UCODE_TLV_API_LQ_SS_PARAMS		= BIT(18),
 	IWL_UCODE_TLV_API_STATS_V10		= BIT(19),
+	IWL_UCODE_TLV_API_NEW_VERSION		= BIT(20),
 };
 
 /**
diff --git a/drivers/net/wireless/iwlwifi/mvm/fw-api.h b/drivers/net/wireless/iwlwifi/mvm/fw-api.h
index c43e5c2..d95b472 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw-api.h
+++ b/drivers/net/wireless/iwlwifi/mvm/fw-api.h
@@ -432,7 +432,7 @@ enum {
 
 #define IWL_ALIVE_FLG_RFKILL	BIT(0)
 
-struct mvm_alive_resp {
+struct mvm_alive_resp_ver1 {
 	__le16 status;
 	__le16 flags;
 	u8 ucode_minor;
@@ -483,6 +483,30 @@ struct mvm_alive_resp_ver2 {
 	__le32 dbg_print_buff_addr;
 } __packed; /* ALIVE_RES_API_S_VER_2 */
 
+struct mvm_alive_resp {
+	__le16 status;
+	__le16 flags;
+	__le32 ucode_minor;
+	__le32 ucode_major;
+	u8 ver_subtype;
+	u8 ver_type;
+	u8 mac;
+	u8 opt;
+	__le32 timestamp;
+	__le32 error_event_table_ptr;	/* SRAM address for error log */
+	__le32 log_event_table_ptr;	/* SRAM address for LMAC event log */
+	__le32 cpu_register_ptr;
+	__le32 dbgm_config_ptr;
+	__le32 alive_counter_ptr;
+	__le32 scd_base_ptr;		/* SRAM address for SCD */
+	__le32 st_fwrd_addr;		/* pointer to Store and forward */
+	__le32 st_fwrd_size;
+	__le32 umac_minor;		/* UMAC version: minor */
+	__le32 umac_major;		/* UMAC version: major */
+	__le32 error_info_addr;		/* SRAM address for UMAC error log */
+	__le32 dbg_print_buff_addr;
+} __packed; /* ALIVE_RES_API_S_VER_3 */
+
 /* Error response/notification */
 enum {
 	FW_ERR_UNKNOWN_CMD = 0x0,
diff --git a/drivers/net/wireless/iwlwifi/mvm/fw.c b/drivers/net/wireless/iwlwifi/mvm/fw.c
index ab81124..7426bb0 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/iwlwifi/mvm/fw.c
@@ -112,25 +112,27 @@ static bool iwl_alive_fn(struct iwl_notif_wait_data *notif_wait,
 	struct iwl_mvm *mvm =
 		container_of(notif_wait, struct iwl_mvm, notif_wait);
 	struct iwl_mvm_alive_data *alive_data = data;
-	struct mvm_alive_resp *palive;
+	struct mvm_alive_resp_ver1 *palive1;
 	struct mvm_alive_resp_ver2 *palive2;
+	struct mvm_alive_resp *palive;
 
-	if (iwl_rx_packet_payload_len(pkt) == sizeof(*palive)) {
-		palive = (void *)pkt->data;
+	if (iwl_rx_packet_payload_len(pkt) == sizeof(*palive1)) {
+		palive1 = (void *)pkt->data;
 
 		mvm->support_umac_log = false;
 		mvm->error_event_table =
-			le32_to_cpu(palive->error_event_table_ptr);
-		mvm->log_event_table = le32_to_cpu(palive->log_event_table_ptr);
-		alive_data->scd_base_addr = le32_to_cpu(palive->scd_base_ptr);
+			le32_to_cpu(palive1->error_event_table_ptr);
+		mvm->log_event_table =
+			le32_to_cpu(palive1->log_event_table_ptr);
+		alive_data->scd_base_addr = le32_to_cpu(palive1->scd_base_ptr);
 
-		alive_data->valid = le16_to_cpu(palive->status) ==
+		alive_data->valid = le16_to_cpu(palive1->status) ==
 				    IWL_ALIVE_STATUS_OK;
 		IWL_DEBUG_FW(mvm,
 			     "Alive VER1 ucode status 0x%04x revision 0x%01X 0x%01X flags 0x%01X\n",
-			     le16_to_cpu(palive->status), palive->ver_type,
-			     palive->ver_subtype, palive->flags);
-	} else {
+			     le16_to_cpu(palive1->status), palive1->ver_type,
+			     palive1->ver_subtype, palive1->flags);
+	} else if (iwl_rx_packet_payload_len(pkt) == sizeof(*palive2)) {
 		palive2 = (void *)pkt->data;
 
 		mvm->error_event_table =
@@ -156,6 +158,33 @@ static bool iwl_alive_fn(struct iwl_notif_wait_data *notif_wait,
 		IWL_DEBUG_FW(mvm,
 			     "UMAC version: Major - 0x%x, Minor - 0x%x\n",
 			     palive2->umac_major, palive2->umac_minor);
+	} else if (iwl_rx_packet_payload_len(pkt) == sizeof(*palive)) {
+		palive = (void *)pkt->data;
+
+		mvm->error_event_table =
+			le32_to_cpu(palive->error_event_table_ptr);
+		mvm->log_event_table =
+			le32_to_cpu(palive->log_event_table_ptr);
+		alive_data->scd_base_addr = le32_to_cpu(palive->scd_base_ptr);
+		mvm->umac_error_event_table =
+			le32_to_cpu(palive->error_info_addr);
+		mvm->sf_space.addr = le32_to_cpu(palive->st_fwrd_addr);
+		mvm->sf_space.size = le32_to_cpu(palive->st_fwrd_size);
+
+		alive_data->valid = le16_to_cpu(palive->status) ==
+				    IWL_ALIVE_STATUS_OK;
+		if (mvm->umac_error_event_table)
+			mvm->support_umac_log = true;
+
+		IWL_DEBUG_FW(mvm,
+			     "Alive VER3 ucode status 0x%04x revision 0x%01X 0x%01X flags 0x%01X\n",
+			     le16_to_cpu(palive->status), palive->ver_type,
+			     palive->ver_subtype, palive->flags);
+
+		IWL_DEBUG_FW(mvm,
+			     "UMAC version: Major - 0x%x, Minor - 0x%x\n",
+			     le32_to_cpu(palive->umac_major),
+			     le32_to_cpu(palive->umac_minor));
 	}
 
 	return true;
diff --git a/drivers/net/wireless/iwlwifi/mvm/utils.c b/drivers/net/wireless/iwlwifi/mvm/utils.c
index a501223..2b9de63 100644
--- a/drivers/net/wireless/iwlwifi/mvm/utils.c
+++ b/drivers/net/wireless/iwlwifi/mvm/utils.c
@@ -332,7 +332,7 @@ static const char *desc_lookup(u32 num)
  * read with u32-sized accesses, any members with a different size
  * need to be ordered correctly though!
  */
-struct iwl_error_event_table {
+struct iwl_error_event_table_v1 {
 	u32 valid;		/* (nonzero) valid, (0) log is empty */
 	u32 error_id;		/* type of error */
 	u32 pc;			/* program counter */
@@ -377,7 +377,55 @@ struct iwl_error_event_table {
 	u32 u_timestamp;	/* indicate when the date and time of the
 				 * compilation */
 	u32 flow_handler;	/* FH read/write pointers, RX credit */
-} __packed;
+} __packed /* LOG_ERROR_TABLE_API_S_VER_1 */;
+
+struct iwl_error_event_table {
+	u32 valid;		/* (nonzero) valid, (0) log is empty */
+	u32 error_id;		/* type of error */
+	u32 pc;			/* program counter */
+	u32 blink1;		/* branch link */
+	u32 blink2;		/* branch link */
+	u32 ilink1;		/* interrupt link */
+	u32 ilink2;		/* interrupt link */
+	u32 data1;		/* error-specific data */
+	u32 data2;		/* error-specific data */
+	u32 data3;		/* error-specific data */
+	u32 bcon_time;		/* beacon timer */
+	u32 tsf_low;		/* network timestamp function timer */
+	u32 tsf_hi;		/* network timestamp function timer */
+	u32 gp1;		/* GP1 timer register */
+	u32 gp2;		/* GP2 timer register */
+	u32 gp3;		/* GP3 timer register */
+	u32 major;		/* uCode version major */
+	u32 minor;		/* uCode version minor */
+	u32 hw_ver;		/* HW Silicon version */
+	u32 brd_ver;		/* HW board version */
+	u32 log_pc;		/* log program counter */
+	u32 frame_ptr;		/* frame pointer */
+	u32 stack_ptr;		/* stack pointer */
+	u32 hcmd;		/* last host command header */
+	u32 isr0;		/* isr status register LMPM_NIC_ISR0:
+				 * rxtx_flag */
+	u32 isr1;		/* isr status register LMPM_NIC_ISR1:
+				 * host_flag */
+	u32 isr2;		/* isr status register LMPM_NIC_ISR2:
+				 * enc_flag */
+	u32 isr3;		/* isr status register LMPM_NIC_ISR3:
+				 * time_flag */
+	u32 isr4;		/* isr status register LMPM_NIC_ISR4:
+				 * wico interrupt */
+	u32 isr_pref;		/* isr status register LMPM_NIC_PREF_STAT */
+	u32 wait_event;		/* wait event() caller address */
+	u32 l2p_control;	/* L2pControlField */
+	u32 l2p_duration;	/* L2pDurationField */
+	u32 l2p_mhvalid;	/* L2pMhValidBits */
+	u32 l2p_addr_match;	/* L2pAddrMatchStat */
+	u32 lmpm_pmg_sel;	/* indicate which clocks are turned on
+				 * (LMPM_PMG_SEL) */
+	u32 u_timestamp;	/* indicate when the date and time of the
+				 * compilation */
+	u32 flow_handler;	/* FH read/write pointers, RX credit */
+} __packed /* LOG_ERROR_TABLE_API_S_VER_2 */;
 
 /*
  * UMAC error struct - relevant starting from family 8000 chip.
@@ -396,11 +444,11 @@ struct iwl_umac_error_event_table {
 	u32 data1;		/* error-specific data */
 	u32 data2;		/* error-specific data */
 	u32 data3;		/* error-specific data */
-	u32 umac_fw_ver;	/* UMAC version */
-	u32 umac_fw_api_ver;	/* UMAC FW API ver */
+	u32 umac_major;
+	u32 umac_minor;
 	u32 frame_pointer;	/* core register 27*/
 	u32 stack_pointer;	/* core register 28 */
-	u32 cmd_header;	/* latest host cmd sent to UMAC */
+	u32 cmd_header;		/* latest host cmd sent to UMAC */
 	u32 nic_isr_pref;	/* ISR status register */
 } __packed;
 
@@ -441,18 +489,18 @@ static void iwl_mvm_dump_umac_error_log(struct iwl_mvm *mvm)
 	IWL_ERR(mvm, "0x%08X | umac data1\n", table.data1);
 	IWL_ERR(mvm, "0x%08X | umac data2\n", table.data2);
 	IWL_ERR(mvm, "0x%08X | umac data3\n", table.data3);
-	IWL_ERR(mvm, "0x%08X | umac version\n", table.umac_fw_ver);
-	IWL_ERR(mvm, "0x%08X | umac api version\n", table.umac_fw_api_ver);
+	IWL_ERR(mvm, "0x%08X | umac major\n", table.umac_major);
+	IWL_ERR(mvm, "0x%08X | umac minor\n", table.umac_minor);
 	IWL_ERR(mvm, "0x%08X | frame pointer\n", table.frame_pointer);
 	IWL_ERR(mvm, "0x%08X | stack pointer\n", table.stack_pointer);
 	IWL_ERR(mvm, "0x%08X | last host cmd\n", table.cmd_header);
 	IWL_ERR(mvm, "0x%08X | isr status reg\n", table.nic_isr_pref);
 }
 
-void iwl_mvm_dump_nic_error_log(struct iwl_mvm *mvm)
+static void iwl_mvm_dump_nic_error_log_old(struct iwl_mvm *mvm)
 {
 	struct iwl_trans *trans = mvm->trans;
-	struct iwl_error_event_table table;
+	struct iwl_error_event_table_v1 table;
 	u32 base;
 
 	base = mvm->error_event_table;
@@ -489,7 +537,7 @@ void iwl_mvm_dump_nic_error_log(struct iwl_mvm *mvm)
 				      table.data1, table.data2, table.data3,
 				      table.blink1, table.blink2, table.ilink1,
 				      table.ilink2, table.bcon_time, table.gp1,
-				      table.gp2, table.gp3, table.ucode_ver,
+				      table.gp2, table.gp3, table.ucode_ver, 0,
 				      table.hw_ver, table.brd_ver);
 	IWL_ERR(mvm, "0x%08X | %-28s\n", table.error_id,
 		desc_lookup(table.error_id));
@@ -530,6 +578,92 @@ void iwl_mvm_dump_nic_error_log(struct iwl_mvm *mvm)
 		iwl_mvm_dump_umac_error_log(mvm);
 }
 
+void iwl_mvm_dump_nic_error_log(struct iwl_mvm *mvm)
+{
+	struct iwl_trans *trans = mvm->trans;
+	struct iwl_error_event_table table;
+	u32 base;
+
+	if (!(mvm->fw->ucode_capa.api[0] & IWL_UCODE_TLV_API_NEW_VERSION)) {
+		iwl_mvm_dump_nic_error_log_old(mvm);
+		return;
+	}
+
+	base = mvm->error_event_table;
+	if (mvm->cur_ucode == IWL_UCODE_INIT) {
+		if (!base)
+			base = mvm->fw->init_errlog_ptr;
+	} else {
+		if (!base)
+			base = mvm->fw->inst_errlog_ptr;
+	}
+
+	if (base < 0x800000) {
+		IWL_ERR(mvm,
+			"Not valid error log pointer 0x%08X for %s uCode\n",
+			base,
+			(mvm->cur_ucode == IWL_UCODE_INIT)
+					? "Init" : "RT");
+		return;
+	}
+
+	iwl_trans_read_mem_bytes(trans, base, &table, sizeof(table));
+
+	if (ERROR_START_OFFSET <= table.valid * ERROR_ELEM_SIZE) {
+		IWL_ERR(trans, "Start IWL Error Log Dump:\n");
+		IWL_ERR(trans, "Status: 0x%08lX, count: %d\n",
+			mvm->status, table.valid);
+	}
+
+	/* Do not change this output - scripts rely on it */
+
+	IWL_ERR(mvm, "Loaded firmware version: %s\n", mvm->fw->fw_version);
+
+	trace_iwlwifi_dev_ucode_error(trans->dev, table.error_id, table.tsf_low,
+				      table.data1, table.data2, table.data3,
+				      table.blink1, table.blink2, table.ilink1,
+				      table.ilink2, table.bcon_time, table.gp1,
+				      table.gp2, table.gp3, table.major,
+				      table.minor, table.hw_ver, table.brd_ver);
+	IWL_ERR(mvm, "0x%08X | %-28s\n", table.error_id,
+		desc_lookup(table.error_id));
+	IWL_ERR(mvm, "0x%08X | uPc\n", table.pc);
+	IWL_ERR(mvm, "0x%08X | branchlink1\n", table.blink1);
+	IWL_ERR(mvm, "0x%08X | branchlink2\n", table.blink2);
+	IWL_ERR(mvm, "0x%08X | interruptlink1\n", table.ilink1);
+	IWL_ERR(mvm, "0x%08X | interruptlink2\n", table.ilink2);
+	IWL_ERR(mvm, "0x%08X | data1\n", table.data1);
+	IWL_ERR(mvm, "0x%08X | data2\n", table.data2);
+	IWL_ERR(mvm, "0x%08X | data3\n", table.data3);
+	IWL_ERR(mvm, "0x%08X | beacon time\n", table.bcon_time);
+	IWL_ERR(mvm, "0x%08X | tsf low\n", table.tsf_low);
+	IWL_ERR(mvm, "0x%08X | tsf hi\n", table.tsf_hi);
+	IWL_ERR(mvm, "0x%08X | time gp1\n", table.gp1);
+	IWL_ERR(mvm, "0x%08X | time gp2\n", table.gp2);
+	IWL_ERR(mvm, "0x%08X | time gp3\n", table.gp3);
+	IWL_ERR(mvm, "0x%08X | uCode version major\n", table.major);
+	IWL_ERR(mvm, "0x%08X | uCode version minor\n", table.minor);
+	IWL_ERR(mvm, "0x%08X | hw version\n", table.hw_ver);
+	IWL_ERR(mvm, "0x%08X | board version\n", table.brd_ver);
+	IWL_ERR(mvm, "0x%08X | hcmd\n", table.hcmd);
+	IWL_ERR(mvm, "0x%08X | isr0\n", table.isr0);
+	IWL_ERR(mvm, "0x%08X | isr1\n", table.isr1);
+	IWL_ERR(mvm, "0x%08X | isr2\n", table.isr2);
+	IWL_ERR(mvm, "0x%08X | isr3\n", table.isr3);
+	IWL_ERR(mvm, "0x%08X | isr4\n", table.isr4);
+	IWL_ERR(mvm, "0x%08X | isr_pref\n", table.isr_pref);
+	IWL_ERR(mvm, "0x%08X | wait_event\n", table.wait_event);
+	IWL_ERR(mvm, "0x%08X | l2p_control\n", table.l2p_control);
+	IWL_ERR(mvm, "0x%08X | l2p_duration\n", table.l2p_duration);
+	IWL_ERR(mvm, "0x%08X | l2p_mhvalid\n", table.l2p_mhvalid);
+	IWL_ERR(mvm, "0x%08X | l2p_addr_match\n", table.l2p_addr_match);
+	IWL_ERR(mvm, "0x%08X | lmpm_pmg_sel\n", table.lmpm_pmg_sel);
+	IWL_ERR(mvm, "0x%08X | timestamp\n", table.u_timestamp);
+	IWL_ERR(mvm, "0x%08X | flow_handler\n", table.flow_handler);
+
+	if (mvm->support_umac_log)
+		iwl_mvm_dump_umac_error_log(mvm);
+}
 void iwl_mvm_enable_txq(struct iwl_mvm *mvm, int queue, u16 ssn,
 			const struct iwl_trans_txq_scd_cfg *cfg,
 			unsigned int wdg_timeout)
-- 
1.9.1

