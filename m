Return-Path: <SRS0=Ms0V=QP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 541A3C282CB
	for <linux-wireless@archiver.kernel.org>; Fri,  8 Feb 2019 10:47:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2C63821919
	for <linux-wireless@archiver.kernel.org>; Fri,  8 Feb 2019 10:47:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727723AbfBHKr2 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 8 Feb 2019 05:47:28 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:56990 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727649AbfBHKr1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 8 Feb 2019 05:47:27 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1gs3gq-0002jg-GV; Fri, 08 Feb 2019 12:47:25 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Shahar S Matityahu <shahar.s.matityahu@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Fri,  8 Feb 2019 12:46:59 +0200
Message-Id: <20190208104712.16210-8-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190208104712.16210-1-luca@coelho.fi>
References: <20190208104712.16210-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 07/20] iwlwifi: mvm: add a debug_enable op
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Shahar S Matityahu <shahar.s.matityahu@intel.com>

D3 debug data is disabled by default. Currently it is done by tampering
the dump mask. Add an operation that will allow this to be changed
without recompilation.

Signed-off-by: Shahar S Matityahu <shahar.s.matityahu@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/fw/dbg.h        | 4 +++-
 drivers/net/wireless/intel/iwlwifi/fw/runtime.h    | 5 +++--
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c       | 6 ++++--
 drivers/net/wireless/intel/iwlwifi/mvm/constants.h | 3 +++
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c       | 6 ++++++
 5 files changed, 19 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/dbg.h b/drivers/net/wireless/intel/iwlwifi/fw/dbg.h
index 3ee86d18a97d..16656949b505 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/dbg.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/dbg.h
@@ -376,7 +376,9 @@ static inline bool iwl_fw_dbg_is_d3_debug_enabled(struct iwl_fw_runtime *fwrt)
 {
 	return fw_has_capa(&fwrt->fw->ucode_capa,
 			   IWL_UCODE_TLV_CAPA_D3_DEBUG) &&
-		fwrt->trans->cfg->d3_debug_data_length &&
+		fwrt->trans->cfg->d3_debug_data_length && fwrt->ops &&
+		fwrt->ops->d3_debug_enable &&
+		fwrt->ops->d3_debug_enable(fwrt->ops_ctx) &&
 		iwl_fw_dbg_type_on(fwrt, IWL_FW_ERROR_DUMP_D3_DEBUG_DATA);
 }
 
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/runtime.h b/drivers/net/wireless/intel/iwlwifi/fw/runtime.h
index 2bbae7a1f492..41c4a3e7ad82 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/runtime.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/runtime.h
@@ -6,7 +6,7 @@
  * GPL LICENSE SUMMARY
  *
  * Copyright(c) 2017 Intel Deutschland GmbH
- * Copyright(c) 2018 Intel Corporation
+ * Copyright (C) 2018-2019 Intel Corporation
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -27,7 +27,7 @@
  * BSD LICENSE
  *
  * Copyright(c) 2017 Intel Deutschland GmbH
- * Copyright(c) 2018 Intel Corporation
+ * Copyright (C) 2018-2019 Intel Corporation
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
@@ -73,6 +73,7 @@ struct iwl_fw_runtime_ops {
 	void (*dump_end)(void *ctx);
 	bool (*fw_running)(void *ctx);
 	int (*send_hcmd)(void *ctx, struct iwl_host_cmd *host_cmd);
+	bool (*d3_debug_enable)(void *ctx);
 };
 
 #define MAX_NUM_LMAC 2
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
index 91ec90e5eb67..4b75a93c7364 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
@@ -8,6 +8,7 @@
  * Copyright(c) 2007 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
  * Copyright(c) 2016 - 2017 Intel Deutschland GmbH
+ * Copyright(c) 2018 - 2019 Intel Corporation
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -30,6 +31,7 @@
  * Copyright(c) 2005 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
  * Copyright(c) 2016 - 2017 Intel Deutschland GmbH
+ * Copyright(c) 2018 - 2019 Intel Corporation
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
@@ -1311,8 +1313,8 @@ static void iwl_req_fw_callback(const struct firmware *ucode_raw, void *context)
 	fw->ucode_capa.standard_phy_calibration_size =
 			IWL_DEFAULT_STANDARD_PHY_CALIBRATE_TBL_SIZE;
 	fw->ucode_capa.n_scan_channels = IWL_DEFAULT_SCAN_CHANNELS;
-	/* dump all fw memory areas by default except d3 debug data */
-	fw->dbg.dump_mask = 0xfffdffff;
+	/* dump all fw memory areas by default */
+	fw->dbg.dump_mask = 0xffffffff;
 
 	pieces = kzalloc(sizeof(*pieces), GFP_KERNEL);
 	if (!pieces)
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/constants.h b/drivers/net/wireless/intel/iwlwifi/mvm/constants.h
index 58e29af12a14..6a3edea3d580 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/constants.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/constants.h
@@ -8,6 +8,7 @@
  * Copyright(c) 2013 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
  * Copyright(c) 2015        Intel Deutschland GmbH
+ * Copyright(c) 2018 - 2019 Intel Corporation
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -30,6 +31,7 @@
  * Copyright(c) 2013 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
  * Copyright(c) 2015        Intel Deutschland GmbH
+ * Copyright(c) 2018 - 2019 Intel Corporation
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
@@ -148,5 +150,6 @@
 #define IWL_MVM_ENABLE_EBS			1
 #define IWL_MVM_FTM_INITIATOR_ALGO		IWL_TOF_ALGO_TYPE_MAX_LIKE
 #define IWL_MVM_FTM_INITIATOR_DYNACK		true
+#define IWL_MVM_D3_DEBUG			false
 
 #endif /* __MVM_CONSTANTS_H */
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
index f8a5a7074dc1..0bdf92c49710 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
@@ -601,11 +601,17 @@ static int iwl_mvm_fwrt_send_hcmd(void *ctx, struct iwl_host_cmd *host_cmd)
 	return ret;
 }
 
+static bool iwl_mvm_d3_debug_enable(void *ctx)
+{
+	return IWL_MVM_D3_DEBUG;
+}
+
 static const struct iwl_fw_runtime_ops iwl_mvm_fwrt_ops = {
 	.dump_start = iwl_mvm_fwrt_dump_start,
 	.dump_end = iwl_mvm_fwrt_dump_end,
 	.fw_running = iwl_mvm_fwrt_fw_running,
 	.send_hcmd = iwl_mvm_fwrt_send_hcmd,
+	.d3_debug_enable = iwl_mvm_d3_debug_enable,
 };
 
 static struct iwl_op_mode *
-- 
2.20.1

