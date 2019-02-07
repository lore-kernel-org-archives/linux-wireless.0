Return-Path: <SRS0=Kusg=QO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED4B8C282C2
	for <linux-wireless@archiver.kernel.org>; Thu,  7 Feb 2019 22:36:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C74A52173B
	for <linux-wireless@archiver.kernel.org>; Thu,  7 Feb 2019 22:36:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726902AbfBGWgn (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 7 Feb 2019 17:36:43 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:56590 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726642AbfBGWgl (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 7 Feb 2019 17:36:41 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1grsHf-0002II-95; Fri, 08 Feb 2019 00:36:39 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Shahar S Matityahu <shahar.s.matityahu@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Fri,  8 Feb 2019 00:36:10 +0200
Message-Id: <20190207223622.9642-6-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190207223622.9642-1-luca@coelho.fi>
References: <20190207223622.9642-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 05/17] iwlwifi: dbg_ini: implement monitor sram memory dump
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Shahar S Matityahu <shahar.s.matityahu@intel.com>

Implement monitor sram memory dump in the new dump mechanism.

Signed-off-by: Shahar S Matityahu <shahar.s.matityahu@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c  | 23 +++++++++++++++-----
 drivers/net/wireless/intel/iwlwifi/iwl-csr.h |  1 +
 2 files changed, 18 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
index 390401300fcf..de6db880d5ce 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
@@ -1284,6 +1284,7 @@ static int iwl_fw_ini_get_trigger_len(struct iwl_fw_runtime *fwrt,
 		case IWL_FW_INI_REGION_PERIPHERY_MAC:
 		case IWL_FW_INI_REGION_PERIPHERY_PHY:
 		case IWL_FW_INI_REGION_PERIPHERY_AUX:
+		case IWL_FW_INI_REGION_INTERNAL_BUFFER:
 		case IWL_FW_INI_REGION_CSR:
 			size += hdr_len + dump_header_len + range_header_len *
 				iwl_dump_ini_mem_ranges(fwrt, reg) +
@@ -1312,7 +1313,6 @@ static int iwl_fw_ini_get_trigger_len(struct iwl_fw_runtime *fwrt,
 		}
 		case IWL_FW_INI_REGION_DRAM_BUFFER:
 			/* Transport takes care of DRAM dumping */
-		case IWL_FW_INI_REGION_INTERNAL_BUFFER:
 		case IWL_FW_INI_REGION_DRAM_IMR:
 			/* Undefined yet */
 		default:
@@ -1346,6 +1346,7 @@ static void iwl_fw_ini_dump_trigger(struct iwl_fw_runtime *fwrt,
 		type = le32_to_cpu(reg->region_type);
 		switch (type) {
 		case IWL_FW_INI_REGION_DEVICE_MEMORY:
+		case IWL_FW_INI_REGION_INTERNAL_BUFFER:
 			ops.get_num_of_ranges = iwl_dump_ini_mem_ranges;
 			ops.get_size = iwl_dump_ini_mem_get_size;
 			ops.fill_mem_hdr = iwl_dump_ini_mem_fill_header;
@@ -1396,7 +1397,6 @@ static void iwl_fw_ini_dump_trigger(struct iwl_fw_runtime *fwrt,
 			iwl_dump_ini_mem(fwrt, type, data, reg, &ops);
 			break;
 		case IWL_FW_INI_REGION_DRAM_IMR:
-		case IWL_FW_INI_REGION_INTERNAL_BUFFER:
 			/* This is undefined yet */
 		default:
 			break;
@@ -1853,7 +1853,8 @@ iwl_fw_dbg_buffer_allocation(struct iwl_fw_runtime *fwrt, u32 size)
 }
 
 static void iwl_fw_dbg_buffer_apply(struct iwl_fw_runtime *fwrt,
-				    struct iwl_fw_ini_allocation_data *alloc)
+				    struct iwl_fw_ini_allocation_data *alloc,
+				    enum iwl_fw_ini_apply_point pnt)
 {
 	struct iwl_trans *trans = fwrt->trans;
 	struct iwl_ldbg_config_cmd ldbg_cmd = {
@@ -1867,9 +1868,19 @@ static void iwl_fw_dbg_buffer_apply(struct iwl_fw_runtime *fwrt,
 		.len[0] = sizeof(ldbg_cmd),
 	};
 	int block_idx = trans->num_blocks;
+	u32 buf_location = le32_to_cpu(alloc->tlv.buffer_location);
+
+	if (buf_location == IWL_FW_INI_LOCATION_SRAM_PATH) {
+		if (!WARN(pnt != IWL_FW_INI_APPLY_EARLY,
+			  "Invalid apply point %d for SMEM buffer allocation",
+			  pnt))
+			/* set sram monitor by enabling bit 7 */
+			iwl_set_bit(fwrt->trans, CSR_HW_IF_CONFIG_REG,
+				    CSR_HW_IF_CONFIG_REG_BIT_MONITOR_SRAM);
+		return;
+	}
 
-	if (le32_to_cpu(alloc->tlv.buffer_location) !=
-	    IWL_FW_INI_LOCATION_DRAM_PATH)
+	if (buf_location != IWL_FW_INI_LOCATION_DRAM_PATH)
 		return;
 
 	if (!alloc->is_alloc) {
@@ -2017,7 +2028,7 @@ static void _iwl_fw_dbg_apply_point(struct iwl_fw_runtime *fwrt,
 		case IWL_UCODE_TLV_TYPE_BUFFER_ALLOCATION: {
 			struct iwl_fw_ini_allocation_data *buf_alloc = ini_tlv;
 
-			iwl_fw_dbg_buffer_apply(fwrt, ini_tlv);
+			iwl_fw_dbg_buffer_apply(fwrt, ini_tlv, pnt);
 			iter += sizeof(buf_alloc->is_alloc);
 			break;
 		}
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-csr.h b/drivers/net/wireless/intel/iwlwifi/iwl-csr.h
index 42af421bbc3c..d0ce3a79c387 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-csr.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-csr.h
@@ -180,6 +180,7 @@
 /* Bits for CSR_HW_IF_CONFIG_REG */
 #define CSR_HW_IF_CONFIG_REG_MSK_MAC_DASH	(0x00000003)
 #define CSR_HW_IF_CONFIG_REG_MSK_MAC_STEP	(0x0000000C)
+#define CSR_HW_IF_CONFIG_REG_BIT_MONITOR_SRAM	(0x00000080)
 #define CSR_HW_IF_CONFIG_REG_MSK_BOARD_VER	(0x000000C0)
 #define CSR_HW_IF_CONFIG_REG_BIT_MAC_SI		(0x00000100)
 #define CSR_HW_IF_CONFIG_REG_BIT_RADIO_SI	(0x00000200)
-- 
2.20.1

