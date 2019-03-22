Return-Path: <SRS0=qAgV=RZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41AB6C43381
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Mar 2019 13:59:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 10AE2218A5
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Mar 2019 13:59:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727880AbfCVN7U (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 22 Mar 2019 09:59:20 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:46104 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727487AbfCVN7T (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 22 Mar 2019 09:59:19 -0400
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1h7KhY-0000bK-ND; Fri, 22 Mar 2019 15:59:18 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Shahar S Matityahu <shahar.s.matityahu@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Fri, 22 Mar 2019 15:58:45 +0200
Message-Id: <20190322135903.10631-7-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190322135903.10631-1-luca@coelho.fi>
References: <20190322135903.10631-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 06/24] iwlwifi: dbg_ini: add region id to the region dump
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Shahar S Matityahu <shahar.s.matityahu@intel.com>

Add the region id of the collected memory to the header of the memory
region.

Signed-off-by: Shahar S Matityahu <shahar.s.matityahu@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c        | 1 +
 drivers/net/wireless/intel/iwlwifi/fw/error-dump.h | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
index 81ce8a46ff11..a014fb729f48 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
@@ -1606,6 +1606,7 @@ iwl_dump_ini_mem(struct iwl_fw_runtime *fwrt,
 	(*data)->type = cpu_to_le32(type | INI_DUMP_BIT);
 	(*data)->len = cpu_to_le32(ops->get_size(fwrt, reg));
 
+	header->region_id = reg->region_id;
 	header->num_of_ranges = cpu_to_le32(num_of_ranges);
 	header->name_len = cpu_to_le32(min_t(int, IWL_FW_INI_MAX_NAME,
 					     le32_to_cpu(reg->name_len)));
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/error-dump.h b/drivers/net/wireless/intel/iwlwifi/fw/error-dump.h
index a2339021153f..ac2589bfedb2 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/error-dump.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/error-dump.h
@@ -297,12 +297,14 @@ struct iwl_fw_ini_error_dump_range {
 /**
  * struct iwl_fw_ini_error_dump_header - ini region dump header
  * @version: dump version
+ * @region_id: id of the region
  * @num_of_ranges: number of ranges in this region
  * @name_len: number of bytes allocated to the name string of this region
  * @name: name of the region
  */
 struct iwl_fw_ini_error_dump_header {
 	__le32 version;
+	__le32 region_id;
 	__le32 num_of_ranges;
 	__le32 name_len;
 	u8 name[IWL_FW_INI_MAX_NAME];
-- 
2.20.1

