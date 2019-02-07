Return-Path: <SRS0=Kusg=QO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD913C282C4
	for <linux-wireless@archiver.kernel.org>; Thu,  7 Feb 2019 22:36:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A90032173B
	for <linux-wireless@archiver.kernel.org>; Thu,  7 Feb 2019 22:36:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726994AbfBGWgv (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 7 Feb 2019 17:36:51 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:56668 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726758AbfBGWgv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 7 Feb 2019 17:36:51 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1grsHl-0002II-7a; Fri, 08 Feb 2019 00:36:45 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Shahar S Matityahu <shahar.s.matityahu@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Fri,  8 Feb 2019 00:36:16 +0200
Message-Id: <20190207223622.9642-12-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190207223622.9642-1-luca@coelho.fi>
References: <20190207223622.9642-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 11/17] iwlwifi: receive umac and lmac error table addresses from TLVs
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Shahar S Matityahu <shahar.s.matityahu@intel.com>

TLV 54 holds umac debug related addresses.
TLV 55 holds lmac debug related addresses.
These TLVs aim to replace the alive notification data in the future.

Parse and keep error table addresses received from the TLVs
for both lmac and umac and use these addresses instead of the pointer
received from alive notification.

The feature supports only unified image.

Signed-off-by: Shahar S Matityahu <shahar.s.matityahu@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 .../net/wireless/intel/iwlwifi/fw/api/alive.h | 28 +++++++++------
 drivers/net/wireless/intel/iwlwifi/fw/dbg.h   | 20 +++++++++++
 drivers/net/wireless/intel/iwlwifi/fw/file.h  |  2 ++
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c  | 35 +++++++++++++++++++
 .../net/wireless/intel/iwlwifi/iwl-trans.h    | 10 ++++++
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c   |  2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c   | 23 +++++++-----
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h  |  3 --
 .../net/wireless/intel/iwlwifi/mvm/utils.c    | 12 ++++---
 9 files changed, 107 insertions(+), 28 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/api/alive.h b/drivers/net/wireless/intel/iwlwifi/fw/api/alive.h
index 08d3d8a190f6..0026e259fd87 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/api/alive.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/api/alive.h
@@ -96,14 +96,7 @@ enum {
 
 #define IWL_ALIVE_FLG_RFKILL	BIT(0)
 
-struct iwl_lmac_alive {
-	__le32 ucode_major;
-	__le32 ucode_minor;
-	u8 ver_subtype;
-	u8 ver_type;
-	u8 mac;
-	u8 opt;
-	__le32 timestamp;
+struct iwl_lmac_debug_addrs {
 	__le32 error_event_table_ptr;	/* SRAM address for error log */
 	__le32 log_event_table_ptr;	/* SRAM address for LMAC event log */
 	__le32 cpu_register_ptr;
@@ -112,13 +105,28 @@ struct iwl_lmac_alive {
 	__le32 scd_base_ptr;		/* SRAM address for SCD */
 	__le32 st_fwrd_addr;		/* pointer to Store and forward */
 	__le32 st_fwrd_size;
+} __packed; /* UCODE_DEBUG_ADDRS_API_S_VER_2 */
+
+struct iwl_lmac_alive {
+	__le32 ucode_major;
+	__le32 ucode_minor;
+	u8 ver_subtype;
+	u8 ver_type;
+	u8 mac;
+	u8 opt;
+	__le32 timestamp;
+	struct iwl_lmac_debug_addrs dbg_ptrs;
 } __packed; /* UCODE_ALIVE_NTFY_API_S_VER_3 */
 
+struct iwl_umac_debug_addrs {
+	__le32 error_info_addr;		/* SRAM address for UMAC error log */
+	__le32 dbg_print_buff_addr;
+} __packed; /* UMAC_DEBUG_ADDRS_API_S_VER_1 */
+
 struct iwl_umac_alive {
 	__le32 umac_major;		/* UMAC version: major */
 	__le32 umac_minor;		/* UMAC version: minor */
-	__le32 error_info_addr;		/* SRAM address for UMAC error log */
-	__le32 dbg_print_buff_addr;
+	struct iwl_umac_debug_addrs dbg_ptrs;
 } __packed; /* UMAC_ALIVE_DATA_API_S_VER_2 */
 
 struct mvm_alive_resp_v3 {
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/dbg.h b/drivers/net/wireless/intel/iwlwifi/fw/dbg.h
index a6133b5f9e83..d11923edd695 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/dbg.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/dbg.h
@@ -442,6 +442,26 @@ void iwl_fw_dbg_apply_point(struct iwl_fw_runtime *fwrt,
 
 void iwl_fwrt_stop_device(struct iwl_fw_runtime *fwrt);
 
+static inline void iwl_fw_lmac1_set_alive_err_table(struct iwl_trans *trans,
+						    u32 lmac_error_event_table)
+{
+	if (!(trans->error_event_table_tlv_status &
+	      IWL_ERROR_EVENT_TABLE_LMAC1) ||
+	    WARN_ON(trans->lmac_error_event_table[0] !=
+		    lmac_error_event_table))
+		trans->lmac_error_event_table[0] = lmac_error_event_table;
+}
+
+static inline void iwl_fw_umac_set_alive_err_table(struct iwl_trans *trans,
+						   u32 umac_error_event_table)
+{
+	if (!(trans->error_event_table_tlv_status &
+	      IWL_ERROR_EVENT_TABLE_UMAC) ||
+	    WARN_ON(trans->umac_error_event_table !=
+		    umac_error_event_table))
+		trans->umac_error_event_table = umac_error_event_table;
+}
+
 /* This bit is used to differentiate the legacy dump from the ini dump */
 #define INI_DUMP_BIT BIT(31)
 
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/file.h b/drivers/net/wireless/intel/iwlwifi/fw/file.h
index 3bffb0f7a5e5..886a620e03cf 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/file.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/file.h
@@ -143,6 +143,8 @@ enum iwl_ucode_tlv_type {
 	IWL_UCODE_TLV_FW_GSCAN_CAPA	= 50,
 	IWL_UCODE_TLV_FW_MEM_SEG	= 51,
 	IWL_UCODE_TLV_IML		= 52,
+	IWL_UCODE_TLV_UMAC_DEBUG_ADDRS	= 54,
+	IWL_UCODE_TLV_LMAC_DEBUG_ADDRS	= 55,
 	IWL_UCODE_TLV_TYPE_BUFFER_ALLOCATION	= IWL_UCODE_INI_TLV_GROUP | 0x1,
 	IWL_UCODE_TLV_TYPE_HCMD			= IWL_UCODE_INI_TLV_GROUP | 0x2,
 	IWL_UCODE_TLV_TYPE_REGIONS		= IWL_UCODE_INI_TLV_GROUP | 0x3,
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
index 2efa1dfe9b4c..784e07b648e6 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
@@ -75,6 +75,7 @@
 #include "iwl-dbg-tlv.h"
 #include "iwl-config.h"
 #include "iwl-modparams.h"
+#include "fw/api/alive.h"
 
 /******************************************************************************
  *
@@ -588,6 +589,8 @@ static int iwl_parse_v1_v2_firmware(struct iwl_drv *drv,
 	return 0;
 }
 
+#define FW_ADDR_CACHE_CONTROL 0xC0000000
+
 static int iwl_parse_tlv_firmware(struct iwl_drv *drv,
 				const struct firmware *ucode_raw,
 				struct iwl_firmware_pieces *pieces,
@@ -1085,6 +1088,38 @@ static int iwl_parse_tlv_firmware(struct iwl_drv *drv,
 				return -ENOMEM;
 			break;
 			}
+		case IWL_UCODE_TLV_UMAC_DEBUG_ADDRS: {
+			struct iwl_umac_debug_addrs *dbg_ptrs =
+				(void *)tlv_data;
+
+			if (tlv_len != sizeof(*dbg_ptrs))
+				goto invalid_tlv_len;
+			if (drv->trans->cfg->device_family <
+			    IWL_DEVICE_FAMILY_22000)
+				break;
+			drv->trans->umac_error_event_table =
+				le32_to_cpu(dbg_ptrs->error_info_addr) &
+				~FW_ADDR_CACHE_CONTROL;
+			drv->trans->error_event_table_tlv_status |=
+				IWL_ERROR_EVENT_TABLE_UMAC;
+			break;
+			}
+		case IWL_UCODE_TLV_LMAC_DEBUG_ADDRS: {
+			struct iwl_lmac_debug_addrs *dbg_ptrs =
+				(void *)tlv_data;
+
+			if (tlv_len != sizeof(*dbg_ptrs))
+				goto invalid_tlv_len;
+			if (drv->trans->cfg->device_family <
+			    IWL_DEVICE_FAMILY_22000)
+				break;
+			drv->trans->lmac_error_event_table[0] =
+				le32_to_cpu(dbg_ptrs->error_event_table_ptr) &
+				~FW_ADDR_CACHE_CONTROL;
+			drv->trans->error_event_table_tlv_status |=
+				IWL_ERROR_EVENT_TABLE_LMAC1;
+			break;
+			}
 		case IWL_UCODE_TLV_TYPE_BUFFER_ALLOCATION:
 		case IWL_UCODE_TLV_TYPE_HCMD:
 		case IWL_UCODE_TLV_TYPE_REGIONS:
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-trans.h b/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
index ef23c6aafb5c..bbebbf3efd57 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
@@ -232,6 +232,12 @@ enum iwl_hcmd_dataflag {
 	IWL_HCMD_DFL_DUP	= BIT(1),
 };
 
+enum iwl_error_event_table_status {
+	IWL_ERROR_EVENT_TABLE_LMAC1 = BIT(0),
+	IWL_ERROR_EVENT_TABLE_LMAC2 = BIT(1),
+	IWL_ERROR_EVENT_TABLE_UMAC = BIT(2),
+};
+
 /**
  * struct iwl_host_cmd - Host command to the uCode
  *
@@ -759,6 +765,10 @@ struct iwl_self_init_dram {
  *	mode is set during the initialization phase and is not
  *	supposed to change during runtime.
  * @dbg_rec_on: true iff there is a fw debug recording currently active
+ * @lmac_error_event_table: addrs of lmacs error tables
+ * @umac_error_event_table: addr of umac error table
+ * @error_event_table_tlv_status: bitmap that indicates what error table
+ *	pointers was recevied via TLV. use enum &iwl_error_event_table_status
  */
 struct iwl_trans {
 	const struct iwl_trans_ops *ops;
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/d3.c b/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
index 36ed7d6fc971..808bc6f363d0 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
@@ -1899,7 +1899,7 @@ static void iwl_mvm_d3_disconnect_iter(void *data, u8 *mac,
 static int iwl_mvm_check_rt_status(struct iwl_mvm *mvm,
 				   struct ieee80211_vif *vif)
 {
-	u32 base = mvm->error_event_table[0];
+	u32 base = mvm->trans->lmac_error_event_table[0];
 	struct error_table_start {
 		/* cf. struct iwl_error_event_table */
 		u32 valid;
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
index 8140b193cc05..cf7f8c340ffe 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
@@ -218,7 +218,7 @@ static bool iwl_alive_fn(struct iwl_notif_wait_data *notif_wait,
 	struct iwl_lmac_alive *lmac1;
 	struct iwl_lmac_alive *lmac2 = NULL;
 	u16 status;
-	u32 umac_error_event_table;
+	u32 lmac_error_event_table, umac_error_event_table;
 
 	if (iwl_rx_packet_payload_len(pkt) == sizeof(*palive)) {
 		palive = (void *)pkt->data;
@@ -233,30 +233,35 @@ static bool iwl_alive_fn(struct iwl_notif_wait_data *notif_wait,
 		status = le16_to_cpu(palive3->status);
 	}
 
-	mvm->error_event_table[0] = le32_to_cpu(lmac1->error_event_table_ptr);
+	lmac_error_event_table =
+		le32_to_cpu(lmac1->dbg_ptrs.error_event_table_ptr);
+	iwl_fw_lmac1_set_alive_err_table(mvm->trans, lmac_error_event_table);
+
 	if (lmac2)
-		mvm->error_event_table[1] =
-			le32_to_cpu(lmac2->error_event_table_ptr);
-	mvm->log_event_table = le32_to_cpu(lmac1->log_event_table_ptr);
+		mvm->trans->lmac_error_event_table[1] =
+			le32_to_cpu(lmac2->dbg_ptrs.error_event_table_ptr);
 
-	umac_error_event_table = le32_to_cpu(umac->error_info_addr);
+	umac_error_event_table = le32_to_cpu(umac->dbg_ptrs.error_info_addr);
 
 	if (!umac_error_event_table) {
 		mvm->support_umac_log = false;
 	} else if (umac_error_event_table >=
 		   mvm->trans->cfg->min_umac_error_event_table) {
 		mvm->support_umac_log = true;
-		mvm->umac_error_event_table = umac_error_event_table;
 	} else {
 		IWL_ERR(mvm,
 			"Not valid error log pointer 0x%08X for %s uCode\n",
-			mvm->umac_error_event_table,
+			umac_error_event_table,
 			(mvm->fwrt.cur_fw_img == IWL_UCODE_INIT) ?
 			"Init" : "RT");
 		mvm->support_umac_log = false;
 	}
 
-	alive_data->scd_base_addr = le32_to_cpu(lmac1->scd_base_ptr);
+	if (mvm->support_umac_log)
+		iwl_fw_umac_set_alive_err_table(mvm->trans,
+						umac_error_event_table);
+
+	alive_data->scd_base_addr = le32_to_cpu(lmac1->dbg_ptrs.scd_base_ptr);
 	alive_data->valid = status == IWL_ALIVE_STATUS_OK;
 
 	IWL_DEBUG_FW(mvm,
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
index e9873fc7bd2b..0255157378db 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
@@ -879,9 +879,6 @@ struct iwl_mvm {
 
 	bool hw_registered;
 	bool calibrating;
-	u32 error_event_table[2];
-	u32 log_event_table;
-	u32 umac_error_event_table;
 	bool support_umac_log;
 
 	u32 ampdu_ref;
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/utils.c b/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
index 4a18997fb48a..4649327abb45 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
@@ -457,12 +457,14 @@ static void iwl_mvm_dump_umac_error_log(struct iwl_mvm *mvm)
 {
 	struct iwl_trans *trans = mvm->trans;
 	struct iwl_umac_error_event_table table;
+	u32 base = mvm->trans->umac_error_event_table;
 
-	if (!mvm->support_umac_log)
+	if (!mvm->support_umac_log &&
+	    !(mvm->trans->error_event_table_tlv_status &
+	      IWL_ERROR_EVENT_TABLE_UMAC))
 		return;
 
-	iwl_trans_read_mem_bytes(trans, mvm->umac_error_event_table, &table,
-				 sizeof(table));
+	iwl_trans_read_mem_bytes(trans, base, &table, sizeof(table));
 
 	if (table.valid)
 		mvm->fwrt.dump.umac_err_id = table.error_id;
@@ -494,7 +496,7 @@ static void iwl_mvm_dump_lmac_error_log(struct iwl_mvm *mvm, u8 lmac_num)
 {
 	struct iwl_trans *trans = mvm->trans;
 	struct iwl_error_event_table table;
-	u32 val, base = mvm->error_event_table[lmac_num];
+	u32 val, base = mvm->trans->lmac_error_event_table[lmac_num];
 
 	if (mvm->fwrt.cur_fw_img == IWL_UCODE_INIT) {
 		if (!base)
@@ -590,7 +592,7 @@ void iwl_mvm_dump_nic_error_log(struct iwl_mvm *mvm)
 
 	iwl_mvm_dump_lmac_error_log(mvm, 0);
 
-	if (mvm->error_event_table[1])
+	if (mvm->trans->lmac_error_event_table[1])
 		iwl_mvm_dump_lmac_error_log(mvm, 1);
 
 	iwl_mvm_dump_umac_error_log(mvm);
-- 
2.20.1

