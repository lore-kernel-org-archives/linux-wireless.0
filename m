Return-Path: <SRS0=OIIa=QG=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54B30C282D8
	for <linux-wireless@archiver.kernel.org>; Wed, 30 Jan 2019 11:55:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2771C20855
	for <linux-wireless@archiver.kernel.org>; Wed, 30 Jan 2019 11:55:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730735AbfA3Lzs (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 30 Jan 2019 06:55:48 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:52718 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730158AbfA3Lzr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 30 Jan 2019 06:55:47 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1gooT3-0003x8-KC; Wed, 30 Jan 2019 13:55:46 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Shahar S Matityahu <shahar.s.matityahu@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Wed, 30 Jan 2019 13:55:13 +0200
Message-Id: <20190130115528.19922-3-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190130115528.19922-1-luca@coelho.fi>
References: <20190130115528.19922-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 02/17] iwlwifi dbg_ini: update ini structs doc
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Shahar S Matityahu <shahar.s.matityahu@intel.com>

update ini struct documentation to the structs being used in the FW

Signed-off-by: Shahar S Matityahu <shahar.s.matityahu@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/fw/api/dbg-tlv.h | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/api/dbg-tlv.h b/drivers/net/wireless/intel/iwlwifi/fw/api/dbg-tlv.h
index ab82b7a67967..b7525d62e26f 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/api/dbg-tlv.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/api/dbg-tlv.h
@@ -155,20 +155,20 @@ struct iwl_fw_ini_region_cfg {
 	};
 	__le32 size;
 	__le32 start_addr[];
-} __packed; /* FW_INI_REGION_CONFIG_S */
+} __packed; /* FW_DEBUG_TLV_REGION_CONFIG_S */
 
 /**
  * struct iwl_fw_ini_region_tlv - (IWL_FW_INI_TLV_TYPE_REGION_CFG)
  * DUMP sections define IDs and triggers that use those IDs TLV
  * @header: header
  * @num_regions: how many different region section and IDs are coming next
- * @iwl_fw_ini_dump dump_config: list of dump configurations
+ * @region_config: list of dump configurations
  */
 struct iwl_fw_ini_region_tlv {
 	struct iwl_fw_ini_header header;
 	__le32 num_regions;
 	struct iwl_fw_ini_region_cfg region_config[];
-} __packed; /* FW_INI_REGION_CFG_S */
+} __packed; /* FW_DEBUG_TLV_REGIONS_S_VER_1 */
 
 /**
  * struct iwl_fw_ini_trigger - (IWL_FW_INI_TLV_TYPE_DUMP_CFG)
@@ -196,7 +196,7 @@ struct iwl_fw_ini_trigger {
 	__le32 trigger_data;
 	__le32 num_regions;
 	__le32 data[];
-} __packed; /* FW_INI_TRIGGER_CONFIG_S */
+} __packed; /* FW_TLV_DEBUG_TRIGGER_CONFIG_S */
 
 /**
  * struct iwl_fw_ini_trigger_tlv - (IWL_FW_INI_TLV_TYPE_TRIGGERS_CFG)
@@ -210,7 +210,7 @@ struct iwl_fw_ini_trigger_tlv {
 	struct iwl_fw_ini_header header;
 	__le32 num_triggers;
 	struct iwl_fw_ini_trigger trigger_config[];
-} __packed; /* FW_INI_TRIGGER_CFG_S */
+} __packed; /* FW_TLV_DEBUG_TRIGGERS_S_VER_1 */
 
 /**
  * enum iwl_fw_ini_trigger_id
-- 
2.20.1

