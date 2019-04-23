Return-Path: <SRS0=odSX=SZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5D4EC10F14
	for <linux-wireless@archiver.kernel.org>; Tue, 23 Apr 2019 09:11:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9E0FE206BA
	for <linux-wireless@archiver.kernel.org>; Tue, 23 Apr 2019 09:11:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726950AbfDWJLh (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 23 Apr 2019 05:11:37 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:59028 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726130AbfDWJLg (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 23 Apr 2019 05:11:36 -0400
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <luca@coelho.fi>)
        id 1hIrS3-0000FN-Ia; Tue, 23 Apr 2019 12:10:55 +0300
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Subject: [PATCH 11/16] iwlwifi: parse command version TLV
Date:   Tue, 23 Apr 2019 12:10:38 +0300
Message-Id: <20190423091043.7156-12-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190423091043.7156-1-luca@coelho.fi>
References: <20190423091043.7156-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

In newer firmware images there's a command version TLV that
states, for each listed command or notification, which version
of the command and/or notification structure is used. Read and
keep this data to be able to use it in the future.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/fw/file.h | 17 +++++++++++++++++
 drivers/net/wireless/intel/iwlwifi/fw/img.h  |  7 +++++--
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c | 18 ++++++++++++++++++
 3 files changed, 40 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/file.h b/drivers/net/wireless/intel/iwlwifi/fw/file.h
index 2faec36f3d76..b0671e16e1ce 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/file.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/file.h
@@ -142,6 +142,7 @@ enum iwl_ucode_tlv_type {
 	IWL_UCODE_TLV_FW_DBG_DEST	= 38,
 	IWL_UCODE_TLV_FW_DBG_CONF	= 39,
 	IWL_UCODE_TLV_FW_DBG_TRIGGER	= 40,
+	IWL_UCODE_TLV_CMD_VERSIONS	= 48,
 	IWL_UCODE_TLV_FW_GSCAN_CAPA	= 50,
 	IWL_UCODE_TLV_FW_MEM_SEG	= 51,
 	IWL_UCODE_TLV_IML		= 52,
@@ -943,4 +944,20 @@ struct iwl_fw_dbg_conf_tlv {
 	struct iwl_fw_dbg_conf_hcmd hcmd;
 } __packed;
 
+#define IWL_FW_CMD_VER_UNKNOWN 99
+
+/**
+ * struct iwl_fw_cmd_version - firmware command version entry
+ * @cmd: command ID
+ * @group: group ID
+ * @cmd_ver: command version
+ * @notif_ver: notification version
+ */
+struct iwl_fw_cmd_version {
+	u8 cmd;
+	u8 group;
+	u8 cmd_ver;
+	u8 notif_ver;
+} __packed;
+
 #endif  /* __iwl_fw_file_h__ */
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/img.h b/drivers/net/wireless/intel/iwlwifi/fw/img.h
index f4c5a4d73206..18ca5f152be6 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/img.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/img.h
@@ -8,7 +8,7 @@
  * Copyright(c) 2008 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
  * Copyright(c) 2016        Intel Deutschland GmbH
- * Copyright(c) 2018 Intel Corporation
+ * Copyright(c) 2018 - 2019 Intel Corporation
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -31,7 +31,7 @@
  * Copyright(c) 2005 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
  * Copyright(c) 2016        Intel Deutschland GmbH
- * Copyright(c) 2018 Intel Corporation
+ * Copyright(c) 2018 - 2019 Intel Corporation
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
@@ -109,6 +109,9 @@ struct iwl_ucode_capabilities {
 	u32 error_log_size;
 	unsigned long _api[BITS_TO_LONGS(NUM_IWL_UCODE_TLV_API)];
 	unsigned long _capa[BITS_TO_LONGS(NUM_IWL_UCODE_TLV_CAPA)];
+
+	const struct iwl_fw_cmd_version *cmd_versions;
+	u32 n_cmd_versions;
 };
 
 static inline bool
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
index 1ad739bace0f..852d3cbfc719 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
@@ -179,6 +179,7 @@ static void iwl_dealloc_ucode(struct iwl_drv *drv)
 		kfree(drv->fw.dbg.trigger_tlv[i]);
 	kfree(drv->fw.dbg.mem_tlv);
 	kfree(drv->fw.iml);
+	kfree(drv->fw.ucode_capa.cmd_versions);
 
 	for (i = 0; i < IWL_UCODE_TYPE_MAX; i++)
 		iwl_free_fw_img(drv, drv->fw.img + i);
@@ -1144,6 +1145,23 @@ static int iwl_parse_tlv_firmware(struct iwl_drv *drv,
 			if (iwlwifi_mod_params.enable_ini)
 				iwl_fw_dbg_copy_tlv(drv->trans, tlv, false);
 			break;
+		case IWL_UCODE_TLV_CMD_VERSIONS:
+			if (tlv_len % sizeof(struct iwl_fw_cmd_version)) {
+				IWL_ERR(drv,
+					"Invalid length for command versions: %u\n",
+					tlv_len);
+				tlv_len /= sizeof(struct iwl_fw_cmd_version);
+				tlv_len *= sizeof(struct iwl_fw_cmd_version);
+			}
+			if (WARN_ON(capa->cmd_versions))
+				return -EINVAL;
+			capa->cmd_versions = kmemdup(tlv_data, tlv_len,
+						     GFP_KERNEL);
+			if (!capa->cmd_versions)
+				return -ENOMEM;
+			capa->n_cmd_versions =
+				tlv_len / sizeof(struct iwl_fw_cmd_version);
+			break;
 		default:
 			IWL_DEBUG_INFO(drv, "unknown TLV: %d\n", tlv_type);
 			break;
-- 
2.20.1

