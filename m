Return-Path: <SRS0=odSX=SZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9361C10F14
	for <linux-wireless@archiver.kernel.org>; Tue, 23 Apr 2019 09:11:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C295D206BA
	for <linux-wireless@archiver.kernel.org>; Tue, 23 Apr 2019 09:11:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727068AbfDWJLv (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 23 Apr 2019 05:11:51 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:59052 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726130AbfDWJLv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 23 Apr 2019 05:11:51 -0400
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <luca@coelho.fi>)
        id 1hIrS4-0000FN-1e; Tue, 23 Apr 2019 12:10:56 +0300
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Shahar S Matityahu <shahar.s.matityahu@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Subject: [PATCH 12/16] iwlwifi: dbg_ini: add lmac and umac error tables dumping support
Date:   Tue, 23 Apr 2019 12:10:39 +0300
Message-Id: <20190423091043.7156-13-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190423091043.7156-1-luca@coelho.fi>
References: <20190423091043.7156-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Shahar S Matityahu <shahar.s.matityahu@intel.com>

Add LMAC_ERROR_TABLE and UMAC_ERROR_TABLE region types and handle them
in the same way as we handle DEVICE_MEMORY.

Signed-off-by: Shahar S Matityahu <shahar.s.matityahu@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/fw/api/dbg-tlv.h | 4 ++++
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c         | 8 +++++++-
 2 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/api/dbg-tlv.h b/drivers/net/wireless/intel/iwlwifi/fw/api/dbg-tlv.h
index af1e3d08c179..f4202bc231a6 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/api/dbg-tlv.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/api/dbg-tlv.h
@@ -473,6 +473,8 @@ enum iwl_fw_ini_debug_flow {
  * @IWL_FW_INI_REGION_CSR: CSR registers
  * @IWL_FW_INI_REGION_NOTIFICATION: FW notification data
  * @IWL_FW_INI_REGION_DHC: dhc response to dump
+ * @IWL_FW_INI_REGION_LMAC_ERROR_TABLE: lmac error table
+ * @IWL_FW_INI_REGION_UMAC_ERROR_TABLE: umac error table
  * @IWL_FW_INI_REGION_NUM: number of region types
  */
 enum iwl_fw_ini_region_type {
@@ -490,6 +492,8 @@ enum iwl_fw_ini_region_type {
 	IWL_FW_INI_REGION_CSR,
 	IWL_FW_INI_REGION_NOTIFICATION,
 	IWL_FW_INI_REGION_DHC,
+	IWL_FW_INI_REGION_LMAC_ERROR_TABLE,
+	IWL_FW_INI_REGION_UMAC_ERROR_TABLE,
 	IWL_FW_INI_REGION_NUM
 }; /* FW_DEBUG_TLV_REGION_TYPE_E_VER_1 */
 
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
index 79e36336f623..035eeeabfc8c 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
@@ -1760,6 +1760,8 @@ static int iwl_fw_ini_get_trigger_len(struct iwl_fw_runtime *fwrt,
 		case IWL_FW_INI_REGION_PERIPHERY_PHY:
 		case IWL_FW_INI_REGION_PERIPHERY_AUX:
 		case IWL_FW_INI_REGION_CSR:
+		case IWL_FW_INI_REGION_LMAC_ERROR_TABLE:
+		case IWL_FW_INI_REGION_UMAC_ERROR_TABLE:
 			size += hdr_len + iwl_dump_ini_mem_get_size(fwrt, reg);
 			break;
 		case IWL_FW_INI_REGION_TXF:
@@ -1821,6 +1823,8 @@ static void iwl_fw_ini_dump_trigger(struct iwl_fw_runtime *fwrt,
 
 		switch (le32_to_cpu(reg->region_type)) {
 		case IWL_FW_INI_REGION_DEVICE_MEMORY:
+		case IWL_FW_INI_REGION_LMAC_ERROR_TABLE:
+		case IWL_FW_INI_REGION_UMAC_ERROR_TABLE:
 			ops.get_num_of_ranges = iwl_dump_ini_mem_ranges;
 			ops.get_size = iwl_dump_ini_mem_get_size;
 			ops.fill_mem_hdr = iwl_dump_ini_mem_fill_header;
@@ -2498,7 +2502,9 @@ static void iwl_fw_dbg_update_regions(struct iwl_fw_runtime *fwrt,
 			 type == IWL_FW_INI_REGION_PERIPHERY_AUX ||
 			 type == IWL_FW_INI_REGION_INTERNAL_BUFFER ||
 			 type == IWL_FW_INI_REGION_PAGING ||
-			 type == IWL_FW_INI_REGION_CSR)
+			 type == IWL_FW_INI_REGION_CSR ||
+			 type == IWL_FW_INI_REGION_LMAC_ERROR_TABLE ||
+			 type == IWL_FW_INI_REGION_UMAC_ERROR_TABLE)
 			iter += le32_to_cpu(reg->internal.num_of_ranges) *
 				sizeof(__le32);
 
-- 
2.20.1

