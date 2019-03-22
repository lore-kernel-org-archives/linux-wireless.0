Return-Path: <SRS0=qAgV=RZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4566FC43381
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Mar 2019 13:59:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1E776218A5
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Mar 2019 13:59:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727871AbfCVN7U (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 22 Mar 2019 09:59:20 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:46088 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727823AbfCVN7R (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 22 Mar 2019 09:59:17 -0400
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1h7KhX-0000bK-Rl; Fri, 22 Mar 2019 15:59:16 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Shahar S Matityahu <shahar.s.matityahu@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Fri, 22 Mar 2019 15:58:44 +0200
Message-Id: <20190322135903.10631-6-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190322135903.10631-1-luca@coelho.fi>
References: <20190322135903.10631-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 05/24] iwlwifi: dbg_ini: add version to dump header
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Shahar S Matityahu <shahar.s.matityahu@intel.com>

Add version to dump header to allow future changes of the dump struct,
once the ini debug flow becomes operational, without breaking backwards
compatibility.

Signed-off-by: Shahar S Matityahu <shahar.s.matityahu@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c        | 5 +++++
 drivers/net/wireless/intel/iwlwifi/fw/error-dump.h | 6 ++++++
 2 files changed, 11 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
index 78bca27b7809..81ce8a46ff11 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
@@ -1380,6 +1380,8 @@ static void *iwl_dump_ini_mem_fill_header(struct iwl_fw_runtime *fwrt,
 {
 	struct iwl_fw_ini_error_dump *dump = data;
 
+	dump->header.version = cpu_to_le32(IWL_INI_DUMP_MEM_VER);
+
 	return dump->ranges;
 }
 
@@ -1402,6 +1404,7 @@ static void
 					       MON_BUFF_CYCLE_CNT_VER2);
 	iwl_trans_release_nic_access(fwrt->trans, &flags);
 
+	mon_dump->header.version = cpu_to_le32(IWL_INI_DUMP_MONITOR_VER);
 	mon_dump->write_ptr = cpu_to_le32(write_ptr);
 	mon_dump->cycle_cnt = cpu_to_le32(cycle_cnt);
 
@@ -1414,6 +1417,8 @@ static void *iwl_dump_ini_fifo_fill_header(struct iwl_fw_runtime *fwrt,
 {
 	struct iwl_fw_ini_fifo_error_dump *dump = data;
 
+	dump->header.version = cpu_to_le32(IWL_INI_DUMP_FIFO_VER);
+
 	return dump->ranges;
 }
 
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/error-dump.h b/drivers/net/wireless/intel/iwlwifi/fw/error-dump.h
index ea5513050b56..a2339021153f 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/error-dump.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/error-dump.h
@@ -278,6 +278,10 @@ struct iwl_fw_error_dump_mem {
 	u8 data[];
 };
 
+#define IWL_INI_DUMP_MEM_VER 1
+#define IWL_INI_DUMP_MONITOR_VER 1
+#define IWL_INI_DUMP_FIFO_VER 1
+
 /**
  * struct iwl_fw_ini_error_dump_range - range of memory
  * @start_addr: the start address of this range
@@ -292,11 +296,13 @@ struct iwl_fw_ini_error_dump_range {
 
 /**
  * struct iwl_fw_ini_error_dump_header - ini region dump header
+ * @version: dump version
  * @num_of_ranges: number of ranges in this region
  * @name_len: number of bytes allocated to the name string of this region
  * @name: name of the region
  */
 struct iwl_fw_ini_error_dump_header {
+	__le32 version;
 	__le32 num_of_ranges;
 	__le32 name_len;
 	u8 name[IWL_FW_INI_MAX_NAME];
-- 
2.20.1

