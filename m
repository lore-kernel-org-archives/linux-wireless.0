Return-Path: <SRS0=OIIa=QG=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E967FC282D7
	for <linux-wireless@archiver.kernel.org>; Wed, 30 Jan 2019 11:56:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C37E420882
	for <linux-wireless@archiver.kernel.org>; Wed, 30 Jan 2019 11:56:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730834AbfA3L41 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 30 Jan 2019 06:56:27 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:52860 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730308AbfA3L41 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 30 Jan 2019 06:56:27 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1gooTE-0003x8-4O; Wed, 30 Jan 2019 13:55:57 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Shahar S Matityahu <shahar.s.matityahu@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Wed, 30 Jan 2019 13:55:25 +0200
Message-Id: <20190130115528.19922-15-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190130115528.19922-1-luca@coelho.fi>
References: <20190130115528.19922-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 14/17] iwlwifi: fix fallthrough comment in iwl-dnt-cfg.c
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Shahar S Matityahu <shahar.s.matityahu@intel.com>

I placed the fall through comment in the wrong case.  Move it to the
right place.

Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 .../wireless/intel/iwlwifi/fw/api/dbg-tlv.h   | 22 +++++++++----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/api/dbg-tlv.h b/drivers/net/wireless/intel/iwlwifi/fw/api/dbg-tlv.h
index b2ab675b3cf8..4926950d432a 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/api/dbg-tlv.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/api/dbg-tlv.h
@@ -70,7 +70,7 @@ struct iwl_fw_ini_header {
 	__le32 tlv_version;
 	__le32 apply_point;
 	u8 data[];
-} __packed; /* FW_INI_HEADER_TLV_S */
+} __packed; /* FW_DEBUG_TLV_HEADER_S */
 
 /**
  * struct iwl_fw_ini_allocation_tlv - (IWL_FW_INI_TLV_TYPE_BUFFER_ALLOCATION)
@@ -92,7 +92,7 @@ struct iwl_fw_ini_allocation_tlv {
 	__le32 size;
 	__le32 max_fragments;
 	__le32 min_frag_size;
-} __packed; /* FW_INI_BUFFER_ALLOCATION_TLV_S_VER_1 */
+} __packed; /* FW_DEBUG_TLV_BUFFER_ALLOCATION_TLV_S_VER_1 */
 
 /**
  * struct iwl_fw_ini_hcmd (IWL_FW_INI_TLV_TYPE_HCMD)
@@ -108,7 +108,7 @@ struct iwl_fw_ini_hcmd {
 	u8 group;
 	__le16 padding;
 	u8 data[0];
-} __packed; /* FW_INI_HCMD_S */
+} __packed; /* FW_DEBUG_TLV_HCMD_DATA_S */
 
 /**
  * struct iwl_fw_ini_hcmd_tlv
@@ -118,7 +118,7 @@ struct iwl_fw_ini_hcmd {
 struct iwl_fw_ini_hcmd_tlv {
 	struct iwl_fw_ini_header header;
 	struct iwl_fw_ini_hcmd hcmd;
-} __packed; /* FW_INI_HCMD_TLV_S_VER_1 */
+} __packed; /* FW_DEBUG_TLV_HCMD_S_VER_1 */
 
 /*
  * struct iwl_fw_ini_debug_flow_tlv (IWL_FW_INI_TLV_TYPE_DEBUG_FLOW)
@@ -129,7 +129,7 @@ struct iwl_fw_ini_hcmd_tlv {
 struct iwl_fw_ini_debug_flow_tlv {
 	struct iwl_fw_ini_header header;
 	__le32 debug_flow_cfg;
-} __packed; /* FW_INI_DEBUG_FLOW_TLV_S_VER_1 */
+} __packed; /* FW_DEBUG_TLV_FLOW_TLV_S_VER_1 */
 
 #define IWL_FW_INI_MAX_REGION_ID	64
 #define IWL_FW_INI_MAX_NAME		32
@@ -176,7 +176,7 @@ struct iwl_fw_ini_region_tlv {
  * struct iwl_fw_ini_trigger - (IWL_FW_INI_TLV_TYPE_DUMP_CFG)
  * Region sections define IDs and triggers that use those IDs TLV
  *
- * @trigger_id: enum &iwl_fw_ini_tigger_id
+ * @trigger_id: enum &iwl_fw_ini_trigger_id
  * @ignore_default: override FW TLV with binary TLV
  * @dump_delay: delay from trigger fire to dump, in usec
  * @occurrences: max amount of times to be fired
@@ -322,7 +322,7 @@ enum iwl_fw_ini_apply_point {
 	IWL_FW_INI_APPLY_MISSED_BEACONS,
 	IWL_FW_INI_APPLY_SCAN_COMPLETE,
 	IWL_FW_INI_APPLY_NUM,
-}; /* FW_INI_APPLY_POINT_E_VER_1 */
+}; /* FW_DEBUG_TLV_APPLY_POINT_E_VER_1 */
 
 /**
  * enum iwl_fw_ini_allocation_id
@@ -342,7 +342,7 @@ enum iwl_fw_ini_allocation_id {
 	IWL_FW_INI_ALLOCATION_ID_SDFX,
 	IWL_FW_INI_ALLOCATION_ID_FW_DUMP,
 	IWL_FW_INI_ALLOCATION_ID_USER_DEFINED,
-}; /* FW_INI_ALLOCATION_ID_E_VER_1 */
+}; /* FW_DEBUG_TLV_ALLOCATION_ID_E_VER_1 */
 
 /**
  * enum iwl_fw_ini_buffer_location
@@ -354,7 +354,7 @@ enum iwl_fw_ini_buffer_location {
 	IWL_FW_INI_LOCATION_INVALID,
 	IWL_FW_INI_LOCATION_SRAM_PATH,
 	IWL_FW_INI_LOCATION_DRAM_PATH,
-}; /* FW_INI_BUFFER_LOCATION_E_VER_1 */
+}; /* FW_DEBUG_TLV_BUFFER_LOCATION_E_VER_1 */
 
 /**
  * enum iwl_fw_ini_debug_flow
@@ -366,7 +366,7 @@ enum iwl_fw_ini_debug_flow {
 	IWL_FW_INI_DEBUG_INVALID,
 	IWL_FW_INI_DEBUG_DBTR_FLOW,
 	IWL_FW_INI_DEBUG_TB2DTF_FLOW,
-}; /* FW_INI_DEBUG_FLOW_E_VER_1 */
+}; /* FW_DEBUG_TLV_FLOW_E_VER_1 */
 
 /**
  * enum iwl_fw_ini_region_type
@@ -398,6 +398,6 @@ enum iwl_fw_ini_region_type {
 	IWL_FW_INI_REGION_PAGING,
 	IWL_FW_INI_REGION_CSR,
 	IWL_FW_INI_REGION_NUM
-}; /* FW_INI_REGION_TYPE_E_VER_1*/
+}; /* FW_DEBUG_TLV_REGION_TYPE_E_VER_1 */
 
 #endif
-- 
2.20.1

