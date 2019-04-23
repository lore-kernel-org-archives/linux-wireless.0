Return-Path: <SRS0=odSX=SZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2450C282DD
	for <linux-wireless@archiver.kernel.org>; Tue, 23 Apr 2019 09:11:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 87EE3206BA
	for <linux-wireless@archiver.kernel.org>; Tue, 23 Apr 2019 09:11:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726790AbfDWJLd (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 23 Apr 2019 05:11:33 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:59022 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726130AbfDWJLd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 23 Apr 2019 05:11:33 -0400
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <luca@coelho.fi>)
        id 1hIrS5-0000FN-0m; Tue, 23 Apr 2019 12:10:57 +0300
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Shahar S Matityahu <shahar.s.matityahu@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Subject: [PATCH 14/16] iwlwifi: dbg: replace dump info device family with HW type
Date:   Tue, 23 Apr 2019 12:10:41 +0300
Message-Id: <20190423091043.7156-15-luca@coelho.fi>
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

In the dump info, the driver sets device_family to
IWL_FW_ERROR_DUMP_FAMILY_7 in case IWL_FW_ERROR_DUMP_FAMILY_7 is used or
IWL_FW_ERROR_DUMP_FAMILY_8 otherwise. This information is misleading and
incorrect since the driver sets the device family to 8 to any device that
is from family 8 and later, e.g. device family 9 is represented as 8 in
the dump.
Also, the device family enum is known only to the driver and
does not give any information to the FW developer

Change the device family to HW type to give propper data about the nic
in use.

Signed-off-by: Shahar S Matityahu <shahar.s.matityahu@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c        | 7 ++-----
 drivers/net/wireless/intel/iwlwifi/fw/error-dump.h | 4 ++--
 drivers/net/wireless/intel/iwlwifi/iwl-csr.h       | 1 +
 3 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
index d8c4fdb8d4a1..4ef447480aaf 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
@@ -917,11 +917,8 @@ iwl_fw_error_dump_file(struct iwl_fw_runtime *fwrt,
 		dump_data->type = cpu_to_le32(IWL_FW_ERROR_DUMP_DEV_FW_INFO);
 		dump_data->len = cpu_to_le32(sizeof(*dump_info));
 		dump_info = (void *)dump_data->data;
-		dump_info->device_family =
-			fwrt->trans->cfg->device_family ==
-			IWL_DEVICE_FAMILY_7000 ?
-				cpu_to_le32(IWL_FW_ERROR_DUMP_FAMILY_7) :
-				cpu_to_le32(IWL_FW_ERROR_DUMP_FAMILY_8);
+		dump_info->hw_type =
+			cpu_to_le32(CSR_HW_REV_TYPE(fwrt->trans->hw_rev));
 		dump_info->hw_step =
 			cpu_to_le32(CSR_HW_REV_STEP(fwrt->trans->hw_rev));
 		memcpy(dump_info->fw_human_readable, fwrt->fw->human_readable,
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/error-dump.h b/drivers/net/wireless/intel/iwlwifi/fw/error-dump.h
index 260097c75427..0feff4c33e39 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/error-dump.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/error-dump.h
@@ -184,7 +184,7 @@ enum iwl_fw_error_dump_family {
 
 /**
  * struct iwl_fw_error_dump_info - info on the device / firmware
- * @device_family: the family of the device (7 / 8)
+ * @hw_type: the type of the device
  * @hw_step: the step of the device
  * @fw_human_readable: human readable FW version
  * @dev_human_readable: name of the device
@@ -196,7 +196,7 @@ enum iwl_fw_error_dump_family {
  *	if the dump collection was not initiated by an assert, the value is 0
  */
 struct iwl_fw_error_dump_info {
-	__le32 device_family;
+	__le32 hw_type;
 	__le32 hw_step;
 	u8 fw_human_readable[FW_VER_HUMAN_READABLE_SZ];
 	u8 dev_human_readable[64];
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-csr.h b/drivers/net/wireless/intel/iwlwifi/iwl-csr.h
index 2b98ecdcf301..553554846009 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-csr.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-csr.h
@@ -290,6 +290,7 @@
 /* HW REV */
 #define CSR_HW_REV_DASH(_val)          (((_val) & 0x0000003) >> 0)
 #define CSR_HW_REV_STEP(_val)          (((_val) & 0x000000C) >> 2)
+#define CSR_HW_REV_TYPE(_val)          (((_val) & 0x000FFF0) >> 4)
 
 /* HW RFID */
 #define CSR_HW_RFID_FLAVOR(_val)       (((_val) & 0x000000F) >> 0)
-- 
2.20.1

