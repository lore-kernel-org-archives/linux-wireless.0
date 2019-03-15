Return-Path: <SRS0=bI0Y=RS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B57FC43381
	for <linux-wireless@archiver.kernel.org>; Fri, 15 Mar 2019 16:37:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0EC1A2077B
	for <linux-wireless@archiver.kernel.org>; Fri, 15 Mar 2019 16:37:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729578AbfCOQhH (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 15 Mar 2019 12:37:07 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:44328 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729541AbfCOQhH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 15 Mar 2019 12:37:07 -0400
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1h4ppG-0004qp-Tj; Fri, 15 Mar 2019 18:36:55 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Shahar S Matityahu <shahar.s.matityahu@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Fri, 15 Mar 2019 18:36:34 +0200
Message-Id: <20190315163634.17315-17-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190315163634.17315-1-luca@coelho.fi>
References: <20190315163634.17315-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 16/16] iwlwifi: dbg_ini: align to FW api version 1
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Shahar S Matityahu <shahar.s.matityahu@intel.com>

align to ini debug struct version 1 and enforce version checking.

Signed-off-by: Shahar S Matityahu <shahar.s.matityahu@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 .../wireless/intel/iwlwifi/fw/api/dbg-tlv.h   | 177 ++++++++++++------
 .../net/wireless/intel/iwlwifi/iwl-dbg-tlv.c  |  10 +-
 2 files changed, 126 insertions(+), 61 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/api/dbg-tlv.h b/drivers/net/wireless/intel/iwlwifi/fw/api/dbg-tlv.h
index 33858787817b..af1e3d08c179 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/api/dbg-tlv.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/api/dbg-tlv.h
@@ -60,12 +60,13 @@
 
 #include <linux/bitops.h>
 
-/*
+/**
  * struct iwl_fw_ini_header: Common Header for all debug group TLV's structures
+ *
  * @tlv_version: version info
  * @apply_point: &enum iwl_fw_ini_apply_point
  * @data: TLV data followed
- **/
+ */
 struct iwl_fw_ini_header {
 	__le32 tlv_version;
 	__le32 apply_point;
@@ -73,7 +74,7 @@ struct iwl_fw_ini_header {
 } __packed; /* FW_DEBUG_TLV_HEADER_S */
 
 /**
- * struct iwl_fw_ini_allocation_tlv - (IWL_FW_INI_TLV_TYPE_BUFFER_ALLOCATION)
+ * struct iwl_fw_ini_allocation_tlv - (IWL_UCODE_TLV_TYPE_BUFFER_ALLOCATION)
  * buffer allocation TLV - for debug
  *
  * @iwl_fw_ini_header: header
@@ -84,7 +85,7 @@ struct iwl_fw_ini_header {
  * @max_fragments: the maximum allowed fragmentation in the desired memory
  *	allocation above
  * @min_frag_size: the minimum allowed fragmentation size in bytes
-*/
+ */
 struct iwl_fw_ini_allocation_tlv {
 	struct iwl_fw_ini_header header;
 	__le32 allocation_id;
@@ -95,33 +96,52 @@ struct iwl_fw_ini_allocation_tlv {
 } __packed; /* FW_DEBUG_TLV_BUFFER_ALLOCATION_TLV_S_VER_1 */
 
 /**
- * struct iwl_fw_ini_hcmd (IWL_FW_INI_TLV_TYPE_HCMD)
- * Generic Host command pass through TLV
+ * enum iwl_fw_ini_dbg_domain - debug domains
+ * allows to send host cmd or collect memory region if a given domain is enabled
+ *
+ * @IWL_FW_INI_DBG_DOMAIN_ALWAYS_ON: the default domain, always on
+ * @IWL_FW_INI_DBG_DOMAIN_REPORT_PS: power save domain
+ */
+enum iwl_fw_ini_dbg_domain {
+	IWL_FW_INI_DBG_DOMAIN_ALWAYS_ON = 0,
+	IWL_FW_INI_DBG_DOMAIN_REPORT_PS,
+}; /* FW_DEBUG_TLV_DOMAIN_API_E_VER_1 */
+
+/**
+ * struct iwl_fw_ini_hcmd
  *
  * @id: the debug configuration command type for instance: 0xf6 / 0xf5 / DHC
  * @group: the desired cmd group
- * @padding: all zeros for dword alignment
- * @data: all of the relevant command (0xf6/0xf5) to be sent
-*/
+ * @reserved: to align to FW struct
+ * @data: all of the relevant command data to be sent
+ */
 struct iwl_fw_ini_hcmd {
 	u8 id;
 	u8 group;
-	__le16 padding;
+	__le16 reserved;
 	u8 data[0];
-} __packed; /* FW_DEBUG_TLV_HCMD_DATA_S */
+} __packed; /* FW_DEBUG_TLV_HCMD_DATA_API_S_VER_1 */
 
 /**
- * struct iwl_fw_ini_hcmd_tlv
+ * struct iwl_fw_ini_hcmd_tlv - (IWL_UCODE_TLV_TYPE_HCMD)
+ * Generic Host command pass through TLV
+ *
  * @header: header
+ * @domain: send command only if the specific domain is enabled
+ *	&enum iwl_fw_ini_dbg_domain
+ * @period_msec: period in which the hcmd will be sent to FW. Measured in msec
+ *	(0 = one time command).
  * @hcmd: a variable length host-command to be sent to apply the configuration.
  */
 struct iwl_fw_ini_hcmd_tlv {
 	struct iwl_fw_ini_header header;
+	__le32 domain;
+	__le32 period_msec;
 	struct iwl_fw_ini_hcmd hcmd;
-} __packed; /* FW_DEBUG_TLV_HCMD_S_VER_1 */
+} __packed; /* FW_DEBUG_TLV_HCMD_API_S_VER_1 */
 
-/*
- * struct iwl_fw_ini_debug_flow_tlv (IWL_FW_INI_TLV_TYPE_DEBUG_FLOW)
+/**
+ * struct iwl_fw_ini_debug_flow_tlv - (IWL_UCODE_TLV_TYPE_DEBUG_FLOW)
  *
  * @header: header
  * @debug_flow_cfg: &enum iwl_fw_ini_debug_flow
@@ -134,8 +154,20 @@ struct iwl_fw_ini_debug_flow_tlv {
 #define IWL_FW_INI_MAX_REGION_ID	64
 #define IWL_FW_INI_MAX_NAME		32
 
+/**
+ * struct iwl_fw_ini_region_cfg_dhc - defines dhc response to dump.
+ *
+ * @id_and_grp: id and group of dhc response.
+ * @desc: dhc response descriptor.
+ */
+struct iwl_fw_ini_region_cfg_dhc {
+	__le32 id_and_grp;
+	__le32 desc;
+} __packed; /* FW_DEBUG_TLV_REGION_DHC_API_S_VER_1 */
+
 /**
  * struct iwl_fw_ini_region_cfg_internal - meta data of internal memory region
+ *
  * @num_of_range: the amount of ranges in the region
  * @range_data_size: size of the data to read per range, in bytes.
  */
@@ -146,6 +178,7 @@ struct iwl_fw_ini_region_cfg_internal {
 
 /**
  * struct iwl_fw_ini_region_cfg_fifos - meta data of fifos region
+ *
  * @fid1: fifo id 1 - bitmap of lmac tx/rx fifos to include in the region
  * @fid2: fifo id 2 - bitmap of umac rx fifos to include in the region.
  *	It is unused for tx.
@@ -163,34 +196,43 @@ struct iwl_fw_ini_region_cfg_fifos {
 
 /**
  * struct iwl_fw_ini_region_cfg
+ *
  * @region_id: ID of this dump configuration
  * @region_type: &enum iwl_fw_ini_region_type
- * @num_regions: amount of regions in the address array.
+ * @domain: dump this region only if the specific domain is enabled
+ *	&enum iwl_fw_ini_dbg_domain
  * @name_len: name length
  * @name: file name to use for this region
  * @internal: used in case the region uses internal memory.
  * @allocation_id: For DRAM type field substitutes for allocation_id
  * @fifos: used in case of fifos region.
+ * @dhc_desc: dhc response descriptor.
+ * @notif_id_and_grp: dump this region only if the specific notification
+ *	occurred.
  * @offset: offset to use for each memory base address
  * @start_addr: array of addresses.
  */
 struct iwl_fw_ini_region_cfg {
 	__le32 region_id;
 	__le32 region_type;
+	__le32 domain;
 	__le32 name_len;
 	u8 name[IWL_FW_INI_MAX_NAME];
 	union {
 		struct iwl_fw_ini_region_cfg_internal internal;
 		__le32 allocation_id;
 		struct iwl_fw_ini_region_cfg_fifos fifos;
-	};
+		struct iwl_fw_ini_region_cfg_dhc dhc_desc;
+		__le32 notif_id_and_grp;
+	}; /* FW_DEBUG_TLV_REGION_EXT_INT_PARAMS_API_U_VER_1 */
 	__le32 offset;
 	__le32 start_addr[];
-} __packed; /* FW_DEBUG_TLV_REGION_CONFIG_S */
+} __packed; /* FW_DEBUG_TLV_REGION_CONFIG_API_S_VER_1 */
 
 /**
- * struct iwl_fw_ini_region_tlv - (IWL_FW_INI_TLV_TYPE_REGION_CFG)
- * DUMP sections define IDs and triggers that use those IDs TLV
+ * struct iwl_fw_ini_region_tlv - (IWL_UCODE_TLV_TYPE_REGIONS)
+ * defines memory regions to dump
+ *
  * @header: header
  * @num_regions: how many different region section and IDs are coming next
  * @region_config: list of dump configurations
@@ -199,13 +241,12 @@ struct iwl_fw_ini_region_tlv {
 	struct iwl_fw_ini_header header;
 	__le32 num_regions;
 	struct iwl_fw_ini_region_cfg region_config[];
-} __packed; /* FW_DEBUG_TLV_REGIONS_S_VER_1 */
+} __packed; /* FW_DEBUG_TLV_REGIONS_API_S_VER_1 */
 
 /**
- * struct iwl_fw_ini_trigger - (IWL_FW_INI_TLV_TYPE_DUMP_CFG)
- * Region sections define IDs and triggers that use those IDs TLV
+ * struct iwl_fw_ini_trigger
  *
- * @trigger_id: enum &iwl_fw_ini_tigger_id
+ * @trigger_id: &enum iwl_fw_ini_trigger_id
  * @override_trig: determines how apply trigger in case a trigger with the
  *	same id is already in use. Using the first 2 bytes:
  *	Byte 0: if 0, override trigger configuration, otherwise use the
@@ -214,6 +255,7 @@ struct iwl_fw_ini_region_tlv {
  *	existing trigger.
  * @dump_delay: delay from trigger fire to dump, in usec
  * @occurrences: max amount of times to be fired
+ * @reserved: to align to FW struct
  * @ignore_consec: ignore consecutive triggers, in usec
  * @force_restart: force FW restart
  * @multi_dut: initiate debug dump data on several DUTs
@@ -226,17 +268,18 @@ struct iwl_fw_ini_trigger {
 	__le32 override_trig;
 	__le32 dump_delay;
 	__le32 occurrences;
+	__le32 reserved;
 	__le32 ignore_consec;
 	__le32 force_restart;
 	__le32 multi_dut;
 	__le32 trigger_data;
 	__le32 num_regions;
 	__le32 data[];
-} __packed; /* FW_TLV_DEBUG_TRIGGER_CONFIG_S */
+} __packed; /* FW_TLV_DEBUG_TRIGGER_CONFIG_API_S_VER_1 */
 
 /**
- * struct iwl_fw_ini_trigger_tlv - (IWL_FW_INI_TLV_TYPE_TRIGGERS_CFG)
- * DUMP sections define IDs and triggers that use those IDs TLV
+ * struct iwl_fw_ini_trigger_tlv - (IWL_UCODE_TLV_TYPE_TRIGGERS)
+ * Triggers that hold memory regions to dump in case a trigger fires
  *
  * @header: header
  * @num_triggers: how many different triggers section and IDs are coming next
@@ -246,16 +289,18 @@ struct iwl_fw_ini_trigger_tlv {
 	struct iwl_fw_ini_header header;
 	__le32 num_triggers;
 	struct iwl_fw_ini_trigger trigger_config[];
-} __packed; /* FW_TLV_DEBUG_TRIGGERS_S_VER_1 */
+} __packed; /* FW_TLV_DEBUG_TRIGGERS_API_S_VER_1 */
 
 /**
  * enum iwl_fw_ini_trigger_id
+ *
  * @IWL_FW_TRIGGER_ID_FW_ASSERT: FW assert
  * @IWL_FW_TRIGGER_ID_FW_HW_ERROR: HW assert
  * @IWL_FW_TRIGGER_ID_FW_TFD_Q_HANG: TFD queue hang
  * @IWL_FW_TRIGGER_ID_FW_DEBUG_HOST_TRIGGER: FW debug notification
- * @IWL_FW_TRIGGER_ID_FW_GENERIC_NOTIFOCATION: FW generic notification
+ * @IWL_FW_TRIGGER_ID_FW_GENERIC_NOTIFICATION: FW generic notification
  * @IWL_FW_TRIGGER_ID_USER_TRIGGER: User trigger
+ * @IWL_FW_TRIGGER_ID_PERIODIC_TRIGGER: triggers periodically
  * @IWL_FW_TRIGGER_ID_HOST_PEER_CLIENT_INACTIVITY: peer inactivity
  * @IWL_FW_TRIGGER_ID_HOST_TX_LATENCY_THRESHOLD_CROSSED: TX latency
  *	threshold was crossed
@@ -299,47 +344,51 @@ enum iwl_fw_ini_trigger_id {
 
 	/* FW triggers */
 	IWL_FW_TRIGGER_ID_FW_DEBUG_HOST_TRIGGER			= 4,
-	IWL_FW_TRIGGER_ID_FW_GENERIC_NOTIFOCATION		= 5,
+	IWL_FW_TRIGGER_ID_FW_GENERIC_NOTIFICATION		= 5,
 
 	/* User trigger */
 	IWL_FW_TRIGGER_ID_USER_TRIGGER				= 6,
 
+	/* periodic uses the data field for the interval time */
+	IWL_FW_TRIGGER_ID_PERIODIC_TRIGGER			= 7,
+
 	/* Host triggers */
-	IWL_FW_TRIGGER_ID_HOST_PEER_CLIENT_INACTIVITY		= 7,
-	IWL_FW_TRIGGER_ID_HOST_TX_LATENCY_THRESHOLD_CROSSED	= 8,
-	IWL_FW_TRIGGER_ID_HOST_TX_RESPONSE_STATUS_FAILED	= 9,
-	IWL_FW_TRIGGER_ID_HOST_OS_REQ_DEAUTH_PEER		= 10,
-	IWL_FW_TRIGGER_ID_HOST_STOP_GO_REQUEST			= 11,
-	IWL_FW_TRIGGER_ID_HOST_START_GO_REQUEST			= 12,
-	IWL_FW_TRIGGER_ID_HOST_JOIN_GROUP_REQUEST		= 13,
-	IWL_FW_TRIGGER_ID_HOST_SCAN_START			= 14,
-	IWL_FW_TRIGGER_ID_HOST_SCAN_SUBMITTED			= 15,
-	IWL_FW_TRIGGER_ID_HOST_SCAN_PARAMS			= 16,
-	IWL_FW_TRIGGER_ID_HOST_CHECK_FOR_HANG			= 17,
-	IWL_FW_TRIGGER_ID_HOST_BAR_RECEIVED			= 18,
-	IWL_FW_TRIGGER_ID_HOST_AGG_TX_RESPONSE_STATUS_FAILED	= 19,
-	IWL_FW_TRIGGER_ID_HOST_EAPOL_TX_RESPONSE_FAILED		= 20,
-	IWL_FW_TRIGGER_ID_HOST_FAKE_TX_RESPONSE_SUSPECTED	= 21,
-	IWL_FW_TRIGGER_ID_HOST_AUTH_REQ_FROM_ASSOC_CLIENT	= 22,
-	IWL_FW_TRIGGER_ID_HOST_ROAM_COMPLETE			= 23,
-	IWL_FW_TRIGGER_ID_HOST_AUTH_ASSOC_FAST_FAILED		= 24,
-	IWL_FW_TRIGGER_ID_HOST_D3_START				= 25,
-	IWL_FW_TRIGGER_ID_HOST_D3_END				= 26,
-	IWL_FW_TRIGGER_ID_HOST_BSS_MISSED_BEACONS		= 27,
-	IWL_FW_TRIGGER_ID_HOST_P2P_CLIENT_MISSED_BEACONS	= 28,
-	IWL_FW_TRIGGER_ID_HOST_PEER_CLIENT_TX_FAILURES		= 29,
-	IWL_FW_TRIGGER_ID_HOST_TX_WFD_ACTION_FRAME_FAILED	= 30,
-	IWL_FW_TRIGGER_ID_HOST_AUTH_ASSOC_FAILED		= 31,
-	IWL_FW_TRIGGER_ID_HOST_SCAN_COMPLETE			= 32,
-	IWL_FW_TRIGGER_ID_HOST_SCAN_ABORT			= 33,
-	IWL_FW_TRIGGER_ID_HOST_NIC_ALIVE			= 34,
-	IWL_FW_TRIGGER_ID_HOST_CHANNEL_SWITCH_COMPLETE		= 35,
+	IWL_FW_TRIGGER_ID_HOST_PEER_CLIENT_INACTIVITY		= 8,
+	IWL_FW_TRIGGER_ID_HOST_TX_LATENCY_THRESHOLD_CROSSED	= 9,
+	IWL_FW_TRIGGER_ID_HOST_TX_RESPONSE_STATUS_FAILED	= 10,
+	IWL_FW_TRIGGER_ID_HOST_OS_REQ_DEAUTH_PEER		= 11,
+	IWL_FW_TRIGGER_ID_HOST_STOP_GO_REQUEST			= 12,
+	IWL_FW_TRIGGER_ID_HOST_START_GO_REQUEST			= 13,
+	IWL_FW_TRIGGER_ID_HOST_JOIN_GROUP_REQUEST		= 14,
+	IWL_FW_TRIGGER_ID_HOST_SCAN_START			= 15,
+	IWL_FW_TRIGGER_ID_HOST_SCAN_SUBMITTED			= 16,
+	IWL_FW_TRIGGER_ID_HOST_SCAN_PARAMS			= 17,
+	IWL_FW_TRIGGER_ID_HOST_CHECK_FOR_HANG			= 18,
+	IWL_FW_TRIGGER_ID_HOST_BAR_RECEIVED			= 19,
+	IWL_FW_TRIGGER_ID_HOST_AGG_TX_RESPONSE_STATUS_FAILED	= 20,
+	IWL_FW_TRIGGER_ID_HOST_EAPOL_TX_RESPONSE_FAILED		= 21,
+	IWL_FW_TRIGGER_ID_HOST_FAKE_TX_RESPONSE_SUSPECTED	= 22,
+	IWL_FW_TRIGGER_ID_HOST_AUTH_REQ_FROM_ASSOC_CLIENT	= 23,
+	IWL_FW_TRIGGER_ID_HOST_ROAM_COMPLETE			= 24,
+	IWL_FW_TRIGGER_ID_HOST_AUTH_ASSOC_FAST_FAILED		= 25,
+	IWL_FW_TRIGGER_ID_HOST_D3_START				= 26,
+	IWL_FW_TRIGGER_ID_HOST_D3_END				= 27,
+	IWL_FW_TRIGGER_ID_HOST_BSS_MISSED_BEACONS		= 28,
+	IWL_FW_TRIGGER_ID_HOST_P2P_CLIENT_MISSED_BEACONS	= 29,
+	IWL_FW_TRIGGER_ID_HOST_PEER_CLIENT_TX_FAILURES		= 30,
+	IWL_FW_TRIGGER_ID_HOST_TX_WFD_ACTION_FRAME_FAILED	= 31,
+	IWL_FW_TRIGGER_ID_HOST_AUTH_ASSOC_FAILED		= 32,
+	IWL_FW_TRIGGER_ID_HOST_SCAN_COMPLETE			= 33,
+	IWL_FW_TRIGGER_ID_HOST_SCAN_ABORT			= 34,
+	IWL_FW_TRIGGER_ID_HOST_NIC_ALIVE			= 35,
+	IWL_FW_TRIGGER_ID_HOST_CHANNEL_SWITCH_COMPLETE		= 36,
 
 	IWL_FW_TRIGGER_ID_NUM,
 }; /* FW_DEBUG_TLV_TRIGGER_ID_E_VER_1 */
 
 /**
  * enum iwl_fw_ini_apply_point
+ *
  * @IWL_FW_INI_APPLY_INVALID: invalid
  * @IWL_FW_INI_APPLY_EARLY: pre loading FW
  * @IWL_FW_INI_APPLY_AFTER_ALIVE: first cmd from host after alive
@@ -360,6 +409,7 @@ enum iwl_fw_ini_apply_point {
 
 /**
  * enum iwl_fw_ini_allocation_id
+ *
  * @IWL_FW_INI_ALLOCATION_INVALID: invalid
  * @IWL_FW_INI_ALLOCATION_ID_DBGC1: allocation meant for DBGC1 configuration
  * @IWL_FW_INI_ALLOCATION_ID_DBGC2: allocation meant for DBGC2 configuration
@@ -380,18 +430,22 @@ enum iwl_fw_ini_allocation_id {
 
 /**
  * enum iwl_fw_ini_buffer_location
+ *
  * @IWL_FW_INI_LOCATION_INVALID: invalid
  * @IWL_FW_INI_LOCATION_SRAM_PATH: SRAM location
  * @IWL_FW_INI_LOCATION_DRAM_PATH: DRAM location
+ * @IWL_FW_INI_LOCATION_NPK_PATH: NPK location
  */
 enum iwl_fw_ini_buffer_location {
 	IWL_FW_INI_LOCATION_INVALID,
 	IWL_FW_INI_LOCATION_SRAM_PATH,
 	IWL_FW_INI_LOCATION_DRAM_PATH,
+	IWL_FW_INI_LOCATION_NPK_PATH,
 }; /* FW_DEBUG_TLV_BUFFER_LOCATION_E_VER_1 */
 
 /**
  * enum iwl_fw_ini_debug_flow
+ *
  * @IWL_FW_INI_DEBUG_INVALID: invalid
  * @IWL_FW_INI_DEBUG_DBTR_FLOW: undefined
  * @IWL_FW_INI_DEBUG_TB2DTF_FLOW: undefined
@@ -404,6 +458,7 @@ enum iwl_fw_ini_debug_flow {
 
 /**
  * enum iwl_fw_ini_region_type
+ *
  * @IWL_FW_INI_REGION_INVALID: invalid
  * @IWL_FW_INI_REGION_DEVICE_MEMORY: device internal memory
  * @IWL_FW_INI_REGION_PERIPHERY_MAC: periphery registers of MAC
@@ -416,6 +471,8 @@ enum iwl_fw_ini_debug_flow {
  * @IWL_FW_INI_REGION_RXF: RX fifo
  * @IWL_FW_INI_REGION_PAGING: paging memory
  * @IWL_FW_INI_REGION_CSR: CSR registers
+ * @IWL_FW_INI_REGION_NOTIFICATION: FW notification data
+ * @IWL_FW_INI_REGION_DHC: dhc response to dump
  * @IWL_FW_INI_REGION_NUM: number of region types
  */
 enum iwl_fw_ini_region_type {
@@ -431,6 +488,8 @@ enum iwl_fw_ini_region_type {
 	IWL_FW_INI_REGION_RXF,
 	IWL_FW_INI_REGION_PAGING,
 	IWL_FW_INI_REGION_CSR,
+	IWL_FW_INI_REGION_NOTIFICATION,
+	IWL_FW_INI_REGION_DHC,
 	IWL_FW_INI_REGION_NUM
 }; /* FW_DEBUG_TLV_REGION_TYPE_E_VER_1 */
 
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c b/drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c
index 5798f434f68f..9107302cc444 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c
@@ -5,7 +5,7 @@
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright (C) 2018 Intel Corporation
+ * Copyright (C) 2018 - 2019 Intel Corporation
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -28,7 +28,7 @@
  *
  * BSD LICENSE
  *
- * Copyright (C) 2018 Intel Corporation
+ * Copyright (C) 2018 - 2019 Intel Corporation
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
@@ -73,6 +73,9 @@ void iwl_fw_dbg_copy_tlv(struct iwl_trans *trans, struct iwl_ucode_tlv *tlv,
 	int copy_size = le32_to_cpu(tlv->length) + sizeof(*tlv);
 	int offset_size = copy_size;
 
+	if (le32_to_cpu(header->tlv_version) != 1)
+		return;
+
 	if (WARN_ONCE(apply_point >= IWL_FW_INI_APPLY_NUM,
 		      "Invalid apply point id %d\n", apply_point))
 		return;
@@ -132,6 +135,9 @@ void iwl_alloc_dbg_tlv(struct iwl_trans *trans, size_t len, const u8 *data,
 		hdr = (void *)&tlv->data[0];
 		apply = le32_to_cpu(hdr->apply_point);
 
+		if (le32_to_cpu(hdr->tlv_version) != 1)
+			continue;
+
 		IWL_DEBUG_FW(trans, "Read TLV %x, apply point %d\n",
 			     le32_to_cpu(tlv->type), apply);
 
-- 
2.20.1

