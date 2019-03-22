Return-Path: <SRS0=qAgV=RZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 840B0C43381
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Mar 2019 14:00:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5C00E218A5
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Mar 2019 14:00:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727977AbfCVOAB (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 22 Mar 2019 10:00:01 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:46226 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727946AbfCVOAB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 22 Mar 2019 10:00:01 -0400
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1h7Khf-0000bK-RJ; Fri, 22 Mar 2019 15:59:24 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Shahar S Matityahu <shahar.s.matityahu@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Fri, 22 Mar 2019 15:58:53 +0200
Message-Id: <20190322135903.10631-15-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190322135903.10631-1-luca@coelho.fi>
References: <20190322135903.10631-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 14/24] iwlwifi: dbg_ini: remove redundant curly brackets from trigger collection flow
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Shahar S Matityahu <shahar.s.matityahu@intel.com>

remove redundant curly brackets from iwl_fw_ini_dump_trigger and
iwl_fw_ini_get_trigger_len

Signed-off-by: Shahar S Matityahu <shahar.s.matityahu@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
index 87da6125683a..3709e90b55f1 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
@@ -1746,7 +1746,7 @@ static int iwl_fw_ini_get_trigger_len(struct iwl_fw_runtime *fwrt,
 		case IWL_FW_INI_REGION_RXF:
 			size += hdr_len + iwl_dump_ini_rxf_get_size(fwrt, reg);
 			break;
-		case IWL_FW_INI_REGION_PAGING: {
+		case IWL_FW_INI_REGION_PAGING:
 			size += hdr_len;
 			if (iwl_fw_dbg_is_paging_enabled(fwrt)) {
 				size += iwl_dump_ini_paging_get_size(fwrt, reg);
@@ -1755,7 +1755,6 @@ static int iwl_fw_ini_get_trigger_len(struct iwl_fw_runtime *fwrt,
 									  reg);
 			}
 			break;
-		}
 		case IWL_FW_INI_REGION_DRAM_BUFFER:
 			if (!fwrt->trans->num_blocks)
 				break;
@@ -1831,7 +1830,7 @@ static void iwl_fw_ini_dump_trigger(struct iwl_fw_runtime *fwrt,
 			ops.fill_range = iwl_dump_ini_dev_mem_iter;
 			iwl_dump_ini_mem(fwrt, type, data, reg, &ops);
 			break;
-		case IWL_FW_INI_REGION_PAGING: {
+		case IWL_FW_INI_REGION_PAGING:
 			ops.fill_mem_hdr = iwl_dump_ini_mem_fill_header;
 			if (iwl_fw_dbg_is_paging_enabled(fwrt)) {
 				ops.get_num_of_ranges =
@@ -1848,7 +1847,6 @@ static void iwl_fw_ini_dump_trigger(struct iwl_fw_runtime *fwrt,
 
 			iwl_dump_ini_mem(fwrt, type, data, reg, &ops);
 			break;
-		}
 		case IWL_FW_INI_REGION_TXF: {
 			struct iwl_ini_txf_iter_data iter = { .init = true };
 			void *fifo_iter = fwrt->dump.fifo_iter;
-- 
2.20.1

